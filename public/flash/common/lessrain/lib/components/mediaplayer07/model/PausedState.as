import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;

/**
 * Paused playback state
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.model.PausedState implements IPlayerState {

	private var _player : AbstractMediaPlayer;

	public function PausedState(player_ : AbstractMediaPlayer) {
		_player = player_;
	}

	/**
	 * @see IPlayerState#doPlay
	 */	
	public function doPlay() : Void {
		_player.setState(_player.playingState);
		_player.__doPlay();
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
		_player.setState(_player.playingState);
		_player.__doResume();
	}

	/**
	 * @see IPlayerState#doStop
	 */	
	public function doStop() : Void {
		_player.setState(_player.stoppedState);
		_player.__doStop();
	}
	
	public function toString():String {
		return "PausedState";
	}
}