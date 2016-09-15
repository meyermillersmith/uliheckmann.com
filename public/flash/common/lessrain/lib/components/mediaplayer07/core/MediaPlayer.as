import lessrain.lib.components.mediaplayer07.core.AbstractMediaPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.AudioPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.Bandwidth;
import lessrain.lib.components.mediaplayer07.core.ChunkedVideoPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.IMediaPlayerFeedable;
import lessrain.lib.components.mediaplayer07.core.ImageViewerFactory;
import lessrain.lib.components.mediaplayer07.core.MVCController;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.core.SWFPlayerFactory;
import lessrain.lib.components.mediaplayer07.core.VideoPlayerFactory;
import lessrain.lib.components.mediaplayer07.display.IViewUIBuilder;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.events.BufferEvent;
import lessrain.lib.components.mediaplayer07.events.LoadEvent;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.logger.LogManager;


/**
 * Use the Media Player to playback FLVs, sounds, images or timeline SWFs
 * 
 * <p><b>Usage:</b>
 * <pre>
 * // Create media player instance
 * var myPlayer:MediaPlayer = new MediaPlayer(_targetMC, MediaPlayer.MEDIA_SCALE_BEST_FIT | MediaPlayer.AUTO_PLAY | MediaPlayer.FULLSCREEN_SAME_WINDOW | MediaPlayer.VIEW_SIZE_PACK);
 * 
 * // Assign a skin factory
 * myPlayer.skinFactory = new SkinFactory();
 * 
 * // Assign the default ui builder
 * myPlayer.setViewUIBuilder(new DefaultViewUIBuilder());
 * myPlayer.showMedia(Media.createSimpleVideo("path/to/video.flv", 320, 240));</pre>
 * 
 * <p><b>Events:</b>
 * <ul>
 * <li>MediaPlayerEvent.STATUS_CHANGE</li>
 * <li>MediaPlayerEvent.PLAYER_START</li>
 * <li>MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE</li>
 * <li>MediaPlayerEvent.PLAYER_END</li>
 * <li>MediaPlayerEvent.FULLSCREEN_CHANGE</li>
 * <li>MediaPlayerEvent.VOLUME_CHANGE</li>
 * <li>MediaPlayerEvent.PLAY_NEXT</li>
 * <li>MediaPlayerEvent.PLAY_PREVIOUS</li>
 * <li>BufferEvent.BUFFER_EMPTY</li>
 * <li>BufferEvent.BUFFER_PROGRESS</li>
 * <li>BufferEvent.BUFFER_FULL</li>
 * <li>LoadEvent.LOAD_START</li>
 * <li>LoadEvent.LOAD_PROGRESS</li>
 * <li>LoadEvent.LOAD_COMPLETE</li>
 * </ul>
 * 
 * @see MediaPlayerEvent
 * @see BufferEvent
 * @see LoadEvent
 * 
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.MediaPlayer implements IDistributor {
	
	/**
	 * Style bit:
	 * Adjust media to the player size, media is completely visible. Media may 
	 * not fill the whole display panel
	 */
	public static var MEDIA_SCALE_BEST_FIT:Number = 1 << 0;
	
	/**
	 * Style bit:
	 * Media may be scaled down to fit small display panels, but it will not be 
	 * scaled up
	 */
	public static var MEDIA_NO_SCALE_UP:Number = 1 << 1;
	
	/**
	 * Style bit:
	 * Media will be scaled so that it fills the whole display panel. Parts of 
	 * the media may be cropped
	 */
	public static var MEDIA_SCALE_FILL:Number = 1 << 2;
	
	/**
	 * Style bit:
	 * Media will never be scaled
	 */
	public static var MEDIA_NO_SCALE:Number = 1 << 3;
	
	/**
	 * Style bit:
	 * Media player will decide if MEDIA_SCALE_BEST_FIT or MEDIA_SCALE_FILL will
	 * be applied. If the player would only crop a small part, MEDIA_SCALE_FILL
	 * will be used.
	 * @see View#processResizeScale
	 */
	public static var MEDIA_SCALE_AUTO:Number = 1 << 4;
	
	/**
	 * Style bit:
	 * The view will be packed when all elements have been created, so the
	 * number and dimensions of the elements (display panel, control panel,
	 * control items) affect the resulting view size.
	 */
	public static var VIEW_SIZE_PACK:Number =  1 << 5;
	
	/**
	 * Style bit:
	 * A fixed view size is defined, the view size doensn't depend on the
	 * dimensions of the elements (display panel, control panel, control items).
	 * If VIEW_SIZE_FIX is set, use <code>setDefaultSize()</code> to specify
	 * the view size.
	 * 
	 * @see	MediaPlayer#setDefaultSize
	 */
	public static var VIEW_SIZE_FIX:Number = 1 << 6;
	
	/**
	 * Style bit:
	 * The media playback starts immediately
	 */
	public static var AUTO_PLAY:Number = 1 << 7;
	
	/**
	 * Style bit:
	 * The playhead will be set to the beginning after the media has finished
	 * playing
	 */
	public static var AUTO_REWIND:Number = 1 << 8;
	
	/**
	 * Style bit:
	 * The media loops
	 */
	public static var LOOP:Number = 1 << 9;
	
	/**
	 * Style bit:
	 * The media player's fullscreen feature is disabled. Even if a fullscreen
	 * button is added to the control panel in the View UI Builder, the button
	 * will neither be displayed nor will the keybaord shortcut work.
	 * 
	 * @see lessrain.lib.components.mediaplayer07.display.FullscreenControl
	 */
	public static var FULLSCREEN_DISABLED:Number = 1 << 10;
	
	/**
	 * Style bit:
	 * The fullscreen player will be opened in a seperate fullscreen popup
	 * window.
	 * <p>NOTE: To make this work, you have to provide several files:
	 * <ul><li>Standalone SWF that contains the mediaplayer</li>
	 * <li>Standalone HTML to embed the standalone swf</li>
	 * <li>JavaScript function that opens the SWF in a popup</li>
	 * <li>Additional resources such as assets.xml etc. for the standalone player
	 * to work</li></ul>
	 * 
	 * @see lessrain.lib.components.mediaplayer07.display.FullscreenControl
	 */
	public static var FULLSCREEN_POPUP:Number = 1 << 11;
	
	/**
	 * Style bit:
	 * The fullscreen player will fill the entire SWF Stage.
	 * <p>NOTE: You have to take care of swapping depths to make the player be 
	 * the topmost item while switched to fullscreen mode.
	 * 
	 * @see lessrain.lib.components.mediaplayer07.display.FullscreenControl
	 */
	public static var FULLSCREEN_SAME_WINDOW:Number = 1 << 12;
	
	/**
	 * Style bit:
	 * The player tries to switch to Flash's native fullscreen mode (available
	 * for Flash player version 9.0.28.0 and newer). If the Flash player doesn't
	 * support the native fullscreen mode, a fullscreen popup will be opened.
	 * <p>NOTE: To use the native fullscreen mode, the Flash parameter
	 * "allowFullscreen" must be set to "true".
	 * 
	 * @see lessrain.lib.components.mediaplayer07.display.FullscreenControl
	 */
	public static var FULLSCREEN_AUTO:Number = 1 << 13;
	
	/**
	 * Style bit:
	 * If a preview image is found, the player forces the preview image to be
	 * the same size as the master. Note that the preview image will appear
	 * distorted if the preview aspect ratio is different from the master's
	 * aspect ratio.
	 * <p>The player's scale mode will not take effect if previewScaleMode is
	 * set to PREVIEW_FORCE_SAME_SIZE.
	 * 
	 * @see MediaPlayer#previewScaleMode
	 */
	public static var PREVIEW_FORCE_SAME_SIZE:Number = 1 << 14;
	
	/**
	 * Style bit:
	 * If a preview image is found, the player treats the preview image in the
	 * same way as the master to adjust the size to the display panel.
	 * <p>If neither PREVIEW_FORCE_SAME_SIZE nor PREVIEW_INDIVIDUAL_SCALE is
	 * set, previewScaleMode is set to PREVIEW_INDIVIDUAL_SCALE by default.
	 * 
	 * @see MediaPlayer#scaleMode
	 * @see MediaPlayer#previewScaleMode
	 */
	public static var PREVIEW_INDIVIDUAL_SCALE:Number = 1 << 15;
	
	private var _targetMC:MovieClip;
	private var _player:AbstractMediaPlayer;
	private var _controller:MVCController;
	private var _media : IMediaPlayerFeedable;
	private var _view:View;
	private var _viewUIBuilder:IViewUIBuilder;
	private var _skinFactory:ISkinFactory;
	
	private var _autoPlay:Boolean;
	private var _autoRewind:Boolean;
	private var _loop:Boolean;
	private var _volume:Number;
	private var _fullscreen:Boolean;
	private var _scaleMode:Number;
	private var _viewSizeMode:Number;
	private var _fullscreenMode:Number;
	private var _previewScaleMode:Number;
	private var _bandwidth:Bandwidth;
	private var _defaultSize:Size;
	private var _loadingPriority:Number;
	
	/*
	 * Stage width and height of the flash movie. We use these values to calculate
	 * the offsets when changing to fullscreen mode.
	 */
	private var _stageWidth:Number;	private var _stageHeight:Number;

	private var _eventDistributor:EventDistributor;
	
	/**
	 * Constructor
	 * @param	targetMC_	Target clip
	 * @param	settings_	Mediaplayer style bit settings
	 */
	public function MediaPlayer(targetMC_:MovieClip, settings_:Number) {
		_eventDistributor = new EventDistributor();
		
		_targetMC = targetMC_;
		
		// Process setting bits: media scale mode
		if((settings_ & MEDIA_NO_SCALE) != 0) _scaleMode = MEDIA_NO_SCALE;
		if((settings_ & MEDIA_NO_SCALE_UP) != 0) _scaleMode = MEDIA_NO_SCALE_UP;		if((settings_ & MEDIA_SCALE_BEST_FIT) != 0) _scaleMode = MEDIA_SCALE_BEST_FIT;		if((settings_ & MEDIA_SCALE_FILL) != 0) _scaleMode = MEDIA_SCALE_FILL;		if((settings_ & MEDIA_SCALE_AUTO) != 0) _scaleMode = MEDIA_SCALE_AUTO;
		if(_scaleMode == null) _scaleMode = MEDIA_SCALE_BEST_FIT;
		
		// view size mode
		if((settings_ & VIEW_SIZE_PACK) != 0) _viewSizeMode = VIEW_SIZE_PACK;
		if((settings_ & VIEW_SIZE_FIX) != 0) _viewSizeMode = VIEW_SIZE_FIX;
		if(_viewSizeMode == null) _viewSizeMode = VIEW_SIZE_PACK;
		
		// fullscreen mode
		if((settings_ & FULLSCREEN_AUTO) != 0) _fullscreenMode = FULLSCREEN_AUTO;		if((settings_ & FULLSCREEN_DISABLED) != 0) _fullscreenMode = FULLSCREEN_DISABLED;		if((settings_ & FULLSCREEN_POPUP) != 0) _fullscreenMode = FULLSCREEN_POPUP;		if((settings_ & FULLSCREEN_SAME_WINDOW) != 0) _fullscreenMode = FULLSCREEN_SAME_WINDOW;
		if(_fullscreenMode == null) _fullscreenMode = FULLSCREEN_AUTO;
		
		// preview scale mode
		if(settings_ & PREVIEW_FORCE_SAME_SIZE != 0) _previewScaleMode = PREVIEW_FORCE_SAME_SIZE;		if(settings_ & PREVIEW_INDIVIDUAL_SCALE != 0) _previewScaleMode = PREVIEW_INDIVIDUAL_SCALE;
		if(_previewScaleMode == null) _previewScaleMode = PREVIEW_INDIVIDUAL_SCALE;
		
		// playback settings
		_autoPlay = (settings_ & AUTO_PLAY) != 0;
		_autoRewind = (settings_ & AUTO_REWIND) != 0;
		_loop = (settings_ & LOOP) != 0;
	}
	
	/**
	 * Define ViewUIBuilder. Every MediaPlayer must be configured with one 
	 * custom UI builder. There is a default UI builder that can be used as a
	 * template.
	 * @see	DefaultUIBuilder
	 * 
	 * @param	viewUIBuilder	View UI Builder
	 */
	public function setViewUIBuilder(viewUIBuilder_:IViewUIBuilder):Void {
		_viewUIBuilder = viewUIBuilder_;
	}
	
	/**
	 * Get View UI Builder instance
	 * @return	View UI Builder
	 */
	public function getViewUIBuilder():IViewUIBuilder {
		return _viewUIBuilder;
	}
	
	/**
	 * Show media item
	 * @param	mediaItem	Media item to be displayed
	 */
	public function showMedia(mediaToShow_:IMediaPlayerFeedable):Void {
		if(mediaToShow_ == null) {
			LogManager.error("No media item specified.");
			return;
		}
		if(_viewUIBuilder == null) {
			LogManager.error("No View Builder specified. Unable to show media.");
			return;
		}
		
		var autoPlay:Boolean = getAutoPlay(); 
		var autoRewind:Boolean = getAutoRewind(); 
		var loop:Boolean = getLoop();
		var volume:Number = getVolume();
		var loadingPriority:Number = getLoadingPriority();
		
		/*
		 * Kill player if it already exists
		 */ 
		reset();
		
		_media = mediaToShow_;
		var factory:AbstractMediaPlayerFactory;
		var type:String = _media.getMasterType();
		switch (type) {
			
			case DataFile.TYPE_VIDEO:
				factory = VideoPlayerFactory.create(this);
				break;
			
			case DataFile.TYPE_IMAGE:
				factory = ImageViewerFactory.create(this);
				break;

			case DataFile.TYPE_AUDIO:
				factory = AudioPlayerFactory.create(this);
				break;

			case DataFile.TYPE_FLASH:
				factory = SWFPlayerFactory.create(this);
				break;
			
			case DataFile.TYPE_CHUNKED_VIDEO:
				factory = ChunkedVideoPlayerFactory.create(this);
				break;
		}
		
		_player = factory.getPlayer();
		_view = factory.getView();
		_controller = new MVCController(_player);
		_view.setModel(_player);
		_view.setMVCController(_controller);

		if(_defaultSize != null) {
			_view.setDefaultSize(_defaultSize);
		}
		_view.resize();
		
		// add listeners
		var playerEventProxy:Function = Proxy.create(this, onPlayerEvent);
		_controller.addEventListener(MediaPlayerEvent.STATUS_CHANGE, playerEventProxy);
		_controller.addEventListener(MediaPlayerEvent.FULLSCREEN_CHANGE, playerEventProxy);
		_controller.addEventListener(MediaPlayerEvent.PLAYER_START, playerEventProxy);
		_controller.addEventListener(MediaPlayerEvent.PLAYER_END, playerEventProxy);
		_controller.addEventListener(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, playerEventProxy);
		_controller.addEventListener(MediaPlayerEvent.VOLUME_CHANGE, playerEventProxy);
		_controller.addEventListener(MediaPlayerEvent.PLAY_NEXT, playerEventProxy);
		_controller.addEventListener(MediaPlayerEvent.PLAY_PREVIOUS, playerEventProxy);		_controller.addEventListener(MediaPlayerEvent.CHUNK_CHANGE, playerEventProxy);

		_controller.addEventListener(BufferEvent.BUFFER_EMPTY, playerEventProxy);
		_controller.addEventListener(BufferEvent.BUFFER_FULL, playerEventProxy);		_controller.addEventListener(BufferEvent.BUFFER_PROGRESS, playerEventProxy);

		_controller.addEventListener(LoadEvent.LOAD_START, playerEventProxy);
		_controller.addEventListener(LoadEvent.LOAD_PROGRESS, playerEventProxy);
		_controller.addEventListener(LoadEvent.LOAD_COMPLETE, playerEventProxy);		
		
		// apply stored player properties
		_player.setAutoPlay(autoPlay);
		_player.setAutoRewind(autoRewind);
		_player.setLoop(loop);
		_player.doSetVolume(volume);
		_player.setLoadingPriority(loadingPriority);
		
		// and start loading the media file
		_player.loadFile(_bandwidth);
	}
	
	/**
	 * Get player instance
	 * @return	Player instance
	 */
	public function getPlayer():AbstractMediaPlayer {
		return _player;
	}
	
	/**
	 * Get view
	 * @return	View instance
	 */
	public function getView():View {
		return _view;
	}
	
	/**
	 * @see AbstractMediaPlayer#getAutoPlay
	 */
	public function getAutoPlay():Boolean {
		if(_player != null) {
			_autoPlay = _player.getAutoPlay();
			return _autoPlay;
		}
		if(_autoPlay != null) {
			return _autoPlay;
		}
		return AbstractMediaPlayer.DEFAULT_AUTO_PLAY;
	}
	
	/**
	 * @see AbstractMediaPlayer#setAutoPlay
	 */
	public function setAutoPlay(autoPlay_:Boolean):Void {
		_autoPlay = autoPlay_;
		if(_player != null) {
			_player.setAutoPlay(_autoPlay);
		}
	}
	
	/**
	 * @see AbstractMediaPlayer#getAutoRewind
	 */
	public function getAutoRewind():Boolean {
		if(_player != null) {
			_autoRewind = _player.getAutoRewind();
			return _autoRewind;
		}
		if(_autoRewind != null) {
			return _autoRewind;
		}
		return AbstractMediaPlayer.DEFAULT_AUTO_REWIND;
	}
	
	/**
	 * @see AbstractMediaPlayer#setAutoRewind
	 */
	public function setAutoRewind(autoRewind_:Boolean):Void {
		_autoRewind = autoRewind_;
		if(_player != null) {
			_player.setAutoRewind(_autoRewind);
		}
	}
	
	/**
	 * @see AbstractMediaPlayer#getFullscreen
	 */
	public function getFullscreen():Boolean {
		if(_player != null) {
			_fullscreen = _player.getFullscreen();
			return _fullscreen;
		}
		if(_fullscreen != null) {
			return _fullscreen;
		}
		return AbstractMediaPlayer.DEFAULT_FULLSCREEN;
	}
	
	/**
	 * @see AbstractMediaPlayer#setFullscreen
	 */
	public function setFullscren(fullscreen_:Boolean):Void {
		_fullscreen = fullscreen_;
		if(_controller != null) {
			_controller.setFullscreen(_fullscreen);
		}
	}
	
	/**
	 * @see AbstractMediaPlayer#getLoop
	 */
	public function getLoop():Boolean {
		if(_player != null) {
			_loop = _player.getLoop();
			return _loop;
		}
		if(_loop != null) {
			return _loop;
		}
		return AbstractMediaPlayer.DEFAULT_LOOP;
	}
	
	/**
	 * @see AbstractMediaPlayer#setLoop
	 */
	public function setLoop(loop_:Boolean):Void {
		_loop = loop_;
		if(_player != null) {
			_player.setLoop(_loop);
		}
	}
	
	/**
	 * @see AbstractMediaPlayer#getLoop
	 */
	public function getBandwidth():Bandwidth {
		if(_player != null) {
			_bandwidth = _player.getBandwidth();
			return _bandwidth;
		}
		return _bandwidth || Bandwidth.HIGH;
	}
	
	/**
	 * @see AbstractMediaPlayer#setBandwidth
	 */
	public function setBandwidth(bandwidth_:Bandwidth):Void {
		if(_bandwidth == bandwidth_) {
			return;
		}
		_bandwidth = bandwidth_;	
		if(_player != null) {
			showMedia(_media);
		}
	}
	
	/**
	 * @see AbstractMediaPlayer#getLoadingPriority
	 */
	public function getLoadingPriority():Number {
		if(_player != null) {
			_loadingPriority = _player.getLoadingPriority();
			return _loadingPriority;
		}
		if(_loadingPriority != null) {
			return _loadingPriority;
		}
		return AbstractMediaPlayer.DEFAULT_LOADING_PRIORITY;
	}
	
	/**
	 * @see AbstractMediaPlayer#setLoadingPriority
	 */
	public function setLoadingPriority(loadingPriority_:Number):Void {
		_loadingPriority = loadingPriority_;
		if(_player != null) {
			_player.setLoadingPriority(_loadingPriority);
		}
	}
	
	
	/**
	 * @see AbstractMediaPlayer#getVolume
	 */
	public function getVolume():Number {
		if(_player != null && _player.doGetVolume() != null) {
			_volume = _player.doGetVolume();
			return _volume;
		}
		if(_volume != null) {
			return _volume;
		}
		return AbstractMediaPlayer.DEFAULT_VOLUME;
	}
	
	/**
	 * @see AbstractMediaPlayer#setVolume
	 */
	public function setVolume(volume_:Number):Void {
		_volume = volume_;
		if(_controller != null) {
			_controller.setVolume(_volume);
		}
	}
	
	/**
	 * Set the player's default size
	 * @param	size_	Default player size
	 * @see				MediaPlayer#VIEW_SIZE_FIX
	 */
	public function setDefaultSize(size_:Size):Void {
		_defaultSize = size_;
		if(_view != null) {
			_view.setDefaultSize(_defaultSize);
		}
	}

	/**
	 * Get the MVC Controller
	 *  @return	MVC Controller
	 */	
	public function getController():MVCController {
		return _controller;
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		reset();
		_targetMC.removeMovieClip();
		_eventDistributor.finalize();
	}
	
	// IEventDistributor methods	
	public function addEventListener(type : String, func : Function) : Void {
		_eventDistributor.addEventListener(type, func );
	}
	
	public function removeEventListener(type : String, func : Function) : Void {
		_eventDistributor.removeEventListener(type, func );
	}
	
	public function distributeEvent(eventObject : IEvent) : Void {
		_eventDistributor.distributeEvent(eventObject );
	}
	
	/**
	 * Reset player
	 */
	private function reset():Void {
		if(_player != null) {
			_player.setFullscreen(false);
			_player.finalize();
		}
		if(_view != null) {
			_view.finalize();
		}
		if(_controller != null) {
			_controller.finalize();
		}
	}
	
	/**
	 * Re-distribute player events
	 */
	private function onPlayerEvent(e_:IEvent):Void {
		_eventDistributor.distributeEvent(e_);
	}

	// Getter & setter
	
	public function get targetMC():MovieClip { return _targetMC; }
	
	public function get skinFactory():ISkinFactory { return _skinFactory; }
	public function set skinFactory(value:ISkinFactory):Void { _skinFactory=value; }
	
	public function get fullscreenMode():Number { return _fullscreenMode; }
	public function set fullscreenMode(fullscreenMode_:Number):Void { _fullscreenMode = fullscreenMode_; }
	
	public function get scaleMode():Number { return _scaleMode; }
	public function set scaleMode(scaleMode_:Number):Void { _scaleMode = scaleMode_; }
	
	public function get viewSizeMode():Number { return _viewSizeMode; }
	public function set viewSizeMode(viewSizeMode_:Number):Void { _viewSizeMode = viewSizeMode_; }
	
	public function get previewScaleMode():Number { return _previewScaleMode; }
	public function set previewScaleMode(previewScaleMode_:Number):Void { _previewScaleMode = previewScaleMode_; }
	
	public function get media():Media { 
		return _media.getCurrentMedia(); 
	}
	
	/*
	 * Not nice, but to keep backwards compatibility I introduced this one to be
	 * able to get the chunked media source. Normally I would have changed
	 * get media(), but many projects rely on that method returning a Media
	 * instance and not an IMediaPlayerFeedable.
	 */
	public function get mediaFeed() : IMediaPlayerFeedable {
		return _media;
	}

	public function get stageWidth():Number {
		var w:Number = _stageWidth;
		if(w == null) {
			LogManager.warning("MediaPlayer.stageWidth has not been set yet. Default width of 600 is assumed. Set stageWidth to correct the result!");
			w = 600;
		}
		return w;
	}
	public function set stageWidth(stageWidth_:Number):Void { _stageWidth = stageWidth_; }
	
	public function get stageHeight():Number {
		var h:Number = _stageHeight;
		if(h == null) {
			LogManager.warning("MediaPlayer.stageHeight has not been set yet. Default height of 400 is assumed. Set stageHeight to correct the result!");
			h = 400;
		}
		return h;
	}
	public function set stageHeight(stageHeight_:Number):Void { _stageHeight = stageHeight_; }
}
