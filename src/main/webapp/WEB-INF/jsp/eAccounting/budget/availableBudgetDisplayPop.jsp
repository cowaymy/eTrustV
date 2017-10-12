<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
    
}
.my-right-style {
    text-align:right;
}
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
<form action="#" method="post">

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
	<th scope="row"><spring:message code="budget.Year" />/<spring:message code="budget.Month" /></th>
	<td colspan="3"><input type="text" title="" placeholder="" class="readonly" readonly="readonly" style="width:100px" value="${item.budgetPlanYear}/${ item.month}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.costCentr }"/></td>
	<th scope="row"><spring:message code="budget.CostCenter" /> <spring:message code="budget.Description" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.costCenterText }"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.BudgetCode" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${item.glAccCode }" /></td>
	<th scope="row"><spring:message code="budget.BudgetCode" /> <spring:message code="budget.Description" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly"  value="${item.glAccDesc }"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${item.budgetCode }"/></td>
	<th scope="row"><spring:message code="expense.GLAccount" /> <spring:message code="budget.Description" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${item.budgetCodeText }" /></td>
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
	<th scope="col" class="bg_color_gray"><spring:message code="budget.Consumed" /> <spring:message code="budget.Amount" /></th>
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