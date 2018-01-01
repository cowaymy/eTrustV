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
//파일 저장 캐시
var myFileCaches = {};
// 최근 그리드 파일 선택 행 아이템 보관 변수
var recentGridItem = null;
var staffClaimColumnLayout = [ {
    dataField : "memAccId",
    headerText : '<spring:message code="smGmClaim.hpId" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="smGmClaim.smGmBrName" />',
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
var staffClaimGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
 // 헤더 높이 지정
    headerHeight : 40,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var staffClaimGridID;

$(document).ready(function () {
	staffClaimGridID = AUIGrid.create("#staffClaim_grid_wrap", staffClaimColumnLayout, staffClaimGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#registration_btn").click(fn_newStaffClaimPop);
    
    AUIGrid.bind(staffClaimGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + event.item.clmNo);
                console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
                console.log("CellDoubleClick appvPrcssStusCode : " + event.item.appvPrcssStusCode);
                // TODO detail popup open
                if(event.item.appvPrcssStusCode == "T") {
                	fn_viewStaffClaimPop(event.item.clmNo);
                } else {
                	fn_webInvoiceRequestPop(event.item.appvPrcssNo);
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
    /* $("#form_newStaffClaim").each(function() {
        this.reset();
    }); */
    
	if($(":input:radio[name=expGrp]:checked").val() == "1"){
        fn_destroyMileageGrid();
        fn_createMileageAUIGrid();
    } else {
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
    
    //clmSeq = 0;
}

function fn_setEvent() {
	$("#form_newStaffClaim :text").change(function(){
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
        } else if(id == "newCostCenter") {
            if(!FormUtil.isEmpty($("#newCostCenter").val())){
                Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:$("#newCostCenter").val()}, function(result) {
                    console.log(result);
                    if(result.length > 0) {
                        var row = result[0];
                        console.log(row);
                        $("#newCostCenterText").val(row.costCenterText);
                    }
                });
            }
        }
   });
	    
	 // 파일 선택하기
	    $('#file').on('change', function(evt) {
	        var data = null;
	        var file = evt.target.files[0];
	        if (typeof file == "undefined") {
	            console.log("파일 선택 시 취소!!");
	            
	            delete myFileCaches[selectRowIdx + 1];

	            AUIGrid.updateRow(mileageGridID, {
	                atchFileName :  ""
	            }, selectRowIdx);
	            return;
	        }
	        
	        /* if(file.size > 2048000) {
	            alert("개별 파일은 2MB 를 초과해선 안됩니다.");
	            return;
	        } */
	        
	        console.log(recentGridItem);
	        
	        // 서버로 보낼 파일 캐시에 보관
	        myFileCaches[selectRowIdx + 1  ] = {
	            file : file
	        };
	        
	        // 파일 수정이라면 수정하는 파일 아이디 보관
	        if(!FormUtil.isEmpty(recentGridItem.atchFileGrpId)) {
                update.push(recentGridItem.atchFileId);
                console.log(JSON.stringify(update));
            }

	        console.log("업로드 할 파일 선택 : \r\n" + file.name);
	        console.log(myFileCaches);
	        
	        // 선택 파일명 그리드에 출력 시킴
	        AUIGrid.updateRow(mileageGridID, {
	            atchFileName :  file.name
	        }, selectRowIdx);
	    });
	 
	    $(":input:radio[name=expGrp]").on('change', function(evt) {
	         fn_checkExpGrp();
	     });
	}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM09"}, null, true, "supplierSearchPop");
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
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM09"}, null, true, "supplierSearchPop");
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
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
                    $("#bankCode").val(row.bankCode);
                    $("#bankName").val(row.bankName);
                    $("#bankAccNo").val(row.bankAccNo);
                }
            });
        }
   }); 
}

function fn_PopExpenseTypeSearchPop() {
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J6'}, null, true, "expenseTypeSearchPop");
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

//AUIGrid 를 생성합니다.
function fn_createMileageAUIGrid() {
    // 이미 생성되어 있는 경우
    console.log("isCreated : " + AUIGrid.isCreated("#mileage_grid_wrap"));
    if(AUIGrid.isCreated("#mileage_grid_wrap")) {
        fn_destroyMileageGrid();
    }

    // 실제로 #grid_wrap 에 그리드 생성
    mileageGridID = AUIGrid.create("#mileage_grid_wrap", mileageGridColumnLayout, mileageGridPros);
    // AUIGrid 에 데이터 삽입합니다.
    //AUIGrid.setGridData("#mileage_grid_wrap", gridData);
}

// 그리드를 제거합니다.
function fn_destroyMileageGrid() {
    AUIGrid.destroy("#mileage_grid_wrap");
    mileageGridID = null;
}

function fn_mileageAdd() {
	if(AUIGrid.getRowCount(mileageGridID) > 0) {
        AUIGrid.addRow(mileageGridID, {clamUn:AUIGrid.getCellValue(mileageGridID, 0, "clamUn"),expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",carMilag:0,carMilagAmt:0,tollAmt:0,parkingAmt:0}, "last");
    } else {
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J6"}, function(result) {
            console.log(result);
            AUIGrid.addRow(mileageGridID, {clamUn:result.clamUn,expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",carMilag:0,carMilagAmt:0,tollAmt:0,parkingAmt:0}, "last");
        });
    }
}

function fn_popSubSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"sPop",accGrp:"VM09"}, null, true, "supplierSearchPop");
}

function fn_setPopSubSupplier() {
    $("#supplir").val($("#search_memAccId").val());
    $("#supplirName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
}

function fn_selectStaffClaimList() {
	Common.ajax("GET", "/eAccounting/smGmClaim/selectSmGmClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(staffClaimGridID, result);
    });
}

function fn_newStaffClaimPop() {
	Common.popupDiv("/eAccounting/smGmClaim/newSmGmClaimPop.do", {callType:"new"}, null, true, "newStaffClaimPop");
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccId").val())) {
        Common.alert('<spring:message code="smGmClaim.hpCode.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newClmMonth").val())) {
        Common.alert('<spring:message code="pettyCashExp.clmMonth.msg" />');
        checkResult = false;
        return checkResult;
    }
    // Expense Type Name == Car Mileage Expense
    //$("#expTypeName").val() == "Car Mileage Expense"
    // WebInvoice Test는 Test
    if($(":input:radio[name=expGrp]:checked").val() == "1"){
    	var length = AUIGrid.getGridData(mileageGridID).length;
        if(length > 0) {
            for(var i = 0; i < length; i++) {
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "carMilagDt"))) {
                    Common.alert('<spring:message code="staffClaim.date.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "locFrom"))) {
                    Common.alert('<spring:message code="staffClaim.from.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "locTo"))) {
                    Common.alert('<spring:message code="staffClaim.to.msgstaffClaim.to.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "purpose"))) {
                    Common.alert('<spring:message code="staffClaim.purpose.msg" />' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
            }
        } else {
        	Common.alert('<spring:message code="staffClaim.mileage.msg" />');
        	checkResult = false;
            return checkResult;
        }
    } else {
    	if(FormUtil.isEmpty($("#invcDt").val())) {
            Common.alert('<spring:message code="webInvoice.invcDt.msg" />');
            checkResult = false;
            return checkResult;
        }
        if($("#invcType").val() == "F") {
            if(FormUtil.isEmpty($("#supplirName").val())) {
            	Common.alert('<spring:message code="staffClaim.supplierName.msg" />');
                checkResult = false;
                return checkResult;
            }
            if(FormUtil.isEmpty($("#invcNo").val())) {
                Common.alert('<spring:message code="webInvoice.invcNo.msg" />');
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
    }
    return checkResult;
}

//AUIGrid 를 생성합니다.
function fn_createMyGrid() {
    // 이미 생성되어 있는 경우
    console.log("isCreated : " + AUIGrid.isCreated("#my_grid_wrap"));
    if(AUIGrid.isCreated("#my_grid_wrap")) {
        fn_destroyMyGrid();
    }

    // 실제로 #grid_wrap 에 그리드 생성
    myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);
    // AUIGrid 에 데이터 삽입합니다.
    //AUIGrid.setGridData("#mileage_grid_wrap", gridData);
    
    fn_myGridSetEvent();
}

// 그리드를 제거합니다.
function fn_destroyMyGrid() {
    AUIGrid.destroy("#my_grid_wrap");
    myGridID = null;
}

function fn_addMyGridRow() {
    if(AUIGrid.getRowCount(myGridID) > 0) {
        AUIGrid.addRow(myGridID, {clamUn:AUIGrid.getCellValue(myGridID, 0, "clamUn"),expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
    } else {
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J6"}, function(result) {
            console.log(result);
            AUIGrid.addRow(myGridID, {clamUn:result.clamUn,expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
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
        // Expense Type Name == Car Mileage Expense
        //$("#expTypeName").val() == "Car Mileage Expense"
        // WebInvoice Test는 Test
        if($(":input:radio[name=expGrp]:checked").val() == "1") {
        	// jQuery Ajax Form 사용
            var formData = new FormData();
            $.each(myFileCaches, function(n, v) {
            	console.log("n : " + n + " v.file : " + v.file);
                formData.append(n, v.file);
            });
        	if(clmSeq == 0) {
        		Common.ajaxFile("/eAccounting/smGmClaim/attachFileUpload.do", formData, function(result) {
                    console.log(result);
                    
                    var gridDataList = AUIGrid.getGridData(mileageGridID);
                    for(var i = 0; i < gridDataList.length; i++) {
                        var data = {
                        		costCentr : $("#newCostCenter").val(),
                                costCentrName : $("#newCostCenterText").val(),
                                memAccId : $("#newMemAccId").val(),
                                bankCode : $("#bankCode").val(),
                                bankAccNo : $("#bankAccNo").val(),
                                clmMonth : $("#newClmMonth").val(),
                                expType : "Z9000",
                                expTypeName : "Car Mileage Expense",
                                glAccCode : "9999999999",
                                glAccCodeName : "Car Mileage Expense",
                                budgetCode : "99999",
                                budgetCodeName : "Car Mileage Expense",
                                clamUn : gridDataList[i].clamUn,
                                expGrp : gridDataList[i].expGrp,
                        		carMilagDt : gridDataList[i].carMilagDt,
                        		locFrom : gridDataList[i].locFrom,
                        		locTo : gridDataList[i].locTo,
                        		cur : "MYR",
                        		carMilag : gridDataList[i].carMilag,
                        		carMilagAmt : gridDataList[i].carMilagAmt,
                        		tollAmt : gridDataList[i].tollAmt,
                        		parkingAmt : gridDataList[i].parkingAmt,
                        		purpose : gridDataList[i].purpose,
                        		expDesc : gridDataList[i].expDesc,
                        		gstBeforAmt : gridDataList[i].carMilagAmt + gridDataList[i].tollAmt + gridDataList[i].parkingAmt,
                        		gstAmt : 0,
                        		taxNonClmAmt : 0
                        }
                        data.atchFileGrpId = result.data.fileGroupKey
                        console.log(data);
                        AUIGrid.addRow(newGridID, data, "last");
                    }
                    
                    fn_getAllTotAmt();
                    
                    // Grid 초기화
                    fn_destroyMileageGrid();
                    fn_createMileageAUIGrid();
                });
        	} else {
        		formData.append("atchFileGrpId", atchFileGrpId);
                formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                
        		Common.ajaxFile("/eAccounting/smGmClaim/attachFileUpdate.do", formData, function(result) {
                    console.log(result);
                    
                    var gridDataList = AUIGrid.getGridData(mileageGridID);
                    for(var i = 0; i < gridDataList.length; i++) {
                        var data = {
                        		costCentr : $("#newCostCenter").val(),
                                costCentrName : $("#newCostCenterText").val(),
                                memAccId : $("#newMemAccId").val(),
                                bankCode : $("#bankCode").val(),
                                bankAccNo : $("#bankAccNo").val(),
                                clmMonth : $("#newClmMonth").val(),
                                expType : "Z9000",
                                expTypeName : "Car Mileage Expense",
                                glAccCode : "9999999999",
                                glAccCodeName : "Car Mileage Expense",
                                budgetCode : "99999",
                                budgetCodeName : "Car Mileage Expense",
                                clamUn : gridDataList[i].clamUn,
                                expGrp : gridDataList[i].expGrp,
                                carMilagDt : gridDataList[i].carMilagDt,
                                locFrom : gridDataList[i].locFrom,
                                locTo : gridDataList[i].locTo,
                                cur : "MYR",
                                carMilag : gridDataList[i].carMilag,
                                carMilagAmt : gridDataList[i].carMilagAmt,
                                tollAmt : gridDataList[i].tollAmt,
                                parkingAmt : gridDataList[i].parkingAmt,
                                purpose : gridDataList[i].purpose,
                                expDesc : gridDataList[i].expDesc,
                                gstBeforAmt : gridDataList[i].carMilagAmt + gridDataList[i].tollAmt + gridDataList[i].parkingAmt,
                                gstAmt : 0,
                                taxNonClmAmt : 0
                        }
                        console.log(data);
                        if(FormUtil.isEmpty(gridDataList[i].clmSeq)) {
                        	AUIGrid.addRow(newGridID, data, "last");
                        } else {
                        	AUIGrid.updateRow(newGridID, data, AUIGrid.rowIdToIndex(newGridID, gridDataList[i].clmSeq));
                        }
                    }
                    
                    console.log(data);
                    
                    fn_getAllTotAmt();
                    
                    clmSeq = 0;
                    
                    // Grid 초기화
                    fn_destroyMileageGrid();
                    fn_createMileageAUIGrid();
                });
        	}
        } else {
        	var formData = Common.getFormData("form_newStaffClaim");
        	if(clmSeq == 0) {
                var data = {
                		costCentr : $("#newCostCenter").val()
                        ,costCentrName : $("#newCostCenterText").val()
                        ,memAccId : $("#newMemAccId").val()
                        ,bankCode : $("#bankCode").val()
                        ,bankAccNo : $("#bankAccNo").val()
                        ,clmMonth : $("#newClmMonth").val()
                        ,supplir : $("#supplir").val()
                        ,supplirName : $("#supplirName").val()
                        ,invcType : $("#invcType").val()
                        ,invcTypeName : $("#invcType option:selected").text()
                        ,invcNo : $("#invcNo").val()
                        ,invcDt : $("#invcDt").val()
                        ,gstRgistNo : $("#gstRgistNo").val()
                        ,cur : "MYR"
                        ,expDesc : $("#expDesc").val()
                        ,gridData : GridCommon.getEditData(myGridID)
                };
                
                Common.ajaxFile("/eAccounting/smGmClaim/attachFileUpload.do", formData, function(result) {
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
                        ,bankCode : $("#bankCode").val()
                        ,bankAccNo : $("#bankAccNo").val()
                        ,clmMonth : $("#newClmMonth").val()
                        ,supplir : $("#supplir").val()
                        ,supplirName : $("#supplirName").val()
                        ,invcType : $("#invcType").val()
                        ,invcTypeName : $("#invcType option:selected").text()
                        ,invcNo : $("#invcNo").val()
                        ,invcDt : $("#invcDt").val()
                        ,gstRgistNo : $("#gstRgistNo").val()
                        ,cur : "MYR"
                        ,expDesc : $("#expDesc").val()
                        ,gridData : GridCommon.getEditData(myGridID)
                };
                
                $("#attachTd").html("");
                $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='file' title='file add' /><label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#' id='remove_btn' onclick='javascript:fn_getRemoveFileList()'>Delete</a></span></div>");
                
                formData.append("atchFileGrpId", atchFileGrpId);
                formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
                formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
                Common.ajaxFile("/eAccounting/smGmClaim/attachFileUpdate.do", formData, function(result) {
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
}

function fn_getAllTotAmt() {
    // allTotAmt GET, SET
    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues (newGridID, "totAmt", true);
    console.log(totAmtList.length);
    for(var i = 0; i < totAmtList.length; i++) {
        allTotAmt += totAmtList[i];
    }
    allTotAmt += "";
    console.log(allTotAmt);
    $("#allTotAmt_text").text(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
}

function fn_insertStaffClaimExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var data = {
                gridDataList : gridDataList
                ,allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
        }
        console.log(data);
        Common.ajax("POST", "/eAccounting/smGmClaim/insertSmGmClaimExp.do", data, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectStaffClaimItemList();
            
            if(st == "new"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#newStaffClaimPop").remove();
            }
            fn_selectStaffClaimList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_selectStaffClaimItemList() {
    var obj = {
            clmNo : clmNo
    };
    Common.ajax("GET", "/eAccounting/smGmClaim/selectSmGmClaimItemList.do?_cacheId=" + Math.random(), obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

function fn_viewStaffClaimPop(clmNo) {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };
    Common.popupDiv("/eAccounting/smGmClaim/viewSmGmClaimPop.do", data, null, true, "viewStaffClaimPop");
}

function fn_selectStaffClaimInfo() {
    var obj = {
            clmNo : clmNo
            ,clmSeq : clmSeq
            ,clamUn : clamUn
    };
    Common.ajax("GET", "/eAccounting/smGmClaim/selectSmGmClaimInfo.do", obj, function(result) {
        console.log(result);
        // Expense Type Name == Car Mileage Expense
        //$("#expTypeName").val() == "Car Mileage Expense"
        // WebInvoice Test는 Test
        if(result.expGrp == "1") {
        	console.log("carMileage_radio checked");
            $("#normalExp_radio").prop("checked", false);
            $("#carMileage_radio").prop("checked", true);
            fn_checkExpGrp();
            
        	$("#newCostCenter").val(result.costCentr);
            $("#newCostCenterText").val(result.costCentrName);
            $("#newMemAccId").val(result.memAccId);
            $("#newMemAccName").val(result.memAccName);
            $("#bankCode").val(result.bankCode);
            $("#bankName").val(result.bankName);
            $("#bankAccNo").val(result.bankAccNo);
            $("#newClmMonth").val(result.clmMonth);
            $("#expType").val(result.expType);
            $("#expTypeName").val(result.expTypeName);
            $("#glAccCode").val(result.glAccCode);
            $("#glAccCodeName").val(result.glAccCodeName);
            $("#budgetCode").val(result.budgetCode);
            $("#budgetCodeName").val(result.budgetCodeName);
        	
        	// TODO attachFile
            attachList = result.attachList;
            console.log(attachList);
            console.log(attachList.length);
            if(attachList.length > 0) {
                for(var i = 0; i < attachList.length; i++) {
                    result.itemGrp[i].atchFileId = attachList[i].atchFileId;
                    result.itemGrp[i].atchFileName = attachList[i].atchFileName;
                    var str = attachList[i].atchFileName.split(".");
                    result.itemGrp[i].fileExtsn = str[1];
                    result.itemGrp[i].fileCnt = 1;
                }
            }
            console.log(result);
            
            AUIGrid.setGridData(mileageGridID, result.itemGrp);
            
            AUIGrid.bind(mileageGridID, "cellDoubleClick", function( event ) {
                console.log("mileageGridID cellDoubleClick");
                if(event.dataField == "atchFileName") {
                    console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                    console.log("CellDoubleClick atchFileGrpId : " + event.item.atchFileGrpId + " CellDoubleClick atchFileId : " + event.item.atchFileId);
                    if(event.item.fileCnt > 1) {
                        atchFileGrpId = event.item.atchFileGrpId;
                        fn_fileListPop();
                    } else {
                        var data = {
                                atchFileGrpId : event.item.atchFileGrpId,
                                atchFileId : event.item.atchFileId
                        };
                        if(event.item.fileExtsn == "jpg" || event.item.fileExtsn == "png") {
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
            });
        } else {
        	console.log("normalExp_radio checked");
            $("#carMileage_radio").prop("checked", false);
            $("#normalExp_radio").prop("checked", true);
            fn_checkExpGrp();
            
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
                $("#form_newStaffClaim :file").change(function() {
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

function fn_fileListPop() {
    var data = {
            atchFileGrpId : atchFileGrpId
    };
    Common.popupDiv("/eAccounting/webInvoice/fileListPop.do", data, null, true, "fileListPop");
}

function fn_updateStaffClaimExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var gridDataObj = GridCommon.getEditData(newGridID);
        gridDataObj.clmNo = clmNo;
        gridDataObj.allTotAmt = Number($("#allTotAmt_text").text().replace(/,/gi, ""));
        console.log(gridDataObj);
        Common.ajax("POST", "/eAccounting/smGmClaim/updateSmGmClaimExp.do", gridDataObj, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectStaffClaimItemList();
            if(st == "view"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#viewStaffClaimPop").remove();
            }
            fn_selectStaffClaimList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_approveLinePop() {
    // tempSave를 하지 않고 바로 submit인 경우
    if(FormUtil.isEmpty(clmNo)) {
    	fn_insertStaffClaimExp("");
    } else {
        // 바로 submit 후에 appvLinePop을 닫고 재수정 대비
        fn_updateStaffClaimExp("");
    }
    
    Common.popupDiv("/eAccounting/smGmClaim/approveLinePop.do", null, null, true, "approveLineSearchPop");
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
			allTotAmt : $("#allTotAmt_text").text().replace(/,/gi, "")
	};
	console.log(data);
	Common.ajax("POST", "/eAccounting/smGmClaim/deleteSmGmClaimExp.do", data, function(result) {
        console.log(result);
       
        // function 호출 안되서 ajax 직접호출
        Common.ajax("GET", "/eAccounting/smGmClaim/selectSmGmClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(staffClaimGridID, result);
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

function fn_checkExpGrp() {
    // Expense Type Name == Car Mileage Expense
    //$("#expTypeName").val() == "Car Mileage Expense"
    // WebInvoice Test는 Test
    console.log("checkExpGrp Action");
    if($(":input:radio[name=expGrp]:checked").val() == "1") {
        console.log("createMileageGrid");
        $("#noMileage").hide();
        $("#myGird_btn").hide();
        fn_destroyMyGrid();
        fn_clearData();
        //fn_createMileageAUIGrid();
        $("#mileage_btn").show();
    } else {
        console.log("createMyGrid");
        $("#mileage_btn").hide();
        $("#noMileage").show();
        fn_destroyMileageGrid();
        fn_clearData();
        //fn_createMyGrid();
        $("#myGird_btn").show();
    }
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
                        } else {
                            taxAmt = event.value;
                            if(event.item.oriTaxAmt > taxAmt) {
                                taxNonClmAmt = event.item.oriTaxAmt - taxAmt;
                            } else {
                                taxNonClmAmt = taxAmt - event.item.oriTaxAmt;
                            }
                            AUIGrid.setCellValue(myGridID, event.rowIndex, "gstAmt", taxAmt);
                            AUIGrid.setCellValue(myGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
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

function fn_webInvoiceRequestPop(appvPrcssNo) {
    var data = {
            appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/webInvoiceRqstViewPop.do", data, null, true, "webInvoiceRqstViewPop");
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="smGmClaim.title" /></h2>
<ul class="right_btns">
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectStaffClaimList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_staffClaim">
<input type="hidden" id="memAccName" name="memAccName">

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
	<th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
    <td><input type="text" title="Create start Date" placeholder="MM/YYYY" class="j_date2" id="clmMonth" name="clmMonth"/></td>
	<th scope="row"><spring:message code="smGmClaim.hpId" /></th>
	<td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row" ><spring:message code="webInvoice.status" /></th>
	<td colspan="3">
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
	<li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="pettyCashExp.newExpClm" /></a></p></li>
	</c:if>
</ul>

<article class="grid_wrap" id="staffClaim_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->