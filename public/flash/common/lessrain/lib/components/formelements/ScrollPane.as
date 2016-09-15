/**
 * @class:   ScrollPane / Slider
 * @author:  luis@lessrain.com, torsten@lessrain.com
 * @version: 1
 * -----------------------------------------------------
 *  Basic Slider
 * ----------------------------------------------------
 */
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.animation.Tween;
import mx.events.EventDispatcher;

class lessrain.lib.components.formelements.ScrollPane
{	
	private var _knobMC:MovieClip;
	private var _baseMC:MovieClip;
	
	private var _orientation:String;
	private var _prop1:String;
	private var _prop2:String;
	
	private var _left:Number;
	private var _right:Number;
	private var _top:Number;
	private var _bottom:Number;
	
	private var pointX:Number;
	private var pointY:Number;
	
	private var mouseListener:Object;
	
	private var _initValue:Number;
	private var _endValue:Number;
	private var _range:Number;
	
	private var _value:Number;
	private var _tw:Tween;
	
	//private static var overColor:Number=0xFFFFFF;
	//private static var outColor:Number=0xFF004C;
	
	// required for EventDispatcher:
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	function ScrollPane ()
	{
		EventDispatcher.initialize (this);
	}
	
	public function init (knob:MovieClip, base:MovieClip, orientation:String, initValue:Number, endValue:Number):Void
	{
		_knobMC = knob;
		_baseMC = base;
		
		_knobMC._x=_baseMC._x;
		_knobMC._y=_baseMC._y;
		
		_orientation = orientation;
		
		if(_orientation == 'horizontal'){
			_prop1='_x';
			_prop2='_width';
		}else{
			_prop1='_y';
			_prop2='_height';
		}
		
		_initValue = initValue;
		_endValue = endValue;
		_range = (_endValue - _initValue);
		
		//_knobMC.onRollOver = Proxy.create (this, colorize, _knobMC, overColor);
		//_knobMC.onRollOut = Proxy.create (this, colorize, _knobMC, outColor);
		_knobMC.onPress = Proxy.create (this, startDrag);
		_knobMC.onRelease = _knobMC.onReleaseOutside = Proxy.create (this, stopDrag);
		
		_baseMC.onPress = Proxy.create (this, findValue);
		
		_knobMC.useHandCursor = _baseMC.useHandCursor = false;
		
		_tw=new Tween(_knobMC);
		
		redrawLimits ();
	}
	
	private function startDrag ():Void
	{
		_tw.abort();
		
		pointX = (_knobMC._x - _baseMC._xmouse);
		pointY = (_knobMC._y - _baseMC._ymouse*_baseMC._yscale/100);
		
		mouseListener = new Object ();
		mouseListener.onMouseMove = Proxy.create (this, updatePos);
		Mouse.addListener (mouseListener);
		dispatchEvent ({target:this, type:'onStartDrag'});
	}
	
	private function stopDrag ():Void
	{
		Mouse.removeListener (mouseListener);
		dispatchEvent ({target:this, type:'onStopDrag'});
	}
	private function updatePos ():Void
	{
		var pos:Number = getCurrentValue (_knobMC[_prop1]);
		if (pos >= _initValue && pos <= _endValue) 
		{
			_knobMC._x = Math.round (_baseMC._xmouse*_baseMC._xscale/100 + pointX);
			_knobMC._y = Math.round (_baseMC._ymouse*_baseMC._yscale/100 + pointY);			
		}
		
		checkLimits ();
		updateAfterEvent ();
	}
	
	private function checkLimits ():Void
	{
		if (_knobMC._x < _left) _knobMC._x = _left;
		if (_knobMC._x > _right) _knobMC._x = _right;
		if (_knobMC._y < _top)_knobMC._y = _top;
		
		if (_knobMC._y > _bottom) _knobMC._y = _bottom;
		
		updateValue();
	}
	public function redrawLimits ():Void
	{
		_left = _baseMC._x;
		_top = _baseMC._y;
		_right = Math.round((_baseMC._x + _baseMC._width*_baseMC._xscale/100) - (_knobMC._width));
		//_bottom = Math.round((_baseMC._y + _baseMC._height*_baseMC._yscale/100) - (_knobMC._height));
		_bottom = Math.round((_baseMC._y + _baseMC._height) - (_knobMC._height));
		
		checkLimits ();
	}
	public function getTarget ():MovieClip
	{
		return _knobMC;
	}
	
	public function getCurrentValue (ref:Number):Number
	{
		return (Math.round ((ref - _baseMC[_prop1]) / (_baseMC[_prop2] - _knobMC[_prop2]) * _range + _initValue));
	}
	
	public function jumpTo (val:Number):Void
	{
		_knobMC[_prop1] = translateValToPos(val);
		checkLimits ();
	}
	
	private function translateValToPos():Number
	{
		var tempValue:Number;
		
		if(arguments.length){
			tempValue=arguments[0];
		}else{
			if (_orientation == 'horizontal')
			{
				tempValue = getCurrentValue(_knobMC._xmouse+(_knobMC[_prop2]/2)  * _baseMC._xscale/100);
			}
			else
			{
				tempValue = getCurrentValue(_baseMC._ymouse+(_knobMC[_prop2]/2)) * _baseMC._yscale/100;
			}
			
		}
		return (Math.round (_baseMC[_prop1] + (((_baseMC[_prop2] - _knobMC[_prop2]) * (tempValue - _initValue)) / (_range))));
	}
	
	private function findValue():Void
	{
		_tw.abort();
		_tw.deleteProperties();
		_tw.duration=250;
		_tw.setTweenProperty (_prop1, _knobMC[_prop1], translateValToPos());
		_tw.addEventListener('onProgress',Proxy.create(this,checkLimits));
		_tw.addEventListener('onComplete',Proxy.create(this,checkLimits));
		_tw.easingFunction=mx.transitions.easing.Regular.easeIn;
		_tw.start();
	}
	
	private function updateValue():Void{

		dispatchEvent ({target:this, type:'onChange', value:getCurrentValue (_knobMC[_prop1])});
	}
	
	private function enableItems(enable:Boolean):Void
	{
		_knobMC.enabled=_baseMC.enabled=enable;
	}
	
	private function colorize (mc:MovieClip, col:Number):Void
	{
		var c:Color = new Color (mc);
		c.setRGB (col);
	}

}
