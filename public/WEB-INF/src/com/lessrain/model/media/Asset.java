package com.lessrain.model.media;

import java.util.TreeMap;


/**
 * 
 * is the representation of a MainAsset within the system. Should be extended by other types of file.
 * 
 * known subclasses: MainAsset PreviewAsset and Large
 * 
 * @author paul hopton
 *
 */
abstract public class Asset{
	
	public int FILE = 1;
	public int PREVIEW = 2;
	public int ENLARGED = 3;
	public static int TYPE = 0;
	/**
	 * the src location of the file
	 */
	private String src;
	
	/**
	 * the type of media
	 */
	private String mediaType;
	
	/**
	 *the width of the file 
	 */
	private int width;
	
	/**
	 * the height of the file 
	 */
	private int height;
	
	private Long id;

	/**
	 * private accessor ensures we can only create a valif file
	 */
	private Asset(){
		
	}
	/**
	 * default constructor. requires src and MediaType.
	 * @throws InvalidExtensionException 
	 */
	protected Asset(String src, String mediaType) throws InvalidExtensionException{
		this.setSrc(src);
		this.mediaType = mediaType;
	}
	
	public String toString(){
		StringBuffer buff = new StringBuffer();
		buff.append(this.getClass().getSimpleName());
		buff.append("(");
		buff.append(this.hashCode());
		buff.append(") - ");
		buff.append("id:");
		if (id != null){
			buff.append(id.toString());
		} else{
			buff.append("none");
		}
		buff.append(",src:");
		buff.append(src);
		buff.append(", mediaType:");
		buff.append(mediaType);
		buff.append(", height:");
		buff.append(height);
		buff.append(", width:");
		buff.append(width);

		return buff.toString();
	}
	/**
	 * constructor requiring all four fields. performs no checking. extending classes should provide checking
	 * @param src
	 * @param mediaType
	 * @param width
	 * @param height
	 * @throws InvalidExtensionException 
	 */
	public Asset(String src, String mediaType, int width, int height) throws InvalidExtensionException {
		this.setSrc(src);
		this.mediaType = mediaType;
		this.width = width;
		this.height = height;
	}
	
	
	
	//Persistence
	public String getTablename() {
		return "file";
	}
	
	public int getType(){
		return TYPE;
	}
	
	//persistence
	public TreeMap toTreeMap() {
		TreeMap<String,Object> map = new TreeMap<String,Object>();
			map.put("src", getSrc());
			map.put("mediaType", getMediaType());
			map.put("width", getWidth());
			map.put("width", getHeight());
		return null;
	}
	
	
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	
	/**
	 * @return Returns the height.
	 */
	public int getHeight() {
		return height;
	}
	/**
	 * @param height The height to set.
	 */
	public void setHeight(int height) {
		this.height = height;
	}
	/**
	 * @return Returns the mediaType.
	 */
	public String getMediaType() {
		return mediaType;
	}
	/**
	 * @param mediaType The mediaType to set.
	 */
	public void setMediaType(String mediaType) {
		this.mediaType = mediaType;
	}
	/**
	 * @return Returns the src.
	 */
	public String getSrc() {
		return src;
	}
	
	public String getUrl(){
		String url = src.replace("\\", "/");
		return url;
	}
	/**
	 * @param src The src to set.
	 * @throws InvalidExtensionException 
	 */
	public void setSrc(String src) throws InvalidExtensionException {
		this.src = src;
	}
	/**
	 * @return Returns the width.
	 */
	public int getWidth() {
		return width;
	}
	/**
	 * @param width The width to set.
	 */
	public void setWidth(int width) {
		this.width = width;
	}
	

	/**
	 * confirms that the file name has the correct extension. not really perfect typee proofing, but will do.
	 * an advanced method would include some analysis of the file itself.
	 * @param file represents the path to be tested
	 * @param extension which we are looking for
	 * @return wether or not the string contains the extension
	 */
	public static boolean acceptableExtension(String file, String extension){
		return file.endsWith(extension);
	}
	
	

}
