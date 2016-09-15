<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="admin" uri="http://www.lessrain.com/projects/tags/admin.jar" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="com.lessrain.heckmann" />
<html>
  <head>
      <title><fmt:message key="upload.for"/> <fmt:message key="generic.${portfolioname}"/></title>
      <link rel="stylesheet" type="text/css" href="${initParam.docroot}/css/admin.css" />
    </head>
    <body>
    	<div class="content">
	       <form action="../upload/process.html" method="post" enctype="multipart/form-data" class="loaderform">
	        <input type="file" name="file" /> 
	        <div><input type="hidden" name="portfolio" value="${portfolioname}" /></div>
	        <div><input type="hidden" name="id" value="${param.id}" /></div>
	        <c:choose>
		        <c:when test="${not empty param.id}">
		        	<div><input type="submit" name="submit" value=" <fmt:message key="generic.thumbnail"/> <fmt:message key="upload.to"/> <fmt:message key="generic.${portfolioname}"/>"/></div>
		       	</c:when>
		       	<c:otherwise>
		        	<div><input type="submit" name="submit" value="<fmt:message key="upload.to"/> <fmt:message key="generic.${portfolioname}"/>"/></div>
		       	</c:otherwise>
	       	</c:choose>
	       </form>
       	</div>
    </body>
  </html>
