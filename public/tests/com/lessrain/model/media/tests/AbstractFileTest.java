package com.lessrain.model.media.tests;

import com.lessrain.model.media.Asset;

import junit.framework.TestCase;

public class AbstractFileTest extends TestCase {

	/*
	 * Test method for 'com.lessrain.model.AbstractFile.acceptableExtension(String, String)'
	 */
	public void testAcceptableExtension() {
		String ext = "jpg";
		String validpath = "imaes/files/testa.jpg";
		assertTrue(Asset.acceptableExtension(validpath,ext));
	}
	
	/*
	 * Test method for 'com.lessrain.model.AbstractFile.acceptableExtension(String, String)'
	 */
	public void testAcceptableExtension_Invalid_Extension() {
		String ext = "jpg";
		String validpath = "imaes/files/testa.gif";
		assertFalse(Asset.acceptableExtension(validpath,ext));
	}
	
	/*
	 * Test method for 'com.lessrain.model.AbstractFile.acceptableExtension(String, String)'
	 */
	public void testAcceptableExtension_Invalid_Path() {
		String ext = "jpg";
		String validpath = "imaes/files/testa";
		assertFalse(Asset.acceptableExtension(validpath,ext));
	}

}
