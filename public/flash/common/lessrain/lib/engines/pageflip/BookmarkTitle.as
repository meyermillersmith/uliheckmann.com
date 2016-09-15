import lessrain.lib.engines.pageflip.BookmarkButton;
class lessrain.lib.engines.pageflip.BookmarkTitle extends BookmarkButton
{
	static var animationInterval:Number = 40;
	static var alphaSmoothness:Number = 0.3;
	
	private var barTitleValue:String;
	
	var currentA:Number;
	var targetA:Number;
	
	var intervalID:Number;
	
	function BookmarkTitle()
	{
		currentA=100;
		targetA=100;
		_alpha=100;
	}
	
	function doRelease()
	{
		bookmarkBar.toggleBookmarks();
	}
	
	function show()
	{
		animateTo(100);
	}
	
	function hide()
	{
		animateTo(70);
	}
	
	function animateTo(tA:Number)
	{
		targetA=tA;
		startAnimation();
	}
	
	function startAnimation()
	{
		clearInterval(intervalID);
		intervalID=setInterval(this, "animate", animationInterval);
	}
	
	function animate()
	{
		var da:Number;
		var isFinished:Boolean=true;
		da = (targetA - currentA)*alphaSmoothness;
		
		if ((da>=0 && da<1) || (da<0 && da>-1))
		{
			currentA=targetA;
		}
		else
		{
			currentA+=da;
			isFinished=false;
		}
		
		bg._alpha=currentA;
		
		if (isFinished)
		{
			clearInterval(intervalID);
		}
	}
	
	// GETTERS
	
	function get barTitle():String
	{
		return barTitleValue;
	}
	
	// SETTERS
	
	function set barTitle(barTitleValue:String)
	{
		this.barTitleValue=barTitleValue;
		setTextFieldLabel(barTitleValue);
	}

	function onRollOver()
	{
	}
}