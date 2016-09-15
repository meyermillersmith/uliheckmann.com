/**
 * cookie, version 1
 * @class:   lessrain.lib.cookie.Cookie
 * @author:  luis@lessrain.com
 * @version: 1.4
 */
 
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.Cookie {

	private var _cookieName:String;
	private var _localO:Object;
	private var onStatus:Function;


	function Cookie(name:String) {
		_cookieName = name;
		getLocal();
		_localO.onStatus = Proxy.create(this,status);
	}
	
	public function save(object:Object):Void {
		_localO.data[_cookieName] = object;
		_localO.flush();
	}

	public function load() {
		getLocal();
		return _localO.data[_cookieName];
	}

	public function exists():Boolean {
		if (_localO.data[_cookieName] != undefined) return true;
		else return false;
	}

	public function remove():Void  {
		delete _localO.data[_cookieName];
		_localO.flush();
	}
	
	private function getLocal():Void{_localO = SharedObject.getLocal(_cookieName);}
    private function status():Void{_localO.onStatus(arguments);}
	
	public function get data() {return _localO.data[_cookieName];}
	public function get size():Number {return _localO.getSize();}
		
	

}