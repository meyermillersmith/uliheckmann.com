import lessrain.lib.utils.DateFormat;
import lessrain.lib.utils.graphics.ShapeUtils;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.text.DynamicTextField;

import TextField.StyleSheet;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.lib.utils.logger.Logger
{
	private static var instance:Logger;
	
	/**
	 * @return singleton instance of Logger
	 */
	public static function getInstance() : Logger
	{
		if (instance == null) instance = new Logger();
		return instance;
	}

	/*
	 * Global settings
	 */
	private var _outputDepth:Number;
	private var _enableLogger:Boolean;

	private var _targetMC : MovieClip;
	
	/*
	 * Output methods settings
	 */
	private var _enableTrace:Boolean;
	private var _enableAlert:Boolean;
	private var _enableOutput:Boolean;
	private var _enableLoggerAPI:Boolean;

	private var _traceKeyword:String;
	private var _alertKeyword:String;
	private var _outputKeyword:String;
	private var _apiKeyword:String;
	
	/*
	 * Output window
	 */
	private var _outputMC:MovieClip;
	private var _outputTitleMC:MovieClip;
	private var _outputBgMC:MovieClip;
	private var _outputText:String;
	private var _outputField:DynamicTextField;
	private var _outputStyleSheet:StyleSheet;
	private var _titleField : DynamicTextField;
	private var _titleIcon1 : MovieClip;
	private var _titleIcon2 : MovieClip;
	private var _titleIcon3 : MovieClip;
	private var _outputClearMC : MovieClip;
	private var _outputCloseMC : MovieClip;
	private var _clearField : DynamicTextField;
	private var _copyField : DynamicTextField;
	private var _toggleMC : MovieClip;
	private var _toggleIcon : MovieClip;
	private var _toggleIconBg : MovieClip;
	private var _outputVisible : Boolean;
	
	/*
	 * Dragging
	 */
	private var _mouseOffsetX : Number;
	private var _mouseOffsetY : Number;
	private var _outputX : Number;
	private var _outputY : Number;

	/*
	 * Logger API
	 */
	private var _loggerAPIConnection:LocalConnection;

	/*
	 * Keyboard activation
	 */
	private var _codeWord : String;
	private var _codeMatch : Boolean;

	/*
	 * Status field
	 */
	private var _statusMC : MovieClip;
	private var _statusStyleSheet : StyleSheet;
	private var _statusBg : MovieClip;
	private var _statusField : DynamicTextField;
	private var _statusInterval : Number;
	
	private function Logger()
	{
		_enableLogger=false;
		
		_outputDepth=17273;
		_enableTrace=false;
		_enableAlert=false;
		_enableOutput=false;
		_enableLoggerAPI=false;
		
		_traceKeyword="logger trace";
		_alertKeyword="logger alert";
		_outputKeyword="logger output";
		_apiKeyword="logger api";
		
		_codeWord="";
		
		_outputVisible=false;
	}
	
	public function log( data:Object ):Void
	{
		var msg:String;

		if (data instanceof XML) msg = data.toString();
		else if (data instanceof Array) msg = "Array "+data.toString();
		else if( data instanceof Object )
		{
			msg="Object { ";
			var isFirst:Boolean=true;
			for( var i:String in data )
			{
				if (!isFirst) msg+=", ";
				isFirst=false;
				msg+=i+": "+data[i];
			}
			msg+=" }";
		}
		else msg = String(data);
		
		var dateFormat:DateFormat = new DateFormat();
		var dateStr:String = dateFormat.getDateString("en", DateFormat.MEDIUM, true);
		var timeStr:String = dateFormat.getTimeString("en", DateFormat.LONG, true);
		msg = "["+dateStr+" "+timeStr+"] "+msg;
		
		if (_targetMC==null)
		{
			_targetMC=_root.createEmptyMovieClip( "loggerOutput", _outputDepth );
		}
		
		if (_enableTrace) trace(msg);
		if (_enableAlert) getURL("javascript:alert('"+msg+"')");
		if (_enableOutput) output(msg);
		if (_enableLoggerAPI) sendToAPI(msg);
	}
	
	/*
	 * Output window
	 */
	private function output(msg:String):Void
	{
		if (_outputMC==null) createOutputWindow();
		_outputText+=msg+"<br>";
		_outputField.text=_outputText;
	}
	
	private function createOutputWindow():Void
	{
		var titleHeight:Number = 20;
		var totalHeight:Number = 400;
		
		_outputX=0;
		_outputY=0;
		
		_outputVisible=true;
		
		_outputMC=_targetMC.createEmptyMovieClip( "output", 1 );
		_outputMC._x=_outputX;
		_outputMC._y=_outputY;
		
		_outputBgMC = _outputMC.createEmptyMovieClip("bg",1);
		_outputTitleMC = _outputMC.createEmptyMovieClip("title",2);

		ShapeUtils.drawRectangle( _outputTitleMC,0,0,500,titleHeight,0x000000,60,6,"1100" );
		ShapeUtils.drawRectangle( _outputBgMC,0,titleHeight,500,totalHeight-titleHeight,0xffffff,60,6,"0011" );
		
		_outputText="";
		_outputStyleSheet = new StyleSheet();
		_outputStyleSheet.setStyle(".title", {fontFamily:"_sans",fontSize:"11",color:"#000000",embedFont: "false"});
		_outputStyleSheet.setStyle(".output", {fontFamily:"_sans",fontSize:"10",color:"#000000",embedFont: "false"});
		
		_titleField = DynamicTextField(_outputMC.attachMovie("DynamicTextField", "titleField", 10));
		_clearField = DynamicTextField(_outputMC.attachMovie("DynamicTextField", "clearField", 11));
		_copyField = DynamicTextField(_outputMC.attachMovie("DynamicTextField", "copyField", 12));
		_outputField = DynamicTextField(_outputMC.attachMovie("DynamicTextField", "outputField", 13));
		
		_toggleMC = _outputMC.createEmptyMovieClip("toggle", 15);
		_toggleMC._x=485;
		_toggleMC._y=6;
		_toggleIconBg = _toggleMC.createEmptyMovieClip("toggleIconBg", 1);
		_toggleIcon = _toggleMC.createEmptyMovieClip("toggleIcon", 2);
		ShapeUtils.drawRectangle( _toggleIconBg,0,0,10,10,0xffffff,30,null,null );
		ShapeUtils.drawRectangle( _toggleIcon,2,2,6,2,0xffffff,30 );

		_titleIcon1 = _outputMC.createEmptyMovieClip("titleIcon1", 16);
		ShapeUtils.drawRectangle( _titleIcon1,5,6,6,2,0xffffff,60 );
		_titleIcon2 = _outputMC.createEmptyMovieClip("titleIcon2", 17);
		ShapeUtils.drawRectangle( _titleIcon2,5,9,6,2,0xffffff,60 );
		_titleIcon3 = _outputMC.createEmptyMovieClip("titleIcon3", 18);
		ShapeUtils.drawRectangle( _titleIcon3,5,12,6,2,0xffffff,60 );

		_titleField.direction = DynamicTextField.DIRECTION_LTR;
		_clearField.direction = DynamicTextField.DIRECTION_LTR;
		_copyField.direction = DynamicTextField.DIRECTION_LTR;
		_outputField.direction = DynamicTextField.DIRECTION_LTR;
		_titleField.initialize( "Debug Output", _outputStyleSheet, "title", false, false, 13, 1 );
		_clearField.initialize( "clear", _outputStyleSheet, "title", false, false, 500-100, 1 );
		_copyField.initialize( "copy", _outputStyleSheet, "title", false, false, 500-100+_clearField.textWidth+5, 1 );
		_outputField.initialize( "", _outputStyleSheet, "output", true, false, 0, titleHeight, 500, null,null,totalHeight-titleHeight );
		_titleField.color=0xffffff;
		_clearField.color=0xcccccc;
		_copyField.color=0xcccccc;
		
		_clearField.onRelease = Proxy.create(this, clearOutput);
		_copyField.onRelease = Proxy.create(this, copyOutput);
		_toggleMC.onRelease = Proxy.create(this, toggleOutput);
		
		_outputTitleMC.onMouseDown = Proxy.create(this, startWindowDrag);
		_outputTitleMC.onMouseUp = Proxy.create(this, stopWindowDrag);
	}
	
	private function startWindowDrag():Void
	{
		_mouseOffsetX=_outputTitleMC._xmouse;
		_mouseOffsetY=_outputTitleMC._ymouse;
		if (_outputTitleMC.hitTest(_outputX+_mouseOffsetX, _outputY+_mouseOffsetY,true))
		{
			_mouseOffsetX=_outputTitleMC._xmouse;
			_mouseOffsetY=_outputTitleMC._ymouse;
			_outputTitleMC.onMouseMove = Proxy.create(this, dragWindow);
		}
	}
	
	private function stopWindowDrag():Void
	{
		delete _outputTitleMC.onMouseMove;
		_outputTitleMC.onMouseMove=null;
	}
	
	private function dragWindow():Void
	{
		_outputX=_targetMC._xmouse-_mouseOffsetX;
		_outputY=_targetMC._ymouse-_mouseOffsetY;
		_outputMC._x=_outputX;
		_outputMC._y=_outputY;
	}
	
	private function clearOutput():Void
	{
		_outputText="";
		_outputField.text="";
	}
	
	private function toggleOutput():Void
	{
		_outputVisible=!_outputVisible;
		_outputBgMC._visible=_outputVisible;
		_outputField._visible=_outputVisible;
		
		if (_outputVisible) ShapeUtils.drawRectangle( _toggleIcon,2,2,6,2,0xffffff,30 );
		else ShapeUtils.drawRectangle( _toggleIcon,2,2,6,6,0xffffff,30 );
	}
	
	private function copyOutput():Void
	{
		System.setClipboard(_outputText);
	}
	
	/*
	 * Output API
	 */
	private function sendToAPI(msg:String):Void
	{
		if (_loggerAPIConnection==null) _loggerAPIConnection=new LocalConnection();
		_loggerAPIConnection.send("lc_loggerAPI", "writeMSG", msg);
	}
	
	/*
	 * Toggling through Keyboard input
	 */
	public function onKeyDown():Void
	{
		_codeWord+=String.fromCharCode(Key.getAscii());
		_codeMatch=false;
		
		if ( checkCode(_traceKeyword) )
		{
			_enableTrace=!_enableTrace;
			showStatusMessage( "Trace output "+(_enableTrace?"enabled":"disabled")+"." );
		}
		else if ( checkCode(_alertKeyword) )
		{
			_enableAlert=!_enableAlert;
			showStatusMessage( "Alert output "+(_enableAlert?"enabled":"disabled")+"." );
		}
		else if ( checkCode(_outputKeyword) )
		{
			_enableOutput=!_enableOutput;
			showStatusMessage( "Logger window output "+(_enableOutput?"enabled":"disabled")+"." );
			if (!_enableOutput)
			{
				_outputMC.removeMovieClip();
				_outputMC=null;
			}
		}
		else if ( checkCode(_apiKeyword) )
		{
			_enableLoggerAPI=!_enableLoggerAPI;
			showStatusMessage( "Logger API output "+(_enableLoggerAPI?"enabled":"disabled")+"." );
		}

		if (!_codeMatch) _codeWord="";
	}
	
	private function checkCode(code:String):Boolean
	{
		if ( code.indexOf(_codeWord)!=-1 )
		{
			_codeMatch=true;
			if (_codeWord == code)
			{
				_codeWord="";
				return true;
			}
			else return false;
		}
		else return false;
	}
	
	/*
	 * Status messages
	 */
	private function showStatusMessage(msg:String):Void
	{
		if (_statusMC==null) createStatusOutput();
		
		_statusMC._visible=true;
		_statusField.text=msg;
		ShapeUtils.drawRectangle( _statusBg,0,0,_statusField.textWidth+20,_statusField.textHeight+1,0x000000,60,2 );

		clearInterval(_statusInterval);
		_statusInterval = setInterval(this, "hideStatus", 3000);		
	}
	
	private function createStatusOutput():Void
	{
		_statusMC=_targetMC.createEmptyMovieClip( "status", 2 );
		_statusMC._x=10;
		_statusMC._y=10;
		
		_statusStyleSheet = new StyleSheet();
		_statusStyleSheet.setStyle(".output", {fontFamily:"_sans",fontSize:"11",color:"#ffffff",embedFont: "false"});
		
		_statusBg=_statusMC.createEmptyMovieClip( "bg", 1 );
		_statusField = DynamicTextField(_statusMC.attachMovie("DynamicTextField", "statusField", 10));
		_statusField.direction = DynamicTextField.DIRECTION_LTR;

		_statusField.initialize( "", _statusStyleSheet, "output", false, false, 0, -1 );
	}
	
	private function hideStatus():Void
	{
		clearInterval(_statusInterval);
		_statusMC._visible=false;
	}
	
	/*
	 * Getter/Setter
	 */
	public function get enableLogger():Boolean { return _enableLogger; }
	public function set enableLogger(value:Boolean):Void
	{
		_enableLogger=value;
		if (_enableLogger) Key.addListener(this);
		else Key.removeListener(this);
	}
	
	public function get enableTrace():Boolean { return _enableTrace; }
	public function set enableTrace(value:Boolean):Void { _enableTrace=value; }
	public function get enableAlert():Boolean { return _enableAlert; }
	public function set enableAlert(value:Boolean):Void { _enableAlert=value; }
	public function get enableOutput():Boolean { return _enableOutput; }
	public function set enableOutput(value:Boolean):Void { _enableOutput=value; }
	public function get enableLoggerAPI():Boolean { return _enableLoggerAPI; }
	public function set enableLoggerAPI(value:Boolean):Void { _enableLoggerAPI=value; }
	
	public function get traceKeyword():String { return _traceKeyword; }
	public function set traceKeyword(value:String):Void { _traceKeyword=value; }
	public function get alertKeyword():String { return _alertKeyword; }
	public function set alertKeyword(value:String):Void { _alertKeyword=value; }
	public function get outputKeyword():String { return _outputKeyword; }
	public function set outputKeyword(value:String):Void { _outputKeyword=value; }
	public function get apiKeyword():String { return _apiKeyword; }
	public function set apiKeyword(value:String):Void { _apiKeyword=value; }
	
	public function get outputDepth():Number { return _outputDepth; }
	public function set outputDepth(value:Number):Void { _outputDepth=value; }
}