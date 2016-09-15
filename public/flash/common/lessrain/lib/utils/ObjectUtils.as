/**
 * ObjectUtils, version 1
 * @class:   lessrain.lib.utils.ObjectUtils
 * @author:  luis@lessrain.com
 * @version: 1.1
 * -----------------------------------------------------
 *   Functions:
 *            1.  traceObject (Object,Number,Number)
 *            2.  clone (Object)
 *
 *  ----------------------------------------------------
 */

class lessrain.lib.utils.ObjectUtils
{
	// 1. traceObject --------------------------------
	
	public static function traceObject (o:Object, recurseDepth:Number, indent:Number):Void
	{
		recurseDepth = recurseDepth || 0;
		indent = indent || 0;
		
		for (var prop:String in o) {
			
			var lead:String = "";
			var i:Number = indent;
			
			while (--i > -1) {
				lead += "   ";
			}
			
			trace (lead + prop + ": " + o[prop]);
			
			if (recurseDepth > 0) {
				traceObject (o[prop], recurseDepth - 1, indent + 1);
			}
			
		}
	}
	
	// 2. clone --------------------------------
	
	public static function clone(o:Object):Object
	{
		if(o instanceof Object){
			
			var newObject:Object = new Object();
			
			for(var i:String in o){
				
				if(o[i] instanceof Object){
					newObject[i] = new Object();
					newObject[i] = clone(o[i]);
				}else{
					newObject[i] = o[i];
				}
				
			}
			return newObject;
			
		}else{
			return o;
		}
	
	}
	
}
