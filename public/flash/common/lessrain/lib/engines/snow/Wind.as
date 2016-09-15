import lessrain.lib.engines.snow.Snow;

class lessrain.lib.engines.snow.Wind
{
	/*
	extend the class and change these values
	or set them from within your project
	*/
	
	// every velocityInterval millis the velocity of the wind changes
	var velocityInterval:Number = 500;
	
	// the minimum wind velocity in percent
	var minVelocity:Number = 30;
	
	// the peak/gust velocity when the user clicks
	var gustVelocity:Number = 150;
	
	// the velocity changes every velocityInterval millis with a smoothness of...
	var velocitySmoothness:Number = 0.3;
	
	
	/*
	other vars
	*/
	var _snow:Snow;
	
	var velocity:Number;
	var targetVelocity:Number;
	var velocityIntervalID:Number;
	
	var loSound:Sound;
	var hiSound:Sound;
	
	function Wind(snow:Snow)
	{
		_snow=snow;
		velocity=0;
		calculateTargetVelocity();
		
		snow.sounds.createEmptyMovieClip("wind1", 1);
		loSound = new Sound(snow.sounds.wind1);
		loSound.attachSound("wind_1");
		
		snow.sounds.createEmptyMovieClip("wind2", 2);
		hiSound = new Sound(snow.sounds.wind2);
		hiSound.attachSound("wind_2");
	}
	
	function startWind()
	{
		loSound.start(0,9999);
		loSound.setVolume(0);
		hiSound.start(0,9999);
		hiSound.setVolume(0);
		changeVelocity();
		velocityIntervalID = setInterval(this, "changeVelocity", velocityInterval);
	}
	
	function stopWind()
	{
		clearInterval(velocityIntervalID);
	}
	
	function createGust()
	{
		if (velocity>=0) targetVelocity=gustVelocity;
		else targetVelocity=-gustVelocity;
		
	}
	
	function calculateTargetVelocity()
	{
		targetVelocity = Math.floor(Math.random()*(100-minVelocity))+minVelocity;
		if (Math.random()>=0.5) targetVelocity=-targetVelocity;
	}
	
	function changeVelocity()
	{
		var d:Number=targetVelocity-velocity;
		velocity += d*velocitySmoothness;
		if (Math.abs(d)<1)
		{
			calculateTargetVelocity();
		}
		_root.wind.text=Math.round(velocity);
		loSound.setVolume( getLoSoundVolume() );
		loSound.setPan( getLoSoundPan() );
		hiSound.setVolume( getHiSoundVolume() );
		hiSound.setPan( getHiSoundPan() );
	}
	
	function getLoSoundVolume():Number
	{
		var v:Number = Math.min( Math.floor(Math.abs(velocity)*0.7)+30 , 100);
		return v;
	}
	
	function getHiSoundVolume():Number
	{
		var v:Number = Math.min( Math.max(Math.floor((Math.abs(velocity)-50)),0), 70);
		return v;
	}
	
	function getLoSoundPan():Number
	{
		var v:Number = -Math.min( Math.round(velocity*0.5), 50);
		return v;
	}
	
	function getHiSoundPan():Number
	{
		var v:Number = -Math.min( Math.round(velocity*0.3), 30);
		return v;
	}
	
	function getVelocity():Number
	{
		return velocity;
	}
	
	function set snow(snowObject:Snow):Void
	{
		_snow=snowObject;
	}
	
	function get snow():Snow
	{
		return _snow;
	}
	
}