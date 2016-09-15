/**
 * DownloadFile
 * 
 * @notice Can only be used in HTTP environment due to FileReference restrictions
 *         Captions such as open and save are illegal - http://www.blog.lessrain.com/?p=223
 *
 * @version 1.0
 * @author  luis@lessrain.com
 * @use with flash 8 only
 *
 */

import flash.net.FileReference;
import mx.events.EventDispatcher;
import lessrain.lib.utils.Proxy;

class lessrain.lib.utils.DownloadFile {

	private var path : String;
	private var download_caption : String;
	private var open_caption : String;
	private var fileListener : Object;
	
	// required for EventDispatcher:
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;

	public function DownloadFile(file : String, dCaption : String, oCaption : String) {

		path = file;
		download_caption=dCaption;
		open_caption=oCaption;
		fileListener=new Object();
		EventDispatcher.initialize(this);
		
	}

	public function assignTo(mc : MovieClip, contextMenu : Boolean) {

		var df : Function = Proxy.create(this, downloadF);
		var of : Function = Proxy.create(this, openF);
		
		if(contextMenu){

			var cm : ContextMenu = new ContextMenu();
			cm.customItems.push(new ContextMenuItem(open_caption, of));
			cm.customItems.push(new ContextMenuItem(download_caption, df));
			cm.hideBuiltInItems();
			mc.menu = cm;
			
		}else{

			mc.onRelease = of;
			
		}
	}
	
	public function downloadF() : Void {

		var fileRef : FileReference = new FileReference();
		fileRef.addListener(fileListener);
		fileRef.download(path,_alternateName);
		
	}

	private function onSelect(file : FileReference) : Void {
		dispatchEvent ({target:this, type:'onSelect',fileName:file.name});
	}

	private function onCancel(file : FileReference) : Void {
		dispatchEvent ({target:this, type:'onCancel'});
	}

	private function onOpen(file : FileReference) : Void {
		dispatchEvent ({target:this, type:'onOpen',fileName:file.name});
	}

	private function onProgress(file : FileReference, bytesLoaded : Number, bytesTotal : Number) : Void {
		dispatchEvent ({target:this, type:'onProgress',bLoaded:bytesLoaded,bTotal:bytesTotal});
	}

	private function onComplete(file : FileReference) : Void {
		dispatchEvent ({target:this, type:'onComplete',fileName:file.name});
	}

	private function onIOError(file : FileReference) : Void {
		dispatchEvent ({target:this, type:'onIOError',fileName:file.name});
	}

	private function openF() : Void {
		getURL(path, '_blank');
	}
	
	private var _alternateName:String;
	public function get alternateName():String { return _alternateName; }
	public function set alternateName(value:String):Void { _alternateName=value; }

}