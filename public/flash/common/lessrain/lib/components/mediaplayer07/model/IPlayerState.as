/**
 * State pattern used by AbstractMediaPlayer
 * 
 * @author Oliver List, Less Rain (o.list@lessrain.com)
 */
interface lessrain.lib.components.mediaplayer07.model.IPlayerState {
	
	/**
	 * Trigger player's play method
	 */
	public function doPlay():Void;
	
	/**
	 * Trigger player's pause method
	 */
	public function doPause():Void;
	
	/**
	 * Trigger player's resume method
	 */
	public function doResume():Void;
	
	/**
	 * Trigger player's stop method
	 */
	public function doStop():Void;
}