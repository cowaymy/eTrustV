<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    $("#ok").click(fn_closePop);
    
});

function fn_closePop() {
    $("#expCompletedMsgPop").remove();
    $("#approveLineSearchPop").remove();
    
    if("${callType}" == "new") {
    	$("#newExpensePop").remove();
    } else if("${callType}" == "view") {
    	$("#viewExpensePop").remove();
    }
    
    fn_selectExpenseList();
}
</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newRgistExpMsg.title" /></h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt"><spring:message code="newRgistExpMsg.compleMsg" /><br><spring:message code="newWebInvoRegistMsg.clmNo" /> ${clmNo}</p>
<ul class="center_btns">
    <li><p class="btn_blue2" id="ok"><a href="#"><spring:message code="newWebInvoRegistMsg.ok" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->