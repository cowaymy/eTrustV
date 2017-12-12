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

var adjGridID;

$(document).ready(function(){
    
     var adjPopColumnLayout = [ {
         dataField : "confirmDate",
         headerText : '<spring:message code="budget.ConfirmDate" />',
         width : 150
     },{
         dataField : "budgetDocNo",
         headerText : '<spring:message code="budget.BudgetDocNo" />',
         width : 150
     },{
         dataField : "budgetAdjType",
         headerText : '<spring:message code="budget.BudgetChangeType" />',
         visible : false
     },{
         dataField : "signal",
         headerText : '',
         visible : false
     },{
         dataField : "budgetAdjTypeName",
         headerText : '<spring:message code="budget.BudgetChangeType" />',
         width : 150
     },{
         dataField : "signalText",
         headerText : '<spring:message code="budget.Signal" />',
         style : "aui-grid-user-custom-left",
         width : 100
     }, {
         dataField : "budgetAdjMonth",
         headerText : '<spring:message code="budget.Year" />/<spring:message code="budget.Month" />',
         width : 100
     },{
         dataField : "costCentr",
         headerText : '',
         visible : false
     },{
         dataField : "costCenterText",
         headerText : '<spring:message code="budget.costCenterName" />',
         style : "aui-grid-user-custom-left",
         width : 150
     },{
         dataField : "glAccCode",
         headerText : '',
         visible : false
     },{
         dataField : "glAccDesc",
         headerText : '<spring:message code="expense.GLAccount" />',
         style : "aui-grid-user-custom-left",
         width : 150
     },{
         dataField : "adjAmt",
         headerText : '<spring:message code="budget.AdjustmentAmount" />',
         width : 150,
         dataType : "numeric",
         formatString : "#,##0.00",
         style : "my-right-style",
     },{
         dataField : "adjRem",
         headerText : '<spring:message code="budget.Remark" />',
         style : "aui-grid-user-custom-left",
         width : 150
     }];
     
     
    // 푸터 설정
     var footerObject = [ {
         labelText : "<spring:message code="budget.Total" />",
         positionField : "confirmDate"
     },  {
         labelText : "<spring:message code="budget.Increase" />",
         positionField : "signalText"
     },{
         positionField : "budgetAdjMonth",
         dataField : "adjAmt",
         formatString : "#,##0.00",
         style : "my-right-style",
         expFunction : function(columnValues) {
             
             var idx = AUIGrid.getRowCount(adjGridID); 
             var amt = 0;
             for(var i = 0; i < idx; i++){
                 if(AUIGrid.getCellValue(adjGridID, i, "budgetAdjType") == '01'){
                	 if(AUIGrid.getCellValue(adjGridID, i, "signal") =="+"){
	                     amt += AUIGrid.getCellValue(adjGridID, i, "adjAmt");                		 
                	 }else{
                         amt -= AUIGrid.getCellValue(adjGridID, i, "adjAmt");      
                	 }
                 }
             }
                         
             return amt; 
         }
     },{
         labelText:"<spring:message code="budget.decrement" />",
         positionField : "costCenterText"
     },{
         positionField : "glAccDesc",
         dataField : "adjAmt",
         formatString : "#,##0.00",
         style : "my-right-style",
         expFunction : function(columnValues) {
             
             var idx = AUIGrid.getRowCount(adjGridID); 
             var amt = 0;
             for(var i = 0; i < idx; i++){
                 if(AUIGrid.getCellValue(adjGridID, i, "budgetAdjType") == '02'){
                	 if(AUIGrid.getCellValue(adjGridID, i, "signal") =="+"){
                         amt += AUIGrid.getCellValue(adjGridID, i, "adjAmt");                        
                     }else{
                         amt -= AUIGrid.getCellValue(adjGridID, i, "adjAmt");      
                     }
                 }
             }
             
             return amt; 
         }
     },{
         labelText:"<spring:message code="budget.Transfer" />",
         positionField : "adjAmt"
     },{
         positionField : "adjRem",
         dataField : "adjAmt",
         formatString : "#,##0.00",
         style : "my-right-style",
         expFunction : function(columnValues) {
             
             var idx = AUIGrid.getRowCount(adjGridID); 
             var amt = 0;
             for(var i = 0; i < idx; i++){
                 if(AUIGrid.getCellValue(adjGridID, i, "budgetAdjType") != '01' && AUIGrid.getCellValue(adjGridID, i, "budgetAdjType") != '02'){
                     amt += AUIGrid.getCellValue(adjGridID, i, "adjAmt");
                 }
             }             
             return amt; 
         }
     }];
     
     var adjOptions = {
                showStateColumn:false,
                showRowNumColumn    : true,
                usePaging : true,
                showFooter : true,
                editable : false
          }; 
     
        adjGridID = GridCommon.createAUIGrid("#adjGridID", adjPopColumnLayout, "", adjOptions);
        
        fn_selectListAjax();
        

        // 푸터 객체 세팅
        AUIGrid.setFooter(adjGridID, footerObject);
});

//리스트 조회.
function fn_selectListAjax() {  
     
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentAmountList", $("#adjPForm").serialize(), function(result) {
            
        console.log("성공.");
        console.log( result);
           
        AUIGrid.setGridData(adjGridID, result);
    }); 
}

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="budget.Adjustment" /> <spring:message code="budget.Amount" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<form action="#" method="post" id="adjPForm" name="adjPForm">
    <input type="hidden" id="budgetPlanYear" name="budgetPlanYear"  value="${item.budgetPlanYear }"/>
    <input type="hidden" id="budgetPlanMonth" name="budgetPlanMonth"  value="${item.budgetPlanMonth }"/>
    <input type="hidden" id="costCentr" name ="costCentr" value="${item.costCentr }"/>
    <input type="hidden" id="glAccCode" name ="glAccCode"  value="${item.glAccCode }" />
    <input type="hidden"  id="budgetCode" name ="budgetCode" value="${item.budgetCode }"/>
</form>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="adjGridID" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->