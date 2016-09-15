import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;

/**
 * State that becomes active when the player is currently playing
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.model.PlayingState implements IPlayerState {
	
	private var _player:AbstractMediaPlayer;
	
	/**
	 * Constructor
	 * @param	player_	Player instance
	 */
	public function PlayingState(player_:AbstractMediaPlayer) {
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
		_player.setState(_player.pausedState);
		_player.__doPause();
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
		_player.setState(_player.stoppedState);
		_player.__doStop();
	}
	
	public function toString():String {
		return "PlayingState";
	}

}