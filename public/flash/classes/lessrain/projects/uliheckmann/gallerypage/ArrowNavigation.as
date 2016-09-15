import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.gallerypage.GalleryEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryLetter;
import lessrain.projects.uliheckmann.gallerypage.GalleryLetterEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryMediaFile;
import lessrain.projects.uliheckmann.header.HeaderEvent;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.geom.Coordinate;
import lessrain.projects.uliheckmann.effects.Word;

import flash.display.BitmapData;

import lessrain.lib.utils.logger.LogManager;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.lib.utils.graphics.ShapeUtils;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.ArrowNavigation implements IDistributor, FileListener
{
	private var _targetMC : MovieClip;

	private var _nextArrow : GalleryLetter;
	private var _prevArrow : GalleryLetter;

	private var _total : Number;
	private var _pos : Number;

	private var _eventDistributor : EventDistributor;
	private var _releaseProxy : Function;

	private var _isEnabled : Boolean;

	private var _menuArrow : GalleryLetter;
	private var _fillMC : MovieClip;
	private var _archiveButtonMC : MovieClip;
	private var _archiveWord : Word;
	private var _archiveFillLoaded : Boolean;
	private var _archiveFillBitmap : BitmapData;
	private var _archiveLink : String;
	private var _defaultFill : BitmapData;
	private var _archiveButtonHitMC : MovieClip;
	private var _showFillWhenLoaded : Boolean;

	public function ArrowNavigation(targetMC_ : MovieClip, total_ : Number, archiveLink_ : String)
	{
		_targetMC = targetMC_;
		_pos = 0;
		_isEnabled = false;
		_total = total_;
		_archiveLink = archiveLink_;
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}

	public function initialize() : Void
	{
		_releaseProxy = Proxy.create(this, onArrowRelease);
		
		_prevArrow = new GalleryLetter(_targetMC.createEmptyMovieClip("prevArrow", 11), "prev", "arrow_left");
		_prevArrow.setPos(GlobalSettings.getInstance().contentLeft, Stage.height - 125);
		_prevArrow.addEventListener(GalleryLetterEvent.RELEASE, _releaseProxy);
		_prevArrow.initialize();
		
		_nextArrow = new GalleryLetter(_targetMC.createEmptyMovieClip("nextArrow", 12), "next", "arrow_right");
		_nextArrow.setPos(GlobalSettings.getInstance().stageWidth - GlobalSettings.getInstance().contentLeft - _nextArrow.width, Stage.height - 125);
		_nextArrow.addEventListener(GalleryLetterEvent.RELEASE, _releaseProxy);
		_nextArrow.initialize();
		
		_defaultFill = new BitmapData(_prevArrow.width, _prevArrow.height, false, 0x000000);
		
		_fillMC = _targetMC.createEmptyMovieClip("fill", 1);
		_archiveButtonHitMC = _targetMC.createEmptyMovieClip("archiveButtonHit", 2);
		_archiveButtonMC = _targetMC.createEmptyMovieClip("archiveButton", 3);
		
		_menuArrow = new GalleryLetter( _targetMC.createEmptyMovieClip("menu",10), "menu", "menu" );
		_menuArrow.setPos((GlobalSettings.getInstance().stageWidth - _menuArrow.width) / 2, Stage.height - 125);
		_menuArrow.addEventListener( GalleryLetterEvent.RELEASE, _releaseProxy );
		_menuArrow.initialize();

		if (_archiveLink != null) loadFill();

		if (GlobalSettings.getInstance().enableFullscreen)
		{
			onResize();
			Stage.addListener(this);
		}
	}

	public function enable() : Void
	{
		if (!_isEnabled)
		{
			_isEnabled = true;
			_prevArrow.enable();
			_nextArrow.enable();
			_menuArrow.enable();
			_menuArrow.show();
			if (_pos >= _total - 1 && _archiveLink != null) showArchive();
		}
	}

	public function disable() : Void
	{
		if (_isEnabled)
		{
			_isEnabled = false;
			_prevArrow.disable();
			_nextArrow.disable();
			_menuArrow.disable();
			if (_archiveLink != null) hideArchive();
		}
	}

	public function show() : Void
	{
		update(_pos);
	}

	public function hide() : Void
	{
		_prevArrow.hide(true);
		_nextArrow.hide(true);
		_menuArrow.hide(true);
	}

	private function onResize() : Void
	{
		_prevArrow.setPos(GlobalSettings.getInstance().contentLeft, Stage.height - 125);
		_nextArrow.setPos(GlobalSettings.getInstance().stageWidth - GlobalSettings.getInstance().contentLeft - _nextArrow.width, Stage.height - 125);
		_menuArrow.setPos((GlobalSettings.getInstance().stageWidth - _menuArrow.width) / 2, Stage.height - 125);
		_archiveWord.setPos(GlobalSettings.getInstance().stageWidth - GlobalSettings.getInstance().contentLeft - _archiveWord.width, Stage.height - 125 - 18);
	}

	public function update( pos_ : Number, prevMediaFile : GalleryMediaFile, nextMediaFile : GalleryMediaFile, currMediaFile: GalleryMediaFile ) : Void
	{
		_pos = pos_;
		if (_pos > 0) _prevArrow.show();
		else _prevArrow.hide();
		
		if (_pos < _total - 1)
		{
			if (_archiveLink != null) hideArchive();
			_nextArrow.show();
		}
		else
		{
			if (_archiveLink != null) showArchive();
			_nextArrow.hide();
		}
		
		if (prevMediaFile != null && _prevArrow.isShowing) _prevArrow.setFill(prevMediaFile.id, prevMediaFile.thumbnailBitmap);
		//else _prevArrow.setFill("default", _defaultFill);
		if (nextMediaFile != null && _nextArrow.isShowing) _nextArrow.setFill(nextMediaFile.id, nextMediaFile.thumbnailBitmap);
		//else _nextArrow.setFill("default", _defaultFill);
		
		if (currMediaFile != null) _menuArrow.setFill(currMediaFile.id, currMediaFile.thumbnailBitmap);
		//else _menuArrow.setFill("default", _defaultFill);
		
		Mouse.show();
	}

	private function loadFill() : Void
	{
		_fillMC._visible = false;
		PriorityLoader.getInstance().addFile(_fillMC.createEmptyMovieClip("holder", 1), lessrain.lib.utils.assets.Image.getImage("fill.main"), this, 10, "fill");
	}

	private function fillLoaded() : Void
	{
		_archiveFillLoaded = true;
		var archivePosition : Coordinate = new Coordinate(96, 216);
		
		_archiveWord = new Word(_archiveButtonMC, "MORE", archivePosition.x, archivePosition.y);
		_archiveFillBitmap = new BitmapData(_fillMC._width, _fillMC._height, false);
		_archiveFillBitmap.draw(_fillMC);
		_fillMC.holder.removeMovieClip();
		_fillMC.removeMovieClip();
		_archiveWord.initialize();
		
		_archiveWord.setPos(GlobalSettings.getInstance().stageWidth - GlobalSettings.getInstance().contentLeft - _archiveWord.width, Stage.height - 125 - 18);

		_archiveWord.setMode(Letter.MODE_MENU);
		_archiveWord.addFill("car", _archiveFillBitmap);
		_archiveWord.setFill("car");
		
		ShapeUtils.drawRectangle(_archiveButtonHitMC, _archiveWord.x, _archiveWord.y, _archiveWord.width, _archiveWord.height, 0x000000, 0);
		_archiveButtonHitMC.onRollOver = Proxy.create(this, onArchiveOver);
		_archiveButtonHitMC.onRollOut = _archiveButtonHitMC.onReleaseOutside = Proxy.create(this, onArchiveOut);
		_archiveButtonHitMC.onRelease = Proxy.create(this, onArchiveClick);

		if (_showFillWhenLoaded) showArchive();
	}

	private function showArchive() : Void
	{
		if (_archiveFillLoaded)
		{
			_archiveWord.setState(Letter.STATE_ANTS);
			_archiveButtonHitMC._visible=true;
		}
		else
		{
			_showFillWhenLoaded=true;
		}
	}

	private function hideArchive() : Void
	{
		_archiveWord.setState(Letter.STATE_INVISIBLE);
		_archiveButtonHitMC._visible=false;
		_showFillWhenLoaded=false;
	}

	private function onArchiveOver() : Void
	{
		_archiveWord.setState(Letter.STATE_BOTH);
	}

	private function onArchiveOut() : Void
	{
		_archiveWord.setState(Letter.STATE_ANTS);
	}

	private function onArchiveClick() : Void
	{
		_archiveWord.setState(Letter.STATE_ANTS);
		_archiveButtonHitMC._visible=false;
		distributeEvent(new GalleryEvent(GalleryEvent.GOTO_ARCHIVE, _archiveLink));
	}

	private function onArrowRelease( galleryLetterEvent_ : GalleryLetterEvent ) : Void
	{
		if (galleryLetterEvent_.getID() == "next")
		{
			if (_pos < _total - 1) distributeEvent(new GalleryEvent(GalleryEvent.IMAGE_SELECT, null, _pos + 1));
		}
		else if (galleryLetterEvent_.getID() == "prev")
		{
			if (_pos > 0) distributeEvent(new GalleryEvent(GalleryEvent.IMAGE_SELECT, null, _pos - 1));
		}
		else if (galleryLetterEvent_.getID() == "menu")
		{
			//distributeEvent(new HeaderEvent(HeaderEvent.TOGGLE_MENU));
			distributeEvent( new HeaderEvent(HeaderEvent.TOGGLE_SUB_MENU) );
		}
	}

	public function finalize() : Void
	{
		_prevArrow.finalize();
		_nextArrow.finalize();
		_menuArrow.finalize();
		_eventDistributor.finalize();
		_targetMC.removeMovieClip();
	}

	public function get targetMC() : MovieClip 
	{ 
		return _targetMC; 
	}

	public function set targetMC(value : MovieClip) : Void 
	{ 
		_targetMC = value; 
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

	
	public function onLoadStart(file : FileItem) : Boolean
	{
		return false;
	}

	public function onLoadComplete(file : FileItem) : Void
	{
		fillLoaded();
	}

	public function onLoadProgress(file : FileItem, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void
	{
	}
}