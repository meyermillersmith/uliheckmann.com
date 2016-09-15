import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.BoundaryControllerDecorator;
import lessrain.lib.layout.boundarycontroller.IBoundaryController;

/**
 * Update the position of an ILayoutable item when the boundaries are set. This
 * class implements the basic position behaviour and simply updates the target's
 * _x and _y values.
 * 
 * <p><b>Usage:</b>
 * <pre>
 * var ctrl:IBoundaryController = new BoundaryController();
 * ctrl = new SimplePositionDecorator(ctrl);
 * </pre> 
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.SimplePositionDecorator extends BoundaryControllerDecorator {
	
	/**
	 * Constructor
	 * @param	controller_	Decorated boundary controller
	 */
	public function SimplePositionDecorator(controller_ : IBoundaryController) {
		super(controller_);
	}
	
	/**
	 * @see BoundaryControllerDecorator#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void {
		_decoratedController.setBoundaries(target_, rect_);
		
		target_._x = Math.round(rect_.x);
		target_._y = Math.round(rect_.y);
	}
}