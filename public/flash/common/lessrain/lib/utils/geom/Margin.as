class lessrain.lib.utils.geom.Margin
{
	private var _left:Number, _top:Number, _right:Number, _bottom:Number;
	
	function Margin(left_:Number, top_:Number, right_:Number, bottom_:Number)
	{
		setValues(left_, top_, right_, bottom_);
	}
	
	function clone():Margin
	{
		return new Margin(_left, _top, _right, _bottom);
	}
	
	function setValues(left_:Number, top_:Number, right_:Number, bottom_:Number):Void
	{
		_left = ( (left_!=null) ? left_ : 0 );
		_top = ( (top_!=null) ? top_ : 0 );
		_right = ( (right_!=null) ? right_ : 0 );
		_bottom = ( (bottom_!=null) ? bottom_ : 0 );
	}
	
	function get left():Number { return _left; }
	function set left(setValue:Number):Void { _left = setValue; }
	
	function get top():Number { return _top; }
	function set top(setValue:Number):Void { _top = setValue; }
	
	function get right():Number { return _right; }
	function set right(setValue:Number):Void { _right = setValue; }
	
	function get bottom():Number { return _bottom; }
	function set bottom(setValue:Number):Void { _bottom = setValue; }
}
