<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
<body class="<tiles:insertAttribute name="bodyClass" />" id="eTrustBody">
		<c:if test="${!param.isPop}">
			<tiles:insertAttribute name="header" />
			<tiles:insertAttribute name="left" />
		</c:if>
		
		<tiles:insertAttribute name="body" />
		
		<c:if test="${!param.isPop}">
		  <tiles:insertAttribute name="footer" />
		</c:if>
</body>
</html>