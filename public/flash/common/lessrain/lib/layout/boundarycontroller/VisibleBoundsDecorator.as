import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.BoundaryControllerDecorator;
import lessrain.lib.layout.boundarycontroller.IBoundaryController;

/**
 * A visible border will be drawn to indicated the boundaries.
 * 
 * <p><b>Usage:</b>
 * <pre>
 * var ctrl:IBoundaryController = new BoundaryController();
 * ctrl = new VisibleBoundsDecorator(ctrl, 2, 0xFF0000, 100); // Draw a red 2px border 
 * </pre> 
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.VisibleBoundsDecorator extends BoundaryControllerDecorator {
	
	/**
	 * Border thickness [px]
	 */
	public var lineThickness:Number = 1;
	
	/**
	 * Border color
	 */
	public var lineColor:Number = 0x666666;
	
	/**
	 * Border alpha
	 */
	public var lineAlpha:Number = 80;
	
	private var _boundTargetMC:MovieClip;
	
	/**
	 * Constructor
	 * @param	controller_		Decorated boundary controller
	 * @param	lineThickness_	Border thickness [px]
	 * @param	lineColor_		Border color
	 * @param	lineAlpha_		Border alpha
	 */
	public function VisibleBoundsDecorator(controller_ : IBoundaryController, lineThickness_:Number, lineColor_:Number, lineAlpha_:Number) {
		super(controller_);
		
		if(lineThickness_) this.lineThickness = lineThickness_;
		if(lineColor_) this.lineColor = lineColor_;
		if(lineAlpha_) this.lineAlpha = lineAlpha_;
	}
	
	/**
	 * @see BoundaryControllerDecorator#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void {
		_decoratedController.setBoundaries(target_, rect_);

		// lazy creation of bound target clip		
		if(_boundTargetMC == null) {
			_boundTargetMC = target_.createEmptyMovieClip("visibleBounds", target_.getNextHighestDepth());
		}

		var bounds:Rectangle = _decoratedController.getBoundaries();
		_boundTargetMC.clear();
		_boundTargetMC.beginFill(lineColor, lineAlpha);
		
		// Don't use ShpaeUtils here, because we don't need a shape with a line
		// outside, but inside the bounding box 
		
		// top line
		_boundTargetMC.moveTo(lineThickness, 0);		_boundTargetMC.lineTo(bounds.width, 0);
		_boundTargetMC.lineTo(bounds.width, lineThickness);
		_boundTargetMC.lineTo(lineThickness, lineThickness);
		
		// right line
		_boundTargetMC.moveTo(bounds.width - lineThickness, lineThickness);
		_boundTargetMC.lineTo(bounds.width, lineThickness);
		_boundTargetMC.lineTo(bounds.width, bounds.height);
		_boundTargetMC.lineTo(bounds.width - lineThickness, bounds.height);
		
		// bottom line
		_boundTargetMC.moveTo(0, bounds.height - lineThickness);
		_boundTargetMC.lineTo(bounds.width - lineThickness, bounds.height - lineThickness);
		_boundTargetMC.lineTo(bounds.width - lineThickness, bounds.height);
		_boundTargetMC.lineTo(0, bounds.height);
		
		// left line
		_boundTargetMC.moveTo(0, 0);
		_boundTargetMC.lineTo(lineThickness, 0);
		_boundTargetMC.lineTo(lineThickness, bounds.height - lineThickness);
		_boundTargetMC.lineTo(0, bounds.height - lineThickness);
				_boundTargetMC.endFill();
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		_boundTargetMC.removeMovieClip();
		
		super.finalize();
	}

}