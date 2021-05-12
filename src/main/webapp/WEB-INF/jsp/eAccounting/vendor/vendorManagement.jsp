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

console.log("vendorManagement");
var vendorManagementColumnLayout = [ {
	dataField : "reqNo",
    headerText : 'Vendor Request No'
}, {
    dataField : "vendorAccId",
    headerText : 'Supplier Code'
}, {
    dataField : "vendorName",
    headerText : 'Name'
}, {
    dataField : "vendorRegNoNric",
    headerText : 'Company Registration No/IC',
    width : 140
}, {
    dataField : "appvPrcssStus",
    headerText : 'Status'
}, {
    dataField : "appvDt",
    headerText : 'Approval Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

//그리드 속성 설정
var vendorManagementGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells",
    showRowCheckColumn : true,
    showRowAllCheckBox : true
};

var vendorManagementGridID;

var bulkRptInt;

$(document).ready(function () {
	vendorManagementGridID = AUIGrid.create("#vendorManagement _grid_wrap", vendorManagementColumnLayout, vendorManagementGridPros);

	$("#search_supplier_btn").click(fn_supplierSearchPop);
	$("#search_regNo_btn").click(fn_supplierSearchPop);
	$("#search_costCenter_btn").click(fn_costCenterSearchPop);
	$("#new_vendor_btn").click(fn_newVendorPop);
	$("#edit_vendor_btn").click(fn_preEdit);


	var userId = "${SESSION_INFO.userId}";
	console.log("crtUserID: " + userId);
	AUIGrid.bind(vendorManagementGridID, "cellDoubleClick", function( event )
		    {
		        console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
		        console.log(event);
		        console.log(event.item.userId);
		        console.log("CellDoubleClick reqNo : " + event.item.reqNo);
		        console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
		        console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);
		        console.log("CellDoubleClick costCenterName : " + event.item.costCenterName);
		        // TODO detail popup open
		        console.log("crtUserID: " + userId);
		        if(event.item.appvPrcssStusCode == "T") {
		        	if(userId != event.item.userId)
		        	{
		        		Common.alert("You are not allow to edit the record.");
		        	}
		        	else
		        	{
		        		fn_editVendorPop(event.item.reqNo);
		        	}

		        } else {
		        	var reqNo = event.item.reqNo;
		        	var clmType = reqNo.substr(0, 2);
		        	var costCenterName = event.item.costCenterName;
		        	var costCenter = event.item.costCenter;
		        	fn_vendorRequestPop(event.item.appvPrcssNo, clmType, costCenterName, costCenter, reqNo);
		        }

		    });

	$("#edit_vendor_btn").click(function() {

        //Param Set
        var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);

        var list = AUIGrid.getCheckedRowItems(vendorManagementGridID);

        var reqNo = '';

        if(gridObj == null || gridObj.length <= 0 ){
            if(list == null || list.length < 1) {
                Common.alert("* No Value Selected. ");
                return;
            } else if(list.length > 1) {
                Common.alert("* Only 1 record can be selected.");
                return
            } else {
                reqNo = list[0].item.reqNo;
            }
        } else {
            reqNo = gridObj[0].item.reqNo;
        }

        $("#_reqNo").val(reqNo);
        console.log("reqNo : " + $("#_reqNo").val());

        $("#reportDownFileName").val(reqNo);

        //fn_report();
        //Common.alert('The program is under development.');
    });

	// Edit rejected web invoice
	$("#editRejBtn").click(fn_editRejected);

	$("#appvPrcssStus").multipleSelect("checkAll");

	fn_setToDay();
/*
	   if('${reqNo}' != null && '${reqNo}' != "") {
	        $("#startDt").val("");
	        $("#endDt").val("");

	        $("#clmNoStart").val('${reqNo}');
	        $("#clmNoEnd").val('${reqNo}');

	        fn_selectVendorList();
	   }
*/
});

function fn_stopBulkRpt() {
    clearInterval(bulkRptInt);
}

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
   // $("#startDt").val(today)
    //$("#endDt").val(today)
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
                    $("#costCentrName").val(row.costCenterText);
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
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM04"}, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
	Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM04"}, null, true, "supplierSearchPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_newVendorPop() {
    Common.popupDiv("/eAccounting/vendor/newVendorPop.do", {callType:'new'}, null, true, "newVendorPop");
}


function fn_preEdit() {

	var userId = "${SESSION_INFO.userId}";
	var selectedItems = AUIGrid.getSelectedItems(vendorManagementGridID);

	if(selectedItems.length <= 0) {
        return;
    }
    else{
    	if(selectedItems[0].item.appvPrcssStusCode == "T")
    	{
    		if(userId != selectedItems[0].item.userId)
            {
                Common.alert("You are not allow to edit the record.");
            }
            else
            {
            	var reqNo = selectedItems[0].item.reqNo;
                fn_editVendorPop(reqNo);
            }
        }
    	else
    	{
    		var reqNo = selectedItems[0].item.reqNo;
            var clmType = reqNo.substr(0, 2);
            var costCenterName = selectedItems[0].item.costCenterName;
            var costCenter = selectedItems[0].item.costCenter;
            fn_vendorRequestPop(selectedItems[0].item.appvPrcssNo, clmType, costCenterName, costCenter, reqNo);
    	}
    }
}

function fn_editVendorPop(reqNo) {

	 var selectedItems = AUIGrid.getSelectedItems(vendorManagementGridID);

     if(selectedItems.length <= 0) {
         Common.alert("No data selected.");
         return;
     }
     else{
    	 if(reqNo == null || reqNo == '')
    	{
    		 reqNo = selectedItems[0].item.reqNo;
    		 console.log('reqNo: ' + reqNo);
    	}
    	 var data = {
    	            reqNo : reqNo,
    	            callType : 'view'
    	    };
    	    Common.popupDiv("/eAccounting/vendor/editVendorPop.do", data, null, true, "editVendorPop");
     }
}

function fn_vendorRequestPop(appvPrcssNo, clmType, costCenterName, costCenter, reqNo) {
    var data = {
            clmType : clmType
            ,appvPrcssNo : appvPrcssNo
            ,costCenterName : costCenterName
            ,costCenter : costCenter
            ,reqNo : reqNo
    };
    Common.popupDiv("/eAccounting/vendor/vendorRqstViewPop.do", data, null, true, "vendorRqstViewPop");
}

function fn_selectVendorList() {
    Common.ajax("GET", "/eAccounting/vendor/selectVendorList.do?_cacheId=" + Math.random(), $("#form_vendor").serialize(), function(result) {
    	console.log(result);
        AUIGrid.setGridData(vendorManagementGridID, result);
    });
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#regNo").val($("#search_gstRgistNo").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
    $("#costCentrName").val($("#search_costCentrName").val());
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
    /*var netAmtList = AUIGrid.getColumnValues(newGridID, "netAmt");
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
    }*/

    var totAmtList = AUIGrid.getColumnValues(newGridID, "totAmt");
    if(totAmtList.length > 0) {
        for(var i in totAmtList) {
            sum += totAmtList[i];
        }
    }
    return sum;
}

function fn_addRow() {
	if(AUIGrid.getRowCount(newGridID) > 0) {
		console.log("clamUn" + AUIGrid.getCellValue(newGridID, 0, "clamUn"));
		//AUIGrid.addRow(newGridID, {clamUn:AUIGrid.getCellValue(newGridID, 0, "clamUn"),cur:"MYR",netAmt:0,taxAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
		AUIGrid.addRow(newGridID, {clamUn:AUIGrid.getCellValue(newGridID, 0, "clamUn"),taxCode:"OP (Purchase(0%):Out of scope)",cur:AUIGrid.getCellValue(newGridID, 0, "cur"),totAmt:0}, "last");
	} else {
		Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J1"}, function(result) {
	        console.log(result);
	        //AUIGrid.addRow(newGridID, {clamUn:result.clamUn,cur:"MYR",netAmt:0,taxAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
	        AUIGrid.addRow(newGridID, {clamUn:result.clamUn,taxCode:"OP (Purchase(0%):Out of scope)",cur:"MYR",totAmt:0}, "last");
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
	console.log("fn_checkEmpty");
	var checkResult = true;
	/*
	if(FormUtil.isEmpty($("#invcDt").val())) {
        Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
        checkResult = false;
        return checkResult;
    }
	*/

    if(FormUtil.isEmpty($("#vendorGroup").val())) {
        Common.alert('Please choose a Vendor Group');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('Please choose a Cost Center');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#regCompName").val())) {
        Common.alert('Please enter the Registered Company / Individual Name');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#regCompNo").val())) {
        Common.alert('Please enter the Company No / IC No');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#bankAccHolder").val())) {
        Common.alert('Please enter the Account Holder');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#bankAccNo").val())) {
           Common.alert('Please enter the Bank Account Number');
           checkResult = false;
           return checkResult;
    }
    if(FormUtil.isEmpty($("#bankList").val())) {
           Common.alert('Please choose a Bank');
           checkResult = false;
           return checkResult;
    }
    if(conditionalCheck == 1 && FormUtil.isEmpty($("#swiftCode").val())) {
           Common.alert('Please enter Swift Code');
           checkResult = false;
           return checkResult;
    }
    console.log("attachTd: " + $('#form_newVendor input[type=file]').get(0).files.length);
    console.log("Hello World: " + $("input[name=attachTd]").length);
    console.log("inputText: " + $(".input_text").val());

    if($("input[name=attachTd]").length == 0 &&  $('#form_newVendor input[type=file]').get(0).files.length == 0 && FormUtil.isEmpty($(".input_text").val()))
    {
    	Common.alert('Please select an Attachment');
        checkResult = false;
        return checkResult;
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

    //if($('#form_newVendor input[type=file]').get(0).files.length == 0)
    //{
    	//if ($('#attachTd').get(0).files.length === 0) {
    	// if(($("#attachTd").length) - 1 < 0) {
    	//if($('#attachTd').val() == null || $('#attachTd').val() == '')
    	//{
    		//Common.alert('Please select an Attachment');
           // checkResult = false;
           // return checkResult;
    	//}
    	return checkResult;
    //}
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
                ,vendorGrp : $("#newVendorGroup").val()
                ,regCompName : $("#newRegCompName").val()
                ,regCompNo : $("#newRegCompNo").val()
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
                if(event.dataField == "netAmt" || event.dataField == "taxAmt" || event.dataField == "taxNonClmAmt" || event.dataField == "totAmt") {
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

                    var availableVar = {
                        costCentr : $("#newCostCenter").val(),
                        stYearMonth : $("#keyDate").val().substring(3),
                        stBudgetCode : event.item.budgetCode,
                        stGlAccCode : event.item.glAccCode
                    }

                    var availableAmtCp = 0;
                    Common.ajax("GET", "/eAccounting/webInvoice/checkBgtPlan.do", availableVar, function(result1) {
                        console.log(result1.ctrlType);

                        if(result1.ctrlType == "Y") {
                            Common.ajax("GET", "/eAccounting/webInvoice/availableAmtCp.do", availableVar, function(result) {
                                console.log("availableAmtCp");
                                console.log(result.totalAvailable);

                                var finAvailable = (parseFloat(result.totalAvilableAdj) - parseFloat(result.totalPending) - parseFloat(result.totalUtilized)).toFixed(2);

                                if(parseFloat(finAvailable) < parseFloat(event.item.totAmt)) {
                                    console.log("else if :: result.totalAvailable < event.item.totAmt");
                                    Common.alert("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
                                    console.log("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
                                    AUIGrid.setCellValue(newGridID, event.rowIndex, "netAmt", "0.00");
                                    AUIGrid.setCellValue(newGridID, event.rowIndex, "totAmt", "0.00");

                                    var totAmt = fn_getTotalAmount();
                                    $("#totalAmount").text(AUIGrid.formatNumber(totAmt, "#,##0.00"));
                                    console.log(totAmt);
                                    $("#totAmt").val(totAmt);
                                } else {
                                    var idx = AUIGrid.getRowCount(newGridID);

                                    console.log("Details count :: " + idx);

                                    for(var a = 0; a < idx; a++) {
                                        console.log("for a :: " + a);

                                        if(event.item.budgetCode == AUIGrid.getCellValue(newGridID, a, "budgetCode") && event.item.glAccCode == AUIGrid.getCellValue(newGridID, a, "glAccCode")) {
                                            availableAmtCp += AUIGrid.getCellValue(newGridID, a, "totAmt");
                                            console.log(availableAmtCp);
                                        }
                                    }

                                    if(result.totalAvailable < availableAmtCp) {
                                        console.log("else :: result.totalAvailable < availableAmtCp");

                                        Common.alert("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
                                        console.log("Insufficient budget amount available for Budget Code : " + event.item.budgetCode + ", GL Code : " + event.item.glAccCode + ". ");
                                        AUIGrid.setCellValue(newGridID, event.rowIndex, "netAmt", "0.00");
                                        AUIGrid.setCellValue(newGridID, event.rowIndex, "totAmt", "0.00");

                                        var totAmt = fn_getTotalAmount();
                                        $("#totalAmount").text(AUIGrid.formatNumber(totAmt, "#,##0.00"));
                                        console.log(totAmt);
                                        $("#totAmt").val(totAmt);


                                    }
                                }
                            });
                        }
                    });
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

                if(event.dataField == "cur") {
                    console.log("currency change");

                    var fCur = AUIGrid.getCellValue(newGridID, 0, "cur");

                    if(event.rowIndex != 0) {
                        if(AUIGrid.getRowCount(newGridID) > 1) {
                            var cCur = AUIGrid.getCellValue(newGridID, event.rowIndex, "cur");

                            if(cCur != fCur) {
                                Common.alert("Different currency selected!");
                                AUIGrid.setCellValue(newGridID, event.rowIndex, "cur", fCur);
                            }
                        }
                    } else {
                        for(var i = 1; i < AUIGrid.getRowCount(newGridID); i++) {
                            AUIGrid.setCellValue(newGridID, i, "cur", fCur);
                        }
                    }
                }
          });

    AUIGrid.bind(newGridID, "selectionChange", function(event) {
        if(event.dataField == "cur") {
            if(AUIGrid.getRowCount(newGridID > 1)) {
                var fCur = AUIGrid.getCellValue(newGridID, 0, "cur");
                var cCur = AUIGrid.getCellValue(newGridID, event.rowIndex, "cur");

                if(cCur != fCur) {
                    Common.alert("Different currency selected.");
                }
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

function fn_selectWebInvoiceInfo(clmNo) {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/webInvoice/selectWebInvoiceInfo.do?_cacheId=" + Math.random(), obj, fn_setWebInvoiceInfo);
}

function fn_report() {
    var option = {
        isProcedure : false
    };
    Common.report("dataForm", option);
}

function fn_setWebInvoiceInfo(result) {
	console.log("fn_setWebInvoiceInfo Action");
	console.log(result);
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
    $("#keyDate").val(result.keyInDt);
    $("#invcType").val(result.invcType);
    $("#invcNo").val(result.invcNo);
    $("#invcRem").val(result.invcRem);
    $("#gstRgistNo").val(result.gstRgistNo);
    $("#payDueDt").val(result.payDueDt);
    $("#utilNo").val(result.utilNo);
    $("#jPayNo").val(result.jPayNo);
    $("#bilPeriodF").val(result.bilPeriodF);
    $("#bilPeriodF").val(result.bilPeriodF);
    $("#invcRem").val(result.invcRem);

    AUIGrid.setGridData(newGridID, result.itemGrp);

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
}

function fn_editRejected() {
    console.log("fn_editRejected");

    var gridObj = AUIGrid.getSelectedItems(vendorManagementGridID);
    var list = AUIGrid.getCheckedRowItems(vendorManagementGridID);

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
            Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J1"}, function(result) {
                console.log(result);

                Common.ajax("POST", "/eAccounting/webInvoice/editRejected.do", {clmNo : selClmNo, clamUn : result.clamUn}, function(result1) {
                    console.log(result1);

                    Common.alert("New claim number : " + result1.data.newClmNo);
                })
            });
        } else {
            Common.alert("Only rejected claims are allowed to edit.");
        }
    } else {
        Common.alert("* No Value Selected. ");
        return;
    }
}

</script>

<style>
.cRange,
.cRange.w100p,
.w100p{width:100%!important;}
</style>

<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/Web_Invoice.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="123123" /> --><!-- Download Name -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="displayCostCenterName" name="displayCostCenterName" value="${costCenterName}"/><!-- View Type  -->

    <!-- params -->
    <input type="hidden" id="_reqNo" name="V_REQNO" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"></a></p>
<h2>Vendor Management</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <!--  <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newVendorPop()">New</a></p></li>-->
        <li><p class="btn_blue"><a href="#" id="new_vendor_btn">New</a></p></li>
        <li><p class="btn_blue"><a href="#" id="edit_vendor_btn">Edit</a></p></li>
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectVendorList()"><span class="search"></span>Search</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_vendor">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="costCenterText" name="costCenterText">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Supplier</th>
        <td>
		    <input type="text" id="memAccId" name="memAccId" class="search_btn" title="" placeholder="" class="fl_left"/>
		    <a href="#"  id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </td>
    <th scope="row">Company Registration No/IC</th>
        <td>
		    <input type="text" id="regNo" name="regNo" class="search_btn" title="" placeholder="" class="fl_left" />
		    <a href="#" id="search_regNo_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </td>
</tr>
<tr>
    <th scope="row">Request Date</th>
        <td>
            <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
                    <span>to</span>
                <p><input type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
            </div><!-- date_set end -->
        </td>
    <th scope="row">Cost Centre Code</th>
        <td>
            <input type="text" id="costCenter"" name="costCenter" class="search_btn" title="" placeholder="" class="fl_left"/>
            <a href="#"  id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </td>
</tr>
<tr>
    <th scope="row">Approval Date</th>
	    <td>
	        <div class="date_set w100p"><!-- date_set start -->
	            <p><input type="text" title="Approval Start Date" placeholder="DD/MM/YYYY" class="j_date" id="appStartDt" name="appStartDt"/></p>
	            <span>to</span>
	            <p><input type="text" title="Approval End Date" placeholder="DD/MM/YYYY" class="j_date" id="appEndDt" name="appEndDt"/></p>
	        </div><!-- date_set end -->
	    </td>
    <th scope="row">Status</th>
	    <td>
	       <select class="multy_select" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
		        <!--  <option value="T"><spring:message code="webInvoice.select.tempSave" /></option>
		        <option value="R"><spring:message code="webInvoice.select.request" /></option>
		        <option value="P"><spring:message code="webInvoice.select.progress" /></option>
		        <option value="A"><spring:message code="webInvoice.select.approved" /></option>
		        <option value="J"><spring:message code="pettyCashRqst.rejected" /></option>-->
		        <option value="T">Draft</option>
		        <option value="R">Request</option>
		        <option value="P">Pending for Approval</option>
		        <option value="A">Approved</option>
		        <option value="J">Rejected</option>
           </select>
	    </td>
</tr>
<tr>
    <th scope="row">Vendor Request Number</th>
        <td>
            <div class="date_set w100p"><!-- date_set start -->
            <p><input type="text" title="" id="vendorReqNoFrom" name="vendorReqNoFrom" class="cRange" /></p>
            <span>to</span>
            <p><input type="text" title="" id="vendorReqNoTo" name="vendorReqNoTo" class="cRange"  /></p>
        </div><!-- date_set end -->
        </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<%--
<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
            <ul class="btns">
                <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                    <li><p class="link_btn"><a href="#" id="_webInvBtn">Web Invoice</a></p></li>
                </c:if>
                <li><p class="link_btn"><a href="#" id="editRejBtn">Edit Rejected</a></p></li>
                <li><p class="link_btn"><a href="#" id="bulkWebInvDl">Bulk Web Invoice</a></p></li>
            </ul>
            <ul class="btns">
            </ul>
            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
</aside><!-- link_btns_wrap end -->
--%>

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="vendorManagement _grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
