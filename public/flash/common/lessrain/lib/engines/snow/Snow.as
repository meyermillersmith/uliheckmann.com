import lessrain.lib.engines.snow.Wind;
import lessrain.lib.engines.snow.Snowflake;
import lessrain.lib.engines.snow.SnowflakeStopper;
import lessrain.lib.engines.snow.SnowflakeStopperObject;

class lessrain.lib.engines.snow.Snow extends MovieClip
{
	/*
	extend the class and change these values
	or set them from within your project
	*/
	
	// every x millis a number of flakes is generated
	var snowflakeInterval:Number = 600;
	
	// the number of flakes generated changes every x millis
	var strengthInterval:Number = 1000;
	
	// [strenght]% of the maxFlakes will be the number of flakes generated 
	var maxSnowflakes:Number = 15;
	
	// that's the minimum percentage of the strength mentioned above
	var minStrength:Number = 10;
	
	// the strength changes every strengthInterval millis with a smoothness of...
	var strengthSmoothness:Number = 0.3;
	
	// enable this to have the flakes stay and melt at the bottom of the screen (a bit performance heavy though)
	var enableGround:Boolean = true;
	
	
	/*
	other vars
	*/
	var wind:Wind;
	var _sounds:MovieClip;
	var stopObjects:Array;
	var continueObject:SnowflakeStopperObject;
	var stopObject:SnowflakeStopperObject;
	var deleteObject:SnowflakeStopperObject;
	
	var snowflakeIntervalID:Number;
	var strengthIntervalID:Number;
	
	var strength:Number;
	var targetStrength:Number;
	
	var width:Number;
	var height:Number;
	
	function Snow()
	{
		strength=0;
		width=Stage.width;
		height=Stage.height;
		this.createEmptyMovieClip("_sounds", 5);
		wind = new Wind(this);
		
		continueObject = new SnowflakeStopperObject(999999);
		stopObject = new SnowflakeStopperObject(height);
		deleteObject = new SnowflakeStopperObject(-1);
		
		if (enableGround)
		{
			stopObjects=new Array();
			for (var i:Number=width-1; i>=0; i--) stopObjects[i]=stopObject;
		}
		
		Mouse.addListener(this);
		Stage.addListener(this);
		
		startSnow();
	}
	
	function startSnow()
	{
		wind.startWind();
		changeStrength();
		generateSnowflakes();
		strengthIntervalID = setInterval(this, "changeStrength", strengthInterval);
		snowflakeIntervalID = setInterval(this, "generateSnowflakes", snowflakeInterval);
	}
	
	function onMouseDown()
	{
		wind.createGust();
	}
	
	function onResize()
	{
		width=Stage.width;
		height=Stage.height;
		stopObject.setY(height);
	}
	
	function stopSnow()
	{
		clearInterval(snowflakeIntervalID);
		clearInterval(strengthIntervalID);
	}
	
	function getSnowflakeStartY():Number
	{
		return -5;
	}
	
	function getSnowflakeStartX():Number
	{
		return Math.floor(Math.random()*(width*1.0)-width*0.0);
	}
	
	function getWindVelocity():Number
	{
		return wind.getVelocity();
	}
	
	function changeStrength()
	{
		var d:Number=targetStrength-strength;
		strength += d*strengthSmoothness;
		if (Math.abs(d)<0.5)
		{
			targetStrength = Math.floor(Math.random()*(100-minStrength))+minStrength;
		}
	}
	
	function generateSnowflakes()
	{
		for (var i:Number=Math.floor((strength*maxSnowflakes)/100)-1; i>=0; i--)
		{
			Snowflake.create(this);
		}
	}
	
	function addStopper(stopper:SnowflakeStopper)
	{
		var x:Number=stopper.getX();
		var lastStopper:SnowflakeStopper = SnowflakeStopper(stopObjects[x]);
		lastStopper.setObjectAbove(stopper);
		stopper.setObjectBelow(lastStopper);
		stopObjects[x]=stopper;
	}
	
	function getStopper(x:Number, y:Number):SnowflakeStopper
	{
		x=Math.round(x);
		if (x<0 || x>=width)
		{
			if (y>height) return SnowflakeStopper(deleteObject);
			else return SnowflakeStopper(continueObject);
		}
		else if (enableGround) return SnowflakeStopper(stopObjects[x]);
		else return SnowflakeStopper(stopObject);
	}
	
	function get sounds():MovieClip
	{
		return _sounds;
	}
}