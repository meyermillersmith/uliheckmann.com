import mx.xpath.XPathAPI;

import lessrain.lib.components.mediaplayer.MediaFile;
import lessrain.lib.engines.pages.PageManager;
import lessrain.lib.utils.assets.Label;
import lessrain.lib.utils.assets.Source;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.GroupListener;
import lessrain.lib.utils.loading.GroupLoader;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.core.DimEvent;
import lessrain.projects.uliheckmann.core.DimPage;
import lessrain.projects.uliheckmann.gallerypage.ArrowNavigation;
import lessrain.projects.uliheckmann.gallerypage.GalleryController;
import lessrain.projects.uliheckmann.gallerypage.GalleryEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryLetter;
import lessrain.projects.uliheckmann.gallerypage.GalleryMediaFile;
import lessrain.projects.uliheckmann.gallerypage.GalleryNavigation;
import lessrain.projects.uliheckmann.header.HeaderEvent;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;
import lessrain.lib.utils.loading.GroupLoaderProgressProxy;
import lessrain.projects.uliheckmann.gallerypage.Caption;
import lessrain.lib.utils.logger.LogManager;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.GalleryPage extends DimPage implements GroupListener
{
	private var _xml : XML;
	private var _mediaFiles : Array;

	private var _title : String;
	private var _menuMC : MovieClip;
	private var _arrowsMC : MovieClip;

	private var _thumbnailLoader : GroupLoader;
	private var _galleryController : GalleryController;
	private var _arrowNavigation : ArrowNavigation;
	private var _galleryNavigation : GalleryNavigation;

	private var _caption : Caption;

	private var _captionMC : MovieClip;

	
	public function GalleryPage(targetMC : MovieClip)
	{
		super(targetMC);
		_hasSubNavigation = true;
		_intermediatePageShowing = GlobalSettings.getInstance().enableIntermediatePage;
	}

	public function initialize() : Void
	{
		super.initialize();
		_arrowsMC = _navigationMC.createEmptyMovieClip("arrows", 10);
		_menuMC = _navigationMC.createEmptyMovieClip("menu", 11);
		_captionMC = _navigationMC.createEmptyMovieClip("caption", 9);
		
		_xml = new XML();
		_xml.ignoreWhite = true;
		
		var srcID : String = getPageIDPart(0) + "." + getPageIDPart(1) + "." + getPageIDPart(2);
		PriorityLoader.getInstance().addFile(_xml, Source.getSource(srcID), this, 100, "xml", Label.getLabel("Loading.data"));
		
		if (GlobalSettings.getInstance().enableFullscreen)
		{
			onResize();
			Stage.addListener(this);
		}
	}

	private function onResize() : Void
	{
		super.onResize();
		_arrowsMC._x = GlobalFunctions.getCenterStageX();
		_menuMC._x = GlobalFunctions.getCenterStageX();
		_menuMC._y = GlobalFunctions.getCenterStageY();
		_captionMC._x = GlobalFunctions.getCenterStageX();
	}

	/**
	 * Called by the PageManager
	 */
	public function updateContent( pageID : String ) : Boolean
	{
		if (getPageIDPart(1) == PageManager.getPageIDPart(pageID, 1) && getPageIDPart(2) == PageManager.getPageIDPart(pageID, 2))
		{
			update(PageManager.getPageIDPart(pageID, 3));
			return true;
		}
		else return false;
	}

	private function initializeGallery() : Void
	{
		var defaultImageID : String = getPageIDPart(3);
		
		_galleryController = new GalleryController(_contentMC, _mediaFiles, _title);
		_galleryController.addEventListener(GalleryEvent.IMAGE_SELECT, Proxy.create(this, onImageSelect));
		_galleryController.addEventListener(GalleryEvent.IMAGE_SHOWING, Proxy.create(this, onImageShowing));
		_galleryController.addEventListener(GalleryEvent.SLIDESHOW_DONE, Proxy.create(this, onSlideshowDone));
		_galleryController.initialize();
		
		_galleryNavigation = new GalleryNavigation(_menuMC, _title, _mediaFiles);
		_galleryNavigation.addEventListener(GalleryEvent.IMAGE_SELECT, Proxy.create(this, onImageSelect));
		_galleryNavigation.addEventListener(HeaderEvent.TOGGLE_MENU, Proxy.create(this, onToggleMenu));
		_galleryNavigation.initialize();
		_galleryNavigation.setBehaviour(GalleryLetter.BEHAVIOUR_SCREEN);
		
		
		var archiveLink : String;
		// build archive link if it's not the mood section
		if (getPageIDPart(2).toLowerCase().indexOf("moods") < 0)
		{
			if (getPageIDPart(1) == "Portfolio") archiveLink = "/" + getPageIDPart(0) + "/Archive/" + getPageIDPart(2);
		}
		
		_arrowNavigation = new ArrowNavigation(_arrowsMC, _mediaFiles.length, archiveLink);
		_arrowNavigation.addEventListener(GalleryEvent.IMAGE_SELECT, Proxy.create(this, onImageSelect));
		_arrowNavigation.addEventListener(GalleryEvent.GOTO_ARCHIVE, Proxy.create(this, onArchiveClick));
		_arrowNavigation.addEventListener(HeaderEvent.TOGGLE_MENU, Proxy.create(this, onToggleMenu));
		_arrowNavigation.addEventListener(HeaderEvent.TOGGLE_SUB_MENU, Proxy.create(this, onToggleSubMenu));
		_arrowNavigation.initialize();
		
		_caption = new Caption(_captionMC);
		_caption.initialize();
		
		if (!GlobalSettings.getInstance().enableIntermediatePage && defaultImageID == null) defaultImageID = GalleryMediaFile(_mediaFiles[0]).id;
		if (defaultImageID == null)
		{
			//_galleryNavigation.setBehaviour(GalleryLetter.BEHAVIOUR_SCREEN);
			_galleryNavigation.show();
			// uncomment to have arrows in the subpage
//			_arrowNavigation.update( -1, null, _mediaFiles[0] );
//			_arrowNavigation.enable();
//			_arrowNavigation.show();
		}
		_galleryController.setImageID(defaultImageID);
		
		dispatchPageInitialized();
	}

	private function update( imageID_ : String ) : Void
	{
		if (imageID_ == null) imageID_ = MediaFile(_mediaFiles[0]).id;
		
		if (_subNavigationShowing)
		{
			hideSubNavigation();
			undim(500);
		}
		if (GlobalSettings.getInstance().enableIntermediatePage && _galleryController.currentImage == null) distributeEvent(new DimEvent(DimEvent.HIDE_SUB_NAV));
		var imageIndex : Number = _galleryController.setImageID(imageID_);
		_caption.hide();
		if (imageIndex >= 0)
		{
			_intermediatePageShowing = false;
			_arrowNavigation.disable();
			_galleryNavigation.setActiveItemAndHide(imageIndex);
			//_galleryNavigation.setBehaviour(GalleryLetter.BEHAVIOUR_OVERLAY);
		}
		else
		{
			_intermediatePageShowing = true;
		}
	}

	private function onToggleMenu(headerEvent : HeaderEvent) : Void
	{
		distributeEvent(headerEvent);
	}

	private function onToggleSubMenu(headerEvent : HeaderEvent) : Void
	{
		distributeEvent(headerEvent);
	}

	public function toggleSlideshow( setRunningState_ : Boolean ) : Void
	{
		_galleryController.toggleSlideshow(setRunningState_);
	}

	public function isSlideshowActive() : Boolean
	{
		return _galleryController.slideshowActive;
	}

	private function onSlideshowDone(galleryEvent_ : GalleryEvent) : Void
	{
		distributeEvent(galleryEvent_);
	}

	private function onImageSelect(e : GalleryEvent) : Void
	{
		if (e.getPos() >= _mediaFiles.length)
		{
			_pageManager.loadPage("/" + getPageIDPart(0) + "/" + getPageIDPart(1) + "/" + getPageIDPart(2) + "/archiveLink");		
		}
		else
		{
			var prevID : String = GalleryMediaFile(_mediaFiles[e.getPos()]).id;
			_pageManager.loadPage("/" + getPageIDPart(0) + "/" + getPageIDPart(1) + "/" + getPageIDPart(2) + "/" + prevID);
		} 
	}

	private function onArchiveClick(e : GalleryEvent) : Void
	{
		_pageManager.loadPage(e.getImageID());
	}

	public function show() : Void
	{
		super.show();
		dispatchPageShowing();
	}

	public function hide() : Void
	{
		_galleryNavigation.hide();
		_galleryNavigation.disable();
		_arrowNavigation.disable();
		super.hide();
		if (!_isDimmed)
		{
			_galleryController.addEventListener(GalleryEvent.IMAGE_HIDDEN, Proxy.create(this, onImageHidden));
			_galleryController.hide();
		}
	}

	public function dim( action_ : Number ) : Void
	{
		_arrowNavigation.hide();
		_arrowNavigation.disable();
		_galleryNavigation.hide();
		_galleryNavigation.disable();
		super.dim(action_);
	}

	private function onTweenComplete(tweenEvent : TweenEvent) : Void
	{
		if (!_isDimmed)
		{
			_arrowNavigation.enable();
			_arrowNavigation.show();
			_galleryNavigation.enable();
			
			/*
			 * the following has been disabled because we don't have overview pages
			 * and we have the archive link, which for now are incompatible
			 * 
			// if we're on an overview page
			if (_galleryController.currentImage == null)
			{
				_galleryNavigation.show();
			}
			// otherwise we're on an image
			else
			{
				_arrowNavigation.enable();
				_arrowNavigation.show();
				_galleryNavigation.enable();
			}
			 */
		}
		super.onTweenComplete(tweenEvent);
	}

	public function showSubNavigation() : Void
	{
		super.showSubNavigation();
		//_galleryNavigation.setBehaviour(GalleryLetter.BEHAVIOUR_SCREEN);
		_galleryNavigation.show();
		// if we're not on an overview page
		if (_galleryController.currentImage != null)
		{
			_arrowNavigation.enable();
			_arrowNavigation.show();
		}
	}

	public function hideSubNavigation() : Void
	{
		super.hideSubNavigation();
		//_galleryNavigation.setBehaviour(GalleryLetter.BEHAVIOUR_OVERLAY);
		_galleryNavigation.hide();
		_arrowNavigation.hide();
		_arrowNavigation.disable();
	}

	private function onImageShowing( galleryEvent : GalleryEvent ) : Void
	{
		updateNavigation(galleryEvent.getImageID());
	}

	private function onImageHidden(galleryEvent : GalleryEvent) : Void
	{
		dispatchPageHidden();
	}

	private function updateNavigation( imageID_ : String ) : Void
	{
		var imagePointer : Number = getImagePos(imageID_);
	
		var currMediaFile : GalleryMediaFile = _mediaFiles[imagePointer];
		
		var prevMediaFile : GalleryMediaFile;
		var nextMediaFile : GalleryMediaFile;
		
		if (imagePointer > 0) prevMediaFile = _mediaFiles[imagePointer - 1];
		if (imagePointer < _mediaFiles.length - 1) nextMediaFile = _mediaFiles[imagePointer + 1];
		
		_arrowNavigation.update(imagePointer, prevMediaFile, nextMediaFile, currMediaFile);
		_arrowNavigation.enable();
		_galleryNavigation.updateVisited();
		_galleryNavigation.enable();
		
		if (imagePointer < _mediaFiles.length) _caption.setCaption(MediaFile(_mediaFiles[imagePointer]).caption);
		else _caption.setCaption("");
		_caption.show();
	}

	private function getImagePos(imageID_ : String) : Number
	{
		for (var i : Number = _mediaFiles.length - 1;i >= 0; i--) if (MediaFile(_mediaFiles[i]).id == imageID_) return i;
	}

	/*
	 * Initial loading etc.
	 */
	private function onXMLLoaded() : Void
	{
		// hack to display the correct page title as the backend cant deliver it
		var xmlTitle : String = XMLNode(XPathAPI.selectSingleNode(_xml.firstChild, "Gallery/Title")).firstChild.nodeValue;
		if (xmlTitle.toLowerCase().indexOf("archive") >= 0) _title = "archive ";
		else _title = "";
		if (xmlTitle.toLowerCase().indexOf("car") >= 0) _title += "cars";
		else if (xmlTitle.toLowerCase().indexOf("people") >= 0) _title += "people";
		else if (xmlTitle.toLowerCase().indexOf("moods") >= 0) _title += "moods";
		
		
		var thumbnailPreloaderMC : MovieClip = _targetMC.createEmptyMovieClip("thumbPreload", 100);
		thumbnailPreloaderMC._visible = false;
		
		var node : XMLNode;
		var nodes : Array = XPathAPI.selectNodeList(_xml.firstChild, "/Gallery/MediaFile");
		var mediaFile : GalleryMediaFile;
		_thumbnailLoader = new GroupLoader(this, GroupLoaderProgressProxy.getInstance(), Label.getLabel("Loading.thumbnails"));
		_thumbnailLoader.groupLoaderProgressProxy = GroupLoaderProgressProxy.getInstance();
		_mediaFiles = new Array();

		// total amount of images must not be more than 26! (a..z)
		//var total : Number = Math.min(nodes.length, 26);
		var total : Number = Math.min(nodes.length, 40);
		for (var i : Number = 0;i < total; i++)
		{
			node = nodes[i];
			mediaFile = GalleryMediaFile.createFromXMLNode(node);
			mediaFile.thumbnailLoaderMC = thumbnailPreloaderMC.createEmptyMovieClip("thumb_" + i, 1 + i);
			_thumbnailLoader.addFile(mediaFile.thumbnailLoaderMC, mediaFile.previewSrc, 100, "thumb");
			_mediaFiles.push(mediaFile);
		}
		
		delete _xml;
		_thumbnailLoader.start();
	}

	private function onThumbnailsLoaded() : Void
	{
		initializeGallery();
	}

	// PriorityLoader function for xml
	public function onLoadComplete(file : FileItem) : Void
	{
		if (file.id == "xml") onXMLLoaded();
	}

	// Group loader functions for thumbnail preloading
	public function onGroupStart(groupLoader : GroupLoader) : Void 
	{
	}

	public function onGroupComplete(groupLoader : GroupLoader) : Void
	{
		for (var i : Number = _mediaFiles.length - 1;i >= 0; i--) GalleryMediaFile(_mediaFiles[i]).createThumbnailBitmap();
		onThumbnailsLoaded();
	}

	public function onGroupProgress(filesLoaded : Number, filesTotal : Number, bytesLoaded : Number, bytesTotal : Number, percent : Number, groupLoader : GroupLoader) : Void 
	{
	}

	public function finalize() : Void
	{
		for (var i : Number = _mediaFiles.length - 1;i >= 0; i--) GalleryMediaFile(_mediaFiles[i]).finalize();
		delete _mediaFiles;
		_arrowNavigation.finalize();
		_galleryNavigation.finalize();
		_galleryController.finalize();
		_menuMC.removeMovieClip();
		_arrowsMC.removeMovieClip();
		super.finalize();
	}
}