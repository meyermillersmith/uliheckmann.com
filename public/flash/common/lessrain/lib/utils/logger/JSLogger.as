import lessrain.lib.utils.logger.BaseLogger;
import lessrain.lib.utils.logger.LogLevel;
/**
 * JSLogger
 * Logger class that displays the log messages in an external browser window.
 * Communication via JavaScript.
 *
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.utils.logger.JSLogger extends BaseLogger {

	/**
	 * @see ILogger.log
	 */
	public function writeToConsole(msg:String, level:LogLevel) {
		var jsLevel:String;
		// map level to js logger class
		switch(level) {
			case LogLevel.DEBUG:
				jsLevel = "debug";
				break;
			case LogLevel.INFO:
				jsLevel = "info";
				break;
			case LogLevel.WARNING:
				jsLevel = "warn";
				break;
			case LogLevel.ERROR:
				jsLevel = "error";
				break;
		}
		getURL("javascript:jslog('" + msg + "', '" + jsLevel + "')");
	}

	public function inspectObject(obj:Object, level:LogLevel, msg:String):Void {
		lineBreak = "<br/>";
		super.inspectObject(obj, level, msg);
	}

}