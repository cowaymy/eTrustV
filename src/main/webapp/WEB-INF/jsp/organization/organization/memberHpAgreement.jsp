<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {

    var memberID = $("#memberID").val();
    var userTypeID = $("#userTypeID").val();

    if (memberID == "") {
        if ($("#popup_wrap").attr("alert") != "Y") {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='ID'/>");
            $("#memberID").focus();
        }
        return false;
    }

    if (userTypeID == "") {
        if ($("#popup_wrap").attr("alert") != "Y") {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='TYPE'/>");
            $("#userTypeID").focus();
        }
        return false;
    }

    if("${message}" == "FAILED") {
        Common.alert("${message}");
    }
});

function fn_testAgreement(choice) {

    $("#choice").val(choice);

    Common.ajax("POST", "/organization/updateHpCfm.do", $('#agreementChoice').serializeJSON(), function(result) {
        Common.alert(result.message);
    });
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>TEST Agreement</h2>
</aside><!-- title_line end -->

<section id = "body">
<form id="applicantInfo" name="applicantInfo" method="post">
    <input type="hidden" id="memberID" name="memberID" value="${memberID}">
    <input type="hidden" id="userTypeID" name="userTypeID" value="${userTypeID}">
</form>

<form id="agreementChoice">
    <input type="hidden" id="choice" name="choice" value="">
</form>

<iframe id="agreementFrame" name = "agreementFrame" width = 100% height = "450px" src = "/resources/report/dev/agreement/CowayHealthPlannerAgreement.pdf" frameborder = "10"></iframe>

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:fn_testAgreement('Y');">Accept</a></p></li>
    <li><p class="btn_blue"><a href="javascript:fn_testAgreement('N');">Reject</a></p></li>
</ul>

</section>

</section><!-- content end -->
