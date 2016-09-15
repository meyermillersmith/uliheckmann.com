import lessrain.lib.components.mediaplayer07.core.Bandwidth;
/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.DataFile 
{
	/*
	 * Types
	 */
	public static var TYPE_IMAGE		: String = "image";
	public static var TYPE_FLASH		: String = "flash";
	public static var TYPE_VIDEO		: String = "video";
	public static var TYPE_AUDIO		: String = "audio";
	public static var TYPE_ARCHIVE		: String = "archive";
	public static var TYPE_CHUNKED_VIDEO: String = "chunkedvideo";
	
	/*
	 * Roles
	 */
	public static var ROLE_THUMBNAIL	: String = "thumbnail";
	public static var ROLE_PREVIEW		: String = "preview";
	public static var ROLE_MASTER		: String = "master";
	public static var ROLE_DOWNLOAD		: String = "download";
	
	/*
	 * Getter & setter
	 */
	private var _type			: String;
	private var _role			: String;
	private var _application	: String;
	private var _bandwidth		: Bandwidth;
	private var _src			: String;
	private var _w				: Number;
	private var _h				: Number;
	private var _size			: Number;
	private var _duration		: Number;
	private var _timeOffset		: Number;
	private var _time			: Number;

	
	public function DataFile()
	{
		_type = null;
		_role = null;
		_bandwidth = Bandwidth.HIGH;
		_src  = null;
		
		_w = 0;
		_h = 0;
		
		_duration = null;
		_time = -1.0;
		
	}
	
	/**
	 * Clone
	 */
	public function clone() :DataFile
	{
	 	var clone:DataFile = new DataFile();
	 	
	 	clone.type			= _type;
		clone.role			= _role;
		clone.application	= _application;
		clone.bandwidth		= _bandwidth;
		clone.src			= _src;
		clone.w				= _w;
		clone.h				= _h;
		clone.size			= _size;
		clone.duration		= _duration;
		clone.timeOffset	= _timeOffset;		clone.time			= _time;
		
	 	return clone;
	}
	
	public function toString():String {
		return "DataFile role: " + _role + " type: " + _type + " src: " + _src + " bandwidth: " + _bandwidth;
	}
	
	/*
	 * Getter & setter
	 */
	public function get duration():Number { return _duration; }
	public function set duration(value:Number):Void { _duration=value; }
	
	public function get size():Number { return _size; }
	public function set size(value:Number):Void { _size=value; }
	
	public function get h():Number { return _h; }
	public function set h(value:Number):Void { _h=value; }
	
	public function get w():Number { return _w; }
	public function set w(value:Number):Void { _w=value; }
	
	public function get src():String { return _src; }
	public function set src(value:String):Void { _src=value; }
	
	public function get role():String { return _role; }	
	public function set role(value:String):Void { _role=value; }
	
	public function get type():String { return _type; }
	public function set type(value:String):Void { _type=value; }
	
	public function get application():String { return _application; }
	public function set application(value:String):Void { _application=value; }
	
	public function get bandwidth():Bandwidth { return _bandwidth; }
	public function set bandwidth(bandwidth_:Bandwidth):Void { _bandwidth = bandwidth_; }
	
	public function get timeOffset():Number { return _timeOffset; }
	public function set timeOffset(value:Number):Void { _timeOffset=value; }
	
	public function get time():Number { return _time; }
	public function set time(value:Number):Void { _time=value; }
	
}