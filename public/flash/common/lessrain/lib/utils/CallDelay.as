import mx.utils.Delegate;
/**
 * CallDelay can be used to trigger a method after a certain amount of time.
 * <p>Usage:
 * <pre>var call:CallDelay = CallDelay.call(Proxy.create(this, myMethod), 1000); // call myMethod with one second delay</pre>
 *  
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.utils.CallDelay {
	
	private var _int:Number;
	private var _rt:Number;
	private var _rc:Number;
	private var _callback:Function;
	private var _delay:Number;
	
	private function CallDelay() {
	}
	
	/**
	 * Trigger delayed method call
	 * @param	callback_		Method to be called
	 * @param	delay_			Delay [ms]
	 * @param	repetitions_	Number of repetitions (optional)
	 * @return					The call instance
	 */
	public static function call(callback_:Function, delay_:Number, repetitions_:Number):CallDelay {
		var instance:CallDelay = new CallDelay();
		instance._rt = repetitions_ || 1;
		instance._rc = 0;
		instance._callback = callback_;
		instance._delay = delay_;
		instance._int = setInterval(Delegate.create(instance, instance.doCall), instance._delay);
		return instance;
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		clearInterval(_int);
		delete _int;
		delete _callback;
	}
	
	/**
	 * Stop the pending call
	 */
	public function clear():Void {
		finalize();
	}
	
	/**
	 * Check if a call is still pending
	 * @return	<code>true</code> if the call is still pending
	 */
	public function isBusy():Boolean {
		return _int != null;
	}
	
	private function doCall():Void {
		_callback.apply();
		if(++_rc >= _rt) {
			finalize();
		}
	}
}