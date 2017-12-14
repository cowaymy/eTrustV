<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/js.cookie.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/pgwbrowser.min.js"></script>
<script type="text/javaScript">
    var returnUserInfo = {};
    var returnSearchUserInfo = {};
    var gVarForm = "";
    var pgwBrowser;

    $(function () {

        if("${exception}" == "401"){
            Common.alert("<spring:message code='sys.msg.session.expired'/>");
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

            if (returnSearchUserInfo.userPassWord == $("#newPasswordConfirmTxt").val()) {
                Common.alert("<spring:message code='sys.login.pswdSameNotPrevious'/>");
                return false;
            }

            gVarForm = "#findIpPopUpForm";
        }

        return true;
    }

    function fnSaveResetPassWordPop(flag) {
        if (fnValidationCheck(flag) == false) {
            return false;
        }

        Common.ajax("POST"
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

    function fn_login() {
        var userId = $("#userId").val();
        var password = $("#password").val();

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

                $("#loginUserId").val(returnUserInfo.userId);

                if (parseInt(result.data.diffDay) > 90) {
                    fnPassWordResetPopUp();
                }
                else {  // 재로그인을 하지 않을려면, popup에서 호출.
                    fn_configCookies(userId);
                    fn_goMain();
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

    function fnSecurityChkPop() {
        if (returnSearchUserInfo.userSecQuesAns != $("#securityAnswerTxt").val()) {
            Common.alert("<spring:message code='sys.login.securityAnswer.Incorrect'/>");
            return false;
        }
        else {
            // step 3
            $("#backBtn").hide();
            $("#step3").show();
            $("#step3").click();
            $("#newPasswordTxt").focus();
        }
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

</script>

<body>
<div id="login_wrap"><!-- login_wrap start -->
    <h1><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"/></h1>

    <article class="login_box"><!-- login_box start -->
        <form id="loginForm" name="loginForm" method="post">
            <input type="hidden" id="loginUserId" name="loginUserId" value=""/>
            <input type="hidden" id="loginOs" name="os" value=""/>
            <input type="hidden" id="loginBrowser" name="browser" value=""/>

            <h2><img src="${pageContext.request.contextPath}/resources/images/common/logo_etrust.gif" alt="Coway"/></h2>
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

        </form>
    </article><!-- login_box end -->

    <p class="copy">Copyrights 2017. Coway Malaysia Sdn. Bhd. All rights reserved..</p>
</div><!-- login_wrap end -->
</body>
