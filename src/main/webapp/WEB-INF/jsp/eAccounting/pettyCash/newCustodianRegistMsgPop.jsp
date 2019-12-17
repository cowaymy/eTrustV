<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_insertCustodian);
    
});

function fn_closePop() {
	$("#registMsgPop").remove();
}

function fn_insertCustodian() {
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
    Common.ajaxFile("/eAccounting/pettyCash/insertCustodian.do", formData, function(result) {
        console.log(result);
        if(result.code == "00"){
        	Common.popupDiv("/eAccounting/pettyCash/newCompletedMsgPop.do", null, null, true, "completedMsgPop");
        } else {
        	Common.alert("The same custodian exists. Please check.");
        }
        
    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newRgsitCustdnMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newRgsitCustdnMsg.rgistMsg" /></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->