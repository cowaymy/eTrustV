<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#ok").click(fn_closePop);

});

function fn_closePop() {
    $("#completedMsgPop").remove();
    $("#approveLineSearchPop").remove();
    $("#newVendorPop").remove();
    $("#editVendorPop").remove();
    console.log(callType);
    if("${callType}" == "new") {
    	$("#newVendorPop").remove();
    }else if("${callType}" == "view") {
    	$("#viewEditVendorPop").remove();
    }

    fn_selectVendorList();
}
</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Vendor Registration</h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt">Registration of new Vendor has been completed.</p>
<ul class="center_btns">
    <li><p class="btn_blue2" id="ok"><a href="#"><spring:message code="newWebInvoRegistMsg.ok" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->