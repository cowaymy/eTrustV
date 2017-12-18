<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var myGridID;
var myGridData = $.parseJSON('${appvInfoAndItems}');
var myColumnLayout = [ {
    dataField : "glAccCode",
    headerText : '<spring:message code="expense.GLAccount" />'
}, {
    dataField : "glAccCodeName",
    headerText : '<spring:message code="newWebInvoice.glAccountName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "budgetCode",
    headerText : '<spring:message code="approveView.budget" />'
}, {
    dataField : "budgetCodeName",
    headerText : '<spring:message code="approveView.budgetName" />',
    style : "aui-grid-user-custom-left"
},{
    dataField : "taxCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "taxName",
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "netAmt",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "taxAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.netAmt + item.taxAmt + item.taxNonClmAmt);
    }
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.description" />',
    style : "aui-grid-user-custom-left",
    width : 200
}
];

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 160
};

$(document).ready(function () {
    myGridID = AUIGrid.create("#approveView_grid_wrap", myColumnLayout, myGridPros);
    
    $("#fileListPop_btn").click(fn_fileListPop);
    
    $("#viewClmNo").text(myGridData[0].clmNo);
    $("#viewClmType").text(myGridData[0].clmType);
    $("#viewCostCentr").text(myGridData[0].costCentr + "/" + myGridData[0].costCentrName);
    $("#viewInvcDt").text(myGridData[0].invcDt);
    $("#viewReqstDt").text(myGridData[0].reqstDt);
    $("#viewReqstUserId").text(myGridData[0].reqstUserId);
    $("#viewMemAccId").text(myGridData[0].memAccId);
    $("#viewMemAccName").text(myGridData[0].memAccName);
    $("#viewPayDueDt").text(myGridData[0].payDueDt);
    $("#viewAppvAmt").text(AUIGrid.formatNumber(myGridData[0].totAmt, "#,##0.00"));
    
    fn_setGridData(myGridID, myGridData);
})
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="approveView.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_approveView">
<input type="hidden" id="viewMemAccId">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.clmNo" /></th>
	<td><span id="viewClmNo"></span></td>
	<th scope="row"><spring:message code="invoiceApprove.clmType" /></th>
	<td><span id="viewClmType"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td id="viewCostCentr"></td>
	<th scope="row"><spring:message code="webInvoice.invoiceDate" /></th>
	<td id="viewInvcDt"></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.requestDate" /></th>
	<td id="viewReqstDt"></td>
	<th scope="row"><spring:message code="approveView.requester" /></th>
	<td id="viewReqstUserId"></td>
</tr>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.member" /></th>
	<td id="viewMemAccName"></td>
	<th scope="row"><spring:message code="newWebInvoice.payDueDate" /></th>
	<td id="viewPayDueDt"></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
	<td colspan="3"><p class="btn_grid"><a href="#" id="fileListPop_btn"><spring:message code="approveView.viewAttachFile" /></a></p></td>
</tr>
<tr>
	<th scope="row"><spring:message code="approveView.approveStatus" /></th>
	<td colspan="3" style="height:60px" id="viewAppvStus">${appvPrcssStus}</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="viewAppvAmt"></span></h2>
</aside><!-- title_line end -->

<article class="grid_wrap" id="approveView_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->