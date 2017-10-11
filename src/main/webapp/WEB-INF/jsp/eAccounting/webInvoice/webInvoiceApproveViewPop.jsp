<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var myGridID;
var myColumnLayout = [ {
    dataField : "glAccCode",
    headerText : '<spring:message code="expense.GLAccount" />'
}, {
    dataField : "glAccCodeName",
    headerText : '<spring:message code="newWebInvoice.glAccountName" />'
}, {
    dataField : "costCentr",
    headerText : 'Cost Center'
}, {
    dataField : "costCentrName",
    headerText : 'C/C Name'
}, {
    dataField : "fund",
    headerText : 'Fund'
}, {
    dataField : "fundName",
    headerText : 'Fund Name'
},{
    dataField : "taxCode",
    headerText : '<spring:message code="newWebInvoice.taxCode" />'
}, {
    dataField : "netAmt",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    dataType: "numeric",
    formatString : "#,##0"
}, {
    dataField : "taxAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    dataType: "numeric",
    formatString : "#,##0"
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    dataType: "numeric",
    formatString : "#,##0",
    editable : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.netAmt + item.taxAmt);
    }
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.description" />',
    width : 200
}
];

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
};

$(document).ready(function () {
    myGridID = AUIGrid.create("#approveView_grid_wrap", myColumnLayout, myGridPros);
    
});
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View Approve</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_approveView">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Invoice date</th>
	<td><span>text</span></td>
	<th scope="row">Key In date</th>
	<td><span>text</span></td>
</tr>
<tr>
	<th scope="row">Cost Center</th>
	<td></td>
	<th scope="row">Create User ID</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Supplier</th>
	<td></td>
	<th scope="row">GST Registration No.</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Bank</th>
	<td></td>
	<th scope="row">Payment Due Date</th>
	<td></td>
</tr>
<tr>
	<th scope="row">Bank Account</th>
	<td></td>
	<th scope="row"></th>
	<td></td>
</tr>
<tr>
	<th scope="row">Attachment</th>
	<td colspan="3"></td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3"></td>
</tr>
<tr>
	<th scope="row">Approve Status</th>
	<td colspan="3" style="height:60px"></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text">Total Amount:<span id="totalAmount"></span></h2>
</aside><!-- title_line end -->

<article class="grid_wrap" id="approveView_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->