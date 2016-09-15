import lessrain.lib.utils.events.IEvent;
import lessrain.projects.uliheckmann.gallerypage.Image;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.ImageEvent implements IEvent
{
	public static var IMAGE_LOADED:String = "imageLoaded";
	public static var IMAGE_SHOWING:String = "imageShowing";
	public static var IMAGE_HIDDEN:String = "imageHidden";
	
	private var _type : String;
	private var _galleryImage : Image;
	
	public function ImageEvent(type_:String, galleryImage_:Image)
	{
		_type = type_;
		_galleryImage=galleryImage_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getImage() : Image
	{
		return _galleryImage;
	}
}