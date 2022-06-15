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
    var myFileCaches = {};
    var recentGridItem = null;
    var htmActFundGridID;

    var htmActFundClaimColumnLayout = [
        {
            dataField : "memAccId",
            headerText : "HTM Code"
        }, {
            dataField : "memAccName",
            headerText : "HTM Name",
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

    var htmActFundClaimGridPros = {
        usePaging : true,
        pageRowCount : 20,
        headerHeight : 40,
        selectionMode : "multipleCells"
    };

    $(document).ready(function () {
        htmActFundGridID = AUIGrid.create("#htmActFundClaim_grid_wrap", htmActFundClaimColumnLayout, htmActFundClaimGridPros);

        $("#appvPrcssStus").multipleSelect("checkAll");

        fn_setToMonth();

        if('${clmNo}' != null && '${clmNo}' != "") {
            $("#clmMonth").val("");
            $("#clmNo").val('${clmNo}');
            $("#clmMonth").val('${period}');

            fn_selectHtmActFundClaimList();
        }

        $("#search_supplier_btn").click(fn_supplierSearchPop);
        $("#registration_btn").click(fn_newClaimPop);
        /*$("#newExpStaffClaim").click(fn_NewClaimPop);*/
        $("#htmClaimBtn").click(function() {
            var gridObj = AUIGrid.getSelectedItems(htmActFundGridID);

            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert("* No Record Selected. ");
                return;
            }

            var claimno = gridObj[0].item.clmNo;
            $("#_repClaimNo").val(claimno);

            fn_report();
        });

        AUIGrid.bind(htmActFundGridID, "cellDoubleClick", function(event) {
            console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            console.log("CellDoubleClick clmNo : " + event.item.clmNo);
            console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
            console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);

            if(event.item.appvPrcssStusCode == "T") {
                fn_viewHtmActFundPop(event.item.clmNo);
            } else {
                var clmNo = event.item.clmNo;
                var clmType = clmNo.substr(0, 2);
                fn_webInvoiceRequestPop(event.item.appvPrcssNo, clmType);
            }
        });
    });

    function fn_setToMonth() {
        var month = new Date();
        var mm = month.getMonth() + 1;
        var yyyy = month.getFullYear();

        if(mm < 10){
            mm = "0" + mm
        }

        $("#clmMonth").val(mm + "/" + yyyy);
    }

    function fn_clearData() {
        $("#invcDt").val("");
        $("#supplirName").val("");
        $("#gstRgistNo").val("");
        $("#invcType").val("F");
        $("#invcNo").val("");
        $("#expDesc").val("");

        fn_destroyMyGrid();
        fn_createMyGrid();

        fn_myGridSetEvent();

        $("#attachTd").html("");
        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
    }

    function fn_NewClaimPop() {
        Common.popupDiv("/newClaim/newPop.do", {callType:"new", claimType:"J9"}, null, true, "newClaimPop");
    }

    function fn_setEvent() {
        $("#form_newHtmActFundClaim :text").change(function() {
            var id = $(this).attr("id");
            console.log(id);

            if(id == "newClmMonth") {
                var clmMonth = $(this).val();
                var month = clmMonth.substring(0, 2);
                var year = clmMonth.substring(3);

                clmMonth = year + month;

                var now = new Date;
                var mm = now.getMonth() + 1;
                var yyyy = now.getFullYear();
                if(mm < 10){
                    mm = "0" + mm
                }
                now = yyyy + "" + mm;

                if(Number(clmMonth) > Number(now)) {
                    Common.alert('<spring:message code="pettyCashExp.onlyPastDt.msg" />');
                    $(this).val(mm + "/" + yyyy);
                }
            } else if(id == "newCostCenter") {
                if(!FormUtil.isEmpty($("#newCostCenter").val())){
                    Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:$("#newCostCenter").val()}, function(result) {
                        console.log(result);
                        if(result.length > 0) {
                            var row = result[0];
                            $("#newCostCenterText").val(row.costCenterText);
                        }
                    });
                }
            } else if(id == "gstRgistNo") {
                if($("#invcType").val() == "F") {
                    var gstRgistNo = $(this).val();
                }
            }
        });

        $('#form_newHtmActFundClaim :file').change(function() {
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

        $('#file').on('change', function(evt) {
            var data = null;
            var file = evt.target.files[0];
            if(typeof file == "undefined") {
                delete myFileCaches[selectRowIdx + 1];
                AUIGrid.updateRow(mileageGridID, {atchFileName :  ""}, selectRowIdx);
                return;
            }

            myFileCaches[selectRowIdx + 1] = {file : file};

            if(!FormUtil.isEmpty(recentGridItem.atchFileGrpId)) {
                update.push(recentGridItem.atchFileId);
                console.log(JSON.stringify(update));
            }

            console.log("#file change");
            console.log(myFileCaches);

            AUIGrid.updateRow(mileageGridID, {atchFileName :  file.name}, selectRowIdx);
        });

        $(":input:radio[name=expGrp]").on('change', function(evt) {
            fn_checkExpGrp();
        });
    }

    function fn_supplierSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM10"}, null, true, "supplierSearchPop");
    }

    function fn_setSupplier() {
        $("#memAccId").val($("#search_memAccId").val());
        $("#memAccName").val($("#search_memAccName").val());
    }

    function fn_popCostCenterSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
    }

    function fn_setPopCostCenter() {
        $("#newCostCenter").val($("#search_costCentr").val());
        $("#newCostCenterText").val($("#search_costCentrName").val());
    }

    function fn_popSupplierSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM10"}, null, true, "supplierSearchPop");
    }

    function fn_setPopSupplier() {
        $("#newMemAccId").val($("#search_memAccId").val());
        $("#newMemAccName").val($("#search_memAccName").val());
        $("#bankCode").val($("#search_bankCode").val());
        $("#bankName").val($("#search_bankName").val());
        $("#bankAccNo").val($("#search_bankAccNo").val());
    }

    function fn_setCostCenterEvent() {
        $("#newCostCenter").change(function() {
            var costCenter = $(this).val();
            if(!FormUtil.isEmpty(costCenter)){
                Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:costCenter}, function(result) {
                    if(result.length > 0) {
                        var row = result[0];
                        $("#newCostCenterText").val(row.costCenterText);
                    }
                });
            }
       });
    }

    function fn_setSupplierEvent() {
        $("#newMemAccId").change(function() {
            var memAccId = $(this).val();
            if(!FormUtil.isEmpty(memAccId)) {
                Common.ajax("GET", "/eAccounting/webInvoice/selectSupplier.do?_cacheId=" + Math.random(), {memAccId:memAccId}, function(result) {
                    if(result.length > 0) {
                        var row = result[0];
                        $("#newMemAccName").val(row.memAccName);
                        $("#bankCode").val(row.bankCode);
                        $("#bankName").val(row.bankName);
                        $("#bankAccNo").val(row.bankAccNo);
                    }
                });
            }
       });
    }

    function fn_PopExpenseTypeSearchPop() {
        Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J9'}, null, true, "expenseTypeSearchPop");
    }

    function fn_setPopExpType() {
        console.log("Action glacc");

        AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCode", $("#search_budgetCode").val());
        AUIGrid.setCellValue(myGridID , selectRowIdx , "budgetCodeName", $("#search_budgetCodeName").val());

        AUIGrid.setCellValue(myGridID , selectRowIdx , "expType", $("#search_expType").val());
        AUIGrid.setCellValue(myGridID , selectRowIdx , "expTypeName", $("#search_expTypeName").val());

        AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCode", $("#search_glAccCode").val());
        AUIGrid.setCellValue(myGridID , selectRowIdx , "glAccCodeName", $("#search_glAccCodeName").val());
    }

function fn_popSubSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"sPop",accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_setPopSubSupplier() {
    $("#supplir").val($("#search_memAccId").val());
    $("#supplirName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
}

// Main Button functions
function fn_selectHtmActFundClaimList() {
    Common.ajax("GET", "/eAccounting/htmActivityFund/selectHtmActFundClaimList.do?_cacheId=" + Math.random(), $("#form_htmClaim").serialize(), function(result) {
        AUIGrid.setGridData(htmActFundGridID, result);
    });
}

function fn_newClaimPop() {
    Common.popupDiv("/eAccounting/htmActivityFund/newClaimPop.do", {callType:"new"}, null, true, "newClaimPop");
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccId").val())) {
        Common.alert('<spring:message code="staffClaim.staffCode.msg" />');
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
    if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
        checkResult = false;
        return checkResult;
    }
    var settlementRowCount = AUIGrid.getRowCount(myGridID);
    if(settlementRowCount > 0){
        for(var i=0; i < settlementRowCount; i++){
            if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "expType"))){
                Common.alert("Please choose a Expenses Type.");
                checkResult = false;
                return checkResult;
            }/*
            if(FormUtil.isEmpty(AUIGrid.getCellValue(settlementGridId, i, "glAccCode"))){
                Common.alert("Please choose a GL code.");
                checkRowFlg = false;
                return checkRowFlg;
            } */
            if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "totAmt")) || AUIGrid.getCellValue(myGridID, i, "totAmt") <= 0){
                Common.alert("Please enter an amount.");
                checkResult = false;
                return checkResult;
                }
            }

    return checkResult;
    }
}

//AUIGrid 를 생성합니다.
function fn_createMyGrid() {
    if(AUIGrid.isCreated("#my_grid_wrap")) {
        fn_destroyMyGrid();
    }

    myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);

    fn_myGridSetEvent();
}

function fn_destroyMyGrid() {
    AUIGrid.destroy("#my_grid_wrap");
    myGridID = null;
}

function fn_addMyGridRow() {
    if(AUIGrid.getRowCount(myGridID) > 0) {
        AUIGrid.addRow(myGridID, {clamUn:AUIGrid.getCellValue(myGridID, 0, "clamUn"),taxCode:"OP (Purchase(0%):Out of scope)",expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
    } else {
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J9"}, function(result) {
            console.log(result);
            AUIGrid.addRow(myGridID, {clamUn:result.clamUn,expGrp:$(":input:radio[name=expGrp]:checked").val(),taxCode:"OP (Purchase(0%):Out of scope)",cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
        });
    }
}

function fn_removeMyGridRow() {
    AUIGrid.removeRow(myGridID, selectRowIdx);
}

function fn_addRow() {
    if(fn_checkEmpty()) {
        var formData = Common.getFormData("form_newHtmActFundClaim");
            console.log(clmSeq);
            if(clmSeq == 0) {
                console.log("Normal Expense Add")
                var data = {
                        costCentr : $("#newCostCenter").val(),
                        costCentrName : $("#newCostCenterText").val(),
                        memAccId : $("#newMemAccId").val(),
                        bankCode : $("#bankCode").val(),
                        bankAccNo : $("#bankAccNo").val(),
                        clmMonth : $("#newClmMonth").val(),
                        supplir : $("#supplir").val(),
                        supplirName : $("#supplirName").val(),
                        invcType : $("#invcType").val(),
                        invcTypeName : $("#invcType option:selected").text(),
                        invcNo : $("#invcNo").val(),
                        invcDt : $("#invcDt").val(),
                        gstRgistNo : $("#gstRgistNo").val(),
                        cur : "MYR",
                        expDesc : $("#expDesc").val(),
                        gridData : GridCommon.getEditData(myGridID)
                };

                Common.ajaxFile("/eAccounting/htmActivityFund/attachFileUpload.do", formData, function(result) {
                    console.log(result);

                    data.atchFileGrpId = result.data.fileGroupKey
                    console.log(data);

                    if(data.gridData.add.length > 0) {
                        for(var i = 0; i < data.gridData.add.length; i++) {
                            data.gridData.add[i].costCentr = data.costCentr;
                            data.gridData.add[i].costCentrName = data.costCentrName;
                            data.gridData.add[i].memAccId = data.memAccId;
                            data.gridData.add[i].bankCode = data.bankCode;
                            data.gridData.add[i].bankAccNo = data.bankAccNo;
                            data.gridData.add[i].clmMonth = data.clmMonth;
                            data.gridData.add[i].supplir = data.supplir;
                            data.gridData.add[i].supplirName = data.supplirName;
                            data.gridData.add[i].invcType = data.invcType;
                            data.gridData.add[i].invcTypeName = data.invcTypeName;
                            data.gridData.add[i].invcNo = data.invcNo;
                            data.gridData.add[i].invcDt = data.invcDt;
                            data.gridData.add[i].gstRgistNo = data.gstRgistNo;
                            data.gridData.add[i].cur = data.cur;
                            data.gridData.add[i].expDesc = data.expDesc;
                            data.gridData.add[i].atchFileGrpId = data.atchFileGrpId;
                            data.gridData.add[i].taxCode = "VB";
                            data.gridData.add[i].taxName = "OP (Purchase(0%):Out of scope)";
                            AUIGrid.addRow(newGridID, data.gridData.add[i], "last");
                        }
                    }

                    fn_getAllTotAmt();
                });
            } else {
                console.log("Normal Expense Update")
                var data = {
                        costCentr : $("#newCostCenter").val(),
                        costCentrName : $("#newCostCenterText").val(),
                        memAccId : $("#newMemAccId").val(),
                        bankCode : $("#bankCode").val(),
                        bankAccNo : $("#bankAccNo").val(),
                        clmMonth : $("#newClmMonth").val(),
                        supplir : $("#supplir").val(),
                        supplirName : $("#supplirName").val(),
                        invcType : $("#invcType").val(),
                        invcTypeName : $("#invcType option:selected").text(),
                        invcNo : $("#invcNo").val(),
                        invcDt : $("#invcDt").val(),
                        gstRgistNo : $("#gstRgistNo").val(),
                        cur : "MYR",
                        expDesc : $("#expDesc").val(),
                        gridData : GridCommon.getEditData(myGridID)
                };

                $("#attachTd").html("");
                $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");

                formData.append("atchFileGrpId", atchFileGrpId);
                formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                Common.ajaxFile("/eAccounting/htmActivityFund/attachFileUpdate.do", formData, function(result) {
                    console.log(result);

                    console.log(data);

                    if(data.gridData.add.length > 0) {
                        for(var i = 0; i < data.gridData.add.length; i++) {
                            data.gridData.add[i].costCentr = data.costCentr;
                            data.gridData.add[i].costCentrName = data.costCentrName;
                            data.gridData.add[i].memAccId = data.memAccId;
                            data.gridData.add[i].bankCode = data.bankCode;
                            data.gridData.add[i].bankAccNo = data.bankAccNo;
                            data.gridData.add[i].clmMonth = data.clmMonth;
                            data.gridData.add[i].supplir = data.supplir;
                            data.gridData.add[i].supplirName = data.supplirName;
                            data.gridData.add[i].invcType = data.invcType;
                            data.gridData.add[i].invcTypeName = data.invcTypeName;
                            data.gridData.add[i].invcNo = data.invcNo;
                            data.gridData.add[i].invcDt = data.invcDt;
                            data.gridData.add[i].gstRgistNo = data.gstRgistNo;
                            data.gridData.add[i].cur = data.cur;
                            data.gridData.add[i].expDesc = data.expDesc;
                            data.gridData.add[i].atchFileGrpId = atchFileGrpId;
                            data.gridData.add[i].taxCode = "VB";
                            data.gridData.add[i].taxName = "OP (Purchase(0%):Out of scope)";
                            AUIGrid.addRow(newGridID, data.gridData.add[i], "last");
                        }
                    }
                    if(data.gridData.update.length > 0) {
                        for(var i = 0; i < data.gridData.update.length; i++) {
                            data.gridData.update[i].costCentr = data.costCentr;
                            data.gridData.update[i].costCentrName = data.costCentrName;
                            data.gridData.update[i].memAccId = data.memAccId;
                            data.gridData.update[i].bankCode = data.bankCode;
                            data.gridData.update[i].bankAccNo = data.bankAccNo;
                            data.gridData.update[i].clmMonth = data.clmMonth;
                            data.gridData.update[i].supplir = data.supplir;
                            data.gridData.update[i].supplirName = data.supplirName;
                            data.gridData.update[i].invcType = data.invcType;
                            data.gridData.update[i].invcTypeName = data.invcTypeName;
                            data.gridData.update[i].invcNo = data.invcNo;
                            data.gridData.update[i].invcDt = data.invcDt;
                            data.gridData.update[i].gstRgistNo = data.gstRgistNo;
                            data.gridData.update[i].cur = data.cur;
                            data.gridData.update[i].expDesc = data.expDesc;
                            data.gridData.update[i].taxCode = "VB";
                            data.gridData.update[i].taxName = "OP (Purchase(0%):Out of scope)";
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
    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues (newGridID, "totAmt", true);

    for(var i = 0; i < totAmtList.length; i++) {
        allTotAmt += totAmtList[i];
    }

    allTotAmt = $.number(allTotAmt,2,'.',',');

    $("#allTotAmt_text").text(allTotAmt);
}

function fn_insertHtmActFundClaimExp(st) {
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var data = {
            gridDataList : gridDataList,
            allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
        }
        console.log(data);
        Common.ajax("POST", "/eAccounting/htmActivityFund/insertHtmActFundExp.do", data, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectHtmActFundItemList();

            if(st == "new"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#newStaffClaimPop").remove();
            }
            fn_selectHtmActFundClaimList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_selectHtmActFundItemList() {
    var obj = {
        clmNo : clmNo
    };

    Common.ajax("GET", "/eAccounting/htmActivityFund/selectHtmActFundItemList.do?_cacheId=" + Math.random(), obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

function fn_viewHtmActFundPop(clmNo) {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };

    Common.popupDiv("/eAccounting/htmActivityFund/viewHtmActFundPop.do", data, null, true, "viewHtmActFundPop");
}

function fn_selectHtmActFundInfo() {
    var obj = {
            clmNo : clmNo,
            clmSeq : clmSeq,
            clamUn : clamUn
    };
    Common.ajax("GET", "/eAccounting/htmActivityFund/selectHtmActFundInfo.do?_cacheId=" + Math.random(), obj, fn_setStaffClaimInfo);
}

function fn_setStaffClaimInfo(result) {
    if(result.expGrp != "1") {
        $("#newCostCenter").val(result.costCentr);
        $("#newCostCenterText").val(result.costCentrName);
        $("#newMemAccId").val(result.memAccId);
        $("#newMemAccName").val(result.memAccName);
        $("#bankCode").val(result.bankCode);
        $("#bankName").val(result.bankName);
        $("#bankAccNo").val(result.bankAccNo);
        $("#newClmMonth").val(result.clmMonth);
        $("#supplir").val(result.supplir);
        $("#supplirName").val(result.supplirName);
        $("#invcType").val(result.invcType);
        $("#invcNo").val(result.invcNo);
        $("#invcDt").val(result.invcDt);
        $("#gstRgistNo").val(result.gstRgistNo);
        $("#expDesc").val(result.expDesc);

        AUIGrid.setGridData(myGridID, result.itemGrp);

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

                $("#form_newHtmActFundClaim :file").change(function() {
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
    }
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);

        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_fileListPop() {
    var data = {
            atchFileGrpId : atchFileGrpId
    };

    Common.popupDiv("/eAccounting/webInvoice/fileListPop.do", data, null, true, "fileListPop");
}

function fn_updateStaffClaimExp(st) {
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var gridDataObj = GridCommon.getEditData(newGridID);
        gridDataObj.clmNo = clmNo;
        gridDataObj.allTotAmt = Number($("#allTotAmt_text").text().replace(/,/gi, ""));
        console.log(gridDataObj);

        Common.ajax("POST", "/eAccounting/htmActivityFund/updateHtmActFundExp.do", gridDataObj, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectHtmActFundItemList();
            if(st == "view"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#viewStaffClaimPop").remove();
            }
            fn_selectHtmActFundClaimList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_approveLinePop(memAccId, clmMonth) {
    /*
    Common.ajax("POST", "/eAccounting/htmActivityFund/checkOnceAMonth.do?_cacheId=" + Math.random(), {clmType:"J4", memAccId:memAccId, clmMonth:clmMonth}, function(result) {
        console.log(result);
        if(result.data > 0) {
            Common.alert(result.message);
        } else {
            if(FormUtil.isEmpty(clmNo)) {
                fn_insertHtmActFundClaimExp("");
            } else {

                fn_updateStaffClaimExp("");
            }

            Common.popupDiv("/eAccounting/htmActivityFund/approveLinePop.do", null, null, true, "approveLineSearchPop");
        }
    });
    */

    if(FormUtil.isEmpty(clmNo)) {
        fn_insertHtmActFundClaimExp("");
    } else {
        fn_updateStaffClaimExp("");
    }

    Common.popupDiv("/eAccounting/htmActivityFund/approveLinePop.do", null, null, true, "approveLineSearchPop");
}

function fn_deleteStaffClaimExp() {
    // Grid Row 삭제
    AUIGrid.removeRow(newGridID, deleteRowIdx);

    fn_getAllTotAmt();
    var data = {
            clmNo : clmNo,
            clmSeq : clmSeq,
            atchFileGrpId : atchFileGrpId,
            expTypeName : expTypeName,
            expGrp : expGrp,
            allTotAmt : $("#allTotAmt_text").text().replace(/,/gi, "")
    };
    console.log(data);
    Common.ajax("POST", "/eAccounting/htmActivityFund/deleteStaffClaimExp.do", data, function(result) {
        console.log(result);

        // function 호출 안되서 ajax 직접호출
        Common.ajax("GET", "/eAccounting/htmActivityFund/selectStaffClaimList.do?_cacheId=" + Math.random(), $("#form_htmClaim").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(staffClaimGridID, result);
        });
    });
}

function fn_myGridSetEvent() {
    AUIGrid.bind(myGridID, "cellClick", function(event) {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        selectRowIdx = event.rowIndex;
    });

    AUIGrid.bind(myGridID, "cellEditEnd", function( event ) {
        if(event.dataField == "gstBeforAmt" || event.dataField == "gstAmt" || event.dataField == "taxNonClmAmt") {
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
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
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
                    AUIGrid.setCellValue(myGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
                }
            }
        }
  });
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

function fn_checkClmMonthAndMemAccId() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newMemAccId").val())) {
        Common.alert('Please enter the Staff Code');
        checkResult = false;
        return checkResult;
    }

    if(FormUtil.isEmpty($("#newClmMonth").val())) {
        Common.alert('Please enter the Claim Month');
        checkResult = false;
        return checkResult;
    }

    return checkResult;
}
</script>

<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/HTMActFund.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="_repClaimNo" name="v_CLM_NO" />
</form>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
        <h2>HTM Activity Fund Claim</h2>
        <ul class="right_btns">
           <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectHtmActFundClaimList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form action="#" method="post" id="form_htmClaim">
            <input type="hidden" id="memAccName" name="memAccName">

            <!-- table start -->
            <table class="type1">
                <caption><spring:message code="webInvoice.table" /></caption>
                <colgroup>
                    <col style="width:110px" />
                    <col style="width:*" />
                    <col style="width:110px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
                        <td>
                            <input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2" id="clmMonth" name="clmMonth"/>
                        </td>
                        <th scope="row">HTM Code</th>
                        <td>
                            <input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId"/>
                            <a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" ><spring:message code="webInvoice.status" /></th>
                        <td>
                            <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
                                <option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
                                <option value="R"><spring:message code="webInvoice.select.request" /></option>
                                <option value="P"><spring:message code="webInvoice.select.progress" /></option>
                                <option value="A"><spring:message code="webInvoice.select.approved" /></option>
                                <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
                            </select>
                        </td>
                        <th scope="row"><spring:message code="invoiceApprove.clmNo" /></th>
                        <td>
                            <input type="text" title="" placeholder="" class="" id="clmNo" name="clmNo"/>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">
                            <li><p class="link_btn"><a href="#" id="htmClaimBtn">HTM Activity Fund Claim</a></p></li>
                        </ul>
                        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">

        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="pettyCashExp.newExpClm" /></a></p></li>
        </ul>

        <!-- grid_wrap start -->
        <article class="grid_wrap" id="htmActFundClaim_grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section><!-- content end -->