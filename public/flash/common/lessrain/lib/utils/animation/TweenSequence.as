/**
 * lessrain.lib.utils.animation.TweenSequence , Version 1.0
 * 
 * 
 * A TweenSequence is collection of tweens, which have to be executed one after another. The sequence can be loopable, initially it's not loopable.
 * You can define callback methods for the sequence states <b>onProgress</b> and <b>onComplete</b>.
 * 
 * <b>Usage:</b>
 * 
 * <code>
 * import lessrain.lib.utils.animation.TweenSequence;
 * import lessrain.lib.utils.animation.Tween;
 * import lessrain.lib.utils.animation.easing.Linear;
 * import lessrain.lib.utils.Proxy;
 * 
 * var tweens:Array = [];
 * 
 * var tweenA:Tween = new Tween (mc, [{prop:'_y', start:0, end:600}, {prop:'_alpha', start:100, end:50}], 1000, Linear.easeInOut, false, 0, false);
 * tweenA.addEventListener('onProgress', Proxy.create(this, tweenAOnProgress));
 * 
 * var tweenB:Tween = new Tween (mc, [{prop:'_x', start:0, end:600}, {prop:'_alpha', start:100, end:100}], 1500, Linear.easeIn, false, 0, false);
 * tweenB.addEventListener('onProgress', Proxy.create(this, tweenBOnProgress));
 * 
 * var tweenC:Tween = new Tween (mc, [{prop:'_x', start:600, end:0}, {prop:'_y', start:600, end:0}], 1000, Linear.easeOut, false, 0, false);
 * tweenC.delay = 500;
 * tweenD.addEventListener('onComplete', Proxy.create(this, tweenCOnComplete));
 * 
 * tweens.push(tweenA);
 * tweens.push(tweenB);
 * tweens.push(tweenC);
 * 
 * var tweenSequence:TweenSequence = new TweenSequence(tweens, true, Proxy.create(this, allOnComplete), Proxy.create(this, allOnProgress));
 * tweenSequence.getDuration();
 * tweenSequence.start();
 * 
 * function tweenAOnProgress() { trace ("tween A onProgress"); }
 * function tweenBOnProgress() { trace ("tween B onProgress"); }
 * function tweenCOnComplete() { trace ("tween C onProgress"); }
 * function allOnProgress() 	{ trace ("allOnProgress"); }
 * function allOnComplete() 	{ trace ("allOnComplete"); }
 * </code>
 * 
 * 
 * @author  Torsten Härtel, Less Rain (torsten@lessrain.com)
 * @version 1.0
 * @see		lessrain.lib.utils.animation.Tween
 * @see		lessrain.lib.utils.Proxy
 * @see		mx.events.EventDispatcher
 */
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.Proxy;
import mx.events.EventDispatcher;

class lessrain.lib.utils.animation.TweenSequence 
{
	// Getter & setter
	private var _tweenSequence				: Array;
	private var _loopSequence				: Boolean = false;
	private var _callBackOnSequenceComplete	: Function;
	private var _callBackOnSequenceProgress	: Function;	
	private var _isStopped					: Boolean = false;	
	private var _isInterrupted				: Boolean = false;
		
	// Internal
	private var _singleTweenProgressProxy	: Function;
	private var _singleTweenCompleteProxy	: Function;
	private var _currentTween				: Tween;
	private var _currentTweenNum			: Number;
	
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	
	
	/**
	 * Adds a file to the Queue.
	 * Loading will start in the next EnterFrame.
	 * 
	 * @param	tweenSequence_					The Arrays with tweens to execute
	 * @param	loopSequence_					The sequence is loopable, initial value is false
	 * @param	callBackOnSequenceComplete_		This method shall be called, when the sequence is complete
	 * @param	callBackOnSequenceProgress_		This method shall be called, when the sequence is in progress
	 * 
	 * @see		lessrain.lib.utils.animation.Tween
	 * @see		lessrain.lib.utils.Proxy
	 */
	public function TweenSequence(tweenSequence_:Array, loopSequence_:Boolean, callBackOnSequenceComplete_:Function, callBackOnSequenceProgress_:Function) 
	{
		_tweenSequence 	= (tweenSequence_!=null) ? tweenSequence_ : [];
		_loopSequence	= (loopSequence_!=null)  ? loopSequence_ : false;
		
		_callBackOnSequenceComplete = (callBackOnSequenceComplete_!=null) ? callBackOnSequenceComplete_ : null;
		_callBackOnSequenceProgress = (callBackOnSequenceProgress_!=null) ? callBackOnSequenceProgress_ : null;
		
		_currentTweenNum = 0;
		
		_isStopped = false;
		
		EventDispatcher.initialize(this);
	}
	
	/**
	 * Starts the sequence
	 */
	public function start() :Void
	{
		startNextTween();
	}
	
	/**
	 * Stops the sequence when the current tween is finished
	 * This is a "soft" stop
	 */
	public function stop() :Void
	{
		_isStopped = true;
	}
	
	/**
	 * Stops the sequence immediately
	 * This is a "hard" stop
	 */
	public function interrupt() :Void
	{
		_isInterrupted = true;
		_isStopped = true;
		deleteCurrentTween();
	}
	
	/**
	 * Gets called, if there are remaining tweens in the queue
	 */
	private function startNextTween() :Void
	{
		// Remove old tween and its listeners
		if (_currentTween!=null)
		{
			//_currentTween.reset();
			deleteCurrentTween();
		}
		
		// Set new listeners
		_singleTweenProgressProxy = Proxy.create(this, onSingleTweenProgress);
		_singleTweenCompleteProxy = Proxy.create(this, onSingleTweenComplete);
		
		// Set new Tween
		_currentTween = Tween( _tweenSequence[ _currentTweenNum ] );
		_currentTween.addEventListener('onProgress', _singleTweenProgressProxy);
		_currentTween.addEventListener('onComplete', _singleTweenCompleteProxy);
		_currentTween.startWithDelay( _currentTween.delay );
	}
	
	/**
	 * Deletes the current tween and its event listeners
	 */
	private function deleteCurrentTween() :Void
	{
		_currentTween.removeEventListener('onProgress', _singleTweenProgressProxy);
		_currentTween.removeEventListener('onComplete', _singleTweenCompleteProxy);
		
		if (_isInterrupted) _currentTween.reset();
		else if (_isStopped) _currentTween.stop();
		
		delete _currentTween;
	}
		
	/**
	 * Gets called, when the current single tween is in progress
	 */
	private function onSingleTweenProgress() :Void
	{
		if (_callBackOnSequenceProgress!=null) onSequenceProgress();
	}
	
	/**
	 * Gets called, when the sequence if finished
	 */
	private function onSingleTweenComplete() :Void
	{
		if ( (_currentTweenNum == (_tweenSequence.length-1)) || _isStopped)
		{
			onSequenceComplete();
		}
		else
		{
			_currentTweenNum++;
			startNextTween();
		}
	}
	
	/**
	 * Gets called, when the sequence is in progress and a function is defined
	 * @required _callBackOnSequenceProgress:Function != null
	 */
	private function onSequenceProgress() :Void
	{
		if (_callBackOnSequenceProgress!=null) _callBackOnSequenceProgress();
		dispatchEvent( { type: "onSequenceProgress", percent: 0 } );
	}
	
	/**
	 * Gets called, when the sequence if finished
	 */
	private function onSequenceComplete() :Void
	{
		deleteCurrentTween();
		
		dispatchEvent( { type: "onSequenceComplete", percent: 100 } );
		
		if (!_isStopped)
		{
			if (_callBackOnSequenceComplete!=null) _callBackOnSequenceComplete();
			
			if (_loopSequence)
			{
				_currentTweenNum = 0;
				startNextTween();
			}
		}
		else
		{
			delete _tweenSequence;
			delete _callBackOnSequenceProgress;
			delete _callBackOnSequenceComplete;
		}
	}
	
	/**
	 * @return total duration of the sequence incl. delay of every single tween
	 */
	public function getDuration() :Number
	{
		var totalDuration:Number = 0;
		for (var i : Number = 0; i < _tweenSequence.length; i++)
		{
			totalDuration += Tween( _tweenSequence[i] ).delay + Tween( _tweenSequence[i] ).duration;
		}
		return totalDuration;
	}

	/*
	 * Getter & setter	
	 */ 
	public function get tweens():Array { return _tweenSequence; }
	public function set tweens(value:Array):Void { _tweenSequence=value; }

	public function get loopSequence():Boolean { return _loopSequence; }
	public function set loopSequence(value:Boolean):Void { _loopSequence=value; }

	public function get callBackOnSequenceProgress():Function { return _callBackOnSequenceProgress; }
	public function set callBackOnSequenceProgress(value:Function):Void { _callBackOnSequenceProgress=value; }
	
	public function get callBackOnSequenceComplete():Function { return _callBackOnSequenceComplete; }
	public function set callBackOnSequenceComplete(value:Function):Void { _callBackOnSequenceComplete=value; }
	
	public function get isStopped():Boolean { return _isStopped; }
	public function set isStopped(value:Boolean):Void { _isStopped=value; }
	
	public function get isInterrupted():Boolean { return _isInterrupted; }
	public function set isInterrupted(value:Boolean):Void { _isInterrupted=value; }
	
}