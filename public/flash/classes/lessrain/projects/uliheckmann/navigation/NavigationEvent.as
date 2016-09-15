import lessrain.lib.utils.events.IEvent;
import lessrain.projects.uliheckmann.navigation.NavigationNode;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.navigation.NavigationEvent implements IEvent
{
	public static var ITEM_SELECTED:String = "itemSelected";
	public static var SHOWING:String = "nodesShowing";
	public static var HIDDEN:String = "nodesHidden";
	
	private var _type : String;
	private var _selectedNode:NavigationNode;
	
	public function NavigationEvent(type_:String, selectedNode_:NavigationNode)
	{
		_type = type_;
		_selectedNode = selectedNode_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getSelectedNode():NavigationNode
	{
		return _selectedNode;
	}
}