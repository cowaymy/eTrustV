<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>
<script  type="text/javascript">
var exGridID;

var expenseCode;
var expenseCodeText;

$(document).ready(function() {
console.log("budgetCodeSearchPop");
    // 아이템 AUIGrid 칼럼 설정
    var expensecolumnLayout = [ {
        dataField : "expType",
        headerText : 'Expense Code',
        width : 100
    }, {
        dataField : "expTypeName",
        headerText : 'Expense Description',
        style : "aui-grid-user-custom-left",
        width : 250
    }];


    exGridID = GridCommon.createAUIGrid("#expenseGrid", expensecolumnLayout, "expenseCode", {editable:false});

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(exGridID, "cellDoubleClick", function(event){

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

         $("#pExpCode").val(AUIGrid.getCellValue(exGridID , event.rowIndex , "expType"));
         $("#pExpCodeName").val( AUIGrid.getCellValue(exGridID , event.rowIndex , "expTypeName"));

         if("${pop}" == "pop"){
             fn_setPopBudgetData();
         }else{
        	 fn_setExpData();
             console.log("Expense Code: " + $("#pExpCode").val());
         }


         $("#expenseCodeSearchPop").remove();
    });

 // add jgkim
    if("${call}" == "budgetAdj") {
        $("#search_btn").click(fn_selectAdjustmentCBG);
    } else {
        $("#search_btn").click(fn_selectExpenseListAjax);
    }

});

//리스트 조회.
function fn_selectExpenseListAjax() {
    Common.ajax("GET", "/eAccounting/expense/selectExpenseCodeList?_cacheId=" + Math.random(), $("#bgSForm").serialize(), function(result) {

         console.log("성공.");
         console.log( result);

        AUIGrid.setGridData(exGridID, result);
    });
}

// add jgkim
function fn_selectAdjustmentCBG() {
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentCBG.do?_cacheId=" + Math.random(), $("#bgSForm").serializeJSON(), function(result) {
        console.log(result);
        AUIGrid.setGridData(exGridID, result);
    });
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Expense Code List</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue"><a href="#" id="search_btn"><span class="search"></span><spring:message code="expense.btn.Search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" id="bgSForm" name="bgSForm" method="post">

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
    <th scope="row">Expense Code</th>
    <td><input type="text" id="expenseCode" name ="expenseCode" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Expense Description</th>
    <td><input type="text" id="expenseCodeText" name ="expenseCodeText"  title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="expenseGrid" style="width:100%; height:350px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->