package com.lessrain.services;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.model.ClientList;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.paulhopton.utils.jdbc.QueryExecuter;

public class ClientService {

	private static ClientService instance;
	private ClientList list;
	private static Log log = LogFactory.getLog(ClientService.class);

	public static ClientService getInstance() {
		if (instance == null){
			instance = new ClientService();
		}
		return instance;
	}

	public ClientList getClientList() {
		log.debug(">>>getClientList");
		if ((list == null)||(list.getListSize() == 0)){
			log.debug("loading clientlist from persistence");
			getListFromPersistence();
		}
		else{
			log.debug("using clientlist from cache");
		}
		log.debug("<<<getClientList");
		return list;
	}

	private void getListFromPersistence() {
		log.debug(">>>getListFromPersistence");
		String sql = "select name from clients order by name asc";
		
		list = new ClientList();
		List<String> builtList = new Vector<String>();
		ResultSet res = QueryExecuter.executeQuery(sql, new Vector<String>());
		try {
			while (res.next()){
				builtList.add(res.getString("name"));
			}
		}
		catch (SQLException sqle){
			log.warn("problem building list", sqle);
		}
		log.debug("list built");
		list.setList(builtList);
		
		log.debug("<<<getListFromPersistence");
	}

	public void deleteClient(String name) {
		log.debug(">>>deleteClient");
		log.debug("name = " + name);
		if (name != null){
			
			deleteClientFromPersistence(name);
			
			list.removeFromList(name);
			
			
		}
		log.debug("<<<deleteClient");
	}
	
	public void addClient(String name) {
		log.debug(">>>addClient");
		log.debug("name = " + name);
		if (name != null){
			
			addClientToPersistence(name);
			list.addToList(name);
		}
		log.debug("<<<addClient");
	}
	
	public void deleteClientFromPersistence(String name){
		log.debug(">>>deleteClientFromPersistence");
		log.debug("name = " + name);
		
		Connection connection = QueryExecuter.getConnection();
		
		String queryString = "DELETE FROM clients where name = ?";
		List<String> parameters = new ArrayList<String>(1);
		parameters.add(name);
		QueryExecuter.executeUpdate(queryString, parameters, connection);
		log.debug("<<<deleteClientFromPersistence");
	}

	public void addClientToPersistence(String name){
		log.debug(">>>addClientToPersistence");
		log.debug("name = " + name);
		Connection connection = QueryExecuter.getConnection();
		
		String queryString = "Insert into clients (name) values(?)";
		List<String> parameters = new ArrayList<String>(1);
		parameters.add(name);
		QueryExecuter.executeUpdate(queryString, parameters, connection);
		log.debug("<<<addClientToPersistence");
	}

}
