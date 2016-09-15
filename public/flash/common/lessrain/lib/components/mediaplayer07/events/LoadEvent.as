/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.utils.events.IEvent;

class lessrain.lib.components.mediaplayer07.events.LoadEvent implements IEvent 
{
	public static var LOAD_START:String 	= "onLoadStart";
	public static var LOAD_PROGRESS:String 	= "onLoadProgress";
	public static var LOAD_COMPLETE:String 	= "onLoadComplete";
	
	private var _type 			: String;
	private var _target			: AbstractMediaPlayer;
	private var _bytesLoaded	: Number;	private var _bytesTotal		: Number;
	
	public function LoadEvent( type_:String, target_:AbstractMediaPlayer, bytesLoaded_:Number, bytesTotal_:Number )
	{
		_type 	= type_;
		_target = target_;
		_bytesLoaded = bytesLoaded_;
		_bytesTotal = bytesTotal_;
	}
	
	public function getType(): String
	{
		return _type;
	}
	
	public function getTarget():AbstractMediaPlayer {
		return _target;
	}
	
	// Getter & setter

	public function get bytesLoaded():Number
	{
		return _bytesLoaded;
	}
	
	public function get bytesTotal():Number
	{
		return _bytesTotal;
	}	
}
