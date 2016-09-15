/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * Upload of a file selected by a user to a remote server.
 * Flash Player can upload files of up to 100 MB. 
 */

import flash.net.FileReference;

import lessrain.lib.utils.events.Dispatcher;
import lessrain.lib.utils.file.UploadEvent;
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.file.UploadFile extends Dispatcher
{
	//private var fileRef

	//The urlPost of the server script configured to handle upload through HTTP POST calls. 
	//The urlPost can be HTTP or, for secure uploads, HTTPS. 
	private var _urlPost : String;
	
	//An array of file types used to filter the files displayed in the dialog box. 
	//If you omit this parameter, all files are displayed. 
	private var _typeList : Array;
	
	private var listener : Object;
	
	// The name of the file on the local disk. 
	private var _fileName : String;
	
	// size in kb
	private var _fileSize : Number;
	
	// The creation date of the file on the local disk
	private var _fileCreationDate : Date;
	
	//The date that the file on the local disk was last modified. 
	private var _fileModificationDate : Date;
	
	// The Macintosh creator type of the file. In Windows, this property is null
	private var _fileCreator : String;
	
	// The file type. In Windows, this property is the file extension. On the Macintosh, 
	// this property is the four-character file type.
	private var _fileType : String;
	
	// progress information
	private var _percentLoaded : Number;
	private var _bytesLoaded : Number;
	private var _bytesTotal : Number;
	private var _kBytesLoaded : Number;
	private var _kBytesTotal : Number;
	private var _kBytesRemaining : Number;
	private var _kBytesSec : Number;
	private var _secondsRemaining : Number;

	private var tempFileRef : FileReference;
	
		
	public function UploadFile() 
	{
		super();
		registerEvents();
	}
	
	/**
	* adds file type descriptions followed by their Windows file extensions and their Macintosh file types.
	* Each element in the array must contain a string that describes the file type and a semicolon-delimited 
	* list of Windows file extensions, with a wildcard character (*) preceding each extension. 
	* @param description string describing the first set of file types.
	* @param extension semicolon-delimited list of Windows file extensions. 
	* @param macType semicolon-delimited list of Macintosh file types. 
	*/
	public function addFileType(description:String,extension:String, macType:String):Void
	{
		if(_typeList==null) _typeList=new Array();
		_typeList.push({description:description,extension:extension,macType:macType});	
	}
	
	// default file type
	public function setDefaultTypeList():Void
	{
		_typeList=new Array(
							{description: "Image files", extension: "*.jpg;*.gif;*.png", macType: "JPEG;jp2_;GIFF"},
		 					{description: "Flash Movies", extension: "*.swf", macType: "SWFL" });	
	}
	
	public function browse():Void
	{
		tempFileRef= new FileReference();
		tempFileRef.addListener(listener);
		tempFileRef.browse(_typeList);
	
	}
	
	public function upload(url:String):Void
	{
		if(urlPost!=null) _urlPost=urlPost;
		tempFileRef.upload(_urlPost);
	}
	
	private function registerEvents():Void
	{
		listener = new Object();
		listener.onCancel=Proxy.create(this,onCancel);
		listener.onSelect=Proxy.create(this,onSelect);
		listener.onOpen=Proxy.create(this,onOpen);
		listener.onProgress=Proxy.create(this,onProgress);
		listener.onComplete=Proxy.create(this,onComplete);
		listener.onHTTPError=Proxy.create(this,onHTTPError);
		listener.onIOError=Proxy.create(this,onIOError);
	}
	
    /*
     * CANCEL
     * Invoked when the user dismisses the file-browsing dialog box
     */
	private function onCancel(file:FileReference):Void
	{
		file.removeListener(listener);
		dispatchEvent( new UploadEvent( UploadEvent.CANCEL, this));
	}
	/*
	 * SELECT
	 * Starts the upload of a file selected by a user to a remote server. (_urlPost)
	 */
	private function onSelect(file:FileReference):Void
	{

		_fileName=file.name;
		_fileCreationDate=file.creationDate;
		_fileModificationDate=file.modificationDate;
		_fileSize=Math.round(file.size/1024); 
		_fileCreator=file.creator;
		_fileType=file.type;
		
		dispatchEvent( new UploadEvent( UploadEvent.SELECT, this,file.name));

	}
	/*
	 * OPEN
	 * Invoked when a upload operation starts.
	 */
	private function onOpen(file:FileReference):Void
	{
		dispatchEvent( new UploadEvent( UploadEvent.OPEN, this,file.name));
	}
	
	/*
	 * PROGRESS
	 * Invoked periodically during the file upload operation.
	 * 
	 * In some cases, onProgress listeners are not invoked; for example, if the file being transmitted is very small, 
	 * or if the upload happens very quickly. 
	 */
	private function onProgress(file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void
	{
		updateProgressInfo(bytesLoaded, bytesTotal);
		dispatchEvent( new UploadEvent( UploadEvent.PROGRESS, this,file.name));
	}
	
	/*
	 * COMPLETE
	 * Invoked when the upload operation has successfully completed.
	 */
	private function onComplete(file:FileReference):Void
	{
		file.removeListener(listener);
		dispatchEvent( new UploadEvent( UploadEvent.COMPLETE, this,file.name));
	}
	
	/*
	 * Invoked when an upload fails because of an HTTP error.
	 */
	private function onHTTPError (file:FileReference,httpError:Number):Void 
	{
   		dispatchEvent( new UploadEvent( UploadEvent.HTTPERROR, this,file.name,httpError));
	}
	
	
	/*
	 * IOERROR
	 * Invoked when the upload fails for any of the following reasons:
	 * 	1) An input/output error occurs while the player is reading, writing, or transmitting the file.
	 * 	2) The SWF file tries to upload a file to a server that requires authentication, 
	 * 	such as a user name and password. 
	 * 	During upload, Flash Player does not provide a means for users to enter passwords. 
	 * 	If a SWF file tries to upload a file to a server that requires authentication, the upload fails. 
	 */
	private function onIOError(file:FileReference):Void
	{
		dispatchEvent( new UploadEvent( UploadEvent.IOERROR, this));
	}
	
	/*
	 * Invoked when an upload fails because of a security error.
	 */
	private function onSecurityError (file:FileReference,errorString:String):Void 
	{
   		dispatchEvent( new UploadEvent( UploadEvent.SECURITYERROR, this,file.name,null,errorString));
	}
	
	private function updateProgressInfo(bytesLoaded:Number, bytesTotal:Number):Void
	{
		_percentLoaded = Math.min(Math.round(bytesLoaded/bytesTotal*100), 100);
		_bytesLoaded = bytesLoaded;
		_bytesTotal = Math.round(isNaN(bytesTotal) ? 0 : bytesTotal);
		_kBytesLoaded = Math.round(bytesLoaded/1024);
		_kBytesTotal = isNaN(_fileSize) ? 0 : _fileSize;
		_kBytesRemaining = Math.round(_kBytesTotal-_kBytesLoaded);
		_kBytesSec = Math.round(_kBytesLoaded/(getTimer()/1000));
		_secondsRemaining = isNaN(Math.round(_kBytesRemaining/_kBytesSec)) ? 0 : Math.round(_kBytesRemaining/_kBytesSec);
		if(_secondsRemaining<0) _secondsRemaining=0;

	}
	
	public function get urlPost() : String { return _urlPost; }
	public function set urlPost( value:String ) { _urlPost = value; }
	
	public function get typeList() : Array { return _typeList; }
	public function set typeList( value:Array ) { _typeList = value; } 
	
	public function get fileName() : String { return _fileName; }
	public function get fileSize() : Number { return _fileSize; }
	public function get fileCreationDate() : Date{ return _fileCreationDate; }
	public function get fileModificationDate() : Date { return _fileModificationDate; }
	public function get fileCreator() : String { return _fileCreator; }
	public function get fileType() : String { return _fileType; }
	
	// progress info
	public function get percentLoaded() : Number { return _percentLoaded; }
	public function get bytesLoaded() : Number { return _bytesLoaded; }
	public function get bytesTotal() : Number { return _bytesTotal; }
	public function get kBytesLoaded() : Number { return _kBytesLoaded; }
	public function get kBytesTotal() : Number { return _kBytesTotal; }
	public function set kBytesTotal( value:Number ) { _kBytesTotal = value; }
	public function get kBytesRemaining() : Number { return _kBytesRemaining; }
	public function get kBytesSec() : Number { return _kBytesSec; }
	public function get secondsRemaining() : Number { return _secondsRemaining; }
	


}