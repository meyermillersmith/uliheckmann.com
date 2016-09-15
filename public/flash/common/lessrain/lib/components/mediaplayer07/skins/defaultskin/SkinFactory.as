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
import lessrain.lib.components.mediaplayer07.skins.defaultskin.SimpleButtonSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.SimpleSwitchSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.TimeTextFieldSkin;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.VolumeControllerSkin;

/**
 * Create set of default media player skins
 * 
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.skins.defaultskin.SkinFactory implements ISkinFactory {
	
	public function SkinFactory() {
	}

	/**
	 * @see	ISkinFactory#createDisplayPanelSkin
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
		return new SimpleSwitchSkin("TogglePlayButtonIllu");
	}

	/**
	 * @see ISkinFactory#createStopButtonSkin
	 */
	public function createStopButtonSkin() : IButtonSkin {
		return new SimpleButtonSkin("StopButtonIllu");
	}

	/**
	 * @see ISkinFactory#createPrevButtonSkin
	 */
	public function createPrevButtonSkin() : IButtonSkin {
		return new SimpleButtonSkin("PrevButtonIllu");
	}

	/**
	 * @see ISkinFactory#createNextButtonSkin
	 */
	public function createNextButtonSkin() : IButtonSkin {
		return new SimpleButtonSkin("NextButtonIllu"); 
	}

	/**
	 * @see ISkinFactory#createFullscreenButtonSkin
	 */
	public function createFullscreenButtonSkin() : ISwitchSkin {
		return new SimpleSwitchSkin("FullscreenButtonIllu"); 
	}
	
	/**
	 * @see ISkinFactory#createTimeTextFieldSkin
	 */
	public function createTimeTextFieldSkin() : ITextFieldSkin {
		return new TimeTextFieldSkin();
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
	 * @see ISkinFactory#createMuteButtonSkin
	 */
	public function createMuteButtonSkin() : ISwitchSkin {
		return new SimpleSwitchSkin("MuteButtonIllu");
	}

	/**
	 * @see ISkinFactory#createBufferingDisplaySkin
	 */
	public function createBufferingDisplaySkin() : IBufferingDisplaySkin {
		return new BufferingDisplaySkin();
	}

}