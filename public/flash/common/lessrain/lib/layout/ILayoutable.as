import flash.geom.Rectangle;

import lessrain.lib.layout.ILayoutData;
import lessrain.lib.layout.Layout;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.layout.ILayoutHost;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.layout.ILayoutable {
	
	/**
	 * Set target clip. Must be called exactly once!
	 * Instances of <code>ILayoutable</code> use delegation to access their 
	 * visible representations (MovieClips)
	 * 
	 * @param	targetMC_	Target MovieClip
	 */
	public function setTarget(targetMC_:MovieClip):Void;
	
	/**
	 * Get target clip
	 * @return target clip
	 */
	public function getTarget():MovieClip;
	
	/**
	 * Get boundaries of instance
	 * @return	<code>Rectangle</code> representing the boundaries 
	 */
	public function getBoundaries():Rectangle;
	
	/**
	 * Set boundaries (position and size) of the receiver
	 * @param	<code>Rectangle</code> representing the boundaries
	 */
	public function setBoundaries(rect_:Rectangle):Void;
	
	/**
	 * Get layout data that is assigned to the instance
	 * @return	<code>ILayoutData</code> that is assigned to the instance 
	 */
	public function getLayoutData():ILayoutData;
	
	/**
	 * Assign <code>ILayoutData</code> to the instance
	 * @param	layoutData_	Layout data
	 */
	public function setLayoutData(layoutData_:ILayoutData):Void;
	
	/**
	 * Get default size
	 * @return	Default size of the instance
	 */
	public function getDefaultSize():Size;
	
	/**
	 * Set the default size
	 */
	public function setDefaultSize(size_:Size):Void;
	
	/**
	 * Returns the preferred size of the receiver
	 * <p>The preferred size of an item is the size that it would best be displayed at.
	 * The width hint and height hint arguments allow the caller to ask a control 
	 * questions such as "Given a particular width, how high does the item need 
	 * to be to show all of the contents?" To indicate that the caller does not wish 
	 * to constrain a particular dimension, the constant <code>Layout.DEFAULT</code>
	 * is passed for the hint.</p>
	 * 
	 * @param	wHint_	width hint
	 * @param	hHint_	height hint
	 * @return			Preferred size
	 */
	public function computeSize(wHint_:Number, hHint_:Number, flushCache_:Boolean):Rectangle;
	
	/**
	 * Causes the receiver to be resized to its preferred size.
	 * For a composite, this involves computing the preferred size
	 * from its layout, if there is one.
	 *
	 * @see #computeSize
	 */
	public function pack():Void;
	
	/**
	 * Get the <code>ILayoutHost</code> that contains this layoutable item
	 * 
	 * @return	The containing <code>ILayoutHost</code>
	 */
	public function getLayoutHost():ILayoutHost;
	
	/**
	 * Set the <code>ILayoutHost</code> that contains this layoutable item
	 * 
	 * @param	layoutHost_	The containing <code>ILayoutHost</code>
	 */
	public function setLayoutHost(layoutHost_:ILayoutHost):Void;
	
	public function getOrderID():Number;
	
	public function setOrderID(id_:Number):Void;
	
	/**
	 * Clean up
	 */
	public function finalize():Void;
}