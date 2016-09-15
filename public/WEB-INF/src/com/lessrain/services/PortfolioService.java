package com.lessrain.services;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.controller.Action;
import com.lessrain.model.media.Asset;
import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.InvalidMediaFileException;
import com.lessrain.model.media.MediaFile;
import com.lessrain.model.media.Portfolio;
import java.sql.Connection;
import com.paulhopton.utils.jdbc.QueryExecuter;

/**
 * @author paul hopton
 * A Singleton providing persistence and local caching for portfolio objects.
 * 
 */
public class PortfolioService {
	
	private static PortfolioService instance;

	private Map<String,Portfolio> cached = new TreeMap<String,Portfolio>();
	private static Log log = LogFactory.getLog(PortfolioService.class);
	
	/**
	 * private no params constructor to force being a singleton
	 */
	private PortfolioService(){
		
	}
	
	/**
	 * @return the only instance of the service
	 */
	public static PortfolioService getInstance(){
		if (instance == null){
			instance = new PortfolioService();
		}
		return instance;
	}
	
	/**
	 * adds a portfolio to the internal cache
	 * @param name the key under which to store it
	 * @param portfolio
	 */
	public void addPortfolioToCache(Portfolio portfolio){
		
		log.debug(">>>addPortfolioToCache");
		log.debug("type"+ portfolio);
		
		cached.put(portfolio.getName(),portfolio);
		
		log.debug("<<<addPortfolioToCache");
	}
	
	public void clearCache(){
		log.debug(">>>clearCache");
		cached.clear();
		log.debug("<<<clearCache");
	}
	/**
	 * gets a portfolio object based on the name given. First search the cache.
	 * If portfolio not contained in cache, modify cahe by loading from database.
	 * 
	 * 
	 * @param name the name of the portfolio to find
	 * @return the Portfolio Object corresponding to the name;
	 * @throws SQLException
	 */
	public Portfolio getPortfolio(String name){
		
		log.debug(">>>getPortfolio");
		
		if (cached.containsKey(name)){
			
			log.debug("returning portfolio from cache");
			log.debug("<<<getPortfolio");
			
			return cached.get(name);
			
		}
		
		Portfolio portfolio;
		
			
			log.info("getting portfolio from database");
			portfolio = getPortfolioFromPersistence(name);
			
		
		
		if (portfolio != null){
			log.debug("adding portfolio to cache");
			addPortfolioToCache(portfolio);
		}
		
		log.debug("<<<getPortfolio");
		return portfolio;
	}
	
	

	/**
	 * @param name the name of the portfolio object to get
	 * @return a portfolio object stored in the db under name
	 */
	private Portfolio getPortfolioFromPersistence(String name){
		
		log.debug(">>>getPortfolioFromPersistence");
		log.debug("type"+ name);
		
		Portfolio portfolio = new Portfolio(name);
		portfolio.setArchiveName(getArchiveName(name));
		
		int portfolioid = getPortfolioID(name);
		if (portfolioid == -1){
			log.error("Requested Portfolio not found");
			log.debug("portfolio not found");
			log.debug("<<<getPortfolioFromPersistence");
			return null;
		}
		Connection con = QueryExecuter.getConnection();
		
		ResultSet res = performQuery(portfolioid, con);
		try {
			while (res.next()){
				
				int id = res.getInt("id");
				
				Asset file = AssetService.getInstance().getAssetFromResultSet(res);
				
				MediaFile mf = portfolio.getMediaFileById(new Long(new Integer(id)));
					
				if (mf == null){
					mf = new MediaFile(file);
					mf.setId(new Long(new Integer(id)));
					log.debug("adding mediafile");
					log.trace("mediafile" +  mf);
					portfolio.addMediaFile(mf);
					mf.setAlign(res.getString("mf.align"));
					mf.setEnableFill( res.getInt("mf.enableFill")==1 );
					mf.setCaption( res.getString("mf.caption"));
				}
				else{
						mf.addFile(file);
					}
			}
		} catch (InvalidExtensionException iee){
					
			log.warn("mediafile detected with inappropriate extension", iee);
					
		} catch (InvalidMediaFileException imfe){
					
			log.warn("Invalid MediaFile found", imfe);
					
		} catch (SQLException sqle){
					
			log.warn("problem with sql statement", sqle);
		} 
		
		QueryExecuter.closeConnection(con);
	

		log.debug("<<<getPortfolioFromPersistence");
		return portfolio;
	}
	
	private String getArchiveName(String name){
		if (isPortfolioArchive(name)){
			return null;
		}
		return "archive" + name;
	}
	
	private boolean isPortfolioArchive(String name){
		if (name.indexOf("archive") > -1){
			return true;
			}
		return false;
		}
	/**
	 * gets the id of portfolio from the name
	 * hard coded is fine for now, but we may want to put this somewhere more accessible
	 * @param name of the portfolio
	 * @return the id of the portfolio
	 */
	private int getPortfolioID(String name) {
		if (name.equals("people")){
			return 1;
		}
		if (name.equals("cars")){
			return 2;
		}
		if (name.equals("moods")){
			return 5;
		}
		if (name.equals("archivepeople")){
			return 4;
		}
		if (name.equals("archivecars")){
			return 3;
		}
		if (name.equals("archivemoods")){
			return 6;
		}
		return -1;
	}

	/**
	 * constructs the sql  and performs the query on the given Portfolio id
	 * 
	 * @param id the portfolio id
	 * @return a resultset produced from the query generated
	 */
	private ResultSet performQuery(int id, Connection connection){
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
			"FROM  " +
				"mediafiles AS mf, " +
				"files as f," +
				"portfolios as p " +
			"WHERE mf.id = f.mediafile_id " +
			"AND p.mediafile_id = mf.id " +
			"AND p.id = ? ORDER BY p.position";
		List parameters = createParemetersFromId(id);
		return QueryExecuter.executeQuery(queryString, parameters, connection);
	}

	private List createParemetersFromId(int id) {
		Vector<String> list = new Vector<String>();
		list.add( new Integer(id).toString());
		return list;
	}

	
	/**
	 * Adds a MediaFiel to the portfolio and performs Persists the state
	 * @param portfolioName the name of the portfolio to be added to
	 * @param mediaFileToAdd the media File to add
	 * @throws PortfolioNotFoundException
	 * @throws InvalidMediaFileException
	 */
	public void addMediaFileToPortfolio(String portfolioName, MediaFile mediaFileToAdd, String insertposition) throws PortfolioNotFoundException, InvalidMediaFileException {

		Portfolio p = getPortfolio(portfolioName);
		if (insertposition.equals("bottom")){
			p.addMediaFile(mediaFileToAdd);
		} else {
			p.addMediaFileToTop(mediaFileToAdd);
		}
		int position = p.getMediaFiles().indexOf(mediaFileToAdd);
		
		Connection connection = QueryExecuter.getConnection();
		addMediaFileToPortfolioPersist(mediaFileToAdd, p, position, connection);
		QueryExecuter.closeConnection(connection);
	}

	private void addMediaFileToPortfolioPersist(MediaFile mf, Portfolio p, int position, Connection connection) {
		String queryString = "INSERT INTO portfolios (id, mediafile_id, position) VALUES(?,?,?)";
		List parameters = getInsertParameters(p,mf,position);
		QueryExecuter.executeUpdate(queryString, parameters, connection);
	}
	
	
	
	/**
	 * deletes the mediafile from the portfolio in perstence
	 * @param portfolioName the name of the portfolio to be deleted from
	 * @param mediafile the mediafile to delete
	 */
	public void deleteMediaFileFromPortfolio(String portfolioName, MediaFile mediafile){
		String queryString = "DELETE FROM portfolios where mediafile_id = ? and id = ?";
		List parameters = createDeleteMediaFileFromPortfolioParams(portfolioName, mediafile);
		QueryExecuter.executeUpdate(queryString, parameters);
	}
	
	private List createDeleteMediaFileFromPortfolioParams(String PortfolioName, MediaFile mf){
		Vector<String> list = new Vector<String>();
		list.add( mf.getId().toString() );
		list.add( new Integer(getPortfolioID(PortfolioName)).toString());
		return list;
	}
	
	/**
	 * empties the portfolio in persistence
	 * @param portfolioName the name of he portfoio to empty
	 */
	public void emptyPortfolio(String portfolioName, Connection connection){
		String queryString = "DELETE FROM portfolios where id = ?";
		List parameters = createParemetersFromId(getPortfolioID(portfolioName));
		QueryExecuter.executeUpdate(queryString, parameters, connection);
	}

	private List getInsertParameters(Portfolio p, MediaFile mf, int position) {
		Vector<String> list = new Vector<String>();
		list.add( new Integer(getPortfolioID(p.getName())).toString());
		list.add( mf.getId().toString());
		list.add( new Integer(position).toString());
		return list;
	}

	private void savePortfolioState(Portfolio portfolio) {
		
		Connection connection = QueryExecuter.getConnection();
	
		emptyPortfolio(portfolio.getName(), connection);
		Iterator it = portfolio.getMediaFiles().iterator();
		int position = 0;
		while (it.hasNext()){
			MediaFile mediafile = (MediaFile) it.next();
			addMediaFileToPortfolioPersist(mediafile, portfolio, position, connection);
			position++;
		}

		QueryExecuter.closeConnection(connection);
	}
	
	public void performAction(Action action) {
		if (action.getType() == null){
			return;
		}
		if (action.getType().equals("delete")){
					
			MediaFile mf = action.getPortfolio().getMediaFileById(action.getId());
					
			if (mf != null){
				deleteMediaFileFromPortfolio(action.getPortfolio().getName(), mf);
					
				MediaFileService.getInstance().delete(mf);
					
				action.getPortfolio().deleteMediaFile(action.getId());
			}
		}
		if (action.getType().equals("changealign")){
			
			MediaFile mf = action.getPortfolio().getMediaFileById(action.getId());
			
			if (mf != null){
				
				mf.switchAlignment();
				MediaFileService.getInstance().update(mf);

			}
			
		}
		if (action.getType().equals("changefill")){
			
			MediaFile mf = action.getPortfolio().getMediaFileById(action.getId());
			
			if (mf != null){
				
				mf.changeFill();
				MediaFileService.getInstance().update(mf);

			}
			
		}
		if (action.getType().equals("changetext")){
			MediaFile mf = action.getPortfolio().getMediaFileById(action.getId());
			if (mf != null){
				mf.setCaption(action.getParameter("caption"));
				MediaFileService.getInstance().update(mf);
			}
		}
		if (action.getType().equals("movetotop")){
			action.getPortfolio().moveFileToTop(action.getId());
			savePortfolioState(action.getPortfolio());
		}
		if (action.getType().equals("moveup")){
			action.getPortfolio().moveFileUp(action.getId());
			savePortfolioState(action.getPortfolio());
		}
		if (action.getType().equals("movedown")){
			action.getPortfolio().moveFileDown(action.getId());
			savePortfolioState(action.getPortfolio());
		}
		if (action.getType().equals("movetobottom")){
			action.getPortfolio().moveFileToBottom(action.getId());
			savePortfolioState(action.getPortfolio());
		}
		
		if (action.getType().equals("movetoarchive")){
			try {
				MediaFile mf = action.getPortfolio().getMediaFileById(action.getId());
				addMediaFileToPortfolio(action.getPortfolio().getArchiveName(),mf,"bottom");
				action.getPortfolio().deleteMediaFile(mf.getId());
				savePortfolioState(action.getPortfolio());
				savePortfolioState(getPortfolio(action.getPortfolio().getArchiveName()));
			} catch (PortfolioNotFoundException e) {
				e.printStackTrace();
			} catch (InvalidMediaFileException e) {
				e.printStackTrace();
			}
			
		}
		
	}

	
}