class lessrain.lib.engines.pageflip.FlipHelp extends MovieClip
{
	function FlipHelp()
	{
	}
	
	function init(isLeftPage:Boolean, pageWidth:Number, pageHeight:Number)
	{
		if (isLeftPage)
		{
			_x=0;
			_y=pageHeight;
			_rotation=-135;
		}
		else
		{
			_x=pageWidth;
			_y=pageHeight;
			_rotation=135;
		}
		
	}
}
