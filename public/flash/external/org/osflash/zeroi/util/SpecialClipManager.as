/**
 * @author Ralf Bokelberg <ralf.bokelberg@gmail.com>
 * @license LGPL
 * 
 */
class org.osflash.zeroi.util.SpecialClipManager {
	
	
	public static var MANAGER_DEPTH:Number = 172334;
	
	private static var instance:SpecialClipManager;
	
	public static function getInstance():SpecialClipManager{
		if( instance == null){
			instance = new SpecialClipManager( _level0.createEmptyMovieClip("__SpecialClipManager__", MANAGER_DEPTH));
		}
		return instance;
	}
	
	
	
	
	private var base:MovieClip;
	
	public function SpecialClipManager( base:MovieClip){
		initBase( base);
	}
	
	public function createEmptyMovieClip( optionalName:String, optionalDepth:Number):MovieClip{
		if( optionalDepth == undefined){
			optionalDepth = base.getNextHighestDepth();
		}
		if( optionalName == undefined){
			optionalName = "mc" + optionalDepth;
		}
		return base.createEmptyMovieClip( optionalName, optionalDepth); 
	}
	
	private function initBase( base:MovieClip):Void{
		this.base = base;
		base.onUnload = function(){
			trace("WARNING: SpecialClipManager: base mc unloaded.");
		};
	} 
	
	
}