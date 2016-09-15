/**
 * FixAlpha, version 2
 * @class:   lessrain.lib.utils.FixAlpha
 * @author:  luis@lessrain.com
 * @version: 2
 */
 
class lessrain.lib.utils.FixAlpha
{
	private var alphaInternal:Number;
	private var xInternal:Number;
	private var yInternal:Number;
	private var xScaleInternal:Number;
	private var yScaleInternal:Number;
	
	private var target:Object;
	
	function FixAlpha (mc:Object)
	{
		target = mc;
		alphaInternal = mc._alpha;
		xInternal = mc._x;
		yInternal = mc._y;
		xScaleInternal = mc._xscale;
		yScaleInternal = mc._yscale;
		
	}
	public function get _alpha ():Number { return alphaInternal; }

	public function set _alpha (alphaIn:Number):Void
	{
		target._alpha = alphaIn;
		alphaInternal = alphaIn;
	}
	// overwrite other Movieclip properties to use together with the Alpha
	
	public function get _x():Number { return xInternal;}
	public function get _y():Number { return yInternal;}
	public function get _xscale():Number { return xScaleInternal;}
	public function get _yscale():Number { return yScaleInternal;}
	
	public function set _x( xIn:Number ):Void
	{
		target._x = xIn;
		xInternal = xIn;
	}
	public function set _y( yIn:Number ):Void
	{
		target._y = yIn;
		yInternal = yIn;
	}
	public function set _xscale( xscaleIn:Number ):Void
	{
		target._xscale = xscaleIn;
		xScaleInternal = xscaleIn;
	}
	public function set _yscale ( yscaleIn:Number ):Void
	{
		target._yscale = yscaleIn;
		yScaleInternal = yscaleIn;
	}
	

	
}
