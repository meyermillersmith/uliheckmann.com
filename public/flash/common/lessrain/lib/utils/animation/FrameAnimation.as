class lessrain.lib.utils.animation.FrameAnimation extends MovieClip
{
	// static parameters
	var beginFrame:Number;
	var endFrame:Number;
	var targetFrame:Number;
	var currentFrame:Number;
	var direction:Number;
	var intervalID:Number;
	
	var animationInterval:Number;
	var step:Number;
	var animationListener:Object;
	var loops:Number;
	var framerate:Number;
	
	function FrameAnimation()
	{
		currentFrame=1;
		beginFrame=1;
		endFrame=_totalframes;
		targetFrame=_totalframes;
		animationInterval=0;
		framerate=0;
		step=1;
		stop();
	}
	
	function startAnimation( beginFrameParam:Number, endFrameParam:Number, framerateParam:Number, stepParam:Number, delayParam:Number, loopsParam:Number, listener:Object)
	{
		beginFrame        = (beginFrameParam == null ? beginFrame : beginFrameParam);
		endFrame          = (endFrameParam == null ? endFrame : endFrameParam);
		framerate         = (framerateParam == null ? framerate : framerateParam);
		animationInterval = (framerate == 0 ? 0 : (1000 / framerate) );
		step              = (stepParam == null ? step : stepParam);
		delayParam        = (delayParam == null ? 0 : delayParam);
		loops             = (loopsParam == null ? loops : loopsParam);
		animationListener = (listener == null ? animationListener : listener);
		
		targetFrame = endFrame;
		gotoAndStop(currentFrame);
		
		direction = ( (targetFrame>currentFrame) ? 1 : -1) ;
		
		stopAnimation();
		if (delayParam>0) intervalID=setInterval(this, "delayed", delayParam);
		else startInterval();
	}
	
	function stopAnimation()
	{
		delete onEnterFrame;
		clearInterval(intervalID);
	}
	
	function delayed()
	{
		clearInterval(intervalID);
		startInterval();
	}
	
	function startInterval()
	{
		if (animationInterval>0) intervalID=setInterval(this, "animate", animationInterval);
		else onEnterFrame=animate;
	}
	
	function animate()
	{
		currentFrame+=step*direction;
		
		if ((direction>0 && currentFrame>=targetFrame) || (direction<0 && currentFrame<=targetFrame))
		{
			if (animationListener!=null) animationListener.onEnd();
			if (loops>0)
			{
				loops--;
				currentFrame=beginFrame;
			}
			else
			{
				currentFrame=targetFrame;
				stopAnimation();
			}
		}
		
		gotoAndStop(currentFrame);
	}
}
