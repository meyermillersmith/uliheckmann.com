import flash.geom.Rectangle;

import lessrain.lib.components.mediaplayer07.skins.core.ITextFieldSkin;
import lessrain.lib.layout.AbstractLayoutable;
import lessrain.lib.utils.geom.Size;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.controls.TextField extends AbstractLayoutable {
	
	private var _skin:ITextFieldSkin;
	private var _text:String;
	
	public function TextField(skin_:ITextFieldSkin) {
		_skin = skin_;
		_skin.setTextField(this);
		
//		boundsVisible = true;
	}
	
	/**
	 * As soon as the target clip is set,  build the skin.
	 * @see ILayoutable#setTarget
	 */
	public function setTarget(targetMC_ : MovieClip) : Void {
		super.setTarget(targetMC_);
		
		_skin.buildSkin();
	}
	
	/**
	 * Get skin instance
	 * @return	Skin instance
	 */
	public function getSkin() : ITextFieldSkin {
		return _skin;
	}
	
	/**
	 * Delegate <code>getDefaultSize()</code> to the skin
	 * @see ILayoutable#getDefaultSize
	 */
	public function getDefaultSize() : Size {
		var s : Size = _skin.getSize();
		return s;
	}
	
	/**
	 * Tell skin to adjust to new dimensions
	 * @see ILayoutable#setBoundaries
	 */
	public function setBoundaries(rect_ : Rectangle) : Void {
		super.setBoundaries(rect_);
	
		_skin.resize(rect_.width, rect_.height);
	}
	
	/**
	 * Set the text to display
	 * @param	text_	Display text 
	 */
	public function setText(text_:String):Void {
		_text = text_;
		_skin.setText(text_);
	}

	/**
	 * Get the text
	 * @return	The text
	 */	
	public function getText():String {
		return _text;
	}

	/**
	 * Clean up
	 */
	public function finalize() : Void {
		_skin.finalize();
		
		super.finalize();
	}

}