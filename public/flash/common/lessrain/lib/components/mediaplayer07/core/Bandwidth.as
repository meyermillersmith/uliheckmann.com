/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.Bandwidth {
	
	public static var HIGH:Bandwidth = new Bandwidth("high");	public static var LOW:Bandwidth = new Bandwidth("low");	public static var MEDIUM:Bandwidth = new Bandwidth("medium");
	
	public static function getBandwidthByType(type_:String):Bandwidth {
		var bw:Bandwidth;
		switch(type_) {
			default:
			case "high":
				bw = HIGH;
				break;
			case "medium":
				bw = MEDIUM;
				break;
			case "low":
				bw = LOW;
				break;
		}
		return bw;
	}
	
	private var _type:String;
	
	private function Bandwidth(type_:String) {
		_type = type_;
	}
	
	public function toString():String {
		return "Bandwidth: type " + _type; 
	}
	
	public function getType():String {
		return _type;
	}
}