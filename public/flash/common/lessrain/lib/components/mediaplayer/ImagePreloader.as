/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.text.DynamicTextField;
import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.animation.easing.Sine;

class lessrain.lib.components.mediaplayer.ImagePreloader
{
	
	private var _targetMC:MovieClip;	
	private var content:MovieClip;
	private var mask:MovieClip;
	
	private var bg:MovieClip;
	private var backgroundBar:MovieClip;
	private var progressBar:MovieClip;
	private var display:DynamicTextField;
	
	private var contentTween:Tween;
	private var percent:Number;
	private var barWidth:Number;
	private var barLeft:Number;
	private var andDestroy:Boolean;
	
	private var _hasStarted:Boolean;
	private var _left:Number;
	private var _bottom:Number;
	private var _width:Number;
	private var _height:Number;
	
	private var _progressBarColor:Number;
	private var _progressBarAlpha:Number;
	//private var _backgroundBarColor:Number;
	//private var _backgroundBarAlpha:Number;
	private var _backgroundColor:Number;
	private var _backgroundAlpha:Number;
	private var _styleSheet:TextField.StyleSheet;
	private var _styleClass:String;
	
	private var _text:String;
	
	function ImagePreloader( targetMC:MovieClip )
	{
		_targetMC=targetMC;
		_text="LOADING";
		_left=0;
		_bottom=0;
		_width=0;
		_height=0;
		andDestroy=false;
		_hasStarted=false;
		init();
	}
	
	private function init()
	{
		content=_targetMC.createEmptyMovieClip("content",1);
		mask=_targetMC.createEmptyMovieClip("mask",2);
		
		bg=content.createEmptyMovieClip("bg",1);
		backgroundBar=content.createEmptyMovieClip("backgroundBar",2);
		progressBar=content.createEmptyMovieClip("progressBar",3);
		display=DynamicTextField(content.attachMovie("DynamicTextField", "display",4));
		display._y=-2;
		
		content._alpha=0;

		contentTween = new Tween(content);
		contentTween.duration=400;
		contentTween.addEventListener("onComplete", Proxy.create( this, tweenComplete ));
	}
	
	/**
	 * Starts the loading bar. Call before every loading operation.
	 */
	public function start():Void
	{
		andDestroy=false;
		percent=0;
		barWidth=_width; //Math.round(_width*0.8);
		barLeft=0; //Math.round((_width-barWidth)/2);
		
		_targetMC._visible=true;
		
		display.styleSheet=_styleSheet;
		display.styleClass=_styleClass;
		display.create();
		updateTextField();
		display._x = 1; //Math.round((_width-display.textWidth)/2);
		
		_height=display._y+display.textHeight+14;
		
		ShapeUtils.drawRectangle( bg, 0, 0, _width, _height, _backgroundColor, _backgroundAlpha );
		//ShapeUtils.drawRectangle( backgroundBar, barLeft, 5, barWidth, 3, _backgroundBarColor, _backgroundBarAlpha );
		
		ShapeUtils.drawRectangle( mask, 0, 0, _width, _height, 0x000000, 100 );
		content.setMask(mask);
		
		_targetMC._x=_left;
		_targetMC._y=_bottom-_height;
		
		content._alpha=0;
		content._y=_height;
		
		_hasStarted=true;
		
		contentTween.reset();
		contentTween.easingFunction = Sine.easeOut;
		contentTween.setTweenProperty('_alpha', 	content._alpha, 	100);
		contentTween.setTweenProperty('_y', content._y, 0);
		contentTween.start();
	}
	
	/**
	 * Stops the loading and moves the bar away. Call after every loading operation.
	 */
	public function stop( andDestroy:Boolean ):Void
	{
		contentTween.reset();
		contentTween.easingFunction = Sine.easeIn;
		contentTween.setTweenProperty('_alpha', 	content._alpha, 	0);
		contentTween.setTweenProperty('_y', content._y, _height);
		contentTween.start();
		
		_hasStarted=false;
		this.andDestroy=andDestroy;
	}
	
	public function tweenComplete()
	{
		if (_targetMC._alpha<1) _targetMC._visible=false;
		if (andDestroy) destroy();
	}
	
	/**
	 * Removes all MCs
	 */
	public function destroy()
	{
		content.removeMovieClip();
		mask.removeMovieClip();
		
		bg.removeMovieClip();
		backgroundBar.removeMovieClip();
		progressBar.removeMovieClip();
	}
	
	/**
	 * Call repeatedly to display progress of loading
	 */
	public function progress( percent:Number ):Void
	{
		this.percent=percent;
		
		ShapeUtils.drawRectangle( progressBar, barLeft, 0, Math.round(barWidth*(percent/100)), _height, _progressBarColor, _progressBarAlpha );
		updateTextField();
	}
	
	private function updateTextField()
	{
		display.text=_text+" "+Math.floor(percent)+"%";
	}
	
	
	/**
	 * Set the style of the background surface and color, bar color and stylesheet of the textfield before calling start
	 */
	public function setStyleProperties( progressBarColor:Number, progressBarAlpha:Number, backgroundBarColor:Number, backgroundBarAlpha:Number, backgroundColor:Number, backgroundAlpha:Number, styleSheet:TextField.StyleSheet, styleClass:String )
	{
		_progressBarColor=progressBarColor;
		_progressBarAlpha=progressBarAlpha;
		//_backgroundBarColor=backgroundBarColor;
		//_backgroundBarAlpha=backgroundBarAlpha;
		_backgroundColor=backgroundColor;
		_backgroundAlpha=backgroundAlpha;
		_styleSheet=styleSheet;
		_styleClass=styleClass;
	}
	
	public function abort():Void
	{
		contentTween.reset();
		this.progress( 0 );
		_hasStarted=false;
	}
	
	
	public function get hasStarted():Boolean { return _hasStarted; }
	
	/**
	 * Width is calculated automatically and can only be get
	 */
	public function get height():Number { return _height; }
	
	/**
	 * Set the width of the bar, i.e. the width of the image that's loaded before calling start
	 */
	public function set width(value:Number):Void { _width=value; }
	public function get width():Number { return _width; }
	
	/**
	 * Set the left position of the bar before calling start
	 */
	public function set left(value:Number):Void
	{
		_targetMC._x=_left;
		_left=value;
	}
	public function get left():Number { return _left; }
	
	/**
	 * Set the bottom alignment position of the bar before calling start
	 */
	public function set bottom(value:Number):Void
	{
		_targetMC._y=_bottom-_height;
		_bottom=value;
	}
	public function get bottom():Number { return _bottom; }

	public function get text():String { return _text; }
	public function set text(value:String):Void { _text=value; }
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function set displayTextfieldY(value:Number) {display._y=value;}
}