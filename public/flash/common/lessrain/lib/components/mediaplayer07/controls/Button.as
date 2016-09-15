import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.controls.events.ButtonEvent;
import lessrain.lib.components.mediaplayer07.skins.core.IButtonSkin;
import lessrain.lib.layout.AbstractLayoutable;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.graphics.ShapeUtils;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.Button extends AbstractLayoutable {

	private var _skin : IButtonSkin; // button skin
	private var _overEvent:ButtonEvent; // some events that are distributed often: mouse roll over
	private var _outEvent:ButtonEvent; // mouse roll out
	private var _pressEvent:ButtonEvent; // mouse press
	private var _releaseEvent:ButtonEvent; // mouse release
	private var _isEnabled:Boolean; // button is enabled or disabled
	private var _hitArea:MovieClip;

	/**
	 * Constructor
	 * @param	skin_	Button skin
	 */
	public function Button(skin_ : IButtonSkin) {
		_skin = skin_;
		_skin.setButton(this);

		_overEvent = new ButtonEvent(ButtonEvent.ROLLOVER, this);		_outEvent = new ButtonEvent(ButtonEvent.ROLLOUT, this);		_pressEvent = new ButtonEvent(ButtonEvent.PRESS, this);		_releaseEvent = new ButtonEvent(ButtonEvent.RELEASE, this);
	}

	/**
	 * Set the button to roll over state
	 */
	public function setOver() : Void {
		_skin.setOver();
		_eventDistributor.distributeEvent(_overEvent);
	}

	/**
	 * Set the button to roll out state
	 */
	public function setOut() : Void {
		_skin.setOut();
		_eventDistributor.distributeEvent(_outEvent);
	}
	
	/**
	 * Set the button to released state
	 * @param	informListener_	If set to <code>true</code>, a ButtonEvent is 
	 * 							distributed. If setReleased is triggered from 
	 * 							outside, this value should be <code>false</code>
	 */
	public function setReleased(informListener_:Boolean):Void {
		_skin.setReleased();
		if(informListener_) {
			_eventDistributor.distributeEvent(_releaseEvent);
		}
	}
	
	/**
	 * Set the button to pressed state
	 * @param	informListener_	If set to <code>true</code>, a ButtonEvent is 
	 * 							distributed. If setPressed is triggered from 
	 * 							outside, this value should be <code>false</code>
	 */
	public function setPressed(informListeners_:Boolean) : Void {
		_skin.setPressed();
		if(informListeners_) {
			_eventDistributor.distributeEvent(_pressEvent);
		}
	}
	
	/**
	 * Set the button to released outside state
	 */
	public function setReleasedOutside() : Void {
		_skin.setReleased();
		_eventDistributor.distributeEvent(new ButtonEvent(ButtonEvent.RELEASE_OUTSIDE, this));
	}

	/**
	 * Get isEnabled state
	 * @return	<code>true</code> if the button is enabled
	 */	
	public function getEnabled():Boolean {
		return _isEnabled;
	}
	
	/**
	 * Set the isEnabled state
	 * @param	isEnabled state
	 */
	public function setEnabled(enabled_:Boolean):Void {
		if(_isEnabled == enabled_) {
			return;
		} 
		_isEnabled = enabled_;
		
//		var targetMC:MovieClip = getTarget();
		if(_isEnabled) {
			_hitArea.onPress = Proxy.create(this, setPressed, true);
			_hitArea.onRelease = Proxy.create(this, setReleased, true);
			_hitArea.onRollOver = Proxy.create(this, setOver);
			_hitArea.onRollOut = _hitArea.onDragOut = Proxy.create(this, setOut);
			_hitArea.onReleaseOutside = Proxy.create(this, setReleasedOutside);
		} else {
			delete _hitArea.onPress;
			delete _hitArea.onRelease;
			delete _hitArea.onRollOver;
			delete _hitArea.onRollOut;
			delete _hitArea.onDragOut;
			delete _hitArea.onReleaseOutside;
		}
		
		_skin.setEnabled(_isEnabled);
	}
	
	/**
	 * Get skin instance
	 * @return	Skin instance
	 */
	public function getSkin() : IButtonSkin {
		return _skin;
	}
	
	/**
	 * As soon as the target clip is set, register to the mouse events and build
	 * the skin.
	 * @see ILayoutable#setTarget
	 */
	public function setTarget(targetMC_ : MovieClip) : Void {
		super.setTarget(targetMC_);
		
		_skin.buildSkin();
		_hitArea = getTarget().createEmptyMovieClip("hitArea", getTarget().getNextHighestDepth());
		
		setEnabled(true);
		setOut();
	}
	
	/**
	 * Delegate <code>getDefaultSize()</code> to the skin
	 * @see ILayoutable#getDefaultSize
	 */
	public function getDefaultSize() : Size {
		var s : Size = _skin.getSize();
		return s;
	}
	
	/**
	 * Tell skin to adjust to new dimensions
	 * @see ILayoutable#setBoundaries
	 */
	public function setBoundaries(rect_ : Rectangle) : Void {
		super.setBoundaries(rect_);
	
		_skin.resize(rect_.width, rect_.height);
		var skinSize:Size = _skin.getSize();
		
		ShapeUtils.drawRectangle(_hitArea, 0, 0, skinSize.w, skinSize.h, 0xFF0000, 0);
	}

	/**
	 * Clean up
	 */
	public function finalize() : Void {
		_skin.finalize();
		_hitArea.removeMovieClip();
		
		super.finalize();
	}
}