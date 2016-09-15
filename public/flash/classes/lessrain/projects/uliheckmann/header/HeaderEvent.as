import lessrain.lib.utils.events.IEvent;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.header.HeaderEvent implements IEvent
{
	public static var TOGGLE_MENU:String = "toggleMenu";
	public static var TOGGLE_SUB_MENU:String = "toggleSubMenu";	public static var TOGGLE_SLIDESHOW:String = "toggleSlideshow";
	
	private var _type : String;
	
	public function HeaderEvent(type_:String)
	{
		_type = type_;
	}
	
	public function getType() : String
	{
		return _type;
	}
}