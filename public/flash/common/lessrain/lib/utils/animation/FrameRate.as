/**
 * @author lessrain
 */
import lessrain.lib.utils.text.DynamicTextField;
import lessrain.lib.utils.Proxy;
import mx.data.formatters.NumberFormatter;

class lessrain.lib.utils.animation.FrameRate
{
	static var interval:Number = 1000;
	
	var target:MovieClip;
	
	var frameCounter:Number;
	var intervalID:Number;
	var fpsValue:Number;
	var fpsThreshold:Number;
	var fpsDisplay:DynamicTextField;
	
	var doPlot:Boolean;
	var doVerbose:Boolean;
	var codeWord:String;
	var plotCounter:Number;
	
	public function FrameRate( target:MovieClip )
	{
		this.target = target;
		target.onEnterFrame = Proxy.create(this, nextFrame);
		
		fpsDisplay = new DynamicTextField( target );
		fpsDisplay.textFormat = new TextFormat("_sans", 10, 0x000000);
		fpsDisplay.useSystemFont = true;
		fpsDisplay.create();
		fpsDisplay.color = 0x000000;
		
		frameCounter=0;
		plotCounter=1;
		fpsValue=0;
		fpsThreshold=12;
		doPlot=false;
		doVerbose=true;
		codeWord="";
		update();
		intervalID = setInterval(this, "update", interval);

		target.lineTo(0, 100);
		Key.addListener(this);
	}
	
	function nextFrame()
	{
		frameCounter++;
	}
	
	function update()
	{
		fpsValue=(frameCounter*1000)/(interval);
		frameCounter=0;
		
		if (doVerbose) verbose();
		if (doPlot) plot();
	}
	
	function getFPS():Number
	{
		return fpsValue;
	}
	
	function plot()
	{
		plotCounter++;
		
		var xVal:Number=plotCounter;
		if (xVal>=Stage.width) xVal = (xVal % Stage.width);
		target.lineStyle (0,0xFFFFFF,100);
		target.beginFill();
		target.lineTo(-xVal, 100-Math.floor(getFPS()));
		target.endFill();
	}
	
	function verbose()
	{
		if (fpsValue<fpsThreshold) fpsDisplay.color=0xEE0000;
		else fpsDisplay.color=0xFFFFFF;
		fpsDisplay.text=(new Number(Math.floor(fpsValue*100)/100)).toString()+" fps";
	}
	
	function onKeyDown()
	{
		codeWord+=String.fromCharCode(Key.getAscii());
		if ("plot".indexOf(codeWord)!=-1)
		{
			if (codeWord == "plot")
			{
				doPlot=!doPlot;
				codeWord="";
				if (doPlot) plot();
			}
		}
		else if ("verbose".indexOf(codeWord)!=-1)
		{
			if (codeWord == "verbose")
			{
				doVerbose=!doVerbose;
				codeWord="";
				if (doVerbose) verbose();
			}
		}
		else codeWord="";
	}
}
