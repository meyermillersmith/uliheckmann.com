/**
	Base class that contains the EventDispatcher mix-in and initialization.
*/

// macromedia classes
import mx.events.EventDispatcher;

class com.mdv.events.Dispatcher {
	
	// mix-in EventDispatcher
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	public function Dispatcher () {
		
		// initialize EventDispatcher
		EventDispatcher.initialize(this);
	}
}
