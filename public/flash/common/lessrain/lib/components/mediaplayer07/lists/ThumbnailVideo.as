import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.lists.ListItem;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.components.mediaplayer07.skins.core.IThumbnailVideoSkin;
import lessrain.lib.utils.Proxy;
/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.lists.ThumbnailVideo
{
	
	/*
	 * Elements
	 */
	private var _targetMC		: MovieClip;
	private var _listItem		: ListItem;
	private var _file 			: DataFile;
	
	private var _netConnection 	: NetConnection;
	private var _netStream 		: NetStream;
	private var _video 			: Video;
	private var _videoContainer : MovieClip;
	private var _displayWidth	: Number;
	private var _displayHeight 	: Number;
	private var _scaleFactor 	: Number;
	private var _videoIsPlaying	: Boolean;
	private var _isLoop			: Boolean;
	
	private var _error			: String;
	private var _progress		: Number;
	private var _progressPercent: Number;
	private var _percentLoaded	: Number;
	private var _totalTime		: Number;

	private var _soundMC 		: MovieClip;
	private var _sound 			: Sound;
	
	private var _skinFactory	: ISkinFactory;
	private var _skin			: IThumbnailVideoSkin;
	
	
	/*
	 * ThumbnailVideo
	 * @param	listItem	ListItem
	 * @param	targetMC	MovieClip
	 * @param	file		DataFile
	 * @param	width		Number
	 * @param	height		Number
	 */
	public function ThumbnailVideo( listItem_:ListItem, targetMC_:MovieClip, file_:DataFile, w_:Number, h_:Number, skinFactory_:ISkinFactory )
	{
		_targetMC = targetMC_.createEmptyMovieClip("thumbnailVideo_"+targetMC_.getNextHighestDepth(), targetMC_.getNextHighestDepth());
		_listItem = listItem_;
		_file 	  = file_;
		_skinFactory = skinFactory_;
		
		_displayWidth  = (w_!=null) ? w_ : 0;
		_displayHeight = (h_!=null) ? h_ : 0;
		
		initialize();
	}
	
	/*
	 * Initialzes the NetConnection, the NetStream and the Video.
	 * The VideoContainer has to be attachable from the Stage.
	 */
	private function initialize() :Void
	{
//		_skin = _skinFactory.createThumbnailVideoSkin( _targetMC, this);
		
		_netConnection = new NetConnection();
		_netConnection.connect(null);
		
		_netStream = new NetStream(_netConnection);
		_netStream.setBufferTime(8);
		
		_video = new Video();
		
		_videoContainer = _targetMC.attachMovie("VideoContainer", "videoContainer_"+_targetMC.getNextHighestDepth(), _targetMC.getNextHighestDepth());
		_videoContainer.video.attachVideo(_netStream);
		_videoContainer.video.smoothing=true;
		_videoIsPlaying = false;
		resize();
	}
	
	/*
	 * Loads a file and shows it
	 * @param	the Media's DataFile
	 */
	public function loadFile() :Void
	{
		_netStream.play( _file.src);
		_netStream.onStatus = Proxy.create(this, onNetStreamStatus);
		_netStream.onMetaData=Proxy.create(this, onMetaData);
		
		_soundMC = _targetMC.createEmptyMovieClip("soundMC", _targetMC.getNextHighestDepth());
		_soundMC.attachAudio(_netStream);
		
		_sound = new Sound(_soundMC);
		_sound.setVolume( 0 );
	}
	
	/*
	 * MetaDataEvent 
	 */
	private function onMetaData(metaDataObject:Object):Void
	{
		_totalTime = metaDataObject.duration;
		_netStream.seek(0);
		_netStream.pause();
		_videoIsPlaying = false;
	}
	
	/*
	 * Handle NetStreamStatus
	 */
	private function onNetStreamStatus( oInfo:Object ) : Void
	{
		switch (oInfo.code)
		{
			case "NetStream.Buffer.Full":
				_videoIsPlaying = true;
				break;
			
			case "NetStream.Play.Start":
				_videoIsPlaying = true;
				break;
			
			case "NetStream.Pause.Notify":
				break;
			
			case "NetStream.Play.Stop":
				_videoIsPlaying = false;
				_netStream.seek(0);
				break;
			
			case "NetStream.Play.Failed":
				break;
			
			case "NetStream.Play.StreamNotFound":
				var _error:String;
				_error = "Error playing URL: " + oInfo.description;
				break;
			
			case "NetStream.Seek.Notify":
				break;
		}
	}
		
	/*
	 * Resizes the videoContainer according to the display dimensions
	 */
	public function resize() :Void
	{
		_scaleFactor = (_videoContainer.video.width!=0) ? _displayWidth / _videoContainer.video.width : 1;
		
		if (_displayWidth<_file.w  || _displayHeight<_file.h)
		{
			var ratioHorizontal:Number = _displayWidth * _scaleFactor/_file.w;
			var ratioVertical:Number = _displayHeight * _scaleFactor/_file.h;
			
			if (ratioHorizontal < ratioVertical)
			{
				_videoContainer._width  = _file.w * ratioHorizontal;
				_videoContainer._height = _file.h * ratioHorizontal;
			}
			else if (ratioHorizontal > ratioVertical)
			{
				_videoContainer._width  = _file.w * ratioVertical;
				_videoContainer._height = _file.h * ratioVertical;
			}
		}
		else
		{
			_videoContainer._width  = _file.w;
			_videoContainer._height = _file.h;
		}
		
		updatePosition();
	}
	
	/*
	 * Updates the pos of the videoContainer according to the display dimensions
	 */
	public function updatePosition() :Void
	{
		if (_videoContainer._width*_scaleFactor<_displayWidth) 	
			_videoContainer._x = Math.round( (_displayWidth-_videoContainer._width*_scaleFactor)/2 );
		
		if (_videoContainer._height*_scaleFactor<_displayHeight)	
			_videoContainer._y = Math.round( (_displayHeight-_videoContainer._height*_scaleFactor)/2 );
	}
	
	
	/*
	 * Play and pause have to be controlled in the ThumbnailVideoSkin
	 */
	public function playVideo() :Void
	{
		if (!_videoIsPlaying)
		{
			_videoIsPlaying = true;
			_netStream.pause();
		}
	}
	
	public function pauseVideo() :Void
	{
		if (_videoIsPlaying)
		{
			_videoIsPlaying = false;
			_netStream.pause();
		}
	}
	
	
	/*
	 * Remove
	 */
	public function remove() :Void
	{
		_netStream.close();
		delete _netStream;
		
		_netConnection.close();
		delete _netConnection;
		
		delete _video;
		
		_videoContainer.removeMovieClip();
		_soundMC.removeMovieClip();
		_targetMC.removeMovieClip();
	} 
	 
	/*
	 * Getter & setter
	 */
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function get videoIsPlaying():Boolean { return _videoIsPlaying; }
	public function set videoIsPlaying(value:Boolean):Void { _videoIsPlaying=value; }
	
	public function get error():String { return _error; }
	public function set error(value:String):Void { _error=value; }
	
	public function get isLoop():Boolean { return _isLoop; }
	public function set isLoop(value:Boolean):Void { _isLoop=value; }
	
	public function get percentLoaded():Number 
	{
		return (_netStream.bytesTotal>10) ? (_netStream.bytesLoaded*100/_netStream.bytesTotal) : 0; 
	}
	
	public function get progress():Number 
	{ 
		return _netStream.time; 
	}
	
	public function get progressPercent():Number 
	{
		if (_totalTime!=null && _totalTime>0) return _netStream.time*100/_totalTime;
		else return 0;
	}
	
	public function get totalTime():Number { return _totalTime; }
	public function set totalTime(value:Number):Void { _totalTime=value; }
	
	public function get listItem():ListItem { return _listItem; }
	public function set listItem(value:ListItem):Void { _listItem=value; }
	
	public function get displayHeight():Number { return _displayHeight; }
	public function set displayHeight(value:Number):Void { _displayHeight=value; }
	
	public function get displayWidth():Number { return _displayWidth; }
	public function set displayWidth(value:Number):Void { _displayWidth=value; }
	
	public function get videoContainer():MovieClip { return _videoContainer; }
	public function set videoContainer(value:MovieClip):Void { _videoContainer=value; }

}