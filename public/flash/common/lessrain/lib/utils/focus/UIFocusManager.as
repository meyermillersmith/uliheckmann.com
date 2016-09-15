/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import flash.geom.Point;
import flash.geom.Rectangle;

import lessrain.lib.utils.focus.IFocus;
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.focus.UIFocusManager 
{
	private var _list:Array;
	private var _listID:Array;
	private var _listPoint:Array;
	private var _listRect : Array;
	
	public static var MC_NAME:String = "__UIFocusMC";
	public static var MC_DEPTH:Number = -9991;
	public static var MC_ROOT:MovieClip = _level0;
	
	private var _uiFocusMC:MovieClip;
	
	private static var instance : UIFocusManager;

	private var _dataLength : Number;

	
	public static function getInstance() : UIFocusManager 
	{
		if (instance == null)instance = new UIFocusManager();
		return instance;
	}
	
	private function UIFocusManager() 
	{
		_list=new Array();
		_listID=new Array();
		_listPoint=new Array();
		_listRect=new Array();
		
		_dataLength=0;
		
		_uiFocusMC= MC_ROOT.createEmptyMovieClip (MC_NAME, MC_DEPTH);
	}
	
	/**
	 * Add item to all lists
	 * If there are no items in the list then 
	 * add MouseMove event once.
	 */
	public function addItem(item_:IFocus, rect_:Rectangle, id_:String):Void
	{
		_list.push(item_);
		
		if(_dataLength==0)addMouseMove();
		
		var itemMC:MovieClip=MovieClip(item_.getTargetMC());

		if(rect_==null) _listRect.push(new Rectangle(0,0,itemMC._width,itemMC._height));
		else _listRect.push(rect_);
		
		if(id_==null) _listID.push(itemMC.name);

		var tempP:Point=locationTrans(itemMC, _uiFocusMC, new Point(_uiFocusMC._x,_uiFocusMC._y));
		var p:Point=new Point(tempP.x,tempP.y);
		_listPoint.push(p);
		
		_dataLength=_list.length;
	}
	
	/**
	 * Remove item from all lists
	 * If there are no items in the list then 
	 * removes MouseMove event
	 */
	public function removeItem(item_:IFocus):Void
	{
		
		var i:Number=_dataLength;
		var index_:Number;
		while(--i>-1)
		{
			if(_list[i]==item_)
			{
				index_=i;
				break;
			}
		}
		
		if(index_!=null)
		{
			_list.splice(index_,1);
			_listID.splice(index_,1);
			_listPoint.splice(index_,1);
			_listRect.splice(index_,1);
		}
		_dataLength=_list.length;
		
		if(_dataLength<1)removeMouseMove();
	}
	
	/**
	 * Update _listrect array
	 * Use it when the item width and height
	 */
	public function updateRect(item_:IFocus,rect_:Rectangle):Void
	{
		var i:Number=_dataLength;
		while(--i>-1)
		{
			if(_list[i]==item_)
			{
				_listRect[i]=rect_;
				break;
			}
		}
	}
	
	/**
	 * Update _listPoint array
	 * Use it when the item changes x and y coordinates
	 */
	public function updateItemPoint(item_:IFocus):Void
	{
		var i:Number=_dataLength;
		while(--i>-1)
		{
			if(_list[i]==item_)
			{
				var itemMC:MovieClip=MovieClip(item_.getTargetMC());
				var tempP:Point=locationTrans(itemMC, _uiFocusMC, new Point(_uiFocusMC._x,_uiFocusMC._y));
				var p:Point=new Point(tempP.x,tempP.y);
				_listPoint[i]=p;
				break;
			}
		}
	}
	
	/**
	 * Loop thru all the items in the list to 
	 * detect when the mouse is over.
	 */
	private function mouseMove():Void
	{

		var tx:Number=_uiFocusMC._xmouse;
		var ty:Number=_uiFocusMC._ymouse;
		
		var i:Number=_dataLength;
		var itemF:IFocus;
		while(--i>-1)
		{
			itemF = _list[i];
			var px:Number=_listPoint[i].x;
			var py:Number=_listPoint[i].y;
			var maxW:Number=px+_listRect[i].width;
			var maxH:Number=py+_listRect[i].height;
			
			
			if((tx>=px) && (tx<=maxW) && (ty>=py) && (ty<=maxH))
			{
				if(!itemF.isFocus()) itemF.setFocus();
			}else{
				if(itemF.isFocus()) itemF.killFocus();
			}
		}
	}
	
	/**
	 * Add mouseMove event to _uiFocusMC 
	 */
	private function addMouseMove():Void
	{
		_uiFocusMC.onMouseMove=Proxy.create(this,mouseMove);	
	}
	
	/**
	 * Remove mouseMove event to _uiFocusMC 
	 */
	private function removeMouseMove():Void
	{
		delete _uiFocusMC.onMouseMove;
		_dataLength=0;
	}
	/**
	 * Transform the position in fromMC_ to toMC_ and return it.
	 */
	private function locationTrans(fromMC_:MovieClip, toMC_:MovieClip, p:Point):Point
	{
		fromMC_.localToGlobal(p);
		toMC_.globalToLocal(p);
		return p;
	}
	
	public function get list() : Array { return _list; }
	public function set list( value:Array ) { _list = value; }
	
	public function get listID() : Array { return _listID; }
	public function set listID( value:Array ) { _listID = value; }
	
	public function get listPoint() : Array { return _listPoint; }
	public function set listPoint( value:Array ) { _listPoint = value; }
	
	public function get listRect() : Array { return _listRect; }
	public function set listRect( value:Array ) { _listRect = value; }
	
	public function get dataLength() : Number { return _dataLength; }
	public function set dataLength( value:Number ) { _dataLength = value; }

}