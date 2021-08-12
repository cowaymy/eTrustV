<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%> 

<c:if test="${empty param.isDiv }"> <!-- div popup 이 아닌 경우에만 추가. : common.js > popupDiv 참고. -->

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" http-equiv="X-UA-Compatible" content="IE=edge">
<title>e-TRUST</title>

<tiles:insertAttribute name="var" />
<tiles:insertAttribute name="script" />

</head>

</c:if>

<tiles:insertAttribute name="body" />

<c:if test="${empty param.isDiv }"> <!-- div popup 이 아닌 경우에만 추가. : common.js > popupDiv 참고. -->
</html>
</c:if>