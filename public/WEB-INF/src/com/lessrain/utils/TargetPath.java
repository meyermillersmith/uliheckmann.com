package com.lessrain.utils;

import java.io.File;
import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class TargetPath {
	
	private static Log log = LogFactory.getLog(TargetPath.class);
	
	private String fileSystemRoot;
	private String imageDirectory;
	private Long id;
	private File file;
	
	public TargetPath(String fileSystemRoot, String imageDirectory, Long id){
		this.fileSystemRoot = fileSystemRoot;
		this.imageDirectory = imageDirectory;
		this.id = id;
	}
	
	public TargetPath(File file){
		this.file = file;
	}
	
	public TargetPath(String fileSystemRoot, String src) {
		this.fileSystemRoot = fileSystemRoot;
		this.file = new File(fileSystemRoot + src);
	}

	public String getPath(){
		
		log.debug(">>>getPath");
		
		StringBuffer buff = getBasePath();
		buff.append(".jpg");
		
		log.debug("type"+ buff.toString());
		log.debug("<<<getPath");
		return buff.toString();
	}
	
	private StringBuffer getBasePath(){
		StringBuffer buff = new StringBuffer();
		buff.append(fileSystemRoot);
		buff.append(imageDirectory);
		buff.append("/image_");
		buff.append(getDoubleDigitID());
		return buff;
	}
	
	public String getThumbPath(){
		
		log.debug(">>>getThumbPath");
		
		StringBuffer buff = getBasePath();
		buff.append("_thumb.jpg");
		
		log.debug("type"+ buff.toString());
		log.debug("<<<getThumbPath");
		return buff.toString();
	}
	
	
	public File getFile() throws IOException{
		
		log.debug(">>>getFile");
		
		if (file != null){
			log.debug("returning file unmodified");
			log.debug("<<<getFile");
			return file;
		}
		log.debug("returning file calculated from the path");
		log.debug("<<<getFile");
		return getFileFromPath(getPath());
	}
	
	public File getThumbFile() throws IOException{
		
		log.debug(">>>getThumbFile");
		
		File thumb = getFileFromPath(getThumbPath());
		
		log.debug("<<<getThumbFile");
		return thumb;
	}
	
	private File getFileFromPath(String path) throws IOException{
		file = new File(path);
		file.createNewFile();
		return file;
	}
	
	private String getDoubleDigitID(){
		if (id > new Long(9)){
			return id.toString();
		}
		return "0" + id.toString();
	}
	
	public String getLocalPath(){
		
		log.debug(">>>getLocalPath");
		
		String path = file.getPath();
		int pos = path.indexOf("media");
		
		String localpath = "/" + path.substring(pos);
		
		log.debug("type"+ localpath);
		log.debug("<<<getLocalPath");
		return localpath;
	}
	
}
