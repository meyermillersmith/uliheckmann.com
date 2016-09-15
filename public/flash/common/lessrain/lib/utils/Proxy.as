/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
class lessrain.lib.utils.Proxy
{
	public static function create (scope:Object, method:Function) : Function
	{
		var p:Array = arguments.splice (2, arguments.length-2);
		var f:Function = function () : Void {method.apply(scope, arguments.concat (p));};
		return f;
	}
}