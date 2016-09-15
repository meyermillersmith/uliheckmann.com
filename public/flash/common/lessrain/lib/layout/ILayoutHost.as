import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.Layout;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.layout.ILayoutHost extends ILayoutable {
	
	/**
	 * Get layout manager
	 * @return layout manager
	 */
	public function getLayout():Layout;
	
	/**
	 * Assign layout manager
	 * @param	layout_	Layout manager	
	 */
	public function setLayout(layout_:Layout):Void;
	
	/**
	 * Perform layout of all children
	 */
	public function layout():Void;
	
	/**
	 * Add child to host
	 * @param	child_	<code>ILayoutable</code> child
	 * @return			Added child
	 */
	public function addChild(child_:ILayoutable):ILayoutable;
	
	/**
	 * Remove a child from the host
	 * @param	child_	<code>ILayoutable</code> child
	 * @return			Removed child
	 */
	public function removeChild(child_:ILayoutable):ILayoutable;
	
	/**
	 * Get array of children
	 * @return	Array of children
	 */
	public function getChildren():Array;
	
	/**
	 * Get the children container clip
	 * @return	Children container clip
	 */
	public function getChildrenContainer():MovieClip;
}