import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.utils.events.IEvent;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.events.ViewEvent implements IEvent {
	
	// The view has been resized
	public static var RESIZE:String = "resizeView";
	
	private var _type:String;
	private var _target:View;
	
	public function ViewEvent(type_:String, target_:View) {
		_type = type_;
		_target = target_;
	}
	
	public function getType() : String {
		return _type;
	}
	
	public function getTarget():View {
		return _target;
	}
}