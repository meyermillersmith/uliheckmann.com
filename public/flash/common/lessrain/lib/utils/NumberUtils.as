/**
 * NumberUtils, version 1
 * @class:   lessrain.lib.utils.NumberUtils
 * @author:  luis@lessrain.com
 * @version: 1.4
 * ----------------------------------------------------------
 *   Functions:
 *            1.  addZero (Number,Number)     returns String
 *            2.  randRange (Number,Number)   returns Number
 *            3.  extractFraction (Number,Number)   returns Number
 *            4.  toString (Number,Number)   returns String
 *            5.  toCurrencyString (Number,String)  returns String
 * 			  6.  isOdd (Number)   returns Boolean *  ---------------------------------------------------------
 */

class lessrain.lib.utils.NumberUtils
{
     // 1. addZero ---------------------------------------

	public static function addZero (n:Number, total:Number):String
	{
		var conv:String = n.toString ();
		var l:Number = conv.length - 1;
		while (--total > l) {
			conv = '0' + conv;
		}
		return conv;
	}
	
	 // 2. randRange ---------------------------------------
	 
	public static function randRange (min:Number, max:Number):Number
	{ 
		var randomNum:Number = Math.floor(Math.random()*(max-min+1))+min; 
		return randomNum;
	}
	
	/**
	 * 3. extractFraction ---------------------------------------
	 * 
	 * reurns the after-comma-part of a floating point number, eg. extractFraction( 564.1524 ) = 0.1524
	 * @return Number	 */

	public static function extractFraction (n:Number):Number
	{
		return (n-Math.floor(n));
	}

	/** 4. toString --------------------------------
	 *  Formats the number to a string of the given length (lengthening or shortening)
	 *
	 *  USAGE: 
	 *      import lessrain.lib.utils.NumberUtils;
	 *		trace (NumberUtils.toString(0, 10)); // 0.00000000
	 *		trace (NumberUtils.toString(0.1, 10)); // 0.10000000
	 *		trace (NumberUtils.toString(12.1, 10)); // 12.1000000
	 *		trace (NumberUtils.toString(1.131313131313131313, 10)); // 1.13131313
 * 
 */ 
	static function toString(input:Number, len:Number):String
	{
		input = Math.round(input*Math.pow(10,len))/Math.pow(10,len);
		var str:String = String(input);
		
		if (len==null || len==0 || str.length == len) return str;
		else if (str.length < len)
		{
			if (str.indexOf(".")<0) str+=".";
			for (var i:Number=(len-str.length-1); i>=0; i-- ) str+="0";
			return str;
		}
		else
		{
			return str.substr(0,len);
		}
	}
	
	/**
	 * 5. toCurrencyString ---------------------------------------
	 * 
	 * Convert and round off a number to some sort of currency format 
	 * @return String
	 */
	
	static function toCurrencyString( amount:Number, currency:String):String
	{
		var append:Boolean=false;
		if (currency.length>1)append=true;
		if (amount == 0)
		{
			if(append) return ('0.00'+' '+currency);
			else return (currency+'0.00');
		}

		var tempAmount:String = String (Math.round (amount * Math.pow (10, 2)));
		var l:Number = tempAmount.length;
		var result:String=tempAmount.slice (0, l - 2) + "." + tempAmount.slice (l - 2, l);
		if(append) return (result+' '+currency);
		else return (currency + result);
	}

/**
	 * 6. isOdd ---------------------------------------
	 * 
	 * returns true if the number is an odd number
	 *  
	 * @return Boolean
	 */
	
	public static function isOdd( input:Number) : Boolean
	{
		var division:Number = input / 2;
		return division > Math.floor(division);
	}
}
