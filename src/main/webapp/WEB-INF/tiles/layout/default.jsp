<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1"/>
    <meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport"/>
    <title>eTrust system</title>
    
	<tiles:insertAttribute name="var" />
	<tiles:insertAttribute name="css" />
	<tiles:insertAttribute name="script" />
	<tiles:insertAttribute name="head" />
	
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