import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.Map;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.utils.KeyManager {
	
	// Listen to all keys
	public static var ALL_KEYS			: Number = 0;

	private static var _upListeners		: Map;
	private static var _downListeners	: Map;
	
	private static var _initialized		: Boolean = false;

	/**
	 * Register a KeyDown listener.
	 * @param	code_		key code to listen to
	 * @param	listener_	Function to be called when the key is pressed
	 * @return				key code that has been registered or -1 if the
	 * 						listener has not been added
	 */	
	public static function addDownListener(code_:Number, listener_:Function, overwriteExisting_:Boolean):Number {
		if(!_initialized) {
			initialize();
		}
		if(listener_ == null) {
			LogManager.error("addDownListener: listener is not set");
			return -1;
		}
		
		// check is anyone is already listening
		// TODO implement overwriteExisting_
//		LogManager.debug("addDownListener: (" + code_ + ")");
		if(_downListeners.containsKey(code_)) {
			LogManager.warning("addDownListener: Someone is already listening for the code " + code_);
			return -1;
		}
		_downListeners.putAt(code_, listener_);
		return code_;
	}
	
	/**
	 * Register a KeyUp listener
	 * @param	code_		key code to listen to
	 * @param	listener_	Function to be called when the key is pressed
	 * @return				key code that has been registered or -1 if the
	 * 						listener has not been added
	 */
	public static function addUpListener(code_:Number, listener_:Function, overwriteExisting_:Boolean):Number {
		if(!_initialized) {
			initialize();
		}
		if(listener_ == null) {
			LogManager.error("addUpListener: listener is not set");
			return -1;
		}
		
		// check is anyone is already listening
		// TODO implement overwriteExisting_
//		LogManager.debug("addUpListener: (" + code_ + ")");
		if(_upListeners.containsKey(code_)) {
			LogManager.warning("addUpListener: Someone is already listening for the code " + code_);
			return -1;
		}
		_upListeners.putAt(code_, listener_);
		return code_;
	}
	
	/**
	 * Remove a KeyDown listener
	 * @param	code_		Key code that should no longer be listened to
	 */
	public static function removeDownListener(code_:Number):Void {
		_downListeners.removeAt(code_);
	}
	
	/**
	 * Remove a KeyUp listener
	 * @param	code		Key code that should no longer be listened to
	 */
	public static function removeUpListener(code_:Number):Void {
		_upListeners.removeAt(code_);
	}
	
	/**
	 * Key listener
	 */
	public static function onKeyDown():Void {
		// is there a listener for all keys?
		var listenerAll:Function = Function(_downListeners.getAt(0));
		if(listenerAll != null) {
			listenerAll.apply();
		}
		var key:Number = Key.getCode();
		var listenerKey:Function = Function(_downListeners.getAt(key));
		if(listenerKey != null) {
			listenerKey.apply();
		}
	}
	
	/**
	 * Key listener
	 */
	public static function onKeyUp():Void {
		// is there a listener for all keys?
		var listenerAll:Function = Function(_upListeners.getAt(0));
		if(listenerAll != null) {
			listenerAll.apply();
		}
		var key:Number = Key.getCode();
		var listenerKey:Function = Function(_upListeners.getAt(key));
		if(listenerKey != null) {
			listenerKey.apply();
		}
	}
	
	/**
	 * Get the key code of a given object that can be either a number, then the
	 * number is considered as the key code or a character, then the key code of
	 * the uppercase key is detected. If a string is passed, only the first
	 * character is used.
	 * 
	 * @param	key_	Key object
	 * @return			key code
	 */
	public static function keyToCode(key_:Object):Number {
		var code:Number;
		switch (typeof(key_)){
			case "number":
				code = Number(key_);
				break;
			case "string":
				code = key_.toUpperCase().charCodeAt(0);
				break;
			default:
				code = ALL_KEYS;
				break;
		}
		return code;
	}
	
	private static function initialize():Void {
		if(_initialized) {
			return;
		}
		Key.addListener(KeyManager);
		_upListeners = new Map();
		_downListeners = new Map();
		_initialized = true;
	}
}