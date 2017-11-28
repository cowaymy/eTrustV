<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

$("#dataForm").empty();

$(document).ready(function() {
    $("#_termSave").click(function() {
        
        if(termValidation() == true){
            // Param Flow : Sales Order Id > Rent Pay Id > Update
            Common.ajax("POST", "/sales/order/rentalPaySetEdit", $("#_termEditForm").serializeJSON() , function(result) {
                Common.alert(result.message, fn_closePop());
            });
        }
    });
    //Term Selected Value
    fn_setInitValue();
    
});//Doc Ready Func End

function fn_setInitValue(){
    
    var selVal = $("#_curPayTerm").val();
    if(selVal == null || selVal == ""){
        $("#_payTerm").val("0");
    }else{
        $("#_payTerm").val(selVal);
    }
}

function fn_closePop(){
    $("#_close").click();
    $("#_calSearch").click();
}

function termValidation(){
    if($("#_payTerm").val() == null || $("#_payTerm").val() == ""){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Pay Term'/>");
        return false;
    }
    
    //Success
    return true;
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>RENTAL PAY SETTING</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->

<aside class="title_line"><!-- title_line start -->
<h2>Rental Payment Setting</h2>
</aside><!-- title_line end -->

<input type="hidden" id="_curPayTerm" value="${payMap.payTrm}">

<form id="_termEditForm" method="POST">
<input type="hidden" name="termSalesOrdId" id="_termSalesOrdId" value="${salesOrdId}">  <!-- SalesOrdId  -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Pay Term</th>
    <td>
    <select class="w100p" id="_payTerm" name="payTerm">
        <option value="0">No Term</option>
        <option value="1">1 Month</option>
        <option value="2">2 Month</option>
        <option value="3">3 Month</option>
        <option value="4">4 Month</option>
        <option value="5">5 Month</option>
        <option value="6">6 Month</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_termSave">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->