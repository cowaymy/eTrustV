<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


$(document).ready(function(){

});

//크리스탈 레포트
function fn_generateStatement(){
    
    if(FormUtil.checkReqValue($("#orderNo")) &&  FormUtil.checkReqValue($("#billNo"))){
    	Common.alert("<spring:message code='pay.alert.billNoOROrderNo'/>");
        return;
    }
    
    Common.ajax("POST", "/payment/selectPenaltyBillDate.do", $("#searchForm").serializeJSON(), function(result) {
        if(result != null && result.length > 0) {
            var year = result[0].billDtYear;
            var month = result[0].billDtMonth;
            
            if(year < 2017 || (year == 2015 && month < 4)){
                //report form에 parameter 세팅
                $("#reportPDFForm #v_orderNo").val($('#orderNo').val());
                $("#reportPDFForm #v_billNo").val($('#billNo').val());
                
                //report 호출
                var option = {
                       isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };
                
                Common.report("reportPDFForm", option);
            
            }else{
            	$("#popup_wrap").remove();
            	Common.popupDiv("/payment/initTaxInvoiceMiscellaneousPop.do", {pdpaMonth:${pdpaMonth}}, null, true);            
            }
        }else{
        	$("#popup_wrap").remove();
        	Common.popupDiv("/payment/initTaxInvoiceMiscellaneousPop.do", {pdpaMonth:${pdpaMonth}}, null, true);
        }               
        
    });
}

function fn_clear(){
    $("#searchForm")[0].reset();
}
</script>
<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Penalty Invoice</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateStatement();"><spring:message code='pay.btn.generate'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>    
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
			<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:160px" />
                    <col style="width:*" />                  
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order No</th>
                        <td>
                            <input id="orderNo" name="orderNo" type="text"  />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">RET No</th>
                        <td>
                            <input id="billNo" name="billNo" type="text"  />
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>
</section>
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/statement/PenantlyInvoice_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_orderNo" name="v_orderNo" />
    <input type="hidden" id="v_billNo" name="v_billNo" />
</form>
</div>