import mx.events.EventDispatcher;

class lessrain.lib.utils.events.Dispatcher {
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	public function Dispatcher () 
	{
		EventDispatcher.initialize(this);
	}
}