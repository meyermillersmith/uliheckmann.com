import lessrain.lib.utils.geom.Size;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.skins.core.ISkin {
	
	/**
	 * Get the default size of the skin
	 */
	public function getSize() : Size;
	
	/**
	 * Resize the skin. <code>resize</code> is called when the layout area of a
	 * skin changes. Implementing classes can choose whether the skin adjusts to
	 * the new size or simply do nothing.
	 * 
	 * @param	w_	New skin layout area width
	 * @param	h_	New skin layout area height
	 */
	public function resize(w_ : Number, h_ : Number) : Void;
	
	/**
	 * Build the visible parts of the skin 
	 */
	public function buildSkin() : Void;
	
	/**
	 * Clean up
	 */
	public function finalize() :Void;
	
}