/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import flash.geom.Rectangle;
interface lessrain.lib.utils.focus.IFocus 
{
	public function setTargetMC(targetMC_:MovieClip):Void;
	public function getTargetMC():MovieClip;
	
	public function setFocusRect(focusRect_:Rectangle):Void;
	public function getFocusRect():Rectangle;
	
	public function updateFocusRect():Void;
	public function updateFocusPoint():Void;
	
	public function setFocus():Void;
	public function killFocus():Void;
	
	public function isFocus():Boolean;
}