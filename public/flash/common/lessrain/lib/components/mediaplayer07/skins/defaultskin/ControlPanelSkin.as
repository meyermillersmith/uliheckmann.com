/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
 
import lessrain.lib.components.mediaplayer07.controls.ControlPanel;
import lessrain.lib.components.mediaplayer07.skins.core.IControlPanelSkin;
import lessrain.lib.utils.geom.Size;

class lessrain.lib.components.mediaplayer07.skins.defaultskin.ControlPanelSkin implements IControlPanelSkin
{
	private var _controlPanel : ControlPanel;
	private var _backgroundShape : MovieClip;
	
	/**
	 * Constructor
	 */
	public function ControlPanelSkin()
	{
	}

	public function resize(w_:Number, h_:Number) :Void
	{
		_backgroundShape._width = w_;		_backgroundShape._height = h_;
	}
	
	public function getSize() : Size {
		var s:Size = new Size(_controlPanel.getTarget()._width, _controlPanel.getTarget()._height);
		return s; 
	}

	public function buildSkin() : Void {
		_backgroundShape = _controlPanel.getTarget().attachMovie("ControlPanelIllu", "backgroundShape", _controlPanel.getTarget().getNextHighestDepth());	}

	public function setControlPanel(controlPanel_ : ControlPanel) :Void {
		_controlPanel = controlPanel_;
	}

	public function finalize() :Void {}

}