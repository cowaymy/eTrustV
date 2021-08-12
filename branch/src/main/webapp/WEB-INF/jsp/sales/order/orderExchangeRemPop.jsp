<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	function fn_saveExchgCancel(){
	    Common.ajax("GET", "/sales/order/saveCancelReq.do", $("#sForm").serialize(), function(result){
	        //result alert and reload
	        Common.alert('<spring:message code="sal.alert.msg.productExchReqCancelled" />', fn_success);
	    }, function(jqXHR, textStatus, errorThrown) {
	        try {
	            console.log("status : " + jqXHR.status);
	            console.log("code : " + jqXHR.responseJSON.code);
	            console.log("message : " + jqXHR.responseJSON.message);
	            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
	
	            //Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
	            Common.alert('<spring:message code="sal.alert.msg.unableToRetrieveExchgeReq" />');
	            }
	        catch (e) {
	            console.log(e);
	            alert("Saving data prepration failed.");
	        }
	        alert("Fail : " + jqXHR.responseJSON.message);
	        });
	    
	}
	
	function fn_success(){
		fn_searchListAjax();
	    
	    $("#_close").click();
	    $("#_dClose").click();
//	    Common.popupDiv("/sales/order/orderExchangeDetailPop.do", $("#detailForm").serializeJSON(), null , true, '_exchgDiv');
	}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.orderExchangeRemark" /></h1>
<ul class="right_opt">
    <li id="mClose"><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.requestCancelConfirmation" /></h2>
</aside><!-- title_line end -->

<form id="sForm" name="sForm" method="post">
    <input type="hidden" id="initType" name="initType" value="${initType }">
    <input type="hidden" id="exchgStus" name="exchgStus" value="${exchgStus }">
    <input type="hidden" id="exchgCurStusId" name="exchgCurStusId" value="${exchgCurStusId }">
    <input type="hidden" id="salesOrderId" name="salesOrderId" value="${salesOrderId }">
    <input type="hidden" id="soExchgIdDetail" name="soExchgIdDetail" value="${soExchgIdDetail }">


<table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
        <tbody>
            <tr>
                <th scope="row"><spring:message code="sal.title.remark" /></th>
                <td>
                <textarea cols="20" rows="5" id="soExchgRem" name="soExchgRem" placeholder="Remark"></textarea>
                </td>
            </tr>
        </tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="fn_saveExchgCancel()"><spring:message code="sal.title.text.cancelReq" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->