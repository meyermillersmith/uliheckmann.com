/**
 * 
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 * Reflector is used to give the illusion of a reflective surface. 
 * It includes a few properties for custom fading, skewing and scaling.
 *  
 */
 
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class lessrain.lib.engines.effects.Reflector {
	
	private var _targetMC:MovieClip;

	private var _skewX:Number;
    private var _scale:Number;
    private var _ray:Number;
    private var __alpha:Number;

	private var _bitmapData : BitmapData;

	private var _pixelSnapping : String;
	private var _smooth : Boolean;
	private var _yOffset:Number;
	
	public function Reflector() 
	{
		
	}
	
	public function initialize(targetMC:MovieClip,skewX:Number,scale:Number,alpha:Number,ray:Number):Void
	{
		_targetMC=targetMC;
		_skewX=skewX || 0;
		_scale=scale || 1;
		__alpha=alpha || 50;
		_ray=ray || 200;
		_pixelSnapping='Always ';
		_smooth=false;
		_yOffset=0;
		
	}
	public function finalize():Void
	{
		_bitmapData.dispose();
	}
	public function create():Void
	{
		 //draw reflection
       _bitmapData = new BitmapData(_targetMC._width, _targetMC._height, true, 0);
       _targetMC.createEmptyMovieClip("reflection", 599); 
        
       var matrix:Matrix = new Matrix( 1, 0, _skewX, -1*_scale, 0, _targetMC._height );
       var delta:Point = matrix.transformPoint(new Point(0,_targetMC._height));
       matrix.tx = delta.x*-1;
       matrix.ty = _targetMC._height+(delta.y-_targetMC._height-_yOffset)*-1;
       
       _bitmapData.draw(_targetMC);
       _targetMC.reflection.createEmptyMovieClip("reflection_container", 600);
       _targetMC.reflection.createEmptyMovieClip("gradient_mask", 601);
       _targetMC.reflection.reflection_container.attachBitmap(_bitmapData, 1,_pixelSnapping, _smooth);
       
      // gradient_mask 
      var fillType:String = "linear"; 
      var grad:Array = [0xFFFFFF, 0xFFFFFF]; 
      var alfas:Array = [__alpha, 0]; 
      var rat:Array = [0, _ray]; 
      var mat:Object = {matrixType:"box", x:0, y:0, w:_targetMC.reflection._width, h:_targetMC.reflection._height, r:-1*(90/180)*Math.PI}; 
      var spread:String = "pad"; 
      
      _targetMC.reflection.gradient_mask.beginGradientFill(fillType, grad, alfas, rat, mat, spread); 
      _targetMC.reflection.gradient_mask.moveTo(0, 0); 
      _targetMC.reflection.gradient_mask.lineTo(0, _targetMC.reflection._height); 
      _targetMC.reflection.gradient_mask.lineTo(_targetMC.reflection._width, _targetMC.reflection._height); 
      _targetMC.reflection.gradient_mask.lineTo(_targetMC.reflection._width, 0); 
      _targetMC.reflection.gradient_mask.lineTo(0, 0); 
      _targetMC.reflection.gradient_mask.endFill(); 
      
      // apply gradient mask
      _targetMC.reflection.reflection_container.cacheAsBitmap = true; 
      _targetMC.reflection.gradient_mask.cacheAsBitmap = true; 
      _targetMC.reflection.reflection_container.setMask(_targetMC.reflection.gradient_mask); 
     
   	  _targetMC.reflection.transform.matrix=matrix;
 
	}
	
	/*
	 * for animated Movieclips or FLV
	 */
	
	public function update():Void 
	{ 
	  _bitmapData.fillRect(new Rectangle(0, 0, _targetMC.reflection._width, _targetMC.reflection._height), 0x00000000); 
      _bitmapData.draw(_targetMC); 
    }
    
 
    public function get yOffset():Number { return _yOffset; }
    public function set yOffset(value:Number):Void { _yOffset=value; }
    
    public function set targetMC(value:MovieClip):Void{_targetMC=value;}
    public function get targetMC():MovieClip{return _targetMC;}
    
    public function set skewX(value:Number):Void{_skewX=value;}
    public function get skewX():Number{return _skewX;}
    
    public function set scale(value:Number):Void{_scale=value;}
    public function get scale():Number{return _scale;}
    
    public function set alpha(value:Number):Void{__alpha=value;}
    public function get alpha():Number{return __alpha;}
    
    public function set ray(value:Number):Void{_ray=value;}
    public function get ray():Number{return _ray;}
    
    public function set pixelSnapping(value:String):Void{_pixelSnapping=value;}
    public function get pixelSnapping():String{return _pixelSnapping;}
    
    public function set smooth(value:Boolean):Void{_smooth=value;}
    public function get smooth():Boolean{return _smooth;}
    
    
    
}