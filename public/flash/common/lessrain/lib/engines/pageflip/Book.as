import lessrain.lib.engines.pageflip.Page;
import lessrain.lib.engines.pageflip.BookmarkBar;

class lessrain.lib.engines.pageflip.Book extends MovieClip
{
	[Inspectable(name="01: Page width", type="Number", defaultValue=0)]
	public var pageWidthValue:Number;
	
	[Inspectable(name="02: Page height", type="Number", defaultValue=0)]
	public var pageHeightValue:Number;
	
	[Inspectable(name="03: Page fold color", type="Color", defaultValue="#000000")]
	public var foldColorValue:Number;
	
	[Inspectable(name="04: Auto fold", type="Boolean", defaultValue=false)]
	public var autoFoldValue:Boolean;
	
	[Inspectable(name="05: Animation interval (ms)", type="Number", defaultValue=40)]
	public var animationIntervalValue:Number;
	
	[Inspectable(name="06: Animation step (%)", type="Number", defaultValue=5)]
	public var animationStepValue:Number;
	
	[Inspectable(name="07: Animate jumps", type="Boolean", defaultValue=true)]
	public var animateJumps:Boolean;
	
	[Inspectable(name="08: Corner visibility (%)", type="Number", defaultValue=5)]
	public var cornerVisibilityValue:Number;
	
	[Inspectable(name="09: Flip Help Symbol", type="String", defaultValue="")]
	public var flipHelpSymbolIdentifier:String;
	
	private var pages:Array;
	private var currentPageRef:Page;
	private var targetPageRef:Page;
	private var targetPageForwardValue:Boolean;
	
	public var bookmarkBar:BookmarkBar;
	
	function Book()
	{
		pages=new Array();
		
		onEnterFrame=buildBook;
	}
	
	function addPage(page:Page)
	{
		pages.push(page);
	}
	
	function buildBook()
	{
		delete onEnterFrame;
		
		var firstPage:Page=null;
		var currentPage:Page=null;
		var nextPage:Page=null;
		var count:Number=0;
		
		for (var i : Number = 0; i < pages.length; i++)
		{
			if (Page(pages[i]).isFirstPage)
			{
				firstPage=Page(pages[i]);
				break;
			}
		}
		
		if (firstPage==null)
		{
			trace("First page not found.");
			return;
		}
		
		nextPage=firstPage;
		
		while (nextPage!=null)
		{
			count++;
			currentPage=nextPage;
			
			// bookmarkBar should've named itself "bookmarkBar". if it's null there is no bookmark bar.
			// if it's there and the page wants to be bookmarked, add a bookmark to the bookmark bar
			if (bookmarkBar!=null && currentPage.isBookmarked) bookmarkBar.addBookmark(currentPage);
			
			if (currentPage.nextPageID!="") nextPage=eval(this+"."+currentPage.nextPageID);
			else nextPage=null;
			
			if (nextPage!=null)
			{
				currentPage.nextPage=nextPage;
				nextPage.prevPage=currentPage;
			}
		}
		
		if (count!=pages.length) trace("Not all pages have been added.");
		
		firstPage.setState(Page.CURRENT_PAGE);
		
		// notify the bookmark bar, that all pages are ready
		if (bookmarkBar!=null) bookmarkBar.onPagesBuilt();
	}
	
	function getAngles(percent:Number):Object
	{
		var angles:Object=new Object();
		
		var ratio:Number=percent/100;
		
		angles.page=ratio*Math.PI/2;
		angles.mask=ratio*Math.PI/4;
		return angles;
	}
	
	// returns if the page flip was accepted
	// not accepted would be a false pageID or a running flipping animation
	function flipToPage(pageID:String):Boolean
	{
		if (targetPageRef!=null) return false;
		
		var tempPage:Page=currentPageRef.nextPage;
		while (tempPage!=null)
		{
			if (tempPage.pageID==pageID)
			{
				targetPageForwardValue=true;
				targetPageRef=tempPage;
				if (animateJumps) currentPageRef.nextPage.autoFoldPage();
				else
				{
					targetPageRef.setState( Page.NEXT_PAGE );
					targetPageRef.autoFoldPage();
				}
				return true;
			}
			tempPage=tempPage.nextPage;
		}
		tempPage=currentPageRef.prevPage;
		while (tempPage!=null)
		{
			if (tempPage.pageID==pageID)
			{
				targetPageForwardValue=false;
				targetPageRef=tempPage;
				if (animateJumps) currentPageRef.prevPage.autoFoldPage();
				else
				{
					targetPageRef.autoFoldPage();
					targetPageRef.setState( Page.PREV_PAGE );
				}
				return true;
			}
			tempPage=tempPage.prevPage;
		}
		return false;
	}
	
	
	
	// GETTERS
	
	function hasTargetPage():Boolean
	{
		return (targetPageRef!=null);
	}
	
	function get targetPageForward():Boolean
	{
		return targetPageForwardValue;
	}
	
	function get targetPage():Page
	{
		return targetPageRef;
	}
	
	function get currentPage():Page
	{
		return currentPageRef;
	}
	
	function get foldColor():Number
	{
		return foldColorValue;
	}
	
	function get pageWidth():Number
	{
		return pageWidthValue;
	}
	
	function get pageHeight():Number
	{
		return pageHeightValue;
	}
	
	function get animationInterval():Number
	{
		return animationIntervalValue;
	}
	
	function get animationStep():Number
	{
		return animationStepValue;
	}
	
	function get autoFold():Boolean
	{
		return autoFoldValue;
	}
	
	function get flipHelpSymbol():String
	{
		return flipHelpSymbolIdentifier;
	}
	
	function get cornerVisibility():Number
	{
		return cornerVisibilityValue;
	}
	
	
	
	// SETTERS
	
	function set foldColor(c:Number):Void
	{
		foldColorValue=c;
	}
	
	function set pageWidth(width:Number):Void
	{
		pageWidthValue=width;
	}
	
	function set pageHeight(height:Number):Void
	{
		pageHeightValue=height;
	}
	
	function set animationInterval(milliSeconds:Number):Void
	{
		animationIntervalValue=milliSeconds;
	}
	
	function set animationStep(percent:Number):Void
	{
		animationStepValue=percent;
	}
	
	function set autoFold(doAutoFold:Boolean):Void
	{
		autoFoldValue=doAutoFold;
	}
	
	function set flipHelpSymbol(usuallyEmpty:String)
	{
		flipHelpSymbolIdentifier=usuallyEmpty;
	}
	
	function set targetPage(targetPageObject:Page)
	{
		targetPageRef=targetPageObject;
	}
	
	function set currentPage(currentPageObject:Page)
	{
		if (currentPageObject.nextPage!=currentPageRef && currentPageObject.prevPage!=currentPageRef)
		{
			// if the old page is neither the previous nor the next page of the new one, we're comming from a page jump.
			// in this case the old page and its neighbours has to be set to hidden, which usually happens in the setState function for adjacent pages
			currentPageRef.setState(Page.HIDDEN_PAGE);
			currentPageRef.nextPage.setState(Page.HIDDEN_PAGE);
			currentPageRef.prevPage.setState(Page.HIDDEN_PAGE);
		}
		
		currentPageRef=currentPageObject;
		
		// if there's a bookmark-bar, set the active page to the current one
		// if the current page isn't bookmarked, get a previous page that is bookmarked and show it instead.
		if (bookmarkBar!=null)
		{
			if (currentPage.isBookmarked) bookmarkBar.activateBookmarkOfPage(currentPage);
			else
			{
				var prevPage:Page=currentPage.prevPage;
				while (prevPage!=null && !prevPage.isBookmarked)
				{
					prevPage=prevPage.prevPage;
				}
				bookmarkBar.activateBookmarkOfPage(prevPage);
			}
		}
	}
}
