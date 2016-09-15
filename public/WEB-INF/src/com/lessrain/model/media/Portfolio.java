package com.lessrain.model.media;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

/**
 * represents a portfolio
 * @author paul hopton
 *
 */
public class Portfolio {
	
	/**
	 * A list containing the mediafiles which constitute the portfolio
	 */
	private List<MediaFile> mediaFiles;
	
	/**
	 * The name of the portfolio
	 */
	private String name;

	private String archiveName;
	
	public String toString(){
			StringBuffer buff = new StringBuffer();
			buff.append(this.getClass().getSimpleName());
			buff.append("(");
			buff.append(this.hashCode());
			buff.append(") - ");
			buff.append("name:");
			buff.append(name);
			buff.append("files:");
			buff.append(mediaFiles.size());

			return buff.toString();
	}
	

	/**
	 * to ensure a valid portfolio, we only allow constructing with a name
	 */
	private Portfolio() {
		mediaFiles = new Vector<MediaFile>();
	}
	
	/**
	 * 
	 * @param name the name of the portfolio
	 */
	public Portfolio(String name) {
		this.name = name;
		mediaFiles = new Vector<MediaFile>();
	}

	/**
	 * @return Returns the mediaFiles.
	 */
	public List<MediaFile> getMediaFiles(){	
		return mediaFiles;
	}

	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * adds the provided media file to the collection
	 * @param mediafile the mediafile to be added
	 * @throws Exception 
	 */
	public void addMediaFile(MediaFile mediafile) throws InvalidMediaFileException{
		if (mediafile.getId() == null){
			throw new InvalidMediaFileException("MediaFile has no id");
		}
		mediaFiles.add(mediafile);
	}
	
	/**
	 * @return the number of mediaFiles contained
	 */
	public int size(){
		return mediaFiles.size();
	}

	/**
	 * here I'm looping through the list to find a matching id. 
	 * TODO We might consider using a map to store the mediaFiles it would be more efficient ...
	 * @param id the id of the MediaFile to find
	 * @return the mediafile matching the given id or null, if nothing is found.
	 */
	public MediaFile getMediaFileById(Long id) {
		int pos = findMediaFileById(id);
		if (pos > -1){
			return mediaFiles.get(pos);
		}
		return null;
	}
	
	private int findMediaFileById(Long id){
		Iterator it = mediaFiles.iterator();
		int cnt = 0;
		while (it.hasNext()){
			MediaFile mf = (MediaFile)it.next();
			if (mf.getId().equals(id)){
				return cnt;
			}
			cnt ++;
		}
		return -1;
	}

	
	/** Rmove the specified MediaFile
	 * @param id the id of the mediafile to remove;
	 */
	public void deleteMediaFile(Long id) {
		int pos = findMediaFileById(id);
		if (pos > -1){
			mediaFiles.remove(findMediaFileById(id));
		}
	}
	
	public void moveFileUp(Long id){
		int pos = findMediaFileById(id);
		if (pos > 0){
			Collections.swap(mediaFiles,pos-1,pos);
		}
	}
	public void moveFileDown(Long id){
		int pos = findMediaFileById(id);
		if (pos < mediaFiles.size() -1){
			Collections.swap(mediaFiles,pos,pos+1);
		}
	}

	public void moveFileToTop(Long id) {
		int pos = findMediaFileById(id);
		List<MediaFile> newmediaFiles = new Vector<MediaFile>();
		newmediaFiles.add(mediaFiles.get(pos));
		mediaFiles.remove(pos);
		newmediaFiles.addAll(mediaFiles);
		mediaFiles = newmediaFiles;
	}

	public void moveFileToBottom(Long id) {
		int pos = findMediaFileById(id);
		MediaFile mediafile = mediaFiles.get(pos);
		mediaFiles.remove(pos);
		mediaFiles.add(mediafile);
	}

	public void addMediaFileToTop(MediaFile mediaFileToAdd) {
		mediaFiles.add(mediaFileToAdd);
		moveFileToTop(mediaFileToAdd.getId());
	}

	public void setArchiveName(String archiveName) {
		this.archiveName = archiveName;
	}

	/**
	 * @return Returns the archiveName.
	 */
	public String getArchiveName() {
		return archiveName;
	}
	
	

}
