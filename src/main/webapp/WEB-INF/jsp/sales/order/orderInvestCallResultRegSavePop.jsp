<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	function fn_regSaveOK(){
	    Common.ajax("GET", "/sales/order/saveCallResultOk.do", $("#regForm").serializeJSON(), function(result) {
	        if(result.resultStatus == 29){
	            Common.alert("INV success", fn_success);
	        }else if(result.resultStatus == 28){
	            Common.alert("REG success", fn_successReg);
	        }else {
	            Common.alert("SUS success", fn_success);
	        }
	        Common.alert(result.msg);
	    }, function(jqXHR, textStatus, errorThrown) {
	            try {
	                console.log("status : " + jqXHR.status);
	                console.log("code : " + jqXHR.responseJSON.code);
	                console.log("message : " + jqXHR.responseJSON.message);
	                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
	
	                Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
	                }
	            catch (e) {
	                console.log(e);
	                alert("Saving data prepration failed.");
	            }
	            alert("Fail : " + jqXHR.responseJSON.message);
	    });
	}
	
	function fn_successReg(){
		fn_investCallResultListAjax();
        $("#_saveClose").click();
        $("#_regClose").click();
	}
</script>

<div id="popup_wrap" class="popup_wrap msg_box msg_big"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Investigation Result Confirmation</h1>
<p class="pop_close"><a href="#" id="_regClose">close</a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="regForm" name="regForm" method="GET">
<input type="hidden" id="callResultInvId" name="callResultInvId" value="${callResultInvId}">
<input type="hidden" id="invCallEntryId" name="invCallEntryId" value="${invCallEntryId}">
<input type="hidden" id="saveSalesOrdNo" name="saveSalesOrdNo" value="${saveSalesOrdNo}">
<input type="hidden" id="saveSalesOrdId" name="saveSalesOrdId" value="${saveSalesOrdId}">
<input type="hidden" id="callResultStus" name="callResultStus" value="${callResultStus}">
<input type="hidden" id="callResultRem" name="callResultRem" value="${callResultRem}">
<div class="msg_txt">
Order Number:<span>${saveSalesOrdNo}</span><br />
This month is BS month for this order.<br />
Ticket of BS request will be send to cody divison automatically by system.<br />
<p class="input_area">
<label><input type="radio" name="ccticket" value="1"/><span>Don't Send Ticket</span></label>
<label><input type="radio" name="ccticket" value="0"/><span>Ticket Send</span></label><br />
</p><br />
Are you sure want to remain this order to status regular?
</div>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="fn_regSaveOK()">YES</a></p></li>
</ul>
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->