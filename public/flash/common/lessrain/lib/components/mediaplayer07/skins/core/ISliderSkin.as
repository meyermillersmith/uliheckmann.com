import lessrain.lib.components.mediaplayer07.skins.core.ISkin;
import lessrain.lib.components.mediaplayer07.controls.Slider;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.ISliderSkin extends ISkin {
	
	/**
	 * Set the underlying slider instance to this skin
	 * @param	slider_	Slider instance
	 */
	public function setSlider(slider_ : Slider) : Void;
	
	/**
	 * Set the current value the slider should point to
	 * @param	value_	Slider value
	 */
	public function setValue(value_ : Number) :Void;
	
	/**
	 * Set the absolute mimimum value
	 * @param	min_	Minimum slider value
	 */
	public function setMin(min_ : Number) :Void;
	
	/**
	 * Set the absolute maximum value
	 * @param	max_	Maximum slider value
	 */
	public function setMax(max_ : Number) :Void;
	
	/**
	 * Set the minimum value that is currenlty selectable
	 * @param	selectableMin_	Minimum selectable value
	 */
	public function setSelectableMin(selectableMin_ : Number) : Void;
	
	/**
	 * Set the maximum value that is currently selecteable
	 * @param	selectableMax_	Maximum selectable value
	 */
	public function setSelectableMax(selectableMax_ : Number) : Void;

	/**
	 * <code>onDrag</code> will be called on mouse move events when the slider
	 * is currently dragged. The calculation of the current slider value should
	 * be done in this method. Implementations should also call <code>setValue</code>
	 * on the slider instance afterwards to set the slider to the new value.
	 */
	public function onDrag() : Void;
	
	/**
	 * Show enabled / disabled state
	 * @param	isEnabled_	Enabled / disabled state
	 */
	public function setEnabled(isEnabled_ : Boolean) : Void;
}