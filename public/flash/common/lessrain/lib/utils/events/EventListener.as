/**
* @author max kugland
*/

/**
* Event is used by EventDistributor to keep track of the events
* EventDistributor manages.
*/
class lessrain.lib.utils.events.EventListener
{
	private var _type : String;
	private var _func : Function;

	public function EventListener(type:String,func:Function)
	{
		_type=type;
		_func=func;
	}
	
	public function finalize() :Void
	{
		delete _type;		delete _func;	}
	
	public function getType() :String { return _type; }	public function getFunction() :Function { return _func; }}