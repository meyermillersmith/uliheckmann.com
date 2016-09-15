/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.lists.ThumbnailVideo;
import lessrain.lib.components.mediaplayer07.skins.core.IThumbnailVideoSkin;

class lessrain.lib.components.mediaplayer07.skins.unused.ThumbnailVideoSkin implements IThumbnailVideoSkin
{
	/*
	 * Getter & setter
	 */
	private var _targetMC				: MovieClip;
	private var _thumbnail 				: ThumbnailVideo;

	
	/*
	 * Constructor
	 */
	public function ThumbnailVideoSkin(targetMC_:MovieClip, thumbnail_:ThumbnailVideo)
	{
		_targetMC = targetMC_;
		_thumbnail = thumbnail_;
		
		initialize();
	}
	
	public function initialize() :Void
	{
	}
	
	public function updateSkin() :Void
	{
	}
		
	// Getter & setter
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }

}