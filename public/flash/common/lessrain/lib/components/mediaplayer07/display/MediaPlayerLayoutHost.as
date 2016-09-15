import mx.utils.Delegate;

import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.events.MouseEvent;
import lessrain.lib.layout.AbstractLayoutHost;
import lessrain.lib.utils.ArrayUtils;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.MediaPlayerLayoutHost extends AbstractLayoutHost {
	
	private var _isOver:Boolean = false;
	
	private var _mouseEnterEvent:MouseEvent;
	private var _mouseLeaveEvent:MouseEvent;
	private var _mouseMoveOverEvent:MouseEvent;
	
	public function MediaPlayerLayoutHost() {
		super();
		
		_mouseEnterEvent = new MouseEvent(MouseEvent.MOUSE_ENTER, this);		_mouseLeaveEvent = new MouseEvent(MouseEvent.MOUSE_LEAVE, this);		_mouseMoveOverEvent = new MouseEvent(MouseEvent.MOUSE_MOVE_OVER, this);
	}
	
	public function setTarget(targetMC_:MovieClip):Void {
		super.setTarget(targetMC_);
		
		// re-route the getNextHighestDepth method of the target clip to force 
		// the children and the mask to be the topmost elements
		getTarget().getNextHighestDepth = Delegate.create(this, getNextTargetDepth);
	}
	
	public function startMouseListener():Void {
		Mouse.addListener(this);
	}
	
	public function stopMouseListener():Void {
		Mouse.removeListener(this);
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		stopMouseListener();
		
		super.finalize();
	}
	
	private function onMouseMove():Void {
		var bounds : Rectangle = getBoundaries();
		var x:Number = getTarget()._xmouse;
		var y:Number = getTarget()._ymouse;
		var over : Boolean = x >= 0 && x <= bounds.width && y >= 0 && y <= bounds.height;
		if(_isOver != over) {
			_isOver = over;
			_eventDistributor.distributeEvent(_isOver ? _mouseEnterEvent : _mouseLeaveEvent);
		} else {
			if(_isOver) {
				_eventDistributor.distributeEvent(_mouseMoveOverEvent);
			}
		}
	}
	
	private function getNextTargetDepth():Number {
		var tgt:MovieClip = getTarget();
		var levels:Array = new Array(0);
		for (var s : String in tgt) {
			if(typeof(tgt[s]) == "movieclip") {
				var clip:MovieClip = MovieClip(tgt[s]); 
				if(clip.getDepth() != DEPTH_CONTAINER) {
					levels.push(clip.getDepth());
				}
			}
		}
		return ArrayUtils.max(levels) + 1;
	}
}