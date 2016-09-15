/**
 * RandomBreak is a class for deesigners to be used as a component in the library.
 * It allows easy definition of timeout in the timeline of Flash, with exact time or random time.
 */

class lessrain.lib.utils.movieclip.RandomBreak extends MovieClip
{
	[Inspectable(name="Minimum timeout", type="Number", defaultValue=0)]
	public var timeMin:Number;
	
	[Inspectable(name="Random timeout span", type="Number", defaultValue=0)]
	public var timeSpan:Number;
	
	[Inspectable(name="Jump to frame(s)", type="Array", defaultValue="")]
	public var continueFrames:Array;

	function RandomBreak()
	{
		setInterval(this, "continuePlaying", (Math.floor(Math.random()*timeSpan)+timeMin));
		_parent.isBreaking=true;
		_parent.stop();
	}
	
	function continuePlaying()
	{
		_parent.isBreaking=false;
		
		if (continueFrames==null || continueFrames.length==0) _parent.play();
		else if (continueFrames.length==1) _parent.gotoAndPlay(continueFrames[0]);
		else
		{
			var i:Number = Math.floor(Math.random()*continueFrames.length);
			_parent.gotoAndPlay(continueFrames[i]);
		}
	}

}
