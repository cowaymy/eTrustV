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
var excelColumnLayoutNew = [{
    dataField : "costCentr",
    headerText : 'Cost Centre',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "costCentrName",
    headerText : 'Cost Centre Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccId",
    headerText : '<spring:message code="staffClaim.staffCode" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="staffClaim.staffName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "clmMonth",
    headerText : '<spring:message code="pettyCashExp.clmMonth" />',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : '<spring:message code="invoiceApprove.clmNo" />'
}, {
    dataField : "reqstDt",
    headerText : '<spring:message code="pettyCashRqst.rqstDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "invcDt",
    headerText : '<spring:message code="webInvoice.invoiceDate" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "invcNo",
    headerText : 'Invoice No',
}, {
    dataField : "supplir",
    headerText : 'Supplier Name',
}, {
    dataField : "expType",
    headerText : 'Expenses Type',
},{
    dataField : "expTypeName",
    headerText : 'Expenses Type Name',
},{
    dataField : "glAccCode",
    headerText : 'GL Acc Code',
},{
    dataField : "glAccCodeName",
    headerText : 'GL Acc Code Name',
},{
    dataField : "budgetCode",
    headerText : 'Budget Code',
},{
    dataField : "budgetCodeName",
    headerText : 'Budget Code Name',
},{
    dataField : "expDesc",
    headerText : 'Expenses Description',
},{
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="pettyCashRqst.appvalDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

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
	console.log("staffClaimExcelDownloadPop");
	multiCombo();
	excelGridIDNew = AUIGrid.create("#excel_grid_wrap_new", excelColumnLayoutNew, excelGridProsNew);

    $("#supplierSearch").click(fn_supplierSearchPopExcel);
	$("#costCenterSearch").click(fn_popCostCenterSearchPopExcel);
});

function multiCombo() {
    $(function() {
        $('#status').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");
    });


}

function fn_excelDownload(){
	var staffCode =  $("#staffMemAccId").val();
	staffCode = staffCode.replaceAll(",,",",");
	staffCode = staffCode.replace(/[`~!@#$%^*()_|+\-=?;:'".<>\{\}\[\]\\\/]/gi, '');
    $("#staffMemAccId").val(staffCode);

    if(staffCode == ""){
    	Common.alert("Please enter at least 1 staff code");
    	return false;
    }

 	 Common.ajax("GET", "/eAccounting/staffClaim/selectExcelListNew.do", $("#form_newExcel").serialize(), function(result2) {
 	     AUIGrid.setGridData(excelGridIDNew, result2);
 	     GridCommon.exportTo("excel_grid_wrap_new", "xlsx", "Staff Claim");
      });
}

function fn_popCostCenterSearchPopExcel() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setPopCostCenter() {
	var costCenter =  $("#costCenter").val();
	var costCenterList = [];
	if(costCenter != ""){
		costCenterList = costCenter.split(",");
	}
	costCenterList.push($("#search_costCentr").val());

	var newJoinCostCenterString = costCenterList.join(",").trim().replaceAll(",,",",");
	newJoinCostCenterString = newJoinCostCenterString.replace(/[`~!@#$%^*()_|+\-=?;:'".<>\{\}\[\]\\\/]/gi, '');
    $("#costCenter").val(newJoinCostCenterString);
}

function fn_supplierSearchPopExcel() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM10",pop:"pop"}, null, true, "supplierSearchPop");
}

function fn_setPopSupplier() {
	var staffCode =  $("#staffMemAccId").val();
	var staffCodeList = [];
	if(staffCode != ""){
		staffCodeList = staffCode.split(",");
	}
	staffCodeList.push($("#search_memAccId").val());
	var newJoinStaffCodeString = staffCodeList.join(",").trim().replaceAll(",,",",");
	newJoinStaffCodeString = newJoinStaffCodeString.replace(/[`~!@#$%^*()_|+\-=?;:'".<>\{\}\[\]\\\/]/gi, '');
    $("#staffMemAccId").val(newJoinStaffCodeString);
}

function fn_clearExcel(){
	$("#staffMemAccId").val('');
	$("#costCenter").val('');
	$("#clmMonthFrom").val('');
	$("#clmMonthTo").val('');
	$("#requestDateFrom").val('');
	$("#requestDateTo").val('');
	$('#status').multipleSelect('checkAll');
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Staff Claim Listing</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newExcel">

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
	<th scope="row"><spring:message code="staffClaim.staffCode" /><span style="color:red">*</span></th>
	<td><input type="text" title="" placeholder="" class="" id="staffMemAccId" name="staffMemAccId"/><a href="#" class="search_btn" id="supplierSearch"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>

	<th scope="row"><spring:message code="webInvoice.status" /></th>
	<td>
	<select class="multy_select" multiple="multiple" id="status" name="status">
		<option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="costCenter" name="costCenter" value="${costCentr}"/><a href="#" class="search_btn" id="costCenterSearch"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th></th>
	<td></td>
</tr>
<tr>
	<th scope="row">Claim Month/Year</th>
	<td>
		<div class="date_set"><!-- date_set start -->
			<p><input type="text" title="Claim Month From" placeholder="MM/YYYY" class="j_date2" id="clmMonthFrom" name="clmMonthFrom"/></p>
			<span>~</span>
			<p><input type="text" title="Claim Month To" placeholder="MM/YYYY" class="j_date2" id="clmMonthTo" name="clmMonthTo"/></p>
		</div><!-- date_set end -->
	<th></th>
	<td></td>
</tr>
<tr>
	<th scope="row">Request Date</th>
	<td>
		<div class="date_set"><!-- date_set start -->
			<p><input type="text" title="Request Date From" placeholder="DD/MM/YYYY" class="j_date"  id="requestDateFrom" name="requestDateFrom"/></p>
			<span>~</span>
			<p><input type="text" title="Request Date To" placeholder="DD/MM/YYYY" class="j_date" id="requestDateTo" name="requestDateTo"/></p>
		</div><!-- date_set end -->
	</td>
	<th></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" onclick="fn_excelDownload()">Excel Download</a></p></li>
	<li><p class="btn_blue2"><a href="#" onclick="fn_clearExcel()">Clear</a></p></li>
</ul>
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap" id="excel_grid_wrap_new" style="display:none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->