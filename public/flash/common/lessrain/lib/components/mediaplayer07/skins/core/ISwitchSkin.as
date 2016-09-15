import lessrain.lib.components.mediaplayer07.skins.core.IButtonSkin;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.ISwitchSkin extends IButtonSkin {
	
	/**
	 * Set switched on / switched off state
	 * @param	on_	Switched on / off state
	 */
	public function setOn(on_ : Boolean) : Void;
}