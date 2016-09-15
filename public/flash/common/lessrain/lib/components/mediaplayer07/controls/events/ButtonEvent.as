import lessrain.lib.components.mediaplayer07.controls.Button;
import lessrain.lib.utils.events.IEvent;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.events.ButtonEvent implements IEvent {

	public static var PRESS : String = "press";
	public static var RELEASE : String = "release";
	public static var ROLLOVER : String = "rollover";
	public static var ROLLOUT : String = "rollout";
	public static var RELEASE_OUTSIDE : String = "releaseOutside";

	private var _type : String;
	private var _target : Button;

	public function ButtonEvent(type_ : String, target_ : Button) {
		_type = type_;
		_target = target_;
	}

	public function getType() : String {
		return _type;
	}

	public function getTarget() : Button {
		return _target;
	}

}