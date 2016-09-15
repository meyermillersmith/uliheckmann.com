package com.paulhopton.utils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;



/**
 * @author paul hopton
 * A collection of utilites fro analysing a url string. eg element/element/file.extension
 */
public class URLProcessor {
	
	private static Log log = LogFactory.getLog(URLProcessor.class);

	/**
	 * @param path the path to analyse
	 * @returns path without any leading slash. If there is no leading slash it reamains untouched
	 */
	public static String removeLeadingSlash(String path){
		
		log.debug(">>>removeLeadingSlash");
		log.debug("path" + path);
		
    	if (path.startsWith("/")){
    		
    		log.debug("<<<removeLeadingSlash");
    		return path.substring(1);
    		
    	}
    	
    	log.debug("<<<removeLeadingSlash");
    	return path;
    }
    
    /**
     * eg: return getFirstElementInPath("/first/in/path/file.html") -> "first"
     * @param path the path to analyse
     * @return the first element in path 
     * 
     */
    public static String getFirstElementInPath(String path){
    	log.debug(">>>getFirstElementInPath");
    	log.debug("path" + path);
    	
    	String element = getNumberedObjectInPath(path, 1);
    	
    	log.debug("<<<getFirstElementInPath");
    	return element;
    }

	/**
	 * eg: return getSecondElementInPath("/first/in/path/file.html") -> "in"
	 * @param path the path to analyse
	 * @return the secondelement in the path
	 */
	public static String getSecondElementInPath(String path) {
		log.debug(">>>getSecondElementInPath");
		log.debug("path" + path);
		
		String element = getNumberedObjectInPath(path, 2);
		
		log.debug("<<<getSecondElementInPath");
		return element;
	}
	
    /**
     * eg: return getThirdElementInPath("/first/in/path/file.html") -> "path"
     * @param path the path to analyse
     * @return the third element in the path
     */
    public static String getThirdElementInPath(String path) {
    	log.debug(">>>getThirdElementInPath");
    	log.debug("path" + path);
    	
    	String element = getNumberedObjectInPath(path, 3);
    	
    	log.debug("<<<getThirdElementInPath");
    	return element;
	}
	
	/**
	 * returns the element in the path identified by position
	 * eg: return getNumberedObjectInPath("/first/in/path/file.html",3) -> "path"
	 * @param path the path to analyse
	 * @param position the position of the lement to find
	 * @return the element in the path identified by position
	 */
	private static String getNumberedObjectInPath(String path, int position){
		log.debug(">>>getNumberedObjectInPath");
		log.debug("path" + path);
		log.debug("position" + position);
		
		if (path != null){
			String []parts = path.split("/");
			if (parts.length > position){
				
				log.debug("type"+ parts[position]);
				log.debug("<<<getNumberedObjectInPath");
				return parts[position];
				
			}
		}
		
		log.debug("type"+ null);
		log.debug("<<<getNumberedObjectInPath");
		return null;
		
	}
	
	
	
	/**
	 * returns the part of the url representing the file.
	 * 
	 * eg: return getRequestedFile("/first/in/path/file.html") -> "file.html"
	 * 
	 * if there is no filepart present then we return null. 
	 * 
	 * eg: return getRequestedFile("/first/in/path/file") -> null
	 * 
	 * We could of course return the 
	 * last element or Directory in the url, however this may be misleading. much better
	 * 
	 * String found = getRequestedFile("/first/in/path/file");
	 * if (found == null){
	 * 		found = getLastElementInPath("/first/in/path/file");
	 * }
	 * 
	 * 
	 * @param path the path to analyse
	 * @returns the portion of the fle representing a file
	 */
	public static String getRequestedFile(String path){
		log.debug(">>>getRequestedFile");
		log.debug("path" + path);
		
		if (path != null){
			String []parts = path.split("/");
			String last = parts[(parts.length - 1)];
			if (last.indexOf(".") > -1 ){
				
				log.debug("type"+ last);
				log.debug("<<<getRequestedFile");
				return last;
			}
		}
		
		log.debug("type"+ null);
		log.debug("<<<getRequestedFile");
		return null;
	}

	/**
	 * eg: return getNumberedObjectInPath("/first/in/path/file.html",3) -> "file"
	 * @param path the path to analyse
	 * @return the portion of the fle representing a file, without extension
	 */
	public static String getRequestedFileName(String path) {
		
		log.debug(">>>getRequestedFileName");
		log.debug("path" + path);
		
		String fullFileName = getRequestedFile(path);
		if (fullFileName != null){
			
			int dotPos = fullFileName.indexOf(".");
			
			String filename = fullFileName.substring(0,dotPos);
			
			log.debug("type"+ filename);
			log.debug("<<<getRequestedFileName");
			return filename;
			
		}
		
		log.debug("type"+ null);
		log.debug("<<<getRequestedFileName");
		return null;
	}

	/**
	 * finds the last non-file element in the url. if there are no elements or just a filename we return null
	 * @param path the path to analyse
	 * @return the last non-file element in path
	 */
	public static Object getLastElementInPath(String path) {
		
		log.debug(">>>getLastElementInPath");
		log.debug("path" + path);
		
		Object element = null;
		
		if (path != null){
			String []parts = path.split("/");
			String last = parts[(parts.length - 1)];
			if (last.indexOf(".") > -1 ){
				if (parts.length - 2 < 0){
					
					log.debug("type"+ element);
					log.debug("<<<getLastElementInPath");
					return element;
					
				}
				
				element = parts[(parts.length - 2)];

				log.debug("type"+ element);
				log.debug("<<<getLastElementInPath");
				return element;
			}
			
			element = last;
			
			log.debug("type"+ element);
			log.debug("<<<getLastElementInPath");
			return element;
			
		}
		
		log.debug("type"+ element);
		log.debug("<<<getLastElementInPath");
		return element;
		
	}
	
	/**
	 * works out at which positionin the path the object is to be found
	 * @param path
	 * @param sought
	 * @return the position at which the object was found or -1 if the object was not there
	 */
	public static int getObjectPositionInPath(String path, String sought){
		
		log.debug(">>>getObjectPositionInPath");
		log.debug("path" + path);
		log.debug("sought" + sought);
		
		if (path != null){
			String []parts = path.split("/");
			for(int i = 0; i< parts.length; i++){
				if (parts[i].equals(sought)){
					
					log.debug("objectposition" + i);
					log.debug("<<<getObjectPositionInPath");
					return i;
				}
			}
		}
		log.debug("objectnot found in path (returning -1)");
		log.debug("<<<getObjectPositionInPath");
		return -1;
	}
	
	
}
