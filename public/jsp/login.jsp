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
	      <form action="index.jsp" method="post" class="login">
	      	<div><label for="user"><fmt:message key="login.user"/></label>
				<br /><input type="text" id="user" name="user" value="" /></div>
			<div><label for="password"><fmt:message key="login.pass"/></label>
			<br /><input type="password" name="password" value=""  /></div>

			<div><input type="submit" value="login"  /></div>
			</form>
       	</div>
    </body>
  </html>
