<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">


$(document).ready(function(){

});

//크리스탈 레포트
function fn_generateStatement(){
	
	if(FormUtil.checkReqValue($("#orderNo")) &&  FormUtil.checkReqValue($("#billNo"))){
        Common.alert('* Please key in either RET No or Order No. <br>');
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
				location.href = "/payment/initTaxInvoiceMiscellaneous.do";				
			}
        }else{
        	location.href = "/payment/initTaxInvoiceMiscellaneous.do";
        }			    
	    
    });
}
function fn_Clear(){
    $("#searchForm")[0].reset();
}
</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Penalty Invoice</li>
    </ul>
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Penalty Invoice</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_generateStatement();">Generate</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_Clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
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