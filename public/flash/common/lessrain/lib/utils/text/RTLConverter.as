/**
 * lessrain.lib.utils.text.RTLConverter, Beta
 * 
 * 
 * RTLConverter converts a string passed in logical right-to-left (RTL) order into a String with pseudo RTL visual order.
 * This String can then be written into a Flash TextField (which should be right aligned).
 * 
 * Limitations:
 * - \n line breaks are ignored
 * - Markup has to be well formed, i.e. correctly nested, opening and closing tags must match
 * - Markup will be separated in lines. Links can span multiple lines, but hovers will only work on a per line basis.
 * - Character type tables aren't fully implemented, so there can always be errors.
 * 
 * References:
 * Description of the algorithm: http://people.w3.org/rishida/scripts/bidi/
 * Unicode tables: http://www.unicode.org/charts/
 * Character classes: http://www.sql-und-xml.de/unicode-database/
 *  
 * 
 * <b>Usage:</b>
 * 
 * <code>
 * import lessrain.lib.utils.text.RTLConverter;
 * class Test
 * {
 * 	private var _tf:TextField;
 * 	private var _styleSheet:ExtendedStyleSheet;
 * 	private var _styleClass:String;
 * 	private var _fieldWidth:Number;
 * 	private var _isMultiline:Boolean;
 * 	private var _text:String;
 * 	
 * 	public function Test()
 * 	{
 * 		createTextField();
 * 		writeText();
 * 	}
 * 	private function createTextField():Void
 * 	{
 * 		// Create the TextField here...
 * 	}
 * 	private function writeText():Void
 * 	{
 * 		var rtlConverter:RTLConverter = new RTLConverter(_text, ExtendedStyleSheet(_styleSheet), _styleClass, _fieldWidth, _isMultiline);
 * 		rtlConverter.convert();
 * 		_tf.htmlText = "<p class=\""+_styleClass+"\"  align=\"right\">"+rtlConverter.convertedText+"</p>";
 * 	}
 * }
 * </code>
 * 
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @version 1.9
 * @see: lessrain.lib.utils.text.ExtendedStyleSheet
 */
 
import lessrain.lib.utils.text.ExtendedStyleSheet;

class lessrain.lib.utils.text.RTLConverter
{
	private static var lineBreaks:Array = ["<br>", "<br/>", "<br />", "<p>", "</p>"];
	private static var ignore:Array = ["\n", "\r"];
	private static var formatingStart:Array = ["<b>", "<i>"];
	private static var formatingEnd:Array = ["</b>", "</i>"];
	private static var enableEntityReplacement:Boolean = true;
	
	private static var runLTR:Number = 1;
	private static var runRTL:Number = 2;

	private static var typeNeutral:Number = 0;
	private static var typeLTR:Number = 1;
	private static var typeRTL:Number = 2;
	private static var typeWeak:Number = 5;
	private static var typeMarkupStart:Number = 10;
	private static var typeMarkup:Number = 11;
	private static var typeMarkupEnd:Number = 12;
	
	private var _sourceText:String;
	private var _styleSheet:ExtendedStyleSheet;
	private var _styleClass:String;
	private var _overallRun:Number;

	private var _textFieldWidth:Number;
	private var _isMultiline:Boolean;
	private var _embedFonts : Boolean;
	private var _antiAliasType : String;
	private var _thickness : Number;
	private var _sharpness : Number;
	private var _gridFitType : String;
	
	private var _convertedText:String;
	private var _lines : Array;

	private var _measureTFDepth:Number;
	private var _measureTF : TextField;

	private var _markupStack : Array;
	private var _markupData : Object;
	private var _markupFound : Boolean;
	private var _markupOpened : Boolean;
	private var _markupClosed : Boolean;
	private var _wasMarkupFragment : Boolean;

	/*
	 * _textWidth records the actual width of the text when align to the left
	 * Flash renders right aligned text smaller (ignoring anitalias and gridfit), but breaks it as if it was rendered with those properties!
	 * So if you need the proper width of the text at a later point, for example to set the width of your textfield, use this
	 * textfield.textWidth will give you a wrong measurement as it's right aligned!
	 */
	private var _textWidth : Number;

	/**
	 * Constructor takes all the important arguments
	 * All arguments are required!
	 * 
	 * @param	sourceText_		Text to be converted in logical RTL order
	 * @param	styleSheet_		StyleSheet used to format the TextField
	 * @param	styleClass_		Name of the Style in styleSheet_ used to format the TextField
	 * @param	textFieldWidth_	Width of the TextField. This is important as the Text can only be converted if it has a target width!
	 * @param	isMultiline_		Indicates if the text should only occupy 1 line of text. Conversion for single line is optimized and therefore faster.
	 * 
	 */
	public function RTLConverter( sourceText_:String, styleSheet_:ExtendedStyleSheet, styleClass_:String, textFieldWidth_:Number, isMultiline_:Boolean )
	{
		_sourceText=(sourceText_==null ? "" : sourceText_);
		
		/*
		 * RTLConverter should only be used for text that is usually RTL, however the special markup:
		 * <p style="direction:ltr">.....</p>
		 * can be used to specifically set a text that is usually RTL as LTR
		 * only the tag as printed above is supported, to have the text as RTL, simply remove the merkup,
		 * do not try to set it as direction:rtl 
		 */
		var directionInfo:String = _sourceText.substr(0, 25);
		if (directionInfo.toLowerCase()=="<p style=\"direction:ltr\">")
		{
			_overallRun = runLTR;
			_sourceText=_sourceText.substring(25,_sourceText.length-4);
		}
		else _overallRun = runRTL;
		
		_styleSheet=styleSheet_;
		_styleClass=styleClass_;
		_textFieldWidth=(textFieldWidth_ == null ? 2048 : textFieldWidth_);
		_isMultiline=isMultiline_;
		_measureTFDepth = 10370;
		_embedFonts = _styleSheet.embedFont(_styleClass);
		_textWidth = 0;
		
		var style:Object;
		style = _styleSheet.getStyle("."+_styleClass);
		
		if (style.antiAliasType!=null) _antiAliasType = style.antiAliasType;
		if (style.antiAliasThickness!=null) _thickness = Number(style.antiAliasThickness);
		if (style.antiAliasSharpness!=null) _sharpness = Number(style.antiAliasSharpness);
		if (style.gridFitType!=null) _gridFitType = style.gridFitType;
	}
	
	/**
	 * Mainfunction of the class, call this to perform the conversion. Converted text is stored in  _convertedText.
	 * Call rtlConverter.convertedText to receive.
	 */
	public function convert():Void
	{
		separateLines();
		
		_convertedText="";
		_markupStack=new Array();
		_markupOpened=false;
		for (var i : Number = 0; i < _lines.length; i++)
		{
			if (i>0) _convertedText+="<br />";
			_convertedText+=convertLine(_lines[i]);

//			Logger.getInstance().log(_lines[i]);
		}
		
		if (_overallRun==runRTL) _convertedText = "<p align=\"right\">"+_convertedText+"</p>";
		
	}
	
	/**
	 * Converts one line of Text in logical order to visual order by performing the bidi algorithm.
	 * Text needs to be split in lines first
	 * 
	 * @param	str_	Line of text in logical order to be converted to visual order
	 * @return	Visual RTL converted line of text
	 * @see	separateLines();
	 */
	private function convertLine(str_:String):String
	{
		var convertedLine:String="";
		
		var lineLength:Number = str_.length;
		var charType:Number;
		var nextCharType:Number;
		var directionalRunFragment:String;
		var previousDirectionalRun:Number=-1;
		var memDirectionalRun:Number=-1;
		var currentDirectionalRun:Number=_overallRun;
		
		var currentCharIndex:Number = 0;
		var charTypes:Array = new Array();
		for (currentCharIndex = 0; currentCharIndex < lineLength; currentCharIndex++) charTypes[currentCharIndex] = getCharType( str_.charCodeAt( currentCharIndex ) );
		_wasMarkupFragment=false;
		
//		var outStr:String = "";
//		for (currentCharIndex = lineLength-1; currentCharIndex >= 0; currentCharIndex--) outStr+=charTypes[currentCharIndex]+", ";//		Logger.getInstance().log(outStr);
		
//		for (currentCharIndex = lineLength-1; currentCharIndex >= 0; currentCharIndex--) Logger.getInstance().log( str_.charAt(currentCharIndex)+": "+charTypes[currentCharIndex] );
		

		currentCharIndex=0;
		while (currentCharIndex<lineLength)
		{
			_markupClosed=false;
			_markupFound=false;
			charType = charTypes[currentCharIndex];
			
			if (charType==typeRTL) currentDirectionalRun=runRTL;
			else if (charType==typeLTR) currentDirectionalRun=runLTR;
			else if (charType==typeWeak)
			{
				if (memDirectionalRun<=0) memDirectionalRun=currentDirectionalRun;
				currentDirectionalRun=runLTR;
			}
			else if (charType==typeNeutral)
			{
				// for neutrals at the end of the line default to the overall directional run (usually rtl)
				if (currentCharIndex==lineLength-1)
				{
					currentDirectionalRun=_overallRun;
				}
				else
				{
					/*
					 * Check for the next non-neutral and see if it will mean a direction change
					 * If so close the fragment and continue with a new one
					 */
					
					nextCharType = charTypes[currentCharIndex+1];
					
					//need to perform a search for a "real" character because the following char is also neutral
					if ( nextCharType==typeNeutral || nextCharType>=typeMarkupStart )
					{
						var c:Number = 2;
						while ((nextCharType==typeNeutral || nextCharType>=typeMarkupStart) && (currentCharIndex+c<lineLength)) 
						{
							nextCharType = charTypes[currentCharIndex+c];
							c++;
						}
					}
					
					// read and clear the memorized directional run
					// if the next char after the neutral is again a weak one, continue memorizing... we're still weak LTR
					if ( nextCharType!=typeWeak && memDirectionalRun>0)
					{
						currentDirectionalRun=memDirectionalRun;
						memDirectionalRun=-1;
					}
					
					// if it's still neutral we're at the end of the line, go to the overall context direction (usually RTL)
					if ( nextCharType==typeNeutral )
					{
						currentDirectionalRun=_overallRun;
					}
					// need to compare the previous running direction with the next char's type
					else if ( (currentDirectionalRun==runRTL && nextCharType==typeRTL) || (currentDirectionalRun==runLTR && (nextCharType==typeLTR || nextCharType==typeWeak) ))
					{
						// nothing, the direction run doesn't change, continue with the fragment
					}
					else
					{
						// there is a change of direction, default to the overall context direction (usually RTL) and close the fragment (later)
						currentDirectionalRun=_overallRun;
					}
				}
				
			}
			/*
			 * If there's markup, do some dirty memorizing of the opening and closing tag
			 * repeat it for every fragment and every line until the closing tag is found
			 * there's no direct match for the closing tag, the last opened markup will be closed first
			 * therefore markup should be properly nested!
			 */
			else if (charType==typeMarkupStart)
			{
				var markup:String="";
				_markupFound=true;
				
				// advance across the <
				currentCharIndex++;
				
				// get the markup string without < and > (first and last character)
				// one markup tag should always be in one line so no need to check for line end
				// line breaks are filtered earlier
				while (charTypes[currentCharIndex]==typeMarkup) 
				{
					markup+=str_.charAt( currentCharIndex );
					currentCharIndex++;
				}
				
				// if the first character is a / it's a closing tag
				// closing tags are ignored
				// memorize that a markup has been closed so that it's removed from the stack later
				if (markup.charAt(0)=="/") _markupClosed=true;
				
				// if the last character is a / it's an empty tag
				// empty tags are ignored completely
				// if that's not the case it's a normal opening tag
				// -> add it to the markup stack
				else if (markup.charAt(markup.length-1)!="/")
				{
					_markupData = new Object();
					_markupData.pre="<"+markup+">";
					// if there's a space in the markup there are attributes which should be ignored for the closing tag, i.e. "a href..."
					// if there's no space just add the markup i.e. "b"
					var spaceIndex:Number = markup.indexOf(" ");
					if (spaceIndex<0) _markupData.post="</"+markup+">";
					else _markupData.post="</"+markup.substring(0,markup.indexOf(" "))+">";
				}
			}
			
			// If there's a change of direction or some markup was found, close the current fragment and append it to the line
			if (previousDirectionalRun!=currentDirectionalRun || _markupFound)
			{
				convertedLine = appendFragment(convertedLine, directionalRunFragment, currentDirectionalRun, previousDirectionalRun);
				// memorize if the directional change (i.e. fragment run) was due to a markup
				// if it was then the append function might need to append the fragment on the right, although the overall direction is RTL
				_wasMarkupFragment = _markupFound;
				
				directionalRunFragment="";
				previousDirectionalRun=currentDirectionalRun;
			}
			
			// just dealing with markup, no need to add any text to the current line
			if (_markupFound)
			{
				// remove a markup from the stack if it has been closed
				if (_markupClosed) _markupStack.pop();
				// otherwise add the newly created markup
				else _markupStack.push(_markupData);
			}
			// if it's a normal character add it to the current fragment in the previously determined running order
			else
			{
				var char:String = str_.charAt( currentCharIndex );
				var charCode:Number = char.charCodeAt( 0 );
				if (isDirectionMark( charCode )) char=" ";
				
				if ( currentDirectionalRun==runLTR ) directionalRunFragment += char;
				else if ( currentDirectionalRun==runRTL )
				{
					// if the direction is RTL and the char is a bracket, a hack has to be performed: swap the brackets (opening/closing)
					if (isBracket( charCode )) directionalRunFragment = getBracketReplacement( charCode ) + directionalRunFragment;
					else directionalRunFragment = char + directionalRunFragment;
				}
			}

			// advance to the next character...
			currentCharIndex++;
		}
		
		// close and write the last eventually remaining fragment
		convertedLine = appendFragment(convertedLine, directionalRunFragment, currentDirectionalRun, previousDirectionalRun);
		
//		getURL("javascript:alert('|"+convertedLine+"|')");
		return convertedLine;
	}
	
	/**
	 * Appends a fragment of a line to an excisting line considering the current directional run (ltr or rtl) of the text (i.e. of the fragment).
	 * Text is appended to the left or to the right accordingly
	 * 
	 * @param	line								Excisting line
	 * @param	fragment						Fragment in one running order / directional run to be appended
	 * @param	currentDirectionalRun		The running order / directional run the fragment is in
	 * @param	previousDirectionalRun	The running order / directional run of the previous fragment (of the line)
	 * @return	The new line with the fragment appended at the correct position with the correct markup
	 */
	private function appendFragment(line:String, fragment:String, currentDirectionalRun:Number, previousDirectionalRun:Number):String
	{
//		getURL("javascript:alert('|"+fragment+"| "+_markupFound+", "+previousDirectionalRun+" -> "+currentDirectionalRun+"')");
		if (fragment!=null && fragment!="")
		{
			// if there's markup, wrap it around the current frament
			if (_markupStack.length>0)
			{
				var prefix:String = "";
				var postfix:String = "";
				// add all the opening markup in normal order to the prefix
				// add all the closing markup in descending order to the postfix
				for (var i : Number = 0; i < _markupStack.length; i++)
				{
					prefix+=_markupStack[i].pre;
					postfix=_markupStack[i].post+postfix;
				}
				
				// add the fragment with markup wrapped around
				if (fragment!=null)
				{
					// if the previous directional run change wasn't a real one (i.e. caused by markup) and the directional run has actually continued from LTR to LTR (for example markup embedded within a ltr text), the fragment needs to be appended on the right, although the overall direction is RTL (which it would usually default to between fragments)
					if (_wasMarkupFragment && previousDirectionalRun==currentDirectionalRun && currentDirectionalRun==runLTR) line=line+prefix+fragment+postfix;
					else line=prefix+fragment+postfix+line;
				}
			}
			// otherwise just add the fragment (redundant but faster than always going through the above)
			else
			{
				if (fragment!=null)
				{
					// if the previous directional run change wasn't a real one (i.e. caused by markup) and the directional run has actually continued from LTR to LTR (for example markup embedded within a ltr text), the fragment needs to be appended on the right, although the overall direction is RTL (which it would usually default to between fragments)
					if (_wasMarkupFragment && previousDirectionalRun==currentDirectionalRun && currentDirectionalRun==runLTR) line=line+fragment;
					else line=fragment+line;
				}
			}
		}
		return line;
	}
	
	/**
	 * Returns the type of a character
	 * Based on (not fully implemented for performance reasons):
	 * Unicode tables: http://www.unicode.org/charts/
	 * Character classes: http://www.sql-und-xml.de/unicode-database/
	 * 
	 * @param	code_	Unicode character code
	 * @return	Type of character according to constants in RTLConverter
	 */
	private function getCharType(code_:Number):Number
	{
		// Markup requires special treatment
		// < character
		if (code_==0x003C)
		{
			_markupOpened=true;
			return typeMarkupStart;
		}
		// markup has been opened
		if (_markupOpened)
		{
			// > character, closing the markup
			if (code_==0x003E)
			{
				_markupOpened=false;
				return typeMarkupEnd;
			}
			// other characters within markup
			else
			{
				return typeMarkup;
			}
		}

		// whitespace is neutral (http://www.sql-und-xml.de/unicode-database/bidi-ws.html)
		if (code_==0x000C || code_==0x0020) return typeNeutral;

		// paragraph separators are neutral (http://www.sql-und-xml.de/unicode-database/bidi-b.html)
		else if (code_==0x000A || code_==0x000D || code_==0x001C || code_==0x001D || code_==0x001E || code_==0x0085) return typeNeutral;

		/*
		 * !"&'()*   +,-./
		 * Although the code tables say that !"&'()* are weak, it works better when they're neutral (also logically)
		 * Same goes for +,-./ they can be number separators which apparently are weak (see below), but usually they're paragraph separators, i.e. neutral
		 */
		else if ( (code_>=0x0021 && code_<=0x0022) || (code_>=0x0026 && code_<=0x0029) || (code_>=0x002B && code_<=0x002F)  ) return typeNeutral;

		/*
		 * :;<=>?@
		 * Haven't really found information for those, but they work as neutrals...
		 */
		else if ( code_>=0x003A && code_<=0x0040 ) return typeNeutral;

		// segment separator are neutral (http://www.sql-und-xml.de/unicode-database/bidi-s.html)
		else if (code_==0x0009 || code_==0x000B || code_==0x001F) return typeNeutral;
		
		// numbers are weak (http://www.sql-und-xml.de/unicode-database/bidi-en.html)
		else if (code_>=0x0030 && code_<=0x0039) return typeWeak;
		
		// control characters are weak, soft hyphen, number separators
		// http://www.sql-und-xml.de/unicode-database/bidi-bn.html
		// http://www.sql-und-xml.de/unicode-database/bidi-cs.html
		// http://www.sql-und-xml.de/unicode-database/bidi-es.html
		else if (code_<=0x001B || (code_>=0x007F && code_<=0x009F) || code_==0x00AD || code_==0x003A || code_==0x00A0 || code_==0x060C) return typeWeak;
		
		// number terminators are weak (http://www.sql-und-xml.de/unicode-database/bidi-et.html)
		else if ( (code_>=0x0023 && code_<=0x0025) || (code_>=0x00A2 && code_<=0x00A5) || code_==0x00B0 || code_==0x00B1 || code_==0x20A0 ) return typeWeak;
		
		// arabic numbers are weak
		else if (code_>=0x0660 && code_<=0x066C) return typeWeak;

		// Speedup for common latin characters
		else if ((code_>=0x0041 && code_<=0x005A) || (code_>=0x0061 && code_<=0x007A) || (code_>=0x00C0 && code_<=0x0233)) return typeLTR;
		
		// Hewbrew characters are RTL
		else if (code_>=0x0590 && code_<=0x05FF) return typeRTL;
		
		// Arabic characters are RTL
		else if ((code_>=0x0600 && code_<=0x06FF) || (code_>=0x0750 && code_<=0x077F)) return typeRTL;
		
		// RLM and LRM (special mark characters)
		else if (code_==0x200E) return typeLTR;
		else if (code_==0x200F) return typeRTL;
		
		// We assume others to be LTR, although there shouldn't be many coming through till here...
		else
		{
//			getURL("javascript:alert('"+code_+"')");
			return typeLTR;
		}
		
		return typeRTL;
	}
	
	private function isDirectionMark( code_:Number ):Boolean
	{
		return (code_==0x200E || code_==0x200F);
	}
	
	private function isBracket(code_:Number):Boolean
	{
		switch (code_)
		{
			case 0x0028:
			case 0x0029:
			case 0x005B:
			case 0x005D:
			case 0x007B:
			case 0x007D: return true;
			default: return false;
		}
	}
	
	private function getBracketReplacement(code_:Number):String
	{
		switch (code_)
		{
			case 0x0028: return ")";
			case 0x0029: return "(";
			case 0x005B: return "]";
			case 0x005D: return "[";
			case 0x007B: return "}";
			case 0x007D: return "{";
			default: return "";
		}
	}
	
	/**
	 * Seperates the text to be converted into single lines
	 * _sourceText is read
	 * _lines is populated
	 * 
	 * @see	_sourceText
	 */
	private function separateLines():Void
	{
		_sourceText=filter(_sourceText);
		_lines = new Array();
		_markupStack = new Array();
		
		var textFormat:TextFormat = _styleSheet.getTextFormat(_styleClass);
		textFormat.align="left";
		resetMeassureTextField();
		
		if (_isMultiline)
		{
			var textLength:Number = _sourceText.length;
			var lineStart:Number = 0;
			var lineEnd:Number = 0;
			var previousEnd:Number = 0;
			var lineFull:Boolean = false;
			var currentWidth:Number;
			var line:String;
			var linePrefix:String="";
			var linePostfix:String="";
			
			while ( lineEnd<textLength )
			{
				lineEnd = _sourceText.indexOf(" ", previousEnd+1);
				if (lineEnd==-1) lineEnd=textLength;
				
				
				_measureTF.htmlText = linePrefix+_sourceText.substring(lineStart, lineEnd)+linePostfix;
				_measureTF.setTextFormat(textFormat);
				currentWidth = _measureTF.textWidth;
				
				lineFull = ( currentWidth>_textFieldWidth );
				if (!lineFull && (lineEnd==textLength))
				{
					lineFull=true;
					previousEnd=textLength;
				}
				
				if (lineFull)
				{
					var separatorLength:Number=1;
					var breakIndex:Number=-1;
					var foundIndex:Number=-1;
					
					// get the line without trailing space or line break, and with ignored characters filtered.
					line = _sourceText.substring(lineStart, previousEnd);

					_measureTF.htmlText = linePrefix+line+linePostfix;
					_measureTF.setTextFormat(textFormat);
					_textWidth = Math.max(_measureTF.textWidth, _textWidth);

					// look for line breaks in the current line
					for (var i : Number = lineBreaks.length-1; i >= 0; i--)
					{
						foundIndex=line.indexOf(lineBreaks[i]);
						// if there's a break within the current line remember the index (the lowest index will be considered at the end
						if ( foundIndex>=0  && (breakIndex<0 || foundIndex<breakIndex) )
						{
							breakIndex=foundIndex;
							separatorLength=lineBreaks[i].length;
						}
					}
	
					// if a break was found break the line earlier
					if ( breakIndex>=0 )
					{
						previousEnd = lineStart+breakIndex;
						line = line.substring(0, breakIndex);
					}
					
					_lines.push( line );
					// movie the pointer beyond the space or line break
					lineStart=lineEnd=previousEnd+separatorLength;

					// look for formatting end/start in the current line
					var markupHasChanged:Boolean=false;
					for (var i : Number = 0; i < formatingStart.length; i++) if ( line.indexOf(formatingStart[i])>=0 ) { _markupStack.push(i); markupHasChanged=true; }					for (var i : Number = 0; i < formatingEnd.length; i++) if ( line.indexOf(formatingEnd[i])>=0 ) { _markupStack.pop(); markupHasChanged=true; }
					linePrefix="";					linePostfix="";
					for (var i : Number = 0; i < _markupStack.length; i++)
					{
						linePrefix+=formatingStart[_markupStack[i]];
						linePostfix=formatingEnd[_markupStack[i]]+linePostfix;
					}
					if (markupHasChanged) resetMeassureTextField();
				}
				previousEnd = lineEnd;
			}
		}
		else
		{
			_measureTF.htmlText = _sourceText;
			_measureTF.setTextFormat(textFormat);
			_textWidth = _measureTF.textWidth;
			_lines.push( _sourceText );
		}
		
		_measureTF.removeTextField();
	}
	
	/**
	 * Resets the TextField used to meassure the length of the line
	 * needs to be remove and reinstaded because otherwise bold formatting would stick once a b-tag is found!
	 * (Silly Flash bug)
	 * 
	 * @see	_measureTF
	 */
	private function resetMeassureTextField():Void
	{
		_measureTF.removeTextField();
		_root.createTextField("___rtlTestField", _measureTFDepth,0,0,2000,100);
		_measureTF = _root.___rtlTestField;
		_measureTF.html = true;
		_measureTF.multiline = false;
		_measureTF.condenseWhite = true;
		_measureTF.selectable = false;
		_measureTF.embedFonts = _embedFonts;
		_measureTF.antiAliasType=_antiAliasType;
		_measureTF.thickness=_thickness;
		_measureTF.sharpness=_sharpness;
		_measureTF.gridFitType=_gridFitType;
	}
	
	/**
	 * Filter the Strings in ignore:Array out of the input String
	 * and replaces numeric entities and &quot; and &nbsp; with real characters
	 * 
	 * @param	input		Text to be filtered
	 * @return	Filtered text. Strings in ignore:Array-free
	 */
	private function filter(input:String):String
	{
		var ignoreIndex:Number;
		var ignoreLength:Number;
		for (var i : Number = ignore.length-1; i >= 0; i--)
		{
			ignoreIndex = input.indexOf( ignore[i] );
			while (ignoreIndex>=0)
			{
				ignoreLength = ignore[i].length;
				input = input.substr( 0, ignoreIndex )+input.substr( ignoreIndex+ignoreLength );
				ignoreIndex = input.indexOf( ignore[i] );
			}
		}
		
		/*
		 * Replace unwanted entities with real characters if enabled
		 */
		if (enableEntityReplacement)
		{
			var entityStartIndex:Number=input.indexOf("&");			var entityEndIndex:Number;
			var entity:String;
			var entityReplacement:String;
			while (entityStartIndex>=0)
			{
				entityEndIndex=input.indexOf(";", entityStartIndex);
				entityReplacement=null;
				/*
				 * if there's only a & without ; it's probably no entity
				 * Same thing if the distance between & and ; is more than 8
				 */
				if (entityEndIndex>=0 && entityEndIndex-entityStartIndex<=8)
				{
					entity=input.substring(entityStartIndex+1, entityEndIndex);
					if (entity=="nbsp") entityReplacement=" ";
					else if (entity=="quot") entityReplacement="\"";
					// it's a numeric entitiy
					else if (entity.charAt(0)=="#")
					{
						// if it's a hex-entity append the "0" before the "x" (getting rid of the "#") so that the string is properly parsed as hex-number
						if (entity.charAt(1)=="x") entity="0"+entity.substr(1);
						// otherwise only get rid of the "#"
						else entity=entity.substr(1);
						
						if (!isNaN(entity)) entityReplacement=String.fromCharCode(parseInt(entity));
					}
				}
				
				if (entityReplacement!=null) input = input.substr( 0, entityStartIndex )+entityReplacement+input.substr( entityEndIndex+1 );
				
				entityStartIndex=input.indexOf("&", entityStartIndex+1);
			}
		}
		return input;
	}
	
	/*
	 * Getters/Setters
	 */
	public function get measureTFDepth():Number { return _measureTFDepth; }
	public function set measureTFDepth(value:Number):Void { _measureTFDepth=value; }
	
	public function get sourceText():String { return _sourceText; }
	public function set sourceText(value:String):Void { _sourceText=value; }
	
	public function get styleSheet():ExtendedStyleSheet { return _styleSheet; }
	public function set styleSheet(value:ExtendedStyleSheet):Void { _styleSheet=value; }
	
	public function get styleClass():String { return _styleClass; }
	public function set styleClass(value:String):Void { _styleClass=value; }
	
	public function get textFieldWidth():Number { return _textFieldWidth; }
	public function set textFieldWidth(value:Number):Void { _textFieldWidth=value; }
	
	public function get convertedText():String { return _convertedText; }
	public function set convertedText(value:String):Void { _convertedText=value; }
	
	public function get textWidth():Number { return _textWidth; }
	public function set textWidth(value:Number):Void { _textWidth=value; }
	
}