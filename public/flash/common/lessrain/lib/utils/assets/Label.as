/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.Label
{
	private static var labels:Array;

	private var _id:String;
	private var _value:String;

	static function reset():Void
	{
		labels=new Array();
	}
	
	static function addLabel(id:String, value:String):Void
	{
		if (labels==null) labels = new Array();
		labels.push( new Label(id, value) );
	}
	
	static function getLabel(id:String):String
	{
		if (labels!=null) for (var i : Number = labels.length-1; i >= 0; i--) if (Label(labels[i]).id==id) return Label(labels[i]).value;
		return "";
	}
	
	public function Label( id:String, value:String )
	{
		_id=id;
		_value=value;
	}
	
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }

	public function get value():String { return _value; }
	public function set value(value:String):Void { _value=value; }
}