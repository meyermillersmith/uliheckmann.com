import lessrain.lib.engines.pages.Page;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.core.EmptyPage extends Page
{
	
	public function EmptyPage(targetMC : MovieClip)
	{
		super(targetMC);
	}

	public function initialize():Void
	{
		super.initialize();
		dispatchPageInitialized();
	}
	
	public function show():Void
	{
		super.show();
		dispatchPageShowing();
	}
	
	public function hide():Void
	{
		super.hide();
		dispatchPageHidden();
	}
}