import lessrain.lib.utils.events.IEvent;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.effects.LetterEvent implements IEvent
{
	public static var STATE_CHANGE:String = "stateChange";
	public static var STATE_COMPLETE:String = "stateComplete";
	
	private var _type : String;
	
	public function LetterEvent(type_:String)
	{
		_type = type_;
	}
	
	public function getType() : String
	{
		return _type;
	}
}