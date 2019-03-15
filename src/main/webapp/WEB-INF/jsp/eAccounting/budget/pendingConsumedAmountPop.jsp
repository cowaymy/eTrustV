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

var penGridID;

$(document).ready(function(){

	CommonCombo.make("clmType", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });

     var penPopColumnLayout = [ {
         dataField : "appvReqKeyNo",
         headerText : '<spring:message code="budget.WebDocument" />',
         width : 150
     },{
         dataField : "costCentrName",
         headerText : '<spring:message code="budget.costCenterName" />',
         width : 150
     },{
         dataField : "userName",
         headerText : '<spring:message code="budget.Drafter" />',
         width : 150
     },{
         dataField : "crtDt",
         headerText : '<spring:message code="budget.DraftingDate" />',
         width : 100
     },{
         dataField : "invcDt",
         headerText : '<spring:message code="budget.PostingDate" />',
         width : 100
     },{
         dataField : "payDueDt",
         headerText : '<spring:message code="budget.PaymentDueDate" />',
         width : 100
     },{
         dataField : "memAccId",
         headerText : '<spring:message code="budget.SupplierID" />',
         width : 100
     },{
         dataField : "memAccName",
         headerText : '<spring:message code="budget.SupplierName" />',
         style : "aui-grid-user-custom-left",
         width : 150
     },{
         dataField : "netAmt",
         headerText : '<spring:message code="budget.Amount" />',
         style : "my-right-style",
         width : 150
     },{
        dataField : "netAmt1",
        dataType : "numeric",
        width : 150,
        visible : false
     },{
         dataField : "expDesc",
         headerText : '<spring:message code="budget.Remark" />',
         style : "aui-grid-user-custom-left",
         width : 150
     }];

     var footerObject = [ {
         labelText : "<spring:message code="budget.Total" />",
         positionField : "memAccName"
     },{
         positionField : "netAmt",
         dataField : "netAmt",
         dataType : "numeric",
         formatString : "#,##0.00",
         style : "my-right-style",
         expFunction : function(columnValues) {

             var idx = AUIGrid.getRowCount(penGridID);
             var amt = 0;
             for(var i = 0; i < idx; i++){
            	 console.log(AUIGrid.getCellValue(penGridID, i, "netAmt1"));
                 amt += AUIGrid.getCellValue(penGridID, i, "netAmt1");
             }
             console.log("amt :: " + amt);
             return amt;
         }
     }];

     var penOptions = {
                showStateColumn:false,
                showRowNumColumn    : true,
                usePaging : true,
                editable : false,
                showFooter : true
          };

        penGridID = GridCommon.createAUIGrid("#penGridID", penPopColumnLayout, "", penOptions);

        fn_selectListPenAjax();

        AUIGrid.setFooter(penGridID, footerObject);

        $('#clmType').change(function() {
            console.log("clmType blur");

            fn_selectListPenAjax();

            AUIGrid.setFooter(penGridID, footerObject);
        });
});

//리스트 조회.
function fn_selectListPenAjax() {

    Common.ajax("GET", "/eAccounting/budget/selectPenConAmountList", $("#penPForm").serialize(), function(result) {

        console.log("성공.");
        console.log( result);

        AUIGrid.setGridData(penGridID, result);
    });
}

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<c:if test="${item.type == 'Pending' }" >
<h1><spring:message code="budget.Pending" /> <spring:message code="budget.Amount" /></h1>
</c:if>
<c:if test="${item.type == 'Consumed' }" >
<h1><spring:message code="budget.Utilised" /> <spring:message code="budget.Amount" /></h1>
</c:if>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<form action="#" method="post" id="penPForm" name="penPForm">
    <input type="hidden" id="budgetPlanYear" name="budgetPlanYear"  value="${item.budgetPlanYear }"/>
    <input type="hidden" id="budgetPlanMonth" name="budgetPlanMonth"  value="${item.budgetPlanMonth }"/>
    <input type="hidden" id="stDate" name="stDate"  value="${item.stDate }"/>
    <input type="hidden" id="edDate" name="edDate"  value="${item.edDate }"/>
    <input type="hidden" id="costCentr" name ="costCentr" value="${item.costCentr }"/>
    <input type="hidden" id="glAccCode" name ="glAccCode"  value="${item.glAccCode }" />
    <input type="hidden"  id="budgetCode" name ="budgetCode" value="${item.budgetCode }"/>
    <input type="hidden"  id="type" name ="type" value="${item.type }"/>

    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
        <tr>
            <th scope="row"><spring:message code="invoiceApprove.clmType" /></th>
            <td>
            <select class="w100p" id="clmType" name="clmType" multiple="multiple">
            </select>
        </tr>
    </tbody>
    </table><!-- table end -->
</form>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="penGridID" style="width:100%; height:450px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
