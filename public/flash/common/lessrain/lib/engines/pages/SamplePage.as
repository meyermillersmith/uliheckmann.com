import lessrain.lib.engines.pages.Page;
import lessrain.lib.utils.assets.StyleSheet;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.text.DynamicTextField;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.engines.pages.SamplePage extends Page
{
	private var _tf : DynamicTextField;
	
	public function SamplePage(targetMC : MovieClip)
	{
		trace("SamplePage constructor");
		super(targetMC);
	}
	
	public function initialize():Void
	{
		trace("SamplePage initialize");
		super.initialize();
		
		_tf = new DynamicTextField(_targetMC.createEmptyMovieClip("tf",1));
		_tf.initialize("Page: "+_pageID,StyleSheet.getStyleSheet("main"),"sample",true,true);
		_tf.target.onRelease=Proxy.create(this, testClick);
		_tf._visible=false;
		
		dispatchPageInitialized();
	}
	

	private function testClick() :Void
	{
		_pageManager.loadPage("SamplePage");
	}
	
	public function show():Void
	{
		trace("SamplePage show");
		super.show();
		_tf._visible=true;
		dispatchPageShowing();
	}
	
	public function hide():Void
	{
		trace("SamplePage hide");
		super.hide();
		dispatchPageHidden();
	}
}