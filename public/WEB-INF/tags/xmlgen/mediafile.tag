<%@ tag display-name="mediafile" description="an xml representation of the mediafile"%><%--
	--%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%--
	--%><%@ attribute name="mediafile" required="true" type="com.lessrain.model.media.MediaFile"%>
    <MediaFile id="${mediafile.id}">
        <File mediaType="${mediafile.mainAsset.mediaType}" src="${initParam['docroot']}${mediafile.mainAsset.url}" width="${mediafile.mainAsset.width}" height="${mediafile.mainAsset.height}" align="${mediafile.alignname}" enableFill="${mediafile.enableFill}" />
        <PreviewFile mediaType="${mediafile.previewAsset.mediaType}" src="${initParam['docroot']}${mediafile.previewAsset.url}" width="${mediafile.previewAsset.width}" height="${mediafile.previewAsset.height}" />
        <Caption>${mediafile.caption}</Caption>
    </MediaFile>