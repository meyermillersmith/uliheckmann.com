import lessrain.lib.utils.assets.Label;
import lessrain.lib.utils.geom.Coordinate;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.PriorityLoader;
import lessrain.lib.utils.loading.QueueListener;
import lessrain.projects.uliheckmann.effects.Letter;
import lessrain.projects.uliheckmann.effects.Word;
import lessrain.projects.uliheckmann.header.TextButton;
import lessrain.projects.uliheckmann.config.GlobalSettings;
import lessrain.projects.uliheckmann.utils.GlobalFunctions;
import lessrain.lib.utils.loading.GroupLoaderProgressProxy;
import lessrain.lib.utils.loading.GroupLoaderEvent;
import lessrain.lib.utils.Proxy;
/**
 * @author Thomas Meyer, Less Rain (thomas@lessrain.com)
 */
class lessrain.projects.uliheckmann.header.LoadingDisplay implements QueueListener
{
	private static var displayThreshold:Number = 80;
	
	private var _targetMC:MovieClip;
	private var _progressPos : Coordinate;
	private var _progressField : TextButton;
	private var _loading : Word;

	private var _loadingPrefix : String;
	
	public function LoadingDisplay(targetMC:MovieClip)
	{
		_targetMC=targetMC;
	}
	public function initialize() : Void
	{
		_loading = new Word( _targetMC.createEmptyMovieClip("loading",1), Label.getLabel("Loading.loading"), 0,0);
		_loading.initialize();
		_loading.setState(Letter.STATE_ANTS);
		
		PriorityLoader.getInstance().addEventListener("onFileStart", this);
		PriorityLoader.getInstance().addEventListener("onFileProgress", this);
		PriorityLoader.getInstance().addEventListener("onFileComplete", this);
		
		GroupLoaderProgressProxy.getInstance().addEventListener(GroupLoaderEvent.GROUP_START, Proxy.create(this, onGroupStart));
		GroupLoaderProgressProxy.getInstance().addEventListener(GroupLoaderEvent.GROUP_PROGRESS, Proxy.create(this, onGroupProgress));
		GroupLoaderProgressProxy.getInstance().addEventListener(GroupLoaderEvent.GROUP_COMPLETE, Proxy.create(this, onGroupComplete));
		
		if (GlobalSettings.getInstance().enableFullscreen)
		{
			onResize();
			Stage.addListener(this);
		}
	}
	
	private function onResize():Void
	{
		_targetMC._x = GlobalFunctions.getCenterStageX()+GlobalSettings.getInstance().contentLeft;
		_targetMC._y = GlobalFunctions.getCenterStageY()+GlobalSettings.getInstance().contentTop;
	}

	public function setProgressField(progressField_ : TextButton) : Void
	{
		_progressField = progressField_;
	}
	
	private function getCounterString(percent:Number):String
	{
		var percentStr:String = Number(percent).toString();
		while (percentStr.length<3) percentStr="0"+percentStr;
		return percentStr;
	}
	
	private function start(description_:String):Void
	{
		if (description_==null) _loadingPrefix="";
		else _loadingPrefix = description_.toLowerCase()+" ";
		_loading.setState(Letter.STATE_ANTS);
		_progressField.setText( getCounterString( 0 ));
		_progressField.show();
	}
	
	private function complete(description_:String):Void
	{
		_loading.setState(Letter.STATE_INVISIBLE);
		_progressField.hide();
	}
	
	private function progress(percent_:Number):Void
	{
		if (percent_!=null && !isNaN(percent_)) _progressField.setText( _loadingPrefix+getCounterString( Math.max(0,percent_) )+"%");
	}

	/*
	 * GroupListener methods
	 */
	public function onGroupStart(event: GroupLoaderEvent) : Void
	{
		start(event.description);
	}

	public function onGroupComplete(event: GroupLoaderEvent) : Void
	{
		complete(event.description);
	}

	public function onGroupProgress(event: GroupLoaderEvent) : Void
	{
		progress(event.percent);
	}


	/*
	 * QueueListener methods
	 */
	public function onFileStart(eventObject : Object) : Void
	{
		var file:FileItem = eventObject.file;
		if (file.priority>=displayThreshold) start(file.description);
	}

	public function onFileComplete(eventObject : Object) : Void
	{
		var file:FileItem = eventObject.file;
		if (file.priority>=displayThreshold) complete(file.description);
	}

	public function onFileProgress(eventObject : Object) : Void
	{
		var file:FileItem = eventObject.file;
		if (file.priority>=displayThreshold) progress(parseInt(eventObject.percent));
	}

	/*
	 * Don't need these QueueListener methods
	 */
	public function onQueueStart() : Void {
	}

	public function onQueueComplete() : Void {
	}

	public function onQueueProgress(eventObject : Object) : Void {
	}
	
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }

}