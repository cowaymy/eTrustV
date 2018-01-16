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
var excelGrid;
var myGridID;
var myGridData = $.parseJSON('${appvInfoAndItems}');
var attachList = null;
var myColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expGrp",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expGrp",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvItmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "glAccCode",
    headerText : '<spring:message code="expense.GLAccount" />'
}, {
    dataField : "glAccCodeName",
    headerText : '<spring:message code="newWebInvoice.glAccountName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "budgetCode",
    headerText : '<spring:message code="approveView.budget" />'
}, {
    dataField : "budgetCodeName",
    headerText : '<spring:message code="approveView.budgetName" />',
    style : "aui-grid-user-custom-left"
},{
    dataField : "taxCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "taxName",
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "netAmt",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "taxAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.netAmt + item.taxAmt + item.taxNonClmAmt);
    }
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.description" />',
    style : "aui-grid-user-custom-left",
    width : 200
}
];

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var mGridColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "expGrp",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expType",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expTypeName",
    headerText : '<spring:message code="pettyCashNewExp.expTypeBrName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "glAccCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "glAccCodeName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "budgetCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "budgetCodeName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "taxCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "taxName",
    headerText : '<spring:message code="newWebInvoice.taxCode" />'
}, {
    dataField : "taxRate",
    dataType: "numeric",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    editable : false
}, {
    dataField : "gstBeforAmt",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "oriTaxAmt",
    dataType: "numeric",
    visible : false, // Color 칼럼은 숨긴채 출력시킴
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.gstBeforAmt * (item.taxRate / 100));
    }
}, {
    dataField : "gstAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.gstBeforAmt + item.gstAmt + item.taxNonClmAmt);
    }
}, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var mGridPros = {
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var mGridID;

var mileageGridColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "expGrp",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "carMilagDt",
    headerText : '<spring:message code="pettyCashNewExp.date" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {

    headerText : '<spring:message code="newStaffClaim.location" />',
    children : [
        {
                dataField: "locFrom",
                headerText: '<spring:message code="newStaffClaim.from" />',
                style : "aui-grid-user-custom-left"
        }, {
                dataField: "locTo",
                headerText: '<spring:message code="newStaffClaim.to" />',
                style : "aui-grid-user-custom-left"
        }
    ]
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
}, {
    dataField : "carMilag",
    headerText : '<spring:message code="newStaffClaim.mileageBrKm" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "carMilagAmt",
    headerText : '<spring:message code="newStaffClaim.mileageBrAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "tollAmt",
    headerText : '<spring:message code="newStaffClaim.tollsBrRm" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "parkingAmt",
    headerText : '<spring:message code="newStaffClaim.parkingBrRm" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "purpose",
    headerText : '<spring:message code="newStaffClaim.purpose" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.remark" />',
    style : "aui-grid-user-custom-left",
    width : 150
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
}, {
    dataField : "fileExtsn",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "fileCnt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var mileageGridPros = {
    // 헤더 높이 지정
    headerHeight : 20,
    // 그리드가 height 지정( 지정하지 않으면 부모 height 의 100% 할당받음 )
    height : 175,
    showStateColumn : true,
    softRemoveRowMode : false,
    // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
    enableRestore : true,
    rowIdField : "id",
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var mileageGridID;

$(document).ready(function () {
    myGridID = AUIGrid.create("#approveView_grid_wrap", myColumnLayout, myGridPros);
    
    AUIGrid.bind(myGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + $("#viewClmNo").text());
                console.log("CellDoubleClick clamUn : " + event.item.clamUn);
                console.log("CellDoubleClick appvItmSeq : " + event.item.appvItmSeq);
                console.log("CellDoubleClick atchFileGrpId : " + event.item.atchFileGrpId);
                // TODO detail popup open
                //appvPrcssNo = event.item.appvPrcssNo;
                //atchFileGrpId = event.item.atchFileGrpId;
                var clmNo = $("#viewClmNo").text();
                var clmType = clmNo.substr(0, 2);
                if(clmType != "R1") {
                	fn_getAppvItemOfClmUn($("#viewClmNo").text(), event.item.appvItmSeq, event.item.clamUn);
                }
            });
    
    $("#fileListPop_btn").click(fn_fileListPop);
    
    $("#viewClmNo").text(myGridData[0].clmNo);
    $("#viewClmType").text(myGridData[0].clmType);
    $("#viewCostCentr").text(myGridData[0].costCentr + "/" + myGridData[0].costCentrName);
    $("#viewInvcDt").text(myGridData[0].invcDt);
    $("#viewReqstDt").text(myGridData[0].reqstDt);
    $("#viewReqstUserId").text(myGridData[0].reqstUserId);
    $("#viewMemAccId").text(myGridData[0].memAccId);
    $("#viewMemAccName").text(myGridData[0].memAccName);
    $("#viewPayDueDt").text(myGridData[0].payDueDt);
    $("#viewAppvAmt").text(AUIGrid.formatNumber(myGridData[0].totAmt, "#,##0.00"));
    
    $("#pApprove_btn").click(fn_approvalSubmit);
    $("#pReject_btn").click(fn_RejectSubmit);
    
    fn_setGridData(myGridID, myGridData);
    
    $("#pExcelDown_btn").click(fn_getAppvExcelInfo);
    
    console.log("${PAGE_AUTH.funcUserDefine1}");
});

function fn_approvalSubmit() {
    var rows = AUIGrid.getRowIndexesByValue(invoAprveGridID, "clmNo", [$("#viewClmNo").text()]);
    // isActive
    AUIGrid.setCellValue(invoAprveGridID, rows, "isActive", "Active");
    fn_approveRegistPop();
}

function fn_RejectSubmit() {
    var rows = AUIGrid.getRowIndexesByValue(invoAprveGridID, "clmNo", [$("#viewClmNo").text()]);
    AUIGrid.setCellValue(invoAprveGridID, rows, "isActive", "Active");
    fn_rejectRegistPop();
}

function fn_getAppvItemOfClmUn(clmNo, appvItmSeq, clamUn) {
	var url = "";
	var obj = {
            clmNo : clmNo
            ,clmSeq : appvItmSeq
            ,clamUn : clamUn
    };
	var clmType = clmNo.substr(0, 2);
	if(clmType == "J1") {
		url = "/eAccounting/webInvoice/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
	} else if(clmType == "J2") {
		url = "/eAccounting/pettyCash/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
	} else if(clmType == "J3") {
		url = "/eAccounting/creditCard/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
    } else {
    	// same table, same query
    	url = "/eAccounting/staffClaim/getAppvItemOfClmUn.do?_cacheId=" + Math.random();
    }
    Common.ajax("POST", url, obj, function(result) {
    	console.log(result);
    	console.log(result.data);
    	
    	console.log("expGrp : " + result.data.expGrp);
    	if(result.data.expGrp == "1") {
    		$("#noMileage").hide();
            
            fn_destroyMGrid();
            fn_createMileageAUIGrid(result.data.itemGrp);
            
            // TODO attachFile
            attachList = result.data.attachList;
            console.log(attachList);
            if(attachList) {
            	if(attachList.length > 0) {
                    for(var i = 0; i < attachList.length; i++) {
                        result.data.itemGrp[i].atchFileId = attachList[i].atchFileId;
                        result.data.itemGrp[i].atchFileName = attachList[i].atchFileName;
                        var str = attachList[i].atchFileName.split(".");
                        result.data.itemGrp[i].fileExtsn = str[1];
                        result.data.itemGrp[i].fileCnt = 1;
                    }
                }
            }
    	} else {
    		$("#noMileage").show();
    		
    		if(clmType == "J1") {
                $("#supplirTh").html('');
                $("#supplirTd").text("");
                $("#payInfo1").show();
                $("#payInfo2").show();
                $("#expDesc").text(result.data.invcRem);
                $("#utilNo").text(result.data.utilNo);
                $("#jPayNo").text(result.data.jPayNo);
                var bilPeriod = result.data.bilPeriodF + " - " + result.data.bilPeriodT;
                $("#bilPeriod").text(bilPeriod);
                mGridColumnLayout[4].visible = false;
            } else if(clmType == "J2") {
                $("#supplirTh").html('<spring:message code="pettyCashNewExp.supplierName" />');
                $("#supplirTd").text(result.data.supplier);
                $("#payInfo1").show();
                $("#payInfo2").show();
                $("#utilNo").text(result.data.utilNo);
                $("#jPayNo").text(result.data.jPayNo);
                var bilPeriod = result.data.bilPeriodF + " - " + result.data.bilPeriodT;
                $("#bilPeriod").text(bilPeriod);
            } else {
                $("#supplirTh").html('<spring:message code="pettyCashNewExp.supplierName" />');
                $("#supplirTd").text(result.data.supplier);
                $("#payInfo1").hide();
                $("#payInfo2").hide();
            }
            $("#invcType").text(result.data.invcType);
            $("#invcNo").text(result.data.invcNo);
            $("#gstRgistNo").text(result.data.gstRgistNo);
            $("#expDesc").text(result.data.expDesc);
            
            fn_destroyMileageGrid();
            fn_createMGrid(result.data.itemGrp);
            
            // TODO attachFile
            attachList = result.data.attachList;
            console.log(attachList);
            if(attachList) {
            	if(attachList.length > 0) {
                    $("#attachTd").html("");
                    for(var i = 0; i < attachList.length; i++) {
                        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
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
                }
            }
    	}
    	
    	//fn_setGridData(mGridID, result.itemGrp);
    });
}

//AUIGrid 를 생성합니다.
function fn_createMileageAUIGrid(gridData) {
    // 이미 생성되어 있는 경우
    console.log("isCreated : " + AUIGrid.isCreated("#mileage_grid_wrap"));
    if(AUIGrid.isCreated("#mileage_grid_wrap")) {
        fn_destroyMileageGrid();
    }
    
    $("#mileage_grid_wrap").show();

    // 실제로 #grid_wrap 에 그리드 생성
    mileageGridID = AUIGrid.create("#mileage_grid_wrap", mileageGridColumnLayout, mileageGridPros);
    // AUIGrid 에 데이터 삽입합니다.
    AUIGrid.setGridData(mileageGridID, gridData);
}

// 그리드를 제거합니다.
function fn_destroyMileageGrid() {
	$("#mileage_grid_wrap").hide();
    AUIGrid.destroy("#mileage_grid_wrap");
    mileageGridID = null;
}

//AUIGrid 를 생성합니다.
function fn_createMGrid(gridData) {
    // 이미 생성되어 있는 경우
    console.log("isCreated : " + AUIGrid.isCreated("#mGrid_wrap"));
    if(AUIGrid.isCreated("#mGrid_wrap")) {
        fn_destroyMGrid();
    }
    
    $("#mGrid_wrap").show();

    // 실제로 #grid_wrap 에 그리드 생성
    mGridID = AUIGrid.create("#mGrid_wrap", mGridColumnLayout, mGridPros);
    // AUIGrid 에 데이터 삽입합니다.
    AUIGrid.setGridData(mGridID, gridData);
    
    //fn_myGridSetEvent();
}

// 그리드를 제거합니다.
function fn_destroyMGrid() {
	$("#mGrid_wrap").hide();
    AUIGrid.destroy("#mGrid_wrap");
    mGridID = null;
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

function fn_getAppvExcelInfo() {
	Common.ajax("POST", "/eAccounting/webInvoice/getAppvExcelInfo.do?_cacheId=" + Math.random(), {appvPrcssNo:"${appvPrcssNo}"}, function(result) {
        console.log(result);
        
        //그리드 생성
        fn_makeGrid();
        
        AUIGrid.setGridData(excelGrid, result.data);
        
        if(result.data.length > 0) {
        	var clmNo = result.data[0].appvReqKeyNo;
        	var reqstDt = result.data[0].reqstDt;
        	reqstDt = reqstDt.replace(/\//gi, "");
        	GridCommon.exportTo("excel_grid_wrap", 'xlsx', clmNo + "_" + reqstDt);
        } else {
        	Common.alert('There is no data to download.');
        } 
    });
}

function fn_makeGrid(){

    var excelPop = [
        {
        	dataField : "appvReqKeyNo",
        	headerText : 'Claim No',
        	width : 100,
        	cellMerge : true
        },{
            dataField : "reqstDt",
            headerText : 'Request Date',
            width : 100,
            cellMerge : true 
        },{
            dataField : "reqstUserId",
            headerText : 'Request User Id',
            width : 100,
            cellMerge : true 
        },{
            dataField : "invcNo",
            headerText : 'Invoice No',
            width : 100
        },{
            dataField : "invcDt",
            headerText : 'Invoice Date',
            width : 100
        },{
            dataField : "invcType",
            headerText : 'Invoice Type',
            width : 100
        },{
            dataField : "memAccId",
            headerText : 'Member Account Id',
            width : 100
        },{
            dataField : "memAccName",
            headerText : 'Member Account Name',
            width : 100
        },{
            dataField : "supplir",
            headerText : 'Supplier Name',
            width : 100
        },{
            dataField : "payDueDt",
            headerText : 'Payment Due Date',
            width : 100
        },{
            dataField : "expType",
            headerText : 'Expense Type',
            width : 100
        },{
            dataField : "expTypeName",
            headerText : 'Expense Type Name',
            width : 100
        },{
            dataField : "costCentr",
            headerText : 'Cost Center',
            width : 100
        },{
            dataField : "costCentrName",
            headerText : 'Cost Center Name',
            width : 100
        },{
            dataField : "budgetCode",
            headerText : 'Budget Code',
            width : 100
        },{
            dataField : "budgetCodeName",
            headerText : 'Budget Code Name',
            width : 100
        },{
            dataField : "glAccCode",
            headerText : 'GL Account Code',
            width : 100
        },{
            dataField : "glAccCodeName",
            headerText : 'GL Account Code Name',
            width : 100
        },{
            dataField : "taxCode",
            headerText : 'Tax Code',
            width : 100
        },{
            dataField : "taxName",
            headerText : 'Tax Code Name',
            width : 100
        },{
            dataField : "netAmt",
            headerText : 'Net Amount',
            width : 100
        },{
            dataField : "taxAmt",
            headerText : 'Tax Amount',
            width : 100
        },{
            dataField : "taxNonClmAmt",
            headerText : 'Tax Non Claim Amount',
            width : 100
        },{
            dataField : "appvAmt",
            headerText : 'Approve Amount',
            width : 100
        },{
            dataField : "utilNo",
            headerText : 'Utilities Account No',
            width : 100
        },{
            dataField : "jPayNo",
            headerText : 'JomPAY No',
            width : 100
        },{
            dataField : "bilPeriodF",
            headerText : 'Billing Period From',
            width : 100
        },{
            dataField : "bilPeriodT",
            headerText : 'Billing Period To',
            width : 100
        }
    ];
        
     var excelOptions = {
            enableCellMerge : true,
            showStateColumn:false,
            fixedColumnCount    : 3,
            showRowNumColumn    : false,
            //headerHeight : 100,
            usePaging : false
      }; 
    
     excelGrid = GridCommon.createAUIGrid("#excel_grid_wrap", excelPop, "", excelOptions);
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="approveView.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_approveView">
<input type="hidden" id="viewMemAccId">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.clmNo" /></th>
	<td><span id="viewClmNo"></span></td>
	<th scope="row"><spring:message code="invoiceApprove.clmType" /></th>
	<td><span id="viewClmType"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td id="viewCostCentr"></td>
	<th scope="row"><spring:message code="webInvoice.invoiceDate" /></th>
	<td id="viewInvcDt"></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.requestDate" /></th>
	<td id="viewReqstDt"></td>
	<th scope="row"><spring:message code="approveView.requester" /></th>
	<td id="viewReqstUserId"></td>
</tr>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.member" /></th>
	<td id="viewMemAccName"></td>
	<th scope="row"><spring:message code="newWebInvoice.payDueDate" /></th>
	<td id="viewPayDueDt"></td>
</tr>
<tr>
	<th scope="row"><spring:message code="approveView.approveStatus" /></th>
	<td colspan="3" style="height:60px" id="viewAppvStus">${appvPrcssStus}</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<table class="type1 mt10" id="noMileage" style="display: none;"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="pettyCashNewExp.invcNo" /></th>
    <td id="invcNo"></td>
    <th scope="row"><spring:message code="newWebInvoice.invoiceType" /></th>
    <td id="invcType"></td>
</tr>
<tr>
    <th scope="row"><spring:message code="pettyCashNewExp.gstRgistNo" /></th>
    <td id="gstRgistNo"></td>
    <th scope="row" id="supplirTh"></th>
    <td id="supplirTd"></td>
</tr>
<tr id="payInfo1">
    <th scope="row"><spring:message code="newWebInvoice.utilNo" /></th>
    <td id="utilNo"></td>
    <th scope="row">Billing Period</th>
    <td id="bilPeriod"></td>
</tr>
<tr id="payInfo2" style="display: none;">
    <th scope="row">JomPAY No</th>
    <td id="jPayNo"></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
    <td colspan="3" id="attachTd">
    <div class="auto_file2 auto_file3"><!-- auto_file start -->
    <input type="file" title="file add" />
    </div><!-- auto_file end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="newWebInvoice.remark" /></th>
    <td colspan="3" id="expDesc"></td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap" id="mGrid_wrap" style="display: none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<article class="grid_wrap" id="mileage_grid_wrap" style="display: none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="viewAppvAmt"></span></h2>
</aside><!-- title_line end -->

<article class="grid_wrap" id="approveView_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<article class="grid_wrap" id="excel_grid_wrap" style="display: none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <c:if test="${appvPrcssResult eq 'R'}">
    <li><p class="btn_blue2"><a href="#" id="pApprove_btn"><spring:message code="invoiceApprove.title" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="pReject_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
    </c:if>
    </c:if>
    <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"> --%>
    <li><p class="btn_blue2"><a href="#" id="pExcelDown_btn">EXCEL DW</a></p></li>
    <%-- </c:if> --%>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->