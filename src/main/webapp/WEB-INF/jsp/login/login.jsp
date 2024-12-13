<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/js.cookie.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/pgwbrowser.min.js"></script>
<script type="text/javaScript">
    var returnUserInfo = {};
    var returnSearchUserInfo = {};
    var gVarForm = "";
    var otpMfaForm = "";
    var isCheckedMfa = "N";
    var mfaObj;
    var pgwBrowser;

    $(function () {

        if("${exception}" == "401"){
            Common.alert("<spring:message code='sys.msg.session.expired'/>");

            //alert(window.top.location.href)
            // go login page - 20190924 KR-MIN : for go login page
            if(window.top.location.href.indexOf("login.do")<0){
                window.top.Common.showLoader();
                // go login page
                window.top.location.href = '/login/login.do';
            }
        }

        pgwBrowser = $.pgwBrowser();
        $("#loginOs").val(pgwBrowser.os.name);
        $("#loginBrowser").val(pgwBrowser.browser.name + " " + pgwBrowser.browser.fullVersion);

        fn_configLocale();
        fn_configLoginId();
        fn_configEvent();

    });

    function fn_configLocale() {
        // spring locale config apply..
        if (FormUtil.isNotEmpty(Cookies.get("org.springframework.web.servlet.i18n.CookieLocaleResolver.LOCALE"))) {
            $("#language  option[value=" + Cookies.get("org.springframework.web.servlet.i18n.CookieLocaleResolver.LOCALE") + "]").attr("selected", "selected");
        }
    }

    function fn_configLoginId() {
        if (FormUtil.isNotEmpty(Cookies.get("cookieUserId"))) {
            $("#userId").val(Cookies.get("cookieUserId"));
        }
    }

    function fn_configEvent() {
        $("#userId").keypress(function (event) {
            if (event.keyCode == 13) {
                fn_login();
            }
        });

        $("#password").keypress(function (event) {
            if (event.keyCode == 13) {
                fn_login();
            }
        });

        $("#language").on("change", function (event) {
            $("#loginForm").attr({
                action: "/login/login.do",
                method: "POST"
            }).submit();
        });
    }

    function fn_configCookies(userId) {
        if ($("#saveId").is(':checked')) {
            Cookies.set("cookieUserId", userId, {expires: 7});
        } else {
            Cookies.remove("cookieUserId");
        }
    }

    function fn_goMain() {
        $("#loginForm").attr("target", "");
        $("#loginForm").attr({
            action: getContextPath() + "/common/main.do",
            method: "POST"
        }).submit();
    }

    function fn_goMainExternal() {
        $("#loginForm").attr("target", "");
        $("#loginForm").attr({
            action: getContextPath() + "/common/mainExternal.do",
            method: "POST"
        }).submit();
    }

    function fn_goSurveyForm(surveyTypeId) {
    	Common.popupDiv("/logistics/survey/surveyForm.do", {"surveyTypeId":surveyTypeId,"inWeb":"0"}, null, false, '_surveyPop');
    }

    // Added to collect Vaccination Information Collection. Hui Ding, 09-09-2021
    function fn_goVaccineForm(){

    		Common.popupDiv("/login/vaccineInfoPop.do", null, null, false, '_vaccineInfoPop');
    	   //Common.popupDiv("/login/vaccineInfoPop.do", null, null, false, '_vaccineInfoPop');
    }

    function fn_checkMFAForm(userInfo){

    	var param = {
    			userId : userInfo.userId,
    			userName: userInfo.userName,
    			email : userInfo.userEmail,
    			memCode: userInfo.userMemCode,
    			isCheckMfa: userInfo.checkMfaFlag
    	};

        Common.popupDiv("/login/checkMFA.do", param, null, true, 'checkMFAPop');
}

    function fnFindIdPopUp() {
        var popUpObj = Common.popupDiv(
            "/login/findIdPop.do"
            , null
            , null
            , true  // true면 더블클릭시 close
            , "findIdPop"  // "popup_wrap"
        );
    }

    function fnRestPassPopUp() {
        var popUpObj = Common.popupDiv(
            "/login/findIdRestPassPop.do"
            , null
            , null
            , true  // true면 더블클릭시 close
            , "findIdPop"  // "popup_wrap"
        );
    }

    function fnPassWordResetPopUp() {
        var popUpObj = Common.popupDiv(
            "/login/resetPassWordPop.do"
            , null
            , null
            , true  // true면 더블클릭시 close
            , "resetPassWordPop"  // "popup_wrap"
        );
    }

    function fnValidationCheck(flag) {  /*
        1.Password length must between 6~20. -> passWordLength
        2.Password cannot contains your login ID. -->pswdContainLoginId
        3.New password cannot same to current password.  --> sys.login.pswdSameNotPrevious
      */

        var format = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

        if ($("#newPasswordConfirmTxt").val().length < 6 || $("#newPasswordConfirmTxt").val().length > 20) {
            Common.alert("<spring:message code='sys.login.passWordLength'/>");
            return false;
        }

        if ($("#newPasswordTxt").val() != $("#newPasswordConfirmTxt").val()) {  //{0} and {1} are different
            Common.alert("<spring:message code='sys.login.passwordConfirm.different' arguments='[New PassWord] ; [Retype New PassWord]' htmlEscape='false' argumentSeparator=';' />");
            return false;
        }

        if (flag == "A1")   // EXPRIED PASSWORD
        {
            if ($("#newPasswordConfirmTxt").val().indexOf($("#userId").val()) >= 0) {
                Common.alert("<spring:message code='sys.login.pswdContainLoginId'/>");
                return false;
            }

            // LaiKW - 20211202 - ITGC Password configuration, special character required for new passwords
            if(!format.test($("#newPasswordConfirmTxt").val())) {
                Common.alert("A single special character is required.");
                return false;
            }

            if ($("#password").val() == $("#newPasswordConfirmTxt").val()) {
                Common.alert("<spring:message code='sys.login.pswdSameNotPrevious'/>");
                return false;
            }

            gVarForm = "#resetPopUpForm";
        }
        else   // FIND ID && PASSWORD CHANGE
        {
            if ($("#newPasswordConfirmTxt").val().indexOf($("#searchLoginName").val()) >= 0) {
                Common.alert("<spring:message code='sys.login.pswdContainLoginId'/>");
                return false;
            }

            // LaiKW - 20211202 - ITGC Password configuration, special character required for new passwords
            if(!format.test($("#newPasswordConfirmTxt").val())) {
                Common.alert("A single special character is required.");
                return false;
            }

            var same = true;
            /* move validate new password cannot match with current password to backend. Hui Ding 17/03/2022. */
            Common.ajaxSync("GET", "/login/checkPassword.do" , {"newPassword" : $("#newPasswordConfirmTxt").val(), "username" : $("#userId").val()}
            	    , function (resultCheck) {
            	console.log("check password result data : " + resultCheck.data);
            	if (resultCheck != null && resultCheck.data != null){
            		if (resultCheck.data >= 1){
            			  Common.alert("<spring:message code='sys.login.pswdSameNotPrevious'/>");
            			  same = false;
            		}
            	}

            });

            if (!same)
            	return false;

            fnSecurityChkPop(); //20220329 hltang - check sec ans in server instead jsp
            /* if (returnSearchUserInfo.userSecQuesAns != $("#securityAnswerTxt").val()) {
                Common.alert("<spring:message code='sys.login.securityAnswer.Incorrect'/>");
                return false;
            } */

            gVarForm = "#findIpPopUpForm";
        }

        return true;
    }

    function fnSaveResetPassWordPop(flag) {
        if (!fnValidationCheck(flag)) {
            return false;
        }

        Common.ajaxSync("POST"
            , "/login/savePassWordReset.do"
            , $(gVarForm).serializeJSON()
            , function (result) {
                if (result.data > 0) {
                    Common.alert("<spring:message code='sys.login.passwordChanged.success'/>");
                    $("#password").val("");
                }

                if (flag == "A1") { // EXPIRED PASSWORD ==> resetPassWordPop.jsp
                    pswdPopUpClose();
                }
                else {  // FIND ID && PASSWORD CHANGE  ==> findIdPop.jsp
                    findIdPopUpClose();
                }

                console.log("성공." + JSON.stringify(result));
                console.log("data : " + result.data);
            }
            , function (jqXHR, textStatus, errorThrown) {
                try {
                    console.log("Fail Status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                }
                catch (e) {
                    console.log(e);
                }

                Common.alert("Fail : " + jqXHR.responseJSON.message);

            });
    }

    function fn_submitMFA() {

    	otpMfaForm = "#otpMfaForm";
    	mfaObj = $(otpMfaForm).serializeJSON();

    	if(mfaObj.code != null && mfaObj.code != "") {
    	      Common.ajaxSync("POST"
    	              , "/login/otpMFASubmit.do"
    	              , $(otpMfaForm).serializeJSON()
    	              , function (result) {
    	                  if (result.code != 99) {
    	                      mfaPopUpClose();
    	                      isCheckedMfa = "Y";
    	                      $("#isCheckedMfa").val(isCheckedMfa);
    	                      fn_login();
    	                  }
    	                  else {
    	                      Common.alert(result.message);
    	                  }

    	                  console.log("성공." + JSON.stringify(result));
    	              }
    	              , function (jqXHR, textStatus, errorThrown) {
    	                  try {
    	                      console.log("Fail Status : " + jqXHR.status);
    	                      console.log("code : " + jqXHR.responseJSON.code);
    	                      console.log("message : " + jqXHR.responseJSON.message);
    	                      console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
    	                  }
    	                  catch (e) {
    	                      console.log(e);
    	                  }

    	                  Common.alert("Fail : " + jqXHR.responseJSON.message);

    	              });
    	}

    	else {
    		Common.alert("Please enter the code");
    	}


    }

    function fn_login() {
        var userId = $("#userId").val();
        var password = $("#password").val();
        console.log("login");
        if (userId == "") {
            if ($("#popup_wrap").attr("alert") != "Y") {
                Common.alert("<spring:message code='sys.msg.necessary' arguments='ID'/>");
                $("#userId").focus();
            }
            return false;
        }

        if (password == "") {
            if ($("#popup_wrap").attr("alert") != "Y") {
                Common.alert("<spring:message code='sys.msg.necessary' arguments='PASSWORD'/>");
                $("#password").focus();
            }
            return false;
        }
/*                 isCheckedMfa = "Y";
        $("#isCheckedMfa").val(isCheckedMfa); */

        Common.ajax("POST"
            , "/login/getLoginInfo.do"
            , $("#loginForm").serializeJSON()
            , function (result) {

                if (result.code == 99) {
                    Common.alert(result.message);
                    // $("#userId").val("");
                    $("#userId").focus();
                    return false;
                }

                returnUserInfo = result.data;

                if(returnUserInfo.rank == "1366" && returnUserInfo.userTypeId == "1") {
                    Common.alert("Dear user, your account has not been activated for more than 2 months. Please refer to your manager or administrative for more details.");
                    return false;
                }

                $("#loginUserId").val(returnUserInfo.userId);


                console.log('checkMfa', returnUserInfo.checkMfaFlag);
                console.log('returnUserInfo', returnUserInfo);
                console.log('result', result);
                if (parseInt(result.data.diffDay) > 90) {
                    fnPassWordResetPopUp();
                }

                          else if(returnUserInfo.checkMfaFlag != 2 && isCheckedMfa == "N") {
                    fn_checkMFAForm(returnUserInfo);
                }

                else {  // 재로그인을 하지 않을려면, popup에서 호출.

                    fn_configCookies(userId);

                    // HP, Cody, CT, Staff, Admin
                    if(returnUserInfo.userTypeId == "5"){
                    	fn_goMainExternal();
                    }
                    else if(result.data.userIsPartTime != "1" && result.data.userIsExternal != "1"){
                    	//var vacPop = "${vaccinationPop}";

                    	var vacPop = "N";
                    	if (result.data.diffVacDay == null  || (result.data.diffVacDay != null && parseInt(result.data.diffVacDay) <= 0 )){
                    		vacPop ="Y";
                    		if (result.data.vacStatus == null || (result.data.vacStatus != null && result.data.vacStatus != "C")){
                    			  vacPop ="Y";
                    		} else {
                    			vacPop ="N";
                    		}
                    	}
                    	console.log(result);
                    	console.log(result.data.diffVacDay == null);
                    	console.log("result.data.diffVacDay: " + result.data.diffVacDay);
                    	console.log("vacPop: " + vacPop);
                    	console.log("result.data.vacStatus: " + result.data.vacStatus);

                    	if ( vacPop == "Y" && (result.data.userTypeId == "1" || result.data.userTypeId == "2" || result.data.userTypeId == "3" || result.data.userTypeId == "7") && // HP, CD, CT, HT
                    			result.data.userId != '83353' ) { // manually by pass this CTM A.K.A STAFF user
                    		// collect vaccination info
                                fn_goVaccineForm();
                    	} else {

	                    	var noticePopResult = null;
	                    	var aResult = null;
	                    	var inQueue = 0;

	                    	// Added for displaying important Notice by Management to all HP, Cody, CT, Staff, Admin. By Hui Ding, 2020-09-28
	                    	/*
	                        Common.ajaxSync("GET", "/login/loginNoticePopCheck", {userId : userId, userTypeId : result.data.userTypeId}, function(noticePop) {
	                        	noticePopResult = noticePop;
	                        	console.log("noticePop");
	                        });
	                    	*/

		                    Common.ajaxSync("GET", "/login/loginPopCheck", {userId : userId, userTypeId : result.data.userTypeId}, function(aResultSet) {
	                            aResult = aResultSet;
	                            console.log("aResultSet");
	                        });
	                        //fn_goMain();

	                        if (aResult != null){
	                        	console.log(aResult);
	                            $("#loginUserType").val(result.data.userTypeId);

	                            if(aResult.retMsg == "") {
	                                if((aResult.popExceptionMemroleCnt > 0 || aResult.popExceptionUserCnt > 0)
	                                    && (aResult.surveyTypeId <= 0 || aResult.verifySurveyStus >= 1)){
	                                	if (noticePopResult == null){
	                                		  fn_goMain();
	                                	}
	                                }
	                                else if (/* (aResult.popExceptionMemroleCnt <= 0 || aResult.popExceptionUserCnt <= 0)&& */
	                                        (aResult.surveyTypeId > 0 && aResult.verifySurveyStus <= 0) ){
	                                    $("#loginForm surveyTypeId").val(aResult.surveyTypeId);
	                                    fn_goSurveyForm(aResult.surveyTypeId);
	                                    inQueue = 1;
	                                }
	                                else {
	                                    inQueue = 1;
	                                    $("#popId").val(aResult.popId);
	                                    $("#loginPdf").val(aResult.popFlName);
	                                    $("#popType").val(aResult.popType);
	                                    $("#popAck1").val(aResult.popAck1);
	                                    $("#popAck2").val(aResult.popAck2);
	                                    $("#popAck3").val(aResult.popAck3);
	                                    $("#popRejectFlg").val(aResult.popRejectFlg);
	                                    $("#surveyStus").val(aResult.verifySurveyStus);
	                                    $("#loginForm surveyTypeId").val(aResult.surveyTypeId);
	                                    $("#verName").val(aResult.verName);
	                                    $("#verNRIC").val(aResult.verNRIC);
	                                    $("#verBankAccNo").val(aResult.verBankAccNo);
	                                    $("#verBankName").val(aResult.verBankName);
	                                    $("#consentFlg").val(aResult.consentFlg);
	                                    $("#applicantId").val(aResult.applicantId);
	                                    Common.popupDiv("/login/loginPop.do", $("#loginForm").serializeJSON(), null, false, '_loginPop');
	                                }
	                            } else {
	                                Common.alert(aResult.retMsg);
	                            }
	                        }
                    	}

                        /*
                        if (noticePopResult != null && noticePopResult != ""){
                            if (noticePopResult.retMsg == "") {
                                $("#loginPdf").val(noticePopResult.popFlName);
                                $("#popType").val(noticePopResult.popType);
                                Common.popupDiv("/login/loginNoticePop.do?inQueue=" + inQueue, $("#loginForm").serializeJSON(), null, false, '_loginNoticePop');
                            } else if (noticePopResult.retMsg == "No Notice."){
                            	if (inQueue != 1){
                            	    fn_goMain();
                            	} else {
                            		//console.log(noticePopResult.retMsg);
                            	}
                            } else {
                            	console.log(noticePopResult.retMsg);
                            }
                        }
                        */
                    }
                    // External
                    else {
                        fn_goMainExternal();
                    }
                }
            }
            , function (jqXHR, textStatus, errorThrown) {
                console.log("fail.");
                console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

                if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                    Common.alert(jqXHR.responseJSON.message);
                    console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);

                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                }
            });
    }

    // 2018-06-14 - LaiKW - Cody agreement pop up and confirmation checking - Start
    function validateCDcnfm() {
        Common.ajax("GET", "/organization/getCDInfo", {userId : $("#userId").value()}, function(result1) {
            if(result1.status == "Y") {
                return "Y";
            } else {
                return "N";
            }
        });
    }
 // 2018-06-14 - LaiKW - Cody agreement pop up and confirmation checking - End

    function fnCreateEvent(objId, eventType) {
        var e = jQuery.Event(eventType);
        $('#' + objId).trigger(e);
    }

    function fnBackStepPop() {
        $("#searchLoginId").val("");
        $("#searchLoginName").val("");
        $("#securityQuestion").val("");
        $("#securityAnswerTxt").val("");

        $("#step2").hide();
        $("#step1").click();
    }

    function fnSecurityChkPop() { //20220329 hltang - check sec ans in server instead jsp

    	Common.ajax("POST"
                , "/login/checkSecAns.do"
                , {secAns : $("#securityAnswerTxt").val(),"username" : $("#searchLoginName").val()}
                , function (result) {
                    if (result.code == 99) {
                        Common.alert("<spring:message code='sys.login.securityAnswer.Incorrect'/>");
                        return false;
                    }else{
                    	$("#backBtn").hide();
                        $("#step3").show();
                        $("#step3").click();
                        $("#newPasswordTxt").focus();
                    }
                }
                , function (jqXHR, textStatus, errorThrown) {
                    console.log("fail.");
                    console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

                    if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                        Common.alert(jqXHR.responseJSON.message);
                        console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);

                        console.log("status : " + jqXHR.status);
                        console.log("code : " + jqXHR.responseJSON.code);
                        console.log("message : " + jqXHR.responseJSON.message);
                        console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                    }

                });

        /* f (returnSearchUserInfo.userSecQuesAns != $("#securityAnswerTxt").val()) {
            Common.alert("<spring:message code='sys.login.securityAnswer.Incorrect'/>");
            return false;
        }
        else {
            // step 3
            $("#backBtn").hide();
            $("#step3").show();
            $("#step3").click();
            $("#newPasswordTxt").focus();
        } */
    }

    function fnSearchIdPop() {
        if ($("#userIdFindPopTxt").val().length == 0) {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='ID'/>");
            return false;
        }

        Common.ajax("POST"
            , "/login/selectFindUserIdPop.do"
            , $("#findIpPopUpForm").serializeJSON()
            , function (result) {
                if (result.code == 99) {
                    Common.alert(result.message);
                    $("#userId").val("");
                    $("#userId").focus();
                    return false;
                }

                returnSearchUserInfo = result.data;

                // step2 find login
                $("#searchLoginId").val(returnSearchUserInfo.userId);
                $("#searchLoginName").val(returnSearchUserInfo.userName);
                $("#securityQuestion").val(returnSearchUserInfo.securityQuestion);

                $("#tempPwCheckBtn").hide();

                if(returnSearchUserInfo.userTypeId == "1") {
                    // HP
                    if(returnSearchUserInfo.memStus != "1" || returnSearchUserInfo.hpStus == "1366") {
                        Common.alert("Dear Hp, please email to hpresetpassword@coway.com.my for further assistance.");
                        $("#popup_wrap").remove();
                        return false;
                    }

                    fn_showFieldsTmpPwd();
                }

                if(returnSearchUserInfo.userTypeId == "2") {
                    // Cody / Service Technician
                    if(returnSearchUserInfo.memStus != "1") {
                        Common.alert("Dear Cody/ST, your account is inactive.");
                        $("#popup_wrap").remove();
                        return false;
                    }

                    fn_showFieldsTmpPwd();
                }

                if(returnSearchUserInfo.userTypeId == "5") {
                    // Organization trainee
                    if(returnSearchUserInfo.memStus != "1") {
                        Common.alert("Dear Trainee, your account is inactive.");
                        $("#popup_wrap").remove();
                        return false;
                    }

                    fn_showFieldsTmpPwd();
                }

                $("#step2").show();
                $("#step2").click();
                $("#securityAnswerTxt").focus();

            }
            , function (jqXHR, textStatus, errorThrown) {
                console.log("fail.");
                console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

                if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                    Common.alert(jqXHR.responseJSON.message);
                    console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);

                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                }

            });
    }

      /*  function fn_cont() {
           /* window.open('','_parent','');
           window.close();
    	   $("#btnClose").click();
   } */

   function fn_orgResetPassword() {
       console.log("fn_orgResetPassword");

       //Common.popupDiv("/login/orgResetPW.do", null, null, true, "orgResetPwPop");
       var popUpObj = Common.popupDiv("/login/orgResetPW.do", null, null, true, "orgResetPwPop");
   }

   function fn_showFieldsTmpPwd() {
       $("#secQuest").hide();
       $("#secAns").hide();
       $("#secCheckBtn").hide();

       $("#backBtn").hide();
       $("#secCheckBtn").hide();

       $("#mobileRow").show();
       $("#smsReqBtn").show();
       $("#smsMsgInfo").show(); //added by keyi 20211027
   }

</script>

<body>
<div id="login_wrap" style="padding:30px 0; background-size:cover"><!-- login_wrap start -->
<%--     <h1><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway2.png" alt="Coway"/></h1> --%>

    <article class="login_box"><!-- login_box start -->
        <form id="loginForm" name="loginForm" method="post">
            <input type="hidden" id="loginUserId" name="loginUserId" value=""/>
            <input type="hidden" id="loginOs" name="os" value=""/>
            <input type="hidden" id="loginBrowser" name="browser" value=""/>

            <input type="hidden" id="loginUserType" name="loginUserType" value=""/> <!-- 2017-07-24 - LaiKW - Staff Memo Pop Up -->
            <input type="hidden" id="popId" name="popId" value=""/>
            <input type="hidden" id="loginPdf" name="loginPdf" value=""/>
            <input type="hidden" id="popType" name="popType" value=""/>
            <input type="hidden" id="popAck1" name="popAck1" value=""/>
            <input type="hidden" id="popAck2" name="popAck2" value=""/>
            <input type="hidden" id="popAck3" name="popAck3" value=""/>
            <input type="hidden" id="popRejectFlg" name="popRejectFlg" value=""/>
            <input type="hidden" id="surveyStus" name="surveyStus" value=""/>
            <input type="hidden" id="surveyTypeId" name="surveyTypeId" value=""/>
            <input type="hidden" id="verName" name="verName" value=""/>
            <input type="hidden" id="verNRIC" name="verNRIC" value=""/>
            <input type="hidden" id="verBankAccNo" name="verBankAccNo" value=""/>
            <input type="hidden" id="verBankName" name="verBankName" value=""/>
            <input type="hidden" id="consentFlg" name="consentFlg" value=""/>
            <input type="hidden" id="isCheckedMfa" name="isCheckedMfa" value="${isCheckedMfa}"/>
            <input type="hidden" id="applicantId" name="applicantId" value=""/>


            <h2><img src="${pageContext.request.contextPath}/resources/images/common/logo_etrust1.png" alt="Coway"/></h2>
            <p><input type="text" title="ID" placeholder="ID" id="userId" name="userId" value=""/></p>
            <p><input type="password" title="PASSWORD" placeholder="PASSWORD" id="password" name="password"
                      value=""/></p>
            <p class="id_save">
                <label>
                    <input id="saveId" type="checkbox" checked/>
                    <span>
                    <spring:message code='sys.info.id'/>
                    <spring:message code='sys.btn.save'/>
                  </span>
                </label>
            </p>

            <p class="lang">
                <span><spring:message code='sys.info.lang'/> <spring:message code='sys.info.select'/></span>
                <select id="language" name="language">
                    <c:forEach var="list" items="${languages}">
                        <option value="${list.language}"
                                <c:if test="${param.language eq list.language}"> selected </c:if>>${list.language}
                        </option>
                    </c:forEach>
                </select>
            </p>

            <p class="login_btn">
                <a href="javascript:void(0);" onclick="javascript:fn_login();">
                    <spring:message code='sys.btn.login'/>
                </a>
            </p>

            <ul class="login_opt">
                <li><a href="javascript:fnRestPassPopUp();"><spring:message code='sys.btn.id.search'/> & <spring:message code='sys.btn.password.search'/></a></li>
            </ul>
            <!-- [s] subject to change upon requirement -- Celeste  -->
            <!-- <div class="icon_container" style=text-align:center;> -->
            <!-- 2021-04-21 - Requested to hide banner until further notice -->
            <!--
            <div class="icon_container" style="height:100%; padding-top:10%;padding-left:12px">
                <p>
                <a href="http://bit.ly/CowayCC">
                 -->
                <!--  <img src="${pageContext.request.contextPath}/resources/images/common/login_hyp_icon.png" style=padding-left:135px>-->
                <!--
                <img src="${pageContext.request.contextPath}/resources/images/common/210302_Coway-eTrust-icon-09.gif" style="max-width:100%;">
                </a>
                 </p>
            </div>
             -->
            <!--
            <div class="icon_container">
                <p style=padding-left:5px;>
                 <ul>
                    <li style=text-align:center><b>HP Voice</b></li>
                 </ul>
                 </p>
            </div>-->
            <!-- [e] subject to change upon requirement -- Celeste  -->
        </form>
    </article><!-- login_box end -->

    <h2 style="display: flex; align-items: flex-end; justify-content: center;"><img src="${pageContext.request.contextPath}/resources/images/common/copyright.png" alt="Coway"/></h2>
<!--     <p class="copy" style="padding-top: 80px">Copyrights 2017. Coway Malaysia Sdn. Bhd. All rights reserved.</p> -->
</div><!-- login_wrap end -->
</body>
