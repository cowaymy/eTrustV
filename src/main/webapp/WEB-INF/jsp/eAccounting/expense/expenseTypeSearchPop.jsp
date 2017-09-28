<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script  type="text/javascript">
var expensSearchGridID;

$(document).ready(function() {

    // 아이템 AUIGrid 칼럼 설정
    var budgetcolumnLayout = [ {
        dataField : "expType",
        headerText : '<spring:message code="expense.ExpenseType" />',
        width : 100
    }, {
        dataField : "expTypeName",
        headerText : '<spring:message code="expense.ExpenseTypeName" />',
        style : "aui-grid-user-custom-left",
        width : 200
    }, {
        dataField : "budgetCode",
        headerText : '',
        visible : false
    }, {
        dataField : "budgetCodeName",
        headerText : '<spring:message code="expense.Activity" />',
        style : "aui-grid-user-custom-left",
        width : 100
    }, {
        dataField : "glAccCode",
        headerText : '',
        visible : false
    }, {
    	dataField : "glAccCodeName",
        headerText : '<spring:message code="expense.GLAccount" />',
        width : 100
    }];

    
    expensSearchGridID = GridCommon.createAUIGrid("#expensSearchGrid", budgetcolumnLayout, "expType", {editable:false});
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(expensSearchGridID, "cellDoubleClick", function(event){
                                   
         var selectedItems = AUIGrid.getSelectedItems(myGridID);
         
         alert(selectedItems);
         
         if(selectedItems.length <= 0) return;
         // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음
         var first = selectedItems[0];
         
         AUIGrid.setCellValue(myGridID , first.rowIndex , "budgetCode", AUIGrid.getCellValue(expensSearchGridID , event.rowIndex , "budgetCode"));
         AUIGrid.setCellValue(myGridID , first.rowIndex , "budgetCodeName", AUIGrid.getCellValue(expensSearchGridID , event.rowIndex , "budgetCodeName"));
         
         AUIGrid.setCellValue(myGridID , first.rowIndex , "expType", AUIGrid.getCellValue(expensSearchGridID , event.rowIndex , "expType"));
         AUIGrid.setCellValue(myGridID , first.rowIndex , "expTypeName", AUIGrid.getCellValue(expensSearchGridID , event.rowIndex , "expTypeName"));
         
         AUIGrid.setCellValue(myGridID , first.rowIndex , "glAccCode", AUIGrid.getCellValue(expensSearchGridID , event.rowIndex , "glAccCode"));
         AUIGrid.setCellValue(myGridID , first.rowIndex , "glAccCodeName", AUIGrid.getCellValue(expensSearchGridID , event.rowIndex , "glAccCodeName"));
         
         $("#expenseTypeSearchPop").remove();
    });
    
   // alert("${popClaimType}");
    
    CommonCombo.make("popClaimType", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "${popClaimType}", {
        id: "code",
        name: "codeName"
    }
    , fn_selectExpensePopListAjax
    );
});

//리스트 조회.
function fn_selectExpensePopListAjax() {        
	$("#popClaimType").attr("disabled", false);
	
    Common.ajax("GET", "/eAccounting/expense/selectExpenseList", $("#expPopSForm").serialize(), function(result) {
        
         console.log("성공.");
         console.log( result);

         $("#popClaimType").attr("disabled", true);
        AUIGrid.setGridData(expensSearchGridID, result);
    });
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="espense.ExpenseTypeSearch" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<%-- <ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_selectExpensePopListAjax();"><spring:message code="expense.btn.Search" /></a></p></li>
</ul> --%>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="expPopSForm" name="expPopSForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="expense.ClaimType" /></th>
	<td>
	<select class="w100p" id="popClaimType" name="popClaimType" disabled="disabled" >
    </select>
    <%-- <input type="hidden" id="popClaimType" name="popClaimType" value= "${popClaimType}"/> --%>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="expensSearchGrid" style="width:100%; height:350px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<!-- <ul class="center_btns mb10">
	<li><p class="btn_blue2"><a href="#">Select</a></p></li>
	<li><p class="btn_blue2"><a href="#">Exit</a></p></li>
</ul> -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>