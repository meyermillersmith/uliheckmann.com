package com.paulhopton.utils.tests;


import com.paulhopton.utils.URLProcessor;

import junit.framework.TestCase;

public class URLProcessorTest extends TestCase {
	
	private String path = "/path/with/slash/file.html";
	
	public void testRemoveLeadingSlash(){
		String expected = "path/with/slash/file.html";
		assertEquals(expected,URLProcessor.removeLeadingSlash(path));
	}
	
	public void testRemoveLeadingSlashLeavesUnchanged(){
		String path = "path/without/slash";
		assertEquals(path,URLProcessor.removeLeadingSlash(path));
	}
	
	public void testGetFirstElementInPath(){
		assertEquals("path", URLProcessor.getFirstElementInPath(path));
	}
	
	public void testGetSecondElementInPath(){
		assertEquals("with", URLProcessor.getSecondElementInPath(path));
	}
	
	public void testGetThirdElementInPath(){
		assertEquals("slash", URLProcessor.getThirdElementInPath(path));
	}
	
	public void testGetRequestedFile(){
		assertEquals("file.html", URLProcessor.getRequestedFile(path));
	}
	
	public void testGetRequestedFileName(){
		assertEquals("file", URLProcessor.getRequestedFileName(path));
	}
	
	public void testGetRequestedFile_no_file_part(){
		String path = "path/without/slash";
		assertNull(URLProcessor.getRequestedFile(path));
	}
	
	public void testGetRequestedFileName_no_file_part(){
		String path = "path/without/slash";
		assertNull(URLProcessor.getRequestedFile(path));
	}
	
	public void testGetLastElementInPath(){
		assertEquals("slash", URLProcessor.getLastElementInPath(path));
	}
	
	public void testGetLastElementInPath_noElement(){
		assertNull(URLProcessor.getLastElementInPath("index.html"));
	}
}
