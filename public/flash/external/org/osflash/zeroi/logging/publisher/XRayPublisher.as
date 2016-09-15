
import org.osflash.zeroi.logging.LoggerClass;
import org.osflash.zeroi.logging.publisher.Publisher;
import org.osflash.zeroi.util.SpecialClipManager;

/**
 * A Publisher which loads the xray connector
 * to send messages to the xray console 
 * @see osflash.org/xray 
 * 
 * You need to start xray.swf in advance to make it work
 * 
 * @author Ralf Bokelberg <ralf.bokelberg@gmail.com>
 * @license LGPL
 *   
 */
class org.osflash.zeroi.logging.publisher.XRayPublisher 
	implements 
		Publisher
{
	
	private static var initialized:Boolean = initialize();
	
	private static function initialize():Boolean{
		if( initialized) return true;
		
		var id:Number;
		id = setInterval( function(){
			if( LoggerClass == undefined) return;
			//
			clearInterval( id);
			LoggerClass.getInstance().addListener( new XRayPublisher());			
		}, 100);
	} 
	
	
	public function XRayPublisher(){
		var self:XRayPublisher = this;
		
		var mcl:MovieClipLoader = new MovieClipLoader();
		mcl.addListener({onLoadComplete:function(){
			var id:Number;
			id = setInterval( function(){
				if( !( typeof this.xrayPackage.Xray.initConnections == 'function')) return;
				clearInterval( id);
				//
				this.xrayPackage.Xray.initConnections();
				LoggerClass.getInstance().replayHistory(self); 
			}, 2000);	
		}});
		mcl.loadClip( "ConnectorOnly_as2_fp7_OS.swf", 
			SpecialClipManager.getInstance().createEmptyMovieClip());
	}
	
	public function publish( type:String, message:String, messageAr:Array):Void {
		this.xrayPackage.XrayTrace.getInstance().trace( type, message);
	}
	
	public function toString():String{
		return "[object XRayPublisher]";
	}
	
	private function get xrayPackage():Object{
		return _global.com.blitzagency.xray;
	}
	
	
	
}