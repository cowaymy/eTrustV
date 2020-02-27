<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 행 스타일 */
.my-cell-style {
    background:#FF0000;
    color:#005500;
    font-weight:bold;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#viewEditWebInvoice_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
var newGridID;
var selectRowIdx;
var callType = "${callType}";
var removeOriFileName = new Array();
var keyValueList = $.parseJSON('${taxCodeList}');
var gridDataList = new Array();
<c:forEach var="data" items="${gridDataList}">
var obj = {
		clmSeq : "${data.clmSeq}"
		,expType : "${data.expType}"
        ,expTypeName : "${data.expTypeName}"
        ,glAccCode : "${data.glAccCode}"
        ,glAccCodeName : "${data.glAccCodeName}"
        ,budgetCode : "${data.budgetCode}"
        ,budgetCodeName : "${data.budgetCodeName}"
        ,taxCode : "${data.taxCode}"
        ,taxName : "${data.taxName}"
        //,taxRate : Number("${data.taxRate}")
        ,cur : "${data.cur}"
        //,netAmt : Number("${data.netAmt}")
        //,taxAmt : Number("${data.taxAmt}")
        //,taxNonClmAmt : Number("${data.taxNonClmAmt}")
        ,totAmt : Number("${data.totAmt}")
        ,expDesc : "${data.expDesc}"
        ,clamUn : "${data.clamUn}"
        ,utilNo : "${data.utilNo}"
};
gridDataList.push(obj);
</c:forEach>
//file action list
var update = new Array();
var remove = new Array();
var attachmentList = new Array();
<c:forEach var="file" items="${attachmentList}">
var obj = {
		atchFileGrpId : "${file.atchFileGrpId}"
		,atchFileId : "${file.atchFileId}"
		,atchFileName : "${file.atchFileName}"
};
attachmentList.push(obj);
</c:forEach>
var myColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "clmSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "budgetCode",
    headerText : '<spring:message code="expense.Activity" />',
    editable : false,
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
            fn_budgetCodePop(rowIndex);
            }
        },
    colSpan : -1
}, {
    dataField : "budgetCodeName",
    headerText : '<spring:message code="newWebInvoice.activityName" />',
    style : "aui-grid-user-custom-left",
    editable : false
},{
    dataField : "glAccCode",
    headerText : '<spring:message code="expense.GLAccount" />',
    editable : false,
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
            fn_glAccountSearchPop(rowIndex);
            }
        },
    colSpan : -1
}, {
    dataField : "glAccCodeName",
    headerText : '<spring:message code="newWebInvoice.glAccountName" />',
    style : "aui-grid-user-custom-left",
    editable : false
}, {
    dataField : "taxCode",
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
    renderer : {
        type : "DropDownListRenderer",
        list : keyValueList, //key-value Object 로 구성된 리스트
        keyField : "taxCode", // key 에 해당되는 필드명
        valueField : "taxName" // value 에 해당되는 필드명
    }
}, {
    dataField : "taxRate",
    dataType: "numeric",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    editable : false
}, /*{
    dataField : "netAmt",
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
        return (item.netAmt * (item.taxRate / 100));
    }
}, {
    dataField : "taxAmt",
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
}, */{
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    /*editable : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.netAmt + item.taxAmt + item.taxNonClmAmt);
    },*/
    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
        if(item.yN == "N") {
            return "my-cell-style";
        }
        return null;
    }
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.description" />',
    style : "aui-grid-user-custom-left",
    width : 200
}, {
    dataField : "yN",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];
var approvalColumnLayout = [ {
    dataField : "clamUn",
    headerText : '<spring:message code="newWebInvoice.seq" />'
}, {
    dataField : "budgetCode",
    headerText : '<spring:message code="expense.Activity" />',
    editable : false
}, {
    dataField : "budgetCodeName",
    headerText : '<spring:message code="newWebInvoice.activityName" />',
    style : "aui-grid-user-custom-left",
    editable : false
}, {
    dataField : "glAccCode",
    headerText : '<spring:message code="expense.GLAccount" />',
    editable : false

}, {
    dataField : "glAccCodeName",
    headerText : '<spring:message code="newWebInvoice.glAccountName" />',
    style : "aui-grid-user-custom-left",
    editable : false
}, {
    dataField : "taxName",
    headerText : '<spring:message code="newWebInvoice.taxCode" />',
    editable : false
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    editable : false
}, /*{
    dataField : "netAmt",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false
}, {
    dataField : "taxAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false
}, {
    dataField : "taxNonClmAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false
}, */{
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
    editable : false
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.description" />',
    style : "aui-grid-user-custom-left",
    width : 200,
    editable : false
}
];

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    editable : true,
    showStateColumn : true,
    softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"

};

$(document).ready(function () {
	var appvPrccNo = "${webInvoiceInfo.appvPrcssNo}";
	if(appvPrccNo == null || appvPrccNo == '') {
		newGridID = AUIGrid.create("#viewEditWebInvoice_grid_wrap", myColumnLayout, myGridPros);
	} else {
		newGridID = AUIGrid.create("#viewEditWebInvoice_grid_wrap", approvalColumnLayout, myGridPros);
	}

    $("#tempSave").click(fn_tempSave);
    $("#submitPop").click(fn_approveLinePop);
    $("#add_row").click(fn_addRow);
    $("#delete_row").click(fn_removeRow);
    $("#supplier_search_btn").click(fn_popSupplierSearchPop);
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);

    fn_setNewGridEvent();

    fn_setKeyInDate();
    fn_setPayDueDtEvent();
    fn_setCostCenterEvent();
    fn_setSupplierEvent();

    if(gridDataList.length > 0) {
        fn_setGridData(gridDataList);
    }
    // 수정시 첨부파일이 없는경우 디폴트 파일태그 생성
    console.log(attachmentList);
    if(attachmentList.length <= 0) {
        setInputFile2();
    }

    // 파일 다운
    $(".input_text").dblclick(function() {
    	var oriFileName = $(this).val();
    	var fileGrpId;
    	var fileId;
    	for(var i = 0; i < attachmentList.length; i++) {
    		if(attachmentList[i].atchFileName == oriFileName) {
    			fileGrpId = attachmentList[i].atchFileGrpId;
    			fileId = attachmentList[i].atchFileId;
    		}
    	}
    	fn_atchViewDown(fileGrpId, fileId);
    });
    // 파일 수정
    $("#form_newWebInvoice :file").change(function() {
        var div = $(this).parents(".auto_file2");
        var oriFileName = div.find(":text").val();
        console.log(oriFileName);
        for(var i = 0; i < attachmentList.length; i++) {
            if(attachmentList[i].atchFileName == oriFileName) {
                update.push(attachmentList[i].atchFileId);
                console.log(JSON.stringify(update));
            }
        }
    });
    // 파일 삭제
    $(".auto_file2 a:contains('Delete')").click(function() {
        var div = $(this).parents(".auto_file2");
        var oriFileName = div.find(":text").val();
        console.log(oriFileName);
        for(var i = 0; i < attachmentList.length; i++) {
            if(attachmentList[i].atchFileName == oriFileName) {
                remove.push(attachmentList[i].atchFileId);
                console.log(JSON.stringify(remove));
            }
        }
    });
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_approveLinePop() {
    console.log("fn_approveLinePop");
	var checkResult = fn_checkEmpty();
console.log("fn_approveLinePop :: checkResult :: " + checkResult);
    if(!checkResult){
        return false;
    }

    var length = AUIGrid.getGridData(newGridID).length;
    if(length > 0) {
console.log("length > 0");
        for(var i = 0; i < length; i++) {
            var availableVar = {
                    costCentr : $("#newCostCenter").val(),
                    stYearMonth : $("#keyDate").val().substring(3),
                    stBudgetCode : AUIGrid.getCellValue(newGridID, i, "budgetCode"),
                    stGlAccCode : AUIGrid.getCellValue(newGridID, i, "glAccCode")
                }

            var availableAmtCp = 0;
            Common.ajax("GET", "/eAccounting/webInvoice/checkBgtPlan.do", availableVar, function(result1) {
                console.log(result1.ctrlType);

                if(result1.ctrlType == "Y") {
                    Common.ajax("GET", "/eAccounting/webInvoice/availableAmtCp.do", availableVar, function(result) {
                        console.log("availableAmtCp");
                        console.log(result.totalAvailable);

                        var finAvailable = result.totalAvilableAdj - result.totalPending - result.totalUtilized;

                        if(finAvailable < AUIGrid.getCellValue(newGridID, i, "totAmt")) {
                            Common.alert("Insufficient budget amount available for Budget Code : " + AUIGrid.getCellValue(newGridID, i, "budgetCode") + ", GL Code : " + AUIGrid.getCellValue(newGridID, i, "glAccCode") + ". ");
                            AUIGrid.setCellValue(newGridID, event.rowIndex, "netAmt", "0.00");
                            AUIGrid.setCellValue(newGridID, event.rowIndex, "totAmt", "0.00");

                            return false;
                        } else {
                            var data = {
                                    memAccId : $("#newMemAccId").val(),
                                    invcNo : $("#invcNo").val()
                                    //clmNo : $("#newClmNo").val()
                            }

                            Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
                                console.log(result);
                                if(result.data && result.data != $("#newClmNo").val()) {
                                    Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
                                    return false;
                                } else {
                                    // 수정 후 temp save가 아닌 바로 submit
                                    // 고려하여 update 후 approve
                                    // file 업로드를 하지 않은 상태라면 atchFileGrpId가 없을 수 있다
                                    if(FormUtil.isEmpty($("#atchFileGrpId").val())) {
                                        console.log("fn_attachmentUpload Action");
                                        fn_attachmentUpload("");
                                    } else {
                                        console.log("fn_attachmentUpdate Action");
                                        fn_attachmentUpdate("");
                                    }

                                    Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
                                }
                            });
                        }
                    });
                } else {
                    var data = {
                            memAccId : $("#newMemAccId").val(),
                            invcNo : $("#invcNo").val()
                            //clmNo : $("#newClmNo").val()
                    }

                    Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
                        console.log(result);
                        if(result.data && result.data != $("#newClmNo").val()) {
                            Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
                            return false;
                        } else {
                            // 수정 후 temp save가 아닌 바로 submit
                            // 고려하여 update 후 approve
                            // file 업로드를 하지 않은 상태라면 atchFileGrpId가 없을 수 있다
                            if(FormUtil.isEmpty($("#atchFileGrpId").val())) {
                                console.log("fn_attachmentUpload Action");
                                fn_attachmentUpload("");
                            } else {
                                console.log("fn_attachmentUpdate Action");
                                fn_attachmentUpdate("");
                            }

                            Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
                        }
                    });
                }
            });
        }
    }
}

function fn_tempSave() {
	var checkResult = fn_checkEmpty();

    if(!checkResult){
        return false;
    }

    var data = {
            memAccId : $("#newMemAccId").val(),
            invcNo : $("#invcNo").val()
    }

    Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
        console.log(result);
        if(result.data && result.data != $("#newClmNo").val()) {
            Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
            return false;
        } else {
        	if(FormUtil.isEmpty($("#atchFileGrpId").val())) {
        		console.log("fn_attachmentUpload Action");
                fn_attachmentUpload(callType);
            } else {
            	console.log("fn_attachmentUpdate Action");
                fn_attachmentUpdate(callType);
            }
        }
    });

}

function fn_attachmentUpload(st) {
    var formData = Common.getFormData("form_newWebInvoice");
    Common.ajaxFile("/eAccounting/webInvoice/attachmentUpload.do", formData, function(result) {
        console.log(result);
        // 신규 add return atchFileGrpId의 key = fileGroupKey
        console.log(result.data.fileGroupKey);
        $("#atchFileGrpId").val(result.data.fileGroupKey);
        fn_updateWebInvoiceInfo(st);
    });
}

function fn_attachmentUpdate(st) {
    // 신규 add or 추가 add인지 update or delete인지 분기 필요
    // 파일 수정해야 하는 경우 : delete 버튼 클릭 or file 버튼 클릭으로 수정
    // delete 버튼의 파일이름 찾아서 저장
    var formData = Common.getFormData("form_newWebInvoice");
    formData.append("atchFileGrpId", $("#atchFileGrpId").val());
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    Common.ajaxFile("/eAccounting/webInvoice/attachmentUpdate.do", formData, function(result) {
        console.log(result);
        fn_updateWebInvoiceInfo(st);
    });
}

function fn_updateWebInvoiceInfo(st) {
    var obj = $("#form_newWebInvoice").serializeJSON();
    var gridData = GridCommon.getEditData(newGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/webInvoice/updateWebInvoiceInfo.do", obj, function(result) {
        console.log(result);
        //fn_selectWebInvoiceItemList(result.data.clmNo);
        fn_selectWebInvoiceInfo(result.data.clmNo);
        if(st == "view"){
            Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
            $("#viewEditWebInvoicePop").remove();
        }
        fn_selectWebInvoiceList();
    });

}

function fn_setGridData(data) {
	console.log(data);
	AUIGrid.setGridData(newGridID, data);
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="viewEditWebInvoice.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" id="tempSave"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="submitPop"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>
</c:if>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" enctype="multipart/form-data" id=form_newWebInvoice>
<input type="hidden" id="newClmNo" name="clmNo" value="${webInvoiceInfo.clmNo}">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="${webInvoiceInfo.atchFileGrpId}">
<!-- <input type="hidden" id="newMemAccName" name="memAccName" value="${webInvoiceInfo.memAccName}"> -->
<input type="hidden" id="newCostCenterText" name="costCentrName" value="${webInvoiceInfo.costCentrName}">
<input type="hidden" id="bankCode" name="bankCode" value="${webInvoiceInfo.bankCode}">
<input type="hidden" id="totAmt" name="totAmt" value="${webInvoiceInfo.totAmt}">
<input type="hidden" id="crtUserId" name="crtUserId" value="${webInvoiceInfo.crtUserId}">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.keyInDate" /></th>
	<td><input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p" id="keyDate" name="keyDate" value="${webInvoiceInfo.crtDt}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">disabled</c:if>/></td>
	<th scope="row"><spring:message code="newWebInvoice.createUserId" /></th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${webInvoiceInfo.crtUserName}" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" value="${webInvoiceInfo.costCentr}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">readonly</c:if>/><c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}"><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
	<th scope="row">Cost Centre Name</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="costCentrName" name="costCentrName" value="${webInvoiceInfo.costCentrName}" disabled/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.supplier" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newMemAccId" name="memAccId" value="${webInvoiceInfo.memAccId}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">readonly</c:if>/><c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}"><a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
	<th scope="row">Supplier Name</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="newMemAccName" name="memAccName" value="${webInvoiceInfo.memAccName}" disabled/></td>
	<!-- <th scope="row"><spring:message code="newWebInvoice.invoiceType" /></th>
	<td>
	<select class="w100p" id="invcType" name="invcType" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">disabled</c:if>>
		<option value="F" <c:if test="${webInvoiceInfo.invcType eq 'F'}">selected</c:if>><spring:message code="newWebInvoice.select.fullTax" /></option>
		<option value="S" <c:if test="${webInvoiceInfo.invcType eq 'S'}">selected</c:if>><spring:message code="newWebInvoice.select.simpleTax" /></option>
	</select>
	</td>-->
</tr>
<tr>
    <th scope="row"><spring:message code="webInvoice.invoiceDate" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="invcDt" name="invcDt" value="${webInvoiceInfo.invcDt}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">disabled</c:if>/></td>
	<th scope="row"><spring:message code="newWebInvoice.invoiceNo" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="invcNo" name="invcNo" autocomplete=off value="${webInvoiceInfo.invcNo}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">readonly</c:if>/></td>
	<!-- <th scope="row"><spring:message code="pettyCashNewExp.gstRgistNo" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="gstRgistNo" name="gstRgistNo" value="${webInvoiceInfo.gstRgistNo}" /></td>-->
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bank" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" value="${webInvoiceInfo.bankName}" /></td>
	<th scope="row"><spring:message code="newWebInvoice.payDueDate" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="payDueDt" name="payDueDt" value="${webInvoiceInfo.payDueDt}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">disabled</c:if>/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bankAccount" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo" value="${webInvoiceInfo.bankAccNo}" /></td>
	<th scope="row"><spring:message code="newWebInvoice.utilNo" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="utilNo" name="utilNo" value="${webInvoiceInfo.utilNo}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">readonly</c:if>/></td>
</tr>
<tr>
    <th scope="row">Billing Period</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="bilPeriodF" name="bilPeriodF" value="${webInvoiceInfo.bilPeriodF}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">disabled</c:if>/></p>
    <span><spring:message code="webInvoice.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="bilPeriodT" name="bilPeriodT" value="${webInvoiceInfo.bilPeriodT}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">disabled</c:if>/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">JomPAY No</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="jPayNo" name="jPayNo" value="${webInvoiceInfo.jPayNo}" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">readonly</c:if>/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
	<td colspan="3">
	<c:forEach var="files" items="${attachmentList}" varStatus="st">
	<div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
	<c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
	<input type="file" title="file add" style="width:300px" />
    <label>
    </c:if>
    <input type='text' class='input_text' readonly='readonly' value="${files.atchFileName}" />
    <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
    <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
    </c:if>
    <c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
    </label>
    <span class='label_text'><a href='#' id="add_btn"><spring:message code="viewEditWebInvoice.add" /></a></span>
    <span class='label_text'><a href='#' id="remove_btn"><spring:message code="viewEditWebInvoice.delete" /></a></span>
    </c:if>
    </div><!-- auto_file end -->
	</c:forEach>
	<c:if test="${fn:length(attachmentList) <= 0}">
	<c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    </div><!-- auto_file end -->
    </c:if>
    </c:if>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.remark" /></th>
	<td colspan="3"><textarea cols="20" rows="5" id="invcRem" name="invcRem" placeholder="Enter up to 200 characters" <c:if test="${webInvoiceInfo.appvPrcssNo ne null and webInvoiceInfo.appvPrcssNo ne ''}">readonly</c:if>>${webInvoiceInfo.invcRem}</textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="totalAmount"><fmt:formatNumber value="${webInvoiceInfo.totAmt}" type="number" pattern="#,##0.00"/></span></h2>
<c:if test="${webInvoiceInfo.appvPrcssNo eq null or webInvoiceInfo.appvPrcssNo eq ''}">
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="add_row"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="delete_row"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</c:if>
</aside><!-- title_line end -->

<article class="grid_wrap" id="viewEditWebInvoice_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->