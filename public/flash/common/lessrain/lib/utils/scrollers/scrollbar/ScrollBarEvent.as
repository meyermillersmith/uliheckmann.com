/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */


import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.scrollers.scrollbar.AbstractScrollBar;

class lessrain.lib.utils.scrollers.scrollbar.ScrollBarEvent implements IEvent
{
	private var _type 							: String;
	private var _scrollbar 						: AbstractScrollBar;
	
	public static var CHANGE					: String = "change";
	public static var START_DRAG				: String = "startDrag";
	public static var STOP_DRAG					: String = "stopDrag";
	
	public static var SCROLL_UP					: String = "scrollUp";
	public static var SCROLL_DOWN				: String = "scrollDown";
	public static var SCROLL_LEFT				: String = "scrollLeft";
	public static var SCROLL_RIGHT				: String = "scrollRight";
	
	public static var TRAY_CLICK	 			: String = "trayClick";
	public static var CONTEXTMENU_SELECT	 	: String = "contextMenuSelect";

	public function ScrollBarEvent (type_:String,scrollbar_:AbstractScrollBar)
	{			
		_type=type_;
		_scrollbar=scrollbar_;
	}
	
	public function getType() : String {return _type;}
	public function getScrollBar() : AbstractScrollBar {return _scrollbar;}


}