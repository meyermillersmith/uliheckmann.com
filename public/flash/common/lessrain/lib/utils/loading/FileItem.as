/**
 * lessrain.lib.utils.loading.FileItem, Version 1.0
 * 
 * FileItem objects hold information about the files to be loaded by the PriorityLoader.
 * These objects are deleted once the loading has finished.
 * 
 * They're also responsible for dropping the actual load command on the target.
 * 
 * Currently supported as targets are:
 * <ul>
 * <li>MovieClip</li>
 * <li>XML</li>
 * <li>lessrain.lib.utils.loading.Loadable</li>
 * </ul>
 * 
 * I'd have named the class "File", but that's reserved by Flash 8...
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 1.0
 * @see: lessrain.lib.utils.loading.PriorityLoader
 * @see: lessrain.lib.utils.loading.Loadable
 */
 
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.utils.loading.FileProgress;
import lessrain.lib.utils.loading.Loadable;
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.loading.FileItem
{
	public static var fileErrorTimeout:Number = 40000;
	public static var fileSlowTimeout:Number = 2000;
	private static var incomingCounter:Number = 0;
	
	public static var NO_ERROR:Number = 0;
	public static var ERROR_TARGET_UNDEFINED:Number = 1;
	public static var ERROR_TIMEOUT:Number = 2;
	public static var ERROR_GENERAL:Number = 3;
	public static var ERROR_NOT_FOUND:Number = 4;
	
	
	// priority between 0..100
	private var _target:Object;
	private var _src:String;
	private var _listener:FileListener;
	private var _priority:Number;
	private var _id:String;
	private var _description:String;
	
	private var _incomingPosition:Number;
	private var _loadTimestamp:Number;
	private var _errorCode:Number;
	private var _loaded:Boolean;
	
	private var _isLoaded:Boolean;
	private var _progress : FileProgress;

	private var _mcLoader : MovieClipLoader;

	private var _useLoader : Boolean;
	private var _useCallback : Boolean;

	public function FileItem(target:Object, src:String, listener:FileListener, priority:Number, id:String, description:String, useCallback:Boolean)
	{
		_incomingPosition = incomingCounter++;
		
		_target = target;
		_src = src;
		_listener = listener;
		if (priority==null) _priority = 0;
		else _priority = priority;
		_loadTimestamp=0;
		_id = id;
		_description = description;
		if (useCallback==null) useCallback=false;
		_useCallback = useCallback;
		_errorCode=0;
		_loaded=false;
		_useLoader = false;
	}
	
	/**
	 * Checks if the FileItem is valid and can be loaded.
	 * This check should be performed BEFORE the file starts loading.
	 * It basically checks if _target is null or undefined.
	 * It also checks for some problems that can occur with certain constellations
	 * 
	 * @return	true if the target object/movieclip is valid to be loaded
	 */
	public function validate():Boolean
	{
		/*
		 * If the target has a getBytesTotal value before it started loading, it already has content.
		 * In this case call unloadMovie, because otherwise the loading can be interrupted before it starts.
		 * ("The BBC problem")
		 * 
		 * Also give a trace warning because unloadMovie is only effective for the next EnterFrame
		 * 
		 */
		 if (typeof _target=="movieclip" && MovieClip(_target).getBytesTotal()>0)
		 {
		 	MovieClip(_target).unloadMovie();
		 	trace("PriorityLoader sais: Careful, you're loading into a MovieClip that already has content. Loading might fail in slow connections!");
		 }
		
		return (_target!=null && _target!=undefined && _src!=null && _src!=undefined);
	}
	
	/**
	 * Executes the load command for different types of objects.
	 * Currently supported are MovieClips, XML, and objects implementing the Loadable interface
	 */
	public function load():Void
	{
		_progress = new FileProgress();
		
		_loadTimestamp=(new Date()).getTime();
		if (_target instanceof MovieClip)
		{
			_useLoader=true;
			_mcLoader = new MovieClipLoader();
			_mcLoader.addListener(this);
			_mcLoader.loadClip(_src,_target);
		}
		else if (_target instanceof XML)
		{
			XML(_target).onLoad=Proxy.create(this, onLoad);
			XML(_target).load(_src);
		}
		else if (_target instanceof Sound)
		{
			Sound(_target).onLoad=Proxy.create(this, onLoad);
			Sound(_target).loadSound(_src, true);
		}
		else if (_target instanceof TextField.StyleSheet)
		{
			_target.getBytesLoaded=function ():Number {return 10;};
			_target.getBytesTotal=function ():Number {return 10;};
			TextField.StyleSheet(_target).onLoad=Proxy.create(this, onLoad);
			TextField.StyleSheet(_target).load(_src);
		}
		else if (_target instanceof Loadable) Loadable(_target).load(_src);
	}
	
	private function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void
	{
		_progress.bytesLoaded = bytesLoaded;		_progress.bytesTotal = bytesTotal;
	}
	
	private function onLoadError(target_mc:MovieClip, errorCode:String, httpStatus:Number):Void
	{
		_errorCode = ERROR_GENERAL;
	}
	
	private function onLoadComplete(target_mc:MovieClip, errorCode:String, httpStatus:Number):Void
	{
		if (httpStatus==404) _errorCode = ERROR_NOT_FOUND;
	}
	
	private function onLoadInit(target_mc:MovieClip):Void
	{
		if (_useCallback) MovieClip(_target).loaderCallback = Proxy.create(this, onLoaderCallback);
		else _loaded = true;
	}
	
	private function onLoaderCallback():Void
	{
		_loaded = true;
	}
	
	/**
	 * Determines if Sound, XML or StyleSheet is properly loaded 
	 */
	public function onLoad(success:Boolean):Void
	{
		if (!success) _errorCode=ERROR_GENERAL;
		_loaded=true;
	}
	
	/**
	 * Gets called by the loader to check the progress. The _progress object is populated and returned
	 * @return	the current _progress object with all properties updated
	 */
	public function getProgress():FileProgress
	{
		if (!_useLoader)
		{
			_progress.bytesLoaded = target.getBytesLoaded();			_progress.bytesTotal = target.getBytesTotal();
		}
		
		if (_progress.bytesTotal==null || isNaN(_progress.bytesTotal) || _progress.bytesTotal<=0 || (_progress.bytesTotal<=30 && (_target instanceof TextField.StyleSheet)))
		{
				_progress.bytesLoaded=0;
				_progress.bytesTotal=0;
				_progress.percent=0;
		}
		else _progress.percent = Math.floor(_progress.bytesLoaded*100/_progress.bytesTotal);
		
		// if there's been an error or the target has been removed or the file has timed out without starting to load, interrupt loading
		if (hasError() || !validateTarget() || (_progress.bytesTotal==0 && hasTimedOut())) _progress.percent=100;
		
		// if the file is loaded 100% but not properly loaded (ie initialized), fake it to 99%
		else if (_progress.percent>=100 && !_loaded) _progress.percent=99;
		
		if (_progress.percent==100) _loaded=true;
		
		return _progress;
	}
	
	/**
	 * Checks if the file has been loading longer than fileErrorTimeout.
	 * A file is asumed non-existant in this case
	 * 
	 * @return	true if the file has been loading longer than fileErrorTimeout, false otherwise
	 */
	public function hasTimedOut():Boolean
	{
		if (((new Date()).getTime()-_loadTimestamp)>fileErrorTimeout)
		{
			_errorCode=ERROR_TIMEOUT;
			return true;
		}
		else return false; 
	}
	
	public function isSlow():Boolean
	{
		if (((new Date()).getTime()-_loadTimestamp)>fileSlowTimeout) return true;
		else return false; 
	}
	
	/**
	 * Checks if the target object/movieclip still exists or if it has been removed while loading
	 * 
	 * @return	true if the target object/movieclip still exists, false otherwise.
	 */
	public function validateTarget():Boolean
	{
		/*
		 * fucked up workaround:
		 * if a target is removed while or before it's loading, the loading process is interrupted
		 * somehow it can't be detected by currentFile.target==undefined, don't know why...
		 * so i'm using the typeof... workaround. it works.....
		 */
		if (_target==null || _target==undefined || (typeof _target=="movieclip" && String(_target).length<3))
		{
			_errorCode=ERROR_TARGET_UNDEFINED;
			return false;
		}
		else return true;
	}
	
	public function hasError():Boolean
	{
		return (_errorCode>0);
	}
	
	public function get incomingPosition():Number { return _incomingPosition; }
	public function get target():Object { return _target; }
	public function get src():String { return _src; }
	public function get listener():FileListener { return _listener; }
	public function get priority():Number { return _priority; }
	public function get id():String { return _id; }
	public function get description():String { return _description; }
	
	public function get errorCode():Number { return _errorCode; }
	public function set errorCode(value:Number):Void { _errorCode=value; }
	
	public function get loaded():Boolean { return _loaded; }
}
