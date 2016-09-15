package com.lessrain.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 * @author paul hopton
 * 
 * methods to manage authentication within a request
 *
 */
public class LoginManager {
	
	private HttpServletRequest request;
	private static Log log = LogFactory.getLog(LoginManager.class);

	/**
	 * 
	 * @param request the request with which this manager is created
	 */
	public LoginManager(HttpServletRequest request){
		log.debug(">>>LoginManager");
		this.request = request;
		log.debug("<<<LoginManager");
	}
	
	/**
	 * @return true if logged in false if not!
	 */
	public boolean isLoggedIn(){
		
		log.debug(">>>isLoggedIn");
		
		HttpSession session = request.getSession();
		Boolean att = (Boolean)session.getAttribute("loggedin");
		
		if (att == null){
			log.debug("no attempt to login return false");
			log.debug("<<<isLoggedIn");
			return false;
		}
		
		boolean loggedinStatus = att.booleanValue();
		
		log.debug("loogedin"+ loggedinStatus);
		log.debug("<<<isLoggedIn");
		
		return loggedinStatus;
		
	}
	
	
	/**
	 * checks parameters  from the request to see if they match thoes expected. Currently implements 
	 * simple lookup of values in web.xml. shoul dprobably expand into a full database lookup with 
	 * encryption. next Iteration or so...
	 * 
	 * @return true if successfuly logged in false if not
	 */
	public boolean dologin(){
		
		log.debug(">>>dologin");
		
		String requiredUser = getInitParamFromRequest("adminuser");
		String requiredPass = getInitParamFromRequest("adminpass");
	
		String user = (String)request.getParameter("user");
		if ((user != null) && (user.equals(requiredUser))){
			String password = (String)request.getParameter("password");
			if ((password != null) && (password.equals(requiredPass))){
				
				HttpSession session = request.getSession();
				session.setAttribute("loggedin", true);
				
				log.debug("login succeedded");
				log.debug("<<<dologin");
				return true;
			}
		}
		
		log.debug("login failed");
		log.debug("<<<dologin");
		return false;
		
	}
	
	/**
	 * Main method here tests to see if the user is already autenticated. then looks to see if this is an authentication attempt. 
	 * @param request
	 * @param response
	 * @return true for a ogged in user, false if not.
	 * 
	 * @throws ServletException if there is a probem forwarding to the login page
	 * @throws IOException if the login pge can't be found
	 */
	public static boolean authenticated(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		log.debug(">>>authenticated");
		
		LoginManager sessionAuth = new LoginManager(request);
		
		if ((!sessionAuth.isLoggedIn()) && (! sessionAuth.dologin())){
			
			forward("/jsp/login.jsp", request, response);
			log.info("user not authenticated");
			log.debug("<<<authenticated");
			return false;
			
		}
		
		log.info("user authenticated");
		log.debug("<<<authenticated");
		return true;
	}
	
	/**
	 * forwards the request on to the resource named by path
	 * @param path the path of the resource to which we redirect
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public static void forward(String path, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		log.debug(">>>forward");
		log.debug("type"+ path);
		
		RequestDispatcher dispatcher= request.getRequestDispatcher(path);
		dispatcher.forward(request,response);
		
		log.debug("<<<forward");
	}
	
	/**
	 * get an Initialisation Parameter (from web.xml) from a request
	 * @param param the parameter to find
	 * @return the value of the requested parameter
	 */
	protected String getInitParamFromRequest(String param){
		log.debug(">>>getInitParamFromRequest");
		
		String paramfound = request.getSession().getServletContext().getInitParameter(param);
		
		log.debug("type"+ paramfound);
		log.debug("<<<getInitParamFromRequest");
		return paramfound;
	}

}
