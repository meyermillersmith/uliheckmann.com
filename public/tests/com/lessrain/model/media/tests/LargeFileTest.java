package com.lessrain.model.media.tests;

import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.LargeAsset;

import junit.framework.TestCase;

public class LargeFileTest extends TestCase {

	
	private LargeAsset largefile;
	private String src = "images/imagex.jpg";
	
	public void setUp(){
		try {
			largefile = new LargeAsset(src);
		} catch (InvalidExtensionException unexpected) {
			fail("unable to construct test");
		}
	}
	/*
	 * Test method for 'com.lessrain.model.PreviewFile.setSrc(String)'
	 */
	public void testSetSrc() {
		String src = "images/image.jpg";
		try {
			largefile.setSrc(src);
		} catch (InvalidExtensionException unexpected) {
			fail();
		}
		assertEquals(src, largefile.getSrc());
	}
	public void testSetSrc_Throws_Exception() {
		String src = "images/image.gif";
		try{
			largefile.setSrc(src);
			fail("should throw exception");
		}
		catch (Exception expected) {
			assertEquals("InvalidExtensionException", expected.getClass().getSimpleName());
		}
	}
	
	public void testGetMediaType(){
		assertEquals("jpg", largefile.getMediaType());
	}

}
