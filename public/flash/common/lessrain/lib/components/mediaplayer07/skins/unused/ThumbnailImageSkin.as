/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.lists.ThumbnailImage;
import lessrain.lib.components.mediaplayer07.skins.core.IThumbnailImageSkin;

class lessrain.lib.components.mediaplayer07.skins.unused.ThumbnailImageSkin implements IThumbnailImageSkin
{
	/*
	 * Getter & setter
	 */
	private var _targetMC				: MovieClip;
	private var _thumbnail 				: ThumbnailImage;
	private var _imageBackgroundShape 	: MovieClip;

	
	/*
	 * Constructor
	 */
	public function ThumbnailImageSkin(targetMC_:MovieClip, thumbnail_:ThumbnailImage)
	{
		_targetMC = targetMC_;
		_thumbnail = thumbnail_;
		
		initialize();
	}
	
	public function initialize() :Void
	{
//		_imageBackgroundShape = _targetMC.createEmptyMovieClip("imagebackgroundShape", _targetMC.getNextHighestDepth());
//		ShapeUtils.drawRectangle( _imageBackgroundShape, 0, 0, _thumbnail.file.w, _thumbnail.file.h, 0x2288ee, 100);
//		
//		_imageBackgroundShape.swapDepths( _thumbnail.imageHolder );
	}
	
	public function updateSkin() :Void
	{
	}
		
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }

}