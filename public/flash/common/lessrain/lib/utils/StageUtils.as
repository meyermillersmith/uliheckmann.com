import mx.events.EventDispatcher;

class lessrain.lib.utils.StageUtils
{
	// required for EventDispatcher:
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private static var instance:StageUtils;
	
	static function getInstance():StageUtils
	{
		if (instance==null) instance = new StageUtils();
		return instance;
	}
	
	private function StageUtils()
	{
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		Stage.addListener(this);
		this.onResize();
		EventDispatcher.initialize(this);
	}
	
	public function onResize()
	{
		dispatchEvent({type:"onRedrawContent", target:this});
	}
}