import lessrain.lib.utils.events.IEvent;
import lessrain.projects.uliheckmann.navigation.NavigationNode;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.navigation.NavigationNodeEvent implements IEvent
{
	public static var FILL_LOADED:String = "fillLoaded";
	public static var NODE_SHOWING:String = "nodeShowing";
	public static var NODE_HIDDEN:String = "nodeHidden";
	public static var ROLL_OVER:String = "rollOver";
	public static var ROLL_OUT:String = "rollOut";	public static var RELEASE:String = "release";
	
	private var _type : String;
	private var _navigationNode:NavigationNode;
	
	public function NavigationNodeEvent(type_:String, navigationNode_:NavigationNode)
	{
		_type = type_;
		_navigationNode = navigationNode_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function getNavigationNode():NavigationNode
	{
		return _navigationNode;
	}
}