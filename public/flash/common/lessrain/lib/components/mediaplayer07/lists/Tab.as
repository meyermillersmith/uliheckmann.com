import lessrain.lib.components.mediaplayer07.lists.List;
import lessrain.lib.components.mediaplayer07.lists.Lists;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.components.mediaplayer07.skins.core.ITabSkin;
/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.lists.Tab 
{
	/*
	 * Getter & setter
	 */
	private var _lists		: Lists;
	private var _targetMC	: MovieClip;
	private var _list		: List;
	private var _title		: String;
	private var _isActive	: Boolean;
	private var _skin		: ITabSkin;
	private var _skinFactory: ISkinFactory;
	
	private var _width		: Number;
	private var _height		: Number;
	
	
	/*
	 * Constructor
	 */
	public function Tab( lists_:Lists, targetMC:MovieClip, list_:List, title_:String, skinFactory_:ISkinFactory)
	{
		_targetMC = targetMC.createEmptyMovieClip("tab_"+targetMC.getNextHighestDepth(), targetMC.getNextHighestDepth());
		_lists 	= lists_;
		_list 	= list_;
		_title 	= title_;
		_skinFactory = skinFactory_;
		
		initialize();
	}
	
	/*
	 * Initializes tab
	 */
	public function initialize() : Void
	{
//		_skin = _skinFactory.createTabSkin( _targetMC, this, _lists.tabXPos, _lists.tabYPos);
		
		_isActive = false;
	}
	
	public function onClick() :Void
	{
		_lists.activateList( _list, this );
	}
	
	/*
	 * Activates tab
	 */
	public function activate() :Void
	{
		_isActive = true;
		_skin.updateSkin();
	}
	
	/*
	 * Deactivates tab
	 */
	public function deactivate() :Void
	{
		_isActive = false;
		_skin.updateSkin();
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function get title():String { return _title; }
	public function set title(value:String):Void { _title=value; }
	
	public function get list():List { return _list; }
	public function set list(value:List):Void { _list=value; }
	
	public function get height():Number { return _skin.getHeight(); }
	public function get width():Number { return _skin.getWidth(); }
	
	public function get isActive():Boolean { return _isActive; }
	public function set isActive(value:Boolean):Void { _isActive=value; }
}