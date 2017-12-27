<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script  type="text/javascript">
var bgGridID;

var budgetCode;
var budgetCodeText;

$(document).ready(function() {

	// 아이템 AUIGrid 칼럼 설정
	var budgetcolumnLayout = [ {
	    dataField : "budgetCode",
	    headerText : '<spring:message code="expense.Activity" />'
	}, {
	    dataField : "budgetCodeText",
	    headerText : '<spring:message code="expense.ActivityName" />',
	    style : "aui-grid-user-custom-left"
	}];

	
    bgGridID = GridCommon.createAUIGrid("#budgetGrid", budgetcolumnLayout, "budgetCode", {editable:false});
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(bgGridID, "cellDoubleClick", function(event){
    	    	 
    	 /* var selectedItems = AUIGrid.getSelectedItems(expPopGridID);
         
    	 budgetCode = AUIGrid.getCellValue(bgGridID , event.rowIndex , "budgetCode");
    	 budgetCodeText = AUIGrid.getCellValue(bgGridID , event.rowIndex , "budgetCodeText");
         
         $("#budgetCode").val(budgetCode);
         $("#budgetCodeName").val(budgetCodeText);
    	 
    	 if(selectedItems.length <= 0) return;
    	 // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음
    	 var first = selectedItems[0];
    	 
    	 AUIGrid.setCellValue(expPopGridID , first.rowIndex , "budgetCode", budgetCode);
    	 AUIGrid.setCellValue(expPopGridID , first.rowIndex , "budgetCodeName", budgetCodeText); */
    	 
    	 /* $("#pBudgetCode").val(AUIGrid.getCellValue(bgGridID , event.rowIndex , "budgetCode"));
         $("#pBudgetCodeName").val( AUIGrid.getCellValue(bgGridID , event.rowIndex , "budgetCodeText"));
         
         if("${pop}" == "pop"){
        	 fn_setPopBudgetData();
         }else{
        	 fn_setBudgetData();
         } */
         
         AUIGrid.setCellValue(newGridID , "${rowIndex}" , "budgetCode", AUIGrid.getCellValue(bgGridID , event.rowIndex , "budgetCode"));
         AUIGrid.setCellValue(newGridID , "${rowIndex}" , "budgetCodeName",  AUIGrid.getCellValue(bgGridID , event.rowIndex , "budgetCodeText"));
    	 
    	 $("#budgetCodeSearchPop").remove();
    });
    
});

//리스트 조회.
function fn_selectBudgetListAjax() {        
    Common.ajax("GET", "/eAccounting/webInvoice/selectBudgetCodeList", $("#bgSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);
         
        AUIGrid.setGridData(bgGridID, result);
    });
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="expense.ActivityCodeSearch" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_selectBudgetListAjax();"><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="bgSForm" >
<input type="hidden" name="costCentrName" value="${costCentrName}">
<input type="hidden" name="costCentr" value="${costCentr}">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" placeholder="" class="readonly w100p" readonly="readonly" value="${costCentr}"/></td>
	<th scope="row"><spring:message code="expense.ActivityName" /></th>
    <td><input type="text" id="budgetCodeText" name ="budgetCodeText"  title="<spring:message code='expense.ActivityName' />" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="budgetGrid"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->