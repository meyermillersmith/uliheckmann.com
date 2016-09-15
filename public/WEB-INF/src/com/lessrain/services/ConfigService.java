package com.lessrain.services;

import snaq.db.ConnectionPool;

public class ConfigService {
	
	private static ConfigService instance;
	private ConnectionPool pool;
	
	private ConfigService(){
		
	}
	
	public static ConfigService getInstance(){
		if (instance == null){
			instance = new ConfigService();
		}
		return instance;
	}
	
	public void setPool(ConnectionPool pool){
		this.pool = pool;
	}
	
	public ConnectionPool getPool(){
		return pool;
	}

}
