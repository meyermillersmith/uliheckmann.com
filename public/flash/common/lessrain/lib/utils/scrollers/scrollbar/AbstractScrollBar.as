/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 *
 * PROPERTIES:
 * 
 * 				- scrollBarValue : Number [R/W]
 * 			
 * 				  		The scrollbar value from 0 to 1.0
 * 				  		
 * 				- sliderThumbPosition : Number [R/W]
 * 			
 * 				  		The sliderThumb position
 * 					
 * METHODS:
 * 			
 * 				- initialize : Void
 * 			
 * 				- createTray : Void [Abstract]
 * 				
 * 				  		Creates the tray part of the scrollbar 
 * 				   
 * 				- createSliderThumb : Void [Abstract]
 * 				
 * 				  		Creates the slider part of the scrollbar 
 * 				   
 * 				- redraw(sliderThumbLength_ : Number, range_ : Number, scrollBarValue_ : Number) : Void
 * 				
 * 				  		Redraw the scrollbar parts.
 * 				  		The sliderThumbLength_ parameter changes the length of the sliderThumb [width or height].
 * 				  		The range_ parameter changes the length of the tray [width or height].
 * 				  		The scrollBarValue_ parameter locks the sliderThumb in a fix position [hack].
 * 				  
 * 				- pageUp():Void
 * 				
 * 				  		Moves the sliderThumb over the tray one page to the top.
 * 				  
 * 				- pageDown():Void
 * 				
 * 				  		Moves the sliderThumb over the tray one page to the bottom.
 * 				  
 * 				- pageLeft():Void
 * 				
 * 				  		Moves the sliderThumb over the tray one page to the left.
 * 				  
 * 				- pageRight():Void
 * 				
 * 				  		Moves the sliderThumb over the tray one page to the right.
 * 				  
 * 				- setSliderThumbLength(sliderThumbLength_:Number) : Void
 * 				
 * 				  		Length of the sliderThumb. Width if the scrollbar orientation
 * 				  		is horizontal and height if the scrollbar orientation is
 * 				  		vertical
 * 				  
 * 				- getSliderThumbLength() : Number 
 * 				
 * 				- getOrientation() : String
 * 				
 * 				- getTargetMC() : MovieClip
 * 				
 * 				- setSlideOnTrayMode(slideOnTrayMode_ : String) : Void [see ScrollBarTrayMode]
 * 				
 * 						Set the mode to move the sliderThumb over 
 * 						the tray. [see ScrollBarTrayMode]
 * 						
 * 						Use ScrollBarConfig.TRAY_MODE static property to set
 * 						the _slideOnTrayMode property for all the ScrollBar instances.
 * 						
 * 						Use ScrollBarTrayTween [DURATION and EASE_FUNCTION] to set 
 * 						the default tween properties when ScrollBarConfig.TRAY_MODE is 
 * 						set TO_PAGE_TWEEN or TO_POINT_TWEEN
 * 						
 *				- addContextMenu(addContextMenu : Boolean) : Void
 * 				
 * 						Add custom context menu to the tray
 * 						
 * 						Use ScrollBarConfig.ADD_CONTEXT_MENU static property to set
 * 						the _addContextMenu property for all the ScrollBar instances.
 * 						
 * 						See ScrolBarContextMenuLabel for labels
 * 				
 * 				- getSlideOnTrayMode() : String
 * 				
 * 				- addEventListener(type : String, func : Function) : Void
 * 				
 * 				- removeEventListener(type : String, func : Function) : Void
 * 				
 * 				- distributeEvent(eventObject : IEvent) : Void
 * 				
 * 				- destroy():Void
 * 				
 * 				
 * EVENTS:
 * 		
 * 				- ScrollBarEvent.START_DRAG
 * 				
 * 				  		Distibuted when the sliderThumb is press
 * 				  
 * 				- ScrollBarEvent.STOP_DRAG
 * 				
 * 				  		Distibuted when the sliderThumb is release
 * 				  
 * 				- ScrollBarEvent.CHANGE
 * 				
 * 				  		Distibuted when the scrollbar changes in shape or value
 * 				
 * 					
 * IMPLEMENTS:
 * 
 * 				IDistributor	
 * 
 * 
 * SEE ALSO:
 * 
 * 				- EventDistributor
 * 				- IDistributor
 * 				- IEvent
 * 				- ScrollBarEvent
 * 				- ScrollBarOrientation
 * 				- ScrollBarContextMenuID
 * 				- ScrollBarContextMenuLabel
 * 				- CustomContextMenu
 * 				- CustomContextMenuEvent
 * 				- ISliderThumb
 * 				- ITray
 * 				- Proxy
 * 				- ScrollBarTrayMode
 * 				- ScrollBarTrayTween
 * 					
 * 
 */




import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.movieclip.CustomContextMenu;
import lessrain.lib.utils.movieclip.CustomContextMenuEvent;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarConfig;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarContextMenuID;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarContextMenuLabel;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarEvent;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarOrientation;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarTrayMode;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarTrayTween;
import lessrain.lib.utils.scrollers.scrollbar.sliderthumb.ISliderThumb;
import lessrain.lib.utils.scrollers.scrollbar.tray.ITray;
import lessrain.lib.utils.tween.TweenTimer;

class lessrain.lib.utils.scrollers.scrollbar.AbstractScrollBar implements IDistributor
{
	private var _targetMC 					: MovieClip;
	private var _sliderThumbMC				: MovieClip;
	private var _trayMC						: MovieClip;
	
	private var _sliderThumb				: ISliderThumb;
	private var _tray						: ITray;
	
	private var _length						: Number;
	private var _strength					: Number;
	
	private var _orientation				: String;
	private var _scrollBarValue				: Number;
	private var _sliderThumbPosition        : Number;
	private var _dragOffset					: Number;
	
	private var _slideOnTrayMode			: String;
	private var _slideOnTrayTween			: TweenTimer;
	
	// page scroll
	private var _scrollPageInterval			: Number;
	private var _scrollPageIntervalTicks	: Number;
	
	private var _eventDistributor 			: EventDistributor;
	
	// events
	private var  _startDragEvent 			: ScrollBarEvent;
	private var  _stopDragEvent 			: ScrollBarEvent;
	private var  _changeEvent 				: ScrollBarEvent;
	private var  _scrollUpEvent 			: ScrollBarEvent;
	private var  _scrollDownEvent 			: ScrollBarEvent;
	private var  _scrollLeftEvent 			: ScrollBarEvent;
	private var  _scrollRightEvent 			: ScrollBarEvent;
	
	private var  _trayClickEvent 			: ScrollBarEvent;
	private var  _cmSelectEvent 			: ScrollBarEvent;

	private var _addContextMenu             : Boolean;

	private var _pages						: Number;
	private var _smoothThumbPosValue		: Boolean;

	
	/**
	 * Constructor
	 * 
	 * @param targetMC_  			MovieClip container.
	 * @param strength_				Scrollbar  strength [width or height].
	 * 								If orientation is Horizontal the strength is the height.
	 * 								If orientation is Vertical the strength is the width.
	 * 								
	 * @param length_				Scrollbar length [width or height].
	 * 								If orientation is Horizontal the length_ is the width.
	 * 								If orientation is Vertical the length_ is the height.
	 * 								
	 * @param orientation_      	Scrollbar orientation [horizontal or vertical].
	 * @param trayID_				Tray id part for the scrollbar factory.
	 * @param sliderThumbID_		Sliderthumb id part for the scrollbar factory.
	 * @param scrollBarFactory_ 	scrollbar factory
	 */
	public function AbstractScrollBar(targetMC_:MovieClip,length_:Number,strength_:Number,orientation_:String)
	{ 
		_eventDistributor = new EventDistributor();

		_targetMC=targetMC_;
		
		_orientation=orientation_;
		_length=length_;
		_strength=strength_;
	}
	
	public function initialize():Void
	{
		
		createTray();
		
		_trayMC=_targetMC.createEmptyMovieClip('_tray_mc',1);
		_tray.setTargetMC(_trayMC);
		_tray.setStrength(_strength);
		_tray.setOrientation(_orientation);
		_tray.draw();
		_tray.setLength(_length);
		
		createSliderThumb();
		
		_sliderThumbMC=_targetMC.createEmptyMovieClip('_sliderThumb_mc',2);
		_sliderThumb.setTargetMC(_sliderThumbMC);
		_sliderThumb.setStrength(_strength);
		_sliderThumb.setRange(_length);
		_sliderThumb.setOrientation(_orientation);
		_sliderThumb.draw();
		_sliderThumb.setLength(0);
		
		_scrollBarValue      = 0;
		_smoothThumbPosValue = true;
		
		_startDragEvent   = new ScrollBarEvent(ScrollBarEvent.START_DRAG,this);
		_stopDragEvent    = new ScrollBarEvent(ScrollBarEvent.STOP_DRAG,this);
		_changeEvent      = new ScrollBarEvent(ScrollBarEvent.CHANGE,this);
		
		_trayClickEvent   = new ScrollBarEvent(ScrollBarEvent.TRAY_CLICK,this);
		
		addSliderThumbEvents();
		addTrayEvents();
	}
	
	
	
	public function createTray():Void {throw new Error('Abstract Method');}
	public function createSliderThumb():Void {throw new Error('Abstract Method');}
	
	private function addSliderThumbEvents():Void
	{
		
		_sliderThumbMC.onPress=Proxy.create(this,startDrag);
		_sliderThumbMC.useHandCursor=false;
		_sliderThumbMC.onRelease=_sliderThumbMC.onReleaseOutside=Proxy.create(this,stopDrag);
	}
	
	private function addTrayEvents():Void
	{
		_trayMC.useHandCursor=false;
		_trayMC.onPress=Proxy.create(this,startSlideOnTray);
		_trayMC.onRelease=_trayMC.onReleaseOutside=_trayMC.onDragOut=Proxy.create(this,stopSlideOnTray);
	}
	
	/**
	 * Trigger when the mouse is press over the sliderThumb.
	 */
	private function startDrag():Void
	{
		// stop all actions on the tray
		abortSlideOnTray();
		
		_sliderThumbMC.onMouseMove=Proxy.create(this,sliderThumbMouseMove);
		_dragOffset = (_orientation == ScrollBarOrientation.HORIZONTAL) ?  _sliderThumb.getMouseX() : _sliderThumb.getMouseY();
		
		distributeEvent( _startDragEvent);
		
		moveWhileDrag();
	}
	
	/**
	 * Trigger when the mouse is release over the sliderThumb.
	 */
	private function stopDrag():Void
	{
		delete _sliderThumbMC.onMouseMove;
		
		// set last sliderThumb position
		moveWhileDrag();
		distributeEvent( _stopDragEvent);
	
	}
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
	private function sliderThumbMouseMove():Void{moveWhileDrag();}
	
	
	/**
	 * Initialize slideOnTrays
	 */
	private function initializeSlideOnTray():Void
	{
		switch(_slideOnTrayMode)
		{
			
			case ScrollBarTrayMode.BY_PAGE:
				// interval properties
				initializeScrollPageInterval();

				break;
				
			case ScrollBarTrayMode.TO_PAGE_TWEEN:
			case ScrollBarTrayMode.TO_POINT_TWEEN:
			
				// tween properties
				initializeSlideOnTrayTween();
			
				break;
				
			case ScrollBarTrayMode.TO_POINT:
			
				break;
		}
	}
	
	/**
	 * Initialize Scroll by Page
	 */
	private function initializeScrollPageInterval():Void
	{
		_scrollPageInterval=-1;
		
		// One page every _scrollPageIntervalTicks ms
		_scrollPageIntervalTicks=ScrollBarConfig.SCROLL_PAGE_TICKS;
	}
	
	/**
	 * Initialize tween
	 */
	private function initializeSlideOnTrayTween():Void
	{
		_slideOnTrayTween=new TweenTimer();
		_slideOnTrayTween.tweenTarget=this;
		_slideOnTrayTween.tweenDuration = ScrollBarTrayTween.DURATION ;
		if(ScrollBarTrayTween.EASING_FUNCTION!=null) _slideOnTrayTween.easingFunction = ScrollBarTrayTween.EASING_FUNCTION;
	}
	
	/**
	 * Trigger when the mouse is press over the tray.
	 */
	private function startSlideOnTray():Void
	{
		distributeEvent( _trayClickEvent);
		
		switch(_slideOnTrayMode)
		{
			
			case ScrollBarTrayMode.BY_PAGE:
			
				_scrollPageInterval=setInterval(Proxy.create(this,slideOnTrayByPage),_scrollPageIntervalTicks);
				
				break;
				
			case ScrollBarTrayMode.TO_PAGE_TWEEN:
				
				slideOnTrayToPageTween();
				
				break;
				
			case ScrollBarTrayMode.TO_POINT:
			
				slideOnTrayToPoint();
			
				break;
				
			case ScrollBarTrayMode.TO_POINT_TWEEN:
				
				slideOnTrayToPointTween();
				
				break;
		}

	}
	
	/**
	 * Abort any action on the tray.
	 */
	private function abortSlideOnTray():Void
	{
		switch(_slideOnTrayMode)
		{
			
			case ScrollBarTrayMode.BY_PAGE :
			
				clearInterval(_scrollPageInterval);
				_scrollPageInterval=-1;

				break;
				
			case ScrollBarTrayMode.TO_PAGE_TWEEN :
			
				_slideOnTrayTween.reset();
				 
				break;
				
			case ScrollBarTrayMode.TO_POINT : break;
			case ScrollBarTrayMode.TO_POINT_TWEEN :
			 
				_slideOnTrayTween.reset();
				
				break;
		}

	}
	
	/**
	 * Trigger when the mouse is release over the tray.
	 */
	private function stopSlideOnTray():Void
	{
		switch(_slideOnTrayMode)
		{
			
			case ScrollBarTrayMode.BY_PAGE :
			
				clearInterval(_scrollPageInterval);
				_scrollPageInterval=-1;

				break;
				
			case ScrollBarTrayMode.TO_PAGE_TWEEN : break;
			case ScrollBarTrayMode.TO_POINT : break;
			case ScrollBarTrayMode.TO_POINT_TWEEN : break;

		}

	}
	
	
	/**
	 * Moves the sliderThumb over the tray one page to the top.
	 */
	public function pageUp():Void
	{
		if(_orientation==ScrollBarOrientation.VERTICAL)slideOnTrayByPage(-1);
		else throw new Error('ERROR: pageDown method is not available when the ScrollBar Orientation is'+_orientation);
	}
	
	/**
	 * Moves the sliderThumb over the tray one page to the bottom.
	 */
	public function pageDown():Void
	{
		if(_orientation==ScrollBarOrientation.VERTICAL)slideOnTrayByPage(1);
		else throw new Error('ERROR: pageDown method is not available when the ScrollBar Orientation is'+_orientation);
	}
	
	/**
	 * Moves the sliderThumb over the tray one page to the left.
	 */
	public function pageLeft():Void
	{
		if(_orientation==ScrollBarOrientation.HORIZONTAL)slideOnTrayByPage(-1);
		else throw new Error('ERROR: pageLeft method is not available when the ScrollBar Orientation is'+_orientation);
	}
	
	/**
	 * Moves the sliderThumb over the tray one page to the right.
	 */
	public function pageRight():Void
	{
		if(_orientation==ScrollBarOrientation.HORIZONTAL)slideOnTrayByPage(1);
		else throw new Error('ERROR: pageRight method is not available when the ScrollBar Orientation is'+_orientation);
	}
	
	
	/**
	 * Moves the sliderThumb over the tray by page.
	 * The page step is sliderThumb length
	 */
	private function slideOnTrayByPage(pageInc:Number):Void
	{
		var sliderThumbLength:Number=getSliderThumbLength();

		var dir		:	Number;

		var currentPage:Number=(Math.round(_scrollBarValue*(pages-1)));
		if (typeof pageInc=="number")dir=pageInc;
		else dir=(getMousePointOnTray()>sliderThumbPosition)? 1:-1;
		
		var page		:	Number		=	Math.round(currentPage+dir);
		var tempValue	:	Number		=	(page*(100/(_pages-1))/100);
		if(tempValue > 1.0) tempValue	=	1.0;
		if(tempValue < 0) tempValue		=	0;
		scrollBarValue					=	tempValue;
	}
	
	/**
	 * Tween the sliderThumb over the tray to a page position 
	 * accroding with the mouse point.
	 */
	private function slideOnTrayToPageTween():Void { executeTrayTween(getScrollValuePage(),'scrollBarValue');}
	
	/**
	 * Get the scrollbar value according with 
	 * the page number of the mouse point on the tray
	 */
	private function getScrollValuePage():Number
	{
		var sliderThumbLength:Number=getSliderThumbLength();
		var page:Number=Math.round((getMousePointOnTray()*(_pages-1)) /_length);
		var tempValue:Number=(page*(100/(_pages-1))/100);
		if(tempValue > 1.0) tempValue=1.0;
		if(tempValue < 0) tempValue=0;
		return(tempValue);

	}
	
	/**
	 * Get the mouse position on the tray
	 */
	private function getMousePointOnTray():Number
	{
		var sliderThumbLength:Number=getSliderThumbLength();
		_dragOffset =  sliderThumbLength >> 1;
	
		var pos:Number;
		
		switch( _orientation )
		{
			case ScrollBarOrientation.HORIZONTAL:
			
				pos=_targetMC._xmouse;
				break;
				
			case ScrollBarOrientation.VERTICAL: 
			 
				pos=_targetMC._ymouse;
				break;
		}
		
		return pos;
	}
	
	/**
	 * Moves the sliderThumb over the tray to the mouse point. [scroll here]
	 */
	private function slideOnTrayToPoint():Void 
	{
		var sliderThumbLength:Number=getSliderThumbLength();
		sliderThumbPosition=Math.round(getMousePointOnTray()-(getSliderThumbLength()/2));
	}
	
	/**
	 * Tween the sliderThumb over the tray to the mouse point. [scroll here with tween]
	 */
	private function slideOnTrayToPointTween():Void 
	{ 
		var sliderThumbLength:Number=getSliderThumbLength();
		executeTrayTween(Math.round(getMousePointOnTray()-(getSliderThumbLength()/2)));
	}

	/**
	 * Execute Tween  over the tray.
	 */
	private function executeTrayTween(endValue_:Number, prop_:String):Void
	{
		_slideOnTrayTween.reset();
		if(prop_=='scrollBarValue')_slideOnTrayTween.setTweenProperty('scrollBarValue',(scrollBarValue || 0),endValue_);
		else _slideOnTrayTween.setTweenProperty('sliderThumbPosition',(sliderThumbPosition || 0),endValue_);
		_slideOnTrayTween.start();
		
	}
	
	/**
	 * Moves sliderThumb while dragging
	 */
	private function moveWhileDrag():Void 
	{
		var pos: Number = ( _orientation == ScrollBarOrientation.HORIZONTAL ? _targetMC._xmouse : _targetMC._ymouse ) - _dragOffset;
		sliderThumbPosition=pos;
	}
	
	/**
	 * Redraw the scrollbar parts.
	 * @param sliderThumbLength_	Changes the length of the sliderThumb [width or height].
	 * @param length_				Changes the length of the tray [width or height].
	 * @param scrollBarValue_		Locks the sliderThumb in a fix position [hack].
	 */
	public function redraw(sliderThumbLength_:Number,length_:Number,scrollBarValue_:Number):Void
	{
		_dragOffset =  sliderThumbLength_ >> 1;
		
		if(length_!=null)
		{
			_length=length_;
			_tray.setLength(_length);
		}
		
		_sliderThumb.setRange(_length);
		_sliderThumb.setLength(sliderThumbLength_);
		
		var sliderThumbLength:Number=getSliderThumbLength();
		
		if(sliderThumbLength<=0) _tray.remove();
		_scrollBarValue = scrollBarValue_;
		
		_sliderThumb.setPosition( _scrollBarValue * ( _length - sliderThumbLength ) );

		distributeEvent( _changeEvent);
	}
	
	/**
	 * 
	 * SPECIAL USE
	 * 
	 * Update SliderThumb.
	 * @param sliderThumbLength_	Changes the length of the sliderThumb [width or height].
	 * @param scrollBarValue_		Locks the sliderThumb in a fix position [hack].
	 */
	public function updateSliderThumb(sliderThumbLength_:Number,scrollBarValue_:Number):Void
	{
		_sliderThumb.setRange(_length);
		_sliderThumb.setLength(sliderThumbLength_);
		//sliderThumbPosition= _sliderThumb.getPosition();
	}
	
	
	
	public function set scrollBarValue( scrollBarValue_: Number ): Void
	{

		var sliderThumbLength:Number=getSliderThumbLength();
		
		_sliderThumb.setPosition( scrollBarValue_ * ( _length - sliderThumbLength ));
		_scrollBarValue = scrollBarValue_;
		
		distributeEvent( _changeEvent);
	}
	
	public function get scrollBarValue(): Number{return _scrollBarValue;}
	
	/**
	 * Used for tray modes only and special cases
	 */
	public function set sliderThumbPosition( sliderThumbPosition_: Number): Void
	{
		var sliderThumbLength:Number=getSliderThumbLength();
		
		var pos:Number=sliderThumbPosition_;
		
		if( pos < 0 )pos = 0;
		else if( pos > _length - sliderThumbLength )pos = (_length - sliderThumbLength);
		_sliderThumb.setPosition( pos );
		
		var tempValue : Number = (pos / ( _length - sliderThumbLength ));
		var newValue  : Number;
		
		// remove digits
		if(!_smoothThumbPosValue)newValue = Math.floor(tempValue*10)/10;
		else newValue=tempValue;
		
		// restore smooth value
		_smoothThumbPosValue = true;
		
		scrollBarValue = newValue;
	}
	
	/**
	 * Optional CustomContextMenu
	 */
	private function setCustomContextMenu():Void
	{
		_scrollUpEvent    = new ScrollBarEvent(ScrollBarEvent.SCROLL_UP,this);
		_scrollDownEvent  = new ScrollBarEvent(ScrollBarEvent.SCROLL_DOWN,this);
		_scrollLeftEvent  = new ScrollBarEvent(ScrollBarEvent.SCROLL_LEFT,this);
		_scrollRightEvent = new ScrollBarEvent(ScrollBarEvent.SCROLL_RIGHT,this);
		
		_cmSelectEvent    = new ScrollBarEvent(ScrollBarEvent.CONTEXTMENU_SELECT,this);
		
		// temp
		var cm:CustomContextMenu=new CustomContextMenu();
		cm.displayObject=_targetMC;
		
		cm.addItem(ScrollBarContextMenuLabel.SCROLL_HERE,ScrollBarContextMenuID.SCROLL_HERE);
		
		switch( _orientation )
		{
			case ScrollBarOrientation.HORIZONTAL:
				
				cm.addItem(ScrollBarContextMenuLabel.LEFT_EDGE,ScrollBarContextMenuID.LEFT_EDGE,true);
				cm.addItem(ScrollBarContextMenuLabel.RIGHT_EDGE,ScrollBarContextMenuID.RIGHT_EDGE);
				
				cm.addItem(ScrollBarContextMenuLabel.PAGE_LEFT,ScrollBarContextMenuID.PAGE_LEFT,true);
				cm.addItem(ScrollBarContextMenuLabel.PAGE_RIGHT,ScrollBarContextMenuID.PAGE_RIGHT);
				
				cm.addItem(ScrollBarContextMenuLabel.SCROLL_LEFT,ScrollBarContextMenuID.SCROLL_LEFT,true);
				cm.addItem(ScrollBarContextMenuLabel.SCROLL_RIGHT,ScrollBarContextMenuID.SCROLL_RIGHT);
				
				break;
				
			case ScrollBarOrientation.VERTICAL: 
			
			 	cm.addItem(ScrollBarContextMenuLabel.TOP,ScrollBarContextMenuID.TOP,true);
				cm.addItem(ScrollBarContextMenuLabel.BOTTOM,ScrollBarContextMenuID.BOTTOM);
				
				cm.addItem(ScrollBarContextMenuLabel.PAGE_UP,ScrollBarContextMenuID.PAGE_UP,true);
				cm.addItem(ScrollBarContextMenuLabel.PAGE_DOWN,ScrollBarContextMenuID.PAGE_DOWN);
				
				cm.addItem(ScrollBarContextMenuLabel.SCROLL_UP,ScrollBarContextMenuID.SCROLL_UP,true);
				cm.addItem(ScrollBarContextMenuLabel.SCROLL_DOWN,ScrollBarContextMenuID.SCROLL_DOWN);
				
				break;
		}
		
		cm.addEventListener(CustomContextMenuEvent.SELECT,Proxy.create(this,contextMenuSelect));
		cm.addEventListener(CustomContextMenuEvent.SELECT_ITEM,Proxy.create(this,contextMenuItemSelect));
	}
	
	private function contextMenuSelect(e:CustomContextMenuEvent):Void
	{
		distributeEvent( _cmSelectEvent );
	}
	
	private function contextMenuItemSelect(e:CustomContextMenuEvent):Void
	{
		
		var cm:CustomContextMenu=e.getCustomContextMenu();
		var selectedID : String= cm.selectedID;
		
		switch (selectedID)
		{
			case ScrollBarContextMenuID.SCROLL_HERE:
			slideOnTrayToPoint();
			break;
			case ScrollBarContextMenuID.PAGE_LEFT:
			pageLeft();
			break;
			case ScrollBarContextMenuID.PAGE_RIGHT:
			pageRight();
			break;
			case ScrollBarContextMenuID.PAGE_UP:
			pageUp();
			break;
			case ScrollBarContextMenuID.PAGE_DOWN:
			pageDown();
			break;
			case ScrollBarContextMenuID.LEFT_EDGE:
			case ScrollBarContextMenuID.TOP:
			scrollBarValue=0;
			break;
			case ScrollBarContextMenuID.BOTTOM:
			case ScrollBarContextMenuID.RIGHT_EDGE:
			scrollBarValue=1.0;
			break;
			case ScrollBarContextMenuID.SCROLL_UP:
			distributeEvent( _scrollUpEvent );
			break;
			case ScrollBarContextMenuID.SCROLL_DOWN:
			distributeEvent( _scrollDownEvent );
			break;
			case ScrollBarContextMenuID.SCROLL_LEFT:
			distributeEvent( _scrollLeftEvent );
			break;
			case ScrollBarContextMenuID.SCROLL_RIGHT:
			distributeEvent( _scrollRightEvent );
			break;
		}

	}
	
	public function get sliderThumbPosition(): Number{return _sliderThumb.getPosition();}
	
	public function setSliderThumbLength(sliderThumbLength_:Number):Void {redraw(sliderThumbLength_,null);}
	public function getSliderThumbLength():Number { return _sliderThumb.getLength();}
	
	
	public function getOrientation():String { return _orientation; };
	public function getTargetMC() : MovieClip { return _targetMC; }
	
	public function getSlideOnTrayMode():String{return _slideOnTrayMode;}
	public function setSlideOnTrayMode( slideOnTrayMode_:String ):Void{_slideOnTrayMode=slideOnTrayMode_;}
	
	public function addContextMenu( addContextMenu_: Boolean):Void {_addContextMenu=addContextMenu_;}
	
	public function get pages() : Number { return _pages; }
	public function set pages( pages_:Number ) { _pages = pages_; }
	
	/**
	 * IDistributor
	 */
	public function addEventListener(type : String, func : Function) : Void{_eventDistributor.addEventListener(type, func );}
	public function removeEventListener(type : String, func : Function) : Void{_eventDistributor.removeEventListener(type, func );}
	public function distributeEvent(eventObject : IEvent) : Void{_eventDistributor.distributeEvent(eventObject );}
	
	
	/**
	 * Destroy or finalize object
	 */
	public function destroy():Void
	{
		delete _sliderThumbMC.onMouseMove;
		
		_eventDistributor.finalize();
		
		_sliderThumbMC.enabled=false;
		_trayMC.enabled=false;
		stopSlideOnTray();
		
		_sliderThumb.destroy();
		_tray.destroy();
		
		if(_slideOnTrayTween!=null) 
		{
			_slideOnTrayTween.reset();
			_slideOnTrayTween.destroy();
		}
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}
			
	}
	
}