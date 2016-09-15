import lessrain.lib.components.mediaplayer07.core.MetaData;
import lessrain.lib.components.mediaplayer07.events.MetaDataEvent;
import lessrain.lib.components.mediaplayer07.events.NetStatusEvent;
import lessrain.lib.components.mediaplayer07.events.VideoChunkEvent;
import lessrain.lib.components.mediaplayer07.model.ChunkedVideoPlayer;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.logger.LogManager;

class lessrain.lib.components.mediaplayer07.model.VideoChunk implements IDistributor {
	private var _src : String; 
	private var _isPaused : Boolean;
	private var _connection : NetConnection;
	private var _stream : NetStream;
	private var _video : Video;
	private var _metaData : MetaData;
	private var _time : Number;
	private var _duration : Number;
	private var _streamInitialized : Boolean;
	private var _pendingSeekPosition : Number;
	private var _soundContainer : MovieClip;
	private var _sound : Sound;
	private var _player : ChunkedVideoPlayer;
	private var _id : String;
	private var _eventDistributor : EventDistributor;

	public function VideoChunk(player_:ChunkedVideoPlayer, id_:String, src_ : String, time_ : Number, duration_:Number, video_ : Video, soundContainer_ : MovieClip) {
		_eventDistributor = new EventDistributor();

		_player = player_;
		_id = id_;
		_src = src_;
		_time = time_;
		_duration = duration_;
		_isPaused = false;		_streamInitialized = false;
			
		_video = video_;
		if(_video == null) {
			LogManager.error(this + "I want to have a video object!");
			return;
		}

		_soundContainer = soundContainer_;
		_sound = new Sound(_soundContainer);
	}

	public function initialize() : Void {
		_connection = new NetConnection();
		_connection.connect(null);

		//			_stream = new NetStream(_connection);
		//			_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		//			_stream.client = this;
		//			_stream.soundTransform = _soundTransform;
		//			_stream.bufferTime = 0.1;
		//		    
		//			_video = new Video();
		//			_video.attachNetStream(_stream);
		//			_video.smoothing = true;
		//			
		//			_soundTransform = new SoundTransform(0, 0);
		//			_stream.soundTransform = _soundTransform;
		//			
		//			addChild(_video);
			
			
		/*
		 * AS2
		 */
		_stream = new NetStream(_connection);
//		_stream.onStatus = Proxy.create(this, onNetStatus);
		_stream.onMetaData = Proxy.create(this, onMetaData);
		_stream.setBufferTime(3);
		
		_soundContainer.attachAudio(_stream);
		
		// TODO fix buffer behaviour
		//		_netStream.setBufferTime(8);

//		_video.attachVideo(_stream);
		
//		_video.smoothing = true;

	}
	
	private function initializeStream( withSeekPos_ : Number) : Void {
//		LogManager.debug(this + " ### initializeStream");
//		_video.attachVideo(_stream);
//		_soundContainer.attachAudio(_stream);
		
		_streamInitialized = true;
		_pendingSeekPosition = withSeekPos_ || 0.0;
//		_stream.play(_src);
	}

	/**
	 * Package internal
	 */
	function setSize( w_ : Number, h_ : Number) : Void {
		_video.width = w_ || 0;
		_video.height = h_ || 0;
	}

	/**
	 * Package internal
	 */
	function seek(pos_ : Number) : Void {
//		LogManager.debug(this + "::seek() pos: " + pos_ + " isPaused? " + _isPaused + " playerIsPaused? " + _player.getPaused() + " playerIsStopped? " + _player.getStopped());
		if (!_streamInitialized) initializeStream(pos_);
			else {
				_stream.seek(pos_);
			}
	}

	public function onMetaData(infoObject : Object) : Void {
//		LogManager.debug(this + "::onMetaData");
		_metaData = new MetaData();
		_metaData.parse(_src, infoObject);
			
		_isPaused = false;
		
//		_soundContainer.onEnterFrame = Proxy.create(this, handleEnterFrame);
		    
		distributeEvent(new MetaDataEvent(MetaDataEvent.META_DATA, _metaData));
		distributeEvent(new VideoChunkEvent(VideoChunkEvent.CHUNK_START));
			
		if (_pendingSeekPosition > 0) {
			_stream.seek(_pendingSeekPosition);
			_pendingSeekPosition = 0;
		}
		
		delete _stream.onMetaData;
	}

	public function onNetStatus(obj_ : Object) : Void {
		if(obj_.code == "NetStream.Seek.Notify") {
//			LogManager.debug(this + " onNetStatus SEEK NOTIFY. player status: " + _player.getPlaying() + " isPaused? " + _isPaused);
			_isPaused = !_player.getPlaying();
			_stream.pause(_isPaused);
		} else if(obj_.code == "NetStream.Play.Stop") {
			distributeEvent(new VideoChunkEvent(VideoChunkEvent.CHUNK_END));
			delete _stream.onStatus;
		}
//		LogManager.info(_src + ": NetConnection status: " + obj_.code);
			
		distributeEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, this, obj_));
	}

	public function onCuePoint(infoObject : Object) : Void {
			//LogManager.debug(_src + ": onCuePoint "+infoObject.info.name);
			//dispatchEvent(new VideoChunkEvent(VideoChunkEvent.PLAY_END));
	}

//	private function handleEnterFrame() : Void {
//		// TODO this may crash
//		if (_metaData != null && _stream.time > _metaData.duration - 0.040) {
//			distributeEvent(new VideoChunkEvent(VideoChunkEvent.CHUNK_END));
////			delete _soundContainer.onEnterFrame;
//		}
//	}

	/**
	 * Package internal
	 */
	function pause() : Void {
		LogManager.debug(this + "::pause()");
		if (_streamInitialized && !_isPaused) {
			_isPaused = true;
			_stream.pause();
//			delete _soundContainer.onEnterFrame;
		}
		_pendingSeekPosition = 0;
	}

	/**
	 * Package internal
	 */
	function resume() : Void {
		LogManager.debug(this + "::resume()");
		if (!_streamInitialized) initializeStream();
		if (_isPaused) {
			_isPaused = false;
			_stream.pause(false);
//			_soundContainer.onEnterFrame = Proxy.create(this, handleEnterFrame);
		}
		_pendingSeekPosition = 0;
	}

	/**
	 * Package internal
	 */
	function unhook() : Void {
		LogManager.debug(this + "::unhook()");
//		delete _stream.onStatus;
//		delete _soundContainer.onEnterFrame;
		//		_stream.pause(true);
		_stream.close();
	}

	/**
	 * Package internal
	 */
	function hook() : Void {
		LogManager.debug(this + "::hook() ");
//		_soundContainer.onEnterFrame = Proxy.create(this, handleEnterFrame);
		_stream.play(_src);
		_stream.onStatus = Proxy.create(this, onNetStatus);
//		_stream.seek(0);
//		_stream.pause(true);
//		_soundContainer.attachAudio(_stream);
		_video.attachVideo(_stream);
	}

	/**
	 * Package internal
	 */
	public function finalize() : Void {
		delete _stream.onStatus;
		delete _stream.onMetaData;
//		delete _soundContainer.onEnterFrame;

		if (_video != null) _video.clear();
		if (_stream != null) _stream.close();
		if (_connection != null) _connection.close();
		
		_player = null;
		_connection = null;
		_stream = null;
		_video = null;
	}
	
	function get volume():Number {
		return _sound.getVolume();
	}
	
	function set volume(volume_:Number):Void {
		_sound.setVolume(volume_);
	}

	/**
	 * Package internal
	 */
	function get isPaused() : Boolean {
		return _isPaused;
	}

	/**
	 * Package internal
	 */
	function get stream() : NetStream {
		return _stream;	}

	/**
	 * Package internal
	 */
	function get metaData() : MetaData {
		return _metaData;
	}

	/**
	 * Package internal
	 */
	function get time() : Number {
		return _time;	}
	
	function get duration():Number {
		return _duration;
	}

	public function get src(  ) : String {
		return _src;	}
	
	public function get id():String {
		return _id;
	}

	/**
	 * @see IDistributor#addEventListener
	 */
	public function addEventListener(type : String, func : Function) : Void {
		_eventDistributor.addEventListener(type, func);
	}

	/**
	 * @see IDistributor#removeEventListener
	 */
	public function removeEventListener(type : String, func : Function) : Void {
		_eventDistributor.removeEventListener(type, func);
	}

	/**
	 * @see IDistributor#distributeEvent
	 */
	public function distributeEvent(eventObject : IEvent) : Void {
		_eventDistributor.distributeEvent(eventObject);
	}
	
	public function toString() : String {
		var s:String = "lessrain.lib.components.mediaplayer07.model.VideoChunk (src: " + src + ")";
		return s;
	}
}
