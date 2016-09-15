import lessrain.lib.layout.ILayoutable;
import lessrain.lib.utils.events.IEvent;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.LayoutEvent implements IEvent {

	public static var CHANGED_DEFAULT_SIZE : String = "changedDefaultSize";
	public static var CHANGED_NUMBER_OF_CHILDREN : String = "changedNumberOfChildren";
	public static var CHANGED_LAYOUT : String = "changedLayout";
	public static var CHANGED_LAYOUT_DATA : String = "changedLayoutData";
	public static var BOUNDARIES_SET : String = "boundariesSet";

	private var _type : String;
	private var _target : ILayoutable;

	public function LayoutEvent(type_ : String, target_ : ILayoutable) {
		_type = type_;
		_target = target_;
	}

	public function getType() : String {
		return _type;
	}

	public function getTarget() : ILayoutable {
		return _target;
	}

}