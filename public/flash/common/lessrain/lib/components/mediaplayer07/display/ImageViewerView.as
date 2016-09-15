import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.components.mediaplayer07.display.ImageContainer;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.ImageViewerView extends View {
	
	/**
	 * View type
	 * @see	View#getType
	 */	
	public static var TYPE:String = "imageViewerView";

	private var _imageContainer:ImageContainer;
		
	public function ImageViewerView(mediaPlayer_:MediaPlayer) {
		super(mediaPlayer_);
	}
	
	/**
	 * @see View#buildUI
	 */
	public function buildUI(skinFactory_:ISkinFactory):Void
	{
		super.buildUI(skinFactory_);
		
		// Attach image container
		var target:MovieClip = _displayPanel.getMediaContainer().getTarget();
		_imageContainer = new ImageContainer(
			target.createEmptyMovieClip("imageContainer_mc", target.getNextHighestDepth())
		);
	}
	
	/**
	 * Get image container clip
	 * @return	image container clip
	 */
	public function getImageContainer():ImageContainer {
		return _imageContainer;
	}
	
	/**
	 * @see View#resize
	 */
	public function resize():Void {
		super.resize();
		
		var file:DataFile = getModel().getMedia().getMaster();
		var scale:Number = processResizeScale(file.w, file.h);
		
		// scale the image
		_imageContainer.scale(scale);
		
		// center the image
		var bounds:Rectangle = _displayPanel.getMediaContainer().getBoundaries();
		_imageContainer.targetMC._x = Math.floor((bounds.width - file.w * scale) / 2);
		_imageContainer.targetMC._y = Math.floor((bounds.height - file.h * scale) / 2);
	}
	
	/**
	 * @see View#getType
	 */
	public function getType():String {
		return TYPE;
	}
	
	public function finalize():Void {
		_imageContainer.finalize();
		_imageContainer = null;

		super.finalize();
	}

}