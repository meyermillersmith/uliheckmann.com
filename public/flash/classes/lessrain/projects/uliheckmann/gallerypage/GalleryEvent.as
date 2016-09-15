import lessrain.lib.utils.events.IEvent;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.GalleryEvent implements IEvent
{
	public static var IMAGE_SELECT:String = "imageSelect";
	public static var IMAGE_HIDDEN:String = "imageHidden";
	public static var IMAGE_SHOWING:String = "imageShowing";
	public static var SLIDESHOW_DONE:String = "slideshowDone";
	public static var GOTO_ARCHIVE:String = "gotoArchive";
	
	private var _type : String;	private var _imageID : String;
	private var _pos : Number;
	
	public function GalleryEvent(type_:String, imageID_:String, pos_:Number)
	{
		_type = type_;
		_imageID = imageID_;
		_pos = pos_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getImageID() : String
	{
		return _imageID;
	}
	
	public function getPos() : Number
	{
		return _pos;
	}
}