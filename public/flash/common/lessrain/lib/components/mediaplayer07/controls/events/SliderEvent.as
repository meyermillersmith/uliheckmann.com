import lessrain.lib.components.mediaplayer07.controls.Slider;
import lessrain.lib.utils.events.IEvent;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.events.SliderEvent implements IEvent {
	
	// Slider value has changed
	public static var VALUE_CHANGED:String = "valueChanged";
	
	// Minumum value has changed
	public static var MIN_CHANGED:String = "minChanged";
	
	// Maximum value has changed
	public static var MAX_CHANGED:String = "maxChanged";
	
	// Minimum selectable value has changed
	public static var SELECTABLE_MIN_CHANGED:String = "selectableMinChanged";
	
	// Maximum selectable value has changed
	public static var SELECTABLE_MAX_CHANGED:String = "selectableMaxChanged";
	
	// User has started dragging the slider
	public static var START_DRAG:String = "startDrag";
	
	// User has stopped dragging the slider
	public static var STOP_DRAG:String = "stopDrag";
	
	private var _type:String;
	private var _target:Slider;
	
	/**
	 * Constructor
	 * @param	type_	Event type
	 * @param	target_	Slider that dispatches the event
	 */
	public function SliderEvent(type_:String, target_:Slider) {
		_type = type_;
		_target = target_;
	}
	
	/**
	 * @see	IEvent#getType
	 */
	public function getType() : String {
		return _type;
	}
	
	/**
	 * Get the slider instance that has dispatched the event
	 * @return	Target slider
	 */
	public function getTarget():Slider {
		return _target;
	}

}