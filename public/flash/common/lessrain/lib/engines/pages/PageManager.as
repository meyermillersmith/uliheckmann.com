/**
 * PageManager contains the main logic for a page-based, browser-button-supported application
 * Every project will implement MyPage classes based on the Page class provided in this package
 * To create those Pages depending on the pageID passed from the browser-location bar every
 * project will implement a PageFactory.
 * 
 * All the PageManager needs is a targetMC to create Pages in, the ID of the Page to load by default, and the PageFactory
 * The communication to the browser is handled by the StatePageManager
 * 
 * You can easily test the functionality in your application by using the sample classes provided in this package:
 * 
 * <code>
 * _pageManager = new PageManager( _targetMC.createEmptyMovieClip("pageManager", 10), "HomePage", new SamplePageFactory() );
 * _pageManager.initialize();
 * </code>
 * 
 * @see lessrain.lib.engines.pages.StatePageManager
 * @see lessrain.lib.engines.pages.Page
 * @see lessrain.lib.engines.pages.IPageFactory
 * @see lessrain.lib.engines.pages.SamplePage
 * @see lessrain.lib.engines.pages.SamplePageFactory
 */

import lessrain.lib.engines.pages.IPageFactory;
import lessrain.lib.engines.pages.Page;
import lessrain.lib.engines.pages.PageEvent;
import lessrain.lib.engines.pages.StatePageEvent;
import lessrain.lib.engines.pages.StatePageManager;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @author Luis Martinez, Less Rain (luis@lessrain.net)
 */
class lessrain.lib.engines.pages.PageManager implements IDistributor
{
	/**
	 * Helper function for pageIDs. Returns the whole "."-notated pageID String or a certain part of it.
	 * @param	pageID		The "."-notated pageID String to be processed
	 * @param	level			The level/part of the "."-notated pageID String to be returned. If ommited or &lt;0 the whole input String is returned
	 */	
	public static function getPageIDPart( pageID:String, level:Number ):String
	{
		if (level==null || level<0) return pageID;
		else
		{
			// remove leading and trailing slashes to get proper level behaviour
			if (pageID.indexOf("/")==0) pageID=pageID.substr(1);
			if (pageID.indexOf("/")==pageID.length-1) pageID=pageID.substr(0,pageID.length-1);
			
			var stack:Array = pageID.split("/");
			if (level>=stack.length) return null;
			else return stack[ level ];
		}
	}
		
	private var _targetMC				:	MovieClip;
	private var _defaultPageID			:	String;
	private var _pageFactory			:	IPageFactory;
	
	private var _currentPage			:	Page;
	private var _oldPage				:	Page;

	private var _pageCount				:	Number;

	private var _pageHiddenProxy 		: 	Function;
	private var _pageShowingProxy 		: 	Function;
	private var _pageInitializedProxy 	: 	Function;

	private var _eventDistributor 		: 	EventDistributor;
	private var _statePageManager 		: 	StatePageManager;
	
	public function PageManager( targetMC_:MovieClip, defaultPageID_:String, pageFactory_:IPageFactory )
	{
		_pageCount				=	0;
		
		_targetMC 				= 	targetMC_;		_defaultPageID 			= 	defaultPageID_;		_pageFactory 			= 	pageFactory_;
		
		_pageInitializedProxy 	= 	Proxy.create(this,onPageInitialized);
		_pageShowingProxy 		= 	Proxy.create(this,onPageShowing);
		_pageHiddenProxy 		= 	Proxy.create(this,onPageHidden);
		
		_eventDistributor 		= 	new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	public function initialize():Void
	{
		_statePageManager = StatePageManager.getInstance();
		_statePageManager.addEventListener(StatePageEvent.CHANGE,Proxy.create(this,stateChange));
		_statePageManager.initialize(_defaultPageID,true);

	}
	
	public function updateStatePageManager(pageID:String) :Void
	{
		if (_statePageManager!=null) _statePageManager.setValue( pageID );
	}
	
	private function stateChange(statePageEvent : StatePageEvent):Void
	{
		gotoPage( _statePageManager.getValue(), false );
	}
	
	public function loadPage( pageID:String ):Void
	{
		if (_statePageManager!=null) _statePageManager.setValue( pageID );
		else gotoPage( pageID, false, true );
	}
	
	public function reloadPage():Void
	{
		gotoPage( _currentPage.pageID, true, false );
	}
	
	private function gotoPage( pageID:String, forceReload:Boolean, finalize:Boolean ):Void
	{
		var pageClassID:String = getPageIDPart(pageID,0);
		
		// If the page stays the same, and the page takes care of the contentID/contentState change itself, leave the function!
		if ( !forceReload && _currentPage.getPageIDPart(0)==pageClassID &&  _currentPage.updateContent(pageID) ) return;
		
		// If the old page isn't hidden yet, kill it (happens when clicking through quickly
		if (_oldPage!=null || _oldPage.state!=Page.stateHidden) removeOldPage();
		
		// Save the reference to the current page
		if (_currentPage!=null) _oldPage = _currentPage;
		
		_pageCount++;
		
		// Create a target MC for the new page
		var pageMC:MovieClip = _targetMC.createEmptyMovieClip("page_"+_pageCount, _pageCount);
		
		// Let the PageFactory create an instance of the Page class
		var page:Page = _pageFactory.createPage(pageClassID, pageID);
		if (page==null)
		{
			_oldPage = null;
			pageMC.removeMovieClip();
			return;
		}
		_currentPage = page;
		
		// Set the page properties
		_currentPage.pageID			=	pageID;
		_currentPage.targetMC		=	pageMC;
		_currentPage.pageManager	=	this;
		distributeEvent( new PageEvent( PageEvent.PAGE_CHANGE, _currentPage ) );
		
		// Listen to events necessary for page handling
		_currentPage.addEventListener( PageEvent.PAGE_INITIALIZED, _pageInitializedProxy);
		_currentPage.addEventListener( PageEvent.PAGE_SHOWING , _pageShowingProxy);
		_currentPage.addEventListener( PageEvent.PAGE_HIDDEN, _pageHiddenProxy);
		
		// Hide the old page if it exists and initialize the new one
		if (_oldPage!=null) hideOldPage();
		else onPageHidden();
	}
	
	private function removeOldPage():Void
	{
		_oldPage.finalize();
		_oldPage=null;
		delete _oldPage;
	}
	
	private function onPageInitialized( pageEvent:PageEvent ):Void
	{
		_eventDistributor.distributeEvent( pageEvent );
		showCurrentPage();
	}
	
	private function onPageShowing( pageEvent:PageEvent ):Void
	{
		_eventDistributor.distributeEvent( pageEvent );
	}
	
	private function onPageHidden( pageEvent:PageEvent ):Void
	{
		_eventDistributor.distributeEvent( pageEvent );
		
		if (_oldPage!=_currentPage)
		{
			if (_oldPage!=null) removeOldPage();
			_currentPage.initialize();
		}
	}
	
	private function showCurrentPage():Void
	{
		currentPage.show();
	}
	
	private function hideOldPage():Void
	{
		oldPage.hide();
	}
	
	/**
	 * Set the title on the browser bar
	 * @param	title_		A String for the default page.
	 * @param	format_		A String for the format settings [see StatePageTitleFormat].
	 * 
	 * @see StatePageManager and StatePageTitleFormat
	 */
	public function setPageTitle(title_:String,format_:String):Void
	{
		_statePageManager.setTitle(title_,format_);
	}
	public function get targetMC() : MovieClip { return _targetMC; }
	public function set targetMC( targetMC_:MovieClip ) { _targetMC = targetMC_; }
	
	public function get defaultPageID():String { return _defaultPageID; }
	public function set defaultPageID(defaultPageID_:String):Void { _defaultPageID=defaultPageID_; }
	
	public function get pageFactory():IPageFactory { return _pageFactory; }
	public function set pageFactory(pageFactory_:IPageFactory):Void { _pageFactory=pageFactory_; }
	
	public function get oldPage():Page { return _oldPage; }
	public function get currentPage():Page { return _currentPage; }
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}

}