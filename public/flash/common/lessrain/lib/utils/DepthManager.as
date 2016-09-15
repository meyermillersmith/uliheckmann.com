/**
******************************************

* based on <a href="http://proto.layer51.com/d.aspx?f=833">Fernando Flórez</a> getNextDepth  AS1 prototype

@class (SINGLETON): DepthManager

@author: luis@lessrain.com

PUBLIC METHODS
getNextDepth
getInstance

@usage:

var dm:DepthManager = DepthManager.getInstance ();
createEmptyMovieClip ("one", 2);
createEmptyMovieClip ("two", dm.getNextDepth (this));
trace ("the next free depth is: " + dm.getNextDepth (this));

******************************************
*/

class lessrain.lib.utils.DepthManager
{
	private static var _oInstance:DepthManager = null;
	
	private function DepthManager ()
	{
	}
	
	public static function getInstance ():DepthManager
	{
		if (_oInstance == null) {
			DepthManager._oInstance = new DepthManager ();
		}
		return DepthManager._oInstance;
	}
	
	public function getNextDepth (mClip:MovieClip):Number
	{
		var t:Number = -Infinity;

		for (var i:String in mClip) {
			if (mClip[i].getDepth () != null && mClip[i]._parent == mClip) {
				t = Math.max (t, mClip[i].getDepth ());
			}
		}
		return (t > -1) ? ++t : 0;
	}
	
}
