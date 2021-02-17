<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_cpeApproveLineSubmit);

});

function fn_closePop() {
    $("#cpeReqstRegistrationMsgPop").remove();
}

function fn_cpeApproveLineSubmit() {
    $("#cpeReqstRegistrationMsgPop").remove();

    var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
    var obj = $("#form_newReqst").serializeJSON();
    obj.apprGridList = apprGridList;
    console.log(obj);

    Common.ajax("POST", "/services/ecom/cpeReqstApproveLineSubmit.do", obj, function(result) {
        console.log(result);
        Common.popupDiv("/services/ecom/cpeReqstCompletedMsgPop.do", {cpeReqNo:result.data.cpeReqNo}, null, true, "cpeReqstCompletedMsgPop");
        //Common.alert("Your authorization request was successful.");
    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newRgistRqstMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newCpeRequest.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newRgistRqstMsg.rgistMsg" /></p>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="yes"><spring:message code="newCpeReqRegistMsg.yes" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="no"><spring:message code="newCpeReqRegistMsg.no" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->