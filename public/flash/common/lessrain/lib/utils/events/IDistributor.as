import lessrain.lib.utils.events.IEvent;
/**
* @author max kugland
*/

/**
* Interface which must be implemented by any class which wants to 
* use EventDistributor for distributing events.
*/
interface lessrain.lib.utils.events.IDistributor 
{
	public function addEventListener(type:String,func:Function) :Void;
	public function removeEventListener(type:String,func:Function) :Void;
	public function distributeEvent(eventObject:IEvent) :Void;
}