/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.loading.FileProgress
{
	private var _percent:Number;
	private var _bytesLoaded:Number;
	private var _bytesTotal:Number;
	
	public function FileProgress()
	{
		_percent=0;
		_bytesLoaded=0;
		_bytesTotal=0;
	}
	
	public function get percent():Number { return _percent; }
	public function set percent(value:Number):Void { _percent=value; }
	public function get bytesLoaded():Number { return _bytesLoaded; }
	public function set bytesLoaded(value:Number):Void { _bytesLoaded=value; }
	public function get bytesTotal():Number { return _bytesTotal; }
	public function set bytesTotal(value:Number):Void { _bytesTotal=value; }
	
	
		
	
}