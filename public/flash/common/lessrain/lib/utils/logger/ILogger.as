import lessrain.lib.utils.logger.LogLevel;
/**
 * Interface ILogger
 * Declare the different logging methods
 *
 * @author	oliver list (o.list@lessrain.com)
 *
 */

interface lessrain.lib.utils.logger.ILogger {

	/**
	 * General logging method.
	 *
	 * @param   msg   The message that should be logged.
	 * @param   level The message's log level.
	 */
	public function writeToConsole(msg:String, level:LogLevel):Void;
}