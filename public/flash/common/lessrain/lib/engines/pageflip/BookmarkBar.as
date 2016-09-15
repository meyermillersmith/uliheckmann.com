import lessrain.lib.engines.pageflip.Book;
import lessrain.lib.engines.pageflip.BookmarkTitle;
import lessrain.lib.engines.pageflip.Bookmark;
import lessrain.lib.engines.pageflip.Page;

class lessrain.lib.engines.pageflip.BookmarkBar extends MovieClip
{
	[Inspectable(name="01: Main title", type="String", defaultValue="")]
	public var titleValue:String;
	
	[Inspectable(name="02: Show bookmarks initially", type="Boolean", defaultValue=true)]
	public var showBookmarks:Boolean;
	
	[Inspectable(name="03: Title y-position", type="Number", defaultValue=0)]
	public var titleY:Number;
	
	[Inspectable(name="04: Bookmark y-position", type="Number", defaultValue=0)]
	public var bookmarkY:Number;
	
	[Inspectable(name="05: Font", type="Font Name", defaultValue="")]
	public var fontValue:String;
	
	[Inspectable(name="06: Font-size", type="Number", defaultValue=10)]
	public var fontSizeValue:Number;
	
	[Inspectable(name="07: Font color", type="Color", defaultValue="#000000")]
	public var fontColorValue:Number;
	
	[Inspectable(name="08: Font highlight color", type="Color", defaultValue="#000000")]
	public var fontHighlightColorValue:Number;
	
	[Inspectable(name="09: Background color", type="Color", defaultValue="#000000")]
	public var bgColorValue:Number;
	
	[Inspectable(name="10: Background highlight color", type="Color", defaultValue="#000000")]
	public var bgHighlightColorValue:Number;
	
	[Inspectable(name="11: Title font color", type="Color", defaultValue="#000000")]
	public var titleFontColorValue:Number;
	
	[Inspectable(name="12: Title background color", type="Color", defaultValue="#000000")]
	public var titleBgColorValue:Number;
	
	private var book:Book;
	private var bookmarks:Array;
	private var bookmarkCount:Number;
	private var bookmarkYPos:Number;
	private var bookmarkTitle:BookmarkTitle;
	
	private var activeBookmark:Bookmark;
	
	private var titleFormatObject:TextFormat;
	private var textFormatObject:TextFormat;
	private var bookmarksShowing:Boolean;
	
	function BookmarkBar()
	{
		_name="bookmarkBar";
		book = Book(_parent);
		
		bookmarksShowing=false;
		
		bookmarks=new Array();
		bookmarkCount=0;
		bookmarkYPos=bookmarkY;
		
		textFormatObject = new TextFormat(fontValue, fontSizeValue, fontColorValue, null, null, null, "", "", "left", 0, 0, 0, 0);
		titleFormatObject = new TextFormat(fontValue, fontSizeValue, titleFontColorValue, null, null, null, "", "", "left", 0, 0, 0, 0);
		
		this.attachMovie("BookmarkTitle", "bookmarkTitle", 100);
		bookmarkTitle.initializeTextField(titleFormatObject, titleBgColorValue);
		bookmarkTitle.barTitle=titleValue;
		bookmarkTitle._y=titleY;
	}
	
	function onPagesBuilt()
	{
		// show Bookmarks on start
		if (showBookmarks) toggleBookmarks();
	}
	
	function addBookmark(page:Page)
	{
		bookmarkCount++;
		var bookmark:Bookmark=Bookmark(this.attachMovie("Bookmark", page.pageID, bookmarkCount));
		bookmark.initializeTextField(textFormatObject, bgColorValue);
		bookmark.pageID=page.pageID;
		bookmark.pageTitle=page.pageTitle;
		bookmark.setStartPos(titleY);
		bookmark.setEndPos(bookmarkYPos);
		
		bookmarkYPos+=bookmark._height;
		bookmarks.push(bookmark);
	}
	
	function flipToPage(bookmark:Bookmark)
	{
		if (book.flipToPage(bookmark.pageID))
		{
			activateBookmark(bookmark);
		}
	}
	
	private function activateBookmark(bookmark:Bookmark)
	{
		if (activeBookmark!=null) activeBookmark.deactivate();
		activeBookmark=bookmark;
		activeBookmark.activate();
	}
	
	function activateBookmarkOfPage(page:Page)
	{
		var bookmark:Bookmark=this[page.pageID];
		activateBookmark(bookmark);
	}
	
	function toggleBookmarks()
	{
		if (bookmarksShowing)
		{
			bookmarkTitle.show();
			for (var i:Number=0; i<bookmarks.length; i++) bookmarks[i].hide();
		}
		else
		{
			bookmarkTitle.hide();
			for (var i:Number=0; i<bookmarks.length; i++) bookmarks[i].show();
		}
		bookmarksShowing=!bookmarksShowing;
	}
	
	// GETTERS
	
	function get textFormat():TextFormat
	{
		return textFormatObject;
	}
	
	function get fontColor():Number
	{
		return fontColorValue;
	}
	
	function get fontHighlightColor():Number
	{
		return fontHighlightColorValue;
	}
	
	function get bgColor():Number
	{
		return bgColorValue;
	}
	
	function get bgHighlightColor():Number
	{
		return bgHighlightColorValue;
	}
	
	// SETTERS
}

