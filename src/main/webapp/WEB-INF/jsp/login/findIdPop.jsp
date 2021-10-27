<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">

var setMainRowIdx = 0;

function findIdPopUpClose() {
	$("#userId").val(returnSearchUserInfo.userName);
	$("#findIdPop").remove();
}

/***************************************************[ Main GRID] ***************************************************/
var searchUpperGridID;

$(document).ready(function() {
    var excuteFlag = "${excuteFlag}";  // findID or resetPass

    if (excuteFlag == "resetPass") {
        $("#userIdFindPopTxt").val($("#userId").val() );
    } else {
        $("#userIdFindPopTxt").val("");
    }

    // backspace 제어
    $(document).bind("keydown",function(e) {
        var backspace = 8;
        //console.log('keyCode: ' + e.keyCode +" /tagName: " +e.target.tagName +" /readonly: " + e.target.getAttribute("readonly") + " /nodeName: " +  e.target.nodeName);

        // 속성이 readonly이며 INPUT에서 backspack 키 누른경우
        if (e.target.tagName == "INPUT" && e.target.getAttribute("readonly") == "true" && e.keyCode == backspace) {
            return false;
        }

        if (e.keyCode == backspace) {
            // INPUT, TEXTAREA, SELECT 가 아닌곳에서 backspace 키 누른경우
            if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA" && e.target.nodeName != "SELECT") {
                return false;
            }

            // SELECT 에서 backspack 키 누른경우
            if (e.target.tagName == "SELECT") {
                return false;
            }
        }
    });

    $("#userIdFindPopTxt").focus();

    $("#step2").hide(); //security Question
    $("#step3").hide();

    // Step 2 Fields
    $("#mobileRow").hide();
    $("#tempPwRow").hide();
    $("#smsReqBtn").hide();
    $("#smsMsgInfo").hide(); //added by keyi 20211027

    $("#tempPwCheckBtn").hide();

    $("#userIdFindPopTxt").keydown(function(key) {
        if (key.keyCode == 13) {
            fnSearchIdPop();
        }
    });

    $("#securityAnswerTxt").keydown(function(key) {
        if (key.keyCode == 13) {
            fnSecurityChkPop();
        }
    });
});

function fnReqSMS() {
    console.log("fnReqSMS");

    if(FormUtil.isEmpty($("#memberMobile").val())) {
        Common.alert("Mobile number required!");
        return false;
    }

    var data ={
        userId : $("#searchLoginId").val(),
        userName : $("#searchLoginName").val(),
        mobileNo : $("#memberMobile").val(),
        userIdFindPopTxt : $("#userIdFindPopTxt").val()
    }

    Common.ajaxSync("GET", "/login/tempPwProcess.do", data, function(result) {
       console.log("checkMobileNumber :: " + result);

       if(result.code == 99) {
           // Common.alert("Dear HP, please enter the correct HP code or update your mobile number at nearest sales office.");
           Common.alert(result.message, findIdPopUpClose);
           return false;
       } else {
    	   var userType = $("#searchLoginName").val().startsWith("CD") ? "user" : "HP";

           Common.alert("Dear " + userType + ", temporary password has been sent to your registered number " + $("memberMobile").val() +
                   ". Kindly login to reset your password.", findIdPopUpClose);

       }
    });
}
</script>

<body>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
		<h1>Find ID / Reset Password</h1>
		<ul class="right_opt">
			<!-- <li><p class="btn_blue2"><a href="./login.do">Login</a></p></li> -->
			<li><p class="btn_blue2"><a onclick="findIdPopUpClose();">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->

		<form id="findIpPopUpForm" name="findIpPopUpForm" method="post">
		    <input type ="hidden" id="newUserIdTxt" name="newUserIdTxt" value=""/>
		<section class="tap_wrap"><!-- tap_wrap start -->
		<ul class="tap_type1">
			<li><a id="step1" href="javascript:void(0);">Find User ID</a></li>
			<li><a id="step2" href="javascript:void(0);">Security Question</a></li>
			<li><a id="step3" href="javascript:void(0);">Enter New Password</a></li>
		</ul>

		<article class="tap_area"><!-- tap_area start -->

			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:130px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">Login ID</th>
					<td>
					<input type="text" id="userIdFindPopTxt" name="userIdFindPopTxt" title="" placeholder="" class="w100p" />
					</td>
				</tr>
				</tbody>
			</table><!-- table end -->

			<ul class="center_btns">
				<li>
				 <p class="btn_blue2 big">
				   <a onclick="fnSearchIdPop();">Find ID</a>
				 </p>
				</li>
			</ul>

		</article><!-- tap_area end -->

		<article class="tap_area"><!-- tap_area start -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:130px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Login ID</th>
						<td>
						  <span>
						    <input type="text" id="searchLoginId" name="searchLoginId" value="" readonly = "true"/>
						  </span>
						</td>
					</tr>
					<tr>
						<th scope="row">Login NAME</th>
						<td>
						  <span>
						    <input type="text" id="searchLoginName" name="searchLoginName" value="" readonly = "true"/>
						  </span>
						</td>
					</tr>

					<tr id="secQuest">
						<th scope="row">Security Question</th>
						<td>
						  <span>
						    <input type="text" id="securityQuestion" name="securityQuestion" value="" readonly = "true"/>
						  </span>
						</td>
					</tr>
					<tr id="secAns">
						<th scope="row">Security Answer</th>
						<td>
						  <input type="text" id="securityAnswerTxt" name="securityAnswerTxt" class="w100p" />
						</td>
					</tr>
					<tr id="mobileRow">
                        <th scope="row">Mobile Number</th>
                        <td>
                          <input type="text" id="memberMobile" name="memberMobile" class="w100p" placeholder="Numeric Only (Eg: 01xxxxxxxx)"
                          onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" />
                        </td>
                    </tr>
                    <tr id="tempPwRow">
                        <th scope="row">Temporary Password</th>
                        <td>
                            <input type="text" id="tempPw" id="tempPw" class="w100p" placeholder="Enter Temporary Password">
                        </td>
                    </tr>
				</tbody>
			</table><!-- table end -->

        <!--added by keyi 20211101-->
        <ul class="left_btns">
        <li id="smsMsgInfo"><p class= "blue_text bold_text">Dear user, please be reminded that there is a limit of maximum 3 times to request for temporary password within 7 days.</p></li>
        <br />
        </ul>

		<ul class="center_btns">
			<li id="backBtn"><p class="btn_blue2 big"><a onclick="fnBackStepPop();">Back</a></p></li>
			<li id="secCheckBtn"><p class="btn_blue2 big"><a onclick="fnSecurityChkPop();">Submit</a></p></li>
			<!-- 20210111 - LaiKW -->
            <li id="smsReqBtn"><p class="btn_blue2 big"><a onclick="fnReqSMS();">Request SMS</a></p></li>
			<li id="tempPwCheckBtn"><p class="btn_blue2 big"><a onclick="fnCheckTempPW();">Submit</a></p></li>
		</ul>
		</article><!-- tap_area end -->

		<article class="tap_area"><!-- tap_area start -->
			<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
				<col style="width:160px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">Enter New Password</th>
				<td>
					<span class="txt_box w100p">
					  <input type="password" id="newPasswordTxt" name="newPasswordTxt" maxlength="20" />
					    <i>
					      &gt; Password length must between 6~20.<br />
					      &gt; Password cannot contains your login ID.<br />
					      &gt; New password cannot same to current password.<br />
				      </i>
			    </span>
				</td>
			</tr>
			<tr>
				<th scope="row">Retype New Password</th>
				<td>
				  <input type="password" id="newPasswordConfirmTxt" name="newPasswordConfirmTxt" class="w100p"  maxlength="20" />
				</td>
			</tr>
			</tbody>
		</table><!-- table end -->

		<ul class="center_btns">
			<li><p class="btn_blue2 big"><a onclick="fnSaveResetPassWordPop('A2');">Change Password</a></p></li>
		</ul>
		</article><!-- tap_area end -->

		</section><!-- tap_wrap end -->

		</form>
	</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>