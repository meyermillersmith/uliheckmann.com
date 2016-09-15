import lessrain.lib.components.mediaplayer07.skins.core.ISkin;
import lessrain.lib.components.mediaplayer07.controls.TextField;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.ITextFieldSkin extends ISkin {
	
	/**
	 * Set the underlying text field
	 * @param	textField_	The text field of this skin
	 */
	public function setTextField(textField_ : TextField) : Void;
	
	/**
	 * Set the text to display
	 * @param	text_	Display text
	 */
	public function setText(text_ : String) : Void;
}