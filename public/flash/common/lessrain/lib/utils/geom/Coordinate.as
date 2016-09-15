class lessrain.lib.utils.geom.Coordinate
{
	private var _x :Number, _y :Number;
	
	function Coordinate(initX:Number, initY:Number)
	{
		_x = ( (initX!=null) ? initX : 0 );
		_y = ( (initY!=null) ? initY : 0 );
	}
	
	function clone():Coordinate
	{
		return new Coordinate(x, y);
	}
	
	function setValues(newX:Number, newY:Number):Void
	{
		x = newX;
		y = newY;
	}
	
	function get x():Number { return _x; }
	function set x(setValue:Number):Void { _x = setValue; }
	
	function get y():Number { return _y; }
	function set y(setValue:Number):Void { _y = setValue; }
}
