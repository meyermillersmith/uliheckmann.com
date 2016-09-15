/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * PatternTile class creates the tile (8 x 8) for the Pattern
 */

import flash.display.BitmapData;
import flash.geom.Rectangle;

class lessrain.projects.uliheckmann.effects.PatternTile 
{
	public static var STROKE_LENGTH:Number = 4;
	public static var TRAIL_LENGTH:Number = STROKE_LENGTH*2;
	
	private static var patternTile:BitmapData;
	
	public static function getPatternTile():BitmapData
	{
		if (patternTile==null) patternTile = create();
		return patternTile;
	}
	
	public static function create():BitmapData
	{
		var rect:Rectangle = new Rectangle(0, 0, TRAIL_LENGTH, TRAIL_LENGTH);
		var bitmapMap:BitmapData = new BitmapData(rect.width, rect.height, false, 0xFFFFFFFF);

		var patternArray:Array=new Array(
										[0,1,1,1,1,0,0,0],
										[1,1,1,1,0,0,0,0],
										[1,1,1,0,0,0,0,1],
										[1,1,0,0,0,0,1,1],
										[1,0,0,0,0,1,1,1],
										[0,0,0,0,1,1,1,1],
										[0,0,0,1,1,1,1,0],
										[0,0,1,1,1,1,0,0]
									);

		for (var x:Number=0;x < (TRAIL_LENGTH+1);x++)  for (var y:Number=0;y < (TRAIL_LENGTH+1);y++) bitmapMap.setPixel(x,y,(patternArray[x][y]==0 ? 0xFFFFFF : 0x000000));
		
		return bitmapMap;
	}
}