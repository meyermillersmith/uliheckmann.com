import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.scrollers.scrollpane.ScrollPane;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.utils.scrollers.scrollpane.ScrollPaneEvent implements IEvent {
	
	public static var FOCUS_RECEIVED:String = "focusReceived";
	public static var FOCUS_LOST:String = "focusLost";
	
	private var _type:String;
	private var _target:ScrollPane;
	
	public function ScrollPaneEvent(type_:String, target_:ScrollPane) {
		_type = type_;
		_target = target_;
	}
	
	public function getType() : String {
		return _type;
	}
	
	public function getTarget():ScrollPane {
		return _target;
	}

}