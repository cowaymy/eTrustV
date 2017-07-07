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
    	
        $("#userId").keypress(function(event) {
            if(event.keyCode == 13) {
                login();
            }
        });
        
        $("#password").keypress(function(event) {
            if(event.keyCode == 13) {
                login();
            }
        });
    });
    
    function fn_login(){
    	var userId = $("#userId").val();
        var password = $("#password").val();
        
        if(userId == ""){
            alert("아이디를 입력하세요.");
            $("#userId").focus();
            return false;
        }
        
        if(password == ""){
            alert("비밀번호를 입력하세요.");
            $("#password").focus();
            return false;
        }
        
    	Common.ajax("POST", "/login/getLoginInfo.do", $("#loginForm").serializeJSON(), function(result) {
    	    
    		if(result.code == 99){
    	    	alert(result.message);
                $("#userId").val("");
                $("#userId").focus();
                return false;
             }
    		 
    	    // 로그인 성공시.
			$("#loginForm").attr("target", "");
			$("#loginForm").attr({
// TODO : 메인 화면 변경 필요.			
//			    action : "/common/main.do",
                action : "/sample/main.do",
			    method : "POST"
			}).submit();
            
        }, function(jqXHR, textStatus, errorThrown) {
			console.log("실패하였습니다.");
			console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
			
			alert(jqXHR.responseJSON.message);
			console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
			
			console.log("status : " + jqXHR.status);
			console.log("code : " + jqXHR.responseJSON.code);
			console.log("message : " + jqXHR.responseJSON.message);
			console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
            
        });
    }
       
    </script>
</head>

<body style="text-align:center; margin:0 auto; display:inline; padding-top:100px;">
                
	<div id="divLogin">
        <form id="loginForm" method="post" action="">
			userId : <input type="text" id="userId" name="userId" value="SKLIM"/><br/>
			password : <input type="text" id="password" name="password" value="SKLIM@12345"/><br/>
			<spring:message code="sys.msg.success" /><br/>
            <input type="button" class="btn" onclick="javascript:fn_login();" value="로그인"/>
        </form>
	</div>
                
</body>
</html>
