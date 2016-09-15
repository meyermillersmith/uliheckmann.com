<%@ tag display-name="mediafile" description="an xml representation of the mediafile"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ attribute name="portfolioname" required="true" %>
<%@ attribute name="archivename" required="true" %>
<%@ attribute name="count" required="true" %>
<%@ attribute name="mediafile" required="true" type="com.lessrain.model.media.MediaFile"%>
<fmt:setBundle basename="com.lessrain.heckmann" />
	<a name="thumb${count}"></a>
	<div class="item">
		 <div class="letter"><fmt:message key="letter${count}"/></div>
		 <div class="thumbnail"><a href="${initParam.docroot}${mediafile.mainAsset.src}"><img src="${initParam.docroot}${mediafile.previewAsset.src}" /></a></div>
		  <div class="details">
		  
		  	<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=delete&id=${mediafile.id}" onclick="return confirm('<fmt:message key="thumbnail.warning"/>')"  title="<fmt:message key="thumbnail.delete"/>"><img src="${initParam.docroot}/images/cms/delete.gif" alt="<fmt:message key="thumbnail.delete"/>" title="<fmt:message key="thumbnail.delete"/>" /></a>
		  	&nbsp;&nbsp;
		  	<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=movetotop&id=${mediafile.id}"><img src="${initParam.docroot}/images/cms/top.gif" alt="<fmt:message key="thumbnail.movetotop"/>" title="<fmt:message key="thumbnail.movetotop"/>"/ ></a>
		  	<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=moveup&id=${mediafile.id}"><img src="${initParam.docroot}/images/cms/up.gif" alt="<fmt:message key="thumbnail.moveup"/>" title="<fmt:message key="thumbnail.moveup"/>" /></a>
		  	<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=movedown&id=${mediafile.id}"><img src="${initParam.docroot}/images/cms/down.gif" alt="<fmt:message key="thumbnail.movedown"/>" title="<fmt:message key="thumbnail.movedown"/>" /></a>	
		  	<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=movetobottom&id=${mediafile.id}"><img src="${initParam.docroot}/images/cms/bottom.gif" alt="<fmt:message key="thumbnail.movetobottom"/>" title="<fmt:message key="thumbnail.movetobottom"/>" /></a>
		  	
		  	<br />
		  	<c:if test="${not empty archivename}">
		  		<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=movetoarchive&id=${mediafile.id}"><fmt:message key="thumbnail.movetoarchive"/></a>
		  	</c:if>
		  	/
		  	<a href="${initParam.approot}/upload/${portfolioname}.html?id=${mediafile.id}"><fmt:message key="thumbnail.uploadnewthumb"/></a>
			<br />
		  	<c:choose>
		  		<c:when test="${mediafile.align == 'L'}">
		  			<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=changealign&id=${mediafile.id}"><fmt:message key="thumbnail.changeright"/></a>
		  		</c:when>
		  		<c:otherwise>
		  			<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=changealign&id=${mediafile.id}"><fmt:message key="thumbnail.changeleft"/></a>
		  		</c:otherwise>
		  	</c:choose>
		  	/
		  	<c:choose>
		  		<c:when test="${mediafile.enableFill}">
		  			<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=changefill&id=${mediafile.id}"><fmt:message key="thumbnail.disablefill"/></a>
		  		</c:when>
		  		<c:otherwise>
		  			<a href="${initParam.approot}/admin/${portfolioname}/index.html?action=changefill&id=${mediafile.id}"><fmt:message key="thumbnail.enablefill"/></a>
		  		</c:otherwise>
		  	</c:choose>
			<form action="" method="get">
				<input type="hidden" name="action" value="changetext" />
				<input type="hidden" name="id" value="${mediafile.id}" />
				<input type="text" name="caption" value="${mediafile.caption}" class="caption_input"/>
				<input type="submit" value="<fmt:message key="thumbnail.submit_caption"/>" class="caption_submit"/>
			</form>
		  </div>
		  <div class="clear"></div>
	</div>