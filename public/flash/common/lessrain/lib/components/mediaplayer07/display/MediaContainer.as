import lessrain.lib.components.mediaplayer07.display.DisplayPanel;
import lessrain.lib.layout.AbstractLayoutable;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.MediaContainer extends AbstractLayoutable {
	
	private var _masterContainer:MovieClip;
	private var _previewContainer:MovieClip;

	public function MediaContainer(displayPanel_ : DisplayPanel) {
		super();

//		boundsVisible = true;
	}
	
	public function setTarget(target_:MovieClip):Void {
		super.setTarget(target_);
		
		_masterContainer = getTarget().createEmptyMovieClip("masterMC", getTarget().getNextHighestDepth());		_previewContainer = getTarget().createEmptyMovieClip("previewMC", getTarget().getNextHighestDepth());
	}
	
	public function getMasterMC():MovieClip {
		return _masterContainer;
	}
	
	public function getPreviewMC():MovieClip {
		return _previewContainer;
	}
}