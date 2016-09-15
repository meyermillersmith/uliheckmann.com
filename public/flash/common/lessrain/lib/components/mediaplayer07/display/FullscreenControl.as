import flash.external.ExternalInterface;

import lessrain.lib.components.mediaplayer07.core.MediaPlayer;
import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.logger.LogManager;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.FullscreenControl implements IDistributor {

	// Is native fullscreen mode supported? (Available for player 9.0.28 and later)
	public static var SUPPORTS_NATIVE_FS_MODE:Boolean = Stage["displayState"] != undefined;	
	// The different fullscreen states	
	public static var STATE_OFF:Number = 0;
	public static var STATE_POPUP:Number = 1;	public static var STATE_NATIVE:Number = 2;	public static var STATE_SAME_WINDOW:Number = 3;
	
	private var _currentState:Number = STATE_OFF;
	private var _mediaString:String;
	private var _view:View;
	
	private var _eventDistributor:EventDistributor;
	
	public function FullscreenControl(view_:View) {
		_view = view_;
		
		_eventDistributor = new EventDistributor();
	}
	
	public function changeFullscreen(mode_:Number, enable_:Boolean):Number {
		
		switch(mode_) {
			case MediaPlayer.FULLSCREEN_POPUP:
				popupFullscreen(enable_);
				break;
			case MediaPlayer.FULLSCREEN_SAME_WINDOW:
				sameWindowFullscreen(enable_);
				break;
			case MediaPlayer.FULLSCREEN_AUTO:
				if(SUPPORTS_NATIVE_FS_MODE) {
					nativeFullscreen(enable_);
				} else {
//					popupFullscreen(enable_);
					sameWindowFullscreen(enable_);
				}
				break;
		}
		return _currentState;
	}
	
	public function isFullscreen():Boolean {
		return _currentState != STATE_OFF;
	}
	
	public function onJSWinClose():Void {
		_currentState = STATE_OFF;
		_eventDistributor.distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.FULLSCREEN_POPUP_CLOSED, _view.getModel()));
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
	public function finalize():Void {
		_eventDistributor.finalize();
		for (var s : String in this) {
			delete this[s];
		}
	}
	
	private function popupFullscreen(active_:Boolean):Void {
		if(!active_) {
			// close popup window
			getURL("javascript:fsWin.close();");
		} else {
			if(_mediaString == null) {
				LogManager.warning("FullscreenMode.fullscreenPopup: unable to open js window. Set mediaString first.");
				return;
			}
			var wasSuccessful:Boolean = ExternalInterface.addCallback("onWindowClosed", FullscreenControl, onJSWinClose);
			
			// TODO media parameter might be too long to be sent via GET 
			var js:String = 
				"var fsWin;\n" +
				"function fullscreen() {\n" + 
				"	var w = screen.availWidth - 4;\n" +
				"	var h = screen.availHeight - 4;\n" +
				"	fsWin = window.open(\"standalone_player.html?media=" + _mediaString + "\", \"fsWin\", \"width=\" + w + \",height=\" + h + \",left=0,top=0\");\n" +
				"}\n" +
				"fullscreen();\n" +
				"";
			getURL("javascript:" + js + "void(0);", "_self");
		}
		
		_currentState = active_ ? STATE_POPUP : STATE_OFF;
	}
		
	private function nativeFullscreen(active_:Boolean):Void {
		// Flash player 9.0.28 and later know the property Stage.displayState
		
		// that controls the fullscreen mode.
		// If the player supports fullscreen mode, we use it here
		// to display the media at maximum size.
		// Otherwise do it the dirty way: open a new browser window,
		// resize it per javascript so that it fills the whole screen,
		// load a special standalone version of the media player and
		// tell it to load the current media item
		
		if(!SUPPORTS_NATIVE_FS_MODE) {
			LogManager.warning("FullscreenMode.nativeFullscreen: Native fullscreen mode is not supported");
			return;
		}
		Stage["displayState"] = active_ ? "fullScreen" : "normal";
		_currentState = active_ ? STATE_NATIVE : STATE_OFF;
	}
	
	private function sameWindowFullscreen(active_:Boolean):Void {
		_currentState = active_ ? STATE_SAME_WINDOW : STATE_OFF;
	}

	// Getter & setter
	
	public function get mediaString():String {
		return _mediaString;
	}
	
	public function set mediaString(mediaString_:String):Void {
		_mediaString = mediaString_;
	}
}