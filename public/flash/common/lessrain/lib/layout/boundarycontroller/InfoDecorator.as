import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.BoundaryControllerDecorator;
import lessrain.lib.layout.boundarycontroller.IBoundaryController;
import lessrain.lib.utils.NumberUtils;

/**
 * Create a textfield that displays the current boundary values (position and
 * dimension).
 * 
 * <p><b>Usage:</b>
 * <pre>
 * var ctrl:IBoundaryController = new BoundaryController();
 * ctrl = new InfoDecorator(ctrl); // Display debug info
 * </pre> 
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.boundarycontroller.InfoDecorator extends BoundaryControllerDecorator {
	
	private var _tf:TextField;
	
	/**
	 * Constructor
	 * @param	controller_	Decorated boundary controller
	 */
	public function InfoDecorator(controller_ : IBoundaryController) {
		super(controller_);
	}
	
	/**
	 * @see	BoundaryControllerDecorator#setBoundaries
	 */
	public function setBoundaries(target_:MovieClip, rect_:Rectangle):Void {
		_decoratedController.setBoundaries(target_, rect_);
		
		// lazy creation of textfield
		if(_tf == null) {
			_tf = target_.createTextField("___layoutInfo", target_.getNextHighestDepth(), 2, 2, 100, 50);
		}
		
		var bounds:Rectangle = getBoundaries();
		_tf.text = "(" + NumberUtils.toString(bounds.x, 5) + "," + NumberUtils.toString(bounds.y, 5) + ")";
		_tf.text += "\n";
		_tf.text += NumberUtils.toString(bounds.width, 5) + "x" + NumberUtils.toString(bounds.height, 5);
		_tf.setTextFormat(new TextFormat("_sans", 10, 0x333333));
		_tf.selectable = false;
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		_tf.removeTextField();
		
		super.finalize();
	}

}