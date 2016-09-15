/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.Source
{
	private static var sources:Array;

	private var _id:String;
	private var _src:String;

	static function reset():Void
	{
		sources=new Array();
	}
	
	static function addSource( id:String, src:String ):Void
	{
		if (sources==null) sources = new Array();
		sources.push( new Source(id, src) );
	}
	
	static function getSource(id:String):String
	{
		if (sources!=null) for (var i : Number = sources.length-1; i >= 0; i--) if (Source(sources[i]).id==id) return Source(sources[i]).src;
		return null;
	}
	
	public function Source( id:String, src:String )
	{
		_id=id;
		_src=src;
	}
	
	public function get id():String { return _id; }
	public function set id(title:String):Void { _id=title; }

	public function get src():String { return _src; }
	public function set src(title:String):Void { _src=title; }
}