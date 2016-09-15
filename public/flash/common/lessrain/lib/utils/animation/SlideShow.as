/**
 * SlideShow, version 1
 * @class:   lessrain.lib.utils.animation.SlideShow
 * @author:  luis@lessrain.com
 * @version: 1.0.0
 */

import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.animation.Tween;
import lessrain.lib.utils.animation.easing.Quad;
import mx.events.EventDispatcher;

//:TODO:  needs to clean up the code a little bit /Luis/ 17:14 - Friday,4 February 2005

class lessrain.lib.utils.animation.SlideShow
{
	private var _listeners:Array;
	private var _que:Array;
	private var _index:Number;
	private var _currItem:Object;
	private var _interval:Number;
	private var _subInterval:Number;
	private var _startLoadTime:Number;
	private var _delay:Number;
	private var _container:MovieClip;
	private var _subContainer:MovieClip;
	private var _oldSubContainer:MovieClip;
	private var _t:Tween;
	private var _trans:Function = Quad.easeOut;
	private var _status:String = 'Play';
	private var _inMotion:Boolean;
	private var dispatchEvent:Function;
	
	// required for EventDispatcher:
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var eventListenerExists:Function;
	
	static var TEMP_TIME:Number;
	static var TEMP_TIME_DIFF:Number;
	
	
	public function get status ():String
	{
		return _status;
	}
	
/**
 * SlideShow constructor
 * @param  container       Container MovieClip
 * @param  delay           millisecons interval
 */
 
	function SlideShow (container:MovieClip, delay:Number)
	{
		_que = new Array ();
		_index = -1;
		_currItem = null;
		_interval = null;
		_subInterval = null;
		_startLoadTime = null;
		_container = container;
		
		_delay = delay;
		
		_container.createEmptyMovieClip ('back', 1);
		_container.createEmptyMovieClip ('top', 2);
		
		_subContainer = null;
		_oldSubContainer = null;
		
		EventDispatcher.initialize (this);
	}
	function $preloadNext ():Void
	{
		_inMotion = false;
		if (_status == 'Play') {
			if ((_que.length - 1) > _index) {
				_index++;
				_currItem = _que[_index];
				clearIntervals ();
				_startLoadTime = getTimer ();
				$loadItem ();
				_interval = setInterval (this, "$onItemData", 100);
			} else {
				dispatchEvent ({type:"onLoad", target:this});
				$startAgain ();
			}
		} else {
			return;
		}
	}
	function $startAgain ():Void
	{
		_index = -1;
		$preloadNext ();
	}
	function $onItemData ():Void
	{
		var itemPercent:Number;
		itemPercent = (_subContainer.getBytesLoaded () / _subContainer.getBytesTotal ()) * 100;
		if (!isNaN (itemPercent)) {
			dispatchEvent ({type:"onItemData", target:this, iPercent:itemPercent, sID:_currItem.id});
		}
		if (_subContainer.getBytesTotal () == -1 && (getTimer () - _startLoadTime) > 7000) {
			$onLoad (false);
		}
		if (itemPercent == 100) {
			$onLoad (true);
		}
	}
	function $onTotalData ():Void
	{
		var totalPercent:Number;
		totalPercent = (_index / _que.length) * 100;
		if (!isNaN (totalPercent)) {
			dispatchEvent ({type:"onTotalData", target:this, iPercent:totalPercent});
		}
	}
	function $onLoad (bSuccess:Boolean):Void
	{
		clearInterval (_interval);
		if (!bSuccess) {
			trace ("FAILURE LOADING ASSET");
			dispatchEvent ({type:"onTotalData", target:this, sID:_currItem.id});
		}
		$onTotalData ();
		if (_subContainer == _container.top || _oldSubContainer == null) {
			_t = new Tween (_subContainer, [{prop:'_alpha', end:100}], 1000, _trans, true);
			_inMotion = true;
		} else {
			_subContainer._alpha = 100;
			_t = new Tween (_oldSubContainer, [{prop:'_alpha', end:0}], 1000, _trans, true);
			_inMotion = true;
		}
		_t.addEventListener ("onComplete", Proxy.create (this, $motionFinished));
	}
	private function $motionFinished ():Void
	{
		if (_subContainer == _container.top) {
			 _container.back.unloadMovie ();
		}else{
			 _container.top.unloadMovie ();
		}
		if (_inMotion) {
			_subInterval = setInterval (this, "$preloadNext", _delay);
			TEMP_TIME = getTimer ();
		} else {
			return;
		}
	}
	private function $loadItem ():Void
	{
		_oldSubContainer = _subContainer;
		_subContainer = (_oldSubContainer == _container.back) ? _container.top : _container.back;
		_subContainer._alpha = 0;
		_subContainer.loadMovie (_currItem.url);
	}
	function addItem (sUrl:String):Void
	{
		var ID:Number;
		ID = _que.length;
		_que.push ({url:sUrl, id:ID});
	}
	function pause ():Void
	{
		clearIntervals ();
		var elapsedTime:Number = getTimer () - TEMP_TIME;
		if (elapsedTime < _delay) {
			trace ('remaining milliseconds :' + (_delay - elapsedTime));
			TEMP_TIME_DIFF = _delay - elapsedTime;
		}
		_inMotion = false;
		_status = 'Pause';
	}
	function play ():Void
	{
		_status = 'Play';
		_subInterval = setInterval (this, "$preloadNext", TEMP_TIME_DIFF);
	}
	function clear ():Void
	{
		_que = new Array ();
		_index = 0;
	}
	function start ():Void
	{
		if (_status != 'Play') {
			clearIntervals ();
			_startLoadTime = getTimer ();
			$loadItem ();
			_interval = setInterval (this, "$onItemData", 100);
		} else {
			_status = 'Play';
			$preloadNext ();
		}
	}
	function clearIntervals ()
	{
		clearInterval (_interval);
		clearInterval (_subInterval);
	}
}
