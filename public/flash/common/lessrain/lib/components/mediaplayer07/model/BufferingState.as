import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;

/**
 * Player state that becomes active when the buffer runs emtpty
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.model.BufferingState implements IPlayerState {
	
	private var _player:AbstractMediaPlayer;
	
	/**
	 * Constructor
	 * @param	player_	Player instance
	 */
	public function BufferingState(player_:AbstractMediaPlayer) {
		_player = player_;
	}

	/**
	 * @see IPlayerState#doPlay
	 */	
	public function doPlay() : Void {
		return;
	}

	/**
	 * @see IPlayerState#doPause
	 */
	public function doPause() : Void {
		return;
		/*
		 * Calling _player.__doPause() causes problems when the media is still
		 * buffering 
		 */
//		_player.setState(_player.pausedState);
//		_player.__doPause();
	}

	/**
	 * @see IPlayerState#doResume
	 */
	public function doResume() : Void {
		return;
	}

	/**
	 * @see IPlayerState#doStop
	 */
	public function doStop() : Void {
		return;
		/*
		 * Calling _player.__doStop() causes problems when the media is still
		 * buffering
		 */
//		_player.setState(_player.stoppedState);
//		_player.__doStop();
	}
	
	public function toString():String {
		return "BufferingState";
	}
}