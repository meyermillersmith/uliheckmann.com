import lessrain.lib.components.mediaplayer07.display.View;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.display.IViewUIBuilder {
	
	/**
	 * Create user interface.
	 * Classes that implement IViewBuilder have to create all the user interface
	 * elements and control their layout.
	 * 
	 * @param	view_			Create the interface elements of this View instance
	 * @param	skinFactory_	Skin factory instance that knows how to create
	 * 							the skins for the different visible elements
	 */
	public function buildUI(view_:View, skinFactory_:ISkinFactory):Void;
	
}