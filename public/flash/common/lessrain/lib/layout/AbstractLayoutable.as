import flash.geom.Rectangle;

import lessrain.lib.layout.boundarycontroller.BoundaryController;
import lessrain.lib.layout.boundarycontroller.IBoundaryController;
import lessrain.lib.layout.boundarycontroller.SimplePositionDecorator;
import lessrain.lib.layout.boundarycontroller.VisibleBoundsDecorator;
import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.ILayoutData;
import lessrain.lib.layout.ILayoutHost;
import lessrain.lib.layout.Layout;
import lessrain.lib.layout.LayoutError;
import lessrain.lib.layout.LayoutEvent;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.Proxy;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * Abstract base class that implements <code>ILayoutable</code> and can be layouted
 * by the Layout Managers that extend <code>Layout</code>. Instances should be
 * added to an <code>ILayoutHost</code> instance.
 * 
 * @see ILayoutHost
 * @see AbstractLayoutHost
 */
class lessrain.lib.layout.AbstractLayoutable implements ILayoutable, IDistributor {
	
	// default width
	public static var DEFAULT_WIDTH:Number = 50;
	// default height
	public static var DEFAULT_HEIGHT:Number = 50;
	
	// clip bounds visibility
	public var boundsVisible:Boolean = false;
	// color of bounding box
	public var boundColor:Number = 0x999999;
	// bounding box alpha
	public var boundAlpha:Number = 60;
	
	private var _targetMC:MovieClip;
	private var _targetSet:Boolean = false;
	private var _layoutHost:ILayoutHost;
	private var _size:Size;
	private var _defaultSize:Size;
	private var _layoutData:ILayoutData;
	private var _orderID:Number;
	private var _eventDistributor:EventDistributor;
	private var _boundaryController:IBoundaryController;
	private var _twins:Array; // ILayoutable
	private var _isOver:Boolean;
	
	/**
	 * Constructor
	 */
	public function AbstractLayoutable() {
		_eventDistributor = new EventDistributor();
	}
	
	/**
	 * @see ILayoutable#setTarget
	 */
	public function setTarget(targetMC_:MovieClip):Void {
		if(_targetSet) {
			LogManager.error("AbstractLayoutable: setTarget(): Target clip has already been set.");
			throw LayoutError.TARGET_ALREADY_SET; 
			return;
		}
		
		_targetMC = targetMC_;
		_targetSet = true;
	}
	
	/**
	 * @see ILayoutable#getTarget
	 */
	public function getTarget():MovieClip {
		return _targetMC;
	}
	
	/**
	 * @see ILayoutable#getBoundaries
	 */
	public function getBoundaries():Rectangle {
		return getBoundaryController().getBoundaries();
	}
	
	/**
	 * @see ILayoutable#setBoundaries
	 * @see IBoundaryController
	 */
	public function setBoundaries(rect_:Rectangle):Void {
		getBoundaryController().setBoundaries(getTarget(), rect_);
		_size = new Size(Math.round(rect_.width), Math.round(rect_.height));
		
		// update twins
		for(var i:Number = 0; i < _twins.length; i++) {
			var twin:ILayoutable = ILayoutable(_twins[i]);
			twin.setBoundaries(rect_);
		}
		
		_eventDistributor.distributeEvent(new LayoutEvent(LayoutEvent.BOUNDARIES_SET, this));
	}
	
	/**
	 * @see ILayoutable#getLayoutData
	 */
	public function getLayoutData():ILayoutData {
		return _layoutData;
	}
	
	/**
	 * @see ILayoutable#setLayoutData
	 */
	public function setLayoutData(data_:ILayoutData):Void {
		_layoutData = data_;
	}

	/**
	 * @see ILayoutable#computeSize
	 */
	public function computeSize(wHint:Number, hHint:Number, flushCache_:Boolean):Rectangle {
		var width:Number = getDefaultSize().w;
		var height:Number = getDefaultSize().h;
		if (wHint != Layout.DEFAULT) width = wHint;
		if (hHint != Layout.DEFAULT) height = hHint;
		var rect:Rectangle = new Rectangle (getTarget()._x, getTarget()._y, width, height);
		return rect;
	}

	/**
	 * @see ILayoutable#getDefaultSize
	 */
	public function getDefaultSize():Size {
		if(_defaultSize == null) {
			_defaultSize = new Size(DEFAULT_WIDTH, DEFAULT_HEIGHT); 
		}
		return _defaultSize;
	}
	
	/**
	 * @see ILayoutable#setDefaultSize
	 */
	public function setDefaultSize(size_:Size):Void {
		// do nothing if new size equals current size
		if((size_.w == _defaultSize.w) && (size_.h == _defaultSize.h)) {
			return;
		}
		_defaultSize = size_;
		
		// flush layout cache
		getLayoutHost().getLayout().flushCache(this);
		
		_eventDistributor.distributeEvent(new LayoutEvent(LayoutEvent.CHANGED_DEFAULT_SIZE, this));
	}
	
	
	/**
	 * @see ILayoutable#pack
	 */
	public function pack() : Void {
		setBoundaries(computeSize(Layout.DEFAULT, Layout.DEFAULT));
	}
	
	/**
	 * @see ILayoutable#getLayoutHost
	 */
	public function getLayoutHost():ILayoutHost {
		return _layoutHost;
	}

	/**
	 * @see ILayoutable#setLayoutHost
	 */
	public function setLayoutHost(layoutHost_:ILayoutHost) : Void {
		_layoutHost = layoutHost_;
	}
	
	/**
	 * @see ILayoutable#getOrderID
	 */
	public function getOrderID():Number {
		return _orderID;
	}
	
	/**
	 * @see ILayoutable#setOrderID
	 */
	public function setOrderID(orderID_:Number):Void {
		_orderID = orderID_;
	}
	
	/**
	 * Get boundaty controller instance. If no boundary controller has been set
	 * yet, create a default one.
	 * @return	Boundary controller instance
	 */
	public function getBoundaryController():IBoundaryController {
		if(_boundaryController == null) {
			
			// create default boundary controller
			_boundaryController = new BoundaryController();
			_boundaryController = new SimplePositionDecorator(_boundaryController);
			if(boundsVisible) {
				_boundaryController = new VisibleBoundsDecorator(_boundaryController, 1, boundColor, boundAlpha);
			}
		}
		return _boundaryController;
	}
	
	/**
	 * Set the boundary controller instance
	 * @param	Boundary controller instance
	 */
	public function setBoundaryController(controller_:IBoundaryController):Void {
		_boundaryController = controller_;
	}
	
	/**
	 * Tell the <code>ILayoutable</code> parameter to keep the boundaries in
	 * sync with its twin. Whenever <code>setBoundaries()</code> is called on
	 * this instance, all twins will be told to set their boundaries accordingly.
	 * 
	 * @param	twin_	ILayoutable to keep synced
	 */
	public function siameseTwin(twin_:ILayoutable):Void{
		var tgt:MovieClip = getLayoutHost().getChildrenContainer();
		twin_.setTarget(tgt.createEmptyMovieClip("twin" + tgt.getNextHighestDepth(), tgt.getNextHighestDepth()));
		
		if(_twins == null) {
			_twins = new Array();
		}
		_twins.push(twin_);
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
	
	/**	
	 * Clean up
	 */
	public function finalize():Void {
		// remove twins
		for(var i:Number = 0; i < _twins.length; i++) {
			ILayoutable(_twins[i]).finalize();
		}
		
		_eventDistributor.finalize();
		getBoundaryController().finalize();
		getLayoutHost().removeChild(this);
		delete getTarget().onMouseMove;
		getTarget().removeMovieClip();
	}
}