import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.lib.utils.tween.TweenTimer;
import lessrain.projects.uliheckmann.config.GlobalSettings;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.header.SoundBar
{
	private static var ALPHA:Number=100;
	
	private static var UPDATE_INTERVAL:Number=200;
	
	private static var WIDTH:Number=4;
	private static var MIN_HEIGHT:Number=4;
	private static var MAX_HEIGHT:Number=10;
	private static var ROUNDED_BY:Number=2;
	
	private var _targetMC:MovieClip;
	private var _tween : TweenTimer;
	private var _width:Number;
	private var _height:Number;
	private var _isOn:Boolean;

	private var _barMC : MovieClip;
	
	public function SoundBar(targetMC_:MovieClip)
	{
		_targetMC=targetMC_;
		_width=WIDTH;
		height=MIN_HEIGHT;
		_isOn=false;
	}
	
	public function initialize():Void
	{
		_barMC = _targetMC.createEmptyMovieClip("bar",1);
		
		_tween = new TweenTimer();
		_tween.tweenTarget = this;
		_tween.tweenDuration = UPDATE_INTERVAL;
		_tween.addEventListener(TweenEvent.TWEEN_COMPLETE, Proxy.create(this, onTweenComplete));
	}
	
	public function setPosition(x_:Number, y_:Number):Void
	{
		_targetMC._x=x_;
		_targetMC._y=y_;
	}
	
	private function onTweenComplete(tweenEvent:TweenEvent):Void
	{
		if (_isOn)
		{
			_tween.reset();
			_tween.setTweenProperty("height",_height,Math.random()*(MAX_HEIGHT-MIN_HEIGHT)+MIN_HEIGHT);
			_tween.start();
		}
	}

	public function finalize():Void
	{
		_targetMC.removeMovieClip();
	}
	
	public function get height():Number { return _height; }
	public function set height(value:Number):Void
	{
		_height=value;
		ShapeUtils.drawRectangle(_barMC,0,-_height,_width,_height,GlobalSettings.getInstance().highlightColor,ALPHA,ROUNDED_BY);
	}
	
	public function get width():Number { return _width; }
	public function set width(value:Number):Void { _width=value; }
	
	public function get isOn():Boolean { return _isOn; }
	public function set isOn(value:Boolean):Void
	{
		_isOn=value;
		if (_isOn)
		{
			onTweenComplete();
		}
		else
		{
			_tween.reset();
			_tween.setTweenProperty("height",_height,MIN_HEIGHT);
			_tween.start();
		}
	}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
}