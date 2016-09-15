import lessrain.lib.components.mediaplayer07.controls.Button;
import lessrain.lib.components.mediaplayer07.skins.core.IButtonSkin;
import lessrain.lib.utils.animation.easing.Sine;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.geom.Size;

/**
 * Implentattion of a simple button skin. The skin attaches clips from the
 * library. Every library item has to contain an invisible clip named "size" 
 * that is positioned at (0, 0) and can be used as the size reference.
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.defaultskin.SimpleButtonSkin implements IButtonSkin {

	private var _button : Button;
	private var _linkageID : String;
	private var _tween : Tween;
	private var _libraryItem : MovieClip;

	public function SimpleButtonSkin(linkageID_ : String) {
		_linkageID = linkageID_;
	}

	public function setButton(button_ : Button) : Void {
		_button = button_;
	}

	public function setPressed() : Void {
		_libraryItem._x = _libraryItem._y = 1;
	}

	public function setReleased() : Void {
		_libraryItem._x = _libraryItem._y = 0;
	}

	public function setOver() : Void {
		_tween.reset();
		_tween.setTweenProperty('_alpha', _button.getTarget()._alpha, 50);
		_tween.start();
	}

	public function setOut() : Void {
		_tween.reset();
		_tween.setTweenProperty('_alpha', _button.getTarget()._alpha, 100);
		_tween.start();
	}

	public function getSize() : Size {
		var sizeMC:MovieClip = MovieClip(_libraryItem["size"]);
		return new Size(sizeMC._width, sizeMC._height);
	}

	public function resize(w_ : Number, h_ : Number) : Void {
	}

	public function buildSkin() : Void {
		var targetMC : MovieClip = _button.getTarget();
		_libraryItem = targetMC.attachMovie(_linkageID, "libMC", targetMC.getNextHighestDepth());

		_tween = new Tween(targetMC);
		_tween.duration = 200;
		_tween.easingFunction = Sine.easeInOut;
	}

	public function finalize() :Void {
		delete _tween;
	}

	public function setEnabled(isEnabled_ : Boolean) : Void {
		_tween.reset();
		_tween.setTweenProperty('_alpha', _button.getTarget()._alpha, isEnabled_ ? 100 : 20);
		_tween.start();
	}

}