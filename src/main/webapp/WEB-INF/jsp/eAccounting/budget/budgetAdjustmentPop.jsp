<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script  type="text/javascript">

var adjPGridID;

$(document).ready(function(){
    
    CommonCombo.make("pAdjustmentType", "/common/selectCodeList.do", {groupCode:'347', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"S"
    });
/*     
    $("#btnSearch").click(fn_selectListAjax);
    
    $("#adjustment").click(fn_budgetAdjustmentPop); */
    
    var adjPLayout = [ {
        dataField : "",
        headerText : '<spring:message code="budget.CostCenter" />',
        cellMerge : true ,
        mergeRef : "", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 130
    },{
        dataField : "adjYearMonth",
        headerText : '<spring:message code="budget.Month" />/<spring:message code="budget.Year" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
    },{
        dataField : "budgetCode",
        headerText : '<spring:message code="budget.BudgetCode" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 130
    },{
        dataField : "glAccCode",
        headerText : '<spring:message code="expense.GLAccount" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 130
    },{
        dataField : "budgetAdjTypeName",
        headerText : '<spring:message code="budget.AdjustmentType" />',
        width : 150
    },{
        dataField : "adjAmt",
        headerText : '<spring:message code="budget.Amount" />',
        dataType : "numeric",
        formatString : "#,##0",
        width : 100
    },{
        dataField : "adjRem",
        headerText : '<spring:message code="budget.Remark" />',
        style : "aui-grid-user-custom-left ",
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 200
    }];
         
    var adjPOptions = {
            enableCellMerge : true,
            showStateColumn:true,
            showRowNumColumn : true,
            usePaging : false,
            editable :false
      }; 
    
    adjPGridID = GridCommon.createAUIGrid("#adjPGridID", adjPLayout, "", adjPOptions);
       
});

var budgetStr ;
//Budget Code Pop 호출
function fn_budgetCodePop(str){
  budgetStr = str;
  Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do",null, null, true, "budgetCodeSearchPop");
}  


function  fn_setBudgetData(){
  if(budgetStr == "send"){
      $("#sendBudgetCode").val($("#pBudgetCode").val());
      $("#sendBudgetCodeName").val( $("#pBudgetCodeName").val());
  }else{
      $("#recvBudgetCode").val($("#pBudgetCode").val());
      $("#recvBudgetCodeName").val( $("#pBudgetCodeName").val());
  }
  
}

//Gl Account Pop 호출
var glStr ;
function fn_glAccountSearchPop(str){
  glStr = str;
  Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_setGlData (str){
  
  if(glStr =="send"){
      $("#sendGlAccCode").val($("#pGlAccCode").val());
      $("#sendGlAccCodeName").val( $("#pGlAccCodeName").val());
  }else{
      $("#recvGlAccCode").val($("#pGlAccCode").val());
      $("#recvGlAccCodeName").val( $("#pGlAccCodeName").val());
  }
      
}

//Cost Center
var costStr ;
function fn_costCenterSearchPop(str) {
  costStr = str;
  Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (str){
  
  if(costStr =="send"){
      $("#sendCostCentr").val($("#search_costCentr").val());
      $("#sendCostCentrName").val( $("#search_costCentrName").val());
  }else{
      $("#recvCostCentr").val($("#search_costCentr").val());
      $("#recvCostCentrName").val( $("#search_costCentrName").val());
  }
      
}



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="budget.BudgetAdjustment" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height:540px;"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="pAdjForm" name="pAdjForm">

    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />
    
    <input type="hidden" id = "search_costCentr" name="search_costCentr" />
    <input type="hidden" id = "search_costCentrName" name="search_costCentrName" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.AdjustmentType" /></th>
	<td>
	<select class="" id="pAdjustmentType" name="pAdjustmentType">
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<aside class="title_line budget"><!-- title_line start -->
<h3><spring:message code="budget.Sender" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
<%-- 	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td> --%>
	<td><input type="text" id="sendYearMonth" name="sendYearMonth" title="" placeholder="MM/YYYY" class="j_date2" value="${yearMonth }" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
		<input type="hidden" id="sendCostCenter" name="sendCostCenter" title="" placeholder="" class="" />
	    <input type="text" id="sendCostCenterName" name="sendCostCenterName" title="" placeholder="" class="" />
	    <a href="#" class="search_btn"  onclick="javascript:fn_costCenterSearchPop('send')">
	        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	    </a>
    </td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.BudgetCode" /></th>
	<td>
		<input type="hidden" id="sendBudgetCode" name="sendCostCenter" title="" placeholder="" class="" />
		<input type="text" id="sendBudgetCodeName" name="sendBudgetCodeName" title="" placeholder="" class="" />
		<a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop('send')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
		<input type="hidden" id="sendGlAccCode" name="sendGlAccCode" title="" placeholder="" class="" />
		<input type="text" id="stGlAccCodeName" name="stGlAccCodeName" title="" placeholder="" class="" />
		<a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop('send')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Send" /> <spring:message code="budget.Amount" /></th>
	<td><input type="text" id="sendAmount" name="sendAmount" title="" placeholder="" class="" /></td>
</tr>
</tbody>
</table><!-- table end -->

</div>

<div style="width:50%;">

<aside class="title_line budget"><!-- title_line start -->
<h3><spring:message code="budget.Receiver" /></h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
<%-- 	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td> --%>
	<td><input type="text" id="recvYearMonth" name="recvYearMonth" title="" placeholder="MM/YYYY" class="j_date2" value="${yearMonth }" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
		<input type="hidden" id="recvCostCenterName" name="recvCostCenterName" title="" placeholder="" class="" />
		<input type="text" id="recvCostCenter" name="recvCostCenter" title="" placeholder="" class="" />
		<a href="#" class="search_btn" onclick="javascript:fn_costCenterSearchPop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.BudgetCode" /></th>
	<td>
		<input type="hidden" id="recvBudgetCode" name="recvBudgetCode" title="" placeholder="" class="" />
		<input type="text" id="recvBudgetCodeName" name="recvBudgetCodeName" title="" placeholder="" class="" />
		<a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
	   </a>
   </td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
        <input type="hidden" id="recvGlAccCode" name="recvGlAccCode" title="" placeholder="" class="" />
		<input type="text"  id="recvGlAccCodeName" name="recvGlAccCodeName" title="" placeholder="" class="" />
		<a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop('recv')">
		   <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
		</a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Receiver" /> <spring:message code="budget.Amount" /></th>
	<td><input type="text"  id="recvAmount" name="recvAmount" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->

</div>

</div><!-- divine_auto end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.REMARK" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.Add" /></a></p></li>
	<li><p class="btn_blue2"><a href="#"><spring:message code="budget.Clear" /></a></p></li>
</ul>

<article class="grid_wrap mt10" style="height:170px"><!-- grid_wrap start -->
    <div id="adjPGridID" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Attathment" /></th>
	<td>
	<div class="auto_file2"><!-- auto_file start -->
	<input type="file" title="file add" />
	</div><!-- auto_file end -->
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns mt10">
	<li><p class="btn_blue2"><a href="#"><spring:message code="budget.Temp" /> <spring:message code="budget.Save" /></a></p></li>
	<li><p class="btn_blue2"><a href="#"><spring:message code="budget.Submit" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->