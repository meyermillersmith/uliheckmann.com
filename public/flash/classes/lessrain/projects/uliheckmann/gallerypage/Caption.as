﻿import lessrain.lib.utils.text.DynamicTextField;import lessrain.lib.utils.assets.StyleSheet;import lessrain.lib.utils.tween.TweenTimer;import lessrain.lib.utils.animation.easing.Sine;import lessrain.projects.uliheckmann.config.GlobalSettings;/** * @author Thomas Meyer, Less Rain (thomas@lessrain.com) */class lessrain.projects.uliheckmann.gallerypage.Caption{	private var _targetMC:MovieClip;	private var _tf : DynamicTextField;	private var _alphaTween : TweenTimer;		public function Caption(targetMC_:MovieClip)	{		_targetMC=targetMC_;	}		public function initialize():Void	{		_tf = new DynamicTextField(_targetMC.createEmptyMovieClip("tf",10));		_tf.initialize( "", StyleSheet.getStyleSheet("main"), "caption", false, false, 264, 0 );				_alphaTween = new TweenTimer();		_alphaTween.tweenTarget=_targetMC;		_alphaTween.tweenDuration = 300;		_alphaTween.easingFunction = Sine.easeOut;				onResize();		if (GlobalSettings.getInstance().enableFullscreen)		{			Stage.addListener(this);		}	}		private function onResize():Void	{		_targetMC._y=Stage.height-125+98-10-_tf.textHeight;	}		public function setPosition(x_:Number, y_:Number):Void	{		if (x_!=null) _targetMC._x=x_;		if (y_!=null) _targetMC._y=y_;	}		public function show(delay_:Number):Void	{		_targetMC._visible=true;		_alphaTween.reset();		_alphaTween.setTweenProperty("_alpha",_targetMC._alpha,100);		_alphaTween.start(delay_);	}		public function hide(delay_:Number):Void	{		_alphaTween.reset();		_alphaTween.setTweenProperty("_alpha",_targetMC._alpha,0);		_alphaTween.start(delay_);	}	public function setCaption(caption_:String):Void	{		_tf.text = caption_;		onResize();	}	public function finalize():Void	{		_tf.removeMovieClip();		_targetMC.removeMovieClip();	}		public function get targetMC():MovieClip { return _targetMC; }	public function set targetMC(value:MovieClip):Void { _targetMC=value; }}