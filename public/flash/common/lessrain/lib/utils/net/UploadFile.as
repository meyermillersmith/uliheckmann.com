/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 * Upload of a file selected by a user to a remote server.
 * Flash Player can upload files of up to 100 MB. 
 */
import flash.net.FileReference;

import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.net.UploadEvent;

class lessrain.lib.utils.net.UploadFile implements IDistributor 
{
	private var _eventDistributor		: EventDistributor;
	
	//The urlPost of the server script configured to handle upload through HTTP POST calls. 
	//The urlPost can be HTTP or, for secure uploads, HTTPS. 
	private var _urlPost 				: String;
	
	//An array of file types used to filter the files displayed in the dialog box. 
	//If you omit this parameter, all files are displayed. 
	private var _typeList 				: Array;
	
	private var listener 				: Object;
	
	// The name of the file on the local disk. 
	private var _fileName 				: String;
	
	// size in kb
	private var _fileSize 				: Number;
	
	// The creation date of the file on the local disk
	private var _fileCreationDate 		: Date;
	
	//The date that the file on the local disk was last modified. 
	private var _fileModificationDate 	: Date;
	
	// The Macintosh creator type of the file. In Windows, this property is null
	private var _fileCreator 			: String;
	
	// The file type. In Windows, this property is the file extension. On the Macintosh, 
	// this property is the four-character file type.
	private var _fileType 				: String;
	
	// progress information
	private var _percentUploaded 		: Number;

	private var _fileRef 				: FileReference;
	
	private var _selectEvent			: UploadEvent;
	private var _openEvent				: UploadEvent;
	private var _cancelEvent			: UploadEvent;
	private var _httpErrorEvent			: UploadEvent;
	private var _ioErrorEvent			: UploadEvent;
	private var _errorStringEvent		: UploadEvent;
	private var _progressEvent			: UploadEvent;
	private var _completeEvent			: UploadEvent;

	private var _httpError 				: Number;

	private var _errorString 			: String;	
	
	public function UploadFile() 
	{
		_eventDistributor		=	 new EventDistributor();
		
		_selectEvent			=   new UploadEvent( UploadEvent.SELECT);
		_openEvent				=   new UploadEvent( UploadEvent.OPEN);
		_cancelEvent			=   new UploadEvent( UploadEvent.CANCEL);
		_httpErrorEvent			=   new UploadEvent( UploadEvent.HTTPERROR);
		_ioErrorEvent			=   new UploadEvent( UploadEvent.IOERROR);
		_errorStringEvent		=   new UploadEvent( UploadEvent.SECURITYERROR);
		_progressEvent			=   new UploadEvent( UploadEvent.PROGRESS);
		_completeEvent			=   new UploadEvent( UploadEvent.COMPLETE);
	}
	
	/**
	* adds file type descriptions followed by their Windows file extensions and their Macintosh file types.
	* Each element in the array must contain a string that describes the file type and a semicolon-delimited 
	* list of Windows file extensions, with a wildcard character (*) preceding each extension. 
	* 
	* @param description string describing the first set of file types.
	* @param extension semicolon-delimited list of Windows file extensions. 
	* @param macType semicolon-delimited list of Macintosh file types.
	*  
	*/
	public function addFileType(description_:String,extension_:String, macType_:String):Void
	{
		if(_typeList==null) _typeList=new Array();
		if(!macType_)_typeList.push({description:description_,extension:extension_});	
		else _typeList.push({description:description_,extension:extension_, macType:macType_});	
	}
	
	// default file type list
	public function setDefaultTypeList():Void
	{
		_typeList=new Array({description: "Image files", extension: "*.jpg;*.gif;*.png"});	
	}
	
	public function browse():Void
	{
		_fileRef	= new FileReference();
		_fileRef.addListener(this);
		_fileRef.browse(_typeList);
	
	}
	
	public function upload(url_:String):Void
	{
		if(url_!=null) _urlPost=url_;
		_fileRef.upload(_urlPost);
	}
	
	 /*
     * CANCEL
     * Invoked when the user dismisses the file-browsing dialog box
     */
	private function onCancel(file_:FileReference):Void
	{
		file_.removeListener(this);
		distributeEvent( _cancelEvent);
	}
	/*
	 * SELECT
	 * Starts the upload of a file selected by a user to a remote server. (_urlPost)
	 */
	private function onSelect(file_:FileReference):Void
	{

		_fileName				=	(file_.name);
		_fileCreationDate		=	(file_.creationDate);
		_fileModificationDate	=	(file_.modificationDate);
		_fileCreator			=	(file_.creator);
		_fileType				=	(file_.type);
		
		_fileSize				=	Number(Math.round(file_.size/1024)); 
		
		distributeEvent( _selectEvent);

	}
	/*
	 * OPEN
	 * Invoked when a upload operation starts.
	 */
	private function onOpen(file_:FileReference):Void
	{
		distributeEvent( _openEvent);
	}
	
	/*
	 * PROGRESS
	 * Invoked periodically during the file upload operation.
	 * 
	 * In some cases, onProgress listeners are not invoked; for example, if the file being transmitted is very small, 
	 * or if the upload happens very quickly. 
	 */
	private function onProgress(file_:FileReference, bytesLoaded_:Number, bytesTotal_:Number):Void
	{
		// do not dispatch or distribute anything from the on progress event,it will crash Safari
		if(bytesTotal_>-1)_percentUploaded 	= Number(Math.min(Math.round(bytesLoaded_/bytesTotal_*100), 100));
	}
	
	/*
	 * COMPLETE
	 * Invoked when the upload operation has successfully completed.
	 */
	private function onComplete(file_:FileReference):Void
	{
		file_.removeListener(this);
		distributeEvent(_completeEvent);
	}
	
	/*
	 * Invoked when an upload fails because of an HTTP error.
	 */
	private function onHTTPError (file_:FileReference,httpError_:Number):Void 
	{
		_httpError = httpError_;
   		distributeEvent(_httpErrorEvent);
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
	private function onIOError(file_:FileReference):Void
	{
		distributeEvent(_ioErrorEvent);
	}
	
	/*
	 * Invoked when an upload fails because of a security error.
	 */
	private function onSecurityError (file_:FileReference,errorString_:String):Void 
	{
		_errorString = errorString_;
   		distributeEvent( _errorStringEvent);
	}
	
	public function get urlPost() : String { return _urlPost; }
	public function set urlPost( urlPost_:String ) { _urlPost = urlPost_; }
	
	public function get typeList() : Array { return _typeList; }
	public function set typeList( typeList_:Array ) { _typeList = typeList_; } 
	
	public function get fileName() : String { return _fileName; }
	public function get fileSize() : Number { return _fileSize; }
	public function get fileCreationDate() : Date{ return _fileCreationDate; }
	public function get fileModificationDate() : Date { return _fileModificationDate; }
	public function get fileCreator() : String { return _fileCreator; }
	public function get fileType() : String { return _fileType; }
	
	public function get httpError() : Number { return _httpError; }
	public function get errorString() : String { return _errorString; }
	
	// progress info
	public function get percentUploaded() : Number { return _percentUploaded; }
	
	public function addEventListener(type : String, func : Function) : Void{_eventDistributor.addEventListener(type, func );}
	public function removeEventListener(type : String, func : Function) : Void{_eventDistributor.removeEventListener(type, func );}
	public function distributeEvent(eventObject : IEvent) : Void{_eventDistributor.distributeEvent(eventObject );}
	
	public function destroy():Void
	{
		_eventDistributor.finalize();
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}
		
		delete this;
	}

}