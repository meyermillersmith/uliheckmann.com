
import org.osflash.zeroi.logging.LoggerClass;
import org.osflash.zeroi.logging.publisher.Publisher;


/**
 * A Publisher which connects to SOS
 * @see http://sos.powerflasher.com
 * You need to start SOS in advance to make it work
 * 
 * 
 * @author Ralf Bokelberg <ralf.bokelberg@gmail.com>
 * @license LGPL
 *  
 */
class org.osflash.zeroi.logging.publisher.SOSPublisher 
	extends 
		LoggerClass
	implements 
		Publisher
{
	
	private static var initialized:Boolean = initialize();
	
	// instance for debug-usage only. otherwise its hard to trace to debug trace ;)
	public static var instance:SOSPublisher;
	
	private static function initialize():Boolean{
		if( initialized) return true;
		
		var id:Number;
		id = setInterval( function(){
			if( LoggerClass == undefined) return;
			//
			clearInterval( id);
			SOSPublisher.instance = new SOSPublisher();
			LoggerClass.getInstance().addListener( SOSPublisher.instance);			
		}, 100);
	} 
	
	
	private var socket:XMLSocket;

	public function SOSPublisher(){
		var self:SOSPublisher = this;
		//
		socket = new XMLSocket();
		socket.onConnect = function( success:Boolean){
			if( success){
				this.send('<clear/>\n');
				trace("d Connected to SOS");
				LoggerClass.getInstance().replayHistory(self); 
			} else {
				trace("Connection to SOS failed. Has SOS been started?");
			}
		};
		socket.connect("localhost", 4445);
	}
	
	public function publish( type:String, message:String, messageAr:Array):Void {
		if( message.length == 0) return;
		
		var xmlMessage:String;
		if(type.toUpperCase()=="OBJECT")
		{
			xmlMessage="<showFoldMessage key='" + type.toUpperCase() + "'><title>"+message+"</title><message>";
			for (var i:Number=0;i<messageAr.length;i++) 
				xmlMessage+=messageAr[i]+"\r\n";
				
			xmlMessage+="</message></showFoldMessage>";
		}
		else
			xmlMessage = '<showMessage key="' + type.toUpperCase() + '"/> ' + message;
		socket.send( xmlMessage +  "\n");
	}
	
	public function toString():String{
		return "[object SOSPublisher]";
	}
	
}