import lessrain.lib.utils.events.IEvent;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.core.DimEvent implements IEvent
{
	public static var NORMAL:String = "normal";	public static var DIMMED:String = "dimmed";
	public static var HIDE_SUB_NAV:String = "hideSubNav";
	
	private var _type : String;	
	public function DimEvent(type_:String)
	{
		_type = type_;
	}
	
	public function getType() : String
	{
		return _type;
	}
}