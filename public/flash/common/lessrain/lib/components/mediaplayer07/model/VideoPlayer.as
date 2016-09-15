/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import mx.utils.Delegate;

import lessrain.lib.components.mediaplayer07.core.Bandwidth;
import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.display.MediaPreview;
import lessrain.lib.components.mediaplayer07.events.BufferEvent;
import lessrain.lib.components.mediaplayer07.events.LoadEvent;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;
import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.Proxy;

class lessrain.lib.components.mediaplayer07.model.VideoPlayer extends AbstractMediaPlayer {
	
	// Name of the video instance in the _videoContainer movieclip
	public static var NAME_VIDEO_INSTANCE:String = "video";
	
	private var _netConnection : NetConnection;
	private var _netStream : NetStream;
	private var _video : Video;
	private var _sound : Sound;
	private var _videoContainer:MovieClip;
	private var _soundContainer : MovieClip;
	private var _playheadPositionChangedEvent:MediaPlayerEvent;
	private var _hasStarted:Boolean = false;
//	private var _videoStillBmp:BitmapData;
//	private var _videoStill:MovieClip;
	
	// Keep track about loading & playback status
	private var _intUpdate : Number;
	private var _lastPosition : Number;
	private var _lastLoaded : Number;
	private var _lastBuffer:Number;
	private var _stateBeforeBufferEmpty:IPlayerState;
	
	/**
	 * Constructor
	 * 
	 * @param	file_				Video DataFile
	 * @param	videoContainer_		Movieclip that contains the video object. The clip
	 * 								must contain a video object that is named according
	 * 								to NAME_VIDEO_INSTANCE
	 * @param	soundContainer_		Sound container movieclip
	 * @param	previewContainer_	Media preview container movieclip
	 */
	public function VideoPlayer(media_:Media, videoContainer_ : MovieClip, soundContainer_ : MovieClip, previewContainer_:MovieClip ) {
		super(media_, previewContainer_);

		_videoContainer = videoContainer_;
		_video = Video(_videoContainer[NAME_VIDEO_INSTANCE]);
		if(_video == null) {
			LogManager.error("No video object found in " + _videoContainer + "!");
			return;
		}

		_soundContainer = soundContainer_;
		_sound = new Sound(_soundContainer);
		
		/**
		 * Mute sound until a NetStream.Buffer.Full event has been received, 
		 * otherwise the video starts playing too early.
		 */
		_sound.setVolume(0);
		
		doSetVolume(AbstractMediaPlayer.DEFAULT_VOLUME);
		_playheadPositionChangedEvent = new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, this);

		_netConnection = new NetConnection();
		_netConnection.connect(null);

		_netStream = new NetStream(_netConnection);
		
		// TODO fix buffer behaviour
		_netStream.setBufferTime(8);

		_video.attachVideo(_netStream);
		_video.smoothing = true;

		_soundContainer.attachAudio(_netStream);
	}
	
	/**
	 * @see AbstractMediaPlayer#loadFile
	 */
	public function loadFile(bandwidth_:Bandwidth) : Void
	{
		_bandwidth = bandwidth_;
		
		// do we have a preview?
		var preview:DataFile = getMedia().getPreview();
		if(preview != null) {
			_preview = new MediaPreview(_previewContainer, preview.src);
			_preview.load(Proxy.create(this, onPreviewLoadDone));
		} else {
			doLoadVideo();
		}
		
		setState(bufferingState);
		distributeEvent(new BufferEvent(BufferEvent.BUFFER_EMPTY, this, 0));
	}
	
	/**
	 * @see AbstractMediaPlayer#scrubTo
	 */
	public function scrubTo( scrubValue_ : Number ) : Void
	{
		var pos : Number = _duration * scrubValue_ / 100;
//		LogManager.debug(scrubValue_ + " " + pos + " dur " + _duration);
		_lastPosition = pos;
		_netStream.seek(pos);
		if(getState() == stoppedState) {
			setState(pausedState);
		}
		if(_preview != null && _preview.isShowing()) {
			_preview.hide();
		}
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#doSetVolume
	 */
	public function doSetVolume(volume_ : Number) : Void {
		if(isNaN(volume_)) {
			return;
		} 
		_volume = Math.min(100, Math.max(volume_, 0));
		if(_hasStarted) {
			_sound.setVolume(_volume);
		}
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGE, this));
	}
	
	/**
	 * @see AbstractMediaPlayer#getPercentLoaded
	 */
	public function getPercentLoaded():Number {
		return (_netStream.bytesTotal > 10) ? (_netStream.bytesLoaded * 100 / _netStream.bytesTotal) : 0; 
	}

	/**
	 * @see AbstractMediaPlayer#getAbsolutePlayheadPosition
	 */
	public function getAbsolutePlayheadPosition():Number {
		return _netStream.time; 
	}

	/**
	 * @see AbstractMediaPlayer#getRelativePlayheadPositon
	 */
	public function getRelativePlayheadPositon():Number {
		if (_duration != null && _duration > 0) {
			return _netStream.time * 100 / _duration;
		} else {
			return 0;
		}
	}
	
	/**
	 * Get video object to apply custom properties
	 */
	public function getVideo():Video {
		return _video;
	}
	
	/**
	 * @see	AbstractMediaPlayer#getBufferPercent
	 */
	public function getBufferPercent():Number {
		return Math.min(Math.round(_netStream.bufferLength / _netStream.bufferTime * 100), 100);
	}
	
	/**
	 * @see AbstractMediaPlayer#finalize()
	 */
	public function finalize():Void {
		super.finalize();

		_netStream.close();
		delete _netStream;

		_netConnection.close();
		delete _netConnection;
		delete _video;
		
//		_videoStillBmp.dispose();
//		_videoStillBmp = null;
//		_videoStill.removeMovieClip();

		clearInterval(_intUpdate);
	}

	/**
	 * @see AbstractMediaPlayer#__doPlay
	 */
	public function __doPlay() : Void {
		if(_preview != null) {
			_preview.hide();
		}
		_netStream.pause(false);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#__doPause
	 */
	public function __doPause() : Void {
		_netStream.pause(true);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#__doResume
	 */
	public function __doResume() : Void {
		__doPlay();
	}

	/**
	 * @see AbstractMediaPlayer#__doStop
	 */
	public function __doStop() : Void {
		_netStream.seek(0);
		_netStream.pause(true);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}
	
	private function doLoadVideo():Void {
		_netStream.play(getMedia().getMaster(_bandwidth).src);
		_netStream.onStatus = Proxy.create(this, onNetStreamStatus);
		_netStream.onMetaData = Proxy.create(this, onMetaData);

		_lastPosition = 0;
		_lastLoaded = 0;
		
		// Fire initial events
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
		distributeEvent(_playheadPositionChangedEvent);
		distributeEvent(new LoadEvent(LoadEvent.LOAD_START, this));
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGE, this));
		
		// start update interval
		_intUpdate = setInterval(Delegate.create(this, updateProperties), 100); 
	}
	
//	private function createScreenShot():Void {
//		if(_videoStillBmp == null) {
//			_videoStillBmp = new BitmapData(_video._width, _video._height, true, 0x00000000);
//		}
//		_videoStillBmp.draw(_video, new Matrix());
//		if(_videoStill == null) {
//			_videoStill = _videoContainer.createEmptyMovieClip("videoStill", _videoContainer.getNextHighestDepth());
//		}
//		_videoStill.attachBitmap(_videoStillBmp, 1, "auto", true);
//	}
//	
//	private function clearScreenshot():Void {
//		_videoStillBmp.dispose();
//		_videoStillBmp = null;
//	}
	
	private function onPreviewLoadDone():Void {
		_preview.show();
		doLoadVideo();
	}
	
	/**
	 * Handle NetStreamStatus
	 */
	private function onNetStreamStatus( oInfo : Object ) : Void
	{
//		LogManager.info("onNetStreamStatus " + oInfo.code);
//		trace("onNetStreamStatus " + oInfo.code);
		switch (oInfo.code)
		{
			case "NetStream.Buffer.Full":
//				if(_currentState == bufferingState) {
//					if(!_hasStarted) {
//						_hasStarted = true;
//						_preview.hide();
//						doSetVolume(_volume);
//						distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_START, this));
//						if(_autoPlay) {
//							setState(playingState);
//							distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
//						} else {
//							setState(new IdleState(this));
//							doStop();
////							distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
//						}
//					}
//				}
				if(_stateBeforeBufferEmpty != null) {
					setState(_stateBeforeBufferEmpty);
				}
				distributeEvent(new BufferEvent(BufferEvent.BUFFER_FULL, this, 100));
				break;

			case "NetStream.Play.Start":
//				if(_currentState == bufferingState) {
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
							if(getBufferPercent() < 99) {
								setState(bufferingState);
							}
						} else {
							setState(playingState);
//							distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
//							doStop();
//							createScreenShot();
						}
					}
//				}
				break;

			case "NetStream.Buffer.Empty":
				if(getRelativePlayheadPositon() > 99) {
					onVideoFinished();
				} else {
					_stateBeforeBufferEmpty = getState();
					setState(bufferingState);
					distributeEvent(new BufferEvent(BufferEvent.BUFFER_EMPTY, this, 0));
				}
				break;

			case "NetStream.Play.Stop":
				onVideoFinished();
				break;

			case "NetStream.Play.Failed":
				break;

			case "NetStream.Play.StreamNotFound":
				var _error : String;
				_error = "Error playing URL: " + oInfo.description;
				LogManager.error(_error);
				break;

			case "NetStream.Seek.Notify":
				break;
		}
	}
	
	private function onMetaData(metaDataObject : Object) : Void
	{
		_duration = metaDataObject.duration;
		if(!_autoPlay) {
			doStop();
//			clearScreenshot();
		}
		
		// remove meta data listener
		delete _netStream.onMetaData;
	}
	
	private function onVideoFinished():Void {
		if(_autoRewind || _isLoop) {
			_netStream.seek(0);
		}
		if(!_isLoop) {
			setState(stoppedState);
			_netStream.pause(true);
			
			// If a preview is defined, display the preview instead of the first
			// video frame
			if(_preview != null && _autoRewind) {
				_preview.show();
			}
		}
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_END, this));
	}

	private function updateProperties() : Void {
		if(_lastPosition != _netStream.time) {
			_lastPosition = _netStream.time;
			distributeEvent(_playheadPositionChangedEvent);
		
			if(_preview != null && _preview.isShowing() && _netStream.time > .1 && getState() != stoppedState) {
				_preview.hide();
			}
			
		}
		if(_lastLoaded != _netStream.bytesLoaded) {
			_lastLoaded = _netStream.bytesLoaded;
			if(_netStream.bytesLoaded == _netStream.bytesTotal) {
				distributeEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE, this, _netStream.bytesLoaded, _netStream.bytesTotal));
			} else {
				distributeEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS, this, _netStream.bytesLoaded, _netStream.bytesTotal));
			}
			
			
			var buffer:Number = getBufferPercent();
			if(buffer != _lastBuffer) {
				if(buffer == 100) {
					distributeEvent(new BufferEvent(BufferEvent.BUFFER_FULL, this, 100));
				} else {
					distributeEvent(new BufferEvent(BufferEvent.BUFFER_PROGRESS, this, buffer));
				}
			}
			_lastBuffer = getBufferPercent();
		}
	}
	
}