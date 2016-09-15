import lessrain.lib.components.mediaplayer07.core.KeyframeData;

class lessrain.lib.components.mediaplayer07.core.MetaData {
	private var _filename : String;

	private var _width : Number;
	private var _height : Number;
	private var _duration : Number;
	private var _creator : String;

	private var _videoDatarate : Number;
	private var _videoCodec : String;
	private var _videoFramerate : Number;

	private var _audioDatarate : Number;
	private var _audioCodec : String;	private var _keyframes : Array;
	private var _avcProfile : String;
	private var _avcLevel : String;
	private var _aacAudioObjectType : String;

	public function MetaData() {
	}

	public function parse(src_ : String, metaDataObject : Object) : Void {
		_filename = src_;
			
		_keyframes = [];
		if (metaDataObject.seekpoints != null && metaDataObject.seekpoints instanceof Array) {
			for (var i : Number = 0;i < Array(metaDataObject.seekpoints).length; i++) {
				var keyframeInfo : Object = metaDataObject.seekpoints[i];
				_keyframes.push(new KeyframeData(keyframeInfo.time, keyframeInfo.offset));
			}
		}
			
		if (metaDataObject.width == null) _width = 320;
			else _width = metaDataObject.width;
		if (metaDataObject.height == null) _height = 240;
			else _height = metaDataObject.height;
			
		_duration = Math.round(parseFloat(metaDataObject.duration) * 1000) / 1000;
		_creator = metaDataObject.creator;
		    
		_videoDatarate = parseFloat(metaDataObject.videodatarate);
		_videoFramerate = parseFloat(metaDataObject.videoframerate);
		if (isNaN(_videoFramerate)) _videoFramerate = parseFloat(metaDataObject.framerate);
			
		switch (String(metaDataObject.videocodecid).toLowerCase()) {
			case "2": 
				_videoCodec = "Sorenson H.263"; 
				break;
			case "3": 
				_videoCodec = "Screen Video"; 
				break;
			case "4": 
			case "5": 				_videoCodec = "On2 VP6"; 
				break;
			case "6": 
				_videoCodec = "Screen Video V2"; 
				break;
			case "vp6f": 
				_videoCodec = "VP6F"; 
				break;
			case "avc1": 
				_videoCodec = "AFC1"; 
				break;
		}
		    
		if (metaDataObject.audiodatarate != null) _audioDatarate = parseFloat(metaDataObject.audiodatarate);			else if (metaDataObject.audiosamplerate) _audioDatarate = parseFloat(metaDataObject.audiosamplerate);
			
		switch (String(metaDataObject.audiocodecid).toLowerCase()) {
			case "0": 
				_audioCodec = "Uncompressed"; 
				break;
			case "1": 
				_audioCodec = "ADPCM"; 
				break;
			case "2": 			case ".mp3": 			case "mp3": 
				_audioCodec = "MP3"; 
				break;
			case "mp4a": 			case "mp4a.": 			case ".mp4a": 
				_audioCodec = "MP4A"; 
				break;
			case "5": 
			case "6": 
				_audioCodec = "NellyMoser"; 
				break;
		}
			
		_avcProfile = metaDataObject.avcprofile;		_avcLevel = metaDataObject.avclevel;		_aacAudioObjectType = metaDataObject.aacaot;
	}

	public function toString() : String {
		var str : String = "MetaData for " + _filename + "\n";
		str += "Width: " + _width + "\n";
		str += "Height: " + _height + "\n";
		str += "Duration: " + _duration + "\n";		str += "Creator: " + _creator + "\n";		str += "Video codec: " + _videoCodec + "\n";
		str += "Video datarate: " + _videoDatarate + "\n";
		str += "Video framerate: " + _videoFramerate + "\n";
		str += "Audio codec: " + _audioCodec + "\n";
		str += "Audio datarate: " + _audioDatarate + "\n";
		str += "AVC profile number: " + _avcProfile + "\n";
		str += "AVC IDC level number: " + _avcLevel + "\n";
		str += "AAC audio object type: " + _aacAudioObjectType + "\n";
		str += "Keyframes count: " + _keyframes.length + "\n";
		return str;
	}

	public function get filename() : String { 
		return _filename; 
	}

	public function get width() : Number { 
		return _width; 
	}

	public function get height() : Number { 
		return _height; 
	}

	public function get duration() : Number { 
		return _duration; 
	}

	public function get creator() : String { 
		return _creator; 
	}

	public function get videoDatarate() : Number { 
		return _videoDatarate; 
	}

	public function get videoFramerate() : Number { 
		return _videoFramerate; 
	}

	public function get videoCodec() : String { 
		return _videoCodec; 
	}

	public function get audioDatarate() : Number { 
		return _audioDatarate; 
	}

	public function get audioCodec() : String { 
		return _audioCodec; 
	}

	public function get avcProfile() : String {
		return _avcProfile;
	}

	public function get avcLevel() : String {
		return _avcLevel;
	}

	public function get aacAudioObjectType() : String {
		return _aacAudioObjectType;
	}

	public function get keyframes() : Array {
		return _keyframes;
	}
}
