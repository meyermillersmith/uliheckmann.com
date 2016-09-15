/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.Gallery;
import lessrain.lib.components.mediaplayer07.skins.core.IGallerySkin;

class lessrain.lib.components.mediaplayer07.skins.unused.GallerySkin implements IGallerySkin
{
	/*
	 * Getter & setter
	 */
	private var _targetMC:MovieClip;
	private var _gallery : Gallery;
	
	
	/*
	 * Constructor
	 */
	public function GallerySkin(targetMC_:MovieClip, gallery_:Gallery )
	{
		_targetMC = targetMC_;
		_gallery = gallery_;
		
		initialize();
	}
	
	public function initialize() :Void
	{
		// Background
		var backgroundShape:MovieClip = _targetMC.createEmptyMovieClip("backgroundShape", _targetMC.getNextHighestDepth());
//		ShapeUtils.drawRectangle( backgroundShape, 0, 0, _gallery.galleryProperties.position.width, _gallery.galleryProperties.position.height, 0xff0045, 100);
		
		// Set properties
//		ColorUtils.colorize(backgroundShape, _gallery.galleryProperties.position.backgroundColor);
//		backgroundShape._alpha = _gallery.galleryProperties.position.backgroundAlpha;
	}
	
	public function updateSkin() :Void
	{
		
	}
	
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
}