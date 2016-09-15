class lessrain.lib.utils.geom.Size
{
	private var _w :Number, _h :Number;
	
	public function Size(initW:Number, initH:Number)
	{
		_w = ( (initW!=null) ? initW : 0 );
		_h = ( (initH!=null) ? initH : 0 );
	}
	
	public function clone():Size
	{
		return new Size(w, h);
	}
	
	public function setValues(newW:Number, newH:Number):Void
	{
		w = newW;
		h = newH;
	}
	
	public function get w():Number { return _w; }
	public function set w(setValue:Number):Void { _w = setValue; }
	
	public function get h():Number { return _h; }
	public function set h(setValue:Number):Void { _h = setValue; }
	
	public function toString():String {
		return "lessrain.lib.utils.geom.Size: (" + w + "," + h + ")";
	}
}
