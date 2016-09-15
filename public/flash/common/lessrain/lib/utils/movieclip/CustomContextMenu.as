/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 * The CustomContextMenu class provides runtime control over the items 
 * in the Flash Player context menu,which appears when a user 
 * right-clicks (Windows) or Control-clicks (Macintosh) on Flash Player.
 * 
 */
 
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.movieclip.CustomContextMenuEvent;
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.movieclip.CustomContextMenu implements IDistributor
{
	private var _eventDistributor : EventDistributor;
	
	//(button, movie clip, text field object, or an entire movie level). 
	private var _displayObject    : Object;
	
	private var _cm            	  : ContextMenu;
	private var _cmData		   	  : Array;
	private var _cmDataLength	  : Number;

	private var _selectedLabel 	  : String;
	private var _selectedID       : String;
	
	private var _selectEvent	  : CustomContextMenuEvent;
	private var _selectItemEvent  : CustomContextMenuEvent;

	public function CustomContextMenu() 
	{
		_eventDistributor 	= 	new EventDistributor();
		_cm					=	new ContextMenu();
		_cm.onSelect		=	Proxy.create(this,contextMenuSelect);
		
		_cmData=new Array();
		
		_selectEvent 		= new CustomContextMenuEvent( CustomContextMenuEvent.SELECT,this );
		_selectItemEvent 	= new CustomContextMenuEvent( CustomContextMenuEvent.SELECT_ITEM,this );
	}
	
	private function contextMenuSelect(obj_:Object, menu_:ContextMenu):Void
	{
		distributeEvent( _selectEvent );
	}
	
	/**
	 * Creates a new ContextMenuItem object that can be added to the ContextMenu.customItems array.
	 * 
	 * @param	label_          A string that specifies the text associated with the menu item.
	 * @param	id_             A string that specifies the id associated with the menu item.
	 * @param	separator_      [optional] A Boolean value that indicates whether a separator bar 
	 * 							should appear above the menu item in the context menu.
	 *                          The default value is false.
	 */
	public function addItem(label_:String,id_:String,separator_:Boolean):Void {
		
		var temp_cm:ContextMenuItem=new ContextMenuItem(label_, Proxy.create(this,distributeItemData));
		if(separator_) temp_cm.separatorBefore=true;
		
		_cm.customItems.push(temp_cm);
		
		_cmData.push({label:label_,id:id_});
		_cmDataLength=_cmData.length;
		
		_cm.hideBuiltInItems();
		
		_displayObject["menu"] = _cm;
		
	}
	
	/**
	 * Enable all items.
	 * 
	 * @param enabled_ A Boolean value that indicates whether the 
	 * 		  items are enabled or disabled.
	 */
	public function enableAll():Void
	{
		var i:Number=_cm.customItems.length;
		while(--i>-1) ContextMenuItem(_cm.customItems[i]).enabled=true;
	}
	
	/**
	 * Disable all items.
	 * 
	 * @param enabled_ A Boolean value that indicates whether the 
	 * 		  items are enabled or disabled.
	 */
	public function disableAll():Void
	{
		var i:Number=_cm.customItems.length;
		while(--i>-1) ContextMenuItem(_cm.customItems[i]).enabled=false;
	}
	
	/**
	 * Enable specific item.(by label or id)
	 * 		  
	 * @param label_ 	A String that specifies the label associated with the menu item.
	 * @param id_ 		A String that specifies the id associated with the menu item.	  
	 */
	public function enableItem( label_:String, id_:String):Void
	{
		var tempIndex:Number;
		
		if(label_!=null) tempIndex = getKeyIndex('label', label_);
		else tempIndex = getKeyIndex('id', id_);
		
		ContextMenuItem(_cm.customItems[tempIndex]).enabled=true;
	}
	
	/**
	 * Disable specific item.(by label or id)
	 * 		  
	 * @param label_ 	A String that specifies the label associated with the menu item.
	 * @param id_ 		A String that specifies the id associated with the menu item.		  
	 */
	public function disableItem( label_:String, id_:String):Void
	{
		var tempIndex:Number;
		
		if(label_!=null) tempIndex = getKeyIndex('label', label_);
		else tempIndex = getKeyIndex('id', id_);
		
		ContextMenuItem(_cm.customItems[tempIndex]).enabled=false;
	}
	
	/**
	 * Enable all menu items except one. (by label or id)
	 * 
	 * @param label_ 	A String that specifies the label associated with the menu item.
	 * @param id_ 		A String that specifies the id associated with the menu item.
	 */
	public function enableAllExcept(label_:String, id_:String):Void
	{
		var tempIndex:Number;
		
		if(label_!=null) tempIndex = getKeyIndex('label', label_);
		else tempIndex = getKeyIndex('id', id_);
		
		var i:Number = _cmDataLength;
		while (--i > -1) 
		{
			if (i == tempIndex)ContextMenuItem(_cmData[i]).enabled=false;
			else ContextMenuItem(_cmData[i]).enabled=true;
		}
	}
	
	/**
	 * Disable all menu items except one. (by label or id)
	 * 
	 * @param label_ 	A String that specifies the label associated with the menu item.
	 * @param id_ 		A String that specifies the id associated with the menu item.
	 */
	public function disableAllExcept(label_:String, id_:String):Void
	{
		var tempIndex:Number;
		
		if(label_!=null) tempIndex = getKeyIndex('label', label_);
		else tempIndex = getKeyIndex('id', id_);
		
		var i:Number = _cmDataLength;
		while (--i > -1) 
		{
			if (i == tempIndex)ContextMenuItem(_cmData[i]).enabled=true;
			else ContextMenuItem(_cmData[i]).enabled=false;
		}
	}
	
	/**
	 * Remove menu item. (by id or label)
	 * 
	 * @param label_ 	A String that specifies the label associated with the menu item.
	 * @param id_ 		A String that specifies the id associated with the menu item.
	 */
	 
	public function removeItem(label_:String, id_:String):Void
	{
		var tempIndex:Number;
		
		if(label_!=null) tempIndex = getKeyIndex('label', label_);
		else tempIndex = getKeyIndex('id', id_);
		
		deleteItemAt (_cm.customItems, tempIndex);
		deleteItemAt (_cmData, tempIndex);
	}
	
	/**
	 * Visible state for a menu item. (by label or id)
	 * 
	 * @param visible_ 	A Boolean value that indicates whether the specified menu item is 
	 * 					visible when the Flash Player context menu is displayed.
	 * 					
	 * @param label_ 	A String that specifies the label associated with the menu item.
	 * @param id_ 		A String that specifies the id associated with the menu item.
	 */
	 
	public function visibleItem(visible_:Boolean, label_:String, id_:String):Void
	{
		var tempIndex:Number;
		
		if(label_!=null) tempIndex = getKeyIndex('label', label_);
		else tempIndex = getKeyIndex('id', id_);
		
		ContextMenuItem(_cm.customItems[tempIndex]).visible=false;
	}
	
	/** 
	*   Distribute an event [SELECT] when the specified menu item is selected from the 
	*   Flash Player context menu.
	*   
	*   The specified callback handler receives two parameters: obj, a reference to the 
	*   object under the mouse when the user invoked the Flash Player context menu, and
	*   item, a reference to the ContextMenuItem object that represents the selected menu item.
	*/
	private function distributeItemData(cmObj_:Object,cmItem_:Object):Void
	{
		_selectedLabel=cmItem_["caption"];
		
		var key:Object=getKeyValue('label', _selectedLabel);
		_selectedID=String(key["id"]);
		
		distributeEvent( _selectItemEvent );
	}
	
	/**
	 * Utils
	 */
	private function getKeyValue (key_:String, value_:Object):Object
	{
		var i:Number = _cmDataLength;
		while (--i > -1) if (_cmData[i][key_] == value_) return _cmData[i];
	}
	
	private function getKeyIndex (key_:String, value_:Object):Number
	{
		var i:Number = _cmDataLength;
		while (--i > -1) if (_cmData[i][key_] == value_) return i;
	}
	
	private function deleteItemAt (a_:Array, index_:Number):Void
    {
		if (index_ == 0) a_.shift ();
		else if (index_ == ( a_.length - 1)) a_.pop ();
		else if (index_ > 0 && index_ < ( a_.length - 1)) a_.splice (index_, 1);
	}
	
	/**
	 * Getter Setter
	 */
	public function get selectedLabel() : String { return _selectedLabel; }
	public function get selectedID() : String { return _selectedID; }
	
	public function get displayObject() : Object { return _displayObject; }
	public function set displayObject( value:Object ) { _displayObject = value; }
	
	/**
	 * IDistributor
	 */
	public function addEventListener(type : String, func : Function) : Void{_eventDistributor.addEventListener(type, func );}
	public function removeEventListener(type : String, func : Function) : Void{_eventDistributor.removeEventListener(type, func );}
	public function distributeEvent(eventObject : IEvent) : Void{_eventDistributor.distributeEvent(eventObject );}
	
	/**
	 * Destroy object
	 */
	public function destroy():Void
	{
		_eventDistributor.finalize();
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}	
	}
}