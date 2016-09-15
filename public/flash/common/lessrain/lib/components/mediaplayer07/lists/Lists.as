/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.Gallery;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.lists.List;
import lessrain.lib.components.mediaplayer07.lists.Tab;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.assets.Label;

class lessrain.lib.components.mediaplayer07.lists.Lists 
{
	/*
	 * Getter & setter
	 */	
	private var _targetMC			: MovieClip;
	private var _gallery			: Gallery;	
	private var _skinFactory		: ISkinFactory;
	private var _mediaArraysByType	: Array;
	private var _lists				: Array;
	private var	_tabs				: Array;
	private var _activeList			: List;
	private var _activeTab			: Tab;
	
	private var _tabXPos			: Number;
	private var _tabYPos			: Number;
	
	
	/*
	 * Constructor
	 */
	public function Lists( gallery_:Gallery, targetMC:MovieClip, mediaArraysByType_:Array, skinFactory_:ISkinFactory)
	{
		_targetMC = targetMC.createEmptyMovieClip("lists_"+targetMC.getNextHighestDepth(), targetMC.getNextHighestDepth());
		_gallery = gallery_;
		_mediaArraysByType = mediaArraysByType_;
		_skinFactory = skinFactory_;
		
		initialize();
	}
	
	/*
	 * Initializes all lists 
	 */
	public function initialize() :Void
	{
		/*
		 Create lists and tabs
		 */
		_lists = new Array();
		_tabs = new Array();
		_tabXPos = 0;
		_tabYPos = 0;
		var l:Number = _mediaArraysByType.length;
		for (var i : Number = 0; i < l; i++)
		{
			// New list
			var list:List = new List( _gallery, _targetMC, Array(_mediaArraysByType[i]), _skinFactory );
			_lists.push( list );
			
			// New tab that knows its list
			var type:String	= Media(list.medias[0]).getMaster().type;
			var title:String = (  Label.getLabel( "mediaPlayer."+type )!=null && Label.getLabel( "mediaPlayer."+type )!=''  ) ? Label.getLabel("mediaPlayer."+type) : type;
			var tab:Tab = new Tab( this, _targetMC, list, title, _skinFactory );
			_tabs.push( tab );
			
			_tabXPos += tab.width;
			_tabYPos += tab.height;
		}
		
		// Activate first list, tab and listItem
		activateList( List(_lists[0]), Tab(_tabs[0]) );
	}
	
	/*
	 * Activate list
	 * @param list				The List we want to activate
	 * @param tab				The Tab that belongs to this List
	 * @param noActiveItemYet	An ListItem has to be (auto-)selected
	 * @param direction			If we are (auto-)selecting an ListItem the direction defines the item,
	 * 							we have to select 
	 * 							{
	 * 								-1	: Select the last item, cuz we're going backwards,
	 * 								+1	: Select the first item, cuz we're going forwards through all lists 
	 * 							}
	 */
	public function activateList(list_:List, tab_:Tab, autoSelect_:Boolean, direction_:Number) :Void
	{
		var autoSelect:Boolean = (autoSelect_) ? true:false;
		
		if (_activeList== null)
		{
			autoSelect = true;
		}
		else if (_activeList!=list_)
		{
			_activeList.deactivate();
			_activeTab.deactivate();
		}
		
		// Activate list
		_activeList = list_;
		_activeList.activate( autoSelect, direction_ );
		
		// Activate tab
		_activeTab = tab_;
		_activeTab.activate();
	}
	
	public function deactivateOtherListItems() :Void
	{
		for (var i : Number = 0; i < _lists.length; i++) 
		{
			List( _lists[i] ).deactivateActiveItem();
		}
	}
	
	/*
	 * Activates next listItem of current list if possible,
	 * else we activate the first item of the next list.. if possible
	 */
	public function getNextListItem() :Void
	{
		var success:Boolean = _activeList.getNext();
		
		// Reached activeList's end
		if (!success)
		{
			var currentListNum:Number = ArrayUtils.indexOf( _lists, _activeList );
			if (currentListNum<_lists.length-1)
			{
				deactivateOtherListItems();
				
				var direction:Number = 1;
				activateList( List(_lists[currentListNum+1]), Tab(_tabs[currentListNum+1]), true, direction );
			}
		}
	}
	
	/*
	 * Activates previous listItem of current list if possible,
	 * else we activate the last item of the previous list.. if possible
	 */
	public function getPreviousListItem() :Void
	{
		var success:Boolean = _activeList.getPrev();
		
		// Reached activeList's end
		if (!success)
		{
			var currentListNum:Number = ArrayUtils.indexOf( _lists, _activeList );
			if (currentListNum>0)
			{
				deactivateOtherListItems();
				
				var direction:Number = -1;
				activateList( List(_lists[currentListNum-1]), Tab(_tabs[currentListNum-1]), true, direction  );
			}
		}
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function get tabXPos():Number { return _tabXPos; }
	public function set tabXPos(value:Number):Void { _tabXPos=value; }
	
	public function get tabYPos():Number { return _tabYPos; }
	public function set tabYPos(value:Number):Void { _tabYPos=value; }
}