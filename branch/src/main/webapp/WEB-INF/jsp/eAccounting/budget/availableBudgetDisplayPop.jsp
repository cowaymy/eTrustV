<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
</style>
<script  type="text/javascript">
$(document).ready(function(){
    
    if("${result.planAmt }" == ""){
        $("#planAmt").text(0);
        $("#chngAmt").text(0);
        $("#adjustAmt").text(0);
        $("#total").text(0);
        $("#pendAppvAmt").text(0);
        $("#consumAppvAmt").text(0);
        $("#availableAmt").text(0);
    }else{
        $("#planAmt").text(comma("${result.planAmt }"));
        $("#chngAmt").text(comma("${result.chngAmt}"));
        $("#adjustAmt").text(comma("${result.adjustAmt }"));
        $("#total").text(comma("${result.total }"));
        $("#pendAppvAmt").text(comma("${result.pendAppvAmt }"));
        $("#consumAppvAmt").text(comma("${result.consumAppvAmt }"));
        $("#availableAmt").text(comma("${result.availableAmt}"));
    }
    
    //adjustAmt 상세 팝업
    $("#adjustAmt").click(function() { 
         Common.popupDiv("/eAccounting/budget/adjustmentAmountPop.do",$("#pForm").serializeJSON(), null, true, "adjustmentAmountPop"); 
    });
    
    //pendAppvAmt 상세 팝업
   $("#pendAppvAmt").click(function() {    
        $("#type").val("Pending");         
         Common.popupDiv("/eAccounting/budget/pendingConsumedAmountPop.do",$("#pForm").serializeJSON(), null, true, "pendingConsumedAmountPop"); 
    });
   
    //consumAppvAmt 상세 팝업
    $("#consumAppvAmt").click(function() { 
        $("#type").val("Consumed");         
         Common.popupDiv("/eAccounting/budget/pendingConsumedAmountPop.do",$("#pForm").serializeJSON(), null, true, "pendingConsumedAmountPop"); 
    });
    
    
});

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="budget.AvailableBudgetDisplay" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height:200px"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="pForm" name="pForm">
<input type="hidden" id="budgetPlanYear" name="budgetPlanYear"  value="${item.budgetPlanYear }"/>
<input type="hidden" id="budgetPlanMonth" name="budgetPlanMonth"  value="${item.budgetPlanMonth }"/>
<input type="hidden" id="type" name="type" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly" readonly="readonly" style="width:100px" value="${ item.month}/${item.budgetPlanYear}"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="budget.CostCenter" /></th>
    <td><input type="text" id="costCentr" name ="costCentr" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.costCentr }"/></td>
    <th scope="row"><spring:message code="budget.CostCenter" /> <spring:message code="budget.Description" /></th>
    <td><input type="text"  id="costCenterText" name ="costCenterText" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.costCenterText }"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="expense.Activity" /></th>
    <td><input type="text"  id="budgetCode" name ="budgetCode" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${item.budgetCode }"/></td>
    <th scope="row"><spring:message code="expense.Activity" /> <spring:message code="budget.Description" /></th>
    <td><input type="text"  id="budgetCodeText" name ="budgetCodeText" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${item.budgetCodeText }" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="expense.GLAccount" /></th>
    <td><input type="text"  id="glAccCode" name ="glAccCode" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${item.glAccCode }" /></td>
    <th scope="row"><spring:message code="expense.GLAccount" /> <spring:message code="budget.Description" /></th>
    <td><input type="text"  id="glAccDesc" name ="glAccDesc" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.glAccDesc }"/></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type2 mt30"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:auto" />
</colgroup>
<thead>
<tr>
    <th scope="col"><spring:message code="budget.YearlyPlan" /></th>
    <th scope="col"><spring:message code="budget.Yearlyadditional" /></th>
    <th scope="col" class="bg_color_gray"><spring:message code="budget.Adjustment" /> <spring:message code="budget.Amount" /></th>
    <th scope="col"><spring:message code="budget.Total" /> <spring:message code="budget.Amount" /></th>
    <th scope="col" class="bg_color_gray"><spring:message code="budget.Pending" /> <spring:message code="budget.Amount" /></th>
    <th scope="col" class="bg_color_gray"><spring:message code="budget.Utilised" /> <spring:message code="budget.Amount" /></th>
    <th scope="col" class="black_text bold_text"><spring:message code="budget.Available" /> <spring:message code="budget.Amount" /></th>
</tr>
</thead>
<tbody>
<tr>
               
    <td><span id="planAmt"></span></td>
    <td><span id="chngAmt"></span></td>
    <td><span ><a href="#" class="blue_text text_underline" id='adjustAmt'></a></span></td>
    <td><span id='total'></span></td>
    <td><span ><a href="#" class="blue_text text_underline" id="pendAppvAmt"></a></span></td>
    <td><span ><a href="#" class="blue_text text_underline" id="consumAppvAmt"></a></span></td>
    <td><span id="availableAmt"></span></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->