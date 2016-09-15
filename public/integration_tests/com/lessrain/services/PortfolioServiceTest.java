package com.lessrain.services;

import junit.framework.TestCase;

import com.lessrain.model.media.Portfolio;

public class PortfolioServiceTest extends TestCase {

	private String testName = "cars";
	private PortfolioService service;
	private Portfolio portfolio;
	
	public void setUp(){
		service = PortfolioService.getInstance();
		try{
			portfolio = service.getPortfolio(testName);
		}
		catch(Exception e){
			fail("unable to set up test. unspecific Error: " + e.getMessage());
		}
	}
	public void testGetPortfolio_returns_portfolio() {
		assertEquals(portfolio.getName(), testName);
	}
	
	
	public void testGetPortfolio_Returns_Cached(){
		String name = "dog";
		Portfolio p = new Portfolio(name);
		service.addPortfolioToCache(p);

				assertEquals(p,service.getPortfolio(name));

	}

}
