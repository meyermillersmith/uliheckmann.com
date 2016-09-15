import lessrain.lib.utils.StringUtils;

class lessrain.projects.uliheckmann.config.GlobalSettings
{
	private static var instance:GlobalSettings;
	
	public static function getInstance():GlobalSettings {
		if (instance==null) {
			instance = new GlobalSettings();
		}
		return instance;
	}
	
	private var _stageWidth:Number;
	private var _stageHeight:Number;
	private var _bgColor:Number;
	private var _buttonBrightOffset:Number;
	private var _contentLeft:Number;
	private var _contentTop:Number;
	private var _encoding:String;
	private var _enableFullscreen:Boolean;
	private var _enableColorFill:Boolean;
	private var _enableIntermediatePage:Boolean;
	private var _enableBlurFade:Boolean;
	private var _waitForMenuFills:Boolean;
	private var _speedUp:Boolean;
	private var _highlightColor:Number;
	private var _defaultFillColor : Number;
	private var _enableLetterTransition : Boolean;
	private var _enableTooltips : Boolean;
	
	private function GlobalSettings()
	{
		var extBgColor:String = StringUtils.checkExternalParameter(_level0.bgColor, "0xffffff");
		_bgColor = Number("0x" + extBgColor.substr(1));
		
		var extHighlightColor:String = StringUtils.checkExternalParameter(_level0.highlightColor, "0xE73F24");
		_highlightColor=Number("0x" + extHighlightColor.substr(1));

		var extButtonBrightOffset:String = StringUtils.checkExternalParameter(_level0.buttonBrightOffset, "255");
		_buttonBrightOffset=Number(extButtonBrightOffset);

		_defaultFillColor=0x000000;
		
		_stageWidth = 990;
		_stageHeight = 700;
		_contentLeft = 50;
		_contentTop = 45;
		_encoding = StringUtils.checkExternalParameter(_level0.encoding, "western");
		_enableFullscreen = true;
		_enableColorFill = true;
		_enableIntermediatePage = false;
		_enableBlurFade = false;
		_enableLetterTransition = false;
		_enableTooltips = true;
		_waitForMenuFills = true;
		_speedUp = false;
	}
	
	public function get stageWidth():Number { return _stageWidth; }
	public function get stageHeight():Number { return _stageHeight; }
	public function get bgColor():Number { return _bgColor; }
	public function get contentLeft():Number { return _contentLeft; }
	public function get contentTop():Number { return _contentTop; }
	public function get encoding():String { return _encoding; }
	public function get enableFullscreen():Boolean { return _enableFullscreen; }
	public function get enableColorFill():Boolean { return _enableColorFill; }
	public function get enableIntermediatePage():Boolean { return _enableIntermediatePage; }
	public function get enableBlurFade():Boolean { return _enableBlurFade; }
	public function get enableLetterTransition():Boolean { return _enableLetterTransition; }
	public function get enableTooltips():Boolean { return _enableTooltips; }
	public function get waitForMenuFills():Boolean { return _waitForMenuFills; }
	public function get speedUp():Boolean { return _speedUp; }
	public function get highlightColor():Number { return _highlightColor; }
	public function get buttonBrightOffset():Number { return _buttonBrightOffset; }
	public function get defaultFillColor():Number { return _defaultFillColor; }
}
