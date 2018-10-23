<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

$(document).ready(function(){
	Common.ajaxSync("GET", "/common/userManagement/selectUserList.do", {userId : '${SESSION_INFO.userId}' }, function(result) {
		if(result != null && result.length == 1) {
			$('#userSettingForm #eMail').val(result[0].userEmail);
			$('#userSettingForm #mobileNo').val(result[0].userMobileNo);
			$('#userSettingForm #exNo').val(result[0].userExtNo);
			$('#userSettingForm #userWorkNo').val(result[0].userWorkNo);
			$('#userSettingForm #nricNo').val(result[0].userNric);
		}else {
            Common.lert('Error. Please contact IT department');
        }
	});

});

function removePopupCallback(){
    userSettingPop.remove();
}

function chkPwd(str){
    var regPwd = /^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    //var regPwd =/^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$/;
    if(regPwd.test(str)){
        return true;
    }

    return false;
}
function chkEmail(str){
    var regStr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if(regStr.test(str) && str.indexOf("@coway.com.my") > -1){
        return true;
    }

    return false;
}

function  isValidMobileNo(inputContact){

    if(isNaN(inputContact) == false){

        return false;
    }

    if(inputContact.length != 10 && inputContact != 11){

        return false;
    }


    if( inputContact.substr(0 , 3) != '010' &&
        inputContact.substr(0 , 3) != '011' &&
        inputContact.substr(0 , 3) != '012' &&
        inputContact.substr(0 , 3) != '013' &&
        inputContact.substr(0 , 3) != '014' &&
        inputContact.substr(0 , 3) != '015' &&
        inputContact.substr(0 , 3) != '016' &&
        inputContact.substr(0 , 3) != '017' &&
        inputContact.substr(0 , 3) != '018' &&
        inputContact.substr(0 , 3) != '019'
      ){

        return false;
    }

    return true;

}

function fn_updateUserPasswd(){
    if($("#passwordForm #currentPasswd").val() == "" || typeof($("#passwordForm #currentPasswd").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Current Password' htmlEscape='false'/>");
        return;
    }
	if('${SESSION_INFO.userPassWord}' != $("#passwordForm #currentPasswd").val()){
		Common.alert("Wrong Current Password.");
        return;
	}
	if('${SESSION_INFO.userPassWord}' == $("#passwordForm #newPasswd").val()){
	    Common.alert("New Password cannot be same.");
	    return;
	}
    if($("#passwordForm #newPasswd").val() == "" || typeof($("#passwordForm #newPasswd").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Password' htmlEscape='false'/>");
        return;
    }
    if($("#passwordForm #confirmPasswd").val() == "" || typeof($("#passwordForm #confirmPasswd").val()) == "undefined"){
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Re-Key Password' htmlEscape='false'/>");
        return;
    }
    if($("#passwordForm #newPasswd").val() !=  $("#passwordForm #confirmPasswd").val()){
        Common.alert("<b>New password</b> does not match the <b>confirm password</b>.");
        return;
    }
    if(chkPwd($("#passwordForm #confirmPasswd").val()) == false){
        Common.alert("6 ~ 20 digits in English and numbers");
        return;
    }

    var data = {searchLoginId : '${SESSION_INFO.userId}', newPasswordConfirmTxt : $("#passwordForm #confirmPasswd").val()};

    Common.ajax("POST","/login/savePassWordReset.do", data,
    	function(data, textStatus, jqXHR){ // Success
    	Common.alert("Password updated",removePopupCallback);
    	},
    	function(jqXHR, textStatus, errorThrown){ // Error
    	Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

function fn_updateUserInfo(){
   if(chkEmail($("#userSettingForm #eMail").val()) == false){
        Common.alert("Email is not in the correct form. <br/> Please make sure it is Coway Email");
        return;
    }
   if( (!FormUtil.checkReqValue($("#userSettingForm #mobileNo")) ) && (isValidMobileNo($("#userSettingForm #mobileNo").val())) == false){
        Common.alert("Invalid Mobile Phone Number");
        return;
    }
    if(FormUtil.checkNum($("#userSettingForm #exNo"))){
        Common.alert("<spring:message code='sal.alert.msg.invalidExtNoNumber' />");
        return;
    }
    if(FormUtil.checkNum($("#userSettingForm #userWorkNo"))){
    	Common.alert("Invalid Office Contact Number");
        return;
    }

    Common.ajax("POST","/login/updateUserInfoSetting.do", $("#userSettingForm").serializeJSON(),
	    function(data, textStatus, jqXHR){ // Success
	      Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>",removePopupCallback);
	    },
	    function(jqXHR, textStatus, errorThrown){ // Error
	      Common.alert("Fail : " + jqXHR.responseJSON.message);
	});
}

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>User Setting</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Personal Info</a></li>
    <li><a href="#" >Change Password</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<form action="#" method="post" id="userSettingForm">

<table class="type1"><!-- table start -->
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Login ID</th>
    <td><span>${SESSION_INFO.userName}</span></td>
</tr>
<tr>
    <th scope="row">Full Name</th>
    <td><span>${SESSION_INFO.userFullname}</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="eMail" type="text" name="eMail" title="" placeholder="email" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Contact(O)</th>
    <td><input id="userWorkNo" type="text" name="userWorkNo" title="" placeholder="Contact number (Office)" class="w100p"  maxlength="15"/></td>
</tr>
<tr>
    <th scope="row">Extension</th>
    <td><input id="exNo" type="text" name="exNo" title="" placeholder="Extension NUMBER (if has any)" class="w100p" maxlength="10"/></td>
</tr>
<tr>
    <th scope="row">Contact(M)</th>
    <td><input id="mobileNo" type="text" name="mobileNo" title="" placeholder="Contact number (Mobile)" class="w100p" maxlength="15"/></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input id="nricNo" type="text" name="nricNo" title="" placeholder="NRIC" class="w100p" /></td>
</tr>

</tbody>
</table><!-- table end -->
</form>

<div style="height: 30px">
</div>
<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: fn_updateUserInfo()">Update Info</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="passwordForm">

<table class="type1"><!-- table start -->
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Current Password</th>
    <td><input id="currentPasswd" type="password" name="currentPasswd" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">New Password</th>
    <td><input id="newPasswd" type="password" name="newPasswd" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Re-key New Password</th>
    <td><input id="confirmPasswd" type="password" name="confirmPasswd" title="" placeholder="" class="w100p" /></td>
</tr>

</tbody>
</table><!-- table end -->
</form>

<div style="height: 30px">
</div>
<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: fn_updateUserPasswd()">Save Password</a></p></li>
</ul>
</article><!-- tap_area end -->

</section><!-- content end -->
</section><!-- container end -->
</section><!-- tap_wrap end  -->
</div><!-- popup_wrap end -->