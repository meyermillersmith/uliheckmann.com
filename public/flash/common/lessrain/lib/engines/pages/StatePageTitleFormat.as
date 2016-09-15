/**
 * @author Luis Martinez, Less Rain (luis@lessrain.com)
 */
import lessrain.lib.utils.StringUtils;
class lessrain.lib.engines.pages.StatePageTitleFormat 
{
	public static var DEFAULT_PREFIX	: String	=	_level0['pageTitle'];
	public static var DEFAULT_SEPARATOR	: String	=	' | ';
	public static var DEFAULT_FORMAT	: String	=	'default';
	
	public static function format(title_:String, format_:String) :String
	{
		var tempTitle	:	String	=	'';
		
		switch (format_)
		{
			case StatePageTitleFormat.DEFAULT_FORMAT:
			
				tempTitle	=	StringUtils.replace(title_, '/', StatePageTitleFormat.DEFAULT_SEPARATOR);
				tempTitle	=	StringUtils.replace(tempTitle, '_', ' ');
				tempTitle	=	StringUtils.ucWords (tempTitle);
				
				if (tempTitle.substr(tempTitle.length-3,3)==StatePageTitleFormat.DEFAULT_SEPARATOR)
				{
					tempTitle	= tempTitle.substr(0,tempTitle.length-3);
				}
				
				tempTitle = StatePageTitleFormat.DEFAULT_PREFIX + tempTitle;
			
			break;
		}
		
		return tempTitle;
	}
}