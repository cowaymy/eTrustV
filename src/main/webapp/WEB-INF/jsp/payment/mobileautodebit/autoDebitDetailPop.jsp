<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
var myFileCaches = {};
var update = new Array();
var remove = new Array();
var atchFileGroupId = 0;
var cifId = 0;
var otherFile1Id = 0;
var otherFile2Id = 0;
var otherFile3Id = 0;
var otherFile4Id = 0;

var cifFileName = "";
var otherFileName1 = "";
var otherFileName2 = "";
var otherFileName3 = "";
var otherFileName4 = "";


$(document).ready(function() {
    console.log("${mobileAutoDebitDetail}");
    console.log("${customerCreditCardEnrollInfo}");
    console.log("${autoDebitAttachmentInfo}");
    if(undefinedCheck('${mobileAutoDebitDetail.atchFileGroupId}','number') > 0){
        atchFileGroupId = parseInt('${mobileAutoDebitDetail.atchFileGroupId}');
    }
    getRejectReasonCodeOption();
    fn_attachmentButtonRegister();

    loadGeneralInfoData();
    loadPaymentInfoData();
    loadStatusInfoData();
    loadAttachmentData();
    checkStatusForConditionalDisable();

	//Ledgers
	$('#btnLedger1').click(function() {
		Common.popupWin("frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
	});
	$('#btnLedger2').click(function() {
		Common.popupWin("frmLedger", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
	});
	//Ledgers

	$('#btnOrdDtlClose').click(function() {
	    $('#_divAutoDebitDetailPop').remove();
	});

	$('#btnAddThirdPartyCust').click(function() {
       Common.popupWin("searchForm",
           "/sales/customer/customerRegistPop.do", {
             width : "1200px",
             height : "630x"
       });
    });

	$('#btnThirdPartyCustSearch').click(function() {

        $('#thrdPartyId').val('');
        $('#thrdPartyType').text('');
        $('#thrdPartyName').text('');
        $('#txtThrdPartyNric').text('');

	     Common.popupDiv("/common/customerPop.do", {
	       callPrgm : "loadThirdPartyPopData"
	     }, null, true);
	});
});

function loadThirdPartyPopData(custData){
	if(custData != null || custData != ""){
        $('#thrdPartyId').val(custData.custId);
        $('#thrdPartyType').text(custData.codeName1);
        $('#thrdPartyName').text(custData.name);
        $('#txtThrdPartyNric').text(custData.nric);
	}
	else{
		 Common
         .alert('<spring:message code="sal.alert.msg.thirdPartyNotFoundmsg" />');
	}
}

function checkStatusForConditionalDisable(){
	var actionStatus = "${mobileAutoDebitDetail.stusCodeId}";
	if(actionStatus == "5" || actionStatus == "6"){
		$('#action').attr('disabled',true);
		$('#rejectReasonCodeList').attr('disabled',true);
		$('#remarks').attr('disabled',true);
		$('#btnSave').hide();
		$('.upload_btn').hide();
		$('.remove_btn').hide();
	}
}

function fn_attachmentButtonRegister(){
	 $('#cardImageFile').change(function(evt) {
         var file = evt.target.files[0];
         if(file == null) {
        	 if(myFileCaches[1] != null){
        		 delete myFileCaches[1];
        	 }
        	 if(cifId != '0'){
                 remove.push(cifId);
        	 }
         }else if(file.name != cifFileName) {
              myFileCaches[1] = {file:file};
              if(cifFileName != "") {
                  update.push(cifId);
              }
          }
     });

	 $('#otherFile1').change(function(evt) {
         var file = evt.target.files[0];
         if(file == null) {
        	 if(myFileCaches[2] != null){
        		 delete myFileCaches[2];
        	 }
        	 if(otherFile1Id != '0'){
                 remove.push(otherFile1Id);
        	 }
         }else if(file.name != otherFileName1) {
              myFileCaches[2] = {file:file};
              if(otherFileName1 != "") {
                  update.push(otherFile1Id);
              }
          }
     });

	 $('#otherFile2').change(function(evt) {
         var file = evt.target.files[0];
         if(file == null) {
        	 if(myFileCaches[3] != null){
        		 delete myFileCaches[3];
        	 }
        	 if(otherFile2Id != '0'){
                 remove.push(otherFile2Id);
        	 }
         }else if(file.name != otherFileName2) {
              myFileCaches[3] = {file:file};
              if(otherFileName2 != "") {
                  update.push(otherFile2Id);
              }
          }
     });

	 $('#otherFile3').change(function(evt) {
         var file = evt.target.files[0];
         if(file == null) {
        	 if(myFileCaches[4] != null){
        		 delete myFileCaches[4];
        	 }
        	 if(otherFile3Id != '0'){
                 remove.push(otherFile3Id);
        	 }
         }else if(file.name != otherFileName3) {
              myFileCaches[4] = {file:file};
              if(otherFileName3 != "") {
                  update.push(otherFile3Id);
              }
          }
     });

	 $('#otherFile4').change(function(evt) {
         var file = evt.target.files[0];
         if(file == null) {
        	 if(myFileCaches[5] != null){
        		 delete myFileCaches[5];
        	 }
        	 if(otherFile4Id != '0'){
                 remove.push(otherFile4Id);
        	 }
         }else if(file.name != otherFileName4) {
              myFileCaches[5] = {file:file};
              if(otherFileName4 != "") {
                  update.push(otherFile4Id);
              }
          }
     });
}

function saveDataValidation(){
	var action = $('#action').val();
	var rejectReasonCode = $('#rejectReasonCodeList').val();
	var remarks = $('#remarks').val();
	var cardImageFileAttachment = $('#cardImageFile').val();

	if(action == ""){
        Common.alert('Please select an action');
        return;
	}

	if(action == "6" && rejectReasonCode == ""){
        Common.alert('Reject Reason Code is compulsory for Rejected Action');
        return;
	}

	if(action == "6" && remarks == ""){
        Common.alert('Remarks is compulsory for Rejected Action');
        return;
	}

	if(cardImageFileAttachment == null || cardImageFileAttachment== ""){
        Common.alert('Card Image Attachment is required');
        return;
	}

	if(action =="5"){
		$("#rejectReasonCodeList option[value='']").attr("selected", true);
	}

	if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
		if(undefinedCheck($('#thrdPartyId').val()) == ""){
			Common.alert('Third Party Customer is required');
	        return;
		}
	}

	//doSave();
}

function doSave(){
	//update data
	var data = {
			statusCodeId : $('#action').val(),
			rejectReasonCode : $('#rejectReasonCodeList').val(),
			remarks : $('#remarks').val(),
			padId: "${mobileAutoDebitDetail.padId}"
	}
	//attachment data
	var formData = new FormData();
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
    formData.append("atchFileGroupId", atchFileGroupId);
    $.each(myFileCaches, function(n, v) {
        formData.append(n, v.file);
    });

	Common.ajaxFile("/payment/mobileautodebit/attachmentAutoDebitFileUpdate.do", formData, function(result) {
		if(result.code == 99){
            Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
        }
		else{
			Common.ajax("POST", "/payment/mobileautodebit/updateAction.do", data, function(result1) {
				console.log("result1 :: " + result1);
				 if(result1.code == 00){
					 fn_close();
				 }
				 else{
                     Common.alert(result1.message);
				 }
			});
		}
	});
}

function fn_close() {
    $("#popup_wrap").remove();
    $('#_listSearchBtn').click();
}

function getRejectReasonCodeOption(){
    doGetComboData('/payment/mobileautodebit/selectRejectReasonCodeOption.do', '', '', 'rejectReasonCodeList', 'S', 'setRejectReasonCode');
}

function setRejectReasonCode(){
	var failReasonCode = "${mobileAutoDebitDetail.failReasonCode}";
	if(failReasonCode != null){
		$("#rejectReasonCodeList option[value='"+ failReasonCode +"']").attr("selected", true);
	}
}

function formatDate(date){
	var year = date.getFullYear();
	var month = (1 + date.getMonth()).toString().padStart(2, "0");
	var day = date.getDate().toString().padStart(2, "0");
	return month + "/" + day + "/" + year;
}

function loadGeneralInfoData(){
	$('#preAutoDebitNo').val("${mobileAutoDebitDetail.padNo}");
	$('#padKeyInDate').val(formatDate(new Date("${mobileAutoDebitDetail.crtDt}")));
	$('#orderNumber').val("${mobileAutoDebitDetail.salesOrdNo}");
	$('#orderDate').val(formatDate(new Date("${mobileAutoDebitDetail.salesDt}")));
	$('#custType').val("${mobileAutoDebitDetail.custType}");
	$('#productName').val("${mobileAutoDebitDetail.stkDesc}");
	$('#customerName').val("${mobileAutoDebitDetail.name}");
	$('#monthlyRentalFee').val("${mobileAutoDebitDetail.mthRentAmt}");
	$('#nricCompanyNumber').val("${mobileAutoDebitDetail.nric}");
	$('#rentalStatus').val("${mobileAutoDebitDetail.rentalStatus}");
}

function loadPaymentInfoData(){
	if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
		$('#thirdPartyPayCheckBox').prop('checked', true);
	}
	$('#cardNumber').val("${customerCreditCardEnrollInfo.custOriCrcNo}");
	$('#visaMasterType').val("${customerCreditCardEnrollInfo.cardProvider}");
	$('#custCrcName').val("${customerCreditCardEnrollInfo.custCrcOwner}");
	$('#cardExpiryDate').val("${customerCreditCardEnrollInfo.custCrcExpr}");
	$('#issueBank').val("${customerCreditCardEnrollInfo.issueBank}");
	$('#custCardType').val("${customerCreditCardEnrollInfo.cardType}");

	checkThirdPartyDisplayCondition();
}

function checkThirdPartyDisplayCondition() {
	if("${mobileAutoDebitDetail.isThirdPartyPayment}" == "1"){
		$('.thirdPartySection').show();
	}
	else{
		$('.thirdPartySection').hide();
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
};

function loadAttachmentData(){
}

function loadStatusInfoData(){
	var actionStatus = "${mobileAutoDebitDetail.stusCodeId}";
	var remarks = "${mobileAutoDebitDetail.remarks}";
	if(actionStatus != null){
		$("#action option[value='"+ actionStatus +"']").attr("selected", true);
	}
	if(remarks != null){
		$('#remarks').val(remarks);
	}
}

//Attachments
function fn_removeFile(name){
    if(name == "CIF") {
         $("#cardImageFile").val("");
         $(".input_text[id='cardImageFileTxt']").val("");
         $('#cardImageFile').change();
    }else if(name == "OTH1") {
        $("#otherFile1").val("");
        $(".input_text[id='otherFileTxt1']").val("");
        $('#otherFile1').change();
    }else if(name == "OTH2") {
        $("#otherFile2").val("");
        $(".input_text[id='otherFileTxt2']").val("");
        $('#otherFile2').change();
    }else if(name == "OTH3") {
        $("#otherFile3").val("");
        $(".input_text[id='otherFileTxt3']").val("");
        $('#otherFile3').change();
    }else if(name == "OTH4") {
        $("#otherFile4").val("");
        $(".input_text[id='otherFileTxt4']").val("");
        $('#otherFile4').change();
    }
}
//Attachments
</script>
<body>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Auto Debit Approval</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a id="btnLedger1" href="#"><spring:message code="sal.btn.ledger" />(1)</a></p></li>
			<li><p class="btn_blue2"><a id="btnLedger2" href="#"><spring:message code="sal.btn.ledger" />(2)</a></p></li>
			<li><p class="btn_blue2"><a id="btnAutoDebitDetailClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<!-- pop_body start -->
	<section class="pop_body">
		<form id="frmLedger" name="frmLedger" action="#" method="post">
		    <input id="ordId" name="ordId" type="hidden" value="${mobileAutoDebitDetail.salesOrdId}"/>
		</form>

		<section>
			<table class="type1"><!-- table start -->
				<colgroup>
				    <col style="width:180px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Pre Auto Debit No</th>
						<td><input type="text" id="preAutoDebitNo" class="readonly w100p" readonly /></td>
						<th scope="row">PAD Key-in Date</th>
						<td><input type="text" id="padKeyInDate" class="readonly w100p" readonly /></td>
					</tr>
					<tr>
						<th scope="row">Order No</th>
						<td><input type="text" id="orderNumber" class="readonly w100p" readonly /></td>
						<th scope="row">Order Date</th>
						<td><input type="text" id="orderDate" class="readonly w100p" readonly /></td>
					</tr>
					<tr>
						<th scope="row">Customer Type</th>
						<td><input type="text" id="custType" class="readonly w100p" readonly /></td>
						<th scope="row">Product</th>
						<td><input type="text" id="productName" class="readonly w100p" readonly /></td>
					</tr>
					<tr>
						<th scope="row">Customer Name</th>
						<td><input type="text" id="customerName" class="readonly w100p" readonly /></td>
						<th scope="row">Final Rental Fee</th>
						<td><input type="text" id="monthlyRentalFee" class="readonly w100p" readonly /></td>
					</tr>
					<tr>
						<th scope="row">NRIC/Company No</th>
						<td><input type="text" id="nricCompanyNumber" class="readonly w100p" readonly /></td>
						<th scope="row">Rental Status</th>
						<td><input type="text" id="rentalStatus" class="readonly w100p" readonly /></td>
					</tr>
				</tbody>
			</table>
		</section>

		<!-- tab -->
		<section class="tap_wrap">
			<ul class="tap_type1 num4">
				<li><a id="aTabPI" href="#" class="on">Payment Info</a></li>
				<li><a id="aTabAttach" href="#" class="">Attachment</a></li>
				<li><a id="aTabUS" href="#" class="">Update Status</a></li>
			</ul>
			<!-- Payment Info Tab -->
			<%@ include file="/WEB-INF/jsp/payment/mobileautodebit/autoDebitPaymentInfoTabPop.jsp" %>
			<!-- Attachment Info Tab -->
			<%@ include file="/WEB-INF/jsp/payment/mobileautodebit/autoDebitAttachmentTabPop.jsp" %>
			<!-- Status Info Tab -->
			<%@ include file="/WEB-INF/jsp/payment/mobileautodebit/autoDebitUpdateStatusTabPop.jsp" %>
		</section>

		<ul class="center_btns mt20">
		    <li><p class="btn_blue2 big"><a id="btnSave" href="#" onclick="saveDataValidation()">Save</a></p></li>
		</ul>
	</section>
	<!-- pop_body end -->
</div>
</body>