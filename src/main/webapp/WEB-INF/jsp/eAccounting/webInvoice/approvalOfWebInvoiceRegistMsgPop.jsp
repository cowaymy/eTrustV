<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	$("#apprvResn").keyup(function(){
		  $("#characterCount").text($(this).val().length + " of 900 max characters");
	});

    $("#cancel_btn").click(fn_closePop);
    $("#confirm_btn").click(function () {
    	var apprvResn = $("#apprvResn").val();
    	fn_appvRejctSubmit("appv", apprvResn);
    	$("#approveRegistPop").remove();
        $("#webInvoiceAppvViewPop").remove();
    });
});

function fn_closePop() {
    $("#approveRegistPop").remove();
}
</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="approvalWebInvoMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="approvalWebInvoMsg.registMsg" /></p>
<textarea cols="20" rows="5" id="apprvResn" maxlength="900"></textarea><span id="characterCount">0 of 900 max characters</span></p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="confirm_btn"><spring:message code="approvalWebInvoMsg.confirm" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="cancel_btn"><spring:message code="approvalWebInvoMsg.cancel" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->