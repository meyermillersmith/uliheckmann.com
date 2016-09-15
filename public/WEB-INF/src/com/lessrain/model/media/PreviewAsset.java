package com.lessrain.model.media;

/**
 * @author paul hopton
 * 
 * represents the preview image. Typically a preview to a normal image file
 *
 */
public class PreviewAsset extends Asset {

	public static int TYPE = 2;
	/**
	 *  full constructor 
	 *  
	 * @param src the source of the image file
	 * @param width the width of the image file
	 * @param height of the image file
	 * @throws InvalidExtensionException 
	 */
	public PreviewAsset(String src, int width, int height) throws InvalidExtensionException {
		super(src, "jpg", width, height);
	}
	
	/**
	 * minimal constructor
	 * @throws InvalidExtensionException 
	 */
	public PreviewAsset(String src) throws InvalidExtensionException {
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
