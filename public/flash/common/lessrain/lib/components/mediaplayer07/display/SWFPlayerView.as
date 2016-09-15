import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.SWFPlayerView extends View {
	
	/**
	 * View type
	 * @see	View#getType
	 */	
	public static var TYPE:String = "swfPlayerView";
	
	private var _swfContainer:MovieClip;
	
	/**
	 * Constructor
	 * @see View
	 */
	public function SWFPlayerView(mediaPlayer_:MediaPlayer) {
		super(mediaPlayer_);
	}
	
	/**
	 * @see View#buildUI
	 */
	public function buildUI(skinFactory_:ISkinFactory):Void {
		super.buildUI(skinFactory_);
		
		// Attach swf container
		var target:MovieClip = _displayPanel.getMediaContainer().getTarget();
		_swfContainer = target.createEmptyMovieClip("swfContainer_mc", target.getNextHighestDepth());
	}
	
	/**
	 * Get SWF container clip
	 * @return SWF container clip
	 */
	public function getSWFContainer():MovieClip {
		return _swfContainer;
	}
	
	/**
	 * @see View#resize
	 */
	public function resize():Void {
		super.resize();
		
		var file:DataFile = getModel().getMedia().getMaster();
		var scale:Number = processResizeScale(file.w, file.h);
		
		// scale the movie
		_swfContainer._xscale = scale * 100;
		_swfContainer._yscale = scale * 100;
		
		// center the movie
		var bounds:Rectangle = _displayPanel.getMediaContainer().getBoundaries();
		_swfContainer._x = Math.floor((bounds.width - file.w * scale) / 2);
		_swfContainer._y = Math.floor((bounds.height - file.h * scale) / 2);
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
		_swfContainer.removeMovieClip();

		super.finalize();
	}
	
}