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
.my-pointer-style {
    text-align:right;
    cursor:pointer;
    font-weight:bold;
}
</style>
<script  type="text/javascript">
var budgetGridID;
$(document).ready(function(){
    
	fn_creatGrid();
	
    //엑셀 다운
    $('#excelDown').click(function() {        
       GridCommon.exportTo("budgetGridID", 'xlsx', "Available Budget List");
    });
    
});

function fn_creatGrid(){
	
    var colLayout = [
            /*  {  dataField : "budgetPlanYear", headerText : '', width : 90, visible :false }
            ,{  dataField : "budgetPlanMonth", headerText : '', width : 90, visible :false }, */
             {  dataField : "costCentr", headerText : '<spring:message code="budget.CostCenter" />', width : 90 }
            ,{  dataField : "costCenterText", headerText : '<spring:message code="budget.CostCenter" />', width : 130 }
            ,{  dataField : "budgetCode", headerText : '<spring:message code="expense.Activity" />', width : 100 }
            ,{  dataField : "budgetCodeText", headerText : '<spring:message code="expense.ActivityName" />', width : 130 }
            ,{  dataField : "glAccCode", headerText : '<spring:message code="expense.GLAccount" />', width : 100 }
            ,{  dataField : "glAccDesc", headerText : '<spring:message code="expense.GLAccountName" />', width : 130 }
            ,{  dataField : "planAmt", headerText : '<spring:message code="budget.YearlyPlan" />',        dataType : "numeric",        formatString : "#,##0.00",        style : "my-right-style",        width : 100    }
            ,{  dataField : "chngAmt", headerText : '<spring:message code="budget.Yearlyadditional" />',        dataType : "numeric",        formatString : "#,##0.00",        style : "my-right-style",        width : 120    }
            ,{  dataField : "adjustAmt",        headerText : '<spring:message code="budget.Adjustment" /> <spring:message code="budget.Amount" />',        dataType : "numeric",        formatString : "#,##0.00",        style : "my-pointer-style",        width : 120    }
            ,{  dataField : "total",        headerText : '<spring:message code="budget.Total" /> <spring:message code="budget.Amount" />',        dataType : "numeric",        formatString : "#,##0.00",        style : "my-right-style",        width : 120    }
            ,{  dataField : "pendAppvAmt",        headerText : '<spring:message code="budget.Pending" /> <spring:message code="budget.Amount" />',        dataType : "numeric",        formatString : "#,##0.00",        style : "my-pointer-style",        width : 120    }
            ,{  dataField : "consumAppvAmt",        headerText : '<spring:message code="budget.Utilised" /> <spring:message code="budget.Amount" />',        dataType : "numeric",        formatString : "#,##0.00",        style : "my-pointer-style",        width : 120    }
            ,{  dataField : "availableAmt",        headerText : '<spring:message code="budget.Available" /> <spring:message code="budget.Amount" />',        dataType : "numeric",        formatString : "#,##0.00",        style : "my-right-style",        width : 120    }
    ];
         
    var options = {
            showStateColumn:false,
            showRowNumColumn    : false,
            usePaging : false,
            editable :false
      }; 
    
    budgetGridID = GridCommon.createAUIGrid("#budgetGridID", colLayout, "", options);
    
    
    AUIGrid.bind(budgetGridID, "cellClick", function(event){
    	
    	$("#stDate").val($("#stYearMonth").val());
    	$("#edDate").val($("#edYearMonth").val());
    	$("#costCentr").val(AUIGrid.getCellValue(budgetGridID, event.rowIndex, "costCentr"));
    	$("#budgetCode").val(AUIGrid.getCellValue(budgetGridID, event.rowIndex, "budgetCode"));
    	$("#glAccCode").val(AUIGrid.getCellValue(budgetGridID, event.rowIndex, "glAccCode"));
        
    	if(event.dataField == "adjustAmt"){
    		
            Common.popupDiv("/eAccounting/budget/adjustmentAmountPop.do",$("#searchForm").serializeJSON(), null, true, "adjustmentAmountPop");
            
    	}else if(event.dataField == "pendAppvAmt"){
    		
            $("#type").val("Pending");  
            Common.popupDiv("/eAccounting/budget/pendingConsumedAmountPop.do",$("#searchForm").serializeJSON(), null, true, "pendingConsumedAmountPop");
            
    	}else if(event.dataField == "consumAppvAmt"){
    		
            $("#type").val("Consumed");         
             Common.popupDiv("/eAccounting/budget/pendingConsumedAmountPop.do",$("#searchForm").serializeJSON(), null, true, "pendingConsumedAmountPop");  
    	}
    });
      
}

//리스트 조회.
function fn_selectListAjax() { 
	
	if($("#stYearMonth").val() == ""){
		Common.alert("Please key in start date.");
		return;
	}
    Common.ajax("GET", "/eAccounting/budget/selectAvailableBudgetList", $("#listSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(budgetGridID, result);

    });
}

var budgetStr ;
//Budget Code Pop 호출
function fn_budgetCodePop(str){
  budgetStr = str;
  Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do",null, null, true, "budgetCodeSearchPop");
}  


function  fn_setBudgetData(){
  if(budgetStr == "st"){
      $("#stBudgetCode").val($("#pBudgetCode").val());
      $("#stBudgetCodeName").val( $("#pBudgetCodeName").val());
  }else{
      $("#edBudgetCode").val($("#pBudgetCode").val());
      $("#edBudgetCodeName").val( $("#pBudgetCodeName").val());
  }
  
}

//Gl Account Pop 호출
var glStr ;
function fn_glAccountSearchPop(str){
  glStr = str;
  Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_setGlData (str){
  
  if(glStr =="st"){
      $("#stGlAccCode").val($("#pGlAccCode").val());
      $("#stGlAccCodeName").val( $("#pGlAccCodeName").val());
  }else{
      $("#edGlAccCode").val($("#pGlAccCode").val());
      $("#edGlAccCodeName").val( $("#pGlAccCodeName").val());
  }
      
}

//Cost Center
var costStr ;
function fn_costCenterSearchPop(str) {
  costStr = str;
  Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (str){
  
  if(costStr =="st"){
      $("#stCostCentr").val($("#search_costCentr").val());
      $("#stCostCentrName").val( $("#search_costCentrName").val());
  }else{
      $("#edCostCentr").val($("#search_costCentr").val());
      $("#edCostCentrName").val( $("#search_costCentrName").val());
  }
      
}

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>eAccount</li>
	<li>Available Budget List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Available Budget List</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onClick="javascript:fn_selectListAjax();" ><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="searchForm" name="searchForm"> 
    <input type="hidden" id = "stDate" name="stDate" />
    <input type="hidden" id = "edDate" name="edDate" />
    <input type="hidden" id = "costCentr" name="costCentr" />
    <input type="hidden" id = "budgetCode" name="budgetCode" />
    <input type="hidden" id = "glAccCode" name="glAccCode" />
    <input type="hidden" id = "type" name="type" />
</form>
<form action="#" method="post" id="listSForm" name="listSForm">    
    <input type="hidden" id = "pBudgetCode" name="pBudgetCode" />
    <input type="hidden" id = "pBudgetCodeName" name="pBudgetCodeName" />
    <input type="hidden" id = "pGlAccCode" name="pGlAccCode" />
    <input type="hidden" id = "pGlAccCodeName" name="pGlAccCodeName" />
    
    <input type="hidden" id = "search_costCentr" name="search_costCentr" />
    <input type="hidden" id = "search_costCentrName" name="search_costCentrName" />    
    
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="budget.Year" />/<spring:message code="budget.Month" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" id="stYearMonth" name="stYearMonth" placeholder="MM/YYYY" class="j_date2" /></p>
	<span>To</span>
	<p><input type="text" id="edYearMonth" name="edYearMonth" placeholder="MM/YYYY" class="j_date2" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
		<div class="date_set w100p"><!-- date_set start -->
		<p class="search_type"><input type="text" id="stCostCentr" name="stCostCentr" class="fl_left" /><a href="#" onclick="javascript:fn_costCenterSearchPop('st')" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		<span>~</span>
		<p class="search_type"><input type="text" id="edCostCentr" name="edCostCentr" class="fl_left" /><a href="#" onclick="javascript:fn_costCenterSearchPop('ed')" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		</div><!-- date_set end -->
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
		<div class="date_set w100p"><!-- date_set start -->
		<p class="search_type"><input type="text" id="stGlAccCode" name="stGlAccCode" class="fl_left" /><a href="#" onclick="javascript:fn_glAccountSearchPop('st')" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		<span>~</span>
		<p class="search_type"><input type="text" id="edGlAccCode" name="edGlAccCode" class="fl_left" /><a href="#" onclick="javascript:fn_glAccountSearchPop('ed')" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="expense.Activity" /></th>
	<td>
		<div class="date_set w100p"><!-- date_set start -->
		<p class="search_type"><input type="text" id="stBudgetCode" name="stBudgetCode" class="fl_left" /><a href="#" onclick="javascript:fn_budgetCodePop('st')" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		<span>~</span>
		<p class="search_type"><input type="text" id="edBudgetCode" name="edBudgetCode" class="fl_left" /><a href="#" onclick="javascript:fn_budgetCodePop('ed')" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		</div><!-- date_set end -->
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#"  id="excelDown"><spring:message code="budget.ExcelDownload" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="budgetGridID" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->