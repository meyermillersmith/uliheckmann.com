/**
 * lessrain.lib.utils.loading.QueueListener, Version 1.0
 * 
 * QueueListener objects are notified about the overall progress of the PriorityLoader queue.
 * 
 * To register an event listener:
 * 
 * <code>
 * import lessrain.lib.utils.loading.PriorityLoader;
 * import lessrain.lib.utils.loading.QueueListener;
 * import lessrain.lib.utils.loading.FileItem;
 * class Test implements QueueListener
 * {
 * 	public function Test()
 * 	{
 * 		PriorityLoader.getInstance().addEventListener("onFileStart", this);
 * 		PriorityLoader.getInstance().addEventListener("onFileProgress", this);
 * 		PriorityLoader.getInstance().addEventListener("onFileComplete", this);
 * 
 * 		PriorityLoader.getInstance().addEventListener("onQueueStart", this);
 * 		PriorityLoader.getInstance().addEventListener("onQueueProgress", this);
 * 		PriorityLoader.getInstance().addEventListener("onQueueComplete", this);
 * 	}
 * 	public function onFileStart(eventObject:Object):Void
 * 	{
 * 	}
 * 	public function onFileComplete(eventObject:Object):Void
 * 	{
 * 	}
 * 	public function onFileProgress(eventObject:Object):Void
 * 	{
 * 	}
 * 	public function onQueueStart():Void
 * 	{
 * 	}
 * 	public function onQueueComplete():Void
 * 	{
 * 	}
 * 	public function onQueueProgress(eventObject:Object):Void
 * 	{
 * 	}
 * </code>
 * 
 * To remove an event listener:
 * <code>
 * PriorityLoader.getInstance().removeEventListener("onFileStart", this);
 * PriorityLoader.getInstance().removeEventListener("onFileProgress", this);
 * PriorityLoader.getInstance().removeEventListener("onFileComplete", this);
 * 
 * PriorityLoader.getInstance().removeEventListener("onQueueStart", this);
 * PriorityLoader.getInstance().removeEventListener("onQueueProgress", this);
 * PriorityLoader.getInstance().removeEventListener("onQueueComplete", this);
 * </code>
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 1.0
 * @see: lessrain.lib.utils.loading.PriorityLoader
 * @see: mx.events.EventDispatcher
 */

interface lessrain.lib.utils.loading.QueueListener
{
	/**
	 * Gets called everytime a FileItem starts loading
	 * 
	 * @param	eventObject	The EventObject contains the following properties:
	 * 										file				The FileItem that starts loading
	 * 										You can access the different properties of the FileItem, e.g.
	 * 										file.id
	 * 										file.description
	 * 										file.target
	 * 										file.src
	 */
	public function onFileStart(eventObject:Object):Void;
	
	/**
	 * Gets called everytime a FileItem has completed loading
	 * 
	 * @param	eventObject	The EventObject contains the following properties:
	 * 										file				The FileItem that has just finished loading
	 */
	public function onFileComplete(eventObject:Object):Void;
	
	/**
	 * Gets called every enterFrame and gives information about the progress of the current loading process
	 * 
	 * @param	eventObject	The EventObject contains the following properties:
	 * 										file				The FileItem that is currently loading
	 * 										bytesLoaded	Number of Bytes loaded from the file
	 * 										bytesTotal		Number of total Bytes of the file
	 * 										percent			Percentage loaded from the file
	 */
	public function onFileProgress(eventObject:Object):Void;


	/**
	 * Gets called when the queue starts loading, i.e. when a file is added to a previously inactive PriorityLoader
	 */
	public function onQueueStart():Void;
	
	/**
	 * Gets called once the whole queue has been loaded
	 */
	public function onQueueComplete():Void;
	
	/**
	 * Gets called everytime a FileItem has finished loading, and gives information of the overall progress
	 * 
	 * @param	eventObject	The EventObject contains the following properties:
	 * 										file				The FileItem that has just finished loading
	 * 										filesLoaded	Number of FileItems loaded from the queue
	 * 										filesTotal		Number of total FileItems in the queue
	 * 										percent			Percentage loaded from the queue
	 */
	public function onQueueProgress(eventObject:Object):Void;
}
