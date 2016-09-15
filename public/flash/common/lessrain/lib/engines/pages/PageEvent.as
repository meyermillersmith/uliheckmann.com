import lessrain.lib.utils.events.IEvent;
import lessrain.lib.engines.pages.Page;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.engines.pages.PageEvent implements IEvent
{
	public static var PAGE_CHANGE:String = "pageChange";
	public static var PAGE_INITIALIZED:String = "pageInitialized";
	public static var PAGE_SHOWING:String = "pageShowing";
	public static var PAGE_HIDDEN:String = "pageHidden";
	
	private var _type : String;
	private var _page:Page;
	
	public function PageEvent(type_:String, page_:Page)
	{
		_type = type_;
		_page = page_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getPage():Page
	{
		return _page;
	}

}