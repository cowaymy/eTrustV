<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_approveLineSubmit);
    
});

function fn_closePop() {
	$("#reqstRegistrationMsgPop").remove();
}

function fn_approveLineSubmit() {
	$("#reqstRegistrationMsgPop").remove();
	
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    var obj = $("#form_newReqst").serializeJSON();
    obj.appvCashAmt = obj.appvCashAmt.replace(/,/gi, '');
    obj.reqstAmt = obj.reqstAmt.replace(/,/gi, '');
    obj.apprGridList = apprGridList;
    console.log(obj);
    
    Common.ajax("POST", "/eAccounting/pettyCash/reqstApproveLineSubmit.do", obj, function(result) {
        console.log(result);
        Common.popupDiv("/eAccounting/pettyCash/reqstCompletedMsgPop.do", {callType:callType,clmNo:result.data.clmNo}, null, true, "reqstCompletedMsgPop");
        //Common.alert("Your authorization request was successful.");
    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newRgistRqstMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newRgistRqstMsg.rgistMsg" /></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->