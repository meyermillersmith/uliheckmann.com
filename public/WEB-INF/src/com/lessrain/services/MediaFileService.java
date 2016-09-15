package com.lessrain.services;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.model.media.Asset;
import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.InvalidMediaFileException;
import com.lessrain.model.media.MainAsset;
import com.lessrain.model.media.MediaFile;
import com.lessrain.model.media.PreviewAsset;
import com.paulhopton.utils.jdbc.QueryExecuter;

/**
 * @author paul hopton
 * A Singleton providing persistence and local caching for portfolio objects.
 * 
 */
public class MediaFileService {
	
	private static MediaFileService instance;
	private static Log log = LogFactory.getLog(MediaFileService.class);
	
	private String tablename = "mediafiles";
	
	/**
	 * private no params constructor to force being a singleton
	 */
	private MediaFileService(){
		
	}
	
	/**
	 * @return the only instance of the service
	 */
	public static MediaFileService getInstance(){
		if (instance == null){
			instance = new MediaFileService();
		}
		return instance;
	}

	public void save(MediaFile mf) throws InvalidMediaFileException{
		
		log.debug(">>>save");
		
		if ((mf.getMainAsset() == null)|| (mf.getPreviewAsset() == null)){
			
			log.warn("invalid mediafile asset missing");
			log.debug("type"+ mf);
			throw new InvalidMediaFileException();
			
		}
		
		log.trace("storing main asset");
		AssetService.getInstance().saveAsset(mf.getMainAsset(), mf.getId());
		
		log.trace("storing preview asset");
		AssetService.getInstance().saveAsset(mf.getPreviewAsset(), mf.getId());
		
		log.trace("saving");
		makeSaveStatement(mf);
		
		log.debug("<<<save");
	}


	

	public void delete(MediaFile mf){
		
		log.debug(">>>delete");
		
		if (mf.getMainAsset() != null){
			log.debug("deleting main asset");
			AssetService.getInstance().deleteAsset(mf.getMainAsset(),MainAsset.TYPE, mf.getId());
		}
		if (mf.getPreviewAsset() != null){
			log.debug("deleting preview asset");
			AssetService.getInstance().deleteAsset(mf.getPreviewAsset(),PreviewAsset.TYPE, mf.getId());
		}
		log.debug("deleting mediafile");
		makeDelQuery(mf.getId());
		mf = null;
		
		log.debug("<<<delete");
	}
	
	public Long getNextAvailableId(){
			
		log.debug(">>>getNextAvailableId");
		ResultSet res = null;
		
		Long max = null;
		String queryString = 
				"Select MAX(id) as next from " + tablename;
			List parameters = new Vector();
			try{
				Connection con = QueryExecuter.getConnection();
				res =  QueryExecuter.executeQuery(queryString, parameters, con);
				
				res.first();
				max = res.getLong("next");
				QueryExecuter.closeConnection(con);
				} 
			catch (SQLException sqle){
				
				log.warn("sql problem getting the next id", sqle);
				
			}
			catch (Exception e){
				
				log.warn("non-sql problem getting the next id", e);
			}
			
				try { 
					log.debug("close connection");
					  if (res != null){
						  
						  res.close(); 
					  }
					  else{
						  log.debug("connection already closed (not open)");
					  }
					}
					catch (SQLException sqle2) { 
						log.warn("connection may not have been ciorrectly closed", sqle2);
					}
			
		max = max + 1;
		
		log.debug("type"+ max);
		log.debug("<<<getNextAvailableId");
		return max;
	}
	
	public MediaFile getMediaFile(Long id){
		
		log.debug(">>>getMediaFile");
		
		ResultSet res = makeGetQuery(id);
		MainAsset main = null;
		PreviewAsset prev = null;
		String align = "U";
		String caption = null;
		boolean enableFill = true;
		try{
			while (res.next()){
				Asset file = AssetService.getInstance().getAssetFromResultSet(res);
				
				if (file.getClass().getSimpleName().equals("MainAsset")){
					main = (MainAsset)file;
				}
				else{
					prev = (PreviewAsset)file;
				}
				
				align = res.getString("mf.align");
				caption = res.getString("mf.caption");
				enableFill = res.getBoolean("mf.enableFill");
				log.debug("type"+ align);
				
			}
		} 
		catch (InvalidExtensionException iee){
				
				log.warn("invalid extension on file", iee);
				
		} 
		catch (SQLException sqle){
			
			log.warn("sql problem getting media file", sqle);
			
		}
			
		MediaFile mf = new MediaFile(main);
		mf.setId(id);
		mf.setPreviewAsset(prev);
		mf.setAlign(align);
		mf.setEnableFill(enableFill);
		mf.setCaption(caption);
		log.debug("type"+ mf);
		log.debug(">>>getMediaFile");
		return mf;
	}
	
	private ResultSet makeGetQuery(Long id){
		Connection con = QueryExecuter.getConnection();
		log.debug(">>>makeGetQuery");
		log.debug("type"+ id);
		String queryString = 
			"SELECT " +
				"mf.id," +
				"mf.align," +
				"mf.enableFill," +
				"mf.caption," +
				"f.type," +
				"f.src," +
				"f.width," +
				"f.height," +
				"f.mediaType " +
			"FROM  " + tablename +
				" AS mf, " +
				"files as f " +
			"WHERE mf.id = f.mediafile_id " +
			"AND mf.id = ?";
		List parameters = createParemetersFromId(id);
		
		ResultSet res =  QueryExecuter.executeQuery(queryString, parameters, con);
		
		QueryExecuter.closeConnection(con);
		log.debug("<<<makeGetQuery");
		return res;
	}
	
	
	
	private String getBooleanAsString(boolean bool){
		if (bool){
			return "1";
		}
		return "0";
	}
	
	public void update(MediaFile mf){
		log.debug(">>>update");
		log.debug("type"+ mf);
		
		String queryString = "update " + tablename + " set caption=?, align=?,  enableFill=? where id=?";
		log.debug("type"+ queryString);
		List parameters = createUpdateParameters(mf);
		int res = QueryExecuter.executeUpdate(queryString, parameters);
		log.debug("Update success" + res);
		log.debug("<<<update");
	}
	
	public List createUpdateParameters(MediaFile mf){
		
		log.debug(">>>createUpdateParameters");
		log.debug("type"+ mf);
		
		Vector<String> list = new Vector<String>();
	
		list.add( mf.getCaption() );
		list.add( mf.getAlign() );
		list.add( getBooleanAsString( mf.getEnableFill() ) );
		list.add( mf.getId().toString() );
		
		log.debug("type"+ list);
		log.debug("<<<createUpdateParameters");
		
		return list;
	}
	
	
	public List createParemetersFromId(Long id) {
		
		log.debug(">>>createParemetersFromId");
		log.debug("type"+ id);
		
		Vector<String> list = new Vector<String>();
		list.add( id.toString() );
		
		log.debug("type"+ list);
		log.debug("<<<createParemetersFromId");
		
		return list;
	}
	
	public void makeDelQuery(Long id) {
		
		log.debug(">>>makeDelQuery");
		log.debug("type"+ id);
		
		String queryString = "delete from " + tablename + " where id = ?";
		List parameters = createParemetersFromId(id);
		QueryExecuter.executeUpdate(queryString, parameters);
		
		log.debug("<<<makeDelQuery");
	}


	private void makeSaveStatement(MediaFile mf) {
		
		log.debug(">>>makeSaveStatement");
		log.debug("type"+ mf);
		
		String queryString = "insert into " + tablename + "(id, copyright,caption, align, enableFill) values( ?,?,?,?,?)";
		List parameters = createSaveParameters(mf);
		QueryExecuter.executeUpdate(queryString, parameters);
		
		log.debug("<<<makeSaveStatement");
	}
	
	public List createSaveParameters(MediaFile mf){
		
		log.debug(">>>createSaveParameters");
		log.debug("type"+ mf);
		
		Vector<String> list = new Vector<String>();
		
		list.add( mf.getId().toString() );
		list.add( mf.getCopyright() );
		list.add( mf.getCaption() );
		list.add( mf.getAlign() );
		list.add( getBooleanAsString( mf.getEnableFill() ) );
		
		log.debug("type"+ list);
		log.debug("<<<createSaveParameters");
		
		return list;
	}


}