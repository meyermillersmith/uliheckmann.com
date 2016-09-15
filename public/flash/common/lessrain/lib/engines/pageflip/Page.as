import lessrain.lib.engines.pageflip.Book;
import lessrain.lib.engines.pageflip.FlipHelp;

class lessrain.lib.engines.pageflip.Page extends MovieClip
{
	public static var CURRENT_PAGE:Number = 1;
	public static var PREV_PAGE:Number = 2;
	public static var NEXT_PAGE:Number = 3;
	public static var HIDDEN_PAGE:Number = 4;
	
	public static var GRADIENT_MAX_WIDTH:Number = 20;
	public static var GRADIENT_MIN_WIDTH:Number = 5;
	
	private static var targetPage:Page;
	private static var flipForward:Boolean;
	
	
	[Inspectable(name="01: Page ID", type="String", defaultValue="")]
	public var pageIDValue:String;

	[Inspectable(name="02: Page title", type="String", defaultValue="")]
	public var pageTitle:String;

	[Inspectable(name="03: Is first page", type="Boolean", defaultValue=false)]
	public var isFirstPageValue:Boolean;

	[Inspectable(name="04: Is bookmarked", type="Boolean", defaultValue=false)]
	public var isBookmarkedValue:Boolean;

	[Inspectable(name="05: Next page", type="String", defaultValue="")]
	public var nextPageIDValue:String;
	
	private var book:Book;

	private var prevPageObject:Page;
	private var nextPageObject:Page;
	
	private var animationIntervalValue:Number;
	private var animationStepValue:Number;
	
	private var foldColorValue:Number;
	private var pageWidthValue:Number;
	private var pageHeightValue:Number;
	private var autoFoldValue:Boolean;
	
	private var leftPage:MovieClip;
	private var rightPage:MovieClip;
	
	private var leftMask:MovieClip;
	private var rightMask:MovieClip;
	
	private var leftGradient:MovieClip;
	private var rightGradient:MovieClip;
	
	private var leftGradientMask:MovieClip;
	private var rightGradientMask:MovieClip;
	
	private var flipHelp:FlipHelp;
	
	private var autoMode:Boolean;
	private var intervalID:Number;
	private var currentState:Number;
	private var currentPosition:Number;
	private var targetPosition:Number;
	
	function Page()
	{
		_name = pageIDValue;
		book = Book(_parent);
		
		_x=0;
		_y=0;
		_visible=false;
		
		foldColorValue=book.foldColor;
		pageWidthValue=book.pageWidth;
		pageHeightValue=book.pageHeight;
		animationIntervalValue=book.animationInterval;
		animationStepValue=book.animationStep;
		autoFoldValue=book.autoFold;
		
		useHandCursor=false;
		autoMode=false;
		currentState=0;
		currentPosition=0;
		targetPosition=0;
		
		init();
		
		MovieClip(this).cacheAsBitmap=true;
		
		book.addPage(this);
	}
	
	function init()
	{
		// SETTINGS FOR GRADIENT
		var colors:Array = [ foldColorValue, foldColorValue, foldColorValue, foldColorValue, foldColorValue, foldColorValue, foldColorValue ];
		var alphas:Array = [55, 35, 18, 8, 0, 3, 0]; 
		var ratios:Array = [0, 5, 17, 51, 89, 132, 255]; 
		var matrix:Object = { matrixType:"box", x:0, y:-pageWidthValue-pageWidthValue-pageHeightValue, w:pageWidthValue, h:pageHeightValue, r:0 }; 
		
		
		
		// LEFT PAGE MOVIES
		
		leftPage.swapDepths(20);
		leftPage.content._x=-pageWidthValue;
		leftPage.content._y=-pageWidthValue-pageHeightValue;
		leftPage._x=pageWidthValue;
		leftPage._y=pageWidthValue+pageHeightValue;
		
		this.createEmptyMovieClip("leftMask",21);
		leftMask.beginFill (0x0000FF, 60);
		leftMask.lineStyle ();
		leftMask.moveTo (-pageWidthValue, -pageWidthValue-pageWidthValue-pageHeightValue);
		leftMask.lineTo (0, -pageWidthValue-pageWidthValue-pageHeightValue);
		leftMask.lineTo (0, -pageWidthValue);
		leftMask.lineTo (-pageWidthValue, -pageWidthValue);
		leftMask.lineTo (-pageWidthValue, -pageWidthValue-pageWidthValue-pageHeightValue);
		leftMask.endFill();
		leftMask._x=pageWidthValue;
		leftMask._y=pageWidthValue+pageHeightValue;
		leftPage.setMask(leftMask);
		
		this.createEmptyMovieClip("leftGradient",22);
		leftGradient.beginGradientFill( "linear", colors, alphas, ratios, matrix );
		leftGradient.lineStyle ();
		leftGradient.moveTo (0, -pageWidthValue-pageWidthValue-pageHeightValue);
		leftGradient.lineTo (pageWidthValue, -pageWidthValue-pageWidthValue-pageHeightValue);
		leftGradient.lineTo (pageWidthValue, -pageWidthValue);
		leftGradient.lineTo (0, -pageWidthValue);
		leftGradient.lineTo (0, -pageWidthValue-pageWidthValue-pageHeightValue);
		leftGradient.endFill();
		leftGradient._x=pageWidthValue;
		leftGradient._y=pageWidthValue+pageHeightValue;
		leftGradient._xscale=-GRADIENT_MAX_WIDTH;
		
		this.createEmptyMovieClip("leftGradientMask",23);
		leftGradientMask.beginFill (0x0000FF, 60);
		leftGradientMask.lineStyle ();
		leftGradientMask.moveTo (-pageWidthValue, -pageWidthValue-pageHeightValue);
		leftGradientMask.lineTo (0, -pageWidthValue-pageHeightValue);
		leftGradientMask.lineTo (0, -pageWidthValue);
		leftGradientMask.lineTo (-pageWidthValue, -pageWidthValue);
		leftGradientMask.lineTo (-pageWidthValue, -pageWidthValue-pageHeightValue);
		leftGradientMask.endFill();
		leftGradientMask._x=pageWidthValue;
		leftGradientMask._y=pageWidthValue+pageHeightValue;
		leftGradient.setMask(leftGradientMask);
		
		
		
		
		// RIGHT PAGE MOVIES
		
		rightPage.swapDepths(10);
		rightPage.content._x=0;
		rightPage.content._y=-pageWidthValue-pageHeightValue;
		rightPage._x=pageWidthValue;
		rightPage._y=pageWidthValue+pageHeightValue;
		
		this.createEmptyMovieClip("rightMask",11);
		rightMask.beginFill (0x0000FF, 60);
		rightMask.lineStyle ();
		rightMask.moveTo (0, -pageWidthValue-pageWidthValue-pageHeightValue);
		rightMask.lineTo (pageWidthValue, -pageWidthValue-pageWidthValue-pageHeightValue);
		rightMask.lineTo (pageWidthValue, -pageWidthValue);
		rightMask.lineTo (0, -pageWidthValue);
		rightMask.lineTo (0, -pageWidthValue-pageWidthValue-pageHeightValue);
		rightMask.endFill();
		rightMask._x=pageWidthValue;
		rightMask._y=pageWidthValue+pageHeightValue;
		rightPage.setMask(rightMask);
		
		this.createEmptyMovieClip("rightGradient",12);
		rightGradient.beginGradientFill( "linear", colors, alphas, ratios, matrix );
		rightGradient.lineStyle ();
		rightGradient.moveTo (0, -pageWidthValue-pageWidthValue-pageHeightValue);
		rightGradient.lineTo (pageWidthValue, -pageWidthValue-pageWidthValue-pageHeightValue);
		rightGradient.lineTo (pageWidthValue, -pageWidthValue);
		rightGradient.lineTo (0, -pageWidthValue);
		rightGradient.lineTo (0, -pageWidthValue-pageWidthValue-pageHeightValue);
		rightGradient.endFill();
		rightGradient._x=pageWidthValue;
		rightGradient._y=pageWidthValue+pageHeightValue;
		rightGradient._xscale=GRADIENT_MAX_WIDTH;
		
		this.createEmptyMovieClip("rightGradientMask",13);
		rightGradientMask.beginFill (0x0000FF, 60);
		rightGradientMask.lineStyle ();
		rightGradientMask.moveTo (0, -pageWidthValue-pageHeightValue);
		rightGradientMask.lineTo (pageWidthValue, -pageWidthValue-pageHeightValue);
		rightGradientMask.lineTo (pageWidthValue, -pageWidthValue);
		rightGradientMask.lineTo (0, -pageWidthValue);
		rightGradientMask.lineTo (0, -pageWidthValue-pageHeightValue);
		rightGradientMask.endFill();
		rightGradientMask._x=pageWidthValue;
		rightGradientMask._y=pageWidthValue+pageHeightValue;
		rightGradient.setMask(rightGradientMask);
	}
	
	function setState(currentState:Number)
	{
		this.currentState=currentState;
		if (currentState==CURRENT_PAGE)
		{
			this.swapDepths(10);
			_visible=true;
			setPosition(0);
			onRelease=null;
			onReleaseOutside=null;
			onPress=null;
			delete onRelease;
			delete onReleaseOutside;
			delete onPress;
			useHandCursor=false;
			
			book.currentPage=this;
			
			if (nextPageObject!=null) nextPageObject.setState(NEXT_PAGE);
			if (prevPageObject!=null) prevPageObject.setState(PREV_PAGE);
			
			if (book.hasTargetPage())
			{
				if (book.targetPage==this) book.targetPage=null;
				else
				{
					if (book.targetPageForward) nextPageObject.autoFoldPage();
					else prevPageObject.autoFoldPage();
				}
			}
		}
		else if (currentState==PREV_PAGE)
		{
			this.swapDepths(11);
			_visible=true;
			setPosition(-100+book.cornerVisibility);
			onRelease=autoFoldPage;
			onReleaseOutside=autoFoldPage;
			onPress=onGrabPage;
			useHandCursor=true;
			
			if (book.flipHelpSymbol!="")
			{
				rightPage.content.attachMovie(book.flipHelpSymbol, "flipHelp", 9999);
				rightPage.content.flipHelp.init(false, pageWidthValue, pageHeightValue);
			}
			
			if (prevPageObject!=null) prevPageObject.setState(HIDDEN_PAGE);
		}
		else if (currentState==NEXT_PAGE)
		{
			this.swapDepths(12);
			_visible=true;
			setPosition(100-book.cornerVisibility);
			onRelease=autoFoldPage;
			onReleaseOutside=autoFoldPage;
			onPress=onGrabPage;
			useHandCursor=true;
			
			if (book.flipHelpSymbol!="")
			{
				leftPage.content.attachMovie(book.flipHelpSymbol, "flipHelp", 9999);
				leftPage.content.flipHelp.init(true, pageWidthValue, pageHeightValue);
				book.flipHelpSymbol="";
			}
			
			if (nextPageObject!=null) nextPageObject.setState(HIDDEN_PAGE);
		}
		else if (currentState==HIDDEN_PAGE)
		{
			_visible=false;
			setPosition(0);
			delete onRelease;
			delete onReleaseOutside;
			delete onPress;
			useHandCursor=false;
		}
	}

	function setPosition(foldingPercentage:Number)
	{
		currentPosition=foldingPercentage;
		drawPosition();
	}
	
	function drawPosition()
	{
		if (currentPosition>0)
		{
			var angles:Object = book.getAngles(currentPosition);
			
			leftPage._rotation = angles.page/(Math.PI/180);
			leftMask._rotation = angles.mask/(Math.PI/180);
			
			leftGradient._rotation = angles.mask/(Math.PI/180);
			leftGradientMask._rotation = angles.page/(Math.PI/180);
			leftGradient._xscale=-GRADIENT_MAX_WIDTH+(GRADIENT_MAX_WIDTH-GRADIENT_MIN_WIDTH)*currentPosition/100;
			
			rightPage._rotation = 0;
			rightMask._rotation = angles.mask/(Math.PI/180);
			
			rightGradient._rotation = angles.mask/(Math.PI/180);
			rightGradientMask._rotation = 0;
			rightGradient._xscale=GRADIENT_MAX_WIDTH-(GRADIENT_MAX_WIDTH-GRADIENT_MIN_WIDTH)*currentPosition/100;
		}
		else if (currentPosition<0)
		{
			var angles:Object = book.getAngles(currentPosition);
			
			rightPage._rotation = angles.page/(Math.PI/180);
			rightMask._rotation = angles.mask/(Math.PI/180);
			
			rightGradient._rotation = angles.mask/(Math.PI/180);
			rightGradientMask._rotation = angles.page/(Math.PI/180);
			rightGradient._xscale=GRADIENT_MAX_WIDTH+(GRADIENT_MAX_WIDTH-GRADIENT_MIN_WIDTH)*currentPosition/100;
			
			leftPage._rotation = 0;
			leftMask._rotation = angles.mask/(Math.PI/180);
			
			leftGradient._rotation = angles.mask/(Math.PI/180);
			leftGradientMask._rotation = 0;
			leftGradient._xscale=-GRADIENT_MAX_WIDTH-(GRADIENT_MAX_WIDTH-GRADIENT_MIN_WIDTH)*currentPosition/100;
		}
		else
		{
			leftPage._rotation = 0;
			rightPage._rotation = 0;
			leftMask._rotation = 0;
			rightMask._rotation = 0;
			leftGradient._xscale=-GRADIENT_MAX_WIDTH;
			leftGradient._rotation = 0;
			leftGradientMask._rotation = 0;
			rightGradient._xscale=GRADIENT_MAX_WIDTH;
			rightGradient._rotation = 0;
			rightGradientMask._rotation = 0;
		}
	}
	
	function autoFoldPage()
	{
		// if we're across the middle-fold of the book or autopageflip is enabled anyway, show the page
		// or else bring it back to its original position
		if (Math.abs(currentPosition) <= 50 || autoFoldValue) targetPosition=0;
		else if (currentPosition>0) targetPosition=100;
		else if (currentPosition<0) targetPosition=-100;
		
		
		autoMode=true;
		onMouseMove=null;
		onRelease=null;
		onReleaseOutside=null;
		onPress=null;
		delete onMouseMove;
		delete onRelease;
		delete onReleaseOutside;
		delete onPress;
		useHandCursor=false;
		intervalID=setInterval(this, "foldPage", animationIntervalValue);
	}
	
	function onGrabPage()
	{
		book.targetPage=null;
		autoMode=false;
		onMouseMove=foldPage;
		this.swapDepths(20);
	}
	
	function foldPage()
	{
		if (leftPage.content.flipHelp!=null) leftPage.content.flipHelp.removeMovieClip();
		if (rightPage.content.flipHelp!=null) rightPage.content.flipHelp.removeMovieClip();
		
		if (autoMode)
		{
			var finished:Boolean=false;
			
			if (targetPosition<currentPosition)
			{
				currentPosition-=animationStepValue;
				if (currentPosition<=targetPosition) finished=true;
			}
			else if (targetPosition>currentPosition)
			{
				currentPosition+=animationStepValue;
				if (currentPosition>=targetPosition) finished=true;
			}
			else if (targetPosition==currentPosition) finished=true;
			
			if (finished)
			{
				currentPosition=targetPosition;
				clearInterval(intervalID);
				intervalID=-1;
				autoMode=false;
				
				if (currentPosition==0) setState(CURRENT_PAGE);
				else if (currentPosition==100) setState(NEXT_PAGE);
				else if (currentPosition==-100) setState(PREV_PAGE);
			}
		}
		else
		{
			if (currentState==NEXT_PAGE) currentPosition = Math.max(Math.min(_xmouse*100/(pageWidthValue*2),100),0);
			else if (currentState==PREV_PAGE) currentPosition = -100+Math.max(Math.min(_xmouse*100/(pageWidthValue*2),100),0);
		}
		drawPosition();
	}
	
	
	// SETTERS
	
	function set nextPage(page:Page):Void
	{
		nextPageObject=page;
	}
	
	function set prevPage(page:Page):Void
	{
		prevPageObject=page;
	}
	
	// GETTERS
	
	function get nextPage():Page
	{
		return nextPageObject;
	}
	
	function get prevPage():Page
	{
		return prevPageObject;
	}
	
	function get pageID():String
	{
		return pageIDValue;
	}
	
	function get nextPageID():String
	{
		return nextPageIDValue;
	}
	
	function get isFirstPage():Boolean
	{
		return isFirstPageValue;
	}
	
	function get isBookmarked():Boolean
	{
		return isBookmarkedValue;
	}
	
}
