import lessrain.lib.components.mediaplayer07.core.MetaData;
import lessrain.lib.utils.events.IEvent;

class lessrain.lib.components.mediaplayer07.events.MetaDataEvent implements IEvent {
	public static var META_DATA : String = "metaData";
	private var _metaData : MetaData;
	private var _type : String;

	public function MetaDataEvent(type_ : String, metaData_ : MetaData) {
		_type = type_;
		_metaData = metaData_;
	}

	public function getTarget() : MetaData {
		return _metaData;
	}

	public function getType() : String {
		return _type;
	}
}
