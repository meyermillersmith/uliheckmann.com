import lessrain.lib.utils.movieclip.HitArea;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.WordEvent;
import lessrain.projects.uliheckmann.navigation.NavigationNode;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.navigation.MainItem extends NavigationNode
{
	private var _mouseMoveProxy : Function;
	private var _subAreaMC : MovieClip;	private var _firstShowDelayIntervalID : Number;
	public function MainItem(targetMC : MovieClip)
	{
		super(targetMC);
	}

	public function initialize():Void
	{
		// position below last MainItem, and set this as last MainItem
		if (lastNode==null) _y=0;
		else _y=lastNode.bottom;
		lastNode=this;
		
		super.initialize();
	}
	
	private function onFirstShow():Void
	{
		if (_showAutomatically)
		{
			_word.setState(Letter.STATE_ANTS);
		}
		else
		{
			if (_isActive) _word.setState(Letter.STATE_ANTS);
			else _word.setState(Letter.STATE_FILL);
			if (_pageID!=null || hasSubNodes) setupMouseHandlers();
		}
	}

	public function onFirstShowComplete():Void
	{
		_firstShowDelayIntervalID = setInterval(this, "firstShowCompleteDelayed", _levelPosition*300);
	}
	
	private function firstShowCompleteDelayed():Void
	{
		clearInterval(_firstShowDelayIntervalID);
		_isFirstShow=false;
		if (_pageID!=null || hasSubNodes)
		{
			setupHitArea();
			setupMouseHandlers();
		}
		_word.setState(Letter.STATE_FILL);
		_word.setMode(Letter.MODE_MENU);
	}
	
	private function onWordStateComplete(wordEvent:WordEvent):Void
	{
		super.onWordStateComplete();
	}

	private function setupHitArea():Void
	{
		super.setupHitArea();
		if (_pageID!=null || hasSubNodes)
		{
			/*
			 * Create hitarea over all subitems to detect when the user moves the mouse out
			 */
			var subX:Number = 0;
			var subWidth:Number = 0;
			var node:NavigationNode;
			node = _childNodes[0];
			subX=node._x;
			node = _childNodes[_childNodes.length-1];
			subWidth=node._x-subX+node._width;
			_subAreaMC = _hitMC.createEmptyMovieClip("subArea",1);
			HitArea.createHitArea(_subAreaMC,1,5,true,subX-_x,0,subWidth,_height-Letter.LINE_SPACING);
			_mouseMoveProxy = Proxy.create(this, mouseMove);
			
			/*
			 * Hack for gapless rollovers over sub items
			 */
			var nextNode:NavigationNode;
			var prevNode:NavigationNode;
			var leftMargin:Number;
			var rightMargin:Number;
			for (var i : Number = 0; i < _childNodes.length; i++)
			{
				node = _childNodes[i];
				if (i<_childNodes.length-1) nextNode=_childNodes[i+1];
				else nextNode=null;
				if (i>0) prevNode=_childNodes[i-1];
				else prevNode=null;
				
				leftMargin = ( prevNode==null ? 0 : Math.ceil((node._x-prevNode._x-prevNode._width)/2) );
				rightMargin = ( nextNode==null ? 0 : Math.ceil((nextNode._x-node._x-node._width)/2) );
				node.setRolloverMargins(leftMargin, rightMargin);
			}
		}
	}
	
	public function enable() : Void
	{
		super.enable();
	}
	public function disable() : Void
	{
		super.disable();
		removeAreaListener();
	}
	
	private function over():Void
	{
		if (hasSubNodes)
		{
			hide();
			setupAreaListener();
			showSubNodes();
		}
		else super.over();
	}
	
	private function mouseMove():Void
	{
		if (!_subAreaMC.hitTest(_root._xmouse,_root._ymouse))
		{
			removeAreaListener();
			hideSubNodes();
			show();
			out();
		}
	}
	
	private function setupAreaListener():Void
	{
		_subAreaMC.onMouseMove = _mouseMoveProxy;
		_subAreaMC._visible=true;
	}
	
	private function removeAreaListener():Void
	{
		_subAreaMC.onMouseMove = null;
		_subAreaMC._visible=false;
	}
	
	public function hide():Void
	{
		super.hide();
		removeAreaListener();
	}
	
}