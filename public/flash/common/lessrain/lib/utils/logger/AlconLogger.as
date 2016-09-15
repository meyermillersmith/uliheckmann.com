import lessrain.lib.utils.logger.BaseLogger;
import lessrain.lib.utils.logger.LogLevel;

import net.hiddenresource.util.debug.Debug;

/**
 * AlconLogger
 * Logger class that uses Alcon (Actionscript Logging Console) to display the
 * log messages
 * Communication via LocalConnection
 *
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.utils.logger.AlconLogger extends BaseLogger {

	public function AlconLogger() {
		super();
		Debug.clear();
	}

	/**
	 * @see ILogger.log
	 */
	public function writeToConsole(msg:String, level:LogLevel) {
		Debug.trace("(" + BaseLogger.getTimestamp() + ") " + msg, false, mapLogLevelToKey(level));
	}
	
	private function mapLogLevelToKey(level:LogLevel):Number {
		var errorLevel:Number;
		// map level to alcon level
		switch(level) {
			case LogLevel.DEBUG:
			default:
				errorLevel = 0;
				break;
			case LogLevel.INFO:
				errorLevel = 1;
				break;
			case LogLevel.WARNING:
				errorLevel = 2;
				break;
			case LogLevel.ERROR:
				errorLevel = 3;
				break;
		}
		return errorLevel;
	}
	
	/**
	 * @see BaseLogger#inspectObject
	 */
	public function inspectObject(obj:Object, level:LogLevel, msg:String):Void {
		var lines:Array = getObjectDetails(obj);
		
		// build message 
		writeToConsole(msg, level);
		
		Debug.setRecursionDepth(getNesting());
		Debug.trace(obj, true, mapLogLevelToKey(level));
	}

}