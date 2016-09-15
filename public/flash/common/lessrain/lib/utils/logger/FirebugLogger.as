import lessrain.lib.utils.logger.BaseLogger;import flash.external.ExternalInterface;
import lessrain.lib.utils.logger.LogLevel;class lessrain.lib.utils.logger.FirebugLogger extends BaseLogger
{
		
		public function FirebugLogger() {
			super();
		}
		
		/**
		 * @see ILogger#writeToConsole
		 */
		public function writeToConsole(msg:String, level:LogLevel):Void {
			// build message
			var out:String = "(" + BaseLogger.getTimestamp() + ")\t" + msg;
			var f:String = "console." + mapLogLevelToKey(level);
			ExternalInterface.call(f, out);
		}
		
		/**
		 * @see BaseLogger#inspectObject
		 */
		public function inspectObject(obj:Object, level:LogLevel, msg:String):Void {
			ExternalInterface.call("console." + mapLogLevelToKey(level), "(" + BaseLogger.getTimestamp() + ")\t" + (msg != null ? msg : "No message"));
			ExternalInterface.call("console.dir", obj);
		}
		
		private function mapLogLevelToKey(level:LogLevel):String {
			var errorLevel:String;
			// map level to logger output
			switch(level) {
				case LogLevel.DEBUG:
				default:
					errorLevel = "debug";
					break;
				case LogLevel.INFO:
					errorLevel = "info";
					break;
				case LogLevel.WARNING:
					errorLevel = "warn";
					break;
				case LogLevel.ERROR:
					errorLevel = "error";
					break;
			}
			return errorLevel;
		}
		
}