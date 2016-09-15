class lessrain.lib.utils.animation.easing.Linear {
	// t: delta time
	// b: start value
	// c: full delta value
	// d: overall duration
	static function easeNone (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
	static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
	static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
	static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
}
