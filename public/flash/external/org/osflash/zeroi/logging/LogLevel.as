/**
 * @author Soenke Rohde <mail at soenkerohde dot com>
 * @license LGPL
 */
class org.osflash.zeroi.logging.LogLevel {
	
	public static var DEBUG:LogLevel = new LogLevel(0);
	public static var INFO:LogLevel = new LogLevel(1);
	public static var WARN:LogLevel = new LogLevel(2);
	public static var ERROR:LogLevel = new LogLevel(3);
	public static var FATAL:LogLevel = new LogLevel(4);
	public static var TEMP:LogLevel = new LogLevel(5);	public static var OBJECT:LogLevel = new LogLevel(6);
	
	
	private var level:Number;
	public function LogLevel(level:Number) {
		this.level = level;
	}
	
	public static function getLevelByName(name:String):LogLevel{
		switch(name){
			case "DEBUG":
				return DEBUG;
			case "INFO":
				return INFO;
			case "WARN":
				return WARN;
			case "ERROR":
				return ERROR;
			case "FATAL":
				return FATAL;
			case "TEMP":
				return TEMP;
			case "OBJECT":
				return OBJECT;
			default: return TEMP;				
		}
		trace("e name not found " + name);
		return null;
	}
	
	public static function getNameByLevel(level:Number):String{
		switch(level){
			case 0:
				return "DEBUG";
			case 1:
				return "INFO";
			case 2:
				return "WARN";
			case 3:
				return "ERROR";
			case 4:
				return "FATAL";
			case 5:
				return "TEMP";
			case 6:
				return "OBJECT";
			default : return "TEMP";
		}
		trace("e level not found " + level);
		return null;
	}
	
	public static function getLevelByKey(key:String):LogLevel{
		switch(key){
			case "d":
				return DEBUG;
			case "i":
				return INFO;
			case "w":
				return WARN;
			case "e":
				return ERROR;
			case "f":
				return FATAL;
			case "t":
				return TEMP;
			case "o":
				return OBJECT;
		}
		trace("i key not found " + key);
		return DEBUG;
	}
	
	public function getLevel(Void):Number{
		return this.level;
	}
	
	
	public function toString() : String {
		return "[LogLevel level="+LogLevel.getNameByLevel(this.level) + "]";
	}
}