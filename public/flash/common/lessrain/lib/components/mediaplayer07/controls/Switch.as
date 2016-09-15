import lessrain.lib.components.mediaplayer07.controls.Button;
import lessrain.lib.components.mediaplayer07.controls.events.SwitchEvent;
import lessrain.lib.components.mediaplayer07.skins.core.ISwitchSkin;

/**
 * A switch behaves like a button except that it is used to switch between two
 * states "on" and "off". The skin can be configured to react on mouse release
 * events to switch between both states.
 * @see Button
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.Switch extends Button {
	
	private var _isOn:Boolean; // on/off state
	private var _stateChangedEvent:SwitchEvent;

	/**
	 * Constructor
	 * @param	skin_	Switch skin
	 */
	public function Switch(skin_ : ISwitchSkin) {
		super(skin_);
		
		_stateChangedEvent = new SwitchEvent(SwitchEvent.STATE_CHANGED, this);
	}
	
	public function setTarget(targetMC_:MovieClip):Void {
		super.setTarget(targetMC_);
		setOn(false, false);
	}
	
	/**
	 * Get switch state
	 * @return	Switch state
	 */
	public function getOn():Boolean {
		return _isOn;
	}

	/**
	 * Set switch state
	 */
	public function setOn(on_:Boolean, informListeners_:Boolean) : Void {
		_isOn = on_;
		ISwitchSkin(_skin).setOn(on_);
		if(informListeners_) {
			_eventDistributor.distributeEvent(_stateChangedEvent);
		}
	}

}