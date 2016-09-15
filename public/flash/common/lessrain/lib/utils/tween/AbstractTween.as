/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
 
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.ITween;
import lessrain.lib.utils.tween.TweenEvent;

class lessrain.lib.utils.tween.AbstractTween implements IDistributor,ITween
{
	private var _eventDistributor 		: EventDistributor;
	
	private var _tweenTarget 			: Object;
	private var _tweenDuration 			: Number;
	private var _tweenDelay				: Number;
	private var _easingFunction			: Function;

	private var _dispatchProgress 		: Boolean;
	private var _enablePixelSnapping 	: Boolean;
	
	private var _propNameList			: Array;
	private var _propStartList			: Array;
	private var _propEndList			: Array;
	private var _propTotal				: Number;

	private var _delayStartInterval 	: Number;
	private var _startTime 				: Number;
	
	private var _startEvent    			: TweenEvent;
	private var _progressEvent 			: TweenEvent;
	private var _completeEvent 			: TweenEvent;
	
	private var _isRunning 				: Boolean;
	
	// optimization
	private var _sin					: Function;
	private var _pi					    : Number;
	
	public function AbstractTween() 
	{
		_eventDistributor = new EventDistributor();
		
		_isRunning=false;
		setDefaultProperties();
		initializePropertyList();
		
		_startEvent = new TweenEvent( TweenEvent.TWEEN_START,this );
		_progressEvent = new TweenEvent( TweenEvent.TWEEN_PROGRESS,this );
		_completeEvent = new TweenEvent( TweenEvent.TWEEN_COMPLETE,this );
		
		_sin = Math.sin;
		_pi  = Math.PI;
		
		// check for FBA (Frame Based Animation) or TBA (Time Based Animation)
		setRunMode();
	}
	
	/**
	 * Abstract Methods
	 */
	public function setRunMode():Void {throw new Error('Abstract Method');}
	public function startRunMode():Void {throw new Error('Abstract Method');}
	public function stopRunMode():Void {throw new Error('Abstract Method');}
	
	/**
	 * Start tween
	 * @param Optional delay_ in milliseconds before the tween executes
	 */
	public function start(delay_:Number):Void
	{
		_isRunning=true;
		seekToTime(0);
		if (delay_==null || delay_==0) executeTween();
		else _delayStartInterval= setInterval (Proxy.create(this,executeTween) , delay_);
	}
	
	private function executeTween():Void
	{
		clearInterval (_delayStartInterval);
		distributeEvent( _startEvent );
	
		_startTime = getTimer ();
		var i:Number=_propTotal;
		while(--i>-1) _tweenTarget [_propNameList[i]] = _propStartList[i];
		
		_isRunning=true;
		startRunMode();
	}
	/**
	 * loop
	 */
	private function update():Void 
	{
		
		var elapsedTime : Number =(getTimer()- _startTime);
		
		if (tweenCompletion(elapsedTime)) tweenComplete();
		else seekToTime(elapsedTime);

	}
	
	/**
	 * Set the progress of the tween to the given time
	 * @param	elapsedTime_	Time [ms] to apply to the tween (0..tweenDuration)
	 */
	public function seekToTime(elapsedTime_:Number):Void
	{
		if (tweenCompletion(elapsedTime_)) 
		{
			tweenComplete();
			
		}else{
			
			var i:Number=_propTotal;
			while(--i>-1)
			{
				var tStart : Number = _propStartList [i];
				var tEnd   : Number = _propEndList[i];
				var tDiff  : Number = ( tEnd - tStart );
				var pName  : String = _propNameList[i];
				if(_enablePixelSnapping) _tweenTarget[pName] = Math.round(_easingFunction (elapsedTime_, tStart, tDiff, _tweenDuration));
				else _tweenTarget[pName] = (_easingFunction (elapsedTime_, tStart, tDiff, _tweenDuration));
			}
			
			// CPU intensive if _dispatchProgress is set to true
			if(_dispatchProgress) distributeEvent( _progressEvent);
		}
	}
	
	/**
	 * Set the progress of the tween to the given percentage
	 * @param	percent	Percentage of the tween (0..100)
	 */
	public function seekToPercent(percent_:Number):Void
	{
		seekToTime(percent_ * _tweenDuration / 100);
	}
	
	/**
	 * Check if the tween is finish
	 */
	private function tweenCompletion(elapsedTime_:Number):Boolean
	{
		if (elapsedTime_ >= _tweenDuration) return true;
		return false;
	}
	
	/**
	 * Tween is finish
	 */
	private function tweenComplete() : Void
	{
		_isRunning=false;
		
		stopRunMode();

		var i:Number=_propTotal;
		
		while(--i>-1)
		{
			var tEnd  : Number = _propEndList[i];
			var pName : String = _propNameList[i];
			
			if(_enablePixelSnapping) _tweenTarget [pName] = Math.round (tEnd);
			else _tweenTarget [pName] = tEnd;
		}
		
		distributeEvent( _completeEvent);
	}
	
	/**
	 * Reset the properties of the tweenTarget and stops 
	 * intervals and/or enterframe
	 */
	public function reset():Void
	{
		clearInterval (_delayStartInterval);
		_isRunning=false;
		stopRunMode();
		initializePropertyList();
	}
	
	/**
	 * Default Tween Properties
	 */
	private function setDefaultProperties():Void
	{
		_tweenDuration = 2000;
		_easingFunction = easingDefault;
		
		_dispatchProgress=false;
		_enablePixelSnapping=false;
	}
	
	private function initializePropertyList():Void
	{
		_propNameList  = new Array();
		_propStartList = new Array();
		_propEndList   = new Array();
		_propTotal     = 0;
	}
	
	/**
	 * Optimal Default easing
	 */
	private function easingDefault (t_:Number, b_:Number, c_:Number, d_:Number):Number 
	{ 
		return c_ / 2 * ( _sin ( _pi * (t_ / d_ - 0.5)) + 1) + b_;
	}
	
	/**
	 * Set the property to tween.
	 * 
	 * @param propName_ 	 property name
	 * @param propStartVal_  start value, if null, defaults to the current property value
	 * @param propEndVal_    end value, if null, defaults to the current property value
	 * 
	 */
	public function setTweenProperty (propName_ : String, propStartVal_ : Number, propEndVal_ : Number) : Void
	{
		if (isNaN(propStartVal_)|| propStartVal_==null) propStartVal_ = _tweenTarget [propName_];
		if (isNaN(propEndVal_)|| propEndVal_==null) propEndVal_ = _tweenTarget [propName_];
		
		_propNameList.push(propName_);
		_propStartList.push(propStartVal_);
		_propEndList.push(propEndVal_);
		_propTotal = _propNameList.length;

	}
	
	public function destroy():Void
	{
		reset();
		_eventDistributor.finalize();
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}
	}
	
	public function get isRunning():Boolean { return _isRunning;}
	
	public function get tweenTarget() : Object { return _tweenTarget; }
	public function set tweenTarget( tweenTarget_:Object ) { _tweenTarget = tweenTarget_; }
	
	public function get tweenDuration() : Number { return _tweenDuration; }
	public function set tweenDuration( tweenDuration_:Number ) { _tweenDuration = tweenDuration_; }
	
	public function get easingFunction() : Function { return _easingFunction; }
	public function set easingFunction( easingFunction_:Function ) { _easingFunction = easingFunction_; }
	
	public function get dispatchProgress() : Boolean { return _dispatchProgress; }
	public function set dispatchProgress( dispatchProgress_:Boolean ) { _dispatchProgress = dispatchProgress_; }
	
	public function get enablePixelSnapping() : Boolean { return _enablePixelSnapping; }
	public function set enablePixelSnapping( enablePixelSnapping_:Boolean ) { _enablePixelSnapping = enablePixelSnapping_; }

	public function get tweenDelay():Number { return _tweenDelay; }
	public function set tweenDelay(tweenDelay_:Number):Void { _tweenDelay = tweenDelay_; }

	public function getTweenTarget() : Object {return _tweenTarget;}

	public function addEventListener(type : String, func : Function) : Void{_eventDistributor.addEventListener(type, func );}
	public function removeEventListener(type : String, func : Function) : Void{_eventDistributor.removeEventListener(type, func );}
	public function distributeEvent(eventObject : IEvent) : Void{_eventDistributor.distributeEvent(eventObject );}
}