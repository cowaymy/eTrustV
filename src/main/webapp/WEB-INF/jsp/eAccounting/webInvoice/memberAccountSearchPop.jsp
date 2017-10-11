<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var supplierColumnLayout = [ {
	dataField : "accGrp",
    visible : false
},{
	dataField : "accGrpName",
    headerText : '<spring:message code="memAcc.group" />'
},{
    dataField : "memAccId",
    headerText : '<spring:message code="memAcc.memAccCode" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="memAcc.memAccName" />'
}, {
    dataField : "gstRgistNo",
    headerText : '<spring:message code="newWebInvoice.gstRegistNo" />'
},{
    dataField : "bankCode",
    visible : false
},{
    dataField : "bankName",
    headerText : '<spring:message code="newWebInvoice.bank" />'
}, {
    dataField : "bankAccNo",
    headerText : '<spring:message code="newWebInvoice.bankAccount" />'
}
];

//그리드 속성 설정
var supplierGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20

};

var supplierGridID;

$(document).ready(function () {
	supplierGridID = AUIGrid.create("#supplier_grid_wrap", supplierColumnLayout, supplierGridPros);
	
	AUIGrid.bind(supplierGridID, "cellDoubleClick", function( event ) {
		$("#search_memAccId").val(event.item.memAccId);
        $("#search_memAccName").val(event.item.memAccName);
        $("#search_gstRgistNo").val(event.item.gstRgistNo)
        $("#search_bankCode").val(event.item.bankCode)
        $("#search_bankName").val(event.item.bankName)
        $("#search_bankAccNo").val(event.item.bankAccNo)
        
        fn_setSupplier();
        
        $("#supplierSearchPop").remove();
  });
});

function fn_selectMember() {
	Common.ajax("GET", "/eAccounting/webInvoice/selectSupplier.do", $("#form_supplier").serialize(), function(result) {
        AUIGrid.setGridData(supplierGridID, result);
	});
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="memAcc.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" onclick="fn_selectMember()"><spring:message code="webInvoice.btn.search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_supplier">
<input type="hidden" id="search_memAccId">
<input type="hidden" id="search_memAccName">
<input type="hidden" id="search_gstRgistNo">
<input type="hidden" id="search_bankCode">
<input type="hidden" id="search_bankName">
<input type="hidden" id="search_bankAccNo">
<input type="hidden" id="accGrp" name="accGrp" value="${params.accGrp}">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="memAcc.memAccCode" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" name="memAccId"/></td>
	<th scope="row"><spring:message code="memAcc.group" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="accGrpName" value="${params.accGrpName}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="memAcc.memAccName" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" name="memAccName"/></td>
	<th scope="row"><spring:message code="newWebInvoice.gstRegistNo" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" name="gstRgistNo"/></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="supplier_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->