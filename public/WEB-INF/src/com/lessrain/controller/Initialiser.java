package com.lessrain.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.services.ConfigService;

import snaq.db.ConnectionPool;
import snaq.db.ConnectionPoolManager;


public class Initialiser extends HttpServlet{
	
		private static final long serialVersionUID = -8181922917427938292L;
		private static Log log = LogFactory.getLog(Initialiser.class);
		
		ConnectionPoolManager cpm = null;
		private static String rootPath = null;
		
		public void init(ServletConfig config) throws ServletException{
			log.debug(">>>init");
			super.init(config);
			initRootPath();
			initDbPool(config);
			log.debug("<<<init");
		}


		public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
			PrintWriter out = res.getWriter();
			if ((req.getParameter("reload") != null) && (req.getParameter("reload").equals("true"))){
				out.println("reloading");
				init(getServletConfig());
				out.println("reloaded");
			}
			out.print(cpm.toString());
			out.close();
		}
		
		public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
			doGet(req,res);
		}
		
		public void destroy(){
			cpm.release();
		}
			

		
		public void initRootPath(){
			log.debug(">>>initRootPath");
			try{
				setRootPath(getServletContext().getRealPath("/"));
				getServletContext().setAttribute("rootpath",getRootPath());
			}
			catch(Exception e){
				log.warn("Initialiser having problems creating RootPath",e);
			}
			log.debug("<<<initRootPath");
		}
		public void initDbPool(ServletConfig config){
			log.debug(">>>initDB");
			try{
				
				String name = 	"local";
				//String url 	= 	"jdbc:mysql:///heckmann";
				String url 	= 	config.getInitParameter("db_url");
				log.debug("type"+ url);
				
				String user	=	config.getInitParameter("db_user");
				log.debug("type"+ user);
				
				String pass = 	config.getInitParameter("db_pass");
				
				int maxpool	= 	10;
				int maxconn = 	30;
				int expiry 	= 	36000;
				
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				ConnectionPool pool = new ConnectionPool( 
					name,
					maxpool,
					maxconn,
					expiry,
					url,
					user,
					pass
				);

				ConfigService.getInstance().setPool(pool);
				
				//initialise the manager
				//cpm = ConnectionPoolManager.getInstance();
				
				//store the manager object in the application attribute
				//getServletContext().setAttribute("dbpool",cpm);
			}
			
			catch (Exception e){
				log.warn("DataConnector has non-specific Problem by init", e);
			}
			log.debug("<<<initDB");
		}

        /**
         * @param rootPath The rootPath to set.
         */
        public void setRootPath(String _rootPath) {
            rootPath = _rootPath;
        }

        /**
         * @return Returns the rootPath.
         */
        public static String getRootPath() {
            return rootPath;
        }
	
	}