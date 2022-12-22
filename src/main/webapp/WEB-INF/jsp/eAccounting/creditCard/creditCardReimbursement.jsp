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
var totalExpAmt = 0;
var clickType = "";
var clmNo = "";
var reimbursementColumnLayout = [ {
    dataField : "crditCardUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserName",
    headerText : '<spring:message code="crditCardReim.cardholder" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "crditCardNo",
    headerText : '<spring:message code="crditCardReim.cardNo" />'
}, {
    dataField : "chrgUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "chrgUserName",
    headerText : '<spring:message code="crditCardReim.chargeName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.costCenter" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="webInvoice.costCenter" />',
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
    headerText : '<spring:message code="webInvoice.requestDate" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "allTotAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appvPrcssNo",
    visible : false
}, {
    dataField : "appvPrcssStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="crditCardReim.appvalDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

var excelColumnLayout = [ {
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

//그리드 속성 설정
var reimbursementGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var excelGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var reimbursementGridID;
var excelGridID;

$(document).ready(function () {
    $("#appvPrcssStus").multipleSelect("checkAll");
	reimbursementGridID = AUIGrid.create("#reimbursement_grid_wrap", reimbursementColumnLayout, reimbursementGridPros);
	excelGridID = AUIGrid.create("#excel_grid_wrap", excelColumnLayout, excelGridPros);

    $("#search_holder_btn").click(function() {
        clickType = "holder";
        fn_searchUserIdPop();
    });
    $("#search_charge_btn").click(function() {
        clickType = "charge";
        fn_searchUserIdPop();
    });
    $("#search_depart_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click(fn_newReimbursementPop);

    AUIGrid.bind(reimbursementGridID, "cellDoubleClick", function( event )
            {
                console.log("cellDoubleClick rowIndex : " + event.rowIndex + ", cellDoubleClick : " + event.columnIndex + " cellDoubleClick");
                console.log("cellDoubleClick clmNo : " + event.item.clmNo);
                console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
                console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);
                clmNo = event.item.clmNo;
                // TODO detail popup open
                if(event.item.appvPrcssStusCode == "T") {
                    fn_viewReimbursementPop();
                } else {
                	clmNo = event.item.clmNo;
                    var clmType = clmNo.substr(0, 2);
                	fn_webInvoiceRequestPop(event.item.appvPrcssNo, clmType);
                }
            });


        $("#_ExpSlipBtn").click(function() {

        var gridObj = AUIGrid.getSelectedItems(reimbursementGridID);

        if(gridObj == null || gridObj.length <= 0 )
        {
            Common.alert("* No Value Selected. ");

            return;
        }

        var clmNo = gridObj[0].item.clmNo;

        $("#_clmNo").val(clmNo);
        console.log("clmNo : " + $("#_clmNo").val());

        fn_report();

    });

    $("#editRejBtn").click(fn_editRejected);

    fn_setToDay();

    if('${clmNo}' != null && '${clmNo}' != "") {
        $("#startDt").val("");
        $("#endDt").val("");

        $("#clmNo").val('${clmNo}');

        fn_selectReimbursementList();
   }
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

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
}

// 그리드에 set 하는 function
function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            console.log(memInfo);
            console.log(memInfo.memCode);
            console.log(memInfo.name);
            console.log(clickType);
            if(clickType == "holder") {
                $("#crditCardUserId").val(memInfo.memCode);
                $("#crditCardUserName").val(memInfo.name);
            } else if(clickType == "charge") {
                $("#chrgUserId").val(memInfo.memCode);
                $("#chrgUserName").val(memInfo.name);
            }
        }
    });
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_selectReimbursementList() {
    Common.ajax("GET", "/eAccounting/creditCard/selectReimbursementList.do?_cacheId=" + Math.random(), $("#form_reimbursement").serialize(), function(result) {
            //Common.ajax("GET", "/eAccounting/creditCard/selectExcelList.do?_cacheId=" + Math.random(), $("#form_reimbursement").serialize(), function(result2) {
		        console.log(result);
		        AUIGrid.setGridData(reimbursementGridID, result);
		        //AUIGrid.setGridData(excelGridID, result2);
            //});
    });
}

function fn_newReimbursementPop() {
    Common.popupDiv("/eAccounting/creditCard/newReimbursementPop.do", {callType:"new"}, null, true, "newReimbursementPop");
}

function fn_clearData() {
    /* $("#form_newReimbursement").each(function() {
        this.reset();
    }); */

    //$("#newCrditCardNo").val("");

    $("#invcDt").val("");
    $("#newSupplyName").val("");
    $("#gstRgistNo").val("");
    $("#invcType").val("F");
    $("#invcNo").val("");
    $("#expDesc").val("");
    $("#sCostCentr").val("");
    $("#sCostCentrName").val("");

    AUIGrid.destroy(myGridID);
    myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);

    fn_myGridSetEvent();

    $("#attachTd").html("");
    $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");

    clmSeq = 0;
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setPopCostCenter() {
    $("#sCostCentr").val($("#search_costCentr").val());
    $("#sCostCentrName").val($("#search_costCentrName").val());
}

function fn_setCostCenterEvent() {
    $("#sCostCentr").change(function(){
        var costCenter = $(this).val();
        console.log(costCenter);
        if(!FormUtil.isEmpty(costCenter)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:costCenter}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#sCostCentrName").val(row.costCenterText);
                }
            });
        }
   });
}

function fn_PopExpenseTypeSearchPop() {
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J3'}, null, true, "expenseTypeSearchPop");
}

function fn_setPopExpType() {
    console.log("Action");
    AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCode", $("#search_budgetCode").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCodeName", $("#search_budgetCodeName").val());

    AUIGrid.setCellValue(myGridID , selectRowIdx , "expType", $("#search_expType").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "expTypeName", $("#search_expTypeName").val());

    AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCode", $("#search_glAccCode").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCodeName", $("#search_glAccCodeName").val());
    AUIGrid.setCellValue(myGridID , selectRowIdx , "cntrlExp", $("#search_cntrlExp").val());
    console.log("Step 2: " + $("#search_cntrlExp").val());
    $("#cntrlExp").val($("#search_cntrlExp").val());
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_setSupplier() {
    $("#newSupply").val($("#search_memAccId").val());
    $("#newSupplyName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
}

function fn_setEvent() {
    $("#form_newReimbursement :text").change(function(){
        var id = $(this).attr("id");
        console.log(id);
        if(id == "clmMonth") {
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
        } else if(id == "sCostCentr") {
            if(!FormUtil.isEmpty($("#sCostCentr").val())){
            	Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:$("#sCostCentr").val()}, function(result) {
                    console.log(result);
                    if(result.length > 0) {
                        var row = result[0];
                        console.log(row);
                        $("#sCostCentrName").val(row.costCenterText);
                    }
                });
            }
        } /*else if(id == "gstRgistNo") {
        	if($("#invcType").val() == "F") {
                var gstRgistNo = $(this).val();
                console.log(gstRgistNo);
                if(gstRgistNo.length != 12) {
                    Common.alert('Please insert 12 digits GST Registration No');
                    $("#gstRgistNo").val("");
                }
            }
        }*/
   });
}

function fn_creditCardNoChange() {
	console.log("fn_creditCardNoChange() Action");
	if(!FormUtil.isEmpty($("#newCrditCardNo").val())) {
		Common.ajaxSync("GET", "/eAccounting/creditCard/selectCrditCardInfoByNo.do", {crditCardNo:$("#newCrditCardNo").val()}, function(result) {
	        console.log(result);
	        if(result.data) {
	            $("#newCrditCardUserId").val(result.data.crditCardUserId);
	            $("#newCrditCardUserName").val(result.data.crditCardUserName);
	            $("#newChrgUserId").val(result.data.chrgUserId);
	            $("#newChrgUserName").val(result.data.chrgUserName);
	            $("#newCostCenter").val(result.data.costCentr);
	            $("#newCostCenterText").val(result.data.costCentrName);
	            $("#bankCode").val(result.data.bankCode);
	            $("#bankName").val(result.data.bankName);
	            $("#sCardSeq").val(result.data.crditCardSeq);
	            $("#cardControlYN").val(result.data.cntrlCard);
	        } else {
	            Common.alert('<spring:message code="crditCardReim.noData.msg" />');
	            $("#newCrditCardUserId").val("");
	            $("#newCrditCardUserName").val("");
	            $("#newChrgUserId").val("");
	            $("#newChrgUserName").val("");
	            $("#newCostCenter").val("");
	            $("#newCostCenterText").val("");
	            $("#bankCode").val("");
	            $("#bankName").val("");
	        }
	    });
	} else {
        $("#newCrditCardUserId").val("");
        $("#newCrditCardUserName").val("");
        $("#newChrgUserId").val("");
        $("#newChrgUserName").val("");
        $("#newCostCenter").val("");
        $("#newCostCenterText").val("");
        $("#bankCode").val("");
        $("#bankName").val("");
	}
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCrditCardNo").val())) {
        Common.alert('<spring:message code="crditCardMgmt.crditCardNo.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#clmMonth").val())) {
        Common.alert('<spring:message code="pettyCashExp.clmMonth.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#sCostCentr").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    //if($("#invcType").val() == "F") {
        if(FormUtil.isEmpty($("#newSupplyName").val())) {
            Common.alert('<spring:message code="crditCardReim.supplierName.msg" />');
            checkResult = false;
            return checkResult;
        }
        if(FormUtil.isEmpty($("#invcNo").val())) {
        	Common.alert('<spring:message code="webInvoice.invcNo.msg" />');
            checkResult = false;
            return checkResult;
        }
        /*if(FormUtil.isEmpty($("#gstRgistNo").val())) {
            Common.alert('Please enter GST Rgist No.');
            checkResult = false;
            return checkResult;
        }*/
        //
        if(FormUtil.isEmpty($("#expDesc").val())) {
            Common.alert('Please enter remark.');
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
                /*if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "taxCode"))) {
                    Common.alert('<spring:message code="webInvoice.taxCode.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }*/
                if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "totAmt")) || AUIGrid.getCellValue(myGridID, i, "totAmt") <= 0) { //gstBeforAmt
                    //Common.alert('<spring:message code="pettyCashExp.amtBeforeGstOfLine.msg" />' + (i +1) + ".");
                    Common.alert('Please enter amount for detail line' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
            }
        }
    //}
    return checkResult;
}

function fn_addMyGridRow() {
    if(AUIGrid.getRowCount(myGridID) > 0) {
        //AUIGrid.addRow(myGridID, {clamUn:AUIGrid.getCellValue(myGridID, 0, "clamUn"),cur:"MYR",netAmt:0,taxAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
        AUIGrid.addRow(myGridID, {clamUn:AUIGrid.getCellValue(myGridID, 0, "clamUn"),taxCode:"OP (Purchase(0%):Out of scope)",cur:"MYR",totAmt:0}, "last");
    } else {
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J3"}, function(result) {
            console.log(result);
            //AUIGrid.addRow(myGridID, {clamUn:result.clamUn,cur:"MYR",netAmt:0,taxAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
            AUIGrid.addRow(myGridID, {clamUn:result.clamUn,taxCode:"OP (Purchase(0%):Out of scope)",cur:"MYR",totAmt:0}, "last");
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
        var formData = Common.getFormData("form_newReimbursement");
        console.log("c1: " + c1);

        if(c1 != 0 || c2 != 0 || c3 != 0 || c4 != 0 || c5 != 0 || c6 != 0) {
            var data = {
                    bankCode : $("#bankCode").val()
                    ,bankName : $("#bankName").val()
                    ,crditCardUserId : $("#newCrditCardUserId").val()
                    ,crditCardUserName : $("#newCrditCardUserName").val()
                    ,crditCardNo : $("#newCrditCardNo").val()
                    ,chrgUserId : $("#newChrgUserId").val()
                    ,chrgUserName : $("#newChrgUserName").val()
                    ,costCentr : $("#newCostCenter").val()
                    ,clmMonth : $("#clmMonth").val()
                    ,invcDt : $("#invcDt").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,sCostCentr : $("#sCostCentr").val()
                    ,sCostCentrName : $("#sCostCentrName").val()
                    ,supply : $("#newSupply").val()
                    ,supplyName : $("#newSupplyName").val()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,invcNo : $("#invcNo").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,cur : "MYR"
                    ,expDesc : $("#expDesc").val()
                    ,gridData : GridCommon.getEditData(myGridID)//AUIGrid.getGridData(myGridID)
            };
        } else {
            var data = {
                    bankCode : $("#bankCode").val()
                    ,bankName : $("#bankName").val()
                    ,crditCardUserId : $("#newCrditCardUserId").val()
                    ,crditCardUserName : $("#newCrditCardUserName").val()
                    ,crditCardNo : $("#newCrditCardNo").val()
                    ,chrgUserId : $("#newChrgUserId").val()
                    ,chrgUserName : $("#newChrgUserName").val()
                    ,costCentr : $("#newCostCenter").val()
                    ,clmMonth : $("#clmMonth").val()
                    ,invcDt : $("#invcDt").val()
                    ,costCentrName : $("#newCostCenterText").val()
                    ,sCostCentr : $("#sCostCentr").val()
                    ,sCostCentrName : $("#sCostCentrName").val()
                    ,supply : $("#newSupply").val()
                    ,supplyName : $("#newSupplyName").val()
                    ,gstRgistNo : $("#gstRgistNo").val()
                    ,invcNo : $("#invcNo").val()
                    ,invcType : $("#invcType").val()
                    ,invcTypeName : $("#invcType option:selected").text()
                    ,cur : "MYR"
                    ,expDesc : $("#expDesc").val()
                    ,gridData : GridCommon.getEditData(myGridID)
            };
        }

        if(clmSeq == 0) {
            Common.ajaxFile("/eAccounting/creditCard/attachFileUpload.do", formData, function(result) {
                console.log(result);

                data.atchFileGrpId = result.data.fileGroupKey
                console.log(data);
                if(data.gridData.add.length > 0) {
                    for(var i = 0; i < data.gridData.add.length; i++) {
                        data.gridData.add[i].bankCode = data.bankCode;
                        data.gridData.add[i].bankName = data.bankName;
                        data.gridData.add[i].crditCardNo = data.crditCardNo;
                        data.gridData.add[i].crditCardUserId = data.crditCardUserId;
                        data.gridData.add[i].crditCardUserName = data.crditCardUserName;
                        data.gridData.add[i].chrgUserId = data.chrgUserId;
                        data.gridData.add[i].chrgUserName = data.chrgUserName;
                        data.gridData.add[i].costCentr = data.costCentr;
                        data.gridData.add[i].costCentrName = data.costCentrName;
                        data.gridData.add[i].sCostCentr = data.sCostCentr;
                        data.gridData.add[i].sCostCentrName = data.sCostCentrName;
                        data.gridData.add[i].clmMonth = data.clmMonth;
                        data.gridData.add[i].supply = data.supply;
                        data.gridData.add[i].supplyName = data.supplyName;
                        data.gridData.add[i].gstRgistNo = data.gstRgistNo;
                        data.gridData.add[i].invcDt = data.invcDt;
                        data.gridData.add[i].invcNo = data.invcNo;
                        data.gridData.add[i].invcType = data.invcType;
                        data.gridData.add[i].invcTypeName = data.invcTypeName;
                        data.gridData.add[i].cur = data.cur;
                        data.gridData.add[i].expDesc = data.expDesc;
                        data.gridData.add[i].atchFileGrpId = data.atchFileGrpId;
                        data.gridData.add[i].taxCode = "VB";
                        data.gridData.add[i].taxName = "OP (Purchase(0%):Out of scope)";
                        if(fn_checkCreditLimit(data.gridData.add[i]))
                        {
                            AUIGrid.addRow(newGridID, data.gridData.add[i], "last");
                            fn_clearData();
                        }
                    }
                    //fn_clearData();
                }

                fn_getAllTotAmt();
            });
        } else {
            $("#attachTd").html("");
            $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");

            formData.append("atchFileGrpId", atchFileGrpId);
            formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
            formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
            Common.ajaxFile("/eAccounting/creditCard/attachFileUpdate.do", formData, function(result) {
                console.log(result);

                console.log(data);

                if(data.gridData.add.length > 0) {
                    for(var i = 0; i < data.gridData.add.length; i++) {
                    	data.gridData.add[i].bankCode = data.bankCode;
                        data.gridData.add[i].bankName = data.bankName;
                        data.gridData.add[i].crditCardNo = data.crditCardNo;
                        data.gridData.add[i].crditCardUserId = data.crditCardUserId;
                        data.gridData.add[i].crditCardUserName = data.crditCardUserName;
                        data.gridData.add[i].chrgUserId = data.chrgUserId;
                        data.gridData.add[i].chrgUserName = data.chrgUserName;
                        data.gridData.add[i].costCentr = data.costCentr;
                        data.gridData.add[i].costCentrName = data.costCentrName;
                        data.gridData.add[i].sCostCentr = data.sCostCentr;
                        data.gridData.add[i].sCostCentrName = data.sCostCentrName;
                        data.gridData.add[i].clmMonth = data.clmMonth;
                        data.gridData.add[i].supply = data.supply;
                        data.gridData.add[i].supplyName = data.supplyName;
                        data.gridData.add[i].gstRgistNo = data.gstRgistNo;
                        data.gridData.add[i].invcDt = data.invcDt;
                        data.gridData.add[i].invcNo = data.invcNo;
                        data.gridData.add[i].invcType = data.invcType;
                        data.gridData.add[i].invcTypeName = data.invcTypeName;
                        data.gridData.add[i].cur = data.cur;
                        data.gridData.add[i].expDesc = data.expDesc;
                        data.gridData.add[i].atchFileGrpId = atchFileGrpId;
                        if(fn_checkCreditLimit(data.gridData.add[i]))
                        {
                        	AUIGrid.addRow(newGridID, data.gridData.add[i], "last");
                        }
                    }
                    fn_clearData();
                }

                if(data.gridData.update.length > 0) {
                    for(var i = 0; i < data.gridData.update.length; i++) {
                    	data.gridData.update[i].bankCode = data.bankCode;
                        data.gridData.update[i].bankName = data.bankName;
                        data.gridData.update[i].crditCardNo = data.crditCardNo;
                        data.gridData.update[i].crditCardUserId = data.crditCardUserId;
                        data.gridData.update[i].crditCardUserName = data.crditCardUserName;
                        data.gridData.update[i].chrgUserId = data.chrgUserId;
                        data.gridData.update[i].chrgUserName = data.chrgUserName;
                        data.gridData.update[i].costCentr = data.costCentr;
                        data.gridData.update[i].costCentrName = data.costCentrName;
                        data.gridData.update[i].sCostCentr = data.sCostCentr;
                        data.gridData.update[i].sCostCentrName = data.sCostCentrName;
                        data.gridData.update[i].clmMonth = data.clmMonth;
                        data.gridData.update[i].supply = data.supply;
                        data.gridData.update[i].supplyName = data.supplyName;
                        data.gridData.update[i].gstRgistNo = data.gstRgistNo;
                        data.gridData.update[i].invcDt = data.invcDt;
                        data.gridData.update[i].invcNo = data.invcNo;
                        data.gridData.update[i].invcType = data.invcType;
                        data.gridData.update[i].invcTypeName = data.invcTypeName;
                        data.gridData.update[i].cur = data.cur;
                        data.gridData.update[i].expDesc = data.expDesc;
                        if(fn_checkCreditLimit(data.gridData.update[i]))
                        {
                        	AUIGrid.updateRow(newGridID, data.gridData.update[i], AUIGrid.rowIdToIndex(newGridID, data.gridData.update[i].clmSeq));
                            fn_clearData();
                        }

                    }
                }

                if(data.gridData.remove.length > 0) {
                    for(var i = 0; i < data.gridData.remove.length; i++) {
                        AUIGrid.removeRow(newGridID, AUIGrid.rowIdToIndex(newGridID, data.gridData.remove[i].clmSeq));
                    }
                }

                if(c1 != 0 || c2 != 0 || c3 != 0 || c4 != 0 || c5 != 0 || c6 != 0) {
                    if(data.gridData.length > 0) {
                        for(var i = 0; i < data.gridData.length; i++) {
                            data.gridData[i].bankCode = data.bankCode;
                            data.gridData[i].bankName = data.bankName;
                            data.gridData[i].crditCardNo = data.crditCardNo;
                            data.gridData[i].crditCardUserId = data.crditCardUserId;
                            data.gridData[i].crditCardUserName = data.crditCardUserName;
                            data.gridData[i].chrgUserId = data.chrgUserId;
                            data.gridData[i].chrgUserName = data.chrgUserName;
                            data.gridData[i].costCentr = data.costCentr;
                            data.gridData[i].costCentrName = data.costCentrName;
                            data.gridData[i].sCostCentr = data.sCostCentr;
                            data.gridData[i].sCostCentrName = data.sCostCentrName;
                            data.gridData[i].clmMonth = data.clmMonth;
                            data.gridData[i].supply = data.supply;
                            data.gridData[i].supplyName = data.supplyName;
                            data.gridData[i].gstRgistNo = data.gstRgistNo;
                            data.gridData[i].invcDt = data.invcDt;
                            data.gridData[i].invcNo = data.invcNo;
                            data.gridData[i].invcType = data.invcType;
                            data.gridData[i].invcTypeName = data.invcTypeName;
                            data.gridData[i].cur = data.cur;
                            data.gridData[i].expDesc = data.expDesc;
                            AUIGrid.updateRow(newGridID, data.gridData[i], AUIGrid.rowIdToIndex(newGridID, data.gridData[i].clmSeq));
                        }
                    }
                    fn_clearData();
                }

                fn_getAllTotAmt();

                clmSeq = 0;
            });
        }

/*         var newFlg = fn_checkCreditLimit();
        console.log(newFlg);
        if(!newFlg) {
            Common.alert('Insufficient Credit Limit');
            return false;
        } */
        //fn_clearData();
    }
}

function fn_getAllTotAmt() {
    // allTotAmt GET, SET
    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues(newGridID, "totAmt", true);
    console.log(totAmtList);
    console.log(totAmtList.length);
    for(var i = 0; i < totAmtList.length; i++) {
        allTotAmt += totAmtList[i];
    }
    //allTotAmt = allTotAmt.toFixed(2);
    console.log($.number(allTotAmt,2,'.',''));
    allTotAmt = $.number(allTotAmt,2,'.',',');
    //allTotAmt += "";
    console.log(allTotAmt);

    //$("#allTotAmt_text").text(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    $("#allTotAmt_text").text(allTotAmt);
}

function filterGridArrayToCaterUpdate(filter,result){
	for(i=0; i< filter.length; i++){
	  for(j=0; j< result.length; j++){
	    if(filter[i].clmSeq == result[j].clmSeq){
	    	result.splice(j,1);
	    }
	  }
	}
	return result;
}

function sumTotalAmount(array){
	var amount = 0.00;
	for(i=0; i< array.length; i++){
		if(array[i].cntrlExp == "Y"){
			amount += array[i].totAmt;
		}
	}
	return amount;
}

function fn_getItemTotal() {
    // allTotAmt GET, SET
    var allTotAmt = 0.00;
//     var totAmtList = AUIGrid.getColumnValues(myGridID, "totAmt", true);
//     var totAmtList2 = AUIGrid.getColumnValues(newGridID, "totAmt", true);

	var gridDataList = AUIGrid.getOrgGridData(myGridID);
	var gridDataList2 = AUIGrid.getOrgGridData(newGridID);

	var filteredResultList = filterGridArrayToCaterUpdate(Array.from(gridDataList),Array.from(gridDataList2));
	allTotAmt += sumTotalAmount(gridDataList);
	allTotAmt += sumTotalAmount(filteredResultList);
//     console.log(totAmtList);
//     console.log(totAmtList.length);
//     console.log(totAmtList2);
//     console.log(totAmtList2.length);
    var clmDt = $("#clmMonth").val();
    var month = clmDt.substring(0, 2);
    var year = clmDt.substring(3);

//    clmDt = year + month;
//     var data = {
//             userid : $("#newCrditCardUserId").val(),
//             cardNo : $("#newCrditCardNo").val(),
//             clmDt : clmDt
//     };
    var data = {
    		userid : $("#newCrditCardUserId").val(),
    		cardNo : $("#newCrditCardNo").val(),
    		clmMonth : ""+year+month,
    		month : month,
    		year : year,
    		crcId : $("#sCardSeq").val()
    };
    Common.ajaxSync("GET", "/eAccounting/creditCard/selectTotalCntrlSpentAmt.do", data, function(results) {
// 	    for(var i = 0; i < totAmtList.length; i++) {
// 	        allTotAmt += totAmtList[i];
// 	    }
// 	    for(var i = 0; i < totAmtList2.length; i++) {
// 	        allTotAmt += totAmtList2[i];
// 	    }
    	allTotAmt += results[0].cntrlSpentAmt;
// 	    allTotAmt += results[0].spentAmt;
// 	    console.log(results[0].spentAmt);
	    //allTotAmt = allTotAmt.toFixed(2);
	    //console.log($.number(allTotAmt,2,'.',''));
	    //allTotAmt = $.number(allTotAmt,2,'.',',');
    });
    return allTotAmt;
}

function fn_checkCreditLimit(v) {
    // To check if limit exceeded
    const {totAmt, cntrlExp} = v;
    var allTotAmt = fn_getItemTotal();
    var limitFlg = true;
    var clmDt = $("#clmMonth").val(); //claim date
    var month = Number(clmDt.substring(0, 2));
    if(month < 10){
    	month = "0" + month
    }
    var year = Number(clmDt.substring(3));
    var data = {
    		userid : $("#newCrditCardUserId").val(),
    		cardNo : $("#newCrditCardNo").val(),
    		clmMonth : ""+year+month,
    		month : month,
    		year : year,
    		crcId : $("#sCardSeq").val()
    };
    console.log(data);
	Common.ajaxSync("GET", "/eAccounting/creditCard/selectAvailableAllowanceAmt.do", data, function(result) {
		//Common.ajaxSync("GET", "/eAccounting/creditCard/selectTotalCntrlSpentAmt.do", data, function(result1) {
	        console.log(result);
	        var planAmt = 0;
	        if(result.length > 0)
	        {
	            planAmt = result[0].availableAmt;
	        }
// 	        if($("#cardControlYN").val() == "Y")
// 	        {
	            if(cntrlExp == "Y")
	            {
// 	                var totalExpAmtSmall = 0;
// 	                var totalCntrlSpentAmt = result1[0].cntrlSpentAmt;
// 	                totalExpAmtSmall = totAmt;
// 	                totalExpAmt = totalExpAmt + totalExpAmtSmall;
// 	                totalCntrlSpentAmt = totalCntrlSpentAmt + totalExpAmt;
	                if(allTotAmt.toFixed(2) > planAmt.toFixed(2))
	                {
	                    Common.alert('Insufficient Allowance Limit');
	                    limitFlg = false;
	                }
	            }
	        //}
		//})
	});
	return limitFlg;
}

/* function fn_checkExceedLimit() {
    var newFlg = fn_checkCreditLimit();
    console.log(newFlg);
    if(!newFlg) {
        Common.alert('Insufficient Credit Limit');
        return false;
    }
} */

function fn_insertReimbursement(st) {
    // row의 수가 0개 이상일때만 insert
    	var gridDataList = AUIGrid.getOrgGridData(newGridID);
        if(gridDataList.length > 0){
            var data = {
                    gridDataList : gridDataList
                    ,allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
            }
            console.log(data);
            Common.ajax("POST", "/eAccounting/creditCard/insertReimbursement.do", data, function(result) {
                console.log(result);
                clmNo = result.data.clmNo;
                fn_selectReimbursementItemList();
                if(st == "new"){
                    Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                    $("#newReimbursementPop").remove();
                }
                fn_selectReimbursementList();
            });
        } else {
            Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
        }
}

function fn_selectReimbursementItemList() {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/creditCard/selectReimbursementItemList.do", obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

function fn_viewReimbursementPop() {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };
    Common.popupDiv("/eAccounting/creditCard/viewReimbursementPop.do", data, null, true, "viewReimbursementPop");
}

function fn_selectReimbursementInfo() {
    var obj = {
            clmNo : clmNo
            ,clmSeq : clmSeq
            ,clamUn : clamUn
    };
    Common.ajax("GET", "/eAccounting/creditCard/selectReimbursementInfo.do?_cacheId=" + Math.random(), obj, function(result) {
        console.log(result);
        var crditCardNo = result.crditCardNo;
        $("#newCrditCardNo").val(crditCardNo);
        /* var crditCardNo1 = crditCardNo.substr(0, 4);
        var crditCardNo4 = crditCardNo.substr(12);
        crditCardNo = crditCardNo1 + "********" + crditCardNo4;
        console.log(crditCardNo);
        $("#maskingNo").val(crditCardNo); */
        $("#newCrditCardUserId").val(result.crditCardUserId);
        $("#newCrditCardUserName").val(result.crditCardUserName);
        $("#newChrgUserId").val(result.chrgUserId);
        $("#newChrgUserName").val(result.chrgUserName);
        $("#newCostCenter").val(result.costCentr);
        $("#newCostCenterText").val(result.costCentrName);
        $("#sCostCentr").val(result.sCostCentr);
        $("#sCostCentrName").val(result.sCostCentrName);
        $("#bankCode").val(result.bankCode);
        $("#bankName").val(result.bankName);
        $("#clmMonth").val(result.clmMonth);
        $("#invcType").val(result.invcType);
        $("#invcNo").val(result.invcNo);
        $("#invcDt").val(result.invcDt);
        $("#newSupply").val(result.supply);
        $("#newSupplyName").val(result.supplyName);
        $("#gstRgistNo").val(result.gstRgistNo);
        $("#expDesc").val(result.expDesc);
        $("#sCardSeq").val(result.crditCardSeq);
        $("#cardControlYN").val(result.cntrlCard);
        $("#cntrlExp").val(result.cntrlExp);

        AUIGrid.setGridData(myGridID, result.itemGrp);

        if(result.appvPrcssNo == null || result.appvPrcssNo == "") {
            $("#hClmMonth").val(result.clmMonth);
            $("#hInvcDt").val(result.invcDt);
            $("#hInvcNo").val(result.invcNo);
            $("#hSCostCentr").val(result.sCostCentr);
            $("#hNewSupplyName").val(result.supplyName);
            $("#hExpDesc").val(result.expDesc);
        }

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
                $("#form_newReimbursement :file").change(function() {
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

function fn_updateReimbursement(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var gridDataObj = GridCommon.getEditData(newGridID);
        gridDataObj.clmNo = clmNo;
        gridDataObj.allTotAmt = Number($("#allTotAmt_text").text().replace(/,/gi, ""));
        console.log(gridDataObj);
        Common.ajax("POST", "/eAccounting/creditCard/updateReimbursement.do", gridDataObj, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectReimbursementItemList();
            if(st == "view"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#viewReimbursementPop").remove();
            }
            fn_selectReimbursementList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_approveLinePop() {
    // tempSave를 하지 않고 바로 submit인 경우
    if(FormUtil.isEmpty(clmNo)) {
    	fn_insertReimbursement("");
    } else {
        // 바로 submit 후에 appvLinePop을 닫고 재수정 대비
        fn_updateReimbursement("");
    }

    Common.popupDiv("/eAccounting/creditCard/approveLinePop.do", null, null, true, "approveLineSearchPop");
}

function fn_deleteReimbursement() {
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
    Common.ajax("POST", "/eAccounting/creditCard/deleteReimbursement.do", data, function(result) {
        console.log(result);

        // function 호출 안되서 ajax 직접호출
        //fn_selectReimbursementList();
        Common.ajax("GET", "/eAccounting/creditCard/selectReimbursementList.do?_cacheId=" + Math.random(), $("#form_reimbursement").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(reimbursementGridID, result);
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
            if(event.dataField == "taxNonClmAmt") {
                if(event.item.taxAmt <= 30) {
                    Common.alert('<spring:message code="newWebInvoice.gstLess.msg" />');
                    AUIGrid.forceEditingComplete(myGridID, null, true);
                }
            }
        } else {
            if(event.dataField == "taxNonClmAmt") {
                Common.alert('<spring:message code="newWebInvoice.gstFullTax.msg" />');
                AUIGrid.forceEditingComplete(myGridID, null, true);
            }
        }
  });

    AUIGrid.bind(myGridID, "cellEditEnd", function( event ) {
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
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxAmt", taxAmt);
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
                }
                if(event.dataField == "taxAmt") {
                	if(event.value > 30) {
                        Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
                        AUIGrid.setCellValue(myGridID, event.rowIndex, "taxAmt", event.oldValue);
                    } else {
                        var taxAmtCnt = fn_getTotTaxAmt(event.rowIndex);
                        if((taxAmtCnt + event.value) > 30) {
                            Common.alert('<spring:message code="newWebInvoice.gstSimTax.msg" />');
                            AUIGrid.setCellValue(myGridID, event.rowIndex, "taxAmt", event.oldValue);
                        }
                    }
                }
            } else {
                if(event.dataField == "netAmt") {
                    taxAmt = event.item.oriTaxAmt;
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxAmt", taxAmt);
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
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
    var amtArr = AUIGrid.getColumnValues(myGridID, "taxAmt", true);
    console.log(amtArr);
    for(var i = 0; i < amtArr.length; i++) {
        taxAmtCnt += amtArr[i];
    }
    // 0번째 행의 name 칼럼의 값 얻기
    var value = AUIGrid.getCellValue(myGridID, rowIndex, "taxAmt");
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

function fn_editRejected() {
    console.log("fn_editRejected");

    var gridObj = AUIGrid.getSelectedItems(reimbursementGridID);
    var list = AUIGrid.getCheckedRowItems(reimbursementGridID);

    if(gridObj != "" || list != "") {
        var status;
        var selClmNo;

        if(list.length > 1) {
            Common.alert("* Only 1 record is permitted. ");
            return;
        }

        if(gridObj.length > 0) {
            status = gridObj[0].item.appvPrcssStus;
            selClmNo = gridObj[0].item.clmNo;
        } else {
            status = list[0].item.appvPrcssStus;
            selClmNo = list[0].item.clmNo;
        }

        if(status == "Rejected") {
        	Common.ajax("POST", "/eAccounting/creditCard/editRejected.do", {clmNo : selClmNo}, function(result) {
                console.log(result);

                Common.alert("New claim number : " + result.data.newClmNo);
            });
        } else {
            Common.alert("Only rejected claims are allowed to edit.");
        }
    } else {
        Common.alert("* No Value Selected. ");
        return;
    }
}

function fn_excelDown(){
	// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
 //Common.popupDiv("/eAccounting/creditCard/newReimbursementPop.do", {callType:"new"}, null, true, "newReimbursementPop");
    Common.popupDiv("/eAccounting/creditCard/creditCardReimbursementExcelDownPop.do", {callType:"new"}, null, true, "creditCardReimbursementExcelDownPop");
    //GridCommon.exportTo("excel_grid_wrap", "xlsx", "Credit Card Expense");
}

</script>

<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/CorporateCRCExpense.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="_clmNo" name="V_CLAIMNO" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="crditCardReim.title" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectReimbursementList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	</c:if>
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_reimbursement">
<input type="hidden" id="crditCardUserId" name="crditCardUserId">
<input type="hidden" id="chrgUserId" name="chrgUserId">
<input type="hidden" id="costCenterText" name="costCentrName">
<input type="hidden" id="cntrlExp" name="cntrlExp">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="crditCardMgmt.cardholderName" /></th>
	<td><input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="crditCardUserName" name="crditCardUserName"/><a href="#" class="search_btn" id="search_holder_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="crditCardMgmt.crditCardNo" /></th>
	<td><input type="text" title="" placeholder="Credit card No" class="" id="crditCardNo" name="crditCardNo" autocomplete=off/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="crditCardMgmt.chargeName" /></th>
	<td><input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="chrgUserName" name="chrgUserName"/><a href="#" class="search_btn" id="search_charge_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="crditCardMgmt.chargeDepart" /></th>
	<td><input type="text" title="" placeholder="" class="" id="costCenter" name="costCentr"/><a href="#" class="search_btn" id="search_depart_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
	<th scope="row"><spring:message code="webInvoice.requestDate" /></th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="startDt" name="startDt"/></p>
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

    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="link_btn"><a href="#" id="_ExpSlipBtn">Print Expenses Slip</a></p></li>
            </c:if>
            <li><p class="link_btn"><a href="#" id="editRejBtn">Edit Rejected</a></p></li>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid"><a href="#" onclick="fn_excelDown()">Excel Filter</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="crditCardReim.newExpClm" /></a></p></li>
	</c:if>
</ul>

<article class="grid_wrap" id="reimbursement_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
<article class="grid_wrap" id="excel_grid_wrap" style="display:none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->