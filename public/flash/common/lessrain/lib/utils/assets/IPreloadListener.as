/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
interface lessrain.lib.utils.assets.IPreloadListener
{
	/**
	 * Gets called once all assets (fonts, css, main) are loaded
	 */
	public function onPreloadComplete():Void;
	
	/**
	 * Gets called every enterframe, and gives information of the preloading progress
	 * 
	 * @param	filesLoaded	Number of FileItems loaded from the queue
	 * @param	filesTotal		Number of total FileItems in the queue
	 * @param	bytesLoaded	Number of Bytes loaded from the all files
	 * @param	bytesTotal		Number of total Bytes of all files
	 * @param	percent			Percentage loaded from the group
	 */
	public function onPreloadProgress(filesLoaded:Number, filesTotal:Number, bytesLoaded:Number, bytesTotal:Number, percent:Number):Void;
}