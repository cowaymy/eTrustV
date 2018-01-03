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
	$("#registMsgPop").remove();
	
    var newGridList = AUIGrid.getOrgGridData(newGridID);
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var costCentr = $("#newCostCenter").val();
    var data = {
            newGridList : newGridList
            ,year : year
            ,month : month
            ,costCentr : costCentr
    };
    console.log(data);
    
    // 예산확인
    Common.ajax("POST", "/eAccounting/webInvoice/budgetCheck.do", data, function(result) {
        console.log(result);
        if(result.length > 0) {
            Common.alert('<spring:message code="newWebInvoRegistMsg.budget.msg" />');
            console.log(result.length);
            for(var i = 0; i < result.length; i++) {
                console.log(result[i]);
                var rowIndex = AUIGrid.rowIdToIndex(newGridID, result[i])
                AUIGrid.setCellValue(newGridID, rowIndex, "yN", "N");
                $("#registMsgPop").remove();
                $("#approveLineSearchPop").remove();
            }
        } else {
        	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
            var obj = $("#form_newWebInvoice").serializeJSON();
            obj.newGridList = newGridList;
            obj.apprGridList = apprGridList;
            
            Common.ajax("POST", "/eAccounting/webInvoice/approveLineSubmit.do", obj, function(result) {
                console.log(result);
                Common.popupDiv("/eAccounting/webInvoice/newCompletedMsgPop.do", {callType:callType, clmNo:result.clmNo}, null, true, "completedMsgPop");
                //Common.alert("Your authorization request was successful.");
            });
        }
    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newWebInvoRegistMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newWebInvoRegistMsg.registMsg" /></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->