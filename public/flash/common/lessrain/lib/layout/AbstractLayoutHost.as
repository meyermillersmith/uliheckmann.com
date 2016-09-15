import lessrain.lib.layout.AbstractLayoutable;
import lessrain.lib.layout.ILayoutHost;
import lessrain.lib.layout.ILayoutable;
import lessrain.lib.layout.Layout;
import lessrain.lib.layout.LayoutError;
import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.geom.Size;

import flash.geom.Rectangle;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 * 
 * Abstract base class that implements <code>ILayoutHost</code>. Extend to
 * create a layout host that arranges its <code>ILayoutable</code>child items 
 * according to its <code>ILayout</code> instance.
 * 
 * @see ILayoutable
 * @see AbstractLayoutable
 */
class lessrain.lib.layout.AbstractLayoutHost extends AbstractLayoutable implements ILayoutHost {
	
	// level of content container clip
	// TODO use a depth manager to keep track of movie clip depths
	public static var DEPTH_CONTAINER:Number = 10000;
	
	private var _children:Array;
	private var _layout:Layout;
	private var _childrenContainer:MovieClip;
	
	/**
	 * Constructor
	 */
	public function AbstractLayoutHost() {
	}
	
	/**
	 * Set target clip. Must be called exactly once!
	 * @param	targetMC_	Target MovieClip
	 */
	public function setTarget(targetMC_:MovieClip):Void {
		try {
			super.setTarget(targetMC_);
		} catch (e_:LayoutError) {
			// an error occured
			return;
		}
		
		// children
		_children = new Array();
		_childrenContainer = getTarget().createEmptyMovieClip("____childrenContainer", DEPTH_CONTAINER);
	}
	
	/**
	 * <p>Adds a child to the host. If the child's target is not set yet, <code>addChild</code>
	 * will assign the target per default.</p>
	 * <p>Usage: Simply add a child to the host: 
	 * <pre>
	 * 	var controlPanel:ControlPanel = new ControlPanel(); // ControlPanel is ILayoutable
	 * 	view.addChild(controlPanel); // view is ILayouthost
	 * </pre>
	 * </p>
	 * <p>Usage: Specify target and target name first:
	 * <pre>
	 * 	var controlPanel:ControlPanel = new ControlPanel(); // ControlPanel is ILayoutable
	 * 	controlPanel.setTarget(view.createNextChildContainer("myControlPanel")); // view is ILayouthost
	 * 	view.addChild(controlPanel);
	 * </pre>
	 * 
	 * @see ILayoutHost#addChild
	 */
	public function addChild(child_:ILayoutable):ILayoutable {
		child_.setLayoutHost(this);
		child_.setOrderID(_children.push(child_) - 1);
		
		// assign target to child
		if(child_.getTarget() == null) {
			child_.setTarget(createNextChildContainer());
		}
		return child_;
	}
	
	/**
	 * Add a child at a given position
	 * @param	child_		Child to be added
	 * @param	orderID_	Insert position of the child
	 * @return				The added child
	 */
	public function addChildAt(child_:ILayoutable, orderID_:Number):ILayoutable {
		_children.splice(orderID_, 0, child_);
		rebuildChildOrder();
		return child_;
	}
	
	/**
	 * @see ILayoutHost#removeChild
	 */
	public function removeChild(child_:ILayoutable):ILayoutable {
		return removeChildAt(child_.getOrderID());
	}
	
	/**
	 * Remove a child from host
	 * @param	orderID_	Order ID of the child to be removed
	 * @return				The removed child or null if the child could not be
	 * 						removed
	 */
	public function removeChildAt(orderID_:Number):ILayoutable {
		var tmp:Array = _children.splice(orderID_, 1);
		if(tmp.length == 0) {
			return null;
		}
		var removed:ILayoutable = ILayoutable(tmp[0]); 
		if(removed != null) {
			rebuildChildOrder();
		}
		return removed;
	}
	
	/**
	 * @see ILayoutHost#getChildren
	 */
	public function getChildren():Array {
		return _children;
	}
	
	/**
	 * @see ILayoutHost#getLayout
	 */
	public function getLayout() : Layout {
		return _layout;
	}
	
	/**
	 * @see ILayoutHost#setLayout
	 */
	public function setLayout(layout_:Layout):Void {
		_layout = layout_;
	}
	
	/**
	 * @see ILayoutable#setBoundaries
	 */
	public function setBoundaries(rect_:Rectangle):Void {
		super.setBoundaries(rect_);

		layout();
	}
	
	/**
	 * @see	ILayoutHost#layout
	 */
	public function layout():Void {
		if(_layout == null) {
			return;
		}
		_layout.layout(this);
	}
	
	/**
	 * @see ILayoutable#computeSize
	 */
	public function computeSize(wHint:Number, hHint:Number, flushCache_:Boolean):Rectangle {
		var size:Size;
		if(_layout != null) {
			if(wHint == Layout.DEFAULT || hHint == Layout.DEFAULT) {
				size = _layout.computeSize(this, wHint, hHint, flushCache_);
			} else {
				size = new Size(wHint, hHint);
			}
		} else {			size = getDefaultSize();
		}
		
		if (size.w == 0) size.w = DEFAULT_WIDTH;
		if (size.h == 0) size.h = DEFAULT_HEIGHT;
		if (wHint != Layout.DEFAULT) size.w = wHint;
		if (hHint != Layout.DEFAULT) size.h = hHint;
		var rect:Rectangle = new Rectangle(getTarget()._x, getTarget()._y, size.w, size.h);
		return rect;
	}
	
	/**
	 * Create and return the next empty clip within the childrenContainer
	 * @param	name_	Clip name prefix (optional)
	 * @return	an empty clip within the childrenContainer
	 */
	public function createNextChildContainer(name_:String):MovieClip {
		var d:Number = _childrenContainer.getNextHighestDepth();
		return _childrenContainer.createEmptyMovieClip((name_ == null ? "child" : name_) + d, d);
	}
	
	/**
	 * @see ILayoutHost#getChildrenContainer
	 */
	public function getChildrenContainer():MovieClip {
		return _childrenContainer;
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		// Make a copy of the children array first, because every child.finalize()
		// call will affect the _children array.
		var children:Array = ArrayUtils.clone(_children);
		for(var i:Number = 0; i < children.length; i++) {
			var child:ILayoutable = ILayoutable(children[i]);
			child.finalize();
		}
		delete _children;
		
		super.finalize();
	}
	
	private function rebuildChildOrder():Void {
		var tmp:Array = ArrayUtils.clone(_children); // ILayoutable
		_children = new Array();
		for(var i:Number = 0; i < tmp.length; i++) {
			addChild(ILayoutable(tmp[i]));
		}
	}
}