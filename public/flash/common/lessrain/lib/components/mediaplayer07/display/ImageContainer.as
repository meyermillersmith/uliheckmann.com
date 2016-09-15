import flash.display.BitmapData;

import lessrain.lib.components.mediaplayer07.events.LoadEvent;
import lessrain.lib.components.mediaplayer07.events.MediaPlayerEvent;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.components.mediaplayer07.model.ImageViewer;
import flash.geom.Matrix;

/**
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.display.ImageContainer {
	
	private var _targetMC:MovieClip;
	private var _imageViewer:ImageViewer;
	private var _loaderMC:MovieClip;
	private var _displayMC:MovieClip;
	private var _imageBmp:BitmapData;
	private var _xscale:Number;
	private var _yscale:Number;
	
	public function ImageContainer(targetMC_:MovieClip, imageViewer_:ImageViewer) {
		_targetMC = targetMC_;
		_imageViewer = imageViewer_;
		
		_loaderMC = _targetMC.createEmptyMovieClip("loaderMC", _targetMC.getNextHighestDepth());
		_displayMC = _targetMC.createEmptyMovieClip("displayMC", _targetMC.getNextHighestDepth());
		
		_loaderMC._alpha = 0;
	}
	
	public function display():Void {
		updateDisplay();
	}
	
	public function scale(scale_:Number):Void {
		xscale = yscale = scale_;
		updateDisplay();
	}
	
	/**
	 * Clean up
	 */
	public function finalize():Void {
		_imageBmp.dispose();
		_targetMC.removeMovieClip();
	}
	
	private function updateDisplay():Void {
		// Hide loaderMC
		_loaderMC._visible = false;
		_loaderMC._alpha = 100;
		
		// Create bitmap from loaderMC
		if(_imageBmp != null) {
			_imageBmp.dispose();
		}
		
		_imageBmp = new BitmapData( _loaderMC._width, _loaderMC._height);
		
		var mtx:Matrix = new Matrix(1, 0, 0, 1);
		_imageBmp.draw(_loaderMC, mtx, null, null, null, true);
		
		// and attach it to the display clip
		_displayMC.attachBitmap(_imageBmp, 0, "auto", true);
		_displayMC._xscale = _xscale  * 100;		_displayMC._yscale = _yscale  * 100;
	}
	
	// Getter & setter
	
	public function get xscale():Number { return _xscale; }
	public function set xscale(xscale_:Number):Void { _xscale = xscale_; }
	
	public function get yscale():Number { return _yscale; }
	public function set yscale(yscale_:Number):Void { _yscale = yscale_; }
	
	public function get targetMC():MovieClip { return _targetMC; }
	
	public function get loaderMC():MovieClip { return _loaderMC; }
}