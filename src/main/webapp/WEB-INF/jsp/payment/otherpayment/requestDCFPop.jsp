<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var requestType = "DCF";

var myRequestDCFGridID;
var myRequestNewDCFGridID;

var myFileCaches = {};
var update = new Array();
var remove = new Array();
var atchFileGroupId = 0;
var attachmentFileId = 0;
var attachmentFileName = "";

//Grid Properties 설정
	var gridPros = {
	        // 편집 가능 여부 (기본값 : false)
	        editable : false,
	        // 상태 칼럼 사용
	        showStateColumn : false,
	        // 기본 헤더 높이 지정
	        headerHeight : 35,

     softRemoveRowMode:false,

     showRowNumColumn : false
};

// AUIGrid 칼럼 설정
var requestDcfColumnLayout = [
	 {dataField : "seq",
       headerText : 'No.',
	   dataType: "numeric",
	   expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
	          // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
	          return rowIndex + 1;
	      }
	 },
 	{dataField : "groupSeq",headerText : "<spring:message code='pay.head.paymentGrpNo'/>",width : 100 , editable : false, visible : false},
	{dataField : "payItmModeId",headerText : "<spring:message code='pay.head.payTypeId'/>",width : 240 , editable : false, visible : false},
	{dataField : "appType",headerText : "<spring:message code='pay.head.appType'/>",width : 130 , editable : false},
	{dataField : "payItmModeNm",headerText : "<spring:message code='pay.head.payType'/>",width : 110 , editable : false},
	{dataField : "custId",headerText : "<spring:message code='pay.head.customerId'/>",width : 140 , editable : false},
	{dataField : "salesOrdNo",headerText : "<spring:message code='pay.head.salesOrder'/>", editable : false},
	{dataField : "totAmt",headerText : "<spring:message code='pay.head.amount'/>", width : 120 ,editable : false, dataType:"numeric", formatString : "#,##0.00" },
	{dataField : "payItmRefDt",headerText : "<spring:message code='pay.head.transDate'/>",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
	{dataField : "orNo",headerText : "<spring:message code='pay.head.worNo'/>",width : 150,editable : false},
	{dataField : "salesOrdId",headerText : "Sales Order Id",width : 150,editable : false, visible: false},
 	{dataField : "brnchId",headerText : "<spring:message code='pay.head.keyInBranch'/>",width : 100,editable : false, visible : false},
 	{dataField : "crcStateMappingId",headerText : "<spring:message code='pay.head.crcState'/>",width : 110,editable : false, visible : false},
 	{dataField : "crcStateMappingDt",headerText : "<spring:message code='pay.head.crcMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
 	{dataField : "bankStateMappingId",headerText : "<spring:message code='pay.head.bankStateId'/>",width : 110,editable : false, visible : false},
 	{dataField : "bankStateMappingDt",headerText : "<spring:message code='pay.head.bankMappingDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
 	{dataField : "revStusId",headerText : "<spring:message code='pay.head.reverseStatusId'/>",width : 110,editable : false, visible : false},
 	{dataField : "ftStusId",headerText : "Fund transfer Status Id",width : 110,editable : false, visible : false},
 	{dataField : "revStusNm",headerText : "<spring:message code='pay.head.reverseStatus'/>",width : 110,editable : false, visible : false},
 	{dataField : "revDt",headerText : "<spring:message code='pay.head.reverseDate'/>",width : 110,editable : false, dataType:"date",formatString:"dd/mm/yyyy", visible : false},
 	{dataField : "payId",headerText : "<spring:message code='pay.head.PID'/>",width : 110,editable : false, visible : false},
 	{dataField : "payData",headerText : "Pay Data",width : 110,editable : false, visible : false},
 	{dataField : "orType",headerText : "OR Type",width : 110,editable : false, visible : false},
 	{dataField : "bankAcc",headerText : "Bank Acc Code",width : 110,editable : false, visible : false}
];

var requestNewDcfColumnLayout = [
	{ dataField : "seq",
		headerText : 'No.',
		dataType: "numeric",
		expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
			// expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
			return rowIndex + 1;
	    }
	},
	{ dataField:"procSeq" ,headerText:"Process Seq" ,editable : false , width : 120 , visible : false },
	{ dataField:"appType" ,headerText:"AppType" ,editable : false , width : 120 , visible : false },
	{ dataField:"advMonth" ,headerText:"AdvanceMonth" ,editable : false , width : 120 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	{ dataField:"billGrpId" ,headerText:"Bill Group ID" ,editable : false , width : 120, visible : false},
	{ dataField:"billId" ,headerText:"Bill ID" ,editable : false , width : 100, visible : false },
	{ dataField:"ordId" ,headerText:"Order ID" ,editable : false , width : 100  , visible : false },
	{ dataField:"mstRpf" ,headerText:"Master RPF" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	{ dataField:"mstRpfPaid" ,headerText:"Master RPF Paid" ,editable : false , width : 100  , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	{ dataField:"billNo" ,headerText:"Bill No" ,editable : false , width : 150 , visible : false},
	{ dataField:"ordNo" ,headerText:"Order No" ,editable : false , width : 100 },
	{ dataField:"billTypeId" ,headerText:"Bill TypeID" ,editable : false , width : 100 , visible : false },
	{ dataField:"billTypeNm" ,headerText:"Bill Type" ,editable : false , width : 180 },
	{ dataField:"installment" ,headerText:"Installment" ,editable : false , width : 100, visible : false },
	{ dataField:"billAmt" ,headerText:"Amount" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00", visible : false},
	{ dataField:"paidAmt" ,headerText:"Paid" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00", visible : false},
	{ dataField:"targetAmt" ,headerText:"Target<br>Amount" ,editable : true , dataType : "numeric", formatString : "#,##0.00"},
	{ dataField:"billDt" ,headerText:"Bill Date" ,editable : false , width : 100 , visible : false},
	{ dataField:"assignAmt" ,headerText:"assignAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	{ dataField:"billStatus" ,headerText:"billStatus" ,editable : false , width : 100 , visible : false },
	{ dataField:"custNm" ,headerText:"custNm" ,editable : false , width : 300, visible : false},
	{ dataField:"srvcContractID" ,headerText:"SrvcContractID" ,editable : false , width : 100 , visible : false },
	{ dataField:"billAsId" ,headerText:"Bill AS Id" ,editable : false , width : 150 , visible : false },
	{ dataField:"discountAmt" ,headerText:"discountAmt" ,editable : false , width : 100 , dataType : "numeric", formatString : "#,##0.00" , visible : false },
	{ dataField:"srvMemId" ,headerText:"Service Membership Id" ,editable : false , width : 150 , visible : false },
    { dataField:"refDtlsJPayRef" ,headerText:"Ref Details/JomPay Ref" ,editable : false , width : 150 },
    { dataField:"trNo" ,headerText:"TR No" ,editable : true , width : 150 },
    { dataField:"trDt" ,headerText:"TR Issue Date" ,editable : false , width : 150 },
    { dataField:"collectorCode" ,headerText:"Collector Code" ,editable : false , width : 250 },
    { dataField:"collectorId" ,headerText:"Collector Id" ,editable : false , width : 150 ,visible : false},
    { dataField:"allowComm" ,headerText:"Commission" ,editable : false , width : 150},
	{ dataField : "delBtn",headerText : "<spring:message code='pay.head.delete'/>", editable : true,
		 renderer : {
		        type : "ButtonRenderer",
		        labelText : "<spring:message code='pay.btn.del'/>",
		        onclick : function(rowIndex, columnIndex, value, item) {
		            AUIGrid.removeRow(myRequestNewDCFGridID, rowIndex);
		            setTargetInfo();
	        }
		  }
	}
];

$(document).ready(function(){
	/* fetch("/payment/checkDCFPopValid.do?groupSeq=${groupSeq}")
	.then(resp => resp.json())
	.then(d => {
		if (d.success) {
			doGetCombo('/common/selectCodeList.do', '392' , ''   , 'reason' , 'S', '');

			myRequestDCFGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);

			searchDCFList();
		} else {
			Common.alert(d.message, () => {
				$("#popup_wrap .pop_header .right_opt .btn_blue2 a").click()
			});
		}
	}) */

	doGetCombo('/common/selectCodeList.do', '392' , '', 'reason' , 'S', '');
    doGetCombo('/common/selectCodeList.do', '36','', 'payType', 'S', '');
    doGetCombo('/common/getAccountList.do', 'CASH','', 'cashBankAcc', 'S', '');
    doGetCombo('/common/getAccountList.do', 'CHQ','', 'chequeBankAcc', 'S', '' );
    doGetCombo('/common/getAccountList.do', 'ONLINE','', 'onlineBankAcc', 'S', '' );;
    doGetCombo('/common/selectCodeList.do', '115','', 'creditCardType', 'S', '');
    doGetCombo('/common/selectCodeList.do', '130' , ''   ,'creditCardMode', 'S' , ''); // KEYIN CARD MODE
    doGetCombo('/common/selectCodeList.do', '21' , '', 'creditCardBrand' , 'S', ''); // KEYIN CRC TYPE

    myRequestDCFGridID = GridCommon.createAUIGrid("grid_request_dcf_wrap", requestDcfColumnLayout,null,gridPros);
    myRequestNewDCFGridID = GridCommon.createAUIGrid("grid_request_new_dcf_wrap", requestNewDcfColumnLayout,null,gridPros);

    searchDCFList();
    $("input[name='rekeyStus']:radio[value='0']").prop('checked', true);
    $("#newOrderInfoSection").hide();

    fn_payTypeChange();

    //Check rekey in status radio button
    $("input[name='rekeyStus']").click(function(){
         var radioValue = $("input[name='rekeyStus']:checked").val();
         if(radioValue == "1"){
             $("#newOrderInfoSection").show();
         }else {
             $("#newOrderInfoSection").hide();

             $("#cashPayInfoForm")[0].reset();
             $("#chequePayInfoForm")[0].reset();
             $("#onlinePayInfoForm")[0].reset();
             $("#creditPayInfoForm")[0].reset();
         }
    });

    fn_attachmentButtonRegister();

    $('#cashTrxId').blur(function() {
        if ($('#cashTrxId').val() != null && $("#cashTrxId").val() != "") {
            fn_checkkTrxIdMapping($('#cashTrxId').val(), $('#cashTotalAmtTxt').val());
        }
    });

    $('#chequeTrxId').blur(function() {
        if ($('#chequeTrxId').val() != null && $("#chequeTrxId").val() != "") {
            fn_checkkTrxIdMapping($('#chequeTrxId').val(), $('#chequeTotalAmtTxt').val());
        }
    });

    $('#onlineTrxId').blur(function() {
        if ($('#onlineTrxId').val() != null && $("#onlineTrxId").val() != "") {
            fn_checkkTrxIdMapping($('#onlineTrxId').val(), $('#onlineTotalAmtTxt').val());
        }
    });

    $("#onlineBankChgAmt").blur(function(){
	     //BankCharge Amount는 Billing 금액의 5%를 초과할수 없다
	     var bcAmt4Limit = 0;
         var payAmt4Limit = 0;
         var bcLimit = 0;

         if(!FormUtil.isEmpty($("#onlineBankChgAmt").val())) {
             bcAmt4Limit = Number($("#onlineBankChgAmt").val());
             payAmt4Limit = Number($("#onlineTotalAmtTxt").val());

             bcAmt4Limit = Number($.number(bcAmt4Limit,2,'.',''));
             payAmt4Limit = Number($.number(payAmt4Limit,2,'.',''));
             bcLimit = Number($.number(payAmt4Limit * 0.05,2,'.',''));

             if (bcLimit < bcAmt4Limit) {
                 Common.alert("Bank Charge Amount can not exceed 5% of Amount.");
                 return;

             }else{
            	 var tot = payAmt4Limit - bcAmt4Limit;
            	 $("#onlineTotalAmtTxt").val(tot.toFixed(2));
             }

         }else{
        	 $("#onlineTotalAmtTxt").val($("#newTotalAmtTxt").val());
         }
    });

});

// ajax list 조회.
function searchDCFList(){
	Common.ajax("POST","/payment/selectPaymentListByGroupSeq.do",$("#_dcfSearchForm").serializeJSON(), function(result){
		AUIGrid.setGridData(myRequestDCFGridID, result);
		recalculateDCFTotalAmt();
	});
}

//clear 처리
function fn_DCFClear(){
	//form.reset 함수는 쓰지 않는다. groupSeq 때문임.
	$("#reason").val('');
	$("#remark").val('');
	fn_removeFile("FILE");

	$("input[name='rekeyStus']").attr('checked',false);
	$("input[name='rekeyStus']:radio[value='0']").prop('checked', true);
    $("#newOrderInfoSection").hide();

	$("#ordNo").val('');
    $("#newTotalAmtTxt").val('');

	AUIGrid.clearGridData(myRequestNewDCFGridID);

	$("#payType").val("");

	$("#paymentInfoSection").hide();
	$("#cashPayInfoForm")[0].reset();
	$("#chequePayInfoForm")[0].reset();
	$("#onlinePayInfoForm")[0].reset();
	$("#creditPayInfoForm")[0].reset();
}

//Amount 계산
function recalculateDCFTotalAmt(){
    var rowCnt = AUIGrid.getRowCount(myRequestDCFGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        for(var i = 0; i < rowCnt; i++){
            totalAmt += AUIGrid.getCellValue(myRequestDCFGridID, i ,"totAmt");
        }
    }

	$("#oldTotalAmt").val(totalAmt);
    $("#oldTotalAmtTxt").val($.number(totalAmt,2));
}

//Search Order 팝업
function fn_requestDCFOrderSearchPop(){
    Common.popupDiv("/payment/requestDCFOrderSearchPop.do", {callPrgm : "RENTAL_PAYMENT", indicator : "SearchOrder"}, null, true, '_newOrderForDCFPop');
}

function fn_payTypeChange(){
	$("#cashPayInfoForm")[0].reset();
    $("#chequePayInfoForm")[0].reset();
    $("#onlinePayInfoForm")[0].reset();
    $("#creditPayInfoForm")[0].reset();

    $("#paymentInfoSection").show();
    $("#cashPayInfo").hide();
    $("#chequePayInfo").hide();
    $("#onlinePayInfo").hide();
    $("#creditPayInfo").hide();

    //우선 BANK_ID 528 삭제
    for(var i= $("#cashBankAcc option").size() - 1; i >= 1; i-- ){
        if($("#cashBankAcc option:eq("+i+")").val() == 528){
            $("#cashBankAcc option:eq("+i+")").remove();
        }
    }

    var payType = $("#payType").val();

    if(payType == "105"){//Cash
        $("#cashPayInfo").show();
        $("#chequePayInfo").hide();
        $("#onlinePayInfo").hide();
        $("#creditPayInfo").hide();

        $("#chequePayInfoForm")[0].reset();
        $("#onlinePayInfoForm")[0].reset();
        $("#creditPayInfoForm")[0].reset();

// ADVANCE KEY IN IS USING THIS PART
//         $("#cashBankType option").remove();
//         $("#cashBankType").append("<option value=''>Choose One</option>");
//         $("#cashBankType").append("<option value='2729'>MBB CDM</option>");
//         $("#cashBankType").append("<option value='2730'>VA</option>");
//         $("#cashBankType").append("<option value='2731'>Others</option>");

//         $("#onlineEFT").prop("required", false);
//         $('span', '#onlineEftLbl').empty().remove();

// //         //CASH이고 APP_TYPE이 OUTRIGHT_MEMBERSHIP이면 BANK_ID 528 추가
// //         if($("#appType").val() == 5){
// //             $("#cashBankAcc").append("<option value='528'>2210/001 - OTHER RECEIVABLES - HR PAYROLL EXPENSES</option>");
// //         }

    }else if(payType == "106"){ //Cheque
        $("#cashPayInfo").hide();
        $("#chequePayInfo").show();
        $("#onlinePayInfo").hide();
        $("#creditPayInfo").hide();

        $("#cashPayInfoForm")[0].reset();
        $("#onlinePayInfoForm")[0].reset();
        $("#creditPayInfoForm")[0].reset();

// ADVANCE KEY IN IS USING THIS PART
//         $("#chequeBankType option").remove();
//         $("#chequeBankType").append("<option value=''>Choose One</option>");
//         $("#chequeBankType").append("<option value='2730'>VA</option>");
//         $("#chequeBankType").append("<option value='2731'>Others</option>");

//         $("#onlineEFT").prop("required", false);
//         $('span', '#onlineEftLbl').empty().remove();
    }else if(payType == "107"){//Credit Card

        $("#cashPayInfo").hide();
        $("#chequePayInfo").hide();
        $("#onlinePayInfo").hide();
        $("#creditPayInfo").show();

        $("#cashPayInfoForm")[0].reset();
        $("#chequePayInfoForm")[0].reset();
        $("#onlinePayInfoForm")[0].reset();


//         $("#onlineBankType option").remove();
//         $("#onlineBankType").append("<option value=''>Choose One</option>");
//         $("#onlineBankType").append("<option value='2728'>JomPay</option>");
//         $("#onlineBankType").append("<option value='2730'>VA</option>");
//         $("#onlineBankType").append("<option value='2731'>Others</option>");

//         $("#onlineEFT").prop("required", true);
//         $("#onlineEftLbl").append("<span class='must'>*</span>");
    }else if(payType == "108"){//Online
        $("#cashPayInfo").hide();
        $("#chequePayInfo").hide();
        $("#onlinePayInfo").show();
        $("#creditPayInfo").hide();

        $("#cashPayInfoForm")[0].reset();
        $("#chequePayInfoForm")[0].reset();
        $("#creditPayInfoForm")[0].reset();

//ADVANCE KEY IN IS USING THIS PART
//         $("#onlineBankType option").remove();
//         $("#onlineBankType").append("<option value=''>Choose One</option>");
//         $("#onlineBankType").append("<option value='2728'>JomPay</option>");
//         $("#onlineBankType").append("<option value='2730'>VA</option>");
//         $("#onlineBankType").append("<option value='2731'>Others</option>");

//         $("#onlineEFT").prop("required", true);
//         $("#onlineEftLbl").append("<span class='must'>*</span>");
    }

    setTargetInfo();
}

//Attachments -- REMOVE button
function fn_removeFile(name){
	if(name == "FILE"){
	    $("#attachmentFile").val("");
	    $('#attachmentFile').change();
	}
}

function fn_attachmentButtonRegister(){
	$('#attachmentFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null) {
            if(myFileCaches[1] != null){
                delete myFileCaches[1];
            }
            if(attachmentFileId != '0'){
                remove.push(attachmentFileId);
            }
        }else if(file.name != attachmentFileName) {
             myFileCaches[1] = {file:file};
             if(attachmentFileName != "") {
                 update.push(attachmentFileId);
             }
         }
    });
}

//크레딧 카드 입력시 Card Mode 변경에 따라 Issue Bank와 Merchant Bank Combo를 갱신한다.
function fn_changeCrcMode(){
    var cardModeVal = $("#creditCardMode").val();

    if(cardModeVal == 2710){
        //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
        doGetCombo('/common/getIssuedBankList.do', 'CRC2710' , ''   , 'creditIssueBank' , 'S', '');

        //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
        doGetCombo('/common/getAccountList.do', 'CRC2710' , ''   , 'creditMerchantBank' , 'S', '');

    }else if(cardModeVal == 2712){      //MPOS IPP
      //IssuedBank 생성 : PBB, HLB, MBB, AMBank, HSBC, SCB, UOB
        doGetCombo('/common/getIssuedBankList.do', 'CRC2712' , ''   , 'creditIssueBank' , 'S', '');

        //Merchant Bank 생성 : CIMB, PBB, HLB, MBB, AM BANK, HSBC, SCB, UOB
        doGetCombo('/common/getAccountList.do', 'CRC2712' , ''   , 'creditMerchantBank' , 'S', '');
    }else{
        //IssuedBank 생성 : ALL
        doGetCombo('/common/getIssuedBankList.do', '' , ''   , 'creditIssueBank' , 'S', '');

        //Merchant Bank 생성
        if(cardModeVal == 2708){      //POS
            doGetCombo('/common/getAccountList.do', 'CRC2708' , ''   , 'creditMerchantBank' , 'S', '');
        }else if(cardModeVal == 2709){      //MOTO
            doGetCombo('/common/getAccountList.do', 'CRC2709' , ''   , 'creditMerchantBank' , 'S', '');
        }else if(cardModeVal == 2711){      //MPOS
            doGetCombo('/common/getAccountList.do', 'CRC2711' , ''   , 'creditMerchantBank' , 'S', '');
        }
    }

    //Tenure Dialble 처리
  $("#creditTenure").attr("disabled", false);
  $("#creditTenure").val("");

    if(cardModeVal == 2708 || cardModeVal == 2709 || cardModeVal == 2711){
        $("#creditTenure").attr("disabled", true);
    }else{
      $("#creditTenure").attr("disabled", false);
    }
}

//Tenure Combo Data
var tenureTypeData = [];
var tenureTypeData1 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "24","codeName": "24 Months"}];
var tenureTypeData2 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"},{"codeId": "36","codeName": "36 Months"}];
var tenureTypeData3 = [{"codeId": "6","codeName": "6 Months"},{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"}];
var tenureTypeData4 = [{"codeId": "12","codeName": "12 Months"},{"codeId": "18","codeName": "18 Months"},{"codeId": "24","codeName": "24 Months"}];
var tenureTypeData5 = [{"codeId": "12","codeName": "12 Months"},{"codeId": "24","codeName": "24 Months"}];

//Merchant Bank 변경시 Tenure 다시 세팅한다.
function fn_changeMerchantBank(){
  var creditMerBank = $("#creditMerchantBank").val();

  if(creditMerBank == 102 || creditMerBank == 104){        //HSBC OR CIMB
    doDefCombo(tenureTypeData1, '' ,'creditTenure', 'S', '');
  }else if(creditMerBank == 100 || creditMerBank == 106 || creditMerBank == 553 || creditMerBank == 871){        // MBB OR AMB OR UOB
        doDefCombo(tenureTypeData2, '' ,'creditTenure', 'S', '');
    }else if(creditMerBank == 105){        //HLB
        doDefCombo(tenureTypeData3, '' ,'creditTenure', 'S', '');
    }else if(creditMerBank == 107 ){        //PBB
        doDefCombo(tenureTypeData4, '' ,'creditTenure', 'S', '');
    }else if(creditMerBank == 563){        //SCB
        doDefCombo(tenureTypeData5, '' ,'creditTenure', 'S', '');
    }else {        //OTHER
        console.log('else')
        doDefCombo(tenureTypeData, '' ,'creditTenure', 'S', '');
    }
}

function fn_bankChange(bankVal){
    if(bankVal == "CASH"){
        var cashBankType = $("#cashBankType").val();
        $("#cashVAAccount").val('');
        $("#cashBankAcc").val('');
        if(cashBankType != "2730"){
            $("#cashVAAccount").addClass("readonly");
            $("#cashVAAccount").attr('readonly', true);
            $("#cashBankAcc").attr('disabled', false);
            $("#cashBankAcc").removeClass("disabled");

            if(cashBankType == '2729'){
                $('#cashBankAcc').val("84");
            }else{
                $('#cashBankAcc').val('');
            }
        }else{
            $("#cashVAAccount").removeClass("readonly");
            $("#cashVAAccount").attr('readonly', false);
            $("#cashBankAcc").attr('disabled', false);
            $("#cashBankAcc").val('525');
            //$("#cashBankAcc").addClass("w100p disabled");
        }
    }else if(bankVal == "CHQ"){
        var chequeBankType = $("#chequeBankType").val();
        $("#chequeVAAccount").val('');
        $("#chequeBankAcc").val('');
        if(chequeBankType != "2730"){
            $("#chequeVAAccount").addClass("readonly");
            $("#chequeVAAccount").attr("readonly", false);
            $("#chequeBankAcc").attr('disabled', false);
            $("#chequeBankAcc").removeClass("disabled");
        }else{
            $("#chequeVAAccount").removeClass("readonly");
            $("#chequeVAAccount").attr("readonly", false);
            $("#chequeBankAcc").attr('disabled', false);
            $("#chequeBankAcc").val('525');
            //$("#chequeBankAcc").addClass("w100p disabled");
        }
    }else if(bankVal == "ONL"){
        var onlineBankType = $("#onlineBankType").val();
        $("#onlineVAAccount").val('');
        $("#onlineBankAcc").val('');
        if(onlineBankType != "2730"){
            $("#onlineVAAccount").addClass("readonly");
            $("#onlineVAAccount").attr('readonly', false);
            $("#onlineBankAcc").attr('disabled', false);
            $("#onlineBankAcc").removeClass("disabled");

            if(onlineBankType == '2728'){
                $("#onlineBankAcc option").remove();
                $("#onlineBankAcc").append("<option value=''>Choose One</option>");
                $("#onlineBankAcc").append("<option value='546'>2710/010C - CIMB 641</option>");
                $("#onlineBankAcc").append("<option value='558'>2710/205 - CIMB 7</option>");
              }else{
                $("#onlineBankAcc option").remove();
                doGetCombo('/common/getAccountList.do', 'ONLINE','', 'onlineBankAcc', 'S', '' );
              }

        }else{
            $("#onlineVAAccount").removeClass("readonly");
            $("#onlineVAAccount").attr('readonly', false);
            $("#onlineBankAcc").attr('disabled', false);
            //$("#onlineBankAcc").addClass("w100p disabled");
            $("#onlineBankAcc option").remove();
            $("#onlineBankAcc").append("<option value='525'>2710/010B - CIMB VA</option>");
            $('#onlineBankAcc').val("525");
        }
    }
}

//저장처리
function fn_DCFRequest(){
//   DCF INFO
	 if(FormUtil.checkReqValue($("#reason option:selected"))){
		 Common.alert("<spring:message code='pay.alert.noReason'/>");
		 return;
	}

//  Checking for attachment
//     var attachmentFile = $('#attachmentFile').val();
//     if(attachmentFile == null || attachmentFile== ""){
//         if(attachmentFileId == 0){
//             Common.alert('Attachment is required');
//             return;
//         }
//     }

	 if($("#attachmentFile").val() == "" || FormUtil.byteLength($("#attachmentFile").val().trim()) == null){
	        Common.alert("Attachement cannot be empty.");
	        return;
	    }
	    else {
	        var str = $("#attachmentFile").val().split(".");
	        if(str[1] != "zip"){
	            Common.alert("Please attach zip file only.");
	            return;
	        }
	    }

	if( Number($("#totalAmt").val()) <= 0 ){
    	Common.alert("<spring:message code='pay.alert.amtThanZero'/>");
    	return;
    }

	if($("#remark").val() == ''){
		Common.alert("<spring:message code='pay.alert.inputRemark'/>");
    	return;
	}

	if( FormUtil.byteLength($("#remark").val()) > 400 ){
    	Common.alert("* Please input the Remark below or less than 400 bytes.");
    	return;
    }

	/* //저장처리
	Common.confirm("<spring:message code='pay.alert.wantToRequestDcf'/>",function (){


	    Common.ajax("POST", "/payment/requestDCF.do", $("#_dcfSearchForm").serializeJSON(), function(result) {

	    	if (result.error) {
	    		var message = result.error;
	    	} else {
				var message = "<spring:message code='pay.alert.dcfSuccessReq' arguments='"+result.returnKey+"' htmlEscape='false'/>";
	    	}

    		Common.alert(message, function(){
				searchList();
				$('#_requestDCFPop').remove();
    		});
	    });
	}); */

	var reKeyStatus = $("input[name='rekeyStus']:checked").val();

    if(reKeyStatus== null){
         Common.alert("Please select Rekey-in status");
         return;

    } else if (reKeyStatus == "1") {

//       NEW DCF
         if( Number($("#newTotalAmtTxt").val()) <= 0 ){
             Common.alert("<spring:message code='pay.alert.amtThanZero'/>");
             return;
         }

        if(AUIGrid.getGridData(myRequestNewDCFGridID).length == 0){
             Common.alert("Please select Order for new DCF request");
             return;
        }

//      NEW DCF PAYMENT INFO
        var payType = $("#payType").val();

        if(payType == null || payType == ''){
            Common.alert("Please select Payment Type");
            return;

        }else if(payType == "105"){    //Cash

            var cashBankType = $("#cashBankType").val();
            var cashVAAccount = $("#cashVAAcc").val();
            var cashBankAcc = $("#cashBankAcc").val();

            if(FormUtil.checkReqValue($("#cashTotalAmtTxt")) ||$("#cashTotalAmtTxt").val() <= 0 ){
                Common.alert("<spring:message code='pay.alert.noAmount'/>");
                return;
            }

            if($("#cashTotalAmtTxt").val() > 200000 ){
                Common.alert("Amount exceed RM 200000");
                return;
            }

            if(cashBankType == ""){
                  Common.alert("* No Bank Type");
               return;
            } else if(cashBankType == "2730"){
                if(cashVAAccount == "" ){
                    Common.alert("<spring:message code='pay.alert.noVAAccount'/>");
                    return;
                }

            } else{
                if(FormUtil.checkReqValue($("#cashBankAcc"))){
                    Common.alert("<spring:message code='pay.alert.noBankAccountSelected'/>");
                    return;
                }
            }

            if(FormUtil.checkReqValue($("#cashTrxDate"))){
                Common.alert("<spring:message code='pay.alert.transDateEmpty '/>");
                return;
            }

            if(FormUtil.checkReqValue($("#cashSlipNo"))){
                Common.alert("<spring:message code='pay.alert.noSlipNo'/>");
                return;
            }

            $("#chequePayInfoForm")[0].reset();
            $("#onlinePayInfoForm")[0].reset();
            $("#creditPayInfoForm")[0].reset();

        }else if(payType == "106"){    //Cheque

            var chequeBankType = $("#chequeBankType").val();
            var chequeVAAccount = $("#chequeVAAcc").val();
            var chequeBankAcc = $("#chequeBankAcc").val();

            if(FormUtil.checkReqValue($("#chequeTotalAmtTxt")) ||$("#chequeTotalAmtTxt").val() <= 0 ){
                Common.alert("<spring:message code='pay.alert.noAmount'/>");
                return;
            }

            if($("#chequeTotalAmtTxt").val() > 200000 ){
                Common.alert("Amount exceed RM 200000");
                return;
            }

            if(chequeBankType == ''){
                  Common.alert("* No Bank Type");
               return;
            } else if(chequeBankType == "2730"){
                if(chequeVAAccount == "" ){
                    Common.alert("<spring:message code='pay.alert.noVAAccount'/>");
                    return;
                }

            }else{
                if(FormUtil.checkReqValue($("#chequeBankAcc"))){
                    Common.alert("<spring:message code='pay.alert.noBankAccountSelected'/>");
                    return;
                }
            }

            if(FormUtil.checkReqValue($("#chequeTrxDate"))){
                Common.alert("<spring:message code='pay.alert.transDateEmpty '/>");
                return;
            }

            if(FormUtil.checkReqValue($("#chequeSlipNo"))){
                Common.alert("<spring:message code='pay.alert.noSlipNo'/>");
                return;
            }

            $("#cashPayInfoForm")[0].reset();
            $("#onlinePayInfoForm")[0].reset();
            $("#creditPayInfoForm")[0].reset();

        }else if(payType == "107"){    //Credit Card

            //Credit Type
            if(FormUtil.checkReqValue($("#creditCardType option:selected"))){
                   Common.alert("* No Card Type");
                   return;
            }

            // Amount
            if(FormUtil.checkReqValue($("#creditTotalAmtTxt")) ||$("#creditTotalAmtTxt").val() <= 0 ){
                    Common.alert("<spring:message code='pay.alert.noAmount'/>");
                return;
            }

            if($("#creditTotalAmtTxt").val() > 200000 ){
                Common.alert("Amount exceed RM 200000");
                return;
            }

            //Card Mode
            if(FormUtil.checkReqValue($("#creditCardMode option:selected"))){
                Common.alert("<spring:message code='pay.alert.noCrcMode'/>");
                return;
            }

            // Credit card brand
            if(FormUtil.checkReqValue($("#creditCardBrand option:selected"))){
                Common.alert("<spring:message code='pay.alert.noCrcBrand'/>");
                return;

            }else{
              var crcType = $("#creditCardBrand").val();
              var cardNo1st1Val = $("#creditCardNo1").val().substr(0,1);
              var cardNo1st2Val = $("#creditCardNo1").val().substr(0,2);
              var cardNo1st4Val = $("#creditCardNo1").val().substr(0,4);

              if(cardNo1st1Val == 4){
                if(crcType != 112){
                  Common.alert("<spring:message code='pay.alert.invalidCrcType'/>");
                        return;
                }
              }

              if((cardNo1st2Val >= 51 && cardNo1st2Val <= 55) || (cardNo1st4Val >= 2221 && cardNo1st4Val <= 2720)){
                    if(crcType != 111){
                        Common.alert("<spring:message code='pay.alert.invalidCrcType'/>");
                        return;
                    }
                }
            }

            // Card No
            if(FormUtil.checkReqValue($("#creditCardNo1")) ||
              FormUtil.checkReqValue($("#creditCardNo2")) ||
              FormUtil.checkReqValue($("#creditCardNo3"))  ||
              FormUtil.checkReqValue($("#creditCardNo4"))){
                Common.alert("<spring:message code='pay.head.noCrcNo'/>");
                return;
            }else{
              var cardNo1Size = $("#creditCardNo1").val().length;
              var cardNo2Size = $("#creditCardNo2").val().length;
              var cardNo3Size = $("#creditCardNo3").val().length;
              var cardNo4Size = $("#creditCardNo4").val().length;
              var cardNoAllSize = cardNo1Size  + cardNo2Size + cardNo3Size + cardNo4Size;

              if(cardNoAllSize != 16){
                Common.alert("<spring:message code='pay.alert.ivalidCrcNo'/>");
                    return;
              }
            }

              // Approval No
              if(FormUtil.checkReqValue($("#creditApprNo"))){
                  Common.alert("<spring:message code='pay.alert.noApprovalNumber'/>");
                  return;
              }else{

                  var appValSize = $("#creditApprNo").val().length;

                  if(appValSize != 6){
                      Common.alert("<spring:message code='pay.alert.invalidApprovalNoLength '/>");
                      return;
                  }
              }

              //Issue Bank 체크
              if(FormUtil.checkReqValue($("#creditIssueBank option:selected"))){
                  Common.alert("<spring:message code='pay.alert.noIssueBankSelected'/>");
                  return;
              }


             // Expiry date
             if(FormUtil.checkReqValue($("#creditExpiryMonth")) || FormUtil.checkReqValue($("#creditExpiryYear"))){
                 Common.alert("<spring:message code='pay.alert.noCrcExpiryDate'/>");
                 return;
             }else{
                 var expiry1Size = $("#creditExpiryMonth").val().length;
                 var expiry2Size = $("#creditExpiryYear").val().length;

                 var expiryAllSize = expiry1Size  + expiry2Size;

                 if(expiryAllSize != 4){
                     Common.alert("<spring:message code='pay.alert.invalidCrcExpiryDate'/>");
                     return;
                 }

                 if(Number($("#creditExpiryMonth").val()) > 12){
                   Common.alert("<spring:message code='pay.alert.invalidCrcExpiryDate'/>");
                     return;
                 }
             }

            //Merchant Bank 체크
            if(FormUtil.checkReqValue($("#creditMerchantBank option:selected"))){
                Common.alert("<spring:message code='pay.alert.noMerchantBankSelected'/>");
                return;
            }

            //Transaction Date 체크
            if(FormUtil.checkReqValue($("#creditTrxDate"))){
                Common.alert("<spring:message code='pay.alert.transDateEmpty'/>");
                return;
            }

            var data = {
                    keyInApprovalNo : $("#creditApprNo").val(),
                    keyInAmount : $("#creditTotalAmtTxt").val(),
                    keyInTrDate : $("#creditTrxDate").val(),
                    keyInMerchantBank : $("#creditMerchantBank").val(),
                    keyInCardNo1 : $("#creditCardNo1").val(),
                    keyInCardNo2 : $("#creditCardNo2").val(),
                    keyInCardNo4: $("#creditCardNo4").val()
            }

            //Check Batch Payment Exist
            Common.ajaxSync("GET", "/payment/common/checkBatchPaymentExist.do", data, function(result) {
                if(result != null){
                    Common.alert("Payment has been uploaded.");
                    return;
                }
            });

            $("#cashPayInfoForm")[0].reset();
            $("#chequePayInfoForm")[0].reset();
            $("#onlinePayInfoForm")[0].reset();

        }else if(payType == "108"){    //Online

            var onlineBankType = $("#onlineBankType").val();
            var onlineVAAccount = $("#onlineVAAcc").val();
            var onlineBankAcc = $("#onlineBankAcc").val();

            if(FormUtil.checkReqValue($("#onlineTotalAmtTxt")) ||$("#onlineTotalAmtTxt").val() <= 0 ){
                Common.alert("<spring:message code='pay.alert.noAmount'/>");
                return;
            }

            if($("#onlineTotalAmtTxt").val() > 200000 ){
                Common.alert("Amount exceed RM 200000");
                return;
            }

          //BankCharge Amount는 Billing 금액의 5%를 초과할수 없다
            var bcAmt4Limit = 0;
            var payAmt4Limit = 0;
            var bcLimit = 0;

            if(!FormUtil.isEmpty($("#onlineBankChgAmt").val())) {
                bcAmt4Limit = Number($("#onlineBankChgAmt").val());
                payAmt4Limit = Number($("#newTotalAmtTxt").val());

                bcAmt4Limit = Number($.number(bcAmt4Limit,2,'.',''));
                payAmt4Limit = Number($.number(payAmt4Limit,2,'.',''));
                bcLimit = Number($.number(payAmt4Limit * 0.05,2,'.',''));

                if (bcLimit < bcAmt4Limit) {
                    Common.alert("Bank Charge Amount can not exceed 5% of Amount.");
                    return;
                }
            }

            if(FormUtil.checkReqValue($("#onlineTrxDate"))){
                Common.alert("<spring:message code='pay.alert.transDateEmpty '/>");
                return;
            }

            if(onlineBankType == "2730"){
                 if(onlineVAAccount == "" ){
                     Common.alert("<spring:message code='pay.alert.noVAAccount'/>");
                     return;
                 }

             }else{
                 if(FormUtil.checkReqValue($("#onlineBankAcc"))){
                     Common.alert("<spring:message code='pay.alert.noBankAccountSelected'/>");
                     return;
                 }

                 if(onlineBankType == "2728") {
                     if(FormUtil.isEmpty($("#onlineEFT").val())) {
                         Common.alert("* No EFT/JomPayRef");
                         return;
                     }
                     if( FormUtil.byteLength($("#onlineEFT").val()) > 100 ){
                         Common.alert("* Please input the EFT No. below or less than 100 bytes.");
                         return;
                     }
                 }
             }

            $("#cashPayInfoForm")[0].reset();
            $("#chequePayInfoForm")[0].reset();
            $("#creditPayInfoForm")[0].reset();
        }
    }

    Common.popupDiv("/payment/requestApprovalLineCreatePop.do", null, '', true,'_requestApprovalLineCreatePop');
}

function fn_checkkTrxIdMapping(trxId, amt){
    var jsonObj = {
    		"trxId" : trxId,
    		"amt" : amt
    };

    Common.ajax("GET", "/payment/checkBankStateMapStus.do", jsonObj, function(result) {
        console.log("data : " + result);
        if (result != null && result.code == "99") {
            Common.alert(result.message);
            $('#cashTrxId').val("");
            $('#chequeTrxId').val("");
            $('#onlineTrxId').val("");
            return false;
        }

        return true;
    });
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

function fn_changeCardNo1(){

	  var cardNo1Size = $("#creditCardNo1").val().length;

	  if(cardNo1Size >= 4){
	    var cardNo1st1Val = $("#creditCardNo1").val().substr(0,1);
	        var cardNo1st2Val = $("#creditCardNo1").val().substr(0,2);
	        var cardNo1st4Val = $("#creditCardNo1").val().substr(0,4);

	        if(cardNo1st1Val == 4){
	          $("#creditCardBrand").val(112);
	        }

	        if((cardNo1st2Val >= 51 && cardNo1st2Val <= 55) || (cardNo1st4Val >= 2221 && cardNo1st4Val <= 2720)){
	          $("#creditCardBrand").val(111);
	        }
	  }
}

// Correct order to request DCF (call back from requestDCFOrderSearchPop.jsp)
function fn_newOrderSearchPopCallBack(returnGrid){
	console.log(returnGrid);
    AUIGrid.setGridData(myRequestNewDCFGridID, returnGrid);
    $('#_newOrderForDCFPop').remove();
    setTargetInfo();
}

function setTargetInfo(){
    //Fund Transfer 총 금액 세팅
    var rowCnt = AUIGrid.getRowCount(myRequestNewDCFGridID);
    var totalAmt = 0;

    if(rowCnt > 0){
        $("#newOrdNo").val(AUIGrid.getCellValue(myRequestNewDCFGridID, 0 ,"ordNo"));
        $("#newCustNm").val(AUIGrid.getCellValue(myRequestNewDCFGridID, 0 ,"custNm"));

        for(var i = 0; i < rowCnt; i++){
            totalAmt += AUIGrid.getCellValue(myRequestNewDCFGridID, i ,"targetAmt");
        }
    }

    $("#newTotalAmtTxt").val(totalAmt.toFixed(2));
    $("#cashTotalAmtTxt").val(totalAmt.toFixed(2));
    $("#chequeTotalAmtTxt").val(totalAmt.toFixed(2));
    $("#onlineTotalAmtTxt").val(totalAmt.toFixed(2));
    $("#creditTotalAmtTxt").val(totalAmt.toFixed(2));
}
</script>

<div id="popup_wrap" class="popup_wrap size_large"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Request DCF</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
        <!-- search_result start -->
        <section class="search_result">
            <span>Old Order Info:</span>
            <!-- grid_wrap start -->
            <article id="grid_request_dcf_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>

        <!-- search_table start -->
        <section class="search_table">
            <form name="_dcfSearchForm" id="_dcfSearchForm"  method="post" enctype="multipart/form-data">
                <input id="groupSeq" name="groupSeq" value="${groupSeq}" type="hidden" />

                <table class="type1"><!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:160px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Reason<span class='must'>*</span></th>
                            <td><select id="reason" name="reason" class="w100p"></select></td>

                            <th scope="row">Rekey-in status<span class="must">*</span></th>
                            <td>
                                <label><input type="radio" name="rekeyStus" id="rekeyStusNo" value="0" /><span>NO</span></label>
                                <label><input type="radio" name="rekeyStus" id="rekeyStusYes" value="1"/><span>YES</span></label>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Attachment<span class='must'>*</span></th>
		                    <td id="attachTd" colspan="3" >
	                            <div class="auto_file2">
	                                <input type="file" title="file add" id="attachmentFile" accept=".zip"/>
	                                <label style="width:100%">
	                                    <input type='text' class='input_text' id='attachmentFileTxt' name='attachmentFileTxt' style='width: 285px !important;'/>
	                                    <span class='label_text' id="uploadBtn"><a href='#'>Upload</a></span>
	                                    <span class='label_text remove'><a href='#' onclick='fn_removeFile("FILE")'>Remove</a></span>
	                                </label>
	                            </div>
		                    </td>
                        </tr>
                        <tr>
                            <th scope="row">Total Amount</th>
                            <td colspan="3">
                                <input id="oldTotalAmtTxt" name="oldTotalAmtTxt" type="text" class="readonly " readonly style='width: 285px !important;' />
                                <input id="oldTotalAmt" name="oldTotalAmt" type="hidden" class="readonly " readonly />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Request Remark<span class='must'>*</span></th>
                            <td colspan="3">
                                <textarea id="remark" name="remark"  cols="15" rows="3" placeholder="" maxlength = "400"></textarea>
                            </td>
                        </tr>
                    </tbody>
                 </table>

                 <!-- WHEN REKEY-IN STATUS = YES, WILL SHOW THIS PART -->
                 <section id="newOrderInfoSection">
                     <!-- NEW ORDER INFO START -->
                     <span>New Order Info:</span>
	                 <table class="type1" >
	                    <caption>table</caption>
	                    <colgroup>
	                        <col style="width:160px" />
	                        <col style="width:*" />
	                        <col style="width:160px" />
	                        <col style="width:*" />
	                    </colgroup>
	                    <tbody>
	                        <tr>
	                            <th scope="row">Order No.</th>
	                               <td>
	                                    <input type="text" id="ordNo" name="ordNo" style="width: 209px;" />
	                                    <p class="btn_sky">
	                                        <a href="javascript:fn_requestDCFOrderSearchPop();" id="search"><spring:message code='sys.btn.search'/></a>
	                                    </p>
	                               </td>

	                            <th scope="row">Total Amount</th>
	                            <td>
	                                <input id="newTotalAmtTxt" name="newTotalAmtTxt" type="text" class="readonly w100p" readonly />
	                                <input id="newTotalAmt" name="newTotalAmt" type="hidden" class="readonly w100p" readonly />
	                            </td>
	                        </tr>
                        </tbody>
                     </table>
                     <!-- NEW ORDER INFO END -->

		             <!-- SELECTED NEW ORDER START -->
				     <section class="search_result">
				          <article id="grid_request_new_dcf_wrap" class="grid_wrap"></article>
				     </section>
				     <!-- SELECTED NEW ORDER END -->

                     <!-- PAYMENT INFO START, NEED HIDE & SHOW FOR ABOVE SELECTED PAYMENT TYPE -->
				     <span>Payment Info:</span>
			         <table class="type1" >
	                         <caption>table</caption>
	                         <colgroup>
	                             <col style="width:160px" />
	                             <col style="width:*" />
	                             <col style="width:160px" />
	                             <col style="width:*" />
	                         </colgroup>
	                         <tbody>
	                             <tr>
	                                 <th scope="row">Payment Type</th>
	                                 <td>
	                                     <select id="payType" name="payType" class="w100p" onChange="javascript:fn_payTypeChange();"></select>
	                                 </td>
	                             </tr>
                             </tbody>
                     </table>
                 </section>
            </form>

			<section id="paymentInfoSection" style="display:none;">
				<!--
				***************************************************************************************
				***************************************************************************************
				*************                                     CASH PAYMENT INFO                                                   ****
				***************************************************************************************
				***************************************************************************************
				-->
			    <section id="cashPayInfo" style="display:none;">
	                <form name="cashPayInfoForm" id="cashPayInfoForm"  method="post">
	                    <table class="type1" >
	                      <caption>table</caption>
	                      <colgroup>
	                          <col style="width:160px" />
	                          <col style="width:*" />
	                          <col style="width:160px" />
	                          <col style="width:*" />
	                      </colgroup>
	                      <tbody>
	                          <tr>
	                              <th scope="row">Amount<span class='must'>*</span></th>
	                              <td>
	                                    <input id="cashTotalAmtTxt" name="cashTotalAmtTxt" type="text" class="readonly w100p" readonly />
	                                    <input id="cashTotalAmt" name="cashTotalAmt" type="hidden" class="readonly w100p" readonly />
	                              </td>

                                  <th scope="row">Bank Type<span class='must'>*</span></th>
	                              <td>
	                                   <select id="cashBankType" name="cashBankType" class="w100p" onchange="fn_bankChange('CASH');">
	                                      <option value="">Choose One</option>
	                                      <option value="2728">JomPay</option>
	                                      <option value="2729">MBB CDM</option>
		                                  <option value="2730">VA</option>
		                                  <option value="2731">Others</option>
	                                  </select>
	                              </td>
	                          </tr>
	                          <tr>
	                              <th scope="row">Bank Account<span class='must'>*</span></th>
	                              <td>
	                                    <select id="cashBankAcc" name="cashBankAcc" class="w100p"></select>
	                              </td>

	                              <th scope="row">VA Account<span class='must'>*</span></th>
	                              <td>
	                                  <input type="text" id="cashVAAcc" name="cashVAAcc" class="w100p" size="22" maxlength="30" />
	                              </td>
	                          </tr>
	                          <tr>
	                              <th scope="row">Transaction Date<span class='must'>*</span></th>
	                              <td>
	                                   <div class="date_set w100p">
	                                      <input type="text" id="cashTrxDate" name="cashTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
	                                   </div>
	                              </td>

                               <th scope="row">Slip No<span class='must'>*</span></th>
                               <td>
                                   <input type="text" id="cashSlipNo" name="cashSlipNo" class="w100p" />
                               </td>
                           </tr>
                           <tr>
                               <th scope="row">Transaction ID</th>
                               <td>
                                    <input type="text" id="cashTrxId" name="cashTrxId" class="w100p" />
                               </td>
                           </tr>
                        </tbody>
                     </table>
                    </form>
                </section>


                <!--
                ***************************************************************************************
                ***************************************************************************************
                *************                                     CHEQUE PAYMENT INFO                                               ****
                ***************************************************************************************
                ***************************************************************************************
                -->
                <section id="chequePayInfo" style="display:none;">
                    <form id="chequePayInfoForm" action="#" method="post">
                          <table class="type1" >
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:160px" />
                                <col style="width:*" />
                                <col style="width:160px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Amount<span class='must'>*</span></th>
                                    <td>
                                          <input id="chequeTotalAmtTxt" name="chequeTotalAmtTxt" type="text" class="readonly w100p" readonly />
                                    </td>

                                    <th scope="row">Bank Type<span class='must'>*</span></th>
                                    <td>
                                         <select id="chequeBankType" name="chequeBankType" class="w100p" onchange="fn_bankChange('CHQ');">
                                            <option value="">Choose One</option>
                                            <option value="2728">JomPay</option>
                                            <option value="2729">MBB CDM</option>
                                            <option value="2730">VA</option>
                                            <option value="2731">Others</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Bank Account<span class='must'>*</span></th>
                                    <td>
                                          <select id="chequeBankAcc" name="chequeBankAcc" class="w100p"></select>
                                    </td>

                                    <th scope="row">VA Account<span class='must'>*</span></th>
                                    <td>
                                        <input type="text" id="chequeVAAcc" name="chequeVAAcc" class="w100p" maxlength="30" />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Transaction Date<span class='must'>*</span></th>
                                    <td>
                                         <div class="date_set w100p">
                                            <input type="text" id="chequeTrxDate" name="chequeTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                                         </div>
                                    </td>

                                    <th scope="row">Slip No<span class='must'>*</span></th>
                                    <td>
                                        <input type="text" id="chequeSlipNo" name="chequeSlipNo" class="w100p" />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Transaction ID</th>
                                    <td>
                                         <input type="text" id="chequeTrxId" name="chequeTrxId" class="w100p" />
                                    </td>
                                </tr>
                             </tbody>
                          </table>
                    </form>
                </section>



              <!--
              ***************************************************************************************
              ***************************************************************************************
              *************                                   CREDIT CARD PAYMENT INFO                                         ****
              ***************************************************************************************
              ***************************************************************************************
              -->
              <section id="creditPayInfo" style="display:none;">
                    <form id="creditPayInfoForm" action="#" method="post">
                          <table class="type1" >
                            <caption>table</caption>
                            <colgroup>
                                <col style="width:160px" />
                                <col style="width:*" />
                                <col style="width:160px" />
                                <col style="width:*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Card Type<span class='must'>*</span></th>
                                    <td>
                                          <select id="creditCardType" name="creditCardType" class="w100p"></select>
                                    </td>

                                    <th scope="row">Amount<span class='must'>*</span></th>
                                    <td>
                                          <input id="creditTotalAmtTxt" name="creditTotalAmtTxt" type="text" class="readonly w100p" readonly />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Card Mode<span class='must'>*</span></th>
                                    <td>
                                         <select id="creditCardMode" name="creditCardMode" class="w100p" onchange="fn_changeCrcMode()"></select>
                                    </td>

                                    <th scope="row">Card Brand<span class='must'>*</span></th>
                                    <td>
                                         <select id="creditCardBrand" name="creditCardBrand" class="w100p"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Card No<span class='must'>*</span></th>
                                    <td>
							            <p class="short"><input type="text" id="creditCardNo1" name="creditCardNo1" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);' onChange="javascript:fn_changeCardNo1();" /></p> <span>-</span>
							            <p class="short"><input type="text" id="creditCardNo2" name="creditCardNo2" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'/></p> <span>-</span>
							            <p class="short"><input type="text" id="creditCardNo3" name="creditCardNo3" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' onkeyup='nextTab(this, event);'/></p> <span>-</span>
							            <p class="short"><input type="text" id="creditCardNo4" name="creditCardNo4" size="4" maxlength="4" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
                                    </td>

                                    <th scope="row">Approval No<span class='must'>*</span></th>
                                    <td>
                                        <input type="text" id="creditApprNo" name="creditApprNo" class="w100p" maxlength="6"  />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Issue Bank<span class='must'>*</span></th>
                                    <td>
                                          <select id="creditIssueBank" name="creditIssueBank" class="w100p"></select>
                                    </td>

                                    <th scope="row">Credit Card Holder Name</th>
                                    <td>
                                        <input type="text" id="creditCardHolderName" name="creditCardHolderName" class="w100p" />
                                    </td>
                                </tr>
                                <tr>
                                     <th scope="row">Expiry Date (mm/yyyy)<span class='must'>*</span></th>
                                    <td>
                                         <div class="date_set w100p">
                                            <p class="short" style="width: 18% !important;padding-right: 0px;"><input type="text" id="creditExpiryMonth" name="creditExpiryMonth" size="2" maxlength="2" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /> <span> / </span> </p>
                                            <p class="short" style="padding-left: 0px;"><input type="text" id="creditExpiryYear" name="creditExpiryYear" size="2" maxlength="2" class="wAuto" onkeydown='return FormUtil.onlyNumber(event)' /></p>
                                         </div>
                                    </td>

                                    <th scope="row">Merchant Bank<span class='must'>*</span></th>
                                    <td>
                                        <select id="creditMerchantBank" name="creditMerchantBank" class="w100p" onChange="javascript:fn_changeMerchantBank();"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Transaction Date<span class='must'>*</span></th>
                                    <td>
                                         <div class="date_set w100p">
                                            <input type="text" id="creditTrxDate" name="creditTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                                         </div>
                                    </td>

                                    <th scope="row">Tenure</th>
                                    <td>
                                      <select id="creditTenure" name="creditTenure" class="w100p"></select>
                                    </td>
                                </tr>
                             </tbody>
                          </table>
                    </form>
                </section>


               <!--
               ***************************************************************************************
               ***************************************************************************************
               *************                                     ONLINE PAYMENT INFO                                                   ****
               ***************************************************************************************
               ***************************************************************************************
               -->
               <section id="onlinePayInfo" style="display:none;">
                   <form id="onlinePayInfoForm" action="#" method="post">
                       <table class="type1" >
                           <caption>table</caption>
                           <colgroup>
                               <col style="width:160px" />
                               <col style="width:*" />
                               <col style="width:160px" />
                               <col style="width:*" />
                           </colgroup>
                           <tbody>
                               <tr>
                                   <th scope="row">Amount<span class='must'>*</span></th>
                                   <td>
                                         <input id="onlineTotalAmtTxt" name="onlineTotalAmtTxt" type="text" class="readonly w100p" readonly />
                                   </td>

                                   <th scope="row">VA Account<span class='must'>*</span></th>
                                   <td>
                                       <input type="text" id="onlineVAAcc" name="onlineVAAcc" class="w100p" size="22" maxlength="30" />
                                   </td>
                               </tr>
                               <tr>
                                   <th scope="row">Bank Type<span class='must'>*</span></th>
                                   <td>
                                        <select id="onlineBankType" name="onlineBankType" class="w100p" onchange="fn_bankChange('ONL');">
                                           <option value="2728">JomPay</option>
                                           <option value="2729">MBB CDM</option>
                                           <option value="2730">VA</option>
                                           <option value="2731">Others</option>
                                       </select>
                                   </td>

                                   <th scope="row">Bank Account<span class='must'>*</span></th>
                                   <td>
                                         <select id="onlineBankAcc" name="onlineBankAcc" class="w100p"></select>
                                   </td>
                               </tr>
                               <tr>
                                   <th scope="row">Transaction Date<span class='must'>*</span></th>
                                   <td>
                                        <div class="date_set w100p">
                                           <input type="text" id="onlineTrxDate" name="onlineTrxDate" title="Transaction Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                                        </div>
                                   </td>

                                   <th scope="row" d="onlineEftLbl">EFT<span class='must'>*</span></th>
                                   <td>
                                       <input type="text" id="onlineEFT" name="onlineEFT" class="w100p" />
                                   </td>
                               </tr>
                               <tr>
                                   <th scope="row">Transaction ID</th>
                                   <td>
                                        <input type="text" id="onlineTrxId" name="onlineTrxId" class="w100p" />
                                   </td>

                                   <th scope="row">Bank Charge Amount</th>
                                   <td>
                                        <input type="text" id="onlineBankChgAmt" name="onlineBankChgAmt" class="w100p" maxlength="10" onkeydown='return FormUtil.onlyNumber(event)'/>
                                   </td>
                               </tr>
                            </tbody>
                       </table>
                    </form>
                </section>
              <!-- PAYMENT INFO END -->
            </section>
        </section>

        <ul class="center_btns">
            <li><p class="btn_blue"><a href="javascript:fn_DCFRequest();"><spring:message code='pay.btn.request'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_DCFClear();"><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </section>
</div>