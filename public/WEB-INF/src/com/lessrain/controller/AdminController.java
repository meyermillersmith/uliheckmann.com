package com.lessrain.controller;

import java.io.IOException;
import java.io.PrintWriter;

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

/**
 * @author paul hopton
 * The Admin Controller handles all requests within the admin area (excluding uploads). Everything is 
 * dealt with via the doGet method. we deal with requests from a mixture of requestpaths and parameters.
 * the request path defines the name of the portfolio or section we are working on. an Action is generated
 * based on the paramteres of the request and passed to the relevant service to process.
 *
 */
public class AdminController extends HttpServlet {

	private static final long serialVersionUID = 3574961681639844014L;
	private static Log log = LogFactory.getLog(AdminController.class);


	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.debug(">>>doGet");
		
		//deal with the situation where there is no path information
		//redirect to home page
		if (request.getPathInfo() == null){
			
			log.info("no path information found redirecting to index.html");
			response.sendRedirect( "admin/index.html");
			
			log.debug("<<<doGet");
			return;
			
		}
		
		//do Authentication
		if (LoginManager.authenticated(request,response)){
			
			String portfolioName = URLProcessor.getFirstElementInPath(request.getPathInfo());
			
			log.debug("type"+ portfolioName);
			
			//deal with missing portfolioname
			if ((portfolioName == null) || (portfolioName.length() < 1) || (portfolioName.indexOf("index") > -1)){
				
				log.info("no portfolio found in path going to index page");
				log.debug("<<<doGet");
				forward("/jsp/index.jsp", request, response);
				
			}
			else if(portfolioName.equals("clients")){
				log.debug("preparing clients");
				checkCacheClearing(request);
				
				
				
				String action = "none";
				if (request.getParameter("action") != null){
					action = request.getParameter("action");
				}
				
				if (action.equals("delete")){
					ClientService.getInstance().deleteClient(request.getParameter("name"));
				}else if (action.equals("add")){
					ClientService.getInstance().addClient(request.getParameter("name"));
				}
				
				ClientList clientList = ClientService.getInstance().getClientList();
				log.trace("clients found" + clientList);

				request.setAttribute("clients", clientList);
					
				forward("/jsp/clients.jsp", request, response);
				log.debug("<<<doGet");
			}
			else{
				log.debug("preparing portfolio " + portfolioName);
				checkCacheClearing(request);
				
				Portfolio p = PortfolioService.getInstance().getPortfolio(portfolioName);
				log.trace("portfolio found");
					
				Action action = getActionFrom(request, p);
				log.trace("action created");
					
				PortfolioService.getInstance().performAction(action);
				log.trace("action passed to Portfolioservice");
					
				request.setAttribute("portfolio", p);
					
				forward("/jsp/list.jsp", request, response);
				log.debug("<<<doGet");
					
			}
		}
		toScreen("shouldn't be here", response);
		log.debug("<<<doGet");
	}


	/**
	 * check for the presence of refresh=true and clear cached portfolios
	 * @param request
	 */
	private void checkCacheClearing(HttpServletRequest request) {
		
		log.debug(">>>checkCacheClearing");
		
		if (request.getParameter("refresh") != null){
			
			log.warn("clearing cache");
			PortfolioService.getInstance().clearCache();
			log.warn("cache cleared");
		}
		
		log.debug("<<<checkCacheClearing");
		
	}
	

	/**
	 * Generate an action object from the request
	 * 
	 * @param request
	 * @param portfolio
	 * @return an Action object
	 */
	private Action getActionFrom(HttpServletRequest request, Portfolio portfolio) {
		
		log.debug(">>>getActionFrom");
		
		String requestedAction = request.getParameter("action");
		Long id = null;
		if (request.getParameter("id") != null){
			id = new Long(request.getParameter("id"));
		}
		
		Action action = new Action(requestedAction, id, portfolio); 
		action.setRequestParams(request.getParameterMap());
		
		log.debug("<<<getActionFrom");
		return action;
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		log.warn("doPost called on AdminController");
		doGet(request, response);
	}
	
	/**
	 * dump the string what to the browser
	 * @param what the text to print to the browser
	 * @param response
	 */
	protected void toScreen(String what, HttpServletResponse response){
		PrintWriter pw;
		try {
			pw = response.getWriter();
			pw.println(what);
			pw.close();
		} catch (IOException e) {
			System.out.println("unable to print with toScreen");
		}
	}
	
	/**
	 * get an Initialisation Parameter (from web.xml) from a request
	 * @param param the parameter to find
	 * @param request the request object with which we can find the initialisation params
	 * @return the value of the requested parameter
	 */
	protected String getInitParamFromRequest(String param, HttpServletRequest request){
		log.debug(">>>getInitParamFromRequest");
		
		String paramfound = request.getSession().getServletContext().getInitParameter(param);
		
		log.debug("type"+ paramfound);
		log.debug("<<<getInitParamFromRequest");
		return paramfound;
	}
	
	/**
	 * forwards the request on to the resource named by path
	 * @param path the path of the resource to which we redirect
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	protected void forward(String path, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		log.debug(">>>forward");
		log.debug("type"+ path);
		
		RequestDispatcher dispatcher= request.getRequestDispatcher(path);
		dispatcher.forward(request,response);
		
		log.debug("<<<forward");
	}
	
}
