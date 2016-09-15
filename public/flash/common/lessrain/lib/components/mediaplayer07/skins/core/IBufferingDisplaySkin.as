import lessrain.lib.components.mediaplayer07.controls.BufferingDisplay;
import lessrain.lib.components.mediaplayer07.skins.core.ISkin;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.IBufferingDisplaySkin extends ISkin {
	
	/**
	 * Set the underlying buffering display control
	 * @param	bufferingDisplay_	Buffering display control
	 */
	public function setBufferingDisplay(bufferingDisplay_ : BufferingDisplay) : Void;
	
	/**
	 * Set the buffer percentage
	 * @param	Buffer percentage [0..100]
	 */
	public function setBufferPercentage(percentage_ : Number) : Void;

	/**
	 * Show buffering display
	 */
	public function show() : Void;

	/**
	 * Hide buffering display
	 */
	public function hide() : Void;

}