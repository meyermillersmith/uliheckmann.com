/**
 * @author Soenke Rohde <mail@soenkerohde.com>
 * @license LGPL
 * 
 */
class org.osflash.zeroi.util.XMLUtils {
	private function XMLUtils(){
		// only static usage
	}
	
	public static function loadXML(path:String, callTarget:Object,callFunc:Function):Void{
		var x:XML = new XML();
		x.ignoreWhite = true;
		x.onLoad = function(b:Boolean):Void{
			if(!b){
				trace("e loadXML failed " + path);	
			}else if(this.status != 0){
				trace("w xml status not valid " + path + " status " + this.status);	
			}
			callFunc.call(callTarget, b, this);
		};
		x.load(path);
	}
	
	public static function byName(node:XMLNode,nodeName:String):XMLNode{
		if(node == null){
			return null;
		}
		if (node.nodeName == nodeName){
			return node;
		}
		return XMLUtils.byName(node.firstChild,nodeName)
			||  XMLUtils.byName(node.nextSibling,nodeName)
			|| null;
	}
	
	public static function byValue(node:XMLNode,nodeName:String,attrName:String,attrValue:Object):XMLNode{
		if(node == null){
			return null;
		}
		if(node.nodeName == nodeName && node.attributes[attrName] == attrValue)return node;
		return XMLUtils.byValue(node.firstChild,nodeName,attrName,attrValue)
			|| XMLUtils.byValue(node.nextSibling,nodeName,attrName,attrValue)
			|| null;
	}
}
