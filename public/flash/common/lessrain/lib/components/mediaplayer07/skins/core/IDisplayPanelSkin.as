import lessrain.lib.components.mediaplayer07.display.DisplayPanel;
import lessrain.lib.components.mediaplayer07.skins.core.ISkin;
import lessrain.lib.utils.geom.Size;
/**
 * @author Oliver List (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.IDisplayPanelSkin extends ISkin
{
	/**
	 * Set the underlying display panel
	 * @param	displayPanel_	Display panel
	 */
	public function setDisplayPanel(displayPanel_:DisplayPanel):Void;
	}