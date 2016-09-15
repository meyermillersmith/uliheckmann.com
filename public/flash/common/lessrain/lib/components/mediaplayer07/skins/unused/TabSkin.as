/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.lists.Tab;
import lessrain.lib.components.mediaplayer07.skins.core.ITabSkin;
import lessrain.lib.utils.animation.easing.Sine;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.assets.StyleSheet;
import lessrain.lib.utils.color.ColorUtils;
import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.text.DynamicTextField;

class lessrain.lib.components.mediaplayer07.skins.unused.TabSkin implements ITabSkin
{
	/*
	 * Getter & setter
	 */
	private var _targetMC	: MovieClip;
	private var _tab 		: Tab;
	private var _tf 		: DynamicTextField;
	private var _x 			: Number;
	private var _y 			: Number;
	private var _tween 		: Tween;

	private var _backgroundShape : MovieClip;
	
	
	/*
	 * Constructor
	 */
	public function TabSkin(targetMC_:MovieClip, tab_:Tab, x_:Number, y_:Number )
	{
		_targetMC = targetMC_;
		_tab = tab_;
		_x = 4 + x_;
		_y = y_;
		
		initialize();
	}
	
	public function initialize() :Void
	{
		_targetMC._x = _x;
		_targetMC._y =  2;
		
		// Background
		_backgroundShape = _targetMC.createEmptyMovieClip("backgroundShape", _targetMC.getNextHighestDepth());
		ShapeUtils.drawRectangle( _backgroundShape, 0, 0, 37, 14, 0x000000, 100);
		
		_tf = DynamicTextField(_targetMC.attachMovie("DynamicTextField","tf_"+_targetMC.getNextHighestDepth(),_targetMC.getNextHighestDepth()));
		_tf.initialize( _tab.title.substr(0,1).toUpperCase()+_tab.title.substr(1,_tab.title.length-1),  StyleSheet.getStyleSheet('main'), 'hotspotPlayerButtonStyle', false, false, 0, 0 );
		_tf._x = 2;
		ColorUtils.colorize(_tf, 0xFFFFFF);

		_backgroundShape._width = _tf._width+4;
		
		// Set properties
		ColorUtils.colorize(_backgroundShape, 0x282A26);
		
		_tween = new Tween(_targetMC);
		_tween.duration = 200;
		_tween.easingFunction = Sine.easeInOut;
			
		_targetMC.onRelease = Proxy.create(this, onClick);
		_targetMC.onRollOver = Proxy.create(this, onRoll, true);
		_targetMC.onRollOut = _targetMC.onDragOut = Proxy.create(this, onRoll, false);
		
		onRoll(false);
	}
	
	public function onClick() :Void
	{
		_tab.onClick();
	}
	
	public function onRoll(highlight:Boolean) :Void
	{
		if (_tween==null) 
		{
//			ColorUtils.colorize(_tf, (highlight)?0x666666:_tab.buttonProperties.position.color);
		}
		else
		{
			_tween.reset();
			_tween.setTweenProperty('_alpha', _targetMC._alpha, (highlight || _tab.isActive)?100:50);
			_tween.start();
		}
	}
	
	public function updateSkin() :Void
	{
		onRoll(false);
		_backgroundShape._alpha = (_tab.isActive) ? 100 : 50;
		_targetMC.enabled = (_tab.isActive) ? false : true;
	}
	
	public function getWidth() : Number
	{
		return _targetMC._width +1 ;
	}

	public function getHeight() : Number
	{
		return _targetMC._height;
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }

}