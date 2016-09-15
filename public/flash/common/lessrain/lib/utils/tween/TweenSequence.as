
//import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.tween.ITween;
import lessrain.lib.utils.tween.TweenFrame;
import lessrain.lib.utils.tween.TweenTimer;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.lib.utils.tween.AbstractTween;
import lessrain.lib.utils.tween.TweenSequenceEvent;

//import mx.events.EventDispatcher;

class lessrain.lib.utils.tween.TweenSequence implements IDistributor
{
	// Getter & setter
	private var _tweenSequence				: Array;
	private var _loopSequence				: Boolean = false;
	private var _callBackOnSequenceComplete	: Function;
	private var _callBackOnSequenceProgress	: Function;	
	private var _isStopped					: Boolean = false;	
	private var _isInterrupted				: Boolean = false;
	private var _percent					: Number = 0;
		
	// Internal
	private var _singleTweenProgressProxy	: Function;
	private var _singleTweenCompleteProxy	: Function;
	private var _currentTween				: AbstractTween;
	private var _currentTweenNum			: Number;
	
	private var _progressEvent 				: TweenSequenceEvent;
	private var _completeEvent 				: TweenSequenceEvent;


	private var _eventDistributor : EventDistributor;
	
	
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
		
		_progressEvent = new TweenSequenceEvent( TweenSequenceEvent.TWEEN_SEQUENCE_PROGRESS, this );
		_completeEvent = new TweenSequenceEvent( TweenSequenceEvent.TWEEN_SEQUENCE_COMPLETE, this );

		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
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
		
		/*
		if (_currentTween instanceof TweenFrame) 
		_currentTween = TweenFrame( _tweenSequence[ _currentTweenNum ] );
		else if (_currentTween instanceof TweenTimer)
		_currentTween = TweenTimer( _tweenSequence[ _currentTweenNum ] );

 * 
 */
 		_currentTween = AbstractTween( _tweenSequence[ _currentTweenNum ] );
		_currentTween.addEventListener(TweenEvent.TWEEN_PROGRESS, _singleTweenProgressProxy);
		_currentTween.addEventListener(TweenEvent.TWEEN_COMPLETE, _singleTweenCompleteProxy);
		_currentTween.start( _currentTween.tweenDelay );
	}
	
	/**
	 * Deletes the current tween and its event listeners
	 */
	private function deleteCurrentTween() :Void
	{
		_currentTween.removeEventListener(TweenEvent.TWEEN_PROGRESS, _singleTweenProgressProxy);
		_currentTween.removeEventListener(TweenEvent.TWEEN_COMPLETE, _singleTweenCompleteProxy);
		
		/*
		if (_isInterrupted) _currentTween.reset();
		else if (_isStopped) _currentTween.stop();
		 * 
		 */
		_currentTween.reset();
		
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
		distributeEvent( _progressEvent );
		//dispatchEvent( { type: "onSequenceProgress", percent: 0 } );
	}
	
	/**
	 * Gets called, when the sequence if finished
	 */
	private function onSequenceComplete() :Void
	{
		deleteCurrentTween();
		
		_percent = 100;
		
		distributeEvent( _completeEvent );
		
		
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
			var tween:AbstractTween = AbstractTween(_tweenSequence[i]);
			totalDuration += tween.tweenDelay + tween.tweenDuration;
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
	
	public function get percent():Number { return _percent; }
	public function set percent(percent_:Number):Void { _percent = percent_; }
	
	
	// Event Distributor
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}

}