/**
 * Used to verify that loading an external SWF with the connector component
 * will work without the FlashIDE.
 *
 * This has been tested with the FAME environment on Windows XP Professional running the following:<br/>
 * Flashout 0.7.1.9<br/>
 * ASDT 0.7.1<br/>
 * MTASC 1.7<br/>
 * Eclipse 3.0.1<br/>
 *
 * More information on FAME, MTASC and other open source Flash tools can be found
 * at the <a href="http://osflash.org">OSFlash webite</a>.
 *
 * @author Chris Allen	chris@cnmpro.com
 * @author John Grden johng@acmewebworks.com
 */

//import com.blitzagency.xray.util.Connector;
import com.blitzagency.xray.util.Flashout;
import com.blitzagency.xray.util.XrayLoader;

class com.blitzagency.xray.util.XrayLoadTest extends MovieClip
{
	private var txt:TextField;
	private var si:Number;

	private function XrayLoadTest()
	{
		init();
	}

	/**
	 * Main entry point into the application.
	 */
	static function main():Void
	{
      _root.__proto__ = XrayLoadTest["prototype"];
      XrayLoadTest["apply"](_root,[]);
	}

	/**
	 * The method to run when the Connector.adminToolLoadComplete event is triggered.
	 * Connector.trace, Connector.tt, Connector.tf are setup here to pass arguments to the admintool
	 */
	public function LoadComplete():Void
    {
		var ttExists:Boolean = _global.tt ? true : false;
		var tfExists:Boolean = _global.tf ? true : false;
		var icExists:Boolean = _global.com.blitzagency.xray.Xray.initConnections ? true : false;
		//you can either call AdminTool trace(), tt() and tf() using _global
		//or by using the Static methods of the Connector class
		_global.tt("Xray methods available? - ", "\n_global.tt? ", ttExists, "\n_global.tf?", tfExists);
		TRACE(Flashout.DEBUG + "ttExists :: " + ttExists);
		this.txt.text = "Xray Load Complete :: "+ icExists;
		//this.si = setInterval(this, "fireupXray", 100);
	}
	
	private function fireupXray():Void
	{
		clearInterval(this.si);
		//_global.com.blitzagency.xray.Xray.init();
		_global.com.blitzagency.xray.Xray.initConnections();
		//_global.com.blitzagency.xray.Xray.createFPSMeter();
	}

	private function init():Void 
	{
		buildTextfield();
		initAdminTool();
	}

	/**
	 * Option: Creates text field for displaying messages
	 */
	private function buildTextfield():Void {
		createTextField("txt",0,0,50,250,22);
		txt.text = "Started...";
	}

    private function initAdminTool():Void
    {
    	//Connector.addEventListener("XrayLoadComplete", this);
    	//Connector.loadTool("ConnectorOnly_as2_fp7_OS.swf", this);
    	XrayLoader.addEventListener("LoadComplete", this);
    	XrayLoader.loadConnector("ConnectorOnly_as2_fp7_OS.swf", this, true);
	}
}