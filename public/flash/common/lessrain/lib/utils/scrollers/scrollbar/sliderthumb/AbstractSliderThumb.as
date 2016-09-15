/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 * METHODS:
 * 				- draw() : Void [Abstract Method]
 * 				- redraw() : Void [Abstract Method]
 * 				- remove() : Void [Abstract Method]
 * 						
 * 				- getTargetMC() : MovieClip
 * 				
 * 					Returns the MovieClip container.
 * 				
 * 				- setTargetMC(targetMC_:MovieClip ):Void
 * 				
 * 					Sets the MovieClip container.
 * 				
 * 				- setOrientation( orientation_ : String ) : Void
 * 				
 * 					Sets the Tray orientation [horizontal or vertical].
 * 					See ScrollBarOrientation
 * 					
 *				- getOrientation() : String
 *				
 *					Returns the sliderThumb _orientation [horizontal or vertical].
 *					See ScrollBarOrientation
 * 				
 *				- setStrength( strength_ : Number ) : Void
 *				
 *					Sets the sliderThumb _strength [width or height].
 * 					If the orientation is Horizontal the _strength is the height:
 * 					If the orientation is Vertical the _strength is the width.
 * 				
 * 				- setLength( length_ : Number ) : Void 
 * 					
 * 					Sets the sliderThumb _length [width or height].
 * 					If the orientation is Horizontal the _length is the width.
 * 					If the orientation is Vertical the _length is the height.
 * 								
 * 				- getLength() : Number
 * 					
 * 					Returns the sliderThumb _length [width or height].
 * 					If the orientation is Horizontal the length_ is the width.
 * 					If the orientation is Vertical the length_ is the height.
 * 					
 * 				- setPosition(position_ : Number) : Void 
 * 					
 * 					Sets the _targetMC x or y coordinates, 
 * 					according with the _roientation
 * 					
 * 				- geetPosition() : Number 
 * 				
 * 					Returns the _targetMC x or y coordinates, 
 * 					according with the _roientation
 * 				 				
 * 				- getMouseX() : Number
 * 					
 * 					Returns the x coordinate of the mouse on the _targetMC
 * 				 				
 * 				- getMouseY() : Number
 * 					
 * 					Returns the y coordinate of the mouse on the _targetMC
 * 				
 * 				- destroy(): Void
 * 				
 * IMPLEMENTS:
 * 
 * 				ISliderThumb	
 * 				
 */
 

import lessrain.lib.utils.scrollers.scrollbar.ScrollBarOrientation;
import lessrain.lib.utils.scrollers.scrollbar.sliderthumb.ISliderThumb;

class lessrain.lib.utils.scrollers.scrollbar.sliderthumb.AbstractSliderThumb implements ISliderThumb
{
	private var _targetMC : MovieClip;
	private var _orientation:String;
	private var _length:Number;
	private var _strength:Number;
	private var _range:Number;
	private var _position : Number;
	
	public function AbstractSliderThumb() 
	{
		super();
	}
	
	public function draw() : Void {throw new Error('Abstract Method');}
	public function redraw() : Void {throw new Error('Abstract Method');}
	public function remove() : Void {throw new Error('Abstract Method');}
	
	public function getTargetMC() : MovieClip { return _targetMC; }
	public function setTargetMC( value:MovieClip ):Void { _targetMC = value; }
	
	public function getOrientation() : String {return _orientation;}
	public function setOrientation(orientation_ : String) : Void {_orientation=orientation_;}

	public function getLength() : Number {return _length;}
	public function setLength(length_ : Number) :Void
	{
		if( length_ < 0.99 )
		{
			_length = _range * length_;
			
			if( _length < _strength ) _length = _strength;
			
			_length=Math.round(_length);
			
			redraw();
		}
		else
		{
			_length=0;
			remove();
		}
		

	}

	public function setStrength(strength_ : Number) : Void {_strength=strength_;}
	public function setRange(range_ : Number) : Void {_range=range_;}

	public function setPosition(position_ : Number) : Void 
	{
		switch( _orientation )
		{
			case ScrollBarOrientation.HORIZONTAL:
			
				_targetMC._x = position_; 
				break;
				
			case ScrollBarOrientation.VERTICAL:
			
				_targetMC._y = position_; 
				break;
					
		}
		
		_position=position_;
	}
	
	public function getPosition() : Number { return _position;}

	public function getMouseX() : Number {return _targetMC._xmouse;}
	public function getMouseY() : Number {return _targetMC._ymouse;}
	
	public function destroy():Void
	{
		remove();
		
		_targetMC.swapDepths(1975);
		_targetMC.removeMovieClip();
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}
			
	}


}