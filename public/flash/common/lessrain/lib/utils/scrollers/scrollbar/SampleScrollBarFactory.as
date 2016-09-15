/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */

import lessrain.lib.utils.scrollers.scrollbar.IScrollBarFactory;
import lessrain.lib.utils.scrollers.scrollbar.sliderthumb.ISliderThumb;
import lessrain.lib.utils.scrollers.scrollbar.sliderthumb.sample.SimpleSliderThumb;
import lessrain.lib.utils.scrollers.scrollbar.tray.ITray;
import lessrain.lib.utils.scrollers.scrollbar.tray.sample.SimpleTray;

class lessrain.lib.utils.scrollers.scrollbar.SampleScrollBarFactory implements IScrollBarFactory 
{
	
	public function createSliderThumb() : ISliderThumb 
	{
		return new SimpleSliderThumb();
	}

	public function createTray() : ITray 
	{
		return new SimpleTray();
	}

}