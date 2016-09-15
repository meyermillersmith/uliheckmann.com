import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.effects.WordEvent implements IEvent
{
	public static var STATE_CHANGE:String = "stateChange";
	public static var STATE_COMPLETE:String = "stateComplete";
	
	private var _type : String;
	private var _source : IDistributor;
	
	public function WordEvent(type_:String, source_:IDistributor)
	{
		_type = type_;
		_source = source_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getSource() : IDistributor
	{
		return _source;
	}
}