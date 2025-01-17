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
//file action list
var update = new Array();
var remove = new Array();
var attachList;
var currList = ["MYR", "USD"];
var conditionalCheck = 0; //0:No need to check; 1:Need to check
var headerCheck = 1; //0:No need to check; 1:Need to check

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

doGetCombo('/eAccounting/vendor/selectVendorType.do', '612', '','vendorType', 'S');

$(document).ready(function () {
    //newGridID = AUIGrid.create("#newVendor_grid_wrap", myColumnLayout, myGridPros);
    var newGridID = Common.getFormData("form_newVendor");
    console.log("CallType:" + callType);

    setInputFile2();

    $("#tempSave").click(fn_tempSave);
    $("#submitPop").click(fn_submit);
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);

    fn_setKeyInDate();
    fn_setCostCenterEvent();
    fn_setSupplierEvent();

    //doGetCombo('/common/selectCodeList.do', '17', '', 'designation', 'S' , ''); // Customer Initial Type Combo Box

    $("#vendorCountry option[value='MY']").attr('selected', 'selected');
    $("#bankCountry option[value='MY']").attr('selected', 'selected');
    $("#vendorGroup option[value='VM11']").attr('selected', 'selected');
    $("#paymentMethod option[value='OTRX']").attr('selected', 'selected');
    $("#payAdvEmail1 option[value='ap@coway.com.my']").attr('selected', 'selected');

});

function fn_close(){
    $("#popup_wrap").remove();
}

function fn_jsFunction1(){
	var txtPaymentMethod = $("#paymentMethod :selected").val();
	console.log('txtPaymentMethod' + txtPaymentMethod);
	if(txtPaymentMethod == 'CASH' || txtPaymentMethod == 'CHEQ')
    {
          $("#bankListHeader").replaceWith('<th id="bankListHeader" scope="row"> Bank</th>');
          $("#bankAccHolderHeader").replaceWith('<th id="bankAccHolderHeader" scope="row">Account Holder</th>');
          $("#bankAccNoHeader").replaceWith('<th id="bankAccNoHeader" scope="row">Bank Account Number</th>');
          $("#bankList").replaceWith('<select class="w100p" id="bankList" name="bankList"><option value=""></option><c:forEach var="list" items="${bankList}" varStatus="status"><option value="${list.code}">${list.name}</option></c:forEach></select>')
          headerCheck = 0;

    }
    else
    {
        $("#bankListHeader").replaceWith('<th id="bankListHeader" scope="row"> Bank<span class="must">*</span></th>');
        $("#bankAccHolderHeader").replaceWith('<th id="bankAccHolderHeader" scope="row">Account Holder<span class="must">*</span></th>');
        $("#bankAccNoHeader").replaceWith('<th id="bankAccNoHeader" scope="row">Bank Account Number<span class="must">*</span></th>');
        $("#bankList").replaceWith('<select class="w100p" id="bankList" name="bankList"><c:forEach var="list" items="${bankList}" varStatus="status"><option value="${list.code}">${list.name}</option></c:forEach></select>')
        headerCheck = 1;
    }
	console.log('headerCheck: ' + headerCheck);
	}


function fn_jsFunction(){
	console.log("fn_jsFunction");
	var txtBankCountry = $("#bankCountry :selected").val();
	var txtVendorCountry = $("#vendorCountry :selected").val();
	var txtPaymentMethod = $("#paymentMethod :selected").val();

	console.log("txtBankCountry" + txtBankCountry);
	console.log("txtVendorCountry" + txtVendorCountry);
	console.log("txtPaymentMethod" + txtPaymentMethod);

	if(txtBankCountry != 'MY')
	{
		$("#bankList").replaceWith('<input type="text" class="w100p" id="bankList" name="bankList" style="text-transform:uppercase"/>');
		$("#swiftCodeHeader").html('Swift Code<span class="must">*</span>');
		$("#bankAccNo").attr('maxLength',100);
		conditionalCheck = 1;
	}
	if(txtBankCountry == 'MY')
	{
		$("#bankList").replaceWith('<select class="w100p" id="bankList" name="bankList"><c:forEach var="list" items="${bankList}" varStatus="status"><option value="${list.code}">${list.name}</option></c:forEach></select>');
		$("#swiftCodeHeader").html('Swift Code');
		conditionalCheck = 0;
		console.log('$("#bankAccNo").length: ' + $("#bankAccNo").val().length);
		if($("#bankAccNo").val().length > 16)
		{
			var strBankAccNo = $("#bankAccNo").val();
			strBankAccNo = strBankAccNo.substr(0,16);
			$("#bankAccNo").val(strBankAccNo);
		}
		$("#bankAccNo").attr('maxLength',16);
		console.log("conditionalCheck: " + conditionalCheck);

	}

	console.log("conditionalCheck: " + conditionalCheck);

    if(txtVendorCountry != 'MY')
    {
        $("#paymentMethod").val("TTRX").attr("selected", "selected");
    }
    if(txtVendorCountry == 'MY')
    {
        $("#paymentMethod").val("OTRX").attr("selected", "selected");
    }
    console.log($("#paymentMethod").val());


}

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
}

function fn_tempSave() {

	fn_vendorValidation("ts");
}

function fn_submit() {
    fn_vendorValidation("");
}

function fn_attachmentUpdate(st) {
    // 신규 add or 추가 add인지 update or delete인지 분기 필요
    // 파일 수정해야 하는 경우 : delete 버튼 클릭 or file 버튼 클릭으로 수정
    // delete 버튼의 파일이름 찾아서 저장
    var formData = Common.getFormData("form_newVendor");
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

function fn_attachmentUpload(st) {
	var formData = Common.getFormData("form_newVendor");
    Common.ajaxFile("/eAccounting/vendor/attachmentUpload.do", formData, function(result) {
        // 신규 add return atchFileGrpId의 key = fileGroupKey
         console.log("attachmentUpload: " + result);
        $("#atchFileGrpId").val(result.data.fileGroupKey);
        fn_insertVendorInfo(st);
    });
}

function fn_insertVendorInfo(st) {
    var obj = $("#form_newVendor").serializeJSON();

    if(st == 'new')
   	{
    	console.log("fn_insertVendorInfo_TempSave");
    	Common.ajax("POST", "/eAccounting/vendor/insertVendorInfo.do", obj, function(result) {

    	});
    	Common.alert('Temporary Save succeeded.');
    	fn_close();
    	fn_selectVendorList();
   	}
    else
    {
    	console.log("fn_insertVendorInfoSubmit");
        Common.ajax("POST", "/eAccounting/vendor/insertVendorInfo.do", obj, function(result) {
            console.log(result);

            $("#newReqNo").val(result.data.reqNo);
            $("#appvPrcssNo").val(result.data.appvPrcssNo);

            // new
            console.log("newReqNo in newVendorPop: " + $("#newReqNo").val());
               if(FormUtil.isEmpty($("#newReqNo").val())) {
                   Common.popupDiv("/eAccounting/vendor/approveLinePop.do", null, null, true, "approveLineSearchPop");
               } else {
                   // update
                   Common.popupDiv("/eAccounting/vendor/approveLinePop.do", null, null, true, "approveLineSearchPop");
               }
        });
    }

}

function fn_vendorValidation(ts){

	var checkResult = fn_checkEmpty();
	var checkRegex = fn_checkRegex();

    if(!checkResult){
        return false;
    }

    if(!checkRegex){
    	return false;
    };

    if(ts == 'ts') // temp_Save
   	{
    	var obj = $("#form_newVendor").serializeJSON();
        console.log("fn_vendorValidation_saveDraft");
        Common.ajax("GET", "/eAccounting/vendor/vendorValidation.do?_cacheId=" + Math.random(), obj, function(result){
            $("#isReset").val(result.isReset);
            $("#isPass").val(result.isPass);
            $("#mem_acc_id").val(result.vendorAccId);

             if($("#isReset").val() == 1 && $("#isPass").val() == 0)
            {
            	// new
                if(FormUtil.isEmpty($("#newReqNo").val())) {
                    fn_attachmentUpload(callType);
                } else {
                // update
                    fn_attachmentUpdate(callType);
                 }
            }
            else
            {
            	if($("#mem_acc_id").val() != null && $("#mem_acc_id").val() != ''){

            		Common.alert('Vendor Existed. Member Account ID: ' + $("#mem_acc_id").val());
                    $('#form_newVendor').clearForm();
            	} else {
            		Common.alert('Vendor existed in Pending stage.');
            		$('#form_newVendor').clearForm();
            	}

            }

        });
   	}
    else // Submit
    {
    	var obj = $("#form_newVendor").serializeJSON();
        console.log("fn_vendorValidation_submit");
        Common.ajax("GET", "/eAccounting/vendor/vendorValidation2.do?_cacheId=" + Math.random(), obj, function(result){
            $("#isReset").val(result.isReset);
            $("#isPass").val(result.isPass);
            $("#mem_acc_id").val(result.vendorAccId);

             if($("#isReset").val() == 1 && $("#isPass").val() == 0)
            {
                if(FormUtil.isEmpty($("#newReqNo").val())) {
                    fn_attachmentUpload("");
                }
                else{
                    fn_attachmentUpdate("");
                }
            }
            else
            {
                Common.alert('Vendor Existed. Member Account ID: ' + $("#mem_acc_id").val());
                $('#form_newVendor').clearForm();
            }

        });
    }
}

function fn_updateWebInvoiceInfo(st) {
    var obj = $("#form_newVendor").serializeJSON();
    var gridData = GridCommon.getEditData(newGridID);
    obj.gridData = gridData;
    console.log(obj);
    Common.ajax("POST", "/eAccounting/webInvoice/updateWebInvoiceInfo.do", obj, function(result) {
        console.log(result);
        //fn_selectWebInvoiceItemList(result.data.reqNo);
        fn_selectWebInvoiceInfo(result.data.reqNo);

        if(st == "new"){
            Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
            $("#newWebInvoicePop").remove();
        }
        fn_selectWebInvoiceList();
    });
}

function fn_checkRegex()
{
	 var checkRegexResult = true;
	 var regExpSpecChar = /^(?!-)(?!\/)\S{1}[a-zA-Z0-9 ~`!#$%\^&*+=[\]\\(\)\';,{}.|\\":<>\?]*(?!-)(?!\/)\S{1}$/;
	 var regExpNum = /^[0-9]*$/;
     var regNric= new RegExp("(([0-9]{2}(?!0229))|([02468][048]|[13579][26])(?=0229))(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|(?<!02)30|(?<!02|4|6|9|11)31)[0-9]{2}[0-9]{4}$");

     if( $("#vendorType").val() == '1'){
    	 if($("#vendorGroup").val() == 'VM11'){
    		 if(regNric.test($("#regCompNo").val()) == false){
    			 Common.alert("* Please make sure NRIC/Company No. format is correct. ");
                 checkRegexResult = false;;
                 return checkRegexResult;
    		 }else if($("#regCompNo").val().length != 12){
                 Common.alert('Only allow 12 characters for NRIC/Company No.');
                 return false;
             }
    	 }
     }
     else if( regExpSpecChar.test($("#regCompName").val()) == false ){
	         Common.alert("* Special character or space as the first and last character are not allow for Registered Company/Individual Name. ");
	         checkRegexResult = false;;
	         return checkRegexResult;
     }
     else if( regExpSpecChar.test($("#bankAccHolder").val()) == false ){
            Common.alert("* Special character or space as the first and last character are not allow for Bank Account Holder. ");
            checkRegexResult = false;;
            return checkRegexResult;
     }
     else if( regExpNum.test($("#bankAccNo").val()) == false ){
            Common.alert("* Only number is allow for Bank Account Number. ");
            checkRegexResult = false;;
            return checkRegexResult;
     }
     else if( regExpNum.test($("#postalCode").val()) == false ){
            Common.alert("* Only number is allow for Postal Code. ");
            checkRegexResult = false;;
            return checkRegexResult;
     }
     return checkRegexResult;
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || type === 'number' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }

        if(this.id === 'vendorCountry' || this.id === 'bankCountry')
       	{
        	$("#vendorCountry").val("MY").attr("selected", "selected");
        	$("#bankCountry").val("MY").attr("selected", "selected");
       	}

    });
};


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Vendor Registration</h1>
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

<form action="#" method="post" enctype="multipart/form-data" id="form_newVendor" name="form_newVendor">
<input type="hidden" id="newReqNo" name="newReqNo">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpId">
<input type="hidden" id="appvPrcssNo" name="appvPrcssNo">
<input type="hidden" id="isReset" name="isReset">
<input type="hidden" id="isPass" name="isPass">
<input type="hidden" id="mem_acc_id" name="mem_acc_id">
<input type="hidden" id="newCostCenterText" name="costCentrName">
<!-- <input type="hidden" id="newMemAccName" name="memAccName"> -->
<input type="hidden" id="bankCode" name="bankCode">
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
    <th>Vendor Type<span class="must">*</span></th>
    <td>
        <select id="vendorType" name="vendorType" class="w100p">
    </td>
</tr>
<tr>
    <th scope="row">Vendor Group<span class="must">*</span></th>
	    <td>
	       <select class="w100p" id=vendorGroup name="vendorGroup">
		          <option value="VM02">VM02 - Coway_Supplier_Foreign</option>
		          <option value="VM03">VM03 - Coway_Supplier_Foreign (Related Company)</option>
		          <option value="VM11">VM11 - Coway_Suppliers_Local</option>
	       </select>
    </td>
	<th scope="row">Key in date</th>
	<td>
	<input type="text" title="" id="keyDate" name="keyDate" placeholder="DD/MM/YYYY" class="w100p" />
	</td>
</tr>
<tr>
      <th scope="row">Cost Center<span class="must">*</span></th>
      <td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" value="${costCentr}"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Create User ID</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" value="${userName} / ${memCode}"/></td>
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
	<th colspan=2 scope="row">Registered Company/Individual Name<span class="must">*</span></th>
	<td colspan=3><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="regCompName" name="regCompName" maxlength = "50"/></td>
</tr>
<tr>
	<th colspan = 2 scope="row">Company Registration No/IC No<span class="must">*</span></th>
    <td colspan="3"><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="regCompNo" name="regCompNo" maxlength = "18"/></td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address (payment advice)<span class="must">*</span></th>
    <td colspan="3">
        <select class="w100p" id=payAdvEmail1 name="payAdvEmail1">
                  <option value="ap@coway.com.my">ap@coway.com.my</option>
                  <option value="ga.payment@coway.com.my">ga.payment@coway.com.my</option>
           </select>
    </td>
</tr>
<tr>
    <th colspan = 2 scope="row">Email Address 2 (payment advice)</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="payAdvEmail2" name="payAdvEmail2"/></td>
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
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="street" name="street"/></td>
    <th scope="row">House/Lot Number</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="houseNo" name="houseNo"/></td>
</tr>
<tr>
	<th scope="row">Postal Code</th>
	<td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="postalCode" name="postalCode" maxlength = "10"/></td>
	<th scope="row">City</th>
	<td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="city" name="city" maxlength = "50"/></td>
</tr>
<tr>
	<th scope="row">Country</th>
	<td colspan=3>
	<select onchange="fn_jsFunction()" style="text-transform:uppercase" class="w100p" id="vendorCountry" name="vendorCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
	</td>
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
    <td>
        <select onchange="fn_jsFunction1()" class="w100p" id=paymentMethod name="paymentMethod">
                  <option value="CASH">CASH</option>
                  <option value="CHEQ">CHEQUE</option>
                  <option value="OTRX">ONLINE TRANSFER</option>
                  <option value="TTRX">TELEGRAPHIC TRANSFER</option>
           </select>
    </td>
</tr>
<tr>
    <th>Others (Please State)</th>
    <td colspan=3><input type="text" title="" placeholder="" class="w100p" id="others" name="others" maxlength = "50"/></td>
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
    <td>
        <select onchange="fn_jsFunction()" style="text-transform:uppercase" class="w100p" id="bankCountry" name="bankCountry">
            <c:forEach var="list" items="${countryList}" varStatus="status">
               <option  value="${list.code}">${list.name}</option>
            </c:forEach>
        </select>
    </td>
    <th id="bankAccHolderHeader" scope="row">Account Holder<span class="must">*</span></th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="bankAccHolder" name="bankAccHolder" maxlength = "60"/></td>
</tr>
<tr>
    <th id="bankListHeader" scope="row"> Bank<span class="must">*</span></th>
    <td>
        <select class="w100p" id="bankList" name="bankList">
	        <c:forEach var="list" items="${bankList}" varStatus="status">
	           <option value="${list.code}">${list.name}</option>
	        </c:forEach>
        </select>

    </td>
    <th id="bankAccNoHeader" scope="row">Bank Account Number<span class="must">*</span></th>
    <td><input style="text-transform: uppercase" type="text" maxlength = "16" title="" placeholder="" class="w100p" id="bankAccNo" name="bankAccNo"/></td>
</tr>
<tr>
    <th>Branch</th>
    <td colspan=3><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="bankBranch" name="bankBranch" maxlength = "50"/></td>
</tr>
<tr>
    <th id="swiftCodeHeader">Swift Code</th>
    <td colspan=3><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="swiftCode" name="swiftCode" maxlength = "20"/></td>
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
    <!-- <select class="w100p" id="designation" name="designation"></select>-->
    <select class="w100p" id=designation name="designation">
                  <option value="Company">Company</option>
                  <option value="Mr.">Mr.</option>
                  <option value="Mr. and Mrs.">Mr. and Mrs.</option>
                  <option value="Ms.">Ms.</option>
           </select>
    </td>

     <th scope="row"> Name</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="vendorName" name="vendorName" maxlength = "50"/></td>
</tr>
<tr>
    <th>Phone Number</th>
    <td><input style="text-transform: uppercase" type="text" title="" placeholder="" class="w100p" id="vendorPhoneNo" name="vendorPhoneNo" maxlength = "20"/></td>
    <th>Email Address</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="vendorEmail" name="vendorEmail" /></td>
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
	<td colspan="3" id="attachTd" name="attachTd">
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
