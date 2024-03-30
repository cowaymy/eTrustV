<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_approveLineSubmit);

});

function fn_closePop() {
    $("#registrationMsgPop").remove();
}

function fn_saveclose() {
	registrationMsgPop.remove();
}

function fn_approveLineSubmit() {


    /* var newGridList = AUIGrid.getOrgGridData(newGridID); */
    var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);

    /* console.log(memCode); */

    var requestResultM = {
            requestCategory : $("#requestCategory").val(),
            memCode : $("#memCode").val(),
            caseCategory : $("#caseCategory").val(),
            remark1 : $("#remark1").val(),
            effectDt : $("#effectDt").val(),
            userName : $("#userName").val()
    }
    console.log("requestResultM: " + requestResultM);

    var obj = {
            /* newGridList : newGridList, */
            apprGridList : apprGridList,
            "requestResultM" : requestResultM,
            /* memCode : memCode, */
    };
    console.log(obj);
    Common.ajax("POST", "/organization/checkApproval.do", obj, function(resultFinAppr) {
        console.log(resultFinAppr);

        if(resultFinAppr.code == "99") {
            Common.alert("Please select the relevant final approver.");
        } else {
        	console.log("Correct Final Approver");
        	Common.ajax("POST", "/organization/approveLineSubmit.do", obj, function(result) {
        		console.log(result);
                //Common.popupDiv("/organization/completedMsgPop.do", {memCode:result.data.memCode}, null, true, "completedMsgPop");
                Common.alert(result.message,fn_saveclose);
                $("#popup_wrap").remove();
        	});
        }
    });


}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member Access</h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt">Submit this request of member Access?</p>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="yes">Yes</a></p></li>
    <li><p class="btn_blue2"><a href="#" id="no">No</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->