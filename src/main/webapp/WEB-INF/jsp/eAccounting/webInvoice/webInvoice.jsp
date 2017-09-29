<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var webInvoiceColumnLayout = [ {
    dataField : "invoiceNo",
    headerText : '<spring:message code="webInvoice.invoiceNo" />',
    width : 140
}, {
    dataField : "postingDate",
    headerText : '<spring:message code="webInvoice.postingDate" />',
    //width : 120

}, {
    dataField : "cc",
    headerText : '<spring:message code="webInvoice.cc" />',
    //width: 120
}, {
    dataField : "ccDate",
    headerText : '<spring:message code="webInvoice.ccDate" />'
}, {
    dataField : "type",
    headerText : '<spring:message code="webInvoice.type" />',
    //dataType : "numeric"
}, {
    dataField : "suppliers",
    headerText : '<spring:message code="webInvoice.suppliers" />'
}, {
    dataField : "name",
    headerText : '<spring:message code="webInvoice.name" />'
}, {
    dataField : "amount",
    headerText : '<spring:message code="webInvoice.amount" />'
}, {
    dataField : "requestDate",
    headerText : '<spring:message code="webInvoice.requestDate" />'
}, {
    dataField : "status",
    headerText : '<spring:message code="webInvoice.status" />'
}, {
    dataField : "approvedDate",
    headerText : '<spring:message code="webInvoice.approvedDate" />'
}
];

//그리드 속성 설정
var webInvoiceGridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20
};

var webInvoiceGridID;

$(document).ready(function () {
	webInvoiceGridID = AUIGrid.create("#webInvoice _grid_wrap", webInvoiceColumnLayout, webInvoiceGridPros);
	
	$("#search_supplier_btn").click(fn_supplierSearchPop);
	$("#search_costCenter_btn").click(fn_costCenterSearchPop);
	$("#registration_btn").click(fn_newWebInvoicePop);
});

function fn_supplierSearchPop() {
	var value = $("#supplier").val();
	var object = {value:value};
	Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
	var value = $("#costCenter").val();
	var object = {value:value};
	Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_newWebInvoicePop() {
	Common.popupDiv("/eAccounting/webInvoice/newWebInvoicePop.do", null, null, true, "newWebInvoicePop");
}
</script>

<div id="wrap">

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code="webInvoice.path" /></li>
    <li><spring:message code="webInvoice.title" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="webInvoice.title" /></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_webInvoice">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="webInvoice.supplier" /></th>
    <td><input type="text" title="" placeholder="" class="" style="width:200px" id="supplier" name="supplier"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row"><spring:message code="webInvoice.costCenter" /></th>
    <td><input type="text" title="" placeholder="" class="" style="width:200px" id="costCenter" name="costCenter"/><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row"><spring:message code="webInvoice.invoiceDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
    <span><spring:message code="webInvoice.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="webInvoice.status" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="status">
        <option value="T"><spring:message code="webInvoice.select.save" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="webInvoice.select.reject" /></option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="webInvoice.btn.registration" /></a></p></li>
</ul>

<article class="grid_wrap" id="webInvoice _grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

</div>