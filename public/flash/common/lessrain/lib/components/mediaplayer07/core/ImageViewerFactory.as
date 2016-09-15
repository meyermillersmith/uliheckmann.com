import lessrain.lib.components.mediaplayer07.core.AbstractMediaPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.ImageViewerView;
import lessrain.lib.components.mediaplayer07.model.ImageViewer;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.ImageViewerFactory extends AbstractMediaPlayerFactory {
	
	public static function create(mediaPlayer_:MediaPlayer):AbstractMediaPlayerFactory {
		instance = new ImageViewerFactory(mediaPlayer_);
		return instance;
	}
	
	private function ImageViewerFactory(mediaPlayer_:MediaPlayer) {
		_view = new ImageViewerView(mediaPlayer_);
		_view.setUIBuilder(mediaPlayer_.getViewUIBuilder());
		_view.buildUI(mediaPlayer_.skinFactory);
		_player = new ImageViewer(
			mediaPlayer_.media,
			ImageViewerView(_view).getImageContainer(),
			_view.getDisplayPanel().getMediaContainer().getPreviewMC()
		);
	}

}