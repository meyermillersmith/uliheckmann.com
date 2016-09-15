﻿/** * @author Oliver List (o.list@lessrain.com) */import lessrain.lib.components.mediaplayer07.core.Bandwidth;import lessrain.lib.components.mediaplayer07.core.DataFile;import lessrain.lib.components.mediaplayer07.core.Media;import lessrain.lib.components.mediaplayer07.display.MediaPreview;import lessrain.lib.components.mediaplayer07.events.LoadEvent;import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;import lessrain.lib.components.mediaplayer07.model.AbstractMediaPlayer;import lessrain.lib.utils.loading.FileItem;import lessrain.lib.utils.loading.FileListener;import lessrain.lib.utils.loading.PriorityLoader;import lessrain.lib.utils.Proxy;class lessrain.lib.components.mediaplayer07.model.SWFPlayer extends AbstractMediaPlayer implements FileListener{	private var _swfContainer:MovieClip;	private var _sound:Sound;	private var _playheadPositionChangedEvent:MediaPlayerEvent;			/**	 * Constructor	 * 	 * @param	file_				Image DataFile	 * @param	swfContainer_		SWF container movieclip	 * @param	previewContainer_	Media preview container movieclip	 */	public function SWFPlayer( media_:Media, swfContainer_:MovieClip, previewContainer_:MovieClip ) {		super(media_, previewContainer_);				_swfContainer = swfContainer_;		_sound = new Sound(_swfContainer);		doSetVolume(AbstractMediaPlayer.DEFAULT_VOLUME);		_playheadPositionChangedEvent = new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_POSITION_CHANGE, this);	}		/**	 * @see AbstractMediaPlayer#loadFile	 */	public function loadFile(bandwidth_:Bandwidth) : Void	{		_bandwidth = bandwidth_;				// do we have a preview?		var preview:DataFile = getMedia().getPreview();		if(preview != null) {			_preview = new MediaPreview(_previewContainer, preview.src);			_preview.load(Proxy.create(this, doLoadSWF));			_preview.show();		} else {			doLoadSWF();		}	}		/**	 * @see AbstractMediaPlayer#scrubTo	 */	public function scrubTo( scrubValue_ : Number ) : Void	{		var pos : Number = Math.floor(_swfContainer._totalframes * scrubValue_ / 100);		_swfContainer.gotoAndStop(pos);		if(getState() == stoppedState) {			setState(pausedState);		}		distributeEvent(_playheadPositionChangedEvent);	}		/**	 * @see AbstractMediaPlayer#doSetVolume	 */	public function doSetVolume(volume_ : Number) : Void {		_volume = Math.min(100, Math.max(volume_, 0));		_sound.setVolume(_volume);		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.VOLUME_CHANGE, this));	}		/**	 * @see AbstractMediaPlayer#getPercentLoaded	 */	public function getPercentLoaded():Number {		return (_swfContainer.getBytesLoaded() > 10 ? (_swfContainer.getBytesLoaded() * 100 / _swfContainer.getBytesTotal()) : 0); 	}	/**	 * @see AbstractMediaPlayer#getAbsolutePlayheadPosition	 */	public function getAbsolutePlayheadPosition():Number {		return _swfContainer._currentframe;	}	/**	 * @see AbstractMediaPlayer#getRelativePlayheadPositon	 */	public function getRelativePlayheadPositon():Number {		var rel:Number = (_swfContainer._currentframe - 1) / (_swfContainer._totalframes - 1) * 100;		return rel;	}		/**	 * @see AbstractMediaPlayer#__doPlay	 */	public function __doPlay() : Void {		_swfContainer.play();		_swfContainer.onEnterFrame = Proxy.create(this, onSWFEnterFrame);		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));	}	/**	 * @see AbstractMediaPlayer#__doPause	 */	public function __doPause() : Void {		_swfContainer.stop();		delete _swfContainer.onEnterFrame;		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));	}	/**	 * @see AbstractMediaPlayer#__doResume	 */	public function __doResume() : Void {		__doPlay();	}	/**	 * @see AbstractMediaPlayer#__doStop	 */	public function __doStop() : Void {		resetMC(_swfContainer);		delete _swfContainer.onEnterFrame;		distributeEvent(_playheadPositionChangedEvent);		distributeEvent(new MediaPlayerEvent(MediaPlayerEvent.STATUS_CHANGE, this));	}		/**	 * @see AbstractMediaPlayer#finalize	 */	public function finalize():Void {		_eventDistributor.finalize();		_swfContainer.removeMovieClip();	} 		/*	 * FileListener methods	 */	public function onLoadStart(file : FileItem) : Boolean {		distributeEvent(new LoadEvent(LoadEvent.LOAD_START, this));		return false;	}	public function onLoadComplete(file : FileItem) : Void {		distributeEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE, this, _swfContainer.getBytesLoaded(), _swfContainer.getBytesTotal()));				_duration = _swfContainer._totalframes;		_swfContainer.gotoAndStop(1);				if(_autoPlay) {			doPlay();		} else {			doStop();		}	}	public function onLoadProgress(file : FileItem, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void {		if(!file.src == _media.getMaster().src) {			return;		}		distributeEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS, this, bytesLoaded, bytesTotal));	}		private function doLoadSWF():Void {		var src:String = _media.getMaster().src;		PriorityLoader.getInstance().addFile(_swfContainer, src, this, getLoadingPriority(), src, "Loading SWF");	}		private function resetMC(mc_:MovieClip):Void {		mc_.gotoAndStop(1);		for (var s : String in mc_) {			var elt:Object = mc_[s];			if(typeof(elt) == "movieclip") {				resetMC(MovieClip(elt));			}		}	}		private function onSWFEnterFrame():Void {		distributeEvent(_playheadPositionChangedEvent);	}}