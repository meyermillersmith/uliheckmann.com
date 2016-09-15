import lessrain.lib.engines.pageflip.BookmarkButton;

class lessrain.lib.engines.pageflip.Bookmark extends BookmarkButton
{
	static var animationInterval:Number = 40;
	static var smoothness:Number = 0.4;
	static var threshold:Number = 0.4;
	static var alphaSmoothness:Number = 0.5;
	
	private var pageIDValue:String;
	private var pageTitleValue:String;
	
	var startY:Number;
	var startA:Number;
	
	var endY:Number;
	var endA:Number;
	
	var currentY:Number;
	var currentA:Number;
	
	var targetY:Number;
	var targetA:Number;
	
	var intervalID:Number;
	
	function Bookmark()
	{
		startA=0;
		_alpha=startA;
		_visible=false;
		currentA=startA;
	}
	
	function setStartPos(y:Number)
	{
		startY=y;
		_y=y;
		currentY=startY;
	}
	
	function setEndPos(y:Number)
	{
		endY=y;
	}
	
	function show()
	{
		animateTo(endY, 100);
	}
	
	function hide()
	{
		animateTo(startY, 0);
	}
	
	function animateTo(tY:Number, tA:Number)
	{
		targetY=tY;
		targetA=tA;
		startAnimation();
	}
	
	function startAnimation()
	{
		_visible=true;
		clearInterval(intervalID);
		intervalID=setInterval(this, "animate", animationInterval);
	}
	
	function animate()
	{
		var dy:Number,da:Number;
		var isFinished:Boolean=true;
		dy = (targetY - currentY)*smoothness;
		da = (targetA - currentA)*alphaSmoothness;
		
		if ((dy>=0 && dy<threshold) || (dy<0 && dy>-threshold))
		{
			currentY=targetY;
		}
		else
		{
			currentY+=dy;
			isFinished=false;
		}
		
		if ((da>=0 && da<1) || (da<0 && da>-1))
		{
			currentA=targetA;
		}
		else
		{
			currentA+=da;
			isFinished=false;
		}
		
		_y=currentY;
		_alpha=currentA;
		
		if (isFinished)
		{
			if (_alpha==0) _visible=false;
			clearInterval(intervalID);
		}
	}
	
	// GETTERS
	
	function get pageID():String
	{
		return pageIDValue;
	}
	
	function get pageTitle():String
	{
		return pageTitleValue;
	}
	
	// SETTERS
	
	function set pageID(pageIDValue:String)
	{
		this.pageIDValue=pageIDValue;
	}
	
	function set pageTitle(pageTitleValue:String)
	{
		this.pageTitleValue=pageTitleValue;
		setTextFieldLabel(pageTitleValue);
	}
	
	function doRelease()
	{
		bookmarkBar.flipToPage(this);
	}
}