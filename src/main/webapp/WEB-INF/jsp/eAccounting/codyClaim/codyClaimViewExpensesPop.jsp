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
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#my_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
var clmNo = "${clmNo}";
var clmSeq = 0;
var clamUn = null;
var atchFileGrpId;
var attachList;
var callType = "${callType}";
var keyValueList = $.parseJSON('${taxCodeList}');
var selectRowIdx;
var deleteRowIdx;
var expTypeName;
//file action list
var update = new Array();
var remove = new Array();
var newGridColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "expGrp",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentr",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentrName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "memAccId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "bankCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "bankAccNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "clmMonth",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "invcDt",
    headerText : '<spring:message code="webInvoice.invoiceDate" />'
}, {
    dataField : "expType",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expTypeName",
    headerText : '<spring:message code="pettyCashNewExp.expBrType" />',
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
    dataField : "supplirName",
    headerText : '<spring:message code="crditCardNewReim.supplierBrName" />'
}, {
    dataField : "taxCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "taxName",
    headerText : '<spring:message code="newWebInvoice.taxCode" />'
}, {
    dataField : "gstRgistNo",
    headerText : '<spring:message code="pettyCashNewExp.gstBrRgist" />'
}, {
    dataField : "invcType",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "invcTypeName",
    headerText : '<spring:message code="pettyCashNewExp.invcBrType" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "invcNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "supplir",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "gstBeforAmt",
    headerText : '<spring:message code="pettyCashNewExp.amtBrBeforeGst" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "gstAmt",
    headerText : '<spring:message code="pettyCashNewExp.gst" />',
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
    headerText : '<spring:message code="pettyCashNewExp.totBrAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.gstBeforAmt + item.gstAmt + item.taxNonClmAmt);
    },
    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
        if(item.yN == "N") {
            return "my-cell-style";
        }
        return null;
    }
}, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "carMilagDt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
	dataField: "locFrom",
	visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField: "locTo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "carMilag",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "carMilagAmt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "tollAmt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "parkingAmt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "purpose",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.remark" />',
    style : "aui-grid-user-custom-left",
    width : 200
}, {
    dataField : "yN",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var newGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 헤더 높이 지정
    headerHeight : 40,
    // 그리드가 height 지정( 지정하지 않으면 부모 height 의 100% 할당받음 )
    height : 175,
    softRemoveRowMode : false,
    rowIdField : "clmSeq"
};

var myGridColumnLayout = [ {
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
    style : "aui-grid-user-custom-left",
    colSpan : 2
}, {
    dataField : "",
    headerText : '',
    width: 30,
    editable : false,
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
        },         
        iconWidth : 24,
        iconHeight : 24,
        onclick : function(rowIndex, columnIndex, value, item) {
            console.log("CellClick rowIndex : " + rowIndex + ", columnIndex : " + columnIndex + " clicked");
            selectRowIdx = rowIndex;
            fn_PopExpenseTypeSearchPop();
            }
        },
    colSpan : -1
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
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
    renderer : {
        type : "DropDownListRenderer",
        list : keyValueList, //key-value Object 로 구성된 리스트
        keyField : "taxCode", // key 에 해당되는 필드명
        valueField : "taxName", // value 에 해당되는 필드명
    }
}, {
    dataField : "taxName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
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
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true, // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
        allowPoint : true // 소수점(.) 입력 가능 설정
    }
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
    formatString : "#,##0.00",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true,
        autoThousandSeparator : true, // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
        allowPoint : true // 소수점(.) 입력 가능 설정
    }
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
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
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.gstBeforAmt + item.gstAmt + item.taxNonClmAmt);
    },
    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
        if(item.yN == "N") {
            return "my-cell-style";
        }
        return null;
    }
}, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

var approvalColumnLayout = [ {
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
    style : "aui-grid-user-custom-left",
    editable : false
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
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
    editable : false
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
    formatString : "#,##0.00",
    editable : false
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
    formatString : "#,##0.00",
    editable : false
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxNonClmAmt" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false,
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
var myGridPros = {
    editable : true,
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160
};

var myGridID;

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
    formatString : "dd/mm/yyyy",
    editRenderer : {
        type : "CalendarRenderer",
        openDirectly : true, // 에디팅 진입 시 바로 달력 열기
        onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
        showExtraDays : true, // 지난 달, 다음 달 여분의 날짜(days) 출력
        titles : [gridMsg["sys.info.grid.calendar.titles.sun"], gridMsg["sys.info.grid.calendar.titles.mon"], gridMsg["sys.info.grid.calendar.titles.tue"], gridMsg["sys.info.grid.calendar.titles.wed"], gridMsg["sys.info.grid.calendar.titles.thur"], gridMsg["sys.info.grid.calendar.titles.fri"], gridMsg["sys.info.grid.calendar.titles.sat"]], // 기본값: ["일", "월", "화", "수", "목", "금", "토"]
        formatYearString : gridMsg["sys.info.grid.calendar.formatYearString"], // 기본값(default) : "yyyy년"
        formatMonthString : gridMsg["sys.info.grid.calendar.formatMonthString"], // 기본값(default) : "yyyy년 mm월"
        monthTitleString : gridMsg["sys.info.grid.calendar.monthTitleString"] // 기본값(default) : "m월"
    }
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
    editable : false
}, {
    dataField : "carMilag",
    headerText : '<spring:message code="newStaffClaim.mileageBrKm" />',
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
    dataField : "carMilagAmt",
    headerText : '<spring:message code="newStaffClaim.mileageBrAmt" />',
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
    dataField : "tollAmt",
    headerText : '<spring:message code="newStaffClaim.tollsBrRm" />',
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
    dataField : "parkingAmt",
    headerText : '<spring:message code="newStaffClaim.parkingBrRm" />',
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
    width : 150,
    editable : false,
    labelFunction : function( rowIndex, columnIndex, value, headerText, item ) {
        if(typeof value == "undefined" || value == "") {
            return "";
        }
        return value;
    },
    colSpan : 2
}, {
    dataField : "",
    headerText : '',
    width: 30,
    editable : false,
    renderer : {
    	type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
        },         
        iconWidth : 24,
        iconHeight : 24,
        onclick : function(rowIndex, columnIndex, value, item) {
        	console.log("rowIndex : " + rowIndex);
            if(!FormUtil.isEmpty("${appvPrcssNo}")){
            	Common.alert('<spring:message code="viewStaffClaim.attach.msg" />');
            } else {
                selectRowIdx = rowIndex;
                fn_myButtonClick(item);
            }
        }
    },
    colSpan : -1
},{
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
    editable : true,
    // 그리드가 height 지정( 지정하지 않으면 부모 height 의 100% 할당받음 )
    height : 175,
    showStateColumn : true,
    softRemoveRowMode : false,
    // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
    enableRestore : true,
    rowIdField : "id"
};

var newGridID;
var mileageGridID;

$(document).ready(function () {
    newGridID = AUIGrid.create("#newStaffCliam_grid_wrap", newGridColumnLayout, newGridPros);
    if("${appvPrcssNo}" == null || "${appvPrcssNo}" == '') {
        myGridID = AUIGrid.create("#my_grid_wrap", myGridColumnLayout, myGridPros);
    } else {
        myGridID = AUIGrid.create("#my_grid_wrap", approvalColumnLayout, myGridPros);
    }
    
    AUIGrid.setGridData(newGridID, $.parseJSON('${itemList}'));
    console.log($.parseJSON('${itemList}'))
    
    var result = $.parseJSON('${itemList}');
    var allTotAmt = "0.00";
    if(result.length > 0) {
        allTotAmt = "" + result[0].allTotAmt;
    }
    $("#allTotAmt_text").text(allTotAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    
    setInputFile2();
    
    $("#supplier_search_btn").click(fn_popSupplierSearchPop);
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);
    $("#expenseType_search_btn").click(fn_PopExpenseTypeSearchPop);
    $("#sSupplier_search_btn").click(fn_popSubSupplierSearchPop);
    $("#mileage_add").click(fn_mileageAdd);
    $("#clear_btn").click(fn_clearData);
    $("#add_btn").click(fn_addRow);
    $("#delete_btn").click(fn_deleteStaffClaimExp);
    $("#tempSave_btn").click(fn_tempSave);
    $("#request_btn").click(fn_approveLinePop);
    $("#add_row").click(fn_addMyGridRow);
    $("#remove_row").click(fn_removeMyGridRow);
    
    AUIGrid.bind(newGridID, "cellDoubleClick", function( event ) {
    	console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log("CellDoubleClick clmNo : " + event.item.clmNo + " CellDoubleClick clmSeq : " + event.item.clmSeq);
        // TODO pettyCash Expense Info GET
        if(clmNo != null && clmNo != "") {
            selectRowIdx = event.rowIndex;
            clmSeq = event.item.clmSeq;
            clamUn = event.item.clamUn;
            atchFileGrpId = event.item.atchFileGrpId;
            fn_selectStaffClaimInfo();
        } else {
            Common.alert('<spring:message code="pettyCashNewExp.beforeSave.msg" />');
        }
    });
    
    AUIGrid.bind(newGridID, "cellClick", function( event ) {
    	console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log("CellClick expTypeName : " + event.item.expTypeName + " CellClick clmSeq : " + event.item.clmSeq);
        // TODO pettyCash Expense Info GET
        deleteRowIdx = event.rowIndex;
        clmSeq = event.item.clmSeq;
        atchFileGrpId = event.item.atchFileGrpId;
        expTypeName = event.item.expTypeName;
    });
    
    fn_myGridSetEvent();
    
    fn_setEvent();
    
    var expGrp = "${expGrp}";
    console.log(expGrp);
    // Expense Type Name == Car Mileage Expense
    //$("#expTypeName").val() == "Car Mileage Expense"
    // WebInvoice Test는 Test
    if(expGrp == "1") {
        $("#noMileage").hide();
        $("#myGird_btn").hide();
        fn_destroyMyGrid();
        if(!FormUtil.isEmpty("${appvPrcssNo}")){
            mileageGridPros.editable = false;
        }
        fn_createMileageAUIGrid();
        $("#normalExp_radio").prop("checked", false);
        $("#carMileage_radio").prop("checked", true);
        $("#mileage_btn").show();
    } else {
        $("#carMileage_radio").prop("checked", false);
        $("#normalExp_radio").prop("checked", true);
    }
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

//그리드의 셀 버턴 클릭 처리
function fn_myButtonClick(item){
	console.log("fn_myButtonClick Action")
    recentGridItem = item; // 그리드의 클릭한 행 아이템 보관
    var input = $("#file");
    input.trigger('click'); // 파일 브라우저 열기
};

function fn_tempSave() {
	fn_updateStaffClaimExp(callType);
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="viewStaffClaim.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newStaffClaim">
<input type="hidden" id="newCostCenter" name="costCentr">
<input type="hidden" id="newMemAccId" name="memAccId">
<input type="hidden" id="supplir" name="supplir">
<input type="hidden" id="bankCode" name="bankCode">
<input type="hidden" id="expType" name="expType">
<input type="hidden" id="budgetCode" name="budgetCode">
<input type="hidden" id="budgetCodeName" name="budgetCodeName">
<input type="hidden" id="glAccCode" name="glAccCode">
<input type="hidden" id="glAccCodeName" name="glAccCodeName">
<input type="hidden" id="taxRate">

<c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}">
<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" id="tempSave_btn"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="request_btn"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>
</c:if>

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenterText" name="costCentrName" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/><c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}"><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
	<th scope="row"><spring:message code="codyClaim.codyCode" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newMemAccName" name="memAccName" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/><c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}"><a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bank" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" name="bankName"/></td>
	<th scope="row"><spring:message code="pettyCashNewCustdn.bankAccNo" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="pettyCashExp.clmMonth" /></th>
	<td><input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="newClmMonth" name="clmMonth" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>/></td>
	<th scope="row"><spring:message code="newStaffClaim.expGrp" /></th>
    <td>
    <label><input type="radio" id="normalExp_radio" name="expGrp" value="0" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>/><span><spring:message code="newStaffClaim.normalExp" /></span></label>
    <label><input type="radio" id="carMileage_radio" name="expGrp" value="1" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>/><span><spring:message code="newStaffClaim.carMileage" /></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1 mt10" id="noMileage"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="webInvoice.invoiceDate" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="invcDt" name="invcDt" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>/></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="pettyCashNewExp.supplierName" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" id="supplirName" name="supplirName" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
    <th scope="row"><spring:message code="pettyCashNewExp.gstRgistNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" id="gstRgistNo" name="gstRgistNo" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="newWebInvoice.invoiceType" /></th>
    <td>
    <select class="w100p" id="invcType" name="invcType" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">disabled</c:if>>
        <option value="F"><spring:message code="newWebInvoice.select.fullTax" /></option>
        <option value="S"><spring:message code="newWebInvoice.select.simpleTax" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="pettyCashNewExp.invcNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" id="invcNo" name="invcNo" autocomplete=off <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
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
    <td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="expDesc" name="expDesc" <c:if test="${appvPrcssNo ne null and appvPrcssNo ne ''}">readonly</c:if>/></td>
</tr>
</tbody>
</table><!-- table end -->

<c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}">
<aside class="title_line" id="myGird_btn"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="add_row"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <li><p class="btn_grid"><a href="#" id="remove_row"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</aside><!-- title_line end -->
</c:if>

<article class="grid_wrap" id="my_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}">
<aside class="title_line" id="mileage_btn" style="display: none;"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="mileage_add"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <%-- <li><p class="btn_grid"><a href="#" id="mileage_remove"><spring:message code="newWebInvoice.btn.delete" /></a></p></li> --%>
</ul>
</aside><!-- title_line end -->
</c:if>
<article class="grid_wrap" id="mileage_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
<!-- 파일 input , 감춰놓기 -->
<input type="file" id="file" style="display: none;"></input>

<c:if test="${appvPrcssNo eq null or appvPrcssNo eq ''}">
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="add_btn"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="delete_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="clear_btn"><spring:message code="pettyCashNewCustdn.clear" /></a></p></li>
</ul>
</c:if>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="allTotAmt_text"></span></h2>
</aside><!-- title_line end -->

<article class="grid_wrap" id="newStaffCliam_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->