/**
 * LRContextMenu
 * @ version 1.1
 * @ author  luis.martinez@lessrain.com
 * @ The LRContextMenu class provides runtime control over the items in the Flash Player context menu,
 *   which appears when a user right-clicks (Windows) or Control-clicks (Macintosh) on Flash Player.
 * @
 */
import mx.events.EventDispatcher;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.StringUtils;

class lessrain.lib.utils.LRContextMenu
{
	private var target_o:Object;
	private var cm:ContextMenu;
	private var cmData:Array;
	
	// required for EventDispatcher:
	private var dispatchEvent : Function;
	public var addEventListener : Function;
	public var removeEventListener : Function;

	
	/**
	 * Constructor
	 * 
	 * @param	target	      Where to attach a ContextMenu object 
	 *                        (button, movie clip, text field object, or an entire movie level). 
	 */
	 
	public function LRContextMenu(target:Object){
		
		target_o=target;
		cm=new ContextMenu();
		cmData=new Array();
		
		EventDispatcher.initialize(this);
		
	}
	
	/**
	 * Creates a new ContextMenuItem object that can be added to the ContextMenu.customItems array.
	 * 
	 * @param	label          A string that specifies the text associated with the menu item.
	 * @param	id             A string that specifies the id associated with the menu item.
	 * @param	handler        A function that you define, which is called when the menu item is selected.
	 * @param	separator      [optional] A Boolean value that indicates whether a separator bar should appear above the menu item in the context menu.
	 *                         The default value is false.
	 */
	 
	public function addItem(label:String,id:String,handler:Function,separator:Boolean):Void {
		
		var tempCM:ContextMenuItem=new ContextMenuItem(label, Proxy.create(this,dispatchItemData));
		if(separator) tempCM.separatorBefore=true;
		cm.customItems.push(tempCM);
		cmData.push({label:label,id:id,handler:handler});
		cm.hideBuiltInItems();
		target_o.menu = cm;
		
	}
	 
	/**
	 * Returns a menu item. (by id or label)
	 * 
	 * @param	item            A String that specifies the label or id associated with the menu item.
	 * @param	type            A String that specifies the type of the item string (id or label) to perform the search.
	 */
	public function getItem(item:String, type:String):ContextMenuItem
	{
		var finder:Number=ArrayUtils.findKeyPosition(cmData, type, item);
		return cm.customItems[finder];
	}
	
	/**
	 * Enable or disable a specified menu item.
	 * 
	 * @param	e              A Boolean value that indicates whether the specified menu item is enabled or disabled.
	 */
	 
	public function enableItems(e:Boolean):Void
	{
		var l:Number=cm.customItems.length;
		for(var i:Number=0;i<l;++i) cm.customItems[i].enabled=e;
		
	}
	
	/**
	 * Enable all menu items except one. (by id or label)
	 * 
	 * @param	item            A String that specifies the label or id associated with the menu item.
	 * @param	type            A String that specifies the type of the item string (id or label) to perform the search.
	 */
	 
	public function enableAllExcept(item:String,type:String):Void
	{
		var l:Number=cm.customItems.length;
		var finder:Number=ArrayUtils.findKeyPosition(cmData, type, item);
		for(var i:Number=0;i<l;++i) {
			cm.customItems[i].enabled=(i!=finder)? true : false; 
		}
		
	}
	
	/**
	 * Remove menu item. (by id or label)
	 * 
	 * @param	item            A String that specifies the label or id associated with the menu item.
	 * @param	type            A String that specifies the type of the item string (id or label) to perform the search.
	 */
	 
	public function removeItem(item:String,type:String):Void
	{

		var finder:Number=ArrayUtils.findKeyPosition(cmData, type, item);
		ArrayUtils.deleteAt(cm.customItems,finder);
		ArrayUtils.deleteAt(cmData,finder);

	}
	
	/**
	 * Visible state for a menu item. (by id or label)
	 * 
	 * @param	item            A String that specifies the label or id associated with the menu item.
	 * @param	v               A Boolean value that indicates whether the specified menu item is visible when the Flash Player context menu is displayed.
	 */
	 
	public function visible(item:String,v:Boolean):Void
	{

		var finder:Number=ArrayUtils.findKeyPosition(cm.customItems, 'caption', item);
		cm.customItems[finder].visible=v;


	}
	
	/** 
	*   Dispatches a onSelect event when the specified menu item is selected from the Flash Player context menu.
	*   The specified callback handler receives two parameters: obj, a reference to the object under the mouse when
	*   the user invoked the Flash Player context menu, and item, a reference to the ContextMenuItem object that
	*   represents the selected menu item.
	*/

	private function dispatchItemData(obj:Object,item:Object):Void
	{
		var label:String=item.caption;
		var finder:Object=ArrayUtils.findKeyValue(cmData, 'label', label);
		var id:String=finder.id;
		var handler:Function=finder.handler;
		dispatchEvent (
			{
				type : "onSelect", 
				target : this,
				label:label,
				id:id,
				handler:handler
			}
			);
	}
	
	
	
	
}
