package com.lessrain.services;

import java.io.File;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.model.media.Asset;
import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.MainAsset;
import com.lessrain.model.media.PreviewAsset;
import com.paulhopton.utils.jdbc.QueryExecuter;

public class AssetService {

	private static AssetService instance;
	private static Log log = LogFactory.getLog(AssetService.class);
	
	/**
	 * private no params constructor to force being a singleton
	 */
	private AssetService(){
		
	}
	
	/**
	 * @return the only instance of the service
	 */
	public static AssetService getInstance(){
		if (instance == null){
			instance = new AssetService();
		}
		return instance;
	}

	/**
	 * extract the results from the resultset and construct a new MainAsset object
	 * @param res the resultset
	 * @return the file constructed
	 * @throws SQLException
	 * @throws InvalidExtensionException
	 */
	public Asset getAssetFromResultSet(ResultSet res) throws SQLException, InvalidExtensionException {
		log.debug(">>>getAssetFromResultSet");
		int type = res.getInt("type");
		String src = res.getString("src");
		int height = res.getInt("height");
		int width = res.getInt("width");
		String mediatype = res.getString("mediatype");
		
		Asset file = getAsset(type, src, height, width, mediatype);
		log.debug("type"+ file);
		log.debug("<<<getAssetFromResultSet");
		return file;
	}
	

	/**
	 * takes the elements and assembles a file form them
	 * @param type
	 * @param src
	 * @param height
	 * @param width
	 * @param mediatype
	 * @return the resuting file
	 * @throws InvalidExtensionException
	 */
	private Asset getAsset(int type, String src, int height, int width, String mediatype) throws InvalidExtensionException {
		
		log.debug(">>>getAsset");
		
		if (type == 1){
			
			Asset asset = new MainAsset(src, mediatype, width, height);
			
			log.debug("type"+ asset);
			log.debug("<<<getAsset");
			return asset;
		}
		else if (type ==2){
			
			Asset asset = new PreviewAsset(src, width, height);
			
			log.debug("type"+ asset);
			log.debug("<<<getAsset");
			return asset;
		}
		
		log.debug("type"+ null);
		log.debug("<<<getAsset");
		return null;
	}

	private List createSaveParameters(Asset asset, Long mediafile_id){
		
		log.debug(">>>createSaveParameters");
		
		Vector<String> list = new Vector<String>();
		if (asset.getClass().getSimpleName().equals("MainAsset")){
			list.add( "1" );
		}
		else{
			list.add( "2" );
		}
		list.add( mediafile_id.toString() );
		list.add( asset.getSrc() );
		list.add( new Integer( asset.getWidth() ).toString() );
		list.add( new Integer( asset.getHeight() ).toString() );
		list.add( asset.getMediaType() );
		
		log.debug("type"+ list);
		log.debug("<<<createSaveParameters");
		
		return list;
	}
	
	private List createDeleteParemeters(int type, Long mediafile_id){
		
		log.debug(">>>createDeleteParemeters");
		
		Vector<String> list = new Vector<String>();
		
		list.add( new Integer( type ).toString() );
		list.add( mediafile_id.toString() );
		
		log.debug("type"+ list);
		log.debug("<<<createDeleteParemeters");
		
		return list;
	}
	
	/**
	 * @param mainAsset
	 * @param mediafile_id
	 */
	public void saveAsset(Asset mainAsset, Long mediafile_id) {
		
		log.debug(">>>saveAsset");
		log.debug("type"+ mainAsset);
		log.debug("type"+ mediafile_id);
		
		String queryString = "insert into files (type, mediafile_id,src,width,height,mediatype) values(?,?,?,?,?,?)";
		List parameters = createSaveParameters(mainAsset, mediafile_id);
		QueryExecuter.executeUpdate(queryString, parameters);
		
		log.debug("<<<saveAsset");
	}
	
	/**
	 * Completely remove the asset ffrom the filesytem and the databse;
	 * @param asset The asset to be removed
	 * @param type the type id of the asset
	 * @param mediafile_id the id of the mediafile to which this asset belongs
	 */
	public void deleteAsset(Asset asset, int type, Long mediafile_id) {
		
		log.debug(">>>deleteAsset");
		
		removeFile(asset);
		removeFromStorage(type, mediafile_id);
		
		log.debug("<<<deleteAsset");
		
	}

	private void removeFile(Asset asset) {
		
		log.debug(">>>removeFile");
		
		File file = new File(asset.getSrc());
		file.delete();
		
		log.debug("<<<removeFile");
	}

	private void removeFromStorage(int type, Long mediafile_id) {
		
		log.debug(">>>removeFromStorage");
		
		String queryString = "delete from files where type = ? and mediafile_id = ?";
		List parameters = createDeleteParemeters(type, mediafile_id);
		QueryExecuter.executeUpdate(queryString, parameters);
		
		log.debug("<<<removeFromStorage");
		
	}
	


}
