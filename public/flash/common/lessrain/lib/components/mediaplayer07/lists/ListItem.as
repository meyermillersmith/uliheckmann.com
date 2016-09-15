/**
 * @author Torsten Härtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.lists.List;
import lessrain.lib.components.mediaplayer07.lists.ThumbnailImage;
import lessrain.lib.components.mediaplayer07.lists.ThumbnailVideo;
import lessrain.lib.components.mediaplayer07.skins.core.IListItemSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;

class lessrain.lib.components.mediaplayer07.lists.ListItem 
{
	/*
	 * Getter & setter
	 */
	private var _list 				: List;
	private var _targetMC			: MovieClip;
	private var _media				: Media;
	private var _thumbnailFile 		: DataFile;
	private var _isActive			: Boolean;
	private var _skin				: IListItemSkin;
	private var _skinFactory		: ISkinFactory;
	private var _thumbnailImage 	: ThumbnailImage;

	private var _thumbnailVideo : ThumbnailVideo;

	
	/*
	 * Constructor
	 */
	public function ListItem(list_:List, targetMC:MovieClip, media_:Media, skinFactory_:ISkinFactory)
	{
		_targetMC = targetMC.createEmptyMovieClip("listItem_"+targetMC.getNextHighestDepth(), targetMC.getNextHighestDepth());
		_list = list_;
		_media = media_;
		_skinFactory = skinFactory_;
		
		initialize();
	}
	
	public function initialize() :Void
	{
		var thumbnails:Array = _media.getFilesByRole("thumbnail");
		_thumbnailFile = thumbnails[0];
		
//		_skin = _skinFactory.createListItemSkin( _targetMC, this, _list.itemXPos, _list.itemYPos);
		
		switch (_thumbnailFile.type)
		 {
			case "image":	_thumbnailImage = new ThumbnailImage( this, _targetMC, _thumbnailFile, _skinFactory );
							break;
			case "video":	_thumbnailVideo = new ThumbnailVideo( this, _targetMC, _thumbnailFile, _thumbnailFile.w, _thumbnailFile.h, _skinFactory );
							_thumbnailVideo.loadFile();
							break;
			default:		break;
		 }
		
		_isActive = false;
	}
	
	public function onClick() :Void
	{
		_list.showFile( this, _media );
	}
	
	public function onRoll(highlight:Boolean) :Void
	{
		if (_thumbnailVideo!=null)
		{
			// Play or pause video
			if (highlight) _thumbnailVideo.playVideo();
			else  _thumbnailVideo.pauseVideo();
		}
	}
	
	/*
	 * Activates list
	 */
	public function activate() :Void
	{
		_isActive = true;
		_skin.updateSkin();
	}
	
	/*
	 * Deactivates list
	 */
	public function deactivate() :Void
	{
		_isActive = false;
		_skin.updateSkin();
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function get thumbnailImage():ThumbnailImage { return _thumbnailImage; }
	public function set thumbnailImage(value:ThumbnailImage):Void { _thumbnailImage=value; }
	
	public function get height():Number { return _skin.getHeight(); }
	public function get width():Number { return _skin.getWidth(); }
	
	public function get isActive():Boolean { return _isActive; }
	public function set isActive(value:Boolean):Void { _isActive=value; }
	
	public function get thumbnailFile():DataFile { return _thumbnailFile; }
	public function set thumbnailFile(value:DataFile):Void { _thumbnailFile=value; }
	
	public function get media():Media { return _media; }
	public function set media(value:Media):Void { _media=value; }
}