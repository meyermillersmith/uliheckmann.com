class lessrain.lib.utils.animation.easing.Aqua {
	// t: delta time
	// b: start value
	// c: full delta value
	// d: overall duration
	private static var amplitudeConstant:Number = Math.atan( 10 );
	
	static function easeNone (t:Number, b:Number, c:Number, d:Number):Number {
		var amplitudeFactor:Number = 1-(Math.atan( (t/d)*10 ) / amplitudeConstant);
		return b+c - Math.cos( (t/d) *4*Math.PI ) * amplitudeFactor * c ;
	}
}
