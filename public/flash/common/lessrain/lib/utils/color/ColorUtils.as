/**
 * 
 * Provides static helper methods for dealing with colors, BitmapDatas etc. 
 * 
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @revision Luis martinez, Less Rain (luis@lessrain.com)
 * @since Flash Player 8
 */
import flash.display.BitmapData;

import lessrain.lib.utils.color.ColorConversion;
 
class lessrain.lib.utils.color.ColorUtils
{
	/**
	 * Averages two RGB values in a fast way
	 * Taken from http://www.compuphase.com/graphic/scale3.htm
	 * 
	 * Attention!
	 * This doesn't work with ARGB values, because Flash operates with 32bit Integers when shifting.
	 * The highest bit will always be 0, so even though the result should be 0x887F7F00, the function will return 0x087F7F00!
	 * If the 2 colors have the same alpha value, the value is preserved though. 
	 * 
	 * @param	a	First Color
	 * @param	b	Second Color
	 * @return	Average by channel of the 2 colors a and b
	 */
	public static function average(a:Number, b:Number):Number
	{
		return ((((a ^ b) & 0xfefefefe) >> 1) + (a & b));
	}
	
	/**
	 * Averages the RGB values of a whole BitmapData object
	 * This isn't particularly fast....
	 * 
	 * @param	bmp	BitmapData
	 * @return	The average RGB value of the BitmapData object
	 */
	public static function averageBitmapData(bmp:BitmapData):Number
	{
		var r:Number = 0, g:Number = 0, b:Number = 0, c:Number;
		for (var i:Number=bmp.height-1; i>=0; i--)
		{
			for (var j:Number=bmp.width-1; j>=0; j--)
			{
				c=bmp.getPixel(j,i);
				r+=(c>>16);
				g+=((c>>8)&0xFF);
				b+=(c&0xFF);
			}
		}
		// c is mistreated as sum of pixels...
		c=bmp.height*bmp.width;
		r=Math.round(r/c);
		g=Math.round(g/c);
		b=Math.round(b/c);
		return (r<<16 | g<<8 | b);
	}

	/**
	 * Converts a Number to an RGB String, i.e. 0xFF5577
	 * 
	 * @param	c				The RGB value to convert
	 * @param	isARGB		Set to true if you want the return value to have the ARGB 24bit format, i.e. 0xFFFF5577. You can also call toARGBString for ease of use
	 * @return	The RGB String representation of color c
	 * 
	 * 	@see		ColorUtils#toARGBString(Number)
	 */
	public static function toRGBString(c:Number, isARGB:Boolean):String
	{
		var output:String = "0x";
		for (var i:Number=(isARGB ? 24:16); i>=0; i-=8)
		{
			var channel:Number = ((c>>i) & 0xff);
			if (channel<=0xf) output+="0";
			output+=channel.toString(16).toUpperCase();
		}
		return output;
	}	
	
	/**
	 * Converts a Number to an ARGB String, i.e. 0xFFFF5577
	 * 
	 * @param	c				The ARGB value to convert
	 * 	@see		ColorUtils#toRGBString(Number,Boolean)
	 * @return	The ARGB String representation of color c
	 */
	public static function toARGBString(c:Number):String
	{
		return toRGBString(c,true);
	}
	
	/**
	 * Takes two hex colors and calculates the
	 * blend of those two colors based on the 3rd argument p
	 * 
	 * @param	c1, c2: Hex values of the colors to blend
	 * @param	p: a value between -1 and 1 which blends the passed colors together. The range is
	 *			actually 0 to 1 or 0 to -1.  Using negative numbers just reverses the blend from
	 *			color 1 to color 2 to color 2 to color 1 
	 * 
	 * @return	New HEX value of the color blend
	 */
	public static function blendHEX(c1:Number, c2:Number, p:Number):Number
	{
		if (p<-1) p = -1;
		else if (p>1) p = 1;
		if (p<0) p = 1+p;
		
		var tempC1 : Object = ColorConversion.hex24torgb(c1);
		var tempC2 : Object = ColorConversion.hex24torgb(c2);
		
		return (tempC1.red+(tempC2.red-tempC1.red)*p) << 16 | (tempC1.green+(tempC2.green-tempC1.green)*p) << 8 | (tempC1.blue+(tempC2.blue-tempC1.blue)*p);
	}
	
	
	/**
	 * Colorizes a MovieClip
	 * @param	targetMC	the MovieClip
	 * @param	color		the Number of the Color
	 */
	static function colorize (targetMC:MovieClip, col:Number):Void
	{
		var c:Color = new Color (targetMC);
		c.setRGB (col);
	}
	
}