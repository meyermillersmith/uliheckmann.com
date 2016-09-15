import lessrain.lib.components.mediaplayer07.controls.ControlPanel;
import lessrain.lib.components.mediaplayer07.skins.core.ISkin;
import lessrain.lib.utils.geom.Size;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.IControlPanelSkin extends ISkin {
	
	/**
	 * Set the underlying control panel
	 * @param	controlPanel_	Control panel
	 */
	public function setControlPanel(controlPanel_:ControlPanel) :Void;
}