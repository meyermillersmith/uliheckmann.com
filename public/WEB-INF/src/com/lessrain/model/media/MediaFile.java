package com.lessrain.model.media;

import java.io.File;

import com.lessrain.utils.TargetPath;

public class MediaFile {
	
	public Asset mainAsset;
	public Asset previewAsset;
	public Asset largeAsset;
	public String caption;
	public String copyright;
	public String align ="L";
	public boolean enableFill = true;
	public Long id;
	

	/**
	 * Ensure that we can only call the public constructor with a field
	 */
	private MediaFile(){
		
	}
	
	/**
	 * Constructor requires a file to create valid media type.
	 * @param file
	 */
	public MediaFile(Asset file) {
		addFile(file);
	}
	
	public String toString(){
		StringBuffer buff = new StringBuffer();
		buff.append("MediaFile(");
		buff.append(this.hashCode());
		buff.append(") - ");
		buff.append("id:");
		if (id != null){
			buff.append(id.toString());
		}
		else{
			buff.append("none");
		}
		buff.append(", caption:");
		buff.append(caption);
		buff.append(", mainasset:");
		if (mainAsset != null){
			buff.append(mainAsset.toString());
		}
		buff.append(", previewAsset:");
		if (previewAsset != null){
			buff.append(previewAsset.toString());
		}
		buff.append(", align:");
		buff.append(align);
		buff.append(", enableFill:");
		buff.append(enableFill);
		return buff.toString();
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
	 * @return Returns the caption.
	 */
	public String getCaption() {
		return caption;
	}
	/**
	 * @param caption The caption to set.
	 */
	public void setCaption(String caption) {
		this.caption = caption;
	}
	/**
	 * @return Returns the copyright.
	 */
	public String getCopyright() {
		return copyright;
	}
	/**
	 * @param copyright The copyright to set.
	 */
	public void setCopyright(String copyright) {
		this.copyright = copyright;
	}
	/**
	 * @return Returns the main asset.
	 */
	public Asset getMainAsset() {
		return mainAsset;
	}
	/**
	 * @param file The file to set.
	 */
	public void setMainAsset(Asset asset) {
		mainAsset = asset;
	}
	/**
	 * @return Returns the largeFile.
	 */
	public Asset getLargeAsset() {
		return largeAsset;
	}
	/**
	 * @param largeFile The largeFile to set.
	 */
	public void setLargeAsset(Asset asset) {
		largeAsset = asset;
	}
	/**
	 * @return Returns the previewFile.
	 */
	public Asset getPreviewAsset() {
		return previewAsset;
	}
	/**
	 * @param previewFile The previewFile to set.
	 */
	public void setPreviewAsset(Asset asset) {
		previewAsset = asset;
	}
	

	/**
	 * @return Returns the align.
	 */
	public String getAlign() {
		return align;
	}
	
	public String getAlignname(){
		if (align.equals("L")){
			return "left";
		}
		return "right";
	}

	/**
	 * @param align The align to set.
	 */
	public void setAlign(String align) {
		this.align = align;
	}
	
	public boolean getEnableFill()
	{
		return enableFill;
	}
	
	public void setEnableFill( boolean enableFill_ )
	{
		enableFill = enableFill_;
	}

	public void addFile(Asset asset) {
		if (asset.getClass().getSimpleName().equals("MainAsset")){
			this.setMainAsset(asset);
		}
		else if (asset.getClass().getSimpleName().equals("PreviewAsset")){
			this.setPreviewAsset(asset);
		}
		else if (asset.getClass().getSimpleName().equals("LargeAsset")){
			this.setLargeAsset(asset);
		}
	}

	/**
	 * Create the mediaFile from the MainAsset and Preview Provided
	 * @param uploadedFile The main MainAsset
	 * @param thumbnail The generated preview
	 * @return an already persisted mediaFile
	 * @throws InvalidExtensionException
	 * @throws InvalidMediaFileException 
	 */
	public static MediaFile createMediaFile(File uploadedFile, File thumbnail, Long id) throws InvalidExtensionException, InvalidMediaFileException {
		
		MainAsset asset = new MainAsset(new TargetPath(uploadedFile).getLocalPath(),"jpg",990,600);
		PreviewAsset previewasset = new PreviewAsset(new TargetPath(thumbnail).getLocalPath(),88,100);
		
		MediaFile mf = new MediaFile(asset);
		mf.setId(id);
		mf.setPreviewAsset(previewasset);
		return mf;
	}

	/**
	 * Swith the alignment ogf the image L becomes R and R becomes L
	 */
	public void switchAlignment() {
		if (align.equals("L")){
			align = "R";
		}
		else{
			align="L";
		}
	}

	public void changeFill() {
		if (enableFill){
			enableFill = false;
		}
		else{
			enableFill = true;
		}
	}


}
