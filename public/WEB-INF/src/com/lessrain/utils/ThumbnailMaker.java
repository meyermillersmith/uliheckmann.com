package com.lessrain.utils;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.mullassery.imaging.Imaging;
import com.mullassery.imaging.ImagingFactory;
import com.mullassery.imaging.util.Util;

public class ThumbnailMaker {
	
	private static Log log = LogFactory.getLog(ThumbnailMaker.class);
	
	private Imaging imaging;
	private BufferedImage original;
	
	private int desired_width = 88; 
	private int desired_height = 100; 
	
	public ThumbnailMaker(File mainfile) { 
		
		log.debug(">>>ThumbnailMaker");
		
		imaging = ImagingFactory.createImagingInstance(
				ImagingFactory.JAI_LOADER, 
				ImagingFactory.JAI_TRANSFORMER
				);
 		original = loadFromFile(mainfile);
 		
 		log.debug(">>>ThumbnailMaker");
 	} 
	
	public void makeThumbnailFrom(File target) throws FileNotFoundException{
		
		log.debug(">>>makeThumbnailFrom");
		
		BufferedImage cropped = resizeAndCrop();
		Util.saveImage(imaging,cropped,"JPEG",target);
		
		log.debug("<<<makeThumbnailFrom");
		
	}
	
	protected BufferedImage loadFromFile(File mainfile) { 
		
		log.debug(">>>makeThumbnailFrom");
		
		BufferedImage image = imaging.read(mainfile); 
		
		log.debug("<<<makeThumbnailFrom");
 		return image;
 	} 
	 
 	private BufferedImage resizeAndCrop() { 
 		
 		log.debug(">>>resizeAndCrop");
 		
 		int original_width = original.getWidth();
 		int original_height = original.getHeight();
 		
 		float ratio = calculateRatio(original_width, original_height);
 		
 		int resize_width = new Float(original_width / ratio).intValue();
 		int resize_height = new Float(original_height / ratio).intValue();
 		log.debug("resized_width: " + resize_width);
 		log.debug("resize_height: " + resize_height);
 		
 		log.debug("resizing image");
 		BufferedImage resized = imaging.resize(original, resize_width, resize_height, true);
 		
 		int x = getOffset(desired_width, resize_width);
 		int y = getOffset(desired_height, resize_height);
 		log.debug("cropx: " + x);
 		log.debug("cropy: " + y);
 		
 		log.debug("cropping image");
 		BufferedImage cropped =imaging.crop(resized, x, y, desired_width, desired_height); 
 		log.debug("<<<resizeAndCrop");
 		
 		return cropped; 
 	}

	private float calculateRatio(int original_width, int original_height) {
		log.debug(">>>calculateRatio");
		float ratio = original_width / desired_width;
 		if ((original_height / ratio) < desired_height){
 			ratio = original_height / desired_height;
 		}
 		
 		log.debug("type"+ ratio);
 		log.debug("<<<calculateRatio");
		return ratio;
	}

	private int getOffset(int desired, int resize) {
		
		log.debug(">>>getOffset");
		
		int x = 0;
 		int x_diff = (resize - desired);
 		if (x_diff > 1 ){
 			x = new Float(x_diff / 2).intValue(); 
 		}
 		log.debug("type"+ x);
 		log.debug("<<<getOffset");
		return x;
	} 
	
 	public void close(){
 		log.debug(">>>close");
 		
 		imaging = null;
 		original = null;
 		
 		log.debug("<<<close");
 	}
 	
 	
}
