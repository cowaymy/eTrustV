<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//생성 후 반환 ID
var purchaseGridID;
var serialTempGridID;
var memGridID;

var paymentGridID;

$(document).ready(function() {

	/******  INIT ********************/

	createPurchaseGridID();
	createSerialTempGridID();
	creatememGridID();
	createPaymentGrid();

	//PosModuleTypeComboBox
	var modulePopParam = {groupCode : 143, codeIn : [2390, 2391]};
	CommonCombo.make('_insPosModuleType', "/sales/pos/selectPosModuleCodeList", modulePopParam , '', optionModule);

	//PosSystemTypeComboBox
    var systemPopParam = {groupCode : 140 , codeIn : [1352, 1353]};
    CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);

    //branch List
    var selVal = $("#_memBrnch").val().trim();
    console.log('membrnch : [' + selVal+ ']');
    CommonCombo.make('_cmbWhBrnchIdPop', "/sales/pos/selectWhBrnchList", '' , selVal, '');

    //Payment
    CommonCombo.make('_payBrnchCode', "/sales/pos/getpayBranchList", '', selVal, '');
    //CommonCombo.make('_payBrnchCode', "/sales/pos/selectWhBrnchList", '' , selVal, '');

    var debSelVal = "524";
    CommonCombo.make("_payDebtorAcc", "/sales/pos/getDebtorAccList", '', debSelVal, optionModule);
    $("#_payDebtorAcc").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

    fn_payModeAndBankAccControl(); //draw Combo


    /******  INIT ********************/

    $("#_payMode").change(function() {

		var payMode = $(this).val();

		if(payMode == 105){  // 105 cash


		    $("#_payCreditCardNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); //this.txtCreditCardNo.Enabled = false;
		    $("#_payApprovNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); // this.txtApprovalNo.Enabled = false;
		    $("#_payCrcType").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); //   this.cmbCRCType.Enabled = false;
		    $("#_payCrcMode").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); // this.cmbCRCMode.Enabled = false;
		    $("#_payIssueBank").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); // this.cmbCRCMode.Enabled = false;

		    fn_payModeAndBankAccControl();

		}// End 105 Cash

		if(payMode == 108){  // 108 deduction

			var initBankParam = {isDeduc : "1"};
		    CommonCombo.make("_payBankAccount", "/sales/pos/getBankAccountList", initBankParam, '59', optionModule);
		    $("#_payBankAccount").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

		    $("#_payCreditCardNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"});  //this.txtCreditCardNo.Enabled = false;
		    $("#_payApprovNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"});  // this.txtApprovalNo.Enabled = false;
		    $("#_payCrcType").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); //   this.cmbCRCType.Enabled = false;
		    $("#_payCrcMode").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); // this.cmbIssuedBank.Enabled = false;
		    $("#_payIssueBank").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); // this.cmbCRCMode.Enabled = false;
		}


	    /* if(payMode == 107){  // 107 Credit Card

	    	$("#_payCreditCardNo").attr({"disabled" : true , "class" : "w100p disabled"});
            $("#_payApprovNo").attr({"disabled" : true , "class" : "w100p disabled"});
            $("#_payCrcType").attr({"disabled" : true , "class" : "w100p disabled"});
            $("#_payCrcMode").attr({"disabled" : true , "class" : "w100p disabled"});
            $("#_payIssueBank").attr({"disabled" : true , "class" : "w100p disabled"});

            //TODO not use
            $("#_payIssueBank").attr({"disabled" : "disabled" , "class" : "w100p disabled"}); // this.cmbCRCMode.Enabled = false;
        } */
	});


    //Wh List
    $("#_cmbWhBrnchIdPop").change(function() {
    	getLocIdByBrnchId($(this).val());
    	$("#_payBrnchCode").val($(this).val());

    	//Clear Grid
    	fn_clearAllGrid();
    });

    //_insPosModuleType Change Func
    $("#_insPosModuleType").change(function() {

    	fn_payFieldClear();

        var tempVal = $(this).val();

        if(tempVal == 2390){ //POS Sales
            var optionSystem = {
                    type: "M",
                    isShowChoose: false
            };
            var systemPopParam = {groupCode : 140 , codeIn : [1352, 1353]};
            CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);
            //PAYMENT TAB DISPLAY
            $("#_purchaseTab").click();
            $("#_payTab").css("display" , "");

            //MEM GRID DISPLAY
            $("#_purchMemBtn").css("display" , "none");
            $("#_mainMemberGrid").css("display" , "none");

            //SERIAL GRID DISPLAY
            $("#_mainSerialGrid").css("display" , "none");

            fn_clearAllGrid();
        }

        if(tempVal == 2391){ //Deduction
        	 var optionSystem = {
                     type: "M",
                     isShowChoose: false
             };
             var systemPopParam = {groupCode : 140 , codeIn : [1352, 1353]};
             CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);
             //PAYMENT TAB DISPLAY
             $("#_purchaseTab").click();
             $("#_payTab").css("display" , "none");

             //MEM GRID DISPLAY
             $("#_purchMemBtn").css("display" , "");
             $("#_mainMemberGrid").css("display" , "");

             //SERIAL GRID DISPLAY
             $("#_mainSerialGrid").css("display" , "none");

             fn_clearAllGrid();
        }

       /*  if(tempVal == 2392){ //Other Income
            var optionSystem = {
                    type: "M",
                    isShowChoose: false
            };
            var systemPopParam = {groupCode : 140 , codeIn : [1358]};
            CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);
             //MEM GRID DISPLAY
            $("#_purchMemBtn").css("display" , "none");
            $("#_mainMemberGrid").css("display" , "none");

            //SERIAL GRID DISPLAY
            $("#_mainSerialGrid").css("display" , "none");

            fn_clearAllGrid();
       } */

    });

    $("#_insPosSystemType").change(function() {

    	//clear Grid
    	fn_clearAllGrid();

    	//
    	$("#_mainSerialGrid").css("display" , "none");

    	//Payment Mode
    	//clear
    	var targetObj = document.getElementById('_payMode');
        for (var i = targetObj.length - 1; i >= 0; i--) {
                targetObj.remove(i);
        }
    	//append Option
    	if( $("#_insPosSystemType").val() == 1352){  //Filter
    		$("#_payMode").append("<option value='105'>Cash</option>");
    		$("#_payMode").append("<option value='108'>Deduct Commission</option>");
    	}else{
    		$("#_payMode").append("<option value='105'>Cash</option>");
    	}
	});

    //Member Search Popup
    $('#memBtnPop').click(function() {
        var callParam = {callPrgm : "1"};
    	Common.popupDiv("/common/memberPop.do", callParam, null, true);
    });

    $('#salesmanPopCd').change(function(event) {

        var memCd = $('#salesmanPopCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd, 1);
        }
    });

    $("#_purcDelBtn").click(function() {

        //1. basketGrid == cheked Items
        var chkDelArray = AUIGrid.getCheckedRowItems(purchaseGridID);
        //2. serialGrid == all Items
        var serialItemArray  = AUIGrid.getColumnValues(serialTempGridID, 'matnr');
        //3. Serial Check
        var delArr = [];
        for (var idx = 0; idx < chkDelArray.length; idx++) {
            for (var i = 0; i < serialItemArray.length; i++) {
                if(chkDelArray[idx].item.stkCode == serialItemArray[i]){
                    delArr.push(i);
                }
            }
        }
        //4. Delete Serial Number
        if(delArr != null && delArr.length > 0){
            AUIGrid.removeRow(serialTempGridID, delArr);
        }

        var serialRowCnt = AUIGrid.getRowCount(serialTempGridID);
        if(serialRowCnt <= 0){
        	$("#_mainSerialGrid").css("display" , "none");
        }
        //5. Remove Check Low
        AUIGrid.removeCheckedRows(purchaseGridID);

        //PayTab Total Charge Text
        var purTotAmt = 0;
        purTotAmt = fn_calcuPurchaseAmt();
        if(chkDelArray == null || chkDelArray.length <= 0){
        	$("#_payTotCharges").html(' ');
        }else{
        	$("#_payTotCharges").html('RM : ' + purTotAmt);
        }


    });

    //Purchase Btn
    $("#_purchBtn").click(function() {

    	//Pos Sales  AND Deduction
    	if($("#_insPosModuleType").val() == 2390 || $("#_insPosModuleType").val() == 2391) {


    		if($("#_insPosModuleType").val() == 2391){

    			var memSize = AUIGrid.getGridData(memGridID);
    			if(memSize == null || memSize.length <= 0){
    				Common.alert('<spring:message code="sal.alert.msg.plzKeyinMemFirst" />');
    				return;
    			}
    		}

    		if($("#_insPosSystemType").val() == 1352){ //Pos Filter / Spare Part / Miscellaneous

    			// 창고 Validation
    			if($("#_cmbWhBrnchIdPop").val() == null || $("#_cmbWhBrnchIdPop").val() == ''){
    				Common.alert('<spring:message code="sal.alert.msg.selectWarehsBrnch" />');
    				return;
    			}
    			if($("#_hidLocId").val() == null || $("#_hidLocId").val() == ''){
    				Common.alert('<spring:message code="sal.alert.msg.warehsHasNoBrnch" />');
                    return;
    			}
    			//창고 parameter
    		//	$("#_cmbWhBrnchIdPop").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    			//
    			$("#_hidInsPosModuleType").val($("#_insPosModuleType").val());
    			$("#_hidInsPosSystemType").val($("#_insPosSystemType").val());
    			Common.popupDiv("/sales/pos/posItmSrchPop.do", $("#_sysForm").serializeJSON(), null, true);
    		}

    	    if($("#_insPosSystemType").val() == 1353){ // Pos Item Bank
    	    //	$("#_cmbWhBrnchIdPop").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    	    	$("#_hidInsPosModuleType").val($("#_insPosModuleType").val());
                $("#_hidInsPosSystemType").val($("#_insPosSystemType").val());
    	    	Common.popupDiv("/sales/pos/posItmSrchPop.do", $("#_sysForm").serializeJSON(), null, true);

            }

		}

    	//Other Income - Item Bank(HQ)
    	if($("#_insPosModuleType").val() == 2392) {

    		if($("#_insPosSystemType").val() == 1358){ //Item Bank(HQ)

    		    // 창고 Validation
                if($("#_cmbWhBrnchIdPop").val() == null || $("#_cmbWhBrnchIdPop").val() == ''){
                    Common.alert('<spring:message code="sal.alert.msg.selectWarehsBrnch" />');
                    return;
                }
                if($("#_hidLocId").val() == null || $("#_hidLocId").val() == ''){
                    Common.alert('<spring:message code="sal.alert.msg.warehsHasNoBrnch" />');
                    return;
                }
                //창고 parameter
            //  $("#_cmbWhBrnchIdPop").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
                $("#_hidInsPosModuleType").val($("#_insPosModuleType").val());
                $("#_hidInsPosSystemType").val($("#_insPosSystemType").val());
                Common.popupDiv("/sales/pos/posItmSrchPop.do", $("#_sysForm").serializeJSON(), null, true);
    		}
    	}
	});


    //Save Request
    $("#_posReqSaveBtn").click(function() {

    	/****Validation ***/
    	//Purchase Grid Null Check
    	if(AUIGrid.getGridData(purchaseGridID) <= 0){
    		Common.alert('<spring:message code="sal.alert.msg.selectItms" />');
    		return;
    	}

    	//Member Grid Null Check
    	if($("#_insPosModuleType").val() == 2391){
    		if(AUIGrid.getGridData(memGridID) <= 0){
                Common.alert('<spring:message code="sal.alert.msg.selectMembers" />');
                return;
            }
    	}

    	//Member Code and Id Null Check
    	if(null == $("#salesmanPopCd").val() || '' == $("#salesmanPopCd").val()){
    		Common.alert('<spring:message code="sal.alert.msg.selectMemCode" />');
    		return;
    	}
    	//Member Check
    	var ajaxOption = {
            async: false,
            isShowLoader : true
        };
    	Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : $("#hiddenSalesmanPopId").val(), memCode : $("#salesmanPopCd").val()}, function(memInfo) {
            if(memInfo == null) {
                Common.alert('<spring:message code="sal.alert.msg.memNotFound" />'+memCode+'</b>');
                return;
            }
        },null,ajaxOption);
    	//Branch WareHouse Null Check
    	if( null == $("#_cmbWhBrnchIdPop").val() || '' == $("#_cmbWhBrnchIdPop").val()){
    		Common.alert('<spring:message code="sal.alert.msg.selectWarehs" />');
    		return;
    	}
    	//Receive Date Null Check
    	if( null == $("#_recvDate").val() || '' == $("#_recvDate").val()){
    		Common.alert('<spring:message code="sal.alert.msg.selectRecevDate" />');
    		return;
    	}
    	// Compare with Todaty?

    	//Remark Null Check
    	if( null == $("#_posRemark").val() || '' == $("#_posRemark").val()){
    		Common.alert('<spring:message code="sal.alert.msg.plzKeyinRemark" />');
    		return;
    	}

    	//TODO payment not Enter
    	/*###############  Payment Validation Part #################################*/

    	if($("#_insPosModuleType").val() == 2390){   //POS SALES
    		/* //Save
            Common.confirm("Will you proceed with payment?", fn_payProceed, fn_payPass); */


            if(null == $("#_payTrIssueDate").val() || '' == $("#_payTrIssueDate").val()){
            	Common.alert('<spring:message code="sal.alert.msg.selectTrIssuedDate" />');
            	$("#_payTrIssueDate").focus();
            	return;
            }
            //Dup Validation
            /*   if (this.txtTotal.Text.Replace("RM", string.Empty) != "0")
            {
                if (string.IsNullOrEmpty(this.cmbPayBranch.SelectedValue))
                {
                    valid = false;
                    message += "* Please select a branch.<br />";
                }
            } */
            if( null == $("#_payBrnchCode").val() || '' == $("#_payBrnchCode").val()){
            	Common.alert('<spring:message code="sal.alert.msg.selectABranch" />');
            	$("#_payBrnchCode").focus();
            	return;
            }


            if(null == $("#_payDebtorAcc").val() ||  '' == $("#_payDebtorAcc").val()){
            	Common.alert('<spring:message code="sal.alert.msg.selectDebAcc" />');
            	return;
            }

            //Charge And Pay
            //
            var payTotAmt = fn_calcuPayAmt();
            var purchTotAmt = fn_calcuPurchaseAmt();

            if( payTotAmt == null || payTotAmt == 0 || purchTotAmt == null || purchTotAmt == 0 || (payTotAmt != purchTotAmt)){
            	Common.alert('<spring:message code="sal.alert.msg.payMethodProhibit" />');
            	return;
            }

            //Save
            fn_payProceed();


    	}else{ //Deduction , Other Income
    		//Save
    		fn_payPass();

    	}
    	/*###############  Payment Validation Part #################################*/

		//, (), ()
	});

    //Member List
    $("#_purchMemBtn").click(function() {


    	if(null == $("#_cmbWhBrnchIdPop").val() || '' == $("#_cmbWhBrnchIdPop").val()){
    		Common.alert("* Please select Warehouse first.");
    		return;
    	}
    	$("#_hidInsPosModuleType").val($("#_insPosModuleType").val());
        $("#_hidInsPosSystemType").val($("#_insPosSystemType").val());
    	Common.popupDiv("/sales/pos/posMemUploadPop.do", $("#_sysForm").serializeJSON(), null , true , '_memDiv');
	});


    //Resize By Tab Click
    $("#_purchaseTab").click(function() {
    	fn_reSizeAllGrid();
    });

    $("#_paymentTab").click(function() {
    	fn_reSizeAllGrid();
    });


    //Add Payment Mode
    $("#_addPayMode").click(function() {

    	//Validation
    	if(null == $("#_payMode").val() || '' == $("#_payMode").val()){
    		Common.alert('<spring:message code="sal.alert.msg.plzSelectPaymMode" />');
    		return;
    	}

    	if(null == $("#_payAmt").val() || '' == $("#_payAmt").val()){
    		Common.alert('<spring:message code="sal.alert.msg.amtCannotBempty" />');
    		return;
    	}

    	if(FormUtil.checkNum($("#_payAmt"))){
    		Common.alert('<spring:message code="sal.alert.msg.plzKeyInNumber" />');
    		return;
    	}

    	if(null == $("#_payBankAccount").val() || '' == $("#_payBankAccount").val()){
    		Common.alert('<spring:message code="sal.alert.msg.plzSelectBankAcc" />');
    		return;
    	}

    	if($("#_payMode") == 107){  //Card Select

    		if(null == $("#_payIssueBank").val() || '' == $("#_payIssueBank").val()){
    			Common.alert('<spring:message code="sal.alert.msg.plzSelectIssuedBank" />');
    			return;
    		}

    		if(null == $("#_payCreditCardNo").val() || '' == $("#_payCreditCardNo").val()){
    		    Common.alert('<spring:message code="sal.alert.msg.plzKeyinCrcNo" />');
    		    return;
    		}else{
    			var crcNo = $("#_payCreditCardNo").val();
    			if(crcNo.length != 16){
    				Common.alert('<spring:message code="sal.alert.msg.crcNoMustbeSisxteenDigit" />');
    				return;
    			}
    		}

    		if(null == $("#_payCrcType").val() || '' == $("#_payCrcType").val()){
    		     Common.alert('<spring:message code="sal.alert.msg.plzSelectCrcType" />');
    		     return;
    		}

    		if (null == $("#_payCrcMode").val() || '' == $("#_payCrcMode").val()) {
				Common.alert('<spring:message code="sal.alert.msg.plzSelectCrcMode" />');
				return;
			}

    		if(null == $("#_payApprovNo").val() || '' == $("#_payApprovNo").val()){
    			Common.alert('<spring:message code="sal.alert.msg.plzKeyinApprovNo" />');
    			return;
    		}else{
    			var tempAppNo = $("#_payApprovNo").val();

    			if(tempAppNo.length != 6){
    				Common.alert('<spring:message code="sal.alert.msg.approvalNoMustbeSixChar" />');
    				return;
    			}
    		}
    	}

    	//Grid Set Data
    	var tempPayObj = {};

    	tempPayObj['payMode']  = $("#_payMode").val();
    	tempPayObj['payModeTxt']  = $("#_payMode :selected").text();
 //   	tempPayObj['payTrRefNo'] = $("#_payTrRefNo").val();
    	tempPayObj['transactionRefNo'] = $("#_transactionRefNo").val();
    	tempPayObj['payAmt'] = $("#_payAmt").val();
    	tempPayObj['payCreditCardNo'] = $("#_payCreditCardNo").val();
    	tempPayObj['payApprovNo'] = $("#_payApprovNo").val();
    	tempPayObj['payCrcMode'] = $("#_payCrcMode").val();
    	tempPayObj['payIssueBank'] = $("#_payIssueBank").val();
    	tempPayObj['payBankAccountTxt'] = $("#_payBankAccount :selected").text();
    	tempPayObj['payBankAccount'] = $("#_payBankAccount").val();
    	tempPayObj['payRefDate'] = $("#_payRefDate").val();
    	tempPayObj['payRem'] = $("#_payRem").val();

    	//not use
    	tempPayObj['payCrcType'] = $("#_payCrcType").val();
    	tempPayObj['payIssueBank'] = $("#_payIssueBank").val();

    	AUIGrid.addRow(paymentGridID, tempPayObj, 'last');

    	var total = 0;
    	total = fn_calcuPayAmt();
    	//total
    	$("#_totalPayAmount").html('Total Pay Amount : <b style="color: red;"> RM : '  + total + '</b>');
	});

    //Clear Pay Grid
    $("#_clearPayGrid").click(function() {
		AUIGrid.clearGridData(paymentGridID);
		var total = 0;
        total = fn_calcuPayAmt();
        //total
        $("#_totalPayAmount").html('Total Pay Amount : <b style="color: red;"> RM : '  + total + '</b>');

	});
});//Document Ready Func End

//Pay Total Amount
function fn_calcuPayAmt(){

	var totArr = [];
    totArr = AUIGrid.getColumnValues(paymentGridID, 'payAmt');

	var totalAmount = 0;
    if(totArr != null && totArr.length > 0){
        for (var idx = 0; idx < totArr.length; idx++) {
            totalAmount += totArr[idx];
        }
    }
    totalAmount = parseFloat(totalAmount).toFixed(2);

    return totalAmount;
}

//Purchase Charge Amount
function fn_calcuPurchaseAmt(){

	var totArr = [];
    totArr = AUIGrid.getColumnValues(purchaseGridID, 'totalAmt');

    var totalAmount = 0;
    if(totArr != null && totArr.length > 0){
        for (var idx = 0; idx < totArr.length; idx++) {
            totalAmount += totArr[idx];
        }
    }
    totalAmount = parseFloat(totalAmount).toFixed(2);

    return totalAmount;
}


function fn_payModeAndBankAccControl(){
	 var memBrnch = $("#_memBrnch").val();
     if(memBrnch == null || memBrnch == ''){
         $("#_payBankAccount").attr({"disabled" : false , "class" : "w100p"});
         var initBankParam = {isCash : "1"};
         CommonCombo.make("_payBankAccount", "/sales/pos/getBankAccountList", initBankParam, '', optionModule);
     }else{
         var accParams = {brnchId : memBrnch};
         var ajaxOpt = { async : false};
         var isResult = false;
         var accResult = '';
         Common.ajax("GET", "/sales/pos/selectAccountIdByBranchId", accParams, function(result){
                 if(result == null || result == ''){
                     isResult = false
                 }else{
                     isResult = true
                     accResult = result.accId + '';
                 }
         }, '', ajaxOpt);    //Call Ajax end

         if(isResult == true){
             $("#_payBankAccount").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
             var initBankParam = {isCash : "1"};
             CommonCombo.make("_payBankAccount", "/sales/pos/getBankAccountList", initBankParam, accResult, optionModule);
         }else{
             $("#_payBankAccount").attr({"disabled" : false , "class" : "w100p"});
             var initBankParam = {isCash : "1"};
             CommonCombo.make("_payBankAccount", "/sales/pos/getBankAccountList", initBankParam, '', optionModule);
         }
     }
}



function fn_payFieldClear(){
	//Filed Clear
    $("#_payBrnchCode").val('');
//    $("#_payTrRefNo").val('');
 //   $("#_payTrIssueDate").val('');
    $("#_payMode").val('');
    $("#_transactionRefNo").val('');
    $("#_payAmt").val('');
    $("#_payCreditCardNo").val('');
    $("#_payCrcType").val('');
    $("#_payCrcMode").val('');
    $("#_payApprovNo").val('');
    $("#_payIssueBank").val('');
    $("#_payBankAccount").val('');
    $("#_payRefDate").val('');
    $("#_payDebtorAcc").val('');
    $("#_payRem").val('');
}

function fn_clearAllGrid(){

    AUIGrid.clearGridData(purchaseGridID);  //purchase TempGridID
    AUIGrid.resize(purchaseGridID , 960, 300);

    AUIGrid.clearGridData(memGridID);  //member TempGridID
    AUIGrid.resize(memGridID , 960, 300);

    AUIGrid.clearGridData(serialTempGridID);  //serial TempGridID
    AUIGrid.resize(serialTempGridID , 960, 300);

    AUIGrid.clearGridData(paymentGridID);  //payment TempGridID
    AUIGrid.resize(paymentGridID , 960, 200);
}

function fn_reSizeAllGrid(){
	AUIGrid.resize(purchaseGridID , 960, 300);
	AUIGrid.resize(memGridID , 960, 300);
	AUIGrid.resize(serialTempGridID , 960, 300);
	AUIGrid.resize(paymentGridID , 960, 200);
}

function fn_setMemberGirdData(paramObj){

	AUIGrid.setGridData(memGridID, paramObj);

}


function fn_payPass(){

	 var data = {};
     var prchParam = AUIGrid.getGridData(purchaseGridID);
     var serialParam = AUIGrid.getGridData(serialTempGridID);
     var memParam = AUIGrid.getGridData(memGridID);

     data.prch = prchParam;
     data.serial = serialParam;
     data.mem = memParam;
	 $("#_payResult").val('-1'); //payment
	 $("#_hidInsPosModuleType").val($("#_insPosModuleType").val());
     $("#_hidInsPosSystemType").val($("#_insPosSystemType").val());
     data.form = $("#_sysForm").serializeJSON();

     Common.ajax("POST", "/sales/pos/insertPos.do", data,function(result){
         Common.alert('<spring:message code="sal.alert.msg.posSavedShowRefNo" arguments="'+result.reqDocNo+'"/>', fn_popClose());
     });

}

function fn_payProceed(){
	var data = {};
    var prchParam = AUIGrid.getGridData(purchaseGridID);
    var serialParam = AUIGrid.getGridData(serialTempGridID);
    var memParam = AUIGrid.getGridData(memGridID);
    var payParam = AUIGrid.getGridData(paymentGridID);

    data.prch = prchParam;
    data.serial = serialParam;
    data.mem = memParam;
    /* payment */
    data.pay = payParam;

    $("#_payResult").val('1');  //payment
    $("#_hidInsPosModuleType").val($("#_insPosModuleType").val());
    $("#_hidInsPosSystemType").val($("#_insPosSystemType").val());
    data.form = $("#_sysForm").serializeJSON();

    /* payment */
    var totAmts = fn_calcuPayAmt();
    $("#_hidTotPayAmt").val(totAmts);
    $("#_hidPayBrnchCode").val($("#_payBrnchCode").val());
    $("#_hidPayDebtorAcc").val($("#_payDebtorAcc").val());

    data.payform = $("#_payForm").serializeJSON();

    Common.ajax("POST", "/sales/pos/insertPos.do", data,function(result){
    	if(result.logError == "000"){

    	    	Common.alert('<spring:message code="sal.alert.msg.posSavedShowRefNo" arguments="'+result.reqDocNo+'" />' , fn_bookingAndpopClose());
    	}
    	else{
    		  Common.alert("fail : Contact Logistics Team")
    	}

    	});
}

//Close
function fn_popClose(){
	$("#_systemClose").click();
}

function fn_bookingAndpopClose(){
    //프로시저 호출
	// 콜백  >>
	$("#_systemClose").click();
}


function getLocIdByBrnchId(tempVal) {

   /*  var tempVal = $(this).val(); */
    if(tempVal == null || tempVal == '' ){
        $("#cmbWhIdPop").val("");
    }else{
        var paramObj = {brnchId : tempVal};
        Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){

            if(result != null){

            	console.log("result.whLocId : " + result.whLocId);

            	$("#cmbWhIdPop").val(result.whLocDesc);
                $("#_hidLocId").val(result.whLocId);
            }else{
                $("#cmbWhIdPop").val('');
                $("#_hidLocId").val('');
            }
        });
    }
}

function createPurchaseGridID(){


    var posColumnLayout =  [
                            {dataField : "stkCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '10%'},
                            {dataField : "stkDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '30%'},
                            {dataField : "qty", headerText : '<spring:message code="sal.title.text.invStock" />', width : '10%'},
                            {dataField : "inputQty", headerText : '<spring:message code="sal.title.qty" />', width : '10%'},
                            {dataField : "amt", headerText : '<spring:message code="sal.title.unitPrice" />', width : '10%' , dataType : "numeric", formatString : "#,##0.00"},
                            {dataField : "subTotal", headerText : '<spring:message code="sal.title.subTotalExclGST" />', width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                            	var calObj = fn_calculateAmt(item.amt , item.inputQty);
                            	return Number(calObj.subChanges);
							}},
                            {dataField : "subChng", headerText : '<spring:message code="sal.title.gstSixPerc" />', width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                            	var calObj = fn_calculateAmt(item.amt , item.inputQty);
                                return Number(calObj.taxes);
                            }},
                            {dataField : "totalAmt", headerText : '<spring:message code="sal.text.totAmt" />', width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                            	var calObj = fn_calculateAmt(item.amt , item.inputQty);
                            	return Number(calObj.subTotal);
                            }},
                            {dataField : "stkTypeId" , visible :false},
                            {dataField : "stkId" , visible :false}//STK_ID
                           ];

    //그리드 속성 설정
    var gridPros = {
            showFooter : true,
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            showRowCheckColumn : true, //checkBox
            softRemoveRowMode : false
    };

    purchaseGridID = GridCommon.createAUIGrid("#item_grid_wrap", posColumnLayout,'', gridPros);  // address list
    AUIGrid.resize(purchaseGridID , 960, 300);

    //
    var footerLayout = [ {
        labelText : "Total(RM)",
        positionField : "#base"
      },{
        dataField : "subTotal",
        positionField : "subTotal",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
      }, {
        dataField : "subChng",
        positionField : "subChng",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
       },{
           dataField : "totalAmt",
           positionField : "totalAmt",
           operation : "SUM",
           formatString : "#,##0.00",
           style : "aui-grid-my-footer-sum-total2"
      }];
//
   // 푸터 레이아웃 그리드에 설정
   AUIGrid.setFooter(purchaseGridID, footerLayout);
}

function createSerialTempGridID(){


var serialGridPros = {

            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            softRemoveRowMode : false,
            showRowCheckColumn : false, //checkBox
            noDataMessage       : "No Item found.",
            groupingMessage     : "Here groupping"
    };

  var serialConfirmlColumnLayout =  [
                             {dataField : "matnr", headerText : '<spring:message code="sal.title.filterCode" />', width : '33%' , editable : false  } ,
                             {dataField : "stkDesc", headerText : '<spring:message code="sal.title.filterName" />', width : '33%' , editable : false },
                             {dataField : "serialNo", headerText : '<spring:message code="sal.title.serial" />', width : '33%' , editable : false },
                             {dataField : "stkId" , visible :true}//STK_ID
                            ];

    serialTempGridID = GridCommon.createAUIGrid("#serialTemp_grid_wrap", serialConfirmlColumnLayout,'', serialGridPros);
    AUIGrid.resize(serialTempGridID , 960, 300);
}


function creatememGridID(){

	var memGridPros = {

            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            softRemoveRowMode : false,
            showRowCheckColumn : false
    };

	var memConfirmlColumnLayout =  [
	                                     {dataField : "memId" , headerText : '<spring:message code="sal.title.memberId" />', width : "20%",  editable : false },
		                                 {dataField : "memCode" , headerText : '<spring:message code="sal.title.memberCode" />', width : "20%",  editable : false },
		                                 {dataField : "name" , headerText : '<spring:message code="sal.title.memberName" />', width : "20%",  editable : false },
		                                 {dataField : "nric" , headerText : '<spring:message code="sal.title.memberNRIC" />', width : "20%",  editable : false },
		                                 {dataField : "code" , headerText : '<spring:message code="sal.text.branch" />', width : "20%",  editable : false },
		                                 {dataField : "brnch" , visible : false},
		                                 {dataField : "memType" , visible : false},
		                                 {dataField : "fullName" , visible : false},
		                                 {dataField : "stus" , visible : false}
	                                 ];

	memGridID = GridCommon.createAUIGrid("#memTemp_grid_wrap", memConfirmlColumnLayout,'', memGridPros);
	AUIGrid.resize(memGridPros , 960, 300);
}

function createPaymentGrid(){
   var payGridPros = {

            usePaging           : true,         //페이징 사용
            pageRowCount        : 5,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
            editable : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            softRemoveRowMode : false,
            showRowCheckColumn : false
    };

   var paymentColumnLayout =  [
                                   {dataField : "payMode", visible : false},
                                   {dataField : "payModeTxt" , headerText : '<spring:message code="sal.title.text.mode" />', width : "10%",  editable : false },
                                   {dataField : "payTrRefNo", visible : false},
                                   {dataField : "transactionRefNo" , headerText : '<spring:message code="sal.title.text.refNo" />', width : "10%",  editable : false },
                                   {dataField : "payAmt" , headerText : '<spring:message code="sal.title.amount" />', width : "10%",  editable : false, dataType : "numeric", formatString : "#,##0.00" },
                                   {dataField : "payCreditCardNo" , headerText : '<spring:message code="sal.title.text.credCard" />', width : "8%",  editable : false },
                                   {dataField : "payApprovNo" , headerText : '<spring:message code="sal.title.text.apprvNo" />', width : "8%",  editable : false },
                                   {dataField : "payCrcMode" , headerText : '<spring:message code="sal.title.text.crcMode" />', width : "8%",  editable : false },
                                   {dataField : "payIssueBank" , headerText : '<spring:message code="sal.title.text.issuedBank" />', width : "8%",  editable : false },
                                   {dataField : "payBankAccountTxt" , headerText : '<spring:message code="sal.text.bankAccNo" />', width : "10%",  editable : false },
                                   {dataField : "payBankAccount", visible : false},//
                                   {dataField : "payRefDate" , headerText : '<spring:message code="sal.title.text.refDate" />', width : "10%",  editable : false },
                                   {dataField : "payRem" , headerText : '<spring:message code="sal.title.remark" />', width : "10%",  editable : false },
                                   {
                                       dataField : "undefined",
                                       headerText : " ",
                                       width : '8%',
                                       renderer : {
                                                type : "ButtonRenderer",
                                                labelText : "Delete",
                                                editable : false,
                                                onclick : function(rowIndex, columnIndex, value, item) {
                                                	AUIGrid.removeRow(paymentGridID, rowIndex);
                                                	var total = 0;
                                                    total = fn_calcuPayAmt();
                                                    //total
                                                    $("#_totalPayAmount").html('Total Pay Amount : <b style="color: red;"> RM : '  + total + '</b>');
                                                }
                                       }
                                   },
                                   //not used
                                   {dataField : "payCrcType", visible : false},
                                   {dataField : "payIssueBank", visible : false},

                                   {dataField : "payIssueBank", visible : false}

                               ];

   paymentGridID = GridCommon.createAUIGrid("#payment_grid_wrap", paymentColumnLayout,'', payGridPros);
   AUIGrid.resize(payGridPros , 960, 300);
}
//posItmSrchPop -> posSystemPop
function getItemListFromSrchPop(itmList, serialList){
	AUIGrid.setGridData(purchaseGridID, itmList);

	var purTotAmt = 0;
	purTotAmt = fn_calcuPurchaseAmt();
	$("#_payTotCharges").html('RM : ' + purTotAmt);

	AUIGrid.setGridData(serialTempGridID, serialList);
}

function fn_calculateAmt(amt, qty) {

    var subTotal = 0;
    var subChanges = 0;
    var taxes = 0;

    subTotal = amt * qty;
    subChanges = (subTotal * 100) / 100;
    subChanges = subChanges.toFixed(2); //소수점2반올림
    taxes = subTotal - subChanges;
    taxes = taxes.toFixed(2);

    var retObj = {subTotal : subTotal , subChanges : subChanges , taxes : taxes};

    return retObj;

}

var prev = "";
var regexp = /^\d*(\.\d{0,2})?$/;

function fn_inputAmt(obj){

	if(obj.value.search(regexp) == -1){
		obj.value = prev;
	}else{
		prev = obj.value;
	}


}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<input type="hidden" id="_memBrnch" value="${memCodeMap.brnch}">


<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.posRequest" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_systemClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue2"><a id="_purchBtn"><spring:message code="sal.title.text.purchItems" /></a></p></li>
    <li><p class="btn_blue2" ><a id="_purchMemBtn" style="display: none;"><spring:message code="sal.title.text.memList" /></a></p></li>
    <li><p class="btn_blue2"><a id="_posReqSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.plzSelectPosType" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.posType" /></th>
    <td>
    <select class="w100p" id="_insPosModuleType" ></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.posSalesType" /></th>
    <td>
    <select class="w100p" id="_insPosSystemType" ></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" id="_purchaseTab"><spring:message code="sal.title.text.purcInfo" /></a></li>
    <li id="_payTab"><a id="_paymentTab"><spring:message code="sal.text.payMode" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.particInfo" /></h2>
</aside><!-- title_line end -->

<form id="_sysForm">
<!-- HIDDEN VALUES -->
<input type="hidden" name="hidLocId" id="_hidLocId" value="${locMap.whLocId }">
<input type="hidden" name="posReason" id="_posReason">
<input type="hidden" name="payResult" id="_payResult">

<!-- MODULE & SYSTEM -->
<input type="hidden" name="insPosModuleType" id="_hidInsPosModuleType">
<input type="hidden" name="insPosSystemType" id="_hidInsPosSystemType">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:230px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
	        <input id="salesmanPopCd" name="salesmanPopCd" type="text" title="" placeholder="" class="w100p"  value="${memCodeMap.memCode}"/>
	        <input id="hiddenSalesmanPopId" name="salesmanPopId" type="hidden"  value="${memCodeMap.memId}"/>
	        <a id="memBtnPop" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </div>
    </td>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.brnchWarehouse" /></th>
    <td><select  id="_cmbWhBrnchIdPop" name="cmbWhBrnchIdPop" class="w100p"></select></td>
    <td style="padding-left:0"><input type="text" disabled="disabled" id="cmbWhIdPop"  value="${locMap.whLocDesc}"></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.recvDate" /></th>
    <td colspan="2">
        <input type="text" title="기준년월" class="j_date w100p" placeholder="MM/YYYY" readonly="readonly"  id="_recvDate" name="recvDate"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td colspan="2">
        <input type="text" title="" placeholder="" class="w100p" id="_posRemark" name="posRemark" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.chargeBal" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a id="_purchBtn">Purchase Items</a></p></li>
    <li><p class="btn_grid" ><a id="_purchMemBtn" style="display: none;">Member List</a></p></li> -->
    <li><p class="btn_grid"><a id="_purcDelBtn"><spring:message code="sal.btn.del" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<div id="_mainSerialGrid" style="display: none;">
<aside class="title_line"><!-- title_line start -->
<h2>Serial List</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="serialTemp_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article>
</div>

<div id="_mainMemberGrid" style="display: none;">
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.memList" /></h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="memTemp_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article>
</div>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.paymInfo" /></h2>
</aside><!-- title_line end -->

<form id="_payForm">
<!-- pay Hidden Value  -->
<input type="hidden" id="_hidTotPayAmt" name="hidTotPayAmt">
<input type="hidden" id="_hidPayBrnchCode" name="payBrnchCode">
<input type="hidden" id="_hidPayDebtorAcc" name="payDebtorAcc">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
<th><spring:message code="sal.title.text.totCharges" /></th>
<td colspan="5" id="_payTotCharges"></td>
</tr>
<tr>
<th><spring:message code="sal.title.text.brnchCode" /></th>
<td>
    <select class="w100p disabled" id="_payBrnchCode"  disabled="disabled"></select>
</td>
<th><spring:message code="sal.title.text.trRefNo" /></th>
<td><input type="text" title="" placeholder="TR Ref No." class="w100p" id="_payTrRefNo" name="payTrRefNo"  maxlength="10"/></td>
<th><spring:message code="sal.title.text.trIssueDate" /></th>
<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="_payTrIssueDate"  name="payTrIssueDate" readonly="readonly"/></td>
</tr>
<tr>
<th><spring:message code="sal.text.payMode" /></th>
<td>
    <select class="w100p" id="_payMode" name="payMode">
        <option value="105"><spring:message code="sal.combo.text.cash" /></option>
        <option value="108"><spring:message code="sal.combo.text.deduction" /></option>
    </select>
</td>
<th><spring:message code="sal.title.text.transacRefNo" /></th>
<td><input type="text" title="" placeholder="Transaction Ref No." class="w100p" id="_transactionRefNo" name="transactionRefNo" /></td>
<th><spring:message code="sal.title.amount" /></th>
<td><input type="text" title="" placeholder="" class="w100p" id="_payAmt" name="payAmt" onkeyup="fn_inputAmt(this)" /></td>
</tr>
<tr>
<th><spring:message code="sal.text.creditCardNo" /></th>
<td><input type="text" title="" placeholder="Credit Card No." class="w100p disabled" id="_payCreditCardNo" name="payCreditCardNo" disabled="disabled"/></td>
<th><spring:message code="sal.title.text.crcType" /></th>
<td>
    <select class="w100p disabled"  id="_payCrcType" name="payCrcType" disabled="disabled"></select>
</td>
<th><spring:message code="sal.title.text.crcMode" /></th>
<td>
    <select class="w100p disabled" id="_payCrcMode" name="payCrcMode" disabled="disabled">
        <option value="" disabled="disabled" selected="selected"></option>
        <option value="1"><spring:message code="sal.combo.text.online" /></option>
        <option value="0"><spring:message code="sal.combo.text.offline" /></option>
    </select>
</td>
</tr>
<tr>
<th><spring:message code="sal.title.text.apprvNo" /></th>
<td><input type="text" title="" placeholder="Credit Card No." class="w100p disabled" id="_payApprovNo" name="payApprovNo" disabled="disabled"/></td>
<th><spring:message code="sal.text.issueBank" /></th>
<td>
    <select class="w100p disabled" id="_payIssueBank" name="payIssueBank"  disabled="disabled"></select>
</td>
<th><spring:message code="sal.title.text.bankAccount" /></th>
<td>
    <select class="w100p" id="_payBankAccount" name="payBankAccount"></select>
</td>
</tr>
<tr>
<th><spring:message code="sal.title.text.refDate" /></th>
<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="_payRefDate" name="payRefDate"  readonly="readonly"/></td>
<th><spring:message code="sal.title.debtorAcc" /></th>
<td>
    <select class="w100p"  id="_payDebtorAcc"  disabled="disabled"></select>
</td>
<th></th>
<td></td>
</tr>
<tr>
<th><spring:message code="sal.title.remark" /></th>
<td colspan="5"><textarea cols="20" rows="5" placeholder="" id="_payRem" name="payRem"></textarea></td>
</tr>

</tbody>
</table><!-- table end -->
</form>
<ul class="right_btns">
    <li><p class="btn_grid"><a  id="_addPayMode"><spring:message code="sal.title.text.addPaymMode" /></a></p></li>
    <li><p class="btn_grid"><a id="_clearPayGrid"><spring:message code="sal.title.text.clearAll" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="payment_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<span class="bold_text mt10" id="_totalPayAmount"><spring:message code="sal.title.text.totPayAmt" /></span>

</article><!-- tap_area end -->
</section><!-- tap_wrap start -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->