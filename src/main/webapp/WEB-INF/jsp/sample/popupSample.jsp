<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="title.sample" /></title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/resources/css/egovframework/sample.css'/>"/>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-2.2.4.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/common.js"></script>        <!-- 일반 공통 js -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/util.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.serializejson.js"></script> <!-- Form to jsonObject -->
        
    <script type="text/javaScript" language="javascript">
    
    $(function() {

    });

    function fn_openDivPop(){

    	var jsonObj = {
    	    	param01 : "param01",
    	    	param02 : "param02",
    	    	param03 : "param03",
    	};
        
        var divObj = Common.popupDiv("/sample/sampleView.do", jsonObj, function(params){
            alert("params01 : " + params.param01);
        });
    }

    function fn_openWinPop(){
       Common.popupWin("dataForm", "/sample/sampleView.do");
    }
    </script>
</head>

<body style="text-align: center; margin: 0 auto; display: inline; padding-top: 100px;">

	<form id="dataForm">
		param02 : <input type="text" id="param02" name="param02" value="param02" /><br /> 
		param02 : <input type="text" id="param02" name="param02" value="param02" /><br /> 
		<input type="button" class="btn" onclick="javascript:fn_openWinPop();" value="새창 팝업 예" />
	</form>

	<div id="div_pop">
		<input type="button" onclick="javascript:fn_openDivPop();"
			value="DIV 팝업 예" />
	</div>
</body>
</html>
