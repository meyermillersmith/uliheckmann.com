import lessrain.lib.components.mediaplayer07.events.BufferEvent;
import lessrain.lib.components.mediaplayer07.events.LoadEvent;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
/**
 * MVC Controller between the AbstractMediaPlayer and the view items, mainly
 * the control panel.
 * 
 * @see	AbstractMediaPlayer
 * @see View
 * @see ControlPanel
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.MVCController implements IDistributor {

	private var _player:AbstractMediaPlayer;
	private var _eventDistributor:EventDistributor;
	private var _isPlaying:Boolean;
	private var _oldVolume:Number;
	
	public function MVCController(player_:AbstractMediaPlayer) {
		_player = player_;
		
		_eventDistributor = new EventDistributor();
		
		// listen to player events
		var playerEventProxy:Function = Proxy.create(this, onPlayerEvent);
		_player.addEventListener(MediaPlayerEvent.STATUS_CHANGE, playerEventProxy);		_player.addEventListener(MediaPlayerEvent.PLAYER_START, playerEventProxy);		_player.addEventListener(MediaPlayerEvent.PLAYER_END, playerEventProxy);
		_player.addEventListener(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, playerEventProxy);
		_player.addEventListener(MediaPlayerEvent.VOLUME_CHANGE, playerEventProxy);
		_player.addEventListener(MediaPlayerEvent.FULLSCREEN_CHANGE, playerEventProxy);
		_player.addEventListener(MediaPlayerEvent.CHUNK_CHANGE, playerEventProxy);
		_player.addEventListener(BufferEvent.BUFFER_EMPTY, playerEventProxy);		_player.addEventListener(BufferEvent.BUFFER_FULL, playerEventProxy);		_player.addEventListener(BufferEvent.BUFFER_PROGRESS, playerEventProxy);		_player.addEventListener(LoadEvent.LOAD_START, playerEventProxy);
		_player.addEventListener(LoadEvent.LOAD_PROGRESS, playerEventProxy);		_player.addEventListener(LoadEvent.LOAD_COMPLETE, playerEventProxy);
	}

	/**
	 * Start media playback
	 */	
	public function doPlay():Void {
		_player.doPlay();
	}

	/**
	 * Pause media playback
	 */	
	public function doPause():Void {
		_player.doPause();
	}
	
	/**
	 * Start/resume or pause the video 
	 */
	public function togglePlay():Void {
		if(_player.getPlaying()) {
			_player.doPause();
		} else {
			_player.doResume();
		}
	}
	
	/**
	 * Stop media playback
	 */
	public function doStop():Void {
		_player.doStop();
	}
	
	/**
	 * Toggle fullscreen mode
	 */
	public function toggleFullscreen():Void {
		var fs:Boolean = !_player.getFullscreen();
		setFullscreen(fs);
	}
	
	/**
	 * Set fullscreen mode on/off
	 * @param	enabled_	Fullscreen mode
	 */
	public function setFullscreen(enabled_:Boolean):Void {
		_player.setFullscreen(enabled_);
	}
	
	/**
	 * Skip media forward
	 */
	public function skipForward():Void {
		_player.skipForward();
	}
	
	/**
	 * Skip media backwards
	 */
	public function skipBack():Void {
		_player.skipBack();
	}
	
	/**
	 * Scrub to given media position
	 * @param	position_	Position [s]
	 */
	public function scrubTo(position_:Number):Void {
		_player.scrubTo(position_);
	}
	
	/**
	 * Set sound volume
	 * @param	volume_	Volume [0..100]
	 */
	public function setVolume(volume_:Number):Void {
		_player.doSetVolume(volume_);
	}
	
	/**
	 * Increase or decrease volume by <code>dVolume</code>
	 * @param	dVolume	volume delta 
	 */
	public function changeVolume(dVolume_:Number):Void {
		_player.doSetVolume(_player.doGetVolume() + dVolume_);
	}
	
	public function toggleMute():Void {
		if(_player.doGetVolume() > 0) {
			_oldVolume = _player.doGetVolume();
			_player.doSetVolume(0);
		} else {
			_player.doSetVolume(_oldVolume || AbstractMediaPlayer.DEFAULT_VOLUME);
		}
	}
	
	/**
	 * Play next media item. As one media player instance is only capable of
	 * playing on single media item, an event is distributed. The client
	 * can then react to the event.
	 */
	public function playNext():Void {
		_eventDistributor.distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAY_NEXT, _player));
	}
	
	/**
	 * Play previous media item. As one media player instance is only capable of
	 * playing on single media item, an event is distributed. The client
	 * can then react to the event.
	 */
	public function playPrevious():Void {
		_eventDistributor.distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAY_PREVIOUS, _player));
	}
	
	/**
	 * Enter scrub mode
	 */
	public function startScrub():Void {
		_isPlaying = _player.getPlaying();
		_player.doPause();
	}
	
	/**
	 * Leave scrub mode
	 */
	public function stopScrub():Void {
		if(_isPlaying) {
			_player.doResume();
		}
	}
	
	/**
	 * @see IDistributor#addEventListener
	 */
	public function addEventListener(type : String, func : Function) : Void {
		_eventDistributor.addEventListener(type, func );
	}
	
	/**
	 * @see IDistributor#removeEventListener
	 */
	public function removeEventListener(type : String, func : Function) : Void {
		_eventDistributor.removeEventListener(type, func );
	}
	
	/**
	 * @see IDistributor#distributeEvent
	 */
	public function distributeEvent(eventObject : IEvent) : Void {
		_eventDistributor.distributeEvent(eventObject );
	}
	
	/**
	 * Clean up
	 */
	public function finalize() : Void {
		delete _player;
		_eventDistributor.finalize();
		delete _eventDistributor;
	}
	
	/**
	 * Receive all Events from the model and distribute them to the registered
	 * listeners
	 * @param	e_	IEvent
	 * 
	 * @see		MediaPlayerEvent
	 * @see		LoadEvent
	 */
	private function onPlayerEvent(e_:IEvent):Void {
		distributeEvent(e_);
	}
}