<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>e-TRUST</title>
	<tiles:insertAttribute name="var" />
	<tiles:insertAttribute name="head" />
	<tiles:insertAttribute name="css" />
	<tiles:insertAttribute name="script" />
</head>
	<body class="<tiles:insertAttribute name="bodyClass" />" id="crayonBody">
		<tiles:insertAttribute name="header" />
		<tiles:insertAttribute name="left" />
		<tiles:insertAttribute name="body" />
		<tiles:insertAttribute name="footer" />
	</body>
</html>