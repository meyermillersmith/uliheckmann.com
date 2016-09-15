/**
 * @author Torsten Härtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.display.MediaContainer;
import lessrain.lib.components.mediaplayer07.display.MediaPlayerLayoutHost;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.skins.core.IDisplayPanelSkin;
import lessrain.lib.layout.FillLayout;
import lessrain.lib.layout.Layout;

import flash.geom.Rectangle;

class lessrain.lib.components.mediaplayer07.display.DisplayPanel extends MediaPlayerLayoutHost {
	/*
	 * Getter & setter
	 */
	private var _view : View;
	private var _skin : IDisplayPanelSkin;
	
	/*
	 * Elements
	 */
	private var _currentMedia : Media;
	private var _mediaContainer : MediaContainer;
	
	/**
	 * Constructor
	 * @param	skin_	Display panel skin
	 */
	public function DisplayPanel(skin_ : IDisplayPanelSkin, view_ : View)
	{
		_skin = skin_;
		_skin.setDisplayPanel(this);

		_view = view_;
		_view.setDisplayPanel(this);
	}
	
	/**
	 * As soon as the target clip is set, build the skin
	 * @see ILayouable#setTarget
	 */
	public function setTarget(targetMC_ : MovieClip) : Void {
		super.setTarget(targetMC_);

		_skin.buildSkin();
//		_contentHost = getTarget().createEmptyMovieClip("contentHost_mc", getTarget().getNextHighestDepth());
		_mediaContainer = MediaContainer(addChild(new MediaContainer(this)));

//		startMouseListener();
	}

	public function layout() : Void {
		if(getLayout() == null) {
			setLayout(new FillLayout(Layout.VERTICAL));
		}
		getLayout().layout(this);
	}
	
	/**
	 * Clean up
	 */
	public function finalize() : Void {
		_skin.finalize();
		_targetMC.removeMovieClip();

		super.finalize();
	}
	
	/**
	 * Tell skin to adjust to new size
	 * @see	ILayoutable#setBoundaries
	 */
	public function setBoundaries(rect_ : Rectangle) : Void {
		super.setBoundaries(rect_);

		var bounds : Rectangle = getBoundaries();
		_skin.resize(bounds.width, bounds.height);
	}
	
	/**
	 * The media container is the clip that contains the visual media
	 * (image, video, flash file)
	 * @return	Media container clip
	 */
	public function getMediaContainer() : MediaContainer {
		return _mediaContainer;
	}
}