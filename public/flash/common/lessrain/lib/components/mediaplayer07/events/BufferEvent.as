import lessrain.lib.utils.events.IEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.events.BufferEvent implements IEvent {
	
	// Buffer empty
	public static var BUFFER_EMPTY : String = "bufferEmpty";
	
	// Buffer full
	public static var BUFFER_FULL : String = "bufferFull";
	
	// Buffer progress
	public static var BUFFER_PROGRESS : String = "bufferProgress";

	private var _type : String;
	private var _target : AbstractMediaPlayer;
	private var _bufferPercent : Number;

	public function BufferEvent(type_ : String, target_ : AbstractMediaPlayer, bufferPercent_ : Number) {
		_type = type_;
		_target = target_;
		_bufferPercent = bufferPercent_;
	}

	public function getType() : String {
		return _type;
	}

	public function getTarget() : AbstractMediaPlayer {
		return _target;
	}

}