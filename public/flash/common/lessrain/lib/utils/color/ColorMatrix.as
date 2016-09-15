/**
 * 
 * ColorMatrix
 * Based on ColorMatrix by Mario Klingemann and ColorMatrix by Grant Skinner
 * Modified and rearranged by Luis Martinez and Thomas Meyer (lessrain)
 * @since Flash Player 8
 * @Usage:
 *              var cm:ColorMatrix = new ColorMatrix ();
 *			    cm.adjustBrightnessBy (100);
 *				cm.adjustSaturationBy (-100);
 *				mc.filters = [cm.filter];
 *
 */
 
import flash.filters.ColorMatrixFilter;

class lessrain.lib.utils.color.ColorMatrix
{

	// RGB to Luminance conversion constants by Paul Haeberli
	
	private static var r_lum:Number = 0.3086;
	private static var g_lum:Number = 0.6094;
	private static var b_lum:Number = 0.0820;
	
	public var matrix:Array;
	
	private static var IDENTITY:Array = new Array (1, 0, 0, 0,
											   0, 0, 1, 0,
											   0, 0, 0, 0,
											   1, 0, 0, 0,
											   0, 0, 1, 0);
	
	// constant for contrast calculations
	private static var DELTA_INDEX:Array = [
											
		0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
		0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
		0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
		0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
		0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
		1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
		1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25, 
		2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
		4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
		7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8, 
		10.0
	];
	
	
	function ColorMatrix (mat:Object)
	{
		if (mat instanceof ColorMatrix) {
			matrix = mat.matrix.concat ();
		} else if (mat instanceof Array) {
			matrix = mat.concat ();
		} else {
			matrix=new Array();
			reset ();
		}
	}
	
	public function reset ():Void
	{
		for (var i : Number = IDENTITY.length-1; i >= 0; i--) matrix[i]=IDENTITY[i];
	}
	
	/**
	 * Convenience function. resets the Matrix and sets both brightness and saturation if they have been specified
	 */
	public function adjustColorTo(brightness:Number, saturation:Number, hue:Number, contrast:Number):Void
	{
		reset();
		if (brightness!=null) adjustBrightnessBy(brightness);
		if (saturation!=null) adjustSaturationBy(saturation);
		if (hue!=null) adjustHueBy(hue);
		if (contrast!=null) adjustContrastBy(hue);
	}
	
	public function adjustAlphaTo(a:Number):Void
	{
		reset();
		adjustAlphaBy( a );
	}
	
	// burn color effect value from 0 to 255
	public function burnTo(val:Number) :Void
	{
		reset();
		burnBy( val);
    }
    
    public function burnBy(val:Number) :Void
	{
		
		var mat:Array = new Array ( 1, 0, 0, 0, val,
					  			 	0, 1, 0, 0, val,
					   			 	0, 0, 1, 0, val,
					    		 	0, 0, 0, 1, val );
		
		concat(mat);

    }
	
	
	public function adjustContrastBy(val:Number):Void 
	{
		val = cleanValue(val,100);
		if (val == 0 || isNaN(val)) { return; }
		
		var x:Number;
		
		if (val<0) {
			x = 127+val/100*127;
		} else {
			x = val%1;
			if (x == 0) x = DELTA_INDEX[val];
			else x = DELTA_INDEX[(val<<0)]*(1-x)+DELTA_INDEX[(val<<0)+1]*x;
			x = x*127+127;
		}
		
		var mat:Array = new Array (
							x/127,0,0,0,0.5*(127-x),
							0,x/127,0,0,0.5*(127-x),
							0,0,x/127,0,0.5*(127-x),
							0,0,0,1,0,
							0,0,0,0,1
							);
		concat (mat);
		
	}
	
	public function adjustHueBy(val:Number):Void 
	{
		val = cleanValue(val,180)/180*Math.PI;
		if (val == 0 || isNaN(val)) { return; }
		
		var cVal:Number = Math.cos(val);
		var sVal:Number = Math.sin(val);
		
		var lr:Number = 0.213;
        var lg:Number = 0.715;
        var lb:Number = 0.072;
		
		var mat:Array = new Array (
						   lr+cVal*(1-lr)+sVal*(-lr), lg+cVal*(-lg)+sVal*(-lg), lb+cVal*(-lb)+sVal*(1-lb), 0, 0,
						   lr+cVal*(-lr)+sVal*(0.143), lg+cVal*(1-lg)+sVal*(0.140), lb+cVal*(-lb)+sVal*(-0.283), 0, 0,
						   lr+cVal*(-lr)+sVal*(-(1-lr)), lg+cVal*(-lg)+sVal*(lg), lb+cVal*(1-lb)+sVal*(lb), 0, 0,
						   0, 0, 0, 1, 0,
						   0, 0, 0, 0, 1
						   );
		
		concat (mat);
	}
	
	public function adjustBrightnessBy (val:Number):Void
	{
		val = cleanValue (val, 100);
		var mat:Array = new Array (1, 0, 0, 0, val,
							   0, 1, 0, 0, val,
							   0, 0, 1, 0, val,
							   0, 0, 0, 1, 0);
		concat (mat);
	}
	
	public function adjustSaturationBy ( val:Number ):Void
	{
		val = cleanValue(val,100);
		if (val == 0 || isNaN(val)) { return; }
		var x:Number = 1+((val > 0) ? 3*val/100 : val/100);
		
	    var irlum:Number = (1-x) * r_lum;
		var iglum:Number = (1-x) * g_lum;
		var iblum:Number = (1-x) * b_lum;
		
		var mat:Array =  new Array (irlum + x, iglum, iblum, 0, 0,
					  			irlum, iglum + x, iblum, 0, 0,
					    		irlum, iglum, iblum + x, 0, 0,
					    		0, 0, 0, 1, 0 );
		
		concat(mat);
	}
	
	public function adjustAlphaBy( alpha:Number ):Void
	{
		var mat:Array = new Array ( 1, 0, 0, 0, 0,
					  			 0, 1, 0, 0, 0,
					   			 0, 0, 1, 0, 0,
					    		 0, 0, 0, alpha, 0 );
		
		concat(mat);
	}
	
	/**
	 * convert to black and white
	 */
	public function desaturate():Void
	{
		var mat:Array =  new Array ( r_lum, g_lum, b_lum, 0, 0,
									 r_lum, g_lum, b_lum, 0, 0,
									 r_lum, g_lum, b_lum, 0, 0,
									 0    , 0    , 0    , 1, 0 );
		
		concat(mat);
	}
	
	public function concat (mat:Array):Void
	{
		var temp:Array = new Array ();
		var i:Number = 0;
		for (var y:Number = 0; y<4; y++) {
			for (var x:Number = 0; x<5; x++) {
				temp[i+x] = mat[i]*matrix[x]+
							mat[i+1]*matrix[x+5]+
							mat[i+2]*matrix[x+10]+
							mat[i+3]*matrix[x+15]+
							(x == 4 ? mat[i+4] : 0);
			}
			i += 5;
		}
		matrix = temp;
	}
	
	private function cleanValue (val:Number, limit:Number):Number
	{
		return Math.min (limit, Math.max (-limit, val));
	}
	
	public function get filter ():ColorMatrixFilter
	{
		return new ColorMatrixFilter (matrix);
	}
}
