/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
 
import lessrain.lib.utils.scrollers.scrollbar.sliderthumb.ISliderThumb;
import lessrain.lib.utils.scrollers.scrollbar.tray.ITray;

interface lessrain.lib.utils.scrollers.scrollbar.IScrollBarFactory 
{
	public function createSliderThumb():ISliderThumb;
	public function createTray():ITray;
}