
import org.osflash.zeroi.logging.LoggerClass;
import org.osflash.zeroi.logging.publisher.Publisher;
import org.osflash.zeroi.util.SpecialClipManager;

/**
 * A Publisher which creates a textfield to display messages
 * The listener extends the Logger to assure, that the logger is 
 * created before the listener  
 * 
 * @author Ralf Bokelberg <ralf.bokelberg@gmail.com>
 * @license LGPL
 *  
 */
class org.osflash.zeroi.logging.publisher.TextFieldPublisher
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
			LoggerClass.getInstance().addListener( new TextFieldPublisher());		 	 
		}, 100);
	} 
	
	
	private var tf:TextField; 
	private var id:String;

	public function TextFieldPublisher(){
		var mc:MovieClip = SpecialClipManager.getInstance().createEmptyMovieClip();
		mc.createTextField("tfDebug", 0, 0, 0, 300, 300);
		this.tf = mc["tfDebug"];
		mc.onPress = function(){
			this.startDrag();
			this.onMouseUp = function(){
				delete this.onMouseUp;
				this.stopDrag();
			};
		};
		this.tf.wordWrap = true;
		this.tf.background = true;
		this.tf.border = true;
		this.tf.type = "input";
		//
		LoggerClass.getInstance().replayHistory(this); 
	}
	
	public function publish( type:String, message:String, messageAr:Array):Void {
		//if( message.length == 0) return;
		tf.text += message + "\n";
		tf.scroll = tf.maxscroll;
	}
	
	public function toString():String{
		return "[object TextFieldPublisherClass]";
	}
}