import lessrain.lib.components.mediaplayer07.core.IMediaPlayerFeedable;
import lessrain.lib.components.mediaplayer07.core.Media;

/**
 * @author Oliver List, Less Rain (o.list_at_lessrain.com)
 */
class lessrain.lib.components.mediaplayer07.core.ChunkedVideo implements IMediaPlayerFeedable {

	private var _chunks : Array;

	public function ChunkedVideo() {
	}

	public function addChunk(chunk_ : Media) : Void {
		if(_chunks == null) {
			_chunks = new Array();
		}
		_chunks.push(chunk_);
	}

	public function getChunks() : Array {
		return _chunks;
	}

	public function getMasterType() : String {
		if(_chunks == null || _chunks.length == 0) {
			return null;
		}
		var firstChunk : Media = Media(_chunks[0]);
		if(firstChunk == null) {
			return null;
		}
		return firstChunk.getMaster().type;
	}

	/**
	 * TODO manage which chunk is active. This one simply returns the first
	 * media item
	 */
	public function getCurrentMedia() : Media {
		if(_chunks == null || _chunks.length == 0) {
			return null;
		}
		return Media(_chunks[0]);
	}
}
