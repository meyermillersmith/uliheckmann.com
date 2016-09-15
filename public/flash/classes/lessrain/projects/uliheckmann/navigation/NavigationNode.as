import flash.display.BitmapData;

import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.movieclip.HitArea;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.Word;
import lessrain.projects.uliheckmann.effects.WordEvent;
import lessrain.projects.uliheckmann.header.HeaderEvent;
import lessrain.projects.uliheckmann.navigation.NavigationNodeEvent;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.lib.utils.logger.LogManager;class lessrain.projects.uliheckmann.navigation.NavigationNode implements IDistributor, FileListener
{
	/*
	 * Holding the objects
	 */
	public static var lastNode:NavigationNode;
	public static var depthCounter:Number = 0;
	
	/*
	 * Member variables
	 */
	private var _targetMC:MovieClip;
	private var _displayMC : MovieClip;
	private var _hitMC : MovieClip;
	private var _hitAreaMC : MovieClip;
	private var _menuFillMC : MovieClip;

	private var _eventDistributor : EventDistributor;
	
	private var _hierarchyLevel:Number;
	private var _levelPosition:Number;
	private var _globalPosition:Number;
	private var _childNodes:Array;
	private var _parentItem:NavigationNode;

	private var _title : String;
	private var _pageID : String;

	// This has only temporary relevance when searching for a node in Navigation.findNode
	private var _matchQuality:Number;
	
	private var _x : Number;
	private var _y : Number;
	private var _width : Number;
	private var _height : Number;
	
	private var _isActive:Boolean;
	private var _isFirstShow : Boolean;

	private var _menuImageSrc:String;
	private var _word : Word;

	private var _overProxy : Function;
	private var _outProxy : Function;
	private var _clickProxy : Function;

	private var _menuFillLoaded : Boolean;
	private var _menuFillBitmap : BitmapData;

	private var _rightMargin : Number;
	private var _leftMargin : Number;

	private var _isShowing : Boolean;
	private var _isEnabled : Boolean;	private var _showAutomatically : Boolean;
	public function NavigationNode(targetMC:MovieClip)
	{
		_targetMC=targetMC;
		_displayMC=_targetMC.createEmptyMovieClip("display",3);
		_hitMC=_targetMC.createEmptyMovieClip("hit",2);
		_menuFillMC=_targetMC.createEmptyMovieClip("menuFillMC",1);
		_menuFillMC._visible=false;
		
		_width=0;
		_height=108;
		_x=0;
		_childNodes = new Array();
		_isActive = false;
		_isFirstShow = true;
		_menuFillLoaded = false;
		_leftMargin=0;		_rightMargin=0;
		_isShowing=true;
		
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}

	public function initialize():Void
	{
		_targetMC._x=_x;
		_targetMC._y=_y;
		_displayMC._visible=false;
		
		_hitAreaMC = _hitMC.createEmptyMovieClip("hitArea",2);
		
		_word = new Word( _displayMC.createEmptyMovieClip("word",10), _title, _x, _y );
		_word.addEventListener( WordEvent.STATE_COMPLETE, Proxy.create(this, onWordStateComplete) );
		_word.initialize();
		_width=_word.width;
		_height=_word.height;
		
		if (GlobalSettings.getInstance().waitForMenuFills) loadFill();
	}
	
	public function setRolloverMargins(left_:Number, right_:Number):Void
	{
		_leftMargin = left_;		_rightMargin = right_;
	}
	
	public function loadFill():Void
	{
		if (_menuImageSrc!=null && _menuImageSrc!="" && !_menuFillLoaded) PriorityLoader.getInstance().addFile( _menuFillMC.createEmptyMovieClip("holder",1), _menuImageSrc, this, 10, "fill" );
	}
	
	private function fillLoaded():Void
	{
		_menuFillLoaded = true;
		_menuFillBitmap=new BitmapData(_menuFillMC._width, _menuFillMC._height, false);
		_menuFillBitmap.draw(_menuFillMC);
		_menuFillMC.holder.removeMovieClip();
		_menuFillMC.removeMovieClip();
		distributeEvent(new NavigationNodeEvent(NavigationNodeEvent.FILL_LOADED, this));
		_menuFillBitmap.dispose();
	}
	
	/*
	add child
	*/
	public function addChildNode(node:NavigationNode):Void
	{
		node.parentItem=this;
		_childNodes.push(node);
		node.levelPosition = _childNodes.length;
	}
	
	/*
	show/hide
	*/
	private function showSubNodes():Void
	{
		for (var i:Number=0; i<_childNodes.length; i++)
		{
			 NavigationNode(_childNodes[i]).show();
		}
	}
	
	public function hideSubNodes():Void
	{
		for (var i:Number=0; i<_childNodes.length; i++)
		{
			 NavigationNode(_childNodes[i]).hide();
		}
	}
	
	public function show():Void
	{
		_displayMC._visible = true;
		_isShowing=true;
		if (_isFirstShow) onFirstShow();
		else
		{
			if (_isActive) _word.setState(Letter.STATE_ANTS);
			else _word.setState(Letter.STATE_FILL);
			if (_pageID!=null || hasSubNodes) setupMouseHandlers();
		}
	}
	
	public function hide():Void
	{
		_isShowing=false;
		_word.setState(Letter.STATE_INVISIBLE);
		removeMouseHandlers();
	}
	
	/**
	 * Abstract function
	 * Main items need to show ants first then fill
	 * sub items dont have any special first time behaviour
	 */
	private function onFirstShow():Void
	{
	}
	
	public function onFirstShowComplete():Void
	{
	}
	
	/**
	 * Gets called when the word's new state is complete
	 */
	private function onWordStateComplete(wordEvent:WordEvent):Void
	{
		if (_isShowing) distributeEvent(new NavigationNodeEvent(NavigationNodeEvent.NODE_SHOWING, this));
		else distributeEvent(new NavigationNodeEvent(NavigationNodeEvent.NODE_HIDDEN, this));
	}
	
	private function setupHitArea():Void
	{
		HitArea.createHitArea(_hitAreaMC,1,5,true,-_leftMargin,0,_width+_leftMargin+_rightMargin,_height-Letter.LINE_SPACING);
		_overProxy = Proxy.create(this, over);
		_outProxy = Proxy.create(this, out);
		if (_pageID!=null) _clickProxy = Proxy.create(this, click);
	}
	
	public function setFill(id_:String) : Void
	{
		_word.setFill(id_);
	}

	public function addFill(id_:String, bitmapFill_ : BitmapData) : Void
	{
		_word.addFill(id_, bitmapFill_);
	}
	
	public function enable() : Void
	{
		_isEnabled=true;
		_hitAreaMC.enabled=true;
	}
	public function disable() : Void
	{
		_isEnabled=false;
		_hitAreaMC.enabled=false;
	}
	
	private function setupMouseHandlers():Void
	{
		_hitAreaMC._visible=true;
		_hitAreaMC.onRollOver = _overProxy;
		_hitAreaMC.onRollOut = _hitAreaMC.onReleaseOutside = _outProxy;
		if (_pageID!=null) _hitAreaMC.onRelease = _clickProxy;
//		_hitAreaMC.useHandCursor=!_isActive;
	}
	
	private function removeMouseHandlers():Void
	{
		_hitAreaMC._visible=false;
		_hitAreaMC.onRollOver = null;
		_hitAreaMC.onRollOut = _hitAreaMC.onReleaseOutside = null;
		_hitAreaMC.onRelease = null;
	}

	private function over() : Void
	{
		if (!_isActive) _word.setState(Letter.STATE_ANTS);
		distributeEvent(new NavigationNodeEvent(NavigationNodeEvent.ROLL_OVER, this));
	}

	private function out() : Void
	{
		if (!_isActive)
		{
			distributeEvent(new NavigationNodeEvent(NavigationNodeEvent.ROLL_OUT, this));
			_word.setState(Letter.STATE_FILL);
		}
	}
	
	public function moveBy(dx:Number) : Void
	{
		_x += dx;
		_targetMC._x=_x;
	}
	
	public function printPos() : Void
	{
		var prefix : String = "";
		for (var i : Number = 1; i < _hierarchyLevel; i++)
		{
			prefix += "\t";
		}
		LogManager.debug( prefix + _title+": "+_x);
	}

	private function click() : Void
	{
		if (_isActive) distributeEvent(new HeaderEvent(HeaderEvent.TOGGLE_MENU));
		else distributeEvent(new NavigationNodeEvent(NavigationNodeEvent.RELEASE, this));
	}
	
	/*
	 * Activate
	 */
	public function activate():Void
	{
		_isActive=true;
//		_word.setState(Letter.STATE_ANTS);
//		_hitAreaMC.useHandCursor=!_isActive;
	}
	
	public function deactivate():Void
	{
//		_word.setState(Letter.STATE_FILL);
		_isActive=false;
//		_hitAreaMC.useHandCursor=!_isActive;
	}
	
	/**
	 * Match a pageID to the pageID of the NavigationNode
	 * @return	The quality of the match, 0=no match; 1..10=amount of matching levels; 100=full match
	 */
	 public function matchPageID(pageID:String):Number
	 {
	 	if (_pageID==pageID) _matchQuality=100;
	 	else
	 	{
	 		_matchQuality=0;
	 		var stackA:Array=_pageID.split("/");
	 		var stackB:Array=pageID.split("/");
	 		// increase the match quality for every part of the pageID that matches 
	 		while ( stackA[_matchQuality] == stackB[_matchQuality] && _matchQuality<stackA.length && _matchQuality<stackB.length) _matchQuality++;
	 	}
	 	return _matchQuality;
	 }

	public function onLoadStart(file : FileItem) : Boolean {return null;}
	public function onLoadComplete(file : FileItem) : Void { if (file.id=="fill" && !file.hasError()) fillLoaded(); }
	public function onLoadProgress(file : FileItem, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void {}
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
	
	/*
	 * Getters / Setters
	 */
	public function get title():String { return _title; }
	function set title(setValue:String):Void { _title = setValue; }

	public function get pageID():String { return _pageID; }
	public function set pageID(setValue:String):Void { _pageID = setValue; }
	
	public function get matchQuality():Number { return _matchQuality; }
	public function set matchQuality(value:Number):Void { _matchQuality=value; }

	public function get parentItem():NavigationNode { return _parentItem; }
	public function set parentItem(value:NavigationNode):Void { _parentItem = value; }
	
	public function get hierarchyLevel():Number { return _hierarchyLevel; }
	public function set hierarchyLevel(level:Number):Void { _hierarchyLevel = level; }
	
	public function get childNodes():Array { return _childNodes; }
	public function set childNodes(value:Array):Void { _childNodes=value; }
	
	public function get hasSubNodes():Boolean
	{
		return (_childNodes.length>0);
	}
	
	public function get levelPosition():Number { return _levelPosition; }
	public function set levelPosition(value:Number):Void { _levelPosition=value; }
	
	public function get globalPosition():Number { return _globalPosition; }
	public function set globalPosition(value:Number):Void { _globalPosition=value; }
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }

	public function get x():Number { return _x; }
	public function set x(value:Number):Void { _x=value; }
	public function get y():Number { return _y; }
	public function set y(value:Number):Void { _y=value; }
	
	public function get bottom():Number { return _y+_height; }
	public function get right():Number { return _x+_width; }
	
	public function get menuImageSrc():String { return _menuImageSrc; }
	public function set menuImageSrc(value:String):Void { _menuImageSrc=value; }	
	public function get menuFillBitmap():BitmapData { return _menuFillBitmap; }
	public function set menuFillBitmap(value:BitmapData):Void { _menuFillBitmap=value; }
	public function get menuFillLoaded():Boolean { return _menuFillLoaded; }
	
	
	public function get showAutomatically():Boolean { return _showAutomatically; }
	public function set showAutomatically(showAutomatically_:Boolean):Void { _showAutomatically = showAutomatically_; }

}
