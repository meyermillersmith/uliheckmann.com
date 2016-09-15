import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.controls.events.SliderEvent;
import lessrain.lib.components.mediaplayer07.skins.core.ISliderSkin;
import lessrain.lib.layout.AbstractLayoutable;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.Proxy;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.Slider extends AbstractLayoutable {

	private var _skin : ISliderSkin; // visible skin
	private var _value : Number; // current value
	private var _min : Number; // minimum value
	private var _max : Number; // maximum value
	private var _selectableMin : Number; // minimum value that is currently selectable
	private var _selectableMax : Number; // maximum value that is currently selectable
	private var _hitArea : MovieClip; // hit area movie clip
	private var _isDragging:Boolean = false; // the slider is being dragged
	private var _isEnabled:Boolean; // the slider can be enabled or disabled

	private var _valueChangedEvent : SliderEvent;
	private var _selectableMinChangedEvent : SliderEvent;
	private var _selectableMaxChangedEvent : SliderEvent;
	
	private var _mouseListener : Object;
	
	/**
	 * Constructor
	 * @param	skin_	Slider skin
	 * @param	min_	Mimimum slider value
	 * @param	max_	Maximum slider value
	 */
	public function Slider(skin_ : ISliderSkin, min_ : Number, max_ : Number) {
		_skin = skin_;
		_skin.setSlider(this);

		setMin(min_);
		setMax(max_);

		_valueChangedEvent = new SliderEvent(SliderEvent.VALUE_CHANGED, this);
		_selectableMinChangedEvent = new SliderEvent(SliderEvent.SELECTABLE_MIN_CHANGED, this);
		_selectableMaxChangedEvent = new SliderEvent(SliderEvent.SELECTABLE_MAX_CHANGED, this);
		
		// MouseListener
		_mouseListener = new Object();
		_mouseListener.onMouseDown = Proxy.create(this, startDrag);
		_mouseListener.onMouseUp   = Proxy.create(this, stopDrag);
		
		setEnabled(true);
		
//		boundsVisible = true;
	}

	/**
	 * @see ILayoutable#setTarget
	 */
	public function setTarget(targetMC_ : MovieClip) : Void {
		super.setTarget(targetMC_);
		
		// Mouse hit area
		_hitArea = getTarget().createEmptyMovieClip("mouseHitArea", getTarget().getNextHighestDepth());

		_skin.buildSkin();
	}

	/**
	 * Tell skin to adjust to new dimensions
	 * @see ILayoutable#setBoundaries
	 */
	public function setBoundaries(rect_ : Rectangle) : Void {
		super.setBoundaries(rect_);
		_skin.resize(rect_.width, rect_.height);
	}

	/**
	 * Get skin instance
	 * @return	Skin instance
	 */
	public function getSkin() : ISliderSkin {
		return _skin;
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
	 * Get the value that is currently selected in the slider
	 * @return	Current slider value
	 */
	public function getValue() : Number {
		return _value;
	}

	/**
	 * Set the slider to a new value. <code>setValue</code> can be called either
	 * from outside to make the slider (and the skin) show the new value or
	 * from the skin when the user has used the slider skin to change the slider
	 * value.
	 * 
	 * @param	value_				New slider value
	 * @param	informListeners_	If <code>true</code>, the slider will
	 * 								inform its listeners about the change. If the
	 * 								value is changed from outside, you usually 
	 * 								set <code>dispatchValueChange</code> to 
	 * 								<code>false</code>. 
	 */
	public function setValue(value_ : Number, informListeners_ : Boolean) : Void {
		if(value_ < _min || value_ > _max || _value == value_) {
			return;
		}
		_value = value_;
		_skin.setValue(_value);
		if(informListeners_) {
			_eventDistributor.distributeEvent(_valueChangedEvent);
		}
	}

	/**
	 * Get the slider minimum value
	 * @return	Minimum value
	 */
	public function getMin() : Number {
		return _min || 0;
	}

	/**
	 * Set the slider minimum value. The value is only applied when the value is
	 * smaller or equal to the current maximum value.
	 * 
	 * @param	min_	Minimum value
	 */
	public function setMin(min_ : Number) : Void {
		if((min_ > _max && _max != null) || _min == min_ || min_ == null) {
			return;
		}
		_min = min_;
		_skin.setMin(_min);
		
		if(_min > _selectableMin) {
			setSelectableMin(_min);
		}
		_eventDistributor.distributeEvent(new SliderEvent(SliderEvent.MIN_CHANGED, this));
	}

	/**
	 * Get the slider maximum value
	 * @return	Maximum value
	 */
	public function getMax() : Number {
		return _max || 100;
	}

	/**
	 * Set the slider maximum value. The value is only applied when the value is
	 * bigger or equal to the current minimun value.
	 * 
	 * @param	max_	Maximum value
	 */
	public function setMax(max_ : Number) : Void {
		if((max_ < _min && _min != null) || _max == max_ || max_ == null) {
			return;
		}
		_max = max_;
		_skin.setMax(_max);
		
		if(_max < _selectableMax) {
			setSelectableMax(_max);
		}
		_eventDistributor.distributeEvent(new SliderEvent(SliderEvent.MAX_CHANGED, this));
	}

	/**
	 * Get the currently selectable minimum value
	 * @return	Selectable minimum
	 */
	public function getSelectableMin() : Number {
		return _selectableMin || getMin();
	}

	/**
	 * Set the currently selectable minimum value. The value is only applied if
	 * its witihn the range between the minimum and maximum.
	 * @param	sMin_	Selectable minimum
	 */
	public function setSelectableMin(sMin_ : Number) : Void {
		if(sMin_ == null) {
			return;
		}
		_selectableMin = Math.max(_min, Math.min(sMin_, _max));
		_skin.setSelectableMin(_selectableMin);
		_eventDistributor.distributeEvent(_selectableMinChangedEvent);
	}

	/**
	 * Get the currently selectable maximum value
	 * @return	Selectable maximum
	 */
	public function getSelectableMax() : Number {
		return _selectableMax || getMax();
	}

	/**
	 * Set the currently selectable maximum value. The value is only applied if
	 * its witihn the range between the minimum and maximum.
	 * @param	sMin_	Selectable maximum
	 */
	public function setSelectableMax(sMax_ : Number) : Void {
		if(sMax_ == null) {
			return;
		}
		_selectableMax = Math.max(_min, Math.min(sMax_, _max));
		_skin.setSelectableMax(_selectableMax);
		_eventDistributor.distributeEvent(_selectableMaxChangedEvent);
	}
	
	public function getEnabled():Boolean {
		return _isEnabled;
	}
	
	public function setEnabled(enabled_:Boolean):Void {
		if(enabled_ === _isEnabled) {
			return;
		}
		_isEnabled = enabled_;
		
		if(_isEnabled) {
			Mouse.addListener(_mouseListener);
		} else {
			Mouse.removeListener(_mouseListener);
		}
		_skin.setEnabled(enabled_);
	}

	/**
	 * Get the slider's hit area clip. The slider itself only creates the clip.
	 * It's subject to the skin to fill, position and resize the hit area.
	 * @return	Hit area clip
	 */
	public function getHitArea() : MovieClip {
		return _hitArea;
	}

	/**
	 * Clean up
	 */
	public function finalize() : Void {
		
		_skin.finalize();
		
		Mouse.removeListener(_mouseListener);
		delete _mouseListener;
		getTarget().removeMovieClip();
		
		super.finalize();
	}
	
	private function startDrag() : Void {
		if(_isDragging || !_isEnabled) {
			return;
		}
		if(_hitArea.hitTest(_root._xmouse, _root._ymouse)) {
			_mouseListener.onMouseMove = Proxy.create(_skin, _skin.onDrag);
			_skin.onDrag();
			_isDragging = true;
			_eventDistributor.distributeEvent(new SliderEvent(SliderEvent.START_DRAG, this));
		}
	}

	private function stopDrag() : Void {
		if(!_isDragging) {
			return;
		}
		_isDragging = false;
		delete _mouseListener.onMouseMove;
		_eventDistributor.distributeEvent(new SliderEvent(SliderEvent.STOP_DRAG, this));
	}
}