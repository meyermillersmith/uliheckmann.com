
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
import lessrain.lib.utils.assets.Label;

import flash.geom.Point;
import flash.geom.Matrix;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.display.BitmapData;

import lessrain.lib.utils.assets.StyleSheet;
import lessrain.lib.utils.text.DynamicTextField;

class lessrain.projects.uliheckmann.effects.LetterMask 
{
	private static var ZERO_POINT : Point = new Point(0, 0);
	private static var OUTLINE_GLOW_FILTER : GlowFilter = new GlowFilter(0xffffff, 100, 1.05, 1.05, 255, 1, true, true);

	private var _targetMC : MovieClip;
	private var _letter : String;
	private var _shapeBitmap : BitmapData;
	private var _antsBitmap : BitmapData;
	private var _isAlphabeticalLetter : Boolean;
	private var _char : String;

	public function LetterMask( targetMC_ : MovieClip, letter_ : String )
	{
		_targetMC = targetMC_;
		_letter = letter_.toLowerCase();
	}

	public function create() : Void
	{
		if (_letter == "world")
		{
			_isAlphabeticalLetter = false;
			createFromLibrary();
		}
		else if (_letter.indexOf("round") >= 0)
		{
			_isAlphabeticalLetter = false;
			createFromLibrary();
		}
		else if (_letter.indexOf("menu") >= 0)
		{
			_isAlphabeticalLetter = false;
			createFromLibrary();
		}
		else if (_letter.indexOf("arrow") >= 0)
		{
			_isAlphabeticalLetter = true;
			
			switch (_letter)
			{
				case "arrow_left":
					_char = "&lt;";
					break;
				case "arrow_right":
					_char = "&gt;";
					break;
				case "arrow_up":
					_char = "&circ;";
					break;
				case "arrow_down":
					_char = "&darr;";
					break;
			}
			createFromTextField();
		}
		else
		{
			_isAlphabeticalLetter = true;
			_char = _letter.toUpperCase();
			createFromTextField();
		}
	}

	private function createFromLibrary() : Void
	{
		_shapeBitmap = BitmapData.loadBitmap(_letter + "_s.png");
		_antsBitmap = BitmapData.loadBitmap(_letter + "_o.png");
	}

	private function createFromTextField() : Void
	{
		var letterStyle : String = _level0.letterStyle;
		if (letterStyle == null || letterStyle == "") letterStyle = "letterDIN";
		
		var _tf : DynamicTextField = new DynamicTextField(_targetMC.createEmptyMovieClip("letterShape", 2));
		_tf.initialize(_char, StyleSheet.getStyleSheet("main"), letterStyle, false, false, 0, 0);
		
		var transformMatrix : Matrix;
		var scale:Number = parseFloat(Label.getLabel("Setting.Letter.Scale"));

		transformMatrix = new Matrix();
		transformMatrix.scale(scale, scale);
		
		var tmpBitmap : BitmapData = new BitmapData(_targetMC._width*scale, _targetMC._height*scale, true, 0x00000000);
		tmpBitmap.draw(_targetMC, transformMatrix);
		
		var contentRect : Rectangle = tmpBitmap.getColorBoundsRect(0xFF000000, 0x00000000, false);
		
		transformMatrix = new Matrix();
		transformMatrix.translate(-contentRect.x, -contentRect.y);
		
		_shapeBitmap = new BitmapData(contentRect.width, contentRect.height, true, 0x00000000);
		_shapeBitmap.draw(tmpBitmap, transformMatrix);
		
		_antsBitmap = new BitmapData(contentRect.width, contentRect.height, true, 0x00000000);
		_antsBitmap.applyFilter(_shapeBitmap, _shapeBitmap.rectangle, ZERO_POINT, OUTLINE_GLOW_FILTER);

		_targetMC.removeMovieClip();
	}

	public function getLetter() : String
	{
		return _letter;
	}

	public function getShapeBitmap() : BitmapData
	{
		return _shapeBitmap.clone();
	}

	public function getAntsBitmap() : BitmapData
	{
		return _antsBitmap.clone();
	}
}
