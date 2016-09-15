import lessrain.lib.utils.loading.GroupLoader;
/**
 * lessrain.lib.utils.loading.GroupListener, Version 1.0
 * 
 * GroupListener objects are notified about the progress of the GroupLoader files.
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 1.0
 * @see: lessrain.lib.utils.loading.GroupLoader
 * @see: mx.events.EventDispatcher
 */

interface lessrain.lib.utils.loading.GroupListener
{
	/**
	 * Gets called when the group of files starts loading
	 * @param	description		Text/Description of the group
	 */
	public function onGroupStart(groupLoader:GroupLoader):Void;
	
	/**
	 * Gets called once the whole group of files has been loaded
	 * @param	description		Text/Description of the group
	 */
	public function onGroupComplete(groupLoader:GroupLoader):Void;
	
	/**
	 * Gets called everytime enterframe, and gives information of the overall progress
	 * 
	 * @param	filesLoaded	Number of FileItems loaded from the queue
	 * @param	filesTotal		Number of total FileItems in the queue
	 * @param	bytesLoaded	Number of Bytes loaded from the all files
	 * @param	bytesTotal		Number of total Bytes of all files
	 * @param	percent			Percentage loaded from the group	 * @param	description		Text/Description of the group
	 */
	public function onGroupProgress(filesLoaded:Number, filesTotal:Number, bytesLoaded:Number, bytesTotal:Number, percent:Number, groupLoader:GroupLoader):Void;
}
