<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_approveLineSubmit);
    
});

function fn_closePop() {
	$("#expRegistrationMsgPop").remove();
}

function fn_approveLineSubmit() {
	$("#expRegistrationMsgPop").remove();
	
	var newGridList = AUIGrid.getOrgGridData(newGridID);
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    var obj = {
            newGridList : newGridList,
            apprGridList : apprGridList,
            clmNo : clmNo,
            allTotAmt : Number($("allTotAmt_text").text().replace(/,/gi, ''))
    };
    console.log(obj);
    
    Common.ajax("POST", "/eAccounting/pettyCash/expApproveLineSubmit.do", obj, function(result) {
        console.log(result);
        Common.popupDiv("/eAccounting/pettyCash/expCompletedMsgPop.do", {callType:callType,clmNo:result.data.clmNo}, null, true, "expCompletedMsgPop");
        //Common.alert("Your authorization request was successful.");
    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newRgistExpMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newRgistExpMsg.rgistMsg" /></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->