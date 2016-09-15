import lessrain.lib.utils.logger.BaseLogger;
import lessrain.lib.utils.logger.LogLevel;
import lessrain.lib.utils.logger.Tracer;
import lessrain.lib.utils.StringUtils;
/**
 * Class Tracer
 * Implement a simple logger that uses trace() to display messages and
 * additionally traces the time when the log was triggered.
 *
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.utils.logger.TimestampTracer extends Tracer {

	/**
	 * @see BaseLogger#writeToConsole
	 */
	public function writeToConsole(msg:String, level:LogLevel):Void {
		trace("(" + BaseLogger.getTimestamp() + ")" + StringUtils.padString(level.getName(), 10, " ", StringUtils.RIGHT) + msg);
	}

}