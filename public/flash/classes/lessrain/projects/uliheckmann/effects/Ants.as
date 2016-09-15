/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import lessrain.lib.utils.animation.easing.Linear; 

import flash.display.BitmapData;
import flash.geom.Matrix;
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
import lessrain.projects.uliheckmann.effects.PatternTile;
import lessrain.projects.uliheckmann.effects.WordEvent;

class lessrain.projects.uliheckmann.effects.Ants implements IDistributor
{
	private static var USE_TWEEN:Boolean=true;
	private static var TWEEN_INTERVAL:Number = 30;
	
	private var _targetMC : MovieClip;
	private var _outputMC:MovieClip;
	
	private var _maskImageBitmap : BitmapData;
	private var _patternBitmap : BitmapData;
	private var _outputBitmap : BitmapData;
	
	private var _rect:Rectangle;
	private var _basePoint:Point;

	private var _w : Number;
	private var _h : Number;
	
	private var _moveInterval : Number;
	private var _isShowing : Boolean;
	private var _tween : TweenTimer;

	private var _eventDistributor : EventDistributor;

	private var _dispatchState : Boolean;

	public function Ants(targetMC_:MovieClip)
	{
		_targetMC=targetMC_;
		
		_moveInterval=-1;
		_isShowing=false;
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
		_basePoint=new Point(0,0);
		
		_w=_maskImageBitmap.width;
		_h=_maskImageBitmap.height;
		_rect=new Rectangle(0,0,_w,_h);
		
		prepareBitmaps();
		
		_tween = new TweenTimer();
		_tween.tweenDuration = TWEEN_INTERVAL;
		_tween.tweenTarget = _outputMC;
		_tween.addEventListener(TweenEvent.TWEEN_START, Proxy.create(this, onTweenStart));
		_tween.addEventListener(TweenEvent.TWEEN_COMPLETE, Proxy.create(this, onTweenComplete));
	}
	
	private function prepareBitmaps():Void
	{
		_outputMC = _targetMC.createEmptyMovieClip("output",10);
		_outputMC._alpha=0;
		
		var patternMC:MovieClip = _targetMC.createEmptyMovieClip("pattern",1);
		patternMC.beginBitmapFill(PatternTile.getPatternTile(), new Matrix(),true);
		patternMC.moveTo(0, 0);
		patternMC.lineTo(_w+PatternTile.TRAIL_LENGTH, 0);
		patternMC.lineTo(_w+PatternTile.TRAIL_LENGTH, _h+PatternTile.TRAIL_LENGTH);
		patternMC.lineTo(0, _h+PatternTile.TRAIL_LENGTH);
		patternMC.lineTo(0, 0);
		patternMC.endFill();
		
		_patternBitmap=new BitmapData(_w+PatternTile.TRAIL_LENGTH, _h+PatternTile.TRAIL_LENGTH);
		_patternBitmap.draw(patternMC);
		patternMC.removeMovieClip();
		
		_outputBitmap=new BitmapData(_w, _h, true, 0);
		_outputMC.attachBitmap(_outputBitmap,1,'always');
	}
	
	public function start():Void
	{
		if (_moveInterval<0) _moveInterval=setInterval(Proxy.create(this,move),28);
	}
	
	public function stop():Void
	{
		if (_moveInterval>=0)
		{
			clearInterval(_moveInterval);
			_moveInterval=-1;
		}
	}
	
	private function move():Void
	{
		_rect.x--;
		if (_rect.x<0) _rect.x=PatternTile.TRAIL_LENGTH-1;
		_outputBitmap.copyPixels(_patternBitmap,_rect,_basePoint,_maskImageBitmap,_basePoint,false);
//		updateAfterEvent();
	}

	public function show( delay_:Number, duration_:Number ):Void
	{
		_dispatchState = true;
		if (!_isShowing)
		{
			_isShowing=true;
			if (USE_TWEEN)
			{
				_tween.reset();
				_tween.tweenDuration=GlobalSettings.getInstance().speedUp ? 10 : duration_;
				_tween.easingFunction = Linear.easeNone;				//_tween.easingFunction = Sine.easeOut;
				_tween.setTweenProperty("_alpha",_outputMC._alpha,100);
				_tween.start(GlobalSettings.getInstance().speedUp ? 0 : delay_);
			}
			else
			{
				onTweenStart();
				_outputMC._alpha=100;
				onTweenComplete();
			}
		}
	}
		
	public function hide( delay_:Number, duration_:Number, dispatchState_:Boolean ):Void
	{
		_dispatchState = dispatchState_;
		if (_isShowing)
		{
			_isShowing=false;
			if (USE_TWEEN)
			{
				_tween.reset();
				_tween.tweenDuration=GlobalSettings.getInstance().speedUp ? 10 : duration_;
				_tween.easingFunction=Sine.easeOut;
				_tween.setTweenProperty("_alpha",_outputMC._alpha,0);
				_tween.start(GlobalSettings.getInstance().speedUp ? 0 : delay_);
			}
			else
			{
				onTweenStart();
				_outputMC._visible=false;
				onTweenComplete();
			}
		}
		else onTweenComplete();
	}
	
	private function onTweenStart():Void
	{
		if (_isShowing)
		{
			start();
			_outputMC._visible=true;
		}
		if (_dispatchState) distributeEvent( new WordEvent(WordEvent.STATE_CHANGE, this) );
	}
	
	private function onTweenComplete():Void
	{
		if (!_isShowing)
		{
			stop();
			_outputMC._visible=false;
		}
		if (_dispatchState) distributeEvent( new WordEvent(WordEvent.STATE_COMPLETE, this) );
	}
	
	public function finalize():Void
	{
		_targetMC.removeMovieClip();
		
		var owner:Ants=this;
		for (var i:String in owner)
		{
			if (owner[i] instanceof BitmapData) BitmapData( owner[i] ).dispose();
			else if (typeof owner[i]=="boolean") owner[i]=false;
			else if (typeof owner[i]=="number") owner[i]=0;
			delete owner[i];
		}

	}
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function get w():Number { return _w; }
	public function set w(value:Number):Void { _w=value; }
	
	public function get h():Number { return _h; }
	public function set h(value:Number):Void { _h=value; }
	
	public function get maskImageBitmap():BitmapData { return _maskImageBitmap; }
	public function set maskImageBitmap(value:BitmapData):Void { _maskImageBitmap=value; }
}