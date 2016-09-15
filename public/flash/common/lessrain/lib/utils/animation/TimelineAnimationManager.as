/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.utils.animation.TimelineAnimationEvent;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;

class lessrain.lib.utils.animation.TimelineAnimationManager implements IDistributor
{
	/*
	 * EventDistributor
	 */
	private var _eventDistributor : EventDistributor;
	
	
	/*
	 * Getter & setter
	 */	
	private var _targetMC		: MovieClip;
	
	
	/*
	 * Properties
	 */
	private var cID				: Number = -1;
	private var delayID			: Number = -1;
	
	private var delay			: Number = 0;
	public  var intervalTime	: Number = 20;
	
	private var startFrame		: Number;
	private var endFrame		: Number;
	private var currentFrame	: Number;
	private var totalFrames		: Number;

	
	
	
	/*
	 * Constructor
	 * @param	the animation movieclip
	 */
	public function TimelineAnimationManager(targetMC:MovieClip)
	{
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
		
		_targetMC = targetMC;
		_targetMC.stop();
		
		currentFrame = _targetMC._currentframe;
		totalFrames  = _targetMC._totalframes;
	}
	
	/*
	 * From A to B:
	 * Starts the animation
	 * @param	startFrame
	 * @param	endFrame
	 * @param	delay in millisec
	 */
	public function startAnimation(startFrame_:Number, endFrame_:Number, delay_:Number, intervalTime_:Number) :Void
	{
		clearInterval( cID );
		startFrame 		= startFrame_;
		endFrame 		= endFrame_;
		delay	 		= (delay_!=null) ? delay_ : delay;
		intervalTime	= (intervalTime_!=null) ? intervalTime_ : intervalTime;
		
		if (delayID<0) delayID = setInterval(this, "startAnimationDelayed", delay);
	}
	
	/*
	 * Forward:
	 * Simple animation from the first to the last frame
	 */
	public function startForward(delay_:Number, intervalTime_:Number) :Void
	{
		clearInterval( cID );
		clearInterval( delayID );
		startFrame 		= 1;
		endFrame 		= totalFrames;
		delay	 		= (delay_!=null) ? delay_ : delay;
		intervalTime	= (intervalTime_!=null) ? intervalTime_ : intervalTime;
		
		if (delayID<0) delayID = setInterval(this, "startAnimationDelayed", delay);
	}
	
	/*
	 * Backward:
	 * Simple animation from the last to the first frame
	 */
	public function startBackward(delay_:Number, intervalTime_:Number) :Void
	{
		clearInterval( cID );
		clearInterval( delayID );
		
		startFrame 		= totalFrames-1;
		endFrame 		= 1;
		delay	 		= (delay_!=null) ? delay_ : delay;
		intervalTime	= (intervalTime_!=null) ? intervalTime_ : intervalTime;
		
		if (delayID<0) delayID = setInterval(this, "startAnimationDelayed", delay);
	}
	
	/*
	 * Start delayed, if not set: delay = 0 ms
	 */
	private function startAnimationDelayed() :Void
	{
		clearInterval( cID );
		clearInterval(delayID);
		delayID = -1;
		
		currentFrame = startFrame;
		
		distributeEvent( new TimelineAnimationEvent( TimelineAnimationEvent.INIT, this ));
		
		cID = setInterval(this, "animate", intervalTime);
	}
	
	/*
	 * A single animation step
	 */
	private function animate() :Void
	{
		if (currentFrame==endFrame)
		{
			clearInterval(cID);
			cID = -1;
			onAnimationFinished();
		}
		else
		{
			var direction:Number = (endFrame>startFrame) ? 1 : -1;
			currentFrame += direction;
			
			_targetMC.gotoAndStop( currentFrame );
			
			distributeEvent( new TimelineAnimationEvent( TimelineAnimationEvent.PROGRESS, this ));
		}
	}
	
	/*
	 * The animation is complete
	 */
	private function onAnimationFinished() :Void
	{
		distributeEvent( new TimelineAnimationEvent( TimelineAnimationEvent.COMPLETE, this ));
	}
	
	public function stop() :Void
	{
		clearInterval(cID);
		cID = -1;
		clearInterval(delayID);
		delayID = -1;
	}
	
	/**
	 * Sets the interval time
	 */
	public function setIntervalTime( value:Number ) :Void
	{
		intervalTime = value;
	}
	
	public function finalize() :Void
	{
		clearInterval(cID);
		clearInterval(delayID);
		_eventDistributor.finalize();
	}
	
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	/*
	 * EventDistributor methods
	 */
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
}