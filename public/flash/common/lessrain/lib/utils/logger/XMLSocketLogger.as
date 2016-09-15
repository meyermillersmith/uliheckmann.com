import lessrain.lib.utils.logger.BaseLogger;
import lessrain.lib.utils.logger.LogLevel;
import lessrain.lib.utils.StringUtils;
/**
 * XMLSocketLogger
 *
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.utils.logger.XMLSocketLogger extends BaseLogger {
	
	private var socket:XMLSocket;

	public function XMLSocketLogger(host:String, port:Number) {
		super();
		connectSOS(host, port);
	}

	/**
	 * @see ILogger#writeToConsole
	 */
	public function writeToConsole(msg:String, level:LogLevel):Void {
		// build message 
		var out:String = "(" + BaseLogger.getTimestamp() + ") " + StringUtils.padString(level.getName(), 10, " ", StringUtils.RIGHT) + msg;
		
		// assemble xml
		var doc:XML = new XML();
		doc.contentType = "text/xml";
		var root:XMLNode = doc.createElement("showMessage");
		root.attributes.key = mapLogLevelToKey(level);
		root.appendChild(doc.createTextNode(out));
		doc.appendChild(root);
		
		// send xml
		socket.send(doc);
	}
	
	/**
	 * @see BaseLogger#inspectObject
	 */
	public function inspectObject(obj:Object, level:LogLevel, msg:String):Void {
		var lines:Array = getObjectDetails(obj);
		
		// build message 
		var headline:String = "(" + BaseLogger.getTimestamp() + ") " + StringUtils.padString(level.getName(), 10, " ", StringUtils.RIGHT) + ">> " + obj.toString() + " (" + typeof obj + ")";
		
		// assemble xml
		var doc:XML = new XML();
		doc.contentType = "text/xml";
		var root:XMLNode = doc.createElement("showFoldMessage");
		root.attributes.key = mapLogLevelToKey(level);
		var title:XMLNode = doc.createElement("title");
		title.appendChild(doc.createTextNode(headline));
		root.appendChild(title);
		var message:XMLNode = doc.createElement("message");
		message.appendChild(doc.createTextNode(lines.join(lineBreak)));
		root.appendChild(message);
		doc.appendChild(root);
		
		// send xml
		socket.send(doc);
	}
	
	private function connectSOS(host:String, port:Number):Void
	{
		socket = new XMLSocket();
		socket.connect(host, port);
		
		// clear
		socket.send("<clear/>\n");
		
		// identify
		socket.send("<appName>XMLSocketLogger</appName>\n");
		socket.send("<identify/>\n");
		
		// configure colors
		socket.send("<setKey><name>ERROR</name><color>"+0xFFCCCC+"</color></setKey>\n");		socket.send("<setKey><name>WARNING</name><color>"+0xFFFFCC+"</color></setKey>\n");		socket.send("<setKey><name>INFO</name><color>"+0xCCFFFF+"</color></setKey>\n");		socket.send("<setKey><name>DEBUG</name><color>"+0xFFFFFF+"</color></setKey>\n");
	}
	
	private function mapLogLevelToKey(level:LogLevel):String {
		var errorLevel:String;
		// map level to logger output
		switch(level) {
			case LogLevel.DEBUG:
			default:
				errorLevel = "DEBUG";
				break;
			case LogLevel.INFO:
				errorLevel = "INFO";
				break;
			case LogLevel.WARNING:
				errorLevel = "WARNING";
				break;
			case LogLevel.ERROR:
				errorLevel = "ERROR";
				break;
		}
		return errorLevel;
	}
}