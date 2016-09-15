import lessrain.lib.components.mediaplayer07.controls.events.ButtonEvent;
import lessrain.lib.components.mediaplayer07.controls.Switch;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.events.SwitchEvent extends ButtonEvent {

	public static var STATE_CHANGED : String = "switchChanged";

	public function SwitchEvent(type_ : String, target_ : Switch) {
		super(type_, target_);
	}

}