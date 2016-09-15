import com.blitzagency.xray.util.XrayLoader;

import lessrain.projects.uliheckmann.core.ApplicationManager;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.lib.utils.logger.LogManager;import lessrain.lib.utils.logger.FirebugLogger;

/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.core.Main
{
	private var _targetMC:MovieClip;
	private var _applicationManager : ApplicationManager;

	public static function main( targetMC_:MovieClip ) : Void
	{
		if (GlobalSettings.getInstance().enableFullscreen) Stage.align="TL";
		else Stage.align="C";

		Stage.scaleMode="noScale";
		Stage.showMenu=false;
		_quality="BEST";
		_root._focusrect=false;

		var app:Main = new Main();
		app.targetMC=targetMC_;
		app.initialize();
	}

	public function Main()
	{
	}

	private function initialize():Void
	{
		if (String(_level0['enableDebugging'])=="true") xray();
		LogManager.getInstance().addLogger(new FirebugLogger());

		_applicationManager = new ApplicationManager(_targetMC.createEmptyMovieClip("app", 1));
		_applicationManager.initialize();
	}

	// Xray Debugging tool
	private function xray() :Void
	{
		var listener:Object = new Object();
		listener['LoadComplete'] = function() {};

		XrayLoader.addEventListener("LoadComplete", listener);
		XrayLoader.loadConnector("xray_connector.swf", _root);
	}

	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
}
