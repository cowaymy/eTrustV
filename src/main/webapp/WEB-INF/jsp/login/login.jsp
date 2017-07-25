<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<script type="text/javaScript" language="javascript">

$(function() {
    
    $("#userId").keypress(function(event) {
        if(event.keyCode == 13) {
        	fn_login();
        }
    });
    
    $("#password").keypress(function(event) {
        if(event.keyCode == 13) {
        	fn_login();
        }
    });
});

function fn_login(){
    var userId = $("#userId").val();
    var password = $("#password").val();
    
    if(userId == ""){
        if($("#popup_wrap").attr("alert") != "Y"){
        	Common.alert("<spring:message code='sys.msg.necessary' arguments='ID'/>");
            $("#userId").focus();
        }
        return false;
    }
    
    if(password == ""){
    	if($("#popup_wrap").attr("alert") != "Y"){
    		Common.alert("<spring:message code='sys.msg.necessary' arguments='PASSWORD'/>");
	        $("#password").focus();
    	}
        return false;
    }
    
    Common.ajax("POST", "/login/getLoginInfo.do", $("#loginForm").serializeJSON(), function(result) {
        
        if(result.code == 99){
            Common.alert(result.message);
            $("#userId").val("");
            $("#userId").focus();
            return false;
         }
         
        // 로그인 성공시.
        $("#loginForm").attr("target", "");
        $("#loginForm").attr({
            action : "/common/main.do",
            method : "POST"
        }).submit();
        
    }, function(jqXHR, textStatus, errorThrown) {
        console.log("fail.");
        console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
        
        Common.alert(jqXHR.responseJSON.message);
        console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
        
        console.log("status : " + jqXHR.status);
        console.log("code : " + jqXHR.responseJSON.code);
        console.log("message : " + jqXHR.responseJSON.message);
        console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        
    });
}
   
</script>

<body>
<div id="login_wrap"><!-- login_wrap start -->
<h1><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway" /></h1>

<article class="login_box"><!-- login_box start -->
<form id="loginForm" name="loginForm" method="post">

<h2><img src="${pageContext.request.contextPath}/resources/images/common/logo_etrust.gif" alt="Coway" /></h2>
<p><input type="text" title="ID" placeholder="ID" id="userId" name="userId" value="IVYLIM"/></p>
<p><input type="password" title="PASSWORD" placeholder="PASSWORD"  id="password" name="password" value="ivy123"/></p>
<p class="login_btn"><a href="javascript:void(0);" onclick="javascript:fn_login();"><spring:message code='sys.btn.login' /></a></p>
<ul class="login_opt">
    <li><a href="javascript:void(0);"><spring:message code='sys.btn.id.search' /></a></li>
    <li><a href="javascript:void(0);"><spring:message code='sys.btn.password.search' /></a></li>
</ul>
</form>
</article><!-- login_box end -->

<p class="copy">Copyrights 2017. Coway Malaysia Sdn. Bhd. All rights reserved.</p>
</div><!-- login_wrap end -->
</body>
