import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.projects.uliheckmann.header.HeaderButton;
import lessrain.projects.uliheckmann.config.GlobalSettings;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.header.HeaderLine extends HeaderButton
{
	public function HeaderLine(targetMC_:MovieClip)
	{
		super(targetMC_);
	}
	
	public function initialize():Void
	{
		super.initialize();
		ShapeUtils.drawRectangle(_targetMC.createEmptyMovieClip("line",1),0,8,6,0.5,GlobalSettings.getInstance().highlightColor,100);
	}
}