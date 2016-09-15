/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
interface lessrain.lib.utils.scrollers.scrollbar.tray.ITray 
{
	public function draw():Void;
	public function redraw():Void;
	public function setOrientation(orientation_:String):Void;
	public function getOrientation():String;
	public function setLength(length_:Number):Void;
	public function getLength():Number;
	public function setStrength(strength_:Number):Void;
	public function remove():Void;
	public function getTargetMC():MovieClip;
	public function setTargetMC(targetMC_:MovieClip):Void;
	public function getMouseX():Number;
	public function getMouseY():Number;
	public function destroy():Void;
	
}