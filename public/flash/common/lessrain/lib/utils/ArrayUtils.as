/**
 * ArrayUtils, version 1
 * @class:   lessrain.lib.utils.ArrayUtils
 * @author:  lessrain.com
 * @version: 1.5
 * -----------------------------------------------------
 *   Functions:
 *            1.  findKeyValue (Array,String,value)
 *            2.  findKeyPosition (Array,String,value)
 *            3.  max (Array)
 *            4.  min (Array)
 *            5.  shuffle (Array)
 *            6.  copyOfArray (Array) [DEPRECATED], use clone instead
 *            7.  findAndRemove (Array,value)
 *            8.  findSimple (Array,value)
 *            9.  indexOf (aArray:Array, value):Number
 *            10. contains (aArray:Array, value):Boolean
 *            11. deleteAt (Array,value)
 *            12. Ruby-like iterators
 *                12.1. each (Array,Function) 
 *                   Call the callback for each value (not the index) in the array or object. 
 *                12.2. filter (Array,Function)
 *                   Return an array containing those items for which the callback returns true. 
 *                12.3. collect (Array,Function)
 *                   Return a copy of the array, replacing each item with the return value of the 
 *                   callback when passed that item.
 *                12.4. find (Array,Function)
 *                   Return the first item for which the callback returns true.
 *                12.5. inject (Array,Function)
 *                   "Inject" all the items in the array or object into a single variable. 
 *                   The call back is passed it's previous return value (or the first item when
 *		             called the first time), and the current item, and combines them into a new return value.
 *  ----------------------------------------------------
 */
 
class lessrain.lib.utils.ArrayUtils
{
	
	// 1. findKeyValue --------------------------------
	
	public static function findKeyValue (aArray:Array, key:String, value:Object):Object
	{
		var i:Number = aArray.length;
		while (--i > -1) {
			if (aArray[i][key] == value) {
				return aArray[i];
			}
		}
	}
	
	// 2. findKeyPosition  --------------------------------
	
	public static function findKeyPosition (aArray:Array, key:String, value:Object):Number
	{
		var i:Number = aArray.length;
		while (--i > -1) {
			if (aArray[i][key] == value) {
				return i;
			}
		}
	}
	
	// 3. max  --------------------------------
	
	public static function max (aArray:Array):Number
	{
		var aCopy:Array = aArray.concat ();
		aCopy.sort (Array.NUMERIC);
		var nMaximum:Number = Number (aCopy.pop ());
		delete aCopy;
		return nMaximum;
	}
	
	// 4. min  --------------------------------
	
	public static function min (aArray:Array):Number
	{
		var aCopy:Array = aArray.concat ();
		aCopy.sort (Array.NUMERIC);
		var nMinimum:Number = Number (aCopy.shift ());
		delete aCopy;
		return nMinimum;
	}
	
	// 5. shuffle  --------------------------------
	
	public static function shuffle (aArray:Array):Array
	{
		var len:Number = aArray.length;
		
		while (--len > -1) {
			var rand:Number = Math.floor (Math.random () * len);
			var temp:Number = aArray[len];
			aArray[len] = aArray[rand];
			aArray[rand] = temp;
		}
		return aArray;
	}
	
	// 6. copyOfArray [DEPRECATED], use clone instead --------------------------------
	
	public static function copyOfArray (aArray:Array):Array
	{
        return clone(aArray);
	}
	
	public static function clone(aArray:Array):Array {
		return aArray.concat();
	}
	
	// 7. findAndRemove  --------------------------------
	
	public static function findAndRemove (aArray:Array, removeVal:Object):Array
	{
		var arr:Array = aArray.toString ().split (removeVal + ",").join ("").split (",");
		if(arr[arr.length - 1] == removeVal ){
			 arr.pop ();
		}
		return arr;
	}
	
	// 8. findSimple --------------------------------
	// Luichi is using this method for da BBC
	// Plz don't delete it! Thanks!
	
	public static function findSimple (aArray:Array, value, rIndex:Boolean)
	{
		var i:Number = aArray.length;
		
		while (--i > -1) {
			if (aArray[i] == value)
			if(rIndex){
				
			   return i;
			 
			}else{
				
			   return true;
			
			}
        }
		
		return false;
	}
	
	// 9. indexOf --------------------------------
	
	public static function indexOf (aArray:Array, value):Number
	{
		var i:Number = aArray.length;
		
		while (--i > -1) {
			if (aArray[i] === value) return i;
        }
		
		return -1;
	}
	
	// 10. contains --------------------------------
	
	public static function contains (aArray:Array, value):Boolean
	{
		var i = aArray.length;
		
		while (--i > -1) {
			if (aArray[i] === value) return true;
        }
		
		return false;
	}
	
	// 11. deleteAt --------------------------------
	
	public static function deleteAt (aArray:Array, index:Number)
    {
		if (index == 0) {
			return aArray.shift ();
		} else if (index == ( aArray.length - 1)) {
			return aArray.pop ();
		} else if (index > 0 && index < ( aArray.length - 1)) {
			return aArray.splice (index, 1);
		}
	};
	
	// 12. Ruby-like iterators  --------------------------------
	
	public static function each (aArray:Array, block:Function):Array
	{
		var l:Number = aArray.length;
		for (var i:Number = 0; i < l; i++) block (aArray[i]);
		return aArray;
	}
	
	public static function filter (aArray:Array, block:Function):Array
	{
		var l:Number = aArray.length;
		var result = [];
		for (var i:Number = 0; i < l; i++) {
			if (block (aArray[i])) result.push (aArray[i]);
		}
		return result;
	}
	
	public static function collect (aArray:Array, block:Function):Array
	{
		var l:Number = aArray.length;
		var result:Array = [];
		for (var i:Number = 0; i < l; i++) result.push (block (aArray[i]));
		return result;
	}
	
	public static function find (aArray:Array, block:Function)
	{
		var l:Number = aArray.length;
		for (var i:Number = 0; i < l; i++) {
			if (block (aArray[i])) return aArray[i];
		}
	}
	
	public static function inject (aArray:Array, block:Function)
	{
		var l:Number = aArray.length;
		var a:Array = aArray[0];
		for (var i:Number = 1; i < l; i++) a = block (a, aArray[i]);
		return a;
	}
	
	/**
	 * Removes needle from haystack
	 */
	public static function removeElement( haystack:Array, needle:Object  ):Boolean
	{
		for (var i:Number=haystack.length-1; i>=0; i--)
		{
			if (haystack[i]==needle)
			{
				haystack.splice( i,1 );
				return true;
			}
		}
		return false;
	}
	
}
