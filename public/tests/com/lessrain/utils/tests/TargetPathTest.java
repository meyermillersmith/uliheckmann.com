package com.lessrain.utils.tests;

import java.io.File;
import java.io.IOException;

import com.lessrain.utils.TargetPath;

import junit.framework.TestCase;

public class TargetPathTest extends TestCase {
	
	private String root;
	private String dir;
	private TargetPath targetpath;
	private Long id;

	public void setUp(){
		root = "/";
		dir = "testdir";
		id = new Long(8);
		targetpath = new TargetPath(root,dir,id);
	}
	
	public void testGetPathSingleFigure(){
		String expected = root + dir + "/image_0" + id + ".jpg";
		assertEquals(expected,targetpath.getPath());
	}
	
	public void testGetPath2Figure(){
		Long id = new Long(18);
		TargetPath targetpath = new TargetPath(root,dir,id);
		String expected = root + dir + "/image_" + id + ".jpg";
		assertEquals(expected,targetpath.getPath());
	}
	
	public void testGetThumbPath(){
		String expected = root + dir + "/image_0" + id + "_thumb.jpg";
		assertEquals(expected,targetpath.getThumbPath());
	}
	public void testGetFile(){
		
		File basedir = new File(root + dir);
		basedir.mkdir();
		
		if (basedir.exists()){
			File file = null;
			try {
				file = targetpath.getFile();
				assertTrue(file.exists());
			} catch (IOException e) {
				System.out.println(targetpath.getPath());
				fail("IO error " + e.getMessage());
			}
			
			if ((file != null) && (file.exists())){
				file.delete();
			}
			basedir.delete();
		}
		else{
			fail("unable to set up basedir");
		}
		
	}

}
