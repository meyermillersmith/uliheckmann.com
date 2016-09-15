import lessrain.lib.engines.snow.SnowflakeStopper;

class lessrain.lib.engines.snow.SnowflakeStopperObject
{
	var y:Number;
	var objectBelow:SnowflakeStopper;
	var objectAbove:SnowflakeStopper;
	
	function SnowflakeStopperObject(defaultYPos:Number)
	{
		y = defaultYPos;
	}
	
	function getY():Number
	{
		return y;
	}
	function setY(ypos:Number):Void
	{
		y=ypos;
	}
	
	function getX():Number
	{
		return 0;
	}
	
	function setObjectBelow(object:SnowflakeStopper):Void
	{
		objectBelow=object;
	}
	function getObjectBelow():SnowflakeStopper
	{
		return objectBelow;
	}
	
	function setObjectAbove(object:SnowflakeStopper):Void
	{
		objectAbove=object;
	}
	function getObjectAbove():SnowflakeStopper
	{
		return objectAbove;
	}

}