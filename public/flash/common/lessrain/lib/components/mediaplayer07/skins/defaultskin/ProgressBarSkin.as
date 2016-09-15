import lessrain.lib.components.mediaplayer07.controls.Slider;
import lessrain.lib.components.mediaplayer07.skins.core.ISliderSkin;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.graphics.ShapeUtils;

/**
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.defaultskin.ProgressBarSkin implements ISliderSkin {

	private var _slider : Slider;
	private var _progressBarContainer : MovieClip; // contains progress and loaded shape
	private var _progressShape : MovieClip; // display the progress value
	private var _loadedShape : MovieClip; // display the loaded amount of data
	private var _maskMC : MovieClip; // mask the progress and loaded shapes
	private var _illuLeft : MovieClip; // left border illustration
	private var _illuRight : MovieClip; // right border illustration

	private var _width : Number;
	private var _height : Number = 15;
	
	
	/**
	 * Constructor
	 */
	public function ProgressBarSkin() {
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
		_progressBarContainer = targetMC.createEmptyMovieClip("progressBarContainer", targetMC.getNextHighestDepth());
		_loadedShape = _progressBarContainer.createEmptyMovieClip("loadedShape", _progressBarContainer.getNextHighestDepth());
		_progressShape = _progressBarContainer.createEmptyMovieClip("progressShape", _progressBarContainer.getNextHighestDepth());
		
		// Separators
		_illuLeft = targetMC.createEmptyMovieClip("illuLeft", targetMC.getNextHighestDepth());
		ShapeUtils.drawRectangle( _illuLeft, 0, 0, 1, 3, 0xFFFFFF, 100);

		_illuRight = targetMC.createEmptyMovieClip("illuRight", targetMC.getNextHighestDepth());
		ShapeUtils.drawRectangle( _illuRight, 0, 0, 1, 3, 0xFFFFFF, 100);
	}

	/**
	 * Display the progress
	 * @see ISliderSkin#setValue
	 */
	public function setValue(value_ : Number) :Void {
		_progressShape._xscale = value_ / _slider.getMax() * 100;
	}
	
	/**
	 * @see ISliderSkin#setMin
	 */
	public function setMin(min_ : Number) :Void {
		// Do nothing
	}

	/**
	 * @see ISliderSkin#setMax
	 */
	public function setMax(max_ : Number) :Void {
		// We could display a textfield that contains the media duration here
	}
	
	/**
	 * @see ISliderSkin#setSelectableMin
	 */
	public function setSelectableMin(selectableMin_ : Number) : Void {
		// Do nothing
	}

	/**
	 * Use this to display the amount of loaded data
	 * @see ISliderSkin#setSelectableMax
	 */
	public function setSelectableMax(selectableMax_ : Number) : Void {
		_loadedShape._xscale = selectableMax_ / _slider.getMax() * 100;
	}
	
	/**
	 * @see ISkin#resize
	 */
	public function resize(w_ : Number, h_ : Number) : Void {
		_progressBarContainer._x = 2;
		_progressBarContainer._y = Math.floor(_height / 2);

		_width = w_;
//		_height = h_;
		_loadedShape.clear();
		_progressShape.clear();
		_slider.getHitArea().clear();

		var innerWidth : Number = _width - 4;
		ShapeUtils.drawRectangle(_loadedShape, 0, 0, innerWidth, 1, 0x4E4F4E, 100);
		ShapeUtils.drawRectangle(_progressShape, 0, 0, innerWidth, 1, 0xFFFFFF, 100);
		ShapeUtils.drawRectangle(_slider.getHitArea(), 0, 0, innerWidth, _height, 0xFFFFFF, 0);
//		_slider.getHitArea()._x = 10;
		
		// Dotted Mask
		if (_maskMC != null) {
			_maskMC.removeMovieClip();
		}
		_maskMC = _slider.getTarget().createEmptyMovieClip("maskMC", _slider.getTarget().getNextHighestDepth());
		_maskMC._x = _progressBarContainer._x;
		_maskMC._y = _progressBarContainer._y;

		var n : Number = 0;
		var xSpace : Number = 2;
		while (n < innerWidth) {
			var dot : MovieClip = _maskMC.createEmptyMovieClip("dot_" + _maskMC.getNextHighestDepth(), _maskMC.getNextHighestDepth());
			ShapeUtils.drawRectangle( dot, 0, 0, 1, 1, 0xff0045, 100);
			dot._x = n;
			n += xSpace;
		}

		_progressBarContainer.setMask( _maskMC );

		_illuLeft._x = 0;
		_illuLeft._y = _progressBarContainer._y - 1;
		_illuRight._x = _progressBarContainer._x + innerWidth + 2;
		_illuRight._y = _illuLeft._y;
		
	}

	/**
	 * @see ISkin#getSize
	 */
	public function getSize() : Size {
		return new Size(_width, _height);
	}
	
	/**
	 * @see ISliderSkin#onDrag
	 */
	public function onDrag() : Void {
		var scrubPercent:Number = (_slider.getHitArea()._xmouse * 100) / _slider.getHitArea()._width;
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
