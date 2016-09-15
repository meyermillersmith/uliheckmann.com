/**
 * @author Eugene Potapenko (www.potapenko.com)
 *  date created: 01.03.2005 8:27:35
 */
class com.blitzagency.xray.util.Flashout_save extends Object
{
	private var object:Object;
	
	private static var task:Object = new Object();
	
	//-------------------------------------------------------------------------
	//	constructor
	//-------------------------------------------------------------------------
	
	public function Flashout_save(object:Object)
	{
		this.object = object;
	}
	
	//-------------------------------------------------------------------------
	//	log
	//-------------------------------------------------------------------------
	
	public static function log(text:Object):Void
	{
		var interval:Number;
		
		trace("LOG: " + text);
		asyncLog("default_log", text);
	}
		//-------------------------------------------------------------------------
	//	info
	//-------------------------------------------------------------------------
	
	public static function info(text:Object):Void
	{
		trace("INFO: " + text);
		asyncLog("info_log", text);
	}	
	//-------------------------------------------------------------------------
	//	warning
	//-------------------------------------------------------------------------
	
	public static function warning(text:Object):Void
	{
		trace("WARNING: " + text);
		asyncLog("warning_log", text);
	}
		//-------------------------------------------------------------------------
	//	debug
	//-------------------------------------------------------------------------
	
	public static function debug(text:Object):Void
	{
		trace("DEBUG: " + text);
		asyncLog("debug_log", text);
	}	
	//-------------------------------------------------------------------------
	//	error
	//-------------------------------------------------------------------------
	
	public static function error(text:Object):Void
	{
		trace("ERROR: " + text);
		asyncLog("error_log", text);
	}	
	//-------------------------------------------------------------------------
	//	serverIn
	//-------------------------------------------------------------------------
	
	public static function serverIn(text:Object):Void
	{
		trace("INCOMING: " + text);
		asyncLog("server_in_log", text);
	}
	
	//-------------------------------------------------------------------------
	//	serverOut
	//-------------------------------------------------------------------------
	
	public static function serverOut(text:Object):Void
	{
		trace("SEND: " + text);
		asyncLog("server_out_log", text);
	}
	
	/*
	
	class MyClass extends Object
	{
	private var name:String;
	private var data:String;
	
	
	private var versionId:Number = 123;
	private var debug:Boolean = false;
	
	//-------------------------------------------------------------------------
	//	constructor
	//-------------------------------------------------------------------------
	
	public function MyClass(name:String, data:String)
	{
		this.name = name;
		this.data = data;
	}

	//-------------------------------------------------------------------------
	//	toString
	//-------------------------------------------------------------------------
	
	public function toString()
	{
		return (new Flashout(this)).generateToString("MyClass", ["versionId", "debug"]);
	}
	
	}
	// .............................................................................
	
	var test:MyClass = new MyClass("anyName", "Hello!");
	
	Flashout.log(test);
	
	// in out
	// MyClass{name="anyName", data="Hello!"};
	
	*/
	
	//-------------------------------------------------------------------------
	//	generateToString
	//-------------------------------------------------------------------------
	
	public function generateToString(className:String, ignoreFields:Array):String
	{
		if(className == undefined) className = "ClassName";
	
		if(!ignoreFields)ignoreFields = new Array();
		
		var p:Object = this.object.__proto__;
		this.object.__proto__ = undefined;
		
		var result:Array = new Array();
		result.push(className + "{");
		for(var v:String in this.object)
		{
			if(indexOf(ignoreFields, v) == -1)
			{
				var quote:String = "";
				var param:Object = this.object[v];
				
				if(typeof(param) == "string") quote = "\"";
				
				result.push(v + "=" + quote + param + quote);
				result.push(", "); 
			}
		}
		
		if(result.length != 1)
		{
			result.pop();
			result.push("");
		}
		
		result.push("};");
		
		this.object.__proto__ = p;
		
		return result.join("");
	}
	
	//-------------------------------------------------------------------------
	//	indexOf
	//-------------------------------------------------------------------------
	
	private static function indexOf(array:Array, searched:Object):Number
	{
		if(array == undefined)return -1;
		
		for(var i:Number=0;i<array.length;i++)
		{
			if(searched == array[i])
			{
				return i;
			}
		}	
		return -1;
	}
	
	//-------------------------------------------------------------------------
	//	asyncLog
	//-------------------------------------------------------------------------
	
	private static function asyncLog(command:String, text:Object):Void
	{
		if(!task.haveTask)
		{
			task.queue = new Array();
			task.haveTask = true;
			
			var taskObj:Object = task;
			var interval:Number;
			
			interval = setInterval(function()
			{
				clearInterval(interval);
				taskObj.haveTask = false;
				
				var item:Object;
				var len:Number = taskObj.queue.length;
				
				for (var i : Number = 0; i < len; i++) 
				{
					item = taskObj.queue[i];
					fscommand(item.command, item.text);
				}
				
				taskObj.queue = new Array();
				
			}, 0);
		}
		
		var message:Object = new Object();
		message.command = command;
		message.text = text;
		
		task.queue.push(message);
	}
}