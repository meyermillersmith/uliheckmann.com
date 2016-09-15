import com.quasimondo.geom.ColorMatrix;

import flash.display.BitmapData;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import lessrain.lib.engines.pages.Page;
import lessrain.lib.utils.animation.easing.Sine;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.lib.utils.tween.TweenTimer;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.core.DimEvent;
import lessrain.projects.uliheckmann.utils.AdvancedColor;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.core.DimPage extends Page
{
	public static var ACTION_NAVI:Number = 1;
	public static var ACTION_SUB_NAVI:Number = 2;
	public static var ACTION_HIDE:Number = 3;
	
	private static var BLUR_WIDTH:Number = 40;
	private static var BRIGHTNESS_FACTOR:Number = 0.15;
	private static var DESATURATION_FACTOR:Number = 0.7;
	
	private var _contentMC : MovieClip;
	private var _dimmedMC : MovieClip;
	private var _navigationMC : MovieClip;

	private var _dimTween : TweenTimer;
	private var _dimmedBitmap : BitmapData;

	private var _blurFilter : BlurFilter;
	private var _colorFilter : ColorMatrixFilter;
	private var _contentRect : Rectangle;
	private var _zeroPoint : Point;

	private var _isDimmed : Boolean;
	private var _dimAction : Number;
	private var _hasSubNavigation:Boolean;
	private var _subNavigationShowing : Boolean;
	private var _intermediatePageShowing:Boolean;

	private var _dimmedColor : AdvancedColor;
	private var _resizeEnterFrame : Function;
	
	public function DimPage(targetMC : MovieClip)
	{
		super(targetMC);
		_isDimmed=false;
		_hasSubNavigation=false;
		_intermediatePageShowing=false;
	}
	
	public function initialize():Void
	{
		super.initialize();
		
		_contentMC = _targetMC.createEmptyMovieClip("content",10);
		_navigationMC = _targetMC.createEmptyMovieClip("navigation",20);
		_dimmedMC = _targetMC.createEmptyMovieClip("dimmed",15);
		_dimmedMC._visible=false;
		_dimmedMC._alpha=0;
		
		_zeroPoint = new Point(0,0);
		_contentRect = new Rectangle(0,0,GlobalSettings.getInstance().stageWidth, GlobalSettings.getInstance().stageHeight);
		_resizeEnterFrame = Proxy.create(this, updateDim);
		
		// set the rect to the correct dimensions
		if (GlobalSettings.getInstance().enableFullscreen)
		{
			updateDim();
			Stage.addListener(this);
		}
		else initializeBitmap();
		
		_blurFilter = new BlurFilter(BLUR_WIDTH,BLUR_WIDTH,3);
		
		_dimmedColor = new AdvancedColor(_dimmedMC);
		_dimmedColor.alphaOffset=0;
		//_dimmedColor.brightMultiplier = BRIGHTNESS_FACTOR;
		
		var colorMatrix:ColorMatrix = new ColorMatrix();
		colorMatrix.adjustSaturation(DESATURATION_FACTOR);
		_colorFilter = new ColorMatrixFilter(colorMatrix.matrix);
		
		_dimTween = new TweenTimer();
		_dimTween.tweenTarget=_dimmedColor;
		_dimTween.tweenDuration = 0;
		_dimTween.easingFunction = Sine.easeOut;
		_dimTween.addEventListener(TweenEvent.TWEEN_COMPLETE, Proxy.create(this, onTweenComplete));
	}
	
	private function initializeBitmap():Void
	{
		_dimmedBitmap = new BitmapData( _contentRect.width, _contentRect.height, true, 0 );
		_dimmedMC.attachBitmap(_dimmedBitmap, 3, "always", false);
	}
	
	private function onResize():Void
	{
		_targetMC.onEnterFrame = _resizeEnterFrame;
	}
	
	private function updateDim():Void
	{
		_targetMC.onEnterFrame = null;
		_contentRect.width=Stage.width;
		_contentRect.height=Stage.height;
		initializeBitmap();
		
		if (_isDimmed)
		{
			_dimmedBitmap.fillRect(_contentRect,0xff000000 | GlobalSettings.getInstance().bgColor);
			//_dimmedBitmap.draw(_contentMC, myMatrix, myColorTransform, blendMode, _contentRect, smooth);
			//_dimmedBitmap.applyFilter(_dimmedBitmap, _contentRect, _zeroPoint, _colorFilter );
			//_dimmedBitmap.applyFilter(_dimmedBitmap, _contentRect, _zeroPoint, _blurFilter );
		}
	}
	
	public function hide():Void
	{
		_dimAction=ACTION_HIDE;
		super.hide();
		if (_isDimmed)
		{
			_contentMC._visible=false;
			_dimTween.reset();
			_dimTween.setTweenProperty("brightMultiplier",_dimmedColor.brightMultiplier,0);
			_dimTween.start();
		}
	}
	
	public function dim( action_:Number ):Void
	{
		if (!_isDimmed)
		{
			_dimAction = action_;
			_isDimmed=true;
			
//			var myMatrix:Matrix = new Matrix();
//			var myColorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
//			var blendMode:String = "normal";
//			var myRectangle:Rectangle = new Rectangle(0, 0, 500, 500);
//			var smooth:Boolean = true;
//			_dimmedBitmap.draw(_contentMC, myMatrix, myColorTransform, blendMode, _contentRect, smooth);
			
			
			_dimmedBitmap.fillRect(_contentRect,0xff000000 | GlobalSettings.getInstance().bgColor);
			//_dimmedBitmap.fillRect(_contentRect,0xcc000000 | GlobalSettings.getInstance().bgColor);
			//_dimmedBitmap.applyFilter(_dimmedBitmap, _contentRect, _zeroPoint, _colorFilter );
			//_dimmedBitmap.applyFilter(_dimmedBitmap, _contentRect, _zeroPoint, _blurFilter );
			_dimmedMC._visible=true;
			
			_dimTween.reset();
			_dimTween.setTweenProperty("alphaOffset",_dimmedColor.alphaOffset,0);
			_dimTween.start();
		}
	}
	
	public function undim( delay_:Number ):Void
	{
		if (_isDimmed)
		{
			_isDimmed=false;
			_contentMC._visible=true;
			_dimTween.reset();
			_dimTween.setTweenProperty("alphaOffset",_dimmedColor.alphaOffset,-255);
			_dimTween.start(delay_);
		}
	}
	
	public function showSubNavigation():Void
	{
		_subNavigationShowing=true;
	}
	
	public function hideSubNavigation():Void
	{
		_subNavigationShowing=false;
		_eventDistributor.distributeEvent( new DimEvent( DimEvent.HIDE_SUB_NAV) );
	}
	
	private function onTweenComplete(tweenEvent:TweenEvent):Void
	{
		if (_isDimmed) _contentMC._visible=false;
		else _dimmedMC._visible=false;
		
		if (_dimAction==ACTION_NAVI) 	distributeEvent( new DimEvent( _isDimmed ? DimEvent.DIMMED : DimEvent.NORMAL ) );
		else if (_dimAction==ACTION_SUB_NAVI && _isDimmed) showSubNavigation();
		else if (_dimAction==ACTION_HIDE) dispatchPageHidden();
	}
	
	public function finalize():Void
	{
		delete _targetMC.onEnterFrame;
		_targetMC.onEnterFrame = null;
		delete _resizeEnterFrame;
		_dimmedBitmap.dispose();
		_dimTween.reset();
		_dimTween.destroy();
		_contentMC.removeMovieClip();
		_navigationMC.removeMovieClip();
		_dimmedMC.removeMovieClip();
		super.finalize();
	}
	
	public function get hasSubNavigation():Boolean { return _hasSubNavigation; }
	public function set hasSubNavigation(value:Boolean):Void { _hasSubNavigation=value; }
	
	public function get subNavigationShowing():Boolean { return _subNavigationShowing; }
	public function set subNavigationShowing(value:Boolean):Void { _subNavigationShowing=value; }
	
	public function get intermediatePageShowing():Boolean { return _intermediatePageShowing; }
	public function set intermediatePageShowing(intermediatePageShowing_:Boolean):Void { _intermediatePageShowing=intermediatePageShowing_; }
}