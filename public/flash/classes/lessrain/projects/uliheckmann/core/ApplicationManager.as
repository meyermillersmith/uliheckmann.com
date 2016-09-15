import lessrain.lib.utils.CallDelay;
import lessrain.lib.utils.assets.Label;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.LetterMaskFactory;
import lessrain.lib.engines.pages.PageEvent;
import lessrain.lib.engines.pages.PageManager;
import lessrain.lib.utils.Proxy;
import lessrain.projects.uliheckmann.core.DimEvent;
import lessrain.projects.uliheckmann.core.DimPage;
import lessrain.projects.uliheckmann.core.PageFactory;
import lessrain.projects.uliheckmann.gallerypage.GalleryEvent;
import lessrain.projects.uliheckmann.gallerypage.GalleryPage;
import lessrain.projects.uliheckmann.header.HeaderBar;
import lessrain.projects.uliheckmann.header.HeaderEvent;
import lessrain.projects.uliheckmann.header.LoadingDisplay;
import lessrain.projects.uliheckmann.header.PageFrame;
import lessrain.projects.uliheckmann.navigation.Navigation;
import lessrain.projects.uliheckmann.navigation.NavigationEvent;
import lessrain.lib.engines.pages.StatePageManager;
import lessrain.projects.uliheckmann.sound.SoundController;
import lessrain.projects.uliheckmann.core.EmptyPage;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.lib.utils.assets.Source;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.core.ApplicationManager
{
	private var _targetMC:MovieClip;
	private var _navigation : Navigation;
	private var _pageManager : PageManager;
	private var _headerBar : HeaderBar;
	private var _loadingDisplay : LoadingDisplay;

	private var _pageFrame : PageFrame;

	public function ApplicationManager(targetMC_:MovieClip)
	{
		_targetMC=targetMC_;
	}
	
	public function initialize():Void
	{
		Letter.LETTER_SPACING = parseFloat(Label.getLabel("Setting.Letter.Spacing"));
		Letter.LINE_SPACING = parseFloat(Label.getLabel("Setting.Letter.Line.Spacing"));
		Letter.SPACE_WIDTH = parseFloat(Label.getLabel("Setting.Letter.Space.Width"));
		
		LetterMaskFactory.getInstance().setTargetMC(_targetMC.createEmptyMovieClip("letterMaskFactory", 1));
		
		//_pageFrame = new PageFrame( _targetMC.createEmptyMovieClip("frame", 19) );
		//_pageFrame.initialize();
		
		if (Source.getSource("Soundtrack") != null)
		{
			SoundController.getInstance().targetMC = _targetMC.createEmptyMovieClip("sound", 7);
			SoundController.getInstance().initialize();
		}
		
		_headerBar = new HeaderBar( _targetMC.createEmptyMovieClip("header", 20) );
		_headerBar.addEventListener(HeaderEvent.TOGGLE_MENU, Proxy.create(this, onToggleMenu));
		_headerBar.addEventListener(HeaderEvent.TOGGLE_SUB_MENU, Proxy.create(this, onToggleSubMenu));
		_headerBar.addEventListener(HeaderEvent.TOGGLE_SLIDESHOW, Proxy.create(this, onToggleSlideshow));
		_headerBar.initialize();
		_headerBar.setState(HeaderBar.STATE_HOME);
		
		_loadingDisplay = new LoadingDisplay( _targetMC.createEmptyMovieClip("loading",21) );
		_loadingDisplay.setProgressField(_headerBar.getProgressField());
		_loadingDisplay.initialize();
		
		_navigation = new Navigation( _targetMC.createEmptyMovieClip("navigation", 11), !StatePageManager.getInstance().hasDeepLink() );
		_navigation.addEventListener(NavigationEvent.ITEM_SELECTED, Proxy.create(this, onNavigationItemSelected));
		_navigation.addEventListener(NavigationEvent.SHOWING, Proxy.create(this, onNavigationShowing));
		_navigation.addEventListener(NavigationEvent.HIDDEN, Proxy.create(this, onNavigationHidden));
		_navigation.addEventListener(HeaderEvent.TOGGLE_MENU, Proxy.create(this, onToggleMenu));
		_navigation.initialize();
	}
	
	private function onNavigationShowing( navEvent:NavigationEvent ) : Void
	{
		// the first time that the nav is showing the pagemanager needs to be initialized
		if (_pageManager==null)
		{
			CallDelay.call(Proxy.create(this, initPageManager), 50);
		}
	}
	private function initPageManager() : Void 
	{
		_pageManager = new PageManager( _targetMC.createEmptyMovieClip("pageManager", 10), "", new PageFactory() );
		_pageManager.addEventListener(PageEvent.PAGE_CHANGE, Proxy.create(this, onPageChange));
		_pageManager.initialize();
	}

	
	private function onNavigationHidden( navEvent:NavigationEvent ):Void
	{
		// in case of deeplinking the pagemanager is only initialized once the navigation has been hidden
		if (_pageManager==null)
		{
			initPageManager();
		}
		// if the navi has been hidden and the the subnavi of the page is not showing, the page needs to be undimmed
		if (!_navigation.isShowing && !DimPage(_pageManager.currentPage).subNavigationShowing) DimPage(_pageManager.currentPage).undim();
	}
	
	private function onPageDimmed(dimEvent:DimEvent):Void
	{
		if (!_navigation.isShowing) _navigation.showNodes( true );
	}
	
	private function onNavigationItemSelected(navigationEvent:NavigationEvent):Void
	{
		_pageManager.loadPage( navigationEvent.getSelectedNode().pageID );
	}
	
	private function onPageChange( pageEvent:PageEvent ):Void
	{
		if (_pageManager.currentPage instanceof EmptyPage)
		{
			_navigation.activateNode(null);
			_headerBar.setSlideshowVisible(false);
			_headerBar.hideSubSection();
			_headerBar.setState(HeaderBar.STATE_HOME);
			_headerBar.setActiveButton(HeaderBar.BUTTON_NONE);
			_navigation.showNodes();
		}
		else
		{
			pageEvent.getPage().addEventListener( DimEvent.DIMMED, Proxy.create(this,onPageDimmed) );
			pageEvent.getPage().addEventListener( DimEvent.HIDE_SUB_NAV, Proxy.create(this,onPageNavigationHidden) );
			pageEvent.getPage().addEventListener( HeaderEvent.TOGGLE_MENU, Proxy.create(this,onToggleMenu) );
			pageEvent.getPage().addEventListener( HeaderEvent.TOGGLE_SUB_MENU, Proxy.create(this,onToggleSubMenu) );
			
			_navigation.activateNode(_navigation.getNodeByPageID(pageEvent.getPage().getPageIDPart()));
			
			if (_pageManager.currentPage instanceof GalleryPage)
			{
				pageEvent.getPage().addEventListener( GalleryEvent.SLIDESHOW_DONE, Proxy.create(this,onSlideshowDone) );
				_headerBar.setSlideshowVisible(true);
			}
			else _headerBar.setSlideshowVisible(false);
			
			var navTitle:String;
			if (_navigation.activeNode.pageID.toLowerCase().indexOf("archive")>=0) navTitle = "archive "+_navigation.activeNode.title;
			else navTitle = _navigation.activeNode.title;
			if (DimPage(_pageManager.currentPage).hasSubNavigation) navTitle+=" overview";
			_headerBar.showSubSection( navTitle, DimPage(_pageManager.currentPage).hasSubNavigation );
			_headerBar.setState(HeaderBar.STATE_PAGE);
			
			if (!GlobalSettings.getInstance().enableIntermediatePage &&  DimPage(_pageManager.currentPage).hasSubNavigation) _headerBar.setActiveButton(HeaderBar.BUTTON_NONE);
			else _headerBar.setActiveButton(HeaderBar.BUTTON_SUB_MENU_PAGE);
			_navigation.hideNodes();
		}
	}
	
	private function onPageNavigationHidden(dimEvent_:DimEvent):Void
	{
		_headerBar.setActiveButton(HeaderBar.BUTTON_NONE);
	}
	
	private function onToggleMenu(headerEvent:HeaderEvent):Void
	{
		if (_navigation.isShowing)
		{
			if (!DimPage(_pageManager.currentPage).hasSubNavigation || DimPage(_pageManager.currentPage).intermediatePageShowing) _headerBar.setActiveButton(HeaderBar.BUTTON_SUB_MENU_PAGE);
			else _headerBar.setActiveButton(HeaderBar.BUTTON_NONE);
			_navigation.hideNodes(true);
		}
		else
		{
			if (DimPage(_pageManager.currentPage).subNavigationShowing)
			{
				DimPage(_pageManager.currentPage).hideSubNavigation();
				_navigation.showNodes( true );
			}
			else
			{
				DimPage(_pageManager.currentPage).dim( DimPage.ACTION_NAVI );
			}
			_headerBar.setActiveButton(HeaderBar.BUTTON_MENU);
			toggleSlideshow(false);
		}
	}
	
	private function onToggleSubMenu(headerEvent:HeaderEvent):Void
	{
		if (DimPage(_pageManager.currentPage).subNavigationShowing)
		{
			_headerBar.setActiveButton(HeaderBar.BUTTON_NONE);
			DimPage(_pageManager.currentPage).hideSubNavigation();
			DimPage(_pageManager.currentPage).undim(500);
		}
		else
		{
			if (_navigation.isShowing)
			{
				_navigation.hideNodes(true);
				DimPage(_pageManager.currentPage).showSubNavigation();
			}
			else
			{
				DimPage(_pageManager.currentPage).dim( DimPage.ACTION_SUB_NAVI );
			}
			if (DimPage(_pageManager.currentPage).intermediatePageShowing)
			{
				_headerBar.setActiveButton(HeaderBar.BUTTON_SUB_MENU_PAGE);
			}
			else
			{
				_headerBar.setActiveButton(HeaderBar.BUTTON_SUB_MENU);
			}
			toggleSlideshow(false);
		}
	}
	
	private function onToggleSlideshow(headerEvent:HeaderEvent):Void
	{
		toggleSlideshow();
	}
	
	public function toggleSlideshow( setRunningState_:Boolean ) : Void
	{
		GalleryPage(_pageManager.currentPage).toggleSlideshow(setRunningState_);
		_headerBar.setSlideshowState( GalleryPage(_pageManager.currentPage).isSlideshowActive() );
	}
	
	private function onSlideshowDone():Void
	{
		if (!GalleryPage(_pageManager.currentPage).isSlideshowActive()) _headerBar.setSlideshowState(false);
	}
	
	public function finalize():Void
	{
		_targetMC.removeMovieClip();
	}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
}