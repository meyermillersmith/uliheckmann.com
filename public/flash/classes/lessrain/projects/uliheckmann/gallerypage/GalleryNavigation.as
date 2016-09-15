import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.components.mediaplayer.MediaFile;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.Word;
import lessrain.projects.uliheckmann.gallerypage.GalleryEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryLetter;
import lessrain.projects.uliheckmann.gallerypage.GalleryLetterEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryMediaFile;
import lessrain.projects.uliheckmann.gallerypage.VisitedImages;
import lessrain.projects.uliheckmann.header.HeaderEvent;
import lessrain.projects.uliheckmann.config.GlobalSettings;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.gallerypage.GalleryNavigation implements IDistributor
{
	private var _targetMC:MovieClip;

	private var _total : Number;
	private var _pos : Number;

	private var _eventDistributor : EventDistributor;

	private var _title : String;
	private var _titleWord : Word;

	private var _letters : Array;

	private var _releaseProxy : Function;
	private var _mouseMoveProxy : Function;

	private var _isShowing : Boolean;
	private var _isEnabled : Boolean;

	private var _mediaFiles : Array;

	private var _menuArrow : GalleryLetter;
	
	public function GalleryNavigation(targetMC_:MovieClip, title_:String, mediaFiles_:Array)
	{
		_targetMC=targetMC_;
		_targetMC=targetMC_;
		_pos=0;
		_title=title_;
		_isShowing = false;
		_mediaFiles = mediaFiles_;
		_total = mediaFiles_.length;
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	public function initialize():Void
	{
		var letter:GalleryLetter;
		var char:String;
		var mediaFile:GalleryMediaFile;
		_letters = new Array();
		_releaseProxy = Proxy.create(this, onLetterRelease);
		_mouseMoveProxy = Proxy.create(this, onMouseMove);
		
		var xPos:Number = GlobalSettings.getInstance().contentLeft;
		var yPos:Number = GlobalSettings.getInstance().contentTop;
		
//		_menuArrow = new GalleryLetter( _targetMC.createEmptyMovieClip("menu",1), "menu", "arrow_up" );
//		_menuArrow.setPos(75,yPos);
//		_menuArrow.addEventListener( GalleryLetterEvent.RELEASE, _releaseProxy );
//		_menuArrow.initialize();
//		yPos+=_menuArrow.height;
		
		_titleWord = new Word(_targetMC.createEmptyMovieClip("title",2), _title, 0,0);
		_titleWord.setPos(xPos,yPos);
		_titleWord.initialize();
		_titleWord.setMode(Letter.MODE_GALLERY);
		yPos+=_titleWord.height;
		
		for (var i : Number = 0; i < _total; i++)
		{
			char =  String.fromCharCode(0x61+i);
			mediaFile = GalleryMediaFile(_mediaFiles[i]);
			//letter = new GalleryLetter( _targetMC.createEmptyMovieClip("letter_"+i,10+i), String(i), char );
			letter = new GalleryLetter( _targetMC.createEmptyMovieClip("letter_"+i,10+i), String(i), "round2" );
			letter.setPos(xPos,yPos);
			letter.addEventListener( GalleryLetterEvent.RELEASE, _releaseProxy );
			letter.isVisited = VisitedImages.getInstance().isVisited( mediaFile.id );
			letter.initialize();
			letter.setFill( mediaFile.id, mediaFile.thumbnailBitmap );
			_letters.push(letter);
			
			if ((i % 10) == 9)
			{
				xPos= GlobalSettings.getInstance().contentLeft;
				yPos+=letter.height;
			}
			else xPos+=letter.width;
			
			/*if (char=="l")
			{
				xPos=75;
				yPos+=letter.height;
			}
			else if (char=="u")
			{
				xPos=395;
				yPos+=letter.height;
			}
			else xPos+=letter.width;*/
		}
	}
	
	public function setBehaviour(behaviour_:Number):Void
	{
		for (var i : Number = _letters.length-1; i >= 0; i--) GalleryLetter(_letters[i]).setBehaviour(behaviour_);
	}
	
	public function updateVisited():Void
	{
		for (var i : Number = _letters.length-1; i >= 0; i--) GalleryLetter(_letters[i]).isVisited=VisitedImages.getInstance().isVisited( GalleryMediaFile(_mediaFiles[i]).id );
	}
	
	public function setActiveItemAndHide(index_ : Number) : Void
	{
		_isShowing = false;
		_titleWord.setState(Letter.STATE_INVISIBLE);
		_menuArrow.hide();
		
		var letter:GalleryLetter;
		for (var i : Number = _letters.length-1; i >= 0; i--)
		{
			letter = GalleryLetter(_letters[i]);
			
			if (i==index_) letter.activate();
			else if (letter.isActive) letter.deactivate();
			else letter.hide();
		}
	}
	
	public function enable():Void
	{
		_isEnabled = true;
		//_targetMC.onMouseMove = _mouseMoveProxy;
		for (var i : Number = _letters.length-1; i >= 0; i--) GalleryLetter(_letters[i]).enable();
	}
	
	public function disable():Void
	{
		_isEnabled = false;
		_targetMC.onMouseMove = null;
		for (var i : Number = _letters.length-1; i >= 0; i--) GalleryLetter(_letters[i]).disable();
	}
	
	private function onMouseMove():Void
	{
		if (_targetMC._ymouse>=45 && _targetMC._ymouse<_targetMC._height+50) show();
		else hide();
	}
	
	public function show():Void
	{
		if (!_isShowing)
		{
			_isShowing = true;
			_titleWord.setState(Letter.STATE_ANTS);
			_menuArrow.show();
			for (var i : Number = _letters.length-1; i >= 0; i--) GalleryLetter(_letters[i]).show();
		}
	}
	
	public function hide():Void
	{
		if (_isShowing)
		{
			_isShowing = false;
			_titleWord.setState(Letter.STATE_INVISIBLE);
			_menuArrow.hide();
			for (var i : Number = _letters.length-1; i >= 0; i--) GalleryLetter(_letters[i]).hide();
		}
	}
	
	private function onLetterRelease( galleryLetterEvent_:GalleryLetterEvent ):Void
	{
		if (galleryLetterEvent_.getID()=="menu")
		{
			distributeEvent( new HeaderEvent(HeaderEvent.TOGGLE_MENU) );
		}
		else
		{
			var index:Number = parseInt(galleryLetterEvent_.getID());
			distributeEvent( new GalleryEvent(GalleryEvent.IMAGE_SELECT,MediaFile(_mediaFiles[index]).id , index) );
		}
	}

	public function finalize():Void
	{
		for (var i : Number = _letters.length-1; i >= 0; i--) GalleryLetter(_letters[i]).finalize();
		delete _letters;
		_eventDistributor.finalize();
		_titleWord.finalize();
		_menuArrow.finalize();
		delete _mediaFiles;
		delete _releaseProxy;
		delete _mouseMoveProxy;
		_targetMC.removeMovieClip();
	}

	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }

}