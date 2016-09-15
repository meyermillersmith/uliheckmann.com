import lessrain.lib.utils.graphics.ShapeUtils;

class lessrain.lib.utils.movieclip.HitArea
{
	static function createHitArea( targetMC:MovieClip, depth:Number, padding:Number, useHandCursor:Boolean, x:Number, y:Number, w:Number, h:Number):MovieClip
	{
		if (padding==null) padding=0;
		if (depth==null) depth=1;
		if (useHandCursor==null) useHandCursor=true;
		
		var hitArea:MovieClip = targetMC.createEmptyMovieClip ("___hitArea", depth);

		// for compatibility with old ButtonMovieClip hacks
		targetMC.bounds=hitArea;
		
		if (x==null || y==null || w==null || h==null)
		{
			var boundsCoords:Object = targetMC.getBounds( targetMC );
			x=boundsCoords.xMin;
			y=boundsCoords.yMin;
			w=boundsCoords.xMax-boundsCoords.xMin;
			h=boundsCoords.yMax-boundsCoords.yMin;
		}

		ShapeUtils.drawRectangle( hitArea,x-padding,y-padding,w+padding*2,h+padding*2,0x000000,100 );
		hitArea._alpha=0;

		targetMC.hitArea=hitArea;
		targetMC.useHandCursor=useHandCursor;
		
		return hitArea;
	}


}
