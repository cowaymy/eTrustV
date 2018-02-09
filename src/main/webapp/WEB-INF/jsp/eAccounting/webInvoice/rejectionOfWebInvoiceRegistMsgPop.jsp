<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
    $("#cancel_btn").click(fn_closePop);
    $("#rejct_btn").click(function() {
    	var rejctResn = $("#rejctResn").val();
    	console.log(rejctResn);
        fn_appvRejctSubmit("rejct", rejctResn);
        $("#rejectRegistPop").remove();
        $("#webInvoiceAppvViewPop").remove();
    });
});

function fn_closePop() {
    $("#rejectRegistPop").remove();
}
</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="rejectionWebInvoiceMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="rejectionWebInvoiceMsg.registMsg" /><br /><br /><textarea cols="20" rows="5" id="rejctResn"></textarea></p>
<ul class="center_btns mt20">
	<li><p class="btn_blue2"><a href="#" id="rejct_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="cancel_btn"><spring:message code="approvalWebInvoMsg.cancel" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->