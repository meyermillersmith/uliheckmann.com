import lessrain.lib.engines.pages.PageEvent;
import lessrain.lib.engines.pages.PageManager;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileListener;

class lessrain.lib.engines.pages.Page implements IDistributor, FileListener
{
	// Possible page states
	public static var stateNone:Number = 0;
	public static var stateInitialized:Number = 1;
	public static var stateShowing:Number = 2;
	public static var stateHidden:Number = 3;
	
	// Member variables
	private var _targetMC:MovieClip;
	
	// Basic page properties
	private var _pageID:String;
	private var _pageManager:PageManager;
	
	// Only needed in case there will be pages requiring a login
	private var _isProtected:Boolean;
	private var _hasValidSession:Boolean;
	
	// Current state of the page
	private var _state:Number;
	
	private var _eventDistributor : EventDistributor;

	/**
	 * Constructur
	 */
	public function Page(targetMC:MovieClip)
	{
		_isProtected=false;
		_hasValidSession=false;
		_targetMC=targetMC;
		
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	/**
	 * Initializes the page, i.e. loads data, files etc. Is called by the PageController.
	 */
	public function initialize():Void	
	{
	}
	
	/**
	 * PageController sets the content properties of a page.
	 * Returns false if the PageController should create a whole new Page.
	 * Returns true If the Page itself takes care of constructing the new state.
	 * 
	 * @param	pageID			The ID of the next page that is currently being constructed
	 * @return	Boolean signaling to the PageController if the Page takes care of displaying the new state.
	 */
	public function updateContent( pageID:String ):Boolean
	{
		return false;
	}
	
	/**
	 * Shows the page. Is called by the PageController once the old Page is hidden and this Page is initialized
	 */
	public function show():Void	
	{
	}
	
	/**
	 * Hides the page. Is called by the PageController.
	 */
	public function hide():Void
	{
		if (_state != stateShowing) interrupt();
	}
		
	/**
	 * If the page is still loading, ie. not in stateInitialized, this function is called to do the necessary clean-up
	 */
	private function interrupt():Void
	{
		// do whatever you have to do if the page is not showing (i.e. is currently loading or animating) and should already be hidden
		dispatchPageHidden();
	}
	
	public function reload():Void
	{
		_pageManager.reloadPage();
	}
	
	private function dispatchPageInitialized():Void
	{
		_state = stateInitialized;
		_eventDistributor.distributeEvent( new PageEvent( PageEvent.PAGE_INITIALIZED, this ) );
	}
	
	private function dispatchPageShowing():Void
	{
		_state = stateShowing;
		_eventDistributor.distributeEvent( new PageEvent( PageEvent.PAGE_SHOWING, this ) );
	}
	
	private function dispatchPageHidden():Void
	{
		_state = stateHidden;
		_eventDistributor.distributeEvent( new PageEvent( PageEvent.PAGE_HIDDEN, this ) );
	}
	
	/**
	 * After the Page is hidden it should be finalized. Clean up all your MC's and objects
	 */
	public function finalize():Void
	{
		_eventDistributor.finalize();
		_targetMC.removeMovieClip();
		for (var i:String in this) delete this[i];
	}
	
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}
	
	public function onLoadStart(file : FileItem) : Boolean {return null;}
	public function onLoadComplete(file : FileItem) : Void { }
	public function onLoadProgress(file : FileItem, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void	{}
	
	/**
	 * Returns the whole pageID or a single part of the "/"-notated pageID-string
	 * @param	level		The level/part of the "/"-notated pageID-string to be returned. If ommited or &lt;0 the whole pageID is returned
	 */	
	public function getPageIDPart( level:Number ):String
	{
		return PageManager.getPageIDPart( _pageID, level );
	}
	
	// Getter & setter
	public function get pageID():String { return _pageID; }
	public function set pageID(value:String):Void { _pageID=value; }
	
	public function get pageManager():PageManager { return _pageManager; }
	public function set pageManager(value:PageManager):Void { _pageManager=value; }
	
	public function get isProtected():Boolean { return _isProtected; }
	public function set isProtected(value:Boolean):Void { _isProtected=value; }
	public function get hasValidSession():Boolean { return _hasValidSession; }
	public function set hasValidSession(value:Boolean):Void { _hasValidSession=value; }
	
	public function get state():Number { return _state; }
	public function set state(value:Number):Void { _state=value; }
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
}
