/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.geom.Alignment
{
	public static var TL:Number = 1;
	public static var T:Number = 2;
	public static var TR:Number = 3;
	public static var L:Number = 4;
	public static var C:Number = 5;
	public static var R:Number = 6;
	public static var BL:Number = 7;
	public static var B:Number = 8;
	public static var BR:Number = 9;
	
	public static function parseAlignment( align_:String ):Number
	{
		switch (align_)
		{
			case "TL": return TL;
			case "T": return T;
			case "TR": return TR;
			case "L": return L;
			case "C": return C;
			case "R": return R;
			case "BL": return BL;
			case "B": return B;
			case "BR": return BR;
		}
	}
}