import mx.events.EventDispatcher;

import lessrain.lib.components.mediaplayer.MediaFile;
import lessrain.lib.utils.animation.easing.Expo;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.NumberUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.text.DynamicTextField;

class lessrain.lib.components.mediaplayer.MediaPlayer extends MovieClip
{
	// Numbers
	var depth:Number;
	var demoCount:Number;
	var loop:Number;
	var currentOffset:Number;
	var newPosition:Number;
	var previousPosition:Number;
	var videoDuration:Number;
	var videoWidth:Number;
	var videoHeight:Number;
	var displayWidth:Number;
	var displayHeight:Number;
	var scaleToFit:Boolean;
	var progressBarWidth:Number;
	var volume:Number;	
	var _dragQueenColor:Number;
	var controlsY:Number;
	
	// Strings
	var state:String;
	
	// Booleans
	var isStreaming:Boolean;
	var demoMode:Boolean;
	var dragMode:Boolean;
	var newPositionFound:Boolean;
	var enableCaption:Boolean;
	var controlsVisible:Boolean;
	
	// MovieClips
	var videoContainer:MovieClip;
	var controls:MovieClip;
	var pauseButton:DynamicTextField;
	var playButton:DynamicTextField;
	var stopButton:DynamicTextField;
	var dragQueen:MovieClip;
	var volumeController:MovieClip;
	var volumeControllerHitArea:MovieClip;
	public var caption:DynamicTextField;
	public var copyright:DynamicTextField;
	var loadingBar:MovieClip;
	
	// Objects
	var netConnection:NetConnection;
	var netStream:NetStream;
	var file:MediaFile;	
	var video:Video;	
	var displayTime:DynamicTextField;
	var media:MovieClip;
	var sound:Sound;
	
	// Example TextFormat
	var FONT:String;
	var BUTTON_TEXT_FORMAT:TextFormat;
	var DURATION_TEXT_FORMAT:TextFormat;
	public var CAPTION_TEXT_FORMAT:TextFormat;
	public var COPYRIGHT_TEXT_FORMAT:TextFormat;
	
	// Used Colors
	var BLACK:Number;
	var GREY:Number;
	var LIGHT_GREY:Number;
	var PINK:Number;
	var WHITE:Number;
	
	private var _smoothing:Boolean;
	private var _videoState:String;
	private var _backgroundColour:Number;

	private var controlsTween : Tween;
	private var controlsMask : MovieClip;
	private var _prograssBarMargin : Number;
	
	// EventDispatcher functions
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;

	private var _backgroundMC : MovieClip;

	function MediaPlayer()
	{
		EventDispatcher.initialize(this);
		
		netConnection = new NetConnection();
		netConnection.connect(null);
		netStream = new NetStream(netConnection);
		netStream.setBufferTime(8);
		
		_prograssBarMargin=205;
		depth=3000;
		state="stop";
		
		video=new Video();

		isStreaming=true;
		
		volume=80;
		sound=new Sound();
		sound.setVolume(volume);
		
		controlsVisible=false;
		demoMode=false;
		demoCount=0;
		loop=0;
		currentOffset=0;
		videoDuration=0;		
		
		dragMode=false;
		
		previousPosition=0;
		newPosition=0;
		newPositionFound=true;
		
		_backgroundColour=-1;
		
		// TextFormat
		BLACK 	= 0x000000;
		PINK  	= 0xFF004C;
		WHITE 	= 0xFFFFFF;
		GREY	= 0x666666;
		LIGHT_GREY	= 0xCCCCCC;
		FONT 	= "Futura LT Condensed";		
		BUTTON_TEXT_FORMAT 		= new TextFormat( FONT, 14, PINK,  null, null, null, "", "", "left", 0, 0, 0, 2);
		DURATION_TEXT_FORMAT	= new TextFormat( FONT, 14, WHITE, null, null, null, "", "", "left", 0, 0, 0, 2);
		CAPTION_TEXT_FORMAT 	= new TextFormat( FONT, 12, BLACK, null, null, null, "", "", "left", 0, 0, 0, 2);
		COPYRIGHT_TEXT_FORMAT	= new TextFormat( FONT, 12, GREY,  null, null, null, "", "", "left", 0, 0, 0, 2);
		
		_smoothing=false;
		_videoState='play';
		
	}
	
	public function setVideoBufferTime(seconds:Number):Void
	{
		netStream.setBufferTime(seconds);
	}
	
	public function setProgressBarMargin(w:Number):Void
	{
		_prograssBarMargin=w;
	}
	
	function create(path:String, file:MediaFile, containerWidth:Number, containerHeight:Number, scaleToFit:Boolean, enableCaption:Boolean):Void
	{
		_visible=false;
		this.file=file;
		displayWidth = containerWidth;
		displayHeight = containerHeight;
		if (scaleToFit!=null) this.scaleToFit = scaleToFit;
		else this.scaleToFit=true;
		this.enableCaption = (enableCaption==null) ? true : enableCaption;
		
		media=createEmptyMovieClip("media",depth++);	
				
		videoContainer = attachMovie("VideoContainer", "video_container", depth++);
		videoContainer.video.attachVideo(netStream);
		if(_smoothing){
			videoContainer.video.smoothing=true;
		}
		
		createMainControls();
		controlsTweenDone();
		
		// Try to get Video Duration
		if (file.fileDuration==undefined || file.fileDuration<=0)
		{
			netStream.onMetaData = Proxy.create(this, createDurationControls);
		}
		else
		{
			var obj:Object = new Object();
			obj.duration = file.fileDuration;
			createDurationControls(obj);
		}
		 
		 // Play File
		netStream.play(path+file.src);		
	}
	
	function checkMouseOver():Void
	{
		if (hitTest(_root._xmouse, _root._ymouse)) showControls();
		else hideControls();
	}
	
	function showControls():Void
	{
		if (!controlsVisible)
		{
			controlsVisible=true;
			controls._visible=true;
			controlsTween.reset();
			controlsTween.setTweenProperty('_y', controls._y, controlsY);
			controlsTween.start();
		}
	}
	
	function hideControls():Void
	{
		if (controlsVisible)
		{
			controlsVisible=false;
			controlsTween.reset();
			controlsTween.setTweenProperty('_y', controls._y, controlsY+controls._height);
			controlsTween.start();
		}
	}
	
	function controlsTweenDone():Void
	{
		if (controls._y>controlsY) controls._visible=false;
	}
	
	function createMainControls():Void
	{
		// Handle the DisplaySize of the different Videofiles
		if (scaleToFit)
		{
			videoContainer._width=displayWidth;
			videoContainer._height=displayHeight;
		}
		else
		{
			videoContainer._width=file.fileWidth;
			videoContainer._height=file.fileHeight;
		
			if (_backgroundColour>=0)
			{
				_backgroundMC = createEmptyMovieClip("background",100);
				ShapeUtils.drawRectangle(_backgroundMC, 0,0,displayWidth,displayHeight,_backgroundColour,100);
				
				videoContainer._x += Math.floor( (displayWidth-file.fileWidth)/2 );
				videoContainer._y=Math.floor( (displayHeight-file.fileHeight)/2 );
			}
			else
			{
				displayWidth = file.fileWidth;
				displayHeight = file.fileHeight;
				
				videoContainer._x += Math.floor( (displayWidth-file.fileWidth)/2 );
				videoContainer._y += Math.floor( (displayHeight-file.fileHeight)/2 );
			}
		}
		progressBarWidth = (displayWidth - _prograssBarMargin - 8);
		
		
		controls = createEmptyMovieClip("controls",depth++);
		controlsY=media._y+displayHeight-26;
		
		controls._x=media._x;
		controls._y=controlsY+26;
		controls.onMouseMove = Proxy.create(this,checkMouseOver);
		controlsTween = new Tween(controls);
		controlsTween.duration=500;
		controlsTween.easingFunction = Expo.easeOut;
		controlsTween.addEventListener("onComplete", Proxy.create( this, controlsTweenDone ));
		
		controlsMask = createEmptyMovieClip("controlsMask",depth++);
		createShape( controlsMask, BLACK, depth++, 0, 0, displayWidth, 26, true);
		controlsMask._x=media._x;
		controlsMask._y=controlsY;
		controls.setMask(controlsMask);
		
		// Caption
		var blackCaption:MovieClip = createShape( controls, BLACK, depth++, 0, 0, displayWidth, 26, true);
		blackCaption._alpha=60;
				
		// Buttons	
		stopButton=DynamicTextField(controls.attachMovie("DynamicTextField","stopButton",depth++));		
		stopButton.textFormat=BUTTON_TEXT_FORMAT;
		stopButton.color = PINK;
		stopButton.create();
		stopButton.text="STOP";
		stopButton._x = 56;
		stopButton._y = 26-stopButton._height;
		stopButton.onRelease=Proxy.create(this, stopVideo);
		stopButton.onRollOver=Proxy.create(this, textOver, stopButton);
		stopButton.onRollOut=stopButton.onReleaseOutside=Proxy.create(this, textOut, stopButton);
		
		playButton=DynamicTextField(controls.attachMovie("DynamicTextField","playButton",depth++));
		playButton.textFormat=BUTTON_TEXT_FORMAT;	
		playButton.color = PINK;
		playButton.create();
		playButton.text="PLAY";
		playButton._x = stopButton._x+stopButton._width+4;
		playButton._y = stopButton._y;
		playButton._visible=false;
		playButton.onRelease=Proxy.create(this, pauseVideo);
		playButton.onRollOver=Proxy.create(this, textOver, playButton);
		playButton.onRollOut=playButton.onReleaseOutside=Proxy.create(this, textOut, playButton);
		
		pauseButton=DynamicTextField(controls.attachMovie("DynamicTextField","pauseButton",depth++));
		pauseButton.textFormat=BUTTON_TEXT_FORMAT;
		pauseButton.color = PINK;
		pauseButton.create();
		pauseButton.text="PAUSE";
		pauseButton._x = playButton._x;
		pauseButton._y = playButton._y;
		pauseButton.onRelease=Proxy.create(this, pauseVideo);
		pauseButton.onRollOver=Proxy.create(this, textOver, pauseButton);
		pauseButton.onRollOut=pauseButton.onReleaseOutside=Proxy.create(this, textOut, pauseButton);
		
		
		var seconds:String = String(Math.floor(videoDuration/1000));
		if (seconds.length<2) seconds = "0"+seconds;
		var milliseconds:Number = Math.floor((videoDuration%1000)/10);
		
		displayTime=DynamicTextField(controls.attachMovie("DynamicTextField","displayTime",depth++));
		displayTime.textFormat = DURATION_TEXT_FORMAT;
		displayTime.create();
		displayTime.text = seconds+":"+milliseconds;
		displayTime._x = 4;
		displayTime._y = stopButton._y;
				
		// TimeLine & LoadingBar
		loadingBar = controls.createEmptyMovieClip("loadingBar", depth++);
		loadingBar._x = _prograssBarMargin;
		loadingBar._y = stopButton._y+5;
		loadingBar.onEnterFrame=Proxy.create(this, updateLoadingBar);
		
		createVolumeControl();
		if (enableCaption) drawCaption();
		
		_visible=true;
	}
	
	private function textOver(button:DynamicTextField):Void
	{
		button.color=WHITE;
	}
	
	private function textOut(button:DynamicTextField):Void
	{
		button.color=PINK;
	}
	
	public function updateLoadingBar():Void
	{
		if (getPercentLoaded()<100)
		{
			(createShape(loadingBar, 0xFFFFFF, 1, 0, 0, getPercentLoaded()*(progressBarWidth/100), 10, true))._alpha = 25;
		}
		else 
		{
			(createShape(loadingBar, 0xFFFFFF, 1, 0, 0, progressBarWidth, 10, true))._alpha = 25;
			delete loadingBar.onEnterFrame;
		}
	}
	
	function createDurationControls(obj:Object):Void
	{
		// DragButton
		videoDuration=obj.duration*1000;
		dragQueen = createShape(loadingBar, PINK, depth++, 0, 0, 4, 10, true);
		var enlargeDragQueen:MovieClip = createShape(dragQueen, PINK, 1, -10, 0, 20, 10, true);
		enlargeDragQueen._alpha=0;
		dragQueen.onEnterFrame=Proxy.create(this, drag);
		dragQueen.onPress=Proxy.create(this, startDragging);
		dragQueen.onRelease=dragQueen.onReleaseOutside=Proxy.create(this, stopDragging);
		
		netStream.onStatus=Proxy.create(this,onStatus);
	}
	
	public function drag():Void
	{
		if (!getDragMode()) dragQueen._x=getVideoPosition();
	}
	
	public function startDragging():Void
	{
		if (!getDragMode())
		{
			setPreviousPosition(dragQueen._x);
			setDragMode(true);
			dragQueen.startDrag(false, 0, dragQueen._y, getPercentLoaded()*(progressBarWidth/100)-4, dragQueen._y);
		}
	}
	
	public function stopDragging():Void
	{
		setVideoPosition(dragQueen._x);
		dragQueen.stopDrag();
		setDragMode(false);
	}
	
	
	function setPreviousPosition(t:Number):Void
	{
		previousPosition=t;
	}
	
	function setDragMode(b:Boolean):Void
	{
		dragMode=b;
	}
	
	function getDragMode():Boolean
	{
		return dragMode;
	}
	
	function setVideoPosition(x:Number):Void
	{
		// Offset requires a value in seconds	
		newPosition = Math.round(x*(videoDuration/1000)/(progressBarWidth-4));
		netStream.seek(newPosition);
	}
	
	function onStatus(info:Object):Void
	{
		if (info.code=="NetStream.Play.Stop")
		{
			dragQueen._x=0;
			stopVideo();
		}
		dispatchEvent( { type: "onStatus", info: info } );
	}
	
	function getVideoPosition():Number
	{
		var t:Number = netStream.time;
		
		var minutes:Number = Math.floor( t/60 );
		var seconds:Number = Math.floor( (t % 60) );
		var milliseconds:Number = Math.floor( NumberUtils.extractFraction(t)*10 );
		
		displayTime.text = NumberUtils.addZero(minutes, 1)+":"+NumberUtils.addZero(seconds, 2)+"."+NumberUtils.addZero(milliseconds, 1);
		
		return netStream.time*(progressBarWidth-4)/(videoDuration/1000);		
	}
	
	function startVideo():Void
	{
		netStream.play(_root.videoPath+file.src);
		showPauseButton();
	}
	
	function pauseVideo():Void
	{
		currentOffset=netStream.time;
		netStream.pause();
		if (pauseButton._visible) {
			hidePauseButton();
		}else {
			showPauseButton();
		}
	}
	
	function setPauseStatus( paused:Boolean ):Void
	{
		if (paused) currentOffset=netStream.time;
		netStream.pause( paused );
		if (paused) hidePauseButton();
		else showPauseButton();
	}
	
	function stopVideo():Void
	{
		dragQueen._x=0;
		netStream.seek(0);
		netStream.pause(true);
		hidePauseButton();
	}
	
	function showPauseButton():Void
	{
		_videoState='play';
		pauseButton._visible=true;
		playButton._visible=false;
	}
	
	function hidePauseButton():Void
	{
		_videoState='pause';
		pauseButton._visible=false;
		playButton._visible=true;
	}
	
	function getPercentLoaded():Number
	{		
		if (netStream.bytesTotal>10) return (netStream.bytesLoaded*100/netStream.bytesTotal);
		else return 0;
	}
	
	function setVideoDuration(d:Number):Void
	{
		videoDuration=d;
	}
	
	function getVideoDuration():Number
	{		
		return videoDuration;
	}
	
	function createVolumeControl():Void
	{
		volumeControllerHitArea = createShape(this, PINK, depth++, 0, 0, 100, 12, true);
		volumeControllerHitArea._x = media._x+displayWidth-108;
		volumeControllerHitArea._y = media._y+displayHeight+8;		
		volumeControllerHitArea._alpha=0;

		volumeControllerHitArea.onPress=function()
		{ 
			MovieClip(this)._parent.observeVolumeController();
		};
		volumeControllerHitArea.onRelease=function()
		{    
			MovieClip(this)._parent.stopObserver();
		};
		volumeControllerHitArea.onReleaseOutside=function()
		{    
			MovieClip(this).onRelease();
		};
		
		// Illustration
		var volumeIllustrationMask:MovieClip = attachMovie("VolumeMask", "volumeIllustrationMask", depth++);
		volumeIllustrationMask._x = volumeControllerHitArea._x;
		volumeIllustrationMask._y = volumeControllerHitArea._y;
		var volumeIllustration:MovieClip = createShape(this, LIGHT_GREY, depth++, 0, 0, volumeControllerHitArea._width, volumeControllerHitArea._height, true);
		volumeIllustration._x = volumeControllerHitArea._x;
		volumeIllustration._y = volumeControllerHitArea._y;
		volumeIllustration.setMask(volumeIllustrationMask);
		
		var volumeMask:MovieClip = attachMovie("VolumeMask", "volumeMask", depth++);
		volumeMask._x = volumeControllerHitArea._x;
		volumeMask._y = volumeControllerHitArea._y;
		volumeController = createShape(this, PINK, depth++, 0, 0, volumeControllerHitArea._width, 10, true);
		volumeController._x = volumeControllerHitArea._x-(100-volume);
		volumeController._y = volumeControllerHitArea._y;		
		volumeController.setMask(volumeMask);
		
		volumeControllerHitArea.volumeController = volumeController;
	}
	
	function observeVolumeController():Void
	{		
		volumeControllerHitArea.onEnterFrame=function()
		{
			var x:Number = Math.max( Math.min( MovieClip(this)._xmouse, 100 ), 0 );
			MovieClip(this).volumeController._x = MovieClip(this)._x+x-MovieClip(this)._width;
			MovieClip(this)._parent.setVolume(x);
		};
	}
	
	function stopObserver():Void
	{
		delete volumeControllerHitArea.onEnterFrame;
	}
	
	function setVolume(volume:Number):Void
	{
		this.volume=volume;
		sound.setVolume(volume);
	}
	
	function drawCaption():Void
	{
		caption=DynamicTextField(attachMovie("DynamicTextField","caption",depth++));
		caption.textFormat = CAPTION_TEXT_FORMAT;
		caption.color = GREY;
		caption.create();
		caption.text=file.caption;
		caption._x = media._x+4;
		caption._y = media._y+displayHeight+1;
		
		copyright=DynamicTextField(attachMovie("DynamicTextField","copyright",depth++));
		copyright.textFormat=COPYRIGHT_TEXT_FORMAT;
		copyright.color=BLACK;
		copyright.create();
		copyright.text=file.copyright;
		copyright._x = caption._x;
		copyright._y = caption._y+caption._height-10;
	}	
	
	function get dragQueenColor():Number { return _dragQueenColor; }
	
	function createShape(parentMovieClip:MovieClip, c:Number, d:Number, x:Number, y:Number, w:Number, h:Number, v:Boolean):MovieClip
	{
		var backgroundMovie:MovieClip = parentMovieClip.createEmptyMovieClip("drawed_background_"+Math.abs(d), d);
		backgroundMovie.beginFill(c);
		backgroundMovie.lineStyle(0,0,0);
		backgroundMovie.moveTo(  x,   y);
		backgroundMovie.lineTo(x+w,   y);
		backgroundMovie.lineTo(x+w, y+h);
		backgroundMovie.lineTo(  x, y+h);
		backgroundMovie.lineTo(  x,   y);
		backgroundMovie.endFill();
		backgroundMovie._visible=v;
		return backgroundMovie;
	}
	function localize(stopTXT:String,playTXT:String,pauseTXT:String):Void{
		stopButton.text=stopTXT;
		playButton.text=playTXT;
		pauseButton.text=pauseTXT;
	}
	
	public function set smoothing(value:Boolean):Void {_smoothing=value;}
	public function get videoState():String {return _videoState;}
	
	public function get backgroundColour():Number { return _backgroundColour; }
	public function set backgroundColour(value:Number):Void { _backgroundColour=value; }
	
	
	
}