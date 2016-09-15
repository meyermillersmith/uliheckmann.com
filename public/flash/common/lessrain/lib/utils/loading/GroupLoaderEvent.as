import lessrain.lib.utils.events.IEvent;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.loading.GroupLoaderEvent implements IEvent
{
	public static var GROUP_START:String = "groupStart";
	public static var GROUP_COMPLETE:String = "groupComplete";
	public static var GROUP_PROGRESS:String = "groupProgress";
	
	private var _type : String;

	private var _filesLoaded : Number;
	private var _filesTotal : Number;
	private var _bytesLoaded : Number;
	private var _bytesTotal : Number;
	private var _percent : Number;
	private var _description : String;
	
	public function GroupLoaderEvent(type_:String, filesLoaded_:Number, filesTotal_:Number, bytesLoaded_:Number, bytesTotal_:Number, percent_:Number, description_:String)
	{
		_type = type_;
		_filesLoaded = filesLoaded_;		_filesTotal = filesTotal_;		_bytesLoaded = bytesLoaded_;		_bytesTotal = bytesTotal_;		_percent = percent_;		_description = description_;
	}
	
	public function getType() : String
	{
		return _type;
	}
	
	public function setType( type_:String ) : Void
	{
		_type=type_;
	}
	
	public function get filesLoaded():Number { return _filesLoaded; }
	public function set filesLoaded(filesLoaded_:Number):Void { _filesLoaded=filesLoaded_; }
	public function get filesTotal():Number { return _filesTotal; }
	public function set filesTotal(filesTotal_:Number):Void { _filesTotal=filesTotal_; }
	public function get bytesLoaded():Number { return _bytesLoaded; }
	public function set bytesLoaded(bytesLoaded_:Number):Void { _bytesLoaded=bytesLoaded_; }
	public function get bytesTotal():Number { return _bytesTotal; }
	public function set bytesTotal(bytesTotal_:Number):Void { _bytesTotal=bytesTotal_; }
	public function get percent():Number { return _percent; }
	public function set percent(percent_:Number):Void { _percent=percent_; }
	public function get description():String { return _description; }
	public function set description(description_:String):Void { _description=description_; }

}