import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;

/**
 * Initial player state, before any playback or user interaction
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.model.IdleState implements IPlayerState {
	
	private var _player:AbstractMediaPlayer;
	
	/**
	 * Constructor
	 * @param	player_	Player instance
	 */
	public function IdleState(player_:AbstractMediaPlayer) {
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
		_player.setState(_player.pausedState);
		_player.__doPause();
	}

	/**
	 * @see IPlayerState#doResume
	 */	
	public function doResume() : Void {
		_player.setState(_player.playingState);
		_player.__doResume();
		_player.distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_START, _player));
	}

	/**
	 * @see IPlayerState#doStop
	 */	
	public function doStop() : Void {
		_player.setState(_player.stoppedState);
		_player.__doStop();
	}

	public function toString():String {
		return "IdleState";
	}
}