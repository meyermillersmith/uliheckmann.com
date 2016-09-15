/**
 * 
 * HSB < - > RGB
 * Based on C Code in "Computer Graphics -- Principles and Practice,"
 * Foley et al, 1996, pp. 592,593.
 * Converted to Actionscript by Guy Watson guy@flashguru.co.uk
 * Modified to strict typing by Thomas Meyer thomas@lessrain.com
 * 
 * @author Guy Watson guy@flashguru.co.uk
 */
class lessrain.lib.utils.color.ColorConversion
{
	//hue: 0-360
	//saturation: 0-100
	//brightness: 0-100
	public static function hsbtorgb(hue:Number,saturation:Number,brightness:Number):Object
	{
		var red:Number, green:Number, blue:Number;
		hue%=360;
		if(brightness==0)
		{
			return {red:0, green:0, blue:0};
		}
		saturation/=100;
		brightness/=100;
		hue/=60;
		var i:Number = Math.floor(hue);
		var f:Number = hue-i;
		var p:Number = brightness*(1-saturation);
		var q:Number = brightness*(1-(saturation*f));
		var t:Number = brightness*(1-(saturation*(1-f)));
		switch(i)
		{
			case 0:
			
				red=brightness; green=t; blue=p;
				break;
			
			case 1:
			
				red=q; green=brightness; blue=p;
				break;
				
			case 2:
			
				red=p; green=brightness; blue=t;
				break;
				
			case 3:
			
				red=p; green=q; blue=brightness;
				break;
				
			case 4:
			
				red=t; green=p; blue=brightness;
				break;
				
			case 5:
			
				red=brightness; green=p; blue=q;
				break;
		}
		red=Math.round(red*255);
		green=Math.round(green*255);
		blue=Math.round(blue*255);
		return {red:red, green:green, blue:blue};
	}

	
	//red: 0-255
	//green: 0-255
	//blue: 0-255
	
	public static function rgbtohsb(red:Number,green:Number,blue:Number):Object
	{
		var min:Number=Math.min(Math.min(red,green),blue);
		var brightness:Number=Math.max(Math.max(red,green),blue);
		var delta:Number=brightness-min;
		var saturation:Number=(brightness == 0) ? 0 : delta/brightness;
		var hue:Number;
		if(saturation == 0)
		{
			hue=0;
		}
		else
		{
			if(red == brightness)
			{
				hue=(60*(green-blue))/delta;
			}
			else if(green == brightness)
			{
				hue=120+(60*(blue-red))/delta;
			}
			else
			{
				hue=240+(60*(red-green))/delta;
			}
			if(hue<0) hue+=360;
		}
		saturation*=100;
		brightness=(brightness/255)*100;
		return {hue:hue,saturation:saturation,brightness:brightness};
	}

	//red: 0-255
	//green: 0-255
	//blue: 0-255
	//if you want to use it dont forget to make a valid hex: 
	//var newColor = "0x"+newColor.toString(16);
	
	public static function rgbtohex24(red:Number,green:Number,blue:Number):Number
	{
		return (red<<16 | green<<8 | blue);
	}
	
	//color: 24 bit base 10 number
	
	public static function hex24torgb(color:Number):Object
	{
		var r:Number=color >> 16 & 0xff;
		var g:Number=color >> 8 & 0xFF;
		var b:Number=color & 0xFF;
		return {red:r,green:g,blue:b};
	}
	
	//alpha: 0-255
	//red: 0-255
	//green: 0-255
	//blue: 0-255
	
	public static function argbtohex32(red:Number,green:Number,blue:Number,alpha:Number):Number
	{
		return (alpha<<24 | red<<16 | green<<8 | blue);
	}
	
	//color: 32 bit base 10 number
	
	public static function hex32toargb(color:Number):Object
	{
		var a:Number=color >> 24 & 0xFF;
		var r:Number=color >> 16 & 0xff;
		var g:Number=color >> 8 & 0xFF;
		var b:Number=color & 0xFF;
		return {alpha:a,red:r,green:g,blue:b};
	}
	
	public static function hex24tohsb(color:Number):Object
	{
		var rgb:Object=ColorConversion.hex24torgb(color);
		return ColorConversion.rgbtohsb(rgb.red,rgb.green,rgb.blue);
	}
	
	public static function hsbtohex24(hue:Number,saturation:Number,brightness:Number):Number
	{
		var rgb:Object=ColorConversion.hsbtorgb(hue,saturation,brightness);
		return ColorConversion.rgbtohex24(rgb.red,rgb.green,rgb.blue);
	}
}