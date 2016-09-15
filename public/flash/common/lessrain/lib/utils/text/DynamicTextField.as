import lessrain.lib.utils.text.ExtendedStyleSheet;
import lessrain.lib.utils.text.RTLConverter;
import lessrain.lib.utils.text.IRTLProxy;
/**
 * lessrain.lib.text.DynamicTextField, Version 2
 * 
 * DynamicTextField makes it easier to attach text _fields.
 * It handles different types of text_fields and textformatting (html formatted, css formatted or by textFormat object)
 * The library symbol connected to this class needs to be in the library and preloaded
 * Alternatively you can pass the reference toa target-MovieClip 
 * 
 * 
 * <b>Usage:</b>
 * 
 * <code>
 * import lessrain.lib.text.DynamicTextField;
 * 
 * class Test
 * {
 * 	var target:MovieClip;
 * 	var textField:DynamicTextField;
 * 	
 * 	public function Test()
 * 	{
 * 		this.attachMovie("DynamicTextField", "textField", 1);
 * 		
 * 		// OR
 * 		this.createEmptyMovieClip("target",1);
 * 		textField = new DynamicTextField(target);
 * 		
 * 		// set basic _field properties (see default values in constructor)
 * 		textField.isMultiline = true;
 * 		textField.fieldWidth = 200;
 * 		textField.textFormat = textFormat;
 * 		
 * 		// draw the actual text-_field
 * 		textField.create();
 * 		
 * 		// set properties (can be called multiple times or at a later point)
 * 		textField.text = "<b>text</b>"; // HTML formatting will be overwritten if textFormat object is set!
 * 		textField.color = 0xFFFFFF;
  * }
 * </code>
 * 
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 2.0
 * @see: TextField
 * @see: TextField.StyleSheet
 */

class lessrain.lib.utils.text.DynamicTextField extends MovieClip
{
	public static var rtlProxy:IRTLProxy;
	
	public static var DIRECTION_LTR : Number = 1;
	public static var DIRECTION_RTL : Number = 2;
	private static var DEFAULT_DIRECTION : Number = DIRECTION_LTR;
	
	
	private var _targetMC:MovieClip;

	private var _field:TextField;
	private var _textFormat:TextFormat;
	private var _styleSheet:TextField.StyleSheet;
	private var _styleClass:String;
	
	/*
	 * General properties
	 */
	private var _id:String;
	private var _isMultiline:Boolean;
	private var _isAutosize:Boolean;
	private var _isFixedWidth:Boolean;
	private var _isFixedHeight:Boolean;
	private var _isHTML:Boolean;
	private var _isSelectable:Boolean;
	private var _useSystemFont:Boolean;
	private var _isPassword:Boolean;
	private var _isInputField:Boolean;
	private var _isTabEnabled:Boolean;
	private var _wordwrap:Boolean;
	private var _maxChars:Number;
	private var _condenseWhite:Boolean;
	
	/*
	 * Width and height of the TextField
	 */
	private var _fieldWidth:Number;
	private var _fieldHeight:Number;
	
	/*
	 * Extra space when setting the TextField's width / height to the textWidth / textHeight
	 */
	private var _widthBuffer:Number;
	private var _heightBuffer:Number;
	
	/*
	 * Color
	 */
	private var _color:Number;	
	private var _backgroundColor:Number;

	/*
	 * Flash 8 features
	 */
	private var _antiAliasSharpness:Number;
	private var _antiAliasThickness:Number;
	private var _antiAliasType:String;
	private var _gridFitType:String;
	private var _offsetX:Number;
	private var _offsetY:Number;
	
	/*
	 * Direction (DIRECTION_LTR or DIRECTION_RTL)
	 */
	private var _direction:Number;

	private var _rtlTextWidth : Number;


	public static function setDefaultDirection( direction:Number ):Void
	{
		DEFAULT_DIRECTION=direction;
	}

	public function DynamicTextField( target:MovieClip )
	{
		if (target==null) _targetMC=this;
		else _targetMC=target;
		
		_isMultiline = false;
		_isAutosize = true;
		_isFixedWidth = false;
		_isFixedHeight = false;
		_isHTML = true;
		_isSelectable = true;
		_useSystemFont = false;
		_isPassword = false;
		_isInputField = false;
		_isTabEnabled = false;
		_wordwrap=true;
		_maxChars=null;
		_textFormat = null;
		_styleSheet = null;
		_styleClass = null;
		_condenseWhite = true;
		
		_fieldWidth = 2048;
		_fieldHeight = 2048;
		_widthBuffer = 5;
		_heightBuffer = 5;
		_color = 0;
		
		_direction = DEFAULT_DIRECTION;
	}
	
	/**
	 * This function can be used to create a DynamicTextField in 2 lines of code.
	 * It only supports TextFields that are styled with StyleSheets.
	 * The StyleSheet itself contains information about color, size etc. but can also contain custom css attributes
	 * defining the antialiasing and whether to use embeded fonts or system fonts!
	 * 
	 * This function was added to the Flash 8 TextField, because it only makes sense with the custom css attributes!
	 * 
	 * Example:
	 * <code>
	 * 	field = DynamicTextField(_targetMC.attachMovie("DynamicTextField", "field", 1));
	 * 	field.initialize( Label.getLabel("test"), StyleSheet.getStyleSheet("main"), "test", true, true, 35, 52 );
	 * </code>
	 * 
	 */
	public function initialize(text:String, styleSheet_:TextField.StyleSheet, styleClass_:String, isMultiline_:Boolean, isSelectable_:Boolean, x:Number, y:Number, fieldWidth:Number, widthBuffer:Number, isFixedWidth:Boolean, fieldHeight:Number, heightBuffer:Number, isFixedHeight:Boolean, direction_:Number):Void
	{
		styleSheet=styleSheet_;
		styleClass=styleClass_;
		
		if (isMultiline!=null) this.isMultiline=isMultiline_;
		if (isSelectable!=null) this.isSelectable=isSelectable_;
		
		if (fieldWidth!=null) this.fieldWidth=fieldWidth;
		if (widthBuffer!=null) this.widthBuffer=widthBuffer;
		if (isFixedWidth!=null) this.isFixedWidth=isFixedWidth;
		if (fieldHeight!=null) this.fieldHeight=fieldHeight;
		if (heightBuffer!=null) this.heightBuffer=heightBuffer;
		if (isFixedHeight!=null) this.isFixedHeight=isFixedHeight;

		if (direction_!=null) _direction=direction_;
//		if (_direction==DIRECTION_RTL) isSelectable=false;

		create();
		this.text=text;
		
		if (x!=null) _targetMC._x=x;
		if (y!=null) _targetMC._y=y;
	}
	
	public function create()
	{
		/*
		 * Support for new ExtendedStyleSheet options
		 */
		var style:Object;
		if (_styleSheet!=null && _styleClass!=null)
		{
			style = _styleSheet.getStyle("."+_styleClass);
			if (style.embedFont!=null) useSystemFont = (style.embedFont!="true");
		}


		// depth 10 is to allow extension classes to put stuff underneath
		_targetMC.createTextField("_field",10,0,0,_fieldWidth, (_fieldHeight<2048 ? _fieldHeight : 10));
		_field = _targetMC._field;
		_field.html = isHTML;
		_field.multiline = isMultiline;
		
		/* Theres something strange going on here. 
		 * Plz let it as it is.. 
		 * too many projects are depended on this.
		 */ 
			// _field.autoSize = (isAutosize) ? "left" : "none";
		_field.selectable = isSelectable;
		_field.embedFonts = !useSystemFont;
		_field.password = isPassword;
		_field.wordWrap = wordwrap;
		_field.type = (isInputField ? "input" : "dynamic");
		_field.tabEnabled = _isTabEnabled;
		_field.condenseWhite = _condenseWhite;
		
		if (styleSheet!=null)
		{
			_field.styleSheet = styleSheet;
			
			/*
			 * Support for new ExtendedStyleSheet options
			 */
			if (style!=null)
			{
				if (style.antiAliasType!=null) _field.antiAliasType = style.antiAliasType;
				if (style.antiAliasThickness!=null) _field.thickness = Number(style.antiAliasThickness);
				if (style.antiAliasSharpness!=null) _field.sharpness = Number(style.antiAliasSharpness);
				if (style.gridFitType!=null) _field.gridFitType = style.gridFitType;
				if (style.offsetX!=null) _field._x += Number(style.offsetX);
				if (style.offsetY!=null) _field._y += Number(style.offsetY);
			}
		}
		else if (textFormat!=null)
		{
			_field.setTextFormat(textFormat);
			_field.setNewTextFormat(textFormat);
		}
		if (_maxChars!=null) _field.maxChars=_maxChars;
	}
	
	private function updateColor()
	{
		if (_backgroundColor!=null)
		{
			_field.background = true;
			_field.backgroundColor = _backgroundColor;
		}
				
		_field.textColor = color;
	}
	
	public function focus()
	{
		Selection.setFocus(_field);
	}
	
	public function redraw()
	{
		if (textFormat!=null)
		{
			_field.setTextFormat(textFormat);
			_field.setNewTextFormat(textFormat);
		}
		
		if (isFixedWidth)
		{
			_field._width = fieldWidth;
		}
		else
		{
			if (fieldWidth<2048)
			{
				// flex-width, but a width has been set -> we treat the set width as max-width
				_field._width = 2048; // we shouldn't ever have text that's longer than this...
				if (_rtlTextWidth==null) _field._width = Math.min( _field.textWidth + widthBuffer, fieldWidth );
				else _field._width = Math.min( Math.max(_field.textWidth, _rtlTextWidth) + widthBuffer, fieldWidth );
			}
			else
			{
				// flex-width, we set the text _field width to the width of the actual text
				_field._width = 2048; // we shouldn't ever have text that's longer than this...
				if (_rtlTextWidth==null) _field._width = _field.textWidth + widthBuffer;
				else _field._width = Math.max(_field.textWidth, _rtlTextWidth) + widthBuffer;
			}
		}
		
		// hack for wrong wordwrap calculation in flash
		_field._height = 100;


		if (isFixedHeight)
		{
			_field._height = fieldHeight;
		}
		else
		{
			if (fieldHeight<2048)
			{
				// flex-height, but a height has been set -> we treat the set height as max-height
				_field._height = 2048; // we shouldn't ever have text that's higher than this...
				_field._height = Math.min( _field.textHeight + heightBuffer, fieldHeight);
			}
			else
			{
				// flex-height, we set the text _field height to the height of the actual text
				_field._height = 2048; // we shouldn't ever have text that's longer than this...
				
				// if a test has positive leading it needs extra height buffer
				if (ExtendedStyleSheet(_styleSheet).getLeading(_styleClass)>0) _field._height = _field.textHeight + heightBuffer + ExtendedStyleSheet(_styleSheet).getLeading(_styleClass);
				else _field._height = _field.textHeight + heightBuffer;
			}
		}
		_field.tabEnabled = _isTabEnabled;
		_targetMC.tabEnabled = _isTabEnabled;
	}
	
	public function get text():String
	{
		return _field.text;
	}
	public function set text(setValue:String):Void
	{
		if (isHTML)
		{
			if (_styleClass!=null && _styleClass!="")
			{
				// Only HTML text with stylesheets is supported to be right-to-left
				if (_direction == DIRECTION_RTL && rtlProxy!=null)
				{
					// because the charcters are swapped in the rtl algorithm (and the text measuring in rtl is on logical direction) add some extra buffer, as charcters might move closer together
					if (_widthBuffer==5) _widthBuffer=8;
					
					rtlProxy.convert( setValue, ExtendedStyleSheet(_styleSheet), _styleClass, _fieldWidth, _widthBuffer, _isMultiline);
					setValue=rtlProxy.getText();
					
					/*
					 * as right aligned text usually measures and renders smaller (ignoring antialias and gridfit propertied),
					 * but breaks as if rendered correctly, ask the rtlconverter for the real width of the text
					 * _field.textWidth would return faulty values
					 * rtlconverter measures the text left align during the process, and therefor knows the correct width
					 */
					_rtlTextWidth = rtlProxy.getTextWidth();
					
//					Logger.getInstance().enableLogger=true;
//					Logger.getInstance().enableOutput=true;
//					Logger.getInstance().log( "Time taken: "+((endTime-startTime)/1000) );
				}
				
				_field.htmlText = "<span class=\""+_styleClass+"\">"+setValue+"</span>";
			} 
			else
			{
				_field.htmlText = setValue;
			}
		}
		else _field.text = setValue;
		
		redraw();
	}
	
	public function get isHTML():Boolean { return _isHTML; }
	public function set isHTML(setValue:Boolean):Void { _isHTML = setValue; }
	
	public function get isMultiline():Boolean { return _isMultiline; }
	public function set isMultiline(setValue:Boolean):Void { _isMultiline = setValue; }
	
	// autosize could be a boolean or string
	public function get isAutosize():Boolean { return _isAutosize; }
	public function set isAutosize(setValue:Boolean):Void { _isAutosize = setValue; }
	
	public function get wordwrap():Boolean { return _wordwrap; }
	public function set wordwrap(setValue:Boolean):Void { _wordwrap = setValue; }
	
	public function get isFixedWidth():Boolean { return _isFixedWidth; }
	public function set isFixedWidth(setValue:Boolean):Void { _isFixedWidth = setValue; }
	
	public function get isFixedHeight():Boolean { return _isFixedHeight; }
	public function set isFixedHeight(setValue:Boolean):Void { _isFixedHeight = setValue; }
	
	public function get isSelectable():Boolean { return _isSelectable; }
	public function set isSelectable(setValue:Boolean):Void { _isSelectable = setValue; }
	
	public function get useSystemFont():Boolean { return _useSystemFont; }
	public function set useSystemFont(setValue:Boolean):Void { _useSystemFont = setValue; }
	
	public function get isPassword():Boolean { return _isPassword; }
	public function set isPassword(setValue:Boolean):Void { _isPassword = setValue; }
	
	public function get isInputField():Boolean { return _isInputField; }
	public function set isInputField(setValue:Boolean):Void { _isInputField = setValue; }
	
	public function get isTabEnabled():Boolean { return _isTabEnabled; }
	public function set isTabEnabled(setValue:Boolean):Void { _isTabEnabled = setValue; }
	
	public function get maxChars():Number { return _maxChars; }
	public function set maxChars(value:Number):Void { _maxChars=value; }
	
	public function get condenseWhite():Boolean { return _condenseWhite; }
	public function set condenseWhite(value:Boolean):Void { _condenseWhite=value; }
		
	
	public function get textWidth():Number { return _field.textWidth; }
	public function get textHeight():Number { return _field.textHeight; }

	public function get fieldWidth():Number { return _fieldWidth; }
	public function set fieldWidth(setValue:Number):Void
	{
		/*
		if the width is set, we default to a fixed width _field!
		for the rare case of having a flex-width _field with a set width (ie. a max. width)
		you need to set the property seperately afterwards
		*/
		isFixedWidth = true;
		
		_fieldWidth = setValue;
	}

	public function get fieldHeight():Number { return _fieldHeight; }
	public function set fieldHeight(setValue:Number):Void
	{
		/*
		if the height is set, we default to a fixed height _field!
		for the rare case of having a flex-height _field with a set height (ie. a max. height)
		you need to set the property seperately afterwards
		*/
		isFixedHeight = true;
		
		_fieldHeight = setValue;
	}
	
	public function get widthBuffer():Number { return _widthBuffer; }
	public function set widthBuffer(setValue:Number):Void { _widthBuffer = setValue; }
	
	public function get heightBuffer():Number { return _heightBuffer; }
	public function set heightBuffer(setValue:Number):Void { _heightBuffer = setValue; }
	
	public function get color():Number { return _color; }
	public function set color(setValue:Number):Void { _color = setValue; updateColor(); }
	
	public function get backgroundColor():Number { return _backgroundColor; }
	public function set backgroundColor(value:Number):Void { _backgroundColor=value; updateColor(); }
	
	public function get textFormat():TextFormat { return _textFormat; }
	public function set textFormat(setValue:TextFormat):Void { _textFormat = setValue; }
	
	public function get id():String{ return _id; }
	public function set id(setValue:String):Void { _id = setValue; }
	
	public function get target():MovieClip { return _targetMC; }
	public function set target(value:MovieClip):Void { _targetMC=value; }
	
	public function get textField():TextField { return _field; }

	/*
	 * StyleSheet stuff
	 */
	public function get styleSheet():TextField.StyleSheet { return _styleSheet; }
	public function set styleSheet(setValue:TextField.StyleSheet):Void { _styleSheet = setValue; }

	public function set styleClass(setValue:String):Void
	{
		_styleClass = setValue;

		/*
		 * This is for support of the custom css attributes:
		 * 
		 * embed-font: true;
		 * anti-alias-type: advanced;
		 * anti-alias-thickness: 0;
		 * anti-alias-sharpness: 0;
		 * grid-fit-type: pixel;
		*/
		if (_styleSheet!=null && _styleClass!=null)
		{
			var style:Object = _styleSheet.getStyle("."+_styleClass);
			
			if (style.embedFont!=null) useSystemFont = (style.embedFont!="true");
			if (style.antiAliasType!=null) antiAliasType = style.antiAliasType;
			if (style.antiAliasThickness!=null) antiAliasThickness = Number(style.antiAliasThickness);
			if (style.antiAliasSharpness!=null) antiAliasSharpness = Number(style.antiAliasSharpness);
			if (style.gridFitType!=null) gridFitType = style.gridFitType;
			if (style.offsetX!=null) offsetX = Number(style.offsetX);
			if (style.offsetY!=null) offsetY = Number(style.offsetY);
		}
	}
	public function get styleClass():String { return _styleClass; }
	
	public function get antiAliasType():String { return _antiAliasType; }
	public function set antiAliasType(value:String):Void { _antiAliasType=value; }
	public function get antiAliasThickness():Number { return _antiAliasThickness; }
	public function set antiAliasThickness(value:Number):Void { _antiAliasThickness=value; }
	public function get antiAliasSharpness():Number { return _antiAliasSharpness; }
	public function set antiAliasSharpness(value:Number):Void { _antiAliasSharpness=value; }
	public function get gridFitType():String { return _gridFitType; }
	public function set gridFitType(value:String):Void { _gridFitType=value; }
	public function get offsetX():Number { return _offsetX; }
	public function set offsetX(value:Number):Void { _offsetX=value; }
	public function get offsetY():Number { return _offsetY; }
	public function set offsetY(value:Number):Void { _offsetY=value; }
	
	public function get direction():Number { return _direction; }
	public function set direction(value:Number):Void { _direction=value; }	
	
}
