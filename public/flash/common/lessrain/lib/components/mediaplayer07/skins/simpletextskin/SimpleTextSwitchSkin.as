import lessrain.lib.components.mediaplayer07.skins.core.ISwitchSkin;
import lessrain.lib.components.mediaplayer07.skins.simpletextskin.SimpleTextButtonSkin;

import TextField.StyleSheet;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.simpletextskin.SimpleTextSwitchSkin extends SimpleTextButtonSkin implements ISwitchSkin {
	
	private var _onText:String;
	private var _offText:String;
	
	public function SimpleTextSwitchSkin(onText_:String, offText_:String, stylesheet_ : StyleSheet, styleclass_ : String) {
		super(_onText, stylesheet_, styleclass_);
		
		_onText = onText_;
		_offText = offText_;
	}
	
	public function setOn(on_ : Boolean) : Void {
		_tf.text = on_ ? _onText : _offText;
	}
	
}