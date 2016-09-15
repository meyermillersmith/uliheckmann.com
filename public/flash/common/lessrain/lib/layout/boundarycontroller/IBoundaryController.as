import flash.geom.Rectangle;
/**
 * IBoundaryController instances let you customize how ILayoutable items behave
 * when <code>setBoundaries()</code> is called. You can simply change size and 
 * position or start a tween when <code>setBoundaries()</code> is called. 
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.layout.boundarycontroller.IBoundaryController {
	
	/**
	 * @param	target_	Target MC 
	 * @see				lessrain.lib.layout.ILayoutable#setBoundaries
	 */
	public function setBoundaries(target_ : MovieClip, rect_ : Rectangle) : Void;
	
	/**
	 * @see	lessrain.lib.layout.ILayoutable#getBoundaries
	 */
	public function getBoundaries() : Rectangle;
	
	/**
	 * Clean up
	 */
	public function finalize() : Void;
}