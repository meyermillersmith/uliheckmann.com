import flash.geom.Rectangle;

import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutData;
import lessrain.lib.layout.Layout;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.layout.GridData implements ILayoutData {
	
	/**
	 * verticalAlignment specifies how controls will be positioned 
	 * vertically within a cell. 
	 *
	 * The default value is Layout.CENTER.
	 *
	 * Possible values are: <ul>
	 *    <li>Layout.BEGINNING (or Layout.TOP): Position the control at the top of the cell</li>
	 *    <li>Layout.CENTER: Position the control in the vertical center of the cell</li>
	 *    <li>Layout.END (or Layout.BOTTOM): Position the control at the bottom of the cell</li>
	 *    <li>Layout.FILL: Resize the control to fill the cell vertically</li>
	 * </ul>
	 */
	public var verticalAlignment:Number = Layout.CENTER;
	
	/**
	 * horizontalAlignment specifies how controls will be positioned 
	 * horizontally within a cell. 
	 *
	 * The default value is BEGINNING.
	 *
	 * Possible values are: <ul>
	 *    <li>Layout.BEGINNING (or Layout.LEFT): Position the control at the left of the cell</li>
	 *    <li>Layout.CENTER: Position the control in the horizontal center of the cell</li>
	 *    <li>Layout.END (or Layout.RIGHT): Position the control at the right of the cell</li>
	 *    <li>Layout.FILL: Resize the control to fill the cell horizontally</li>
	 * </ul>
	 */
	public var horizontalAlignment:Number = Layout.BEGINNING;
	
	/**
	 * widthHint specifies the preferred width in pixels. This value
	 * is the wHint passed into ILayoutable.computeSize() 
	 * to determine the preferred size of the control.
	 *
	 * The default value is Layout.DEFAULT.
	 * 
	 * @see ILayoutable.computeSize
	 */
	public var widthHint:Number = Layout.DEFAULT;
	
	/**
	 * heightHint specifies the preferred height in pixels. This value
	 * is the hHint passed into ILayoutable.computeSize()
	 * to determine the preferred size of the control.
	 *
	 * The default value is Layout.DEFAULT.
	 * 
	 * @see ILayoutable.computeSize
	 */
	public var heightHint:Number = Layout.DEFAULT;
	
	/**
	 * horizontalIndent specifies the number of pixels of indentation
	 * that will be placed along the left side of the cell.
	 *
	 * The default value is 0.
	 */
	public var horizontalIndent:Number = 0;
	
	/**
	 * verticalIndent specifies the number of pixels of indentation
	 * that will be placed along the top side of the cell.
	 *
	 * The default value is 0.
	 */
	public var verticalIndent:Number = 0;
	
	/**
	 * horizontalSpan specifies the number of column cells that the control
	 * will take up.
	 *
	 * The default value is 1.
	 */
	public var horizontalSpan:Number = 1;
	
	/**
	 * verticalSpan specifies the number of row cells that the control
	 * will take up.
	 *
	 * The default value is 1.
	 */
	public var verticalSpan:Number = 1;
	
	/**
	 * <p>grabExcessHorizontalSpace specifies whether the width of the cell 
	 * changes depending on the size of the host. If 
	 * grabExcessHorizontalSpace is <code>true</code>, the following rules
	 * apply to the width of the cell:</p>
	 * <ul>
	 * <li>If extra horizontal space is available in the parent, the cell will 
	 * grow to be wider than its preferred width.  The new width 
	 * will be "preferred width + delta" where delta is the extra 
	 * horizontal space divided by the number of grabbing columns.</li>
	 * <li>If there is not enough horizontal space available in the parent, the 
	 * cell will shrink until it reaches its minimum width as specified by 
	 * GridData.minimumWidth. The new width will be the maximum of 
	 * "minimumWidth" and "preferred width - delta", where delta is 
	 * the amount of space missing divided by the number of grabbing columns.</li>
	 * <li>If the parent is packed, the cell will be its preferred width 
	 * as specified by GridData.widthHint.</li>
	 * <li>If the item spans multiple columns and there are no other grabbing 
	 * controls in any of the spanned columns, the last column in the span will
	 * grab the extra space.  If there is at least one other grabbing item
	 * in the span, the grabbing will be spread over the columns already 
	 * marked as grabExcessHorizontalSpace.</li>
	 * </ul>
	 * 
	 * <p>The default value is false.</p>
	 * 
	 * @see GridData#minimumWidth
	 * @see GridData#widthHint
	 */	
	public var grabExcessHorizontalSpace:Boolean = false;
	
	/**
	 * <p>grabExcessVerticalSpace specifies whether the height of the cell 
	 * changes depending on the size of the parent. If 
	 * grabExcessVerticalSpace is <code>true</code>, the following rules
	 * apply to the height of the cell:</p>
	 * <ul>
	 * <li>If extra vertical space is available in the parent, the cell will 
	 * grow to be taller than its preferred height.  The new height 
	 * will be "preferred height + delta" where delta is the extra 
	 * vertical space divided by the number of grabbing rows.</li>
	 * <li>If there is not enough vertical space available in the parent, the 
	 * cell will shrink until it reaches its minimum height as specified by 
	 * GridData.minimumHeight. The new height will be the maximum of 
	 * "minimumHeight" and "preferred height - delta", where delta is 
	 * the amount of space missing divided by the number of grabbing rows.</li>
	 * <li>If the parent is packed, the cell will be its preferred height 
	 * as specified by GridData.heightHint.</li>
	 * <li>If the item spans multiple rows and there are no other grabbing 
	 * controls in any of the spanned rows, the last row in the span will
	 * grab the extra space.  If there is at least one other grabbing item
	 * in the span, the grabbing will be spread over the rows already 
	 * marked as grabExcessVerticalSpace.</li>
	 * </ul>
	 * 
	 * <p>The default value is false.</p>
	 * 
	 * @see GridData#minimumHeight
	 * @see GridData#heightHint
	 */	
	public var grabExcessVerticalSpace:Boolean = false;

	/**
	 * minimumWidth specifies the minimum width in pixels. This value
	 * applies only if grabExcessHorizontalSpace is true. A value of 
	 * Layout.DEFAULT means that the minimum width will be the result
	 * of ILayoutable.computeSize() where wHint is 
	 * determined by GridData.widthHint.
	 *
	 * The default value is 0.
	 *
	 * @see ILayoutable#computeSize
	 * @see GridData#widthHint
	 */
	public var minimumWidth:Number = 0;
	
	/**
	 * minimumHeight specifies the minimum height in pixels.  This value
	 * applies only if grabExcessVerticalSpace is true. A value of 
	 * Layout.DEFAULT means that the minimum height will be the result
	 * of ILayoutable.computeSize() where hHint is 
	 * determined by GridData.heightHint.
	 *
	 * The default value is 0.
	 *
	 * @see Control#computeSize
	 * @see GridData#heightHint
	 */
	public var minimumHeight:Number = 0;
	
	/**
	 * exclude informs the layout to ignore this control when sizing
	 * and positioning items.  If this value is <code>true</code>,
	 * the size and position of the item will not be managed by the
	 * layout. If this	value is <code>false</code>, the size and 
	 * position of the control will be computed and assigned.
	 * 
	 * The default value is <code>false</code>.
	 */
	public var exclude:Boolean = false;
	
	/**
	 * Value for horizontalAlignment or verticalAlignment.
	 * Position the item at the top or left of the cell.
	 */
	public static var BEGINNING:Number = Layout.BEGINNING;
	
	/**
	 * Value for horizontalAlignment or verticalAlignment.
	 * Position the item in the vertical or horizontal center of the cell
	 */
	public static var CENTER:Number = 2;
	
	/**
	 * Value for horizontalAlignment or verticalAlignment.
	 * Position the item at the bottom or right of the cell
	 */
	public static var END:Number = 3;
	
	/**
	 * Value for horizontalAlignment or verticalAlignment.
	 * Resize the item to fill the cell horizontally or vertically.
	 */
	public static var FILL:Number = Layout.FILL;

	/**
	 * Style bit for <code>new GridData()</code>.
	 * Position the item at the top of the cell.
	 */
	public static var VERTICAL_ALIGN_BEGINNING:Number =  1 << 1;
	
	/**
	 * Style bit for <code>new GridData()</code> to position the 
	 * item in the vertical center of the cell.
	 */
	public static var VERTICAL_ALIGN_CENTER:Number = 1 << 2;
	
	/**
	 * Style bit for <code>new GridData()</code> to position the 
	 * item at the bottom of the cell.
	 */
	public static var VERTICAL_ALIGN_END:Number = 1 << 3;
	
	/**
	 * Style bit for <code>new GridData()</code> to resize the 
	 * item to fill the cell vertically.
	 */
	public static var VERTICAL_ALIGN_FILL:Number = 1 << 4;
	
	/**
	 * Style bit for <code>new GridData()</code> to position the 
	 * item at the left of the cell.
	 */
	public static var HORIZONTAL_ALIGN_BEGINNING:Number =  1 << 5;
	
	/**
	 * Style bit for <code>new GridData()</code> to position the 
	 * item in the horizontal center of the cell.
	 */
	public static var HORIZONTAL_ALIGN_CENTER:Number = 1 << 6;
	
	/**
	 * Style bit for <code>new GridData()</code> to position the 
	 * item at the right of the cell.
	 */
	public static var HORIZONTAL_ALIGN_END:Number = 1 << 7;
	
	/**
	 * Style bit for <code>new GridData()</code> to resize the 
	 * item to fill the cell horizontally.
	 */
	public static var HORIZONTAL_ALIGN_FILL:Number = 1 << 8;
	
	/**
	 * Style bit for <code>new GridData()</code> to resize the 
	 * item to fit the remaining horizontal space.
	 */
	public static var GRAB_HORIZONTAL:Number = 1 << 9;
	
	/**
	 * Style bit for <code>new GridData()</code> to resize the 
	 * item to fit the remaining vertical space.
	 */
	public static var GRAB_VERTICAL:Number = 1 << 10;
	
	/**
	 * Style bit for <code>new GridData()</code> to resize the 
	 * item to fill the cell vertically and to fit the remaining
	 * vertical space.
	 * FILL_VERTICAL = VERTICAL_ALIGN_FILL | GRAB_VERTICAL
	 */	
	public static var FILL_VERTICAL:Number = VERTICAL_ALIGN_FILL | GRAB_VERTICAL;
	
	/**
	 * Style bit for <code>new GridData()</code> to resize the 
	 * item to fill the cell horizontally and to fit the remaining
	 * horizontal space.
	 * FILL_HORIZONTAL = HORIZONTAL_ALIGN_FILL | GRAB_HORIZONTAL
	 */	
	public static var FILL_HORIZONTAL:Number = HORIZONTAL_ALIGN_FILL | GRAB_HORIZONTAL;
	
	/**
	 * Style bit for <code>new GridData()</code> to resize the 
	 * item to fill the cell horizontally and vertically and 
	 * to fit the remaining horizontal and vertical space.
	 * FILL_BOTH = FILL_VERTICAL | FILL_HORIZONTAL
	 */	
	public static var FILL_BOTH:Number = FILL_VERTICAL | FILL_HORIZONTAL;

	public var cacheWidth:Number = -1;
	public var cacheHeight:Number = -1;
	public var logEnabled:Boolean = false;
	
	private var defaultWhint:Number;
	private var defaultHhint:Number;
	private var defaultWidth:Number = -1;
	private var defaultHeight:Number = -1;
	private var currentWhint:Number;
	private var currentHhint:Number;
	private var currentWidth:Number = -1;
	private var currentHeight:Number = -1;

	/**
	 * Constructs a new instance based on the GridData style.
	 * This constructor is not recommended.
	 * 
	 * @param style the GridData style
	 */
	public function GridData (style:Number) {
		super ();
		if ((style & VERTICAL_ALIGN_BEGINNING) != 0) verticalAlignment = BEGINNING;
		if ((style & VERTICAL_ALIGN_CENTER) != 0) verticalAlignment = CENTER;
		if ((style & VERTICAL_ALIGN_FILL) != 0) verticalAlignment = FILL;
		if ((style & VERTICAL_ALIGN_END) != 0) verticalAlignment = END;
		if ((style & HORIZONTAL_ALIGN_BEGINNING) != 0) horizontalAlignment = BEGINNING;
		if ((style & HORIZONTAL_ALIGN_CENTER) != 0) horizontalAlignment = CENTER;
		if ((style & HORIZONTAL_ALIGN_FILL) != 0) horizontalAlignment = FILL;
		if ((style & HORIZONTAL_ALIGN_END) != 0) horizontalAlignment = END;
		grabExcessHorizontalSpace = (style & GRAB_HORIZONTAL) != 0;
		grabExcessVerticalSpace = (style & GRAB_VERTICAL) != 0;
	}
	
	function computeSize(item_:ILayoutable, wHint_:Number, hHint_:Number, flushCache_:Boolean):Void {
		if (cacheWidth != -1 && cacheHeight != -1) {
			return;
		}
		if (wHint_ == this.widthHint && hHint_ == this.heightHint) {
			if (defaultWidth == -1 || defaultHeight == -1 || wHint_ != defaultWhint || hHint_ != defaultHhint) {
				var size:Rectangle = item_.computeSize (wHint_, hHint_, flushCache_);
				defaultWhint = wHint_;
				defaultHhint = hHint_;
				defaultWidth = size.width;
				defaultHeight = size.height;
			}
			cacheWidth = defaultWidth;
			cacheHeight = defaultHeight;
			return;
		}
		if (currentWidth == -1 || currentHeight == -1 || wHint_ != currentWhint || hHint_ != currentHhint) {
			var size:Rectangle = item_.computeSize (wHint_, hHint_, flushCache_);
			currentWhint = wHint_;
			currentHhint = hHint_;
			currentWidth = size.width;
			currentHeight = size.height;
		}
		cacheWidth = currentWidth;
		cacheHeight = currentHeight;
	}
	
	public function flushCache():Void {
		cacheWidth = cacheHeight = -1;
		defaultWidth = defaultHeight = -1;
		currentWidth = currentHeight = -1;
	}
	
	/**
	 * Returns a string containing a concise, human-readable
	 * description of the receiver.
	 *
	 * @return a string representation of the GridData object
	 */
	public function toString ():String {
		var hAlign:String = "";
		switch (horizontalAlignment) {
			case Layout.FILL: hAlign = "Layout.FILL"; break;
			case Layout.BEGINNING: hAlign = "Layout.BEGINNING"; break;
			case Layout.LEFT: hAlign = "Layout.LEFT"; break;
			case END: hAlign = "GridData.END"; break;
			case Layout.RIGHT: hAlign = "Layout.RIGHT"; break;
			case Layout.CENTER: hAlign = "Layout.CENTER"; break;
			case CENTER: hAlign = "GridData.CENTER"; break;
			default: hAlign = "Undefined "+horizontalAlignment; break;
		}
		var vAlign:String = "";
		switch (verticalAlignment) {
			case Layout.FILL: vAlign = "Layout.FILL"; break;
			case Layout.BEGINNING: vAlign = "Layout.BEGINNING"; break;
			case Layout.TOP: vAlign = "Layout.TOP"; break;
			case END: vAlign = "GridData.END"; break;
			case Layout.BOTTOM: vAlign = "Layout.BOTTOM"; break;
			case Layout.CENTER: vAlign = "Layout.CENTER"; break;
			case CENTER: vAlign = "GridData.CENTER"; break;
			default: vAlign = "Undefined "+verticalAlignment; break;
		}
	 	var string:String = "GridData {";
	 	string += "horizontalAlignment="+hAlign+" ";
	 	if (horizontalIndent != 0) string += "horizontalIndent="+horizontalIndent+" ";
	 	if (horizontalSpan != 1) string += "horizontalSpan="+horizontalSpan+" ";
	 	if (grabExcessHorizontalSpace) string += "grabExcessHorizontalSpace="+grabExcessHorizontalSpace+" ";
	 	if (widthHint != Layout.DEFAULT) string += "widthHint="+widthHint+" ";
	 	if (minimumWidth != 0) string += "minimumWidth="+minimumWidth+" ";
	 	string += "verticalAlignment="+vAlign+" ";
	 	if (verticalIndent != 0) string += "verticalIndent="+verticalIndent+" ";
		if (verticalSpan != 1) string += "verticalSpan="+verticalSpan+" ";
	 	if (grabExcessVerticalSpace) string += "grabExcessVerticalSpace="+grabExcessVerticalSpace+" ";
	 	if (heightHint != Layout.DEFAULT) string += "heightHint="+heightHint+" ";
	 	if (minimumHeight != 0) string += "minimumHeight="+minimumHeight+" ";
	 	if (exclude) string += "exclude="+exclude+" ";
	 	string += "}";
		return string;
	}
}