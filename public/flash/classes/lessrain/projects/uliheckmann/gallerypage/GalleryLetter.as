import flash.display.BitmapData;

import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.movieclip.HitArea;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.WordEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryLetterEvent;
import lessrain.projects.uliheckmann.config.GlobalSettings;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.GalleryLetter implements IDistributor
{
	public static var BEHAVIOUR_SCREEN:Number = 1;
	public static var BEHAVIOUR_OVERLAY:Number = 2;
	
	private var _targetMC:MovieClip;
	private var _letter : Letter;
	private var _hitArea : MovieClip;

	private var _letterStr : String;
	private var _orderNum : Number;
	private var _isLastLetter : Boolean;

	private var _eventDistributor : EventDistributor;

	private var _eventID : String;
	private var _isShowing:Boolean;
	private var _isEnabled : Boolean;
	private var _isVisited:Boolean;
	private var _isActive:Boolean;

	private var _behaviour : Number;
	private var _transitionIntervalID : Number;
	
	public function GalleryLetter(targetMC_:MovieClip, eventID_:String, letterStr_:String, orderNum_:Number, isLastLetter_:Boolean )
	{
		_targetMC=targetMC_;
		_eventID=eventID_;
		_letterStr=letterStr_;
		_orderNum= (orderNum_==null ? 0 : orderNum_);
		_isLastLetter= (isLastLetter_==null ? false : isLastLetter_);
		_isShowing = false;
		_isEnabled = false;
		_isVisited = false;
		_isActive = false;
		_behaviour=BEHAVIOUR_OVERLAY;
		
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	public function initialize():Void
	{
		_letter = new Letter( _targetMC.createEmptyMovieClip("letter",1), _letterStr, 0,0,_orderNum, _isLastLetter );
		_letter.mode = Letter.MODE_GALLERY;
		_letter.initialize();
		
		_hitArea = _targetMC.createEmptyMovieClip("prevHitArea",2);
		HitArea.createHitArea(_hitArea,1,0,true,0,0,_letter.width, _letter.height);
		_hitArea.onRollOver = Proxy.create(this, over);
		_hitArea.onRollOut = _hitArea.onReleaseOutside = Proxy.create(this, out);
		_hitArea.onRelease = Proxy.create(this, release);
		_hitArea._visible=false;
	}
	
	public function setFill(id_:String, fillBitmap_ : BitmapData) : Void
	{
		_letter.addFill( id_, fillBitmap_ );
		_letter.setFill( id_ );
	}
	
	public function setPos(x_:Number, y_:Number):Void
	{
		_targetMC._x=x_;
		_targetMC._y=y_;
	}
	
	public function setMode(mode_:Number):Void
	{
		_letter.mode=mode_;
	}
	
	public function setBehaviour(behaviour_:Number):Void
	{
		_behaviour=behaviour_;
	}
	
	public function show():Void
	{
		if (!_isShowing)
		{
			_isShowing=true;
			_hitArea._visible=true;
			_targetMC._visible=true;
			enable();
			out();
		}
	}
	
	public function hide( immediately_:Boolean ):Void
	{
		if (immediately_==null) immediately_=false;
		if (_isShowing)
		{
			_isShowing=false;
			_hitArea._visible=false;
			disable();
			if (immediately_) _targetMC._visible=false;
			else _letter.setState(Letter.STATE_INVISIBLE);
		}
	}
	
	public function enable():Void
	{
		if (!_isEnabled)
		{
			_isEnabled=true;
			_hitArea.enabled=true;
			if (!_hitArea.hitTest(_root._xmouse, _root._ymouse)) out();
		}
	}
	
	public function disable():Void
	{
		if (_isEnabled)
		{
			_isEnabled=false;
			_hitArea.enabled=false;
		}
	}
	
	public function activate():Void
	{
		_isActive=true;
		
		if (GlobalSettings.getInstance().enableLetterTransition)
		{
			_transitionIntervalID=setInterval(this, "onStateComplete", 1000);
			_letter.setState(Letter.STATE_BOTH);
		}
		else
		{
			_letter.setState(Letter.STATE_INVISIBLE);
		}
		
		_isShowing=false;
		_hitArea._visible=false;
		disable();
	}
	
	public function deactivate():Void
	{
		_isActive=false;
		
		if (GlobalSettings.getInstance().enableLetterTransition)
		{
			_transitionIntervalID=setInterval(this, "onStateComplete", 500);
			_letter.setState(Letter.STATE_FILL);
		}
		else
		{
			_letter.setState(Letter.STATE_INVISIBLE);
		}
		
		_isShowing=false;
		_hitArea._visible=false;
		disable();
	}
	
	private function onStateComplete(wordEvent_:WordEvent):Void
	{
		clearInterval(_transitionIntervalID);
		if (!_isShowing) _letter.setState(Letter.STATE_INVISIBLE);
	}
	
	private function over():Void
	{
		if (_isShowing && _isEnabled) _letter.setState(Letter.STATE_BOTH);
	}
	
	public function out():Void
	{
		if (_isShowing && _isEnabled)
		{
			if (_behaviour==BEHAVIOUR_OVERLAY)
			{
				if (_isActive) _letter.setState(Letter.STATE_BOTH);
				else if (_isVisited) _letter.setState(Letter.STATE_FILL);
				else _letter.setState(Letter.STATE_ANTS);
			}
			else if (_behaviour==BEHAVIOUR_SCREEN)
			{
				if (_isActive) _letter.setState(Letter.STATE_BOTH);
				else _letter.setState(Letter.STATE_FILL);
			}
		}
	}
	
	private function release():Void
	{
		if (_isEnabled) distributeEvent( new GalleryLetterEvent(GalleryLetterEvent.RELEASE, _eventID) );
	}

	public function finalize():Void
	{
		_letter.finalize();
		_hitArea.removeMovieClip();
		_eventDistributor.finalize();
		_targetMC.removeMovieClip();
	}
	
	public function get height():Number { return _letter.height+Letter.LINE_SPACING; }
	public function get width():Number { return _letter.width+Letter.LETTER_SPACING; }
	
	public function get isShowing():Boolean { return _isShowing; }
	public function get isEnabled():Boolean { return _isEnabled; }
	public function get isVisited():Boolean { return _isVisited; }
	public function set isVisited(value:Boolean):Void { _isVisited=value; out(); }
	public function get isActive():Boolean { return _isActive; }
	public function set isActive(value:Boolean):Void { _isActive=value; out(); }
	
	
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
}