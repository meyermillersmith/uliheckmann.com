import flash.display.BitmapData;
import flash.geom.Matrix;

import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.utils.loading.PriorityLoader;
/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.MediaPreview implements FileListener {
	
	private var _targetMC:MovieClip;
	private var _loadTarget:MovieClip;
	private var _displayTarget:MovieClip;
	private var _src:String;
	private var _loadCallback:Function;
	private var _bitmap:BitmapData;
	private var _isShowing:Boolean;
	
	public function MediaPreview(targetMC_:MovieClip, src_:String) {
		_targetMC = targetMC_;
		_src = src_;

		_loadTarget = _targetMC.createEmptyMovieClip("loadTarget", _targetMC.getNextHighestDepth());
		_loadTarget._alpha = 0;
		_displayTarget = _targetMC.createEmptyMovieClip("displayTarget", _targetMC.getNextHighestDepth());
	}
	
	public function load(callback_:Function):Void {
		_loadCallback = callback_;
		PriorityLoader.getInstance().addFile(_loadTarget, _src, this, 100, _src, "Loading Preview");
	}
	
	public function show():Void {
		if(_isShowing === true) {
			return;
		}
		_isShowing = true;
		_displayTarget._visible = true;
	}
	
	public function hide():Void {
		if(_isShowing === false) {
			return;
		}
		_isShowing = false;
		_displayTarget._visible = false;
	}
	
	public function isShowing():Boolean {
		return _isShowing;
	}
	
	// FileListener methods

	public function onLoadStart(file : FileItem) : Boolean {
		return null;
	}

	public function onLoadComplete(file : FileItem) : Void {
		if(!file.src == _src) {
			return;
		}
		_bitmap = new BitmapData(_loadTarget._width, _loadTarget._height, false);
		_bitmap.draw(_loadTarget, new Matrix());
		_loadTarget.removeMovieClip();
		
		_displayTarget._visible = false;
		_displayTarget.attachBitmap(_bitmap, 0, "auto", true);

		_loadCallback.apply();
	}

	public function onLoadProgress(file : FileItem, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void {
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		_targetMC.removeMovieClip();
		_bitmap.dispose();
	}

}