import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.BoundaryControllerDecorator;
import lessrain.lib.layout.boundarycontroller.IBoundaryController;

/**
 * Add the scrollRect property to the ILayoutable target clip to mask the
 * content according to the boundary dimensions.
 * 
 * <p><b>Usage:</b>
 * <pre>
 * var ctrl:IBoundaryController = new BoundaryController();
 * ctrl = new ScrollRectDecorator(ctrl);
 * </pre> 
 * 
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.ScrollRectDecorator extends BoundaryControllerDecorator {
	
	/**
	 * Constructor
	 * @param	controller_	Decorated boundary controller 
	 */
	public function ScrollRectDecorator(controller_ : IBoundaryController) {
		super(controller_);
	}
	
	/**
	 * @see BoundaryControllerDecorator#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void {
		_decoratedController.setBoundaries(target_, rect_);

		var bounds:Rectangle = _decoratedController.getBoundaries();
		target_.scrollRect = new Rectangle(0, 0, bounds.width, bounds.height);
	}
}