import lessrain.lib.components.mediaplayer07.controls.BufferingDisplay;
import lessrain.lib.components.mediaplayer07.skins.core.IBufferingDisplaySkin;
import lessrain.lib.utils.geom.Size;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.defaultskin.BufferingDisplaySkin implements IBufferingDisplaySkin {

	private var _libMC : MovieClip;
	private var _bufferingDisplay : BufferingDisplay;

	public function setBufferingDisplay(bufferingDisplay_ : BufferingDisplay) : Void {
		_bufferingDisplay = bufferingDisplay_;
	}

	public function getSize() : Size {
		return new Size(_libMC._width, _libMC._height);
	}

	public function resize(w_ : Number, h_ : Number) : Void {
	}

	public function buildSkin() : Void {
		var targetMC : MovieClip = _bufferingDisplay.getTarget();
		_libMC = targetMC.attachMovie("LoadingDisplayIllu", "bufferingIllu", targetMC.getNextHighestDepth());
		_libMC._xscale = _libMC._yscale = 50;
		_libMC._visible = false;
	}

	public function setBufferPercentage(percentage_ : Number) : Void {
		// You may create a text field here to show the buffer amount 
	}

	public function finalize() :Void {
	}


	public function show() : Void {
		_libMC._visible = true;
	}

	public function hide() : Void {
		_libMC._visible = false;
	}

}