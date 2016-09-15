/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.Link
{
	private static var links:Array;

	private var _id:String;
	private var _href:String;
	private var _target:String;
	private var _title:String;

	static function reset():Void
	{
		links=new Array();
	}
	
	static function addLink( id:String, href:String, target:String, title:String ):Void
	{
		if (links==null) links = new Array();
		links.push( new Link(id, href, target, title) );
	}
	
	static function getLink(id:String):Link
	{
		if (links!=null) for (var i : Number = links.length-1; i >= 0; i--) if (Link(links[i]).id==id) return Link(links[i]);
		return null;
	}
	
	public function Link( id:String, href:String, target:String, title:String )
	{
		_id=id;
		_href=href;
		_target=target;
		_title=title;
	}
	
	public function get id():String { return _id; }
	public function set id(title:String):Void { _id=title; }

	public function get href():String { return _href; }
	public function set href(title:String):Void { _href=title; }

	public function get target():String { return _target; }
	public function set target(title:String):Void { _target=title; }

	public function get title():String { return _title; }
	public function set title(title:String):Void { _title=title; }
}