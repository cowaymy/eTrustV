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
#newVendor_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
var newGridID;
var selectRowIdx;
var callType = "${callType}";
var keyValueList = $.parseJSON('${taxCodeList}');
//file action list
var update = new Array();
var remove = new Array();
var attachList;
var currList = ["MYR", "USD"];

/*
var myColumnLayout = [ {
    dataField : "clamUn",
    editable : false,
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

}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />',
    renderer : {
        type : "DropDownListRenderer",
        list : currList
    }
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="newWebInvoice.totalAmount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00",
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
    width : 200,
    editRenderer : {
        maxlength: 100
    }
}, {
    dataField : "yN",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];
*/

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

$("#keyDate").val($.datepicker.formatDate('dd/mm/yy', new Date()));

$("#keyDate").attr("readOnly", true);


$(document).ready(function () {
    //newGridID = AUIGrid.create("#newVendor_grid_wrap", myColumnLayout, myGridPros);

    setInputFile2();

    $("#tempSave").click(fn_tempSave);
    $("#remove_row").click(fn_removeRow);
    $("#supplier_search_btn").click(fn_popSupplierSearchPop);
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);

    fn_setNewGridEvent();

    fn_setKeyInDate();
    fn_setPayDueDtEvent();
    fn_setCostCenterEvent();
    fn_setSupplierEvent();

    doGetCombo('/common/selectCodeList.do', '17', '', 'designation', 'S' , ''); // Customer Initial Type Combo Box

    $("#newRegCompName").bind("keyup", function()
   	    {
   	        $(this).val($(this).val().toUpperCase());

   	    });
    $("#newRegCompNo").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#street").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#houseNo").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#postalCode").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#city").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#accHolder").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#branch").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#bankAccNo").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#swiftCode").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#vendorName").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#vendorPhoneNo").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
    $("#vendorEmail").bind("keyup", function()
            {
                $(this).val($(this).val().toUpperCase());

            });
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_approveLinePop() {
	var checkResult = fn_checkEmpty();

    if(!checkResult){
        return false;
    }

    var data = {
            RegCompName : $("#newRegCompName").val(),
            invcNo : $("#invcNo").val()
    }

    // new
    if(FormUtil.isEmpty($("#newClmNo").val())) {
        Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
            console.log(result);
            if(result.data) {
                Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
            } else {
                fn_attachmentUpload("");

                Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
            }
        });
    } else {
        // update
        data.clmNo = $("#newClmNo").val();
        Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
            console.log(result);
            if(result.data && result.data != $("#newClmNo").val()) {
                Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
            } else {
                fn_attachmentUpdate("");

                Common.popupDiv("/eAccounting/webInvoice/approveLinePop.do", null, null, true, "approveLineSearchPop");
            }
        });
    }

}

function fn_tempSave() {
	var checkResult = fn_checkEmpty();

    if(!checkResult){
        return false;
    }

    var data = {
            RegCompName : $("#newRegCompName").val(),
            invcNo : $("#invcNo").val()
    }
    // new
    if(FormUtil.isEmpty($("#newClmNo").val())) {
    	Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
            console.log(result);
            if(result.data) {
                Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
            } else {
                fn_attachmentUpload(callType);
            }
        });
    } else {
    	// update
    	Common.ajax("GET", "/eAccounting/webInvoice/selectSameVender.do?_cacheId=" + Math.random(), data, function(result) {
            console.log(result);
            if(result.data && result.data != $("#newClmNo").val()) {
                Common.alert('<spring:message code="newWebInvoice.sameVender.msg" />');
            } else {
            	fn_attachmentUpdate(callType);
            }
        });
    }
}

function fn_attachmentUpload(st) {
	var formData = Common.getFormData("form_editVendor");
    Common.ajaxFile("/eAccounting/webInvoice/attachmentUpload.do", formData, function(result) {
        console.log(result);
        // 신규 add return atchFileGrpId의 key = fileGroupKey
        $("#atchFileGrpId").val(result.data.fileGroupKey);
        fn_insertWebInvoiceInfo(st);
    });
}

function fn_insertWebInvoiceInfo(st) {
    var obj = $("#form_editVendor").serializeJSON();
    var gridData = GridCommon.getEditData(newGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/webInvoice/insertWebInvoiceInfo.do", obj, function(result) {
        console.log(result);
        $("#newClmNo").val(result.data.clmNo);
        //fn_selectWebInvoiceItemList(result.data.clmNo);
        fn_selectWebInvoiceInfo(result.data.clmNo);

        if(st == 'new') {
            Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
            $("#newWebInvoicePop").remove();
        }
        fn_selectWebInvoiceList();
    });
}

function fn_attachmentUpdate(st) {
    // 신규 add or 추가 add인지 update or delete인지 분기 필요
    // 파일 수정해야 하는 경우 : delete 버튼 클릭 or file 버튼 클릭으로 수정
    // delete 버튼의 파일이름 찾아서 저장
    var formData = Common.getFormData("form_editVendor");
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
    var obj = $("#form_editVendor").serializeJSON();
    var gridData = GridCommon.getEditData(newGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/webInvoice/updateWebInvoiceInfo.do", obj, function(result) {
        console.log(result);
        //fn_selectWebInvoiceItemList(result.data.clmNo);
        fn_selectWebInvoiceInfo(result.data.clmNo);

        if(st == "new"){
            Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
            $("#newWebInvoicePop").remove();
        }
        fn_selectWebInvoiceList();
    });
}


</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Edit Vendor Registration</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue2"><a href="#" id="tempSave">Save Draft</a></p></li>
	<li><p class="btn_blue2"><a href="#" id="submitPop">Submit</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->

<form action="#" method="post" enctype="multipart/form-data" id="form_editVendor">
<input type="hidden" id="newClmNo" name="clmNo">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId">
<input type="hidden" id="newCostCenterText" name="costCentrName">
<!-- <input type="hidden" id="newMemAccName" name="memAccName"> -->
<input type="hidden" id="bankCode" name="bankCode">
<input type="hidden" id="totAmt" name="totAmt">
<input type="hidden" id="crtUserId" name="crtUserId" value="${userId}">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Claim No / Vendor Code<span class="must">*</span></th>
    <td colspan=3><input type="text" title="" id="newVendorCode" name="vendorCode" placeholder="" class="readonly w100p" readonly="readonly" value="*To change again when edit draft to show else completed request no need show*"/></td><!--  value="${claimNo}"-->
</tr>
<tr>
    <th scope="row">Vendor Group<span class="must">*</span></th>
    <td><input type="text" title="" id="newVendorGroup" name= "vendorGroup" placeholder="" class="readonly w100p" readonly="readonly" value="${vendorGrp }" /></td>
	<th scope="row">Key in date</th>
	<td>
	<input type="text" title="" id="keyDate" name="keyDate" placeholder="DD/MM/YYYY" class="w100p" />
	</td>
</tr>
<tr>
      <th scope="row">Cost Center</th>
      <td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" value="${costCentr}"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Create User ID</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${userName}"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th colspan=2 scope="row">Registered Company/Individual Name</th>
	<td colspan=3><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newRegCompName" name="regCompName" value="${regCompName}"/></td>
</tr>
<tr>
	<th colspan = 2 scope="row">Company Registration No/IC No</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newRegCompNo" name="regCompNo" value="${regCompNo}"/></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Address</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Street</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="street" name="street"/></td>
    <th scope="row">House/Lot Number</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="houseNo" name="houseNo"/></td>
</tr>
<tr>
	<th scope="row">Postal Code</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="postalCode" name="postalCode"/></td>
	<th scope="row">City</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="city" name="city"/></td>
</tr>
<tr>
	<th scope="row">Country</th>
	<td>Combo Box</td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Payment Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th>Payment Terms <b>(Days)</b></th>
    <td><input type="number" min="1"  title="" placeholder="" class="w100p" id="paymentTerms" name="paymentTerms" /></td>
    <th>Payment Method</th>
    <td>Combo Box</td>
</tr>
<tr>
    <th>Others (Please State)</th>
    <td colspan=3><input type="text" title="" placeholder="" class="w100p" id="others" name="others" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Bank Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Country</th>
    <td>Combo Box</td>
    <th scope="row">Account Holder<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" id="accHolder" name="accHolder"/></td>
</tr>
<tr>
    <th scope="row"> Bank<span class="must">*</span></th>
    <td>Combo Box</td>
    <th scope="row">Bank Account Number<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" id="bankAccNo" name="bankAccNo"/></td>
</tr>
<tr>
    <th>Branch</th>
    <td colspan=3><input type="text" title="" placeholder="" class="w100p" id="branch" name="branch"/></td>
</tr>
<tr>
    <th>Swift Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="swiftCode" name="swiftCode"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Vendor Contact Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Designation</th>
    <td>
    <select class="w100p" id="designation" name="designation"></select>
    </td>
</tr>
<tr>
    <th scope="row"> Name</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="vendorName" name="vendorName"/></td>
</tr>
<tr>
    <th>Phone Number</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="vendorPhoneNo" name="phoneNo"/></td>
    <th>Email Address</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="vendorEmail" name="email" /></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Attachment<span class="must">*</span></th>
	<td colspan="3" id="attachTd">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    </div><!-- auto_file end -->
	</td>
</tr>

</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->
<%--
<section class="search_result"><!-- search_result start -->


<article class="grid_wrap" id="newVendor_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->
--%>
</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
