/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */


import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.tween.FramePulse;

class lessrain.lib.utils.tween.FramePulseEvent  implements IEvent
{
	private var _source:FramePulse;
	private var _type:String;
	
	public static var ENTERFRAME:String = "enterFrame";

	public function FramePulseEvent ( type_:String, source_:FramePulse) 
	{
		_type = type_;
		_source = source_;
	}
	
	public function getType() : String {return _type;}
	public function getFramePulse() : FramePulse {return _source;}

}