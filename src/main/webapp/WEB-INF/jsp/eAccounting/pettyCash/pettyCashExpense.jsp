<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
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
var pettyCashExpColumnLayout = [ {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.cc" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="webInvoice.ccName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccId",
    headerText : 'Custodian'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="approveLine.name" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "clmMonth",
    headerText : 'Claim Month',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "clmNo",
    headerText : 'Claim No',
}, {
    dataField : "reqstDt",
    headerText : 'Request<br>Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "cvrr",
    headerText : '<spring:message code="newWebInvoice.cvrr" />',
}, {
    dataField : "totAmt",
    headerText : 'Amount',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appvPrcssStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : 'Approved<br>Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

//그리드 속성 설정
var pettyCashExpGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
 // 헤더 높이 지정
    headerHeight : 40
};

var pettyCashExpGridID;

$(document).ready(function () {
	pettyCashExpGridID = AUIGrid.create("#expenseMgmt_grid_wrap", pettyCashExpColumnLayout, pettyCashExpGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click(fn_newExpensePop);
    
    AUIGrid.bind(pettyCashExpGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + event.item.clmNo);
                
                fn_viewRequestPop(event.item.clmNo);
            });
    
    $("#appvPrcssStus").multipleSelect("checkAll");
    
    fn_setToMonth();
});

function fn_setToMonth() {
    var month = new Date();
    
    var mm = month.getMonth() + 1;
    var yyyy = month.getFullYear();
    
    if(mm < 10){
        mm = "0" + mm
    }
    
    month = mm + "/" + yyyy;
    $("#clmMonth").val(month)
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_selectExpenseList() {
    Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseList.do", $("#form_pettyCashExp").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(pettyCashExpGridID, result);
    });
}

function fn_newExpensePop() {
    Common.popupDiv("/eAccounting/pettyCash/newExpensePop.do", {callType:"new"}, null, true, "newExpensePop");
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Petty Cash Expense</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectExpenseList()"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_pettyCashExp">
<input type="hidden" id="memAccId" name="memAccId">
<input type="hidden" id="costCenter" name="costCentr">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Cost Center</th>
    <td><input type="text" title="" placeholder="" class="" id="costCenterText" name="costCentrName"/><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Custodian</th>
    <td><input type="text" title="" placeholder="" class="" id="memAccName" name="memAccName"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row">Claim Month</th>
    <td><input type="text" title="Reference Month" placeholder="MM/YYYY" class="j_date2 w100p" id="clmMonth" name="clmMonth"/></td>
    <th scope="row">Status</th>
    <td>
    <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
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
    <li><p class="btn_grid"><a href="#" id="registration_btn">New Expenses</a></p></li>
</ul>

<article class="grid_wrap" id="expenseMgmt_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->