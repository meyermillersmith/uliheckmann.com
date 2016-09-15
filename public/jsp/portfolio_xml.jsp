<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml;charset=UTF-8"%><%--
--%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%--
--%><%@ taglib prefix="xmlgen" uri="http://www.lessrain.com/projects/tags/xmlgen.jar" %><%--
--%><!DOCTYPE Gallery SYSTEM "../dtd/gallery.dtd">
<Gallery>
	<Title>${portfolio.name}</Title><%--
	--%><c:forEach items="${portfolio.mediaFiles}" var="mediafile"><%--
	    --%><xmlgen:mediafile mediafile="${mediafile}"/><%--
	--%></c:forEach>
</Gallery>
