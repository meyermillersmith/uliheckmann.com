import lessrain.projects.uliheckmann.config.GlobalSettings;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.utils.GlobalFunctions
{
	public static function getCenterStageX():Number
	{
		return Math.round((Stage.width-GlobalSettings.getInstance().stageWidth)/2);
	}
	public static function getCenterStageY():Number
	{
		var y:Number = Math.round((Stage.height-GlobalSettings.getInstance().stageHeight)/2);
		
		/*
		 * substracting a maximum of 20 pixels to keep the page in its vertical place for the first x pixels of enlarging the window,
		 * so that on bigger screens the page is visually higher
		 * aka the mikkel factor
		 */
		return y-Math.min(y, 20);
	}
}