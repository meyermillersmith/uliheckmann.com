/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.lists.ListItem;
import lessrain.lib.components.mediaplayer07.skins.core.IListItemSkin;
import lessrain.lib.utils.animation.easing.Sine;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.assets.StyleSheet;
import lessrain.lib.utils.color.ColorUtils;
import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.text.DynamicTextField;

class lessrain.lib.components.mediaplayer07.skins.unused.ListItemSkin implements IListItemSkin
{
	/*
	 * Getter & setter
	 */
	private var _targetMC	: MovieClip;
	private var _listItem 		: ListItem;
	private var _tf 		: DynamicTextField;
	private var _x 			: Number;
	private var _y 			: Number;
	private var _tween 		: Tween;

	private var _imageBackgroundShape : MovieClip;
	private var _textBackgroundShape : MovieClip;
	
	/*
	 * Constructor
	 */
	public function ListItemSkin(targetMC_:MovieClip, listItem_:ListItem, x_:Number, y_:Number )
	{
		_targetMC = targetMC_;
		_listItem = listItem_;
		_x = 4;
		_y = y_;
		
		initialize();
	}
	
	public function initialize() :Void
	{
		_targetMC._x = _x;
		_targetMC._y = _y;
		
		// ImageBackground
		_imageBackgroundShape = _targetMC.createEmptyMovieClip("imagebackgroundShape", _targetMC.getNextHighestDepth());
		ShapeUtils.drawRectangle( _imageBackgroundShape, 0, 0, 40, 30, 0x454742, 100);
		
		// Background
		_textBackgroundShape = _targetMC.createEmptyMovieClip("textBackgroundShape", _targetMC.getNextHighestDepth());
		ShapeUtils.drawRectangle( _textBackgroundShape, 0, 0, 103, 30, 0x1E201D, 100);
		_textBackgroundShape._x = 42;
		
		_tf = DynamicTextField(_targetMC.attachMovie("DynamicTextField","tf_"+_targetMC.getNextHighestDepth(),_targetMC.getNextHighestDepth()));
		_tf.initialize( _listItem.thumbnailFile.src,  StyleSheet.getStyleSheet('main'), 'hotspotPlayerButtonStyle', false, false, 0, 0 );
		_tf._x = 44;
		ColorUtils.colorize(_tf, 0xFFFFFF);
		
		
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
		_listItem.onClick();
	}
		
	public function onRoll( highlight:Boolean ) :Void
	{
		_listItem.onRoll( highlight );
		
		if (_tween==null) 
		{
//			ColorUtils.colorize(_tf, (highlight)?0x666666:_listItem.buttonProperties.position.color);
		}
		else
		{
			_tween.reset();
			_tween.setTweenProperty('_alpha', _targetMC._alpha, (highlight || _listItem.isActive)?100:50);
			_tween.start();
		}
	}
	
	public function updateSkin() :Void
	{
		onRoll(false);
		_textBackgroundShape._alpha = (_listItem.isActive) ? 100 : 50;
		_targetMC.enabled = (_listItem.isActive) ? false : true;
	}
	
	public function getWidth() : Number
	{
		return _targetMC._width + 1 ;
	}

	public function getHeight() : Number
	{
		return _targetMC._height + 1;
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }

}