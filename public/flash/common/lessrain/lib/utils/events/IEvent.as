/**
* @author max kugland
*/

/**
* EventDistributor only dispatches event objects which implement IEvent.
* So the event receiving functions in the class which uses EventDistributor
* receive an IEvent object.
*/
interface lessrain.lib.utils.events.IEvent
{
	public function getType() :String;
}