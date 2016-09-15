import lessrain.lib.engines.pages.Page;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.engines.pages.ProtectedPage extends Page
{
	public function ProtectedPage(targetMC : MovieClip)
	{
		super(targetMC);
		_isProtected=true;
	}
	
	/**
	 * Checks if the XML represents a page generated with a valid user session.
	 * If it's not a valid session, the log in page is generated.
	 * 
	 * Has to be called before dispatching onPageInitialized, best before parsing the XML file, i.e. immediately after loading the XML file
	 * 
	 */
	private function checkSession( contentXML:XML ):Void
	{
		var rootNode:XMLNode = contentXML.firstChild;
		_hasValidSession = (rootNode.attributes.hasValidSession=="true");
	}
	
	public function hideLogin():Void
	{
//		_loginPage.hide();
	}
	
	public function onLoginHidden():Void
	{
		interrupt();
	}
	
	public function showLogin():Void
	{
//		_loginPage = new LoginPage( _targetMC.createEmptyMovieClip("login",1) );
//		_loginPage.sourcePage = this;
//		_loginPage.initialize();
		dispatchPageShowing();
	}
}