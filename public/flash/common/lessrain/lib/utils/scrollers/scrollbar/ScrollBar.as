/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 * 
 *
 * INHERIT PROPERTIES:
 * 
 * 				- scrollBarValue : Number [R/W]
 * 			
 * 				  		The scrollbar value from 0 to 1.0
 * 				  		
 * 				- sliderThumbPosition : Number [R/W]
 * 			
 * 				  		The sliderThumb position
 * 					
 * INHERIT METHODS:
 * 			
 * 				- initialize : Void
 * 			
 * 				- createTray : Void [Abstract]
 * 				
 * 				  		Creates the tray part of the scrollbar 
 * 				   
 * 				- createSliderThumb : Void [Abstract]
 * 				
 * 				  		Creates the slider part of the scrollbar 
 * 				   
 * 				- redraw(sliderThumbLength_ : Number, range_ : Number, scrollBarValue_ : Number) : Void
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- pageUp():Void
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- pageDown():Void
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- pageLeft():Void
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- pageRight():Void
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- setSliderThumbLength(sliderThumbLength_:Number) : Void
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- getSliderThumbLength() : Number 
 * 				
 * 				- getOrientation() : String
 * 				
 * 				- getTargetMC() : MovieClip
 * 				
 * 				- setSlideOnTrayMode(slideOnTrayMode_ : String) : Void [see ScrollBarTrayMode]
 * 				
 * 						See AbstractScrolBar
 * 						
 * 				- addContextMenu(addContextMenu : Boolean) : Void
 * 				
 * 						See AbstractScrolBar
 * 				
 * 				- getSlideOnTrayMode() : String
 * 				
 * 				- resetSlideOnTray(slideOnTrayMode_:String) : Void 
 * 				
 * 						Reset the mode to move the sliderThumb over
 * 						the tray at runtime. [see ScrollBarTrayMode]
 * 				
 * 				- addEventListener(type : String, func : Function) : Void
 * 				
 * 				- removeEventListener(type : String, func : Function) : Void
 * 				
 * 				- distributeEvent(eventObject : IEvent) : Void
 * 				
 * 				- destroy():Void
 * 				
 * 				
 * INHERIT EVENTS:
 * 		
 * 				- ScrollBarEvent.START_DRAG
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- ScrollBarEvent.STOP_DRAG
 * 				
 * 				  		See AbstractScrolBar
 * 				  
 * 				- ScrollBarEvent.CHANGE
 * 				
 * 				  		See AbstractScrolBar
 * 				
 * 					
 * INHERIT:
 * 
 * 				AbstractScrollBar > ScrollBar
 * 				
 * 			
 * IMPLEMENTS:
 * 
 * 				IDistributor	
 * 
 * 
 * SEE ALSO:
 * 
 * 				- AbstractScrollBar
 * 				- IScrollBarFactory
 * 				- EventDistributor
 * 				- IDistributor
 * 				- IEvent
 * 				- ScrollBarEvent
 * 				- ScrollBarOrientation
 * 				- ISliderThumb
 * 				- ITray
 * 				- ScrollBarTrayMode
 * 					
 * 
 */

import lessrain.lib.utils.scrollers.scrollbar.AbstractScrollBar;
import lessrain.lib.utils.scrollers.scrollbar.IScrollBarFactory;
import lessrain.lib.utils.scrollers.scrollbar.ScrollBarConfig;

class lessrain.lib.utils.scrollers.scrollbar.ScrollBar extends AbstractScrollBar
{
	
	private var _scrollBarFactory : IScrollBarFactory;

	/**
	 * Constructor
	 * 
	 * @param targetMC_  			MovieClip container.
	 * @param strength_				Scrollbar  strength [width or height].
	 * 								If orientation is Horizontal the strength is the height.
	 * 								If orientation is Vertical the strength is the width.
	 * 								
	 * @param length_				Scrollbar length [width or height].
	 * 								If orientation is Horizontal the length_ is the width.
	 * 								If orientation is Vertical the length_ is the height.
	 * 								
	 * 								
	 * @param orientation_      	Scrollbar orientation [horizontal or vertical].
	 * @param scrollBarFactory_ 	scrollbar factory
	 */
	public function ScrollBar(targetMC_:MovieClip,length_:Number,strength_:Number,orientation_:String,scrollBarFactory_:IScrollBarFactory) 
	{
		super(targetMC_,length_,strength_,orientation_);
		
		_scrollBarFactory=scrollBarFactory_;
	}
	
	public function initialize():Void 
	{
		super.initialize();
		
		if( _slideOnTrayMode == null) _slideOnTrayMode=ScrollBarConfig.TRAY_MODE;
		if( _addContextMenu == null ) _addContextMenu=ScrollBarConfig.ADD_CONTEXT_MENU;
		if( _addContextMenu ) setCustomContextMenu();
		initializeSlideOnTray();
	}
	
	private function initializeSlideOnTray():Void { super.initializeSlideOnTray();}
	private function setCustomContextMenu():Void { super.setCustomContextMenu();}
	private function abortSlideOnTray():Void { super.abortSlideOnTray(); }
	
	/**
	 * SPECIAL RUNTIME USE
	 * 
	 * Reset the mode to move the sliderThumb over 
 	 * the tray at runtime. [see ScrollBarTrayMode]
	 */
	public function resetSlideOnTray(slideOnTrayMode_:String):Void
	{
		abortSlideOnTray();
		
		if(slideOnTrayMode_==null) _slideOnTrayMode=ScrollBarConfig.TRAY_MODE;
		else _slideOnTrayMode=slideOnTrayMode_;
		
		initializeSlideOnTray();
	}
	
	// scrollbar parts
	public function createTray():Void {_tray=_scrollBarFactory.createTray();}
	public function createSliderThumb():Void {_sliderThumb=_scrollBarFactory.createSliderThumb();}
	
	public function destroy():Void
	{
		delete _sliderThumbMC.onMouseMove;
		
		_eventDistributor.finalize();
		
		_sliderThumbMC.enabled=false;
		_trayMC.enabled=false;
		stopSlideOnTray();
		
		_sliderThumb.destroy();
		_tray.destroy();
		
		if(_slideOnTrayTween!=null) 
		{
			_slideOnTrayTween.reset();
			_slideOnTrayTween.destroy();
		}
		
		for (var i:String in this)
		{
			if (typeof this[i]=="boolean") this[i]=false;
			else if (typeof this[i]=="number") this[i]=0;
			delete this[i];
		}	
	}

	
}