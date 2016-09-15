import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.BoundaryControllerDecorator;
import lessrain.lib.layout.boundarycontroller.IBoundaryController;
import lessrain.lib.utils.animation.easing.Quad;
import lessrain.lib.utils.tween.AbstractTween;
import lessrain.lib.utils.tween.TweenFrame;

/**
 * When the ILayoutable boundaries are set, the position is updated via tween.
 * 
 * <p><b>Usage:</b>
 * <pre>
 * var tween:AbstractTween = new TweenFrame();
 * tween.easingFunction = Sine.easeIn;
 * tween.duration = 400;
 * var ctrl:IBoundaryController = new BoundaryController();
 * ctrl = new PositionTweenDecorator(ctrl, tween);
 * </pre> 
 * 
 * @see SimplePositionDecorator
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.PositionTweenDecorator extends BoundaryControllerDecorator {
	
	private var _tween:AbstractTween;
	private var _initialBoundariesSet:Boolean; // do not tween when setBoundaries is called for the first time 
	
	/**
	 * Constructor
	 * @param	controller_	Decorated boundary controller
	 * @param	tween_		Custom tween. If omitted, a default tween will be
	 * 						generated
	 */
	public function PositionTweenDecorator(controller_ : IBoundaryController, tween_:AbstractTween) {
		super(controller_);
		
		if(tween_) {
			_tween = tween_;
		} else {
			_tween = new TweenFrame();
			_tween.easingFunction = Quad.easeInOut;
			_tween.tweenDuration = 300;
		}
		
		_initialBoundariesSet = false;
	}
	
	/**
	 * @see IBoundaryController#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void {
		_decoratedController.setBoundaries(target_, rect_);
				
		if(!_initialBoundariesSet) {
			target_._x = Math.round(rect_.x);
			target_._y = Math.round(rect_.y);
			_initialBoundariesSet = true;
		} else {
			startTween(target_, rect_);
		}
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		_tween.destroy();
		
		super.finalize();
	}
	
	private function startTween(target_:MovieClip, rect_:Rectangle):Void {
		_tween.reset();
		_tween.tweenTarget = target_;
		_tween.setTweenProperty("_x", target_._x, Math.round(rect_.x));
		_tween.setTweenProperty("_y", target_._y, Math.round(rect_.y));
		_tween.start();
	}

}