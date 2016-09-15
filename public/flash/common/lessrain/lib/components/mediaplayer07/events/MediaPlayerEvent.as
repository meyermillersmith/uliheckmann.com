import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.utils.events.IEvent;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent implements IEvent {

	// The playing state has changed (e.g. playing / paused)
	public static var STATUS_CHANGE : String = "statusChange";

	// Playhead position has changed
	public static var PLAYHEAD_POSITION_CHANGE : String = "playheadPositionChange";

	/*
	 * Seek position has changed (whatever this may be, introduced to adapt the
	 * Chunked media player to AS2.
	 */
	public static var SEEK_POSITION_CHANGE : String = "seekPositionChange";

	// Playback has started
	public static var PLAYER_START : String = "playerStart";

	// End of the media file has been reached
	public static var PLAYER_END : String = "playerEnd";

	// Fullscreen state has changed
	public static var FULLSCREEN_CHANGE : String = "fullscreenChange";

	// Fullscreen popup window has been closed
	public static var FULLSCREEN_POPUP_CLOSED : String = "fullscreenPopupClosed";

	// Volume has changed
	public static var VOLUME_CHANGE : String = "volumeChange";

	// Next file
	public static var PLAY_NEXT : String = "playNext";

	// Previous file
	public static var PLAY_PREVIOUS : String = "playPrevious";

	/**
	 * Seek complete
	 */
	public static var SEEK_NOTIFY : String = "seekNotify";

	/*
	 * Change chunk
	 */
	public static var CHUNK_CHANGE : String = "chunkChange";

	private var _target : AbstractMediaPlayer;
	private var _type : String;

	/**
	 * Constructor
	 * @param type_		Event type
	 * @param target_	Event target
	 */
	public function MediaPlayerEvent(type_ : String, target_ : AbstractMediaPlayer) {
		_type = type_;
		_target = target_;
	}

	/**
	 * Get event type
	 * @return event type
	 */
	public function getType() : String {
		return _type;
	}

	/**
	 * Get event target
	 * @return event target
	 */
	public function getTarget() : AbstractMediaPlayer {
		return _target;
	}
}