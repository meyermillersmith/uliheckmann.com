import mx.xpath.XPathAPI;

import lessrain.lib.utils.assets.Label;
import lessrain.lib.utils.assets.Source;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.projects.uliheckmann.core.DimPage;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.Word;
import lessrain.projects.uliheckmann.utils.TextFieldFader;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.contactpage.ContactPage extends DimPage
{
	private var _xml : XML;
	private var _title : String;
	private var _titleWord : Word;

	private var _contact : String;
	private var _contactField : TextFieldFader;
	
	public function ContactPage(targetMC : MovieClip)
	{
		super(targetMC);
		_hasSubNavigation=false;
	}
	
	public function initialize():Void
	{
		super.initialize();
		
		_xml = new XML();
		_xml.ignoreWhite=true;
		
		var srcID:String = getPageIDPart(0);
		PriorityLoader.getInstance().addFile( _xml, Source.getSource(srcID), this, 100, "xml", Label.getLabel("Loading.data") );
		
		if (GlobalSettings.getInstance().enableFullscreen)
		{
			onResize();
			Stage.addListener(this);
		}
	}
	
	private function onResize():Void
	{
		super.onResize();
		_targetMC._x = GlobalFunctions.getCenterStageX();
		_targetMC._y = GlobalFunctions.getCenterStageY();
	}
	
	private function build():Void
	{
		var xPos:Number = GlobalSettings.getInstance().contentLeft;
		var yPos:Number = GlobalSettings.getInstance().contentTop;
		
		_titleWord = new Word(_contentMC.createEmptyMovieClip("title",2), _title, 0,0);
		_titleWord.setPos(xPos,yPos);
		_titleWord.initialize();
		_titleWord.setMode(Letter.MODE_GALLERY);
		yPos+=_titleWord.height+6;
		
		_contactField = new TextFieldFader( _contentMC.createEmptyMovieClip("contact",11), _contact, "contact" );
		_contactField.initialize();
		_contactField.setPosition(xPos-3, yPos);
	}
	
	public function show():Void
	{
		super.show();
		_titleWord.setState(Letter.STATE_ANTS);
		_contactField.show();
		
		dispatchPageShowing();
	}
	
	public function hide():Void
	{
		super.hide();
		if (!_isDimmed)
		{
			_titleWord.setState(Letter.STATE_INVISIBLE);
			_contactField.addEventListener(TweenEvent.TWEEN_COMPLETE, Proxy.create(this, dispatchPageHidden));
			_contactField.hide();
		}
	}
	
	public function dim( action_:Number ):Void
	{
		super.dim(action_);
	}
	
	public function undim( delay_:Number ):Void
	{
		_titleWord.setState(Letter.STATE_ANTS);
		super.undim(delay_);
	}
	
	private function onTweenComplete(tweenEvent:TweenEvent):Void
	{
		if (_isDimmed)
		{
			_titleWord.setState(Letter.STATE_INVISIBLE);
		}
		super.onTweenComplete(tweenEvent);
	}
	
	/*
	 * Initial loading etc.
	 */
	private function onXMLLoaded():Void
	{
		_title = XMLNode(XPathAPI.selectSingleNode(_xml.firstChild, "Contact/Title")).firstChild.nodeValue;
		_contact = XMLNode(XPathAPI.selectSingleNode(_xml.firstChild, "Contact/Content")).firstChild.nodeValue;
		
		var node:XMLNode;
		
		delete _xml;
		
		build();
		dispatchPageInitialized();
	}

	// PriorityLoader function for xml
	public function onLoadComplete(file : FileItem) : Void
	{
		if (file.id=="xml") onXMLLoaded();
	}
	
	public function finalize():Void
	{
		_contactField.finalize();
		_titleWord.finalize();
		super.finalize();
	}
}