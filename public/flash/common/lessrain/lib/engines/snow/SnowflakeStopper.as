interface lessrain.lib.engines.snow.SnowflakeStopper
{
	function getY():Number;
	function getX():Number;
	
	function setObjectBelow(object:SnowflakeStopper):Void;
	function getObjectBelow():SnowflakeStopper;
	
	function setObjectAbove(object:SnowflakeStopper):Void;
	function getObjectAbove():SnowflakeStopper;
}