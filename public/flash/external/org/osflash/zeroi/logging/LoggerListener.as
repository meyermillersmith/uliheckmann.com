/**
 * The interface of a listener to the logger
 *  
 * @author Ralf Bokelberg <ralf.bokelberg@gmail.com>
 *  @license LGPL
 */
interface org.osflash.zeroi.logging.LoggerListener
{
	public function log( type:String, message:String):Void;
	
}