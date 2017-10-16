<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var appvPrcssNo;
var atchFileGrpId;
var invoAprveGridColLayout = [ {
    dataField : "appvPrcssNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},{
    dataField : "clmNo",
    headerText : '<spring:message code="invoiceApprove.clmNo" />',
    width : 90
},{
    dataField : "reqstDt",
    headerText : '<spring:message code="invoiceApprove.reqstDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy",

}, {
    dataField : "codeName",
    headerText : '<spring:message code="invoiceApprove.clmType" />'
}, {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.cc" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="webInvoice.ccName" />'
}, {
    dataField : "invcType",
    headerText : '<spring:message code="invoiceApprove.type" />'
}, {
    dataField : "memAccId",
    headerText : '<spring:message code="invoiceApprove.supBrEnp" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="invoiceApprove.supBrEnpName" />'
}, {
    dataField : "appvAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    dataType: "numeric",
    formatString : "#,##0"
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />'
}, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileName",
    headerText : '<spring:message code="newWebInvoice.attachment" />',
    width : 200,
    renderer : {
        type : "ButtonRenderer",
        onclick : function(rowIndex, columnIndex, value, item) {
        	console.log("view_btn click atchFileGrpId : " + item.atchFileGrpId);
        	console.log(item);
        	if(item.fileCnt > 1) {
        		atchFileGrpId = item.atchFileGrpId;
        		fn_fileListPop();
        	} else {
        		if(item.fileExtsn == "jpg") {
                    // TODO View
                } else {
                    console.log("view_btn click fileSubPath : " + item.fileSubPath + ", physiclFileName : " + item.physiclFileName + ", atchFileName : " + item.atchFileName);
                    window.open("/file/fileDown.do?subPath=" + item.fileSubPath
                            + "&fileName=" + item.physiclFileName + "&orignlFileNm=" + item.atchFileName
                            + "");
                }
        	}
        }
    }
}, {
    dataField : "fileSubPath",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "physiclFileName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "fileExtsn",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "fileCnt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="invoiceApprove.appvBrDt" />'
}
];

//그리드 속성 설정
var invoAprveGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 체크박스 표시 설정
    showRowCheckColumn : true,
    showRowNumColumn : false,
    // 헤더 높이 지정
    headerHeight : 40
};

var invoAprveGridID;

$(document).ready(function () {
	invoAprveGridID = AUIGrid.create("#approve_grid_wrap", invoAprveGridColLayout, invoAprveGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#approve_btn").click(fn_approveRegistPop);
    $("#reject_btn").click(fn_rejectRegistPop);
    
    AUIGrid.bind(invoAprveGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
                console.log("CellDoubleClick atchFileGrpId : " + event.item.atchFileGrpId);
                // TODO detail popup open
                appvPrcssNo = event.item.appvPrcssNo;
                atchFileGrpId = event.item.atchFileGrpId;
                
                fn_webInvoiceAppvViewPop();
            });
    
    CommonCombo.make("clmType", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });
});

function fn_supplierSearchPop() {
	var object = {
            accGrp : "VM01",
            accGrpName : "Coway_Suppliers_Local"
    };
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", object, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    var value = $("#costCenter").val();
    var object = {value:value};
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_selectApproveList() {
    Common.ajax("GET", "/eAccounting/webInvoice/selectApproveList.do", $("#form_approve").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(invoAprveGridID, result);
    });
}

function fn_fileListPop() {
    var data = {
    		atchFileGrpId : atchFileGrpId
    };
    Common.popupDiv("/eAccounting/webInvoice/fileListPop.do", data, null, true, "fileListPop");
}

function fn_webInvoiceAppvViewPop() {
    var data = {
            appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/webInvoiceAppvViewPop.do", data, null, true, "webInvoiceAppvViewPop");
}

function fn_approveRegistPop() {
	var data = {
            appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/approveRegistPop.do", null, null, true, "approveRegistPop");
}

function fn_rejectRegistPop() {
	var data = {
            appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/rejectRegistPop.do", null, null, true, "rejectRegistPop");
}

function fn_setGridData(gridId, data) {
    console.log(data);
    AUIGrid.setGridData(gridId, data);
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="invoiceApprove.title" /></h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="fn_selectApproveList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_approve">
<input type="hidden" id="memAccId" name="memAccId">
<input type="hidden" id="costCenter" name="costCenter">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.clmType" /></th>
	<td>
	<select class="w100p" id="clmType" name="clmType" multiple="multiple">
	</select>
	</td>
	<th scope="row"><spring:message code="invoiceApprove.createUser" /></th>
	<td><input type="text" title="" placeholder="" class="" id="createUser" name="createUser" /><a href="#" class="search_btn" id="search_createUser_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.suppliEmploy" /></th>
	<td><input type="text" title="" placeholder="" class="" id="memAccName" name="memAccName" /><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="costCenterText" name="costCenterText" /><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.postingDate" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
	<span><spring:message code="webInvoice.to" /></span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="webInvoice.status" /></th>
	<td>
	<select class="multy_select w100p" multiple="multiple" name="appvPrcssStus">
		<option value="A"><spring:message code="webInvoice.select.approved" /></option>
		<option value="R"><spring:message code="webInvoice.select.request" /></option>
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
	<li><p class="btn_grid"><a href="#" id="approve_btn"><spring:message code="invoiceApprove.title" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="reject_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
</ul>

<article class="grid_wrap" id="approve_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->