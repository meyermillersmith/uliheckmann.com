/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */

import lessrain.lib.components.mediaplayer07.display.DisplayPanel;
import lessrain.lib.components.mediaplayer07.skins.core.IDisplayPanelSkin;
import lessrain.lib.utils.geom.Size;

class lessrain.lib.components.mediaplayer07.skins.defaultskin.DisplayPanelSkin implements IDisplayPanelSkin
{
	private var _backgroundShape	: MovieClip;
	private var _display 			: DisplayPanel;
	
	public function DisplayPanelSkin()
	{
	}

	public function finalize() : Void {
	}

	public function getSize() : Size {
		return new Size(_backgroundShape._width, _backgroundShape._height);
	}

	public function resize(w_ : Number, h_ : Number) : Void {
		_backgroundShape._width = w_;
		_backgroundShape._height = h_;
	}

	public function buildSkin() : Void {
		var targetMC:MovieClip = _display.getTarget();
		_backgroundShape = targetMC.attachMovie("DisplayPanelIllu", "backgroundShape", targetMC.getNextHighestDepth());
	}

	public function setDisplayPanel(displayPanel_ : DisplayPanel) : Void {
		_display = displayPanel_;
	}
	
}