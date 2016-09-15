import lessrain.lib.components.mediaplayer07.core.Bandwidth;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.display.MediaPreview;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.model.BufferingState;
import lessrain.lib.components.mediaplayer07.model.IPlayerState;
import lessrain.lib.components.mediaplayer07.model.IdleState;
import lessrain.lib.components.mediaplayer07.model.PausedState;
import lessrain.lib.components.mediaplayer07.model.PlayingState;
import lessrain.lib.components.mediaplayer07.model.StoppedState;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.logger.LogManager;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer implements IDistributor {
	
	/**
	 * Number of seconds to skip on skip event
	 */
	public static var SKIP_PERCENT : Number = 5;
	
	/**
	 * Default volume
	 */
	public static var DEFAULT_VOLUME : Number = 70;
	
	/**
	 * Default autoPlay property
	 */
	public static var DEFAULT_AUTO_PLAY : Boolean = false;
	
	/**
	 * Default autoRewind property
	 */
	public static var DEFAULT_AUTO_REWIND : Boolean = false;
	
	/**
	 * Default loop property
	 */
	public static var DEFAULT_LOOP : Boolean = false;
	
	/**
	 * Default fullscren property
	 */
	public static var DEFAULT_FULLSCREEN : Boolean = false;
	
	/**
	 * The default loading priority will be passed to the PriorityLoader if no
	 * custom priority is specified. The loading priority will only affect
	 * Images and SWFs.
	 * 
	 * @see setLoadingPriority
	 * @see SWFPlayer
	 * @see ImageViewer
	 */
	public static var DEFAULT_LOADING_PRIORITY:Number = 100;

	public var playingState : IPlayerState;
	public var pausedState : IPlayerState;
	public var stoppedState : IPlayerState;	public var bufferingState : IPlayerState;		private var _autoPlay : Boolean = DEFAULT_AUTO_PLAY;
	private var _autoRewind : Boolean = DEFAULT_AUTO_REWIND;
	private var _isLoop : Boolean = DEFAULT_LOOP;
	private var _isFullscreen : Boolean = DEFAULT_FULLSCREEN;
	private var _volume : Number;
	private var _loadingPriority : Number = DEFAULT_LOADING_PRIORITY;

	private var _media:Media;
	private var _bandwidth:Bandwidth;
	private var _previewContainer:MovieClip;
	private var _currentState:IPlayerState;
	private var _error : String;
	private var _progress : Number;
	private var _progressPercent : Number;
	private var _percentLoaded : Number;
	private var _duration : Number;
	private var _preview:MediaPreview;
	private var _eventDistributor : EventDistributor;
	
	/**
	 * Constructor
	 * 
	 * @param	file_	Datafile to be played
	 */
	public function AbstractMediaPlayer(media_ : Media, previewContainer_:MovieClip) {
		_eventDistributor = new EventDistributor();

		_media = media_;
		_previewContainer = previewContainer_;
		
		playingState = new PlayingState(this);
		pausedState = new PausedState(this);
		bufferingState = new BufferingState(this);
		stoppedState = new StoppedState(this);
		
		setState(new IdleState(this));
	}
	
	/**
	 * Start loading a media file
	 */
	public function loadFile(bandwidth_:Bandwidth) : Void { // abstract
		LogManager.error("AbstractMediaPlayer.loadFile() must be overwritten by subclass");
	}
	
	/**
	 * Get the player's media object
	 * @return	The player's <code>Media</code> instance
	 */
	public function getMedia():Media {
		return _media;
	}
	
	/**
	 * Start media playback
	 */
	public function doPlay():Void {
		LogManager.warning(this + "::doPlay " + _currentState);
		_currentState.doPlay();
	}
	
	/**
	 * Pause media playback
	 */
	public function doPause():Void {
		_currentState.doPause();
	}

	/**
	 * Resume media playback
	 */
	public function doResume():Void {
		_currentState.doResume();
	}
	
	/**
	 * Stop media playback
	 */
	public function doStop():Void {
		_currentState.doStop();
	}
	
	/**
	 * Skip media forward
	 * @see SKIP_PERCENT
	 */
	public function skipForward() : Void {
		scrubTo(Math.min(100, getRelativePlayheadPositon() + SKIP_PERCENT));
	}
	
	/**
	 * Skip media back
	 * @see SKIP_PERCENT
	 */
	public function skipBack() : Void {
		scrubTo(Math.max(0, getRelativePlayheadPositon() - SKIP_PERCENT));
	}
	
	/**
	 * Scrubs to the given position
	 * @param	the percentage of the media's total duration
	 */
	public function scrubTo(scrubValue_ : Number) : Void { // abstract
		LogManager.error("AbstractMediaPlayer.scrubTo() must be overwritten by subclass");
	}
	
	/**
	 * Get sound volume
	 * @return Sound volume
	 */
	public function doGetVolume() : Number {
		return _volume;
	}

	/**
	 * Set sound volume
	 * @param	volume_	Volume  [0..100]
	 */
	public function doSetVolume(volume_ : Number) : Void { // abstract
		LogManager.error("AbstractMediaPlayer.doSetVolume() must be overwritten by subclass");
	}

	/**
	 * Get fullscreen state
	 * @return	<code>true</code> if the player is currently switched to
	 * 			fullscreen mode 
	 */
	public function getFullscreen() : Boolean {
		return _isFullscreen;
	}

	/**
	 * Set fullscreen state
	 * @param	isFullscreen_	set to <code>true</code> to enable fullscreen
	 * 							mode
	 */
	public function setFullscreen(isFullscreen_ : Boolean) : Void {
		if (_isFullscreen!=isFullscreen_) {
			_isFullscreen = isFullscreen_;
			distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.FULLSCREEN_CHANGE, this));
		}
	}
	
	/**
	 * Get the autoPlay property. If autoPlay is set to true, playback stars
	 * immediately (without user interaction).
	 * @return	autoPlay property
	 */
	public function getAutoPlay():Boolean {
		return _autoPlay;
	}
	
	/**
	 * Set the autoPlay property. If autoPlay is set to true, playback stars
	 * immediately (without user interaction).
	 * @param	autoPlay_	autoPlay property
	 */
	public function setAutoPlay(autoPlay_:Boolean):Void {
		_autoPlay = autoPlay_;
	}
	
	/**
	 * Get the loop property. If loop is set to true, the player keeps playing
	 * the media file in a loop.
	 * @return	Loop property
	 */
	public function getLoop():Boolean {
		return _isLoop;
	}
	
	/**
	 * Set the loop property. If loop is set to true, the player keeps playing
	 * the media file in a loop.
	 * @param	loop_	Loop property
	 */
	public function setLoop(loop_:Boolean):Void {
		_isLoop = loop_;
	}
	
	/**
	 * Get the autoRewind property. If autoRewind is set to true, the playhead
	 * moves to the beginning of the media file after the playhead has reached
	 * the end.
	 * @return	autoRewind property
	 */
	public function getAutoRewind():Boolean {
		return _autoRewind;
	}
	
	/**
	 * Set the autoRewind property. If autoRewind is set to true, the playhead
	 * moves to the beginning of the media file after the playhead has reached
	 * the end.
	 * @param	autoRewind_	autoRewind property
	 */
	public function setAutoRewind(autoRewind_:Boolean):Void {
		_autoRewind = autoRewind_;
	}
	
	public function getBandwidth():Bandwidth {
		return _bandwidth || Bandwidth.HIGH;
	}
	
	/**
	 * Get the loading priority
	 * @return Loading priority
	 */
	public function getLoadingPriority():Number {
		return _loadingPriority;
	}
	
	/**
	 * Set the loading priority. The loading priority will only affect
	 * Images and SWFs.
	 * @param	priority_	Loading priority
	 * @see		DEFAULT_LOADING_PRIORITY
	 */
	public function setLoadingPriority(priority_:Number):Void {
		_loadingPriority = priority_;
	}
	
	/**
	 * Get the percentage that has been loaded
	 * @return	Loaded percentage
	 */
	public function getPercentLoaded():Number { // abstract
		LogManager.error("AbstractMediaPlayer.getPercentLoaded() must be overwritten by subclass");
		return null; 
	}
	
	/**
	 * Get buffer fill percentage
	 * @return	buffer fill percentage [0..100]
	 */
	public function getBufferPercent():Number {
		return getPercentLoaded();
	}

	/**
	 * Get the absolute playhead position
	 * @return	Playhead position (sec)
	 */
	public function getAbsolutePlayheadPosition():Number { // abstract
		LogManager.error("AbstractMediaPlayer.getAbsolutePlayheadPosition() must be overwritten by subclass");
		return null; 
	}

	/**
	 * Get the relative playhead position
	 * @return Playhead position (percentage)
	 */
	public function getRelativePlayheadPositon():Number { // abstract
		LogManager.error("AbstractMediaPlayer.getRelativePlayheadPositon() must be overwritten by subclass");
		return null;
	}

	/**
	 * Get the total media duration
	 * @return	Media duration [s]
	 */
	public function getDuration():Number {
		return _duration;
	}

	/**
	 * Set the total media duration
	 * @param	duration_	Media duration [s]
	 */	
	public function setDuration(duration_:Number):Void {
		_duration = duration_;
	}
	
	/**
	 * Get playing state
	 * @return	<code>true</code> if the player is currently playing
	 */
	public function getPlaying() : Boolean {
		return _currentState == playingState;
	}

	/**
	 * Get paused state
	 * @return	<code>true</code> if the player is currently paused
	 */
	public function getPaused():Boolean {
		return _currentState == pausedState;
	}
	
	/**
	 * Get stopped state
	 * @return	<code>true</code> if the player has stopped
	 */
	public function getStopped():Boolean {
		return _currentState == stoppedState;
	}
	
	/**
	 * Get buffering state
	 * @return	<code>true</code> if the player is buffering
	 */
	public function getBuffering():Boolean {
		return _currentState == bufferingState;
	}
	
	/**
	 * Get error message
	 * @return	error message
	 */
	public function getError():String {
		return _error;
	}
	
	/**
	 * Get the current <code>IPlayerState</code> instance
	 * @see	IPlayerState
	 */
	public function getState():IPlayerState {
		return _currentState;
	}
	
	/**
	 * Set the current <code>IPlayerState</code> instance
	 * @see IPlayerState
	 */
	public function setState(state_:IPlayerState):Void {
		LogManager.debug("State change from: " + _currentState + " to: " + state_);
		_currentState = state_;
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
		delete _currentState;
		_eventDistributor.finalize();
	}
	
	/**
	 * The following __do..() methods must not be called from outside. They
	 * are only used by the different IPLayerState instances.
	 * 
	 * Subclasses must overwrite all __do..() methods and implement the player 
	 * spedific functionality, e.g. start/pause/stop/resume the NetStream object
	 * of a video or sound player. 
	 */
	
	/**
	 * !!! Do not call !!!
	 */
	public function __doPlay() : Void { // abstract
		LogManager.error("AbstractMediaPlayer.__doPlay() must be overwritten by subclass");
	}
	
	/**
	 * !!! Do not call !!!
	 */
	public function __doPause() : Void { // abstract
		LogManager.error("AbstractMediaPlayer.__doPause() must be overwritten by subclass");
	}
	
	/**
	 * !!! Do not call !!!
	 */
	public function __doStop() : Void { // abstract
		LogManager.error("AbstractMediaPlayer.__doStop() must be overwritten by subclass");
	}
	
	/**
	 * !!! Do not call !!!
	 */
	public function __doResume() : Void { // abstract
		LogManager.error("AbstractMediaPlayer.__doResume() must be overwritten by subclass");
	}
}