<%@ tag display-name="mediafile" description="an xml representation of the mediafile"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="com.lessrain.heckmann" />
<%@ attribute name="portfolioname" required="true" %>
<%@ attribute name="message" required="false" %>

	<div class="nav">
		<div class="item">
			<c:if test="${portfolioname != 'cars'}">
	    		<a href="${initParam.approot}/admin/cars/index.html"><fmt:message key="nav.switch"/> <fmt:message key="generic.cars"/></a>
    		</c:if>
    		<c:if test="${portfolioname != 'people'}">
	    		<a href="${initParam.approot}/admin/people/index.html"><fmt:message key="nav.switch"/> <fmt:message key="generic.people"/></a>
    		</c:if>
    		<c:if test="${portfolioname != 'moods'}">
	    		<a href="${initParam.approot}/admin/moods/index.html"><fmt:message key="nav.switch"/> <fmt:message key="generic.moods"/></a>
    		</c:if>
    		<c:if test="${portfolioname != 'archivecars'}">
	    		<a href="${initParam.approot}/admin/archivecars/index.html"><fmt:message key="nav.switch"/> <fmt:message key="generic.archivecars"/></a>
    		</c:if>
    		<c:if test="${portfolioname != 'archivepeople'}">
	    		<a href="${initParam.approot}/admin/archivepeople/index.html"><fmt:message key="nav.switch"/> <fmt:message key="generic.archivepeople"/></a>
    		</c:if>
    		<c:if test="${portfolioname != 'archivemoods'}">
	    		<a href="${initParam.approot}/admin/archivemoods/index.html"><fmt:message key="nav.switch"/> <fmt:message key="generic.archivemoods"/></a>
    		</c:if>
    		<c:if test="${portfolioname != 'clients'}">
                        <a href="${initParam.approot}/admin/clients/index.html"><fmt:message key="nav.switch"/> <fmt:message key="generic.clients"/></a>
             </c:if>
    		
    		</div>
    	<div class="clear"></div>
    </div>
