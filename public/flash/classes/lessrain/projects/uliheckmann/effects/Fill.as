import flash.geom.Matrix;

import lessrain.lib.utils.logger.LogManager;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import lessrain.lib.utils.animation.easing.Sine;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.lib.utils.tween.TweenTimer;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.effects.WordEvent;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.effects.Fill implements IDistributor
{
	private static var USE_TWEEN:Boolean=true;
	private static var TWEEN_INTERVAL:Number = 30;
	
	private var _targetMC:MovieClip;

	private var _id:String;
	private var _fillBitmap:BitmapData;
	private var _maskImageBitmap : BitmapData;

	private var _displayBitmap : BitmapData;
	private var _basePoint : Point;
	private var _tween : TweenTimer;
	private var _isShowing : Boolean;

	private var _eventDistributor : EventDistributor;

	private var _dispatchState : Boolean;
	
	public function Fill(targetMC_:MovieClip)
	{
		_targetMC=targetMC_;
		_isShowing = false;
	}
	
	/**
	 * Not in constructor because it's only needed for the last letter
	 */
	public function initializeEventDistributor():Void
	{
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	public function initialize():Void
	{
		_basePoint = new Point(0,0);
		
		var copyRect : Rectangle = _maskImageBitmap.rectangle;
		var fillRect : Rectangle = _fillBitmap.rectangle;
		
		if (fillRect.height < copyRect.height)
		{
			var resizeMatrix:Matrix = new Matrix();
			resizeMatrix.scale((copyRect.height / fillRect.height), (copyRect.height / fillRect.height));
			
			fillRect.width = fillRect.width * (copyRect.height / fillRect.height);
			fillRect.height = copyRect.height;
			
			var resizedBitmap : BitmapData = new BitmapData(fillRect.width, fillRect.height, false);
			resizedBitmap.draw(_fillBitmap, resizeMatrix);
			
			//_fillBitmap.dispose();
			_fillBitmap = resizedBitmap;
			
		}
		
		if (fillRect.width!=copyRect.width) copyRect.x = Math.round((fillRect.width-copyRect.width)/2);
		
		_displayBitmap = new BitmapData(copyRect.width,copyRect.height,true, 0x00000000);
		_displayBitmap.copyPixels(_fillBitmap,copyRect,_basePoint,_maskImageBitmap,_basePoint,false);
		
		_targetMC.attachBitmap(_displayBitmap,1);

		_tween = new TweenTimer();
		_tween.tweenDuration = TWEEN_INTERVAL;
		_tween.tweenTarget = _targetMC;
		_tween.addEventListener(TweenEvent.TWEEN_START, Proxy.create(this, onTweenStart));
		_tween.addEventListener(TweenEvent.TWEEN_COMPLETE, Proxy.create(this, onTweenComplete));
		
		_targetMC._alpha=0;
		_targetMC._visible=false;
	}
	
	public function setPosition(x_:Number, y_:Number):Void
	{
		_targetMC._x=x_;
		_targetMC._y=y_;
	}
	
	public function show( delay_:Number, duration_:Number ):Void
	{
		_dispatchState = true;
		if (!_isShowing || (_tween.tweenDuration!=duration_ && _targetMC._alpha<95))
		{
			_isShowing=true;
			if (USE_TWEEN)
			{
				_tween.reset();
				_tween.tweenDuration=GlobalSettings.getInstance().speedUp ? 10 : duration_;
				_tween.easingFunction=Sine.easeOut;
				_tween.setTweenProperty("_alpha",_targetMC._alpha,100);
				_tween.start(GlobalSettings.getInstance().speedUp ? 0 : delay_);
			}
			else
			{
				onTweenStart();
				_targetMC._alpha=100;
				onTweenComplete();
			}
		}
	}
	
	public function hide( delay_:Number, duration_:Number, dispatchState_:Boolean ):Void
	{
		_dispatchState = dispatchState_;
		if (_isShowing || (_tween.tweenDuration!=duration_ && _targetMC._alpha>5) )
		{
			_isShowing=false;
			if (USE_TWEEN)
			{
				_tween.reset();
				_tween.tweenDuration=GlobalSettings.getInstance().speedUp ? 10 : duration_;
				_tween.easingFunction=Sine.easeOut;
				_tween.setTweenProperty("_alpha",_targetMC._alpha,0);
				_tween.start(GlobalSettings.getInstance().speedUp ? 0 : delay_);
			}
			else
			{
				onTweenStart();
				_targetMC._visible=false;
				onTweenComplete();
			}
		}
		else if (!_tween.isRunning) onTweenComplete();
	}
	
	private function onTweenStart():Void
	{
		if (_isShowing) _targetMC._visible = true;
		if (_dispatchState) distributeEvent( new WordEvent(WordEvent.STATE_CHANGE, this) );
	}
	
	private function onTweenComplete():Void
	{
		if (!_isShowing) _targetMC._visible = false;
		if (_dispatchState) distributeEvent( new WordEvent(WordEvent.STATE_COMPLETE, this) );
	}

	public function finalize():Void
	{
		_fillBitmap=null;
		_maskImageBitmap=null;
		_displayBitmap.dispose();
		delete _tween;
		_targetMC.removeMovieClip();
	}
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }
	public function get fillBitmap():BitmapData { return _fillBitmap; }
	public function set fillBitmap(value:BitmapData):Void { _fillBitmap=value; }
	public function get maskImageBitmap():BitmapData { return _maskImageBitmap; }
	public function set maskImageBitmap(value:BitmapData):Void { _maskImageBitmap=value; }
}