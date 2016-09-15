	
	/**
 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.Bandwidth;
import lessrain.lib.components.mediaplayer07.core.ChunkedVideo;
import lessrain.lib.components.mediaplayer07.core.IMediaPlayerFeedable;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.core.MetaData;
import lessrain.lib.components.mediaplayer07.display.MediaPreview;
import lessrain.lib.components.mediaplayer07.events.BufferEvent;
import lessrain.lib.components.mediaplayer07.events.LoadEvent;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.events.MetaDataEvent;
import lessrain.lib.components.mediaplayer07.events.NetStatusEvent;
import lessrain.lib.components.mediaplayer07.events.VideoChunkEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;
import lessrain.lib.components.mediaplayer07.model.VideoChunk;
import lessrain.lib.components.mediaplayer07.model.VideoPlayer;
import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.events.Event;
import lessrain.lib.utils.logger.LogManager;

import mx.utils.Delegate;

class lessrain.lib.components.mediaplayer07.model.ChunkedVideoPlayer extends AbstractMediaPlayer {
	public static var SUPER_VERBOSE : Boolean = false;

	private var _videoContainer : MovieClip;
	private var _soundContainer : MovieClip;

	// Keep track about loading & playback status
	private var _intUpdate : Number;
	private var _lastPosition : Number;
	private var _lastLoaded : Number;
	private var _lastBuffer : Number;
	private var _firstRun : Boolean;
	private var _video : Video;
	private var _feed : ChunkedVideo;

	// chunky stuff
	private var _currentChunk : VideoChunk;

	private var _videoChunks : Array;
	private var _videoMetaData : MetaData;
	private var _isPaused : Boolean;
	private var _stateBeforeBufferEmpty : IPlayerState;
	private var _hasStarted : Boolean;

	/**
	 * Constructor
	 */
	public function ChunkedVideoPlayer(feed_ : IMediaPlayerFeedable, videoContainer_ : MovieClip, soundContainer_ : MovieClip, previewContainer_ : MovieClip ) {
		super(feed_.getCurrentMedia(), previewContainer_);
		
		if(!feed_ instanceof ChunkedVideo) {
			LogManager.error("Invalid Video Chunk Feed");
			return;
		}
		
		_feed = ChunkedVideo(feed_);
		_videoContainer = videoContainer_;
		_video = Video(_videoContainer[VideoPlayer.NAME_VIDEO_INSTANCE]);
		if(_video == null) {
			LogManager.error("No video object found in " + _videoContainer + "!");
			return;
		}
		
		_soundContainer = soundContainer_;
		
		_hasStarted = false;
	}
	
	/**
	 * @see AbstractMediaPlayer#loadFile
	 */
	public function loadFile(bandwidth_ : Bandwidth) : Void {
		_bandwidth = bandwidth_;
		
		/*
		 * TODO preview
		 */
		//			var preview : DataFile = getMedia().getPreview();
		//			if(preview != null) 
		//			{
		//				_preview = _previewContainer.addChild(new MediaPreview(preview.src)) as MediaPreview;
		//				_preview.addEventListener(Event.COMPLETE, onPreviewLoadDone);
		//				_preview.load();
		//			} else 
		//			{
		
		createChunks(_feed);
		doLoadVideo();
		//			}
		setState(bufferingState);
	}
	
	private function createChunks(chunkedVideo_ : ChunkedVideo) : Void {
		/*
		 * Clean up the mess before creating new Chunks. This is necessary
		 * since createChunks() is called more than once if the user decides
		 * to change the bandwidth.
		 */
		if(_videoChunks) {
			while(_videoChunks.length > 0) {
				VideoChunk(_videoChunks.pop()).finalize();
			}
		} 
		
		_videoChunks = new Array();
		
		_duration = 0;
		
		for (var i : Number = 0;i < chunkedVideo_.getChunks().length; i++) {
			var media : Media = Media(chunkedVideo_.getChunks()[i]);
			var src : String = media.getMaster(_bandwidth).src;
			var time : Number = (i == 0 ? 0.0 : _duration);
			var duration:Number = media.getMaster(_bandwidth).duration;
			var id:String = media.id;
			var soundContainer : MovieClip = _soundContainer.createEmptyMovieClip("chunkSound" + i, _soundContainer.getNextHighestDepth());
			var chunk : VideoChunk = new VideoChunk(this, id, src, time, duration, _video, soundContainer);
			
			_duration += media.getMaster(_bandwidth).duration;
			
			if (_videoChunks.length == 0) chunk.addEventListener(MetaDataEvent.META_DATA, handleMetaData);
			chunk.addEventListener(NetStatusEvent.NET_STATUS, Proxy.create(this, handleNetStatus));
			chunk.addEventListener(VideoChunkEvent.CHUNK_START, Proxy.create(this, handleChunkStart));
			chunk.addEventListener(VideoChunkEvent.CHUNK_END, Proxy.create(this, handleChunkEnd));
			
			chunk.initialize();
			
			_videoChunks.push(chunk);
		}
	}
	
	private function onPreviewLoadDone(event_ : Event) : Void {
		_preview.show();
		doLoadVideo();
	}

	private function doLoadVideo() : Void {
		_firstRun = true;
		
		initializeVideoControl();
		
		playNextChunk();
	}

	private function initializeVideoControl() : Void {
		doSetVolume(0);
		
		_lastPosition = 0;
		_lastLoaded = 0;
		
		// Fire initial events
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, this));
		distributeEvent(new MediaPlayerEvent(LoadEvent.LOAD_START, this));
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGE, this));
	}

	private function handleChunkStart(event_ : VideoChunkEvent) : Void {
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug(this + " ### handlePlayStart");
			
		var chunk : VideoChunk = event_.getTarget();
		if ( _currentChunk == null) {
			if (ArrayUtils.contains(_videoChunks, chunk))
				{
					// TODO fixme
//					getState().onBufferFull();
//					distributeEvent(new MediaPlayerEvent(BufferEvent.BUFFER_FULL, this));
				}
				else {
				chunk.pause();
			}
		}
			else {
			if ( _currentChunk != chunk) chunk.pause();
		}
	}

	private function handleChunkEnd(event_ : VideoChunkEvent) : Void {
		LogManager.debug(this + "::handleChunkEnd");
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug(this + " ### handlePlayEnd");
			
		var chunk : VideoChunk = event_.getTarget();
			
		if (!isLastChunk(_currentChunk)) {
			//chunk.pause();
			//chunk.seek(0);
			playNextChunk();
		}
	}
	
	private function isLastChunk(chunk_):Boolean {
		return ArrayUtils.indexOf(_videoChunks, chunk_) == _videoChunks.length - 1;
	}

	function handleFirstTimePlayable() : Void {
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("handleFirstTimePlayable");
		_firstRun = false;
		doSetVolume(DEFAULT_VOLUME);
		// start update interval
		clearInterval(_intUpdate);
		_intUpdate = setInterval(Delegate.create(this, handleTimer), 100);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	private function handleNetStatus(event_ : NetStatusEvent) : Void {
		//			var sourceChunk : VideoChunk = event_.info.videoChunk as VideoChunk;
		//			
		//			if (sourceChunk == _currentChunk)
		//			{
		//				if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug(sourceChunk.src + " ### onNetStatus: " + event_.info.code);
		//			
		//				switch(event_.info.code)
		//				{
		//					case NetStatusEventCode.NETSTREAM_PLAY_START:
		//						handleVideoStart();
		//						break;
		//					case NetStatusEventCode.NETSTREAM_PLAY_STOP:
		//						handleVideoStop();
		//						break;
		//					case NetStatusEventCode.NETSTREAM_BUFFER_FULL:
		//						handleBufferFull();
		//						break;
		//					case NetStatusEventCode.NETSTREAM_BUFFER_EMPTY:
		//						handleBufferEmpty();
		//						break;
		//					case NetStatusEventCode.NETSTREAM_SEEK_NOTIFY:
		//						handleSeekNotify();
		//						break;
		//					case NetStatusEventCode.NETSTREAM_SEEK_INVALID_TIME:
		//						handleSeekToInvalidTime(parseFloat(event_.info.details));
		//						break;
		//					case NetStatusEventCode.NETSTREAM_PLAY_STREAMNOTFOUND:
		//					case NetStatusEventCode.NETSTREAM_SEEK_FAILED:
		//						handleError(String(event_.info.details));
		//						break;
		//					case NetStatusEventCode.NETSTREAM_BUFFER_FLUSH:
		//						handleBufferFlush();
		//						break;
		//				}
		//			}
		//			else
		//			{
		//				if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug(sourceChunk.src + " ### onNetStatus inactive: " + event_.info.code);
		//			
		//				switch(event_.info.code)
		//				{
		//					case NetStatusEventCode.NETSTREAM_PLAY_STOP:
		//						handlePreviousVideoChunkStop(sourceChunk);
		//						break;
		//				}
		//			}
			
		/*******************************************************************
		 * AS2
		 *******************************************************************/
 
		//		LogManager.info("onNetStreamStatus " + oInfo.code);

		var netStatusCode : String = event_.getNetStatusCode();
		var sourceChunk : VideoChunk = VideoChunk(event_.getTarget());
		if(sourceChunk == _currentChunk) {
			switch (netStatusCode) {
				case "NetStream.Buffer.Full":
					handleBufferFull();
					break;

				case "NetStream.Play.Start":
					handleVideoStart();
					break;

				case "NetStream.Buffer.Empty":
					handleBufferEmpty();
					break;

				case "NetStream.Play.Stop":
					handleVideoStop();
					break;

				case "NetStream.Play.Failed":
					break;

				case "NetStream.Play.StreamNotFound":
					var _error : String;
					_error = "Error playing URL: " + event_.getInfoObject().description;
					LogManager.error(_error);
					break;

				case "NetStream.Seek.Notify":
					handleSeekNotify();
					break;
			}		
		} else {
			if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug(sourceChunk.src + " ### onNetStatus inactive: " + netStatusCode);
			
			switch(netStatusCode) {
				case "NetStream.Play.Stop":
					handlePreviousVideoChunkStop(sourceChunk);
					break;
			}
		}	
	}

	/**
	 * @see AbstractMe_currentChunkdiaPlayer#__doPlay
	 */
	public function __doPlay() : Void {
		if(_preview != null) {
			_preview.hide();
		}
		_isPaused = false;
			
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("doPlay");
			
		if (_currentChunk == null) {
			playNextChunk();
		} else {
			if(isLastChunk(_currentChunk) && Math.abs(_currentChunk.duration - _currentChunk.time) < 0.5) {
				scrubTo(0);
			} else {
				_currentChunk.resume();
			}
		}
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#__doPause
	 */
	public function __doPause() : Void {
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("doPause " + (_currentChunk == null ? "null" : _currentChunk.src));
			
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("absolutePlayheadPosition " + getAbsolutePlayheadPosition() + " / " + _duration);
			
		_isPaused = true;
		if (_currentChunk != null) _currentChunk.pause();
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	public function __doResume() : Void {
		__doPlay();
	}

	/**
	 * @see AbstractMediaPlayer#__doStop
	 */
	public function __doStop() : Void {
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("doStop");
			
		scrubTo(0);
		__doPause();
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	
	/**
	 * @see AbstractMediaPlayer#scrubTo
	 */
	public function scrubTo( position_ : Number ) : Void {
		/**
		 * Calculate relative position, depending on connection type. If
		 * the video is retrieved via progressive download, the max available
		 * scrub position is the loaded percentage.
		 */
		var relPos : Number;
		relPos = Math.min(position_, getPercentLoaded());
		relPos = Math.max(0, Math.min(relPos, 100));
		// Calculate absolute position
		var absPos : Number = _duration * relPos / 100;
		
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("seek to " + absPos);
		
		if(getState() == stoppedState) {
			setState(pausedState);
		}
			
		_lastPosition = absPos;
		//_seekControl.pendingPosition = absPos;

		var chunk : VideoChunk;
			
		for (var i : Number = _videoChunks.length - 1;i >= 0; i--) {
			chunk = _videoChunks[i];
			if (chunk.time <= _lastPosition) {
				if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("seeking to " + absPos + " in chunk: " + chunk.src);
					
				if (_currentChunk != chunk) playChunk(i);
				chunk.seek(_lastPosition - chunk.time);
					
				return;
			}
		}

		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.SEEK_POSITION_CHANGE, this));
	}
	
	/**
	 * Play the given chunk. The player will start playing, no matter if it has
	 * been paused or stopped before.
	 * 
	 * @param chunk_	Chunk to play
	 */
	public function scrubToChunk(chunk_:VideoChunk):Void {
		if(chunk_ == null) {
			return;
		}
		LogManager.debug(this + "::scrubToChunk() " + chunk_.id);
		if(_currentChunk == chunk_) {
			/*
			 * We already playing the desired chunk, so simply reset it
			 */
			_currentChunk.seek(0);
			return;
		}
		for (var i : Number = 0; i < _videoChunks.length; i++) {
			if(VideoChunk(_videoChunks[i]) == chunk_) {
				playChunk(i);
				doPlay();
				return;
			}
		}
	}
	
	public function getChunkByMediaID(id_:String):VideoChunk {
		for (var i : Number = 0; i < _videoChunks.length; i++) {
			var chunk:VideoChunk = VideoChunk(_videoChunks[i]);
			if(chunk.id == id_) {
				return chunk;
			}
		}
		return null;
	}
	
	public function getPreviousChunk():VideoChunk {
		var currentIndex:Number = ArrayUtils.indexOf(_videoChunks, _currentChunk);
		var prevIndex:Number = currentIndex - 1;
		if(prevIndex < 0) {
			return null;
		}
		return VideoChunk(_videoChunks[prevIndex]);
	}
	
	public function getCurrentChunk() : VideoChunk {
		return _currentChunk;
	}

	public function getNextChunk():VideoChunk {
		var currentIndex:Number = ArrayUtils.indexOf(_videoChunks, _currentChunk);
		var nextIndex:Number = currentIndex + 1;
		if(nextIndex >= _videoChunks.length) {
			return null;
		}
		return VideoChunk(_videoChunks[nextIndex]);
	}
	
	private function playNextChunk() : Void {
		if(_videoChunks == null || _videoChunks.length == 0) {
			LogManager.error(this + "::playNextChunk(). No chunks to play!");
			return;
		}
		LogManager.debug(this + "::playNext()");
		if (_currentChunk == null) {
			playChunk(0);
		} else {
			var i : Number = ArrayUtils.indexOf(_videoChunks, _currentChunk) + 1;
			playChunk(i, false);
		}
	}
	
	private function playChunk(chunkIndex_ : Number, stopOldChunk_ : Boolean) : Void {
		if (chunkIndex_ >= 0 && chunkIndex_ <= _videoChunks.length - 1) {
			if(_currentChunk != null) {
				if (stopOldChunk_) {
					_currentChunk.pause();
					_currentChunk.seek(0);
				}
				_currentChunk.unhook();
			}
				
			_currentChunk = _videoChunks[chunkIndex_];

			distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.CHUNK_CHANGE, this));

			_currentChunk.hook();
			
			_lastBuffer = 0;
			// TODO fixme
			LogManager.debug("currentState: " + getState() + " isPaused: " + _isPaused);
			//				getState().onBufferEmpty();
			if (!_isPaused) _currentChunk.resume();
			
		}
	}

	private function handleTimer() : Void {
		var playheadPositionMem : Number = getAbsolutePlayheadPosition();
			
		if(_lastPosition != playheadPositionMem) {
			_lastPosition = playheadPositionMem;
				
			//			if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("absolutePlayheadPosition " + _lastPosition + " / " + _duration);
				
			//TODO Not sure why olli did it this way, i'm using NETSTREAM_PLAY_STOP now!
			/*if(playheadPositionMem >= _duration) 
			{
			handleVideoComplete();
			}*/
			distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, this));
		}
		
		
		var bytesLoadedMem : Number = bytesLoaded;
		if(_lastLoaded != bytesLoadedMem) {
			_lastLoaded = bytesLoadedMem;
				
			if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("loading " + _lastLoaded + " / " + bytesTotal);
				
			if(bytesLoadedMem == bytesTotal) {
				distributeEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE, this));
			} else {
				distributeEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS, this));
			}
		}
			
		var buffer : Number = getBufferPercent();
			
		if(buffer != _lastBuffer) {
			if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.debug("buffering " + buffer);
				
			if(buffer == 100) {
				handleBufferFull();
			} else {
				distributeEvent(new BufferEvent(BufferEvent.BUFFER_PROGRESS, this));
			}
		}
		_lastBuffer = getBufferPercent();
	}

	/**
	 * Called when the NetStream.Play.Start event is triggered. This event is
	 * just an indicator that the netstream has successfully started and the
	 * first frame is displayed. It does *not* mean that enough data has been
	 * buffered to start playback.
	 */
	private function handleVideoStart() : Void {
		if(!_hasStarted) {
			_hasStarted = true;
			//						if(_preview != null) {
			//							_preview.hide();
			//						}
			doSetVolume(_volume);
			distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_START, this));
			if(_autoPlay) {
				setState(playingState);
				_stateBeforeBufferEmpty = playingState;
				distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
//				if(getBufferPercent() < 99) {
//					setState(bufferingState);
//				}
			} else {
				setState(playingState);
//							distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
//							doStop();
//							createScreenShot();
			}
		}
		
		distributeEvent(new BufferEvent(BufferEvent.BUFFER_EMPTY, this));
	}

	private function handleVideoStop() : Void {
		if (ArrayUtils.indexOf(_videoChunks, _currentChunk) == _videoChunks.length - 1) {
				handleVideoComplete();
		}
	}

	private function handlePreviousVideoChunkStop( chunk_ : VideoChunk ) : Void {
		if (chunk_ != _currentChunk) {
			chunk_.pause();
			chunk_.seek(0);
		}
	}

	private function handleVideoComplete() : Void {
		if (ChunkedVideoPlayer.SUPER_VERBOSE) LogManager.info("video complete");
			
		//		if(_autoRewind || _isLoop) scrubTo(0);
		//		if(!_isLoop) __doPause();
		//			
		//		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
		//		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_END, this));

		
		if(_autoRewind || _isLoop) {
			scrubTo(0);
		}
		if(!_isLoop) {
			setState(_autoRewind ? stoppedState : pausedState);
			__doPause();
			
			// If a preview is defined, display the preview instead of the first
			// video frame
			if(_preview != null && _autoRewind) {
				_preview.show();
			}
		}
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_END, this));
	}

	private function handleBufferEmpty() : Void {
		if(getRelativePlayheadPositon() > 99) {
			//handleVideoComplete();
			return;
		}
		// TODO fixme
		//			state.onBufferEmpty();
		distributeEvent(new BufferEvent(BufferEvent.BUFFER_EMPTY, this));
	}

	private function handleBufferFull() : Void {
		// TODO fixme
		//			state.onBufferFull();
		if(_firstRun) {
			handleFirstTimePlayable();
		}
		distributeEvent(new BufferEvent(BufferEvent.BUFFER_FULL, this));
	}

	private function handleBufferFlush() : Void {
		distributeEvent(new BufferEvent(BufferEvent.BUFFER_FULL, this));
	}

	private function handleError(errorInfo_ : String ) : Void {
		LogManager.error(errorInfo_);
	}

	private function handleSeekToInvalidTime(lastValidPosition_ : Number) : Void {
		if(getState() == bufferingState) {
			return;
		}
		var lastValidPosition : Number = lastValidPosition_;
		scrubTo(lastValidPosition);
		setState(bufferingState);
	}

	private function handleSeekNotify() : Void {
		LogManager.debug(this + "::handleSeekNotify()");
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, this));
//		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.SEEK_NOTIFY, this));
	}

	private function handleMetaData(event_ : MetaDataEvent) : Void {
		_videoMetaData = event_.getTarget();
			
		for (var i : Number = 0;i < _videoChunks.length; i++) {
			var chunk : VideoChunk = VideoChunk(_videoChunks[i]);
			chunk.setSize(_videoMetaData.width, _videoMetaData.height);
		}
			
		distributeEvent(event_);
	}

	/**
	 * @see AbstractMediaPlayer#doSetVolume
	 */
	public function doSetVolume(volume_ : Number) : Void {
		if(isNaN(volume_))  return;
			
		_volume = Math.min(100, Math.max(volume_, 0));
			
		for (var i : Number = 0;i < _videoChunks.length; i++) {
			var chunk : VideoChunk = VideoChunk(_videoChunks[i]);
			chunk.volume = _volume;
		}
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#getPercentLoaded
	 */
	public function getPercentLoaded() : Number {
		var loaded : Number = 0;
		var total : Number = 0;
			
		var chunk : VideoChunk;
		for (var i : Number = 0;i < _videoChunks.length; i++) {
			chunk = _videoChunks[i];
			if (loaded == total) loaded += chunk.stream.bytesLoaded;
			total += chunk.stream.bytesTotal;
		}
			
		return (total > 10) ? (loaded * 100 / total) : 0; 
	}

	public function get bytesLoaded() : Number {
		var loaded : Number = 0;
		var total : Number = 0;
			
		var chunk : VideoChunk;
		for (var i : Number = 0;i < _videoChunks.length; i++) {
			chunk = _videoChunks[i];
			if (loaded == total) loaded += chunk.stream.bytesLoaded;
			total += chunk.stream.bytesTotal;
		}
			
		return loaded;
	}

	public function get bytesTotal() : Number {
		var total : Number = 0;
			
		var chunk : VideoChunk;
		for (var i : Number = 0;i < _videoChunks.length; i++) {
			chunk = _videoChunks[i];
			total += chunk.stream.bytesTotal;
		}
			
		return total;
	}

	/**
	 * @see AbstractMediaPlayer#getAbsolutePlayheadPosition
	 */
	public function getAbsolutePlayheadPosition() : Number {
		return _currentChunk == null ? 0 : _currentChunk.time + _currentChunk.stream.time;
	}

	/**
	 * @see AbstractMediaPlayer#getRelativePlayheadPositon
	 */
	public function getRelativePlayheadPositon() : Number {
		var pos : Number = 0;
		if (!isNaN(_duration) && _duration > 0) {
			pos = getAbsolutePlayheadPosition() * 100 / _duration;
		}
		//		LogManager.debug(this + "::getRelativePlayheadPositon() " + pos + " currentChunk:\n" + _currentChunk + "\nstreamTime: " + _currentChunk.stream.time);
		return pos;
	}

	/**
	 * @see	AbstractMediaPlayer#getBufferPercent
	 */
	public function getBufferPercent() : Number {
		if (_currentChunk != null) {
			return Math.max(0, Math.min(Math.round(_currentChunk.stream.bufferLength / _currentChunk.stream.bufferTime * 100), 100));
		} else {
			return 0;
		}
	}
	
	public function getRelChunkOffset():Number {
		return _currentChunk.time / _duration;
	}
	
	public function getRelChunkDuration():Number {
		return _currentChunk.duration / _duration;
	}

	/**
	 * @see AbstractMediaPlayer#finalize()
	 */
	public function finalize() : Void {
		super.finalize();
		
		while(_videoChunks.length > 0) {
			VideoChunk(_videoChunks.pop()).finalize();
		}
		_videoChunks = null;
		_videoContainer = null;
		clearInterval(_intUpdate);
	}

	public function toString() : String {
		return "lessrain.lib.components.mediaplayer07.model.ChunkedVideoPlayer";
	}
}
