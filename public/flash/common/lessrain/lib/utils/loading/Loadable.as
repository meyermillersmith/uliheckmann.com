/**
 * lessrain.lib.utils.loading.Loadable, Version 1.0
 * 
 * Loadable objects can be used to build your custom load/progress behaviour, without using MovieClips, XML etc.
 * 
 * The following example shows how loading behaviour can be modified.
 * It waits for the getBytesLoaded method to be called 100 times.
 * 
 * <code>
 * import lessrain.lib.utils.loading.Loadable
 * 
 * class SomethingLoadable implements Loadable
 * {
 *	private var counter:Number;
 * 
 * 	public function SomethingLoadable()
 * 	{
 * 		PriorityLoader.getInstance().addFile(this, "", null, 10);
 * 	}
 * 	
 * 	function load(url:String):Void
 * 	{
 * 		counter=0;
 * 	}
 * 	function getBytesLoaded():Number
 * 	{
 * 		return ++counter;
 * 	}
 * 	function getBytesTotal():Number
 * 	{
 * 		return 100;
 * 	}
 * 	
 * }
 * </code>
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 1.0
 * @see: lessrain.lib.utils.loading.PriorityLoader
 */

interface lessrain.lib.utils.loading.Loadable
{
	/**
	 * @param	url		The URL of the file to be loaded
	 */
	function load(url:String):Void;
	
	/**
	 * @return	The Number of bytes loaded
	 */
	function getBytesLoaded():Number;
	
	/**
	 * @return	The Number of total bytes
	 */
	function getBytesTotal():Number;
}
