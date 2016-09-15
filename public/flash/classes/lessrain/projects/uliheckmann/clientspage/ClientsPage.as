import mx.xpath.XPathAPI;

import flash.display.BitmapData;

import lessrain.lib.utils.assets.Label;
import lessrain.lib.utils.assets.Source;
import lessrain.lib.utils.geom.Coordinate;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.core.DimPage;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.Word;
import lessrain.projects.uliheckmann.utils.TextFieldFader;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.clientspage.ClientsPage extends DimPage
{
	private var _xml : XML;
	private var _clientsList : Array;
	private var _clients : String;
	private var _title : String;
	private var _titleWord : Word;
	private var _worldMap : Letter;
	private var _clientsField : TextFieldFader;
	
	public function ClientsPage(targetMC : MovieClip)
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
		var yPos:Number = 45;
		
		_titleWord = new Word(_contentMC.createEmptyMovieClip("title",2), _title, 0,0);
		_titleWord.setPos(xPos,yPos);
		_titleWord.initialize();
		_titleWord.setMode(Letter.MODE_GALLERY);
		yPos+=_titleWord.height+6;
		
		_clientsList.sort();
		for (var i : Number = 0; i < _clientsList.length; i++)
		{
			if (i>0) _clients+="<br/>";
			_clients+=_clientsList[i];
		}
		
		_clientsField = new TextFieldFader( _contentMC.createEmptyMovieClip("clients",11), _clients, "clients" );
		_clientsField.initialize();
		_clientsField.setPosition(xPos-3, yPos);
		
		xPos+=_clientsField.getWidth()-38;
		yPos+=12;
		_worldMap = new Letter(_contentMC.createEmptyMovieClip("worldMap",10), "world", xPos, yPos, 2, true);
		_worldMap.fillOffset = new Coordinate(10,7);
		_worldMap.initialize();
		_worldMap.addFill("orange", new BitmapData(_worldMap.width, _worldMap.height, false, GlobalSettings.getInstance().highlightColor));
	}
	
	public function show():Void
	{
		super.show();
		_titleWord.setState(Letter.STATE_ANTS);
		_worldMap.setFill("orange");
		_worldMap.setState(Letter.STATE_BOTH);
		_clientsField.show();
		
		dispatchPageShowing();
	}
	
	public function hide():Void
	{
		super.hide();
		if (!_isDimmed)
		{
			_titleWord.setState(Letter.STATE_INVISIBLE);
			_worldMap.setState(Letter.STATE_INVISIBLE);
			_clientsField.addEventListener(TweenEvent.TWEEN_COMPLETE, Proxy.create(this, dispatchPageHidden));
			_clientsField.hide();
		}
	}
	
	public function dim( action_:Number ):Void
	{
		super.dim(action_);
	}
	
	public function undim( delay_:Number ):Void
	{
		_titleWord.setState(Letter.STATE_ANTS);
		_worldMap.setState(Letter.STATE_BOTH);
		super.undim(delay_);
	}
	
	private function onTweenComplete(tweenEvent:TweenEvent):Void
	{
		if (_isDimmed)
		{
			_titleWord.setState(Letter.STATE_INVISIBLE);
			_worldMap.setState(Letter.STATE_INVISIBLE);
		}
		super.onTweenComplete(tweenEvent);
	}
	
	/*
	 * Initial loading etc.
	 */
	private function onXMLLoaded():Void
	{
		_title = XMLNode(XPathAPI.selectSingleNode(_xml.firstChild, "Clients/Title")).firstChild.nodeValue;
		
		var node:XMLNode;
		var nodes:Array = XPathAPI.selectNodeList(_xml.firstChild,"/Clients/Client");
		_clients = "";
		_clientsList = new Array();

		var total:Number=nodes.length;
		for (var i : Number = 0; i < total; i++)
		{
			node = nodes[i];
			_clientsList.push(node.firstChild.nodeValue);
		}
		
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
		_clientsField.finalize();
		_titleWord.finalize();
		_worldMap.finalize();
		super.finalize();
	}
}