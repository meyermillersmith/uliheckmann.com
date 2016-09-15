/**
 * ViewRect, version 1 for easy use of the scrollRect ( See MovieClip.scrollRect property)
 * @author:  luis.martinez@lessrain.com
 */

import flash.geom.Rectangle;
class lessrain.lib.utils.scrollers.ScrollRect
{

	private var rect:Rectangle;

	private var _targetMC : MovieClip;
	

	public function ScrollRect (){}
	
	public function initialize (target_:MovieClip, w_:Number, h_:Number, cache_:Boolean, opaqueBG_:Number):Void
	{
		_targetMC = target_;
		
		if(cache_ !=null) cacheBitmap(cache_);
		else cacheBitmap(false);
		
		if(opaqueBG_!=null) _targetMC.opaqueBackground=opaqueBG_;
		
		rect = new Rectangle (0, 0, w_, h_);
		
		updateTargetRect();
	}
	
	public function set y (value:Number):Void
	{
		rect.y = value;
		updateTargetRect();
	}
	
	public function set x (value:Number):Void
	{
		rect.x = value;
		updateTargetRect();
	}
	
	public function set w (value:Number):Void
	{
		rect.width = value;
		updateTargetRect();
	}
	
	public function set h (value:Number):Void
	{
		rect.height = value;
		updateTargetRect();
	}
	
	private function updateTargetRect():Void
	{
		_targetMC.scrollRect = rect;
	}
	
	public function cacheBitmap (cache:Boolean):Void
	{
		_targetMC.cacheAsBitmap=cache;
	}
	
	public function destroy() :Void
	{
		_targetMC.scrollRect = null;
	}
	public function get targetMC() : MovieClip { return _targetMC; }
	public function set targetMC( value:MovieClip ) { _targetMC = value; }
	public function set bgColor(value:Number):Void {_targetMC.opaqueBackground=value;}
	public function get bgColor():Number {return _targetMC.opaqueBackground;}
	public function get y ():Number { return rect.y; }
	public function get x ():Number { return rect.x; }
	public function get w ():Number { return rect.width; }
	public function get h ():Number { return rect.height; }
	public function get rectParameters ():String { return rect.toString(); }

}
