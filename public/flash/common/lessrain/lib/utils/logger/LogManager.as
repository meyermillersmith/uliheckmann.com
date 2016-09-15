import mx.utils.Delegate;

import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.logger.BaseLogger;
import lessrain.lib.utils.logger.ILogger;
import lessrain.lib.utils.logger.LogLevel;

/**
 * Class LogManager
 * Different ILogger instances can be added to the LogManager
 *
 * @author	oliver list (o.list@lessrain.com)
 *
 */
class lessrain.lib.utils.logger.LogManager {

	private static var instance:LogManager;
	private static var hasLogger:Boolean = false;
	
	private var loggerList:Array;
	
	/**
	 * Constructor
	 */
	private function LogManager() {
		loggerList = new Array();
	}

	/**
	 * Get an instance of the LogManager (Singleton).
	 *
	 * @return  An instance of the LogManager class.
	 */
	public static function getInstance():LogManager {
		if(instance == undefined) {
			instance = new LogManager();
		}
		return instance;
	}

	/**
	 * Add a logger to the list of loggers that should be informed of every log.
	 *
	 * @param   logger The logger that should be added to the list.
	 * @return
	 */
	public function addLogger(logger:ILogger):Boolean {
		// check if the logger has already been added to the logger list
		if(ArrayUtils.contains(loggerList, logger)) {
			return false;
		}
		hasLogger = true;
		loggerList.push(logger);
		return true;
	}

	/**
	 * Remove the logger that should no longer be informed of every log from
	 * the logger list.
	 *
	 * @param   logger
	 * @return
	 */
	public function removeLogger(logger:ILogger):Boolean {
		// check if the logger list contains the logger instance to be removed
		if(!ArrayUtils.contains(loggerList, logger)) {
			return false;
		}

		ArrayUtils.removeElement(loggerList, logger);
	}

	/**
	 * Send log message and level to all registered loggers.
	 *
	 * @param   msg   The message that should be logged.
	 * @param   level The message log level.
	 */
	private function broadcastLog(msg:Object, level:LogLevel):Void {
		for(var i:Number = 0; i < loggerList.length; i++) {
			var logger:ILogger = ILogger(loggerList[i]);
			logger.writeToConsole(msg.toString(), level);
		}
	}

	private function _inspectObject(obj:Object, level:LogLevel, msg:String):Void {
		for(var i:Number = 0; i < loggerList.length; i++) {
			var logger:BaseLogger = BaseLogger(loggerList[i]);
			logger.inspectObject(obj, level, msg);
		}
	}
	
	public static function watch(scope:Object, value:String):Void {
		if(typeof(scope[value]) == "object") {
			error("Unable to perform watch() on Objects.");
			return;
		}
		debug("Added \"" + value + "\" to watchlist");
		scope.watch(value, Delegate.create(LogManager, onValueChange)); 
	}

	public static function debug(msg:Object):Void {
		if(hasLogger) getInstance().broadcastLog(msg, LogLevel.DEBUG);
	}

	public static function info(msg:Object):Void {
		if(hasLogger) getInstance().broadcastLog(msg, LogLevel.INFO);
	}

	public static function warning(msg:Object):Void {
		if(hasLogger) getInstance().broadcastLog(msg, LogLevel.WARNING);
	}

	public static function error(msg:Object):Void {
		if(hasLogger) getInstance().broadcastLog(msg, LogLevel.ERROR);
	}

	public static function inspectObject(obj:Object, level:LogLevel, msg:String):Void {
		if(hasLogger) getInstance()._inspectObject(obj, (level == null ? (LogLevel.DEBUG) : level), msg);
	}
	
	private static function onValueChange(prop:String, oldval:Object, newval:Object):Object {
		debug(prop + " = " + newval + " (Watch)");
		return newval;
	}
}