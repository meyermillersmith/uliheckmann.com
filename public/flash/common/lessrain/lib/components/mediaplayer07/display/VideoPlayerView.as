import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.utils.logger.LogManager;
import net.hiddenresource.util.debug.Debug;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.VideoPlayerView extends View {
	
	/**
	 * View type
	 * @see	View#getType
	 */	
	public static var TYPE:String = "videoPlayerView";

	/**
	 * Linkage ID of the video container clip. There must be a symbol with this
	 * name in the library to make the video player work. The symbol must also
	 * contain a video instance.
	 * @see VideoPlayer#NAME_VIDEO_INSTANCE
	 */	
	public static var VIDEO_CONTAINER_LINKAGE_ID:String = "VideoContainer";
	
	private var _soundContainer:MovieClip;
	private var _videoContainer:MovieClip;
	
	/**
	 * Constructor
	 * @see View
	 */
	public function VideoPlayerView(mediaPlayer_:MediaPlayer) {
		super(mediaPlayer_);
	}
	
	/**
	 * @see View#buildUI
	 */
	public function buildUI(skinFactory_:ISkinFactory):Void
	{
		super.buildUI(skinFactory_);
		
		// Attach sound and video containers
		var target:MovieClip = _displayPanel.getMediaContainer().getTarget();
//		_videoContainer = target.attachMovie(VIDEO_CONTAINER_LINKAGE_ID, "videoContainer_mc", target.getNextHighestDepth());
//		_soundContainer = target.createEmptyMovieClip("soundContainer_mc", target.getNextHighestDepth());		var videoTarget:MovieClip = getDisplayPanel().getMediaContainer().getMasterMC();
		_videoContainer = videoTarget.attachMovie(VIDEO_CONTAINER_LINKAGE_ID, "videoContainer_mc", videoTarget.getNextHighestDepth());		_soundContainer = videoTarget.createEmptyMovieClip("soundContainer_mc", videoTarget.getNextHighestDepth());
	}
	
	/**
	 * Get sound container clip
	 * @return sound container clip
	 */
	public function getSoundContainer():MovieClip {
		return _soundContainer;
	}
	
	/**
	 * Get video container clip
	 * @return video container clip
	 */
	public function getVideoContainer():MovieClip {
		return _videoContainer;
	}
	
	/**
	 * @see View#resize
	 */
	public function resize():Void {
		super.resize();
		
		var file:DataFile = getModel().getMedia().getMaster();
		var scale:Number = processResizeScale(file.w, file.h);
		
		// scale the video		_videoContainer._width = file.w * scale;
		_videoContainer._height = file.h * scale;
		
		// center the video
		var bounds:Rectangle = _displayPanel.getMediaContainer().getBoundaries();		_videoContainer._x = Math.floor((bounds.width - _videoContainer._width) / 2);
		_videoContainer._y = Math.floor((bounds.height - _videoContainer._height) / 2);
	}
	
	/**
	 * @see View#getType
	 */
	public function getType():String {
		return TYPE;
	}
	
	/**
	 * @see View#finalize
	 */
	public function finalize():Void {
		_soundContainer.removeMovieClip();
		_videoContainer.removeMovieClip();

		super.finalize();
	}
	
}