/**
 * Class LogLevel
 *
 * @author	oliver list (o.list@lessrain.com)
 *
 */
class lessrain.lib.utils.logger.LogLevel {

	/**
	 * Level "debug" (lowest debug level)
	 */
	public static var DEBUG:LogLevel = new LogLevel(1 << 1);

	/**
	 * Level "info"
	 */
	public static var INFO:LogLevel = new LogLevel(1 << 2);

	/**
	 * Level "warning"
	 */
	public static var WARNING:LogLevel = new LogLevel(1 << 3);

	/**
	 * Level "error"
	 */
	public static var ERROR:LogLevel = new LogLevel(1 << 4);
	
	private var level:Number;
	
	/**
	 * Get the log level's name
	 */
	public function getName():String {
		var out:String;
		switch(level) {
			case DEBUG.level:
			default:
				out = "DEBUG";
				break;
			case INFO.level:
				out = "INFO";
				break;
			case WARNING.level:
				out = "WARNING";
				break;
			case ERROR.level:
				out = "ERROR";
				break;
		}
		return out;
	}
	
	/**
	 * Constructor
	 */
	private function LogLevel(level:Number) {
		this.level = level;		
	}
}