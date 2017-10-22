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
		formData.append(key, value);
	});
    Common.ajaxFile("/eAccounting/pettyCash/insertCustodian.do", formData, function(result) {
        console.log(result);
        Common.popupDiv("/eAccounting/pettyCash/newCompletedMsgPop.do", null, null, true, "completedMsgPop");
    });
	
    /* var newGridList = AUIGrid.getOrgGridData(newGridID);
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
    console.log(data); */
    
    // 예산확인
    /* Common.ajax("POST", "/eAccounting/pettyCash/budgetCheck.do", data, function(result) {
        console.log(result);
        if(result.length > 0) {
            Common.alert("Budget exceeded.");
            console.log(result.length);
            
        } else {
        	Common.ajax("POST", "/eAccounting/pettyCash/insertCustodian.do", $("#form_newWebInvoice").serializeJSON(), function(result) {
                console.log(result);
                Common.popupDiv("/eAccounting/webInvoice/newCompletedMsgPop.do", {callType:callType}, null, true, "completedMsgPop");
            });
        }
    }); */
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New petty cash custodian  registration</h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt">Are you sure you want to create this new petty cash custodian into system?</p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->