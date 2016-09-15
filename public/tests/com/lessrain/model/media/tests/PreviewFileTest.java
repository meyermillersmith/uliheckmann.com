package com.lessrain.model.media.tests;

import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.PreviewAsset;

import junit.framework.TestCase;

public class PreviewFileTest extends TestCase {

	
	private PreviewAsset previewfile;
	private String src = "images/imagex.jpg";
	public void setUp(){
		try {
			previewfile = new PreviewAsset(src);
		} catch (InvalidExtensionException unexpected) {
			fail("unable to setUp test");
		}
	}
	/*
	 * Test method for 'com.lessrain.model.PreviewFile.setSrc(String)'
	 */
	public void testSetSrc() {
		String src = "images/image.jpg";
		try {
			previewfile.setSrc(src);
		} catch (InvalidExtensionException unexpected) {
			fail();
		}
		assertEquals(src, previewfile.getSrc());
	}
	public void testSetSrc_Throws_Exception() {
		String src = "images/image.gif";
		try{
			previewfile.setSrc(src);
			fail("should throw exception");
		}
		catch (Exception expected) {
			assertEquals("InvalidExtensionException", expected.getClass().getSimpleName());
		}
	}
	
	public void testGetMediaType(){
		assertEquals("jpg", previewfile.getMediaType());
	}

}
