import lessrain.lib.components.mediaplayer.MediaFile;
import lessrain.lib.utils.NumberUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.text.DynamicTextField;

class lessrain.lib.components.mediaplayer.AudioPlayer extends MovieClip
{
	// Numbers
	private var depth:Number=0;
	private var loops:Number=0;
	private var currentOffset:Number=0;
	private var newPosition:Number=0;
	private var previousPosition:Number=0;
	private var duration:Number=0;
	private var progressBarWidth:Number=-1;
	private var volume:Number=80;
	private var _dragQueenColor:Number;
	private var containerWidth:Number = 330;
	private var containerHeight:Number = 26;
	
	// Strings
	private var path:String;
	private var state:String="stop";
	
	// Booleans
	private var isStreaming:Boolean=true;
	private var dragMode:Boolean=false;
	private var newPositionFound:Boolean=false;
	private var enableCaption:Boolean=true;
	
	// MovieClips
	private var audioContainer:MovieClip;
	private var pauseButton:DynamicTextField;
	private var playButton:DynamicTextField;
	private var stopButton:DynamicTextField;
	private var dragQueen:MovieClip;
	private var volumeController:MovieClip;
	private var volumeControllerHitArea:MovieClip;
	public var caption:DynamicTextField;
	public var copyright:DynamicTextField;
	
	// Objects
	private var file:MediaFile;
	private var displayTime:DynamicTextField;
	private var media:MovieClip;
	private var sound:Sound;
	
	// Example TextFormat
	private var FONT:String;
	private var BUTTON_TEXT_FORMAT:TextFormat;
	private var DURATION_TEXT_FORMAT:TextFormat;
	private var CAPTION_TEXT_FORMAT:TextFormat;
	private var COPYRIGHT_TEXT_FORMAT:TextFormat;
	
	// Used Colors
	private var BLACK:Number;
	private var GREY:Number;
	private var LIGHT_GREY:Number;
	private var PINK:Number;
	private var WHITE:Number;

	private var loadingBar : MovieClip;
	

	function AudioPlayer()
	{
		// Colors
		BLACK 	= 0x000000;
		PINK  	= 0xFF004C;
		WHITE 	= 0xFFFFFF;
		GREY	= 0x666666;
		LIGHT_GREY	= 0xCCCCCC;
		FONT 	= "Futura LT Condensed";		
		
		// TextFormats
		BUTTON_TEXT_FORMAT 		= new TextFormat( FONT, 14, PINK,  null, null, null, "", "", "left", 0, 0, 0, 2);
		DURATION_TEXT_FORMAT	= new TextFormat( FONT, 14, WHITE, null, null, null, "", "", "left", 0, 0, 0, 2);
		CAPTION_TEXT_FORMAT 	= new TextFormat( FONT, 12, BLACK, null, null, null, "", "", "left", 0, 0, 0, 2);
		COPYRIGHT_TEXT_FORMAT	= new TextFormat( FONT, 12, GREY,  null, null, null, "", "", "left", 0, 0, 0, 2);
		
	}
	
	function create(path:String, file:MediaFile, isStreaming:Boolean, enableCaption:Boolean, loops:Number )
	{
		this.path = path;
		this.file = file;
		this.isStreaming = (isStreaming==null) ? true : isStreaming;
		this.enableCaption = (enableCaption==null) ? true : enableCaption;
		this.loops = (loops==null) ? 0 : loops;
		media = createEmptyMovieClip("media",depth++);
		
		createControls();
		
		sound = new Sound();
		sound.loadSound(path+file.src, true);
		sound.start();
		sound.onLoad = Proxy.create(this, setData);
	}
	
	function setData()
	{
		duration = sound.duration;
	}
	
	function createControls()
	{
		progressBarWidth = 120;
		
		// Caption
		var blackCaption:MovieClip = createShape( this, BLACK, depth++, media._x, media._y+containerHeight-26, containerWidth, 26, true);
		blackCaption._alpha=60;
				
		// Buttons	
		stopButton=DynamicTextField(attachMovie("DynamicTextField","stopButton",depth++));		
		stopButton.textFormat=BUTTON_TEXT_FORMAT;
		stopButton.color = PINK;
		stopButton.create();
		stopButton.text="STOP";
		stopButton._x = media._x+56;
		stopButton._y = media._y+containerHeight-stopButton._height;
		stopButton.onRelease=Proxy.create(this, stopSound);
		stopButton.onRollOver=Proxy.create(this, textOver, stopButton);
		stopButton.onRollOut=stopButton.onReleaseOutside=Proxy.create(this, textOut, stopButton);
		
		playButton=DynamicTextField(attachMovie("DynamicTextField","playButton",depth++));
		playButton.textFormat=BUTTON_TEXT_FORMAT;	
		playButton.color = PINK;
		playButton.create();
		playButton.text="PLAY";
		playButton._x = stopButton._x+stopButton._width+4;
		playButton._y = stopButton._y;
		playButton._visible=false;
		playButton.onRelease=Proxy.create(this, startSound);
		playButton.onRollOver=Proxy.create(this, textOver, playButton);
		playButton.onRollOut=playButton.onReleaseOutside=Proxy.create(this, textOut, playButton);
		
		pauseButton=DynamicTextField(attachMovie("DynamicTextField","pauseButton",depth++));
		pauseButton.textFormat=BUTTON_TEXT_FORMAT;
		pauseButton.color = PINK;
		pauseButton.create();
		pauseButton.text="PAUSE";
		pauseButton._x = playButton._x;
		pauseButton._y = playButton._y;
		pauseButton.onRelease=Proxy.create(this, pauseSound);
		pauseButton.onRollOver=Proxy.create(this, textOver, pauseButton);
		pauseButton.onRollOut=pauseButton.onReleaseOutside=Proxy.create(this, textOut, pauseButton);
		
		
		var seconds:String = String(Math.floor(duration/1000));
		if (seconds.length<2) seconds = "0"+seconds;
		var milliseconds:String = String(Math.floor((duration%1000)/10));
		
		displayTime=DynamicTextField(attachMovie("DynamicTextField","displayTime",depth++));
		displayTime.textFormat = DURATION_TEXT_FORMAT;
		displayTime.create();
		displayTime.text = seconds+":"+milliseconds;
		displayTime._x = media._x+4;
		displayTime._y = stopButton._y;
		
		
				
		// TimeLine & LoadingBar
		loadingBar = createEmptyMovieClip("loadingBar", depth++);
		loadingBar._x = media._x+205;
		loadingBar._y = stopButton._y+5;
		loadingBar.onEnterFrame=Proxy.create(this, updateLoadingBar);
		
		// DragButton
		dragQueen = createShape(loadingBar, PINK, depth++, 0, 0, 4, 10, true);
		var enlargeDragQueen:MovieClip = createShape(dragQueen, PINK, 1, -10, 0, 20, 10, true);
		enlargeDragQueen._alpha=0;
		
		// DragQueen handling
		dragQueen.onEnterFrame = Proxy.create(this, getSoundPosition);
		dragQueen.onPress = Proxy.create(this, enterDragMode);
		dragQueen.onRelease = dragQueen.onReleaseOutside = Proxy.create(this, setSoundPosition);
		
		createVolumeControl();
		if (enableCaption) drawCaption();
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
			(createShape(loadingBar, 0xFFFFFF, 1, 0, 0, (getPercentLoaded()/100)*progressBarWidth, 10, true))._alpha = 25;
		}
		else 
		{
			(createShape(loadingBar, 0xFFFFFF, 1, 0, 0, progressBarWidth, 10, true))._alpha = 25;
			delete loadingBar.onEnterFrame;
		}
	}
	
	function enterDragMode()
	{
		if (!dragMode)
		{
			dragMode=true;
			previousPosition = dragQueen._x;
			dragQueen.startDrag( false, 0, dragQueen._y, getPercentLoaded()*progressBarWidth/100-4, dragQueen._y);
		}
	}	
	
	function setSoundPosition()
	{
		var x:Number = dragQueen._x;
		dragQueen.stopDrag();
		dragMode=false;
		
		var percent:Number = x/(progressBarWidth-4);
		newPosition = percent*duration/1000;
		
		sound.start(newPosition);
	}
	
	function getSoundPosition()
	{
		var t:Number = sound.position/1000;
		
		var minutes:Number = Math.floor( t/60 );
		var seconds:Number = Math.floor( (t % 60) );
		var milliseconds:Number = Math.floor( NumberUtils.extractFraction(t)*10 );
		
		displayTime.text = NumberUtils.addZero(minutes, 1)+":"+NumberUtils.addZero(seconds, 2)+"."+NumberUtils.addZero(milliseconds, 1);
		
		if (!dragMode) { dragQueen._x = sound.position/duration*(progressBarWidth-4); }
	}
	
	function startSound()
	{
		sound.start( currentOffset );
		showPauseButton();
	}
	
	function pauseSound()
	{
		currentOffset=sound.position/1000;
		sound.stop();
		if (pauseButton._visible) hidePauseButton();
		else showPauseButton();
	}
	
	function stopSound()
	{
		dragQueen._x=0;
		currentOffset = 0;
		sound.position = 0;
		sound.stop();
		hidePauseButton();
	}
	
	function showPauseButton()
	{
		pauseButton._visible=true;
		playButton._visible=false;
	}
	
	function hidePauseButton()
	{
		pauseButton._visible=false;
		playButton._visible=true;
	}
	
	function getPercentLoaded():Number
	{
		if (sound.getBytesTotal()>10) return (sound.getBytesLoaded()*100/sound.getBytesTotal());
		else return 0;
	}
	
	function createVolumeControl()
	{
		volumeControllerHitArea = createShape(this, PINK, depth++, 0, 0, 100, 12, true);
		volumeControllerHitArea._x = media._x+containerWidth-108;
		volumeControllerHitArea._y = media._y+containerHeight+8;
		volumeControllerHitArea._alpha=0;

		volumeControllerHitArea.onPress = Proxy.create(this, observeVolumeController);
		volumeControllerHitArea.onRelease = Proxy.create(this, stopObserver);
		volumeControllerHitArea.onReleaseOutside = function () { MovieClip(this).onRelease(); };
		
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
	
	function observeVolumeController()
	{		
		volumeControllerHitArea.onEnterFrame=function()
		{
			var x:Number = Math.max( Math.min( MovieClip(this)._xmouse, 100 ), 0 );
			MovieClip(this).volumeController._x = MovieClip(this)._x+x-MovieClip(this)._width;
			MovieClip(this)._parent.setVolume(x);
		};
	}
	
	function stopObserver() { delete volumeControllerHitArea.onEnterFrame; }
	
	function setVolume(volume:Number) { sound.setVolume(volume); } 
	
	function drawCaption()
	{
		caption=DynamicTextField(attachMovie("DynamicTextField","caption",depth++));
		caption.textFormat = CAPTION_TEXT_FORMAT;
		caption.color = GREY;
		caption.create();
		caption.text=file.caption.toUpperCase();
		caption._x = media._x+4;
		caption._y = stopButton._y+27;
		
		copyright=DynamicTextField(attachMovie("DynamicTextField","copyright",depth++));
		copyright.textFormat=COPYRIGHT_TEXT_FORMAT;
		copyright.color=BLACK;
		copyright.create();
		copyright.text=file.copyright.toUpperCase();
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
	
}