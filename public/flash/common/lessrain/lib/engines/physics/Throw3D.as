/**
 * @author Luis Martinez, Lessrain (luis@lessrain.com)
 * @since Flash Player 8
 * First prototype for lessrain japan?...throw stones!!!!!!
 */

import flash.geom.*;

import lessrain.lib.utils.Proxy;
class lessrain.lib.engines.physics.Throw3D{
	
	private var _targetMC:MovieClip;
	private var _focalLength:Number;
	private var _initPoint:Point;
	private var _shift:Point;
	private var _initSpeed:Number;
	private var _initSpeedZ:Number;
	private var _gravity:Number;
	private var x:Number;
	private var y:Number;
	private var z:Number;
	private var _interval:Number;
	private var count:Number;
	
	function Throw3D(){
	}
	
	public function init(mc:MovieClip,fl:Number,initPoint:Point,shift:Point,iSpeed:Number,iSpeedZ:Number,g:Number){

		_targetMC=mc;
		count=0;
		if(!_focalLength) _focalLength=fl || 1000;
		if(!_initPoint) _initPoint=initPoint || new Point(100,300);
		if(!_shift) _shift=shift || new Point(0,0);
		if(!_initSpeed) _initSpeed=iSpeed || -40;
		if(!_initSpeedZ) _initSpeedZ=iSpeedZ || 5;
		if(!_gravity) _gravity=g || 1.5;
		x=0;
		y=-1;
		z=0;
		update3dObject (x, y, z);
	}
	public function start():Void{
		_interval=setInterval(Proxy.create(this,throwObject),10);
	}
	
	private function calculateScale (z:Number):Number {
		var scaleRatio:Number = _focalLength/(_focalLength+z);
		return scaleRatio*100;
	}
	
	private function to3dPoint (x:Number, y:Number, z:Number):Point {
		
		var xTo3d:Number = (x+_shift.x)*calculateScale(z)/100+_initPoint.x;
		var yTo3d:Number = (y+_shift.y)*calculateScale(z)/100+_initPoint.y;
		var pt:Point = new Point(xTo3d,yTo3d);
		return pt;
	}
	
	private function update3dObject (x:Number, y:Number, z:Number):Void {
		var newPoint:Point = to3dPoint(x, y, z);
		_targetMC._xscale =_targetMC._yscale= calculateScale(z);
		_targetMC._x = newPoint.x;
		_targetMC._y = newPoint.y;
	
	}
	
	private function throwObject():Void
	{
		count++;
		z += initSpeedZ;
		//x+=0;
		y += _initSpeed+(gravity*count)+4;
		if (y>=0) {
			_initSpeed=0-(_initSpeed+(_gravity*count));
			y+=2*(_initSpeed) ;count=0;
			if(y>=0){clearInterval(_interval);}
		}

	
		update3dObject( x, y, z);

	}
	
	
	function get target():MovieClip { return _targetMC; }
	function set target(mc:MovieClip):Void { _targetMC = mc; }
	
	function get focalLength():Number { return _focalLength; }
	function set focalLength(val:Number):Void { _focalLength = val; }
	
	function get initPoint():Point { return _initPoint; }
	function set initPoint(p:Point):Void { _initPoint = p; }
	
	function get shift():Point { return _shift; }
	function set shift(p:Point):Void { _shift = p; }
	
	function get initSpeed ():Number { return _initSpeed ; }
	function set initSpeed (val:Number):Void { _initSpeed  = val; }
	
	function get initSpeedZ ():Number { return _initSpeedZ ; }
	function set initSpeedZ (val:Number):Void { _initSpeedZ  = val; }
	
	function get gravity ():Number { return _gravity ; }
	function set gravity (val:Number):Void { _gravity  = val; }

	
	
}