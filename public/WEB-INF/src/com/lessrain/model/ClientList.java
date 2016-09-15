package com.lessrain.model;

import java.util.List;

public class ClientList {
	
	List<String> list;
	
	public void setList(List<String> list){
		this.list = list;
	}
	
	public List getList(){
		return this.list;
	}
	
	public void addToList(String clientToAdd){
		list.add(clientToAdd);
	}
	
	public void removeFromList(String clientToRemove){
		if (list.contains(clientToRemove)){
			list.remove(clientToRemove);
		}
	}
	
	public int getListSize(){
		return list.size();
	}

}
