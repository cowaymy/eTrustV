<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-cell-style {
    background:#FF0000;
    color:#005500;
    font-weight:bold;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#my_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
var excelColumnLayoutNew = [ {
	dataField : "clmMonth",
    headerText : 'CLM_MONTH',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : 'CLM_NO'
}, {
    dataField : "crditCardUserId",
    headerText : 'CRDIT_CARD_USER_ID'
}, {
    dataField : "crditCardUserName",
    headerText : 'CRDIT_CARD_USER_NAME'
}, {
    dataField : "costCentr",
    headerText : 'COST_CENTR'
}, {
    dataField : "costCentrName",
    headerText : 'COST_CENTR_NAME'
}, {
    dataField : "bankName",
    headerText : 'BANK_NAME'
}, {
    dataField : "allTotAmt",
    headerText : 'CLM_TOTAL_AMT',
    dataType: "numeric",
    formatString : "#,##0.00",
    style : "aui-grid-user-custom-right"
}, {
    dataField : "clmSeq",
    headerText : 'CLM_SEQ',
}, {
    dataField : "invcDt",
    headerText : 'INVC_DT',
}, {
    dataField : "supplyName",
    headerText : 'SUPPLIER_NAME'
}, {
    dataField : "expType",
    headerText : 'EXP_TYPE'
}, {
    dataField : "expTypeName",
    headerText : 'EXP_TYPE_NAME'
}, {
    dataField : "glAccCode",
    headerText : 'GL_ACC_CODE'
}, {
    dataField : "glAccCodeName",
    headerText : 'GL_ACC_CODE_NAME'
}, {
    dataField : "budgetCode",
    headerText : 'BUDGET_CODE'
}, {
    dataField : "budgetCodeName",
    headerText : 'BUDGET_CODE_NAME'
}, {
    dataField : "totAmt",
    headerText : 'TOT_AMT',
    dataType: "numeric",
    formatString : "#,##0.00",
    style : "aui-grid-user-custom-right"
}, {
    dataField : "expDesc",
    headerText : 'EXP_DESC'
}, {
    dataField : "appvPrcssStus",
    headerText : 'Status'
}, {
    dataField : "cntrlExp",
    headerText : 'Controlled Expense Type'
}];

var excelGridProsNew = {
	    // 페이징 사용
	    usePaging : true,
	    // 한 화면에 출력되는 행 개수 20(기본값:20)
	    pageRowCount : 20,
	    // 셀 선택모드 (기본값: singleCell)
	    selectionMode : "multipleCells"
	};
var excelGridIDNew;

$(document).ready(function () {
	console.log("creditCardReimbursementExcelDownPop");
	multiCombo();
	excelGridIDNew = AUIGrid.create("#excel_grid_wrap_new", excelColumnLayoutNew, excelGridProsNew);
});

function multiCombo() {
    $(function() {
        $('#crcHolderName').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");

        $('#crcHolderCardNo').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");

        $('#pic').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");

        $('#costCenterList').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");

        $('#statusList').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");
    });


}

function fn_excelDownload(){
	var crcHolderName = $('#crcHolderName option').length;
	var crcHolderCardNo = $('#crcHolderCardNo option').length;
	var pic = $('#pic option').length;
	var costCenterList = $('#costCenterList option').length;
	var statusList = $('#statusList option').length;

	var crcHolderNameSelected = $('#crcHolderName option:selected').length;
	var crcHolderCardNoSelected = $('#crcHolderCardNo option:selected').length;
	var picSelected = $('#pic option:selected').length;
	var costCenterListSelected = $('#costCenterList option:selected').length;
	var statusListSelected = $('#statusList option:selected').length;

	if(crcHolderName == crcHolderNameSelected){
	    $('#crcHolderName').multipleSelect("uncheckAll");
	}
	if(crcHolderCardNo == crcHolderCardNoSelected){
	    $('#crcHolderCardNo').multipleSelect("uncheckAll");
	}
	if(pic == picSelected){
	    $('#pic').multipleSelect("uncheckAll");
	}
	if(costCenterList == costCenterListSelected){
	    $('#costCenterList').multipleSelect("uncheckAll");
	}
	if(statusList == statusListSelected){
	    $('#statusList').multipleSelect("uncheckAll");
	}

 	 Common.ajax("GET", "/eAccounting/creditCard/selectExcelListNew.do", $("#form_newReimbursementExcel").serialize(), function(result2) {
 	     AUIGrid.setGridData(excelGridIDNew, result2);
 	     GridCommon.exportTo("excel_grid_wrap_new", "xlsx", "Credit Card Expense");
      });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Credit Card Expense Listing</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newReimbursementExcel">

<table class="type1 mt10"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th>Credit Card Holder Name</th>
	<td>
		<select class="w100p multy_select" multiple="multiple" id="crcHolderName" name="crcHolderName">
			<c:forEach var="list" items="${crcHolder}" varStatus="status">
				<option value="${list.crditCardUserId}">${list.crditCardUserName}</option>
			</c:forEach>
		</select>
	</td>
	<th>Credit Card Number</th>
	<td>
		<select class="w100p multy_select" multiple="multiple" id="crcHolderCardNo" name="crcHolderCardNo">
			<c:forEach var="list" items="${crcHolder}" varStatus="status">
				<option value="${list.crditCardNo}">${list.crditCardNo}</option>
			</c:forEach>
		</select>
	</td>
</tr>
<tr>
	<th scope="row">Claim Month/Year</th>
    <td>
        <p><input type="text" id="startClaimDate" name="startClaimDate" title="" placeholder="" class="j_date2 w100p" /></p>
        <span>~</span>
        <p><input type="text" id="endClaimDate" name="endClaimDate" title="" placeholder="" class="j_date2 w100p" /></p>
    </td>
	<th>PIC Name</th>
	<td>
		<select class="w100p multy_select" multiple="multiple" id="pic" name="pic">
			<c:forEach var="list" items="${pic}" varStatus="status">
				<option value="${list.chrgUserId}">${list.crcPic}</option>
			</c:forEach>
		</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.status" /></th>
	<td>
	<select class="w100p multy_select" multiple="multiple" id="statusList" name="statusList">
		<option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
	</select>
	</td>
	<th>Cost Center</th>
	<td>
		<select class="w100p multy_select" multiple="multiple" id="costCenterList" name="costCenterList">
			<c:forEach var="list" items="${costCenter}" varStatus="status">
				<option value="${list.costCenter}">${list.costCenterText}</option>
			</c:forEach>
		</select>
	</td>
</tr>
<tr>
	<th scope="row">Invoice Date</th>
	<td>
		<div class="date_set"><!-- date_set start -->
		<p><input type="text" title="Invoice start Date" placeholder="DD/MM/YYYY" class="j_date"  id="invoiceStartDate" name="invoiceStartDate"/></p>
		<span>~</span>
		<p><input type="text" title="Invoice end Date" placeholder="DD/MM/YYYY" class="j_date" id="invoiceEndDate" name="invoiceEndDate"/></p>
		</div><!-- date_set end -->
	</td>
	<th></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" onclick="fn_excelDownload()">Excel Download</a></p></li>
</ul>
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap" id="excel_grid_wrap_new" style="display:none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->