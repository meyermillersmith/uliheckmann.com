/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import flash.geom.ColorTransform;
import flash.geom.Transform;


class lessrain.projects.uliheckmann.utils.AdvancedColor 
{

	private var _targetMC : MovieClip;
	private var colorTrans: ColorTransform;
	private var trans:Transform;

	private var _brightOffset : Number;	private var _brightMultiplier : Number;

	public function AdvancedColor(target:MovieClip) 
	{
		_targetMC=target;
		colorTrans=new ColorTransform();
		trans= new Transform(_targetMC);
	}
	
	private function setTransform():Void
	{
		trans.colorTransform = colorTrans;
	}
	

	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void 
	{ 
		_targetMC=value;
		trans=null; 
		trans= new Transform(_targetMC);
	}
	
	/**
	 * alphaMultiplier A decimal value that is multiplied by the alpha transparency channel value. 
	 */
	public function get alphaMultiplier():Number { return colorTrans.alphaMultiplier; }
	public function set alphaMultiplier(value:Number):Void 
	{ 
		colorTrans.alphaMultiplier=value;
		setTransform();
	}
	
	/**
	 * alphaOffset A number from -255 to 255 that is added to the alpha transparency channel 
	 * value after it has been multiplied by the alphaMultiplier value.. 
	 */
	public function get alphaOffset():Number { return colorTrans.alphaOffset; }
	public function set alphaOffset(value:Number):Void 
	{ 
		colorTrans.alphaOffset=Math.round(value);
		setTransform();
	}
	
	/**
	 * redOffset A number from -255 to 255 that is added to the red channel 
	 * value after it has been multiplied by the redMultiplier value.
	 */
	public function get redOffset():Number { return colorTrans.redOffset; }
	public function set redOffset(value:Number):Void 
	{
		colorTrans.redOffset=Math.round(value);
		setTransform();
	}
	
	/**
	 * greenOffset A number from -255 to 255 that is added to the green channel 
	 * value after it has been multiplied by the greenMultiplier value.
	 */
	public function get greenOffset():Number { return colorTrans.greenOffset; }
	public function set greenOffset(value:Number):Void 
	{
		colorTrans.greenOffset=Math.round(value);
		setTransform();
	}
	
	/**
	 * blueOffset A number from -255 to 255 that is added to the blue channel 
	 * value after it has been multiplied by the blueMultiplier value.
	 */
	public function get blueOffset():Number { return colorTrans.blueOffset; }
	public function set blueOffset(value:Number):Void 
	{
		colorTrans.blueOffset=Math.round(value);
		setTransform();
	}
	
	/**
	 * redMultiplier A decimal value that is multiplied by the red channel value.
	 */
	public function get redMultiplier():Number { return colorTrans.redMultiplier; }
	public function set redMultiplier(value:Number):Void 
	{
		colorTrans.redMultiplier=value;
		setTransform();
	}
	
	/**
	 * greenMultiplier A decimal value that is multiplied by the green channel value.
	 */
	public function get greenMultiplier():Number { return colorTrans.greenMultiplier; }
	public function set greenMultiplier(value:Number):Void 
	{
		colorTrans.greenMultiplier=value;
		setTransform();
	}
	
	/**
	 * blueMultiplier A decimal value that is multiplied by the blue channel value.
	 */
	public function get blueMultiplier():Number { return colorTrans.blueMultiplier; }
	public function set blueMultiplier(value:Number):Void 
	{
		colorTrans.blueMultiplier=value;
		setTransform();
	}
	
	public function get brightOffset():Number { return _brightOffset; }
	public function set brightOffset(value:Number):Void 
	{ 
		_brightOffset=value;
		colorTrans.redOffset=Math.round(value);
		colorTrans.greenOffset=Math.round(value);
		colorTrans.blueOffset=Math.round(value);

		setTransform();
 
	}
	
	public function get brightMultiplier():Number { return _brightMultiplier; }
	public function set brightMultiplier(value:Number):Void 
	{ 
		_brightMultiplier=value;
		colorTrans.redMultiplier=value;
		colorTrans.greenMultiplier=value;
		colorTrans.blueMultiplier=value;

		setTransform();
 
	}
	
	
	
}