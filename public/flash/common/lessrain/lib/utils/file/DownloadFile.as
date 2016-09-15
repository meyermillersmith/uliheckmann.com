/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */

import flash.net.FileReference;

import lessrain.lib.utils.events.Dispatcher;
import lessrain.lib.utils.file.DownloadEvent;
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.file.DownloadFile extends Dispatcher
{
	private var _fileURL : String;
	private var _alternateName : String;
	
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

	public function DownloadFile() 
	{
		super();
		registerEvents();
	}
	
	public function startDownload(fileURL_:String):Void
	{
		if(fileURL_!=null) _fileURL=fileURL_;
		
		// The default filename displayed in the dialog box, 
		// for the file to be downloaded. 
		// This string cannot contain the following characters: / \ : * ? " < > | % 

		
		var tempFileRef : FileReference = new FileReference();
		
		tempFileRef.addListener(listener);
		
		if(_alternateName!=null)
		{
			tempFileRef.download(_fileURL,_alternateName);
		}else{
			tempFileRef.download(_fileURL);
		}
		
	}
	
	private function registerEvents():Void
	{
		listener = new Object();
		listener.onCancel=Proxy.create(this,onCancel);
		listener.onSelect=Proxy.create(this,onSelect);
		listener.onOpen=Proxy.create(this,onOpen);
		listener.onProgress=Proxy.create(this,onProgress);
		listener.onComplete=Proxy.create(this,onComplete);
		listener.onIOError=Proxy.create(this,onIOError);
	}
	
    /*
     * CANCEL
     * Invoked when the user dismisses the file-browsing dialog box
     */
	private function onCancel(file:FileReference):Void
	{
		file.removeListener(listener);
		dispatchEvent( new DownloadEvent( DownloadEvent.CANCEL, this));
	}
	/*
	 * SELECT
	 * Invoked when the user selects a file to download from the file-browsing dialog box.
	 */
	private function onSelect(file:FileReference):Void
	{
		_fileName=file.name;
		_fileCreationDate=file.creationDate;
		_fileModificationDate=file.modificationDate;
		_fileSize=Math.round(file.size/1024); 
		_fileCreator=file.creator;
		_fileType=file.type;
		
		
		dispatchEvent( new DownloadEvent( DownloadEvent.SELECT, this,file.name));
	}
	/*
	 * OPEN
	 * Invoked when a download operation starts.
	 */
	private function onOpen(file:FileReference):Void
	{
		dispatchEvent( new DownloadEvent( DownloadEvent.OPEN, this,file.name));
	}
	
	/*
	 * PROGRESS
	 * Invoked periodically during the file download operation.
	 * 
	 * In some cases, onProgress listeners are not invoked; for example, if the file being transmitted is very small, 
	 * or if the upload or download happens very quickly. 
	 */
	private function onProgress(file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void
	{
		updateProgressInfo(bytesLoaded, bytesTotal);
		dispatchEvent( new DownloadEvent( DownloadEvent.PROGRESS, this,file.name));
	}
	
	/*
	 * COMPLETE
	 * Invoked when the download operation has successfully completed.
	 */
	private function onComplete(file:FileReference):Void
	{
		file.removeListener(listener);
		dispatchEvent( new DownloadEvent( DownloadEvent.COMPLETE, this,file.name));
	}
	
	/*
	 * IOERROR
	 * Invoked when the download fails for any of the following reasons:
	 * 	1) An input/output error occurs while the player is reading, writing, or transmitting the file.
	 * 	2) The SWF file tries to download a file from a server that requires authentication, in the stand-alone or external player. 
	 * 	During download, the stand-alone and external players do not provide a means for users to enter passwords. 
	 * 	If a SWF file in these players tries to download a file from a server that requires authentication, 
	 * 	the download fails. File download can succeed only in the ActiveX control and browser plug-in players.   
	 */
	private function onIOError(file:FileReference):Void
	{
		dispatchEvent( new DownloadEvent( DownloadEvent.IOERROR, this));
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
	
	public function get fileURL() : String { return _fileURL; }
	public function set fileURL( value:String ) { _fileURL = value; }
	
	public function get alternateName() : String { return _alternateName; }
	public function set alternateName( value:String ) { _alternateName = value; }
	
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