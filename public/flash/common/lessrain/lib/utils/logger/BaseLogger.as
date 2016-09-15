import lessrain.lib.utils.logger.ILogger;
import lessrain.lib.utils.logger.LogLevel;
import lessrain.lib.utils.StringUtils;

/**
 * Class LoggerAdapter
 * The base implementation for Loggers.
 *
 * @author	oliver list (o.list@lessrain.com)
 *
 */
class lessrain.lib.utils.logger.BaseLogger implements ILogger {

	// string that will be used as the line delimiter
	public var lineBreak:String;

	// the nesting depth when inspecting objects
	public var nesting:Number;
	
	/**
	 * The constructor
	 */
	public function BaseLogger() {
		lineBreak = "\n";
		nesting = 5;
	}
	
	/**
	 * @see ILogger#writeToConsole
	 */
	public function writeToConsole(msg : String, level : LogLevel) : Void {
	}

	/**
	 * Inspect an object
	 * The object information will be logged at the lowest log level.
	 *
	 * @param obj	The Object that will be inspected
	 * @param level	The message's log level
	 * @param msg	An additional log message
	 */
	public function inspectObject(obj:Object, level:LogLevel, msg:String):Void {
		var lines:Array = getObjectDetails(obj);
		
		if(msg != undefined) {
			lines.unshift(msg);
		}
		
		var output:String = lines.join(lineBreak);
		writeToConsole(output, level);
	}
	
	
	public function setNesting(nesting:Number):Void {
		if(nesting > 0) {
			this.nesting = nesting;
		} else {
			writeToConsole("Invalid value for nesting depth: " + nesting.toString(), LogLevel.WARNING);
		}
	}

	public function getNesting():Number {
		return nesting;
	}
	
	static function getTimestamp():String {
		var date:Date = new Date();
		var h:String = StringUtils.padString(date.getHours().toString(), 2, "0");
		var m:String = StringUtils.padString(date.getMinutes().toString(), 2, "0");
		var s:String = StringUtils.padString(date.getSeconds().toString(), 2, "0");
		var ms:String = StringUtils.padString(date.getMilliseconds().toString(), 3, "0");
		return (h + ":" + m + ":" + s + ":" + ms);
	}
	
	private function getObjectDetails(obj:Object):Array {
		var indentLevel:Number = -1;
		var indentString:String = "                                                                                      ";
		var indentElements:Number = 0;

		//  array of output lines
		var lines:Array = new Array();
		
		var ref:BaseLogger = this;
		
		// function that is called recursively
		var _inspectLevel:Function = function(id: String, localObj:Object):Void {
			indentLevel++;
			
			if(indentLevel <= ref.nesting) {
				indentElements = 0;
				var type_str:String = typeof(localObj);
				if(type_str == "number" || type_str == "integer" || type_str == "string" || type_str == "boolean") {
					lines.push(indentString.substr(0, indentLevel * 2) + id + ": " + localObj + " (" + typeof(localObj) + ")");
				} else if(type_str == "object" || type_str == "movieclip") {
					lines.push(indentString.substr(0, indentLevel * 2) + id + " (" + typeof(localObj) + ")");
					for(var subId:String in localObj) {
						arguments.callee(subId, localObj[subId]);
					}
				} else if(type_str == "function") {
					lines.push(indentString.substr(0, indentLevel * 2) + id + " (" + typeof(localObj) + ")");
				}
				indentLevel--;
			} else {
				//show Message for only one sub-object
				if(indentElements == 0)
				{
					indentElements = lines.push(indentString.substr(0, indentLevel * 2) + ("NESTING TOO DEEP - NESTING:" + ref.nesting));
				}
				//go one Level up and proceed
				indentLevel--;
			}
		};

		if(obj != undefined) {
			for(var mainId:String in obj) {
				_inspectLevel(mainId, obj[mainId]);
			}
		} else {
			lines.push("UNDEFINED");
		}
		
		return lines;
	}

}