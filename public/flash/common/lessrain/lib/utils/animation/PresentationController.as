/**
 * PresentationController, version 1
 * @class:   lessrain.lib.utils.animation.PresentationController
 * @author:  thomas@lessrain.com
 * @version: 1.0.0
 */

class lessrain.lib.utils.animation.PresentationController extends MovieClip
{
	private var _firstFrame:Number;
	private var _lastFrame:Number;
	private var _frame:Number;
	private var _target:MovieClip;
	
	
	function PresentationController(targetMovieClip:MovieClip, first:Number, last:Number)
	{
		Stage.align="C";
		Stage.scaleMode="noScale";
		
		firstFrame = first;
		lastFrame = last;
		frame = first;
		target = targetMovieClip;
		
		Mouse.addListener(this);
		Key.addListener(this);
		
		target.gotoAndStop(frame);
	}
	
	function moveBy(frames:Number)
	{
		frame+=frames;
		if (frame>lastFrame) frame=lastFrame;
		if (frame<firstFrame) frame=firstFrame;
		target.gotoAndStop(frame);
	}
	
	function onMouseUp()
	{
		moveBy(1);
	}
	
	function onMouseWheel(delta:Number)
	{
		moveBy(-delta);
	}
	
	function onKeyUp()
	{
		if (Key.getCode()==Key.LEFT || Key.getCode()==Key.UP || Key.getCode()==Key.PGUP) moveBy(-1);
		else if (Key.getCode()==Key.RIGHT || Key.getCode()==Key.DOWN || Key.getCode()==Key.PGDN) moveBy(1);
	}
	
	function get target():MovieClip { return _target; }
	function set target(setValue:MovieClip):Void { _target = setValue; }
	
	function get frame():Number { return _frame; }
	function set frame(setValue:Number):Void { _frame = setValue; }
	
	function get firstFrame():Number { return _firstFrame; }
	function set firstFrame(setValue:Number):Void { _firstFrame = setValue; }
	
	function get lastFrame():Number { return _lastFrame; }
	function set lastFrame(setValue:Number):Void { _lastFrame = setValue; }
	
}
