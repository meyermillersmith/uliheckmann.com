/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
import mx.xpath.XPathAPI;

import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.Media;

class lessrain.lib.components.mediaplayer07.core.MediaXMLUtils
{
	/**
	 * Parses an XMLNode and creates a Media object with DataFiles with all values set
	 */
	public static function xmlNode2Media(dataFileNode:XMLNode):Media
	{
		var media:Media;
		var node:XMLNode;
		var subNodes:Array;
		
		if (dataFileNode!=null)
		{
			media = new Media();
			
			node = XPathAPI.selectSingleNode( dataFileNode,"/Media");
			media.id 		= node.attributes.id;
			media.caption	= XMLNode(XPathAPI.selectSingleNode(node,"/Media/Caption")).firstChild.nodeValue;
			media.copyright	= XMLNode(XPathAPI.selectSingleNode(node,"/Media/Copyright")).firstChild.nodeValue;

			subNodes = XPathAPI.selectNodeList(dataFileNode,"/Media/File");
			for (var i : Number = 0; i < subNodes.length; i++) 
			{
				var dataFile:DataFile = new DataFile();
				if (subNodes[i].attributes.src!=null)
				{
					dataFile.type 		= (subNodes[i].attributes.type) ? subNodes[i].attributes.type : "image";
					dataFile.role 		= (subNodes[i].attributes.role) ? subNodes[i].attributes.role : "master";
					dataFile.src 		= (subNodes[i].attributes.src) 	? subNodes[i].attributes.src  : null;
					dataFile.w 			= (subNodes[i].attributes.w) 	? Math.floor( parseFloat(subNodes[i].attributes.w) ) : 0;
					dataFile.h	 		= (subNodes[i].attributes.h) 	? Math.floor( parseFloat(subNodes[i].attributes.h) ) : 0;
					dataFile.duration 	= (subNodes[i].attributes.duration) ? Math.floor( parseFloat(subNodes[i].attributes.duration) ) : null;
					
					media.addFile( dataFile );
				}
			}
			
			return media;
		}
		else return null;
	}
	
	/**
	 * Transforms a media item back into the XML representation
	 * @param	Media item to transform
	 * @return	XML representation
	 */
	public static function media2XmlNode(media_:Media):XMLNode {
		var mediaNode:XMLNode= new XMLNode(1, "Media");
		mediaNode.attributes.id = media_.id;
		if(media_.caption != null) {
			var captionNode:XMLNode = new XMLNode(1, "Caption");
			captionNode.appendChild(new XMLNode(3, media_.caption));
			mediaNode.appendChild(captionNode);
		}
		if(media_.copyright != null) {
			var copyrightNode:XMLNode = new XMLNode(1, "Copyright");
			copyrightNode.appendChild(new XMLNode(3, media_.copyright));
			mediaNode.appendChild(copyrightNode);
		}
		
		for(var i:Number = 0; i < media_.files.length; i++) {
			var fileNode:XMLNode = new XMLNode(1, "File");
			var file:DataFile = DataFile(media_.files[i]);
			fileNode.attributes.src = file.src;			fileNode.attributes.type = file.type;
			fileNode.attributes.role = file.role;
			if(file.w != null) {
				fileNode.attributes.w = file.w;
			}
			if(file.h != null) {
				fileNode.attributes.h = file.h;
			}
			if(file.duration != null) {
				fileNode.attributes.duration = file.duration;
			}
			mediaNode.appendChild(fileNode);
		}
		
		return mediaNode;
	}
	
	/**
	 * Parses an XMLNode and creates an Array of Media objects with all values set
	 */
	public static function xmlNode2Gallery(galleryNode:XMLNode):Array
	{
		var gallery:Array = new Array();
		var nodes:Array;
		
		if (galleryNode!=null)
		{
			nodes = XPathAPI.selectNodeList( galleryNode,"/Gallery/Media");
			
			for (var i : Number = 0; i < nodes.length; i++)
			{
				var media:Media = xmlNode2Media(nodes[i]);
				gallery.push(media);
			}
		}
		
		return gallery;
	}
	
}