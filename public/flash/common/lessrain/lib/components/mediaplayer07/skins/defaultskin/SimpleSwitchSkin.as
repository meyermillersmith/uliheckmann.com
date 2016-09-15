import lessrain.lib.components.mediaplayer07.skins.core.ISwitchSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.SimpleButtonSkin;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.defaultskin.SimpleSwitchSkin extends SimpleButtonSkin implements ISwitchSkin {
	
	public function SimpleSwitchSkin(linkageID_ : String) {
		super(linkageID_);
	}
	
	public function setOn(on_ : Boolean) : Void {
		_libraryItem.gotoAndStop(on_ ? 1 : 2);
	}

}