import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileProgress;
import lessrain.lib.utils.loading.GroupListener;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.loading.GroupLoaderProgressProxy;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.loading.GroupLoader
{
	private var _listener : GroupListener;
	private var _files:Array;
	private var _intervalID:Number;
	private var _enterFrameBeaconDepth:Number;
	
	private var _debugMode:Boolean;
	
	private var _filesLoaded:Number;
	private var _filesTotal:Number;
	
	private var _progress : FileProgress;
	private var _groupLoaderProgressProxy:GroupLoaderProgressProxy;
	private var _description : String;
	
	public function GroupLoader(listener:GroupListener, groupLoaderProgressProxy:GroupLoaderProgressProxy, description:String)
	{
		_files = new Array();
		_debugMode=false;
		_intervalID = -1;
		_filesTotal=0;
		_filesLoaded=0;
		_progress = new FileProgress();
		_enterFrameBeaconDepth = 1048569;
		
		_listener = listener;
		_groupLoaderProgressProxy = groupLoaderProgressProxy;
		_description = description;
	}
	
	public function addFile(target_:Object, src_:String, priority_:Number, id_:String, description_:String, useCallback_:Boolean):Void
	{
		var file:FileItem = new FileItem(target_, src_, null, priority_, id_, description_, useCallback_);
		
		if (file.validate())
		{
			if (_debugMode) trace( "Adding file: \""+src_+"\", target \""+target_.toString()+"\", priority "+priority_ );
			
			sortFileIntoQueue( file );
			_filesTotal++;
		}
		else
		{
			if (_debugMode) trace( "Omitting file because it's invalid: \""+src_+"\", target \""+target_+"\", priority "+priority_ );
		}
	}
	
	public function start():Void
	{
		if (_filesTotal>0 && loadFiles())
		{
			startLoading();
		}
		else
		{
			if (_debugMode) trace( "No group to load" );
			_listener.onGroupComplete();
			if (_groupLoaderProgressProxy!=null) _groupLoaderProgressProxy.onGroupComplete(this);
		}
	}
	
	/**
	 * Puts a file at the correct position into the already sorted _files array.
	 * The Array is sorted ascending by file.priority, new items are inserted before existing items with the same priority.
	 * 
	 * @param	file	FileItem to be added to the _files Array
	 */
	private function sortFileIntoQueue( file:FileItem ):Void
	{
		for (var i : Number = _files.length-1; i >= 0; i--)
		{
			if ( FileItem(_files[i]).priority<file.priority )
			{
				_files.splice( i+1, 0, file );
				return;
			}
		}
		_files.unshift( file );
	}
	
	private function loadFiles():Boolean
	{
		var file:FileItem;
		var isComplete:Boolean = true;
		
		for (var i : Number = _files.length-1; i >= 0; i--)
		{
			file = FileItem(_files[i]);
			
			if (file.target!=null && !file.loaded)
			{
				if (_debugMode) trace( "Loading file \""+file.src+"\" into target "+file.target );
				
				isComplete=false;
				file.load();
			}
			else
			{
				_files.splice(i,1);
			}
		}
		
		return !isComplete;
	}
	
	private function startLoading():Void
	{
		if (_intervalID<0)
		{
			_listener.onGroupStart();
			if (_groupLoaderProgressProxy!=null) _groupLoaderProgressProxy.onGroupStart(this);
			
			_intervalID=1;
			(_root.createEmptyMovieClip("___groupLoaderBeacon",_enterFrameBeaconDepth)).onEnterFrame=Proxy.create(this,update);
		}
	}
	
	private function stopLoading():Void
	{
		if (_intervalID>=0)
		{
			//clearInterval(intervalID);
			_intervalID = -1;
			_filesTotal=0;
			_filesLoaded=0;
			delete _root.___groupLoaderBeacon.onEnterFrame;
			_root.___groupLoaderBeacon.onEnterFrame=null;
			_root.___groupLoaderBeacon.removeMovieClip();
		}
	}
	
	private function update():Void
	{
		var file:FileItem;		var fileProgress:FileProgress;
		_progress.bytesLoaded = 0;
		_progress.bytesTotal = 0;
		_filesLoaded=0;
		
		var filesStarted:Number = 0;		var filesTotal:Number = _files.length;
		for (var i : Number = filesTotal-1; i >= 0; i--)
		{
			file = FileItem(_files[i]);
			fileProgress = file.getProgress();
			
			_progress.bytesLoaded += fileProgress.bytesLoaded;
			_progress.bytesTotal += fileProgress.bytesTotal;
			
			if (fileProgress.bytesTotal>0) filesStarted++;
			if (file.loaded) _filesLoaded++;
		}
		
		_progress.bytesTotal = Math.round(_progress.bytesTotal / (filesStarted/filesTotal));
		if (_progress.bytesTotal>0) _progress.percent = Math.floor(_progress.bytesLoaded*100/_progress.bytesTotal);
		else _progress.percent=0;
		_listener.onGroupProgress( _filesLoaded, _filesTotal, _progress.bytesLoaded, _progress.bytesTotal, _progress.percent );
		if (_groupLoaderProgressProxy!=null) _groupLoaderProgressProxy.onGroupProgress( _filesLoaded, _filesTotal, _progress.bytesLoaded, _progress.bytesTotal, _progress.percent, this );
		
		if (_filesLoaded==_filesTotal)
		{
			for (var i : Number = _files.length-1; i >= 0; i--)
			{
				file = FileItem(_files[i]);
				delete file;
			}
			stopLoading();
			_files = new Array();
			
			if (_debugMode) trace( "Group loaded" );
			_listener.onGroupComplete();
			if (_groupLoaderProgressProxy!=null) _groupLoaderProgressProxy.onGroupComplete(this);
		}
	}
	
	public function get debugMode():Boolean { return _debugMode; }
	public function set debugMode(value:Boolean):Void { _debugMode=value; }
	
	public function get groupLoaderProgressProxy():GroupLoaderProgressProxy { return _groupLoaderProgressProxy; }
	public function set groupLoaderProgressProxy(groupLoaderProgressProxy_:GroupLoaderProgressProxy):Void { _groupLoaderProgressProxy=groupLoaderProgressProxy_; }
	public function get description():String { return _description; }
	public function set description(description_:String):Void { _description=description_; }
}