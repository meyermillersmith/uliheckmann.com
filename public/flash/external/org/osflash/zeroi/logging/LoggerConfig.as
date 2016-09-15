import org.osflash.zeroi.logging.LogLevel;
import org.osflash.zeroi.logging.publisher.SOSPublisher;
import org.osflash.zeroi.util.XMLUtils;
/**
 * @author Soenke Rohde <mail at soenkerohde dot com>
 * @license LGPL
 */
class org.osflash.zeroi.logging.LoggerConfig {
	
	private static var completeFunc:Function;
	
	private static var DEFAULT:LogLevel;
	private static var logs:Array;
	
	private static var initComplete:Boolean;
	
	private function LoggerConfig() {
		
	}
	
	public static function isInitialized(Void):Boolean{
		return logs != null;
	}
	
	public static function init(xmlURI:String, completeFunc:Function):Void{
		LoggerConfig.completeFunc = completeFunc;
		LoggerConfig.logs = new Array();
		
		XMLUtils.loadXML(xmlURI, LoggerConfig, onXML);
	}
	
	private static function onXML(b:Boolean, x:XML):Void{
		LoggerConfig.DEFAULT = LogLevel.getLevelByName(XMLUtils.byName(x, "logger").attributes.level);
		trace("i default " + LoggerConfig.DEFAULT);
		
		var logNode:XMLNode = XMLUtils.byName(x, "log");
		while(logNode){
			logs[logNode.attributes.target] = LogLevel.getLevelByName(logNode.attributes.level);
			logNode = logNode.nextSibling;
		}
		LoggerConfig.initComplete = true;
		LoggerConfig.completeFunc(b);
	}
	
	public static function getLogLevel(fullpath:String):LogLevel{
		//SOSPublisher.instance.publish("ERROR", "getLogLevel " + fullpath);
		if(!initComplete){
			return LogLevel.INFO;
		}
		var log:LogLevel = logs[fullpath];
		if(log != undefined){
			//SOSPublisher.instance.publish("WARNING", "got " + log + " for " + fullpath);
			return log;
		}else{
			var splitted:Array = fullpath.split(".");
			//SOSPublisher.instance.publish("ERROR", splitted.toString());
			if(splitted.length > 1){
				//SOSPublisher.instance.publish("ERROR", "splitted l " + splitted.length.toString());
				var newpath:String = new String();
				for(var i:Number=0;i<splitted.length-1;i++){
					newpath += splitted[i];
					//SOSPublisher.instance.publish("TEMP", "newpath " + newpath);
					if(i < splitted.length-2){
						newpath += ".";
					}
				}
				return getLogLevel(newpath);
			}
		}
		
		return LoggerConfig.DEFAULT;
	}
	
	public static function getDefaultLogLevel(Void):LogLevel{
		return 	LoggerConfig.DEFAULT;
	}
	
}