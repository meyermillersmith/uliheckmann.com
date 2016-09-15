﻿import lessrain.lib.utils.animation.easing.Sine;import lessrain.lib.utils.assets.StyleSheet;import lessrain.lib.utils.events.EventDistributor;import lessrain.lib.utils.events.IDistributor;import lessrain.lib.utils.events.IEvent;import lessrain.lib.utils.Proxy;import lessrain.lib.utils.text.DynamicTextField;import lessrain.lib.utils.tween.TweenEvent;import lessrain.lib.utils.tween.TweenTimer;/** * @author Thomas Meyer, Less Rain (thomas@lessrain.com) */class lessrain.projects.uliheckmann.utils.TextFieldFader implements IDistributor{	private var _targetMC:MovieClip;	private var _text : String;	private var _styleClass : String;	private var _tf : DynamicTextField;	private var _tween : TweenTimer;	private var _isShowing : Boolean;	private var _eventDistributor : EventDistributor;		public function TextFieldFader(targetMC_:MovieClip, text_:String, styleClass_:String)	{		_targetMC=targetMC_;		_text=text_;		_styleClass=styleClass_;		_eventDistributor = new EventDistributor();		_eventDistributor.initialize(this);	}		public function initialize():Void	{		_tf = new DynamicTextField( _targetMC );		_tf.initialize( _text, StyleSheet.getStyleSheet("main"), _styleClass, true, true, 0, 0 );				_targetMC._visible=false;		_targetMC._alpha=0;				_tween = new TweenTimer();		_tween.tweenTarget=_targetMC;		_tween.tweenDuration = 800;		_tween.easingFunction = Sine.easeOut;		_tween.addEventListener(TweenEvent.TWEEN_COMPLETE, Proxy.create(this, onTweenComplete));	}		private function onTweenComplete(tweenEvent_:TweenEvent):Void	{		if (!_isShowing) _targetMC._visible=false;			}		public function setPosition(x_:Number, y_:Number):Void	{		_targetMC._x=x_;		_targetMC._y=y_;	}		public function show():Void	{		if (!_isShowing)		{			_isShowing = true;			_targetMC._visible=true;			_tween.reset();			_tween.setTweenProperty("_alpha", _targetMC._alpha, 100);			_tween.start();		}	}		public function hide():Void	{		if (_isShowing)		{			_isShowing = false;			_tween.reset();			_tween.setTweenProperty("_alpha", _targetMC._alpha, 0);			_tween.start();		}	}		public function getWidth():Number	{		return _tf.textWidth;	}	public function finalize():Void	{		_targetMC.removeMovieClip();	}		public function get targetMC():MovieClip { return _targetMC; }	public function set targetMC(value:MovieClip):Void { _targetMC=value; }		public function addEventListener(type : String, func : Function) : Void {}	public function removeEventListener(type : String, func : Function) : Void {}	public function distributeEvent(eventObject : IEvent) : Void {}}