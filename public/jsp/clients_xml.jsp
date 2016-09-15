<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml;charset=UTF-8"%><%--
--%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%--
--%><!DOCTYPE Gallery SYSTEM "../dtd/clients.dtd">
<Clients>
	<Title>Clients</Title><%--
	--%><c:forEach items="${clients.list}" var="client"><%--
	    --%><Client>${client}</Client><%--
	--%></c:forEach>
</Clients>
