import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.assets.Label;

import mx.xpath.XPathAPI;

import flash.display.BitmapData;

import lessrain.lib.utils.assets.Source;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.header.HeaderEvent;
import lessrain.projects.uliheckmann.navigation.MainItem;
import lessrain.projects.uliheckmann.navigation.NavigationEvent;
import lessrain.projects.uliheckmann.navigation.NavigationNode;
import lessrain.projects.uliheckmann.navigation.NavigationNodeEvent;
import lessrain.projects.uliheckmann.navigation.SubItem;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;
import de.betriebsraum.gui.TooltipManager;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.navigation.Navigation implements FileListener, IDistributor
{
	private var _targetMC:MovieClip;
	private var _mainNavigationMC : MovieClip;
	private var _xml:XML;
	
	private var _rootNodes:Array;
	private var _allNodes:Array;
	private var _itemCount:Number;
	private var _activeNode:NavigationNode;

	private var _eventDistributor : EventDistributor;

	private var _menuImageSrc : String;
	private var _menuFillMC : MovieClip;

	private var _isShowing : Boolean;
	private var _isFirstShow : Boolean;

	private var _selectedNode : NavigationNode;

	private var _isShowingChain : Boolean;
	private var _isHidingChain : Boolean;

	private var _fillMenuProxy : Function;
	private var _itemSelectProxy : Function;
	private var _nodeShowingProxy : Function;
	private var _nodeHiddenProxy : Function;
	private var _fillLoadedProxy : Function;
	private var _toggleMenuProxy : Function;

	private var _tooltipManager : TooltipManager;

	private var _tooltipMC : MovieClip;
	private var _showAutomatically : Boolean;

	public function Navigation(targetMC:MovieClip, showAutomatically_:Boolean)
	{
		_targetMC=targetMC;
		_itemCount=0;
		_isShowing=false;
		_isFirstShow=true;
		_showAutomatically = showAutomatically_;
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	public function initialize():Void
	{
		_mainNavigationMC = _targetMC.createEmptyMovieClip("main",10);
		_mainNavigationMC._x = 0;
		_mainNavigationMC._y = 0;
		
		_menuFillMC = _targetMC.createEmptyMovieClip("menuFillMC",1);
		_menuFillMC._visible=false;
		
		if (GlobalSettings.getInstance().enableTooltips)
		{
			_tooltipMC = _targetMC.createEmptyMovieClip("tooltipMC",11);
			_tooltipManager = TooltipManager.getInstance();
			_tooltipManager.init( _tooltipMC, 1 );
	
			_tooltipManager.hAlign = "right";
			_tooltipManager.vAlign = "down";
			_tooltipManager.offsetX = 0;
			_tooltipManager.offsetY = 20;
			_tooltipManager.delay = 500;
			_tooltipManager.duration = 2000;
			_tooltipManager.follow = true;
			_tooltipManager.autoHide = false;
			_tooltipManager.enabled = true;
			
			_tooltipManager.tipStyle = {textFormat:new TextFormat("HaasUnica", 12, 0xffffff, false), 
						   borderThickness:3,
						   borderColor:0x000000,
						   borderAlpha:0,
						   fillColor:0x000000,
						   fillAlpha:100,
						   shadowColor:0x000000,
						   shadowAlpha:0,
						   shadowSize:2,
						   shadowOffset:4		
						   };
		}
		
		if (Label.getLabel("Setting.NavigationPositioning.Enable")=="true") Key.addListener(this);
		
		_fillMenuProxy = Proxy.create(this, onFillMenu);
		_itemSelectProxy = Proxy.create(this, onItemSelect);
		_nodeShowingProxy = Proxy.create(this, onNodeShowing);
		_nodeHiddenProxy = Proxy.create(this, onNodeHidden);
		_fillLoadedProxy = Proxy.create(this, onFillLoaded);
		_toggleMenuProxy = Proxy.create(this, onToggleMenu);
			
		_rootNodes=new Array();
		_allNodes=new Array();
		
		/*
		Read XML
		*/
		_xml = new XML();
		_xml.ignoreWhite=true;
		PriorityLoader.getInstance().addFile( _xml, Source.getSource("Navigation"), this, 100, "xml", "Navigation" );
		
		if (GlobalSettings.getInstance().enableFullscreen)
		{
			onResize();
			Stage.addListener(this);
		}
	}
	
	private function onKeyDown() : Void
	{
		if (Key.getCode() == Key.LEFT || Key.getCode() == Key.RIGHT)
		{
			for (var i : Number = _rootNodes.length-1; i >= 0; i--)
			{
				if (_targetMC._ymouse > NavigationNode(_rootNodes[i]).y)
				{
					if (Key.getCode() == Key.RIGHT) NavigationNode(_rootNodes[i]).moveBy(1);
					else if (Key.getCode() == Key.LEFT) NavigationNode(_rootNodes[i]).moveBy(-1);
					return;
				}
			}
		}
		else if (Key.getCode() == Key.SPACE)
		{
			for (var j : Number = 0; j < _allNodes.length; j++)
			{
				NavigationNode(_allNodes[j]).printPos();
			}
		}
	}
	
	private function onResize():Void
	{
		_targetMC._x = GlobalFunctions.getCenterStageX()+GlobalSettings.getInstance().contentLeft;
		_targetMC._y = GlobalFunctions.getCenterStageY()+GlobalSettings.getInstance().contentTop;
	}

	public function finalize():Void
	{
		_targetMC.removeMovieClip();
	}
	
	public function toggleNodes():Void
	{
		if (_isShowing) hideNodes();
		else showNodes();
	}
	
	public function showNodes( showAll_:Boolean ):Void
	{
		if (!_isShowing)
		{
			updateFill( _menuImageSrc );
			_isShowing = true;
			_isShowingChain=true;
			disableNodes();
			
			if (showAll_) for (var i : Number = 0; i < _rootNodes.length; i++) NavigationNode(_rootNodes[i]).show();
			else NavigationNode(_rootNodes[0]).show();
		}
	}
	
	public function hideNodes( hideAll_:Boolean ):Void
	{
		if (_isShowing)
		{
			_isShowing = false;
			_isHidingChain=true;
			disableNodes();
			
			if (hideAll_) for (var i : Number = 0; i < _rootNodes.length; i++) NavigationNode(_rootNodes[i]).hide();
			else NavigationNode(_rootNodes[0]).hide();
		}
	}
	
	private function onNodeShowing( navigationNodeEvent:NavigationNodeEvent ):Void
	{
		if (_isShowingChain)
		{
			var nextNode:NavigationNode;
			for (var i : Number = 0; i < _rootNodes.length; i++)
			{
				if (NavigationNode(_rootNodes[i]) == navigationNodeEvent.getNavigationNode() && i<_rootNodes.length-1) nextNode=NavigationNode(_rootNodes[i+1]);
			}
			if (nextNode!=null) nextNode.show();
			else
			{
				_isShowingChain=false;
				enableNodes();
				if (_isFirstShow)
				{
					for (var j : Number = 0; j < _allNodes.length; j++) NavigationNode(_allNodes[j]).onFirstShowComplete();
					_isFirstShow=false;
					if (!GlobalSettings.getInstance().waitForMenuFills) for (var k : Number = 0; k < _allNodes.length; k++) NavigationNode(_allNodes[k]).loadFill();
				}
				distributeEvent(new NavigationEvent(NavigationEvent.SHOWING, _activeNode));
			}
		}
	}
	
	private function onNodeHidden( navigationNodeEvent:NavigationNodeEvent ):Void
	{
		if (_isHidingChain)
		{
			var nextNode:NavigationNode;
			for (var i : Number = 0; i < _allNodes.length; i++)
			{
				if (NavigationNode(_allNodes[i]) == navigationNodeEvent.getNavigationNode() && i<_allNodes.length-1) nextNode=NavigationNode(_allNodes[i+1]);
			}
			if (nextNode!=null) nextNode.hide();
			else
			{
				_isHidingChain=false;
				if (_selectedNode!=null)
				{
					distributeEvent(new NavigationEvent(NavigationEvent.ITEM_SELECTED, _selectedNode));
					_selectedNode=null;
				}
				else distributeEvent(new NavigationEvent(NavigationEvent.HIDDEN, _activeNode));
			}
		}
	}
		
	public function enableNodes():Void
	{
		for (var i : Number = _allNodes.length-1; i >= 0; i--) NavigationNode(_allNodes[i]).enable();
	}
	
	public function disableNodes():Void
	{
		for (var i : Number = _allNodes.length-1; i >= 0; i--) NavigationNode(_allNodes[i]).disable();
	}
	
	
	public function activateNode(node:NavigationNode):Void
	{
		_activeNode.deactivate();
		_activeNode = node;
		_activeNode.activate();
	}
	
	/**
	 * Finds the node that represents the given pageID
	 * The closest match to the pageID is returned
	 */
	public function getNodeByPageID( pageID:String ):NavigationNode
	{
		var bestMatch:NavigationNode;
		for (var i : Number = _allNodes.length-1; i >= 0; i--)
		{
			var node:NavigationNode = _allNodes[i];
			if (node.matchPageID(pageID)>bestMatch.matchQuality || bestMatch==null) bestMatch=node;
		}
		//trace("pageID: "+pageID+", found: "+bestMatch.title+", macthQuality: "+bestMatch.matchQuality);
		return bestMatch;
	}
	
	/**
	 * Finds the node that represents the given pageID
	 * The closest match to the pageID is returned
	 */
	public function getNodeByPosition( pos:Number ):NavigationNode
	{
		for (var i : Number = _allNodes.length-1; i >= 0; i--)
		{
			var node:NavigationNode = _allNodes[i];
			if (node.globalPosition==pos) return node;
		}
		return null;
	}
	
	private function xmlLoaded():Void
	{
		var nodes:Array;
		var node:XMLNode;
		
		/*
		* main navigation
		*/
		node = XPathAPI.selectSingleNode(_xml.firstChild,"/Navigation/Main");
		
		_menuImageSrc = node.attributes.menuImageSrc;
		PriorityLoader.getInstance().addFile( _menuFillMC.createEmptyMovieClip("holder",1), _menuImageSrc, this, 70, "fill" );
		buildNavigationTree(node, 0, _mainNavigationMC);

		/*
		* xml done, cleaning up
		*/
		delete _xml;
	}
	
	private function fillLoaded():Void
	{
		var menuFillBitmap:BitmapData=new BitmapData(_menuFillMC._width, _menuFillMC._height, false);
		var defaultFillBitmap:BitmapData=new BitmapData(_menuFillMC._width, _menuFillMC._height, false, GlobalSettings.getInstance().defaultFillColor);
		menuFillBitmap.draw(_menuFillMC);
		_menuFillMC.holder.removeMovieClip();
		_menuFillMC.removeMovieClip();
		for (var i : Number = _allNodes.length-1; i >= 0; i--)
		{
			NavigationNode(_allNodes[i]).addFill(_menuImageSrc, menuFillBitmap);
			NavigationNode(_allNodes[i]).addFill("default", defaultFillBitmap);
		}
		menuFillBitmap.dispose();
		defaultFillBitmap.dispose();
		updateFill( _menuImageSrc );
		
		if (!GlobalSettings.getInstance().waitForMenuFills)
		{
			if (_showAutomatically) showNodes();
			else distributeEvent(new NavigationEvent(NavigationEvent.SHOWING, _activeNode));
		}
	}
	
	private function updateFill(id_:String):Void
	{
		for (var i : Number = _allNodes.length-1; i >= 0; i--)
		{
			var navNode:NavigationNode = _allNodes[i];
			navNode.setFill(id_);
		}
	}

	private function onFillMenu( navigationNodeEvent:NavigationNodeEvent ):Void
	{
		if (navigationNodeEvent.getType()==NavigationNodeEvent.ROLL_OVER)
		{
			if (navigationNodeEvent.getNavigationNode().menuFillLoaded) updateFill( navigationNodeEvent.getNavigationNode().menuImageSrc );
			else updateFill("default");
		}
		else if (navigationNodeEvent.getType()==NavigationNodeEvent.ROLL_OUT) updateFill( _menuImageSrc );
	}
	
	private function onFillLoaded( navigationNodeEvent:NavigationNodeEvent ):Void
	{
		var node:NavigationNode=navigationNodeEvent.getNavigationNode();
		var iteratorNode:NavigationNode;
		var allLoaded:Boolean = true;
		for (var i : Number = _allNodes.length-1; i >= 0; i--)
		{
			iteratorNode=NavigationNode(_allNodes[i]);
			iteratorNode.addFill(node.menuImageSrc, node.menuFillBitmap);
			if (iteratorNode.menuImageSrc!=null && iteratorNode.menuImageSrc!="" && !iteratorNode.menuFillLoaded) allLoaded=false;
		}
		if (allLoaded && GlobalSettings.getInstance().waitForMenuFills)
		{
			if (_showAutomatically) showNodes();
			else distributeEvent(new NavigationEvent(NavigationEvent.SHOWING, _activeNode));
		}
	}
	
	private function onItemSelect( navigationNodeEvent:NavigationNodeEvent ):Void
	{
		if (_activeNode!=navigationNodeEvent.getNavigationNode())
		{
			_selectedNode = navigationNodeEvent.getNavigationNode();
			hideNodes();
		}
	}
	
	private function onToggleMenu(headerEvent:HeaderEvent):Void
	{
		distributeEvent(headerEvent);
	}
	
	// recursively build the navigation tree
	private function buildNavigationTree(node:XMLNode, level:Number, container:MovieClip):NavigationNode
	{
		var navNode:NavigationNode;
		if (node.nodeName=="Item")
		{
			level++;
			_itemCount++;
			
			var targetMC:MovieClip = container.createEmptyMovieClip("nav_"+container.getNextHighestDepth(), container.getNextHighestDepth());

			/*
			 * Create different types of navigation nodes here, depending on their level, pageID etc.
			*/
			if (level==1) navNode = new MainItem( targetMC );
			else navNode = new SubItem( targetMC );
			
			if (level==1)
			{
				navNode.levelPosition = _rootNodes.length;
				_rootNodes.push(navNode);
			}
			_allNodes.push(navNode);

			navNode.pageID = node.attributes.pageID;
			navNode.menuImageSrc = node.attributes.menuImageSrc;
			navNode.showAutomatically = _showAutomatically;
			navNode.x = parseInt(node.attributes.x);
			navNode.hierarchyLevel = level;
			navNode.globalPosition = _itemCount;

			navNode.title = XMLNode(XPathAPI.selectSingleNode(node,"/Item/Title")).firstChild.nodeValue;
			navNode.addEventListener(NavigationNodeEvent.ROLL_OVER, _fillMenuProxy);
			navNode.addEventListener(NavigationNodeEvent.ROLL_OUT, _fillMenuProxy);
			navNode.addEventListener(NavigationNodeEvent.RELEASE, _itemSelectProxy);
			navNode.addEventListener(NavigationNodeEvent.NODE_SHOWING, _nodeShowingProxy);
			navNode.addEventListener(NavigationNodeEvent.NODE_HIDDEN, _nodeHiddenProxy);
			navNode.addEventListener(NavigationNodeEvent.FILL_LOADED, _fillLoadedProxy);
			navNode.addEventListener(HeaderEvent.TOGGLE_MENU, _toggleMenuProxy);

			navNode.initialize();
		}

		var subNodes:Array = XPathAPI.selectNodeList(node, "/"+node.nodeName+"/*");
		
		for (var i : Number = 0; i < subNodes.length; i++)
		{
			var childNode:NavigationNode = buildNavigationTree( subNodes[i], level, container );
			if (navNode!=null && childNode!=null) navNode.addChildNode( childNode );
		}
		
		return navNode;
	}
	
	public function onLoadStart(file : FileItem) : Boolean
	{
		return null;
	}

	public function onLoadComplete(file : FileItem) : Void
	{
		if (file.id=="xml") xmlLoaded();
		else if (file.id=="fill") fillLoaded();
	}

	public function onLoadProgress(file : FileItem, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void
	{
	}
	
	public function get activeNode():NavigationNode { return _activeNode; }
	public function set activeNode(value:NavigationNode):Void { _activeNode=value; }
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	public function get isShowing():Boolean { return _isShowing; }
	public function set isShowing(value:Boolean):Void { _isShowing=value; }
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
}