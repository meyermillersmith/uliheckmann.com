/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import lessrain.lib.components.mediaplayer07.core.IMediaPlayerFeedable;
import lessrain.lib.components.mediaplayer07.core.Bandwidth;
import lessrain.lib.components.mediaplayer07.core.DataFile;

class lessrain.lib.components.mediaplayer07.core.Media implements IMediaPlayerFeedable {
	/*
	 * Getter & setter
	 */
	private var _id:String;
	private var _files:Array;
	private var _caption:String;
	private var _copyright:String;
	private var _description:String;

	/**
	 * Easily create a video media item withput reading and parsing an XML that
	 * contains the media definition.
	 * Note that the created item does not contain any advanced information such
	 * as a preview, a downloadable file or a thumbnail.
	 * 
	 * @param	src_	Path to the FLV
	 * @param	w_		Video width
	 * @param	h_		Video height
	 * @return			Video media item 
	 */	
	public static function createSimpleVideo(src_:String, w_:Number, h_:Number):Media {
		var media:Media = new Media();
		var data:DataFile = new DataFile();
		data.w = w_;
		data.h = h_;
		data.role = DataFile.ROLE_MASTER;
		data.type = DataFile.TYPE_VIDEO;
		data.src = src_;
		media.addFile(data);
		return media;
	}
	
	/**
	 * Easily create an audio media item without reading and parsing an XML that
	 * contains the media definition.
	 * Note that the created item does not contain any advanced information such
	 * as a preview, a downloadable file or a thumbnail.
	 * 
	 * @param	src_		Path to the audio file
	 * @param	duration_	Duartion of the audio file [s]
	 * @return				Audio media item 
	 */	
	public static function createSimpleAudio(src_:String, duration_:Number):Media {
		var media:Media = new Media();
		var data:DataFile = new DataFile();
		data.duration = duration_;
		data.role = DataFile.ROLE_MASTER;
		data.type = DataFile.TYPE_AUDIO;
		data.src = src_;
		media.addFile(data);
		return media;
	}
	
	public function Media()
	{
		_files = [];
		_id = null;
		_caption = "";
		_copyright = "";
	}
	
	/*
	 * Add a file to this Media
	 * @param	file : DataFile
	 */
	public function addFile( file:DataFile ) :Void
	{
		_files.push( file );
	}
	
	/*
	 * Returns the first DataFile which is a Master
	 * @return master : DataFile
	 */
	public function getMaster(bandwidth_:Bandwidth) :DataFile
	{		
		var bandwidth:Bandwidth = bandwidth_ || Bandwidth.HIGH;
		var masters:Array = getFilesByRole(DataFile.ROLE_MASTER);
		for(var i:Number = 0; i < masters.length; i++) {
			var file:DataFile = DataFile(masters[i]);
			if(file.bandwidth == bandwidth) {
				return file;
			}
		}
		return null;
	}
	
	/*
	 * Returns the first DataFile which is a Thumbnail
	 * @return thumbnail : DataFile
	 */
	public function getThumbnail() :DataFile
	{		
		for (var i : Number = 0; i < _files.length; i++)
		{
			if (DataFile(_files[i]).role == DataFile.ROLE_THUMBNAIL)
				return DataFile(_files[i]);
		}
		return null;
	}
	
	/*
	 * Returns the first DataFile which is a Preview
	 * @return preview : DataFile
	 */
	public function getPreview() :DataFile
	{		
		for (var i : Number = 0; i < _files.length; i++)
		{
			if (DataFile(_files[i]).role == DataFile.ROLE_PREVIEW)
				return DataFile(_files[i]);
		}
		return null;
	}
	
	/*
	 * Returns a specific file of this Media
	 * @param	type	, f.e. Image, Video, Audio, Flash, Archive
	 * @param	role	, f.e. Thumbnail, Preview, Master, Download
	 * @return 	datafile : DataFile
	 */
	public function getFile( type:String, role:String ) :DataFile
	{
		for (var i : Number = 0; i < _files.length; i++)
		{
			if (DataFile(_files[i]).type == type && DataFile(_files[i]).role == role) 
				return DataFile(_files[i]);
		}
		return null;
	}
	
	/*
	 * Returns an array of files with specific type and role in this Media
	 * @param	type	, f.e. Image, Video, Audio, Flash, Archive
	 * @param	role	, f.e. Thumbnail, Preview, Master, Download
	 * @return  Array	, an Array of DataFiles
	 */
	public function getFilesByTypeAndRole( type:String, role:String ) :Array
	{
		var a:Array = [];
		for (var i : Number = 0; i < _files.length; i++)
		{
			if (DataFile(_files[i]).type == type && DataFile(_files[i]).role == role)
				a.push( DataFile(_files[i]) );
		}
		return a;
	}
	
	/*
	 * Returns an array of files with a specific role in this Media
	 * @param	role	, f.e. Thumbnail, Preview, Master, Download
	 * @return  Array	, an Array of DataFiles
	 */
	public function getFilesByRole(role:String ) :Array
	{
		var a:Array = [];
		for (var i : Number = 0; i < _files.length; i++)
		{
			if (DataFile(_files[i]).role == role)
				a.push( DataFile(_files[i]) );
		}
		return a;
	}
	
	public function getVideoMasterByBandwidth(bandWidth_:String):DataFile {
		var masters:Array = getFilesByTypeAndRole(DataFile.TYPE_VIDEO, DataFile.ROLE_MASTER);
		for(var i:Number = 0; i < masters.length; i++) {
			var file:DataFile = DataFile(masters[i]);
			if(file.bandwidth == bandWidth_) {
				return file;
			}
		}
		return null;
	}
	
	/**
	 * Clone
	 */
	public function clone() :Media
	{
	 	var clone:Media = new Media();
	 	clone.id 		= _id;
	 	clone.copyright = _copyright;
	 	clone.caption 	= _caption;
	 	
	 	for (var i : Number = 0; i < _files.length; i++) {
	 		clone.addFile( DataFile(_files[i]).clone() );
	 	}

	 	return clone;
	}
	
	public function getMasterType():String {
		return getMaster().type;
	}
	
	
	public function getCurrentMedia() : Media {
		return this;
	}
	
	/*
	 * Getter & setter
	 */
	public function get id():String { return _id; }
	public function set id(value:String):Void { _id=value; }
	
	public function get copyright():String { return _copyright; }
	public function set copyright(value:String):Void { _copyright=value; }
	
	public function get description():String { return _description; }
	public function set description(value:String):Void { _description=value; }
	
	public function get caption():String { return _caption; }
	public function set caption(value:String):Void { _caption=value; }
	
	public function get files():Array { return _files; }
	public function set files(value:Array):Void { _files=value; }
}
