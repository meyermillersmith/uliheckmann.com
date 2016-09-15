<%@ tag display-name="uploader" description=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<fmt:setBundle basename="com.lessrain.heckmann" />

<%@ attribute name="portfolioname" required="true" %>
<%@ attribute name="position" required="true" %>
<div class="inlineuploader">
<form action="${initParam.approot}/upload/process.html" method="post" enctype="multipart/form-data">
    <input type="file" name="file" /><input type="hidden" name="portfolio" value="${portfolioname}" /><input type="hidden" name="position" value="${position}" />
    <input type="submit" name="submit" value="<fmt:message key="upload.to"/> <fmt:message key="generic.${portfolioname}"/>"/>
</form>
</div>