import lessrain.lib.components.mediaplayer07.skins.core.IBufferingDisplaySkin;
import lessrain.lib.components.mediaplayer07.skins.core.IButtonSkin;
import lessrain.lib.components.mediaplayer07.skins.core.IControlPanelSkin;
import lessrain.lib.components.mediaplayer07.skins.core.IDisplayPanelSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.components.mediaplayer07.skins.core.ISliderSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ISwitchSkin;
import lessrain.lib.components.mediaplayer07.skins.core.ITextFieldSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.BufferingDisplaySkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.ControlPanelSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.DisplayPanelSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.ProgressBarSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.TimeTextFieldSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.VolumeControllerSkin;
import lessrain.lib.components.mediaplayer07.skins.simpletextskin.SimpleTextButtonSkin;
import lessrain.lib.components.mediaplayer07.skins.simpletextskin.SimpleTextSwitchSkin;
import lessrain.lib.utils.assets.StyleSheet;

/**
 * Create a set of text control elements
 *  
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.simpletextskin.TextSkinFactory implements ISkinFactory {
	
	/**
	 * @see ISkinFactory#createDisplayPanelSkin
	 */
	public function createDisplayPanelSkin() : IDisplayPanelSkin {
		return new DisplayPanelSkin();
	}
	
	/**
	 * @see ISkinFactory#createControlPanelSkin
	 */
	public function createControlPanelSkin() : IControlPanelSkin {
		return new ControlPanelSkin();
	}
	
	/**
	 * @see ISkinFactory#createTogglePlayButtonSkin
	 */
	public function createTogglePlayButtonSkin() : ISwitchSkin {
		return new SimpleTextSwitchSkin("PAUSE", "PLAY", StyleSheet.getStyleSheet("main"), "hotspotPlayerButtonStyle");
	}

	/**
	 * @see ISkinFactory#createStopButtonSkin
	 */
	public function createStopButtonSkin() : IButtonSkin {
		return new SimpleTextButtonSkin("STOP", StyleSheet.getStyleSheet("main"), "hotspotPlayerButtonStyle");
	}
	
	/**
	 * @see ISkinFactory#createPrevButtonSkin
	 */
	public function createPrevButtonSkin() : IButtonSkin {
		return new SimpleTextButtonSkin("PREVIOUS", StyleSheet.getStyleSheet("main"), "hotspotPlayerButtonStyle");
	}
	
	/**
	 * @see ISkinFactory#createNextButtonSkin
	 */
	public function createNextButtonSkin() : IButtonSkin {
		return new SimpleTextButtonSkin("NEXT", StyleSheet.getStyleSheet("main"), "hotspotPlayerButtonStyle");
	}
	
	/**
	 * @see ISkinFactory#createTimeTextFieldSkin
	 */
	public function createTimeTextFieldSkin() : ITextFieldSkin {
		return new TimeTextFieldSkin();
	}
	
	/**
	 * @see ISkinFactory#createFullscreenButtonSkin
	 */
	public function createFullscreenButtonSkin() : ISwitchSkin {
		return new SimpleTextSwitchSkin("NORMAL", "FULLSCREEN", StyleSheet.getStyleSheet("main"), "hotspotPlayerButtonStyle");
	}

	/**
	 * @see ISkinFactory#createMuteButtonSkin
	 */
	public function createMuteButtonSkin() : ISwitchSkin {
		return new SimpleTextSwitchSkin("SOUND ON", "SOUND OFF", StyleSheet.getStyleSheet("main"), "hotspotPlayerButtonStyle");
	}
	
	/**
	 * @see ISkinFactory#createProgressBarSkin
	 */
	public function createProgressBarSkin() : ISliderSkin {
		return new ProgressBarSkin();
	}
	
	/**
	 * @see ISkinFactory#createVolumeControllerSkin
	 */
	public function createVolumeControllerSkin() : ISliderSkin {
		return new VolumeControllerSkin();
	}
	
	/**
	 * @see ISkinFactory#createBufferingDisplaySkin
	 */
	public function createBufferingDisplaySkin() : IBufferingDisplaySkin {
		return new BufferingDisplaySkin();
	}

}