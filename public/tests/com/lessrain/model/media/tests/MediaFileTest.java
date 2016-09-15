package com.lessrain.model.media.tests;

import java.io.File;

import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.InvalidMediaFileException;
import com.lessrain.model.media.MediaFile;

import junit.framework.TestCase;

public class MediaFileTest extends TestCase {
	
	private Long id;
	
	public void setUp(){
		id = new Long("99");
	}
	
	public void testCreateMediaFile_not_null(){
		MediaFile mf = setUpTestCreateMediaFile();
		assertNotNull(mf);
	}
	public void testCreateMediaFile_matches_expected_id(){
		MediaFile mf = setUpTestCreateMediaFile();
		assertEquals(mf.getId(), id);
	}
	public void testCreateMediaFile_matches_mainAsset(){
		MediaFile mf = setUpTestCreateMediaFile();
		assertTrue(mf.getMainAsset().getSrc().indexOf("a.jpg") > -1);
	}
	public void testCreateMediaFile_matches_previewAsset(){
		MediaFile mf = setUpTestCreateMediaFile();
		assertTrue(mf.getPreviewAsset().getSrc().indexOf("b.jpg") > -1);
	}

	
	private MediaFile setUpTestCreateMediaFile(){
		File uploadedFile = new File("/media/a.jpg");
		File thumbnail = new File("/media/b.jpg");
		try {
			return MediaFile.createMediaFile(uploadedFile, thumbnail, id);
		} catch (InvalidExtensionException e) {
			fail("unable to set up test" + e.getMessage());
		} catch (InvalidMediaFileException e) {
			fail("unable to set up test" + e.getMessage());
		}
		return null;
	}

}
