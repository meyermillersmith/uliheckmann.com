import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.IBoundaryController;

/**
 * Basic boundary controller that doesn't apply any visible changes on the
 * layoutable item but simply stores the boundary property <code>_rect</code>
 * 
 * <p>BoundaryController is the basis to create any custom boundary controller,
 * such as visible boundaries, tweened  boundaries, masked boundaries etc.
 * 
 * @see BoundaryControllerDecorator
 * @see SimplePositionDecorator
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.BoundaryController implements IBoundaryController {
	
	private var _rect:Rectangle;
	
	/**
	 * @see IBoundaryController#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void {
		_rect = rect_;
	}

	/**
	 * @see IBoundaryController#getBoundaries
	 */
	public function getBoundaries() : Rectangle {
		return _rect;
	}
	
	/**
	 * Clean up
	 */
	public function finalize() : Void {
	}

}