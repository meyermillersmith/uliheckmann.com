/**
 * lessrain.lib.utils.loading.PriorityLoader, Version 2.0
 * 
 * 
 * PriorityLoader is a Load Queue, that loads one file at a time. It does this in the order given by a priority parameter from 0..100.
 * FIles with a high priority move to the beginning of the queue immediately when added.
 * Files with the same priority are ordered the way they were added (first in first out).
 * PriorityLoader is a singleton class.
 * 
 * FileListener objects are notified when the loading of their target starts, every enterFrame of progress and when it's finished loading.
 * 
 * You can turn debug-mode on to get trace-output and load-time-simulation (5% for every step/enterFrame)
 * <code>
 * PriorityLoader.getInstance().debugMode=true;
 * </code>
 * 
 * <b>Usage:</b>
 * 
 * <code>
 * import lessrain.lib.utils.loading.PriorityLoader;
 * import lessrain.lib.utils.loading.FileListener;
 * import lessrain.lib.utils.loading.FileItem;
 * class Test implements FileListener
 * {
 * 	var target:MovieClip;
 * 	var src:String;
 * 	public function Test()
 * 	{
 * 		this.createEmptyMovieClip("target",1);
 * 		src = "/images/test.jpg";
 * 		// loads the image with a relatively low priority of 10 and specifies this as FileListener
 * 		PriorityLoader.getInstance().addFile(target, src, this, 10, "", "Test Image");
 * 	}
 * 	public function onLoadStart(file:FileItem):Boolean
 * 	{
 * 		// The load command should be done by the PriorityLoader
 * 		return false;
 * 	}
 * 	public function onLoadComplete(file:FileItem):Void
 * 	{
 * 		// stop loading animation and show content
 * 	}
 * 	public function onLoadProgress(file:FileItem, bytesLoaded:Number, bytesTotal:Number, percent:Number):Void
 * 	{
 * 		trace(percent+"% loaded of "+file.description);
 * 		// update loading animation here
 * 	}
 * }
 * </code>
 * 
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 1.7
 * @see: lessrain.lib.utils.loading.FileItem
 * @see: lessrain.lib.utils.loading.FileListener
 * @see: lessrain.lib.utils.loading.QueueListener
 * @see: lessrain.lib.utils.loading.Loadable
 * @see: mx.events.EventDispatcher
 */

import mx.events.EventDispatcher;

import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.loading.FileProgress;

class lessrain.lib.utils.loading.PriorityLoader
{
	private static var instance : PriorityLoader;
	
	/**
	 * @return singleton instance of PriorityLoader
	 */
	public static function getInstance() : PriorityLoader
	{
		if (instance == null) instance = new PriorityLoader();
		return instance;
	}
	
	private var currentFile:FileItem;
	private var queue:Array; // of FileItem
	private var pile:Array; // of FileItem, for slow files that would otherwise block the queue
	private var _enablePile:Boolean;
	
	private var intervalID:Number;
	private var _debugMode:Boolean;
	private var _enterFrameBeaconDepth:Number;
	
	private var filesLoaded:Number;
	private var filesTotal:Number;
	
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;

	function PriorityLoader()
	{
		queue = new Array();
		pile = new Array();
		_debugMode=false;
		_enablePile=false;
		intervalID = -1;
		_enterFrameBeaconDepth = 1048570;
		EventDispatcher.initialize(this);
	}
	
	/**
	 * Adds a file to the Queue and starts loading immediately.
	 * A file might be 100% loaded immediately, before any other files can be added to the queue.
	 * Use queueFile if you want a set of files to be loaded with the listener receiving the correct filesLoaded / filesTotal values
	 * 
	 * @param	target			The Object (usually MovieClip) that something should be loaded into
	 * @param	src				Path/URL to the file that's loaded into target
	 * @param	listener			The FileListener that wants to observe the progress
	 * @param	priority			Number between 0..100 defining the priority of this file. 100 is the highest priority
	 * @param	id					String that can be used to identify the file in a QueueListener (optional)
	 * @param	description		String that can be used to describe the file in a QueueListener, e.g. in a loading bar (optional)
	 * @param	useCallback	[For MovieClips only!] Specify whether or not to use a calback function in the loaded MC. The Loader will wait for a function "loaderCallback" to be called before it completes the loading. Particularly necessary if the MC uses a shared library. 
	 * @see		lessrain.lib.utils.loading.FileItem
	 * @see		PriorityLoader#queueFile()
	 */
	public function addFile(target:Object, src:String, listener:FileListener, priority:Number, id:String, description:String, useCallback:Boolean):Void
	{
		queueFile(target, src, listener, priority, id, description, useCallback);
		priorityLoad();
	}

	/**
	 * Adds a file to the Queue.
	 * Loading will start in the next EnterFrame.
	 * 
	 * @param	target			The Object (usually MovieClip) that something should be loaded into
	 * @param	src				Path/URL to the file that's loaded into target
	 * @param	listener			The FileListener that wants to observe the progress
	 * @param	priority			Number between 0..100 defining the priority of this file. 100 is the highest priority
	 * @param	id					String that can be used to identify the file in a QueueListener (optional)
	 * @param	description		String that can be used to describe the file in a QueueListener, e.g. in a loading bar (optional)
	 * @param	useCallback	[For MovieClips only!] Specify whether or not to use a calback function in the loaded MC. The Loader will wait for a function "loaderCallback" to be called before it completes the loading. Particularly necessary if the MC uses a shared library. 
	 * @see		lessrain.lib.utils.loading.FileItem
	 */
	public function queueFile(target:Object, src:String, listener:FileListener, priority:Number, id:String, description:String, useCallback:Boolean):Void
	{
		var file:FileItem = new FileItem(target, src, listener, priority, id, description, useCallback);
		
		if (file.validate())
		{
			if (_debugMode) trace( "Adding file: \""+src+"\", target \""+target.toString()+"\", priority "+priority );
			startLoading();
			
			sortFileIntoQueue( file );
			filesTotal++;
		}
		else
		{
			if (_debugMode) trace( "Omitting file because it's invalid: \""+src+"\", target \""+target+"\", priority "+priority );
		}
	}
	
	private function startLoading():Void
	{
		if (intervalID<0)
		{
			filesTotal=0;
			filesLoaded=0;
			dispatchEvent( { type: "onQueueStart" } );
			intervalID=1;
			//intervalID = setInterval( this, "priorityLoad", 20 );
			(_root.createEmptyMovieClip("___priorityLoaderBeacon",_enterFrameBeaconDepth)).onEnterFrame=Proxy.create(this,priorityLoad);
		}
	}
	
	private function stopLoading():Void
	{
		if (intervalID>=0)
		{
			//clearInterval(intervalID);
			intervalID = -1;
			filesTotal=0;
			filesLoaded=0;
			if (_enterFrameBeaconDepth<=0) MovieClip(_root.___priorityLoaderBeacon).swapDepths( 1048570 );
			delete _root.___priorityLoaderBeacon.onEnterFrame;
			_root.___priorityLoaderBeacon.onEnterFrame = null;
			_root.___priorityLoaderBeacon.removeMovieClip();
		}
	}
	
	
	/**
	 * Puts a file at the correct position into the already sorted queue.
	 * The Array is sorted ascending by file.priority, new items are inserted before existing items with the same priority.
	 * 
	 * @param	file	FileItem to be added to the queue Array
	 */
	private function sortFileIntoQueue( file:FileItem ):Void
	{
		for (var i : Number = queue.length-1; i >= 0; i--)
		{
			if ( FileItem(queue[i]).priority<file.priority )
			{
				queue.splice( i+1, 0, file );
				return;
			}
		}
		queue.unshift( file );
	}
	
	/**
	 * Is called every enterFrame.
	 * Gets the next file if there is currently none loading (nextFile();)
	 * Checks the progress of the current file if there is one  (processFile();)
	 * Proccesses the pile of slow files (none-queued)
	 */
	public function priorityLoad():Void
	{
		// if there's no file loading get the next one
		if (currentFile==null) nextFile();
		
		// Go through the pile of slow-starter-files and checks their progress
		if (_enablePile && pile.length>0) for (var i : Number = pile.length-1; i >= 0; i--) processFile(pile[i], i);
		
		// check the progress of the current file
		if (currentFile!=null) processFile(currentFile, -1);
	}
	
	
	/*
	 * Checks the progress of a file and notifies the listeners.
	 * Returns true if the file has completed loading.
	 * It might change the member variable currentFile when it's done loading a file to prevent endless loops!
	 */
	private function processFile(file:FileItem, pileIndex:Number):Void
	{
		var progress:FileProgress = file.getProgress();
		
		if (_enablePile && progress.percent==0 && pileIndex<0 && file.isSlow())
		{
			pile.unshift(file);
			file=null;
			currentFile=null;
			progress.percent=0;
		}
			
		if (file!=null)
		{
			if (file.listener!=null) file.listener.onLoadProgress(file, progress.bytesLoaded, progress.bytesTotal, progress.percent);
			dispatchEvent( { type: "onFileProgress", file: file, bytesLoaded: progress.bytesLoaded, bytesTotal: progress.bytesTotal, percent: progress.percent } );
			
			if (progress.percent>=100)
			{
				var memFile:FileItem=file;
				if (_enablePile && pileIndex>=0)
				{
					pile.splice( pileIndex,1 );
				}
				else
				{
					currentFile=null;
					dispatchEvent( { type: "onQueueProgress", file: memFile, filesLoaded: filesLoaded, filesTotal: filesTotal, percent: Math.floor(filesLoaded*100/filesTotal) } );
				}
				dispatchEvent( { type: "onFileComplete", file: memFile } );
				if (memFile.listener!=null) memFile.listener.onLoadComplete(memFile);
			}
		}
	}
	
	/**
	 * Gets called if the current file is finished loading, or the loading process has just started.
	 * It removes the next file from the queue and sets it as the currentFile
	 */
	private function nextFile():Void
	{
		while (queue.length>0 && currentFile==null)
		{
			currentFile = FileItem(queue.pop());
			filesLoaded++;
			if (currentFile.target==null) currentFile=null;
		}
		
		if (currentFile==null)
		{
			if (!_enablePile || pile.length<=0)
			{
				stopLoading();
				if (_debugMode) trace( "Priority loading done" );
				dispatchEvent( { type: "onQueueComplete" } );
			}
		}
		else
		{
			if (_debugMode) trace( "Loading file \""+currentFile.src+"\" into target "+currentFile.target );
			
			dispatchEvent( { type: "onFileStart", file: currentFile } );
			// loadMovie command can be prevented by returning true from the onLoadStart handler
			// as in some cases you might want to do something different in the onLoadStart handler
			if (currentFile.listener!=null && currentFile.listener.onLoadStart(currentFile)) return;
			else currentFile.load();
		}
	}
	
	public function isEmpty():Boolean
	{
		return (queue.length==0);
	}
	
	/**
	 * Getter / Setter for debugMode
	 */
	public function get debugMode():Boolean { return _debugMode; }
	public function set debugMode(value:Boolean):Void { _debugMode=value; }
	
	public function get enterFrameBeaconDepth():Number { return _enterFrameBeaconDepth; }
	public function set enterFrameBeaconDepth(value:Number):Void { _enterFrameBeaconDepth=value; }
	
	public function get enablePile():Boolean { return _enablePile; }
	public function set enablePile(value:Boolean):Void { _enablePile=value; }
}
