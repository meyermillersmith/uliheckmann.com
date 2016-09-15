﻿import flash.display.BitmapData;import flash.geom.Point;import flash.geom.Rectangle;import lessrain.lib.utils.events.EventDistributor;import lessrain.lib.utils.events.IDistributor;import lessrain.lib.utils.events.IEvent;import lessrain.lib.utils.Proxy;import lessrain.projects.uliheckmann.effects.Letter;import lessrain.projects.uliheckmann.effects.WordEvent;/** * @author Thomas Meyer, Less Rain (thomas@lessrain.com) */class lessrain.projects.uliheckmann.effects.Word implements IDistributor{	private var _targetMC : MovieClip;	private var _wordStr : String;	private var _letters : Array;	private var _width : Number;	private var _height : Number;	private var _bitmapOffsetX : Number;	private var _bitmapOffsetY : Number;	private var _eventDistributor : EventDistributor;	public function Word(targetMC_ : MovieClip, wordStr_ : String, bitmapOffsetX_ : Number, bitmapOffsetY_ : Number )	{		_targetMC = targetMC_;		_wordStr = wordStr_;		_bitmapOffsetX = bitmapOffsetX_;		_bitmapOffsetY = bitmapOffsetY_;		_eventDistributor = new EventDistributor();		_eventDistributor.initialize(this);	}	public function initialize() : Void	{		_letters = new Array();		var letter : Letter;		var character : String;		var isLastLetter : Boolean;				_width = 0;		_height = 0;		for (var i : Number = 0;i < _wordStr.length; i++)		{			character = _wordStr.charAt(i);			if (character == " ") _width += Letter.SPACE_WIDTH + Letter.LETTER_SPACING;			else			{				isLastLetter = (i == _wordStr.length - 1);				letter = new Letter(_targetMC.createEmptyMovieClip("letter_" + i, 10 + i), character, _width, 0, i, isLastLetter);				if (isLastLetter) letter.addEventListener(WordEvent.STATE_COMPLETE, Proxy.create(this, onStateComplete));				letter.initialize();				letter.fillRect = new Rectangle(_bitmapOffsetX + letter.x, _bitmapOffsetY + letter.y, letter.width, letter.height);				_width += letter.width;				if (i < _wordStr.length - 1) _width += Letter.LETTER_SPACING;				_height = Math.max(_height, letter.height);				_letters.push(letter);			}		}		_height += Letter.LINE_SPACING;	}	public function setPos(x_ : Number, y_ : Number) : Void	{		_targetMC._x = x_;		_targetMC._y = y_;	}	public function setFill(id_ : String) : Void	{		var letter : Letter;		for (var i : Number = _letters.length - 1;i >= 0; i--)		{			letter = _letters[i];			letter.setFill(id_);		}	}	public function setState(state_ : Number) : Void	{		for (var i : Number = _letters.length - 1;i >= 0; i--) Letter(_letters[i]).setState(state_);	}	public function setMode(mode_ : Number) : Void	{		for (var i : Number = _letters.length - 1;i >= 0; i--) Letter(_letters[i]).mode = mode_;	}	public function addFill(id_ : String, fillBitmap_ : BitmapData) : Void	{		var bmp : BitmapData;		var letter : Letter;		var basePoint : Point = new Point();		for (var i : Number = _letters.length - 1;i >= 0; i--)		{			letter = _letters[i];			bmp = new BitmapData(letter.fillRect.width, letter.fillRect.height, true);			bmp.copyPixels(fillBitmap_, letter.fillRect, basePoint);			letter.addFill(id_, bmp);			bmp.dispose();		}	}	private function onStateComplete(wordEvent : WordEvent) : Void	{		distributeEvent(wordEvent);	}	public function finalize() : Void	{		for (var i : Number = _letters.length - 1;i >= 0; i--) Letter(_letters[i]).finalize();		delete _letters;		_eventDistributor.finalize();		_targetMC.removeMovieClip();	}	public function addEventListener(type : String, func : Function) : Void 	{	}	public function removeEventListener(type : String, func : Function) : Void 	{	}	public function distributeEvent(eventObject : IEvent) : Void 	{	}	public function get targetMC() : MovieClip 	{ 		return _targetMC; 	}	public function set targetMC(value : MovieClip) : Void 	{ 		_targetMC = value; 	}	public function get height() : Number 	{ 		return _height; 	}	public function get width() : Number 	{ 		return _width; 	}	public function get x() : Number	{ 		return _targetMC._x; 	}	public function set x(value : Number) : Void 	{ 		_targetMC._x = value; 	}	public function get y() : Number 	{ 		return _targetMC._y; 	}	public function set y(value : Number) : Void 	{ 		_targetMC._y = value; 	}	public function get bitmapOffsetX() : Number 	{ 		return _bitmapOffsetX; 	}	public function set bitmapOffsetX(value : Number) : Void 	{ 		_bitmapOffsetX = value; 	}	public function get bitmapOffsetY() : Number 	{ 		return _bitmapOffsetY; 	}	public function set bitmapOffsetY(value : Number) : Void 	{ 		_bitmapOffsetY = value; 	}}