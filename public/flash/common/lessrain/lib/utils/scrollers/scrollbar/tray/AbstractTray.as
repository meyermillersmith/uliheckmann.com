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
 *					Returns the Tray orientation [horizontal or vertical].
 *					See ScrollBarOrientation
 * 				
 *				- setStrength( strength_ : Number ) : Void
 *				
 *					Sets the tray _strength [width or height].
 * 					If the orientation is Horizontal the _strength is the height:
 * 					If the orientation is Vertical the _strength is the width.
 * 				
 * 				- setLength( length_ : Number ) : Void 
 * 					
 * 					Sets the tray _length [width or height].
 * 					If the orientation is Horizontal the _length is the width.
 * 					If the orientation is Vertical the _length is the height.
 * 								
 * 				- getLength() : Number
 * 					
 * 					Returns the tray _length [width or height].
 * 					If the orientation is Horizontal the length_ is the width.
 * 					If the orientation is Vertical the length_ is the height.
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
 * 				ITray	
 * 				
 */
import lessrain.lib.utils.scrollers.scrollbar.tray.ITray;

class lessrain.lib.utils.scrollers.scrollbar.tray.AbstractTray implements ITray
{

	private var _targetMC : MovieClip;
	private var _orientation : String;
	
	/**
	 * _strength [width or height].
 	 * If the orientation is Horizontal the _strength is the height:
 	 * If the orientation is Vertical the _strength is the width.
	 */
	private var _strength:Number;
	
	/**
	 * _length [width or height].
 	 * If the orientation is Horizontal the _length is the width.
 	 * If the orientation is Vertical the _length is the height.
	 */
	private var _length : Number;
	
	public function AbstractTray() {}
	
	public function draw() : Void {throw new Error('Abstract Method');}
	public function redraw() : Void {throw new Error('Abstract Method');}
	public function remove() : Void {throw new Error('Abstract Method');}

	public function getTargetMC() : MovieClip { return _targetMC; }
	public function setTargetMC(targetMC_:MovieClip ):Void { _targetMC = targetMC_; }

	public function getOrientation() : String {return _orientation;}
	public function setOrientation(orientation_ : String) : Void {_orientation=orientation_;}

	public function setStrength(strength_ : Number) : Void {_strength=strength_;}
	public function setLength(length_ : Number) : Void 
	{
		_length=length_;
		if( _length >0 )redraw();
		else remove();

	}
	public function getLength() : Number {return _length;}
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