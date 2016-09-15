/**
 * KillerBeacon, version 1
 * @class:   KillerBeacon
 * @author:  lessrain
 * @version: 1.0
 * -----------------------------------------------------
 *   Functions:
 *            1.  killerBeacon (Object)
 *            1.  skew (MovieClip, MovieClip, Number, String)
 *  *  ----------------------------------------------------
 */
 
import lessrain.lib.utils.DepthManager;

class lessrain.lib.utils.MovieClipUtils

{
	
	
	/* 1. killerBeacon --------------------------------
	
	 * removes from the stage TextFields that were not created with createTextField() 
	   or movie clip instances that were not created with duplicateMovieClip(), 
	   MovieClip.duplicateMovieClip(), or MovieClip.attachMovie()
	   
	   USAGE:
	   		var killer=MovieClipUtils.killerBeacon(myTextField);
	   
     */
	 
	public static function killerBeacon (o:Object):Void
	{
		var dm:DepthManager = DepthManager.getInstance ();
		var target:MovieClip = o._parent;
		var nextDepth:Number=dm.getNextDepth (target);
		var tempKiller:MovieClip = target.createEmptyMovieClip ('killer', nextDepth);
		
		tempKiller.swapDepths (o);
	
		if(typeof (o) == 'movieclip'){
			o.removeMovieClip ();
		}else{
			 o.removeTextField ();
		}
		
		// remove killer mc
		tempKiller.swapDepths (nextDepth);
		tempKiller.removeMovieClip ();
	}
	
	
	// taken and adapted from Alex Uhlmanns Animation package
	// http://www.alex-uhlmann.de/flash/animationpackage/index.htm
	public static function skew(target:MovieClip, innerTarget:MovieClip, degrees:Number, type:String)
	{
		var h_skew:Number;
		var v_skew:Number;
		if(type == "h")
		{
			h_skew = degrees;
			v_skew = 0;	
		}
		else if (type == "v")
		{
			h_skew = 0;
			v_skew = degrees;			
		}

		if (innerTarget._parent!=target)
		{
			trace("The MovieClip \"target\" has to be the _parent of \"innerTarget\". Cannot perform skew in lessrain.lib.utils.MovieClipUtils.");
			return;
		}
		
		var x0:Number = target._x;
		var y0:Number = target._y;
		var x_offset:Number = 0;
		var y_offset:Number = 0;
		
		//nacho@yestoall.com (http://flashAPI.yestoall.com) and Andres Sebastian Yañez Duran (lifaros@yahoo.com)
		innerTarget._x = 0.5*Math.SQRT2*(-x_offset-y_offset);
		innerTarget._y = 0.5*Math.SQRT2*(x_offset-y_offset);
		innerTarget._rotation = -45;
		target._rotation = 45+(h_skew+v_skew)/2;	
		target._yscale = Math.sin((90+h_skew-v_skew)*0.5*(Math.PI/180))*Math.SQRT2*100;
		target._xscale = Math.cos((90+h_skew-v_skew)*0.5*(Math.PI/180))*Math.SQRT2*100;
		target._x = x0 + x_offset;
		target._y = y0 + y_offset;
	}
	
	public static function addChildAt(target_ : MovieClip, name_ : String, depth_:Number) : MovieClip
	{
		return target_.createEmptyMovieClip(name_,depth_);
	}
	
	public static function addChildFromLibrary(target_ : MovieClip, name_ : String, depth_:Number) : MovieClip
	{
		return target_.attachMovie(name_,name_,depth_);
	}
}
