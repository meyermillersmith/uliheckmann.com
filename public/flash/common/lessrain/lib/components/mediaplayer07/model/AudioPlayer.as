import mx.utils.Delegate;

import lessrain.lib.components.mediaplayer07.core.Bandwidth;
import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.display.MediaPreview;
import lessrain.lib.components.mediaplayer07.events.BufferEvent;
import lessrain.lib.components.mediaplayer07.events.LoadEvent;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.Proxy;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.model.AudioPlayer extends AbstractMediaPlayer {
	
	private var _soundContainer:MovieClip;
	private var _sound:Sound;
	private var _playheadPositionChangedEvent:MediaPlayerEvent;
	private var _pausePosition:Number;
	private var _resumeAfterScrub:Boolean;
	
	// Keep track about loading & playback status
	private var _intUpdate : Number;
	private var _lastPosition : Number;
	private var _lastLoaded : Number;
	private var _hasStarted : Boolean = false;
	
	/**
	 * Constructor
	 * 
	 * @param	file_				Audio DataFile
	 * @param	soundContainer_		Sound container movieclip
	 * @param	previewContainer_	Media preview container movieclip
	 */
	public function AudioPlayer( media_:Media, soundContainer_:MovieClip, previewContainer_:MovieClip ) {
		super(media_, previewContainer_);
		
		_soundContainer = soundContainer_;
		_sound = new Sound(_soundContainer);
		
		_playheadPositionChangedEvent = new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, this);
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
			doLoadAudio();
		}
		
		setState(bufferingState);
		distributeEvent(new BufferEvent(BufferEvent.BUFFER_EMPTY, this, 0));
	}
	
	/**
	 * @see AbstractMediaPlayer#scrubTo
	 */
	public function scrubTo( scrubValue_ : Number ) : Void {
		var pos : Number = _duration * scrubValue_ / 100;
		_sound.start(pos);
		if(!_resumeAfterScrub) {
			_sound.stop();
		}
		_resumeAfterScrub = false;
		_pausePosition = pos * 1000;
		if(getState() == stoppedState) {
			setState(pausedState);
		}
		distributeEvent(_playheadPositionChangedEvent);
	}

	/**
	 * @see AbstractMediaPlayer#skipForward
	 */
	public function skipForward() : Void {
		_resumeAfterScrub = getPlaying();
		super.skipForward();
	}

	/**
	 * @see AbstractMediaPlayer#skipBack
	 */
	public function skipBack() : Void {
		_resumeAfterScrub = getPlaying();
		super.skipBack();
	}

	/**
	 * @see AbstractMediaPlayer#doSetVolume
	 */
	public function doSetVolume(volume_ : Number) : Void {
		_volume = Math.min(100, Math.max(volume_, 0));
		_sound.setVolume(_volume);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGE, this));;
	}
	
	/**
	 * @see AbstractMediaPlayer#getPercentLoaded
	 */
	public function getPercentLoaded():Number {
		return (_sound.getBytesLoaded() > 10) ? (_sound.getBytesLoaded() * 100 / _sound.getBytesTotal()) : 0; 
	}

	/**
	 * @see AbstractMediaPlayer#getAbsolutePlayheadPosition
	 */
	public function getAbsolutePlayheadPosition():Number {
		return _sound.position / 1000; 
	}

	/**
	 * @see AbstractMediaPlayer#getRelativePlayheadPositon
	 */
	public function getRelativePlayheadPositon():Number {
		if (_duration != null && _duration > 0) {
			return getAbsolutePlayheadPosition() * 100 / _duration;
		} else {
			return 0;
		}
	}
	
	/**
	 * @see AbstractMediaPlayer#finalize()
	 */
	public function finalize():Void {
		super.finalize();
		_sound.stop();
		delete _sound;

		clearInterval(_intUpdate);
	}
	
	/**
	 * @see AbstractMediaPlayer#__doPlay
	 */
	public function __doPlay() : Void {
		_sound.start(_pausePosition != null ? _pausePosition / 1000 : 0);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#__doPause
	 */
	public function __doPause() : Void {
		_pausePosition = _sound.position;
		_sound.stop();
		_sound.setPosition(_pausePosition);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#__doResume
	 */
	public function __doResume() : Void {
		__doPlay();
//		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}

	/**
	 * @see AbstractMediaPlayer#__doStop
	 */
	public function __doStop() : Void {
		_sound.start(0);
		_sound.stop();
		_pausePosition = null;
		distributeEvent(_playheadPositionChangedEvent);
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
	}
	
	private function onPreviewLoadDone():Void {
		_preview.show();
		doLoadAudio();
	}
	
	private function doLoadAudio():Void {
		
		_sound.loadSound(getMedia().getMaster().src, true);
		_sound.onLoad = Proxy.create(this, onLoadSound);
		_sound.onID3 = Proxy.create(this, onID3);
		_sound.onSoundComplete = Proxy.create(this, onSoundComplete); 
		
		_lastPosition = 0;
		_lastLoaded = 0;
		
		// Fire initial events
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
		distributeEvent(_playheadPositionChangedEvent);
		distributeEvent(new LoadEvent(LoadEvent.LOAD_START, this));
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGE, this));
		
		// start update interval
		_intUpdate = setInterval(Delegate.create(this, updateProperties), 100);
		
		if(_autoPlay) {
			doPlay();
		} else {
			doStop();
		}
		
		// set volume again, after calling Sound.load, the volume property is gone!
		_sound.setVolume(_volume);
	}
	
	private function onLoadSound(success_:Boolean):Void {
		if(!success_) {
			_error = "Unable to load sound";
			LogManager.error(_error);
			return;
		}
	}
	
	private function onID3():Void {
		if(_sound.id3.TLEN != null && _duration == null) {
			_duration = parseInt(_sound.id3.TLEN) / 1000;
		} 
	}
	
	private function onSoundComplete():Void {
		if(_autoRewind || _isLoop) {
			_sound.stop();
		}
		if(!_isLoop) {
			setState(stoppedState);
			_sound.stop();
		}
		
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_END, this));
	}
	
	private function updateProperties() : Void {
		if(_lastPosition != _sound.getPosition()) {
			if(getState() == bufferingState) {
				setState(playingState);
				if(!_hasStarted) {
					_hasStarted = true;
					distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYER_START, this));
				}
				distributeEvent(new BufferEvent(BufferEvent.BUFFER_FULL, this, 100));
				distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));
			}
			_lastPosition = _sound.getPosition();
			distributeEvent(_playheadPositionChangedEvent);
		} else if(getPlaying()) {
			setState(bufferingState);
			distributeEvent(new BufferEvent(BufferEvent.BUFFER_EMPTY, this, 0));
		}
		
		if(_lastLoaded != _sound.getBytesLoaded()) {
			_lastLoaded = _sound.getBytesLoaded();
			if(_sound.getBytesLoaded() == _sound.getBytesTotal()) {
				distributeEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE, this, _sound.getBytesLoaded(), _sound.getBytesTotal()));
			} else {
				distributeEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS, this, _sound.getBytesLoaded(), _sound.getBytesTotal()));
			}
			
			if(getState() == bufferingState) {
				distributeEvent(new BufferEvent(BufferEvent.BUFFER_PROGRESS, this, getBufferPercent()));
			}
		}
	}
}