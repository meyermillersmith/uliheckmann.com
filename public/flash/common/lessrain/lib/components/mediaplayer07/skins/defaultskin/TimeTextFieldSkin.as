/**
 * @author Oliver List (o.list@lessrain.com)
 */

import lessrain.lib.components.mediaplayer07.controls.TextField;
import lessrain.lib.components.mediaplayer07.skins.core.ITextFieldSkin;
import lessrain.lib.utils.assets.StyleSheet;
import lessrain.lib.utils.geom.Size;
import lessrain.lib.utils.text.DynamicTextField;

class lessrain.lib.components.mediaplayer07.skins.defaultskin.TimeTextFieldSkin implements ITextFieldSkin {
	
	private var _textField : TextField;
	private var _tf : DynamicTextField;
	
	
	/*
	 * Constructor
	 */
	public function TimeTextFieldSkin()
	{
	}

	/**
	 * @see ISkin#getSize
	 */
	public function getSize() : Size {
		return new Size(_tf.textWidth, _tf.textHeight);
	}

	/**
	 * @see	ISkin#finalize
	 */
	public function finalize() : Void {
		_tf.removeMovieClip();
	}
	
	/**
	 * @see ITextFieldSkin#setTextField
	 */
	public function setTextField(textField_ : TextField) : Void {
		_textField = textField_;
	}

	/**
	 * @see ITextFieldSkin#setText
	 */
	public function setText(text_ : String) : Void {
		_tf.text = text_;
	}

	/**
	 * @see	ISkin#resize
	 */
	public function resize(w_ : Number, h_ : Number) : Void {
		// no, do not resize
	}

	/**
	 * @see	ISkin#buildSkin
	 */
	public function buildSkin() : Void {
		var targetMC:MovieClip = _textField.getTarget();
		
		_tf = DynamicTextField(targetMC.attachMovie("DynamicTextField", "tf_" + targetMC.getNextHighestDepth(),targetMC.getNextHighestDepth()));
		_tf.initialize( "88:88",  StyleSheet.getStyleSheet("main"), "hotspotPlayerButtonStyle", false, false, -2, -2);
	}
}
