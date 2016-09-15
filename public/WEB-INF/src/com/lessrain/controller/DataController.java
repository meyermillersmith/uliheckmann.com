package com.lessrain.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.model.ClientList;
import com.lessrain.model.media.Portfolio;
import com.lessrain.services.ClientService;
import com.lessrain.services.PortfolioService;
import com.paulhopton.utils.URLProcessor;

public class DataController extends HttpServlet {

	private static final long serialVersionUID = 7200253754828491442L;
	private static Log log = LogFactory.getLog(DataController.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.debug(">>>doGet");
		
		String requested = URLProcessor.getRequestedFileName(request.getPathInfo());

		log.debug("type"+ requested);

		String target;
		if (requested.equals("clients")){
			loadClientList(request);
			target = "clients";
		}
		else{
			loadPortfolio(request, requested);
			target = "portfolio";
		}
		
			
		log.debug("portfolio found");
		log.debug("<<<doGet");
		RequestDispatcher dispatcher= request.getRequestDispatcher("/jsp/" + target + "_xml.jsp");
		dispatcher.forward(request,response);

		
	}

	private void loadClientList(HttpServletRequest request) {
		log.debug(">>>loadClientList");
		ClientList list = ClientService.getInstance().getClientList();
		request.setAttribute("clients", list);
		log.debug("<<<loadClientList");
	}

	private void loadPortfolio(HttpServletRequest request, String requested) {
		log.debug(">>>loadPortfolio");
		Portfolio portfolio = PortfolioService.getInstance().getPortfolio(requested);
		request.setAttribute("portfolio", portfolio);
		log.debug("<<<loadPortfolio");
	}

}
