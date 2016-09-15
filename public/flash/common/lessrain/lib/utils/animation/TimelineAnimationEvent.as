/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.utils.animation.TimelineAnimationManager;
import lessrain.lib.utils.events.IEvent;

class lessrain.lib.utils.animation.TimelineAnimationEvent implements IEvent 
{
	public static var INIT 		: String = "onTimelineAnimationInitialized";
	public static var PROGRESS	: String = "onTimelineAnimationProgress";
	public static var COMPLETE	: String = "onTimelineAnimationComplete";
	
	
	/*
	 * Infos
	 */
	private var _type 	: String;
	private var _target : TimelineAnimationManager;
	
	
	/*
	 * Wat der Max da wieder für'n Jelumpe gebaut hat .. der Lump der ..
	 */
	public function TimelineAnimationEvent( type_:String, target_:TimelineAnimationManager ) 
	{
		_target = target_;
		_type 	= type_;
	}
	
	/*
	 * Get infos
	 */
	public function getTarget() : TimelineAnimationManager { return _target; }
	public function getType() 	: String 	 { return _type; }
}