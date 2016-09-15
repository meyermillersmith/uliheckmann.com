<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="admin" uri="http://www.lessrain.com/projects/tags/admin.jar" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="com.lessrain.heckmann" />
<html>
  <head>
      <title>Login</title>
      <link rel="stylesheet" type="text/css" href="${initParam.docroot}/css/admin.css" />
    </head>
    <body>
    	<div class="content">
    	<div class="title"><img src="${initParam.docroot}/images/cms_title.png" alt="Ulli Heckmann" /></div>
	      <div class="box">
	      		<a href="cars/index.html" class="midlink">portfolio.cars</a>
	      		<br>
	      		<a href="people/index.html" class="midlink">portfolio.people</a>
	      		<br>
	      		<a href="moods/index.html" class="midlink">portfolio.moods</a>
	      		<br>
	      		<a href="archivecars/index.html" class="midlink">archive.cars</a>
	      		<br>
	      		<a href="archivepeople/index.html" class="midlink">archive.people</a>
                <br>
                <a href="archivemoods/index.html" class="midlink">archive.moods</a>
                <br>
	      		<a href="clients/index.html" class="midlink">clients</a>
			</div>
			
       	</div>
    </body>
  </html>
