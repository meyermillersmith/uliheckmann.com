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
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarOrientation;
import lessrain.lib.utils.scrollers.scrollbar.sliderthumb.AbstractSliderThumb;

class lessrain.lib.utils.scrollers.scrollbar.sliderthumb.sample.MacStyleSliderThumb extends AbstractSliderThumb
{
	

	private var _targetGFX	: MovieClip;
	private var _matrix		: Matrix;
	private var _mp			: Number;
	private var _mp2		: Number;
	
	
	public function MacStyleSliderThumb() {}
	public function draw() : Void 
	{
		_mp = Math.PI;
		_mp2 = _mp/2;
		_matrix=new Matrix();
		_targetGFX=_targetMC.createEmptyMovieClip('gfx',1);
		
		_targetMC.blendMode = 14;
		_targetMC.filters =
		[
			new DropShadowFilter( 0, 0, 0xff, 1, 8, 8, 1, 3, true ),
			new DropShadowFilter( 0, 0, 0, 1, 4, 4, 1, 3, true )
		];
			
		_targetMC.cacheAsBitmap = true;
	}
	
	public function redraw() : Void 
	{
		
			_targetGFX.clear();
			
			switch( _orientation )
			{
				case ScrollBarOrientation.HORIZONTAL:
				
					_matrix.createGradientBox( _length-2, _strength-2, -_mp2, 1, 1 );
					ShapeUtils.drawRectangle( _targetGFX, 0,0,_length,_strength,null,null,(_strength/2),null,null,null,null,
					'linear',[0x8FBBFF, 0x0046B2, 0xffffff ],[ 100, 100, 100 ],[0, 160, 255 ],_matrix );
					
					break;
					
				case ScrollBarOrientation.VERTICAL:  
					
					_matrix.createGradientBox( _strength-2,_length-2, -_mp, 1, 1 );
					ShapeUtils.drawRectangle( _targetGFX, 0,0,_strength, _length,null,null,(_strength/2),null,null,null,null,
					'linear',[0x8FBBFF, 0x0046B2, 0xffffff ],[ 100, 100, 100 ],[0, 160, 255 ],_matrix );
					
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