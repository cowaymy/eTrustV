<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, user-scalable=no">

	<title>eTrust system</title>

    <tiles:insertAttribute name="var" />
    <tiles:insertAttribute name="css" />
    <tiles:insertAttribute name="script" />
    <tiles:insertAttribute name="head" />

</head>

<body class="<tiles:insertAttribute name="bodyClass" />" id="eTrustBody">
		<tiles:insertAttribute name="header" />
		<tiles:insertAttribute name="left" />

		<div id="wrap">
		<tiles:insertAttribute name="body" />
		</div>

		<tiles:insertAttribute name="footer" />
</body>
</html>