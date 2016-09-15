/**
 * @author Torsten H�rtel (torsten@lessrain.com)
 */
import mx.xpath.XPathAPI;

import lessrain.lib.components.mediaplayer07.core.DataFile;
import lessrain.lib.components.mediaplayer07.core.Media;
import lessrain.lib.components.mediaplayer07.core.MediaXMLUtils;
import lessrain.lib.components.mediaplayer07.lists.Lists;
import lessrain.lib.components.mediaplayer07.skins.core.IGallerySkin;
import lessrain.lib.components.mediaplayer07.skins.core.ISkinFactory;
import lessrain.lib.components.mediaplayer07.skins.defaultskin.SkinFactory;
import lessrain.lib.utils.ArrayUtils;
import lessrain.lib.utils.events.EventDistributor;
import lessrain.lib.utils.events.IDistributor;
import lessrain.lib.utils.events.IEvent;
import lessrain.lib.utils.loading.FileItem;
import lessrain.lib.utils.loading.FileListener;
import lessrain.lib.utils.loading.PriorityLoader;

class lessrain.lib.components.mediaplayer07.core.Gallery implements FileListener, IDistributor 
{
	private var _src				: String;
	private var _xml				: XML;
	private var _lists 				: Lists;
//	private var _galleryProperties	: GalleryProperties;
	
	
	/*
	 * Getter & setter
	 */
	private var _targetMC			: MovieClip;
	private var _medias				: Array;
	private var _skin				: IGallerySkin;
	private var _skinFactory		: ISkinFactory;
	
	/*
	 * EventDistributor
	 */
	private var _eventDistributor : EventDistributor;
	
	
	public function Gallery( targetMC_:MovieClip, src_:String, skinFactory_:SkinFactory )
	{
		_eventDistributor = new EventDistributor();
		_eventDistributor.initialize(this);
	
		_targetMC = targetMC_.createEmptyMovieClip("gallery_"+targetMC_.getNextHighestDepth(), targetMC_.getNextHighestDepth());
		_src = src_;
		_skinFactory = skinFactory_;
		
		// TODO move keys to configuration xml
//		KeyManager.addDownListener(Key.DOWN, Delegate.create(this, onNextButtonEvent));
//		KeyManager.addDownListener(Key.UP, Delegate.create(this, onPrevButtonEvent));
	}
	
	public function loadXML() :Void
	{
		_xml = new XML();
		_xml.ignoreWhite=true;
		
		PriorityLoader.getInstance().addFile( _xml, _src, this, 100, "galleryXML", "Gallery XML" );
	}
	
	/*
	 * FileListener methods
	 */
	public function onLoadStart(file : FileItem) : Boolean { return null; }
	public function onLoadProgress(file : FileItem, bytesLoaded : Number, bytesTotal : Number, percent : Number) : Void {}
	public function onLoadComplete(file : FileItem) : Void
	{
		var nodes:Array = XPathAPI.selectNodeList(_xml.firstChild,"/Gallery/Media");
		
		_medias = [];
		for (var i : Number = 0; i < nodes.length; i++)
		{
			var media:Media = MediaXMLUtils.xmlNode2Media( nodes[i] );
			if (media!=null) _medias.push( media );
		}
		
//		distributeEvent( new GalleryLoadCompleteEvent( this ) );
		
		// Gallery contains more than one item
		if (_medias.length > 1)
		{
			createGallery();
		}
	}
	
	/*
	 * Create the gallery with all lists and listitems
	 */
	public function createGallery() :Void
	{
		// Find all different types in the medias array and create new arrays for every type
		var requiredTabs:Array = new Array();
		var fileArraysForEveryType:Array = new Array();
		for (var i : Number = 0; i < _medias.length; i++)
		{
			var typeOfMaster:String = DataFile(  Media(_medias[i]).getMaster()  ).type;
			var n:Number = ArrayUtils.indexOf( requiredTabs, typeOfMaster, true);
			if (n == -1)
			{
				requiredTabs.push( typeOfMaster );
				var a:Array = new Array();
				a.push( _medias[i] );
				fileArraysForEveryType.push( a );
			}
			else
			{
				Array( fileArraysForEveryType[ n ] ).push( _medias[i] );
			}
		}
		
		// Create skin
//		_skin = _skinFactory.createGallerySkin( _targetMC, this);
		
		// Create lists
		
		_lists = new Lists( this, _targetMC, fileArraysForEveryType, _skinFactory);
		
		resize();
	}
	
	public function showFile( media_:Media ) :Void
	{
		_lists.deactivateOtherListItems();
//		_mediaPlayer.showMedia(media_);
//		distributeEvent(new MediaSelectEvent(media_));
	}
	
	public function onNextButtonEvent() :Void 		
	{
		_lists.getNextListItem();
	}
	
	public function onPrevButtonEvent() :Void 		
	{
		_lists.getPreviousListItem();
	}
	
	/*
	 * Resize stuff
	 */
	public function resize() :Void
	{
//		_targetMC._x = _mediaPlayer.view.targetMC._x + _mediaPlayer.view.targetMC._width;
		_skin.updateSkin();
	}
	
	/**
	 * Hide gallery
	 */
	public function hide():Void {
		_targetMC._visible = false;
	}
	
	public function show():Void {
		_targetMC._visible = true;
	}
	
	/*
	 * Getter & setter
	 */
	public function get targetMC():MovieClip { return _targetMC; }
	public function set targetMC(value:MovieClip):Void { _targetMC=value; }
	
	public function get medias():Array { return _medias; }
	public function set medias(value:Array):Void { _medias=value; }
	
	public function get skin():IGallerySkin { return _skin; }
	public function set skin(value:IGallerySkin):Void { _skin=value; }
	
	/*
	 * EventDistributor methods
	 */
	public function addEventListener(type : String, func : Function) : Void {}
	public function removeEventListener(type : String, func : Function) : Void {}
	public function distributeEvent(eventObject : IEvent) : Void {}

}