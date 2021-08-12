<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_updateCustodian);
    
});

function fn_closePop() {
	$("#registMsgPop").remove();
}

function fn_updateCustodian() {
	$("#registMsgPop").remove();
	
	var formData = Common.getFormData("form_newCustdn");
	var obj = $("#form_newCustdn").serializeJSON();
	$.each(obj, function(key, value) {
		if(key == "custdnNric") {
			formData.append(key, value.replace(/\-/gi, ''));
			console.log(value.replace(/\-/gi, ''));
		} else if(key == "appvCashAmt") {
			formData.append(key, value.replace(/,/gi, ''));
            console.log(value.replace(/,/gi, ''));
		} else {
			formData.append(key, value);
		}
	});
	formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    Common.ajaxFile("/eAccounting/pettyCash/updateCustodian.do", formData, function(result) {
        console.log(result);
        Common.popupDiv("/eAccounting/pettyCash/viewCompletedMsgPop.do", null, null, true, "completedMsgPop");
    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="viewRgistCustdnMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="viewRgistCustdnMsg.rgistMsg" /></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->