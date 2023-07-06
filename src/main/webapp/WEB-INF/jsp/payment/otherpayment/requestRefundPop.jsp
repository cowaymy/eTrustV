<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="/resources/js/util.js"></script>

<script type="text/javaScript">
var myRequestRefundFinalGridID;
//var myGridData = $.parseJSON('${resultList}');
var myGridData;
var update = new Array();
var remove = new Array();
var atchFileGroupId = 0;
var cifId = 0;
var cifFileName = "";
var requestType = "REF";
var myFileCaches = {};
var oldAmt = 0;

//Grid Properties 설정
var gridPros = {
		// 편집 가능 여부 (기본값 : false)
		editable : false,
		// 상태 칼럼 사용
		showStateColumn : false,
		// 기본 헤더 높이 지정
		headerHeight : 35,

		softRemoveRowMode:false

};

//Set AUIGrid column: targetFinalBillGridID
var requestRefundColumnLayout = [
    {dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGrpNo'/>",width : 100 , editable : false, visible : false},
    {dataField : "payItmModeId",headerText : "<spring:message code='pay.head.payTypeId'/>",width : 240 , editable : false, visible : false},
    {dataField : "appType",headerText : "<spring:message code='pay.head.appType'/>",width : 130 , editable : false},
    {dataField : "payItmModeNm",headerText : "<spring:message code='pay.head.payType'/>",width : 110 , editable : false},
    {dataField : "custId",headerText : "<spring:message code='pay.head.customerId'/>",width : 140 , editable : false},
    {dataField : "salesOrdNo",headerText : "<spring:message code='pay.head.salesOrder'/>", editable : false},
    {dataField : "totAmt",headerText : "<spring:message code='pay.head.amount'/>", width : 120 ,editable : false, dataType:"numeric", formatString : "#,##0.00" },
    {dataField : "payItmRefDt",headerText : "<spring:message code='pay.head.transDate'/>",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
    {dataField : "orNo",headerText : "<spring:message code='pay.head.worNo'/>",width : 150,editable : false},
    {dataField : "brnchId",headerText : "<spring:message code='pay.head.keyInBranch'/>",width : 100,editable : false, visible : false},
    {dataField : "crcStateMappingId",headerText : "<spring:message code='pay.head.crcState'/>",width : 110,editable : false, visible : false},
    {dataField : "crcStateMappingDt",headerText : "<spring:message code='pay.head.crcMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
    {dataField : "bankStateMappingId",headerText : "<spring:message code='pay.head.bankStateId'/>",width : 110,editable : false, visible : false},
    {dataField : "bankStateMappingDt",headerText : "<spring:message code='pay.head.bankMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
    {dataField : "revStusId",headerText : "<spring:message code='pay.head.reverseStatusId'/>",width : 110,editable : false, visible : false},
    {dataField : "revStusNm",headerText : "<spring:message code='pay.head.reverseStatus'/>",width : 110,editable : false, visible : false},
    {dataField : "revDt",headerText : "<spring:message code='pay.head.reverseDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false}
];

$(document).ready(function(){
	doGetComboCodeId('/common/selectReasonCodeId.do', {typeId : 7277}, ''   , 'newReason' , 'S', '');
	CommonCombo.make("refundMode", "/payment/selectCodeList.do", null, "", {id: "code", name: "codeName", type:"S"});
    CommonCombo.make("issueBank", "/payment/selectBankCode.do", null, "", {id: "code", name: "name", type:"S"});
    $("#requestType").val(requestType);

    fn_attachmentButtonRegister();
 	myRequestRefundFinalGridID= GridCommon.createAUIGrid("grid_request_refund_wrap", requestRefundColumnLayout, null, gridPros);
 	searchRefundList();
 	/*	AUIGrid.setGridData(myRequestRefundFinalGridID, myGridData); */

});

// ajax list 조회.
function searchRefundList(){
	console.log($("#groupSeq").val());
	console.log($("#payId").val());
	console.log($("#appTypeId").val());

	Common.ajax("POST","/payment/selectRefundOldData.do",$("#_refundSearchForm").serializeJSON(), function(result){
		$("#oldOrdNo").val(result.salesOrdNo);
		$("#oldCustNm").val(result.custNm);
		$("#oldAmt").val(result.totAmt);
		$("#oldOrNo").val(result.orNo);
		AUIGrid.setGridData(myRequestRefundFinalGridID, result);
		calculateOldAmt();

		//recalculateTotalAmt();
	});
}

//Reason Code onChange
function fn_reasonOnChange(selectedReason) {
	var reasonCd = selectedReason.value;

	if(reasonCd != null && reasonCd != 0 && (reasonCd == "3524" || reasonCd == "3523" || reasonCd == "3522" || reasonCd == "3521")) {
		$("#oldAmt").removeAttr("readonly");

	}else{
		$("#oldAmt").attr("readonly", "readonly");
		calculateOldAmt();
	}
}

//Display Section onChange
function fn_displaySection(selectedRefMode) {
	var refMode = selectedRefMode.value;

	$("#crcSection").attr("hidden", "hidden");
	$("#onlineSection").attr("hidden", "hidden");

	if(refMode != null && refMode != 0 && (refMode == "107")) {
		$("#crcSection").removeAttr("hidden");

	}else if(refMode != null && refMode != 0 && (refMode == "108"))  {
		$("#onlineSection").removeAttr("hidden");
	}
}

//clear 처리
function fn_RefundClear(){
	//form.reset 함수는 쓰지 않는다. groupSeq 때문임.
	$("#newRemark").val('');
	$("#newReason").val('');
	$("#newCustNm").val('');
	$("#newOrdNo").val('');
	AUIGrid.clearGridData(myRequestRefundFinalGridID);
}

function validateSave(refMode, reasonCd){
	var validFlg = true;

	if(reasonCd != "3519" && reasonCd != "3520") { //reasonCd that is not allow for partial refund
		if( Number($("#oldAmt").val()) <= 0 ){
	        Common.alert("<spring:message code='pay.alert.totalAmtZero'/>");
	        return validFlg = false;
	    }
		else if( Number($("#oldAmt").val() > oldAmt)){
			Common.alert("Key-in Amount cannot be greater than Total Amount. ");
			return validFlg = false;
		}
	}

	if(refMode != null && refMode != "" && refMode != "0" && refMode == "107"){ //CreditCard Mode
		if($("#keyInCardNo1").val() == "" || $("#keyInCardNo2").val() == "" || $("#keyInCardNo3").val() == "" || $("#keyInCardNo4").val() == ""){
			Common.alert("Credit Card No. incomplete. Please enter a valid credit card number. ");
			return validFlg = false;
		}
        if($("#apprNo").val() == "" || $("#apprNo").val() == null){
        	Common.alert("Please key in Appr No.");
            return validFlg = false;
        }
	}else if(refMode != null && refMode != "" && refMode != "0" && refMode == "108"){
		if($("#bankAccNo").val() == "" || $("#bankAccNo").val() == null){
			Common.alert("Please key in Bank Account No.");
            return validFlg = false;
		}
		if($("#beneficiaryName").val() == "" || $("#beneficiaryName").val() == null){
			Common.alert("Please key in Beneficiary Name.");
            return validFlg = false;
		}
	}

	if ($("#newReason").val() == null || $("#newReason").val() == "" || $("#newReason option:selected").index() <= 0) {
        Common.alert("<spring:message code='pay.alert.noReasonSelected'/>");
        return validFlg = false;
    }
    if(refMode == "" || refMode == null){
        Common.alert("Please select a Refund Mode.");
        return validFlg = false;
    }
    if($("#issueBank").val() == "" || $("#issueBank").val() == null){
        Common.alert("Please select an Issue Bank.");
        return validFlg = false;
    }
    if($("#newRemark").val() == null || $("#newRemark").val() == "" || FormUtil.byteLength($("#newRemark").val()) > 3000 ){
        Common.alert("<spring:message code='pay.alert.inputRemark3000Char'/>");
        return validFlg = false;
    }
    if($("#newAttach").val() == "" || FormUtil.byteLength($("#newAttach").val().trim()) == null){
        Common.alert("Attachement cannot be empty.");
        return validFlg = false;
    }
    if($("#newAttach").val() == "" || FormUtil.byteLength($("#newAttach").val().trim()) == null){
        Common.alert("Attachement cannot be empty.");
        return validFlg = false;
    }
    else {
    	var str = $("#newAttach").val().split(".");
        if(str[1] != "zip"){
        	Common.alert("Please attach zip file only.");
        	return validFlg = false;
        }
    }
    return validFlg;
}

//저장처리
function fn_RefundRequest(){
	console.log("testing");

	if(validateSave($("#refundMode").val(), $("#newReason").val())) {
		Common.confirm("<spring:message code='pay.alert.wantToReqRefund'/>",function (){

	        //param data array
	        var data = {};

	        //var obj = $("#_refundSearchForm").serializeJSON();                           //form data
	        var gridList = AUIGrid.getGridData(myRequestRefundFinalGridID);       //grid data
	        var formList = $("#_refundSearchForm").serializeArray();                  //form data

	         //array에 담기
	         if(gridList.length > 0) {
	            data.all = gridList;
	            data.form = formList;
	        }  else {
	        	data.form = [];
	            Common.alert("<spring:message code='pay.alert.noPaymentData'/>");
	            return;
	        }

	         console.log(gridList);
	         console.log(formList);
	         console.log(data);

	         /* var formData = new FormData();
	         formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
	         formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
	         formData.append("atchFileGroupId", atchFileGroupId);
	         $.each(myFileCaches, function(n, v) {
	             formData.append(n, v.file);
	         }); */

	         Common.popupDiv('/payment/requestApprovalLineCreatePop.do', data, null , true ,'_requestApprovalLineCreatePop');

	    });
	}
}

function calculateOldAmt(){
	var rowCnt = AUIGrid.getRowCount(myRequestRefundFinalGridID);
	var totalAmt = 0;

	if(rowCnt > 0){

		for(var i = 0; i < rowCnt; i++){
			totalAmt += AUIGrid.getCellValue(myRequestRefundFinalGridID, i ,"totAmt");
		}
	}

	$("#oldAmt").val(totalAmt.toFixed(2));
	oldAmt = $("#oldAmt").val();
	// $("#newAmt").val(totalAmt.toFixed(2));

}

function fn_removeFile(name){
	$("#newAttach").val("");
    $('#newAttach').change();
}

function isNumberKey(evt){
	var charCode = (evt.which) ? evt.which : evt.keyCode;
	if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
		return false;
	}

	//validateDecimal();
	return true;
}

function validateDecimal(){
	var totalAmt = $("#oldAmt").val();
	totalAmt = Number.parseFloat(totalAmt);
	$("#oldAmt").val(AUIGrid.formatNumber(Number(totalAmt), "#,##0.00"));
	/* var a=Number.parseFloat($("#budget_project").val()); // from input field
	var b=Number.parseFloat(html); // from ajax
	var c=a-b;
	$("#result").html(c.toFixed(2)); // put to id='result' (div or others) */
}

//When entering the card number, select the card brand according to the number
function fn_changeCardNo1(){

  var cardNo1Size = $("#keyInCardNo1").val().length;

  if(cardNo1Size >= 4){
    var cardNo1st1Val = $("#keyInCardNo1").val().substr(0,1);
        var cardNo1st2Val = $("#keyInCardNo1").val().substr(0,2);
        var cardNo1st4Val = $("#keyInCardNo1").val().substr(0,4);

        if(cardNo1st1Val == 4){
          $("#keyInCrcType").val(112);
        }

        if((cardNo1st2Val >= 51 && cardNo1st2Val <= 55) || (cardNo1st4Val >= 2221 && cardNo1st4Val <= 2720)){
          $("#keyInCrcType").val(111);
        }
  }
}

function nextTab (a, e) {
    if (e.keyCode!=8) {
      if (a.value.length == a.size) {
        var no = parseInt(a.name.substring(a.name.length - 1, a.name.length)) + 1;;
        var name = a.name.substring(0, a.name.length - 1);
        $("#" + a.name.substring(0, a.name.length - 1) + no).focus();
      }
    }
  }

function fn_attachmentButtonRegister(){
    $('#newAttach').change(function(evt) {
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
}

function closeApproveLine(){
	$("#_requestApprovalLineCreatePop").remove();
    $("#_requestRefundPop").remove();
    searchList();
}
</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Request Refund</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
		<!-- search_table start -->
		<section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_request_refund_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>

		<section class="search_table">
 			<form name="_refundSearchForm" id="_refundSearchForm"  method="post">
				<input id="groupSeq" name="groupSeq" value="${groupSeq}" type="hidden" />
				<input id="payId" name="payId" value="${payId}" type="hidden" />
				<input id="appTypeId" name="appTypeId" value="${appTypeId}" type="hidden" />
				<input id="requestType" name="requestType" type="hidden" />
				<input id="atchFileId" name="atchFileId" type="hidden" />
				<input id="fileGroupKey" name="fileGroupKey" type="hidden" />

				<!-- title_line start -->
				<aside class="title_line">
					<h2 class="pt0">Refund Request Details</h2>
				</aside>
				<!-- title_line end -->

				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:140px" />
                        <col style="width:*" />
                        <col style="width:140px" />
                        <col style="width:*" />
					</colgroup>
					<tbody>
                        <tr>
                            <th scope="row">Reason<span class="must">*</span></th>
                            <td colspan="3">
                                <select id="newReason" name="newReason" class="w100p" onchange="fn_reasonOnChange(this)"></select>
                            </td>
                            <th scope="row">Total Amount<span class="must">*</span></th>
                            <td colspan="3">
                                 <input type="text" name="oldAmt" id="oldAmt" title="" placeholder="" class="w100p"  readonly  onkeypress="return isNumberKey(event)" onblur="validateDecimal()"/>
                            </td>
                        </tr>
						<tr>
							<th scope="row">Refund Mode<span class="must">*</span></th>
                            <td colspan="3">
                                <select id="refundMode" name="refundMode" class="w100p" onchange="fn_displaySection(this)">></select>
                            </td>
							<th scope="row">Issue Bank<span class="must">*</span></th>
                            <td colspan="3">
                                <select id="issueBank" name="issueBank" class="w100p"></select>
                            </td>
						</tr>
						<tr id="onlineSection" hidden>
							<th scope="row">Bank Account No.<span class="must">*</span></th>
							<td colspan="3">
								 <input type="text" name="bankAccNo" id="bankAccNo" title="" placeholder="" class="w100p"   />
							</td>
							<th scope="row">Beneficiary Name<span class="must">*</span></th>
							<td colspan="3">
								 <input type="text" name="beneficiaryName" id="beneficiaryName" title="" placeholder="" class="w100p"/>
							</td>
						</tr>
						<tr id="crcSection" hidden>
							<th scope="row">Card No.<span class="must">*</span></th>
							<!-- <td colspan="3">
								 <input type="text" name="cardNo" id="cardNo" title="" placeholder="" class="w100p"/>
							</td> -->
				            <td style="width:100%"colspan="3">
				              <p class="short"><input type="text" id="keyInCardNo1" name="keyInCardNo1" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);' onChange="javascript:fn_changeCardNo1();" /></p> <span>-</span>
				              <p class="short"><input type="text" id="keyInCardNo2" name="keyInCardNo2" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'/></p> <span>-</span>
				              <p class="short"><input type="text" id="keyInCardNo3" name="keyInCardNo3" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'/></p> <span>-</span>
				              <p class="short"><input type="text" id="keyInCardNo4" name="keyInCardNo4" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
				            </td>
							<th scope="row">Appr No.<span class="must">*</span></th>
							<td colspan="3">
								 <input type="text" name="apprNo" id="apprNo" title="" placeholder="" class="w100p"/>
							</td>
						</tr>
						<tr>
                            <th scope="row">Remark<span class="must">*</span></th>
                            <td colspan="7">
                                <textarea id="newRemark" name="newRemark"  cols="15" rows="2" placeholder=""></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment<span class="must">*</span></th>
                            <td colspan="7" id="newAttachRef">
                                <div class="auto_file2">
                                    <input type="file" title="file add" id="newAttach" accept=".zip" /> <!-- accept="application/pdf" -->
                                <label style="width:100%">
                                <input type='text' class='input_text' readonly='readonly' style='width:300px'/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                                <span class='label_text'><a href='#' onclick='fn_removeFile()'>Remove</a></span>
                                </label>
                                </div>
                            </td>
                        </tr>
						</tbody>
				  </table>
			</form>
		</section>
		<!-- search_result start -->
		<section class="search_result" style="display:none">
			<!-- grid_wrap start -->
			<article id="grid_request_refund_wrap" class="grid_wrap"></article>
			<!-- grid_wrap end -->
		</section>
		<ul class="center_btns">
			<li><p class="btn_blue"><a href="javascript:fn_RefundRequest();"><spring:message code='pay.btn.request'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_RefundClear();"><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>
	</section>
</div>