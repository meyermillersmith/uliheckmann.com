/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */


import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.movieclip.CustomContextMenu;

class lessrain.lib.utils.movieclip.CustomContextMenuEvent implements IEvent
{
	private var _type        		: String;
	private var _cm         		: CustomContextMenu;
	
	public static var SELECT 		: String = "select";
	public static var SELECT_ITEM 	: String = "selectItem";

	public function CustomContextMenuEvent (type_:String,cm_:CustomContextMenu)
	{			
		_type=type_;
		_cm=cm_;
	}
	
	public function getType() : String {return _type;}
	public function getCustomContextMenu() : CustomContextMenu {return _cm;}


}