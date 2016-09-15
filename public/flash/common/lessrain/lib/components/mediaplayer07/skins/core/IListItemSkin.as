/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */

interface lessrain.lib.components.mediaplayer07.skins.core.IListItemSkin 
{
	public function updateSkin():Void;
	public function onClick():Void;
	public function onRoll( highlight:Boolean ):Void;
	public function getWidth():Number;
	public function getHeight():Number;
}