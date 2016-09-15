import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.text.ExtendedStyleSheet;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.StyleSheet
{
	private static var styleSheets:Array;

	private var _id:String;
	private var _src:String;
	private var _styleSheet:TextField.StyleSheet;

	static function reset():Void
	{
		styleSheets=new Array();
	}
	
	static function addStyleSheet(id:String, src:String):StyleSheet
	{
		var styleSheet:StyleSheet = new StyleSheet(id, src);
		if (styleSheets==null) styleSheets = new Array();
		styleSheets.push( styleSheet );
		return styleSheet;
	}
	
	static function getStyleSheet(id:String):TextField.StyleSheet
	{
		if (styleSheets!=null) for (var i : Number = styleSheets.length-1; i >= 0; i--) if (StyleSheet(styleSheets[i]).id==id) return StyleSheet(styleSheets[i]).styleSheetObject;
		return null;
	}
	
	public function StyleSheet( id:String, src:String)
	{
		_id=id;
		_src = src;
		_styleSheet=new ExtendedStyleSheet();
	}
	
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }

	public function get src():String { return _src; }
	public function set src(value:String):Void { _src=value; }

	public function get styleSheetObject():TextField.StyleSheet { return _styleSheet; }
	public function set styleSheetObject(value:TextField.StyleSheet):Void { _styleSheet=value; }
}