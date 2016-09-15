import lessrain.lib.components.mediaplayer07.skins.core.ISkin;
import lessrain.lib.components.mediaplayer07.controls.Button;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.IButtonSkin extends ISkin {
	
	/**
	 * Set the underlying button instance for this skin
	 * @param	button_	Button instance
	 */
	public function setButton(button_ : Button) : Void;

	/**
	 * Show pressed state
	 */
	public function setPressed() : Void;

	/**
	 * Show released state
	 */
	public function setReleased() : Void;

	/**
	 * Show mouse over state
	 */
	public function setOver() : Void;

	/**
	 * Show mouse out state
	 */
	public function setOut() : Void;
	
	/**
	 * Show enabled / disabled state
	 * @param	isEnabled_	Enabled / disabled state
	 */
	public function setEnabled(isEnabled_ : Boolean) : Void;

}