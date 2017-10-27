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
var pettyCashReqstColumnLayout = [ {
    dataField : "clmNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
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
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
}, {
    dataField : "appvCashAmt",
    headerText : 'Approved<br>Petty Cash',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true, // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
        allowPoint : true // 소수점(.) 입력 가능 설정
    }
}, {
    dataField : "reqstAmt",
    headerText : 'Request<br>Petty Cash',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true, // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
        allowPoint : true // 소수점(.) 입력 가능 설정
    }
}, {
    dataField : "reqstNo",
    headerText : 'Request No'
}, {
    dataField : "crtDt",
    headerText : 'Create Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "reqstDt",
    headerText : 'Request<br>Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
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
            console.log("view_btn click atchFileGrpId : " + item.atchFileGrpId + " atchFileId : " + item.atchFileId);
            if(item.fileCnt > 1) {
                atchFileGrpId = item.atchFileGrpId;
                fn_fileListPop(item.atchFileGrpId);
            } else {
                var data = {
                        atchFileGrpId : item.atchFileGrpId,
                        atchFileId : item.atchFileId
                };
                if(item.fileExtsn == "jpg") {
                    // TODO View
                    console.log(data);
                    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                        console.log(result);
                        var fileSubPath = result.fileSubPath;
                        fileSubPath = fileSubPath.replace('\', '/'');
                        console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                        window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                    });
                } else {
                    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                        console.log(result);
                        var fileSubPath = result.fileSubPath;
                        fileSubPath = fileSubPath.replace('\', '/'');
                        console.log("/file/fileDown.do?subPath=" + fileSubPath
                                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                        window.open("/file/fileDown.do?subPath=" + fileSubPath
                            + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                    });
                }
            }
        }
    }
}, {
    dataField : "fileExtsn",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "fileCnt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
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
var pettyCashReqstGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
 // 헤더 높이 지정
    headerHeight : 40
};

var pettyCashReqstGridID;

$(document).ready(function () {
    pettyCashReqstGridID = AUIGrid.create("#pettyCashReqst_grid_wrap", pettyCashReqstColumnLayout, pettyCashReqstGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click(fn_newRequestPop);
    
    AUIGrid.bind(pettyCashReqstGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + event.item.clmNo);
                
                fn_viewRequestPop(event.item.clmNo);
            });
    
    $("#appvPrcssStus").multipleSelect("checkAll");
    
    fn_setToDay();
});

function fn_setToDay() {
    var today = new Date();
    
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm
    }
    
    today = dd + "/" + mm + "/" + yyyy;
    $("#startDt").val(today)
    $("#endDt").val(today)
}

function fn_fileListPop(atchFileGrpId) {
    var data = {
            atchFileGrpId : atchFileGrpId
    };
    Common.popupDiv("/eAccounting/webInvoice/fileListPop.do", data, null, true, "fileListPop");
}

function fn_setGridData(gridId, data) {
    console.log(data);
    AUIGrid.setGridData(gridId, data);
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop"}, null, true, "supplierSearchPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
    
    if(fn_checkEmpty()){
        // Approved Cash Amount GET and CUSTDN_NRIC GET
        var data = {
                memAccId : $("#newMemAccId").val(),
                costCentr : $("#newCostCenter").val()
        };
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(FormUtil.isEmpty(result.data)) {
                Common.alert("There is no data for cost centers and custodians.");
            } else {
                var appvCashAmt = "" + result.data.appvCashAmt;
                $("#appvCashAmt").val(appvCashAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                var custdnNric = result.data.custdnNric;
                $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
            }
        });
    }
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
    
    if(fn_checkEmpty()){
        // Approved Cash Amount GET and CUSTDN_NRIC GET
        var data = {
                memAccId : $("#newMemAccId").val(),
                costCentr : $("#newCostCenter").val()
        };
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(FormUtil.isEmpty(result.data)) {
            	Common.alert("There is no data for cost centers and custodians.");
            } else {
            	var appvCashAmt = "" + result.data.appvCashAmt;
                $("#appvCashAmt").val(appvCashAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                var custdnNric = result.data.custdnNric;
                $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
            }
        });
    }
}

function fn_selectRequestList() {
    Common.ajax("GET", "/eAccounting/pettyCash/selectRequestList.do", $("#form_pettyCashReqst").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(pettyCashReqstGridID, result);
    });
}

function fn_newRequestPop() {
    Common.popupDiv("/eAccounting/pettyCash/newRequestPop.do", {callType:"new"}, null, true, "newRequestPop");
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenterText").val())) {
        Common.alert("Please enter the Cost Center.");
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccName").val())) {
        Common.alert("Please enter the Custodian.");
        checkResult = false;
        return checkResult;
    }
    return checkResult;
}

function fn_viewRequestPop(clmNo) {
	var data = {
            clmNo : clmNo,
            callType : 'view'
    };
	Common.popupDiv("/eAccounting/pettyCash/viewRequestPop.do", data, null, true, "viewRequestPop");
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
<h2>Request Petty Cash</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectRequestList()"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_pettyCashReqst">
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
	<td><input type="text" title="" placeholder="" class="" id="memAccName" name="memAccName" /><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row">Create Date</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt" /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt" /></p>
	</div><!-- date_set end -->
	</td>
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
	<li><p class="btn_grid"><a href="#" id="registration_btn">New Request</a></p></li>
</ul>

<article class="grid_wrap" id="pettyCashReqst_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->