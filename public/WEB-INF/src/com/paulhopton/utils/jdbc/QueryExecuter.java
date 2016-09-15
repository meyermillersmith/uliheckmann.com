package com.paulhopton.utils.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.services.ConfigService;

/**
 * a simple wrapper for JDBC calls requires a working ConnectionPoolManager from which to get connections.
 * Uses prepared Statments exclusively. both methods expect a query string containing question marks for the passed in values, and a list object containing the4 values to be passed in.
 * handles Exceptions quietly logging them using SimpleLog and returning an acceptable value.
 * 
 * @author paul hopton
 *
 */
public class QueryExecuter {
	
	private static Log log = LogFactory.getLog(QueryExecuter.class);
	
	/**
	 * Execute a query on the database.
	 * 
	 * @param queryString The queryString to be executed
	 * @param parameters The parameters to pass
	 * @return a resultset on successful completion or null on failure.
	*/
	public static ResultSet executeQuery(String queryString, List parameters) {
		Connection connection = getConnection();
		ResultSet res = executeQuery(queryString, parameters, connection);
		closeConnection(connection);
		return res;
	} 
	
	/**
	 * @return a valid connection or null if none could dbe found
	 */
	public static Connection getConnection(){
		log.debug(">>>getConnection");
		try {
			Connection con = ConfigService.getInstance().getPool().getConnection();
			log.debug("connection found");
			log.debug("<<<getConnection");
			return con;
		} catch (SQLException e) {
			log.warn("unable to get connection", e);
		}
		log.debug("<<<getConnection");
		return null;
	}
	
	/**
	 * @param con the connection to close
	 */
	public static void closeConnection(Connection con){
		log.debug(">>>closeConnection");
		try {
			if (con != null){
				con.close();
				log.debug("connection closed");
			}
			else{
				log.debug("connection previously colsed");
			}
			
		} catch (SQLException e) {
			log.warn("unable to close connection", e);
		}
		log.debug("<<<closeConnection");
	}
	
	/**
	 * Execute a query on the database.
	 * 
	 * @param queryString The queryString to be executed
	 * @param parameters The parameters to pass
	 * @param closeConnection wether or not to automatically close the connection
	 * @return a resultset on successful completion or null on failure.
	 */
	public static ResultSet executeQuery(String queryString, List parameters, Connection  con) {
		
		log.debug(">>>executeQuery");
		log.debug("type"+ queryString);
		log.debug("type"+ parameters);
		

		PreparedStatement saveStatement;
		try{

			if (con != null){
				
				log.debug("Connection valid");
				
				saveStatement = con.prepareStatement(queryString);
				setUpStatement(saveStatement, parameters);
				ResultSet res =  saveStatement.executeQuery();
				
				log.debug("<<<executeQuery");
				return res;
			
			}
			else{
			  log.warn("unable to get connection");
			}
		}
		catch (SQLException sqle){
			
		  log.warn("problem executing sql", sqle);
		  log.debug(queryString);
		  
		} 
		catch (Exception e){
			
			 log.warn("unspecific database problem", e);
			 
		}

		log.debug("<<<executeQuery");
		return null;
	}
	
	public void setPoolname(String newname){
	}
	
	
	public static int executeUpdate(String queryString, List parameters) {
		
		log.debug(">>>executeUpdate (no connection");
		
		Connection con = getConnection();
		int res = -1;
		
		if (con != null){
			res = executeUpdate(queryString, parameters, con);
			closeConnection(con);
		}
		
		return res;
	}
	
	/**
	 * executes an update stament
	 * @param queryString The queryString to be executed
	 * @param parameters The parameters to pass
	 * @return ither (1) the row count for INSERT, UPDATE, or DELETE statements or (2) 0 for SQL statements that return nothing or (3) -1 for a problem
	 */
	public static int executeUpdate(String queryString, List parameters, Connection con) {
		
		log.debug(">>>executeUpdate");
		log.debug("type"+ queryString);
		log.debug("type"+ parameters);
		
		PreparedStatement saveStatement;
		try {
			if (con != null){
				
				log.debug("Connection valid");
				log.debug("type"+ queryString);
				
				saveStatement = con.prepareStatement(queryString);
				setUpStatement(saveStatement, parameters);
				int result = saveStatement.executeUpdate();
				
				log.debug("query successfully completed");
				log.debug("type"+ result);
				
				log.debug("<<<executeUpdate");
				return result;
			}
			else{
				  log.warn("unable to get connection");
			}
		}
		catch (SQLException sqle){
				
			log.warn("problem executing sql", sqle);
			log.debug("type"+ queryString);
			log.debug("type"+ parameters);

		}
		catch (Exception e){
			
			 log.warn("unspecific database problem", e);
			 
		}
		log.debug("<<<executeUpdate");
		return -1;
	}
	
	/**
	 * loads the parameters into the querystatment;
	 * @param queryStatement
	 * @param parameters
	 * @throws SQLException if a database access error occurs
	 */
	private static void setUpStatement(PreparedStatement queryStatement, List parameters) throws SQLException {
		log.debug(">>>setUpStatement");
		
		queryStatement.clearParameters();
		log.trace("parameters cleared");
		
		int columnIndex = 1;
		for (Iterator i = parameters.iterator(); i.hasNext(); columnIndex++){
			log.trace("Parametercount" + columnIndex);
			
			Object eachParameter = (Object) i.next();
			queryStatement.setObject(columnIndex, eachParameter);
			
			log.trace("parameter" + eachParameter);
		}
		
		log.debug("<<<setUpStatement");
	}
}
