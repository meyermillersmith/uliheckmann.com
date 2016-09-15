import lessrain.lib.components.mediaplayer07.skins.core.IBufferingDisplaySkin;
import lessrain.lib.layout.AbstractLayoutable;
import lessrain.lib.utils.geom.Size;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.BufferingDisplay extends AbstractLayoutable {
	
	private var _skin:IBufferingDisplaySkin;
	private var _bufferPercentage:Number;
	
	public function BufferingDisplay(skin_:IBufferingDisplaySkin) {
		_skin = skin_;
		_skin.setBufferingDisplay(this);
		
//		boundsVisible = true;
	}
	
	public function setTarget(targetMC_:MovieClip):Void {
		super.setTarget(targetMC_);
		
		_skin.buildSkin();
	}
	
	public function getDefaultSize():Size {
		return _skin.getSize();
	}
	
	public function show():Void {
		_skin.show();
	}
	
	public function hide():Void {
		_skin.hide();
	}
	
	public function getBufferPercentage():Number {
		return _bufferPercentage;
	}
	
	public function setBufferPercentage(percentage_:Number):Void {
		_bufferPercentage = percentage_;
		_skin.setBufferPercentage(_bufferPercentage);
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		_skin.finalize();
		
		super.finalize();
	}

}