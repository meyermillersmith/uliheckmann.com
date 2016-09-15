import lessrain.lib.utils.events.IEvent;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.GalleryLetterEvent implements IEvent
{
	public static var RELEASE:String = "letterRelease";
	
	private var _type : String;	private var _id : String;
	
	public function GalleryLetterEvent(type_:String, id_:String)
	{
		_type = type_;
		_id = id_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getID() : String
	{
		return _id;
	}
}