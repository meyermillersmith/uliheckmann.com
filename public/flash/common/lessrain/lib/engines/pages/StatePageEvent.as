/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import lessrain.lib.utils.events.IEvent;

class lessrain.lib.engines.pages.StatePageEvent implements IEvent 
{
	public static var CHANGE	:	String = 'statePageChange';
	private var _type 			: 	String;
	
	public function StatePageEvent(type_:String, pageID_:String)
	{
		_type 	= type_;
	}
	public function getType() 	: String { return _type;}
}