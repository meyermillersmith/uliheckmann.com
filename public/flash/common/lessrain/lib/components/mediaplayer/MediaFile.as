/**
	MediaFile ( JPG,FLV,MP3,SWF )
	
	Define MediaFiles with the following DTD:
	
	<!ELEMENT MediaFile (File, PreviewFile?, LargeFile?, Caption?, Copyright?)>
	<!ATTLIST MediaFile
			  id						CDATA			#REQUIRED
	>
		<!ELEMENT File EMPTY>
		<!ATTLIST File
				  src						CDATA					#REQUIRED
				  mediaType			(jpg|flv|swf|mp3)		#REQUIRED
				  width					CDATA					#REQUIRED
				  height					CDATA					#REQUIRED
				  autoPlay				(true|false)				"true"
				  loop					(true|false)				"false"
				   
		>
		<!ELEMENT PreviewFile EMPTY>
		<!ATTLIST PreviewFile
				  src						CDATA			#REQUIRED
				  mediaType			(jpg)				"jpg"
				  width					CDATA			#REQUIRED
				  height					CDATA			#REQUIRED
		>
		<!ELEMENT LargeFile EMPTY>
		<!ATTLIST LargeFile
				  src						CDATA			#REQUIRED
				  mediaType			(jpg)				#IMPLIED
				  width					CDATA			#REQUIRED
				  height					CDATA			#REQUIRED
		>
		<!ELEMENT Caption (#PCDATA)>
		<!ELEMENT Copyright (#PCDATA)>
	
*/
import mx.xpath.XPathAPI;

class lessrain.lib.components.mediaplayer.MediaFile
{
	/**
	 * Parses an XMLNode and creates a MediaFile object with all values set
	 * The root element of the XMLNode should be the MediaFile element
	 */
	public static function createFromXMLNode(mediaFileNode:XMLNode, pathPrefix:String):MediaFile
	{
		var mediaFile:MediaFile;
		var node:XMLNode;
		
		if (mediaFileNode!=null)
		{
			mediaFile = new MediaFile();
			
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
	
	private var _id:String="";
	private var _canBeOrdered:Boolean=false;
	
	private var _src:String;	
	private var _fileWidth:Number=100;
	private var _fileHeight:Number=100;
	private var _mediaType:String="";
	private var _fileDuration:Number=-1;
	private var _autoPlay:Boolean;
	private var _loop:Boolean;
	
	private var _previewSrc:String;
	private var _previewFileWidth:Number=100;
	private var _previewFileHeight:Number=100;
	private var _previewMediaType:String="";
	
	private var _previewRollOverSrc:String;
	private var _previewRollOverFileWidth:Number=100;
	private var _previewRollOverFileHeight:Number=100;
	private var _previewRollOverMediaType:String="";
	
	private var _largeFileWidth:Number=100;
	private var _largeFileHeight:Number=100;
	private var _largeMediaType:String="";
	private var _largeSrc:String;	
	
	private var _caption:String="";
	private var _copyright:String="";
	
	public function MediaFile()
	{
	}
	
	public function set id(value:String):Void { _id = (value!=null) ? value : ""; }
	public function get id():String { return _id; }
	
	public function set canBeOrdered(value:Boolean):Void { _canBeOrdered = (value!=null) ? value : false; }
	public function get canBeOrdered():Boolean { return _canBeOrdered; }
	
	public function get src():String { return _src; }
	public function set src(value:String):Void { _src=(value!=null) ? value : "filename not set"; }
	
	public function set fileWidth(value:Number):Void { _fileWidth = (value!=null) ? value : 100; }
	public function get fileWidth():Number { return _fileWidth; }
	
	public function set fileHeight(value:Number):Void { _fileHeight = (value!=null) ? value : 100; }
	public function get fileHeight():Number { return _fileHeight; }
	
	public function get autoPlay():Boolean { return _autoPlay; }
	public function set autoPlay(value:Boolean):Void { _autoPlay=value; }
	
	public function get loop():Boolean { return _loop; }
	public function set loop(value:Boolean):Void { _loop=value; }
	
	public function set mediaType(value:String):Void { _mediaType = (value!=null) ? value : "not set"; }
	public function get mediaType():String { return _mediaType; }
	
	public function set fileDuration(value:Number):Void { _fileDuration = (value!=null) ? value : -1; }
	public function get fileDuration():Number { return _fileDuration; }
	
	public function get previewSrc():String { return _previewSrc; }
	public function set previewSrc(value:String):Void { _previewSrc=(value!=null) ? value : "filename not set"; }
	
	public function set previewFileWidth(value:Number):Void { _previewFileWidth = (value!=null) ? value : 100; }
	public function get previewFileWidth():Number { return _previewFileWidth; }
	
	public function set previewFileHeight(value:Number):Void { _previewFileHeight = (value!=null) ? value : 100; }
	public function get previewFileHeight():Number { return _previewFileHeight; }
	
	public function set previewMediaType(value:String):Void { _previewMediaType = (value!=null) ? value : "not set"; }
	public function get previewMediaType():String { return _previewMediaType; }
	
	
	public function get previewRollOverSrc():String { return _previewRollOverSrc; }
	public function set previewRollOverSrc(value:String):Void { _previewRollOverSrc=(value!=null) ? value : "filename not set"; }
	
	public function set previewRollOverFileWidth(value:Number):Void { _previewRollOverFileWidth = (value!=null) ? value : 100; }
	public function get previewRollOverFileWidth():Number { return _previewRollOverFileWidth; }
	
	public function set previewRollOverFileHeight(value:Number):Void { _previewRollOverFileHeight = (value!=null) ? value : 100; }
	public function get previewRollOverFileHeight():Number { return _previewRollOverFileHeight; }
	
	public function set previewRollOverMediaType(value:String):Void { _previewRollOverMediaType = (value!=null) ? value : "not set"; }
	public function get previewRollOverMediaType():String { return _previewRollOverMediaType; }
	
	
	public function get largeSrc():String { return _largeSrc; }
	public function set largeSrc(value:String):Void { _largeSrc=(value!=null) ? value : "filename not set"; }
	
	public function set largeFileWidth(value:Number):Void { _largeFileWidth = (value!=null) ? value : 100; }
	public function get largeFileWidth():Number { return _largeFileWidth; }
	
	public function set largeFileHeight(value:Number):Void { _largeFileHeight = (value!=null) ? value : 100; }
	public function get largeFileHeight():Number { return _largeFileHeight; }
	
	public function set largeMediaType(value:String):Void { _largeMediaType = (value!=null) ? value : "not set"; }
	public function get largeMediaType():String { return _largeMediaType; }


	public function set caption(value:String):Void { _caption = (value!=null) ? value : ""; }
	public function get caption():String { return _caption; }
	
	public function set copyright(value:String):Void { _copyright = (value!=null) ? value : ""; }
	public function get copyright():String { return _copyright; }
	

}