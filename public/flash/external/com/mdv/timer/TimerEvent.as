/*
   @class com.mdv.timer.TimerEvent
   @author Martijn de Visser 
   @description The TimerEvent is broadcasted by the {@link Timer} class, the 'type' property can have any of the following values
		<blockquote>
			<b>onTimerStart</b>, broadcasted when a Timer is started.<br>
			<b>onTimerStop</b>, broadcasted when a Timer is stopped.<br>
			<b>onTimerPause</b>, broadcasted when a Timer is paused.<br>
			<b>onTimerResume</b>, broadcasted when a Timer is resumed.<br>
			<b>onTimerReset</b>, broadcasted when a Timer is reset.<br>
			<b>onTimerProgress</b>, broadcasted on Timer progress.<br>			
			<b>onTimerLoopReady</b>, broadcasted when a loop is completed.<br>
			<b>onTimerReady</b>, broadcasted when Timer is done (all loops).<br>
		</blockquote>
	The event always contains a target property, referring to the Timer that triggered the event and the follwoing detailed loop-releated information:
	<ul>
		<li><b>loop</b>, the current loop the timer is in (-1 if 'loops' set to infinite).</li>
		<li><b>loops</b>, the total number of loops to execute (-1 if 'loops' set to infinite).</li>
		<li><b>loopProgress</b>, the progress of this loop (msecs).</li>
		<li><b>totalProgress</b>, the progress of all loops together so far (msecs).</li>
	</ul>
*/

import com.mdv.timer.Timer;

class com.mdv.timer.TimerEvent {

	public var type:String;
	public var target:Timer;
	public var loop:Number;
	public var loops:Number;
	public var loopProgress:Number;
	public var totalProgress:Number;
	
	// possible values for 'type'
	public static var START:String 		= "onTimerStart";
	public static var STOP:String 		= "onTimerStop";
	public static var PAUSE:String 		= "onTimerPause";
	public static var RESUME:String 	= "onTimerResume";
	public static var RESET:String 		= "onTimerReset";
	public static var PROGRESS:String 	= "onTimerProgress";
	public static var LOOPREADY:String 	= "onTimerLoopReady";
	public static var READY:String 		= "onTimerReady";

	/**-----------------------------------------------------------------------
	*	Constructor
	-------------------------------------------------------------------------*/
	public function TimerEvent ( inType:String, inTarget:Timer, inLoop:Number, inLoops:Number, inLoopProgress:Number, inTotalProgress:Number ) {
	
		type = inType;
		target = inTarget;
		loop = inLoop;
		loops = inLoops;
		loopProgress = inLoopProgress;
		totalProgress = inTotalProgress;
	}
}