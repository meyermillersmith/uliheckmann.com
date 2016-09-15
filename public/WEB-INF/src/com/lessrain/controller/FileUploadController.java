package com.lessrain.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lessrain.model.media.InvalidExtensionException;
import com.lessrain.model.media.InvalidMediaFileException;
import com.lessrain.model.media.MediaFile;
import com.lessrain.model.media.Portfolio;
import com.lessrain.services.MediaFileService;
import com.lessrain.services.PortfolioNotFoundException;
import com.lessrain.services.PortfolioService;
import com.lessrain.utils.FileItemsToMediaFileMaker;
import com.lessrain.utils.TargetPath;
import com.paulhopton.utils.URLProcessor;

public class FileUploadController extends HttpServlet {
	
	private static final long serialVersionUID = -1576887717800129208L;
	private static Log log = LogFactory.getLog(FileUploadController.class);

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		log.debug(">>>doPost");
		String portfolioName = "index.html";
		
		if (LoginManager.authenticated(request,response)){
			try {
				
				List items = getFileItems(request);

				portfolioName = getPortfolioNameFromList(items);

				String position = getPositionFromList(items);
				
				Long id = getMediaFileIdFromItems(items);
				
				String root = "";//getServletContext().getRealPath("/");
				String mediaDir = getInitParamFromRequest("imagedirectory", request);
				
				if (id ==null){
					manageNewFileUpload(
						items,
						portfolioName,
						position,
						root,
						mediaDir
						);
				}
				else{
					manageReplacementThubnailUpload(
							items,
							id,
							portfolioName,
							mediaDir
							);
					
				}
				
				addErrorMessage("NONE", request);
				
				goToListPage(response, portfolioName);
			}
				
			catch (FileUploadException fue) {
				log.error("Problem manipulating uploaded file", fue);
				
				addErrorMessage("file", request);
				
				throw new IOException(fue.getMessage());
				
			} catch (InvalidExtensionException iee) {
				log.warn("the file had an invalid file extension",iee);
				
				addErrorMessage("file_extension", request);

				doGet(request, response);
				
			} catch (InvalidMediaFileException imfe) {
				log.warn("Problem generating MediaFile", imfe);
				
				addErrorMessage("media_file", request);
				
				goToListPage(response, portfolioName);
				
			}catch (FileNotFoundException ffe) {
				log.warn("unable to find file for thumbnail",ffe);
				
				addErrorMessage("uploaded_file_not_found", request);
				
				goToListPage(response, portfolioName);
				
			}catch (Exception e) {
				log.warn("non specific exception", e);
				
				addErrorMessage("non_specific_error", request);
				
				goToListPage(response, portfolioName);
				
			}
		}	
		log.debug("<<<doPost");
	}


	private void addErrorMessage(String message, HttpServletRequest request){
		log.debug(">>>addErrorMessage");
		
		log.debug("type"+ message);
		
		request.setAttribute("message", "error." + message);
		
		log.debug("<<<addErrorMessage");
	}

	private void manageReplacementThubnailUpload(List items, Long id, String portfolioName, String mediaDir) throws PortfolioNotFoundException, IOException, FileUploadException{
		
		log.debug(">>>manageReplacementThubnailUpload");
		
		Portfolio portfolio = PortfolioService.getInstance().getPortfolio(portfolioName);
		MediaFile mediafile = portfolio.getMediaFileById(id);
		
		String modified = mediaDir.substring(0, (mediaDir.length() - 6));
		
		TargetPath targetPath =  new TargetPath(
				modified,
				mediafile.getPreviewAsset().getSrc() );
		targetPath.getFile();
		
		FileItemsToMediaFileMaker mediaFileMaker = new FileItemsToMediaFileMaker();
		
		mediaFileMaker.manageFileModicfication(items, targetPath.getFile());
		
		log.debug("<<<manageReplacementThubnailUpload");
	}

	/**
	 * take a FileItems list. save the image to the correct place. generate a thubnail image. Create a mediaFile. Persist It. add The mediaFile to the correct Portfolio.
	 * there is a lot going on here. It seems like too much. everything has been factored out and it only needs 8 lines. 
	 * 
	 * @param items The List of fileitems
	 * @param fileSystemRoot
	 * @param imageDirectory
	 * @param string 
	 * @return
	 * @throws InvalidExtensionException 
	 * @throws InvalidMediaFileException 
	 * @throws FileUploadException
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws PortfolioNotFoundException
	 */
	private void manageNewFileUpload(List items, String portfolioName, String position, String fileSystemRoot, String imageDirectory) 
		throws 
		InvalidExtensionException, 
		InvalidMediaFileException, 
		FileUploadException, 
		FileNotFoundException, 
		IOException, 
		PortfolioNotFoundException 
		{
		log.debug(">>>manageNewFileUpload");
		
		Long nextId = MediaFileService.getInstance().getNextAvailableId();
		
		TargetPath targetPath =  new TargetPath(
				fileSystemRoot,
				imageDirectory,
				nextId );
		
		FileItemsToMediaFileMaker mediaFileMaker = new FileItemsToMediaFileMaker();
		MediaFile mediafile = mediaFileMaker.managePostedImage(items, targetPath.getFile(),targetPath.getThumbFile(), nextId);
		
		MediaFileService.getInstance().save(mediafile);
		
		PortfolioService.getInstance().addMediaFileToPortfolio(portfolioName,mediafile, position);

		log.debug("<<<manageNewFileUpload");
		
	}



	/**
	 * send a redirect to the browser
	 * @param response
	 * @param portfolioName the name of the portfolio to view
	 * @throws IOException
	 */
	private void goToListPage(HttpServletResponse response, String portfolioName) throws IOException {
		
		log.debug(">>>goToListPage");
		
		String docroot = getServletContext().getInitParameter("approot");
		String path = ( docroot + "/admin/" + portfolioName + "/index.html");
		log.debug("type"+ path);
		log.debug("<<<goToListPage");
		response.sendRedirect(path);
		
		
		
	}


	
	/**
	 * finds the portfolio name from the formfield named portfolio
	 * @param items The List of items in the upload form
	 * @return the name of the portfolio
	 */
	public String getPortfolioNameFromList(List /* FileItem */ items){
		
		log.debug(">>>getPortfolioNameFromList");
		
		String portfolioname = getFieldFromList("portfolio", items);
		
		log.debug("type"+ portfolioname);
		log.debug("<<<getPortfolioNameFromList");
		
		return portfolioname;
	}
	
	/**
	 * finds the position in which to place the uploaded item from the formfield named position
	 * @param items The List of items in the upload form
	 * @return the position
	 */
	public String getPositionFromList(List /* FileItem */ items){
		log.debug(">>>getPositionFromList");
		
		String position = getFieldFromList("position", items);
		
		log.debug("type"+ position);
		log.debug("<<<getPositionFromList");
		return position;
	}
	
	
	
	/**
	 * Loop throught he items in the list, looking for a field whose name matches that requested
	 * @param field the name of the field to find
	 * @param items the list in which to look for the items
	 * @return the value of the field if found, null if not
	 */
	private String getFieldFromList(String field, List /* FileItem */ items){
		
		log.debug(">>>getFieldFromList");
		log.debug("field to find" + field);
		
		Iterator iter = items.iterator();
		while (iter.hasNext()) {
		    FileItem item = (FileItem) iter.next();

		    if (item.isFormField() && item.getFieldName().equals(field)) {
		    	String foundfield = item.getString();
		    	
		    	log.debug("type"+ foundfield);
		    	log.debug("<<<getFieldFromList");
		    	return foundfield;
		    } 
		}
		
		log.debug("type"+ null);
    	log.debug("<<<getFieldFromList");
		return null;
	}

	/**
	 * gets the requested id from the list provided
	 * @param items the List to search
	 * @return the value of id as a Long, unless it cannot be found. then return null.
	 */
	private Long getMediaFileIdFromItems(List items) {
		
		log.debug(">>>getMediaFileIdFromItems");
		
		String id = getFieldFromList("id", items);
		
		if ((id != null) &&(id.length()>0)){
			
			Long foundid = new Long(id);
			
			log.debug("type"+ foundid);
			log.debug("<<<getMediaFileIdFromItems");
			
			return foundid;
		}
		
		log.debug("type"+ null);
		log.debug("<<<getMediaFileIdFromItems");
		return null;
	}


	/**
	 * creates a List of FileItems from the included elements in the Request
	 * @param request containing the uploaded file
	 * @return a list of MediaFiel items
	 * 
	 * @throws FileUploadException
	 */
	public List getFileItems(HttpServletRequest request) throws FileUploadException {
		log.debug(">>>getFileItems");
		//Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();
		
		//Set factory constraints
		factory.setSizeThreshold(3000000);
		String tempdirectoryName = getInitParamFromRequest("tempdirectory",request);
		factory.setRepository(new File(tempdirectoryName));
		
		//Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);
		
//		set the size in kB
		int sizeParam = new Integer(getInitParamFromRequest("maxfilesize", request)).intValue();
		log.debug("type"+ sizeParam);
		//Set overall request size constraint
		upload.setSizeMax(sizeParam);
		
		//Parse the request
		List /* FileItem */ items = upload.parseRequest(request);
		
		log.debug("<<<getFileItems");
		
		return items;
		
	}

	/**
	 * redirects to to the fie which displays the form
	 * @see com.lessrain.controller.AbstractController#manageGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		log.debug(">>>doGet");
		
		if (LoginManager.authenticated(request,response)){
			String portfolioName = URLProcessor.getRequestedFileName(request.getPathInfo());
			request.setAttribute("portfolioname", portfolioName);
			forward("/jsp/fileuploader.jsp", request, response);
		}
		
		log.debug("<<<doGet");
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
		RequestDispatcher dispatcher= request.getRequestDispatcher(path);
		dispatcher.forward(request,response);
		log.debug("<<<forward");
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


}
