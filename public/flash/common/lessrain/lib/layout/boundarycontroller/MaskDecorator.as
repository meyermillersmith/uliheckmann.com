import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.BoundaryControllerDecorator;
import lessrain.lib.layout.boundarycontroller.IBoundaryController;
import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.logger.LogManager;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.MaskDecorator extends BoundaryControllerDecorator {
	
	private var _mask:MovieClip;
	private var _maskTarget:MovieClip;
	
	public function MaskDecorator(controller_ : IBoundaryController, maskTarget_:MovieClip) {
		super(controller_);
		
		_maskTarget = maskTarget_;
	}
	
	/**
	 * @see IBoundaryController#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void {
		_decoratedController.setBoundaries(target_, rect_);

		if(_mask == null) {
			_mask = _maskTarget.createEmptyMovieClip("mask_" + getTimer(), _maskTarget.getNextHighestDepth());
			ShapeUtils.drawRectangle(_mask, 0, 0, 100, 100, 0xFF0000, 60);
			target_.setMask(_mask);
		}
		
		var bounds:Rectangle = _decoratedController.getBoundaries();
		_mask._x = bounds.x;
		_mask._y = bounds.y;
		_mask._xscale = bounds.width;
		_mask._yscale = bounds.height;
	}

}