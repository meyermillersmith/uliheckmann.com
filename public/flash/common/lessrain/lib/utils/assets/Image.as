/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.Image
{
	private static var images:Array;

	private var _id:String;
	private var _src:String;

	static function reset():Void
	{
		images=new Array();
	}
	
	static function addImage(id:String, src:String):Image
	{
		var image:Image = new Image(id, src);
		if (images==null) images = new Array();
		images.push( image );
		return image;
	}
	
	static function getImage(id:String):String
	{
		if (images!=null) for (var i : Number = images.length-1; i >= 0; i--) if (Image(images[i]).id==id) return Image(images[i]).src;
		return "";
	}
	
	public function Image( id:String, src:String )
	{
		_id=id;
		_src=src;
	}
	
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }

	public function get src():String { return _src; }
	public function set src(value:String):Void { _src=value; }
}