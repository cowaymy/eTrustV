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
/* 첨부파일 버튼 스타일 재정의*/
.aui-grid-button-renderer {
     width:100%;
     padding: 4px;
 }
</style>
<script type="text/javascript">
var pettyCashReqstColumnLayout = [ {
    dataField : "clmNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.costCenter" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="pettyCashCustdn.costCentrName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccId",
    headerText : '<spring:message code="pettyCashCustdn.custdn" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="pettyCashCustdn.custdnName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "appvCashAmt",
    headerText : '<spring:message code="pettyCashRqst.appvPettyCash" />',
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
    headerText : '<spring:message code="pettyCashRqst.pettyCashRqst" />',
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
    headerText : '<spring:message code="pettyCashRqst.rqstNo" />'
}, {
    dataField : "crtDt",
    headerText : '<spring:message code="pettyCashCustdn.crtDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "reqstDt",
    headerText : '<spring:message code="pettyCashRqst.rqstDt" />',
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
    labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
        var myString = value;
        // 로직 처리
        // 여기서 value 를 원하는 형태로 재가공 또는 포매팅하여 반환하십시오.
        if(FormUtil.isEmpty(myString)) {
            myString = '<spring:message code="invoiceApprove.noAtch.msg" />';
        }
        return myString;
     }, 
    renderer : {
        type : "ButtonRenderer",
        onclick : function(rowIndex, columnIndex, value, item) {
            console.log("view_btn click atchFileGrpId : " + item.atchFileGrpId + " atchFileId : " + item.atchFileId);
            if(item.fileCnt > 1) {
                fn_fileListPop(item.atchFileGrpId);
            } else {
            	if(item.fileCnt == 1) {
                    var data = {
                            atchFileGrpId : item.atchFileGrpId,
                            atchFileId : item.atchFileId
                    };
                    if(item.fileExtsn == "jpg" || item.fileExtsn == "png") {
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
                } else {
                	Common.alert('<spring:message code="invoiceApprove.notFoundAtch.msg" />');
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
    headerText : '<spring:message code="pettyCashRqst.appvalDt" />',
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
    headerHeight : 40,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
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
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM09"}, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
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
                costCentr : $("#newCostCenter").val()
        };
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(FormUtil.isEmpty(result.data)) {
                Common.alert('<spring:message code="pettyCashRqst.custdnNric.msg" />');
            } else {
            	$("#newMemAccId").val(result.data.memAccId);
            	$("#newMemAccName").val(result.data.memAccName);
            	$("#bankCode").val(result.data.bankCode);
            	$("#bankName").val(result.data.bankName);
            	$("#bankAccNo").val(result.data.bankAccNo);
            	if(!FormUtil.isEmpty(result.data.appvCashAmt)) {
            		var appvCashAmt = "" + result.data.appvCashAmt;
                    $("#appvCashAmt").val(appvCashAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
            	}
            	if(!FormUtil.isEmpty(result.data.custdnNric)) {
            		var custdnNric = result.data.custdnNric;
                    $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
            	}
            }
        });
    }
}

function fn_setCostCenterEvent() {
    $("#newCostCenter").change(function(){
        var costCenter = $(this).val();
        console.log(costCenter);
        if(!FormUtil.isEmpty(costCenter)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:costCenter}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#newCostCenterText").val(row.costCenterText);
                }
                
                if(fn_checkEmpty()){
                    // Approved Cash Amount GET and CUSTDN_NRIC GET
                    var data = {
                            costCentr : $("#newCostCenter").val()
                    };
                    Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
                        console.log(result);
                        console.log(FormUtil.isEmpty(result.data));
                        if(FormUtil.isEmpty(result.data)) {
                            Common.alert('<spring:message code="pettyCashRqst.custdnNric.msg" />');
                        } else {
                            $("#newMemAccId").val(result.data.memAccId);
                            $("#newMemAccName").val(result.data.memAccName);
                            $("#bankCode").val(result.data.bankCode);
                            $("#bankName").val(result.data.bankName);
                            $("#bankAccNo").val(result.data.bankAccNo);
                            if(!FormUtil.isEmpty(result.data.appvCashAmt)) {
                                var appvCashAmt = "" + result.data.appvCashAmt;
                                $("#appvCashAmt").val(appvCashAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                            }
                            if(!FormUtil.isEmpty(result.data.custdnNric)) {
                                var custdnNric = result.data.custdnNric;
                                $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
                            }
                        }
                    });
                }
            });
        }
   }); 
}

function fn_selectRequestList() {
    Common.ajax("GET", "/eAccounting/pettyCash/selectRequestList.do?_cacheId=" + Math.random(), $("#form_pettyCashReqst").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(pettyCashReqstGridID, result);
    });
}

function fn_newRequestPop() {
    Common.popupDiv("/eAccounting/pettyCash/newRequestPop.do", {callType:"new"}, null, true, "newRequestPop");
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
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
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="pettyCashRqst.title" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectRequestList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_pettyCashReqst">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="costCenterText" name="costCentrName">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="costCenter" name="costCentr"/><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="pettyCashCustdn.custdn" /></th>
	<td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId" /><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row"><spring:message code="pettyCashCustdn.crtDt" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt" /></p>
	<span><spring:message code="webInvoice.to" /></span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="webInvoice.status" /></th>
	<td>
	<select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
		<option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="petttyCashRqst.newRqst" /></a></p></li>
	</c:if>
</ul>

<article class="grid_wrap" id="pettyCashReqst_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->