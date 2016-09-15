package com.lessrain.model.media;


/**
 * @author paul hopton
 * 
 * a normal file. Full size. what we want to see
 *
 */
public class MainAsset extends Asset {

	private String align;
	private String duration;
	private boolean autoPlay;
	private boolean loop;
	
	public static int TYPE = 1;
	
	/**
	 * constructor requiring all four fields. performs no checking. extending classes should provide checking
	 * @param src
	 * @param mediaType
	 * @param width
	 * @param height
	 * @throws InvalidExtensionException 
	 */
	public MainAsset(String src, String mediaType, int width, int height) throws InvalidExtensionException {
		super(src, mediaType, width, height);
	}
	
	public MainAsset(String src, String mediaType) throws InvalidExtensionException{
		super(src, mediaType);
	}
	
	/**
	 * @return Returns the align.
	 */
	public String getAlign() {
		return align;
	}
	
	
	/**
	 * setter with basic checking must be either "left" or "right"
	 * @param align The align to set.
	 */
	public void setAlign(String align) {
		if (align.equals("left") || align.equals("right")){
			this.align = align;
		}
		else{
			throw new RuntimeException("bad alignment");
		}
	}
	/**
	 * @return Returns the autoPlay.
	 */
	public boolean isAutoPlay() {
		return autoPlay;
	}
	/**
	 * @param autoPlay The autoPlay to set.
	 */
	public void setAutoPlay(boolean autoPlay) {
		this.autoPlay = autoPlay;
	}
	/**
	 * @return Returns the duration.
	 */
	public String getDuration() {
		return duration;
	}
	/**
	 * @param duration The duration to set.
	 */
	public void setDuration(String duration) {
		this.duration = duration;
	}
	/**
	 * @return Returns the loop.
	 */
	public boolean isLoop() {
		return loop;
	}
	/**
	 * @param loop The loop to set.
	 */
	public void setLoop(boolean loop) {
		this.loop = loop;
	}
	
	
	
}
