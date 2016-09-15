import mx.utils.Delegate;

import lessrain.lib.utils.logger.AlconLogger;
import lessrain.lib.utils.logger.LogLevel;
import lessrain.lib.utils.logger.LogManager;
import lessrain.lib.utils.logger.TimestampTracer;
import lessrain.lib.utils.logger.XMLSocketLogger;

/**
 * Class LogDemo
 * Example usage of the Logger classes
 *
 * @author Oliver List (o.list@lessrain.com)
 */
class lessrain.lib.utils.logger.LogDemo {

	private var isRunning:Boolean;
	private var button:MovieClip;
	private var int:Number;
	private var num:Number;
	private var bool:Boolean;
	private var obj:Array;
	private var logManager:LogManager;
	private var host:MovieClip;
	

	/**
	 * The constructor
	 *
	 * @param   target The target timeline
	 */
	private function LogDemo(target:MovieClip) {
		logManager = LogManager.getInstance();

		// add different loggers
		//logManager.addLogger(new Tracer());
		logManager.addLogger(new AlconLogger());
		logManager.addLogger(new TimestampTracer());
		var xmlLogger:XMLSocketLogger = new XMLSocketLogger("localhost", 4445);
		xmlLogger.setNesting(10);
		logManager.addLogger(xmlLogger);
		//logManager.addLogger(new JSLogger());
		num = 5;

		this.isRunning = false;
		button = target.attachMovie("button", "button_mc", 1);
		button.onRelease = Delegate.create(this, this.toggleButton);
		
		this.host = target;
		LogManager.watch(this, "num");
	}

	/**
	 * The application's main method. This class is only accessible via this
	 * static main() method.
	 *
	 * @param   Host MovieClip
	 */
	public static function main(host:MovieClip):Void {
		var instance:LogDemo = new LogDemo(host);
	}

	/**
	 * Toggle demo log on/off.
	 */
	private function toggleButton():Void {
		if(isRunning) {
			isRunning = false;
			button.buttonTxt.text = "START LOG";
			clearInterval(int);
		} else {
			isRunning = true;
			button.buttonTxt.text = "STOP LOG";
			clearInterval(int);
			int = setInterval(Delegate.create(this, this.demoLog), 500);
			
		}
	}

	/**
	 * A demo log output
	 */
	private function demoLog():Void {
		
		LogManager.debug("debug message");
		LogManager.info("Info message");
		LogManager.warning("Warn message");
		LogManager.error("Error message");
		
		num ++;
		if(bool == true) bool = false;
		else bool = true;
		
		LogManager.inspectObject({ a: 100, b: "foo", 	c: 
														{a: 50, b: "100", 	obj: 
																			{ a: 100, b: "foo", c: 
																								{a: 50, b: "100", d: 
																												  {a: 100, b: "foo", e: 
																																	 {a: 50, b: "100", f: 
																																					   {a: 100, b: "foo", g: 
																																										  {a: 50, b: "100"}//ende g
																																						, h: ["a", "b", "c"] }//ende f
																																	 }//ende e
																												  , f: ["a", "b", "c"] }//ende d
																								}//ende c
																			, d: ["a", "b", "c"] }//ende obj
														, k: 50}//ende c
									, d: ["a", "b", "c"] }//ende zu inspizierendes Object
									, LogLevel.DEBUG, "obj");
		LogManager.inspectObject(_root, LogLevel.INFO, "_root");
		

	}
}