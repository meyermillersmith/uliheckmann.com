import lessrain.lib.layout.ILayoutable;
import lessrain.lib.utils.events.IEvent;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.events.MouseEvent implements IEvent {
	
	public static var MOUSE_ENTER:String = "mouseEnter";
	public static var MOUSE_LEAVE:String = "mouseLeave";	public static var MOUSE_MOVE_OVER:String = "mouseMoveOver";
	
	private var _type:String;
	private var _target:ILayoutable;
	
	public function MouseEvent(type_:String, target_:ILayoutable) {
		_type = type_;
		_target = target_;
	}
	
	public function getTarget():ILayoutable {
		return _target;
	}
	
	public function getType() : String {
		return _type;
	}

}