import flash.geom.Rectangle;

import lessrain.lib.layout.AbstractLayoutHost;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.graphics.ShapeUtils;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.SampleLayoutHost extends AbstractLayoutHost {
	
	private var _bg:MovieClip;
	
	public function setTarget(targetMC_:MovieClip):Void {
		super.setTarget(targetMC_);

		_bg = getTarget().createEmptyMovieClip("bg", 0);
		ShapeUtils.drawRectangle(_bg, 0, 0, 100, 100, 0xCCCCCC, 20);
	}
	
	public function setBoundaries(rect_:Rectangle):Void {
		super.setBoundaries(rect_);
		
		_bg._xscale = getBoundaries().width;		_bg._yscale = getBoundaries().height;
	}
	
}