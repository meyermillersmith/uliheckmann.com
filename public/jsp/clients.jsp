<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="admin" uri="http://www.lessrain.com/projects/tags/admin.jar" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="com.lessrain.heckmann" />
<html>
  <head>
      <title><fmt:message key="list.listfor"/>  <fmt:message key="generic.clients"/></title>
      <link rel="stylesheet" type="text/css" href="${initParam.docroot}/css/admin.css" />
    </head>
    <body>
    	<div class="content">
	    	<h2><fmt:message key="list.listfor"/> <fmt:message key="generic.clients"/></h2>
	    	
	    	<admin:nav portfolioname="clients" />
	    	
	    	<div class="list">
		    	<c:forEach items="${clients.list}" var="client" varStatus="count">
		    		<admin:client name="${ client }" />
		    	</c:forEach>
		    	<div class="item">
		    	<form action="" method="get" style="margin:0px 5px 5px 5px;">
					<input type="hidden" name="action" value="add" />
					<input type="text" name="name" value="" class="caption_input"/>
					<input type="submit" value="<fmt:message key="client.add"/>" class="caption_submit"/>
				</form>
		    	
		    	</div>
		    	<div class="clear"></div>
		    </div>
		    
			<admin:nav portfolioname="clients" />
	    	

       </div>
       
    </body>
  </html>