import lessrain.lib.components.mediaplayer07.core.AbstractMediaPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.AudioPlayerView;
import lessrain.lib.components.mediaplayer07.model.AudioPlayer;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.AudioPlayerFactory extends AbstractMediaPlayerFactory {
	
	public static function create(mediaPlayer_:MediaPlayer):AbstractMediaPlayerFactory {
		instance = new AudioPlayerFactory(mediaPlayer_);
		return instance;
	}
	
	private function AudioPlayerFactory(mediaPlayer_:MediaPlayer) {
		_view = new AudioPlayerView(mediaPlayer_);
		_view.setUIBuilder(mediaPlayer_.getViewUIBuilder());
		_view.buildUI(mediaPlayer_.skinFactory);
		_player = new AudioPlayer(
			mediaPlayer_.media,
			AudioPlayerView(_view).getSoundContainer(),
			_view.getDisplayPanel().getMediaContainer().getPreviewMC()
		);
		if(mediaPlayer_.media.getMaster().duration != null) {
			_player.setDuration(mediaPlayer_.media.getMaster().duration);
		}
	}

}