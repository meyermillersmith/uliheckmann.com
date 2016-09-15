import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.AbstractMediaPlayerFactory {

	private static var instance : AbstractMediaPlayerFactory;

	private var _view : View;
	private var _player : AbstractMediaPlayer;
	
	/**
	 * Create view and player
	 */
	public static function create(mediaPlayer_ : MediaPlayer) : AbstractMediaPlayerFactory { // abstract
		return null;
	}
	
	/**
	 * Get the created media type specific view
	 * @return Created view
	 */
	public function getView() : View {
		return _view;
	}
	
	/**
	 * Get the created media type specific player
	 * @return	Created player
	 */
	public function getPlayer() : AbstractMediaPlayer {
		return _player;
	}
	
	/**
	 * Constructor
	 * Will be called by static create() method. Subclasses' implementations
	 * have to assign the fields <code>_view</code> and <code>_player</code>.
	 * 
	 * @param	mediaPlayer_	Calling media player instance
	 */
	private function AbstractMediaPlayerFactory(mediaPlayer_ : MediaPlayer) { // abstract
	}
	
}