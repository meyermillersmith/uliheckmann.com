
/**
 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.Media;

interface lessrain.lib.components.mediaplayer07.core.IMediaPlayerFeedable {
	function getMasterType() : String;
	function getCurrentMedia():Media;
}
