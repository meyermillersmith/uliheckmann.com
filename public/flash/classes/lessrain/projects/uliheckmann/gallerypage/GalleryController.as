import lessrain.lib.components.mediaplayer.MediaFile;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.gallerypage.BlurImage;
import lessrain.projects.uliheckmann.gallerypage.GalleryEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryMediaFile;
import lessrain.projects.uliheckmann.gallerypage.Image;
import lessrain.projects.uliheckmann.gallerypage.ImageEvent;
import lessrain.projects.uliheckmann.gallerypage.ImagePreloader;
import lessrain.projects.uliheckmann.gallerypage.VisitedImages;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.GalleryController implements IDistributor
{
	private static var SLIDESHOW_INTERVAL : Number = 3000;
	private static var PRELOAD_AMOUNT : Number = 8;
	private static var PRELOAD_FORWARD : Number = 6;
	private var _targetMC : MovieClip;
	private var _imagesMC : MovieClip;
	private var _eventDistributor : EventDistributor;
	private var _mediaFiles : Array;
	private var _title : String;
	private var _currentImage : Image;
	private var _prevImage : Image;
	private var _imagePointer : Number;
	private var _imageCount : Number;
	private var _displayCount : Number;
	private var _imagePreloaders : Array;
	private var _preloaderMC : MovieClip;
	private var _preloadCount : Number;
	private var _loadedProxy : Function;
	private var _showingProxy : Function;
	private var _hiddenProxy : Function;
	private var _slideshowActive : Boolean;
	private var _slideshowIntervalID : Number;
	public function GalleryController(targetMC_ : MovieClip, mediaFiles_ : Array, title_ : String)
	{
		_targetMC = targetMC_;
		_mediaFiles = mediaFiles_;
		_title = title_;
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
		_displayCount = 0;
		_preloadCount = 0;
		_imagePointer = -1;
		_imageCount = mediaFiles_.length;
		_imagePreloaders = new Array();
		_slideshowActive = false;
	}
	public function initialize() : Void
	{
		_loadedProxy = Proxy.create(this, onImageLoaded);
		_showingProxy = Proxy.create(this, onImageShowing);
		_hiddenProxy = Proxy.create(this, onImageHidden);
		
		_preloaderMC = _targetMC.createEmptyMovieClip("preload", 2);
		_imagesMC = _targetMC.createEmptyMovieClip("images", 3);
		
		Key.addListener(this);
	}
	private function preloadImages() : Void
	{
		var toIndex : Number = Math.min(_imagePointer + PRELOAD_FORWARD, _imageCount - 1);
		var fromIndex : Number = Math.max(toIndex - PRELOAD_AMOUNT, 0);
		
		var newImagePreloaders : Array = new Array();
		var imgID : String;
		var imagePreloader : ImagePreloader;
		var i : Number;
		
		// create/reuse preloaders in the preload-range
		for (i = fromIndex;i <= toIndex; i++)
		{
			if (i != _imagePointer)
			{
				if (MediaFile(_mediaFiles[i]).mediaType != "swf")
				{
					imgID = MediaFile(_mediaFiles[i]).id;
					
					// check if the image is already being preloaded and save the reference to that preloader
					imagePreloader = removeImagePreloader(imgID);
					
					// if it's not being preloaded already, create a new preloader for this image
					if (imagePreloader == null)
					{
						_preloadCount++;
						
						/*
						 * The closer the image is to the current one, the higher is the preload priority
						 * Whereas images next to the current one have a higher priority than the previous ones
						 */
						var priority : Number;
						if (i > _imagePointer) priority = 80 + (_imagePointer - i);
						else priority = 70 + (i - _imagePointer);
						
						imagePreloader = new ImagePreloader(_preloaderMC.createEmptyMovieClip("preload_" + _preloadCount, 10 + _preloadCount), _mediaFiles[i]);
						imagePreloader.initialize(priority);
					}
					
					// add the reused/new preloader to the new array of preloaders
					newImagePreloaders.push(imagePreloader);
				}
			}
		}
		
		// finalize preloaders that aren't in the range anymore
		for (i = _imagePreloaders.length - 1;i >= 0; i--)
		{
			imagePreloader = ImagePreloader(_imagePreloaders[i]);
			imagePreloader.finalize();
		}
		
		// set the new array of preloaders
		_imagePreloaders = newImagePreloaders;
	}
	private function removeImagePreloader(id_ : String) : ImagePreloader
	{
		var imagePreloader : ImagePreloader;
		for (var i : Number = _imagePreloaders.length - 1;i >= 0; i--)
		{
			if (ImagePreloader(_imagePreloaders[i]).id == id_)
			{
				imagePreloader = ImagePreloader(_imagePreloaders[i]);
				_imagePreloaders.splice(i, 1);
				return imagePreloader;
			}
		}
		return null;
	}
	public function setImageID(imageID_ : String) : Number
	{
		if (imageID_ == null)
		{
			preloadImages();
		}
		else
		{
			if (_currentImage == null || _currentImage.id != imageID_)
			{
				var mediaFile : GalleryMediaFile;
				for (var i : Number = _imageCount - 1;i >= 0; i--)
				{
					mediaFile = _mediaFiles[i];
					if (mediaFile.id == imageID_ || (imageID_ == null && i == 0))
					{
						_imagePointer = i;
						loadImage(mediaFile);
						return i;
					}
				}
				loadImage(null);
				return _imageCount;
			}
		}
		return -1;
	}
	private function loadImage(mediaFile_ : GalleryMediaFile) : Void
	{
		if (!_currentImage.isLoaded)
		{
			_currentImage.finalize();
			_currentImage = _prevImage;
		}
		
		_displayCount++;
		_prevImage = _currentImage;
		
		if (mediaFile_ == null)
		{
			_currentImage = null;
			
			if (_prevImage == null) onImageHidden(null);
			else _prevImage.hide();
		}
		else
		{
			if (GlobalSettings.getInstance().enableBlurFade) _currentImage = new BlurImage(_imagesMC.createEmptyMovieClip("image_" + _displayCount, _displayCount), mediaFile_);
			else _currentImage = new Image(_imagesMC.createEmptyMovieClip("image_" + _displayCount, _displayCount), mediaFile_);
			_currentImage.addEventListener(ImageEvent.IMAGE_LOADED, Proxy.create(this, _loadedProxy));
			_currentImage.addEventListener(ImageEvent.IMAGE_SHOWING, Proxy.create(this, _showingProxy));
			_currentImage.addEventListener(ImageEvent.IMAGE_HIDDEN, Proxy.create(this, _hiddenProxy));
			_currentImage.initialize();
			
			var imagePreloader : ImagePreloader = removeImagePreloader(mediaFile_.id);
			if (imagePreloader == null) _currentImage.loadImage();
			else
			{
				if (imagePreloader.isLoaded) _currentImage.createFromMovieClip(imagePreloader.targetMC);
				else _currentImage.loadImage();
				imagePreloader.finalize();
			}
		}
	}
	private function onKeyUp() : Void
	{
		if (Key.getCode() == Key.RIGHT || Key.getCode() == Key.SPACE) showNextImage();
		else if (Key.getCode() == Key.LEFT) showPrevImage();
	}
	public function toggleSlideshow( setRunningState_ : Boolean ) : Void
	{
		if (setRunningState_ == null) _slideshowActive = !_slideshowActive;
		else _slideshowActive = setRunningState_;
		setSlideshow();
	}
	private function setSlideshow() : Void
	{
		clearInterval(_slideshowIntervalID);
		if (_slideshowActive) _slideshowIntervalID = setInterval(this, "showNextImage", SLIDESHOW_INTERVAL);
	}
	private function showPrevImage() : Void
	{
		clearInterval(_slideshowIntervalID);
		if (_imagePointer > 0) distributeEvent(new GalleryEvent(GalleryEvent.IMAGE_SELECT, null, _imagePointer - 1));
		else if (_slideshowActive)
		{
			_slideshowActive = false;
			distributeEvent(new GalleryEvent(GalleryEvent.SLIDESHOW_DONE));
		}
	}
	private function showNextImage() : Void
	{
		clearInterval(_slideshowIntervalID);
		if (_imagePointer < _imageCount - 1) distributeEvent(new GalleryEvent(GalleryEvent.IMAGE_SELECT, null, _imagePointer + 1));
		else if (_slideshowActive)
		{
			_slideshowActive = false;
			distributeEvent(new GalleryEvent(GalleryEvent.SLIDESHOW_DONE));
		}
	}
	public function hide() : Void
	{
		_prevImage = _currentImage;
		_currentImage = null;
		if (_prevImage!=null) _prevImage.hide();
		else onImageHidden();
	}
	private function onImageLoaded( imageEvent : ImageEvent ) : Void
	{
		if (_prevImage == null) _currentImage.show();
		else _prevImage.hide();
	}
	private function onImageShowing( imageEvent : ImageEvent ) : Void
	{
		VisitedImages.getInstance().setVisited(_currentImage.id);
		preloadImages();
		setSlideshow();
		distributeEvent(new GalleryEvent(GalleryEvent.IMAGE_SHOWING, _currentImage.id));
	}
	private function onImageHidden( imageEvent : ImageEvent ) : Void
	{
		imageEvent.getImage().finalize();
		if (_prevImage != null) _prevImage = null;
		distributeEvent(new GalleryEvent(GalleryEvent.IMAGE_HIDDEN, _prevImage.id));
		if (_currentImage != null) _currentImage.show();
		else distributeEvent(new GalleryEvent(GalleryEvent.IMAGE_SHOWING, "archiveLink"));
	}
	public function finalize() : Void
	{
		Key.removeListener(this);
		_eventDistributor.finalize();
		_prevImage.finalize();
		_prevImage = null;
		_currentImage.finalize();
		_currentImage = null;
		for (var i : Number = _imagePreloaders.length - 1;i >= 0; i--) ImagePreloader(_imagePreloaders[i]).finalize();
		delete _imagePreloaders;
		delete _loadedProxy;
		delete _showingProxy;
		delete _hiddenProxy;
		delete _mediaFiles;
		_preloaderMC.removeMovieClip();
		_imagesMC.removeMovieClip();
	}
	public function get currentImage() : Image 
	{ 
		return _currentImage; 
	}
	public function get slideshowActive() : Boolean 
	{ 
		return _slideshowActive; 
	}
	public function set slideshowActive(value : Boolean) : Void 
	{ 
		_slideshowActive = value; 
	}
	public function addEventListener(type : String, func : Function) : Void 
	{
	}
	public function removeEventListener(type : String, func : Function) : Void 
	{
	}
	public function distributeEvent(eventObject : IEvent) : Void 
	{
	}
}