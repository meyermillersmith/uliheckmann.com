/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.AbstractTween;
import lessrain.lib.utils.tween.FramePulse;
import lessrain.lib.utils.tween.FramePulseEvent;

class lessrain.lib.utils.tween.TweenFrame extends AbstractTween 
{
	private var framePulseProxy : 	Function;
	private var frameController	:	FramePulse;
	
	public function TweenFrame() {super();}
	
	public function setRunMode():Void 
	{
		framePulseProxy		=	Proxy.create(this,enterFrame);
		frameController 	= 	FramePulse.getInstance();
	}
	
	public function startRunMode() : Void { addFrameController(); }
	public function stopRunMode() : Void { removeFrameController(); }
	private function enterFrame(e : FramePulseEvent ) : Void{ super.update(); }
	
	private function addFrameController() : Void { frameController.addEnterFrameListener(framePulseProxy); }
	private function removeFrameController() : Void { frameController.removeEnterFrameListener(framePulseProxy); }
}