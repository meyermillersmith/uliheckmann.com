package com.lessrain.model.media.tests;

import com.lessrain.model.media.InvalidMediaFileException;
import com.lessrain.model.media.MainAsset;
import com.lessrain.model.media.MediaFile;
import com.lessrain.model.media.Portfolio;

import junit.framework.TestCase;

public class PortfolioTest extends TestCase {

	private Portfolio portfolio;
	private String name ="people";
	private Long id;
	
	public void setUp(){
		portfolio = new Portfolio(name);
		id = new Long(new Integer(400));
	}
	
	
	public void testPortfolio() {
		assertEquals(name, portfolio.getName());
	}

	/*
	 * Test method for 'com.lessrain.model.media.tests.Portfolio.addMediaFile(MediaFile)'
	 */
	public void testAddMediaFile() {
		int oldsize = portfolio.size();
		try {
			portfolio.addMediaFile(getMediaFileWithId());
		} catch (Exception e) {
			fail("MediaFile Without Id");
		}
		assertEquals((oldsize + 1), portfolio.size());
	}
	
	public void testAddMediaFile_rejects_mediaFile_without_id() {
		try{
			portfolio.addMediaFile(getMediaFile());
			fail("MediaFile Without Id");
		}catch (Exception e){
			
		}
	}
	
	public void testDeleteMediaFile(){
		try {
			int oldsize = portfolio.size();
			portfolio.addMediaFile(getMediaFileWithId());
			portfolio.deleteMediaFile(id);
			assertEquals(oldsize, portfolio.size());
			
		} catch (InvalidMediaFileException e) {
			fail("MediaFile Without Id");
		}
		
	}

	/*
	 * Test method for 'com.lessrain.model.media.tests.Portfolio.size()'
	 */
	public void testgetMediaFileById() {
		try {
			portfolio.addMediaFile(getMediaFileWithId());
		} catch (Exception e) {
			fail("MediaFile Without Id");
		}
		assertNotNull(portfolio.getMediaFileById(id));
	}
	
	public void testgetMediaFileById_returns_correct_mediaFile() {
		try {
			portfolio.addMediaFile(getMediaFileWithId());
		} catch (Exception e) {
			fail("MediaFile Without Id");
		}
		assertEquals(portfolio.getMediaFileById(id).getId(), id);
	}
	
	public void testgetMediaFileById_returns_nul_when_file_is_missing() {
		try {
			portfolio.addMediaFile(getMediaFileWithId());
		} catch (Exception e) {
			fail("MediaFile Without Id");
		}
		assertNull(portfolio.getMediaFileById(new Long("1")));
	}
	
	private MediaFile getMediaFileWithId(){
		MediaFile mf = getMediaFile();
		mf.setId(id);
		return mf;
	}
	private MediaFile getMediaFile(){
		try{
			MainAsset file = new MainAsset("a", "b");
			MediaFile mf = new MediaFile(file);
			return mf;
		}
		catch (Exception e){
			fail("unable to create mediafile");
		}
		return null;
	}

}
