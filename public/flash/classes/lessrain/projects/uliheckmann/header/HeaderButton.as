﻿import lessrain.lib.utils.animation.easing.Sine;import lessrain.lib.utils.color.SuperColor;import lessrain.lib.utils.events.EventDistributor;import lessrain.lib.utils.events.IDistributor;import lessrain.lib.utils.events.IEvent;import lessrain.lib.utils.tween.TweenTimer;import lessrain.projects.uliheckmann.header.ButtonEvent;import lessrain.projects.uliheckmann.utils.AdvancedColor;import lessrain.projects.uliheckmann.config.GlobalSettings;/** * @author Thomas Meyer, Less Rain (thomas@lessrain.com) */class lessrain.projects.uliheckmann.header.HeaderButton implements IDistributor{	private var _targetMC:MovieClip;	private var _eventDistributor : EventDistributor;	private var _isInverted : Boolean;	private var _alphaTween : TweenTimer;	private var _colorTween : TweenTimer;	private var _advancedColor : AdvancedColor;	private var _superColor : SuperColor;	public function HeaderButton(targetMC_:MovieClip, label_:String, hasIcon_:Boolean)	{		_targetMC=targetMC_;		_isInverted=false;		_eventDistributor = new EventDistributor();		_eventDistributor.initialize(this);	}		public function initialize():Void	{		_alphaTween = new TweenTimer();		_alphaTween.tweenTarget=_targetMC;		_alphaTween.tweenDuration = 300;		_alphaTween.easingFunction = Sine.easeOut;				_advancedColor = new AdvancedColor(_targetMC);		_advancedColor.brightOffset=0;				_superColor = new SuperColor(_targetMC);		_superColor._brightOffset=0;				_colorTween = new TweenTimer();		_colorTween.tweenTarget=_superColor;		_colorTween.tweenDuration = 300;		_colorTween.easingFunction = Sine.easeOut;				_targetMC._alpha=0;		_targetMC._visible=false;	}		public function setPosition(x_:Number, y_:Number):Void	{		if (x_!=null) _targetMC._x=x_;		if (y_!=null) _targetMC._y=y_;	}		public function show(delay_:Number):Void	{		_targetMC._visible=true;		_alphaTween.reset();		_alphaTween.setTweenProperty("_alpha",_targetMC._alpha,100);		_alphaTween.start(delay_);	}		public function hide(delay_:Number):Void	{		_alphaTween.reset();		_alphaTween.setTweenProperty("_alpha",_targetMC._alpha,0);		_alphaTween.start(delay_);	}		public function fadeToWhite():Void	{		_colorTween.reset();		_colorTween.setTweenProperty("_brightOffset",_superColor._brightOffset,GlobalSettings.getInstance().buttonBrightOffset);		_colorTween.start();			}		public function fadeToColor():Void	{		_colorTween.reset();		_colorTween.setTweenProperty("_brightOffset",_superColor._brightOffset,0);		_colorTween.start();	}	public function setEnabled(isEnabled_ : Boolean) : Void	{		targetMC.enabled = isEnabled_;		if (!isEnabled_) out();	}		public function invert():Void	{		_isInverted=true;		out();	}		public function revert():Void	{		_isInverted=false;		out();	}		private function over():Void	{		if (_isInverted) fadeToColor();		else fadeToWhite();	}		private function out():Void	{		if (_isInverted) fadeToWhite();		else fadeToColor();	}		private function release():Void	{		distributeEvent( new ButtonEvent(ButtonEvent.RELEASE, this) );	}	public function finalize():Void	{		_targetMC.removeMovieClip();		_eventDistributor.finalize();	}		public function get targetMC():MovieClip { return _targetMC; }	public function set targetMC(value:MovieClip):Void { _targetMC=value; }	public function get width():Number { return _targetMC._width; }	public function get height():Number { return _targetMC._height; }	public function get x():Number { return _targetMC._x; }		public function addEventListener(type : String, func : Function) : Void {}	public function removeEventListener(type : String, func : Function) : Void {}	public function distributeEvent(eventObject : IEvent) : Void {}}