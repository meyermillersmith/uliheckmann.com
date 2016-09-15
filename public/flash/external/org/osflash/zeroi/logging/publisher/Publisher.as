/**
 * The interface of a listener to the logger
 *  
 * @author Ralf Bokelberg <ralf.bokelberg@gmail.com>
 *  @license LGPL
 */
interface org.osflash.zeroi.logging.publisher.Publisher
{
	public function publish( type:String, message:String, messageAr:Array):Void;
	
}