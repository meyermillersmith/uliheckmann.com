/**
 * lessrain.lib.utils.DateFormat, Version 1.3
 * 
 * 
 * DateFormat extends the Date object and has 2 methods to return a formatted String of the date represented by the Date object
 * 
 * <b>History</b>
 * 1.3:
 * Added constructor to allow creation of any date, not only dates that represent
 * the current time. 
 * 
 * <b>Usage:</b>
 * 
 * <code>
 * import lessrain.lib.utils.DateFormat;
 * 
 * var df = new DateFormat();
 * trace( df.getDateString( "en", DateFormat.SHORT) );
 * trace( df.getDateString( "en", DateFormat.MEDIUM) );
 * trace( df.getDateString( "en", DateFormat.LONG) );
 * trace( df.getDateString( "en", DateFormat.FULL) );
 * 
 * trace( df.getTimeString( "en", DateFormat.SHORT) );
 * trace( df.getTimeString( "en", DateFormat.MEDIUM) );
 * trace( df.getTimeString( "en", DateFormat.LONG) );
 * trace( df.getTimeString( "en", DateFormat.FULL) );
 * </code>
 * 
 * <b>Prints:</b>
 * 11/01/2006
 * Jan 11, 2006
 * January 11, 2006
 * Wednesday, January 11, 2006
 * 11:13
 * 11:13
 * 11:13:11
 * 11:13:11.887
 * 
 * @author  Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @author	Oliver List, Less Rain (o.list@lessrain.com)
 * @version 1.3
 * @see: Date
 * @see: lessrain.lib.utils.NumberUtils
 */

import lessrain.lib.utils.NumberUtils;

class lessrain.lib.utils.DateFormat extends Date
{
	public static var SHORT:Number=1;
	public static var MEDIUM:Number=2;
	public static var LONG:Number=3;
	public static var FULL:Number=4;
	
	/**
	 * Constructor
	 * @see Date
	 */
	public function DateFormat(yearOrTimevalue:Number,month:Number,date:Number,hour:Number,minute:Number,second:Number,millisecond:Number)
	{
		super(yearOrTimevalue, month, date, hour, minute, second, millisecond);
	}

	/**
	 * Returns the date represented by the Date object as a String
	 * 
	 * @param	localeISO		Locale to format the date by. Valid values are "en", "de", "us_en", ...
	 * @param	style				Level of detail of the return String, see constants SHORT, MEDIUM, LONG, FULL
	 * @param	fillZeros			Determines whether to fill values lower than 9 with a leading "0"
	 * @return	The formatted date String
	 */
	public function getDateString(localeISO:String, style:Number, fillZeros:Boolean):String
	{
		var day:Number=getDate();
		var month:Number=getMonth()+1;
		var year:Number=getYear()+1900;
		
		var minLength:Number = 1;
		if (fillZeros==null || fillZeros) minLength=2;
		
		switch (localeISO)
		{
			case "de":
			case "de_de":
			case "at_de":
			
				if (style==SHORT)
				{
					return NumberUtils.addZero(day, minLength)+"."+NumberUtils.addZero(month, minLength)+"."+year;
				}
				else if (style==MEDIUM)
				{
					var monthNames:Array = new Array("Jan", "Feb", "Mrz", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez");
					return  NumberUtils.addZero(day, minLength)+". "+monthNames[month-1]+" "+year;
				}
				else if (style==LONG)
				{
					var monthNames:Array = new Array("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember");
					return NumberUtils.addZero(day, minLength)+". "+monthNames[month-1]+" "+year;
				}
				else if (style==FULL)
				{
					var dayNames:Array = new Array("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag");
					var monthNames:Array = new Array("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember");
					return dayNames[getDay()]+", "+NumberUtils.addZero(day, minLength)+". "+monthNames[month-1]+" "+year;
				}
				
				break;
			
			case "us":
			case "us_en":
			
				if (style==SHORT)
				{
					return NumberUtils.addZero(month, minLength)+"/"+NumberUtils.addZero(day, minLength)+"/"+year;
				}
				else if (style==MEDIUM)
				{
					var monthNames:Array = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
					return monthNames[month-1]+" "+NumberUtils.addZero(day, minLength)+", "+year;
				}
				else if (style==LONG)
				{
					var monthNames:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
					return monthNames[month-1]+" "+NumberUtils.addZero(day, minLength)+", "+year;
				}
				else if (style==FULL)
				{
					var dayNames:Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
					var monthNames:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
					return dayNames[getDay()]+", "+monthNames[month-1]+" "+NumberUtils.addZero(day, minLength)+", "+year;
				}
				
				break;
				
			case "en":
			case "uk_en":
			default:
			
				if (style==SHORT)
				{
					return NumberUtils.addZero(day, minLength)+"/"+NumberUtils.addZero(month, minLength)+"/"+year;
				}
				else if (style==MEDIUM)
				{
					var monthNames:Array = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
					return monthNames[month-1]+" "+NumberUtils.addZero(day, minLength)+", "+year;
				}
				else if (style==LONG)
				{
					var monthNames:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
					return monthNames[month-1]+" "+NumberUtils.addZero(day, minLength)+", "+year;
				}
				else if (style==FULL)
				{
					var dayNames:Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
					var monthNames:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
					return dayNames[getDay()]+", "+monthNames[month-1]+" "+NumberUtils.addZero(day, minLength)+", "+year;
				}
				
				break;
				
		}
	}

	/**
	 * Returns the time represented by the Date object as a String
	 * 
	 * @param	localeISO		Locale to format the time by. Currently this is irrelevant, as all locales look the same.
	 * @param	style				Level of detail of the return String, see constants SHORT, MEDIUM, LONG, FULL
	 * @param	fillZeros			Determines whether to fill values lower than 9 with a leading "0"
	 * @return	The formatted time String
	 */
	public function getTimeString(localeISO:String, style:Number, fillZeros:Boolean):String
	{
		var hour:Number=getHours();
		var minute:Number=getMinutes();
		var second:Number=getSeconds();
		var millis:Number=getMilliseconds();
		
		var minLength:Number = 1;
		if (fillZeros==null || fillZeros) minLength=2;

		switch (localeISO)
		{
			case "":
			default:
				if (style==SHORT)
				{
					return NumberUtils.addZero(hour, 2)+":"+NumberUtils.addZero(minute, 2);
				}
				else if (style==MEDIUM)
				{
					return NumberUtils.addZero(hour, 2)+":"+NumberUtils.addZero(minute, 2);
				}
				else if (style==LONG)
				{
					return NumberUtils.addZero(hour, 2)+":"+NumberUtils.addZero(minute, 2)+":"+NumberUtils.addZero(second, 2);
				}
				else if (style==FULL)
				{
					return NumberUtils.addZero(hour, 2)+":"+NumberUtils.addZero(minute, 2)+":"+NumberUtils.addZero(second, 2)+"."+millis;
				}
				
				break;
		}
	}

}
