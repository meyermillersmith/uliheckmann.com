import mx.utils.Delegate;

import lessrain.lib.utils.events.EventListener;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
/**
 * @author max kugland
 */

/**
 * EventDistributor is a class to distribute events.
 */
class lessrain.lib.utils.events.EventDistributor implements IDistributor
{
	private var _eventListenersAr : Array;
	private var _implementer : IDistributor;
	
	public function EventDistributor()
	{
		_eventListenersAr=[];
	}
	
	/**
	* EventDistributor is a class to distribute events.
	* EventDistributor is glued on the class which would like to use EventDistributor
	* @param implementer a class which implements the IDistributor interface
	*/
	public function initialize(implementer:IDistributor) :Void
	{
		_implementer=implementer;		_implementer.addEventListener=Delegate.create(this,addEventListener);		_implementer.removeEventListener=Delegate.create(this,removeEventListener);
		_implementer.distributeEvent=Delegate.create(this,distributeEvent);
	}
	
	/**
	* adds an EventListener to the EventDistributor 
	* @param type the name of the event
	* @param func the function which is called when the event is fired 
	*/
	public function addEventListener(type:String,func:Function) :Void
	{
		if(!isInEventList(type,func))
			_eventListenersAr.push(new EventListener(type,func));
	}
	
	/**
	* removes an EventListener from the EventDistributor 
	* @param type the name of the event
	* @param func the function which is called when the event is fired 
	*/
	public function removeEventListener(type:String,func:Function) :Void
	{
		var pos:Number = getEventListenerPosition(type,func);
		if(pos != null) {
			EventListener(_eventListenersAr.splice(pos,1)[0]).finalize();
		}
	}
	
	/**
	* removes all EventListeners of a given type
	* if no type is passed all event listeners are removed 
	* @param type the name of the event
	*/
	public function removeEventListeners(type:String) :Void
	{
		var eventListener:EventListener;
		for (var i : Number = _eventListenersAr.length-1; i >= 0; i--)
		{
			eventListener = _eventListenersAr[i];
			if (type==null || eventListener.getType()==type)
			{
				eventListener.finalize();
				_eventListenersAr.splice(i,1);
			}
		}
	}
	
	/**
	* distributes an EventObject to specific Listeners of EventDistributor.
	* Which Listeners receive the event is decided via getType() method of the DistributorEvent.
	* Furthermore the DistributorEvent is distributed along with the IEvent implementing
	* eventObject to the listeners, too to provide an easy way to remove the listener.
	* @param eventObject must implement IEvent
	*/
	public function distributeEvent(eventObject:IEvent) :Void
	{
		var eventListeners:Array=getEventListeners(eventObject.getType());
		// make a copy to ensure the array doesn't change during distribution
		var eventListenersCopy:Array = eventListeners.slice(0);

		var i:Number=eventListenersCopy.length;
		while(--i>-1) 
			EventListener(eventListenersCopy[i]).getFunction()(eventObject,EventListener(eventListenersCopy[i]));
	}
	
	/**
	 * Returns whether the EventDistributor has any Listeners for the given event-type
	 * If no event type is passed the function returns true if there are any listeners at all registered.
	 * @param type Event type to check for. If no type is passed it checks if there are any listeners at all
	 */
	public function hasListeners(type:String):Boolean
	{
		if (type==null) return (_eventListenersAr.length>0);
		else
		{
			for (var i : Number = _eventListenersAr.length-1; i >= 0; i--)
			{
				if( EventListener(_eventListenersAr[i]).getType()==type) return true;
			}
		}
		return false;
	}
	
	public function getEventListeners(type:String) :Array
	{
		var eventListeners:Array=[];
		var o:EventListener;
		var i:Number=_eventListenersAr.length;		while(--i>-1)
		{
			o=_eventListenersAr[i];
			if(o.getType()==type) eventListeners.push(o);
		}
		
		return eventListeners;
	}
	
	private function getEventListenerPosition(type:String,func:Function) :Number
	{
		var ret:Number=null;
		var o:EventListener;
		var i:Number=_eventListenersAr.length;
		while(--i>-1)
		{
			o=EventListener(_eventListenersAr[i]);
			if(o.getFunction()===func&&o.getType()==type) {
				ret=i;
			}
		}
		return ret;
	}
	
	public function isInEventList(type:String,func:Function) :Boolean
	{
		return (getEventListenerPosition(type,func)!=null);
	}
	
	/**
	* when finalize() is invoked, all events are removed 
	* and EventDistributor will be destroyed completely. 
	*/
	public function finalize() :Void
	{
		var i:Number=_eventListenersAr.length;
		while(--i>-1) EventListener(_eventListenersAr.shift()).finalize();
		delete _eventListenersAr;
		delete _implementer;
	}
}