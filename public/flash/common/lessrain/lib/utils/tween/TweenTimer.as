/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */

import lessrain.lib.utils.tween.AbstractTween;
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.tween.TweenTimer extends AbstractTween 
{
	
	private var _timerInterval : Number;
	private var _timerTicks : Number;
	
	public function TweenTimer() {super();}
	
	public function setRunMode():Void 
	{
		if(_timerTicks==null) _timerTicks=15;
	
	}
	
	public function startRunMode() : Void {_timerInterval=setInterval (Proxy.create(this,updateTimer) , _timerTicks);}
	public function stopRunMode() : Void 
	{ 
		
		clearInterval(_timerInterval); 
		_timerInterval=null;
	}
	
	private function updateTimer() : Void{ super.update(); }
		 
	public function get timerTicks():Number { return _timerTicks; }
	public function set timerTicks(value:Number):Void { _timerTicks=value; }
	
}