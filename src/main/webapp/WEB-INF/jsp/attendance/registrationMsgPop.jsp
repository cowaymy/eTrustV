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

function fn_approveLineSubmit() {
    $("#registrationMsgPop").remove();

    var data = AUIGrid.getOrgGridData(approveLineGridID);

    var obj = {
            apprGridList : data,
            batchId : '${batchId}'
    };

    Common.ajax("POST", "/attendance/approveLineSubmit.do", obj, function(result) {
        Common.alert("Success to submit. Pending to Approval.",fn_reload);
    });

}

function fn_reload(){
	location.reload();
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Attendance Upload Approval Form</h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newRgistStaffClaim.rgistMsg" /></p>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newWebInvoRegistMsg.yes" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newWebInvoRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->