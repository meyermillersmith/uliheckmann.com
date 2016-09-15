import mx.events.EventDispatcher;
import mx.xpath.XPathAPI;

import lessrain.lib.utils.assets.Image;
import lessrain.lib.utils.assets.Label;
import lessrain.lib.utils.assets.Link;
import lessrain.lib.utils.assets.Source;
import lessrain.lib.utils.assets.StyleSheet;
import lessrain.lib.utils.loading.GroupListener;
import lessrain.lib.utils.loading.GroupLoader;
import lessrain.lib.utils.Proxy;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.assets.AssetsLoader implements GroupListener
{
	private var _src:String;
	private var _assetsXML:XML;
	private var _preloaderDepth:Number;
	private var _isComplete:Boolean;
	private var _groupLoader : GroupLoader;
	private var _holderMC : MovieClip;
	
	// Prefix can be set when developing
	// When the path to assets is differs from the Flash IDE to the HTML structure
	private var _pathPrefix:String;

	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;

	private var _preloadCount : Number;

	public function AssetsLoader( src:String )
	{
		_preloaderDepth=1048568;
		_src=src;
		_assetsXML = new XML();
		_assetsXML.ignoreWhite=true;
		_isComplete=false;
		_pathPrefix="";
		EventDispatcher.initialize(this);
	}
	
	public function start( clearAssets:Boolean ):Void
	{
		if (clearAssets)
		{
			Label.reset();
			StyleSheet.reset();
			Image.reset();
			Link.reset();
			Source.reset();
		}
		
		_assetsXML.onLoad = Proxy.create(this, xmlLoaded);
		_assetsXML.load(_src);
	}
	
	private function xmlLoaded():Void
	{
		// create mc to load the external file assets into
		_holderMC = _root.createEmptyMovieClip("___assetLoaderPreload",_preloaderDepth);
		_holderMC._visible=false;
		_holderMC = _root.___assetLoaderPreload;
		_holderMC.createEmptyMovieClip("temp",1);
		_holderMC.createEmptyMovieClip("keep",2);
		_preloadCount=0;
		
		_groupLoader = new GroupLoader(this);
		
		parseAssets();
		
		delete _assetsXML;
		_groupLoader.start();
	}
	
	private function parseAssets():Void
	{
		var nodes:Array;
		var node:XMLNode;

		/*
		labels
		*/
		nodes = XPathAPI.selectNodeList(_assetsXML.firstChild,"/Assets/Labels/Label");
		for (var i : Number = 0; i < nodes.length; i++)
		{
			node=nodes[i];
			Label.addLabel(node.attributes.id, node.firstChild.nodeValue);
		}

		/*
		links
		*/
		nodes = XPathAPI.selectNodeList(_assetsXML.firstChild,"/Assets/Links/Link");
		for (var i : Number = 0; i < nodes.length; i++)
		{
			node=nodes[i];
			Link.addLink(node.attributes.id, node.attributes.href, node.attributes.target, node.firstChild.nodeValue);
		}

		/*
		sources
		*/
		nodes = XPathAPI.selectNodeList(_assetsXML.firstChild,"/Assets/Sources/Source");
		for (var i : Number = 0; i < nodes.length; i++)
		{
			node=nodes[i];
			Source.addSource(node.attributes.id, _pathPrefix+node.attributes.src);
		}
		
		/*
		style sheets
		*/
		nodes = XPathAPI.selectNodeList(_assetsXML.firstChild,"/Assets/StyleSheets/StyleSheet");
		for (var i : Number = 0; i < nodes.length; i++)
		{
			node=nodes[i];
			var styleSheet:StyleSheet = StyleSheet.addStyleSheet(node.attributes.id, _pathPrefix+node.attributes.src);
			_groupLoader.addFile( styleSheet.styleSheetObject, styleSheet.src, 100 );
		}
		
		/*
		images
		*/
		nodes = XPathAPI.selectNodeList(_assetsXML.firstChild,"/Assets/Images/Image");
		for (var i : Number = 0; i < nodes.length; i++)
		{
			node=nodes[i];
			_preloadCount++;
			var image:Image = Image.addImage(node.attributes.id, _pathPrefix+node.attributes.src );
			_groupLoader.addFile( _holderMC.temp.createEmptyMovieClip("asset_"+_preloadCount, _preloadCount), image.src, 100 );
		}
	}

	public function onGroupStart(groupLoader:GroupLoader) : Void { }
	public function onGroupComplete(groupLoader:GroupLoader) : Void
	{
		_isComplete=true;
		_preloadCount=0;
		_holderMC.temp.removeMovieClip();
		_holderMC.temp=null;
		
		dispatchEvent( { type: "onAssetsComplete" } );
	}
	public function onGroupProgress(filesLoaded : Number, filesTotal : Number, bytesLoaded : Number, bytesTotal : Number, percent : Number, groupLoader:GroupLoader) : Void { }
	
	public function get src():String { return _src; }
	public function set src(value:String):Void { _src=value; }
	public function get preloaderDepth():Number { return _preloaderDepth; }
	public function set preloaderDepth(value:Number):Void { _preloaderDepth=value; }
	public function get isComplete():Boolean { return _isComplete; }
	public function set isComplete(value:Boolean):Void { _isComplete=value; }
	public function get pathPrefix():String { return _pathPrefix; }
	public function set pathPrefix(value:String):Void { _pathPrefix=value; }
}