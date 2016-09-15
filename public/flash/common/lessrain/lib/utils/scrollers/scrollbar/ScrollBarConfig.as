/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import lessrain.lib.utils.scrollers.scrollbar.IScrollBarFactory;
import lessrain.lib.utils.scrollers.scrollbar.SampleScrollBarFactory;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarTrayMode;

class lessrain.lib.utils.scrollers.scrollbar.ScrollBarConfig 
{
	public static var TRAY_MODE			: String			=	ScrollBarTrayMode.TO_POINT_TWEEN;
	public static var ADD_CONTEXT_MENU	: Boolean			=	true;
	public static var SCROLLBAR_FACTORY	: IScrollBarFactory	=	new SampleScrollBarFactory();
	
	/**
	 * Number of ticks for scrollpage 
	 * interval when the tray mode is set BY_PAGE
	 */
	public static var SCROLL_PAGE_TICKS	: Number	=	60;
}