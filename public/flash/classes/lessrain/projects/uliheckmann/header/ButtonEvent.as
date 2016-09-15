import lessrain.lib.utils.events.IEvent;
import lessrain.projects.uliheckmann.header.HeaderButton;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.header.ButtonEvent implements IEvent
{
	public static var RELEASE:String = "release";	
	private var _type : String;
	private var _button : HeaderButton;
	
	public function ButtonEvent(type_:String, button_:HeaderButton)
	{
		_type = type_;
		_button=button_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getButton() : HeaderButton
	{
		return _button;
	}
}