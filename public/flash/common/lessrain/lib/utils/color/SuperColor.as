/**
 * Super Color
 * extended Color class
 * 
 * -----------------------------------
 * 
 * Based on <a href="http://www.robertpenner.com/">Robert PENNER</a> Color Toolkit v1.3
 *
 * Properties
 *
 *   _brightness
 *   _brightOffset
 *   _contrast
 *   _negative
 *
 *   _rgb
 *   _rgbStr
 *   _red
 *   _green
 *   _blue
 *
 *   _redPercent
 *   _greenPercent
 *   _bluePercent
 *
 *   _redOffset
 *   _greenOffset
 *   _blueOffset
 *
 * Methods
 *
 *   getTarget()
 *
 *   setRGBStr()
 *   getRGBStr()
 *   setRGB2()
 *   getRGB2()
 *   reset()
 *
 *   setBrightness()
 *   getBrightness()
 *   setBrightOffset()
 *   getBrightOffset()
 *	 setContrast()
 *   getContrast()
 *
 *   getNegative()
 *   setNegative()
 *   invert()
 *
 *   setTint()
 *   getTint()
 *   setTint2()
 *   getTint2()
 *   setTintOffset()
 *   getTintOffset()
 *
 *   setRed()
 *   getRed()
 *   setGreen()
 *   getGreen()
 *   setBlue()
 *   getBlue()
 *
 *   setRedPercent()
 *   getRedPercent()
 *   setGreenPercent()
 *   getGreenPercent()
 *   setBluePercent()
 *   getBluePercent()
 *
 *   setRedOffset()
 *   getRedOffset()
 *   setGreenOffset()
 *   getGreenOffset()
 *   setBlueOffset()
 *   getBlueOffset()
 *
 * @version 0.4
 * @author Luis Martinez
 */

class lessrain.lib.utils.color.SuperColor extends Color {

	private var _targetMC:MovieClip;

	/**
	 * Constructor
	 * @param clip Clip to apply the color
	 */
	function SuperColor(clip:MovieClip) {
		super(clip);
		_targetMC = clip;
	}
	
	/**
	 * Returns affected clip
	 * @return Targeted MovieClip
	 */
	public function getTarget():MovieClip {
		return _targetMC;
	}
	
	public function set _alpha(value:Number) { _targetMC._alpha = value; }
	public function get _alpha():Number { return _targetMC._alpha; }
      
   	public function set _x(value:Number) { _targetMC._x = value; }
	public function get _x():Number { return _targetMC._x; }
	
	public function set _y(value:Number) { _targetMC._y = value; }
	public function get _y():Number { return _targetMC._y; }
	
	public function set _xscale(value:Number) { _targetMC._xscale = value; }
	public function get _xscale():Number { return _targetMC._xscale; }
	
	public function set _yscale(value:Number) { _targetMC._yscale = value; }
	public function get _yscale():Number { return _targetMC._yscale; }
	
	public function set _rotation(value:Number) { _targetMC._rotation = value; }
	public function get _rotation():Number { return _targetMC._rotation; }
	
		// ----------o RGB
	

	/**
	 * Set an RGB value from an hexadecimal string
	 * @param hexStr Hexadecimal value string
	 */
	public function setRGBStr(hexStr:String) {
		// grab the last six characters of the string
		hexStr = hexStr.substr (-6, 6);
		setRGB (parseInt (hexStr, 16));
	}
	
	/**
	 * Get the RGB value as a string
	 * @return Hexadecimal value string
	 */
	public function getRGBStr():String {
		var hexStr:String = getRGB().toString(16);
		// fill in zeroes as needed
		var toFill:Number = 6 - hexStr.length;
		while (toFill--) hexStr = "0" + hexStr;
		return hexStr.toUpperCase();
	}

	/**
	 * Set red, green, and blue with normal numbers
	 * @param r Red value between 0 and 255 
	 * @param g Greeb value between 0 and 255 
	 * @param b Blue value between 0 and 255 
	 */
	public function setRGB2(r:Number, g:Number, b:Number) {
		setRGB (r << 16 | g << 8 | b);
	} // Branden Hall - www.figleaf.com
	
	/**
	 * @return Object with r, g, and b properties
	 */
	public function getRGB2():Object {
		var t:Object = getTransform();
		return {r:t.rb, g:t.gb, b:t.bb};
	}
	
	/**
	 * Reset the color object to normal
	 */
	public function reset() : Void {
		setTransform ({ra:100, ga:100, ba:100, rb:0, gb:0, bb:0});
	}



		// ----------o Brightness



	/**	
	 * Brighten just like Property Inspector of MovieClip
	 * @param val Brightness between -100 and 100
	 */
	public function setBrightness(val:Number) {
		var trans:Object = getTransform();
		if (trans!=null)
		{
			trans.ra = trans.ga = trans.ba =  100 - Math.abs(val);
			trans.rb = trans.gb = trans.bb = (val > 0) ? val * (256/100) : 0;
		}
		setTransform(trans);
	}
	
	/**
	 * @return Brightness set with setBrightness
	 * @see setBrightness
	 */
	public function getBrightness():Number {
		var trans:Object = getTransform();
		if (trans!=null)
		{
			return trans.rb ? 100 - trans.ra : trans.ra - 100;
		}
	}
	
	/**
	 * Set brightness offset
	 * @param val Offset between -255 and 255
	 */
	public function setBrightOffset(val:Number) {
		var trans:Object = getTransform();
		if (trans!=null)
		{
			trans.rb = trans.gb = trans.bb = val;
		}
		setTransform(trans);
	}
	
	/**
	 * @return Brightness set with setBrightOffset
	 * @see setBrightOffset
	 */
	public function getBrightOffset():Number {
		return getTransform().rb;
	}
	


		// ----------o Contrast

	/**
	 * Set contrast
	 * @param val Percent between -100 and 100
	 */
	public function setContrast(val:Number) {
		var trans:Object = {};
		trans.ra = trans.ga = trans.ba = val;
		trans.rb = trans.gb = trans.bb = 128 - (128/100 * val);
		setTransform(trans);
	}
	
	/**
	 * @return Contrast set with setContrast
	 * @see setContrast
	 */
	public function getContrast():Number {
	    return getTransform().ra;
	}
		
		// ----------o Negative and invert




	/**
	 * Produce a negative image of the normal appearance
	 * @param percent Between 0 and 100
	 */
	public function setNegative(percent:Number) {
	    var t:Object = {};
	    t.ra = t.ga = t.ba = 100 - 2 * percent;
	    t.rb = t.gb = t.bb = percent * (255/100);
	    setTransform (t);
	}
	
	/**
	 * @return Negative percentage
	 * @see setNegative
	 */
	public function getNegative():Number {
	    return getTransform().rb * (100/255);
	}
	
	/**
	 * Invert the current color values
	 */
	public function invert() {
		var trans:Object = getTransform();
		if (trans!=null)
		{
			trans.ra = -trans.ra;
			trans.ga = -trans.ga;
			trans.ba = -trans.ba;
			trans.rb = 255 - trans.rb;
			trans.gb = 255 - trans.gb;
			trans.bb = 255 - trans.bb;
		}
		setTransform (trans);
	}
	


		// ----------o Tint
	


	/**
	 * Tint with a color just like Property Inspector
	 * @param r Red value between 0 and 255 
	 * @param g Greeb value between 0 and 255 
	 * @param b Blue value between 0 and 255 
	 * @param percent Between 0 and 100 
	 */
	public function setTint(r:Number, g:Number, b:Number, percent:Number) {
		var ratio:Number = percent / 100;
		var trans:Object = {rb:r*ratio, gb:g*ratio, bb:b*ratio};
		trans.ra = trans.ga = trans.ba = 100 - percent;
		setTransform (trans);
	}
	
	/**
	 * @return tint object containing r, g, b, and percent properties
	 * @see setTint
	 */
	public function getTint():Object {
		var trans:Object = getTransform();
		var tint:Object = {percent: 100 - trans.ra};
		var ratio:Number = 100 / tint.percent;
		tint.r = trans.rb * ratio;
		tint.g = trans.gb * ratio;
		tint.b = trans.bb * ratio;
		return tint;
	}
	
	/**
	 * tint with a color - alternate approach
	 * @param rgb Color number between 0 and 0xFFFFFF
	 * @param percent Between 0 and 100
	 */
	public function setTint2(rgb:Number, percent:Number) {
		var r:Number = (rgb >> 16) ;
		var g:Number = (rgb >> 8) & 0xFF;
		var b:Number = rgb & 0xFF;
		var ratio:Number = percent / 100;
		var trans:Object = {rb:r*ratio, gb:g*ratio, bb:b*ratio};
		trans.ra = trans.ga = trans.ba = 100 - percent;
		setTransform (trans);
	}
	
	/**
	 * @return a tint object containing rgb (a 0xFFFFFF number) and percent properties
	 * @see setTint2
	 */
	public function getTint2():Object {
		var trans:Object = getTransform();
		var tint:Object = {percent: 100 - trans.ra};
		var ratio:Number = 100 / tint.percent;
		tint.rgb = (trans.rb*ratio)<<16 | (trans.gb*ratio)<<8 | trans.bb*ratio;
		return tint;
	}



		// ----------o Tint offset



	/**
	 * @param r Red value between 0 and 255 
	 * @param g Greeb value between 0 and 255 
	 * @param b Blue value between 0 and 255 
	 */
	public function setTintOffset(r:Number, g:Number, b:Number) {
		var trans:Object = getTransform();
		trans.rb = r;
		trans.gb = g;
		trans.bb = b;
		setTransform (trans);
	}
	
	/**
	 * @return Object containing r, g, b properties
	 * @see setTintOffset
	 */
	public function getTintOffset():Object {
		var t:Object = getTransform();
		return {r:t.rb, g:t.gb, b:t.bb};
	}
	


		// ----------o Color values




	/**
	 * Set red value
	 * @param amount Between 0 and 255
	 */
	public function setRed(amount:Number) {
		var t:Object = getTransform();
		setRGB (amount << 16 | t.gb << 8 | t.bb);
	}
	
	/**
	 * Get red value
	 * @return Value between 0 and 255
	 * @see setRed
	 */
	public function getRed():Number {
		return getTransform().rb;
	}
	
	/**
	 * Set green value
	 * @param amount Between 0 and 255
	 */
	public function setGreen(amount:Number) {
		var t:Object = getTransform();
		setRGB (t.rb << 16 | amount << 8 | t.bb);
	}
	
	/**
	 * Get green value
	 * @return Value between 0 and 255
	 * @see setGreen
	 */
	public function getGreen():Number {
		return getTransform().gb;
	}
	
	/**
	 * Set blue value
	 * @param amount Between 0 and 255
	 */
	public function setBlue(amount:Number) {
		var t:Object = getTransform();
		setRGB (t.rb << 16 | t.gb << 8 | amount);
	}
	
	/**
	 * Get blue value
	 * @return Value between 0 and 255
	 * @see setBlue
	 */
	public function getBlue():Number {
		return getTransform().bb;
	}
	


		// ----------o Color percentages




	/**
	 * Set red percentage
	 * @param percent Between -100 and 100
	 */
	public function setRedPercent(percent:Number) {
		var trans:Object = getTransform();
		trans.ra = percent;
		setTransform (trans);
	}
	
	/**
	 * Get red percentage
	 * @return Value between -100 and 100
	 * @see setRedPercent
	 */
	public function getRedPercent():Number {
		return getTransform().ra;
	}
	
	/**
	 * Set green percentage
	 * @param percent Between -100 and 100
	 */
	public function setGreenPercent(percent:Number) {
		var trans:Object = getTransform();
		trans.ga = percent;
		setTransform (trans);
	}
	
	/**
	 * Get green percentage
	 * @return Value between -100 and 100
	 * @see setGreenPercent
	 */
	public function getGreenPercent():Number {
		return getTransform().ga;
	}
	
	/**
	 * Set blue percentage
	 * @param percent Between -100 and 100
	 */
	public function setBluePercent(percent:Number) {
		var trans:Object = getTransform();
		trans.ba = percent;
		setTransform (trans);
	}
	
	/**
	 * Get blue percentage
	 * @return Value between -100 and 100
	 * @see setBluePercent
	 */
	public function getBluePercent():Number {
		return getTransform().ba;
	}
	


		// ----------o Color offsets




	/**
	 * Set red offset
	 * @param offset Between -255 and 255
	 */
	public function setRedOffset(offset:Number) {
		var trans:Object = getTransform();
		trans.rb = offset;
		setTransform (trans);
	}
	
	/**
	 * Get red offset
	 * @return Value between -255 and 255
	 * @see setRedOffset
	 */
	public function getRedOffset():Number {
		return getTransform().rb;
	}
	
	/**
	 * Set green offset
	 * @param offset Between -255 and 255
	 */
	public function setGreenOffset(offset:Number) {
		var trans:Object = getTransform();
		trans.gb = offset;
		setTransform (trans);
	}
	
	/**
	 * Get green offset
	 * @return Value between -255 and 255
	 * @see setGreenOffset
	 */
	public function getGreenOffset():Number {
		return getTransform().gb;
	}
	
	/**
	 * Set blue offset
	 * @param offset Between -255 and 255
	 */
	public function setBlueOffset(offset:Number) {
		var trans:Object = getTransform();
		trans.bb = offset;
		setTransform (trans);
	}
	
	/**
	 * Get blue offset
	 * @return Value between -255 and 255
	 * @see setBlueOffset
	 */
	public function getBlueOffset():Number {
		return getTransform().bb;
	}
	



		// ----------o Getter/Setter
	



	/**
	 * RGB value
	 * @type Number
	 */
	function set _rgb(val:Number) {
		setRGB(val);
	}
	
	function get _rgb():Number {
		return getRGB();
	}
	
	/**
	 * RGB value
	 * @type String
	 */
	function set _rgbStr(val:String) {
		setRGBStr(val);
	}
	
	function get _rgbStr():String {
		return getRGBStr();
	}
	
	/**
	 * Brightness value
	 * @type Number
	 */
	function set _brightness(b:Number) {
		setBrightness(b);
	}
	
	function get _brightness():Number {
		return getBrightness();
	}
	
	/**
	 * Brightness offset
	 * @type Number
	 */
	function set _brightOffset (b:Number) {
		setBrightOffset(b);
	}
	
	public function get _brightOffset():Number {
		return getBrightOffset();
	}
	
	/**
	 * Contrast
	 * @type Number
	 */

	function set _contrast (c:Number) {
		setContrast(c);
	}
	
	public function get _contrast():Number {
		return getContrast();
	}
	
	/**
	 * Negative percentage
	 * @type Number
	 */
	public function set _negative(p:Number) {
		setNegative(p);
	}
	
	public function get _negative():Number {
		return getNegative();
	}
	
	/**
	 * Red value
	 * @type Number
	 */
	public function set _red(v:Number) {
		setRed(v);
	}
	
	public function get _red():Number {
		return getRed();
	}
	
	/**
	 * Green value
	 * @type Number
	 */
	public function set _green(v:Number) {
		setGreen(v);
	}
	
	public function get _green():Number {
		return getGreen();
	}
	
	/**
	 * Blue value
	 * @type Number
	 */
	public function set _blue(v:Number) {
		setBlue(v);
	}
	
	public function get _blue():Number {
		return getBlue();
	}
	
	/**
	 * Red percentage
	 * @type Number
	 */
	public function set _redPercent(v:Number) {
		setRedPercent(v);
	}
	
	public function get _redPercent():Number {
		return getRedPercent();
	}
	
	/**
	 * Green percentage
	 * @type Number
	 */
	public function set _greenPercent(v:Number) {
		setGreenPercent(v);
	}
	
	public function get _greenPercent():Number {
		return getGreenPercent();
	}
	
	/**
	 * Blue percentage
	 * @type Number
	 */
	public function set _bluePercent(v:Number) {
		setBluePercent(v);
	}
	
	public function get _bluePercent():Number {
		return getBluePercent();
	}
	
	/**
	 * Red offset
	 * @type Number
	 */
	public function set _redOffset(v:Number) {
		setRedOffset(v);
	}
	
	public function get _redOffset():Number {
		return getRedOffset();
	}
	
	/**
	 * Green offset
	 * @type Number
	 */
	public function set _greenOffset(v:Number) {
		setGreenOffset(v);
	}
	
	public function get _greenOffset():Number {
		return getGreenOffset();
	}
	
	/**
	 * Blue offset
	 * @type Number
	 */
	public function set _blueOffset(v:Number) {
		setBlueOffset(v);
	}
	
	public function get _blueOffset():Number {
		return getBlueOffset();
	}
	
}