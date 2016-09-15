/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 * @author Oliver List (o.list@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.skins.core.IBufferingDisplaySkin;
import lessrain.lib.components.mediaplayer07.skins.core.IButtonSkin;
import lessrain.lib.components.mediaplayer07.skins.core.IControlPanelSkin;
import lessrain.lib.components.mediaplayer07.skins.core.IDisplayPanelSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ISliderSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ISwitchSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ITextFieldSkin;



interface lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory
{
	/**
	 * Create display panel skin (The area that contains the visible media)
	 * @return	Display panel skin
	 */
	public function createDisplayPanelSkin() : IDisplayPanelSkin;
	
	/**
	 * Create control panel skin (The area that contains the control elements)
	 * @return	Control panel skin
	 */
	public function createControlPanelSkin() : IControlPanelSkin;
	
	/**
	 * Create toggle play/pause button skin
	 * @return	Toggle play/pause button skin
	 */
	public function createTogglePlayButtonSkin() : ISwitchSkin;
	
	/**
	 * Create stop button skin
	 * @return	Stop button skin
	 */
	public function createStopButtonSkin() : IButtonSkin;
	
	/**
	 * Create skin for the "play previous item" button
	 * @return	Play previous item button skin
	 */
	public function createPrevButtonSkin() : IButtonSkin;
	
	/**
	 * Create skin for the "play next item" button
	 * @return	Play next item button skin
	 */
	public function createNextButtonSkin() : IButtonSkin;
	
	/**
	 * Create time textfield skin
	 * @return	Time textfield skin
	 */
	public function createTimeTextFieldSkin() : ITextFieldSkin;
	
	/**
	 * Create fullscreen button skin
	 * @return	Fullscreen button skin
	 */
	public function createFullscreenButtonSkin() : ISwitchSkin;
	
	/**
	 * Create progress bar skin
	 * @return	Progress bar skin
	 */
	public function createProgressBarSkin() : ISliderSkin;
	
	/**
	 * Create volume controller skin
	 * @return Volume controller skin
	 */
	public function createVolumeControllerSkin() : ISliderSkin;
	
	/**
	 * Create mute button skin
	 * @return	Mute button skin
	 */
	public function createMuteButtonSkin() : ISwitchSkin;
	
	/**
	 * Create buffering / loading display skin
	 * @return	Buffering / loading display skin
	 */
	public function createBufferingDisplaySkin() : IBufferingDisplaySkin;
}