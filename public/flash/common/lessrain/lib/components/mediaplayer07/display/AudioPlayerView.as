import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.AudioPlayerView extends View {

	/**
	 * View type
	 * @see	View#getType
	 */	
	public static var TYPE:String = "audioPlayerView";
	
	private var _soundContainer:MovieClip;
	
	/**
	 * Constructor
	 * @see View
	 */
	public function AudioPlayerView(mediaPlayer_:MediaPlayer) {
		super(mediaPlayer_);
	}
	
	/**
	 * @see View#buildUI
	 */
	public function buildUI(skinFactory_:ISkinFactory):Void
	{
		super.buildUI(skinFactory_);
		
		// Attach sound container
		var target:MovieClip = _displayPanel.getMediaContainer().getTarget();
		_soundContainer = target.createEmptyMovieClip("soundContainer_mc", target.getNextHighestDepth());
	}
	
	/**
	 * Get sound container clip
	 * @return sound container clip
	 */
	public function getSoundContainer():MovieClip {
		return _soundContainer;
	}
	
	/**
	 * @see View#getType
	 */
	public function getType():String {
		return TYPE;
	}
	
	private function onExternalWindowClosed():Void {
		getMVCController().setFullscreen(false);
	}
	
	/**
	 * @see View#onStageFullScreenChanged
	 */
	private function onStageFullScreenChanged(isFullscreen_:Boolean):Void {
		getMVCController().setFullscreen(isFullscreen_);
	}
	
	/**
	 * @see View#finalize
	 */
	public function finalize():Void {
		_soundContainer.removeMovieClip();

		super.finalize();
	}
	
}