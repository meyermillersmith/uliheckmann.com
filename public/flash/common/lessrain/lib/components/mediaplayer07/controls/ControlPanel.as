/**
 * @author Oliver List (o.list@lessrain.com)
 */
import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.controls.BufferingDisplay;
import lessrain.lib.components.mediaplayer07.controls.Button;
import lessrain.lib.components.mediaplayer07.controls.ControlType;
import lessrain.lib.components.mediaplayer07.controls.events.ButtonEvent;
import lessrain.lib.components.mediaplayer07.controls.events.SliderEvent;
import lessrain.lib.components.mediaplayer07.controls.Slider;
import lessrain.lib.components.mediaplayer07.controls.Switch;
import lessrain.lib.components.mediaplayer07.controls.TextField;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.core.MVCController;
import lessrain.lib.components.mediaplayer07.display.MediaPlayerLayoutHost;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.events.BufferEvent;
import lessrain.lib.components.mediaplayer07.events.LoadEvent;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.skins.core.IControlPanelSkin;
import lessrain.lib.utils.KeyManager;
import lessrain.lib.utils.Map;
import lessrain.lib.utils.Proxy;

class lessrain.lib.components.mediaplayer07.controls.ControlPanel extends MediaPlayerLayoutHost {

	private var _view : View;
	private var _skin : IControlPanelSkin;
	private var _shortcutMap : Map; // Function
	private var _mvcController : MVCController;
	
	
	/**
	 * Control elements
	 */
	private var _togglePlayButton : Switch;
	private var _stopButton : Button;
	private var _prevButton : Button;
	private var _nextButton : Button;
	private var _muteButton:Switch;
	private var _timeTextField : TextField;
	private var _progressBar : Slider;
	private var _volumeController : Slider;
	private var _fullscreenButton : Switch;
	private var _volSlider : Slider;
	private var _loadingDisplay:BufferingDisplay;
	private var _bufferDisplay:BufferingDisplay;
	
	/**
	 * Proxies
	 */
	private var _togglePlayProxy : Function;
	private var _stopProxy : Function;
	private var _fullscreenProxy : Function;
	private var _prevProxy : Function;
	private var _nextProxy : Function;
	private var _skipForwardProxy : Function;
	private var _skipBackProxy : Function;
	private var _volumeUpProxy : Function;
	private var _volumeDownProxy : Function;	private var _toggleMuteProxy : Function;
	
	
	/**
	 * Constructor
	 * @param	skin_	Controlpanel skin
	 * @param	view_	View
	 */
	public function ControlPanel(skin_ : IControlPanelSkin, view_:View) {
		_skin = skin_;
		_skin.setControlPanel(this);
		
		_view = view_;
		_view.setControlPanel(this);

		_shortcutMap = new Map();
		
		// Proxies
		_togglePlayProxy = Proxy.create(this, togglePlay);
		_stopProxy = Proxy.create(this, stopMedia);
		_fullscreenProxy = Proxy.create(this, toggleFullscreen);
		_prevProxy = Proxy.create(this, previous);
		_nextProxy = Proxy.create(this, next);
		_skipForwardProxy = Proxy.create(this, skipForward);
		_skipBackProxy = Proxy.create(this, skipBack);
		_volumeUpProxy = Proxy.create(this, volumeUp);
		_volumeDownProxy = Proxy.create(this, volumeDown);
		_toggleMuteProxy = Proxy.create(this, toggleMute);
		
	}
	
	/**
	 * Set the MVC Controller
	 * @param	controller_	MVC Controller
	 */
	public function setMVCController(controller_ : MVCController) : Void {
		_mvcController = controller_;
		_mvcController.addEventListener(MediaPlayerEvent.STATUS_CHANGE, Proxy.create(this, onPlayerStatusChanged));
		_mvcController.addEventListener(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, Proxy.create(this, onPlayerPositionChanged));
		_mvcController.addEventListener(MediaPlayerEvent.VOLUME_CHANGE, Proxy.create(this, onVolumeChanged));
		_mvcController.addEventListener(MediaPlayerEvent.FULLSCREEN_CHANGE, Proxy.create(this, onFullscreenChanged));
		
		_mvcController.addEventListener(BufferEvent.BUFFER_EMPTY, Proxy.create(this, onStartBuffering));		_mvcController.addEventListener(BufferEvent.BUFFER_PROGRESS, Proxy.create(this, onBufferProgress));		_mvcController.addEventListener(BufferEvent.BUFFER_FULL, Proxy.create(this, onStopBuffering));
		_mvcController.addEventListener(LoadEvent.LOAD_COMPLETE, Proxy.create(this, onStopBuffering));
		
		_mvcController.addEventListener(LoadEvent.LOAD_START, Proxy.create(this, onPlayerLoadStart));
		_mvcController.addEventListener(LoadEvent.LOAD_PROGRESS, Proxy.create(this, onPlayerLoadProgress));
		_mvcController.addEventListener(LoadEvent.LOAD_COMPLETE, Proxy.create(this, onPlayerLoadComplete));	}

	/**
	 * As soon as the target clip is set, build the skin
	 * @see	ILayoutable#setTarget
	 */
	public function setTarget(target_ : MovieClip) : Void {
		super.setTarget(target_);

		_skin.buildSkin();
	}

	/**
	 * Inform the skin about the new size
	 * @see	AbstractlayoutHost#setBoundaries
	 */
	public function setBoundaries(rect_ : Rectangle) : Void {
		super.setBoundaries(rect_);

		var bounds : Rectangle = getBoundaries();
		_skin.resize(bounds.width, bounds.height);
	}

	/**
	 * Get the view instance
	 * @return View
	 */
	public function getView() : View {
		return _view;
	}
	
	/**
	 * Set the "toggle play/pause" button
	 * @param	btn_		Toggle play/pause button
	 * @param	shortcut_	Keyboard shortcut. Works with either single 
	 * 						characters or one of the constants defined in the
	 * 						core class <code>Key</code>.
	 * 						
	 * @return				<code>true</code> if the button has been registered,
	 * 						<code>false</code> if the button
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support the action
	 * 						that is assigned with the button.
	 * 						
	 * @see					Key
	 * @see					View#hasControl
	 */
	public function setTogglePlayButton(btn_ : Switch, shortcut_:Object) : Boolean {
		if(_togglePlayButton != null || !_view.hasControl(ControlType.TOGGLE_PLAY_SWITCH)) {
			return false;
		}

		_togglePlayButton = btn_;
		_togglePlayButton.addEventListener(ButtonEvent.RELEASE, _togglePlayProxy);
		
		// register keyboard shortcut
		registerButtonShortcut(shortcut_, _togglePlayProxy);
		return true;
	}

	/**
	 * Set the "stop" button
	 * @param	btn_		Stop button
	 * @param	shortcut_	Keyboard shortcut. Works with either single 
	 * 						characters or one of the constants defined in the
	 * 						core class <code>Key</code>.
	 * 						
	 * @return				<code>true</code> if the button has been registered,
	 * 						<code>false</code> if the button
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support the action
	 * 						that is assigned with the button.
	 * 						
	 * @see					Key
	 * @see					View#hasControl
	 */
	public function setStopButton(btn_ : Button, shortcut_:Object) : Boolean {
		if(_stopButton != null || !_view.hasControl(ControlType.STOP_BUTTON)) {
			return false;
		}

		_stopButton = btn_;
		_stopButton.addEventListener(ButtonEvent.RELEASE, _stopProxy);
		
		// register keyboard shortcut
		registerButtonShortcut(shortcut_, _stopProxy);
		return true;
	}

	/**
	 * Set the "play previous" button
	 * @param	btn_		Play previous button
	 * @param	shortcut_	Keyboard shortcut. Works with either single 
	 * 						characters or one of the constants defined in the
	 * 						core class <code>Key</code>.
	 * 						
	 * @return				<code>true</code> if the button has been registered,
	 * 						<code>false</code> if the button
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support the action
	 * 						that is assigned with the button.
	 * 						
	 * @see					Key
	 * @see					View#hasControl
	 */
	public function setPrevButton(btn_ : Button, shortcut_:Object) : Boolean {
		if(_prevButton != null || !_view.hasControl(ControlType.PREV_BUTTON)) {
			return false;
		}

		_prevButton = btn_;
		_prevButton.addEventListener(ButtonEvent.RELEASE, _prevProxy);
		
		// register keyboard shortcut
		registerButtonShortcut(shortcut_, _prevProxy);
		return true;
	}

	/**
	 * Set the "play next" button
	 * @param	btn_		Play next button
	 * @param	shortcut_	Keyboard shortcut. Works with either single 
	 * 						characters or one of the constants defined in the
	 * 						core class <code>Key</code>.
	 * 						
	 * @return				<code>true</code> if the button has been registered,
	 * 						<code>false</code> if the button
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support the action
	 * 						that is assigned with the button.
	 * 						
	 * @see					Key
	 * @see					View#hasControl
	 */
	public function setNextButton(btn_ : Button, shortcut_:Object) : Boolean {
		if(_nextButton != null || !_view.hasControl(ControlType.NEXT_BUTTON)) {
			return false;
		}

		_nextButton = btn_;
		_nextButton.addEventListener(ButtonEvent.RELEASE, _nextProxy);
		
		// register keyboard shortcut
		registerButtonShortcut(shortcut_, _nextProxy);
		return true;
	}

	/**
	 * Set the "fullscreen" button
	 * @param	btn_		Fullscreen button
	 * @param	shortcut_	Keyboard shortcut. Works with either single 
	 * 						characters or one of the constants defined in the
	 * 						core class <code>Key</code>.
	 * 						
	 * @return				<code>true</code> if the button has been registered,
	 * 						<code>false</code> if the button
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support the action
	 * 						that is assigned with the button.
	 * 						
	 * @see					Key
	 * @see					View#hasControl
	 */
	public function setFullscreenButton(btn_ : Switch, shortcut_:Object) : Boolean {
		if(_fullscreenButton != null || !_view.hasControl(ControlType.FULLSCREEN_SWITCH) || _view.getMediaPlayer().fullscreenMode == MediaPlayer.FULLSCREEN_DISABLED) {
			return false;
		}

		_fullscreenButton = btn_;
		_fullscreenButton.addEventListener(ButtonEvent.RELEASE, _fullscreenProxy);
		
		// register keyboard shortcut
		registerButtonShortcut(shortcut_, _fullscreenProxy);
		return true;
	}
	
	/**
	 * Set the "mute" button
	 * @param	btn_		Mute button
	 * @param	shortcut_	Keyboard shortcut. Works with either single 
	 * 						characters or one of the constants defined in the
	 * 						core class <code>Key</code>.
	 * 						
	 * @return				<code>true</code> if the button has been registered,
	 * 						<code>false</code> if the button
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support the action
	 * 						that is assigned with the button.
	 * 						
	 * @see					Key
	 * @see					View#hasControl
	 */
	public function setMuteButton(btn_ : Switch, shortcut_:Object) : Boolean {
		if(_muteButton != null || !_view.hasControl(ControlType.MUTE_SWITCH)) {
			return false;
		}

		_muteButton = btn_;
		_muteButton.addEventListener(ButtonEvent.RELEASE, _toggleMuteProxy);
		
		// register keyboard shortcut
		registerButtonShortcut(shortcut_, _toggleMuteProxy);
		return true;
	}

	/**
	 * Set the time textfield
	 * @param	fld_		Time textfield
	 * 
	 * @return				<code>true</code> if the field has been registered,
	 * 						<code>false</code> if the field
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support a time field
	 * 						
	 * @see					View#hasControl
	 */
	public function setTimeTextfield(fld_ : TextField) : Boolean {
		if(_timeTextField != null || !_view.hasControl(ControlType.TIME_TEXTFIELD)) {
			return false;
		}
		_timeTextField = fld_;
		return true;
	}

	/**
	 * Set the progress bar
	 * @param	progressBar_		Progress bar
	 * @param	shortcutIncrease_	Keyboard shortcut to increase the progress bar value (scrub media forward)
	 * @param	shortcutDecrease_	Keyboard shortcut to decrease the progress bar value (scrub media back)
	 * 								Works with either single 
	 * 								characters or one of the constants defined in the
	 * 								core class <code>Key</code>.
	 * 
	 * @return						<code>true</code> if the progress bar has been registered,
	 * 								<code>false</code> if the progress bar
	 * 								a) has already been set before or
	 * 								b) the current media type doens't support a progress bar.
	 * 
	 * @see							Key
	 * @see							View#hasControl
	 */
	public function setProgressBar(progressBar_ : Slider, shortcutIncrease_:Object, shortcutDecrease_:Object) : Boolean {
		if(_progressBar != null|| !_view.hasControl(ControlType.PROGRESS_SLIDER)) {
			return false;
		}

		_progressBar = progressBar_;
		
		// register keyboard shortcut
		registerButtonShortcut(shortcutIncrease_, _skipForwardProxy);
		registerButtonShortcut(shortcutDecrease_, _skipBackProxy);
		
		// listen to slider events
		_progressBar.addEventListener(SliderEvent.VALUE_CHANGED, Proxy.create(this, onProgressBarPositionChanged));
		_progressBar.addEventListener(SliderEvent.START_DRAG, Proxy.create(this, onProgressBarStartScrub));
		_progressBar.addEventListener(SliderEvent.STOP_DRAG, Proxy.create(this, onProgressBarStopScrub));
		return true;
	}

	/**
	 * Set the volume controller
	 * @param	ctrl_				Volume controller
	 * @param	shortcutIncrease_	Keyboard shortcut to increase the volume
	 * @param	shortcutDecrease_	Keyboard shortcut to decrease the volume
	 * 								Works with either single 
	 * 								characters or one of the constants defined in the
	 * 								core class <code>Key</code>.
	 * 
	 * @return						<code>true</code> if the volume controller has been registered,
	 * 								<code>false</code> if the volume controller
	 * 								a) has already been set before or
	 * 								b) the current media type doens't support a volume controller.
	 * 
	 * @see							Key
	 * @see							View#hasControl
	 */
	public function setVolumeController(ctrl_ : Slider, shortcutIncrease_:Object, shortcutDecrease_:Object) : Boolean {
		if(_volumeController != null || !_view.hasControl(ControlType.VOLUME_SLIDER)) {
			return false;
		}

		_volumeController = ctrl_;
		
		// register keyboard shortcut
		registerButtonShortcut(shortcutIncrease_, _volumeUpProxy);
		registerButtonShortcut(shortcutDecrease_, _volumeDownProxy);
		
		// listen to slider events
		_volumeController.addEventListener(SliderEvent.VALUE_CHANGED, Proxy.create(this, onVolumeSliderValueChanged));
		return true;
	}
	
	/**
	 * Set the loading display
	 * @param	display_	Loading display
	 * 
	 * @return				<code>true</code> if the loading display has been registered,
	 * 						<code>false</code> if the loading display
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support a loading display
	 * 						
	 * @see					View#hasControl
	 */
	public function setLoadingDisplay(display_:BufferingDisplay):Boolean {
		if(_loadingDisplay != null ||  !_view.hasControl(ControlType.LOADING_DISPLAY)) {
			return false;
		}
		_loadingDisplay = display_;
		return true;
	}
	
	/**
	 * Set the buffering display
	 * @param	display_	Buffering display
	 * 
	 * @return				<code>true</code> if the buffering display has been registered,
	 * 						<code>false</code> if the buffering display
	 * 						a) has already been set before or
	 * 						b) the current media type doens't support a buffering display
	 * 						
	 * @see					View#hasControl
	 */
	public function setBufferingDisplay(display_:BufferingDisplay):Boolean {
		if(!_view.hasControl(ControlType.BUFFERING_DISPLAY)) {
			return false;
		}
		_bufferDisplay = display_;
		return true;
	}
	
	/**
	 * Enable the keyboard shortcuts
	 */
	public function enableShortcuts():Void {
		var shorcutKeys:Array = _shortcutMap.getKeys();
		for(var i:Number = 0; i < shorcutKeys.length; i++) {
			var key:Number = Number(shorcutKeys[i]);
			KeyManager.addDownListener(key, Function(_shortcutMap.getAt(key)));
		}
	}
	
	/**
	 * Disable the keyboard shortcuts
	 */
	public function disableShortcuts():Void {
		var shorcutKeys:Array = _shortcutMap.getKeys();
		while(shorcutKeys.length > 0) {
			var key:Number = Number(shorcutKeys.pop());
			KeyManager.removeDownListener(key);
		}
	}
	
	/**
	 * @see MediaPlayerLayoutHost#finalize
	 */
	public function finalize() : Void {

		// remove key listeners
		disableShortcuts();
		_shortcutMap = null;

		_skin.finalize();

		_togglePlayButton.finalize();
		_stopButton.finalize();
		_prevButton.finalize();
		_nextButton.finalize();
		_timeTextField.finalize();
		_progressBar.finalize();
		_fullscreenButton.finalize();
		_volumeController.finalize();
		_muteButton.finalize();
		_loadingDisplay.finalize();
		_bufferDisplay.finalize();
		
		getTarget().removeMovieClip();
		
		super.finalize();
	}

	private function registerButtonShortcut(shortcut_ : Object, func_ : Function) : Void {
		if(shortcut_ != null) {
			var code : Number = KeyManager.addDownListener(KeyManager.keyToCode(shortcut_), func_);
			if(code != -1) {
				_shortcutMap.putAt(code, func_);
			}
		}
	}

	private function onProgressBarPositionChanged(e_ : SliderEvent) : Void {
		if(e_.getType() == SliderEvent.VALUE_CHANGED) {
			_mvcController.scrubTo(e_.getTarget().getValue());
		}
	}

	private function onProgressBarStartScrub(e_ : SliderEvent) : Void {
		_mvcController.startScrub();
	}

	private function onProgressBarStopScrub(e_ : SliderEvent) : Void {
		_mvcController.stopScrub();
	}

	private function onVolumeSliderValueChanged(e_ : SliderEvent) : Void {
		_mvcController.setVolume(e_.getTarget().getValue());
	}

	private function onPlayerStatusChanged(e_ : MediaPlayerEvent) : Void {
		if(_togglePlayButton) {
			_togglePlayButton.setOn(e_.getTarget().getPlaying(), false);
		}
	}

	private function onPlayerPositionChanged(e_ : MediaPlayerEvent) : Void {
		if(_progressBar) {
			_progressBar.setValue(e_.getTarget().getRelativePlayheadPositon(), false);
		}
		if(_timeTextField) {
			_timeTextField.setText(formatTime(e_.getTarget().getAbsolutePlayheadPosition()));
		}
	}
	
	private function onPlayerLoadStart(e_:LoadEvent):Void {
		if(_progressBar) {
			_progressBar.setSelectableMax(0);
		}
		if(_loadingDisplay) {
			_loadingDisplay.setBufferPercentage(0);
			_loadingDisplay.show();
		}
	}

	private function onPlayerLoadProgress(e_ : LoadEvent) : Void {
		if(_progressBar) {
			_progressBar.setSelectableMax(e_.getTarget().getPercentLoaded());
		}
		
		if(_loadingDisplay) {
			_loadingDisplay.setBufferPercentage(e_.getTarget().getPercentLoaded());
			_loadingDisplay.show();
		}
	}
	
	private function onPlayerLoadComplete(e_:LoadEvent):Void {
		if(_progressBar) {
			_progressBar.setSelectableMax(100);
		}
		if(_loadingDisplay) {
			_loadingDisplay.setBufferPercentage(100);
			_loadingDisplay.hide();
		}
	}

	private function onVolumeChanged(e_ : MediaPlayerEvent) : Void {
		var vol:Number = e_.getTarget().doGetVolume();
		if(_volumeController) {
			_volumeController.setValue(vol, false);
		}
		if(_muteButton) {
			_muteButton.setOn(vol == 0);
		}
	}

	private function onFullscreenChanged(e_ : MediaPlayerEvent) : Void {
		if(_fullscreenButton) {
			_fullscreenButton.setOn(e_.getTarget().getFullscreen(), false);
		}
	}
	
	private function onStartBuffering(e_:BufferEvent):Void {
		if(_bufferDisplay) {
			_bufferDisplay.setBufferPercentage(0);
			_bufferDisplay.show();
		}
		if(_togglePlayButton) {
			_togglePlayButton.setEnabled(false);
		}
	}
	
	private function onStopBuffering(e_:BufferEvent):Void {
		if(_bufferDisplay) {
			_bufferDisplay.setBufferPercentage(100);
			_bufferDisplay.hide();
		}
		if(_togglePlayButton) {
			_togglePlayButton.setEnabled(true);
		}
	}
	
	private function onBufferProgress(e_:BufferEvent):Void {
		if(_bufferDisplay) {
			_bufferDisplay.setBufferPercentage(e_.getTarget().getBufferPercent());
		}
	}

	private function volumeUp() : Void {
		_mvcController.changeVolume(10);
	}

	private function volumeDown() : Void {
		_mvcController.changeVolume(-10);
	}

	private function togglePlay() : Void {
		_mvcController.togglePlay();
	}

	private function stopMedia() : Void {
		_mvcController.doStop();
	}

	private function previous() : Void {
		_mvcController.playPrevious();
	}

	private function next() : Void {
		_mvcController.playNext();
	}

	private function skipForward() : Void {
		_mvcController.skipForward();
	}

	private function skipBack() : Void {
		_mvcController.skipBack();
	}

	private function toggleFullscreen() : Void {
		_mvcController.toggleFullscreen();
	}
	
	private function toggleMute():Void {
		_mvcController.toggleMute();
	}

	private function formatTime(time_ : Number) : String {
		if(time_ < 0 || time_ == null || isNaN(time_)) {
			return null;
		}
		var seconds : Number = time_;
		var min : Number = Math.floor( seconds/60 );
		var sec : Number = Math.floor( seconds % 60 );

		var s : String = "";
		s += (min < 10) ? "0" + min : min;
		s += ":";
		s += (sec < 10) ? "0" + sec : sec;
		return s;
	}
}