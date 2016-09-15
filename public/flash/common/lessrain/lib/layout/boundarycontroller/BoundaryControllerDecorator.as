import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.IBoundaryController;

/**
 * You can combine several controllers to achieve the desired behaviour
 * (Decorator pattern).
 * 
 * <p><b>Usage:</b>
 * <pre>
 * var ctrl:IBoundaryController = new BoundaryController();
 * ctrl = new SimplePositionDecorator(ctrl); // Adjust position when boundaries are set
 * ctrl = new ScrollRectDecorator(ctrl); // Adjust scrollRect when boundaries are set
 * ctrl = new VisibleBoundsDecorator(ctrl); // Draw visible bounds
 * </pre> 
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.BoundaryControllerDecorator implements IBoundaryController { // abstract
	
	private var _decoratedController:IBoundaryController; // protected
	private var _rect:Rectangle;

	/**
	 * Constructor
	 * @param	controller_	Decorated boundary controller
	 */	
	public function BoundaryControllerDecorator(controller_:IBoundaryController) {
		_decoratedController = controller_;
	}
	
	/**
	 * @see IBoundaryController#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void {
		_decoratedController.setBoundaries(target_, rect_);
	}

	/**
	 * @see IBoundaryController#getBoundaries
	 */
	public function getBoundaries() : Rectangle {
		return _decoratedController.getBoundaries();
	}
	
	/**
	 * Clean up
	 */
	public function finalize() : Void {
	}

}