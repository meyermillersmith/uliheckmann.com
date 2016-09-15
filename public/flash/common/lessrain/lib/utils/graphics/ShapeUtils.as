
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 * @revision 24-10-2005 Luis Martinez, Lessrain (luis@lessrain.com)
 */
class lessrain.lib.utils.graphics.ShapeUtils
{
	/**
	 * Draws a rectangle into the target MovieClip.
	 * 
	 * The rectangle can optionally have rounded corners by passing the cornerRadius parameter.
	 * If only some corners of the rectangle should be rounded, cornersRounded can be passed additionally, defining which corners to round with a binarry String (see below). Leave null otherwise.
	 * Omit or pass 0 or null to have sharp corners.
	 * 
	 * The rectangle can optionally have outlines/strokes by passing the respective parameters.
	 * No stroke is drawn by default.
	 * Omit or pass 0 or null for all line parameters to not draw a line.
	 * 
	 * The rectangle can optionally be filled with a gradient by passing the respective parameters (see MovieClip.beginGradientFill() params)
	 * If gradientType is omitted, null or "" no gradient fill is performed.
	 * 
	 * @param	target					The shape is drawn into target MovieClip
	 * @param	x							X-coordinate of the rectangle. The target MovieClip is repositioned to target x-coordinate.
	 * @param	y							Y-coordinate of the rectangle. The target MovieClip is repositioned to target y-coordinate.
	 * @param	w							Width of the rectangle.
	 * @param	h							Height of the rectangle
	 * @param	color						Fill color of the rectangle
	 * @param	alpha						Fill alpha of the rectangle
	 * @param	cornerRadius			Optional radius to round the corners by. Default is sharp corners. (optional)
	 * @param	cornersRounded		Optional binary String defining which corners should be rounded. The order is: top-left, top-right, bottom-right, bottom-left (e.g. "1111" for all corners, "0110" for rounded corners on the right only). Leave null for all corners when cornerRadius is specified. (optional)
	 * @param	lineThickness		Optional thickness of the outline. 0 or null for all line parameters to not draw a line. (optional)
	 * @param	lineColor				Optional color of the outline. 0 or null for all line parameters to not draw a line. (optional)
	 * @param	lineAlpha				Optional alpha of the outline. 0 or null for all line parameters to not draw a line. (optional)
	 * @param	gradientType			Optional type of gradient to fill with. Valid values are null, "", "linear" and "radial". (optional)
	 * @param	gradientColors		Optional array of RGB hexadecimal color values you can use in the gradient. You can specify up to 15 colors. For each color, ensure to specify a corresponding value in the gradientAlphas and gradientRatios parameters. (optional)
	 * @param	gradientAlphas		Optional array of alpha values for the corresponding colors in the colors array; valid values are 0 to 100. If the value is less than 0, Flash uses 0. If the value is greater than 100, Flash uses 100. (optional)
	 * @param	gradientRatios		Optional array of color distribution ratios; valid values are 0 to 255. This value defines the percentage of the width where the color is sampled at 100%. Specify a value for each value in the colors parameter. (optional)
	 * @param	gradientMatrix 		Optional transformation matrix for the gradient (see MovieClip.beginGradientFill()) (optional)
	 * 
	 * @see		MovieClip#beginGradientFill()
	 */
	public static function drawRectangle(target:MovieClip, x:Number, y:Number, w:Number, h:Number, color:Number, alpha:Number, cornerRadius:Number, cornersRounded:String, lineThickness:Number, lineColor:Number, lineAlpha:Number, gradientType:String, gradientColors:Array, gradientAlphas:Array, gradientRatios:Array, gradientMatrix:Object, bDontClear:Boolean ):Void
	{
		if (lineThickness==null) lineThickness=0;
		if (lineColor==null) lineColor=0;
		if (lineAlpha==null) lineAlpha=0;
		
		if (x!=null) target._x=x;
		if (y!=null) target._y=y;
		if (!bDontClear)
		{
			target.clear();
		}
		
		target.lineStyle(lineThickness,lineColor,lineAlpha);
		
		if (gradientType==null || gradientType=="" || (gradientType!="linear" && gradientType!="radial")) target.beginFill( color, alpha );
		else target.beginGradientFill( gradientType, gradientColors, gradientAlphas, gradientRatios, gradientMatrix );
		
		if (cornerRadius==null || cornerRadius==0)
		{
			// sharp corners
			target.moveTo( 0, 0 );
			target.lineTo( w, 0 );
			target.lineTo( w, h );
			target.lineTo( 0, h );
			target.lineTo( 0, 0 );
		}
		else
		{
			if (cornersRounded==null || cornersRounded=="" || cornersRounded=="1111" || cornersRounded.length!=4)
			{
				// all corners rounded
				target.moveTo( cornerRadius, 0 );
				target.lineTo( w-cornerRadius, 0 );
				target.curveTo( w, 0, w, cornerRadius );
				target.lineTo( w, h-cornerRadius );
				target.curveTo( w, h, w-cornerRadius, h );
				target.lineTo( cornerRadius, h );
				target.curveTo( 0, h, 0, h-cornerRadius );
				target.lineTo( 0, cornerRadius );
				target.curveTo( 0, 0, cornerRadius, 0 );
			}
			else
			{
				// only round corners specified in cornersRounded
				
				var cornerFlags:Number = parseInt( cornersRounded ,2);
				
				// top-left
				if ( ((cornerFlags>>3) & 1) == 1)
				{
					target.moveTo( cornerRadius, 0 );
				}
				else
				{
					target.moveTo( 0, 0 );
				}
				
				// top-right
				if ( ((cornerFlags>>2) & 1) == 1)
				{
					target.lineTo( w-cornerRadius, 0 );
					target.curveTo( w, 0, w, cornerRadius );
				}
				else
				{
					target.lineTo( w, 0 );
				}
				
				// bottom-right
				if ( ((cornerFlags>>1) & 1) == 1)
				{
					target.lineTo( w, h-cornerRadius );
					target.curveTo( w, h, w-cornerRadius, h );
				}
				else
				{
					target.lineTo( w, h );
				}
				
				// bottom-left
				if ( ((cornerFlags) & 1) == 1)
				{
					target.lineTo( cornerRadius, h );
					target.curveTo( 0, h, 0, h-cornerRadius );
				}
				else
				{
					target.lineTo( 0, h );
				}
				
				// top-left
				if ( ((cornerFlags>>3) & 1) == 1)
				{
					target.lineTo( 0, cornerRadius );
					target.curveTo( 0, 0, cornerRadius, 0 );
				}
				else
				{
					target.lineTo( 0, 0 );
				}
			}
		}
		
		target.endFill();
	}
	
	public static function drawCircle(target:MovieClip, x:Number, y:Number, r:Number, color:Number, alpha:Number, lineThickness:Number, lineColor:Number, lineAlpha:Number, gradientType:String, gradientColors:Array, gradientAlphas:Array, gradientRatios:Array, gradientMatrix:Object):Void
	{
		if (lineThickness==null) lineThickness=0;
		if (lineColor==null) lineColor=0;
		if (lineAlpha==null) lineAlpha=0;
		
//		if (x!=null) target._x=x;
//		if (y!=null) target._y=y;
		target.clear();
		target.lineStyle(lineThickness,lineColor,lineAlpha);
		
		if (gradientType==null || gradientType=="" || (gradientType!="linear" && gradientType!="radial")) target.beginFill( color, alpha );
		else target.beginGradientFill( gradientType, gradientColors, gradientAlphas, gradientRatios, gradientMatrix );
		
		target.moveTo(x+r, y);
		target.curveTo(r+x, Math.tan(Math.PI/8)*r+y, Math.sin(Math.PI/4)*r+x, Math.sin(Math.PI/4)*r+y);
		target.curveTo(Math.tan(Math.PI/8)*r+x, r+y, x, r+y);
		target.curveTo(-Math.tan(Math.PI/8)*r+x, r+y, -Math.sin(Math.PI/4)*r+x, Math.sin(Math.PI/4)*r+y);
		target.curveTo(-r+x, Math.tan(Math.PI/8)*r+y, -r+x, y);
		target.curveTo(-r+x, -Math.tan(Math.PI/8)*r+y, -Math.sin(Math.PI/4)*r+x, -Math.sin(Math.PI/4)*r+y);
		target.curveTo(-Math.tan(Math.PI/8)*r+x, -r+y, x, -r+y);
		target.curveTo(Math.tan(Math.PI/8)*r+x, -r+y, Math.sin(Math.PI/4)*r+x, -Math.sin(Math.PI/4)*r+y);
		target.curveTo(r+x, -Math.tan(Math.PI/8)*r+y, r+x, y);
		
		target.endFill();
		
		// TODO implement gradient stuff
	}
	

}