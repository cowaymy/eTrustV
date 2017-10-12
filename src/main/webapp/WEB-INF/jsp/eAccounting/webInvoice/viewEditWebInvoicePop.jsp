<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var myGridID;
var selectRowIdx;
var keyValueList = $.parseJSON('${taxCodeList}');
var gridDataList = new Array();
<c:forEach var="data" items="${gridDataList}">
var obj = {
		expType : "${data.expType}"
        ,expTypeName : "${data.expTypeName}"
        ,glAccCode : "${data.glAccCode}"
        ,glAccCodeName : "${data.glAccCodeName}"
        ,budgetCode : "${data.budgetCode}"
        ,budgetCodeName : "${data.budgetCodeName}"
        ,taxCode : "${data.taxCode}"
        ,netAmt : Number("${data.netAmt}")
        ,taxAmt : Number("${data.taxAmt}")
        ,totAmt : Number("${data.taxAmt}")
        ,expDesc : "${data.expDesc}"
};
gridDataList.push(obj);
</c:forEach>
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
    dataField : "expType",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},{
    dataField : "expTypeName",
    headerText : '<spring:message code="expense.ExpenseType" />',
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
        },         
        iconWidth : 24,
        iconHeight : 24,
        iconPosition : "aisleRight",
        onclick : function(rowIndex, columnIndex, value, item) {
            fn_expenseTypeSearchPop();
            }
        }
}, {
    dataField : "glAccCode",
    headerText : '<spring:message code="expense.GLAccount" />',
    editable : false

}, {
    dataField : "glAccCodeName",
    headerText : '<spring:message code="newWebInvoice.glAccountName" />',
    editable : false
}, {
    dataField : "budgetCode",
    headerText : '<spring:message code="expense.Activity" />',
    editable : false
}, {
    dataField : "budgetCodeName",
    headerText : '<spring:message code="newWebInvoice.activityName" />',
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
    dataField : "netAmt",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    dataType: "numeric",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true, // 0~9만 입력가능
        autoThousandSeparator : true // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
    }
}, {
    dataField : "taxAmt",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    dataType: "numeric",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true, // 0~9만 입력가능
        autoThousandSeparator : true // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
    }
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    dataType: "numeric",
    formatString : "#,##0",
    editable : false,
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return (item.netAmt + item.taxAmt);
    }
}, {
    dataField : "expDesc",
    headerText : '<spring:message code="newWebInvoice.description" />',
    width : 200
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
    // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
    enableRestore : true,

};

$(document).ready(function () {
    myGridID = AUIGrid.create("#viewEditWebInvoice_grid_wrap", myColumnLayout, myGridPros);
    
    $("#tempSave").click(fn_attachmentUpload);
    $("#submitPop").click(fn_approveLinePop);
    $("#add_btn").click(fn_addRow);
    $("#remove_btn").click(fn_removeRow);
    $("#supplier_search_btn").click(fn_supplierSearchPop);
    $("#costCenter_search_btn").click(fn_costCenterSearchPop);
    
    AUIGrid.bind(myGridID, "cellClick", function( event ) 
    {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        selectRowIdx = event.rowIndex;
    });
    
    AUIGrid.bind(myGridID, "cellEditEnd", function( event ) {
        if(event.dataField == "netAmt" || event.dataField == "taxAmt") {
            var totAmt = fn_getTotalAmount();
            $("#totalAmount").text(AUIGrid.formatNumber(totAmt, "#,##0"));
            $("#totAmt").val(totAmt);
        }
  });
    
    fn_setKeyInDate();
    
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
    	fn_attachmentDown(fileGrpId, fileId);
    });
});

/* 인풋 파일(멀티) start */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

/* $(document).on(//인풋파일 추가
    "click", ".auto_file2 a:contains('Add')", function(){
    
    $(".auto_file2:last-child").clone().insertAfter(".auto_file2:last-child");
    $(".auto_file2:last-child :file, .auto_file2:last-child :text").val("");
    return false;
}); */

$(document).on(//인풋파일 삭제
    "click", ".auto_file2 a:contains('Delete')", function(){
    var fileNum=$(".auto_file2").length;

    if(fileNum <= 1){

    }else{
        $(this).parents(".auto_file2").remove();
    }
    return false;
});
/* 인풋 파일(멀티) end */

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
    return AUIGrid.getCellFormatValue(myGridID, index, "totAmt");
}

function fn_getTotalAmount() {
    // 수정할 때 netAmount와 taxAmount의 values를 각각 더하고 합하기
    sum = 0;
    var netAmtList = AUIGrid.getColumnValues(myGridID, "netAmt");
    var taxAmtList = AUIGrid.getColumnValues(myGridID, "taxAmt");
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
    return sum;
}

function fn_supplierSearchPop() {
	var object = {
            accGrp : "VM01",
            accGrpName : "Coway_Suppliers_Local"
    };
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", object, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    var value = $("#costCenter").val();
    var object = {value:value};
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_expenseTypeSearchPop() {
    Common.popupDiv("/eAccounting/expense/expenseTypeSearchPop.do", {popClaimType:'J1'}, null, true, "expenseTypeSearchPop");
}

function fn_approveLinePop() {
    var value = $("#approveLine").val();
    var object = {value:value};
    Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
}

function fn_addRow() {
    AUIGrid.addRow(myGridID, {netAmt:0,taxAmt:0,totAmt:0}, "last");
}

function fn_removeRow() {
    var total = Number($("#totalAmount").text().replace(',', ''));
    AUIGrid.removeRow(myGridID, selectRowIdx);
    var value = fn_getValue(selectRowIdx);
    value = Number(value.replace(',', ''));
    total -= value;
    $("#totalAmount").text(AUIGrid.formatNumber(total, "#,##0"));
    $("#totAmt").val(total);
    // remove한 row를 화면상에서도 지우도록 구현 필요
    // totalAmount를 할때 값이 포함된다
    // TO DO
    AUIGrid.update(); // update 해본 결과 : 실패
}

function fn_attachmentUpload() {
	// TODO 파일 리스트에서 delete btn click인 경우 어떻게 처리할것인지
    var formData = Common.getFormData("form_viewEditWebInvoice");
    Common.ajaxFile("/eAccounting/webInvoice/attachmentUpload.do", formData, function(result) {
        console.log(result);
        $("#atchFileGrpId").val(result.fileGroupKey);
        fn_updateWebInvoiceInfo();
    });
}

function fn_attachmentDown(fileGrpId, fileId) {
	var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("POST", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        var subPath = result.fileSubPath;
        var fileName = result.physiclFileName;
        var orignlFileNm = result.atchFileName;
        
        window.open("/file/fileDown.do?subPath=" + subPath
                + "&fileName=" + fileName + "&orignlFileNm=" + orignlFileNm
                + "");
    });
}

function fn_updateWebInvoiceInfo() {
    var data = {
            costCentr : $("#newCostCenter").val(),
            costCentrName : $("#newCostCenterText").val(),
            memAccId : $("#newMemAccId").val(),
            gstRgistNo : $("#gstRgistNo").val(),
            bankCode : $("#bankCode").val(),
            bankAccNo : $("#bankAccNo").val(),
            invcType : $("#invcType").val(),
            invcNo : $("#invcNo").val(),
            invcDt : $("#invcDt").val(),
            payDueDt : $("#payDueDt").val(),
            atchFileGrpId : $("#atchFileGrpId").val(),
            invcRem : $("#invcRem").val(),
            totAmt : $("#totAmt").val(),
            crtUserId : $("#crtUserId").val()
    };
    
    Common.ajax("POST", "/eAccounting/webInvoice/updateWebInvoiceInfo.do", data, function(result) {
        console.log(result);
        $("#clmNo").val(result.clmNo);
        fn_saveGridInfo();
    });
    
}

function fn_saveGridInfo() {
	// TODO update인 경우 clmSeq값 필요, 어떻게 처리할것인지
    //var data = AUIGrid.exportToObject(myGridID);
    var gridData = GridCommon.getEditData(myGridID);
    var clmNo = $("#clmNo").val();
    
    console.log(gridData);
    
    Common.ajax("POST", "/eAccounting/webInvoice/saveGridInfo.do?clmNo=" + clmNo, GridCommon.getEditData(myGridID), function(result) {
        console.log(result);
        Common.alert("Temporary save succeeded.");
        //fn_SelectMenuListAjax() ;
    });
}

function fn_setGridData(data) {
	console.log(data);
	AUIGrid.setGridData(myGridID, data);
}

function fn_setCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
}

function fn_setSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#gstRgistNo").val($("#search_gstRgistNo").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
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

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" id="tempSave"><spring:message code="newWebInvoice.btn.tempSave" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="submitPop"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="">
<input type="hidden" id="clmNo" name="clmNo" value="${webInvoiceInfo.clmNo}">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="${webInvoiceInfo.atchFileGrpId}">
<input type="hidden" id="newMemAccId" name="memAccId" value="${webInvoiceInfo.memAccId}">
<input type="hidden" id="newCostCenter" name="costCentr" value="${webInvoiceInfo.costCentr}">
<input type="hidden" id="bankCode" name="bankCode" value="${webInvoiceInfo.bankCode}">
<input type="hidden" id="totAmt" name="totAmt" value="${webInvoiceInfo.totAmt}">

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
	<th scope="row"><spring:message code="webInvoice.invoiceDate" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="invcDt" name="invcDt" value="${webInvoiceInfo.invcDt}"/></td>
	<th scope="row"><spring:message code="newWebInvoice.keyInDate" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="keyDate" name="keyDate" value="${webInvoiceInfo.crtDt}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenterText" name="costCentrName" value="${webInvoiceInfo.costCentrName}"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="newWebInvoice.createUserId" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="crtUserId" name="crtUserId" value="${webInvoiceInfo.crtUserId}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.supplier" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newMemAccName" name="memAccName" value="${webInvoiceInfo.memAccName}"/><a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="newWebInvoice.invoiceType" /></th>
	<td>
	<select class="w100p">
		<option value="F" <c:if test="${webInvoiceInfo.invcType eq 'F'}">selected</c:if>><spring:message code="newWebInvoice.select.fullTax" /></option>
		<option value="S" <c:if test="${webInvoiceInfo.invcType eq 'S'}">selected</c:if>><spring:message code="newWebInvoice.select.simpleTax" /></option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.invoiceNo" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="invcNo" name="invcNo" value="${webInvoiceInfo.invcNo}"/></td>
	<th scope="row"><spring:message code="newWebInvoice.gstRegistNo" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="gstRgistNo" name="gstRgistNo" value="${webInvoiceInfo.gstRgistNo}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bank" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" value="${webInvoiceInfo.bankName}"/></td>
	<th scope="row"><spring:message code="newWebInvoice.payDueDate" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="payDueDt" name="payDueDt" value="${webInvoiceInfo.payDueDt}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bankAccount" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo" value="${webInvoiceInfo.bankAccNo}"/></td>
	<th scope="row"></th>
	<td></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
	<td colspan="3">
	<!-- TODO 미승인 상태인 경우 -->
	<c:forEach var="files" items="${attachmentList}" varStatus="st">
	<div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    <label>
    <input type='text' class='input_text' readonly='readonly' value="${files.atchFileName}" />
    <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
    </label>
    <span class='label_text'><a href='#' id="add_btn"><spring:message code="viewEditWebInvoice.add" /></a></span>
    <span class='label_text'><a href='#' id="remove_btn"><spring:message code="viewEditWebInvoice.delete" /></a></span>
    </div><!-- auto_file end -->
	</c:forEach>
	<c:if test="${fn:length(attachmentList) <= 0}">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    </div><!-- auto_file end -->
    </c:if>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.remark" /></th>
	<td colspan="3"><textarea cols="20" rows="5" id="invcRem" name="invcRem">${webInvoiceInfo.invcRem}</textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="totalAmount"><fmt:formatNumber value="${webInvoiceInfo.totAmt}" type="number" pattern="#,##0"/></span></h2>
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="add_btn"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="delete_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="viewEditWebInvoice_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->