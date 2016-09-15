import lessrain.lib.utils.logger.BaseLogger;
import lessrain.lib.utils.logger.LogLevel;
import lessrain.lib.utils.StringUtils;

/**
 * Class Tracer
 * Implement a simple logger that uses trace() to display messages.
 *
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.utils.logger.Tracer extends BaseLogger {

	/**
	 * @see BaseLogger#writeToConsole
	 */
	public function writeToConsole(msg:String, level:LogLevel):Void {
//		trace(StringUtils.padString(getLogLevelName(level), 10, " ", StringUtils.RIGHT) + msg);		trace(StringUtils.padString(level.getName(), 10, " ", StringUtils.RIGHT) + msg);
	}
}
