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
var pettyCashExpColumnLayout = [ {
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
    headerText : '<spring:message code="pettyCashRqst.appvalDt" />',
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
    headerHeight : 40,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var pettyCashExpGridID;

$(document).ready(function () {
	pettyCashExpGridID = AUIGrid.create("#expenseMgmt_grid_wrap", pettyCashExpColumnLayout, pettyCashExpGridPros);

    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click(fn_newExpensePop);
    $("#_pettyCashExpenseBtn").click(function() {

        //Param Set
        var gridObj = AUIGrid.getSelectedItems(pettyCashExpGridID);


        if(gridObj == null || gridObj.length <= 0 ){
            Common.alert("* No Record Selected. ");
            return;
        }

        var claimno = gridObj[0].item.clmNo;
        $("#_repClaimNo").val(claimno);
        console.log("clmNo : " + $("#_repClaimNo").val());

        fn_report();
        //Common.alert('The program is under development.');
    });

    AUIGrid.bind(pettyCashExpGridID, "cellDoubleClick", function( event )
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + event.item.clmNo);
                console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
                console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);
                // TODO detail popup open
                if(event.item.appvPrcssStusCode == "T") {
                	fn_viewExpensePop(event.item.clmNo);
                } else {
                	var clmNo = event.item.clmNo;
                    var clmType = clmNo.substr(0, 2);
                	fn_webInvoiceRequestPop(event.item.appvPrcssNo, clmType);
                }
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


function fn_clearData() {
    /* $("#form_newExpense").each(function() {
    	this.reset();
    }); */

    $("#invcDt").val("");
    $("#sMemAccName").val("");
    $("#gstRgistNo").val("");
    $("#invcType").val("F");
    $("#invcNo").val("");
    $("#expDesc").val("");
    $("#utilNo").val("");
    $("#jPayNo").val("")
    $("#bilPeriodF").val("")
    $("#bilPeriodT").val("")

    AUIGrid.destroy(myGridID);
    myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);

    fn_myGridSetEvent();

    $("#attachTd").html("");
    $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");

    clmSeq = 0;
}

function fn_setEvent() {
	$("#form_newExpense :text").change(function(){
        var id = $(this).attr("id");
        console.log(id);
        if(id == "newClmMonth") {
            var clmMonth = $(this).val();
            console.log(clmMonth);
            var month = clmMonth.substring(0, 2);
            var year = clmMonth.substring(3);
            console.log("year : " + year + " month : " + month);
            clmMonth = year + month;

            var now = new Date;
            var mm = now.getMonth() + 1;
            var yyyy = now.getFullYear();
            if(mm < 10){
                mm = "0" + mm
            }
            now = yyyy + "" + mm;
            console.log("yyyy : " + yyyy + " mm : " + mm);

            console.log(clmMonth);
            console.log(now);
            if(Number(clmMonth) > Number(now)) {
                Common.alert('<spring:message code="pettyCashExp.onlyPastDt.msg" />');
                $(this).val(mm + "/" + yyyy);
            }
        } else if(id == "gstRgistNo") {
        	if($("#invcType").val() == "F") {
        		var gstRgistNo = $(this).val();
                console.log(gstRgistNo);
                if(gstRgistNo.length != 12) {
                    Common.alert('Please insert 12 digits GST Registration No');
                    $("#gstRgistNo").val("");
                }
        	}
        }
   });
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_popSubSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"sPop",accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_PopExpenseTypeSearchPop() {
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J2'}, null, true, "expenseTypeSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

/* function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());

    if(fn_checkForCustdnNric()){
        // Approved Cash Amount GET and CUSTDN_NRIC GET
        var data = {
                memAccId : $("#newMemAccId").val(),
                costCentr : $("#newCostCenter").val()
        };
        console.log(data);
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log("fn_setPopCostCenter Action");
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(FormUtil.isEmpty(result.data)) {
                Common.alert('<spring:message code="pettyCashRqst.custdnNric.msg" />');
            } else {
            	if(!FormUtil.isEmpty(result.data.custdnNric)) {
                    var custdnNric = result.data.custdnNric;
                    $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
                }
            }
        });
    }
} */

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());

    if(fn_checkForCustdnNric()){
        // Approved Cash Amount GET and CUSTDN_NRIC GET
        var data = {
                memAccId : $("#newMemAccId").val(),
                //costCentr : $("#newCostCenter").val()
        };
        console.log(data);
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log("fn_setPopSupplier Action");
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(FormUtil.isEmpty(result.data)) {
                Common.alert('<spring:message code="pettyCashRqst.custdnNric.msg" />');
            } else {
            	$("#newCostCenter").val(result.data.costCentr);
            	$("#newCostCenterText").val(result.data.costCentrName);
            	if(!FormUtil.isEmpty(result.data.custdnNric)) {
                    var custdnNric = result.data.custdnNric;
                    $("#custdnNric").val(custdnNric.replace(/(\d{6})(\d{2})(\d{4})/, '$1-$2-$3'));
                }
            }
        });
    }
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
                    $("#bankCode").val(row.bankCode);
                    $("#bankName").val(row.bankName);
                    $("#bankAccNo").val(row.bankAccNo);
                }

                if(fn_checkForCustdnNric()){
                    // Approved Cash Amount GET and CUSTDN_NRIC GET
                    var data = {
                            memAccId : $("#newMemAccId").val(),
                            //costCentr : $("#newCostCenter").val()
                    };
                    console.log(data);
                    Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
                        console.log("fn_setPopSupplier Action");
                        console.log(result);
                        console.log(FormUtil.isEmpty(result.data));
                        if(FormUtil.isEmpty(result.data)) {
                            Common.alert('<spring:message code="pettyCashRqst.custdnNric.msg" />');
                        } else {
                            $("#newCostCenter").val(result.data.costCentr);
                            $("#newCostCenterText").val(result.data.costCentrName);
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

function fn_setPopSubSupplier() {
    $("#sMemAccId").val($("#search_memAccId").val());
    $("#sMemAccName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
}

function fn_setPopExpType() {
    console.log("Action");
    AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCode", $("#search_budgetCode").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCodeName", $("#search_budgetCodeName").val());

    AUIGrid.setCellValue(myGridID , selectRowIdx , "expType", $("#search_expType").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "expTypeName", $("#search_expTypeName").val());

    AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCode", $("#search_glAccCode").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCodeName", $("#search_glAccCodeName").val());
}

function fn_checkForCustdnNric() {
    var checkResult = true;
    /* if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    } */
    if(FormUtil.isEmpty($("#newMemAccId").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.custdn.msg" />');
        checkResult = false;
        return checkResult;
    }
    return checkResult;
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
    	Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccId").val())) {
    	Common.alert('<spring:message code="pettyCashCustdn.custdn.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newClmMonth").val())) {
        Common.alert('<spring:message code="pettyCashExp.clmMonth.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
        checkResult = false;
        return checkResult;
    }
    if($("#invcType").val() == "F") {
        if(FormUtil.isEmpty($("#sMemAccName").val())) {
            Common.alert('<spring:message code="webInvoice.supplier.msg" />');
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#invcNo").val())) {
        	Common.alert('<spring:message code="webInvoice.invcNo.msg" />');
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#gstRgistNo").val())) {
            Common.alert('Please enter GST Rgist No.');
            checkResult = false;
            return checkResult;
        }
        var length = AUIGrid.getGridData(myGridID).length;
        if(length > 0) {
            for(var i = 0; i < length; i++) {
            	if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "expTypeName"))) {
                    Common.alert('<spring:message code="webInvoice.expType.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "taxCode"))) {
                    Common.alert('<spring:message code="webInvoice.taxCode.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "gstBeforAmt"))) {
                    Common.alert('<spring:message code="pettyCashExp.amtBeforeGstOfLine.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
            }
        }
    }
    return checkResult;
}

function fn_selectExpenseList() {
    Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseList.do?_cacheId=" + Math.random(), $("#form_pettyCashExp").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(pettyCashExpGridID, result);
    });
}

function fn_newExpensePop() {
    Common.popupDiv("/eAccounting/pettyCash/newExpensePop.do", {callType:"new"}, null, true, "newExpensePop");
}

function fn_addMyGridRow() {
	if(AUIGrid.getRowCount(myGridID) > 0) {
		AUIGrid.addRow(myGridID, {clamUn:AUIGrid.getCellValue(myGridID, 0, "clamUn"),cur:"MYR",gstBeforAmt:0,gstAmt:0,nonClmGstAmt:0,totAmt:0}, "last");
	} else {
		Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J2"}, function(result) {
            console.log(result);
            AUIGrid.addRow(myGridID, {clamUn:result.clamUn,cur:"MYR",gstBeforAmt:0,gstAmt:0,nonClmGstAmt:0,totAmt:0}, "last");
        });
	}
}

function fn_removeMyGridRow() {
    AUIGrid.removeRow(myGridID, selectRowIdx);
}

function fn_addRow() {
    // 파일 업로드 전에 필수 값 체크
    // 파일 업로드 후 그룹 아이디 값을 받아서 Add
    if(fn_checkEmpty()) {
        var formData = Common.getFormData("form_newExpense");
        if(clmSeq == 0) {
        	var data = {
                    costCentr : $("#newCostCenter").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,memAccId : $("#newMemAccId").val()
                    ,custdnNric : $("#custdnNric").val()
                    ,bankCode : $("#bankCode").val()
                    ,bankAccNo : $("#bankAccNo").val()
                    ,clmMonth : $("#newClmMonth").val()
                    ,sMemAccId : $("#sMemAccId").val()
                    ,sMemAccName : $("#sMemAccName").val()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,invcNo : $("#invcNo").val()
                    ,invcDt : $("#invcDt").val()
                    ,cur : "MYR"
                    ,expDesc : $("#expDesc").val()
                    ,utilNo : $("#utilNo").val()
                    ,jPayNo : $("#jPayNo").val()
                    ,bilPeriodF : $("#bilPeriodF").val()
                    ,bilPeriodT : $("#bilPeriodT").val()
                    ,gridData : GridCommon.getEditData(myGridID)
            };

        	Common.ajaxFile("/eAccounting/pettyCash/attachFileUpload.do", formData, function(result) {
                console.log(result);

                data.atchFileGrpId = result.data.fileGroupKey
                console.log(data);

                if(data.gridData.add.length > 0) {
                	for(var i = 0; i < data.gridData.add.length; i++) {
                		data.gridData.add[i].costCentr = data.costCentr;
                		data.gridData.add[i].costCentrName = data.costCentrName;
                		data.gridData.add[i].memAccId = data.memAccId;
                		data.gridData.add[i].custdnNric = data.custdnNric;
                		data.gridData.add[i].bankCode = data.bankCode;
                		data.gridData.add[i].bankAccNo = data.bankAccNo;
                		data.gridData.add[i].clmMonth = data.clmMonth;
                		data.gridData.add[i].sMemAccId = data.sMemAccId;
                		data.gridData.add[i].sMemAccName = data.sMemAccName;
                		data.gridData.add[i].gstRgistNo = data.gstRgistNo;
                		data.gridData.add[i].invcDt = data.invcDt;
                		data.gridData.add[i].invcNo = data.invcNo;
                		data.gridData.add[i].invcType = data.invcType;
                		data.gridData.add[i].invcTypeName = data.invcTypeName;
                		data.gridData.add[i].cur = data.cur;
                		data.gridData.add[i].expDesc = data.expDesc;
                		data.gridData.add[i].utilNo = data.utilNo;
                		data.gridData.add[i].jPayNo = data.jPayNo;
                		data.gridData.add[i].bilPeriodF = data.bilPeriodF;
                		data.gridData.add[i].bilPeriodT = data.bilPeriodT;
                		data.gridData.add[i].atchFileGrpId = data.atchFileGrpId;
                		AUIGrid.addRow(newGridID, data.gridData.add[i], "last");
                	}
                }

                fn_getAllTotAmt();
            });
        } else {
        	var data = {
        			costCentr : $("#newCostCenter").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,memAccId : $("#newMemAccId").val()
                    ,custdnNric : $("#custdnNric").val()
                    ,bankCode : $("#bankCode").val()
                    ,bankAccNo : $("#bankAccNo").val()
                    ,clmMonth : $("#newClmMonth").val()
                    ,sMemAccId : $("#sMemAccId").val()
                    ,sMemAccName : $("#sMemAccName").val()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,invcNo : $("#invcNo").val()
                    ,invcDt : $("#invcDt").val()
                    ,cur : "MYR"
                    ,expDesc : $("#expDesc").val()
                    ,utilNo : $("#utilNo").val()
                    ,jPayNo : $("#jPayNo").val()
                    ,bilPeriodF : $("#bilPeriodF").val()
                    ,bilPeriodT : $("#bilPeriodT").val()
                    ,gridData : GridCommon.getEditData(myGridID)
            };

            $("#attachTd").html("");
            $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");

        	formData.append("atchFileGrpId", atchFileGrpId);
        	formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        	Common.ajaxFile("/eAccounting/pettyCash/attachFileUpdate.do", formData, function(result) {
                console.log(result);

                console.log(data);

                if(data.gridData.add.length > 0) {
                    for(var i = 0; i < data.gridData.add.length; i++) {
                        data.gridData.add[i].costCentr = data.costCentr;
                        data.gridData.add[i].costCentrName = data.costCentrName;
                        data.gridData.add[i].memAccId = data.memAccId;
                        data.gridData.add[i].custdnNric = data.custdnNric;
                        data.gridData.add[i].bankCode = data.bankCode;
                        data.gridData.add[i].bankAccNo = data.bankAccNo;
                        data.gridData.add[i].clmMonth = data.clmMonth;
                        data.gridData.add[i].sMemAccId = data.sMemAccId;
                        data.gridData.add[i].sMemAccName = data.sMemAccName;
                        data.gridData.add[i].gstRgistNo = data.gstRgistNo;
                        data.gridData.add[i].invcDt = data.invcDt;
                        data.gridData.add[i].invcNo = data.invcNo;
                        data.gridData.add[i].invcType = data.invcType;
                        data.gridData.add[i].invcTypeName = data.invcTypeName;
                        data.gridData.add[i].cur = data.cur;
                        data.gridData.add[i].expDesc = data.expDesc;
                        data.gridData.add[i].utilNo = data.utilNo;
                        data.gridData.add[i].jPayNo = data.jPayNo;
                        data.gridData.add[i].bilPeriodF = data.bilPeriodF;
                        data.gridData.add[i].bilPeriodT = data.bilPeriodT;
                        data.gridData.add[i].atchFileGrpId = atchFileGrpId;
                        AUIGrid.addRow(newGridID, data.gridData.add[i], "last");
                    }
                }
                if(data.gridData.update.length > 0) {
                    for(var i = 0; i < data.gridData.update.length; i++) {
                        data.gridData.update[i].costCentr = data.costCentr;
                        data.gridData.update[i].costCentrName = data.costCentrName;
                        data.gridData.update[i].memAccId = data.memAccId;
                        data.gridData.update[i].custdnNric = data.custdnNric;
                        data.gridData.update[i].bankCode = data.bankCode;
                        data.gridData.update[i].bankAccNo = data.bankAccNo;
                        data.gridData.update[i].clmMonth = data.clmMonth;
                        data.gridData.update[i].sMemAccId = data.sMemAccId;
                        data.gridData.update[i].sMemAccName = data.sMemAccName;
                        data.gridData.update[i].gstRgistNo = data.gstRgistNo;
                        data.gridData.update[i].invcDt = data.invcDt;
                        data.gridData.update[i].invcNo = data.invcNo;
                        data.gridData.update[i].invcType = data.invcType;
                        data.gridData.update[i].invcTypeName = data.invcTypeName;
                        data.gridData.update[i].cur = data.cur;
                        data.gridData.update[i].expDesc = data.expDesc;
                        data.gridData.update[i].utilNo = data.utilNo;
                        data.gridData.update[i].jPayNo = data.jPayNo;
                        data.gridData.update[i].bilPeriodF = data.bilPeriodF;
                        data.gridData.update[i].bilPeriodT = data.bilPeriodT;
                        AUIGrid.updateRow(newGridID, data.gridData.update[i], AUIGrid.rowIdToIndex(newGridID, data.gridData.update[i].clmSeq));
                    }
                }
                if(data.gridData.remove.length > 0) {
                    for(var i = 0; i < data.gridData.remove.length; i++) {
                    	AUIGrid.removeRow(newGridID, AUIGrid.rowIdToIndex(newGridID, data.gridData.remove[i].clmSeq));
                    }
                }

                fn_getAllTotAmt();

                clmSeq = 0;
            });
        }

        fn_clearData();
    }
}

function fn_getAllTotAmt() {
	// allTotAmt GET, SET
    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues (newGridID, "totAmt", true);
    console.log(totAmtList.length);
    for(var i = 0; i < totAmtList.length; i++) {
        allTotAmt += totAmtList[i];
    }
    console.log($.number(allTotAmt,2,'.',''));
    allTotAmt = $.number(allTotAmt,2,'.',',');
    //allTotAmt += "";
    console.log(allTotAmt);
    //$("#allTotAmt_text").text(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    $("#allTotAmt_text").text(allTotAmt);
}

function fn_insertPettyCashExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var data = {
                gridDataList : gridDataList
                ,allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
        }
        console.log(data);
        Common.ajax("POST", "/eAccounting/pettyCash/insertPettyCashExp.do", data, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectExpenseItemList();
            if(st == "new"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#newExpensePop").remove();
            }
            fn_selectExpenseList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_selectExpenseItemList() {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseItemList.do", obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

function fn_selectExpenseInfo() {
    var obj = {
            clmNo : clmNo
            ,clmSeq : clmSeq
            ,clamUn : clamUn
    };
    Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseInfo.do?_cacheId=" + Math.random(), obj, function(result) {
        console.log(result);
        $("#newCostCenter").val(result.costCentr);
        $("#newCostCenterText").val(result.costCentrName);
        $("#newMemAccId").val(result.memAccId);
        $("#newMemAccName").val(result.memAccName);
        $("#custdnNric").val(result.custdnNric);
        $("#bankCode").val(result.bankCode);
        $("#bankName").val(result.bankName);
        $("#bankAccNo").val(result.bankAccNo);
        $("#newClmMonth").val(result.clmMonth);
        $("#sMemAccId").val(result.sMemAccId);
        $("#sMemAccName").val(result.sMemAccName);
        $("#invcType").val(result.invcType);
        $("#invcNo").val(result.invcNo);
        $("#invcDt").val(result.invcDt);
        $("#gstRgistNo").val(result.gstRgistNo);
        $("#expDesc").val(result.expDesc);
        $("#utilNo").val(result.utilNo);
        $("#jPayNo").val(result.jPayNo);
        $("#bilPeriodF").val(result.bilPeriodF);
        $("#bilPeriodT").val(result.bilPeriodT);
        $("#newCrtUserId").val(result.crtUserId);
        $("#newCrtUserName").val(result.userName);

        AUIGrid.setGridData(myGridID, result.itemGrp);

        // TODO attachFile
        attachList = result.attachList;
        console.log(attachList);
        if(attachList) {
        	if(attachList.length > 0) {
                $("#attachTd").html("");
                for(var i = 0; i < attachList.length; i++) {
                    if(result.appvPrcssNo == null || result.appvPrcssNo == "") {
                        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span></div>");
                    } else {
                    	//$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' /></div>");
                        $(".input_text").val(attachList[i].atchFileName);
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
                $("#form_newExpense :file").change(function() {
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
    });
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_viewExpensePop(clmNo) {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };
    Common.popupDiv("/eAccounting/pettyCash/viewExpensePop.do", data, null, true, "viewExpensePop");
}

function fn_updatePettyCashExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
    	var gridDataObj = GridCommon.getEditData(newGridID);
    	gridDataObj.clmNo = clmNo;
        gridDataObj.allTotAmt = Number($("#allTotAmt_text").text().replace(/,/gi, ""));
        console.log(gridDataObj);
        Common.ajax("POST", "/eAccounting/pettyCash/updatePettyCashExp.do", gridDataObj, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectExpenseItemList();
            if(st == "view"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#viewExpensePop").remove();
            }
            fn_selectExpenseList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_expApproveLinePop() {
    // tempSave를 하지 않고 바로 submit인 경우
    if(FormUtil.isEmpty(clmNo)) {
        fn_insertPettyCashExp("");
    } else {
        // 바로 submit 후에 appvLinePop을 닫고 재수정 대비
    	fn_updatePettyCashExp("");
    }

    Common.popupDiv("/eAccounting/pettyCash/expApproveLinePop.do", null, null, true, "approveLineSearchPop");
}

function fn_deletePettyCashExp() {
	// Grid Row 삭제
    AUIGrid.removeRow(newGridID, deleteRowIdx);

    fn_getAllTotAmt();
    var data = {
            clmNo : clmNo,
            clmSeq : clmSeq,
            atchFileGrpId : atchFileGrpId,
            allTotAmt : $("#allTotAmt_text").text().replace(/,/gi, "")
    };
    console.log(data);
    Common.ajax("POST", "/eAccounting/pettyCash/deletePettyCashExp.do", data, function(result) {
        console.log(result);

        // function 호출 안되서 ajax 직접호출
        //fn_selectExpenseList();
        Common.ajax("GET", "/eAccounting/pettyCash/selectExpenseList.do?_cacheId=" + Math.random(), $("#form_pettyCashExp").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(pettyCashExpGridID, result);
        });
    });
}

function fn_selectTaxRate() {
    var data = {
            taxCode : $("#taxCode").val()
    };
    Common.ajax("GET", "/eAccounting/webInvoice/selectTaxRate.do", data, function(result) {
        console.log(result);
        $("#taxRate").val(result.taxRate);
    });
}

function fn_myGridSetEvent() {
	AUIGrid.bind(myGridID, "cellClick", function( event )
            {
                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                selectRowIdx = event.rowIndex;
            });

    AUIGrid.bind(myGridID, "cellEditBegin", function( event ) {
        // return false; // false, true 반환으로 동적으로 수정, 편집 제어 가능
        if($("#invcType").val() == "S") {
            if(event.dataField == "nonClmGstAmt") {
                if(event.item.taxAmt <= 30) {
                    Common.alert('<spring:message code="newWebInvoice.gstLess.msg" />');
                    AUIGrid.forceEditingComplete(myGridID, null, true);
                }
            }
        } else {
            if(event.dataField == "nonClmGstAmt") {
                Common.alert('<spring:message code="newWebInvoice.gstFullTax.msg" />');
                AUIGrid.forceEditingComplete(myGridID, null, true);
            }
        }
  });

    AUIGrid.bind(myGridID, "cellEditEnd", function( event ) {
        if(event.dataField == "gstBeforAmt" || event.dataField == "gstAmt" || event.dataField == "nonClmGstAmt") {
            var taxAmt = 0;
            var taxNonClmAmt = 0;
            if($("#invcType").val() == "S") {
                if(event.dataField == "gstBeforAmt") {
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
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", taxAmt);
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "nonClmGstAmt", taxNonClmAmt);
                }
                if(event.dataField == "gstAmt") {
                    if(event.value > 30) {
                        Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
                        AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", event.oldValue);
                    } else {
                        var taxAmtCnt = fn_getTotTaxAmt(event.rowIndex);
                        if((taxAmtCnt + event.value) > 30) {
                            Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
                            AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", event.oldValue);
                        }
                    }
                }
            } else {
                if(event.dataField == "gstBeforAmt") {
                    taxAmt = event.item.oriTaxAmt;
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", taxAmt);
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "nonClmGstAmt", taxNonClmAmt);
                }
            }
        }
        if(event.dataField == "taxCode") {
            console.log("taxCode Choice Action");
            console.log(event.item.taxCode);
            var data = {
                    taxCode : event.item.taxCode
            };
            Common.ajax("GET", "/eAccounting/webInvoice/selectTaxRate.do", data, function(result) {
                console.log(result);
                AUIGrid.setCellValue(myGridID, event.rowIndex, "taxRate", result.taxRate);
                AUIGrid.setCellValue(myGridID, event.rowIndex, "taxName", result.taxName);
            });
        }
  });
}

function fn_getTotTaxAmt(rowIndex) {
    var taxAmtCnt = 0;
    // 필터링이 된 경우 필터링 된 상태의 값만 원한다면 false 지정
    var amtArr = AUIGrid.getColumnValues(myGridID, "gstAmt", true);
    console.log(amtArr);
    for(var i = 0; i < amtArr.length; i++) {
        taxAmtCnt += amtArr[i];
    }
    // 0번째 행의 name 칼럼의 값 얻기
    var value = AUIGrid.getCellValue(myGridID, rowIndex, "gstAmt");
    console.log(taxAmtCnt);
    console.log(value);
    taxAmtCnt -= value;
    console.log("taxAmtCnt : " + taxAmtCnt);
    return taxAmtCnt;
}

function fn_webInvoiceRequestPop(appvPrcssNo, clmType) {
    var data = {
    		clmType : clmType
            ,appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/webInvoiceRqstViewPop.do", data, null, true, "webInvoiceRqstViewPop");
}

function fn_report() {
    var option = {
        isProcedure : true
    };
    Common.report("dataForm", option);
}


</script>

<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/PettyCashExpense.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="123123" /> --><!-- Download Name -->

    <!-- params -->
    <input type="hidden" id="_repClaimNo" name="V_CLAIMNO" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="pettyCashExp.title" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectExpenseList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_pettyCashExp">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="costCenterText" name="costCenterText">

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
    <td><input type="text" title="" placeholder="" class="" id="costCenter" name="costCenter"/><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row"><spring:message code="pettyCashCustdn.custdn" /></th>
    <td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
    <td><input type="text" title="Reference Month" placeholder="MM/YYYY" class="j_date2 w100p" id="clmMonth" name="clmMonth"/></td>
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

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="link_btn"><a href="#" id="_pettyCashExpenseBtn">Petty Cash Slip</a></p></li>
            </c:if>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="pettyCashExp.newExpClm" /></a></p></li>
    </c:if>
</ul>

<article class="grid_wrap" id="expenseMgmt_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->