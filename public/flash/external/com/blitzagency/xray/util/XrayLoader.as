import mx.events.EventDispatcher;
/**
 * A utility class for loading and using the Xray.
 * More information on Xray can be found here:
 * <a href="http://labs.blitzagency.com/?p=52">http://labs.blitzagency.com/?p=52</a>
 *
 * @example <pre>
 import com.blitzagency.xray.util.XrayLoader;
 var listener:Object = new Object();
 listener.xrayLoadComplete = function()
 {
 	Connector.trace("Xray has loaded...");
 }
 Connector.addEventListener("xrayLoadComplete", listener);
 Connector.loadConnector("ConnectorOnly.swf", this);
 </pre>
 *
 * @author Chris Allen	chris@cnmpro.com
 * @author John Grden 	neoRiley@gmail.com
 */
//import Flashout;

class com.blitzagency.xray.util.XrayLoader
{
	private static var connector:MovieClip;
	private static var containerMovie:MovieClip;
	private static var componentSWFPath:String;
	private static var loaded:Boolean;
	private static var fpsMeter:Boolean;

	private static var eventDispatcherDependency:Object = EventDispatcher;
	private static var eventDispatcherInitialized:Boolean = initEventDispatcher();

	public static var addEventListener:Function;
	public static var removeEventListener:Function;
	public static var dispatchEvent:Function;

	/**
	 * An event that is triggered once the xray
	 * connector componet has fully loaded and is ready to use.
	 */
	[Event("xrayLoadComplete")]

	/**
	 * An event that is triggered during the loading process of
	 * the xray connector componet
	 *
	 * @param eventObject Object that contains {percentLoaded:percentLoaded}
	 */
	 [Event("onLoadProgress")]

	/**
	 * An event that is triggered during the loading process of
	 * the xray connector componet
	 *
	 * @param eventObject Object that contains {errorCode:errorCode}
	 */
	 [Event("xrayLoadError")]

	/**
	 * Loads the Xray connector component for use with the Xray interface.
	 *
	 * @param componentSWF 	String 		The relative path to the component SWF.
	 * @param containerClip	MovieClip	The location as to where you want the
	 * 									connector loaded.(default is _root)
	 */
	public static function loadConnector(componentSWF:String, containerClip:MovieClip, showFPS:Boolean):Void
	{
		componentSWFPath = componentSWF;
		containerMovie = !containerClip ? _root : containerClip;
		fpsMeter = showFPS;
		loadXray();
	}

	private static function initEventDispatcher():Boolean
	{
		// initialize the Connector to dispatch events
		EventDispatcher.initialize(XrayLoader);
		return true;
	}

	private static function loadXray():Void
	{
    	var loader:MovieClipLoader = new MovieClipLoader();
    	connector = containerMovie.createEmptyMovieClip("__xrayConnector", containerMovie.getNextHighestDepth());
    	loader.addListener(XrayLoader);
    	loader.loadClip(componentSWFPath, connector);
	}

	/**
	 * onLoadProgress() - dispatches an event everytime this method is called
	 * Create a method in your class called onLoadProgress for use with a custom preloader
	 *
	 * dispatches an object with 2 properties:
	 *
	 * @type: String - event fired ("onLoadProgress")
	 * @percentLoaded: Number - 0 thru 100 representing the downloaded amount
	 */
	private static function onLoadProgress(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void
	{
		var percentLoaded:Number = Math.floor((loadedBytes/totalBytes)*100);

		XrayLoader.dispatchEvent({type:"onLoadProgress", percentLoaded:percentLoaded});
	}

	private static function onLoadInit(targetMC:MovieClip):Void
	{
		// initialize  connections
		
		_global.com.blitzagency.xray.Xray.initConnections();

		if(fpsMeter) _global.com.blitzagency.xray.Xray.createFPSMeter(targetMC);

		//Dispatch Event
		XrayLoader.dispatchEvent({type:"LoadComplete"});
	}

	private static function onLoadComplete(targetMC:MovieClip):Void
	{
		XrayLoader.loaded = true;
		//targetMC._visible = false;
	}

	private static function onLoadError(targetMC:MovieClip, errorCode:String):Void
	{
		XrayLoader.dispatchEvent({type:"LoadError", errorCode:errorCode});
	}
}