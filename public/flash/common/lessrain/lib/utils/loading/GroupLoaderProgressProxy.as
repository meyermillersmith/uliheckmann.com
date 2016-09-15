import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.loading.GroupListener;
import lessrain.lib.utils.events.EventDistributor;
import mx.events.EventDispatcher;
import lessrain.lib.utils.loading.GroupLoaderEvent;
import lessrain.lib.utils.loading.GroupLoader;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.loading.GroupLoaderProgressProxy implements GroupListener, IDistributor
{
	private static var instance : GroupLoaderProgressProxy;
	
	/**
	 * @return singleton instance of PriorityLoader
	 */
	public static function getInstance() : GroupLoaderProgressProxy
	{
		if (instance == null) instance = new GroupLoaderProgressProxy();
		return instance;
	}
	
	
	private var _eventDistributor : EventDistributor;
	private var _event : GroupLoaderEvent;
	
	private function GroupLoaderProgressProxy()
	{
		_eventDistributor = new EventDistributor();
		_event = new GroupLoaderEvent();
	}

	public function onGroupStart(groupLoader:GroupLoader) : Void
	{
		_event.setType(GroupLoaderEvent.GROUP_START);
		_event.description=groupLoader.description;
		distributeEvent(_event);
	}

	public function onGroupComplete(groupLoader:GroupLoader) : Void
	{
		_event.setType(GroupLoaderEvent.GROUP_COMPLETE);
		_event.description=groupLoader.description;
		distributeEvent(_event);
	}

	public function onGroupProgress(filesLoaded : Number, filesTotal : Number, bytesLoaded : Number, bytesTotal : Number, percent : Number, groupLoader:GroupLoader) : Void
	{
		_event.setType(GroupLoaderEvent.GROUP_PROGRESS);
		_event.filesLoaded = filesLoaded;		_event.filesTotal = filesTotal;		_event.bytesLoaded = bytesLoaded;		_event.bytesTotal = bytesTotal;		_event.percent = percent;		_event.description = groupLoader.description;
		distributeEvent(_event);
	}
	
	public function addEventListener(type : String, func : Function) : Void
	{
		_eventDistributor.addEventListener(type,func);
	}

	public function removeEventListener(type : String, func : Function) : Void
	{
		_eventDistributor.removeEventListener(type,func);
	}

	public function distributeEvent(eventObject : IEvent) : Void
	{
		_eventDistributor.distributeEvent(eventObject);
	}

}