import lessrain.lib.components.mediaplayer07.core.AbstractMediaPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.VideoPlayerView;
import lessrain.lib.components.mediaplayer07.model.VideoPlayer;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.VideoPlayerFactory extends AbstractMediaPlayerFactory {
	
	public static function create(mediaPlayer_:MediaPlayer):AbstractMediaPlayerFactory {
		instance = new VideoPlayerFactory(mediaPlayer_);
		return instance;
	}
	
	private function VideoPlayerFactory(mediaPlayer_:MediaPlayer) {
		_view = new VideoPlayerView(mediaPlayer_);
		_view.setUIBuilder(mediaPlayer_.getViewUIBuilder());
		_view.buildUI(mediaPlayer_.skinFactory);
		_player = new VideoPlayer(
			mediaPlayer_.media,
			VideoPlayerView(_view).getVideoContainer(),
			VideoPlayerView(_view).getSoundContainer(),
			_view.getDisplayPanel().getMediaContainer().getPreviewMC()
		);
	}

}