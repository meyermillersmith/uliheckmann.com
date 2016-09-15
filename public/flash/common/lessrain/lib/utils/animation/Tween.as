/**
* Tween, version 1
* @class:   lessrain.lib.utils.animation.Tween
* @author:  lessrain.com
* @version: 1.4
* @usage:   var oListener:Object = new Object();

oListener.onInit = function(oEvent:Object):Void {...};
oListener.onProgress = function(oEvent:Object):Void {...};
oListener.onComplete = function(oEvent:Object):Void {...};

//outside the object
function test():Void{...}

var twCircle:Tween = new Tween(circle_mc,
[{prop:'_x',start:10,end:200},
{prop:'_alpha',start:10,end:100}],
1000,
mx.transitions.easing.Regular.easeIn,
false);

// alternative--> var twCircle:Tween = new Tween(circle_mc);
//                twCircle.duration=1000;
//				   twCircle.setTweenProperty ('_x', 0, 100)
//                twCircle.easingFunction=mx.transitions.easing.Regular.easeIn
//				   twCircle.start();


twCircle.addEventListener("onInit", oListener);
twCircle.addEventListener("onProgress", oListener);
twCircle.addEventListener("onComplete", oListener);
//twCircle.addEventListener("onComplete", lessrain.lib.utils.Proxy.create(this, test));

*/
import mx.events.EventDispatcher;
import mx.transitions.OnEnterFrameBeacon;

import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.Proxy;


class lessrain.lib.utils.animation.Tween
{
	/**
	* @property properties_array  (Array)    -- Tween more than one property at a time.
	* @property _duration         (Number)   -- Duration in milliseconds.
	* @property _tweenInterval         (Number)   --
	* @property _oTarget          (Object)   -- the target could be a movieclip or an object.
	* @property _startTime        (Number)   -- start timer.
	* @property _ease )           (Function) -- easing function.
	*/
	private var properties_array : Array;
	private var _duration : Number;
	private var _tweenInterval : Number;
	private var _intervalTime:Number = 15;	
	private var _startDelayInterval:Number=-1;
	private var _oTarget : Object;
	private var _startTime : Number;	
	private var _delay:Number = 0;	
	private var _ease : Function;
	private var _enablePixelSnapping: Boolean;
	
	// required for EventDispatcher:
	private var dispatchEvent : Function;
	public var addEventListener : Function;
	public var removeEventListener : Function;
	
	private var _isMac:Boolean;
	private var eBeaconObject:Object;
	public static var _useEnterFrame : Boolean;

	private var _dispatchProgress : Boolean;
	
	/**
	* Tween constructor
	* @param  target          Object to tween
	* @param  tweenPropList   Properties to tween
	* @param  tweenDuration   duration in milliseconds
	* @param  easingFunction  easing function --> mx.transitions.easing.Regular.easeIn
	* @param  enablePixelSnapping  round the current values or not. default is rounding!
	*/
	// added the option to have float values as current value, if specifically passed as an argument
	function Tween (target : Object, tweenPropList : Object, tweenDuration : Number, easingFunction : Function, startFlag : Boolean, delay : Number, enablePixelSnapping:Boolean)
	{
		EventDispatcher.initialize(this);
		_dispatchProgress=true;
		
	    if(System.capabilities.os=='MacOS' ||  _useEnterFrame){
			
			_isMac=true;
			OnEnterFrameBeacon.init();
			eBeaconObject=new Object();
			eBeaconObject.onEnterFrame=Proxy.create(this,update);
			
		}
		
		_oTarget = target;
		
		// defaults to 1 second
		_duration = tweenDuration || 1000;
		
		if (enablePixelSnapping==null) _enablePixelSnapping=false;
		else _enablePixelSnapping=enablePixelSnapping;
		
		// defaults to None
		if(easingFunction != undefined)_ease = easingFunction;
		else _ease = easingDefault;

		properties_array = new Array ();
		
		if (tweenPropList != undefined) for (var a:String in tweenPropList) setTweenProperty (tweenPropList [a].prop, tweenPropList [a].start, tweenPropList [a].end);
		//EventDispatcher.initialize (this);
		if (startFlag)
		{
			if (delay>0) startWithDelay ( delay );
			else start();
		}
	}
	
	public function reset () : Void
	{
		clearInterval (_tweenInterval);
		
		if(_isMac) MovieClip.removeListener(eBeaconObject);
		if (_startDelayInterval>=0)
		{
			clearInterval (_startDelayInterval);
			_startDelayInterval=-1;
		}
		
		properties_array = new Array ();
	}
	public function setTweenProperty (sProperty : String, nStart : Number, nEnd : Number) : Void
	{
		/*
		the Tween class assumes the current value. For example,
		if the current _alpha value is 100, the following tweens to 0,
		assuming 100 as the starting point. {prop:'_alpha', end: 0}
		*/
		if (nStart == undefined) nStart = _oTarget [sProperty];
		if (nEnd == undefined) nEnd = _oTarget [sProperty];
		properties_array.push ({prop : sProperty, start : nStart, end : nEnd});
	}
	
	public function stop () : Void
	{
		clearInterval (_tweenInterval);
		if(_isMac) MovieClip.removeListener(eBeaconObject);
		if (_startDelayInterval>=0)
		{
			clearInterval (_startDelayInterval);
			_startDelayInterval=-1;
		}
		var i : Number = properties_array.length;
		while ( -- i > - 1) _oTarget [properties_array [i].prop] = properties_array [i].end;
	}
	public function startWithDelay (myDelay:Number):Void
	{
		if (_startDelayInterval>=0)
		{
			clearInterval (_startDelayInterval);
			_startDelayInterval=-1;
		}
		_startDelayInterval=setInterval (Proxy.create(this,start),myDelay);
	}
	
	public function start () : Void
	{		
		clearInterval (_tweenInterval);
		if(_isMac) MovieClip.removeListener(eBeaconObject);
		if (_startDelayInterval>=0)
		{
			clearInterval (_startDelayInterval);
			_startDelayInterval=-1;
		}
		
		_startTime = getTimer ();
//		var i : Number = properties_array.length;
//		while ( -- i > - 1) _oTarget [properties_array [i].prop] = properties_array [i].start;
		setToTime(0);
		dispatchEvent ({type : "onInit", target : this});

		if(_isMac){
			MovieClip.addListener(eBeaconObject);
			_tweenInterval=null;
		}else{
			_tweenInterval = setInterval (Proxy.create (this, update) , _intervalTime);
		}
	}
	
	private function update () : Void
	{
		var t:Number = getTimer() - _startTime;
		if (t >= _duration)
		{
			this.stop ();
			if(_dispatchProgress) dispatchEvent ({type : "onProgress", target : this});
			dispatchEvent ({type : "onComplete", target : this});
		}
		else
		{
			setToTime(t);
			if(_dispatchProgress) dispatchEvent ({type : "onProgress", target : this});
		}
	}
	
	/**
	 * Set the progress of the tween to the given time
	 * @param	time_	Time [ms] to apply to the tween (0..duration)
	 */
	public function setToTime(time_:Number):Void {
		var isFinished:Boolean = (time_ >= _duration);
		for (var i : Number = properties_array.length-1; i >= 0; i--)
		{
			var nEnd:Number = properties_array [i].end;
			if(isFinished) {
				_oTarget[properties_array [i].prop] = nEnd;
			} else {
				var nStart:Number = properties_array [i].start;
				_oTarget[properties_array [i].prop] = _enablePixelSnapping ? 
					Math.round(_ease(time_, nStart, nEnd - nStart, _duration)) :
					_ease(time_, nStart, nEnd - nStart, _duration);
			}
		}
	}
	
	/**
	 * Set the progress of the tween to the given percentage
	 * @param	percent_	Percentage of the tween (0..100)
	 */
	public function setToPercent(percent_:Number):Void {
		setToTime(percent_ * duration / 100);
	}
	
	public function deleteProperties () : Void{properties_array = new Array ();}
	// abort
	public function abort () : Void
	{
		if(_isMac)MovieClip.removeListener(eBeaconObject);
		clearInterval (_tweenInterval);
	}
	// defaults to None
	private function easingDefault (t:Number, b:Number, c:Number, d:Number):Number { return c / 2 * (Math.sin(Math.PI * (t / d - 0.5)) + 1) + b;}
	
	public function get enablePixelSnapping():Boolean { return _enablePixelSnapping; }
	public function set enablePixelSnapping(value:Boolean):Void { _enablePixelSnapping=value; }
	
	public function get intervalTime():Number { return _intervalTime; }
	public function set intervalTime(value:Number):Void { _intervalTime=value; }
	
	public function get delay():Number { return _delay; }
	public function set delay(value:Number):Void { _delay=value; }
	
	public function set easingFunction (value : Function) : Void { _ease = value;}
	
	public function get duration () : Number { return (_duration);}
	public function set duration (value : Number) : Void { _duration = value;}
	
	public function get target () : Object { return (_oTarget );}
	public function set target (value:Object) : Void { _oTarget=value;}
	
	public function get dispatchProgress():Boolean { return _dispatchProgress; }
	public function set dispatchProgress(value:Boolean):Void { _dispatchProgress=value; }
	
	
}
