import flash.geom.Point;
import flash.geom.Rectangle;

import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutHost;
import lessrain.lib.layout.Layout;
import lessrain.lib.layout.RowData;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.StringUtils;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * AS version of Eclipse's RowLayout (org.eclipse.swt.layout.RowLayout)
 * 
 * Instances of this class determine the size and position of the 
 * children of a <code>ILayoutHost</code> by placing them either in 
 * horizontal rows or vertical columns within the parent <code>ILayoutHost</code>. 
 * <p>
 * <code>RowLayout</code> aligns all controls in one row if the
 * <code>type</code> is set to horizontal, and one column if it is
 * set to vertical. It has the ability to wrap, and provides configurable 
 * margins and spacing. <code>RowLayout</code> has a number of configuration 
 * fields. In addition, the height and width of each control in a 
 * <code>RowLayout</code> can be specified by setting a <code>RowData</code>
 * object into the control using <code>setLayoutData ()</code>.
 * </p>
 * <p>
 * The following example code creates a <code>RowLayout</code>, sets all 
 * of its fields to non-default values, and then assigns it to an 
 * <code>ILayoutable</code> item. 
 * <pre>
 * 		var rowLayout:RowLayout = new RowLayout(Layout.VERTICAL);
 * 		rowLayout.wrap = false;
 * 		rowLayout.pack = false;
 * 		rowLayout.justify = true;
 * 		rowLayout.marginLeft = 5;
 * 		rowLayout.marginTop = 5;
 * 		rowLayout.marginRight = 5;
 * 		rowLayout.marginBottom = 5;
 * 		rowLayout.spacing = 0;
 * 		myHost.setLayout(rowLayout); // myHost must be an implementation of ILayoutHost
 * </pre>
 * If you are using the default field values, you only need one line of code:
 * <pre>
 * 		myHost.setLayout(new RowLayout()); // myHost must be an implementation of ILayoutHost
 * </pre>
 * </p>
 * 
 * @see RowData
 */
class lessrain.lib.layout.RowLayout extends Layout {
	
	/**
	 * type specifies whether the layout places controls in rows or 
	 * columns.
	 * 
	 * The default value is HORIZONTAL.
	 * 
	 * Possible values are: <ul>
	 *    <li><code>Layout.HORIZONTAL</code>: Position the controls horizontally from left to right</li>
	 *    <li><code>Layout.VERTICAL</code>: Position the controls vertically from top to bottom</li>
	 * </ul>
	 */
	public var type:Number = Layout.HORIZONTAL;
	
	/**
	 * marginWidth specifies the number of pixels of horizontal margin
	 * that will be placed along the left and right edges of the layout.
	 *
	 * The default value is 0.
	 */
 	public var marginWidth:Number = 0;
 	
	/**
	 * marginHeight specifies the number of pixels of vertical margin
	 * that will be placed along the top and bottom edges of the layout.
	 *
	 * The default value is 0.
	 */
 	public var marginHeight:Number = 0;

	/**
	 * spacing specifies the number of pixels between the edge of one cell
	 * and the edge of its neighbouring cell.
	 *
	 * The default value is 3.
	 */
	public var spacing:Number = 3;
	 		
	/**
	 * wrap specifies whether a control will be wrapped to the next
	 * row if there is insufficient space on the current row.
	 *
	 * The default value is true.
	 */
	public var wrap:Boolean = true;

	/**
	 * pack specifies whether all controls in the layout take
	 * their preferred size.  If pack is false, all controls will 
	 * have the same size which is the size required to accommodate the 
	 * largest preferred height and the largest preferred width of all 
	 * the controls in the layout.
	 *
	 * The default value is true.
	 */
	public var pack:Boolean = true;
	
	/**
	 * fill specifies whether the controls in a row should be
	 * all the same height for horizontal layouts, or the same
	 * width for vertical layouts.
	 *
	 * The default value is false.
	 */
	public var fill:Boolean = false;

	/**
	 * justify specifies whether the controls in a row should be
	 * fully justified, with any extra space placed between the controls.
	 *
	 * The default value is false.
	 */
	public var justify:Boolean = false;

	/**
	 * marginLeft specifies the number of pixels of horizontal margin
	 * that will be placed along the left edge of the layout.
	 *
	 * The default value is 3.
	 */
	public var marginLeft:Number = 3;

	/**
	 * marginTop specifies the number of pixels of vertical margin
	 * that will be placed along the top edge of the layout.
	 *
	 * The default value is 3.
	 */
	public var marginTop:Number = 3;

	/**
	 * marginRight specifies the number of pixels of horizontal margin
	 * that will be placed along the right edge of the layout.
	 *
	 * The default value is 3.
	 */
	public var marginRight:Number = 3;

	/**
	 * marginBottom specifies the number of pixels of vertical margin
	 * that will be placed along the bottom edge of the layout.
	 *
	 * The default value is 3.
	 */
	public var marginBottom:Number = 3;

	/**
	 * Constructs a new instance of this class given the type.
 	 * <p>Usage:
 	 * <p><pre>var layout:RowLayout = new RowLayout(Layout.VERTICAL, LAYOUT.BOTTOM_UP); // define a vertical row layout that is filled from the bottom up
 	 * var myHost:ILayoutHost = new SampleLayoutHost();
 	 * myHost.setLayout(layout); // assign the layout to a layout host
 	 * myHost.addChild(new SampleLayoutable()); // add some elements
 	 * myHost.addChild(new SampleLayoutable());</pre>
	 *
	 * @param	type_	The type of row layout
	 * @param	style_	Style bits to define horizontal and vertical orientation
	 * @see				Layout
	 */
	public function RowLayout (type_:Number, style_:Number) {
		super(style_);
		
		if(type != null) {
			type = type_;
		}
	}
	
	public function computeSize(item:ILayoutHost, wHint:Number, hHint:Number, flushCache:Boolean):Size {
		var extent:Size;
		if (type == Layout.HORIZONTAL) {
			extent = layoutHorizontal(item, false, (wHint != Layout.DEFAULT) && wrap, wHint, flushCache);
		} else {
			extent = layoutVertical(item, false, (hHint != Layout.DEFAULT) && wrap, hHint, flushCache);
		}
		if (wHint != Layout.DEFAULT) {
			extent.w = wHint;
		}
		if (hHint != Layout.DEFAULT) {
			extent.h = hHint;
		}
		return extent;
	}
	
	private function getChildSize(item_:ILayoutable, flushCache_:Boolean):Rectangle {
		var wHint:Number = Layout.DEFAULT;
		var hHint:Number = Layout.DEFAULT;
		var data:RowData = RowData(item_.getLayoutData());
		if (data != null) {
			wHint = data.width;
			hHint = data.height;
		}
		return item_.computeSize(wHint, hHint);
	}
	
	private function layout(item:ILayoutHost, flushCache:Boolean):Void {
		var clientArea:Rectangle = item.getBoundaries();
		if (type == Layout.HORIZONTAL) {
			layoutHorizontal (item, true, wrap, clientArea.width, flushCache);
		} else {
			layoutVertical (item, true, wrap, clientArea.height, flushCache);
		}
	}
	
	private function layoutHorizontal(item:ILayoutHost, move:Boolean, wrap:Boolean, width:Number, flushCache:Boolean):Size {
		var children:Array = item.getChildren ();
		var count:Number = 0;
		for (var i:Number = 0; i < children.length; i++) {
			var child:ILayoutable = ILayoutable(children [i]);
			var data:RowData = RowData(child.getLayoutData ());
			if (data == null || !data.exclude) {
				children [count++] = ILayoutable(children [i]);
			} 
		}
		if (count == 0) {
			return new Size (marginLeft + marginWidth * 2 + marginRight, marginTop + marginHeight * 2 + marginBottom);
		}
		var childWidth:Number = 0;
		var childHeight:Number = 0;
		var maxHeight:Number = 0;
		if (!pack) {
			for (var i:Number = 0; i < count; i++) {
				var child:ILayoutable = ILayoutable(children [i]);
				var size:Rectangle = getChildSize (child, flushCache);
				childWidth = Math.max (childWidth, size.width);
				childHeight = Math.max (childHeight, size.height);
			}
			maxHeight = childHeight;
		}
		var clientX:Number = 0;
		var clientY:Number = 0;
		var wraps:Array = null; // Number
		var wrapped:Boolean = false;
		var bounds:Array = null; // Rectangle
		if (move && (justify || fill)) {
			bounds = new Array(count); // Rectangle
			wraps = new Array(count); // Number
		}
		var maxX:Number = 0;
		var x:Number = marginLeft + marginWidth;
		var y:Number = marginTop + marginHeight;
		for (var i:Number = 0; i < count; i++) {
			var child:ILayoutable = ILayoutable(children [i]);
			if (pack) {
				var size:Rectangle = getChildSize (child, flushCache);
				childWidth = size.width;
				childHeight = size.height;
			}
			if (wrap && (i != 0) && (x + childWidth > width)) {
				wrapped = true;
				if (move && (justify || fill)) {
					wraps [i - 1] = maxHeight;
				}
				x = marginLeft + marginWidth;
				y += spacing + maxHeight;
				if (pack) {
					maxHeight = 0;
				}
			}
			if (pack || fill) {
				maxHeight = Math.max (maxHeight, childHeight);
			}
			if (move) {
				var childX:Number = x + clientX;
				var childY:Number = y + clientY;
				if (justify || fill) {
					bounds [i] = new Rectangle (childX, childY, childWidth, childHeight);
				} else {
					child.setBoundaries(translateRect(new Rectangle(childX, childY, childWidth, childHeight), item.getBoundaries().width, item.getBoundaries().height));
				}
			}
			x += spacing + childWidth;
			maxX = Math.max (maxX, x);
		}
		maxX = Math.max (clientX + marginLeft + marginWidth, maxX - spacing);
		if (!wrapped) {
			maxX += marginRight + marginWidth;
		}
		if (move && (justify || fill)) {
			var space:Number = 0;
			var margin:Number = 0;
			if (!wrapped) {
				space = Math.max (0, (width - maxX) / (count + 1));
				margin = Math.max (0, ((width - maxX) % (count + 1)) / 2);
			} else {
				if (fill || justify) {
					var last:Number = 0;
					if (count > 0) {
						wraps [count - 1] = maxHeight;
					}
					for (var i:Number = 0; i < count; i++) {
						if (Number(wraps [i]) != 0) {
							var wrapCount:Number = i - last + 1;
							if (justify) {
								var wrapX:Number = 0;
								for (var j:Number = last; j <= i; j++) {
									wrapX += Rectangle(bounds [j]).width + spacing;
								}
								space = Math.max (0, (width - wrapX) / (wrapCount + 1));
								margin = Math.max (0, ((width - wrapX) % (wrapCount + 1)) / 2);
							}
							for (var j:Number = last; j < i; j++) {
								if (justify){
									Rectangle(bounds [j]).x += (space * (j - last + 1)) + margin;
								}
								if (fill) {
									Rectangle(bounds [j]).height = Number(wraps [i]);
								}
							}
							last = i + 1;
						}
					}
				}
			}
			for (var i:Number = 0; i < count; i++) {
				if (!wrapped) {
					if (justify) {
						Rectangle(bounds [i]).x += (space * (i + 1)) + margin;
					}
					if (fill){
						Rectangle(bounds [i]).height = maxHeight;
					}
				}
				ILayoutable(children [i]).setBoundaries(translateRect(Rectangle(bounds [i]), item.getBoundaries().width, item.getBoundaries().height));
			}
		}
//		LogManager.inspectObject(bounds);
		return new Size (maxX, y + maxHeight + marginBottom + marginHeight);
	}
	
	private function layoutVertical (item:ILayoutHost, move:Boolean, wrap:Boolean, height:Number, flushCache:Boolean):Size {
		var children:Array = item.getChildren (); // ILayoutable
		var count:Number = 0;
		for (var i:Number = 0; i < children.length; i++) {
			var child:ILayoutable = ILayoutable(children [i]);
			var data:RowData = RowData(child.getLayoutData ());
			if (data == null || !data.exclude) {
				children [count++] = children [i];
			} 
		}
		if (count == 0) {
			return new Size (marginLeft + marginWidth * 2 + marginRight, marginTop + marginHeight * 2 + marginBottom);
		}
		var childWidth:Number = 0;
		var childHeight:Number = 0;
		var maxWidth:Number = 0;
		if (!pack) {
			for (var i:Number = 0; i < count; i++) {
				var child:ILayoutable = ILayoutable(children [i]);
				var size:Rectangle = getChildSize (child, flushCache);
				childWidth = Math.max (childWidth, size.width);
				childHeight = Math.max (childHeight, size.height);
			}
			maxWidth = childWidth;
		}
		var clientX:Number = 0;
		var clientY:Number = 0;
		var wraps:Array = null; // Number
		var wrapped:Boolean = false;
		var bounds:Array = null; // Rectangle
		if (move && (justify || fill)) {
			bounds = new Array(count);
			wraps = new Array(count);
		}
		var maxY:Number = 0;
		var x:Number = marginLeft + marginWidth;
		var y:Number = marginTop + marginHeight;
		for (var i:Number = 0; i < count; i++) {
			var child:ILayoutable = ILayoutable(children [i]);
			if (pack) {
				var size:Rectangle = getChildSize (child, flushCache);
				childWidth = size.width;
				childHeight = size.height;
			}
			if (wrap && (i != 0) && (y + childHeight > height)) {
				wrapped = true;
				if (move && (justify || fill)) {
					wraps [i - 1] = maxWidth;
				}
				x += spacing + maxWidth;
				y = marginTop + marginHeight;
				if (pack) {
					maxWidth = 0;
				}
			}
			if (pack || fill) {
				maxWidth = Math.max (maxWidth, childWidth);
			}
			if (move) {
				var childX:Number = x + clientX;
				var childY:Number = y + clientY;
				if (justify || fill) {
					bounds [i] = new Rectangle (childX, childY, childWidth, childHeight);
				} else {
					child.setBoundaries(translateRect(new Rectangle(childX, childY, childWidth, childHeight), item.getBoundaries().width, item.getBoundaries().height));
				}
			}
			y += spacing + childHeight;
			maxY = Math.max (maxY, y);
		}
		maxY = Math.max (clientY + marginTop + marginHeight, maxY - spacing);
		if (!wrapped) {
			maxY += marginBottom + marginHeight;
		}
		if (move && (justify || fill)) {
			var space:Number = 0;
			var margin:Number = 0;
			if (!wrapped) {
				space = Math.max (0, (height - maxY) / (count + 1));
				margin = Math.max (0, ((height - maxY) % (count + 1)) / 2);
			} else {
				if (fill || justify) {
					var last:Number = 0;
					if (count > 0) {
						wraps [count - 1] = maxWidth;
					}
					for (var i:Number = 0; i < count; i++) {
						if (Number(wraps [i]) != 0) {
							var wrapCount:Number = i - last + 1;
							if (justify) {
								var wrapY:Number = 0;
								for (var j:Number = last; j <= i; j++) {
									wrapY += Rectangle(bounds [j]).height + spacing;
								}
								space = Math.max (0, (height - wrapY) / (wrapCount + 1));
								margin = Math.max (0, ((height - wrapY) % (wrapCount + 1)) / 2);
							}
							for (var j:Number = last; j <= i; j++) {
								if (justify) {
									bounds [j].y += (space * (j - last + 1)) + margin;
								}
								if (fill) {
									bounds [j].width = wraps [i];
								}
							}
							last = i + 1;
						}
					}
				}
			}
			for (var i:Number = 0; i < count; i++) {
				if (!wrapped) {
					if (justify) {
						bounds [i].y += (space * (i + 1)) + margin;
					}
					if (fill) {
						bounds [i].width = maxWidth;
					}
				}
				ILayoutable(children [i]).setBoundaries(translateRect(Rectangle(bounds [i]), item.getBoundaries().width, item.getBoundaries().height));
			}
		}
		return new Size (x + maxWidth + marginRight + marginWidth, maxY);
	}
	
	/**
	 * Convenience: Set all margin values (margin width, height, left, right,
	 * top and bottom)
	 * @param	margin_	Margin value
	 */
	public function set margin(margin_:Number):Void {
		marginWidth = marginHeight = marginTop = marginRight = marginBottom = marginLeft = margin_;
	}
	
	/**
	 * Returns a string containing a concise, human-readable
	 * description of the receiver.
	 *
	 * @return a string representation of the layout
	 */
	public function toString():String {
	 	var string:String = "RowLayout {";
	 	string += "type="+((type != Layout.HORIZONTAL) ? "Layout.VERTICAL" : "Layout.HORIZONTAL")+" ";
	 	if (marginWidth != 0) string += "marginWidth="+marginWidth+" ";
	 	if (marginHeight != 0) string += "marginHeight="+marginHeight+" ";
	 	if (marginLeft != 0) string += "marginLeft="+marginLeft+" ";
	 	if (marginTop != 0) string += "marginTop="+marginTop+" ";
	 	if (marginRight != 0) string += "marginRight="+marginRight+" ";
	 	if (marginBottom != 0) string += "marginBottom="+marginBottom+" ";
	 	if (spacing != 0) string += "spacing="+spacing+" ";
	 	string += "wrap="+wrap+" ";
		string += "pack="+pack+" ";
		string += "fill="+fill+" ";
		string += "justify="+justify+" ";
		string = StringUtils.trim(string);
		string += "}";
	 	return string;
	}
}