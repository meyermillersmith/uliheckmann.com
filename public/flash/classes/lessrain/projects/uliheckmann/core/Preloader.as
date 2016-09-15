import lessrain.lib.utils.assets.IPreloadListener;
import lessrain.lib.utils.assets.SitePreloader;
import lessrain.lib.utils.Proxy;
import lessrain.lib.utils.tween.TweenEvent;
import lessrain.lib.utils.tween.TweenTimer;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.core.Preloader implements IPreloadListener
{
	private var _sitePreloader : SitePreloader;
	private var _targetMC:MovieClip;
	private var _mainMC : MovieClip;
	private var _assetsSrc : String;
	private var _pathPrefix : String;

	private var _animationTween : TweenTimer;
	private var _progressTween : TweenTimer;

	private var _isShowing : Boolean;
	
	public static function main( targetMC_:MovieClip ) : Void
	{
		if (GlobalSettings.getInstance().enableFullscreen) Stage.align="TL";
		else Stage.align="C";
		
		Stage.scaleMode="noScale";
		Stage.showMenu=false;
		_quality="BEST";
		_root._focusrect=false;
		
		var app:Preloader = new Preloader();
		app.targetMC=targetMC_;
		app.initialize();
	}
	
	public function Preloader()
	{
	}
	
	private function initialize():Void
	{
		_targetMC.preloader._alpha=0;
		
		_isShowing=true;
		_targetMC.progress._x=GlobalSettings.getInstance().contentLeft;
		_targetMC.progress._y=GlobalSettings.getInstance().contentTop;
		_animationTween = new TweenTimer();
		_animationTween.tweenTarget=_targetMC.animation;
		_animationTween.tweenDuration = 500;
		_animationTween.setTweenProperty("_alpha",0,100);
		_animationTween.addEventListener(TweenEvent.TWEEN_COMPLETE,Proxy.create(this, tweenComplete));
		
		//_animationTween.start();
		tweenComplete();
		
		_targetMC.progress.tf.text=getCounterString( 0 )+" %";
		_targetMC.progress.tf.textColor=GlobalSettings.getInstance().highlightColor;
		_targetMC.progress._x=71;
		_targetMC.progress._y=12;
		_progressTween = new TweenTimer();
		_progressTween.tweenTarget=_targetMC.progress;
		_progressTween.tweenDuration = 500;
		_progressTween.setTweenProperty("_alpha",0,100);
		_progressTween.start(200);
		
		if (GlobalSettings.getInstance().enableFullscreen)
		{
			onResize();
			Stage.addListener(this);
		}
	}
	
	private function onResize():Void
	{
		_targetMC.progress._x = GlobalFunctions.getCenterStageX()+GlobalSettings.getInstance().contentLeft-4;
		_targetMC.animation._x = GlobalFunctions.getCenterStageX()+GlobalSettings.getInstance().contentLeft;
		_targetMC.animation._y = GlobalFunctions.getCenterStageY()+GlobalSettings.getInstance().contentTop;
	}
	
	private function tweenComplete(tweenEvent:TweenEvent):Void
	{
		if (_isShowing) startPreloading();
		else endPreloading();
	}
	
	private function startPreloading():Void
	{
		_assetsSrc = checkExternalParameter( _level0.assetsSrc, "../../data/en/assets.xml" );
		_mainMC = _targetMC.createEmptyMovieClip("main",1);
		_sitePreloader = new SitePreloader( _assetsSrc, _mainMC, this);
		_sitePreloader.start();
	}
	
	private function endPreloading():Void
	{
		_targetMC.animation.swapDepths(100);
		_targetMC.animation.removeMovieClip();
		_animationTween.destroy();
		_animationTween=null;
		
		_targetMC.progress.swapDepths(100);
		_targetMC.progress.removeMovieClip();
		_progressTween.destroy();
		_progressTween=null;
		
		_mainMC.gotoAndStop(2);
	}
	
	private function checkExternalParameter (input:String, defaultValue:String):String
	{
		if (input == null || input == "") return defaultValue;
		else return input;
	}
	
	private function getCounterString(percent:Number):String
	{
		var percentStr:String = Number(percent).toString();
		while (percentStr.length<3) percentStr="0"+percentStr;
		return percentStr;
	}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function onPreloadComplete() : Void
	{
		_isShowing=false;
		_animationTween.reset();
		_animationTween.setTweenProperty("_alpha",_targetMC.animation._alpha,0);
		//_animationTween.start(500);
		tweenComplete();
		
		_progressTween.reset();
		_progressTween.setTweenProperty("_alpha",_targetMC.progress._alpha,0);
		_progressTween.start();
	}

	public function onPreloadProgress(filesLoaded : Number, filesTotal : Number, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void
	{
		_targetMC.progress.tf.text="LOADING "+getCounterString( Math.round(percent) )+" %";
		//_targetMC.preloader.gotoAndPlay( Math.round(percent)+1 );
	}
}