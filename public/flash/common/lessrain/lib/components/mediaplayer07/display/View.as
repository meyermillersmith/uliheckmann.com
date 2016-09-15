import lessrain.lib.components.mediaplayer07.display.ChunkedVideoPlayerView;

import flash.geom.Point;
import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.controls.ControlPanel;
import lessrain.lib.components.mediaplayer07.controls.ControlType;
import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.core.MediaXMLUtils;
import lessrain.lib.components.mediaplayer07.core.MVCController;
import lessrain.lib.components.mediaplayer07.display.AudioPlayerView;
import lessrain.lib.components.mediaplayer07.display.DisplayPanel;
import lessrain.lib.components.mediaplayer07.display.FullscreenControl;
import lessrain.lib.components.mediaplayer07.display.ImageViewerView;
import lessrain.lib.components.mediaplayer07.display.IViewUIBuilder;
import lessrain.lib.components.mediaplayer07.display.SWFPlayerView;
import lessrain.lib.components.mediaplayer07.display.VideoPlayerView;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.components.mediaplayer07.events.ViewEvent;
import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.layout.AbstractLayoutHost;
import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.Map;
import lessrain.lib.utils.Proxy;

/**
 * The Media Player view. A view consists of a display panel that contains the
 * visible media (e.g. video or image) and a control panel.
 *  
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.View extends AbstractLayoutHost {
	
	public static var DEFAULT_SIZE:Size = new Size(320, 240);
	
	/**
	 * Scale factor tolerance percentage
	 * <p>If scale mode is set to MEDIA_SCALE_AUTO, the difference between hScale
	 * and vScale is compared to the lower of both values.
	 * MEDIA_SCALE_FILL behaviour is applied if the difference is within the range,
	 * MEDIA_SCALE_BEST_FIT if the difference is too big.
	 * 
	 * @see View#processResizeScale
	 * @see MediaPlayer#MEDIA_SCALE_AUTO
	 */
	private static var AUTO_SIZE_SCALE_DIFF_THRESHOLD:Number = .1;
	
	private var _mediaPlayer:MediaPlayer;
	private var _model:AbstractMediaPlayer;
	private var _controller:MVCController;
//	private var _previewContainer:MovieClip;
	private var _displayPanel:DisplayPanel;
	private var _controlPanel:ControlPanel;
	
	private var _isPlaying:Boolean;
	private var _isFullScreen:Boolean;
	private var _oldPos : Point;
	private var _uiBuilder:IViewUIBuilder;
	private var _fullscreenControl:FullscreenControl;
	
	private var _viewControlMap:Map;
		private var _stageResizeListener:Object; // stage resize listener
	private var _stageFullscreenListener:Object; // stage fullscreen listener
	
	public function View(mediaPlayer_:MediaPlayer) {
		
		_mediaPlayer = mediaPlayer_;
		
		setDefaultSize(DEFAULT_SIZE);
		setTarget(_mediaPlayer.targetMC.createEmptyMovieClip("view", _mediaPlayer.targetMC.getNextHighestDepth()));
		
		// Stage.onResize listener
		_stageResizeListener = { onResize: Proxy.create(this, resize) };
		
		// Stage.onFullScreen listener (native fullscreen mode, available in player 9.0.28 or later)
		_stageFullscreenListener = { onFullScreen : Proxy.create(this, onStageFullScreenChanged) };
		
		Stage.addListener(_stageResizeListener);
		Stage.addListener(_stageFullscreenListener);
		
		_fullscreenControl = new FullscreenControl(this);
		_fullscreenControl.addEventListener(MediaPlayerEvent.FULLSCREEN_POPUP_CLOSED, Proxy.create(this, onExternalWindowClosed));
	}
	
	/**
	 * Get underlying media player instance
	 * @return Media player
	 */	
	public function getMediaPlayer():MediaPlayer {
		return _mediaPlayer;
	}
	
	/**
	 * Set ViewUIBuilder
	 * @param	uiBuilder	IViewUIBuilder instance
	 */
	public function setUIBuilder(uiBuilder_:IViewUIBuilder):Void {
		_uiBuilder = uiBuilder_;
	}

	/**
	 * Delegate the creation of user interface elements to IViewUIBuilder
	 * instance
	 * @param	skinfactory_	Skin factory
	 */
	public function buildUI(skinFactory_:ISkinFactory):Void {
		if(_uiBuilder == null) {
			LogManager.error("No ViewUIBuilder specified. Unable to create view UI.");
			return;
		}
		_uiBuilder.buildUI(this, skinFactory_);
		
//		// Attach preview container
//		var target:MovieClip = _displayPanel.getMediaContainer().getTarget();
//		_previewContainer = target.createEmptyMovieClip("preview", target.getNextHighestDepth());	}
	
	/**
	 * Adjust the view size
	 */
	public function resize():Void {
		updateLayout();
		resizePreview();
		
		_eventDistributor.distributeEvent(new ViewEvent(ViewEvent.RESIZE, this));
		
		// Overwrite the media specific resize behaviour in View's subclasses.
	}

	/**
	 * Get model (AbstractMediaPlayer instance)
	 * @return AbstractMediaPlayer instance
	 */
	public function getModel():AbstractMediaPlayer {
		return _model;
	}
	
	/**
	 * Assign a model to the view
	 * @param	model_	AbstractMediaPlayer instance
	 */
	public function setModel(model_:AbstractMediaPlayer) : Void {
		_model = model_;
	}
	
	/**
	 * Get MVC controller
	 * @return MVC controller
	 */
	public function getMVCController():MVCController {
		return _controller;
	}
	
	/**
	 * Set MVC controller
	 * @param	controller_	MVC controller
	 */
	public function setMVCController(controller_:MVCController):Void {
		_controller = controller_;
		_controlPanel.setMVCController(_controller);
		
		_controller.addEventListener(MediaPlayerEvent.FULLSCREEN_CHANGE, Proxy.create(this, onFullScreenChanged));
	}
	
	/**
	 * Get control panel
	 * @return control panel
	 */
	public function getControlPanel():ControlPanel {
		return _controlPanel;
	}
	
	/**
	 * Set control panel
	 * @param	controlPanel_	control panel
	 * @return					<code>true</code> if the control panel has been
	 * 							registered
	 */
	public function setControlPanel(controlPanel_:ControlPanel):Boolean {
		if(_controlPanel != null) {
			return false;
		}
		_controlPanel = controlPanel_;
		// if we already have an MVC controller, tell the control panel about it
		if(_controller != null) {
			_controlPanel.setMVCController(_controller);
		}
		
		return true;
	}
	
	/**
	 * Get display panel
	 * @return display	panel
	 */
	public function getDisplayPanel():DisplayPanel {
		return _displayPanel;
	}
	
	/**
	 * Set display panel
	 * @param	displayPanel_	display panel
	 * @return					<code>true</code> if the display panel has been
	 * 							registered 
	 */
	public function setDisplayPanel(displayPanel_:DisplayPanel):Boolean {
		if(_displayPanel != null) {
			return false;
		}
		_displayPanel = displayPanel_;
		return true;
	}
	
//	/**
//	 * Get preview container clip
//	 * @return preview container clip
//	 */
//	public function getPreviewContainer():MovieClip {
//		return _previewContainer;
//	}
	
	/**
	 * Get view type
	 * @return	View type
	 * @see		VideoPlayerView#TYPE	 * @see		ImageViewerView#TYPE	 * @see		AudioPlayerView#TYPE	 * @see		SWFPlayerView#TYPE
	 */
	public function getType():String { // abstract
		return null;
	}
	
	/**
	 * Set the default size for the view area. Calling setDefaultSize only has
	 * an effect if the view size is fixed.
	 * @see MediaPlayer#VIEW_SIZE_FIX 
	 * @see ILayoutable#setDefaultSize
	 * 
	 * @param	size_	Default view size
	 */
	public function setDefaultSize(size_:Size):Void {
		super.setDefaultSize(size_);
		resize();
	}
	
	public function setBoundaries(rect_:Rectangle):Void {
//		LogManager.debug("setBoundaries" + rect_.x + " " +  rect_.y + " " + rect_.width + " " + rect_.height);
		super.setBoundaries(rect_);
	}
	
	/**
	 * Finalize instance after use
	 */
	public function finalize() : Void {
		_displayPanel.finalize();
		_controlPanel.finalize();
		
		// remove listeners
		Stage.removeListener(_stageResizeListener);
		Stage.removeListener(_stageFullscreenListener);
		
		_fullscreenControl.finalize();
		getTarget().removeMovieClip();
		
		super.finalize();
	}
	
	/**
	 * Process the scale factor depending on the _scaleMode
	 * @return	Media scale factor
	 * @see		MediaPlayerSettings
	 */
	private function processResizeScale(nativeWidth_:Number, nativeHeight_:Number):Number {
		var displayWidth:Number = _displayPanel.getMediaContainer().getBoundaries().width;
		var displayHeight:Number = _displayPanel.getMediaContainer().getBoundaries().height;
		
		
		var scaleH:Number = displayWidth / nativeWidth_;
		var scaleV:Number = displayHeight / nativeHeight_;
		var scale:Number;
		
		switch (_mediaPlayer.scaleMode) {
			default:
			case MediaPlayer.MEDIA_SCALE_BEST_FIT:
				scale = Math.min(scaleH, scaleV);
				break;
			case MediaPlayer.MEDIA_NO_SCALE:
				scale = 1;
				break;
			case MediaPlayer.MEDIA_NO_SCALE_UP:
				scale = Math.min(1, Math.min(scaleH, scaleV));
				break;
			case MediaPlayer.MEDIA_SCALE_FILL:
				scale = Math.max(scaleH, scaleV);
				break;
			case MediaPlayer.MEDIA_SCALE_AUTO:
				var dScale:Number = Math.abs(scaleH - scaleV);
				if(Math.min(scaleH, scaleV) * .1 > dScale) {
					scale = Math.max(scaleH, scaleV);
				} else {
					scale = Math.min(scaleH, scaleV);
				}
		}

		return scale;
	}
	
	private function resizePreview():Void {
		var preview:DataFile = getModel().getMedia().getPreview();
		if(preview == null) {
			return;
		}
		
		var xScale:Number;
		var yScale:Number;

		if(_mediaPlayer.previewScaleMode == MediaPlayer.PREVIEW_FORCE_SAME_SIZE && getModel().getMedia().getMaster().type != DataFile.TYPE_AUDIO) {
			var masterFile:DataFile = getModel().getMedia().getMaster();
			var masterScale:Number = processResizeScale(masterFile.w, masterFile.h);
			
			xScale = masterFile.w * masterScale / preview.w;
			yScale = masterFile.h * masterScale / preview.h;
		} else {
			xScale = yScale = processResizeScale(preview.w, preview.h);
		}

		// scale the preview
		_displayPanel.getMediaContainer().getPreviewMC()._xscale = xScale * 100;
		_displayPanel.getMediaContainer().getPreviewMC()._yscale = yScale * 100;
		
		// center the preview
		var bounds:Rectangle = _displayPanel.getMediaContainer().getBoundaries();
		_displayPanel.getMediaContainer().getPreviewMC()._x = Math.floor((bounds.width - preview.w * xScale) / 2);
		_displayPanel.getMediaContainer().getPreviewMC()._y = Math.floor((bounds.height - preview.h * yScale) / 2);
		
	}
	
	private function onFullScreenChanged(e_:MediaPlayerEvent):Void {
		if(_mediaPlayer.fullscreenMode == MediaPlayer.FULLSCREEN_DISABLED) {
			return;
		}
		if(_isFullScreen == getModel().getFullscreen() || getModel().getFullscreen() == null) {
			return;
		}
		
		_isFullScreen = getModel().getFullscreen();
		
		// save current position
		if(_isFullScreen) {
			_oldPos = new Point(getTarget()._x, getTarget()._y);
		}

		// store current playing state
		_isPlaying = getModel().getPlaying();

		var media:XMLNode = MediaXMLUtils.media2XmlNode(_mediaPlayer.media);
		var mediaString:String = escape(media.toString());
		_fullscreenControl.mediaString = escape(mediaString);
		
		var state:Number = _fullscreenControl.changeFullscreen(_mediaPlayer.fullscreenMode, _isFullScreen);
		
		switch(state) {
			case FullscreenControl.STATE_NATIVE:
			case FullscreenControl.STATE_SAME_WINDOW:
				resize();
				break;
			case FullscreenControl.STATE_POPUP:
				// pause the movie
				if(_isPlaying) {
					getModel().doPause();
				}
				break;
			case FullscreenControl.STATE_OFF:
				resize();
				if(_isPlaying) {
					getModel().doResume();
				}
				break;
		}
	}
	
	private function calculateFullscreenOffset(target_:MovieClip):Object {
		var dx:Number;
		var dy:Number;
		
		/*
		 * Calculate the offset of the root movieclip relative to the Stage
		 */
		switch(Stage.align) {
			case "T": // "Top", h: center, v: top
				dx = (Stage.width - _mediaPlayer.stageWidth) / 2;
				dy = 0;
				break;
			case "B": // "Bottom", h: center, v: bottom
				dx = (Stage.width - _mediaPlayer.stageWidth) / 2;
				dy = Stage.height - _mediaPlayer.stageHeight;
				break;
			case "L": // "Left", h: left, v: center
				dx = 0;
				dy = (Stage.height - _mediaPlayer.stageHeight) / 2;
				break;
			case "R": // "Right", h: right, v: center
				dx = Stage.width - _mediaPlayer.stageWidth;
				dy = (Stage.height - _mediaPlayer.stageHeight) / 2;
				break;
			case "TL": // "Top Left", h: left, v: top
			case "LT":
				dx = 0;
				dy = 0;
				break;
			case "TR": // "Top Right", h: right, v: top
			case "RT":
				dx = Stage.width - _mediaPlayer.stageWidth;
				dy = 0;
				break;
			case "BL": // "Bottom Left", h: left, v: bottom
			case "LB":
				dx = 0;
				dy = Stage.height - _mediaPlayer.stageHeight;
				break;
			case "BR": // "Bottom Right", h: right, v: bottom
			case "RB":
				dx = Stage.width - _mediaPlayer.stageWidth;
				dy = Stage.height - _mediaPlayer.stageHeight;
				break;
			default: // "Center", h: center, v: center
				dx = (Stage.width - _mediaPlayer.stageWidth) / 2;
				dy = (Stage.height - _mediaPlayer.stageHeight) / 2;
				break;			
		}
		var origin:Object = { x: 0, y: 0 };
		target_.localToGlobal(origin);
		origin.x += dx;		origin.y += dy;
//		LogManager.debug("Stage.align: " + Stage.align + " dx " + dx + " dy " + dy);//		LogManager.inspectObject(origin);
		return { x: origin.x, y: origin.y };
	}
	
	private function onExternalWindowClosed():Void {
		getMVCController().setFullscreen(false);
	}

	private function updateLayout():Void {
		if(getTarget() == null || getLayout() == null) {
			return;
		}
		var isFullscreen:Boolean = getModel().getFullscreen();
		if(isFullscreen) {
			var offset:Object = calculateFullscreenOffset(getTarget());
			var rect:Rectangle = new Rectangle(getTarget()._x - offset.x, getTarget()._y - offset.y, Stage.width, Stage.height);
			setBoundaries(rect);
		} else {
			var defaultSize:Size = getDefaultSize();
			setBoundaries(new Rectangle(_oldPos.x, _oldPos.y, defaultSize.w, defaultSize.h));
			if(_mediaPlayer.viewSizeMode == MediaPlayer.VIEW_SIZE_PACK) {
				pack();
			}
//			switch(_mediaPlayer.viewSizeMode) {
//				case MediaPlayer.VIEW_SIZE_PACK:
//				default:
//					pack();
//					break;//				case MediaPlayer.VIEW_SIZE_FIX:
////					var rect:Rectangle = new Rectangle(getTarget()._x, getTarget()._y, getDefaultSize().w, getDefaultSize().h); 
//					break;
//			}
		}
	}
	
	/**
	 * Check if the a view has a given control
	 * @param	controlType_	Control type
	 * @return					<code>true</code> if control_ is assigned to the
	 * 							current view type
	 * @see ControlType
	 */
	public function hasControl(ctrlType_:String) : Boolean {
		// initially fill view control map
		if(_viewControlMap == null) {
			_viewControlMap = new Map();
			_viewControlMap.putAt(VideoPlayerView.TYPE, new Array(
				ControlType.TOGGLE_PLAY_SWITCH,
				ControlType.STOP_BUTTON,
				ControlType.PREV_BUTTON,
				ControlType.NEXT_BUTTON,
				ControlType.TIME_TEXTFIELD,
				ControlType.PROGRESS_SLIDER,
				ControlType.VOLUME_SLIDER,
				ControlType.MUTE_SWITCH,
				ControlType.FULLSCREEN_SWITCH,
				ControlType.BUFFERING_DISPLAY
			));
			_viewControlMap.putAt(AudioPlayerView.TYPE, new Array(
				ControlType.TOGGLE_PLAY_SWITCH,
				ControlType.STOP_BUTTON,
				ControlType.PREV_BUTTON,
				ControlType.NEXT_BUTTON,
				ControlType.TIME_TEXTFIELD,
				ControlType.PROGRESS_SLIDER,
				ControlType.VOLUME_SLIDER,
				ControlType.MUTE_SWITCH,
				ControlType.BUFFERING_DISPLAY
			));
			_viewControlMap.putAt(ImageViewerView.TYPE, new Array(
				ControlType.PREV_BUTTON,
				ControlType.NEXT_BUTTON,
				ControlType.FULLSCREEN_SWITCH,
				ControlType.LOADING_DISPLAY
			));
			_viewControlMap.putAt(SWFPlayerView.TYPE, new Array(
				ControlType.TOGGLE_PLAY_SWITCH,
				ControlType.STOP_BUTTON,
				ControlType.PREV_BUTTON,
				ControlType.NEXT_BUTTON,
				ControlType.PROGRESS_SLIDER,
				ControlType.VOLUME_SLIDER,
				ControlType.MUTE_SWITCH,
				ControlType.FULLSCREEN_SWITCH,
				ControlType.LOADING_DISPLAY
			));
			_viewControlMap.putAt(ChunkedVideoPlayerView.TYPE, new Array(
				ControlType.TOGGLE_PLAY_SWITCH,
				ControlType.STOP_BUTTON,
				ControlType.PREV_BUTTON,
				ControlType.NEXT_BUTTON,
				ControlType.TIME_TEXTFIELD,
				ControlType.PROGRESS_SLIDER,
				ControlType.VOLUME_SLIDER,
				ControlType.MUTE_SWITCH,
				ControlType.FULLSCREEN_SWITCH,
				ControlType.BUFFERING_DISPLAY
			));
		}
		return ArrayUtils.contains(Array(_viewControlMap.getAt(getType())), ctrlType_);
	}
	
	/**
	 * Stage.onFullScreen listener
	 */
	private function onStageFullScreenChanged(isFullscreen_:Boolean):Void {
		getMVCController().setFullscreen(isFullscreen_);
	}
}