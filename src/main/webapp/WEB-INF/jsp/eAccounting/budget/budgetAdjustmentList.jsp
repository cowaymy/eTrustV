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
var adjMGridID;

$(document).ready(function(){
	
    CommonCombo.make("budgetAdjType", "/common/selectCodeList.do", {groupCode:'347', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });

    $("#stYearMonth").val("${stYearMonth}");
    $("#edYearMonth").val("${edYearMonth}");
    
    $("#btnSearch").click(fn_selectListAjax);
    
    $("#adjustment").click(fn_budgetAdjustmentPop);
    
    var adjLayout = [ {
        dataField : "checkId",
        headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 50,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            // 체크박스 disabled 함수
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.status == "Close")
                    return true; // true 반환하면 disabled 시킴
                return false;
            }
      }
    },{
        dataField : "status",
        headerText : '<spring:message code="budget.Status" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 70
    },{
        dataField : "budgetDocNo",
        headerText : '<spring:message code="budget.BudgetDoc" />',
        cellMerge : true ,
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
        width : 100
    },{
        dataField : "glAccCode",
        headerText : '<spring:message code="expense.GLAccount" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 100
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
        width : 150
    },{
        dataField : "fileSubPath",
        headerText : '<spring:message code="budget.View" />',
        cellMerge : true ,
        mergeRef : "budgetDocNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 150
    }];
         
    var adjOptions = {
            enableCellMerge : true,
            showStateColumn:false,
            showRowNumColumn    : false,
            usePaging : false,
            editable :false
      }; 
    
    adjMGridID = GridCommon.createAUIGrid("#adjMGridID", adjLayout, "", adjOptions);
       
});

//리스트 조회.
function fn_selectListAjax() {        
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentList", $("#listSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(adjMGridID, result);
    });
}


//Budget Code Pop 호출
function fn_budgetCodePop(){
    Common.popupDiv("/eAccounting/expense/budgetCodeSearchPop.do",null, null, true, "budgetCodeSearchPop");
}  

function  fn_setBudgetData(){
	$("#budgetCode").val($("#pBudgetCode").val());
	$("#budgetCodeName").val( $("#pBudgetCodeName").val());    
}

//Gl Account Pop 호출
function fn_glAccountSearchPop(str){
    Common.popupDiv("/eAccounting/expense/glAccountSearchPop.do", null, null, true, "glAccountSearchPop");
}

function fn_setGlData (){    
	$("#glAccCode").val($("#pGlAccCode").val());
	$("#glAccCodeName").val( $("#pGlAccCodeName").val());        
}

//Cost Center
function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter (){
	$("#costCentr").val($("#search_costCentr").val());
	$("#costCentrName").val( $("#search_costCentrName").val());
}

//adjustment Pop
function fn_budgetAdjustmentPop() {
	var stYearMonth = $("#stYearMonth").val();
	var edYearMonth = $("#edYearMonth").val();
    Common.popupDiv("/eAccounting/budget/budgetAdjustmentPop.do", $("#listSForm").serializeJSON(), null, true, "budgetAdjustmentPop");
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="budget.BudgetAdjustmentList" /></h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" id="btnSearch" ><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
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
	<th scope="row"><spring:message code="budget.Month" />/<spring:message code="budget.Year" /></th>
	<td>
	<div class="date_set"><!-- date_set start -->
	<p><input type="text" id="stYearMonth" name="stYearMonth" title="Create start Date" placeholder="MM/YYYY" class="j_date2"/></p>
	<span><spring:message code="budget.To" /></span>
	<p><input type="text" id="edYearMonth" name="edYearMonth" title="Create end Date" placeholder="MM/YYYY" class="j_date2" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="budget.CostCenter" /></th>
	<td>
	<input type="hidden" id="costCentr" name="costCentr" title="" placeholder="" class="" />
	<input type="text" id="costCentrName" name="costCentrName" title="" placeholder="" class="" />
	<a href="#" class="search_btn" onclick="javascript:fn_costCenterSearchPop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="expense.GLAccount" /></th>
	<td>
	      <input type="hidden" id="glAccCode" name="glAccCode" title="" placeholder="" class="" />
	      <input type="text" id="glAccCodeName" name="glAccCodeName" title="" placeholder="" class="" />
	      <a href="#" class="search_btn" onclick="javascript:fn_glAccountSearchPop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
	<th scope="row"><spring:message code="budget.BudgetCode" /></th>
	<td>
		<input type="hidden" id="budgetCode" name="budgetCode" title="" placeholder="" class="" />
		<input type="text" id="budgetCodeName" name="budgetCodeName" title="" placeholder="" class="" />
		<a href="#" class="search_btn" onclick="javascript:fn_budgetCodePop();"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.AdjustmentType" /></th>
	<td><select class="multy_select w100p" id="budgetAdjType" name="budgetAdjType" multiple="multiple"></select></td>
	<th scope="row"><spring:message code="budget.BudgetDocumentNo" /></th>
	<td><input type="text" title="" placeholder="" class="" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="budget.Status" /></th>
	<td>
	<select id="appvStus" name="appvStus" class="">
		<option value=""><spring:message code="budget.All" /></option>
		<option value="O"><spring:message code="budget.Open" /></option>
		<option value="C"><spring:message code="budget.Close" /></option>
	</select>
	</td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt><spring:message code="budget.Link" /></dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="#"><spring:message code="budget.BudgetPlan" /></a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="adjustment"><spring:message code="budget.Adjustment" /></a></p></li>
	<li><p class="btn_grid"><a href="#"><spring:message code="budget.Approval" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="adjMGridID" style="width:100%; height:370px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->