<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/moment.min.js"></script>

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
    headerText : '<spring:message code="staffClaim.staffCode" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="staffClaim.staffName" />',
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
},
{
	dataField:"isResubmitAllowed",
	visible:false
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
    $("#newExpStaffClaim").click(fn_NewClaimPop);
    $("#_staffClaimBtn").click(function() {

        //Param Set
        var gridObj = AUIGrid.getSelectedItems(staffClaimGridID);


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
                	var clmNo = event.item.clmNo;
                    var clmType = clmNo.substr(0, 2);
                	fn_webInvoiceRequestPop(event.item.appvPrcssNo, clmType);
                }

            });

    $("#appvPrcssStus").multipleSelect("checkAll");

    //fn_setToMonth();

    /* if('${clmNo}' != null && '${clmNo}' != "") {
        $("#clmMonth").val("");

        $("#clmNo").val('${clmNo}');
        $("#clmMonth").val('${period}');
 */
        fn_selectStaffClaimList();

    /*     Common.ajax("POST", "")
     }
        */


    	// Edit rejected staff claim
    	$("#editRejectBtn").click(fn_editRejected);
});

function fn_NewClaimPop() {
    Common.popupDiv("/newClaim/newPop.do", {callType:"new", claimType:"J2"}, null, true, "newClaimPop");
}

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

    update = new Array();
    remove = new Array();
    myFileCaches = {}
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
// 	        else if(id == "gstRgistNo") {
// 	        	if($("#invcType").val() == "F") {
// 	                var gstRgistNo = $(this).val();
// 	                console.log(gstRgistNo);
// 	                /*if(gstRgistNo.length != 12) {
// 	                    Common.alert('Please insert 12 digits GST Registration No');
// 	                    $("#gstRgistNo").val("");
// 	                }*/
// 	            }
// 	        }
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
	        myFileCaches[selectRowIdx + 1] = {
	            file : file
	        };

	        // 파일 수정이라면 수정하는 파일 아이디 보관
	        if(!FormUtil.isEmpty(recentGridItem.atchFileGrpId)) {
            	update.push({selectRowIdx:selectRowIdx+1,atchFileGrpId:recentGridItem.atchFileGrpId,atchFileId:recentGridItem.atchFileId});
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
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J4'}, null, true, "expenseTypeSearchPop");
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
    fn_mileageGridSetEvent();

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
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J4"}, function(result) {
            console.log(result);
            AUIGrid.addRow(mileageGridID, {clamUn:result.clamUn,expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",carMilag:0,carMilagAmt:0,tollAmt:0,parkingAmt:0}, "last");
        });
    }
}

function fn_popSubSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"sPop",accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_setPopSubSupplier() {
    $("#supplir").val($("#search_memAccId").val());
    $("#supplirName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
}

function fn_selectStaffClaimList() {
// 	Common.ajax("GET", "/eAccounting/staffClaim/selectStaffClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
//         console.log(result);
//         AUIGrid.setGridData(staffClaimGridID, result);
//     });

//     if("${PAGE_AUTH.funcView}" == 'Y'){
//         Common.ajax("GET", "/eAccounting/staffClaim/selectStaffClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
//             console.log(result);
//             AUIGrid.setGridData(staffClaimGridID, result);
//         });
//     }

    Common.ajax("GET", "/eAccounting/staffClaim/selectStaffClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(staffClaimGridID, result);
    });
}

function fn_newStaffClaimPop() {
	Common.popupDiv("/eAccounting/staffClaim/newStaffClaimPop.do", {callType:"new"}, null, true, "newStaffClaimPop");
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
    // Expense Type Name == Car Mileage Expense
    //$("#expTypeName").val() == "Car Mileage Expense"
    // WebInvoice Test는 Test
    //Fix checking
    if($(":input:radio[name=expGrp]:checked").val() == "1"){
    	var length = AUIGrid.getGridData(mileageGridID).length;
        if(length > 0) {
            for(var i = 0; i < length; i++) {
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "carMilagDt"))) {
                    Common.alert('<spring:message code="staffClaim.date.msg" /> ' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "locFrom"))) {
                    Common.alert('<spring:message code="staffClaim.from.msg" /> ' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "locTo"))) {
                    Common.alert('<spring:message code="staffClaim.to.msg" /> ' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(AUIGrid.getCellValue(mileageGridID, i, "carMilag") == 0 && AUIGrid.getCellValue(mileageGridID, i, "tollAmt") == 0 && AUIGrid.getCellValue(mileageGridID, i, "parkingAmt") == 0){
                    Common.alert('Mileage,Tolls and Parking is 0.00 for Line ' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "purpose"))) {
                    Common.alert('<spring:message code="staffClaim.purpose.msg" /> ' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
                if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "expDesc"))) {
                    Common.alert('Please fill in Remark of Line ' + (i +1) + ".");
                    checkResult = false;
                    return checkResult;
                }
//                 if(FormUtil.isEmpty(AUIGrid.getCellValue(mileageGridID, i, "atchFileName"))) {
//                     Common.alert('Attachment not found for Line ' + (i +1) + ".");
//                     checkResult = false;
//                     return checkResult;
//                 }
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
    	//not sure about this invcType F/S checking
        //if($("#invcType").val() == "F") { //not used anymore
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
            if(FormUtil.isEmpty($("#expDesc").val())) {
                Common.alert('Please fill in remark');
                checkResult = false;
                return checkResult;
            }
//             if(FormUtil.isEmpty($("#gstRgistNo").val())) {
//                 Common.alert('Please enter GST Rgist No.');
//                 checkResult = false;
//                 return checkResult;
//             }

// Requested to ignore attachment compulsory
//         $("#attachTd input[type='file']").each(function() {
//         	if(FormUtil.isEmpty($(this).val())){
//         		Common.alert('Attachment is required.');
//                 checkResult = false;
//                 return checkResult;
//         	}
//         });
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
                    if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "totAmt"))) {
                        Common.alert('Please enter the Total Amount of Line ' + (i +1) + ".");
                        checkResult = false;
                        return checkResult;
                    }
                    else{
                        var totAmt = AUIGrid.getCellValue(myGridID, i, "totAmt");

                        if(totAmt == 0){
                        	Common.alert('Total Amount must be bigger than 0 for Line ' + (i +1) + ".");
                            checkResult = false;
                            return checkResult;
                        }
                    }
//                     if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "gstBeforAmt"))) {
//                         Common.alert('<spring:message code="pettyCashExp.amtBeforeGstOfLine.msg" />' + (i +1) + ".");
//                         checkResult = false;
//                         return checkResult;
//                     }
                }
            }
        //}
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
        AUIGrid.addRow(myGridID, {clamUn:AUIGrid.getCellValue(myGridID, 0, "clamUn"),taxCode:"OP (Purchase(0%):Out of scope)",expGrp:$(":input:radio[name=expGrp]:checked").val(),cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
    } else {
        Common.ajax("GET", "/eAccounting/webInvoice/selectClamUn.do?_cacheId=" + Math.random(), {clmType:"J4"}, function(result) {
            console.log(result);
            AUIGrid.addRow(myGridID, {clamUn:result.clamUn,expGrp:$(":input:radio[name=expGrp]:checked").val(),taxCode:"OP (Purchase(0%):Out of scope)",cur:"MYR",gstBeforAmt:0,gstAmt:0,taxNonClmAmt:0,totAmt:0}, "last");
        });
    }
}

function fn_removeMyGridRow() {
    AUIGrid.removeRow(myGridID, selectRowIdx);

	var gridData = GridCommon.getEditData(myGridID);
	 if(gridData.remove.length > 0) {
         for(var i = 0; i < gridData.remove.length; i++) {
        	 console.log(gridData.remove[i].clmSeq);
         }
     }
}

function fn_addCarMilleage(){
    Common.showLoader();
 	console.log("Car Mileage Expense Add");
	var gridDataList = AUIGrid.getGridData(mileageGridID);
    for(var i = 0; i < gridDataList.length; i++) {
    	// jQuery Ajax Form 사용
        var formData = new FormData();
        var data = {
        		costCentr : $("#newCostCenter").val(),
                costCentrName : $("#newCostCenterText").val(),
                memAccId : $("#newMemAccId").val(),
                bankCode : $("#bankCode").val(),
                bankAccNo : $("#bankAccNo").val(),
                clmMonth : $("#newClmMonth").val(),
                expType : "J4001",
                expTypeName : "Car Mileage",
                glAccCode : "61130110",
                glAccCodeName : "TRAVELLING CLAIM - LOCAL (LAND/SEA TRANSPORT)",
                budgetCode : "01311",
                budgetCodeName : "Local travel - Milleage",
                clamUn : gridDataList[i].clamUn,
                expGrp : gridDataList[i].expGrp,
        		carMilagDt : moment(new Date(gridDataList[i].carMilagDt)).format('YYYY/MM/DD'),
        		locFrom : gridDataList[i].locFrom,
        		locTo : gridDataList[i].locTo,
        		cur : "MYR",
        		carMilag : gridDataList[i].carMilag,
        		carMilagAmt : gridDataList[i].carMilagAmt,
        		tollAmt : gridDataList[i].tollAmt,
        		parkingAmt : gridDataList[i].parkingAmt,
        		purpose : gridDataList[i].purpose,
        		expDesc : gridDataList[i].expDesc,
        		totAmt : gridDataList[i].carMilagAmt + gridDataList[i].tollAmt + gridDataList[i].parkingAmt,
        		gstAmt : 0,
        		taxNonClmAmt : 0,
                expGrp : "1"
        }

			$.each(myFileCaches, function(n, v) {
			     console.log("n : " + n + " v.file : " + v.file);
			     if(n == (i+1)){
			      formData.append(n, v.file);
			     }
			});

			Common.ajaxFileNoSync("/eAccounting/staffClaim/attachFileUpload.do", formData, function(result) {
	            console.log(result);
	            if(result.data.fileGroupKey){
	                data.atchFileGrpId = result.data.fileGroupKey
	            }
	            console.log(data);
	            AUIGrid.addRow(newGridID, data, "last");
			});
    }

    fn_getAllTotAmt();

    // Grid 초기화
    fn_destroyMileageGrid();
    fn_createMileageAUIGrid();
    setTimeout(function() {
        Common.removeLoader();
    }, 1000);
}

function  fn_updateCarMilleage(){
    Common.showLoader();
    var formData = new FormData();
    var existingGridNewAttachmentAddArray = new Array();
    var finalSelectedRow = 0;
    $.each(update, function(n){
    	if(finalSelectedRow < update[n].selectRowIdx){
    		finalSelectedRow = update[n].selectRowIdx;
    	}
    });

    $.each(myFileCaches, function(n, v) {
    	n = parseInt(n);
    	if(n <= finalSelectedRow){
    		if (update.filter(function(e) { return e.selectRowIdx == n; }).length > 0) {
                formData.append(n, v.file);
    		}
    		else{
    			existingGridNewAttachmentAddArray.push(n);
    		}
    	}
    	else{
			existingGridNewAttachmentAddArray.push(n);
    	}
    });

	console.log("Car Mileage Expense Update")
    formData.append("update", JSON.stringify(update));
    console.log(JSON.stringify(update));
    formData.append("remove", JSON.stringify(remove));
    console.log(JSON.stringify(remove));

	Common.ajaxFileNoSync("/eAccounting/staffClaim/attachFileUpdate.do", formData, function(result) {
        console.log(result);
    });
        var gridDataList = AUIGrid.getGridData(mileageGridID);
        for(var i = 0; i < gridDataList.length; i++) {
            var data = {
            		costCentr : $("#newCostCenter").val(),
                    costCentrName : $("#newCostCenterText").val(),
                    memAccId : $("#newMemAccId").val(),
                    bankCode : $("#bankCode").val(),
                    bankAccNo : $("#bankAccNo").val(),
                    clmMonth : $("#newClmMonth").val(),
                    expType : "J4001",
                    expTypeName : "Car Mileage",
                    glAccCode : "61130110",
                    glAccCodeName : "TRAVELLING CLAIM - LOCAL (LAND/SEA TRANSPORT)",
                    budgetCode : "01311",
                    budgetCodeName : "Local travel - Milleage",
                    clamUn : gridDataList[i].clamUn,
                    expGrp : gridDataList[i].expGrp,
                    carMilagDt : moment(new Date(gridDataList[i].carMilagDt)).format('YYYY/MM/DD'),
                    locFrom : gridDataList[i].locFrom,
                    locTo : gridDataList[i].locTo,
                    cur : "MYR",
                    carMilag : gridDataList[i].carMilag,
                    carMilagAmt : gridDataList[i].carMilagAmt,
                    tollAmt : gridDataList[i].tollAmt,
                    parkingAmt : gridDataList[i].parkingAmt,
                    purpose : gridDataList[i].purpose,
                    expDesc : gridDataList[i].expDesc,
                    totAmt : gridDataList[i].carMilagAmt + gridDataList[i].tollAmt + gridDataList[i].parkingAmt,
                    gstAmt : 0,
                    taxNonClmAmt : 0,
                    expGrp : "1"
            }
            console.log(data);
            if(FormUtil.isEmpty(gridDataList[i].clmSeq)) {
            	//For new detail record under existing detail record
            	 var formDataAdd = new FormData();
                 $.each(myFileCaches, function(n, v) {
                 	console.log("n : " + n + " v.file : " + v.file);
                 	if(n == (i+1)){
                 		formDataAdd.append(n, v.file);
                 	}
                 });

            	Common.ajaxFileNoSync("/eAccounting/staffClaim/attachFileUpload.do", formDataAdd, function(result) {
                    console.log(result);
                    if(result.data.fileGroupKey){
                        data.atchFileGrpId = result.data.fileGroupKey
                    }
                    console.log(data);
                    AUIGrid.addRow(newGridID, data, "last");
        		});
            } else {
            	//new attachment upload to existing record with empty attachment
            	if(existingGridNewAttachmentAddArray.filter(function(e) { return e == i+1; }).length > 0){
            		var formDataAddToExist = new FormData();
                    $.each(myFileCaches, function(n, v) {
                    	console.log("n : " + n + " v.file : " + v.file);
                    	if(n == (i+1)){
                    		formDataAddToExist.append(n, v.file);
                    	}
                    });

                	Common.ajaxFileNoSync("/eAccounting/staffClaim/attachFileUpload.do", formDataAddToExist, function(result) {
                        console.log(result);
                        if(result.data.fileGroupKey){
                            data.atchFileGrpId = result.data.fileGroupKey
                        }
                    	AUIGrid.updateRow(newGridID, data, AUIGrid.rowIdToIndex(newGridID, gridDataList[i].clmSeq));
            		});
            	}
            	//update has been done above where attachment is replaced with existing atchGroupId and fileId
            	else{
                	AUIGrid.updateRow(newGridID, data, AUIGrid.rowIdToIndex(newGridID, gridDataList[i].clmSeq));
            	}
            }
        }

        console.log(data);
        fn_getAllTotAmt();
        clmSeq = 0;
        // Grid 초기화
        fn_destroyMileageGrid();
        fn_createMileageAUIGrid();
        setTimeout(function() {
            Common.removeLoader();
        }, 1000);
}

function fn_addNormalExpenses(){
	var formData = Common.getFormData("form_newStaffClaim");
	console.log("Normal Expense Add")
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
    Common.ajaxFile("/eAccounting/staffClaim/attachFileUpload.do", formData, function(result) {
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
}

function fn_updateNormalExpenses(){
	var formData = Common.getFormData("form_newStaffClaim");
	console.log("Normal Expense Update")
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

    formData.append("update", JSON.stringify(update));
    console.log(JSON.stringify(update));
    formData.append("remove", JSON.stringify(remove));
    console.log(JSON.stringify(remove));

    if(atchFileGrpId){
    	//update if existing atchFileGrpId exist
    	formData.append("atchFileGrpId", atchFileGrpId);
	    Common.ajaxFile("/eAccounting/staffClaim/attachFileUpdate.do", formData, function(result) {
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
    else {
    	//use to capture unchanged update data if exist so that able to handle upload attachment if no update is being done
    	if(data.gridData.update.length == 0){
    		var allGridData = GridCommon.getGridData(myGridID);
    		if(allGridData && allGridData.all){
    			var value = allGridData.all;

        		if(data.gridData.add.length > 0){
        			for(var i =0; i<data.gridData.add.length;i++){
        				value = value.filter(function(val, index, a) {
        				    return (val.clmSeq !== data.gridData.add[i].clmSeq);
        				});
            		}
        		}

        		if(data.gridData.remove.length > 0){
        			for(var i =0; i<data.gridData.add.length;i++){
        				value = value.filter(function(val, index, a) {
        				    return (val.clmSeq !== data.gridData.add[i].clmSeq);
        				});
            		}
        		}

        		for(var i =0; i<value.length;i++){
            		data.gridData.update.push(value[i]);
        		}
    		}
    	}

    	//upload file if existing record did not update attachment before
    	Common.ajaxFile("/eAccounting/staffClaim/attachFileUpload.do", formData, function(result) {
            console.log(result);

            data.atchFileGrpId = result.data.fileGroupKey;

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
	                data.gridData.add[i].atchFileGrpId = result.data.fileGroupKey;
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
	                data.gridData.update[i].atchFileGrpId = result.data.fileGroupKey;
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
}

function fn_addRow() {
	console.log("fn_addRow Action");
    // 파일 업로드 전에 필수 값 체크
    // 파일 업로드 후 그룹 아이디 값을 받아서 Add
    if(fn_checkEmpty()) {
        // Expense Type Name == Car Mileage Expense
        //$("#expTypeName").val() == "Car Mileage Expense"
        // WebInvoice Test는 Test
        console.log($(":input:radio[name=expGrp]:checked").val());
        if($(":input:radio[name=expGrp]:checked").val() == "1") {
        	console.log("Car Mileage Expense");
            console.log(clmSeq);
        	if(clmSeq == 0) {
        		fn_addCarMilleage();
        	} else {
        		fn_updateCarMilleage();
        	}
        } else {
        	console.log("Normal Expense");
        	console.log(clmSeq);
        	if(clmSeq == 0) {
        		fn_addNormalExpenses();
            } else {
            	fn_updateNormalExpenses();
            }

            fn_clearData();
        }

    }
}

function fn_getAllTotAmt() {
    // allTotAmt GET, SET
    var allTotAmt = 0.00;
    var totAmtList = AUIGrid.getColumnValues(newGridID, "totAmt", true);
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

function fn_insertStaffClaimExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var data = {
                gridDataList : gridDataList
                ,allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
        }
        console.log(data);
        Common.ajax("POST", "/eAccounting/staffClaim/insertStaffClaimExp.do", data, function(result) {
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
    Common.ajax("GET", "/eAccounting/staffClaim/selectStaffClaimItemList.do?_cacheId=" + Math.random(), obj, function(result) {
        console.log(result);
        AUIGrid.setGridData(newGridID, result);
    });
}

function fn_viewStaffClaimPop(clmNo) {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };
    Common.popupDiv("/eAccounting/staffClaim/viewStaffClaimPop.do", data, null, true, "viewStaffClaimPop");
}

function fn_selectStaffClaimInfo() {
	if(!Number.isInteger(clmSeq)){
		Common.alert("This is a new record. Please save before able to view");
		return false;
	}

    var obj = {
            clmNo : clmNo
            ,clmSeq : clmSeq
            ,clamUn : clamUn
    };
    Common.ajax("GET", "/eAccounting/staffClaim/selectStaffClaimInfo.do?_cacheId=" + Math.random(), obj, fn_setStaffClaimInfo);
}

function fn_setStaffClaimInfo(result) {
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
        //$("#newClmMonth").val(result.clmMonth);
        $("#expType").val(result.expType);
        $("#expTypeName").val(result.expTypeName);
        $("#glAccCode").val(result.glAccCode);
        $("#glAccCodeName").val(result.glAccCodeName);
        $("#budgetCode").val(result.budgetCode);
        $("#budgetCodeName").val(result.budgetCodeName);

        for(var i = 0; i < result.itemGrp.length; i++) {
        	if(result.itemGrp[i].attachList){
                attachList = result.itemGrp[i].attachList;
        		for(var j = 0; j < attachList.length; j++) {
        			result.itemGrp[i].atchFileId = attachList[j].atchFileId;
	                 result.itemGrp[i].atchFileName = attachList[j].atchFileName;
	                 var str = attachList[j].atchFileName.split(".");
	                 result.itemGrp[i].fileExtsn = str[1];
	                 result.itemGrp[i].fileCnt = 1;
        		}
        	}
        }
        console.log(result);
        myFileCaches = {};

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
                    if(event.item.fileExtsn == "jpg" || event.item.fileExtsn == "png" || event.item.fileExtsn == "gif") {
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
                            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
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
        attachList = result.itemGrp[0].attachList;
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
                $("#form_newStaffClaim :file").change(function() {
                    var div = $(this).parents(".auto_file2");
                    var oriFileName = div.find(":text").val();
                    console.log(oriFileName);
                    for(var i = 0; i < attachList.length; i++) {
                        if(attachList[i].atchFileName == oriFileName) {
                        	update.push({atchFileGrpId:attachList[i].atchFileGrpId,atchFileId:attachList[i].atchFileId});
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
                        	remove.push({atchFileGrpId:attachList[i].atchFileGrpId,atchFileId:attachList[i].atchFileId});
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

function fn_fileListPop() {
    var data = {
            atchFileGrpId : atchFileGrpId
    };
    Common.popupDiv("/eAccounting/webInvoice/fileListPop.do", data, null, true, "fileListPop");
}

function fn_updateStaffClaimExp(st) {
	if(FormUtil.isEmpty($("#newCostCenter").val())) {
	      Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
	      return false;
	}
	if(FormUtil.isEmpty($("#newMemAccId").val())) {
	    Common.alert('<spring:message code="staffClaim.staffCode.msg" />');
	      return false;
	}
	if(FormUtil.isEmpty($("#newClmMonth").val())) {
	    Common.alert('<spring:message code="pettyCashExp.clmMonth.msg" />');
	      return false;
	}

    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var gridDataObj = GridCommon.getEditData(newGridID);
        gridDataObj.clmNo = clmNo;
        gridDataObj.allTotAmt = Number($("#allTotAmt_text").text().replace(/,/gi, ""));
        gridDataObj.costCentr = $("#newCostCenter").val();
        gridDataObj.costCentrName = $("#newCostCenterText").val();
        gridDataObj.memAccId = $("#newMemAccId").val();
        gridDataObj.bankCode = $("#bankCode").val();
        gridDataObj.bankAccNo = $("#bankAccNo").val();
        gridDataObj.clmMonth = $("#newClmMonth").val();
        console.log(gridDataObj);
        Common.ajax("POST", "/eAccounting/staffClaim/updateStaffClaimExp.do", gridDataObj, function(result) {
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

function fn_approveLinePop(memAccId, clmMonth, costCentre) {
	// check request - Request once per user per month
    Common.ajax("POST", "/eAccounting/staffClaim/checkOnceAMonth.do?_cacheId=" + Math.random(), {clmType:"J4", memAccId:memAccId, clmMonth:clmMonth}, function(result) {
        console.log(result);
        if(result.data > 0) {
        	Common.alert(result.message);
        } else {
        	// tempSave를 하지 않고 바로 submit인 경우
            if(FormUtil.isEmpty(clmNo)) {
                fn_insertStaffClaimExp("");
            } else {
                // 바로 submit 후에 appvLinePop을 닫고 재수정 대비
                fn_updateStaffClaimExp("");
            }

            Common.popupDiv("/eAccounting/staffClaim/approveLinePop.do", {clmType:"J4", memAccId:memAccId, clmMonth:clmMonth}, null, true, "approveLineSearchPop");
        }
    });
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
	Common.ajax("POST", "/eAccounting/staffClaim/deleteStaffClaimExp.do", data, function(result) {
        console.log(result);

        // function 호출 안되서 ajax 직접호출
        Common.ajax("GET", "/eAccounting/staffClaim/selectStaffClaimList.do?_cacheId=" + Math.random(), $("#form_staffClaim").serialize(), function(result) {
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

function fn_mileageGridSetEvent() {
	AUIGrid.bind(mileageGridID, "cellEditEnd", function( event ) {
        if(event.dataField == "carMilag") {
        	var result = 0;
            var oriCarMilag = event.item.carMilag;
            var reCarMilag = 0;
            var totCarMilag = fn_getTotCarMilag(event.rowIndex);
            // 2019-06-07 - New policy update
            result = oriCarMilag * 0.7;

            /*if(totCarMilag > 600) {
                result = oriCarMilag * 0.5;
            } else {
            	if(totCarMilag == 0) {
            		if((totCarMilag + oriCarMilag) > 600) {
                        reCarMilag = 600 - totCarMilag;
                        if(oriCarMilag > reCarMilag) {
                            oriCarMilag = oriCarMilag - reCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        } else {
                            oriCarMilag = reCarMilag - oriCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        }
                    } else {
                        result = oriCarMilag * 0.7;
                    }
            	} else {
            		if((totCarMilag + oriCarMilag) > 600) {
            			reCarMilag = 600 - totCarMilag;
                        if(oriCarMilag > reCarMilag) {
                            oriCarMilag = oriCarMilag - reCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        } else {
                            oriCarMilag = reCarMilag - oriCarMilag;
                            result = (oriCarMilag * 0.5) + (reCarMilag * 0.7);
                        }
            		} else {
            			result = oriCarMilag * 0.7;
            		}
            	}
            }*/
            AUIGrid.setCellValue(mileageGridID, event.rowIndex, "carMilagAmt", result);
        }
  });
}

function fn_getTotCarMilag(rowIndex) {
    var totCarMilag = 0;
    // 필터링이 된 경우 필터링 된 상태의 값만 원한다면 false 지정
    var amtArr = AUIGrid.getColumnValues(mileageGridID, "carMilag", true);
    console.log(amtArr);
    for(var i = 0; i < amtArr.length; i++) {
    	totCarMilag += amtArr[i];
    }
    // 0번째 행의 name 칼럼의 값 얻기
    var value = AUIGrid.getCellValue(mileageGridID, rowIndex, "carMilag");
    console.log(totCarMilag);
    console.log(value);
    totCarMilag -= value;
    console.log("totCarMilag : " + totCarMilag);
    return totCarMilag;
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

function fn_editRejected(){
    console.log("fn_editRejected");

    var gridObj = AUIGrid.getSelectedItems(staffClaimGridID);

    if(gridObj != "") {
        var selectedClaimNo;
        var status;
        var isResubmitAllowed;

        if(gridObj.length > 0) {
            status = gridObj[0].item.appvPrcssStus;
            selectedClaimNo = gridObj[0].item.clmNo;
            isResubmitAllowed = undefinedCheck(gridObj[0].item.isResubmitAllowed);
            if(status == "Rejected"){
           		if(isResubmitAllowed === 0){
                       Common.alert("Resubmit is not allowed for Claim No: " + selectedClaimNo);
                       return false;
           		}
           		var clmMonth = new Date(gridObj[0].item.clmMonth).getMonth() + 1;
           		var currentMonth = new Date().getMonth() + 1;
           		if((currentMonth - clmMonth) > 2){
                    Common.alert("The resubmission has exceeded 2 months. Please create New Expense Claim for Claim No: " + selectedClaimNo);
                    return false;
           		}
            	Common.ajax("POST", "/eAccounting/staffClaim/editRejectedClaim.do", {clmNo : selectedClaimNo}, function(result1) {
                    Common.alert("New claim number : " + result1.data.newClmNo);
                    fn_selectStaffClaimList();
             	});
            }
            else{
            	Common.alert("Please select a record with rejected status only.");
            	return false;
            }
        }
        else{
        	Common.alert("No record selected. Please select a record.");
        	return false;
        }
    }
    else{
    	Common.alert("No record selected. Please select a record.");
    	return false;
    }
}

function undefinedCheck(value, type){
	var retVal;

	if (value == undefined || value == "undefined" || value == null || value == "null" || $.trim(value).length == 0) {
		if (type && type == "number") {
			retVal = 0;
		} else {
			retVal = "";
		}
	} else {
		if (type && type == "number") {
			retVal = Number(value);
		}else{
			retVal = value;
		}
	}

	return retVal;
}

function fn_excelDown(){
    Common.popupDiv("/eAccounting/staffClaim/staffClaimExcelDownloadPop.do", {callType:"new"}, null, true, "staffClaimExcelDownloadPop");
}
</script>

<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/e-accounting/StaffClaim.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->

    <input type="hidden" id="_repClaimNo" name="v_CLM_NO" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="staffClaim.title" /></h2>
<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectStaffClaimList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	<%-- </c:if> --%>
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_staffClaim">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="pageAuthFuncUserDefine1" name="pageAuthFuncUserDefine1" value="${PAGE_AUTH.funcUserDefine1}">

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
	<th scope="row"><spring:message code="staffClaim.staffCode" /></th>
	<td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId"/><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
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
            <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"> --%>
            <li><p class="link_btn"><a href="#" id="_staffClaimBtn">Staff Claim</a></p></li>
            <li><p class="link_btn"><a href="#" id="editRejectBtn">Edit Rejected</a></p></li>
   			 <li><p class="link_btn"><a href="#" onclick="fn_excelDown()">Excel Filter</a></p></li>
            <%-- </c:if> --%>
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
    <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
	<li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="pettyCashExp.newExpClm" /></a></p></li>
	<%-- </c:if> --%>
</ul>

<article class="grid_wrap" id="staffClaim_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->