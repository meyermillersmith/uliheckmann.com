import lessrain.lib.engines.pages.IPageFactory;
import lessrain.lib.engines.pages.Page;
import lessrain.lib.engines.pages.SamplePage;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.engines.pages.SamplePageFactory implements IPageFactory
{
	
	public function createPage( pageClassID:String, pageID:String ):Page
	{
		return new SamplePage();
	}

}