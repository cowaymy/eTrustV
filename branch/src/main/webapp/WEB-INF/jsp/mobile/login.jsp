<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/js.cookie.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/pgwbrowser.min.js"></script>
<script type="text/javaScript">
    var pgwBrowser;

    $(function () {

        if ("${exception}" == "401") {
            alert("<spring:message code='sys.msg.session.expired'/>");
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
                action: "/mobileWeb/login.do",
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
            action: getContextPath() + "/mobileWeb/common/main.do",
            method: "POST"
        }).submit();
    }

    function fn_login() {
        var userId = $("#userId").val();
        var password = $("#password").val();

        if (userId == "") {
            if ($("#popup_wrap").attr("alert") != "Y") {
                alert("<spring:message code='sys.msg.necessary' arguments='ID'/>");
                $("#userId").focus();
            }
            return false;
        }

        if (password == "") {
            if ($("#popup_wrap").attr("alert") != "Y") {
                alert("<spring:message code='sys.msg.necessary' arguments='PASSWORD'/>");
                $("#password").focus();
            }
            return false;
        }

        Common.ajax("POST"
            , "/login/getLoginInfo.do"
            , $("#loginForm").serializeJSON()
            , function (result) {

                if (result.code == 99) {
                    alert(result.message);
                    // $("#userId").val("");
                    $("#userId").focus();
                    return false;
                }

                fn_configCookies(userId);
                fn_goMain();
            }
            , function (jqXHR, textStatus, errorThrown) {
                console.log("fail.");
                console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

                if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                    alert(jqXHR.responseJSON.message);
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
    <h1><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway2.png" alt="Coway"/></h1>

    <article class="login_box"><!-- login_box start -->

        <form id="loginForm" name="loginForm" method="post">
            <input type="hidden" id="loginUserId" name="loginUserId" value=""/>
            <input type="hidden" id="loginOs" name="os" value=""/>
            <input type="hidden" id="loginBrowser" name="browser" value=""/>

            <h2><img src="${pageContext.request.contextPath}/resources/images/common/logo_etrust.gif" alt="Coway"/></h2>
            <p><input type="text" title="ID" placeholder="ID" id="userId" name="userId" value="IVYLIM"/></p>
            <p><input type="password" title="PASSWORD" placeholder="PASSWORD" id="password" name="password" value="ivy123"/></p>
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


        </form>
    </article><!-- login_box end -->

    <p class="copy">Copyrights 2017.<br>Coway Malaysia Sdn. Bhd. All rights reserved.</p>
</div><!-- login_wrap end -->
</body>