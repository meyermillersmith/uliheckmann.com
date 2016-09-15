
/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
 
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.tween.ITween;

class lessrain.lib.utils.tween.TweenEvent implements IEvent
{
	private var _source:ITween;
	private var _type:String;
	
	// possible values  for 'type'
	public static var TWEEN_START:String = "tweenStart";
	public static var TWEEN_PROGRESS:String = "tweenProgress";
	public static var TWEEN_COMPLETE:String = "tweenComplete";
	
	public function TweenEvent ( type_:String, source_:ITween) 
	{
		_type = type_;
		_source = source_;
	}
	
	public function getType() : String {return _type;}
	public function getTween() : ITween {return _source;}

}