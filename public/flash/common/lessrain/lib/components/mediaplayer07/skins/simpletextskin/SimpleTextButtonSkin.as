import lessrain.lib.components.mediaplayer07.controls.Button;
import lessrain.lib.components.mediaplayer07.skins.core.IButtonSkin;
import lessrain.lib.utils.animation.easing.Sine;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.text.DynamicTextField;

import TextField.StyleSheet;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.simpletextskin.SimpleTextButtonSkin implements IButtonSkin {

	private var _button : Button;
	private var _text : String;
	private var _tween : Tween;
	private var _tf : DynamicTextField;
	private var _stylesheet : StyleSheet;
	private var _styleclass : String;

	public function SimpleTextButtonSkin(text_ : String, stylesheet_ : StyleSheet, styleclass_ : String) {
		_text = text_;
		_stylesheet = stylesheet_;
		_styleclass = styleclass_;
	}

	public function setButton(button_ : Button) : Void {
		_button = button_;
	}

	public function setPressed() : Void {
	}

	public function setReleased() : Void {
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
		var size:Size = new Size(_button.getTarget()._width + 10, _button.getTarget()._height);
		return size;
	}

	public function resize(w_ : Number, h_ : Number) : Void {
	}

	public function buildSkin() : Void {
		var targetMC : MovieClip = _button.getTarget();
		_tf = new DynamicTextField(targetMC);
		_tf.initialize(_text, _stylesheet, _styleclass, false, false, 0, 0);

		_tween = new Tween(targetMC);
		_tween.duration = 200;
		_tween.easingFunction = Sine.easeInOut;
	}

	public function finalize() :Void {
		delete _tween;
		_tf.removeMovieClip();
	}

	public function setEnabled(isEnabled_ : Boolean) : Void {
	}

}