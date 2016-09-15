package com.lessrain.services.tests;

import com.lessrain.model.media.Portfolio;
import com.lessrain.services.PortfolioService;

import junit.framework.TestCase;

public class PortfolioServiceTest extends TestCase {
	

	private Portfolio testportfolio;
	private PortfolioService portfolioservice;
	private String portfolioname = "test";

	public void setUp(){
		this.testportfolio = new Portfolio(portfolioname);
		this.portfolioservice = PortfolioService.getInstance();
	}
	public void testAddPortfolioToCache() {
		portfolioservice.addPortfolioToCache(testportfolio);
		Portfolio found = portfolioservice.getPortfolio(portfolioname);
		assertEquals(found, testportfolio);
		
	}

	
	public void testClearCache() {
		portfolioservice.addPortfolioToCache(testportfolio);
		portfolioservice.clearCache();
		Portfolio missing = null;
		missing = portfolioservice.getPortfolio(portfolioname);
		assertNull(missing);
	}

	/*
	 * Test method for 'com.lessrain.services.PortfolioService.getPortfolio(String)'
	 */
	public void testGetPortfolio_retreives_from_cache() {
		testAddPortfolioToCache();
	}
	
	public void testGetPortfolio_retreives_from_db() {
		
	}

	/*
	 * Test method for 'com.lessrain.services.PortfolioService.addMediaFileToPortfolio(String, MediaFile, String)'
	 */
	public void testAddMediaFileToPortfolio() {

	}

	/*
	 * Test method for 'com.lessrain.services.PortfolioService.deleteMediaFileFromPortfolio(String, MediaFile)'
	 */
	public void testDeleteMediaFileFromPortfolio() {

	}

	/*
	 * Test method for 'com.lessrain.services.PortfolioService.emptyPortfolio(String)'
	 */
	public void testEmptyPortfolio() {

	}

	/*
	 * Test method for 'com.lessrain.services.PortfolioService.performAction(Action)'
	 */
	public void testPerformAction() {

	}

}
