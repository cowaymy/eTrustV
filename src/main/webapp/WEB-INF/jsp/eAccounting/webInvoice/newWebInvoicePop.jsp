<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
/* 인풋 파일(멀티) start */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}
setInputFile2();

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
    editable : false,
    renderer : { // HTML 템플릿 렌더러 사용
        type : "TemplateRenderer"
    }
}, {
    dataField : "netAmount",
    headerText : '<spring:message code="newWebInvoice.netAmount" />',
    dataType: "numeric",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true, // 0~9만 입력가능
        autoThousandSeparator : true // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
    },
}, {
    dataField : "taxAmount",
    headerText : '<spring:message code="newWebInvoice.taxAmount" />',
    dataType: "numeric",
    editRenderer : {
        type : "InputEditRenderer",
        onlyNumeric : true, // 0~9만 입력가능
        autoThousandSeparator : true // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
    },
}, {
    dataField : "totalAmount",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    dataType: "numeric",
    editable : false,
    labelFunction : function(  rowIndex, columnIndex, labelText, headerText, item, dataField ) {
        var sum = 0;
    	if(!item._$isBranch) {
    		if(item.netAmount != null) {
                sum += item.netAmount;
            }
            if(item.taxAmount != null) {
                sum += item.taxAmount;
            }
            /* totalAmount += sum;
            $("#totalAmount").text(AUIGrid.formatNumber(totalAmount, "#,##0")); */
        }
    	return AUIGrid.formatNumber(sum, "#,##0");
    }
}, {
    dataField : "description",
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
    
    editable : true
};

var myGridID;
var taxCodeSelectBox;
var totalAmount = 0;

$(document).ready(function () {
	myGridID = AUIGrid.create("#newWebInvoice_grid_wrap", myColumnLayout, myGridPros);
	
    $("#tempSave").click(fn_tempSave);
    $("#submitPop").click(fn_approveLinePop);
    $("#add_btn").click(fn_addRow);
    //$("#delete_btn").click(fn_addRow);
	$("#supplier_search_btn").click(fn_supplierSearchPop);
    $("#costCenter_search_btn").click(fn_costCenterSearchPop);
    
    Common.ajax("POST", "/eAccounting/webInvoice/selectTextCodeWebInvoiceFlag.do", null, function(result) {
        
        console.log(result);
        
        taxCodeSelectBox = '<select class="w100p" name="textCode"><option></option>';
        for(var i in result) {
        	taxCodeSelectBox += '<option value="' + result[i].taxCode + '">' + result[i].taxName + '</option>';
        }
        taxCodeSelectBox += '</select>';
        
        fn_addRow();
    });
    
    fn_setKeyInDate();
});

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
	$("#keyInDate").val(today)
}

function fn_supplierSearchPop() {
    var value = $("#supplier").val();
    var object = {value:value};
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
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
	var item = {"taxCode" : taxCodeSelectBox};
	AUIGrid.addRow(myGridID, item, "last");
}

function fn_uploadFile() {
	var formData = Common.getFormData("form_newWebInvoice");
	console.log(formData);
	Common.ajaxFile("/eAccounting/webInvoice/attachmentUpload.do", formData, function(result) {

        console.log("총 갯수 : " + result.length);
        console.log(JSON.stringify(result));
    });
}

function fn_tempSave() {
	fn_uploadFile();
	
	/* Common.ajax("POST", "/eAccounting/webInvoice/tempSave.do", $("#form_newWebInvoice").serialize(), function(result) {
        console.log(result);
    }); */
}

</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="newWebInvoice.title" /></h1>
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

<form action="#" method="post" enctype="multipart/form-data" id="form_newWebInvoice">

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
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="invoiceDate"/></td>
	<th scope="row"><spring:message code="newWebInvoice.keyInDate" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="keyInDate" name="keyInDate"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCenter"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="newWebInvoice.createUserId" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${userId}" name="createUserId"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.supplier" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newSupplier" name="supplier"/><a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="newWebInvoice.invoiceType" /></th>
	<td>
	<select class="w100p" name="invoiceType">
		<option value="F"><spring:message code="newWebInvoice.select.fullTax" /></option>
		<option value="S"><spring:message code="newWebInvoice.select.simpleTax" /></option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.invoiceNo" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" name="invoiceNo"/></td>
	<th scope="row"><spring:message code="newWebInvoice.gstRegistNo" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="gstRegistrationNo" name="gstRegistrationNo"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bank" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bank" name="bank"/></td>
	<th scope="row"><spring:message code="newWebInvoice.payDueDate" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="paymentDueDate"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bankAccount" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccount" name="bankAccount"/></td>
	<th scope="row"></th>
	<td></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
	<td colspan="3">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    </div><!-- auto_file end -->
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.remark" /></th>
	<td colspan="3"><textarea cols="20" rows="5" name="remark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="totalAmount"></span></h2>
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="add_btn"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="delete_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="newWebInvoice_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
