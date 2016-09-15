import lessrain.lib.engines.pages.Page;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
interface lessrain.lib.engines.pages.IPageFactory
{
	public function createPage( pageClassID:String, pageID:String ):Page;
}