import flash.geom.Rectangle;

import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutHost;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.logger.LogManager;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * Adapted AS version of Eclipse's SWT (org.eclipse.swt.SWT)
 * 
 * Abstract base class for Layouts
 * 
 * @see RowLayout
 * @see FillLayout
 * @see GridLayout
 */
class lessrain.lib.layout.Layout {
	
	public static var DEFAULT:Number = -1;
	
	/**
	 * Style constant for left to right orientation (value is 1&lt;&lt;25).
	 * <p>
	 * When orientation is not explicitly specified, orientation is
	 * inherited.  This means that children will be assigned the
	 * orientation of their parent.  To override this behavior and
	 * force an orientation for a child, explicitly set the orientation
	 * of the child when that child is created.
	 * <br>Note that this is a <em>HINT</em>.
	 * </p>
	 */
	public static var LEFT_TO_RIGHT:Number = 1 << 25;
	
	/**
	 * Style constant for right to left orientation (value is 1&lt;&lt;26).
	 * <p>
	 * When orientation is not explicitly specified, orientation is
	 * inherited.  This means that children will be assigned the
	 * orientation of their parent.  To override this behavior and
	 * force an orientation for a child, explicitly set the orientation
	 * of the child when that child is created.
	 * <br>Note that this is a <em>HINT</em>.
	 * </p>
	 */
	public static var RIGHT_TO_LEFT:Number = 1 << 26;
	
	/**
	 * Style constant for top down orientation (value is 1&lt;&lt;27).
	 */
	public static var TOP_DOWN:Number = 1 << 27;
	
	/**
	 * Style constant for bottom up orientation (value is 1&lt;&lt;28).
	 */
	public static var BOTTOM_UP:Number = 1 << 28;
	
	/**
	 * Style constant for align up behavior (value is 1&lt;&lt;7,
	 * since align UP and align TOP are considered the same).
	 */
	public static var UP:Number = 1 << 7;

	/**
	 * Style constant for align top behavior (value is 1&lt;&lt;7,
	 * since align UP and align TOP are considered the same).
	 */
	public static var TOP:Number = UP;

	/**
	 * Style constant for align down behavior (value is 1&lt;&lt;10,
	 * since align DOWN and align BOTTOM are considered the same).
	 */
	public static var DOWN:Number = 1 << 10;

	/**
	 * Style constant for align bottom behavior (value is 1&lt;&lt;10,
	 * since align DOWN and align BOTTOM are considered the same).
	 */
	public static var BOTTOM:Number = DOWN;

	/**
	 * Style constant for leading alignment (value is 1&lt;&lt;14).
	 */
	public static var LEAD:Number = 1 << 14;
	
	/**
	 * Style constant for align left behavior (value is 1&lt;&lt;14).
	 * This is a synonym for LEAD (value is 1&lt;&lt;14).  Newer
	 * applications should use LEAD instead of LEFT to make code more
	 * understandable on right-to-left platforms.
	 */
	public static var LEFT:Number = LEAD;

	/**
	 * Style constant for trailing alignment (value is 1&lt;&lt;17).
	 */
	public static var TRAIL:Number = 1 << 17;
		
	/**
	 * Style constant for align right behavior (value is 1&lt;&lt;17).
	 * This is a synonym for TRAIL (value is 1&lt;&lt;14).  Newer
	 * applications should use TRAIL instead of RIGHT to make code more
	 * understandable on right-to-left platforms.
	 */
	public static var RIGHT:Number = TRAIL;

	/**
	 * Style constant for align center behavior (value is 1&lt;&lt;24).
	 */
	public static var CENTER:Number = 1 << 24;

	/**
	 * Style constant for horizontal alignment or orientation behavior (value is 1&lt;&lt;8).
	 * <p><b>Used By:</b><ul>
	 * <li><code>FillLayout</code> type</li>
	 * <li><code>RowLayout</code> type</li>
	 * </ul></p>
	 */
	public static var HORIZONTAL:Number = 1 << 8;

	/**
	 * Style constant for vertical alignment or orientation behavior (value is 1&lt;&lt;9).
	 * <p><b>Used By:</b><ul>
	 * <li><code>FillLayout</code> type</li>
	 * <li><code>RowLayout</code> type</li>
	 * </ul></p>
	 */
	public static var VERTICAL:Number = 1 << 9;
	
	/**
	 * Style constant for vertical alignment or orientation behavior (value is 1).
	 * <p><b>Used By:</b><ul>
	 * <li><code>GridLayout</code> type</li>
	 * </ul></p>
	 */
	public static var BEGINNING:Number = 1;
	
	/**
	 * Style constant for vertical alignment or orientation behavior (value is 4).
	 * <p><b>Used By:</b><ul>
	 * <li><code>GridLayout</code> type</li>
	 * </ul></p>
	 */
	public static var FILL:Number = 4;
	
 	// Left-to-right or right-to-left orientation
 	public var horizontalOrientation:Number;
 	
 	// Top-down or bottom-up orientation
 	public var verticalOrientation:Number;
 	
 	
 	/**
 	 * Constructor
 	 * 
 	 * @param	style_	Style bit to control horizontal and vertical orientation.
 	 * 					Style bits can be combined via bitwise-or operators:
 	 * 					<p><code>new Layout(Layout.TOP_DOWN | Layout.RIGHT_TO_LEFT);</code>
 	 */
 	public function Layout(style_:Number) {
		if((style_ & Layout.RIGHT_TO_LEFT) != 0) horizontalOrientation = Layout.RIGHT_TO_LEFT;
		if((style_ & Layout.LEFT_TO_RIGHT) != 0) horizontalOrientation = Layout.LEFT_TO_RIGHT;
		if(horizontalOrientation == null) horizontalOrientation = Layout.LEFT_TO_RIGHT;

		if((style_ & Layout.TOP_DOWN) != 0) verticalOrientation = Layout.TOP_DOWN;
		if((style_ & Layout.BOTTOM_UP) != 0) verticalOrientation = Layout.BOTTOM_UP;
		if(verticalOrientation == null) verticalOrientation = Layout.TOP_DOWN;
 	}
	
	/**
	 * Computes and returns the size of the specified layout host client area 
	 * according to this layout.
	 * 
	 * <p>This method computes the size that the client area of the layout host 
	 * must be in order to position all children at their preferred size inside
	 * according to the layout algorithm encoded by this layout.
	 * 
	 * <p>When a width or height hint is supplied, it is used to constrain the 
	 * result. For example, if a width hint is provided that is less than the 
	 * width of the client area, the layout may choose to wrap and increase 
	 * height, clip, overlap, or otherwise constrain the children.
	 * 
	 * @param	item		A layout host item using this layout
	 * @param	wHint		Width hint (<code>Layout.DEFAULT</code> for preferred width)
	 * @param	hHint		Height hint (<code>Layout.DEFAULT</code> for preferred height)
	 * @param	flushCache	<code>true</code> deletes the cached layout values and forces to re-compute the size
	 * @return				The item's size
	 */
	public function computeSize(item:ILayoutHost, wHint:Number, hHint:Number, flushCache:Boolean):Size {
		LogManager.error("lessrain.lib.layout.Layout: computeSize(ILayoutable) must be implemented in subclass.");
		return null;
	}
	
	/**
	 * Lays out the children of the specified item according to this layout.
	 * 
	 * <p>This method positions and sizes the children of an
	 * <code>ILayoutHost</code> item using the layout algorithm encoded by this 
	 * layout. Children of the item are positioned in the item's client area. 
	 * The position of the composite is not altered by this method.
	 * 
	 * <p>When the flush cache hint is true, the layout is instructed to flush 
	 * any cached values associated with the children. Typically, a layout will 
	 * cache the preferred sizes of the children to avoid the expense of 
	 * computing these values each time the item is laid out.
	 * 
	 * <p>When layout is triggered explicitly by the programmer, the flush cache
	 * hint is <code>true</code>. When layout is triggered by a resize, either 
	 * caused by the programmer or by the user, the hint is <code>false</code>.
	 * 
	 * @param	item_		A layout host using this layout
	 * @param	flushCache_	<code>true</code> deletes the cached layout values 
	 * 						and forces to re-compute the size
	 */
	public function layout(item_:ILayoutHost, flushCache_:Boolean):Void {
		LogManager.error("layout() must be implemented in subclass.");
		return;
	}
	
	/**
	 * Instruct the layout to flush any cached values associated with the item
	 * specified in the argument
	 * 
	 * @param	item_	An <code>ILayoutable</code> item managed by this layout
	 * @return			<code>true</code> if the layout has flushed all cached
	 * 					information associated with the item
	 */
	public function flushCache(item_:ILayoutable):Boolean {
		return false;
	}
	
	private function translateRect(rect_:Rectangle, width_:Number, height_:Number):Rectangle {
		var translated:Rectangle = new Rectangle(0, 0, rect_.width, rect_.height);
		
		translated.x = (horizontalOrientation == Layout.LEFT_TO_RIGHT) ? 
			rect_.x : 
			width_ - (rect_.x + rect_.width);
		translated.y = (verticalOrientation == Layout.TOP_DOWN) ?
			rect_.y :
			height_ - (rect_.y + rect_.height);

		return translated;
	}
}