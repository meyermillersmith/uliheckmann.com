package com.lessrain.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.InvalidMediaFileException;
import com.lessrain.model.media.MediaFile;
import com.lessrain.utils.image.ImageSpecification;
import com.lessrain.utils.image.conversion.MakerFactory;
import com.lessrain.utils.image.conversion.MakerI;

public class FileItemsToMediaFileMaker {
	
	public static int OK = 0;
	public static int FILESIZE_ERROR = 1;
	public static int FILETYPE_ERROR = 2;
	public static int IMAGE_DIMENSION_ERROR = 3;
	
	private static Log log = LogFactory.getLog(FileItemsToMediaFileMaker.class);
	
	
	/**
	 * manages the business of posted images.
	 * @param items
	 * @param targetPath
	 * @return 
	 * @throws InvalidExtensionException
	 * @throws InvalidMediaFileException
	 * @throws FileUploadException
	 * @throws FileNotFoundException 
	 */
	public MediaFile managePostedImage(List items, File mainfile, File thumbfile, Long id) throws InvalidExtensionException, InvalidMediaFileException, FileUploadException, FileNotFoundException {

		log.debug(">>>managePostedImage");
		
		manageFileModicfication(items, mainfile);
		createThumbnail(mainfile,thumbfile);
		
		MediaFile mf = MediaFile.createMediaFile(mainfile, thumbfile, id);
		
		log.debug("type"+ mf);
		log.debug("<<<managePostedImage");
		return mf;
	}
	
	public void manageFileModicfication(List items, File mainfile) throws FileUploadException{
		
		log.debug(">>>manageFileModicfication");
		
		FileItem item = getFileItemFromList(items);
		modifyFile(item, mainfile);
		
		log.debug("<<<manageFileModicfication");
	}


	
	private void createThumbnail(File uploadedFile , File thumbfile) throws FileNotFoundException{
		
		log.debug(">>>createThumbnail");
		
		ImageSpecification spec = new ImageSpecification(100,88,"jpg");
		spec.setThumbnail(true);
		spec.setAction("CroppedThumbnail");
		
		MakerI maker =new  MakerFactory().getMakeableFromImageSpecification(spec);
		
		boolean res = maker.makeImage(uploadedFile, thumbfile, spec);
		
		log.debug("result from thumbnail creation = " + res);
		log.debug("<<<createThumbnail");
	}
	
	/**
	 * transforms the fileItem into a MainAsset object in the requested location
	 * @param item The FileItem representing the Uploaded MainAsset (either in memory or tmp)
	 * @param targetfile The location to which the file should move
	 * @return A MainAsset object representing the file in it's new location
	 * @throws FileUploadException 
	 * @throws Exception
	 */
	private File modifyFile(FileItem item, File targetfile) throws FileUploadException{
		
		log.debug(">>>modifyFile");
		
		 try {
			item.write(targetfile);
		} catch (Exception e) {
			log.warn("problem moving the uploaded asset", e);
			throw new FileUploadException();
		}
		
		log.debug("<<<modifyFile");
		
		 return targetfile;
	}
	

	/**
	 * @param items items The List of items in the upload form
	 * @returns the uploaded MainAsset as a FileItem
	 */
	public FileItem getFileItemFromList(List /* FileItem */ items) {
		
		log.debug(">>>getFileItemFromList");
		
		Iterator iter = items.iterator();
		
		while (iter.hasNext()) {
		    
			FileItem item = (FileItem) iter.next();
		   
			if (!item.isFormField()) {
		    	
		    	log.debug("file creation unsuccessful");
				log.debug("<<<getFileItemFromList");
		    	return item;
		    	
		    }
		}
		
		log.debug("file creation unsuccessful");
		log.debug("<<<getFileItemFromList");
		return null;
		
	}
	
	

}
