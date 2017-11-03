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
</style>
<script type="text/javascript">
var clmNo = "${clmNo}";
var clmSeq = 0;
var atchFileGrpId;
var attachList;
var callType = "${callType}";
var selectRowIdx;
//file action list
var update = new Array();
var remove = new Array();
var newGridColumnLayout = [ {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "bankCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "bankName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "chrgUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "chrgUserName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentr",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "clmMonth",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "invcDt",
    headerText : 'Invoice<br>Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "costCentrName",
    headerText : 'Cost Center<br>Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "expType",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expTypeName",
    headerText : 'Expense<br>Type',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "glAccCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "glAccCodeName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "budgetCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "budgetCodeName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "supply",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "supplyName",
    headerText : 'Supplier<br>Name',
}, {
    dataField : "taxCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "taxName",
    headerText : '<spring:message code="newWebInvoice.taxCode" />'
}, {
    dataField : "gstRgistNo",
    headerText : 'GST<br>Registration'
}, {
    dataField : "invcNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "invcType",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "invcTypeName",
    headerText : 'Invoice<br>Type',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "netAmt",
    headerText : 'Amount<br>before GST',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "taxAmt",
    headerText : 'GST',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "totAmt",
    headerText : 'Total<br>Amount',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.netAmt + item.taxAmt);
    },
    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
        if(item.yN == "N") {
            return "my-cell-style";
        }
        return null;
    }
}, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expDesc",
    headerText : 'Remark',
    style : "aui-grid-user-custom-left",
    width : 200
}, {
    dataField : "yN",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var newGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 헤더 높이 지정
    headerHeight : 40,
    // 그리드가 height 지정( 지정하지 않으면 부모 height 의 100% 할당받음 )
    height : 175,
    rowIdField : "clmSeq"
};

var newGridID;

$(document).ready(function () {
    newGridID = AUIGrid.create("#newReimbursement_grid_wrap", newGridColumnLayout, newGridPros);
    
    AUIGrid.setGridData(newGridID, $.parseJSON('${itemList}'));
    console.log($.parseJSON('${itemList}'))
    
    var result = $.parseJSON('${itemList}');
    var allTotAmt = "" + result[0].allTotAmt;
    $("#allTotAmt_text").text(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    
    setInputFile2();
    
    $("#supplier_search_btn").click();
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);
    $("#expenseType_search_btn").click(fn_PopExpenseTypeSearchPop);
    $("#supply_search_btn").click(fn_supplierSearchPop);
    $("#clear_btn").click(fn_clearData);
    $("#add_btn").click(fn_addRow);
    $("#tempSave_btn").click(fn_tempSave);
    $("#request_btn").click(fn_approveLinePop);
    
    AUIGrid.bind(newGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + event.item.clmNo + " CellDoubleClick clmSeq : " + event.item.clmSeq);
                // TODO pettyCash Expense Info GET
                if(clmNo != null && clmNo != "") {
                    selectRowIdx = event.rowIndex;
                    clmSeq = event.item.clmSeq;
                    atchFileGrpId = event.item.atchFileGrpId;
                    fn_selectReimbursementInfo();
                } else {
                    Common.alert("You must save it before you can edit it.");
                }
            });
    
    CommonCombo.make("taxCode", "/eAccounting/creditCard/selectTaxCodeCreditCardFlag.do", null, "", {
        id: "taxCode",
        name: "taxName",
        type:"S"
    });
    
    fn_setEvent();
    
    var appvPrcssNo = "${appvPrcssNo}";
    if(appvPrcssNo != null || appvPrcssNo != ""){
    	$("#maskingNo").unbind("click");
    }
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_tempSave() {
    fn_updateReimbursement(callType);
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View/Edit Reimbursement</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newReimbursement">
<input type="hidden" id="newCrditCardNo" name="crditCardNo">
<input type="hidden" id="newCrditCardUserId" name="crditCardUserId">
<input type="hidden" id="newChrgUserId" name="chrgUserId">
<input type="hidden" id="newSupply" name="supply">
<input type="hidden" id="newCostCenter" name="costCentr">
<input type="hidden" id="bankCode" name="bankCode">
<input type="hidden" id="expType" name="expType">
<input type="hidden" id="glAccCode" name="glAccCode">
<input type="hidden" id="glAccCodeName" name="glAccCodeName">
<input type="hidden" id="budgetCode" name="budgetCode">
<input type="hidden" id="budgetCodeName" name="budgetCodeName">

<c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}">
<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" id="tempSave_btn">Temp. save</a></p></li>
	<li><p class="btn_blue2"><a href="#" id="request_btn">Summit</a></p></li>
</ul>
</c:if>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Credit Card No</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="maskingNo" maxlength="16" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
	<th scope="row">Credit cardholder name</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newCrditCardUserName" name="crditCardUserName"/></td>
</tr>
<tr>
	<th scope="row">Issue bank</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" name="bankName"/></td>
	<th scope="row">Person-in-charge name</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newChrgUserName" name="chrgUserName"/></td>
</tr>
<tr>
	<th scope="row">Claim Month</th>
    <td><input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="clmMonth" name="clmMonth" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>/></td>
	<th scope="row">Person-in-charge department</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newCostCenterText" name="costCentrName"/></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Invoice Date</th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="invcDt" name="invcDt" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>/></td>
	<th scope="row">Cost Center</th>
	<td><input type="text" title="" placeholder="" class="" id="sCostCenterText" readonly="readonly"/></td>
</tr>
<tr>
	<th scope="row">Expense Type</th>
	<td><input type="text" title="" placeholder="" class="" id="expTypeName" name="expTypeName" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/><c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}"><a href="#" class="search_btn" id="expenseType_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
	<th scope="row">Tax Code</th>
	<%-- <td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td> --%>
	<td><select class="" id="taxCode" name="taxCode" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>></select></td>
</tr>
<tr>
	<th scope="row">Supplier Name</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="newSupplyName" name="supplyName" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/><c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}"><a href="#" class="search_btn" id="supply_search_btn" style="display:none"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
	<th scope="row">GST Registration No</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="gstRgistNo" name="gstRgistNo" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
</tr>
<tr>
	<th scope="row">Invoice Type</th>
	<td>
	<select class="w100p" id="invcType" name="invcType" onchange="javascript:fn_ActionInvcTypeS()" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>>
		<option value="F">Full Tax invoice</option>
		<option value="S">Simplified Tax invoice</option>
	</select>
	</td>
	<th scope="row">Invoice No</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="invcNo" name="invcNo" autocomplete="off" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
</tr>
<tr id="amt">
	<th scope="row">Approved cash amount (RM)</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="netAmt" name="netAmt" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
	<th scope="row">GST (RM)</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="taxAmt" name="taxAmt" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
</tr>
<tr>
	<th scope="row"></th>
	<td></td>
	<th scope="row">Total Amount</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="totAmt" name="totAmt"/></td>
</tr>
<tr>
	<th scope="row">Attachment</th>
	<td colspan="3" id="attachTd">
	<div class="auto_file2 auto_file3"><!-- auto_file start -->
	<input type="file" title="file add" />
	</div><!-- auto_file end -->
	</td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3"><textarea class="w100p" rows="2" style="height:auto" id="expDesc" name="expDesc" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}">
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="add_btn">Add</a></p></li>
	<li><p class="btn_blue2"><a href="#" id="clear_btn">Clear</a></p></li>
</ul>
</c:if>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text">Total Amount:<span id="allTotAmt_text"></span></h2>
</aside><!-- title_line end -->

<article class="grid_wrap" id="newReimbursement_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->