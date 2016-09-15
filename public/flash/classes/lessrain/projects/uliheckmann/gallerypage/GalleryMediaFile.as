import mx.xpath.XPathAPI;

import flash.display.BitmapData;

import lessrain.lib.components.mediaplayer.MediaFile;

class lessrain.projects.uliheckmann.gallerypage.GalleryMediaFile extends MediaFile
{
	public static function createFromXMLNode(mediaFileNode:XMLNode, pathPrefix:String):GalleryMediaFile
	{
		var mediaFile:GalleryMediaFile;
		var node:XMLNode;
		if (pathPrefix==null) pathPrefix="";
		
		if (mediaFileNode!=null)
		{
			mediaFile = new GalleryMediaFile();
			
			node = XPathAPI.selectSingleNode( mediaFileNode,"/MediaFile");
			mediaFile.id 				= node.attributes.id;
			mediaFile.caption		= XMLNode(XPathAPI.selectSingleNode(node,"/MediaFile/Caption")).firstChild.nodeValue;
			mediaFile.copyright	= XMLNode(XPathAPI.selectSingleNode(node,"/MediaFile/Copyright")).firstChild.nodeValue;
			
			node = XPathAPI.selectSingleNode(mediaFileNode,"/MediaFile/File");
			if (node.attributes.src!=null)
			{
				mediaFile.src 			= pathPrefix+node.attributes.src;
				mediaFile.fileWidth 	= Math.floor( parseFloat(node.attributes.width) );
				mediaFile.fileHeight 	= Math.floor( parseFloat(node.attributes.height) );			
				mediaFile.mediaType = node.attributes.mediaType;
				mediaFile.align 			= node.attributes.align;
				mediaFile.enableFill 	=  (node.attributes.enableFill!="false"); // default is enableFill=true!
				mediaFile.autoPlay		= (node.attributes.autoPlay!="false"); // default is autoPlay=true!
				mediaFile.loop			= (node.attributes.loop=="true"); // default is loop=false
				if (!isNaN(node.attributes.duration)) mediaFile.fileDuration = Number(node.attributes.duration);
			}
			else return null;
			
			node = XPathAPI.selectSingleNode(mediaFileNode,"/MediaFile/PreviewFile");
			if ( node.attributes.src!=null )
			{
				mediaFile.previewSrc	= pathPrefix+node.attributes.src;
				mediaFile.previewFileWidth 	= Math.floor( parseFloat(node.attributes.width) );			
				mediaFile.previewFileHeight	= Math.floor( parseFloat(node.attributes.height) );
				mediaFile.previewMediaType 	= node.attributes.mediaType;
			}
			
			node = XPathAPI.selectSingleNode(mediaFileNode,"/MediaFile/LargeFile");
			if ( node.attributes.src!=null )
			{
				mediaFile.largeSrc	= pathPrefix+node.attributes.src;
				mediaFile.largeFileWidth 	= Math.floor( parseFloat(node.attributes.width) );			
				mediaFile.largeFileHeight	= Math.floor( parseFloat(node.attributes.height) );
				mediaFile.largeMediaType 	= node.attributes.mediaType;
			}
		}
		
		return mediaFile;
	}
	
	private var _align:String;
	private var _enableFill:Boolean;
	private var _thumbnailLoaderMC:MovieClip;
	private var _thumbnailBitmap:BitmapData;
	
	public function GalleryMediaFile()
	{
	}
	
	public function finalize():Void
	{
		_thumbnailBitmap.dispose();
		_thumbnailLoaderMC.removeMovieClip();
	}
	
	public function createThumbnailBitmap():Void
	{
		_thumbnailBitmap = new BitmapData(_thumbnailLoaderMC._width, _thumbnailLoaderMC._height, false );
		_thumbnailBitmap.draw(_thumbnailLoaderMC);
		_thumbnailLoaderMC.removeMovieClip();
		_thumbnailLoaderMC=null;
	}
	
	public function get thumbnailLoaderMC():MovieClip { return _thumbnailLoaderMC; }
	public function set thumbnailLoaderMC(value:MovieClip):Void { _thumbnailLoaderMC=value; }
	
	public function get thumbnailBitmap():BitmapData { return _thumbnailBitmap; }
	public function set thumbnailBitmap(value:BitmapData):Void { _thumbnailBitmap=value; }
	
	public function get align():String { return _align; }
	public function set align(value:String):Void { _align=value; }
	
	public function get enableFill():Boolean { return _enableFill; }
	public function set enableFill(enableFill_:Boolean):Void { _enableFill=enableFill_; }
	
}