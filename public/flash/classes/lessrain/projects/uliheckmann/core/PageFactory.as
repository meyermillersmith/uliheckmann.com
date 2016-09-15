import lessrain.lib.engines.pages.IPageFactory;
import lessrain.lib.engines.pages.Page;
import lessrain.projects.uliheckmann.clientspage.ClientsPage;
import lessrain.projects.uliheckmann.contactpage.ContactPage;
import lessrain.projects.uliheckmann.gallerypage.GalleryPage;
import lessrain.projects.uliheckmann.core.EmptyPage;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.core.PageFactory implements IPageFactory
{
	
	public function createPage( pageClassID:String, pageID:String ):Page
	{
		switch (pageClassID)
		{
			case "Gallery": return new GalleryPage();
			case "Clients": return new ClientsPage();
			case "Contact": return new ContactPage();
			default: return new EmptyPage();		}
	}

}