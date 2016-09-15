
import org.osflash.zeroi.logging.LoggerConfig;
import org.osflash.zeroi.logging.LogLevel;

/**
 * A Logger, which broadcasts its messages to all its listeners
 * Furthermore it is able to record the messages and replay them 
 * to a single listener instance.
 * 
 * @author Ralf Bokelberg <ralf.bokelberg@gmail.com>
 * @license LGPL
 * 
 */
class org.osflash.zeroi.logging.LoggerClass 
{
	
	private static var instance:LoggerClass;
	
	public static function getInstance():LoggerClass{
		if( instance == null){
			instance = new LoggerClass();
		}
		return instance;
	}
	
	public static function log(msg:String, method:String, file:String, lineNr:Number):Void{
		var logger:LoggerClass = getInstance();
		logger.doLog.apply( logger, arguments);
	}


	private var history:Array;
	private var doBroadcast:Function;
	private var _listeners:Array;
	private var replayCount:Number;

	private function LoggerClass(){
		AsBroadcaster.initialize(this);
		history = new Array();
		doBroadcast = broadcastAndRecordMessage;
		replayCount = 0;
	}	
		
	private function doLog(msg:Object, method:String, file:String, lineNr:Number):Void{
		
		var o:Object;
		if (typeof msg=="string") msg=String(msg);
		else if (msg instanceof Object) 
		{
			o=msg;
			msg=o.name;
		}	
		
		var ch:String = msg.charAt(0).toLowerCase();
		if( msg.length == 1){
			msg = "";
		} else if( msg.charAt(1) == " "){
			msg = msg.substr(2);
		}
		var newMsg:String = method.split(".").pop() + " "+lineNr+">> " + msg;
		if(LoggerConfig.isInitialized()){
			var className:String = method.substr(0, method.indexOf(":"));
			var logLevel:LogLevel = LoggerConfig.getLogLevel(className);
			if(LogLevel.getLevelByKey(ch).getLevel() < logLevel.getLevel()){
				return;
			}
		}
		
		switch(ch){
			case "d":
				doBroadcast("publish", "debug", newMsg);
				break;
			case "i":
				doBroadcast("publish", "info", newMsg);
				break;
			case "w":
				doBroadcast("publish", "warn", newMsg);			
				break;
			case "e":
				doBroadcast("publish", "error", newMsg);			
				break;
			case "f":
				doBroadcast("publish", "fatal", newMsg);			
				break;
			case "t":
				doBroadcast("publish", "temp", newMsg);			
				break;
			case "o":
				doBroadcast("publish", "object", newMsg, o.msg);
				break;
			default:
				doBroadcast("publish", "temp", newMsg);
		}	
	}
	
	private function stopRecordingHistory():Void{
		history = null;
		doBroadcast = broadcastMessage;
		//t race("d " + [_listeners.length, replayCount]);
	}
	
	public function doReplayHistory( listener:Object):Void{
		var methodName:String;
		var args:Array;
		for( var i:Number=0;i<history.length;i++){
			methodName = history[i][0];
			args = history[i].slice(1);
			listener[methodName].apply( listener, args);
		}
		replayCount++;
		//trace("d " + [listener, history.join("###")]);
				
		if( replayCount == _listeners.length){
			stopRecordingHistory();
		}
	}
	
	public function addListener( listener:Object):Void{}
	
	private function removeListener( listener:Object):Void{}
	
	private function broadcastMessage( msg:String):Void{}

	private function broadcastAndRecordMessage( msg:String):Void{
		history.push( arguments);
		broadcastMessage.apply( this, arguments);
	} 	
	
	
	
	public function replayHistory( listener:Object):Void{
		// add a little delay to avoid 
		// calling logger.stopRecording too early,
		// @see doReplayHistory
		var id:Number;
		var self:LoggerClass = this;
		id = setInterval( function(){
			clearInterval( id);
			self.doReplayHistory( listener);
		}, 500);
	}
	
	
}