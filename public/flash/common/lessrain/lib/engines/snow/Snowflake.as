import lessrain.lib.engines.snow.Snow;
import lessrain.lib.engines.snow.SnowflakeStopper;

class lessrain.lib.engines.snow.Snowflake extends MovieClip implements SnowflakeStopper
{
	/*
	extend the class and change these values
	or set them from within your project
	*/
	
	// enable melting at the end of the animation (should only be set when snow.enableGround is true)
	var enableMelting:Boolean = true;
	
	// animation interval
	var fallInterval:Number = 40;
	
	// interval the density changes at the end (only used when enableMelting is true)
	var meltInterval:Number = 500;
	
	// the minimum density a snowflake can have in percent (visible as _alpha value)
	var minDensity:Number = 20;
	
	// the minimum size a snowflake can have in percent (visible as x/y-scale of snowflake graphic)
	var minSize:Number = 20;
	
	// the density decreases by x percent when the flake melts (only used when enableMelting is true)
	var meltStep:Number = 2;
	
	// factor to influence the strength/width of the horizontal movement (by wind and size)
	var horizontalFactor:Number = 8;
	
	// factor to influence the strength/width of the vertical movement (by gravity and density)
	var verticalFactor:Number = 8;
	
	// minimum alpha value of the flake (density = minDensity)
	var minAlpha:Number = 20;
	
	
	
	/*
	other vars
	*/
	
	static var instanceCount:Number=0;
	
	var fallIntervalID:Number;
	var _snow:Snow;
	var objectBelow:SnowflakeStopper;
	var objectAbove:SnowflakeStopper;
	
	var currentX:Number, currentY:Number, density:Number, size:Number, horizontalSpeed:Number, verticalSpeed:Number;
	
	static function create(snow:Snow)
	{
		instanceCount++;
		var ref:MovieClip = snow.attachMovie("Snowflake", "flake_"+instanceCount, 10+instanceCount);
		ref.snow=snow;
		ref.startFalling();
		
		if (instanceCount>3000) instanceCount=0;
	}
	
	function Snowflake()
	{
	}
	
	function startFalling()
	{
		currentX=snow.getSnowflakeStartX();
		currentY=snow.getSnowflakeStartY();
		
		density=Math.floor(Math.random()*(100-minDensity))+minDensity;
		size=Math.floor(Math.random()*100-minSize)+minSize;
		
		horizontalSpeed=0;
		verticalSpeed=0;
		
		_alpha=density*((100-minAlpha)/100) + minAlpha;
		_xscale=size;
		_yscale=size;
		
		fall();
		
		fallIntervalID=setInterval(this, "fall", fallInterval);
	}
	
	function fall()
	{
		var horizontalAcceleration:Number = (snow.getWindVelocity()/100)*size;
		horizontalSpeed += horizontalAcceleration;
		horizontalSpeed /= density;
		
		var verticalAcceleration:Number = density;
		verticalSpeed += verticalAcceleration;
		verticalSpeed /= size;
		
		currentX+=horizontalSpeed*horizontalFactor;
		currentY+=verticalSpeed*verticalFactor;
		
		var stopper:SnowflakeStopper = snow.getStopper(currentX, currentY);
		if (currentY>=stopper.getY())
		{
			if (enableMelting && stopper.getY()>0)
			{
				currentY=stopper.getY()-1;
				currentX=Math.round(currentX);
				clearInterval(fallIntervalID);
				fallIntervalID=setInterval(this, "melt", meltInterval);
			}
			else remove();
		}
		
		_x=Math.round(currentX);
		_y=Math.round(currentY);
	}
	
	function melt()
	{
		density-=meltStep;
		_alpha=density*((100-minAlpha)/100) + minAlpha;
		if (density<=0) remove();
	}
	
	function remove()
	{
		clearInterval(fallIntervalID);
		this.removeMovieClip();
	}
	
	function set snow(snowObject:Snow):Void
	{
		_snow=snowObject;
	}
	
	function get snow():Snow
	{
		return _snow;
	}
	
	function getX():Number
	{
		return currentX;
	}
	
	function getY():Number
	{
		return currentY;
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