/**
 * StringUtils
 * @class:   lessrain.lib.string.StringFunctions
 * @author:  lessrain
 * @version: 1.5
 * -----------------------------------------------------
 *   Functions:
 *            1.  normalizePath  (input:String)
 *            2.  checkExternalParameter (input:String, defaultValue:String)
 *            3.  rtrim (input:String)
 *            4.  ltrim (input:String)
 *            5.  trim (input:String)
 *            6.  abbreviate (input:String, len:Number, snap:Boolean)
 *            7.  isEmail (input:String)
 *            8.  replace (input:String, before:String, after:String)
 *            9.  objectToString (object)
 *            10.  convertToHex (input:String)
 *            11.  getHashCode (object)
 *            12.  ucWords (input:String)
 *            13.  padString (val:String, strLength:Number, padChar:String, padDirection:Number)
 *  ----------------------------------------------------
 */

import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.logger.LogManager;

class lessrain.lib.utils.StringUtils
{
	
	public static var LEFT:Number = 1 << 1;
	public static var RIGHT:Number = 1 << 2;
	
	/** 1. normalizePath --------------------------------
	
		returns string that's been stripped of all slashes at the end of the string
		leading slashes are left unchanged
		
	*/

	public static function normalizePath (input:String):String
	{
		if (input == "") return input;
		while (input.lastIndexOf ("/") == input.length-1) input = input.substr (0, input.length-1);
		return input;
	}
	
	// 2. checkExternalParameter --------------------------------
	
	public static function checkExternalParameter (input:String, defaultValue:String):String
	{
		if (input == null || input == "") {
			
			return defaultValue;
			
		} else {
			
			return input;
		}
	}
	
	// 3. rtrim --------------------------------
	
	static var trimCharacters:Array = new Array( " ", "\t", "\n", "\r" );

	public static function rtrim (input:String):String
	{
		
		var i:Number = input.length-1;
		while( ArrayUtils.contains(trimCharacters, input.substr( i--, 1 )) ) {trace("gor");}
        return input.substr( 0, i+2 );
	}
	
	// 4. ltrim --------------------------------

	public static function ltrim (input:String):String
	{
		var i:Number = 0;
		while( ArrayUtils.contains(trimCharacters, input.substr( i++, 1 )) ) {trace("gol");}
        return input.substr( i-1 );
	}
	
	// 5. trim --------------------------------

	public static function trim (input:String):String
	{
		return rtrim(ltrim(input));
	}



	/** 6. abbreviate --------------------------------
	 *  USAGE: 
	 *      import lessrain.lib.utils.StringUtils;
     *      var myString:String = 'I do not like Andrew Cross pictures, they are really boring';
	 *		trace (StringUtils.abbreviate (myString, 42));// I do not like Andrew Cross pictures, th...
	 * 		trace (StringUtils.abbreviate (myString, 42, true));// I do not like Andrew Cross pictures,...
	 *		trace (StringUtils.abbreviate (myString, 27));// I do not like Andrew Cro...
	 *		trace (StringUtils.abbreviate (myString, 27, true));// I do not like Andrew...
	 *		trace (StringUtils.abbreviate (myString, 10));// I do no...
	 *      trace (StringUtils.abbreviate (myString, 3, true));// undefined
	 */
	public static function abbreviate (input:String, len:Number, snap:Boolean):String
	{
		if (!len || input.length<=len) return input;
		var st:String =(snap)? input.substr (0, input.lastIndexOf (" ", len-3)): StringUtils.rtrim (input.substr (0, len-3));
	    if (st.length>len) return "";
        if (st.charAt (st.length-1) == ".") return st;
        return st+"...";
	}
	
	// 7. isEmail --------------------------------
	public static function isEmail(input:String):Boolean
	{

		if (input.length < 5)return false;
		var iChars:String = "*|,\":<>[]{}`';()&$#%";
		var eLength:Number = input.length;
		for (var i:Number=0; i < eLength; i++){
			if (iChars.indexOf(input.charAt(i)) != -1)return false;
			if ((input.charAt(i) == "." || input.charAt(i) == "@") && input.charAt(i) == input.charAt(i-1)) return false;
		} 
		
		var atIndex:Number = input.lastIndexOf("@");
		if(atIndex < 1 || (atIndex == eLength - 1)) return false;
		var pIndex:Number = input.lastIndexOf(".");
		if(pIndex < 3 || (pIndex == eLength - 1)) return false;
		if(atIndex > pIndex)return false;
		
		return true;
		
	}
	// 8. replace --------------------------------
	public static function replace (input:String, before:String, after:String):String
	{
		return input.split(before).join(after);
	}
	
	// 9. objectToString --------------------------------
	public static function objectToString (object:Object):String
	{
		var objectString:String = "";
		var hasFields:Boolean = false;
		for (var field:String in object) {
			hasFields = true;
			objectString += field;
			objectString += objectToString (object[field]);
		}
		if (!(hasFields)) objectString += object.toString();
		return objectString;
	}
	
	// 10. convertToHex --------------------------------
	public static function convertToHex (input:String):String
	{
		var stringLength:Number = input.length;
		var asciiCodes:Number = 0;
		for (var i:Number = 0; i < stringLength; i++) {
			asciiCodes += input.charCodeAt (i);
		}
		return asciiCodes.toString (16);
	}
	
	// 11. getHashCode --------------------------------
	public static function getHashCode (object:Object):String
	{
		return convertToHex(objectToString (object));
	}
	
	// 12 .Removes unwanted leading and trailing characters
	public static function stripChars (c:String):Number
	{
		var bad:Array = [" ","\t","\r","\n"];
		for(var x:Number=0;x<=bad.length-1;x++){ if(bad[x] == c){return 1;}}
		return 0;
	}
	public static function stripWS (input:String):String
	{
		while( stripChars(input.substr(0,1))){input = input.substr(1);};
		while(stripChars(input.substr(-1))){input = input.substr(0,-1);};
		return input;
	}

	/**
	 * Checks if String haystack contains String needle as a substring
	 * @param 	haystack	Is checked if it contains needle
	 * @param	needle		Might be a substring of haystack
	 * @return	True if needle is a substring of haystack
	 */
	 public static function contains(haystack:String, needle:String):Boolean
	 {
	 	return (haystack.indexOf(needle)>=0);
	 }
	
	/**
	 * Checks if String haystack starts with the substring needle
	 * @param 	haystack		Is checked if it starts with needle
	 * @param	needle			Might be the start of haystack
	 * @return	True if needle is a substring of haystack at position 0
	 */
	 public static function startsWith(haystack:String, needle:String):Boolean
	 {
	 	return (haystack.substr(0,needle.length)==needle);
	 }
	
	/**
	 * Checks if String haystack ends with the substring needle
	 * @param 	haystack		Is checked if it ends with needle
	 * @param	needle			Might be the end of haystack
	 * @return	True if needle is a substring of haystack at the end
	 */
	 public static function endsWith(haystack:String, needle:String):Boolean
	 {
	 	return (haystack.substr(haystack.length-needle.length,needle.length)==needle);
	 }
	 
	 public static function ucWords (input:String):String
	 {
		var tempString:String ='';
		var tempArray:Array = input.split (' ');
		for (var a:Number = 0; a<tempArray.length; a++) {
			tempString += tempArray[a].substring (0, 1).toUpperCase ()+tempArray[a].substring (1, tempArray[a].length);
			if(a<tempArray.length-1){
				tempString +=' ';
			}
		}
		return tempString;
	 }
	 
	/**
	 * Resize a given string to a greater length and fill it up with a custom
	 * character.
	 *
	 * @usage   StringUtils.padString("4", 3, "0", StringUtils.LEFT); // "004"
	 * @param   val           The value that will be modified
	 * @param   strLength     The length of the new string
	 * @param   padChar       The string will be padded with this character
	 * @paraam  padDirection  Where will the characters be added?
	 * @return
	 */
	public static function padString(val:String, strLength:Number, padChar:String, padDirection:Number):String {
		if(padDirection == null) {
			padDirection = LEFT;
		}
		// If the input value is already as long as the result should be, return
		// the unchanged input value.
		// Also do nothing if padChar is not a single character.
		if(val.length >= strLength || padChar.length != 1) {
			return val;
		}
		var fill:String = "";
		for(var i:Number = 0; i < strLength - val.length; i++) {
			fill += padChar;
		}
		var out:String = padDirection == LEFT ? (fill + val) : (val + fill);
		return out;
	}

}
