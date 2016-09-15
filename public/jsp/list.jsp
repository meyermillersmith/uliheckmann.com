<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="admin" uri="http://www.lessrain.com/projects/tags/admin.jar" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="com.lessrain.heckmann" />
<html>
  <head>
      <title><fmt:message key="list.listfor"/>  <fmt:message key="generic.${portfolio.name}"/></title>
      <link rel="stylesheet" type="text/css" href="${initParam.docroot}/css/admin.css" />
    </head>
    <body>
    	<div class="content">
	    	<h2><fmt:message key="list.listfor"/> <fmt:message key="generic.${portfolio.name}"/></h2>
	    	
	    	<admin:nav portfolioname="${portfolio.name}" />
	    	<admin:uploader portfolioname="${portfolio.name}" position="top" />
	    	
	    	<div class="list">
		    	<c:forEach items="${portfolio.mediaFiles}" var="mediafile" varStatus="count">
		    		<admin:thumbnail portfolioname="${portfolio.name}" mediafile="${mediafile}" count="${count.count}" archivename="${portfolio.archiveName}" />
		    	</c:forEach>
		    	<div class="clear"></div>
		    </div>
		    <admin:uploader portfolioname="${portfolio.name}" position="bottom" />
	    	<admin:nav portfolioname="${portfolio.name}" />
	    	
	    	<c:if test="${showuploader}">
		    	
	       </c:if>
	       
       </div>
       
    </body>
  </html>