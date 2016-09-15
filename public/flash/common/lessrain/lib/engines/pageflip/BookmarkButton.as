import lessrain.lib.engines.pageflip.BookmarkBar;
import lessrain.lib.utils.movieclip.HitArea;

class lessrain.lib.engines.pageflip.BookmarkButton extends MovieClip
{
	private var bookmarkBar:BookmarkBar;
	
	private var textFormat:TextFormat;
	private var bgColor:Number;
	private var releaseHandler:Object;
	private var description:TextField;
	private var bg:MovieClip;
	
	private var pressed:Boolean;

	function BookmarkButton()
	{
		bookmarkBar = BookmarkBar(_parent);
		pressed=false;
		_rotation=90;
	}
	
	function initializeTextField(textFormat:TextFormat, bgColor:Number)
	{
		this.bgColor=bgColor;
		
		this.textFormat=textFormat;
		createTextField("description",2,0,0,500,100);
		description.html = true;
		description.embedFonts = true;
		description.multiline = false;
		description.selectable = false;
		description.setTextFormat(textFormat);
		description.setNewTextFormat(textFormat);
	}
	
	function setReleaseHandler(releaseHandler:Object)
	{
		this.releaseHandler=releaseHandler;
	}
	
	function setTextFieldLabel(label:String)
	{
		description.htmlText = label;
		description.setTextFormat(textFormat);
		description._width = description.textWidth+6;
		description._height = description.textHeight+4;

		var boundsCoords:Object=this.getBounds(this);
		
		this.createEmptyMovieClip("bg",1);
		bg.beginFill (bgColor, 100);
		bg.lineStyle ();
		bg.moveTo (boundsCoords.xMin, boundsCoords.yMin);
		bg.lineTo (boundsCoords.xMax, boundsCoords.yMin);
		bg.lineTo (boundsCoords.xMax, boundsCoords.yMax);
		bg.lineTo (boundsCoords.xMin, boundsCoords.yMax);
		bg.lineTo (boundsCoords.xMin, boundsCoords.yMin);
		bg.endFill();
		
		HitArea.createHitArea( this,3 );
		
		_x=boundsCoords.yMax;
		
		onRollOut();
	}
	
	function getDescription():String
	{
		return description.text;
	}
	
	function getWidth():Number
	{
		return description.textWidth;
	}
	
	function getHeight():Number
	{
		return description.textHeight;
	}
	
	function updateColors()
	{
		onRollOut();
	}
	
	function activate()
	{
		onRollOver();
		pressed=true;
	}
	
	function deactivate()
	{
		pressed=false;
		onRollOut();
	}
	
	
	function onRollOver()
	{
		if (!pressed)
		{
			var myc:Color=new Color(bg);
			myc.setRGB(bookmarkBar.bgHighlightColor);
		
			description.textColor=bookmarkBar.fontHighlightColor;
		}
	}
	
	function onRollOut()
	{
		if (!pressed)
		{
			var myc:Color=new Color(bg);
			myc.setRGB(bgColor);
		
			description.textColor=bookmarkBar.fontColor;
		}
	}
	
	function onReleaseOutside()
	{
		if (!pressed)
		{
			var myc:Color=new Color(bg);
			myc.setRGB(bookmarkBar.bgColor);
		
			description.textColor=bookmarkBar.fontColor;
		}
	}
	
	function onRelease()
	{
		//if (!pressed) doRelease();
		doRelease();
	}
	
	function doRelease()
	{
		if (releaseHandler!=undefined)
		{
			releaseHandler.onRelease();
		}
	}
}
