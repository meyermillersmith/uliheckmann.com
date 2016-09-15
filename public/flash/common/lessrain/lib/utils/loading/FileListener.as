/**
 * lessrain.lib.utils.loading.FileListener, Version 1.0
 * 
 * FileListener objects are notified when the loading of their target starts, every enterFrame of progress and when it's finished loading.
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 1.0
 * @see: lessrain.lib.utils.loading.PriorityLoader
 * @see: lessrain.lib.utils.loading.PriorityLoader
 */
 
import lessrain.lib.utils.loading.FileItem;

interface lessrain.lib.utils.loading.FileListener
{
	/**
	 * @param	file		The FileItem that starts loading
	 * 								You can access the different properties of the FileItem, e.g.
	 * 								file.id
	 * 								file.description
	 * 								file.target
	 * 								file.src
	 * 								...
	 * @return				<code>true</code> if the load/loadMovie command is handled by the FileListener 
     *                 				and the implicit load command should not be executed;
     *                 				<code>false</code> if the File object should take care of the load command.
	 */
	public function onLoadStart(file:FileItem):Boolean;
	
	/**
	 * @param	file		The FileItem that has finished loading
	 */
	public function onLoadComplete(file:FileItem):Void;
	
	/**
	 * @param	file				The FileItem that is currently loading
	 * @param	bytesLoaded	Number of Bytes loaded from the file
	 * @param	bytesTotal		Number of total Bytes of the file
	 * @param	percent			Percentage loaded from the file
	 */
	public function onLoadProgress(file:FileItem, bytesLoaded:Number, bytesTotal:Number, percent:Number):Void;
}