/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 * See AbstractSliderThumb
 * 
 * _orientation ,horizontal or vertical [Inherits from AbstractSliderThumb].
 * See ScrollBarOrientation
 * 
 * _strength [Inherits from AbstractSliderThumb].
 * If the orientation is Horizontal the _strength is the height:
 * If the orientation is Vertical the _strength is the width.
 * 
 * _length [Inherits from AbstractSliderThumb].
 * If the orientation is Horizontal the _length is the width.
 * If the orientation is Vertical the _length is the height.
 * 
 */
import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarOrientation;
import lessrain.lib.utils.scrollers.scrollbar.sliderthumb.AbstractSliderThumb;

class lessrain.lib.utils.scrollers.scrollbar.sliderthumb.sample.SimpleSliderThumb extends AbstractSliderThumb
{
	

	private var _targetGFX	 : MovieClip;
	
	private static var COLOR : Number = 0xF2F2F2;
	
	
	public function SimpleSliderThumb() {}
	public function draw() : Void 
	{
	
		_targetGFX=_targetMC.createEmptyMovieClip('gfx',1);
			
		_targetMC.cacheAsBitmap = true;
		
		redraw();
	}
	
	public function redraw() : Void 
	{
		
			_targetGFX.clear();
			
			switch( _orientation )
			{
				case ScrollBarOrientation.HORIZONTAL:
				

					ShapeUtils.drawRectangle( _targetGFX, 0,0,_length,_strength,SimpleSliderThumb.COLOR,100);
					
					break;
					
				case ScrollBarOrientation.VERTICAL:  
					

					ShapeUtils.drawRectangle( _targetGFX, 0,0,_strength, _length,SimpleSliderThumb.COLOR,100);
					
					break;
			}
		
	}
	
	public function remove():Void
	{
		_targetGFX.clear();
	}
	
	public function destroy():Void
	{
		super.destroy();
		
		remove();
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}			
	}
	
}