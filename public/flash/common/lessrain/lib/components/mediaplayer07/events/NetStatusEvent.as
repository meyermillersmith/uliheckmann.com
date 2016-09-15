import lessrain.lib.utils.events.IEvent;

/**
 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.events.NetStatusEvent implements IEvent {
	
	public static var NET_STATUS:String = "netStatus";
	
	private var _type:String;
	private var _target : Object;
	private var _infoObject:Object;

	
	public function NetStatusEvent(type_:String, target_:Object, infoObject_:Object) {
		_type = type_;
		_target = target_;
		_infoObject = infoObject_;
	}

	public function getType() : String {
		return _type;
	}
	
	public function getNetStatusCode():String {
		return _infoObject.code.toString();
	}

	public function getTarget():Object {
		return _target;
	}
	
	public function getInfoObject():Object {
		return _infoObject;
	}
}
