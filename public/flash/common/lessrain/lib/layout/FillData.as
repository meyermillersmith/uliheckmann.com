import flash.geom.Rectangle;

import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutData;
import lessrain.lib.layout.Layout;
import lessrain.lib.utils.geom.Size;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * AS version of Eclipse's FillData (org.eclipse.swt.layout.FillData)
 */
class lessrain.lib.layout.FillData implements ILayoutData {
	
	public var defaultWidth:Number = -1;
	public var defaultHeight:Number = -1;
	public var currentWhint:Number;
	public var currentHhint:Number;
	public var currentWidth:Number = -1;
	public var currentHeight:Number = -1;
	
	public function computeSize(item_:ILayoutable, wHint_:Number, hHint_:Number, flushCache_:Boolean):Size {
		if (flushCache) flushCache();
		if (wHint_ == Layout.DEFAULT && hHint_ == Layout.DEFAULT) {
			if (defaultWidth == -1 || defaultHeight == -1) {
				var rect:Rectangle = item_.computeSize(wHint_, hHint_, flushCache_);
				defaultWidth = rect.width;
				defaultHeight = rect.height;
			}
			return new Size(defaultWidth, defaultHeight);
		}
		if (currentWidth == -1 || currentHeight == -1 || wHint_ != currentWhint || hHint_ != currentHhint) {
			var rect:Rectangle = item_.computeSize(wHint_, hHint_, flushCache_);
			currentWhint = wHint_;
			currentHhint = hHint_;
			currentWidth = rect.width;
			currentHeight = rect.height;
		}
		return new Size(currentWidth, currentHeight);
	}
	
	public function flushCache():Void {
		defaultWidth = defaultHeight = -1;
		currentWidth = currentHeight = -1;
	}
	
	public function toString():String {
		return "FillData";
	}
}