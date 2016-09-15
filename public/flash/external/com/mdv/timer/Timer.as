/**-----------------------------------------------------------------------------
*	@class mdv.com.timer.Timer
*	@author Martijn de Visser - http://www.martijndevisser.com
*	@version 0.3
*	@description The Timer class enables the creation of timers that run for a specific number of milliseconds and can optionally run for a specific number of loops. Generated events : start, stop, pause, resume, progress, loopReady, timerReady. Please note that by default, the Timer does NOT generate progress events. Use either the 'reportProgress' paramter in the .start method to enable progress reporting, or set the 'reportProgress' to true. Porgress reporting is very CPU INTENSIVE!
*	@usage The following creates and then starts a Timer with an infinite number of 2 second loops:<br>
*	<code>
*	myTimer:Timer = new Timer(2000);
*	myTimer.start();
*	</code>
*	This creates a timer that runs 2 one second loops:<br>
*	<code>
*	myTimer:Timer = new Timer(1000, 2 );
*	myTimer.start();
*	</code>
*	@implementationNote Please note that setting the reportProgress property to true (to have the timer report loop progress) is very CPU INTENSIVE as many events are fired and each timer update needs to check for progress. This is off by default.
------------------------------------------------------------------------------*/
import com.mdv.events.Dispatcher;
import com.mdv.timer.TimerEvent;

class com.mdv.timer.Timer extends Dispatcher {

	/**
		@method addEventListener
		@usage <code>Timer.addEventListener(event, listener)</code><p>
		@description See {@link TimerEvent}
		@param event (String) Required; event to subscribe listener to.
		@param listener (Object) The listener object to subscribe to the specified event.
		@returns Nothing.
	*/

	/**
		@method removeEventListener
		@usage <code>Timer.removeEventListener(event, listener)</code><p>
		@description  Stops a listener from receiving the specified event.
		@param event (String) Required; event to unsubscribe listener from.
		@param listener (Object) The listener object to unsubscribe from the specified event.
		@returns Nothing.
	*/
	// event handling
	private var bPaused:Boolean;
	private var bRunning:Boolean;
	private var bReportProgress:Boolean;

	private var startTime:Number;
	private var playTime:Number;
	private var nLoop:Number;
	private var nLoops:Number;
	private var nDuration:Number;
	private var updateInterval:Number;
	private var intervalID:Number;

	/**-----------------------------------------------------------------------------
	Constructor
	@param nDuration (Number) Optional, number of milliseconds to run.
	@param loops (Number) Optional, number of loops to run. Defaults to 1 when ommitted.
	@param interval (Number) Optional, specifies how often the Timer is updated. Default is 50 milliseconds (e.g. 20 times a second).
	@param start (Boolean) Optional, if true, immediately starts the Timer after creation. Default is false.
	------------------------------------------------------------------------------*/
	public function Timer( inDuration:Number, inLoops:Number, inInterval:Number, inStartTimer:Boolean ) {

		super();

		// set vars
		bPaused = false;
		bRunning = false;
		bReportProgress = false;
		playTime = 0;
		nLoop = 0;
		nLoops = 1;
		intervalID = -1;
		updateInterval = 50;

		if (inDuration != undefined) { nDuration = inDuration; }
		if (inLoops != undefined) { nLoops = inLoops; }
		if (inInterval != undefined) { updateInterval = inInterval; }

		// if _startTimer is true, start the time
		if (inStartTimer)	{

			start(nDuration);
		}
	}


	//////////////////////////
	// 						//
	// 	PRIVATE FUNCTIONS	//
	// 						//
	//////////////////////////


	// called through setInterval to update timer
	private function update() : Void {

		// update timer
		playTime = (getTimer() - startTime);

		// dispatch progress event
		dispatchEvent( new TimerEvent( TimerEvent.PROGRESS, this, loop, loops, loopProgress, totalProgress ));

		if (playTime >= nDuration) {

			// dispatch loopReady event
			dispatchEvent( new TimerEvent( TimerEvent.LOOPREADY, this, loop, loops ));

			if (nLoops > 0) {

				// check current nLoop
				if (nLoop == nLoops) {

					// dispatch ready event
					dispatchEvent( new TimerEvent( TimerEvent.READY, this ));

					// clear interval
					clearInterval(intervalID);
					bRunning = false;

				} else {

					// start next loop
					nLoop++;
					startTime = getTimer();
				}

			} else {

				// run indefinitively
				startTime = getTimer();
			}
		}
	}

	//////////////////////////
	//						//
	// 	PUBLIC FUNCTIONS	//
	//						//
	//////////////////////////


	/**
		@method start
		@usage <code>Timer.start( 1000, true );</code><p>
		@description Starts the timer.
		@param inDuration (Number) Number of milliseconds / loop. Optional when already set on construction.
		@param inReportProgress (Boolean) optional, set this value to true to have the timer report loop progress by default. Please note that setting this to true is CPU INTENSIVE as many events are fired and each timer update needs to check for progress.
		@returns Nothing.
	*/
	public function start( inDuration:Number, inReportProgress:Boolean ) : Void {

		// start the timer
		if (inDuration != undefined) { nDuration = inDuration; }
		if (nLoops > 0 ) { nLoop = 1; }
		startTime = getTimer();
		bPaused = false;
		bRunning = true;
		
		// dispatch start event
		dispatchEvent( new TimerEvent( TimerEvent.START, this, loop, loops ));

		// was reportProgress param passed along?
		if (inReportProgress != undefined) bReportProgress = inReportProgress;

		// set interval
		if (bReportProgress) {
			intervalID = setInterval(this, "update", updateInterval );
		} else {
			intervalID = setInterval(this, "update", nDuration );
		}
	}

	/**
		@method stop
		@usage <code>Timer.stop();</code><p>
		@description Stops the timer.
		@returns Nothing.
	*/
	public function stop() : Void {

		// dispatch stop event
		dispatchEvent( new TimerEvent( TimerEvent.STOP, this ));
		clearInterval(intervalID);
		bRunning = false;
	}

	/**
		@method pause
		@usage <code>Timer.pause();</code><p>
		@description Pauses the timer.
		@returns Nothing.
	*/
	public function pause() : Void {
		
		// dispatch pause event
		dispatchEvent( new TimerEvent( TimerEvent.PAUSE, this ));
		// clear interval
		clearInterval(intervalID);
		// set flag
		bPaused = true;
	}

	/**
		@method resume
		@usage <code>Timer.resume();</code><p>
		@description Resumes the timer.
		@returns Nothing.
	*/
	public function resume() : Void {

		if (bPaused) {

			// dispatch resume event
			dispatchEvent( new TimerEvent( TimerEvent.RESUME, this ));
			// set flag
			bPaused = false;
			// update timer
			startTime = getTimer() - playTime;
			// set interval
			intervalID = setInterval(this, "update", updateInterval );
		}
	}

	/**
		@method reset
		@usage <code>Timer.reset();</code><p>
		@description Resets the timer (same as a .stop(), followed by a .start()).
		@returns Nothing.
	*/
	public function reset() : Void {

		// dispatch reset event
		dispatchEvent( new TimerEvent( TimerEvent.RESET, this ));
		stop();
		start();
	}


	//////////////////////////////////////////
	//										//
	// 	PUBLIC GETTER / SETTER FUNCTIONS	//
	//										//
	//////////////////////////////////////////


	/**
		@property loopProgress (Number) Returns the progress of current loop in milliseconds.
	*/
	public function get loopProgress() : Number {

		return playTime;
	}

	/**
		@property totalProgress (Number) Returns the progress of all loops in milliseconds.
	*/
	public function get totalProgress() : Number {

		return ((nLoop - 1) * nDuration ) + playTime;
	}

	/**
		@property loopPercentage (Number) Returns the progress of current loop as a percentage.
	*/
	public function get loopPercentage() : Number {

		return int(Math.max(1, Math.min(100, (playTime / nDuration ) * 100)));
	}

	/**
		@property totalPercentage (Number) Returns the progress of all loops as a percentage.
	*/
	public function get totalPercentage() : Number {

		return int(Math.max(1, Math.min(100, (totalProgress / (nLoops * nDuration ) ) * 100)));
	}

	/**
		@property duration (Number) Returns or sets the duration of a loop.
	*/
	public function get duration() : Number {

		return nDuration;
	}

	public function set duration( value:Number ) : Void {

		nDuration = (value < 0)? 0 : value;
	}

	/**
		@property interval (Number) Specifies how often the Timer is updated (msecs).
	*/
	public function set interval( value:Number ) : Void {

		updateInterval = (value < 1)? 10 : value;
	}
	
	/**
		@property Set this value to true to have the timer report loop progress by default. Please note that setting this to true is CPU INTENSIVE as many events are fired and each timer update needs to check for prrogress.
	*/
	public function set reportProgress ( inReportProgress:Boolean ) {
	
		bReportProgress = inReportProgress;
	}

	/**
		@property paused (Boolean) Returns if the timer is bPaused
	*/
	public function get paused() : Boolean {

		return bPaused;
	}

	/**
		@property running (Boolean) Returns if the timer is running (true during a pause!)
	*/
	public function get running() : Boolean {

		return bRunning;
	}

	/**
		@property loop (Number) Returns the current loop the timer is in.
	*/
	public function get loop() : Number {

		return nLoop;
	}

	/**
		@property loops (Number) Returns or sets the total number of loops.
	*/
	public function get loops() : Number {

		return nLoops;
	}

	public function set loops( value:Number ) : Void {

		nLoops = (value < 0)? 0 : value;
	}

	public function toString () : String {
		return ";mdv.com.timer.Timer";
	}
}
