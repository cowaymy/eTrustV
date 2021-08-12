<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<input type="hidden" name="_TEMP_" value="<c:out value="${TEMP}"/>" />

<script>
	var javascriptLoglevel = "debug";
	var DEFAULT_DELIMITER = "|!|";
	var _SESSION_EXPIRE_MESSAGE ="<spring:message code='sys.msg.session.expired'/>";
	var DEFAULT_RESOURCE_FILE = "/resources/WebShare";

	function getContextPath() {
       return "${pageContext.request.contextPath}";
    }

</script>