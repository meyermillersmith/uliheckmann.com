/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.lists.List;
import lessrain.lib.components.mediaplayer07.skins.core.IListSkin;
import lessrain.lib.utils.color.ColorUtils;
import lessrain.lib.utils.graphics.ShapeUtils;

class lessrain.lib.components.mediaplayer07.skins.unused.ListSkin implements IListSkin
{
	/*
	 * Getter & setter
	 */
	private var _targetMC:MovieClip;
	private var _list : List;
	
	
	/*
	 * Constructor
	 */
	public function ListSkin(targetMC_:MovieClip, list_:List )
	{
		_targetMC = targetMC_;
		_list = list_;
		
		initialize();
	}
	
	public function initialize() :Void
	{
		_targetMC._x = 4;
		_targetMC._y = 20;
		
		// Background
		var backgroundShape:MovieClip = _targetMC.createEmptyMovieClip("backgroundShape", _targetMC.getNextHighestDepth());
		ShapeUtils.drawRectangle( backgroundShape, 0, -4, 152, 194, 0x000000, 100);
		
		// Set properties
		ColorUtils.colorize(backgroundShape, 0x282A26);
		backgroundShape._alpha = 100;
	}
	
	public function updateSkin() :Void
	{
		_targetMC._visible = (_list.isActive) ? true : false;
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
}