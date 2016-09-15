/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 * @description The UploadEvent is broadcasted by the UploadFile class, 
 * the 'type' property can have any of the following values:
 * 
 *   onCancel - Invoked when the user dismisses the file-browsing dialog box
 *   onSelect - Invoked when the user selects a file to download from the file-browsing dialog box.
 *   onOpen - Invoked when a upload operation starts.
 *   onProgress - Invoked periodically during the file upload operation.
 *   onComplete - Invoked when the file upload operation successfully completes.
 *   onHTTPError - Invoked when an upload fails because of an HTTP error.
 *   			   HTTP error values can be found in sections 10.4 and 10.5 of the HTTP specification 
 *   			   at ftp://ftp.isi.edu/in-notes/rfc2616.txt.
 *   onIOError - Invoked when an upload fails because of an HTTP error. 
 *   onSecurityError - Invoked when an upload fails because of a security violation. 
 */


import lessrain.lib.utils.file.UploadFile;

class lessrain.lib.utils.file.UploadEvent 
{

	public var type:String;
	public var target:UploadFile;
	public var fileName:String;
	public var httpError:Number;
	public var errorString:String;
	
	// possible values  for 'type'
	public static var CANCEL:String = "onCancel";
	public static var SELECT:String = "onSelect";
	public static var OPEN:String = "onOpen";
	public static var PROGRESS:String = "onProgress";
	public static var COMPLETE:String = "onComplete";
	public static var HTTPERROR:String = "onHTTPError";
	public static var IOERROR:String = "onIOError";
	public static var SECURITYERROR:String = "onSecurityError";

	public function UploadEvent ( uType:String, uTarget:UploadFile, uFileName:String,uHttpError:Number,uErrorString:String) 
	{
		type = uType;
		target = uTarget;
		fileName = uFileName;
		httpError = uHttpError;
		errorString = uErrorString;
	}
}