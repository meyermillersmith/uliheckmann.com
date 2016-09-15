import lessrain.lib.components.mediaplayer07.core.AbstractMediaPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.SWFPlayerView;
import lessrain.lib.components.mediaplayer07.model.SWFPlayer;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.SWFPlayerFactory extends AbstractMediaPlayerFactory {
	
	public static function create(mediaPlayer_:MediaPlayer):AbstractMediaPlayerFactory {
		instance = new SWFPlayerFactory(mediaPlayer_);
		return instance;
	}
	
	private function SWFPlayerFactory(mediaPlayer_:MediaPlayer) {
		_view = new SWFPlayerView(mediaPlayer_);
		_view.setUIBuilder(mediaPlayer_.getViewUIBuilder());
		_view.buildUI(mediaPlayer_.skinFactory);
		_player = new SWFPlayer(
			mediaPlayer_.media,
			SWFPlayerView(_view).getSWFContainer(),
			_view.getDisplayPanel().getMediaContainer().getPreviewMC()
		);
	}

}