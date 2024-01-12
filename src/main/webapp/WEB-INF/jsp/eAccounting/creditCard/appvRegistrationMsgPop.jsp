<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_approveLineSubmit);

});

function fn_closePop() {
	$("#registMsgPop").remove();
}

function fn_approveLineSubmit() {
	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);

	if(apprGridList.length==0){
        Common.alert('Approval Line must have at least 1 record. Please set approval line on credit card management page.');
       	return false;
	}

    if(apprGridList.length >= 1) {
        for(var i = 0; i < apprGridList.length; i++) {
            if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ". Please set approval line on credit card management page.");
               	return false;
                break;
            }
        }
    }

	$("#registMsgPop").remove();

	var newGridList = AUIGrid.getOrgGridData(newGridID);
    var obj = {
            newGridList : newGridList,
            apprGridList : apprGridList,
            clmNo : clmNo,
            allTotAmt : Number($("allTotAmt_text").text().replace(/,/gi, ''))
    };
    console.log(obj);
    Common.ajax("POST", "/eAccounting/creditCard/approveLineSubmit.do", obj, function(result) {
        console.log(result);
        Common.popupDiv("/eAccounting/creditCard/appvCompletedMsgPop.do", {callType:callType,clmNo:result.data.clmNo}, null, true, "completedMsgPop");
        //Common.alert("Your authorization request was successful.");
    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newRgistReimMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newRgistReimMsg.rgistMsg" /></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->