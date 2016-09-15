import mx.xpath.XPathAPI;

import lessrain.lib.components.mediaplayer.MediaFile;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.components.mediaplayer.MediaFileUtils
{
	/**
	 * Parses an XMLNode and creates a MediaFile object with all values set
	 */
	public static function xmlNode2MediaFile(mediaFileNode:XMLNode):MediaFile
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
				mediaFile.src 			= node.attributes.src;
				mediaFile.fileWidth 	= Math.floor( parseFloat(node.attributes.width) );
				mediaFile.fileHeight 	= Math.floor( parseFloat(node.attributes.height) );			
				mediaFile.mediaType = node.attributes.mediaType;
			}
			else return null;
			
			node = XPathAPI.selectSingleNode(mediaFileNode,"/MediaFile/PreviewFile");
			if ( node.attributes.src!=null )
			{
				mediaFile.previewSrc	= node.attributes.src;
				mediaFile.previewFileWidth 	= Math.floor( parseFloat(node.attributes.width) );			
				mediaFile.previewFileHeight	= Math.floor( parseFloat(node.attributes.height) );
				mediaFile.previewMediaType 	= node.attributes.mediaType;
			}
			
			node = XPathAPI.selectSingleNode(mediaFileNode,"/MediaFile/LargeFile");
			if ( node.attributes.src!=null )
			{
				mediaFile.largeSrc	= node.attributes.src;
				mediaFile.largeFileWidth 	= Math.floor( parseFloat(node.attributes.width) );			
				mediaFile.largeFileHeight	= Math.floor( parseFloat(node.attributes.height) );
				mediaFile.largeMediaType 	= node.attributes.mediaType;
			}
		}
		
		return mediaFile;
	}
	
}