package com.lessrain.model.media.tests;

import com.lessrain.model.media.MainAsset;

import junit.framework.TestCase;

public class MainAssetTest extends TestCase {

	private MainAsset file;
	private String src = "images/imagex.jpg";
	private String type = "jpg";

	protected void setUp() throws Exception {
		super.setUp();
		file = new MainAsset(src, type);
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	/*
	 * Test method for 'com.lessrain.model.File.setAlign(String)'
	 */
	public void testSetAlign_Left() {
		String align = "left";
		file.setAlign(align);
		assertEquals(align, file.getAlign());
	}
	
	/*
	 * Test method for 'com.lessrain.model.File.setAlign(String)'
	 */
	public void testSetAlign_Right() {
		String align = "right";
		file.setAlign(align);
		assertEquals(align, file.getAlign());
	}
	
	/*
	 * Test method for 'com.lessrain.model.File.setAlign(String)'
	 */
	public void testSetAlign_Bad_Input() {
		String align = "sausage";
		try{
			file.setAlign(align);
			fail("bad alignments should not work");
		}
		catch (Exception expected){
			
		}
	}

}
