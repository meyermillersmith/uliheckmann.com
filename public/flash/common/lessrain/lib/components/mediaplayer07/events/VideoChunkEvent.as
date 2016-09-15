import lessrain.lib.components.mediaplayer07.model.VideoChunk;
import lessrain.lib.utils.events.IEvent;	

class lessrain.lib.components.mediaplayer07.events.VideoChunkEvent implements IEvent {
	public static var CHUNK_START : String = "chunkStart";	public static var CHUNK_END : String = "chunkEnd";
	
	private var _type : String;
	private var _target : VideoChunk;

	
	public function VideoChunkEvent(type_ : String, target_:VideoChunk) {
		_type = type_;
		_target = target_;
	}

	public function getType() : String {
		return _type;
	}
	
	public function getTarget() : VideoChunk {
		return _target;
	}
}
