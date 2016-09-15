/**
 * MovieClipController
 * @ version 1.0
 * @ author  luis.martinez@lessrain.com
 * @ The MovieClipController class provides runtime control over the movieclip playhead to reach a certain frame number,
 *   wait for a number of frames or wait for a number of milliseconds.
 */

import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.MovieClipController
{
	private var taskQueue:Array;
	private var taskCounter:Number;
	private var timeline:MovieClip;
	private var _enterFrameBeaconDepth:Number;
	
	

	public function MovieClipController ()
	{
		taskQueue = [];
		taskCounter = 0;
		_enterFrameBeaconDepth = -13172;
		var tempController:MovieClip = _level0.createEmptyMovieClip ("___movieclipControllerBeacon", _enterFrameBeaconDepth);
		tempController.onEnterFrame = Proxy.create (this, mainThread);
	}
	
	public function waitForFrame (mc:MovieClip, frame:Number, callback:Function, args:Array, scope:Object):Void
	{
		var task:Object = new Object ({mode:1, target:mc, frame:frame, callback:callback, scope:scope, args:args});
		taskQueue.push (task);
		taskCounter++;
	}
	
	public function wait (delay:Number, callback:Function, args:Array, scope:Object):Void
	{
		var task:Object = new Object ({mode:2, endTime:getTimer ()+delay, callback:callback, scope:scope, args:args});
		taskQueue.push (task);
		taskCounter++;
	}
	
	public function waitFrames (frames:Number, callback:Function, args:Array, scope:Object):Void
	{
		var task:Object = new Object ({mode:3, counter:0, frames:frames, callback:callback, scope:scope, args:args});
		taskQueue.push (task);
		taskCounter++;
	}
	
	private function taskComplete (id:Number):Void
	{
		var o:Object = new Object (taskQueue[id]);
		delete taskQueue[id];
		taskCounter--;
		if (o.args == null) {
			o.callback ();
		} else {
			o.callback.apply (o.scope, o.args);
		}
	}
	
	
	private function mainThread ()
	{
		if (taskCounter>0) {
			for (var i:String in taskQueue) {
				var o:Object = new Object (taskQueue[i]);
				switch (o.mode) {
				case 1 :
					if (o.target._currentframe>=o.frame) taskComplete (Number (i));
					break;
				case 2 :
					if (getTimer ()>=o.endTime) taskComplete (Number (i));
					break;
				case 3 :
					o.counter++;
					if (o.counter>=o.frames) taskComplete (Number (i));
					break;
				}
			}
		} else {
			destroy ();
		}
	}
	
	private function destroy ():Void
	{
		delete _level0.___movieclipControllerBeacon.onEnterFrame;
		_level0.___movieclipControllerBeacon.swapDepths (_level0.getNextHighestDepth ());
		_level0.___movieclipControllerBeacon.removeMovieClip ();
	}
	
	public function abort ():Void {destroy ();}
	public function get enterFrameBeaconDepth ():Number {return _enterFrameBeaconDepth;}
	public function set enterFrameBeaconDepth (value:Number):Void {_enterFrameBeaconDepth = value;}
	
}
