/**
 * Background Utilities, version 1
 * @class:   lessrain.lib.utils.BackgroundUtils
 * @author:  luis@lessrain.com
 * @version: 1.0
 * @use with flash 8 only
 */
import flash.geom.Rectangle;
import flash.display.BitmapData;

class lessrain.lib.utils.BackgroundUtils {
	
	// change background color
	public static function backgroundColor(hexValue:Number, target:MovieClip):Void {

		if (target == undefined) {
			target = _level0;
			target.scrollRect = new Rectangle(0, 0, Stage.width, Stage.height);
		}
		target.opaqueBackground = hexValue;
	}
	
	// tile background
	public static function backgroundTile(tile:String, target:MovieClip):Void {
		var pattern:BitmapData = BitmapData.loadBitmap(tile);
		var w:Number=target._width;
		var h:Number=target._height;
		if (target == undefined) {
			target = _level0;
			w=Stage.width;
			h=Stage.height;
		}
		target.beginBitmapFill(pattern);
		target.moveTo(0, 0);
		target.lineTo(w, 0);
		target.lineTo(w, h);
		target.lineTo(0, h);
		target.lineTo(0, 0);
		target.endFill();
	}
}
