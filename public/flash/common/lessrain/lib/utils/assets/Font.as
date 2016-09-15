/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.Font
{
	private static var fonts:Array;

	private var _id:String;
	private var _fontSrc:String;
	private var _importSrc:String;

	static function reset():Void
	{
		fonts=new Array();
	}
	
	static function addFont(id:String, fontSrc:String, importSrc:String):Font
	{
		var font:Font = new Font(id, fontSrc, importSrc);
		if (fonts==null) fonts = new Array();
		fonts.push( font );
		return font;
	}
	
	static function getFont(id:String):Font
	{
		if (fonts!=null) for (var i : Number = fonts.length-1; i >= 0; i--) if (Font(fonts[i]).id==id) return Font(fonts[i]);
		return null;
	}
	
	static function getFonts():Array
	{
		return fonts;
	}
	
	public function Font( id:String, fontSrc:String, importSrc:String )
	{
		_id=id;
		_fontSrc=fontSrc;		_importSrc=importSrc;
	}
	
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }

	public function get fontSrc():String { return _fontSrc; }
	public function set fontSrc(value:String):Void { _fontSrc=value; }

	public function get importSrc():String { return _importSrc; }
	public function set importSrc(value:String):Void { _importSrc=value; }
}