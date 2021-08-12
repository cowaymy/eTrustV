<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8" http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title>eTrust system</title>

    <tiles:insertAttribute name="var" />
    <tiles:insertAttribute name="css" />
    <tiles:insertAttribute name="script" />
    <tiles:insertAttribute name="head" />

</head>



<body class="<tiles:insertAttribute name="bodyClass" />" id="eTrustBody">
		<tiles:insertAttribute name="header" />
		<tiles:insertAttribute name="left" />
		<tiles:insertAttribute name="body" />
		<tiles:insertAttribute name="footer" />
</body>
</html>