import flash.geom.Rectangle;

import lessrain.lib.layout.FillData;
import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutHost;
import lessrain.lib.layout.Layout;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.StringUtils;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * AS version of Eclipse's FillLayout (org.eclipse.swt.layout.FillLayout)
 * 
 * <code>FillLayout</code> is the simplest layout class. It lays out 
 * items in a single row or column, forcing them to be the same size. 
 * <p>
 * Initially, the items will all be as tall as the tallest control, 
 * and as wide as the widest. <code>FillLayout</code> does not wrap, 
 * but you can specify margins and spacing. 
 * </p>
 * <p>
 * Example code: first a <code>FillLayout</code> is created and
 * its type field is set, and then the layout is set into the 
 * <code>ILayoutHost</code>. Note that in a <code>FillLayout</code>,
 * children are always the same size, and they fill all available space.
 * <pre>
 * 		var layout:FillLayout = new FillLayout();
 * 		layout.type = Layout.VERTICAL;
 * 		myHost.setLayout(layout); // myHost must be an ILayoutHost
 * </pre>
 * </p>
 */
class lessrain.lib.layout.FillLayout extends Layout {
	
	/**
	 * marginWidth specifies the number of pixels of horizontal margin
	 * that will be placed along the left and right edges of the layout.
	 * 
	 * Default is 0.
	 */
	public var marginWidth:Number = 0;
	
	/**
	 * marginHeight specifies the number of pixels of vertical margin
	 * that will be placed along the top and bottom edges of the layout.
	 * 
	 * Default is 0.
	 */	public var marginHeight:Number = 0;
	
	/**
	 * Layout type (horizonal or vertical).
	 * Legal values are <code>Layout.HORIZONTAL</code> and <code>Layout.VERTICAL</code>
	 * 
	 * Default is Layout.HORIZONTAL
	 */
	public var type:Number = Layout.HORIZONTAL;
	
	/**
	 * spacing specifies the number of pixels between the edge of one cell
	 * and the edge of its neighbouring cell.
	 * 
	 * Default is 0.
	 */
	public var spacing:Number = 0;
	
	/**
	 * Constructor
	 * 
	 * @param	type_	Layout type [<code>Layout.HORIZONTAL</code>, <code>Layout.VERTICAL</code>]
	 * @param	style_	Style bits to define horizontal and vertical orientation
	 * @see				Layout
	 */
	public function FillLayout(type_:Number, style_:Number) {
		super(style_);
		
		type = type_;
	}
	
	/**
	 * @see Layout#layout
	 */
	public function layout(item_:ILayoutHost, flushCache_:Boolean):Void {
		var rect:Rectangle = item_.getBoundaries();
		var children:Array = item_.getChildren();
		var count:Number = children.length;
		if(count == 0) {
			return;
		}
		
		var width:Number = rect.width - marginWidth * 2;
		var height:Number = rect.height - marginHeight * 2;
		
		if(type == Layout.HORIZONTAL) {
			width -= (count - 1) * spacing;
			var x:Number = marginWidth;
			var extra:Number = width % count;
			var y:Number = marginHeight;
			var cellWidth:Number = width / count;
			
			for(var i:Number = 0; i < count; i++) {
				var child:ILayoutable = ILayoutable(children[i]);
				var childWidth:Number = cellWidth;
				if(i == 0) {
					childWidth += extra / 2;
				} else {
					if (i == count - 1) {
						childWidth += (extra + 1) / 2;
					}
				}
				child.setBoundaries(
					translateRect(
						new Rectangle(x, y, childWidth, height),
						item_.getBoundaries().width,
						item_.getBoundaries().height
					)
				);
				x += childWidth + spacing;
			}
		} else {
			height -= (count - 1) * spacing;
			var x:Number = marginWidth;
			var cellHeight:Number = height / count;
			var y:Number = marginHeight;
			var extra:Number = height % count;
			
			for (var i:Number = 0; i < count; i++) {
				var child:ILayoutable = ILayoutable(children[i]);
				var childHeight:Number = cellHeight;
				if(i == 0) {
					childHeight += extra / 2;
				} else {
					if(i == count - 1) {
						childHeight += (extra + 1) / 2;
					}
				}
				child.setBoundaries(
					translateRect(
						new Rectangle(x, y, width, childHeight),
						item_.getBoundaries().width,
						item_.getBoundaries().height
					)
				);
				y += childHeight + spacing;
			}
		}
	}
	
	/**
	 * @see Layout#computeSize
	 */
	public function computeSize(item_:ILayoutHost, wHint:Number, hHint:Number, flushCache:Boolean):Size {
		var children:Array = item_.getChildren (); // ILayoutable 
		var count:Number = children.length;
		var maxWidth:Number = 0;
		var maxHeight:Number = 0;
		for (var i:Number = 0; i < count; i++) {
			var child:ILayoutable = ILayoutable(children[i]);
			var w:Number = wHint;
			var h:Number = hHint;
			if (count > 0) {
				if (type == Layout.HORIZONTAL && wHint != Layout.DEFAULT) {
					w = Math.max (0, (wHint - (count - 1) * spacing) / count);
				}
				if (type == Layout.VERTICAL && hHint != Layout.DEFAULT) {
					h = Math.max (0, (hHint - (count - 1) * spacing) / count);
				}
			}
			var size:Size = computeChildSize (child, w, h, flushCache);
			maxWidth = Math.max (maxWidth, size.w);
			maxHeight = Math.max (maxHeight, size.h);
		}
		var width:Number = 0;
		var height:Number = 0;
		if (type == Layout.HORIZONTAL) {
			width = count * maxWidth;
			if (count != 0) width += (count - 1) * spacing;
			height = maxHeight;
		} else {
			width = maxWidth;
			height = count * maxHeight;
			if (count != 0) height += (count - 1) * spacing;
		}
		width += marginWidth * 2;
		height += marginHeight * 2;
		if (wHint != Layout.DEFAULT) width = wHint;
		if (hHint != Layout.DEFAULT) height = hHint;
		return new Size(width, height);
	}
	
	private function computeChildSize (item_:ILayoutable, wHint_:Number, hHint_:Number, flushCache_:Boolean):Size {
		var data:FillData = FillData(item_.getLayoutData());
		if (data == null) {
			data = new FillData();
			item_.setLayoutData(data);
		}
		var size:Size = null;
		if (wHint_ == Layout.DEFAULT && hHint_ == Layout.DEFAULT) {
			size = data.computeSize(item_, wHint_, hHint_, flushCache_);
		} else {
			// TEMPORARY CODE
			var trimX:Number = 0;
			var trimY:Number = 0;
			/*
			if (item_ instanceof Scrollable) {
				Rectangle rect = ((Scrollable) control).computeTrim (0, 0, 0, 0);
				trimX = rect.width;
				trimY = rect.height;
			} else {
				trimX = trimY = control.getBorderWidth () * 2;
			}*/
			var w:Number = wHint_ == Layout.DEFAULT ? wHint_ : Math.max(0, wHint_ - trimX);
			var h:Number = hHint_ == Layout.DEFAULT ? hHint_ : Math.max(0, hHint_ - trimY);
			size = data.computeSize(item_, w, h, flushCache_);
		}
		return size;
	}
	
	/**
	 * Convenience: Set all margin values (margin width and height)
	 * @param	margin_	Margin value
	 */
	public function set margin(margin_:Number):Void {
		marginWidth = marginHeight = margin_;
	}
	
	/**
	 * Returns a string containing a concise, human-readable
	 * description of the receiver.
	 *
	 * @return a string representation of the layout
	 */
	public function toString():String {
	 	var string:String = "FillLayout ";
	 	string += "type=" + ((type == Layout.VERTICAL) ? "Layout.VERTICAL" : "Layout.HORIZONTAL") + " ";
	 	if (marginWidth != 0) string += "marginWidth=" + marginWidth+" ";
	 	if (marginHeight != 0) string += "marginHeight=" + marginHeight+" ";
	 	if (spacing != 0) string += "spacing=" + spacing+" ";
	 	string = StringUtils.trim(string);
	 	string += "}";
	 	return string;
	}

}