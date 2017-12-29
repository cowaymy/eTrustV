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
#newWebInvoice_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
var newGridID;
var selectRowIdx;
var callType = "${callType}";
var keyValueList = $.parseJSON('${taxCodeList}');
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
        valueField : "taxName", // value 에 해당되는 필드명
        
    }
}, {
    dataField : "taxRate",
    dataType: "numeric",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    editable : false
}, {
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
    },
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

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    editable : true,
    softRemoveRowMode : false,
    rowIdField : "clmSeq",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {
    newGridID = AUIGrid.create("#newWebInvoice_grid_wrap", myColumnLayout, myGridPros);
    
    setInputFile2();
    
    $("#tempSave").click(fn_tempSave);
    $("#submitPop").click(fn_approveLinePop);
    $("#add_row").click(fn_addRow);
    $("#remove_row").click(fn_removeRow);
    $("#supplier_search_btn").click(fn_popSupplierSearchPop);
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);
    
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
                        } else {
                        	taxAmt = event.value;
                        	if(event.item.oriTaxAmt > taxAmt) {
                                taxNonClmAmt = event.item.oriTaxAmt - taxAmt;
                            } else {
                                taxNonClmAmt = taxAmt - event.item.oriTaxAmt;
                            }
                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxAmt", taxAmt);
                            AUIGrid.setCellValue(newGridID, event.rowIndex, "taxNonClmAmt", taxNonClmAmt);
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
  });
    
    fn_setKeyInDate();
    fn_setPayDueDtEvent();
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_approveLinePop() {
	var data = {
			memAccId : $("#newMemAccId").val(),
            invcNo : $("#invcNo").val()
    }
    Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
        console.log(result);
        if(result.data) {
        	Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
        } else {
            var checkResult = fn_checkEmpty();
            
            if(!checkResult){
                return false;
            }
            
            // tempSave를 하지 않고 바로 submit인 경우
            if(FormUtil.isEmpty($("#clmNo").val())) {
                // 신규 상태에서 approve, 파일 업로드 후 info 인서트 처리
                fn_attachmentUpload("");
            } else {
                fn_updateWebInvoiceInfo("");
            }
            
            Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
        }
    });
}

function fn_tempSave() {
	var data = {
            memAccId : $("#newMemAccId").val(),
            invcNo : $("#invcNo").val()
    }
    Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
        console.log(result);
        if(result.data) {
        	Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
        } else {
        	var checkResult = fn_checkEmpty();
            
            if(checkResult){
                fn_attachmentUpload(callType);
            }
        }
    });
}

function fn_attachmentUpload(st) {
	var formData = Common.getFormData("form_newWebInvoice");
    Common.ajaxFile("/eAccounting/webInvoice/attachmentUpload.do", formData, function(result) {
        console.log(result);
        // 신규 add return atchFileGrpId의 key = fileGroupKey
        $("#atchFileGrpId").val(result.data.fileGroupKey);
        fn_insertWebInvoiceInfo(st);
    });
}

function fn_insertWebInvoiceInfo(st) {
    var obj = $("#form_newWebInvoice").serializeJSON();
    var gridData = GridCommon.getEditData(newGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/webInvoice/insertWebInvoiceInfo.do", obj, function(result) {
        console.log(result);
        $("#clmNo").val(result.data.clmNo);
        fn_selectWebInvoiceItemList(result.data.clmNo);
        
        if(st == 'new') {
            Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
            $("#newWebInvoicePop").remove();
        }
        fn_selectWebInvoiceList();
    });
}

function fn_updateWebInvoiceInfo(st) {
    var obj = $("#form_newWebInvoice").serializeJSON();
    var gridData = GridCommon.getEditData(newGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/webInvoice/updateWebInvoiceInfo.do", obj, function(result) {
        console.log(result);
        fn_selectWebInvoiceItemList(result.data.clmNo);
        if(st == "view"){
            Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
            $("#viewEditWebInvoicePop").remove();
        }
        fn_selectWebInvoiceList();
    });
    
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
<input type="hidden" id="clmNo" name="clmNo">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId">
<input type="hidden" id="newCostCenterText" name="costCentrName">
<input type="hidden" id="newMemAccId" name="memAccId">
<input type="hidden" id="bankCode" name="bankCode">
<input type="hidden" id="totAmt" name="totAmt">
<input type="hidden" id="crtUserId" name="crtUserId" value="${userId}">

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
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="invcDt" name="invcDt"/></td>
	<th scope="row"><spring:message code="newWebInvoice.keyInDate" /></th>
	<td><input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p" id="keyDate" name="keyDate"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="newWebInvoice.createUserId" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${userName}"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="webInvoice.supplier" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newMemAccName" name="memAccName"/><a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="newWebInvoice.invoiceType" /></th>
	<td>
	<select class="w100p" id="invcType" name="invcType">
		<option value="F"><spring:message code="newWebInvoice.select.fullTax" /></option>
		<option value="S"><spring:message code="newWebInvoice.select.simpleTax" /></option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.invoiceNo" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="invcNo" name="invcNo" autocomplete=off/></td>
	<th scope="row"><spring:message code="pettyCashNewExp.gstRgistNo" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="gstRgistNo" name="gstRgistNo"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bank" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName"/></td>
	<th scope="row"><spring:message code="newWebInvoice.payDueDate" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="payDueDt" name="payDueDt"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.bankAccount" /></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo"/></td>
	<th scope="row"><spring:message code="newWebInvoice.utilNo" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="utilNo" name="utilNo"/></td>
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
	<td colspan="3"><textarea cols="20" rows="5" id="invcRem" name="invcRem" placeholder="Enter up to 200 characters"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="total_text"><spring:message code="newWebInvoice.total" /><span id="totalAmount"></span></h2>
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="add_row"><spring:message code="newWebInvoice.btn.add" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="remove_row"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="newWebInvoice_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
