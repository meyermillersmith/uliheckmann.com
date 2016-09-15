
/** * @author Thomas Meyer, Less Rain (thomas@lessrain.com) */class lessrain.lib.components.mediaplayer07.core.KeyframeData {
	private var _time : Number;
	private var _offset : Number;

	public function KeyframeData( time_ : Number, offset_ : Number) {		_time = time_ || 0;
		_offset = offset_ || 0;
	}

	public function get time() : Number { 
		return _time; 
	}

	public function set time(time_ : Number) : Void { 
		_time = time_; 
	}

	public function get offset() : Number { 
		return _offset; 
	}

	public function set offset(offset_ : Number) : Void { 
		_offset = offset_; 
	}
}