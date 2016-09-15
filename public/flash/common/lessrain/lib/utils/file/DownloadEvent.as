/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 * @description The DownloadEvent is broadcasted by the DownloadFile class, 
 * the 'type' property can have any of the following values:
 * 
 *   onCancel - Invoked when the user dismisses the file-browsing dialog box
 *   onSelect - Invoked when the user selects a file to download from the file-browsing dialog box.
 *   onOpen - Invoked when a download operation starts.
 *   onProgress - Invoked periodically during the file download operation.
 *   onComplete - Invoked when the download operation has successfully completed.
 *   onIOError - Invoked when the download fails. 
 */


import lessrain.lib.utils.file.DownloadFile;

class lessrain.lib.utils.file.DownloadEvent 
{

	public var type:String;
	public var target:DownloadFile;
	public var fileName:String;
	
	// possible values  for 'type'
	public static var CANCEL:String = "onCancel";
	public static var SELECT:String = "onSelect";
	public static var OPEN:String = "onOpen";
	public static var PROGRESS:String = "onProgress";
	public static var COMPLETE:String = "onComplete";
	public static var IOERROR:String = "onIOError";

	public function DownloadEvent ( dType:String, dTarget:DownloadFile, dFileName:String) 
	{
		type = dType;
		target = dTarget;
		fileName = dFileName;
	}
}