package com.lessrain.model.media;

/**
 * represents a Large format file. Typically an enlarged version of the normal file
 * 
 * @author paul hopton
 *
 */
public class LargeAsset extends Asset {

	/**
	 *  full constructor 
	 *  
	 * @param src the source of the image file
	 * @param width the width of the image file
	 * @param height of the image file
	 * @throws InvalidExtensionException 
	 */
	public LargeAsset(String src, int width, int height) throws InvalidExtensionException {
		super(src, "jpg", width, height);
	}
	
	/**
	 * minimal constructor
	 * @throws InvalidExtensionException 
	 */
	public LargeAsset(String src) throws InvalidExtensionException {
		super(src, "jpg");
	}
	
	/**
	 * provide filename based checking tht file is a JPEG
	 * @see com.lessrain.model.media.tests.Asset#setSrc(java.lang.String)
	 */
	public void setSrc(String src) throws InvalidExtensionException{
		if (!Asset.acceptableExtension(src, "jpg")){
			throw new InvalidExtensionException();
		}
		super.setSrc(src);
	}
	
	/** 
	 * MediaType is always JPG
	 * @return "jpg";
	 */
	public String getMediaType(){
		return "jpg";
	}


}
