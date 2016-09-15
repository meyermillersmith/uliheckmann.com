/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 *
 * PROPERTIES:
 * 
 * 				- targetMC : MovieClip [R]
 * 						
 * 				  		Returns ScrollPane MovieClip container
 * 				  		The _targetMC is set in the Constructor
 * 				  		
 * 				- targetToScroll : MovieClip [R]
 * 				
 * 						MovieClip to scroll
 * 						
 * 						USAGE:	
 * 								var scollPaneContainerMC:MovieClip = this.createEmptyMovieClip('scrollpane_container_mc', 2);
 * 								var scollPane:ScrollPane = new ScrollPane(scollPaneContainerMC, 200, 200);
 * 								
 * 								// associate MovieClip to targetToScroll
 * 								var myContentMC:MovieClip=scollPane.targetToScroll;
 * 								
 * 								// attach content movieclip to myContentMC [targetToScroll]
 * 								myContentMC.attachMovie('myContent', 'myContent', 1);
 * 								
 * 				- easeContent : Boolean [R/W]
 * 				
 * 						Ease content [targetToScroll]
 * 						Use ScrollPaneConfig.EASE_CONTENT static property to set
 * 						the easeContent for all the ScrollPane instances.
 * 						
 * 						The easeContent property neutralizes ScrollPaneConfig.EASE_CONTENT in 
 * 						a specific ScrollPane instance
 * 						
 * 						See forceStartEase method and forceStopEase method to change easeContent 
 * 						during runtime, both methods neutralize ScrollPaneConfig.EASE_CONTENT in 
 * 						a specific ScrollPane instance
 * 						
 * 				- snapToGrid : Boolean [R/W]
 * 				
 * 						Snap the content to a defined grid [snapH,snapV]
 * 						
 * 						Use ScrollPaneConfig.SNAP_TO_GRID static property to set
 * 						the snapToGrid for all the ScrollPane instances.
 * 						
 * 						The snapToGrid property neutralizes ScrollPaneConfig.SNAP_TO_GRID in 
 * 						a specific ScrollPane instance
 * 						
 * 				- snapV : Number [R/W]
 * 				
 * 						Snapping vertical value
 * 						
 * 						Use ScrollPaneConfig.SNAP_V static property to set
 * 						the snapV for all the ScrollPane instances.
 * 						
 * 						The easeContent property neutralizes ScrollPaneConfig.SNAP_V in 
 * 						a specific ScrollPane instance
 * 				
 * 				- snapH : Number [R/W]
 * 				
 * 						Snapping horizontal value
 * 						
 * 						Use ScrollPaneConfig.SNAP_H static property to set
 * 						the snapH for all the ScrollPane instances.
 * 						
 * 						The easeContent property neutralizes ScrollPaneConfig.SNAP_H in 
 * 						a specific ScrollPane instance
 * 						
 * 				- scrollBarHoffset : Number [R/W]
 * 				
 * 						[Y] Distance in pixels from the _scRect.h [view area height] to 
 * 							the horizontal scrollbar
 * 						
 * 				- scrollBarVoffset : Number [R/W]
 * 				
 * 						[X] Distance in pixels from the _scRect.w [view area width] to 
 * 							the vertical scrollbar
 * 							
 * 				- scrollBarTrayMode : String [R/W]
 * 				
 * 							Sets the mode to move the sliderThumb over 
 * 							the tray. [see ScrollBarTrayMode]
 * 							
 * 							Use ScrollBarConfig.TRAY_MODE static property to set
 * 							the scrollBarTrayMode property for all the ScrollBar instances.
 * 							
 *              - addContextMenu : Boolean [W]
 * 				
 * 						Add custom context menu to the Scrolbar tray
 * 						
 * 						Use ScrollBarConfig.ADD_CONTEXT_MENU static property to set
 * 						the _addContextMenu property for all the ScrollBar instances.
 * 						
 * 						See ScrolBarContextMenuLabel for labels
 * 						
 * 				- useMouseWheel : Boolean [R/W]
 * 				
 * 							Scroll with the mouse wheel
 * 							
 * 							Use ScrollPaneConfig.USE_MOUSE_WHEEL static property to set
 * 							the _useMouseWheel for all the ScrollPane instances.
 * 							
 * 							See UIFocusManager and IFocus
 * 							
 * 				- mouseWheelSpeed : Number [R/W]
 * 				
 * 							Speed for the Scroll with the mouse wheel (_mouseWheelSpeed * delta)
 * 							
 * 							delta : A number indicating how many lines should be scrolled for 
 * 									each notch the user rolls the mouse wheel.
 * 							
 * 							Use ScrollPaneConfig.MOUSE_WHEEL_SPEED static property to set
 * 							the _mouseWheelSpeed for all the ScrollPane instances.
 * 							
 * 						
 * 				- visibleArea : String [R]
 * 			
 * 				  		Returns ScrollRect parameters [see ScrollRect].
 * 					
 * METHODS:
 * 			
 * 				- initialize : Void
 * 				
 * 				- setScrollBarFactory( scrollBarFactory_: IScrollBarFactory )
 * 							
 * 							Set the scrolbarfactory to use [see SampleScrollFactory]
 * 							
 * 							Use ScrollBarConfig.SCROLLBAR_FACTORY static property to set
 * 							the same scrollBarFactory for all the ScrollPane instances.
 * 				
 * 				- updateView (viewWidth_ : Number , viewHeight_ : Number )	
 * 					
 * 							Updates the scrollrect rectangle [visible area]
 * 							
 * 				- redraw(sliderThumbLength_ : Number, range_ : Number, scrollBarValue_ : Number)
 * 				
 * 				  		Redraw the scrollbar parts.
 * 				  		The sliderThumbLength_ parameter changes the length of the sliderThumb [width or height].
 * 				  		The range_ parameter changes the length of the tray [width or height].
 * 				  		The scrollBarValue_ parameter locks the sliderThumb in a fix position [hack].
 * 	
 * 				- scrollToContentPoint ( x_ : Number, y_ : Number)	
 * 						  		
 *                      Scrolls _targetToScroll to point x and y
 *                      
 * 				- scrollToPercent ( percentH_ : Number, percentV_ : Number )
 * 				
 * 						Sets scrollbar value to percent		
 * 			
 * 				- forceStartEase : Void
 * 				
 * 				  		Force to start ease at runtime [easeContent is set to true]
 * 				   
 *			    - forceStopEase : Void
 * 				
 * 				  		Force to stop ease at runtime [easeContent is set to false]
 * 				  
 * 				- destroy():Void
 * 				
 * 				
 * IMPLEMENTS:
 * 
 * 				IFocus	
 * 
 * 
 * SEE ALSO:
 * 
 * 				- FramePulse
 * 				- FramePulseEvent
 * 				- IFocus
 * 				- UIFocusManager
 * 				- IScrollBarFactory
 * 				- ScrollBar
 * 				- ScrollBarEvent
 * 				- SampleScrollBarFactory
 * 				- ScrollBarConfig
 * 				- ScrollBarOrientation
 * 				- ScrollPaneConfig
 * 				- ScrollRect
 * 					
 * 
 */

import com.pixelbreaker.ui.MouseWheel;

import flash.geom.Rectangle;

import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.focus.IFocus;
import lessrain.lib.utils.focus.UIFocusManager;
import lessrain.lib.utils.MovieClipUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.scrollers.scrollbar.IScrollBarFactory;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBar;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarConfig;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarEvent;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarOrientation;
import lessrain.lib.utils.scrollers.scrollpane.ScrollPaneConfig;
import lessrain.lib.utils.scrollers.scrollpane.ScrollPaneEvent;
import lessrain.lib.utils.scrollers.ScrollRect;
import lessrain.lib.utils.tween.FramePulse;
import lessrain.lib.utils.tween.FramePulseEvent;

class lessrain.lib.utils.scrollers.scrollpane.ScrollPane implements IFocus, IDistributor 
{
	private var _targetMC 				: MovieClip;
	private var _targetToScroll 		: MovieClip;
	private var _frameMC				: MovieClip;
	
	private var _scRect					: ScrollRect;
	
	private var _scrollBarsMC			: MovieClip;
	
	private var _scrollBarH				: ScrollBar;
	private var _scrollBarV				: ScrollBar;
	
	private var _scrollBarH_mc			: MovieClip;
	private var _scrollBarV_mc			: MovieClip;
	
	private var _scrollBarHoffset		: Number;
	private var _scrollBarVoffset		: Number;
	
	private var _scrollBarTrayMode       : String;
	
	private var _snapToGrid 			: Boolean;
	private var _snapV					: Number;
	private var _snapH					: Number;

	private var _easeContent 			: Boolean;
	private var _easeContentFactor 		: Number;
	private var _easeContentFactorMax 	: Number;
	private var _easeContentFactorMin 	: Number;
	private var _pauseEase 				: Boolean;
	
	private var _framePulse				: FramePulse;
	private var _framePulseProxy		: Function;

	private var _currentPositionV 		: Number;
	private var _newPositionV 			: Number;
	private var _oldPositionV 			: Number;
	private var _currentPositionH 		: Number;
	private var _newPositionH 			: Number;
	private var _oldPositionH 			: Number;

	private var _scrollBarFactory 		: IScrollBarFactory;
	private var _sliderThumbID 			: String;
	private var _trayID 				: String;

	//_targetToScroll height
	private var _contentH 				: Number;
	//_targetToScroll width
	private var _contentW 				: Number;
	
	// IFocus
	private var __focusRect				: Rectangle;
	private var _isFocus				: Boolean;
	private var _focusManager			: UIFocusManager;
	private var _lockFocus				: Boolean;
	private var _onReleaseFocusHandler	: Function;
	
	// mousewheel
	private var _useMouseWheel          : Boolean;
	private var _mouseListener			: Object;
	private var _mouseWheelSpeed 		: Number;
	
	private var _initializeComplete     : Boolean;
	
	private var _cm_step_default        : Number;

	// snap divisions
	private var _cwDiv 					: Number;
	private var _rwDiv 					: Number;
	private var _rhDiv 					: Number;
	private var _chDiv 					: Number;

	private var _addContextMenu         : Boolean;
	
	// alternate Strength for the scrollBars
	private var _scrollBarHStrength 	: Number;
	private var _scrollBarVStrength 	: Number;
	
	// special usage
	private var _xpandFocusRectToScrollBar : Boolean	=	true;

	private var _forceContentH : Number;
	
	private var _eventDistributor:EventDistributor;

	public function ScrollPane(target_:MovieClip,viewWidth_:Number,viewHeight_:Number) 
	{
		_targetMC=target_;
		
		_frameMC=MovieClipUtils.addChildAt(_targetMC,'frame_mc',1);
		
		_scRect=new ScrollRect();
		_scRect.initialize(_frameMC, viewWidth_, viewHeight_);

		_targetToScroll=MovieClipUtils.addChildAt(_frameMC,'targetToScroll_mc',2);
		
		_scrollBarsMC=MovieClipUtils.addChildAt(_targetMC,'scrollbars_mc',3);
		
		_scrollBarsMC._x=_targetToScroll._x;
		_scrollBarsMC._y=_targetToScroll._y;
		
		_onReleaseFocusHandler = Proxy.create(this, onReleaseFocus);
		
		_eventDistributor = new EventDistributor();
	}
	
	public function initialize():Void
	{
		if(_scrollBarFactory==null)		_scrollBarFactory	=	ScrollBarConfig.SCROLLBAR_FACTORY;
		if(_easeContent == null) 		_easeContent		=	ScrollPaneConfig.EASE_CONTENT;
		if(_snapToGrid == null) 		_snapToGrid			=	ScrollPaneConfig.SNAP_TO_GRID;
		if(_snapH == null) 				_snapH				=	ScrollPaneConfig.SNAP_H;
		if(_snapV == null) 				_snapV				=	ScrollPaneConfig.SNAP_V;
		if(_useMouseWheel == null) 		_useMouseWheel		=	ScrollPaneConfig.USE_MOUSE_WHEEL;
		if(_mouseWheelSpeed == null) 	_mouseWheelSpeed	=	ScrollPaneConfig.MOUSE_WHEEL_SPEED;
		if(_cm_step_default ==null) 	_cm_step_default	=	ScrollPaneConfig.CM_SCROLL_STEP_DEFAULT;
		
		setScrollBarH();
		setScrollBarV();
		
		if(_useMouseWheel ) setFocusProperties();
		if(_easeContent)initEase();
		
		updateView(_scRect.w,_scRect.h);
		
		_initializeComplete=true;
	}
	
	private function setFocusProperties():Void
	{
		_focusManager=UIFocusManager.getInstance();
		
		_isFocus=false;
		_lockFocus = false;
		
		var hOffset:Number=(_scrollBarH_mc._height || 0)+(_scrollBarHoffset ||0);
		var vOffset:Number=(_scrollBarV_mc._width || 0)+(_scrollBarVoffset|| 0);
		
		setFocusRect(new Rectangle(0,0,(_scRect.w+hOffset),_scRect.h+vOffset));
		
		_focusManager.addItem(this,getFocusRect());
	}
	
	private function setScrollBarH():Void
	{
		if(_contentW==null) _contentW=_targetToScroll._width;
		_scrollBarH_mc=MovieClipUtils.addChildAt(_scrollBarsMC,'scH',1);
		
		_scrollBarH = new ScrollBar(_scrollBarH_mc,_scRect.w, _scrollBarHStrength || 16, ScrollBarOrientation.HORIZONTAL,_scrollBarFactory);
		
		_scrollBarH.addEventListener(ScrollBarEvent.CHANGE,Proxy.create(this,scrollBarChange));
		
		_scrollBarH.addEventListener(ScrollBarEvent.START_DRAG,Proxy.create(this,scrollBarStartDrag));
		_scrollBarH.addEventListener(ScrollBarEvent.STOP_DRAG,Proxy.create(this,scrollBarStopDrag));
		_scrollBarH.addEventListener(ScrollBarEvent.TRAY_CLICK,Proxy.create(this,scrollBarTrayClick));
		
		_scrollBarH.addEventListener(ScrollBarEvent.SCROLL_LEFT,Proxy.create(this,scrollLeft));
		_scrollBarH.addEventListener(ScrollBarEvent.SCROLL_RIGHT,Proxy.create(this,scrollRight));
		
		if(_scrollBarTrayMode!=null)_scrollBarH.setSlideOnTrayMode(_scrollBarTrayMode);
		if(_addContextMenu != null)_scrollBarH.addContextMenu (_addContextMenu);
		
		// for custom context menu
		_scrollBarH.initialize();
		
		alignScrollBars();
		
		_scrollBarH.redraw( (_scRect.w /_contentW),_scRect.w );
		
	}
	
	private function setScrollBarV():Void
	{
		
		// Add mousewheel functionality
		_mouseListener = new Object();
		_mouseListener['onMouseWheel'] = Proxy.create(this,mouseWheel);
		
		if(_contentH==null) _contentH=_targetToScroll._height;
		_scrollBarV_mc=MovieClipUtils.addChildAt(_scrollBarsMC,'scV',2);
		
		_scrollBarV = new ScrollBar(_scrollBarV_mc,_scRect.h, _scrollBarVStrength || 16, ScrollBarOrientation.VERTICAL,_scrollBarFactory);
		
		_scrollBarV.addEventListener(ScrollBarEvent.CHANGE,Proxy.create(this,scrollBarChange));
		
		_scrollBarV.addEventListener(ScrollBarEvent.START_DRAG,Proxy.create(this,scrollBarStartDrag));
		_scrollBarV.addEventListener(ScrollBarEvent.STOP_DRAG,Proxy.create(this,scrollBarStopDrag));
		_scrollBarV.addEventListener(ScrollBarEvent.TRAY_CLICK,Proxy.create(this,scrollBarTrayClick));
		
		_scrollBarV.addEventListener(ScrollBarEvent.CONTEXTMENU_SELECT,Proxy.create(this,contextMenuSelect));
		
		_scrollBarV.addEventListener(ScrollBarEvent.SCROLL_UP,Proxy.create(this,scrollUp));
		_scrollBarV.addEventListener(ScrollBarEvent.SCROLL_DOWN,Proxy.create(this,scrollDown));
		
		if(_scrollBarTrayMode!=null)_scrollBarV.setSlideOnTrayMode(_scrollBarTrayMode);
		if(_addContextMenu != null)_scrollBarV.addContextMenu (_addContextMenu);
		
		_scrollBarV.initialize();
			
		alignScrollBars();

		_scrollBarV.redraw( (_scRect.h / _contentH),_scRect.h );
	}
	
	/**
	 * Scroll content 1 position up
	 * 
	 * If the snap value is not defined or is less than _cm_step_default
	 * pixels, the step defaulst to _cm_step_default
	 */
	private function scrollUp():Void
	{
		var step:Number=(_snapV>_cm_step_default) ? _snapV : _cm_step_default;
		var tempPointY:Number=(getCurrentPointY()+step);
		if(tempPointY>0)tempPointY=0;
		scrollToContentPoint(null,tempPointY);
	}
	
	/**
	 * Scroll content 1 position down
	 * 
	 * If the snap value is not defined or is less than _cm_step_default
	 * pixels, the step defaulst to _cm_step_default
	 */
	private function scrollDown():Void
	{
		var step:Number=(_snapV>_cm_step_default && _snapToGrid) ? _snapV : _cm_step_default;
		scrollToContentPoint(null,getCurrentPointY()-step);
	}
	
	/**
	 * Scroll content 1 position left
	 * 
	 * If the snap value is not defined or is less than _cm_step_default
	 * pixels, the step defaulst to _cm_step_default
	 */
	private function scrollLeft():Void
	{
		var step:Number=(_snapH>_cm_step_default && _snapToGrid) ? _snapH : _cm_step_default;
		var tempPointX:Number=(getCurrentPointX()+step);
		if(tempPointX>0)tempPointX=0;
		scrollToContentPoint(tempPointX,null);
	}
	
	/**
	 * Scroll content 1 position right
	 * Used for the custom context menu
	 * 
	 * If the snap value is not defined or is less than _cm_step_default
	 * pixels, the step defaulst to _cm_step_default
	 */
	private function scrollRight():Void
	{
		var step:Number=(_snapH>_cm_step_default && _snapToGrid) ? _snapH : _cm_step_default;
		scrollToContentPoint(getCurrentPointX()-step,null);
	}
	
	/**
	 * Align horizontal and vertical scrollbar around the content
	 */
	private function alignScrollBars():Void
	{
		// align vertical scrollbar
		if(_scrollBarV_mc!=null)
		{
			_scrollBarV_mc._x = Math.round(_scRect.w + (_scrollBarVoffset || 0));
			_scrollBarV_mc._y = 0;
		}
		
		// align horizontal scrollbar
		if(_scrollBarH_mc!=null)
		{
			_scrollBarH_mc._y = Math.round(_scRect.h + (_scrollBarHoffset|| 0));
			_scrollBarH_mc._x = 0;
		}
		
		updateFocusRect();
	}
	
	/**
	 * START_DRAG Event is received from the scrollbars
	 */
	private function scrollBarStartDrag(event:ScrollBarEvent):Void {
		_lockFocus = true;
	}
	
	/**
	 * STOP_DRAG Event is received from the scrollbars
	 */
	private function scrollBarStopDrag(event:ScrollBarEvent):Void {
		_lockFocus = false;
	}
	
	/**
	 * TRAY_CLICK Event is received from the scrollbars when user interacts with the tray
	 */
	private function scrollBarTrayClick(event:ScrollBarEvent):Void{}
	
	/**
	 * CONTEXTMENU_SELECT Event is received when a user invokes the Flash Player context menu
	 */
	private function contextMenuSelect(event:ScrollBarEvent):Void{}
	
	private function mouseWheel(delta:Number):Void
	{
		if (_scrollBarV.getSliderThumbLength() > 0) {
			var currentValue:Number=(_scrollBarV.scrollBarValue || 0);
			var newValue:Number=currentValue-((delta*(_mouseWheelSpeed))/100);
			
			if(newValue<=0) _scrollBarV.scrollBarValue=0;
			if(newValue>=1.0) _scrollBarV.scrollBarValue=1.0;
			
			if(newValue<1.0 && newValue>0) _scrollBarV.scrollBarValue=newValue;
		}
	}
	
	/**
	 * CHANGE Event is received from the scrollbars
	 */
	private function scrollBarChange(event:ScrollBarEvent):Void
	{
		var sc:ScrollBar=ScrollBar(event.getScrollBar());
		var value: Number = sc.scrollBarValue;
		var orientation: String = sc.getOrientation();
		
		switch( orientation )
		{
			case ScrollBarOrientation.HORIZONTAL:
				
				var newPosH:Number=(-(_contentW - _scRect.w ) * value);
				if(_snapToGrid)
				{
					var sPositionH:Number = Math.round(newPosH) - Math.round(newPosH) % _snapH;
					
					if(!_easeContent)_targetToScroll._x =_currentPositionH = sPositionH;
					else _newPositionH=Math.round(sPositionH);
				}else{
					if(!_easeContent) _targetToScroll._x =_currentPositionH=Math.round(newPosH);
					else _newPositionH=Math.round(newPosH);
				}
				
				break;
				
			case ScrollBarOrientation.VERTICAL:
				
				var newPosV:Number=(-( (_contentH) - (_scRect.h) ) * value);
				
				if(_snapToGrid)
				{
					var vDiv:Number=Math.round(value*(_chDiv-_rhDiv));
					var sPositionV:Number=-_snapV*(vDiv);
					
					if(!_easeContent)_targetToScroll._y =_currentPositionV=Math.round(sPositionV);
					else _newPositionV=Math.round(sPositionV);
					
				}else{

					if(!_easeContent) _targetToScroll._y =_currentPositionV=Math.round(newPosV);
					else _newPositionV=Math.round(newPosV);	
				}
			
				break;
		}
		
	}
	
	/**
	 * Initialize ease
	 */
	private function initEase():Void
	{
		_easeContentFactorMax=10.0;
		_easeContentFactorMin=1.0;
		_easeContentFactor=_easeContentFactorMax;
		
		_framePulse = FramePulse.getInstance();
		_framePulseProxy=Proxy.create(this,easeLoop);
		
		_pauseEase=false;
		
		startEase();
	}
	
	/**
	 * Properties used while easing
	 */
	private function setEasePositionProps():Void
	{
		if(_currentPositionV==null) _currentPositionV=0;
		if(_newPositionV==null) _newPositionV=0;
		if(_currentPositionH==null)_currentPositionH=0;
		if(_newPositionH==null) _newPositionH=0;
		
		_newPositionV=_oldPositionV=_currentPositionV;
		_newPositionH=_oldPositionV=_currentPositionH;
	}
	
	/**
	 * Add enterFrame listener
	 */
	private function addFramePulse():Void {_framePulse.addEnterFrameListener(_framePulseProxy);}
	
	/**
	 * Remove enterFrame listener
	 */
	private function removeFramePulse():Void { _framePulse.removeEnterFrameListener(_framePulseProxy);}
	
	/**
	 * Start ease
	 */
	private function startEase():Void 
	{
		if(!_easeContent) 
		{
			// Ease has not been initialize
			if(_framePulse==null) initEase();
			_easeContent=true;
			setEasePositionProps();
			addFramePulse();
		}
	}
	
	/**
	 * Stop ease
	 */
	private function stopEase():Void 
	{
		if(_easeContent) _easeContent=false;
		removeFramePulse();
	}
	
	/**
	 * Resume ease after pauseEase
	 */
	private function resumeEase():Void 
	{
		_easeContent=true;
		_pauseEase=false;
		setEasePositionProps();
		addFramePulse();
	}
	
	/**
	 * Stop ease to be restore later
	 */
	private function pauseEase():Void 
	{
		_easeContent=false;
		_pauseEase=true;
		removeFramePulse();
	}
	
	/**
	 * SPECIAL RUNTIME USAGE
	 * 
	 * Force to start ease property at runtime
	 */
	public function forceStartEase():Void { if(!_easeContent) startEase();}
	
	/**
	 * SPECIAL RUNTIME USAGE
	 * 
	 * Force to stop ease property at runtime
	 */
	public function forceStopEase():Void { if(_easeContent) stopEase();}
	
	/**
	 * Main enterframe for ease triggered by framepulse
	 * Optimized to don not execute anything after the 
	 * currentposition gets the desired value
	 */
	private function easeLoop(e:FramePulseEvent):Void
	{
		// vertical ease
		if(!isNaN(_newPositionV))
		{

			if(Math.round(_currentPositionV)!=_newPositionV)
			{
				_currentPositionV +=(_newPositionV-_currentPositionV)/_easeContentFactor;
				var dirV:Number=(_newPositionV<_oldPositionV) ? 1 : -1;

				if(dirV==1)
				{
					if(_currentPositionV<(_oldPositionV-0.1))_targetToScroll._y=_currentPositionV;	
				}else{
					if(_currentPositionV>(_oldPositionV+0.1)) _targetToScroll._y=_currentPositionV;
				}
				
				_oldPositionV=_currentPositionV;
				
				
			}else if(_targetToScroll._y!=_newPositionV)
			{
				// ease stop
				_targetToScroll._y=_newPositionV;
			}
			
		}
		// horizontal ease
		if(!isNaN(_newPositionH))
		{
			if(Math.round(_currentPositionH)!=_newPositionH)
			{
				_currentPositionH +=(_newPositionH-_currentPositionH)/_easeContentFactor;
				var dirH:Number=(_newPositionH<_oldPositionH) ? 1 : -1;
				
				if(dirH==1)
				{
					if(_currentPositionH<_oldPositionH-0.1)_targetToScroll._x=_currentPositionH;
				}else{
					if(_currentPositionH>_oldPositionH+0.1) _targetToScroll._x=_currentPositionH;	
				}
				
				_oldPositionH=_currentPositionH;
				
			}else if(_targetToScroll._x!=_newPositionH)
			{
				// ease stop
				_targetToScroll._x=_newPositionH;
			}
		}
	}
	
	/**
	 * Check for content properties changes
	 */
	private function redrawContent():Void
	{
		if(_contentW==null || _contentW!=_targetToScroll._width) _contentW=_targetToScroll._width;
		if(_contentH==null || _contentH!=_targetToScroll._height) _contentH=_targetToScroll._height;
		
		if(_forceContentH!=null)_contentH = _forceContentH;
		
		if(_snapToGrid)
		{
			if(_contentH > _scRect.h)
			{
				_rhDiv = Math.floor(_scRect.h/_snapV);
				_chDiv = Math.ceil(_contentH/_snapV);
				
				var oldContentH:Number=_contentH;
				var tempContentH:Number=(((_chDiv-_rhDiv)*_snapV)+_scRect.h);
				if(tempContentH<_contentW)_contentH +=(_contentW-tempContentH);
				else _contentH=tempContentH;
				if(_contentH>(oldContentH+_snapV))_contentH=oldContentH+_snapV;
			}
			
			if(_contentW > _scRect.w)
			{
				_rwDiv = Math.floor(_scRect.w/_snapH);
				_cwDiv = Math.ceil(_contentW/_snapH);
				
				var oldContentW:Number = _contentW;
				var tempContentW:Number	= (((_cwDiv-_rwDiv)*_snapH)+_scRect.w);
				if(tempContentW<_contentW)_contentW +=(_contentW-tempContentW);
				else _contentW=tempContentW;
				if(_contentW>(oldContentW+_snapH))_contentW=oldContentW+_snapH;
			}
		}
	}
	
	/**
	 * Redraw scrollbars according with the new scrollrect properties [w or h] 
	 * or targetToScroll properties [_width or _height]
	 */
	public function redraw():Void
	{
		if(_easeContent) pauseEase();
		
		// check if content properties have change
		redrawContent();

		// align scrollbars
		alignScrollBars();
		
		_scrollBarH.pages=Math.ceil(_contentW/_scRect.w);
		_scrollBarV.pages=Math.ceil(_contentH/_scRect.h);

		_scrollBarH.redraw( (_scRect.w /_contentW),_scRect.w,translatePointX(getCurrentPointX()));
		_scrollBarV.redraw( (_scRect.h /_contentH),_scRect.h,translatePointY(getCurrentPointY()));

		if(_pauseEase) resumeEase();
	}
	
	/**
	 * update   scrollrect rectangle [visible area]
	 * @param	viewWidth_   width
	 * @param	viewHeight_  height
	 */
	public function updateView(viewWidth_:Number,viewHeight_:Number):Void
	{
		if(viewWidth_!=null)
		{
			if(viewWidth_<=(_contentW)) _scRect.w=Math.round(viewWidth_ || _scRect.w);
			else _scRect.w=(_contentW);
		}
		
		if(viewHeight_!=null)
		{
			if(viewHeight_<=(_contentH)) _scRect.h=Math.round(viewHeight_ || _scRect.h);
			else _scRect.h=(_contentH);
		}
		
		redraw();
	}
	
	/**
	 * scroll _targetToScroll to point x and y
	 * @param	x_ horizontal point
	 * @param	y_ vertical point
	 */
	public function scrollToContentPoint(x_:Number,y_:Number):Void
	{
		if(x_!=null)
		{
			if(x_>0 )x_=-1*x_;
			var tX:Number=translatePointX(x_);
			if(tX<0) tX=0;
			if(tX>1.0) tX=1.0;
			_scrollBarH.scrollBarValue=tX;
		}
		
		if(y_!=null)
		{	
			if(y_>0 )y_=-1*y_;
			var tY:Number=translatePointY(y_);
			if(tY<0) tY=0;
			if(tY>1.0) tY=1.0;
			_scrollBarV.scrollBarValue=tY;
		}
	}
	
	/**
	 * Set scrollbar value to percent
	 * @param	percentH_ horizontal percentage
	 * @param	percentV_ vertical percentage
	 */
	public function scrollToPercent(percentH_:Number,percentV_:Number):Void
	{
		if(percentH_!=null && percentH_<=100) _scrollBarH.scrollBarValue=(percentH_/100);
		if(percentV_!=null && percentV_<=100) _scrollBarV.scrollBarValue=(percentV_/100);
	}
	
	public function getScrollHPercent():Number {
		return _scrollBarH.scrollBarValue * 100;
	}
	
	public function getScrollVPercent():Number {
		return _scrollBarV.scrollBarValue * 100;
	}
	
	/**
	 * Translates targetToScroll point x to scrollbar position
	 * @param	x_ horizontal point
	 */
	private function translatePointX(x_:Number):Number
	{
		var scrPos:Number=(_scRect.w*(x_))/-(_contentW-_scRect.w);
		var scValue:Number=(scrPos/_scRect.w);
		if(scValue<=0) scValue=0;
		if(scValue>=1) scValue=1;
		return scValue;
	}
	
	/**
	 * Translates targetToScroll point y to scrollbar position
	 * @param	y_ horizontal point
	 */
	private function translatePointY(y_:Number):Number
	{
		var scrPos:Number=(_scRect.h*(y_))/-(_contentH-_scRect.h);
		var scValue:Number=(scrPos/_scRect.h);
		if(scValue<=0) scValue=0;
		if(scValue>=1) scValue=1;
		return scValue;
	}
	
	/**
	 * returns current targetToScroll point x
	 */
	private function getCurrentPointX():Number {return (_targetToScroll._x);}
	
	/**
	 * returns current targetToScroll point y
	 */
	private function getCurrentPointY():Number {return (_targetToScroll._y);}
	
	/**
	 * Set scrollbar parts [skin]
	 * 
	 * @param   scrollBarFactory_ 	factory
	 * 
	 */
	public function setScrollBarFactory(scrollBarFactory_:IScrollBarFactory):Void {_scrollBarFactory=scrollBarFactory_;}
	
	/**
	 * SPECIAL RUNTIME USAGE
	 * 
	 * Force the mode to move the sliderThumb over 
 	 * the tray. [see ScrollBarTrayMode]
	 */
	public function forceScrollBarTrayMode( scrollBarTrayMode_:String ) : Void
	{ 
		_scrollBarTrayMode = scrollBarTrayMode_; 

		if(_scrollBarH!=null) _scrollBarH.resetSlideOnTray(_scrollBarTrayMode);
		if(_scrollBarV!=null) _scrollBarV.resetSlideOnTray(_scrollBarTrayMode);
	}
	
	/**
	 * SPECIAL RUNTIME USAGE
	 * 
	 * Update snap to grid at runtime
	 */
	private function updateSnapToGrid(snapH_:Number,snapV_:Number):Void 
	{ 
		if(snapH_!=null) _snapH=snapH_;
		if(snapV_!=null) _snapV=snapV_;
		
		updateView();
	}
	
	public function get easeContent() : Boolean { return _easeContent; }
	public function set easeContent( ease_:Boolean ) { _easeContent = ease_; }
	
	public function get snapV() : Number { return _snapV; }
	public function set snapV( snapV_:Number ) 
	{
		_snapV = snapV_;
		if(_initializeComplete && _snapToGrid) updateSnapToGrid(_snapH,_snapV);
	}
	
	public function get snapH() : Number { return _snapH; }
	public function set snapH(snapH_:Number ) 
	{ 
		_snapH = snapH_;
		if(_initializeComplete && _snapToGrid) updateSnapToGrid(_snapH,_snapV);
	}
	
	public function get scrollBarHoffset() : Number { return _scrollBarHoffset; }
	public function set scrollBarHoffset( scrollBarHoffset_:Number ) { _scrollBarHoffset = scrollBarHoffset_; }
	
	public function get scrollBarVoffset() : Number { return _scrollBarVoffset; }
	public function set scrollBarVoffset( scrollBarVoffset_:Number ) { _scrollBarVoffset = scrollBarVoffset_; }
	
	public function get scrollBarHStrength_() : Number { return _scrollBarHStrength; }
	public function set scrollBarHStrength_( scrollBarHStrength_:Number ) { _scrollBarHStrength = scrollBarHStrength_; }
	
	public function get scrollBarVStrength() : Number { return _scrollBarVStrength; }
	public function set scrollBarVStrength( scrollBarVStrength_:Number ) { _scrollBarVStrength = scrollBarVStrength_; }
	
	public function get targetMC() : MovieClip { return _targetMC; }
	public function get targetToScroll() : MovieClip { return _targetToScroll; }
	
	public function get visibleArea() : String { return _scRect.rectParameters; }
	
	public function get snapToGrid() : Boolean { return _snapToGrid; }
	public function set snapToGrid( snapToGrid_:Boolean ) 
	{
		_snapToGrid = snapToGrid_; 
		if(_initializeComplete) updateSnapToGrid(_snapH,_snapV);
	}
	

	public function get scrollBarHValue():Number 
	{ 
		return _scrollBarH.scrollBarValue; 
	}

	public function get scrollBarVValue():Number 
	{ 
		return _scrollBarV.scrollBarValue; 
	}
	
	public function get scrollBarTrayMode() : String 
	{ 
		if(_scrollBarTrayMode==null) return ScrollBarConfig.TRAY_MODE;
		else return _scrollBarTrayMode; 
	}
	public function set scrollBarTrayMode( scrollBarTrayMode_:String ) { _scrollBarTrayMode = scrollBarTrayMode_; }
	
	public function get contentH():Number { return _contentH; }
	public function set contentH(contentH_:Number):Void { _contentH=contentH_; }
	
	public function set forceContentH(forceContentH_:Number):Void { _forceContentH=forceContentH_; }
	
	public function get contentW():Number { return _contentW; }
	public function set contentW(contentW_:Number):Void { _contentH=contentW_; }
	
	public function get initializeComplete():Boolean { return _initializeComplete; }
	
	public function get useMouseWheel() : Boolean { return _useMouseWheel; }
	public function set useMouseWheel( value:Boolean ) { _useMouseWheel = value; }
	
	public function get mouseWheelSpeed():Number { return _mouseWheelSpeed; }
	public function set mouseWheelSpeed(value:Number):Void { _mouseWheelSpeed=value; }
	
	public function set addContextMenu( addContextMenu_ : Boolean) : Void { _addContextMenu = addContextMenu_; }
	
	public function get cmStep() : Number { return _cm_step_default; }
	public function set cmStep( cmStep_:Number ) { _cm_step_default = cmStep_; }
	
	public function get xpandFocusRectToScrollBar() : Boolean { return _xpandFocusRectToScrollBar; }
	public function set xpandFocusRectToScrollBar( xpandFocusRectToScrollBar_:Boolean ) { _xpandFocusRectToScrollBar = xpandFocusRectToScrollBar_; }
	/**
	 * IFocus
	 */
	public function setTargetMC(targetMC_ : MovieClip) : Void {_targetMC=targetMC_;}
	public function getTargetMC() : MovieClip {return _targetMC;}

	public function setFocusRect(focusRect_ : Rectangle) : Void {__focusRect=focusRect_;}
	public function getFocusRect() : Rectangle {return __focusRect;}
	
	public function get targetToScrollY():Number 
	{ 
		return _targetToScroll._y; 
	}
	
	public function get targetToScrollX():Number 
	{ 
		return _targetToScroll._y; 
	}


	public function updateFocusRect() : Void 
	{
		var hOffset:Number 	=	0;
		var vOffset:Number	= 	0;
		if(_xpandFocusRectToScrollBar)
		{
			hOffset	=	(_scrollBarH_mc._height || 0)+(_scrollBarHoffset ||0);
			vOffset	=	(_scrollBarV_mc._width || 0)+(_scrollBarVoffset|| 0);
		}
		
		setFocusRect(new Rectangle(0,0,(_scRect.w+vOffset),_scRect.h+hOffset));
		
		_focusManager.updateRect(this,getFocusRect());
	}

	public function setFocus() : Void 
	{
//		Mouse.addListener(_mouseListener);
		MouseWheel.addListener(_mouseListener );
		_isFocus=true;
		distributeEvent(new ScrollPaneEvent(ScrollPaneEvent.FOCUS_RECEIVED, this));
	}

	public function killFocus() : Void 
	{
//		Mouse.removeListener(_mouseListener);
		MouseWheel.removeListener(_mouseListener );
		_isFocus=false;
		if(!_lockFocus) {
			distributeEvent(new ScrollPaneEvent(ScrollPaneEvent.FOCUS_LOST, this));
		} else {
			_scrollBarH.addEventListener(ScrollBarEvent.STOP_DRAG, _onReleaseFocusHandler);			_scrollBarV.addEventListener(ScrollBarEvent.STOP_DRAG, _onReleaseFocusHandler);
		}
	}

	public function updateFocusPoint() : Void {}
	public function isFocus() : Boolean {return _isFocus;}
	
	/**
	 * Destroy objects
	 */
	public function destroy():Void
	{
		removeFramePulse();
		
		_scrollBarH.destroy();
		_scrollBarV.destroy();
		
		_targetToScroll.swapDepths(1989);
		_targetToScroll.removeMovieClip();
		
		_targetMC.swapDepths(1989);
		_targetMC.removeMovieClip();
		
		_focusManager.removeItem(this);
		
		_eventDistributor.finalize();
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}	
	}
	
	private function onReleaseFocus(e_:ScrollBarEvent):Void {
		_scrollBarH.removeEventListener(ScrollBarEvent.STOP_DRAG, _onReleaseFocusHandler);
		_scrollBarV.removeEventListener(ScrollBarEvent.STOP_DRAG, _onReleaseFocusHandler);
		distributeEvent(new ScrollPaneEvent(ScrollPaneEvent.FOCUS_LOST, this));
	}
	
	public function get scRect():ScrollRect { return _scRect; }
	public function set scRect(value:ScrollRect):Void { _scRect=value; }
	
	public function getScrollBarsMC() :MovieClip
	{
		return _scrollBarsMC;
	}
	
	/**
	 * @see IDistributor#addEventListener
	 */
	public function addEventListener(type : String, func : Function) : Void {
		_eventDistributor.addEventListener(type, func );
	}
	
	/**
	 * @see IDistributor#removeEventListener
	 */
	public function removeEventListener(type : String, func : Function) : Void {
		_eventDistributor.removeEventListener(type, func );
	}
	
	/**
	 * @see IDistributor#distributeEvent
	 */
	public function distributeEvent(eventObject : IEvent) : Void {
		_eventDistributor.distributeEvent(eventObject );
	}
}