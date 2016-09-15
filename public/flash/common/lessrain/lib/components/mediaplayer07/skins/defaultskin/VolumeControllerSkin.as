import lessrain.lib.components.mediaplayer07.controls.Slider;
import lessrain.lib.components.mediaplayer07.skins.core.ISliderSkin;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.graphics.ShapeUtils;

/**
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.defaultskin.VolumeControllerSkin implements ISliderSkin {

	private var _slider : Slider;
	private var _volumeSliderContainer : MovieClip; // contains volume slider assets
	private var _volumeBar : MovieClip; // shape that is scaled on volume change
	private var _maskMC : MovieClip; // _volumeBar mask

	private var _width : Number = 35;
	private var _height : Number = 12;
	
	
	/**
	 * Constructor
	 */
	public function VolumeControllerSkin() {
	}
	
	/**
	 * @see ISliderSkin#setSlider
	 */
	public function setSlider(slider_ : Slider) : Void {
		_slider = slider_;
	}
	
	/**
	 * @see ISliderSkin#buildSkin
	 */
	public function buildSkin() : Void {
		var targetMC : MovieClip = _slider.getTarget();

		_volumeSliderContainer = targetMC.createEmptyMovieClip("volumeSliderContainer", targetMC.getNextHighestDepth());
//		_volumeSliderContainer._x = _volumeSliderContainer._y = 5;
		
		_slider.getHitArea().clear();

		// Skin dimensions
//		_width  = _libMC._width;
//		_height = _libMC._height;
		var innerWidth : Number = _width/* - 10*/;
		var innerHeight : Number = _height/* - 10*/;

		// Dotted BG
		var bgN : Number = 0;
		var bgXSpace : Number = 2;
		while (bgN < innerWidth) {
			var bgDot : MovieClip = _volumeSliderContainer.createEmptyMovieClip("bgDot_" + _volumeSliderContainer.getNextHighestDepth(), _volumeSliderContainer.getNextHighestDepth());
			var num : Number = innerWidth / (1 + bgXSpace);
			var h : Number = bgN / num * innerHeight/innerWidth * 10;
			ShapeUtils.drawRectangle(bgDot, 0, innerHeight - h, 1, h, 0x4E4F4E, 100);
			bgDot._x = bgN;
			bgN += bgXSpace;
		}
		
		_volumeBar = _volumeSliderContainer.createEmptyMovieClip("volumeBar", _volumeSliderContainer.getNextHighestDepth());
		ShapeUtils.drawRectangle( _volumeBar, 0, 0, innerWidth, innerHeight, 0xFFFFFF, 100);
		
		_maskMC = _volumeSliderContainer.createEmptyMovieClip("maskMC", _volumeSliderContainer.getNextHighestDepth());
		_maskMC._x = _volumeBar._x;
		_maskMC._y = _volumeBar._y;

		var n : Number = 0;
		var xSpace : Number = 2;
		while (n < innerWidth)
		{
			var dot : MovieClip = _maskMC.createEmptyMovieClip("dot_"+_maskMC.getNextHighestDepth(), _maskMC.getNextHighestDepth());

			var num : Number = innerWidth / (1+xSpace);
			var h : Number = n/num * innerHeight/innerWidth * 10;
			ShapeUtils.drawRectangle( dot, 0, innerHeight - h, 1, h, 0xff0045, 100);
			dot._x = n;
			n += xSpace;
		}

		_volumeBar.setMask(_maskMC);
		
		// MouseHitArea
		ShapeUtils.drawRectangle( _slider.getHitArea(), 0, 0, innerWidth, innerHeight, 0xFFFFFF, 0);
		_slider.getHitArea()._x = _volumeSliderContainer._x;
		_slider.getHitArea()._y = _volumeSliderContainer._y;
	}

	/**
	 * Display the volume
	 * @see ISliderSkin#setValue
	 */
	public function setValue(value_ : Number) :Void {
		_volumeBar._xscale = value_ / _slider.getMax() * 100;
	}
	
	/**
	 * @see ISliderSkin#setMin
	 */
	public function setMin(min_ : Number) :Void {
		// We could display a textfield for the minimum volume value
	}

	/**
	 * @see ISliderSkin#setMax
	 */
	public function setMax(max_ : Number) :Void {
		// We could display a textfield for the maximum volume value
	}
	
	/**
	 * @see ISliderSkin#setSelectableMin
	 */
	public function setSelectableMin(selectableMin_ : Number) : Void {
		// Do nothing
	}

	/**
	 * @see ISliderSkin#setSelectableMax
	 */
	public function setSelectableMax(selectableMax_ : Number) : Void {
		// Do nothing
	}

	/**
	 * @see ISkin#resize
	 */
	public function resize(w_ : Number, h_ : Number) : Void {
		// The volume slider skin doesn't adjust its size
	}

	/**
	 * @see ISkin#getSize
	 */
	public function getSize() : Size {
//		return new Size(_libMC._width, _libMC._height);		return new Size(_width, _height);
	}

	/**
	 * @see ISliderSkin#onDrag
	 */
	public function onDrag() : Void {
		var scrubPercent : Number = (_slider.getHitArea()._xmouse * 100) / _slider.getHitArea()._width;
		scrubPercent = Math.max(0, Math.min(100, scrubPercent));
		_slider.setValue(scrubPercent, true);
	}
	
	/**
	 * @see ISliderSkin#setEnabled
	 */
	public function setEnabled(isEnabled_ : Boolean) : Void {
	}

	/**
	 * @see ISkin#finalize
	 */
	public function finalize() : Void {
	}
}
