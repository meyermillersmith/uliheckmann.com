/**
 * @author lessrain
 */

/*

Usage:

import lessrain.lib.text.ExtendedStyleSheet;
import lessrain.lib.utils.Proxy;

class Constants
{
	private var _css:TextField.StyleSheet;
	private var _cssLoaded:Boolean;

	public function loadCSS()
	{
		_css = new ExtendedStyleSheet();
		_css.load(cssURL);
		_css.onLoad = Proxy.create(this, onLoadCSS);
	}
	public function onLoadCSS(success:Boolean):Void
	{
		_cssLoaded=success;
	}
	public function get css():TextField.StyleSheet
	{
		return _css;
	}
	public function get cssLoaded():Boolean
	{
		return _cssLoaded;
	}
}
 
 */
 
import lessrain.lib.utils.text.ExtendedStyleSheetFix;
import lessrain.lib.utils.geom.Coordinate;

class lessrain.lib.utils.text.ExtendedStyleSheet extends ExtendedStyleSheetFix
{
	private var _styles : Object;


	/*
	strips the unit from the end of the string and returns the number only
	supported units are "pt" and "px" (or anything that starts with a "p" really...)
	textformat doesn't need the units as they're fixed (i.e. size is always pt, indent always px etc.)
	*/
	function stripUnit(input:String):Number
	{
		if ( input.indexOf("p")>=0 ) return Number(input.substr(0, input.indexOf("p")));
		else return Number(input);
	}
	
	/*
	Flash ignores a negative leading and sets it to zero:
	textFormat.leading = -10;
	trace(textFormat.leading); // prints "0"
	
	However it works when setting it through the constructor:
	textFormat = new TextFormat(null, null, null, null, null, null, null, null, null, null, null, null, -10);
	trace(textFormat.leading); // prints "-10"!
	
	This function works around this bug by creating a new TextFormat object with the leading in
	the constructor and re-setting all the previously set properties, except leading...
	It's dirty but it works...
	*/
	function negativeLeadingFix( textFormat:TextFormat, leading:Number ):TextFormat
	{
		if (leading>=0)
		{
			textFormat.leading = leading;
			return textFormat;
		}
		else
		{
			var newTextFormat:TextFormat = new TextFormat(null, null, null, null, null, null, null, null, null, null, null, null, leading);
			for (var property:String in textFormat)
			{
				if (property!="leading") newTextFormat[property]=textFormat[property];
			}
			return newTextFormat;
		}
	}
	
	// override the transform method
	function transform(style:Object):TextFormat
	{
		var format:TextFormat = super.transform(style);
		for (var property:String in style)
		{
			switch (property)
			{
				case "leading": format = negativeLeadingFix( format, stripUnit(style[property]) ); break;
				case "blockIndent": format.blockIndent = stripUnit(style[property]); break;
				case "tabStops": format.tabStops = String(style[property]).split(","); break;
				case "bullet": format.bullet = (style[property]=="true"); break;
				case "align": format.align = style[property]; break;
			}
		}
		
		return format;
	}
	
	/**
	 * Returns the hex-color value of a certain style class as a Number
	 * Practial for assigning the original color of the style to a TextField after a roll-over highlight
	 * 
	 * Example:
	 * textField.color = ExtendedStyleSheet(textField.styleSheet).getColor(textField.styleClass);
	 * 
	 * @param	styleClass		The class name of the Style
	 * @return	The hex-color value as a Number, that can be assigned directly to a textField.color for example
	 */
	public function getColor(styleClass:String):Number
	{
		return parseInt(String(getStyle("."+styleClass).color).substring(1), 16);
	}
	
	/**
	 * Changes the color of a style
	 * Practical for changing the link color for example if the site has different color schemes
	 * Attention: The "." isn't automatically added to the styleClass name, because otherwise "a:link" styles wouldn't be found!
	 * 
	 * Example:
	 * ExtendedStyleSheet(StyleSheet.getStyleSheet("main")).setColor("a:link", "#00ffff");
	 * ExtendedStyleSheet(StyleSheet.getStyleSheet("main")).setColor("a:hover", "#000000");
	 * 
	 * @param	styleClass		The class name of the Style
	 * @param	color				The new color attribute as a string, eg. "#ff0000"
	 * 
	 */
	public function setColor(styleClass:String, color:String):Void
	{
		var style:Object = getStyle(styleClass);
		if (style!=null)
		{
			style.color = color;
			setStyle( styleClass, style );
		}
	}
	
	/**
	 * Returns whether the style uses system font (or embedded fonts)
	 * Practial for having conditions regarding animations of a TextField (system font can't be animated)
	 * 
	 * Example:
	 * if ( ExtendedStyleSheet(textField.styleSheet).embedFont(textField.styleClass) ) textField._alpha=30;
	 * else textField._alpha=100;
	 * 
	 * @param	styleClass		The class name of the Style
	 * @return	The hex-color value as a Number, that can be assigned directly to a textField.color for example
	 */
	public function embedFont(styleClass:String):Boolean
	{
		return String(getStyle("."+styleClass).embedFont)=="true";
	}
	
	/**
	 * Returns the leading used in a style
	 * 
	 * Example:
	 * ExtendedStyleSheet(textField.styleSheet).getLeading(textField.styleClass);
	 * 
	 * @param	styleClass		The class name of the Style
	 * @return	The leading as a Number
	 */
	public function getLeading(styleClass:String):Number 
	{
		return stripUnit(String(getStyle("."+styleClass).leading));
	}
	
	/**
	 * Returns the offset used in a style
	 * 
	 * Example:
	 * ExtendedStyleSheet(textField.styleSheet).getOffset(textField.styleClass);
	 * 
	 * @param	styleClass		The class name of the Style
	 * @return	The offset position as a Coordinate object
	 */
	public function getOffset(styleClass:String):Coordinate 
	{
		var c:Coordinate = new Coordinate(0,0);
		var s:Object = getStyle("."+styleClass);
		if ( s.offsetX!=null && !isNaN(stripUnit(String(s.offsetX))) ) c.x = stripUnit(String(s.offsetX));
		if ( s.offsetY!=null && !isNaN(stripUnit(String(s.offsetY))) ) c.y = stripUnit(String(s.offsetY));
		return c;
	}
	
	public function getTextFormat(styleClass:String):TextFormat
	{
		styleClass = "."+styleClass;
		for (var i : String in _styles) if (i==styleClass) return TextFormat(_styles[i]);
		return null;
	}
}

/*

// see: http://livedocs.macromedia.com/flash/mx2004/main_7_2/00001015.html

// max css support
.sample
{
	font-family: "Arial Black", "Arial", _sans;
	font-size: 11pt;
	font-weight: bold;
	font-style: bold;
	color : #000000;
	text-align: left;
	text-decoration: none;
	display: none;
	margin-left: 5px;
	margin-right: 5px;
	text-indent: 5px;
	
	// these aren't standard css...
	leading: 5pt;
	block-indent: 5px;
	tab-stops: 150, 300;
	bullet: true;
}


// full text format object
font:[getter/setter] "hooge 0555",
size:[getter/setter] 8,
color:[getter/setter] null,
url:[getter/setter] null,
target:[getter/setter] null,
bold:[getter/setter] null,
italic:[getter/setter] null,
underline:[getter/setter] null,
align:[getter/setter] null,
leftMargin:[getter/setter] null,
rightMargin:[getter/setter] null,
indent:[getter/setter] null,
leading:[getter/setter] null,
blockIndent:[getter/setter] null,
tabStops:[getter/setter] null,
bullet:[getter/setter] null,
display:[getter/setter] "block"

// flash standard mapping from css to css object
text-align	->	textAlign	:	Recognized values are left, center, and right.
font-size	->	fontSize	:	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
text-decoration	->	textDecoration	:	Recognized values are none and underline.
margin-left	->	marginLeft	:	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
margin-right	->	marginRight	:	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
font-weight	->	fontWeight	:	Recognized values are normal and bold.
font-style	->	fontStyle	:	Recognized values are normal and italic.
text-indent	->	textIndent	:	Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
font-family	->	fontFamily	:	A comma-separated list of fonts to use, in descending order of desirability. Any font family name can be used. If you specify a generic font name, it will be converted to an appropriate device font. The following font conversions are available: mono is converted to _typewriter, sans-serif is converted to _sans, and serif is converted to _serif.
color	->	color	:	Only hexadecimal color values are supported. Named colors (such as blue) are not supported. Colors are written in the following format: #FF0000.
display	->	display	:	Supported values are inline, block, and none

*/