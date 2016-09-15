import lessrain.lib.components.mediaplayer07.core.AbstractMediaPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.ChunkedVideoPlayerView;
import lessrain.lib.components.mediaplayer07.model.ChunkedVideoPlayer;

/**
 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.ChunkedVideoPlayerFactory extends AbstractMediaPlayerFactory {

	public static function create(mediaPlayer_ : MediaPlayer) : AbstractMediaPlayerFactory {
		instance = new ChunkedVideoPlayerFactory(mediaPlayer_);
		return instance;
	}

	/**
	 * Constructor
	 * Do not call!
	 */
	public function ChunkedVideoPlayerFactory(mediaPlayer_ : MediaPlayer) {
		_view = new ChunkedVideoPlayerView(mediaPlayer_);
		_view.setUIBuilder(mediaPlayer_.getViewUIBuilder());
		_view.buildUI(mediaPlayer_.skinFactory);
		
		_player = new ChunkedVideoPlayer(mediaPlayer_.mediaFeed, ChunkedVideoPlayerView(_view).getVideoContainer(), ChunkedVideoPlayerView(_view).getSoundContainer(), _view.getDisplayPanel().getMediaContainer().getPreviewMC());
	}
}
