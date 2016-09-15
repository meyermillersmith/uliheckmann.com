/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.Gallery;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.lists.ListItem;
import lessrain.lib.components.mediaplayer07.skins.core.IListSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.utils.ArrayUtils;

class lessrain.lib.components.mediaplayer07.lists.List 
{
	/*
	 * Getter & setter
	 */	
	private var _targetMC	: MovieClip;
	private var _gallery	: Gallery;
	private var _medias		: Array;
	private var _listItems	: Array;
	private var _isActive	: Boolean;
	private var _skin		: IListSkin;
	private var _skinFactory: ISkinFactory;
	private var _itemXPos	: Number;
	private var _itemYPos	: Number;
	private var _activeListItem : ListItem;
	
	
	/*
	 * Constructor
	 */
	public function List( gallery_:Gallery, targetMC:MovieClip, medias_:Array, skinFactory_:ISkinFactory)
	{
		_targetMC = targetMC.createEmptyMovieClip("list_"+targetMC.getNextHighestDepth(), targetMC.getNextHighestDepth());
		_gallery = gallery_;
		_medias = medias_;
		_skinFactory = skinFactory_;
		_isActive = false;
		
		initialize();
	}
	
	/*
	 * Initializes list
	 */
	public function initialize() :Void
	{
//		_skin = _skinFactory.createListSkin( _targetMC, this);
		_skin.updateSkin();
		
		/*
		 Create lists
		 */
		_itemXPos = 0;
		_itemYPos = 0;
		_listItems = [];
		for (var i : Number = 0; i < _medias.length; i++) 
		{
			var item:ListItem = new ListItem( this, _targetMC, Media(_medias[i]),_skinFactory );
			_listItems.push( item );
			
			_itemXPos += item.width;
			_itemYPos += item.height;
		}
	}
	
	/*
	 * Activates list
	 */
	public function activate( autoSelect_:Boolean, direction_:Number ) :Void
	{
		_isActive = true;
		_skin.updateSkin();
		
		var firstItem:ListItem = ListItem( _listItems[0] );
		var lastItem:ListItem  = ListItem( _listItems[ _listItems.length-1 ] );
		
		if (autoSelect_)
		{
			switch (direction_)
			{
				case -1:	lastItem.onClick();
							break;
				case  1:	firstItem.onClick();
							break;
				default:	firstItem.onClick();
							break;
			}
			
		}
	}
	
	/*
	 * Deactivates list
	 */
	public function deactivate() :Void
	{
		_isActive = false;
		_skin.updateSkin();
	}
	
	/*
	 * Activate item
	 */
	public function showFile( listItem_:ListItem, media_:Media ) :Void
	{
		_gallery.showFile( media_ );
		
		if (_activeListItem != listItem_)
		{
			_activeListItem.deactivate();
			_activeListItem = listItem_;
			_activeListItem.activate();
		}
	}
	
	/*
	 * Deactivates list
	 */
	public function deactivateActiveItem() :Void
	{
		if (_activeListItem!=null)
		{
			_activeListItem.deactivate();
			_activeListItem = null;
		}
	}
	
	public function getNext() :Boolean
	{
		var currentItemNum:Number = ArrayUtils.indexOf( _listItems, _activeListItem );
		if (currentItemNum<(_listItems.length-1))
		{
			ListItem( _listItems[currentItemNum+1] ).onClick();
			return true;
		}
		else return false;
	}
	
	public function getPrev() :Boolean
	{
		var currentItemNum:Number = ArrayUtils.indexOf( _listItems, _activeListItem );
		if (currentItemNum>0)
		{
			ListItem( _listItems[currentItemNum-1] ).onClick();
			return true;
		}
		else return false;
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function get isActive():Boolean { return _isActive; }
	public function set isActive(value:Boolean):Void { _isActive=value; }
	
	public function get skin():IListSkin { return _skin; }
	public function set skin(value:IListSkin):Void { _skin=value; }
	
	public function get medias():Array { return _medias; }
	public function set medias(value:Array):Void { _medias=value; }
	
	public function get itemXPos():Number { return _itemXPos; }
	public function set itemXPos(value:Number):Void { _itemXPos=value; }
	
	public function get itemYPos():Number { return _itemYPos; }
	public function set itemYPos(value:Number):Void { _itemYPos=value; }
}