﻿/** * @author Thomas Meyer, Less Rain (thomas@lessrain.com) */class lessrain.projects.uliheckmann.header.PageFrame{	private var _targetMC:MovieClip;	private var _topMC : MovieClip;	private var _leftMC : MovieClip;	private var _rightMC : MovieClip;	private var _bottomMC : MovieClip;		public function PageFrame(targetMC_:MovieClip)	{		_targetMC=targetMC_;	}		public function initialize():Void	{		_topMC = _targetMC.attachMovie("HeaderGradient","top",1);		_leftMC = _targetMC.attachMovie("HeaderGradient","left",2);		_rightMC = _targetMC.attachMovie("HeaderGradient","right",3);		_bottomMC = _targetMC.attachMovie("HeaderGradient","bottom",4);				onResize();		Stage.addListener(this);	}	public function finalize():Void	{		_targetMC.removeMovieClip();	}		private function onResize():Void	{		_topMC._width = Stage.width;				_leftMC._rotation=0;		_leftMC._width = Stage.height;		_leftMC._rotation=-90;		_leftMC._x=-_leftMC._width/2;		_leftMC._y=Stage.height;				_rightMC._rotation=0;		_rightMC._width = Stage.height;		_rightMC._rotation=90;		_rightMC._x=Stage.width+_rightMC._width/2;				_bottomMC._width = Stage.width;		_bottomMC._y=Stage.height+_bottomMC._width/2;		_bottomMC._yscale=-100;	}		public function get targetMC():MovieClip { return _targetMC; }	public function set targetMC(value:MovieClip):Void { _targetMC=value; }}