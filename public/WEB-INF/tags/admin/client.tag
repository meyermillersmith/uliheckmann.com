<%@ tag display-name="mediafile" description="an xml representation of the mediafile"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="com.lessrain.heckmann" />
<%@ attribute name="name" required="true" %>
<div class="item">
	&nbsp;${ name }
	<a href="${initParam.approot}/admin/clients/index.html?action=delete&name=${name}"><fmt:message key="client.delete"/></a>
</div>