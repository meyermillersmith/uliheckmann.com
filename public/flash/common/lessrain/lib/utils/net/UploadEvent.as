/**
 * @author Luis Martinez, Less Rain (luis@lessrain.net)
 * 
 * The UploadEvent is broadcasted by the UploadFile class, 
 * the 'type' property can have any of the following values:
 * 
 *   cancel 		Invoked when the user dismisses the file-browsing dialog box
 *   select 		Invoked when the user selects a file to download from the file-browsing dialog box.
 *   open 			Invoked when a upload operation starts.
 *   progress 		Invoked periodically during the file upload operation.
 *   complete 		Invoked when the file upload operation successfully completes.
 *   
 *   HTTPError 		Invoked when an upload fails because of an HTTP error.
 *   			 	HTTP error values can be found in sections 10.4 and 10.5 of the HTTP specification 
 *   			   	at ftp://ftp.isi.edu/in-notes/rfc2616.txt.
 *   			   		
 *   IOError  		Invoked when an upload fails because of an HTTP error. 
 *   securityError  Invoked when an upload fails because of a security violation. 
 *   
 */
import lessrain.lib.utils.events.IEvent;
class lessrain.lib.utils.net.UploadEvent implements IEvent 
{
	public var _type				:	String;
	
	// possible values  for 'type'
	public static var CANCEL		:	String = "cancel";
	public static var SELECT		:	String = "select";
	public static var OPEN			:	String = "open";
	public static var PROGRESS		:	String = "progress";
	public static var COMPLETE		:	String = "complete";
	public static var HTTPERROR		:	String = "HTTPError";
	public static var IOERROR		:	String = "IOError";
	public static var SECURITYERROR	:	String = "securityError";
	
	public function UploadEvent ( type_:String) {_type = type_;}
	
	public function getType() : String {return _type;}
}