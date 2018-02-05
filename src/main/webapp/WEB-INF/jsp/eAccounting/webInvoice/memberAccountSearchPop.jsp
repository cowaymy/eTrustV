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
var supplierColumnLayout = [ {
	dataField : "accGrp",
	headerText : '<spring:message code="memAcc.group" />'
},{
    dataField : "memAccId",
    headerText : '<spring:message code="memAcc.memAccCode" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="memAcc.memAccName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "gstRgistNo",
    headerText : '<spring:message code="newWebInvoice.gstRegistNo" />'
},{
    dataField : "bankCode",
    visible : false
},{
    dataField : "bankName",
    headerText : '<spring:message code="newWebInvoice.bank" />',
    style : "aui-grid-user-custom-left"
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
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"

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
        
        if("${pop}" == "pop") {
        	fn_setPopSupplier();
        } else if("${pop}" == "sPop") {
        	fn_setPopSubSupplier();
        } else {
        	fn_setSupplier();
        }
        
        $("#supplierSearchPop").remove();
  });
	
	//$("#accGrp").multipleSelect("checkAll");
});

function fn_selectMember() {
	Common.ajax("GET", "/eAccounting/webInvoice/selectSupplier.do", $("#form_supplier").serializeJSON(), function(result) {
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
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectMember()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_supplier">
<input type="hidden" id="search_memAccId">
<input type="hidden" id="search_memAccName">
<input type="hidden" id="search_gstRgistNo">
<input type="hidden" id="search_bankCode">
<input type="hidden" id="search_bankName">
<input type="hidden" id="search_bankAccNo">

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
	<td>
	<select class="w100p" id="accGrp" name="accGrp">
        <option value="VM11" <c:if test="${accGrp eq 'VM11'}">selected</c:if>><spring:message code="memAcc.local" /></option>
        <option value="VM07" <c:if test="${accGrp eq 'VM07'}">selected</c:if>><spring:message code="memAcc.cody" /></option>
        <option value="VM08" <c:if test="${accGrp eq 'VM08'}">selected</c:if>><spring:message code="memAcc.ct" /></option>
        <option value="VM09" <c:if test="${accGrp eq 'VM09'}">selected</c:if>><spring:message code="memAcc.smGm" /></option>
        <option value="VM10" <c:if test="${accGrp eq 'VM10'}">selected</c:if>><spring:message code="memAcc.staff" /></option>
    </select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="memAcc.memAccName" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" name="memAccName"/></td>
	<th scope="row">GST Registration No.</th>
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