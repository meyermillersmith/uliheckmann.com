import mx.xpath.XPathAPI;

import lessrain.lib.utils.assets.AssetsLoader;
import lessrain.lib.utils.assets.Font;
import lessrain.lib.utils.assets.IPreloadListener;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.SitePreloader extends AssetsLoader implements IDistributor
{
	private static var PHASE_XML:Number = 1;
	private static var PHASE_ASSETS:Number = 2;
	private static var PHASE_FONTS:Number = 3;
	
	private var _mainMC : MovieClip;
	private var _eventDistributor : EventDistributor;
	private var _listener : IPreloadListener;
	private var _phase : Number;
	
	public function SitePreloader( assetcSrc:String, mainMC:MovieClip, listener:IPreloadListener )
	{
		super( assetcSrc );
		_mainMC=mainMC;
		_listener=listener;
		_phase = PHASE_XML;
		
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	}
	
	public function start():Void
	{
		_phase = PHASE_XML;
		super.start();
	}
	
	private function xmlLoaded():Void
	{
		_phase = PHASE_ASSETS;
		super.xmlLoaded();
	}
	
	private function parseAssets():Void
	{
		var nodes:Array;
		var node:XMLNode;
		

		/*
		mainSWF
		*/
		node = XPathAPI.selectSingleNode(_assetsXML.firstChild,"/Assets");
		var src:String = node.attributes.mainSWFSrc;
		if (src!=null && src!="")
		{
			// this is for the v=1 increment in the html code to force browsers to download new versions of an swf
			if (_level0.v!=null && _level0.v!="") src+="?v="+_level0.v;
			_groupLoader.addFile( _mainMC, src, 100 );
		}
		
		/*
		fonts
		*/
		nodes = XPathAPI.selectNodeList(_assetsXML.firstChild,"/Assets/Fonts/Font");
		for (var i : Number = 0; i < nodes.length; i++)
		{
			node=nodes[i];
			_preloadCount++;
			var font:Font = Font.addFont(node.attributes.id, _pathPrefix+node.attributes.fontSrc, _pathPrefix+node.attributes.importSrc );
			_groupLoader.addFile( _holderMC.temp.createEmptyMovieClip("asset_"+_preloadCount, _preloadCount), font.fontSrc, 100 );
		}
		
		super.parseAssets();
	}
	
	private function loadFonts():Void
	{
		_phase = PHASE_FONTS;
		var fonts:Array = Font.getFonts();
		for (var i : Number = 0; i < fonts.length; i++)
		{
			_preloadCount++;
			var font:Font = fonts[i];
			_groupLoader.addFile( _holderMC.keep.createEmptyMovieClip("font_"+_preloadCount, _preloadCount), font.importSrc, 100, null, null, true );
		}
		_groupLoader.start();
	}
	
	public function onGroupStart() : Void {}
	
	private function onGroupComplete():Void
	{
		if (_phase==PHASE_FONTS)
		{
			_listener.onPreloadComplete();
		}
		else
		{
			_isComplete=true;
			_preloadCount=0;
			_holderMC.temp.removeMovieClip();
			_holderMC.temp=null;
			
			if (Font.getFonts()==null) _listener.onPreloadComplete();
			else loadFonts();
		}
	}
	
	public function onGroupProgress(filesLoaded : Number, filesTotal : Number, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void
	{
		switch (_phase)
		{
			case PHASE_XML: _listener.onPreloadProgress( 0, 1, 0, 0, 0 ); break;
			case PHASE_ASSETS: _listener.onPreloadProgress( filesLoaded, filesTotal, bytesLoaded, bytesTotal, percent ); break;
			case PHASE_FONTS: _listener.onPreloadProgress( 1, 1, 0, 0, 100 ); break;
		}
	}
	
	public function addEventListener(type : String, func : Function) : Void { }
	public function removeEventListener(type : String, func : Function) : Void { }
	public function distributeEvent(eventObject : IEvent) : Void { }

}