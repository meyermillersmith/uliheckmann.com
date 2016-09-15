/**
 * Pane, version 1 for easy use of the scrollRect ( See MovieClip.scrollRect property)
 * @class:   lessrain.lib.movieclip.Pane
 * @author:  luis.martinez@lessrain.com
 * @version: 1.1
 * @use with flash 8 only
 *
 * The scrollRect property allows you to quickly scroll movie clip content and
 * have a window viewing larger content. Text fields and complex content scroll
 * much faster, because pixel level copying is used to scroll data instead of 
 * regenerating the entire movie clip from vector data.
 *
 */

import flash.geom.Rectangle;
class lessrain.lib.utils.movieclip.Pane
{
	private var target_mc:MovieClip;
	private var rect:Rectangle;
	
	/** 
	 * Constructor
	 *
	 * @param	target    	The movie clip to crop and scroll
	 * @param	w		  	The width of the visible area
	 * @param	cache	  	A Boolean to cache an internal bitmap representation 
	 *                    	of the movie clip. This can increase performance for 
	 *                    	movie clips that contain complex vector content. 
	 * @param	opaqueBG  	The color of the movie clip's opaque (not transparent,RGB hexadecimal value) 
	 *                      Setting opaqueBackground can improve rendering performance. 
	 */
	 
	function Pane (target:MovieClip, w:Number, h:Number, cache:Boolean, opaqueBG:Number)
	{
		target_mc = target;
		if(cache) cacheBitmap(cache);
		if(opaqueBG!=undefined) target_mc.opaqueBackground=opaqueBG;
		rect = new Rectangle (0, 0, w, h);
		updateTargetRect();
	}
	
	public function set y (yVal:Number):Void
	{
		rect.y = yVal;
		updateTargetRect();
	}
	
	public function set x (xVal:Number):Void
	{
		rect.x = xVal;
		updateTargetRect();
	}
	
	public function set w (wVal:Number):Void
	{
		rect.width = wVal;
		updateTargetRect();
	}
	
	public function set h (hVal:Number):Void
	{
		rect.height = hVal;
		updateTargetRect();
	}
	
	private function updateTargetRect():Void
	{
		target_mc.scrollRect = rect;
	}
	
	public function cacheBitmap (cache:Boolean):Void
	{
		target_mc.cacheAsBitmap=cache;
	}
	
	public function destroy() :Void
	{
		target_mc.scrollRect = null;
	}
	
	public function set bgColor(value:Number):Void {target_mc.opaqueBackground=value;}
	public function get bgColor():Number {return target_mc.opaqueBackground;}
	public function get y ():Number { return rect.y; }
	public function get x ():Number { return rect.x; }
	public function get w ():Number { return rect.width; }
	public function get h ():Number { return rect.height; }
	public function get target ():MovieClip { return target_mc; }
	public function get rectParameters ():String { return rect.toString(); }

}
