import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;

/**
 * StoppesState becomes active when the playhead reached the end of the media
 * file playback is stopped by the user.
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.model.StoppedState implements IPlayerState {
	
	private var _player:AbstractMediaPlayer;
	
	/**
	 * Constructor
	 * @param	player_	Player instance
	 */
	public function StoppedState(player_:AbstractMediaPlayer) {
		_player = player_;
	}
	
	/**
	 * @see IPlayerState#doPlay
	 */	
	public function doPlay() : Void {
		doResume();
	}

	/**
	 * @see IPlayerState#doPause
	 */	
	public function doPause() : Void {
		return;
	}

	/**
	 * @see IPlayerState#doResume
	 */	
	public function doResume() : Void {
		_player.__doStop();
		_player.setState(_player.playingState);
		_player.__doResume();
		_player.distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_START, _player));
	}

	/**
	 * @see IPlayerState#doStop
	 */	
	public function doStop() : Void {
		return;
	}
	
	public function toString():String {
		return "StoppedState";
	}

}