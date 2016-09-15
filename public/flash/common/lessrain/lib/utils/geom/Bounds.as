import lessrain.lib.utils.geom.Coordinate;

class lessrain.lib.utils.geom.Bounds extends Coordinate
{
	private var _w :Number, _h :Number;
	
	function Bounds(initX:Number, initY:Number, initW:Number, initH:Number)
	{
		super(initX, initY);
		_w = ( (initW!=null) ? initW : 0 );
		_h = ( (initH!=null) ? initH : 0 );
	}
	
	function clone():Bounds
	{
		return new Bounds(x, y, w, h);
	}
	
	function setValues(newX:Number, newY:Number, newW:Number, newH:Number):Void
	{
		super.setValues(newX, newY);
		w = newW;
		h = newH;
	}
	
	function get w():Number { return _w; }
	function set w(setValue:Number):Void { _w = setValue; }
	
	function get h():Number { return _h; }
	function set h(setValue:Number):Void { _h = setValue; }
}