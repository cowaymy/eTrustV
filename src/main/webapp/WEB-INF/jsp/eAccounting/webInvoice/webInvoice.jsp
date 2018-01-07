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
var webInvoiceColumnLayout = [ {
    dataField : "invcDt",
    headerText : '<spring:message code="webInvoice.postingDate" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "clmNo",
    visible : false
}, {
    dataField : "invcNo",
    headerText : '<spring:message code="webInvoice.invoiceNo" />',
    width : 140
}, {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.cc" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="webInvoice.ccName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="webInvoice.name" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    dataType: "numeric",
    formatString : "#,##0.00",
    style : "aui-grid-user-custom-right"
}, {
    dataField : "reqstDt",
    headerText : '<spring:message code="webInvoice.requestDate" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "appvPrcssNo",
    visible : false
}, {
    dataField : "appvPrcssStusCode",
    visible : false
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="webInvoice.approvedDate" />'
}
];

//그리드 속성 설정
var webInvoiceGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var webInvoiceGridID;

$(document).ready(function () {
	webInvoiceGridID = AUIGrid.create("#webInvoice _grid_wrap", webInvoiceColumnLayout, webInvoiceGridPros);
	
	$("#search_supplier_btn").click(fn_supplierSearchPop);
	$("#search_costCenter_btn").click(fn_costCenterSearchPop);
	$("#registration_btn").click(fn_newWebInvoicePop);
	
	AUIGrid.bind(webInvoiceGridID, "cellDoubleClick", function( event ) 
		    {
		        console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
		        console.log("CellDoubleClick clmNo : " + event.item.clmNo);
		        console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
		        console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);
		        // TODO detail popup open
		        if(event.item.appvPrcssStusCode == "T") {
		        	fn_viewEditWebInvoicePop(event.item.clmNo);
		        } else {
		        	fn_webInvoiceRequestPop(event.item.appvPrcssNo);
		        }
		        
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

function fn_setPayDueDtEvent() {
	$("#payDueDt").change(function(){
		var payDueDt = $(this).val();
        console.log(payDueDt);
        var day = payDueDt.substring(0, 2);
        var month = payDueDt.substring(3, 5);
        var year = payDueDt.substring(6);
        console.log("year : " + year + " month : " + month + " day : " + day);
        payDueDt = year + month + day;
        
        var now = new Date;
        var dd = now.getDate();
        var mm = now.getMonth() + 1;
        var yyyy = now.getFullYear();
        if(dd < 10) {
            dd = "0" + dd;
        }
        if(mm < 10){
            mm = "0" + mm
        }
        now = yyyy + "" + mm + "" + dd;
        console.log("yyyy : " + yyyy + " mm : " + mm + " dd : " + dd);
        
        console.log(payDueDt);
        console.log(now);
        if(Number(payDueDt) < Number(now)) {
            Common.alert('<spring:message code="webInvoice.payDueDt.msg" />');
            $("#payDueDt").val(dd + "/" + mm + "/" + yyyy);
        }
   }); 
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
            });
        }
   }); 
}

function fn_setSupplierEvent() {
    $("#newMemAccId").change(function(){
        var memAccId = $(this).val();
        console.log(memAccId);
        if(!FormUtil.isEmpty(memAccId)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectSupplier.do?_cacheId=" + Math.random(), {memAccId:memAccId}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#newMemAccName").val(row.memAccName);
                    $("#gstRgistNo").val(row.gstRgistNo);
                    $("#bankCode").val(row.bankCode);
                    $("#bankName").val(row.bankName);
                    $("#bankAccNo").val(row.bankAccNo);
                }
            });
        }
   }); 
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM01"}, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
	Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM01"}, null, true, "supplierSearchPop");
}

function fn_viewEditWebInvoicePop(clmNo) {
	var data = {
            clmNo : clmNo,
            callType : 'view'
    };
	Common.popupDiv("/eAccounting/webInvoice/viewEditWebInvoicePop.do", data, null, true, "viewEditWebInvoicePop");
}

function fn_webInvoiceRequestPop(appvPrcssNo) {
    var data = {
    		appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/webInvoiceRqstViewPop.do", data, null, true, "webInvoiceRqstViewPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_newWebInvoicePop() {
    Common.popupDiv("/eAccounting/webInvoice/newWebInvoicePop.do", {callType:'new'}, null, true, "newWebInvoicePop");
}

function fn_selectWebInvoiceList() {
    Common.ajax("GET", "/eAccounting/webInvoice/selectWebInvoiceList.do?_cacheId=" + Math.random(), $("#form_webInvoice").serialize(), function(result) {
    	console.log(result);
        AUIGrid.setGridData(webInvoiceGridID, result);
    });
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
}

function fn_setPopExpType() {
	AUIGrid.setCellValue(newGridID , selectRowIdx , "budgetCode", $("#search_budgetCode").val());
    AUIGrid.setCellValue(newGridID , selectRowIdx , "budgetCodeName", $("#search_budgetCodeName").val());
    
    AUIGrid.setCellValue(newGridID , selectRowIdx , "expType", $("#search_expType").val());
    AUIGrid.setCellValue(newGridID , selectRowIdx , "expTypeName", $("#search_expTypeName").val());
    
    AUIGrid.setCellValue(newGridID , selectRowIdx , "glAccCode", $("#search_glAccCode").val());
    AUIGrid.setCellValue(newGridID , selectRowIdx , "glAccCodeName", $("#search_glAccCodeName").val());
}

function fn_setKeyInDate() {
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
    $("#keyDate").val(today)
}

function fn_getValue(index) {
    return AUIGrid.getCellFormatValue(newGridID, index, "totAmt");
}

function fn_getTotalAmount() {
    // 수정할 때 netAmount와 taxAmount의 values를 각각 더하고 합하기
    sum = 0;
    var netAmtList = AUIGrid.getColumnValues(newGridID, "netAmt");
    var taxAmtList = AUIGrid.getColumnValues(newGridID, "taxAmt");
    var taxNonClmAmtList = AUIGrid.getColumnValues(newGridID, "taxNonClmAmt");
    if(netAmtList.length > 0) {
        for(var i in netAmtList) {
            sum += netAmtList[i];
        }
    }
    if(taxAmtList.length > 0) {
        for(var i in taxAmtList) {
            sum += taxAmtList[i];
        }
    }
    if(taxNonClmAmtList.length > 0) {
        for(var i in taxNonClmAmtList) {
            sum += taxNonClmAmtList[i];
        }
    }
    return sum;
}

function fn_addRow() {
	if(AUIGrid.getRowCount(newGridID) > 0) {
		console.log("clamUn" + AUIGrid.getCellValue(newGridID, 0, "clamUn"));
		AUIGrid.addRow(newGridID, {clamUn:AUIGrid.getCellValue(newGridID, 0, "clamUn"),cur:"MYR",netAmt:0,taxAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
	} else {
		Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J1"}, function(result) {
	        console.log(result);
	        AUIGrid.addRow(newGridID, {clamUn:result.clamUn,cur:"MYR",netAmt:0,taxAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
	    });
	}
}

function fn_removeRow() {
    var total = Number($("#totalAmount").text().replace(',', ''));
    var value = fn_getValue(selectRowIdx);
    value = Number(value.replace(',', ''));
    total -= value;
    $("#totalAmount").text(AUIGrid.formatNumber(total, "#,##0.00"));
    $("#totAmt").val(total);
    AUIGrid.removeRow(newGridID, selectRowIdx);
}

function fn_checkEmpty() {
	var checkResult = true;
	if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
        checkResult = false;
        return checkResult;
    }
	if($("#invcType").val() == "F") {
	    if(FormUtil.isEmpty($("#newMemAccId").val())) {
	        Common.alert('<spring:message code="webInvoice.supplier.msg" />');
	        checkResult = false;
	        return checkResult;
	    }
	    if(FormUtil.isEmpty($("#invcNo").val())) {
	        Common.alert('<spring:message code="webInvoice.invcNo.msg" />');
	        checkResult = false;
	        return checkResult;
	    }
	    var length = AUIGrid.getGridData(newGridID).length;
	    if(length > 0) {
	    	for(var i = 0; i < length; i++) {
	            if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "taxCode"))) {
	                Common.alert('<spring:message code="webInvoice.taxCode.msg" />' + (i +1) + ".");
	                checkResult = false;
	                return checkResult;
	            }
	            if(FormUtil.isEmpty(AUIGrid.getCellValue(newGridID, i, "netAmt"))) {
                    Common.alert('<spring:message code="webInvoice.netAmt.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
	        }
	    }
	}
	return checkResult;
}

function fn_selectWebInvoiceItemList(clmNo) {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/webInvoice/selectWebInvoiceItemList.do?_cacheId=" + Math.random(), obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

//Budget Code Pop 호출
function fn_budgetCodePop(rowIndex){
    if(!FormUtil.isEmpty($("#newCostCenter").val())){
    	var data = {
                rowIndex : rowIndex
                ,costCentr : $("#newCostCenter").val()
                ,costCentrName : $("#newCostCenterText").val()
        };
    	Common.popupDiv("/eAccounting/webInvoice/budgetCodeSearchPop.do", data, null, true, "budgetCodeSearchPop");
    } else {
    	Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
    }
}  

//Gl Account Pop 호출
function fn_glAccountSearchPop(rowIndex){
    
    var myValue = AUIGrid.getCellValue(newGridID, rowIndex, "budgetCode");
    
    if(!FormUtil.isEmpty(myValue)){
    	var data = {
                rowIndex : rowIndex
                ,costCentr : $("#newCostCenter").val()
                ,costCentrName : $("#newCostCenterText").val()
                ,budgetCode : AUIGrid.getCellValue(newGridID, rowIndex, "budgetCode")
                ,budgetCodeName : AUIGrid.getCellValue(newGridID, rowIndex, "budgetCodeName")
        };
           Common.popupDiv("/eAccounting/webInvoice/glAccountSearchPop.do", data, null, true, "glAccountSearchPop");
    } else {
    	Common.alert('<spring:message code="webInvoice.budgetCode.msg" />');
    }
}

function fn_setNewGridEvent() {
	AUIGrid.bind(newGridID, "cellClick", function( event ) 
		    {
		        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
		        selectRowIdx = event.rowIndex;
		    });
		    
		    AUIGrid.bind(newGridID, "cellEditBegin", function( event ) {
		        // return false; // false, true 반환으로 동적으로 수정, 편집 제어 가능
		        if($("#invcType").val() == "S") {
		            if(event.dataField == "taxNonClmAmt") {
		                if(event.item.taxAmt <= 30) {
		                    Common.alert('<spring:message code="newWebInvoice.gstLess.msg" />');
		                    AUIGrid.forceEditingComplete(newGridID, null, true);
		                }
		            }
		        } else {
		            if(event.dataField == "taxNonClmAmt") {
		                Common.alert('<spring:message code="newWebInvoice.gstFullTax.msg" />');
		                AUIGrid.forceEditingComplete(newGridID, null, true);
		            }
		        }
		  });
		    
		    AUIGrid.bind(newGridID, "cellEditEnd", function( event ) {
		        if(event.dataField == "netAmt" || event.dataField == "taxAmt" || event.dataField == "taxNonClmAmt") {
		            var taxAmt = 0;
		            var taxNonClmAmt = 0;
		            if($("#invcType").val() == "S") {
		                if(event.dataField == "netAmt") {
		                    var taxAmtCnt = fn_getTotTaxAmt(event.rowIndex);
		                    if(taxAmtCnt >= 30) {
		                        taxNonClmAmt = event.item.oriTaxAmt;
		                    } else {
		                        if(taxAmtCnt == 0) {
		                            if(event.item.oriTaxAmt > 30) {
		                                taxAmt = 30;
		                                taxNonClmAmt = event.item.oriTaxAmt - 30;
		                            } else {
		                                taxAmt = event.item.oriTaxAmt;
		                            }
		                        } else {
		                            if((taxAmtCnt + event.item.oriTaxAmt) > 30) {
		                                taxAmt = 30 - taxAmtCnt;
		                                if(event.item.oriTaxAmt > taxAmt) {
		                                    taxNonClmAmt = event.item.oriTaxAmt - taxAmt;
		                                } else {
		                                    taxNonClmAmt = taxAmt - event.item.oriTaxAmt;
		                                }
		                            } else {
		                                taxAmt = event.item.oriTaxAmt;
		                                taxNonClmAmt = 0;
		                            }
		                        }
		                    }
		                    AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", taxAmt);
		                    AUIGrid.setCellValue(newGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
		                }
		                if(event.dataField == "taxAmt") {
		                    if(event.value > 30) {
		                        Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
		                        AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", event.oldValue);
		                    } else {
		                        var taxAmtCnt = fn_getTotTaxAmt(event.rowIndex);
		                        if((taxAmtCnt + event.value) > 30) {
		                            Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
		                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", event.oldValue);
		                        } else {
		                            taxAmt = event.value;
		                            if(event.item.oriTaxAmt > taxAmt) {
		                                taxNonClmAmt = event.item.oriTaxAmt - taxAmt;
		                            } else {
		                                taxNonClmAmt = taxAmt - event.item.oriTaxAmt;
		                            }
		                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", taxAmt);
		                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
		                        }
		                    }
		                }
		            } else {
		                if(event.dataField == "netAmt") {
		                    taxAmt = event.item.oriTaxAmt;
		                    AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", taxAmt);
		                    AUIGrid.setCellValue(newGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
		                }
		            }
		            var totAmt = fn_getTotalAmount();
		            $("#totalAmount").text(AUIGrid.formatNumber(totAmt, "#,##0.00"));
		            console.log(totAmt);
		            $("#totAmt").val(totAmt);
		        }
		        if(event.dataField == "taxCode") {
		            console.log("taxCode Choice Action");
		            console.log(event.item.taxCode);
		            var data = {
		                    taxCode : event.item.taxCode
		            };
		            Common.ajax("GET", "/eAccounting/webInvoice/selectTaxRate.do", data, function(result) {
		                console.log(result);
		                AUIGrid.setCellValue(newGridID, event.rowIndex, "taxRate", result.taxRate);
		            });
		        }
		  });
}

function fn_getTotTaxAmt(rowIndex) {
    var taxAmtCnt = 0;
    // 필터링이 된 경우 필터링 된 상태의 값만 원한다면 false 지정
    var amtArr = AUIGrid.getColumnValues(newGridID, "taxAmt", true);
    console.log(amtArr);
    for(var i = 0; i < amtArr.length; i++) {
        taxAmtCnt += amtArr[i];
    }
    // 0번째 행의 name 칼럼의 값 얻기
    var value = AUIGrid.getCellValue(newGridID, rowIndex, "taxAmt");
    console.log(taxAmtCnt);
    console.log(value);
    taxAmtCnt -= value;
    console.log("taxAmtCnt : " + taxAmtCnt);
    return taxAmtCnt;
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDown.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDown.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_selectWebInvoiceInfo(clmNo) {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/webInvoice/selectWebInvoiceInfo.do?_cacheId=" + Math.random(), obj, fn_setWebInvoiceInfo);
}

function fn_setWebInvoiceInfo(result) {
	$("#newClmNo").val(result.clmNo);
	$("#atchFileGrpId").val(result.atchFileGrpId);
	$("#newCostCenter").val(result.costCentr);
    $("#newCostCenterText").val(result.costCentrName);
    $("#newMemAccId").val(result.memAccId);
    $("#newMemAccName").val(result.memAccName);
    $("#bankCode").val(result.bankCode);
    $("#bankName").val(result.bankName);
    $("#bankAccNo").val(result.bankAccNo);
    $("#totAmt").val(result.totAmt);
    $("#crtUserId").val(result.crtUserId);
    $("#invcDt").val(result.invcDt);
    $("#keyDate").val(result.crtDt);
    $("#invcType").val(result.invcType);
    $("#invcNo").val(result.invcNo);
    $("#gstRgistNo").val(result.gstRgistNo);
    $("#payDueDt").val(result.payDueDt);
    $("#utilNo").val(result.utilNo);
    $("#invcRem").val(result.invcRem);
    
    AUIGrid.setGridData(newGridID, result.itemGrp);
    
    // TODO attachFile
    attachList = result.attachList;
    console.log(attachList);
    console.log(attachList.length);
    if(attachList.length > 0) {
        $("#attachTd").html("");
        for(var i = 0; i < attachList.length; i++) {
            if(result.appvPrcssNo == null || result.appvPrcssNo == "") {
                $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span></div>");
            } else {
                $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
            }
        }
        
        // 파일 다운
        $(".input_text").dblclick(function() {
            var oriFileName = $(this).val();
            var fileGrpId;
            var fileId;
            for(var i = 0; i < attachList.length; i++) {
                if(attachList[i].atchFileName == oriFileName) {
                    fileGrpId = attachList[i].atchFileGrpId;
                    fileId = attachList[i].atchFileId;
                }
            }
            fn_atchViewDown(fileGrpId, fileId);
        });
        // 파일 수정
        $("#form_newWebInvoice :file").change(function() {
            var div = $(this).parents(".auto_file2");
            var oriFileName = div.find(":text").val();
            console.log(oriFileName);
            for(var i = 0; i < attachList.length; i++) {
                if(attachList[i].atchFileName == oriFileName) {
                    update.push(attachList[i].atchFileId);
                    console.log(JSON.stringify(update));
                }
            }
        });
        // 파일 삭제
        $(".auto_file2 a:contains('Delete')").click(function() {
            var div = $(this).parents(".auto_file2");
            var oriFileName = div.find(":text").val();
            console.log(oriFileName);   
            for(var i = 0; i < attachList.length; i++) {
                if(attachList[i].atchFileName == oriFileName) {
                    remove.push(attachList[i].atchFileId);
                    console.log(JSON.stringify(remove));
                }
            }
        });
    }
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="webInvoice.title" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectWebInvoiceList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_webInvoice">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="costCenterText" name="costCenterText">

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
    <td><input type="text" title="" placeholder="" class="" style="width:200px" id="memAccId" name="memAccId"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
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
    <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
        <option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
        <option value="R"><spring:message code="webInvoice.select.request" /></option>
        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"></th>
    <td></td>
    <th scope="row"><spring:message code="invoiceApprove.clmNo" /></th>
    <td><input type="text" title="" placeholder="" class="" id="clmNo" name="clmNo"/></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="webInvoice.btn.registration" /></a></p></li>
    </c:if>
</ul>

<article class="grid_wrap" id="webInvoice _grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
