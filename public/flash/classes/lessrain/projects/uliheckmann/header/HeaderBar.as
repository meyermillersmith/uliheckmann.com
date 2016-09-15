import lessrain.lib.utils.assets.Label;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.header.ButtonEvent;
import lessrain.projects.uliheckmann.header.HeaderEvent;
import lessrain.projects.uliheckmann.header.HeaderLine;
import lessrain.projects.uliheckmann.header.SoundButton;
import lessrain.projects.uliheckmann.header.TextButton;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;
import lessrain.lib.utils.assets.Link;
import lessrain.lib.utils.assets.Source;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.header.HeaderBar implements IDistributor
{
	// Is native fullscreen mode supported? (Available for player 9.0.28 and later)
	public static var SUPPORTS_NATIVE_FS_MODE:Boolean = Stage["displayState"] != undefined;
	
	public static var STATE_HOME:Number=1;
	public static var STATE_PAGE:Number=2;
	
	public static var BUTTON_NONE:Number=0;
	public static var BUTTON_MENU:Number=1;
	public static var BUTTON_SUB_MENU:Number=2;
	public static var BUTTON_SUB_MENU_PAGE:Number=3;
	public static var BUTTON_MENU_SUB_MENU_PAGE:Number=4;
	
	private var _buttonOffsetX:Number;
	
	private var _targetMC:MovieClip;
	private var _eventDistributor : EventDistributor;

	private var _title : TextButton;
	private var _state : Number;
	private var _hasSubMenu : Boolean;

	private var _menuButton : TextButton;
	private var _separator : HeaderLine;
	private var _subMenuButton : TextButton;
	private var _progress : TextButton;
	private var _sound : SoundButton;

	private var _slideshowButton : TextButton;
	private var _slideshowVisible : Boolean;
	private var _design : TextButton;
	private var _lessrain : TextButton;
	private var _lessrainWordWidth : Number;

	private var _designWidth : Number;
	
	public function HeaderBar(targetMC_:MovieClip)
	{
		_buttonOffsetX = GlobalSettings.getInstance().contentLeft-3;
		_hasSubMenu=false;
		_targetMC=targetMC_;
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	public function initialize():Void
	{
		_title = new TextButton( _targetMC.createEmptyMovieClip("title",10), Label.getLabel("Header.title") );
		_title.setPosition(_buttonOffsetX,12);
		_title.initialize();
		_title.show();
		
		_menuButton = new TextButton( _targetMC.createEmptyMovieClip("menuButton",11), Label.getLabel("Header.menu"), true );
		_menuButton.addEventListener( ButtonEvent.RELEASE, Proxy.create(this, onButtonRelease) );
		_menuButton.setPosition(_buttonOffsetX,12);
		_menuButton.initialize();
		
		_separator = new HeaderLine( _targetMC.createEmptyMovieClip("separator",12) );
		_separator.setPosition(_menuButton.x+_menuButton.width+3,12);
		_separator.initialize();
		
		_subMenuButton = new TextButton( _targetMC.createEmptyMovieClip("subMenuButton",13), "", true );
		_subMenuButton.addEventListener( ButtonEvent.RELEASE, Proxy.create(this, onButtonRelease) );
		_subMenuButton.setPosition(_separator.x+_separator.width+2,12);
		_subMenuButton.initialize();
		
		_slideshowButton = new TextButton( _targetMC.createEmptyMovieClip("slideshowButton",14), Label.getLabel("Header.slideshow"), true );
		_slideshowButton.addEventListener( ButtonEvent.RELEASE, Proxy.create(this, onButtonRelease) );
		_slideshowButton.setPosition(_buttonOffsetX+192,12);
		_slideshowButton.initialize();
		
		if (Source.getSource("Soundtrack") != null)
		{
			_sound = new SoundButton( _targetMC.createEmptyMovieClip("sound",20) );
			_sound.addEventListener( ButtonEvent.RELEASE, Proxy.create(this, onButtonRelease) );
			_sound.setPosition(750-2,12);
			_sound.initialize();
			_sound.setEnabled(true);
			_sound.show();
		}
		
		if (SUPPORTS_NATIVE_FS_MODE)
		{
		}
		
		_design = new TextButton( _targetMC.createEmptyMovieClip("design",25), Label.getLabel("Credits.design") );
		_design.initialize();
		_designWidth = _design.width;
		_design.show();
		_design.invert();
		
		_lessrain = new TextButton( _targetMC.createEmptyMovieClip("lessrain",26), Link.getLink("Credits.lessrain").title );
		_lessrain.addEventListener( ButtonEvent.RELEASE, Proxy.create(this, onButtonRelease) );
		_lessrain.initialize();
		_lessrain.show();
		
		_design.rotate(-90);
		_lessrain.rotate(-90);
		
		_progress = new TextButton( _targetMC.createEmptyMovieClip("progress",30) );
		_progress.setPosition(_buttonOffsetX+352,12);
		_progress.initialize();
		
		onResize();
		if (GlobalSettings.getInstance().enableFullscreen)
		{
			Stage.addListener(this);
		}
	}
	
	private function onResize():Void
	{
		_targetMC._x = GlobalFunctions.getCenterStageX();
		
		_design.setPosition(Stage.width-GlobalFunctions.getCenterStageX()-20, GlobalFunctions.getCenterStageY()+578);
		_lessrain.setPosition(Stage.width-GlobalFunctions.getCenterStageX()-20, GlobalFunctions.getCenterStageY()+578-_designWidth+2);
	}
	
	public function getProgressField():TextButton
	{
		return _progress;
	}
	
	public function setState(state_:Number):Void
	{
		_state = state_;
		updateState();
	}
	
	public function showSubSection(title_:String, hasSubMenu_:Boolean):Void
	{
		_hasSubMenu=hasSubMenu_;
		_subMenuButton.setText(title_);
		_subMenuButton.show();
		_subMenuButton.setEnabled(_hasSubMenu);
		_separator.show();
	}
	
	public function hideSubSection():Void
	{
		_hasSubMenu=false;
		_subMenuButton.hide();
		_separator.hide();
	}
	
	public function setActiveButton(buttonType_:Number):Void
	{
		if (buttonType_==BUTTON_MENU)
		{
			_menuButton.revert();
			_subMenuButton.invert();
			_subMenuButton.setEnabled(_hasSubMenu);
			updateSlideshowButton(false);
		}
		else if (buttonType_==BUTTON_SUB_MENU)
		{
			_menuButton.invert();
			_subMenuButton.revert();
			updateSlideshowButton(false);
		}
		else if (buttonType_==BUTTON_SUB_MENU_PAGE)
		{
			_menuButton.invert();
			_subMenuButton.revert();
			_subMenuButton.setEnabled(false);
			updateSlideshowButton(_slideshowVisible);
		}
		else if (buttonType_==BUTTON_MENU_SUB_MENU_PAGE)
		{
			_menuButton.revert();
			_subMenuButton.revert();
			_subMenuButton.setEnabled(false);
			updateSlideshowButton(_slideshowVisible);
		}
		else if (buttonType_==BUTTON_NONE)
		{
			_menuButton.invert();
			_menuButton.setEnabled(true);
			_subMenuButton.invert();
			_subMenuButton.setEnabled(_hasSubMenu);
			updateSlideshowButton(_slideshowVisible);
		}
	}
	
	public function setSlideshowState(isActive_:Boolean):Void
	{
		if (_slideshowVisible)
		{
			if (isActive_) _slideshowButton.revert();
			else _slideshowButton.invert();
		}
	}
	
	public function setSlideshowVisible(isVisible_:Boolean):Void
	{
		_slideshowVisible = isVisible_;
		_slideshowButton.invert();
		updateSlideshowButton(_slideshowVisible);
	}
	
	private function updateSlideshowButton(isVisible_:Boolean):Void
	{
		if (isVisible_)
		{
			_slideshowButton.setEnabled(true);
			_slideshowButton.show();
		}
		else
		{
			_slideshowButton.setEnabled(false);
			_slideshowButton.hide();
		}
	}
	
	private function updateState():Void
	{
		if (_state==STATE_HOME)
		{
			_separator.hide();
			_subMenuButton.hide();
			_menuButton.setEnabled(false);
			_menuButton.hide();
			_title.revert();
			_title.show();
			if (_sound!=null) _sound.revert();
			_progress.revert();
			_design.show();
			_lessrain.show();
		}
		else if (_state==STATE_PAGE)
		{
			_menuButton.setEnabled(true);
			_menuButton.invert();
			_menuButton.show();
			_title.hide();
//			if (_hasSubMenu)
			{
				_separator.invert();
				_subMenuButton.invert();
			}
			if (_sound!=null) _sound.invert();
			_progress.invert();
			_design.hide();
			_lessrain.hide();
		}
	}
	
	private function onButtonRelease( buttonEvent:ButtonEvent ):Void
	{
		if (buttonEvent.getButton()==_menuButton) distributeEvent( new HeaderEvent(HeaderEvent.TOGGLE_MENU) );
		else if (buttonEvent.getButton()==_subMenuButton) distributeEvent( new HeaderEvent(HeaderEvent.TOGGLE_SUB_MENU) );
		else if (buttonEvent.getButton()==_slideshowButton) distributeEvent( new HeaderEvent(HeaderEvent.TOGGLE_SLIDESHOW) );
		else if (buttonEvent.getButton()==_lessrain) getURL(Link.getLink("Credits.lessrain").href);
	}

	public function finalize():Void
	{
		_targetMC.removeMovieClip();
	}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}

}