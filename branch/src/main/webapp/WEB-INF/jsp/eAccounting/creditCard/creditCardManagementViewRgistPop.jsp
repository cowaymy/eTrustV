<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no_btn").click(fn_closePop);
    $("#yes_btn").click(fn_updateCreditCard);
    
});

function fn_closePop() {
    $("#registMsgPop").remove();
}

function fn_updateCreditCard() {
    $("#registMsgPop").remove();
    
    var formData = Common.getFormData("form_newMgmt");
    var obj = $("#form_newMgmt").serializeJSON();
    var appvCrditLimit = obj.appvCrditLimit;
    obj.appvCrditLimit = Number(appvCrditLimit.replace(/,/gi, ""));
    obj.crditCardNo = obj.crditCardNo1 + obj.crditCardNo2 + obj.crditCardNo3 + obj.crditCardNo4;
    obj.bankName = $("#bankCode option:selected").text();
    delete obj.crditCardNo1;
    delete obj.crditCardNo2;
    delete obj.crditCardNo3;
    delete obj.crditCardNo4;
    console.log(obj);
    $.each(obj, function(key, value) {
        formData.append(key, value);
    });
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    Common.ajaxFile("/eAccounting/creditCard/updateCreditCard.do", formData, function(result) {
        console.log(result);
        Common.popupDiv("/eAccounting/creditCard/viewCompletedMsgPop.do", null, null, true, "completedMsgPop");
    });
}
</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="viewRgistMgmt.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="viewRgistMgmt.rgistMsg" /></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes_btn"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no_btn"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->