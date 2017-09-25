<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    
    var ORD_ID        = '${salesOrderId}';
    var ORD_NO        = '${salesOrderNo}';
    var CUST_ID       = '${custId}';
    var APP_TYPE_ID   = '${appTypeId}';
    var APP_TYPE_DESC = '${appTypeDesc}';
    var TAB_NM        = '${ordEditType}';
    var CUST_NRIC     = '${custNric}';
    
    var option = {
		winName    : "popup",
        width      : "1200px", //창 가로 크기
        height     : "400px",  //창 세로 크기
       	resizable  : "yes",    //창 사이즈 변경. (yes/no)(default : yes)
        scrollbars : "no"      //스크롤바. (yes/no)(default : yes)
    };
    
    $(document).ready(function(){
        doGetComboData('/common/selectCodeList.do', {groupCode :'335'}, TAB_NM, 'ordEditType', 'S'); //Order Edit Type
        doGetComboSepa('/common/selectBranchCodeList.do', '1', ' - ', '', 'modKeyInBranch', 'S'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', '', 'dscBrnchId',     'S'); //Branch Code
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '', 'rentPayMode', 'S', ''); //Common Code
        
        if(FormUtil.isNotEmpty(TAB_NM)) {
            fn_changeTab(TAB_NM);
        }
    });
    
    $(function(){
        $('#btnEditType').click(function() {
            var tabNm = $('#ordEditType').val();
            
            fn_changeTab(tabNm);
        });
        $('#btnSaveBasicInfo').click(function() {            
            if(!fn_validBasicInfo()) return false;            
            fn_doSaveBasicInfo();
        });
        $('#btnSaveMailingAddress').click(function() {            
            if(!fn_validMailingAddress()) return false;            
            fn_doSaveMailingAddress();
        });
        $('#btnSaveCntcPerson').click(function() {            
            if(!fn_validCntcPerson()) return false;
            fn_doSaveCntcPerson();
        });
        $('#btnSaveNric').click(function() {            
            if(fn_validNric()) fn_doSaveNric();
        });
        $('#btnSaveInstInfo').click(function() {            
            if(!fn_validInstallInfo()) return false;
            fn_doSaveInstallInfo();
        });
        $('#btnSalesmanPop').click(function() {
            Common.popupDiv("/common/memberPop.do", { callPrgm : "ORD_MODIFY_BSC_INF" }, null, true);
        });
        $('#modSalesmanCd').change(function() {
            fn_loadOrderSalesman(null, $('#modSalesmanCd').val())
        });
        $('#btnBillNewAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : CUST_ID, callParam : "ORD_MODIFY_MAIL_ADR"}, null , true);
        });
        $('#btnBillSelAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : CUST_ID, callPrgm : "ORD_MODIFY_MAIL_ADR"}, null, true);
        });
        $('#btnInstNewAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : CUST_ID, callParam : "ORD_MODIFY_INST_ADR"}, null , true);
        });
        $('#btnInstSelAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : CUST_ID, callPrgm : "ORD_MODIFY_INST_ADR"}, null, true);
        });
        //Payment Channel - Add New Bank Account
        $('#btnAddBankAccount').click(function() {
            Common.popupDiv("/sales/customer/customerBankAccountAddPop.do", {custId : CUST_ID}, null, true);
        });
        //Payment Channel - Select Another Bank Account
        $('#btnSelBankAccount').click(function() {
            Common.popupDiv("/sales/customer/customerBankAccountSearchPop.do", {custId : CUST_ID, callPrgm : "ORD_MODIFY_BANK_ACC"});
        });
        //Payment Channel - Add New Credit Card
        $('#addCreditCardBtn').click(function() {
            Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : CUST_ID}, null, true);
        });
        //Payment Channel - Select Another Credit Card
        $('#selCreditCardBtn').click(function() {
            Common.popupDiv("/sales/customer/customerCreditCardSearchPop.do", {custId : CUST_ID, callPrgm : "ORD_MODIFY_PAY_CHAN"}, null, true);
        });
        $('#btnNewCntc').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewContactPop.do", {custId: CUST_ID, callParam : "ORD_MODIFY_CNTC_OWN"}, null , true);
        });
        $('#btnSelCntc').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : CUST_ID, callPrgm : "ORD_MODIFY_CNTC_OWN"}, null, true);
        });
        $('#btnInstNewCntc').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewContactPop.do", {custId: CUST_ID, callParam : "ORD_MODIFY_INST_CNTC"}, null , true);
        });
        $('#btnInstSelCntc').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : CUST_ID, callPrgm : "ORD_MODIFY_INST_CNTC"}, null, true);
        });
        $('#chkRejectDate').click(function() {
            
            var isChk = $('#chkRejectDate').is(":checked");
            
            fn_clearControlReject();
            
            if(isChk) $('#chkRejectDate').prop("checked", true);
            
            if(isChk) {
                if($("#rentPayMode option:selected").index() <= 0) {
                    $("#chkRejectDate").prop("checked", false);
                    Common.alert("Rental Paymode Required" + DEFAULT_DELIMITER + "<b>Please select the rental payment mode first.</b>");
                }
                else {
                    $('#spRjctDate').text("*");
                    $('#spRejectReason').text("*");
                    $('#modStartDate').prop("disabled", true);
                    $('#modRejectDate').removeAttr("disabled");
                    $('#modRejectReason').removeAttr("disabled");
                }
            }
        });
        $('#thrdParty').click(function() {

            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();
            fn_clearControlReject();

            $('#modApplyDate').val(${toDay});
            $('#modSubmitDate').val('');
            $('#modStartDate').val('');
            $('#rentPayMode').val('');
            
            if($('#thrdParty').is(":checked")) {
                $('#scPC_ThrdParty').removeClass("blind");
            }
        });
        $('#thrdPartyId').change(function(event) {
            
            var InputCustID = 0;
            
            if(FormUtil.isNotEmpty($('#thrdPartyId').val())) {
                InputCustID = $('#thrdPartyId').val();
            }
            
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();
            fn_clearControlReject();
            
            $('#modApplyDate').val(${toDay});
            $('#modSubmitDate').val('');
            $('#modStartDate').val('');
            $('#rentPayMode').val('');
            
            if(InputCustID != CUST_ID) {
                fn_loadThirdParty(InputCustID, 2);
            }
            else {
                Common.alert("Invalid Third Party ID" + DEFAULT_DELIMITER + "<b>Invalid third party ID.</b>");
            }
        });
        $('#rentPayMode').change(function(event) {
            if($('#rentPayMode').val() == '133' || $('#rentPayMode').val() == '134') {
                Common.alert("Rental Paymode Restriction" + DEFAULT_DELIMITER + "<b>Currently we are not provide [" + $("#rentPayMode option:selected").text() + "] service.</b>");
                $('#rentPayMode').val('');
            }
            else {
                if($('#rentPayMode').val() == '131') {
                    if($('#thrdParty').is(":checked")) {
                        if(FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert("Third Party Required" + DEFAULT_DELIMITER + "<b>Please select the third party first.</b>");
                            $('#rentPayMode').val('');
                        }
                        else {
                            $('#scPC_CrCard').removeClass("blind");
                        }
                    }
                    else {
                        $('#scPC_CrCard').removeClass("blind");
                    }
                }
                else if($('#rentPayMode').val() == '132') {
                    if($('#thrdParty').is(":checked")) {
                        if(FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert("Third Party Required" + DEFAULT_DELIMITER + "<b>Please select the third party first.</b>");
                            $('#rentPayMode').val('');
                        }
                        else {
                            $('#scPC_DirectDebit').removeClass("blind");
                        }
                    }
                    else {
                        $('#scPC_DirectDebit').removeClass("blind");
                    }
                }
                
                fn_loadRejectReasonList($('#rentPayMode').val(), 0)
            }
        });
    });
    
    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPayMode() {
        $('#rentPayModeForm').clearForm();
    }
    
    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPay3thParty() {
        $('#scPC_ThrdParty').addClass("blind");
        $('#thrdPartyForm').clearForm();
    }

    //ClearControl_RentPaySet_DD
    function fn_clearRentPaySetDD() {
        $('#scPC_DirectDebit').addClass("blind");
        
        $("#hiddenRentPayBankAccID").val('');
        $("#rentPayBankAccNo").text('');
        $("#rentPayBankAccNoEncrypt").val('');
        $("#rentPayBankAccType").text('');
        $("#accName").text('');
        $("#accBranch").text('');
        $("#accBank").text('');
        $("#hiddenAccBankId").val('');
    }

    //ClearControl_RentPaySet_CRC
    function fn_clearRentPaySetCRC() {
        $('#scPC_CrCard').addClass("blind");
        
        $("#hiddenRentPayCRCId").val('');
        $("#rentPayCRCNo").text('');
        $("#hiddenRentPayEncryptCRCNo").val('');
        $("#rentPayCRCType").text('');
        $("#rentPayCRCName").text('');
        $("#rentPayCRCExpiry").text('');
        $("#rentPayCRCBank").text('');
        $("#hiddenRentPayCRCBankId").val('');
        $("#rentPayCRCCardType").text('');
    }
    
    function fn_clearControlReject() {
        $("#chkRejectDate").prop("checked", false);
        $('#spRjctDate').text("");
        $('#spRejectReason').text("");
        $('#modStartDate').val('').removeAttr("disabled");
        $('#modRejectDate').val('').prop("disabled", true);
        $('#modRejectReason').val('').prop("disabled", true);
    }
    
    function fn_loadMailAddr(custAddId){
        console.log("fn_loadMailAddr START");

        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(billCustInfo) {

            if(billCustInfo != null) {

                console.log("성공.");
                console.log("hiddenBillAddId : " + billCustInfo.custAddId);

                $("#modNewAddress").text(billCustInfo.fullAddress);
                $("#modCustAddId").val(billCustInfo.custAddId);
                
                Common.alert("Address Selected" + DEFAULT_DELIMITER + "<b>New address selected.<br />Click save to confirm change address.</b>");
            }
        });
    }
    
    function fn_loadOrderSalesman(memId, memCode) {

        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);

        fn_clearOrderSalesman();

        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

            if(memInfo == null || memInfo == 'undefined') {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCd+'</b>');
            }
            else {
                $('#modSalesmanId').val(memInfo.memId);
                $('#modSalesmanCd').val(memInfo.memCode);
                $('#modSalesmanType').val(memInfo.codeName);
                $('#modSalesmanTypeId').val(memInfo.memType);
                $('#modSalesmanName').val(memInfo.name);
                $('#modSalesmanIc').val(memInfo.nric);
                $('#modOrderDeptCode').val(memInfo.deptCode);
                $('#modDeptMemId').val(memInfo.lvl3UpId);
                $('#modOrderGrpCode').val(memInfo.grpCode);
                $('#modGrpMemId').val(memInfo.lvl2UpId);
                $('#modOrderOrgCode').val(memInfo.orgCode);
                $('#modOrgMemId').val(memInfo.lvl1UpId);
            }
        });
    }
    
    function isEditableNRIC() {
        var isEditable;
        
        Common.ajax("GET", "/sales/order/checkNricEdit.do", {custId : CUST_ID}, function(result) {

            if(result != null) {
                console.log('result.isEditable:'+result.isEditable);

                isEditable = result.isEditable;

                if(isEditable == false) {
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>Customer NRIC/Company No. for Customer ID : " + CUST_ID + " is disallowed to edit.</b>");
                }

                return isEditable;
            }
        });
    }
    
    function fn_changeTab(tabNm) {
        
        if(tabNm == 'NRC' && isEditableNRIC() == false) {
            return false;
        }

        if(tabNm == 'PAY' && APP_TYPE_ID != '66' && APP_TYPE_ID != '1412') {
            var msg = "[" + ORD_NO + "] is [" + APP_TYPE_DESC + "] order.<br />"
                    + "Only rental order is allow to edit rental pay setting.";
                    
            Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
                
            return false;
        }
 
        var vTit = 'Order Edit';
        
        if($("#ordEditType option:selected").index() > 0) {
            vTit += ' - '+$('#ordEditType option:selected').text();
        }
                
        $('#hTitle').text(vTit);

        if(tabNm == 'BSC') {
            $('#scBI').removeClass("blind");
            $('#aTabMI').click();
            fn_loadUpdateInfo(ORD_ID);
        } else {
            $('#scBI').addClass("blind");
        }
        if(tabNm == 'MAL') {
            $('#scMA').removeClass("blind");
            $('#aTabMA').click();
            fn_loadBillGrpMailAddr(ORD_ID);
        } else {
            $('#scMA').addClass("blind");
        }
        if(tabNm == 'CNT') {
            $('#scCP').removeClass("blind");
            $('#aTabMA').click();
            fn_loadBillGrpCntcPerson(ORD_ID);
        } else {
            $('#scCP').addClass("blind");
        }
        if(tabNm == 'NRC') {
            $('#scIC').removeClass("blind");
            $('#aTabCI').click();
            fn_loadNric(CUST_ID);
        } else {
            $('#scIC').addClass("blind");
        }
        if(tabNm == 'INS') {
            $('#scIN').removeClass("blind");
            $('#aTabMI').click();
            fn_loadInstallInfo(ORD_ID);
        } else {
            $('#scIN').addClass("blind");
        }
         if(tabNm == 'PAY') {
            $('#scPC').removeClass("blind");
            $('#aTabMI').click();
            fn_loadRentPaySetInfo(ORD_ID);
        } else {
            $('#scPC').addClass("blind");
        }
    }

    function fn_loadRentPaySetInfo(ordId){
        console.log("fn_loadRentPaySetInfo START");

        Common.ajax("GET", "/sales/order/selectRentPaySetInfo.do", {salesOrderId : ordId}, function(rsltInfo) {

            if(rsltInfo != null) {
                
                if(rsltInfo.is3Party == '1') {
                    $("#thrdParty").attr("checked", true);
                    $('#scPC_ThrdParty').removeClass("blind");
                    fn_loadThirdParty(rsltInfo.payerCustId, 1);
                }
                
                $("#rentPayMode").val(rsltInfo.payModeId);
                
                if(rsltInfo.payModeId == '131') {
                    $('#scPC_CrCard').removeClass("blind");
                    fn_loadCreditCard(rsltInfo.crcId);
                }
                else if(rsltInfo.payModeId == '132') {
                    $('#scPC_DirectDebit').removeClass("blind");
                    fn_loadBankAccount(rsltInfo.bankAccId);
                }
                
                $('#rentPayIC').val(rsltInfo.oldIc);
                if(rsltInfo.rentPayApplyDt  != '01/01/1900') $('#modApplyDate').val(rsltInfo.rentPayApplyDt);
                if(rsltInfo.rentPaySubmitDt != '01/01/1900') $('#modSubmitDate').val(rsltInfo.rentPaySubmitDt);
                if(rsltInfo.rentPayStartDt  != '01/01/1900') $('#modStartDate').val(rsltInfo.rentPayStartDt);
                
                if(rsltInfo.rentPayRejctDt  != '01/01/1900') {
                    $('#spRjctDate').text("*");
                    $('#spRejectReason').text("*");
                    $('#modRejectDate').val(rsltInfo.rentPayRejctDt);
                    $('#modRejectDate').removeAttr("disabled");
                    $('#modStartDate').val("").prop("disabled", true);
                    $('#modRejectReason').removeAttr("disabled");
                }
                
                $('#modPayTerm').val(rsltInfo.payTrm);
                
                fn_loadRejectReasonList(rsltInfo.payModeId, rsltInfo.failResnId)
            }
        });
    }
    
    function fn_loadRejectReasonList(paymodeId, failReasonId) {
        
        var typeId = 0, separator = ' - ';
        
        if(paymodeId == '131') {
            typeId = 168;
        }
        else if(paymodeId == '132') {
            typeId = 170;
        }
        
        doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : typeId, inputId : failReasonId, separator : separator}, '', 'modRejectReason', 'S'); //Reason Code
    }

    function fn_loadThirdPartyPop(InputCustID) {

            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();
            fn_clearControlReject();
            
            $('#modApplyDate').val(${toDay});
            $('#modSubmitDate').val('');
            $('#modStartDate').val('');
            $('#rentPayMode').val('');
            
            if(InputCustID != CUST_ID) {
                fn_loadThirdParty(InputCustID, 1);
            }
            else {
                Common.alert("Third party and customer cannot be same person/company.<br/>Your input third party ID : "
                    + InputCustID + DEFAULT_DELIMITER + "<b>Invalid third party ID.</b>");
            }
    }

    function fn_loadThirdParty(custId, sMethd) {

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {

            if(result != null && result.length == 1) {

                var custInfo = result[0];

                $('#hiddenThrdPartyId').val(custInfo.custId);
                $('#thrdPartyId').val(custInfo.custId);
                $('#thrdPartyType').val(custInfo.codeName1);
                $('#thrdPartyName').val(custInfo.name);
                $('#thrdPartyNric').val(custInfo.nric);
            }
            else {
                if(sMethd == 2) {
                    Common.alert('<b>Third party not found.<br/>Your input third party ID : ' + custId + '</b>'
                        + InputCustID + DEFAULT_DELIMITER + "Third Party Not Found");
                }
            }
        });

        $('#sctThrdParty').removeClass("blind");
    }

    function fn_loadCreditCardPop(crcId) {
        console.log("fn_loadCreditCardPop START");
        //hiddenRentPayCRCId
        fn_clearRentPaySetCRC();
        fn_loadCreditCard(crcId);        
        $('#scPC_CrCard').removeClass("blind");
        
        fn_clearControlReject();
        $('#modApplyDate').val(${toDay});
        $('#modSubmitDate').val('');
        $('#modStartDate').val('');
    }
    
    function fn_loadCreditCard(custCrcId) {
        console.log("fn_loadCreditCard START");

        Common.ajax("GET", "/sales/order/selectCustomerCreditCardDetailView.do", {getparam : custCrcId}, function(rsltInfo) {
            if(rsltInfo != null) {
                $("#hiddenRentPayCRCId").val(rsltInfo.custCrcId);
                $("#rentPayCRCNo").text(rsltInfo.decryptCRCNoShow);
                $("#hiddenRentPayEncryptCRCNo").val(rsltInfo.custCrcNo);
                $("#rentPayCRCType").text(rsltInfo.code);
                $("#rentPayCRCName").text(rsltInfo.custCrcOwner);
                $("#rentPayCRCExpiry").text(rsltInfo.custCrcExpr);
                $("#rentPayCRCBank").text(rsltInfo.bankCode + ' - ' + rsltInfo.bankId);
                $("#hiddenRentPayCRCBankId").val(rsltInfo.custCrcBankId);
                $("#rentPayCRCCardType").text(rsltInfo.codeName);
            }
        });
    }
    
    function fn_loadBankAccountPop(bankAccId) {
        fn_clearRentPayMode();
        fn_loadBankAccount(bankAccId);
        
        $('#scPC_DirectDebit').removeClass("blind");
        
        fn_clearControlReject();
        
        $('#modApplyDate').val('');
        $('#modSubmitDate').val('');
        $('#modStartDate').val('');
        $('#rentPayMode').val('');
        
        if(!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $('#rentPayBankAccNo').val())) {
            fn_clearRentPaySetDD();
            $('#scPC_DirectDebit').removeClass("blind");
            Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER + "<b>Invalid account for auto debit.</b>");
        }
    }
    
    function fn_loadBankAccount(bankAccId) {
        console.log("fn_loadBankAccount START");
        
        Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

            if(rsltInfo != null) {
                $("#hiddenRentPayBankAccID").val(rsltInfo.custAccId);
                $("#rentPayBankAccNo").text(rsltInfo.custAccNo);
                $("#rentPayBankAccNoEncrypt").val(rsltInfo.custEncryptAccNo);
                $("#rentPayBankAccType").text(rsltInfo.codeName);
                $("#accName").text(rsltInfo.custAccOwner);
                $("#accBranch").text(rsltInfo.custAccBankBrnch);
                $("#accBank").text(rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
                $("#hiddenAccBankId").val(rsltInfo.custAccBankId);
            }
        });
    }
    
    function fn_loadInstallInfo(ordId){
        console.log("fn_loadInstallInfo START");

        Common.ajax("GET", "/sales/order/selectInstallInfo.do", {salesOrderId : ordId}, function(instInfo) {

            if(instInfo != null) {
                $("#modInstallId").val(instInfo.installId);
                $("#dscBrnchId").val(instInfo.dscId);
                $("#modPreferInstDt").val(instInfo.preferInstDt);
                $("#modPreferInstTm").val(instInfo.preferInstTm);
                $("#modInstct").val(instInfo.instct);
                
                fn_loadInstallAddrInfo(instInfo.installAddrId);
                fn_loadInstallCntcInfo(instInfo.installCntcId);
            }
        });
    }
    
    function fn_loadInstallAddrInfo(custAddId){
        console.log("fn_loadInstallAddrInfo START");

        Common.ajax("GET", "/sales/order/selectInstallAddrInfo.do", {custAddId : custAddId}, function(addrInfo) {

            if(addrInfo != null) {

                $("#modInstAddrDtl").text(addrInfo.addrDtl);
                $("#modInstStreet").text(addrInfo.street);
                $("#modInstArea").text(addrInfo.area);
                $("#modInstCity").text(addrInfo.city);
                $("#modInstPostCd").text(addrInfo.postcode);
                $("#modInstState").text(addrInfo.city);
                $("#modInstCnty").text(addrInfo.country);

                $("#modInstAreaId").val(addrInfo.areaId);
                $("#modInstCustAddId").val(addrInfo.custAddId);
                $("#modInstCustAddIdOld").val(addrInfo.custAddId);
            }
        });
    }
    
    function fn_loadInstallAddrInfo2(custAddId){
        console.log("fn_loadInstallAddrInfo START");

        Common.ajax("GET", "/sales/order/selectInstallAddrInfo.do", {custAddId : custAddId}, function(addrInfo) {

            if(addrInfo != null) {

                $("#modInstAddrDtl").text(addrInfo.addrDtl);
                $("#modInstStreet").text(addrInfo.street);
                $("#modInstArea").text(addrInfo.area);
                $("#modInstCity").text(addrInfo.city);
                $("#modInstPostCd").text(addrInfo.postcode);
                $("#modInstState").text(addrInfo.city);
                $("#modInstCnty").text(addrInfo.country);
                
                $("#modInstCustAddId").val(addrInfo.custAddId);
            }
        });
    }
    
    function fn_checkInstallResult(ordId){
        Common.ajax("GET", "/sales/order/selectInstRsltCount.do", {salesOrdId : ordId}, function(rsltInfo) {
            if(rsltInfo != null) {
                console.log('fn_checkInstallResult:'+rsltInfo.cnt);
                return rsltInfo.cnt;
            }
        }, null, {async : false});
    }
    
    function fn_checkGSTZRLocation(areaId){
        Common.ajax("GET", "/sales/order/selectGSTZRLocationCount.do", {areaId : areaId}, function(rsltInfo) {
            if(rsltInfo != null) {
                console.log('fn_checkGSTZRLocation:'+rsltInfo.cnt);
                return rsltInfo.cnt;
            }
        }, null, {async : false});
    }
    
    function fn_checkGSTZRLocationByAddrId(custAddId){
        Common.ajax("GET", "/sales/order/selectGSTZRLocationByAddrIdCount.do", {custAddId : ordId}, function(rsltInfo) {
            if(rsltInfo != null) {
                console.log('fn_checkGSTZRLocationByAddrId:'+rsltInfo.cnt);
                return rsltInfo.cnt;
            }
        }, null, {async : false});
    }
    
    function fn_loadInstallAddrInfoNew(custAddId){
        console.log("fn_loadInstallAddrInfoNew START");
        
        $("#modInstCustAddId").val(custAddId);
        
        var addrIdOld = $("#modInstCustAddIdOld").val();            
        var addrIdNew = $("#modInstCustAddId").val();            
            
        if(APP_TYPE_ID == '67' || APP_TYPE_ID == '68') {
                        
            if(fn_checkInstallResult(ORD_ID) == 0) {
                
                if(fn_checkGSTZRLocation($("#modInstAreaId").val()) > 0) {
                    
                    if(fn_checkGSTZRLocationByAddrId(addrIdOld) > 0) {                        
                        $("#modInstCustAddIdOld").val(addrIdNew);
                        fn_loadInstallAddrInfo2(addrIdNew);
                    }
                    else {
                        Common.alert("Changed Failed" + DEFAULT_DELIMITER + "<b>Zero Rate Area cannot change to Non-Zero Rate Area.</b>");
                    }
                }
                else {
                    if(fn_checkGSTZRLocationByAddrId(addrIdOld) > 0) {
                        Common.alert("Changed Failed" + DEFAULT_DELIMITER + "<b>Non-Zero Rate Area cannot change to Zero Rate Area.</b>");
                    }
                    else {
                        $("#modInstCustAddIdOld").val(addrIdNew);
                        fn_loadInstallAddrInfo2(addrIdNew);
                    }
                }
            }
            else {
                $("#modInstCustAddIdOld").val(addrIdNew);
                fn_loadInstallAddrInfo2(addrIdNew);
            }
        }
        else {
            $("#modInstCustAddIdOld").val(addrIdNew);
            fn_loadInstallAddrInfo2(addrIdNew);
        }        
    }
    
    function fn_loadInstallCntcInfo(custCntcId){
        console.log("fn_loadInstallCntcInfo START");

        Common.ajax("GET", "/sales/order/selectInstallCntcInfo.do", {custCntcId : custCntcId}, function(cntcInfo) {

            if(cntcInfo != null) {
                $("#modInstCntcName").text(cntcInfo.name1);
                $("#modInstCntcInit").text(cntcInfo.code);
                $("#modInstCntcGender").text(cntcInfo.gender);
                $("#modInstCntcNric").text(cntcInfo.nric);
                $("#modInstCntcDob").text(cntcInfo.dob);
                $("#modInstCntcRace").text(cntcInfo.codeName);
                $("#modInstCntcEmail").text(cntcInfo.email);
                $("#modInstCntcDept").text(cntcInfo.dept);
                $("#modInstCntcPost").text(cntcInfo.pos);
                $("#modInstCntcTelM").text(cntcInfo.telM1);
                $("#modInstCntcTelR").text(cntcInfo.telR);
                $("#modInstCntcTelO").text(cntcInfo.telO);
                $("#modInstCntcTelF").text(cntcInfo.telf);
                
                $("#modInstCustCntcId").val(cntcInfo.custCntcId);
              //$("#modInstCustCntcIdOld").val(cntcInfo.custCntcId);
            }
        });
    }
    
    function fn_loadNric(custId){
        console.log("fn_loadNric START");

        Common.ajax("GET", "/sales/order/selectCustomerInfo.do", {custId : custId}, function(resultInfo) {

            if(resultInfo != null) {

                $("#modCustNricOld").val(resultInfo.nric);
                $("#modCustNric").val(resultInfo.nric);
                $("#modCustGender").val(resultInfo.gender);
                $("#modNationality").val(resultInfo.nation);
                $("#modCustType").val(resultInfo.typeId);
            }
        });
    }
    
    function fn_loadCntcPerson(custCntcId){
        console.log("fn_loadCntcPerson START");

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                console.log('custCntcInfo.custCntcId:'+custCntcInfo.custCntcId);

                var vInit = FormUtil.isEmpty(custCntcInfo.code) ? "" : custCntcInfo.code;

                $("#modCntcPersonNew").text(vInit + ' ' + custCntcInfo.name1);
                $("#modCntcMobNoNew").text(custCntcInfo.telM1);
                $("#modCntcResNoNew").text(custCntcInfo.telR);
                $("#modCntcOffNoNew").text(custCntcInfo.telO);
                $("#modCntcFaxNoNew").text(custCntcInfo.telf);

                $("#modCustCntcId").val(custCntcInfo.custCntcId);
                
                Common.alert("Contact Person Selected" + DEFAULT_DELIMITER + "<b>New contact person selected.<br />Click save to confirm change contact person.</b>");
            }
        });
    }
    
    function fn_loadBillGrpCntcPerson(ordId) {
        Common.ajax("GET", "/sales/order/selectBillGrpCntcPersonJson.do", {salesOrdId : ordId}, function(cntcPerInfo) {

            if(cntcPerInfo != null) {
                
                $('#modCustId2').val(cntcPerInfo.custBillCustId);
                $('#modBillGroupId2').val(cntcPerInfo.custBillId);
                $('#modBillGroupNo2').text(cntcPerInfo.custBillGrpNo);
                $('#modTotalOrder2').text(cntcPerInfo.totOrder);
                
                $('#modCntcPerson').text(cntcPerInfo.custAddInfo.code + ' ' + cntcPerInfo.custAddInfo.name1);
                $('#modCntcMobNo').text(cntcPerInfo.custAddInfo.telM1);
                $('#modCntcOffNo').text(cntcPerInfo.custAddInfo.telO);
                $('#modCntcResNo').text(cntcPerInfo.custAddInfo.telR);
                $('#modCntcFaxNo').text(cntcPerInfo.custAddInfo.telf);
                
                $('#modCustCntcIdOld').val(cntcPerInfo.custAddInfo.custCntcId);     
            }
        });
    }

    function fn_loadBillGrpMailAddr(ordId) {
        Common.ajax("GET", "/sales/order/selectBillGrpMailingAddrJson.do", {salesOrdId : ordId}, function(mailAddrInfo) {

            if(mailAddrInfo != null) {
                
                $('#modCustId').val(mailAddrInfo.custBillCustId);
                $('#modBillGroupId').val(mailAddrInfo.custBillId);
                $('#modBillGroupNo').text(mailAddrInfo.custBillGrpNo);
                $('#modTotalOrder').text(mailAddrInfo.totOrder);
                $('#modAddress').text(mailAddrInfo.fullAddress);
                
                $('#modCustAddIdOld').val(mailAddrInfo.custBillAddId);                
            }
        });
    }

    function fn_loadUpdateInfo(ordId) {
        Common.ajax("GET", "/sales/order/selectBasicInfoJson.do", {salesOrderId : ordId}, function(basicInfo) {

            if(basicInfo != null) {
                
                if(basicInfo.appTypeId == '68') {
                    $('#modInstallDur').removeAttr("disabled").val(basicInfo.instlmtPriod);
                }
                
                $('#modSalesOrdNo').val(basicInfo.ordNo);
                
                $('#modAppTypeId').val(basicInfo.appTypeId);
                $('#modOrdRefNo').val(basicInfo.ordRefNo);
                $('#modOrdPoNo').val(basicInfo.ordPoNo);
                $('#modOrdRem').val(basicInfo.ordRem);
                
                $('#modSalesmanId').val(basicInfo.ordMemId);
                $('#modSalesmanCd').val(basicInfo.ordMemCode);
                $('#modSalesmanType').val(basicInfo.ordMemTypeName);
                $('#modSalesmanTypeId').val(basicInfo.ordMemTypeId);
                $('#modSalesmanName').val(basicInfo.ordMemName);
                $('#modSalesmanIc').val(basicInfo.ordMemNric);
                $('#modOrderDeptCode').val(basicInfo.ordDeptCode);
                $('#modDeptMemId').val(basicInfo.ordHmId);
                $('#modOrderGrpCode').val(basicInfo.ordGrpCode);
                $('#modGrpMemId').val(basicInfo.ordSmId);
                $('#modOrderOrgCode').val(basicInfo.ordOrgCode);
                $('#modOrgMemId').val(basicInfo.ordGmId);
                
                $('#modKeyInBranch').val(basicInfo.keyinBrnchId);
            }
        });
    }

    function fn_validNric() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#modCustNric').val().trim())) {
            isValid = false;
            msg += "Please key in Cutomer NRIC / Company No";
        }
        else {
            
            var existNric = fn_validNricExist();

            console.log('existNric:'+existNric);
            
            if(existNric > 0) {
                isValid = false;
                msg += "This is existing customer. Customer ID : "+existNric;

            }
            else {
                if($('#modCustType').val().trim() == '964') {            
                    var ic = $('#modCustNric').val().trim();
                    var lastDigit = parseInt(ic.charAt(ic.length - 1));
                    
                    if(lastDigit != null) {
                        if($('#modCustGender').val() == "F") {
                            if (lastDigit % 2 != 0) {
                                isValid = false;
                                msg += "Invalid NRIC.";
                            }
                        }
                        else {
                            if (lastDigit % 2 == 0) {
                                isValid = false;
                                msg += "Invalid NRIC.";
                            }
                        }
                    }
                }
            }
        }        
        
        if(!isValid) Common.alert("Save Validation" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        
        console.log('msg:'+msg);
        console.log('isValid:'+isValid);
        
        return isValid;
    }
    
    function fn_validNricExist() {

        var exCustId = 0;
        
        Common.ajax("GET", "/sales/order/checkNricExist.do", $('#frmNric').serializeJSON(), function(result) {
            
            console.log('result:'+result);
            
            if(result != null) {
                console.log('result.custId:'+result.custId);

                exCustId = result.custId;
            }
            
       }, null, {async : false});

       return exCustId;
    }
    
    function fn_validInstallInfo() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#modInstCustAddId').val())) {
            isValid = false;
            msg += "* Please select an installation address.<br/>";
        }

        if(FormUtil.isEmpty($('#modInstCustCntcId').val())) {
            isValid = false;
            msg += "* Please select an installation contact person.<br/>";
        }

        if($("#dscBrnchId option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the DSC branch.<br/>";
        }

        if(FormUtil.isEmpty($('#modPreferInstDt').val().trim())) {
            isValid = false;
            msg += "* Please select prefer install date.<br/>";
        }

        if(FormUtil.isEmpty($('#modPreferInstTm').val().trim())) {
            isValid = false;
            msg += "* Please select prefer install time.<br/>";
        }

        if(FormUtil.isEmpty($('#modInstct').val().trim())) {
            isValid = false;
            msg += "* Please key-in the special instruction.<br/>";
        }

        if(!isValid) Common.alert("Order Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_validCntcPerson() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#modCustCntcId').val().trim())) {
            isValid = false;
            msg += "* Please select the contact person.<br/>";
        }

        if(FormUtil.isEmpty($('#modRem2').val().trim())) {
            isValid = false;
            msg += "* Please key in the reason to update.<br/>";
        }
        else {
            if(FormUtil.byteLength($('#modRem2').val().trim()) > 200) {            
                isValid = false;
                msg += "* Reason to update cannot more than 200 characters.<br/>";
            }
        }

        if(!isValid) Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_validMailingAddress() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#modCustAddId').val().trim())) {
            isValid = false;
            msg += "* Please select the address.<br/>";
        }

        if(FormUtil.isEmpty($('#modRem').val().trim())) {
            isValid = false;
            msg += "* Please key in the reason to update.<br/>";
        }
        else {
            if(FormUtil.byteLength($('#modRem').val().trim()) > 200) {            
                isValid = false;
                msg += "* Reason to update cannot more than 200 characters.<br/>";
            }
        }

        if(!isValid) Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_validBasicInfo() {
        var isValid = true, msg = "";

        if($('#modAppTypeId').val() == '68' && FormUtil.isEmpty($('#modInstallDur').val().trim())) {
            isValid = false;
            msg += "* Please key in the installment duration.<br/>";
        }

        if(FormUtil.isNotEmpty($('#modSalesmanTypeId').val().trim())) {
            if($('#modSalesmanTypeId').val().trim() == 1 || $('#modSalesmanTypeId').val().trim() == 2) {
                if(FormUtil.isEmpty($('#modOrderDeptCode').val().trim())
                || FormUtil.isEmpty($('#modOrderGrpCode').val().trim())
                || FormUtil.isEmpty($('#modOrderOrgCode').val().trim())) {
                    isValid = false;
                    var memType = "";
                    
                    if($('#modSalesmanTypeId').val().trim() == 1) {
                        memType = "HP";
                    }
                    else if($('#modSalesmanTypeId').val().trim() == 2) {
                        memType = "Cody";
                    }
                    
                    msg += "* The " + memType + " department/group/organization code is missing.<br/>";
                }
            }
        }
        else {
            if($('#modAppTypeId').val() != '143') {
                isValid = false;
                msg += "* Please select a salesman.<br/>";
            }
        }
        
        if($("#modKeyInBranch option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the key-in branch.<br/>";
        }

        if(!isValid) Common.alert("Order Update Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_doSaveBasicInfo() {
        console.log('!@# fn_doSaveBasicInfo START');
        
        $('#hiddenOrdEditType').val($('#ordEditType').val());
        
        Common.ajax("POST", "/sales/order/updateOrderBasinInfo.do", $('#frmBasicInfo').serializeJSON(), function(result) {
                
                Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveMailingAddress() {
        console.log('!@# fn_doSaveMailingAddress START');

        Common.ajax("POST", "/sales/order/updateMailingAddress.do", $('#frmMailAddr').serializeJSON(), function(result) {
                
                Common.alert("Mailing Address Updated" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Update" + DEFAULT_DELIMITER + "<b>Failed to update mailing address.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveCntcPerson() {
        console.log('!@# fn_doSaveCntcPerson START');

        Common.ajax("POST", "/sales/order/updateCntcPerson.do", $('#frmCntcPer').serializeJSON(), function(result) {
                
                Common.alert("Mailing Address Updated" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Update" + DEFAULT_DELIMITER + "<b>Failed to update mailing address.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveNric() {
        console.log('!@# fn_doSaveNric START');

        Common.ajax("POST", "/sales/order/updateNric.do", $('#frmNric').serializeJSON(), function(result) {
                
                Common.alert("Success To Update" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Saved" + DEFAULT_DELIMITER + "<b>Failed to save. Please try again later.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveInstallInfo() {
        console.log('!@# fn_doSaveInstallInfo START');

        Common.ajax("POST", "/sales/order/updateInstallInfo.do", $('#frmInstInfo').serializeJSON(), function(result) {
                
                Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSavePaymentChannel() {
        console.log('!@# fn_doSaveInstallInfo START');

        Common.ajax("POST", "/sales/order/updateInstallInfo.do", $('#frmInstInfo').serializeJSON(), function(result) {
                
                Common.alert("Update Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

	function fn_reloadPage(){
	    Common.popupDiv("/sales/order/orderModifyPop.do", { salesOrderId : ORD_ID, ordEditType : $('#ordEditType').val() }, null , true);
	    $('#btnCloseModify').click();
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="hTitle">Order Edit</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="btnCloseModify" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Edit Type</th>
	<td>
	<select id="ordEditType" class="mr5"></select>
	<p class="btn_sky"><a id="btnEditType" href="#">Confirm</a></p>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>

<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------
    Basic Info Edit START
------------------------------------------------------------------------------->
<section id="scBI" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Basic Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<form id="frmBasicInfo" method="post">
<input id="modSalesOrdId" name="salesOrdId" type="hidden" value="${salesOrderId}"/>
<input id="modSalesOrdNo" name="salesOrdNo" type="hidden" />
<input id="modAppTypeId" name="appTypeId" type="hidden" />
<input id="modSalesmanId" name="salesmanId" type="hidden" />
<input id="modSalesmanTypeId" name="salesmanTypeId" type="hidden" />
<input id="modDeptMemId" name="deptMemId" type="hidden" />
<input id="modGrpMemId" name="grpMemId" type="hidden" />
<input id="modOrgMemId" name="orgMemId" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:200px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Installment Duration<span class="must">*</span></th>
	<td><input id="modInstallDur" name="installDur" type="text" title="" placeholder="Installment Duration (1-36 Months)" class="w100p" disabled /></td>
	<th scope="row">Salesman Code<span class="must">*</span></th>
	<td><input id="modSalesmanCd" name="salesmanCd" type="text" title="" placeholder="Salesman Code" class="" /><a id="btnSalesmanPop" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row">Reference No</th>
	<td><input id="modOrdRefNo" name="ordRefNo" type="text" title="" placeholder="Reference Number" class="w100p" /></td>
	<th scope="row">Salesman Type</th>
	<td><input id="modSalesmanType" name="salesmanType" type="text" title="" placeholder="Salesman Type" class="" /></td>
</tr>
<tr>
	<th scope="row">PO No</th>
	<td><input id="modOrdPoNo" name="ordPoNo" type="text" title="" placeholder="PO Number" class="w100p" /></td>
	<th scope="row">Salesman Name</th>
	<td><input id="modSalesmanName" name="salesmanName" type="text" title="" placeholder="Salesman Name" class="" /></td>
</tr>
<tr>
	<th scope="row">Key-In Branch<span class="must">*</span></th>
	<td>
	<select id="modKeyInBranch" name="keyInBranch" class="w100p"></select>
	</td>
	<th scope="row">Salesman NRIC</th>
	<td><input id="modSalesmanIc" name="salesmanIc" type="text" title="" placeholder="Salesman NRIC" class="" /></td>
</tr>
<tr>
	<th scope="row" rowspan="3">Remark</th>
	<td rowspan="3"><textarea id="modOrdRem" name="ordRem" cols="20" rows="5"></textarea></td>
	<th scope="row">Department Code</th>
	<td><input id="modOrderDeptCode" name="orderDeptCode" type="text" title="" placeholder="Department Code" class="" /></td>
</tr>
<tr>
	<th scope="row">Group Code</th>
	<td><input id="modOrderGrpCode" name="orderGrpCode" type="text" title="" placeholder="Group Code" class="" /></td>
</tr>
<tr>
	<th scope="row">Organization Code</th>
	<td><input id="modOrderOrgCode" name="orderOrgCode" type="text" title="" placeholder="Organization Code" class="" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnSaveBasicInfo" name="btnSaveBasicInfo" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Basic Info Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Mailing Address Edit START
------------------------------------------------------------------------------->
<section id="scMA" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Billing Group Maintenance - Mailing Address</h3>
</aside><!-- title_line end -->
<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnBillNewAddr" href="#">Add New Address</a></p></li>
    <li><p class="btn_grid"><a id="btnBillSelAddr" href="#">Select Mailing Address</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form id="frmMailAddr" method="post">
<input name="salesOrdId" type="hidden" value="${salesOrderId}"/>
<input id="modCustId" name="custId" type="hidden" />
<input id="modBillGroupId" name="billGroupId" type="hidden" />
<input id="modCustAddId" name="custAddId" type="hidden" />
<input id="modCustAddIdOld" name="custAddIdOld" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:190px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Billing Group</th>
	<td><span id="modBillGroupNo"></span></td>
	<th scope="row">Total Order In Group</th>
	<td><span id="modTotalOrder"></span></td>
</tr>
<tr>
	<th scope="row">Current Address</th>
	<td colspan="3"><span id="modAddress"></span></td>
</tr>
<tr>
	<th scope="row">New Address</th>
	<td colspan="3"><span id="modNewAddress"></span></td>
</tr>
<tr>
	<th scope="row">Reason Update</th>
	<td colspan="3"><textarea id="modRem" name="sysHistRem" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnSaveMailingAddress" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Mailing Address Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Contact Person Edit START
------------------------------------------------------------------------------->
<section id="scCP" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Billing Group Maintenance - Contact Person</h3>
</aside><!-- title_line end -->
<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnNewCntc" href="#">Add New Contact</a></p></li>
    <li><p class="btn_grid"><a id="btnSelCntc" href="#">Select Contact Person</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form id="frmCntcPer" method="post">
<input name="salesOrdId" type="hidden" value="${salesOrderId}"/>
<input id="modCustId2" name="custId" type="hidden" />
<input id="modBillGroupId2" name="billGroupId" type="hidden" />
<input id="modCustCntcId" name="custCntcId" type="hidden" />
<input id="modCustCntcIdOld" name="custCntcIdOld" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Billing Group</th>
	<td><span id="modBillGroupNo2"></span></td>
	<th scope="row">Total Order In Group</th>
	<td><span id="modTotalOrder2"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Current Contact Person</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Person</th>
	<td colspan="3"><span id="modCntcPerson"></span></td>
</tr>
<tr>
	<th scope="row">Mobile Number</th>
	<td><span id="modCntcMobNo"></span></td>
	<th scope="row">Office Number</th>
	<td><span id="modCntcOffNo"></span></td>
</tr>
<tr>
	<th scope="row">Residence Number</th>
	<td><span id="modCntcResNo"></span></td>
	<th scope="row">Fax Number</th>
	<td><span id="modCntcFaxNo"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>New Contact Person</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Contact Person</th>
	<td colspan="3"><span id="modCntcPersonNew"></td>
</tr>
<tr>
	<th scope="row">Mobile Number</th>
	<td><span id="modCntcMobNoNew"></span></td>
	<th scope="row">Office Number</th>
	<td><span id="modCntcOffNoNew"></span></td>
</tr>
<tr>
	<th scope="row">Residence Number</th>
	<td><span id="modCntcResNoNew"></span></td>
	<th scope="row">Fax Number</th>
	<td><span id="modCntcFaxNoNew"></span></td>
</tr>
<tr>
	<th scope="row">Reason Update</th>
	<td colspan="3"><textarea id="modRem2" name="sysHistRem" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnSaveCntcPerson" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Contact Person Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    NRIC/Company No. Edit START
------------------------------------------------------------------------------->
<section id="scIC" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>NRIC/Company No.</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="frmNric" method="post">
<input name="custId" value="${custId}" type="hidden" />
<input id="modCustNricOld" name="custNricOld" type="hidden" />
<input id="modCustGender" name="custGender" type="hidden" />
<input id="modNationality" name="nationality" type="hidden" />
<input id="modCustType" name="custType" type="hidden" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">NRIC/Company No.</th>
	<td><input id="modCustNric" name="custNric" type="text" title="" placeholder="NRIC/Company No." class="" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnSaveNric" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    NRIC/Company No. Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Installation Edit START
------------------------------------------------------------------------------->
<section id="scIN" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Installation Address</h3>
</aside><!-- title_line end -->
<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnInstNewAddr" href="#">Add New Address</a></p></li>
    <li><p class="btn_grid"><a id="btnInstSelAddr" href="#">Select Mailing Address</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->

<form id="frmInstInfo" method="post">
<input name="salesOrdId" type="hidden" value="${salesOrderId}"/>
<input name="salesOrdNo" type="hidden" value="${salesOrderNo}"/>
<!-- Install Address Info                                                    -->
<input id="modInstallId" name="installId" type="hidden" />
<input id="modInstCustAddIdOld" name="custAddIdOld" type="hidden" />
<input id="modInstCustAddId" name="custAddId" type="hidden" />
<input id="modInstAreaId" name="areaId" type="hidden" />

<!-- Install Contact Info                                                    -->
<input id="modInstCustCntcId" name="custCntcId" type="hidden" />
<!--input id="modInstCustCntcIdOld" name="custGender" type="hidden" /-->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Address Detail<span class="must">*</span></th>
	<td colspan="3"><span id="modInstAddrDtl"></span></td>
</tr>
<tr>
	<th scope="row">Street<span class="must">*</span></th>
	<td colspan="3"><span id="modInstStreet"></span></td>
</tr>
<tr>
	<th scope="row">Area<span class="must">*</span></th>
	<td colspan="3" id="modInstArea"><span></span></td>
</tr>
<tr>
	<th scope="row">City</th>
	<td><span id="modInstCity"></span></td>
	<th scope="row">PostCode</th>
	<td><span id="modInstPostCd"></span></td>
</tr>
<tr>
	<th scope="row">State</th>
	<td><span id="modInstState"></span></td>
	<th scope="row">Country</th>
	<td><span id="modInstCnty"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Contact Person</h3>
</aside><!-- title_line end -->
<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnInstNewCntc" href="#">Add New Contact</a></p></li>
    <li><p class="btn_grid"><a id="btnInstSelCntc" href="#">Select Contact Person</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Name<span class="must">*</span></th>
	<td><span id="modInstCntcName"></span></td>
	<th scope="row">Initial</th>
	<td><span id="modInstCntcInit"></span></td>
	<th scope="row">Gender</th>
	<td><span id="modInstCntcGender"></span></td>
</tr>
<tr>
	<th scope="row">NRIC</th>
	<td><span id="modInstCntcNric"></span></td>
	<th scope="row">DOB</th>
	<td><span id="modInstCntcDob"></span></td>
	<th scope="row">Race</th>
	<td><span id="modInstCntcRace"></span></td>
</tr>
<tr>
	<th scope="row">Email</th>
	<td><span id="modInstCntcEmail"></span></td>
	<th scope="row">Department</th>
	<td><span id="modInstCntcDept"></span></td>
	<th scope="row">Post</th>
	<td><span id="modInstCntcPost"></span></td>
</tr>
<tr>
	<th scope="row">Tel (Mobile)</th>
	<td><span id="modInstCntcTelM"></span></td>
	<th scope="row">Tel (Residence)</th>
	<td><span id="modInstCntcTelR"></span></td>
	<th scope="row">Tel (Office)</th>
	<td><span id="modInstCntcTelO"></span></td>
</tr>
<tr>
	<th scope="row">Tel (Fax)</th>
	<td><span id="modInstCntcTelF"></span></td>
	<th scope="row"></th>
	<td><span></span></td>
	<th scope="row"></th>
	<td><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:190px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">DSC Branch<span class="must">*</span></th>
	<td colspan="3">
	<select id="dscBrnchId" name="dscBrnchId" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row">Prefer Install Date<span class="must">*</span></th>
	<td><input id="modPreferInstDt" name="preDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/></td>
	<th scope="row">Prefer Install Time<span class="must">*</span></th>
	<td>
	<div class="time_picker w100p"><!-- time_picker start -->
	<input id="modPreferInstTm" name="preTm" type="text" title="" placeholder="" class="time_date w100p" readonly/>
	<ul>
		<li>Time Picker</li>
		<li><a href="#">12:00 AM</a></li>
		<li><a href="#">01:00 AM</a></li>
		<li><a href="#">02:00 AM</a></li>
		<li><a href="#">03:00 AM</a></li>
		<li><a href="#">04:00 AM</a></li>
		<li><a href="#">05:00 AM</a></li>
		<li><a href="#">06:00 AM</a></li>
		<li><a href="#">07:00 AM</a></li>
		<li><a href="#">08:00 AM</a></li>
		<li><a href="#">09:00 AM</a></li>
		<li><a href="#">10:00 AM</a></li>
		<li><a href="#">11:00 AM</a></li>
		<li><a href="#">12:00 PM</a></li>
		<li><a href="#">01:00 PM</a></li>
		<li><a href="#">02:00 PM</a></li>
		<li><a href="#">03:00 PM</a></li>
		<li><a href="#">04:00 PM</a></li>
		<li><a href="#">05:00 PM</a></li>
		<li><a href="#">06:00 PM</a></li>
		<li><a href="#">07:00 PM</a></li>
		<li><a href="#">08:00 PM</a></li>
		<li><a href="#">09:00 PM</a></li>
		<li><a href="#">10:00 PM</a></li>
		<li><a href="#">11:00 PM</a></li>
	</ul>
	</div><!-- time_picker end -->
	</td>
</tr>
<tr>
	<th scope="row">Special Instruction<span class="must">*</span></th>
	<td colspan="3"><textarea id="modInstct" name="instct" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a id="btnSaveInstInfo" href="#">SAVE</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Installation Edit END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Payment Channel Edit START
------------------------------------------------------------------------------->
<section id="scPC" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Payment Channel</h3>
</aside><!-- title_line end -->
<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnViewHistory" href="#">View Histoty</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Pay By Third Party</th>
	<td colspan="3">
	<label><input id="thrdParty" type="checkbox" /><span></span></label>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<!------------------------------------------------------------------------------
    Third Party - Form ID(thrdPartyForm)
------------------------------------------------------------------------------->
<section id="scPC_ThrdParty" class="blind">

<aside class="title_line"><!-- title_line start -->
<h2>Third Party</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="thrdPartyAddCustBtn" href="#">Add New Third Party</a></p></li>
</ul>
<form id="thrdPartyForm" name="thrdPartyForm" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID<span class="must">*</span></th>
    <td><input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="Third Party ID" class="" />
        <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenThrdPartyId" name="hiddenThrdPartyId" type="hidden" title="" placeholder="Third Party ID" class="" /></td>
    <th scope="row">Type</th>
    <td><input id="thrdPartyType" name="thrdPartyType" type="text" title="" placeholder="Costomer Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="thrdPartyName" name="thrdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="thrdPartyNric" name="thrdPartyNric" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<!------------------------------------------------------------------------------
    Rental Paymode - Form ID(rentPayModeForm)
------------------------------------------------------------------------------->
<section id="scPC_RentPayMode">

<form id="rentPayModeForm" id="rentPayModeForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Rental Paymode<span class="must">*</span></th>
	<td>
	<select id="rentPayMode" name="rentPayMode" class="w100p"></select>
	</td>
	<th scope="row">NRIC on DD/Passbook</th>
	<td><input id="rentPayIC" name="rentPayIC" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section>

<!------------------------------------------------------------------------------
    Credit Card
------------------------------------------------------------------------------->
<section id="scPC_CrCard" class="blind">

<aside class="title_line"><!-- title_line start -->
<h2>Credit Card</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb1m">
    <li><p class="btn_grid"><a id="addCreditCardBtn" href="#">Add New Credit Card</a></p></li>
    <li><p class="btn_grid"><a id="selCreditCardBtn" href="#">Select Another Credit Card</a></p></li>
</ul>

<form id="crcForm" name="crcForm" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Credit Card Number<span class="must">*</span></th>
    <td><span id="rentPayCRCNo"></span>
        <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" />
        <input id="hiddenRentPayEncryptCRCNo" name="hiddenRentPayEncryptCRCNo" type="hidden" /></td>
    <th scope="row">Credit Card Type</th>
    <td><span id="rentPayCRCType"></span></td>
</tr>
<tr>
    <th scope="row">Name On Card</th>
    <td><span id="rentPayCRCName"></span></td>
    <th scope="row">Expiry</th>
    <td><span id="rentPayCRCExpiry"></span></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><span id="rentPayCRCBank"></span>
        <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" title="" class="w100p" /></td>
    <th scope="row">Card Type</th>
    <td><span id="rentPayCRCCardType"></span></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>
<!------------------------------------------------------------------------------
    Direct Debit
------------------------------------------------------------------------------->
<section id="scPC_DirectDebit" class="blind">
<aside class="title_line"><!-- title_line start -->
<h2>Direct Debit</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb1m">
    <li><p class="btn_grid"><a id="btnAddBankAccount" href="#">Add New Bank Account</a></p></li>
    <li><p class="btn_grid"><a id="btnSelBankAccount" href="#">Select Another Bank Account</a></p></li>
</ul>

<form id="ddForm" name="ddForm" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Account Number<span class="must">*</span></th>
    <td><span id="rentPayBankAccNo"></span>
        <input id="rentPayBankAccNoEncrypt" name="rentPayBankAccNoEncrypt" type="hidden" />
        <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" />
    <th scope="row">Account Type</th>
    <td><span id="rentPayBankAccType"></span></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><span id="accName"></span></td>
    <th scope="row">Issue Bank Branch</th>
    <td><span id="accBranch"></span></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td colspan=3><span id="accBank"></span>
        <input id="hiddenAccBankId" name="hiddenAccBankId" type="hidden" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Apply Date<span class="must">*</span></th>
	<td><input id="modApplyDate" name="applyDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
	<th scope="row">Submit Date</th>
	<td><input id="modSubmitDate" name="submitDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
	<th scope="row">Start Date</th>
	<td><input id="modStartDate" name="startDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
	<th scope="row"><label>
	    <input id="chkRejectDate" type="checkbox" /><span>Reject Date</span><span id="spRjctDate" class="must"></span></label></th>
	<td><input id="modRejectDate" name="rejectDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" disabled /></td>
</tr>
<tr>
	<th scope="row">Pay Term</th>
	<td>
	<select id="modPayTerm" name="payTerm" class="w100p"></select>
	</td>
	<th scope="row">Reject Reason<span id="spRejectReason" class="must"></span></th>
	<td>
	<select id="modRejectReason" name="rejectReason" class="w100p" disabled></select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#">SAVE</a></p></li>
</ul>  
</section>
<!------------------------------------------------------------------------------
    Payment Channel Edit END
------------------------------------------------------------------------------->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->