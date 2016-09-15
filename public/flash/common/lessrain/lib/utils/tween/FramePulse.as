/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */

import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.FramePulseEvent;

class lessrain.lib.utils.tween.FramePulse implements IDistributor 
{
	private var _eventDistributor 		: EventDistributor;
	
	public static var MC_NAME			: String = "__FramePulseMC";
	public static var MC_DEPTH			: Number = -9998;
	public static var MC_ROOT			: MovieClip = _level0;
	
	private var _targetMC				: MovieClip;
	
	private var _enterFrameEvent     	: FramePulseEvent;
	private var _enterFrameEventType	: String;
	
	private static var sInstance    	: FramePulse = null;
	
	private function FramePulse () 
	{
		_eventDistributor		= new EventDistributor();
		_targetMC= MC_ROOT.createEmptyMovieClip (MC_NAME, MC_DEPTH);
		_enterFrameEventType	=	FramePulseEvent.ENTERFRAME;	
		_enterFrameEvent 		= 	new FramePulseEvent( FramePulseEvent.ENTERFRAME );
			
	}
	
	public static function getInstance () : FramePulse 
	{
		if (sInstance == null) sInstance = new FramePulse();
		return sInstance;
	}
	
	private function createEnterFrame():Void {_targetMC.onEnterFrame = Proxy.create(this,pulse) ;}
	private function deleteEnterFrame():Void {delete _targetMC.onEnterFrame;}
	
	public function addEnterFrameListener (listener:Function) : Void 
	{
		if(isEmpty()) createEnterFrame();
		addEventListener(_enterFrameEventType, listener);
	}
	
	public function removeEnterFrameListener (listener_ : Function) : Void 
	{
		if(exists(listener_)) removeEventListener(_enterFrameEventType, listener_);
		if(isEmpty()) deleteEnterFrame();
	}
	
	private function isEmpty():Boolean 
	{ 
		return _eventDistributor.getEventListeners(_enterFrameEventType).length==0; 
	}
	
	private function exists(listener_ : Function ):Boolean 
	{ 
		return _eventDistributor.isInEventList(_enterFrameEventType,listener_);
	}
	
	private function pulse () : Void { distributeEvent( _enterFrameEvent); }
	
	public function addEventListener(type : String, func : Function) : Void{_eventDistributor.addEventListener(type, func );}
	public function removeEventListener(type : String, func : Function) : Void{_eventDistributor.removeEventListener(type, func );}
	public function distributeEvent(eventObject : IEvent) : Void{_eventDistributor.distributeEvent(eventObject );}

}
