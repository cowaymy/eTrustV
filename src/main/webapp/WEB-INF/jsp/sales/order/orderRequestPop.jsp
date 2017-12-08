<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    
    var TAB_NM        = '${ordReqType}';
    var ORD_ID        = '${orderDetail.basicInfo.ordId}';
    var ORD_NO        = '${orderDetail.basicInfo.ordNo}';
    var ORD_DT        = '${orderDetail.basicInfo.ordDt}';
    var ORD_STUS_ID   = '${orderDetail.basicInfo.ordStusId}';
    var ORD_STUS_CODE = '${orderDetail.basicInfo.ordStusCode}';
    var CUST_ID       = '${orderDetail.basicInfo.custId}';
    var CUST_TYPE_ID  = '${orderDetail.basicInfo.custTypeId}';
    var APP_TYPE_ID   = '${orderDetail.basicInfo.appTypeId}';
    var APP_TYPE_DESC = '${orderDetail.basicInfo.appTypeDesc}';
    var CUST_NRIC     = '${orderDetail.basicInfo.custNric}';
    var PROMO_ID      = '${orderDetail.basicInfo.ordPromoId}';
    var PROMO_CODE    = '${orderDetail.basicInfo.ordPromoCode}';
    var PROMO_DESC    = '${orderDetail.basicInfo.ordPromoDesc}';
    var STOCK_ID      = '${orderDetail.basicInfo.stockId}';
    var STOCK_DESC    = '${orderDetail.basicInfo.stockDesc}';
    var CNVR_SCHEME_ID= '${orderDetail.basicInfo.cnvrSchemeId}';
    var RENTAL_STUS   = '${orderDetail.basicInfo.rentalStus}';
    var EMP_CHK       = '${orderDetail.basicInfo.empChk}';
    var EX_TRADE      = '${orderDetail.basicInfo.exTrade}';
    var TODAY_DD      = '${toDay}';
    var SRV_PAC_ID    = '${orderDetail.basicInfo.srvPacId}';

    var filterGridID;
    
    $(document).ready(function(){
        doGetComboData('/common/selectCodeList.do', {groupCode :'348'}, TAB_NM, 'ordReqType', 'S'); //Order Edit Type
        
        if(FormUtil.isNotEmpty(TAB_NM)) {
            fn_changeTab(TAB_NM);
        }
        
    });

    $(function(){
        $('#btnEditType').click(function() {
            var tabNm = $('#ordReqType').val();            
            fn_changeTab(tabNm);
        });
        $('#txtPenaltyAdj').change(function() {
            if(FormUtil.isEmpty($('#txtPenaltyAdj').val().trim())) {
                $('#txtPenaltyAdj').val(0);
            }
            fn_calculatePenaltyAndTotalAmount();
        });
        $('#txtPenaltyAdj').keydown(function (event) {  
            if (event.which == 13) {    //enter
                if(FormUtil.isEmpty($('#txtPenaltyAdj').val().trim())) {
                    $('#txtPenaltyAdj').val(0);
                }
                fn_calculatePenaltyAndTotalAmount();
            }  
        });
        $('#btnReqCancOrder').click(function() {
            if(fn_validReqCanc()) fn_clickBtnReqCancelOrder();
        });
        $('#btnReqPrdExch').click(function() {
            if(fn_validReqPexc()) fn_doSaveReqPexc();
        });
        $('#btnReqSchmConv').click(function() {
//          fn_doSaveReqSchm();
            Common.popupDiv("/sales/order/schemConvPop.do", '');
        });
        $('#btnReqAppExch').click(function() {
            if(!fn_isLockOrder('AEXC')) {
                if(fn_validReqAexc()) fn_doSaveReqAexc();
            }
        });
        $('#cmbOrderProduct').change(function() {

            if(FormUtil.isEmpty($('#cmbOrderProduct').val())) {
                $('#cmbPromotion option').remove();
                return;
            }
            
            $('#btnCurrentPromo').prop("checked", false).prop("disabled", true);
        
//          $('#ordCampgn option').remove();
//          $('#ordCampgn').prop("readonly", true);
//          $('#relatedNo').val('').prop("readonly", true).addClass("readonly");
//          $('#trialNoChk').prop("checked", false).prop("disabled", true);
//          $('#trialNo').val('').addClass("readonly");
            $('#txtPrice').val('');
            $('#ordPriceId').val('');
            $('#txtPV').val('');
            $('#txtOrderRentalFees').val('');

            var stkIdVal   = $("#cmbOrderProduct").val();

            if($("#cmbOrderProduct option:selected").index() > 0) {
                fn_loadProductPrice(APP_TYPE_ID, stkIdVal);
                fn_loadProductPromotion(APP_TYPE_ID, stkIdVal, EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);                
                $('#btnCurrentPromo').removeAttr("disabled");
            }
        });
        $('#cmbPromotion').change(function() {

            var stkIdVal   = $("#cmbOrderProduct").val();
            var promoIdIdx = $("#cmbPromotion option:selected").index();
            var promoIdVal = $("#cmbPromotion").val();

            if(promoIdIdx > 0 && promoIdVal != '0') {
                fn_loadPromotionPrice(promoIdVal, stkIdVal);
            }
            else {
                fn_loadProductPrice(APP_TYPE_ID, stkIdVal);
            }
        });
        $('#btnCurrentPromo').click(function(event) {
            
            $('#cmbPromotion').val('').removeAttr("disabled");
            
            if($('#btnCurrentPromo').is(":checked")) {
                
                $('#cmbPromotion').prop("disabled", true);                
                
                if($('#hiddenCurrentPromotionID').val() > 0) {
                    //$('#cmbPromotion').text($('#hiddenCurrentPromotion').val());
                    $('#cmbPromotion option').remove();
                    $('#cmbPromotion').append("<option value=''>"+$('#hiddenCurrentPromotion').val()+"</option>");
                    fn_loadPromotionPrice($("#hiddenCurrentPromotionID").val(), $("#cmbOrderProduct").val());
                }
                else {
                    fn_loadProductPrice(APP_TYPE_ID, $("#cmbOrderProduct").val());
                    fn_loadProductPromotion(APP_TYPE_ID, $("#cmbOrderProduct").val(), EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
                }
            }
            else {
                fn_loadProductPrice(APP_TYPE_ID, $("#cmbOrderProduct").val());
                fn_loadProductPromotion(APP_TYPE_ID, $("#cmbOrderProduct").val(), EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
            }
        });
        $('#cmbAppTypeAexc').change(function() {
            
            var appSubType = '';
            
            if($('#cmbAppTypeAexc').val() == '66') {
                appSubType = '367';
            }
            else if($('#cmbAppTypeAexc').val() == '67') {
                appSubType = '368';
            }
            else if($('#cmbAppTypeAexc').val() == '68') {
                appSubType = '369';
            }
            else {
                $('#srvPacIdAexc option').remove();
            }
            
            if(appSubType != '') {
                doGetComboData('/common/selectCodeList.do', {groupCode :appSubType}, '',  'srvPacIdAexc',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
            }

            $('#txtInstallmentDurationAexc').addClass("blind");
            $("#txtInstallmentDurationAexc").val('').prop("disabled", true);

            $('#cmbPromotionAexc option').remove();
            
          //$("#txtPriceAexc").val('');
          //$("#txtPVAexc").val('');
            
            if($("#cmbAppTypeAexc option:selected").index() > 0) {
                if($("#cmbAppTypeAexc").val() == '68') {
                    $('#txtInstallmentDurationAexc').removeClass("blind");
                    $('#txtInstallmentDurationAexc').removeAttr("disabled");
                }

                $('#cmbPromotionAexc').removeAttr("disabled");
                $('#txtPriceAexc').removeAttr("disabled");
                $('#txtPVAexc').removeAttr("disabled");   
                
                //this.LoadPromotionPrice(int.Parse(cmbPromotion.SelectedValue), int.Parse(hiddenProductID.Value));
            }
        });
        $('#cmbPromotionAexc').change(function() {
            
            var promoIdIdx = $("#cmbPromotionAexc option:selected").index();
            var promoIdVal = $("#cmbPromotionAexc").val();

            if(promoIdIdx > 0 && promoIdVal != '0') {
               fn_loadPromotionPriceAexc($('#cmbPromotionAexc').val(), STOCK_ID);
            }
            else {
                fn_loadProductPriceAexc(APP_TYPE_ID, STOCK_ID)
            }
            
        });
        $('#srvPacIdAexc').change(function() {

            var idx    = $("#srvPacIdAexc option:selected").index();
            var selVal = $("#srvPacIdAexc").val();
            
            if(idx > 0) {
                var stkType = $("#cmbAppTypeAexc").val() == '66' ? '1' : '2';
                
                Common.ajax("GET", "/sales/order/selectProductCodeList.do", {stkType:stkType, srvPacId:selVal}, function(result) {
        
                    if(result != null && result.length > 0) {        
                        var isExist = false;

                        for(var i = 0; i < result.length; i++) {
                            if(result[i].stkId == STOCK_ID) {
                                isExist = true;
                                break;
                            }
                        }
                    }

                    if(!isExist) {
                        Common.alert("Sub Type Selected" + DEFAULT_DELIMITER + "<b>Not a sub-type suitable for a product</b>");                    
                        $('#srvPacIdAexc').val('');
                    }
                    else {
                        fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(), STOCK_ID, EMP_CHK, CUST_TYPE_ID, $("#exTradeAexc").val(), $('#srvPacIdAexc').val());   
                    }
                });
            }
        });        
        $('#exTradeAexc').change(function() {
            
            $('#cmbPromotionAexc option').remove();
            
            if($("#exTradeAexc").val() == '1') {
                $('#relatedNoAexc').removeAttr("readonly").removeClass("readonly");
            }
            else {
                $('#relatedNoAexc').val('').prop("readonly", true).addClass("readonly");
            }

            fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(), STOCK_ID, EMP_CHK, CUST_TYPE_ID, $("#exTradeAexc").val(), $('#srvPacIdAexc').val());
        });
        $('#custIdOwnt').change(function(event) {
            fn_selectCustInfo();
        });
        $('#custIdOwnt').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_selectCustInfo();
                return false;
            }
        });
        $('#addCustBtn').click(function() {
            Common.popupWin("searchFormOwnt", "/sales/customer/customerRegistPop.do", {width : "1200px", height : "580x"});
            //Common.popupDiv("/sales/customer/customerRegistPop.do", $("#searchForm").serializeJSON(), null, true);
        });
        $('#custBtnOwnt').click(function() {
            //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
            Common.popupDiv("/common/customerPop.do", {callPrgm : "ORD_REGISTER_CUST_CUST"}, null, true);
        });
        $('#btnReqOwnTrans').click(function() {
            if(!fn_isLockOrder('OTRN')) {
                if(fn_validReqOwnt()) {
                    fn_doSaveReqOwnt();
                }
            }
        });
        $('#btnAddAddress').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#txtHiddenCustIDOwnt').val(), callParam : "ORD_REQUEST_MAIL"}, null , true);
        });
        $('#btnSelectAddress').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#txtHiddenCustIDOwnt').val(), callPrgm : "fn_loadMailAddress"}, null, true);
        });
        $('#btnAddContact').click(function() {
            Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {"custId": $('#txtHiddenCustIDOwnt').val(), callParam : "ORD_REQUEST_MAIL"}, null , true ,'_editDiv3New');
        });
        $('#btnSelectContact').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#txtHiddenCustIDOwnt').val(), callPrgm : "fn_loadCntcPerson"}, null, true);
        });
        $('#btnAddInstAddress').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#txtHiddenCustIDOwnt').val(), callParam : "ORD_REQUEST_MAIL"}, null , true);
        });
        $('#btnSelectInstAddress').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#txtHiddenCustIDOwnt').val(), callPrgm : "fn_loadInstAddress"}, null, true);
        });
        $('#btnAddInstContact').click(function() {
            Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {"custId": $('#txtHiddenCustIDOwnt').val(), callParam : "ORD_REQUEST_MAIL"}, null , true ,'_editDiv3New');
        });
        $('#btnSelectInstContact').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#txtHiddenCustIDOwnt').val(), callPrgm : "fn_loadInstallationCntcPerson"}, null, true);
        });
        $('#btnThirdPartyOwnt').click(function(event) {

            fn_clearRentPayMode();
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            if($('#btnThirdPartyOwnt').is(":checked")) {
                $('#sctThrdParty').removeClass("blind");
            }
            else {
                $('#sctThrdParty').addClass("blind");
            }
        });
        $('#cmbRentPaymodeOwnt').change(function() {

            console.log('cmbRentPaymodeOwnt click event');

            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            var rentPayModeIdx = $("#cmbRentPaymodeOwnt option:selected").index();
            var rentPayModeVal = $("#cmbRentPaymodeOwnt").val();

            if(rentPayModeIdx > 0) {
                if(rentPayModeVal == '133' || rentPayModeVal == '134') {

                    Common.alert('<b>Currently we are not provide ['+rentPayModeVal+'] service.</b>');
                    fn_clearRentPayMode();
                }
                else {
                    if(rentPayModeVal == '131') {
                        if($('#btnThirdPartyOwnt').is(":checked") && FormUtil.isEmpty($('#txtHiddenThirdPartyIDOwnt').val())) {
                            Common.alert('<b>Please select the third party first.</b>');
                        }
                        else {
                            $('#sctCrCard').removeClass("blind");
                        }
                    }
                    else if(rentPayModeVal == '132') {
                        if($('#btnThirdPartyOwnt').is(":checked") && FormUtil.isEmpty($('#txtHiddenThirdPartyIDOwnt').val())) {
                            Common.alert('<b>Please select the third party first.</b>');
                        }
                        else {
                            $('#sctDirectDebit').removeClass("blind");
                        }
                    }
                }
            }
        });
        $('#txtThirdPartyIDOwnt').change(function(event) {
            fn_loadThirdParty($('#txtThirdPartyIDOwnt').val().trim(), 2);
        });
        $('#txtThirdPartyIDOwnt').keydown(function(event) {
            if(event.which === 13) {    //enter
                fn_loadThirdParty($('#txtThirdPartyIDOwnt').val().trim(), 2);
            }
        });
        $('#thrdPartyBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
            Common.popupDiv("/common/customerPop.do", {callPrgm : "ORD_REQUEST_PAY"}, null, true);
        });
        $('#btnAddCRC').click(function() {
            var vCustId = $('#btnThirdPartyOwnt').is(":checked") ? $('#txtHiddenThirdPartyIDOwnt').val() : $('#txtHiddenCustIDOwnt').val();
            Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : vCustId}, null, true);
        });
        $('#btnSelectCRC').click(function() {
            var vCustId = $('#btnThirdPartyOwnt').is(":checked") ? $('#txtHiddenThirdPartyIDOwnt').val() : $('#txtHiddenCustIDOwnt').val();
            Common.popupDiv("/sales/customer/customerCreditCardSearchPop.do", {custId : vCustId, callPrgm : "ORD_REQUEST_PAY"}, null, true);
        });
        $('#btnAddBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#txtHiddenThirdPartyIDOwnt').val() : $('#txtHiddenCustIDOwnt').val();
            Common.popupDiv("/sales/customer/customerBankAccountAddPop.do", {custId : vCustId}, null, true);
        });
        $('#btnSelectBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#txtHiddenThirdPartyIDOwnt').val() : $('#txtHiddenCustIDOwnt').val();
            Common.popupDiv("/sales/customer/customerBankAccountSearchPop.do", {custId : vCustId, callPrgm : "ORD_REQUEST_PAY"});
        });
        $('#btnAddThirdParty').click(function() {
            Common.popupWin("searchFormOwnt", "/sales/customer/customerRegistPop.do", {width : "1200px", height : "580x"});
        });
        $('[name="grpOpt"]').click(function() {
            fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
        });
        $('#billGrpBtn').click(function() {
            Common.popupDiv("/sales/customer/customerBillGrpSearchPop.do", {custId : $('#txtHiddenCustIDOwnt').val(), callPrgm : "ORD_REQUEST_BILLGRP"}, null, true);
        });
    });
    
    function fn_loadBillingGroup(billGrpId, custBillGrpNo, billType, billAddrFull, custBillRem, custBillAddId) {
        $('#txtHiddenBillGroupIDOwnt').removeClass("readonly").val(billGrpId);
        $('#txtBillGroupOwnt').removeClass("readonly").val(custBillGrpNo);
        $('#txtBillTypeOwnt').removeClass("readonly").val(billType);
        $('#txtBillAddressOwnt').removeClass("readonly").val(billAddrFull);
        $('#txtBillGroupRemarkOwnt').removeClass("readonly").val(custBillRem);

        fn_loadMailAddress(custBillAddId);
    }
    
    function fn_setBillGrp(grpOpt) {

        if(grpOpt == 'new') {

            $('#btnAddAddress').removeClass("blind");
            $('#btnSelectAddress').removeClass("blind");
        
            fn_clearBillGroup();

            $('#grpOpt1').prop("checked", true);
        }
        else if(grpOpt == 'exist') {

            $('#btnAddAddress').removeClass("blind");
            $('#btnSelectAddress').removeClass("blind");
            
            fn_clearBillGroup();

            $('#grpOpt2').prop("checked", true);

            $('#sctBillSel').removeClass("blind");

            $('#txtBillGroupRemarkOwnt').prop("readonly", true);
        }
    }
    
    function fn_loadBankAccountPop(bankAccId) {
        fn_clearRentPaySetDD();
        fn_loadBankAccount(bankAccId);
        
        $('#sctDirectDebit').removeClass("blind");

        if(!FormUtil.IsValidBankAccount($('#txtHiddenRentPayBankAccIDOwnt').val(), $('#txtRentPayBankAccNoOwnt').val())) {
            fn_clearRentPaySetDD();
            $('#sctDirectDebit').removeClass("blind");
            Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER + "<b>Invalid account for auto debit.</b>");
        }
    }
    
    function fn_loadBankAccount(bankAccId) {
        console.log("fn_loadBankAccount START");
        
        Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

            if(rsltInfo != null) {
                console.log("fn_loadBankAccount Setting");
                
                $("#txtHiddenRentPayBankAccIDOwnt").val(rsltInfo.custAccId);
                $("#txtRentPayBankAccNoOwnt").val(rsltInfo.custAccNo);
                $("#hiddenRentPayEncryptBankAccNoOwnt").val(rsltInfo.custEncryptAccNo);
                $("#txtRentPayBankAccTypeOwnt").val(rsltInfo.codeName);
                $("#txtRentPayBankAccNameOwnt").val(rsltInfo.custAccOwner);
                $("#txtRentPayBankAccBankBranchOwnt").val(rsltInfo.custAccBankBrnch);
                $("#txtRentPayBankAccBankOwnt").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
                $("#hiddenRentPayBankAccBankIDOwnt").val(rsltInfo.custAccBankId);
            }
        });
    }
    
    function fn_loadCreditCard(crcId, custOriCrcNo, custCrcNo, custCrcType, custCrcName, custCrcExpr, custCRCBank, custCrcBankId, crcCardType) {
        $('#txtHiddenRentPayCRCIDOwnt').val(crcId);
        $('#txtRentPayCRCNoOwnt').val(custOriCrcNo);
        $('#hiddenRentPayEncryptCRCNoOwnt').val(custCrcNo);
        $('#txtRentPayCRCTypeOwnt').val(custCrcType);
        $('#txtRentPayCRCNameOwnt').val(custCrcName);
        $('#txtRentPayCRCExpiryOwnt').val(custCrcExpr);
        $('#txtRentPayCRCBankOwnt').val(custCRCBank);
        $('#hiddenRentPayCRCBankIDOwnt').val(custCrcBankId);
        $('#rentPayCRCCardTypeOwnt').val(crcCardType);
    }

    function fn_loadThirdParty(custId, sMethd) {

        fn_clearRentPayMode();
        fn_clearRentPay3thParty();
        fn_clearRentPaySetCRC();
        fn_clearRentPaySetDD();

        if(custId != $('#txtHiddenCustIDOwnt').val()) {
            Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {

            if(result != null && result.length == 1) {

                var custInfo = result[0];

                $('#txtHiddenThirdPartyIDOwnt').val(custInfo.custId)
                $('#txtThirdPartyIDOwnt').val(custInfo.custId)
                $('#txtThirdPartyTypeOwnt').val(custInfo.codeName1)
                $('#txtThirdPartyNameOwnt').val(custInfo.name)
                $('#txtThirdPartyNRICOwnt').val(custInfo.nric)
/*
                $('#thrdPartyId').removeClass("readonly");
                $('#thrdPartyType').removeClass("readonly");
                $('#thrdPartyName').removeClass("readonly");
                $('#thrdPartyNric').removeClass("readonly");
*/
            }
            else {
                if(sMethd == 2) {
                    Common.alert('<b>Third party not found.<br />'
                               + 'Your input third party ID : ' + custId + '</b>');
                }
            }
        });
        }
        else {
            Common.alert('<b>Third party and customer cannot be same person/company.<br />'
                       + 'Your input third party ID : ' + custId + '</b>');
        }

        $('#sctThrdParty').removeClass("blind");
    }
    
    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPayMode() {
        $('#cmbRentPaymodeOwnt').val('');
        $('#txtRentPayICOwnt').val('');
    }
    
    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPay3thParty() {
      //PanelThirdParty.Visible = false;
        $('#txtThirdPartyIDOwnt').val('');
        $('#txtHiddenThirdPartyIDOwnt').val('');
        $('#txtThirdPartyTypeOwnt').val('');
        $('#txtThirdPartyNameOwnt').val('');
        $('#txtThirdPartyNRICOwnt').val('');
    }
    
    //ClearControl_RentPaySet_CRC
    function fn_clearRentPaySetCRC() {
        $('#sctCrCard').addClass("blind");
        $('#txtRentPayCRCNoOwnt').val('');
        $('#txtHiddenRentPayCRCIDOwnt').val('');
        $('#hiddenRentPayEncryptCRCNoOwnt').val('');
        $('#txtRentPayCRCTypeOwnt').val('');
        $('#txtRentPayCRCNameOwnt').val('');
        $('#txtRentPayCRCExpiryOwnt').val('');
        $('#txtRentPayCRCBankOwnt').val('');
        $('#hiddenRentPayCRCBankIDOwnt').val('');
    }
    
    //ClearControl_RentPaySet_DD
    function fn_clearRentPaySetDD() {
        $('#sctDirectDebit').addClass("blind");
        $('#txtRentPayBankAccNoOwnt').val('');
        $('#txtHiddenRentPayBankAccIDOwnt').val('');
        $('#hiddenRentPayEncryptBankAccNoOwnt').val('');
        $('#txtRentPayBankAccTypeOwnt').val('');
        $('#txtRentPayBankAccNameOwnt').val('');
        $('#txtRentPayBankAccBankBranchOwnt').val('');
        $('#txtRentPayBankAccBankOwnt').val('');
        $('#hiddenRentPayBankAccBankIDOwnt').val('');
    }
    
    function fn_selectCustInfo() {
        var strCustId = $('#custIdOwnt').val();

        //CLEAR CUSTOMER
        fn_clearCustomer();
        fn_clearMailAddress();
        fn_clearContactPerson();

        //CLEAR RENTAL PAY SETTING
        $('#btnThirdPartyOwnt').prop("checked", false);

        fn_clearRentPayMode();
        fn_clearRentPay3thParty();
        fn_clearRentPaySetCRC();
        fn_clearRentPaySetDD();

        //CLEAR BILLING GROUP
        fn_clearBillGroup();

        //CLEAR INSTALLATION
        fn_clearInstAddress();
        fn_clearInstallationCntcPerson();

        if(FormUtil.isNotEmpty(strCustId) && strCustId > 0) {            
            if(CUST_ID == strCustId) {
                $('#custIdOwnt').val('');
                Common.alert("Invalid Customer ID" + DEFAULT_DELIMITER + "<b>This customer is already the owner of this order.</b>");
            }
            else {
                fn_loadCustomer(strCustId);
            }
        }
        else {
            Common.alert('<b>Invalid customer ID.</b>');
        }
    }

    //ClearControl_BillGroup
    function fn_clearBillGroup() {

        $('#grpOpt1').removeAttr("checked");
        $('#grpOpt2').removeAttr("checked");

        $('#sctBillSel').addClass("blind");
        
        $('#txtBillGroupOwnt').val('');
        $('#txtHiddenBillGroupIDOwnt').val('');
        $('#txtBillTypeOwnt').val('');
        $('#txtBillAddressOwnt').val('');
        $('#txtBillGroupRemarkOwnt').val('');
        $('#installDur').removeAttr("readonly");
    }
    
    //ClearControl_Installation_Address
    function fn_clearInstAddress() {
        $('#btnAddInstAddress').addClass("blind");
        $('#btnSelectInstAddress').addClass("blind");
        
        $('#txtHiddenInstAddressIDOwnt').val('');
        $('#txtInstAddrDtlOwnt').val('');
        $('#txtInstStreetOwnt').val('');
        $('#txtInstAreaOwnt').val('');
        $('#txtInstCityOwnt').val('');
        $('#txtInstPostcodeOwnt').val('');
        $('#txtInstStateOwnt').val('');
        $('#txtInstCountryOwnt').val('');
    }
    
    function fn_clearMailAddress() {
        
        $('#btnAddAddress').addClass("blind");
        $('#btnSelectAddress').addClass("blind");
        
        $('#txtHiddenAddressIDOwnt').val('');
        $('#txtMailAddrDtlOwnt').val('');
        $('#txtMailStreetOwnt').val('');
        $('#txtMailAreaOwnt').val('');
        $('#txtMailCityOwnt').val('');
        $('#txtMailPostcodeOwnt').val('');
        $('#txtMailStateOwnt').val('');
        $('#txtMailCountryOwnt').val('');
    }
    
    //ClearControl_Customer(Customer)
    function fn_clearCustomer() {
//      $('#custFormOwnt').clearForm();
        
        $('#custIdOwnt').clearForm();
        $('#custTypeNmOwnt').clearForm();
        $('#typeIdOwnt').clearForm();
        $('#nameOwnt').clearForm();
        $('#nricOwnt').clearForm();
        $('#nationNmOwnt').clearForm();
        $('#raceOwnt').clearForm();
        $('#raceIdOwnt').clearForm();
        $('#dobOwnt').clearForm();
        $('#genderOwnt').clearForm();
        $('#pasSportExprOwnt').clearForm();
        $('#visaExprOwnt').clearForm();
        $('#emailOwnt').clearForm();
        $('#custRemOwnt').clearForm();
        $('#empChkOwnt').clearForm();
    }
    
    function fn_loadCustomer(custId){

        $("#searchCustIdOwnt").val(custId);

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {

            if(result != null && result.length == 1) {
                
                //fn_tabOnOffSet('BIL_DTL', 'SHOW');

                var custInfo = result[0];

                console.log("성공.");
                console.log("custId : " + result[0].custId);
                console.log("userName1 : " + result[0].name);

                //
                $("#txtHiddenCustIDOwnt").val(custInfo.custId); //Customer ID(Hidden)
                $("#custIdOwnt").val(custInfo.custId); //Customer ID
                $("#custTypeNmOwnt").val(custInfo.codeName1); //Customer Name
                $("#typeIdOwnt").val(custInfo.typeId); //Type
                $("#nameOwnt").val(custInfo.name); //Name
                $("#nricOwnt").val(custInfo.nric); //NRIC/Company No
                $("#nationNmOwnt").val(custInfo.name2); //Nationality
                $("#raceIdOwnt").val(custInfo.raceId); //Nationality
                $("#raceOwnt").val(custInfo.codeName2); //
                $("#dobOwnt").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                $("#genderOwnt").val(custInfo.gender); //Gender
                $("#pasSportExprOwnt").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                $("#visaExprOwnt").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                $("#emailOwnt").val(custInfo.email); //Email
                $("#custRemOwnt").val(custInfo.rem); //Remark
                $("#empChkOwnt").val('${orderDetail.basicInfo.empChk}'); //Employee
//              $("#gstChk").val('0').prop("disabled", true);

                if(custInfo.corpTypeId > 0) {
                    $("#corpTypeNmOwnt").val(custInfo.codeName); //Industry Code
                }
                else {
                    $("#corpTypeNmOwnt").val(""); //Industry Code
                }

                if(custInfo.custAddId > 0) {

                    //----------------------------------------------------------
                    // Mail Address SETTING
                    //----------------------------------------------------------
                    fn_clearMailAddress();
                    fn_loadMailAddress(custInfo.custAddId);

                    //----------------------------------------------------------
                    // Installation Address SETTING
                    //----------------------------------------------------------
                    fn_clearInstAddress();
                    fn_loadInstAddress(custInfo.custAddId);
                }

                if(custInfo.custCntcId > 0) {
                    //----------------------------------------------------------
                    // Contact Person
                    //----------------------------------------------------------
                    fn_clearContactPerson();
                    fn_loadCntcPerson(custInfo.custCntcId);

                    //----------------------------------------------------------
                    // Installation Contact Person
                    //----------------------------------------------------------
                    fn_clearInstallationCntcPerson();
                    fn_loadInstallationCntcPerson(custInfo.custCntcId);
                }

                $('#btnSelectAddress').removeClass("blind");
                $('#btnAddAddress').removeClass("blind");
                $('#btnSelectContact').removeClass("blind");
                $('#btnAddContact').removeClass("blind");
                $('#btnSelectInstAddress').removeClass("blind");
                $('#btnAddInstAddress').removeClass("blind");
                $('#btnSelectInstContact').removeClass("blind");
                $('#btnAddInstContact').removeClass("blind");
            }
            else {
                Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
            }
        });
    }

    function createSchemAUIGrid() {
        console.log('createModAUIGrid1() START');
        
        //AUIGrid 칼럼 설정
        var docColumnLayout = [
            { headerText : "Filter Code",   dataField : "stkCode",           width : 120 }
          , { headerText : "Name",          dataField : "stkDesc", }
          , { headerText : "Change Period", dataField : "srvFilterPriod",    width : 120 }
          , { headerText : "Last Change",   dataField : "srvFilterPrvChgDt", width : 120 }
          ];

        //그리드 속성 설정
        var filterGridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
    }
    
    function fn_clearInstallationCntcPerson() {

        $('#btnSelectInstContact').removeClass("blind");
        $('#btnAddInstContact').removeClass("blind");
        
        $('#txtHiddenInstContactIDOwnt').val('');
        $('#txtInstContactNameOwnt').val('');
        $('#txtInstContactInitialOwnt').val('');
        $('#txtInstContactGenderOwnt').val('');
        $('#txtInstContactICOwnt').val('');
        $('#txtInstContactDOBOwnt').val('');
        $('#txtInstContactRaceOwnt').val('');
        $('#txtInstContactEmailOwnt').val('');
        $('#txtInstContactDeptOwnt').val('');
        $('#txtInstContactPostOwnt').val('');
        $('#txtInstContactTelMobOwnt').val('');
        $('#txtInstContactTelResOwnt').val('');
        $('#txtInstContactTelOffOwnt').val('');
        $('#txtInstContactTelFaxOwnt').val('');
    }

    function fn_loadInstallationCntcPerson(custCntcId){
        console.log("fn_loadInstallationCntcPerson START :custCntcId:"+custCntcId);

        $("#searchCustCntcId").val(custCntcId);

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(rslt) {

            if(rslt != null) {
                $("#txtHiddenInstContactIDOwnt").val(rslt.custCntcId);
                $("#txtInstContactNameOwnt").val(rslt.name1);
                $("#txtInstContactInitialOwnt").val(rslt.code);
                $("#txtInstContactGenderOwnt").val(rslt.gender);
                $("#txtInstContactICOwnt").val(rslt.nric);
                $("#txtInstContactDOBOwnt").val(rslt.dob);
                $("#txtInstContactRaceOwnt").val(rslt.codeName);
                $("#txtInstContactEmailOwnt").val(rslt.email);
                $("#txtInstContactDeptOwnt").val(rslt.dept);
                $("#txtInstContactPostOwnt").val(rslt.pos);
                $("#txtInstContactTelMobOwnt").val(rslt.telM1);
                $("#txtInstContactTelResOwnt").val(rslt.telR);
                $("#txtInstContactTelOffOwnt").val(rslt.telO);
                $("#txtInstContactTelFaxOwnt").val(rslt.telf);
            }
        });
    }
    
    function fn_loadCntcPerson(custCntcId){
        console.log("fn_loadCntcPerson START");

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(rslt) {

            if(rslt != null) {
                $("#txtHiddenContactIDOwnt").val(rslt.custCntcId);
                $("#txtContactNameOwnt").val(rslt.name1);
                $("#txtContactInitialOwnt").val(rslt.code);
                $("#txtContactGenderOwnt").val(rslt.gender);
                $("#txtContactICOwnt").val(rslt.nric);
                $("#txtContactDOBOwnt").val(rslt.dob);
                $("#txtContactRaceOwnt").val(rslt.codeName);
                $("#txtContactEmailOwnt").val(rslt.email);
                $("#txtContactDeptOwnt").val(rslt.dept);
                $("#txtContactPostOwnt").val(rslt.pos);
                $("#txtContactTelMobOwnt").val(rslt.telM1);
                $("#txtContactTelResOwnt").val(rslt.telR);
                $("#txtContactTelOffOwnt").val(rslt.telO);
                $("#txtContactTelFaxOwnt").val(rslt.telf);
            }
        });
    }
    
    function fn_clearContactPerson() {
        $('#btnAddContact').addClass("blind");
        $('#btnSelectContact').addClass("blind");
        
        $('#txtHiddenContactIDOwnt').val('');
        $('#txtContactNameOwnt').val('');
        $('#txtContactInitialOwnt').val('');
        $('#txtContactGenderOwnt').val('');
        $('#txtContactICOwnt').val('');
        $('#txtContactDOBOwnt').val('');
        $('#txtContactRaceOwnt').val('');
        $('#txtContactEmailOwnt').val('');
        $('#txtContactDeptOwnt').val('');
        $('#txtContactPostOwnt').val('');
        $('#txtContactTelMobOwnt').val('');
        $('#txtContactTelResOwnt').val('');
        $('#txtContactTelOffOwnt').val('');
        $('#txtContactTelFaxOwnt').val('');
/*
        btnAddContact.Visible = false;
        btnSelectContact.Visible = false;

        txtHiddenContactID.Text = "";
        txtContactName.Text = "";
        txtContactInitial.Text = "";
        txtContactGender.Text = "";
        txtContactIC.Text = "";
        txtContactDOB.Text = "";
        txtContactRace.Text = "";
        txtContactEmail.Text = "";
        txtContactDept.Text = "";
        txtContactPost.Text = "";
        txtContactTelMob.Text = "";
        txtContactTelRes.Text = "";
        txtContactTelOff.Text = "";
        txtContactTelFax.Text = "";
*/
    }

    function fn_loadMailAddress(custAddId){
        console.log("fn_loadMailAddress START");

        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(rslt) {

            if(rslt != null) {

                console.log("Success!!!!!!.");
                console.log("hiddenBillAddId : " + rslt.custAddId);
                console.log("rslt.addrDtl : " + rslt.addrDtl);

                $("#txtHiddenAddressIDOwnt").val(rslt.custAddId); //Customer Address ID(Hidden)
                $("#txtMailAddrDtlOwnt").val(rslt.addrDtl); //Address
                $("#txtMailStreetOwnt").val(rslt.street); //Street
                $("#txtMailAreaOwnt").val(rslt.area); //Area
                $("#txtMailCityOwnt").val(rslt.city); //City
                $("#txtMailPostcodeOwnt").val(rslt.postcode); //Post Code
                $("#txtMailStateOwnt").val(rslt.state); //State
                $("#txtMailCountryOwnt").val(rslt.country); //Country
                
              //$("#hiddenBillStreetId").val(rslt.custAddId); //Magic Address STREET_ID(Hidden)
            }
        });
    }
    
    function fn_loadInstAddress(custAddId){
        console.log("fn_loadMailAddress START");

        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(rslt) {

            if(rslt != null) {

                console.log("Success!!!!!!.");
                console.log("hiddenBillAddId : " + rslt.custAddId);
                console.log("rslt.addrDtl : " + rslt.addrDtl);

                $("#txtHiddenInstAddressIDOwnt").val(rslt.custAddId); //Customer Address ID(Hidden)
                $("#txtInstAddrDtlOwnt").val(rslt.addrDtl); //Address
                $("#txtInstStreetOwnt").val(rslt.street); //Street
                $("#txtInstAreaOwnt").val(rslt.area); //Area
                $("#txtInstCityOwnt").val(rslt.city); //City
                $("#txtInstPostcodeOwnt").val(rslt.postcode); //Post Code
                $("#txtInstStateOwnt").val(rslt.state); //State
                $("#txtInstCountryOwnt").val(rslt.country); //Country
                
              //$("#hiddenBillStreetId").val(rslt.custAddId); //Magic Address STREET_ID(Hidden)
            }
        });
    }
    
    // 리스트 조회.
    function fn_selectOrderActiveFilterList() {
        Common.ajax("GET", "/sales/membership/selectMembershipFree_oList", {ORD_ID : ORD_ID}, function(result) {
            AUIGrid.setGridData(filterGridID, result);
        });
    }
    
    function fn_getLoginInfo(){
        var userId = 0;

        Common.ajaxSync("GET", "/sales/order/loginUserId.do", '', function(rsltInfo) {
            if(rsltInfo != null) {
                userId = rsltInfo.userId;
            }
            console.log('fn_getLoginInfo userid:'+userId);
        });

        return userId;
    }
    
    function fn_getCheckAccessRight(userId, moduleUnitId){
        var result = false;

        Common.ajaxSync("GET", "/sales/order/selectCheckAccessRight.do", {userId : userId, moduleUnitId : moduleUnitId}, function(rsltInfo) {
            if(rsltInfo != null) {
                result = true;
            }
            console.log('fn_getLoginInfo result:'+result);
        });

        return result;
    }
    
    function fn_loadPromotionPriceAexc(promoId, stkId) {

        Common.ajax("GET", "/sales/order/selectProductPromotionPriceByPromoStockID.do", {promoId : promoId, stkId : stkId}, function(promoPriceInfo) {

            if(promoPriceInfo != null) {

                $("#txtPriceAexc").val(promoPriceInfo.orderPricePromo);
                $("#txtPVAexc").val(promoPriceInfo.orderPVPromo);
                $("#ordRentalFeesAexc").val(promoPriceInfo.orderRentalFeesPromo);

                $("#promoDiscPeriodTpAexc").val(promoPriceInfo.promoDiscPeriodTp);
                $("#promoDiscPeriodAexc").val(promoPriceInfo.promoDiscPeriod);
            }
            else {
                Common.alert("Unable To Find Promotion" + DEFAULT_DELIMITER + "<b>* Unable to find the promotion for this product.<br />Please reselect another promotion.</b>");
                
                if($('#btnCurrentPromo').is(":checked")) {
                    $('#btnCurrentPromo').click();
                }
            }
        });
    }

    function fn_loadPromotionPrice(promoId, stkId) {

        Common.ajax("GET", "/sales/order/selectProductPromotionPriceByPromoStockID.do", {promoId : promoId, stkId : stkId}, function(promoPriceInfo) {

            if(promoPriceInfo != null) {

                $("#ordPrice").val(promoPriceInfo.orderPricePromo);
                $("#ordPv").val(promoPriceInfo.orderPVPromo);
                $("#ordRentalFees").val(promoPriceInfo.orderRentalFeesPromo);

                $("#promoDiscPeriodTp").val(promoPriceInfo.promoDiscPeriodTp);
                $("#promoDiscPeriod").val(promoPriceInfo.promoDiscPeriod);
            }
            else {
                Common.alert("Unable To Find Promotion" + DEFAULT_DELIMITER + "<b>* Unable to find the promotion for this product.<br />Please reselect another promotion.</b>");
                
                if($('#btnCurrentPromo').is(":checked")) {
                    $('#btnCurrentPromo').click();
                }
            }
        });
    }

    //LoadProductPromotion
    function fn_loadProductPromotionAexc(appTypeVal, stkId, empChk, custTypeVal, exTrade, srvPacId) {

        $('#cmbPromotionAexc option').remove();
            
        if(appTypeVal == '' || exTrade == '') return;
        
        console.log('fn_loadProductPromotion --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPromotion --> stkId:'+stkId);
        console.log('fn_loadProductPromotion --> empChk:'+empChk);
        console.log('fn_loadProductPromotion --> custTypeVal:'+custTypeVal);
        console.log('fn_loadProductPromotion --> exTrade:'+exTrade);

        doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:srvPacId}, '', 'cmbPromotionAexc', 'S'); //Common Code
    }
    
    //LoadProductPromotion
    function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal, exTrade, srvPacId) {
        console.log('fn_loadProductPromotion --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPromotion --> stkId:'+stkId);
        console.log('fn_loadProductPromotion --> empChk:'+empChk);
        console.log('fn_loadProductPromotion --> custTypeVal:'+custTypeVal);

        $('#cmbPromotion').removeAttr("disabled");

        doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:srvPacId}, '', 'cmbPromotion', 'S', ''); //Common Code
    }

    //LoadProductPrice
    function fn_loadProductPriceAexc(appTypeVal, stkId) {
        console.log('fn_loadProductPrice --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPrice --> stkId:'+stkId);

        var appTypeId = 0;

        appTypeId = appTypeVal=='68' ? '67' : appTypeVal;

        Common.ajax("GET", "/sales/order/selectStockPriceJsonInfo.do", {appTypeId : appTypeId, stkId : stkId}, function(stkPriceInfo) {

            if(stkPriceInfo != null) {

                console.log("성공.");

                $("#txtPriceAexc").val(stkPriceInfo.orderPrice);
                $("#txtPVAexc").val(stkPriceInfo.orderPV);
                $("#ordRentalFeesAexc").val(stkPriceInfo.orderRentalFees);
                $("#ordPriceIdAexc").val(stkPriceInfo.priceId);

                $("#orgOrdPriceAexc").val(stkPriceInfo.orderPrice);
                $("#orgOrdPvAexc").val(stkPriceInfo.orderPV);
                $("#orgOrdRentalFeesAexc").val(stkPriceInfo.orderRentalFees);
                $("#orgOrdPriceIdAexc").val(stkPriceInfo.priceId);
                
                $("#promoDiscPeriodTpAexc").val('');
                $("#promoDiscPeriodAexc").val('');
            }
        });
    }
    
    //LoadProductPrice
    function fn_loadProductPrice(appTypeVal, stkId) {
        console.log('fn_loadProductPrice --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPrice --> stkId:'+stkId);

        var appTypeId = 0;

        appTypeId = appTypeVal=='68' ? '67' : appTypeVal;
/*
        $("#searchAppTypeId").val(appTypeId);
        $("#searchStkId").val(stkId);
*/
        Common.ajax("GET", "/sales/order/selectStockPriceJsonInfo.do", {appTypeId : appTypeId, stkId : stkId}, function(stkPriceInfo) {

            if(stkPriceInfo != null) {

                console.log("성공.");

                $("#ordPrice").val(stkPriceInfo.orderPrice);
                $("#ordPv").val(stkPriceInfo.orderPV);
                $("#ordRentalFees").val(stkPriceInfo.orderRentalFees);
//              $("#hiddenPriceID").val(stkPriceInfo.priceId);

                $("#orgOrdPrice").val(stkPriceInfo.orderPrice);
                $("#orgOrdPv").val(stkPriceInfo.orderPV);
                $("#orgOrdRentalFees").val(stkPriceInfo.orderRentalFees);
                $("#hiddenPriceID").val(stkPriceInfo.priceId);
                
                $("#promoDiscPeriodTp").val('');
                $("#promoDiscPeriod").val('');
            }
        });
    }
    
    function fn_changeTab(tabNm) {
        
        var userid = fn_getLoginInfo();
        var todayDD = Number(TODAY_DD.substr(0, 2));

        if(tabNm == 'CANC') {

            if(fn_getCheckAccessRight(userid, 9)) {

                if(ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                    var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>"
                            + "Order cancellation request is disallowed.";                            
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                    
                    return false;
                }

                if(todayDD == 26 || todayDD == 27 || todayDD == 1 || todayDD == 2) {
                    var msg = "Request for order cancellation is restricted on 26, 27, 1, 2 of every month";                            
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                    
                    return false;
                }
            }
            else {
                var msg = "Sorry. You have no access rights to request order cancellation.";                        
                Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                
                return false;
            }
        }
        
        if(tabNm == 'PEXC') {

            if(fn_getCheckAccessRight(userid, 10)) {
                
                if(ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                    var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>"
                            + "Produt exchange request is disallowed.";                            
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                    
                    return false;
                }
            }
            else {
                var msg = "Sorry. You have no access rights to request product exchange.";                        
                Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                
                return false;
            }
        }
        
        if(tabNm == 'SCHM') {
            var isValid = true, msg = "";
            
            if(FormUtil.isEmpty(RENTAL_STUS)) {
                isValid = false;
                msg += "* The order rental status is not REG<br/>";
            }
            else if(RENTAL_STUS != 'REG') {
                isValid = false;
                msg = "* The order rental status is not REG<br/>";
            }
        
            if(!fn_getSchemePriceSettingByPromoCode(PROMO_ID, STOCK_ID)) {
                isValid = false;
                msg = "* This order stock code / promotion code is not entitled for Scheme Exchange<br/>";
            }
            
            if(ORD_DT >= '2016-04-27') {
                isValid = false;
                msg = "* This order is placed after 2016-04-27<br/>";
            }
            
            if(!isValid) {
                Common.confirm("Invalid Order No" + DEFAULT_DELIMITER + msg, fn_selfClose);                
                return false;
            }
        }
        
        if(tabNm == 'AEXC') {

            if(fn_getCheckAccessRight(userid, 11)) {
                if(ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                    var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>"
                            + "Application type exchange request is disallowed.";                            
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                    
                    return false;
                }
                else {
                    if(APP_TYPE_ID != '66' && APP_TYPE_ID != '67' && APP_TYPE_ID != '68') {
                        var msg = "[" + ORD_NO + "] is [" + APP_TYPE_DESC + "] order.<br/>"
                                + "Only rental/outright/installment order is allow to request application type exchange.";                                
                        Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                        
                        return false;
                    }
                }
            }
            else {
                var msg = "Sorry. You have no access rights to request application type exchange.";                        
                Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                
                return false;
            }
        }
        
        if(tabNm == 'OTRN') {
            
            if(fn_getCheckAccessRight(userid, 12)) {
                
                if(ORD_STUS_ID != '4') {
                    var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>"
                            + "Only complete order is allow to transfer ownership.";                            
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                    
                    return false;
                }

                console.log('todayDD:'+todayDD);
                
                if(todayDD >= 26 || todayDD == 1) {
                    var msg = "Ownership transfer is not allowed from 26 until 1 next month.";                            
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                    
                    return false;
                }
            }
            else {
                var msg = "Sorry. You have no access rights to request ownership transfer.";                        
                Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                
                return false;
            }
        }
        
        var vTit = 'Order Request';
        
        if($("#ordReqType option:selected").index() > 0) {
            vTit += ' - '+$('#ordReqType option:selected').text();
        }
        
        $('#hTitle').text(vTit);

        if(tabNm == 'CANC') {
            $('#scCN').removeClass("blind");
            $('#aTabMI').click();
            console.log('call fn_loadListCanc');
            fn_loadListCanc();
            
            fn_loadOrderInfoCanc();

            fn_isLockOrder(tabNm);
        } else {
            $('#scCN').addClass("blind");
        }
        if(tabNm == 'PEXC') {
            $('#scPX').removeClass("blind");
            $('#aTabBI').click();

            fn_loadListPexch();
            
            fn_loadOrderInfoPexc();

            fn_isLockOrder(tabNm);
        } else {
            $('#scPX').addClass("blind");
        }
        if(tabNm == 'SCHM') {
            $('#scSC').removeClass("blind");
            $('#aTabBI').click();

            fn_loadOrderInfoSCHM();
        } else {
            $('#scSC').addClass("blind");
        }
        if(tabNm == 'AEXC') {
            $('#scAE').removeClass("blind");
            $('#aTabBI').click();
            
            fn_loadListAexc();
            
            fn_loadOrderInfoAexc();
            
            fn_isLockOrder(tabNm);
            
            fn_validateOrderAexc(ORD_NO);
        } else {
            $('#scAE').addClass("blind");
        }
        if(tabNm == 'OTRN') {
            $('#scOT').removeClass("blind");
            $('#aTabBI').click();
            
            fn_loadListOwnt();
            
            fn_loadOrderInfoOwnt();
            
            fn_isLockOrder(tabNm);
        } else {
            $('#scOT').addClass("blind");
        }

    }
    
    function fn_validateOrderAexc(ORD_NO) {
        var valid = '';
        var msgT = '';
        var msg = '';
        
        Common.ajaxSync("GET", "/sales/order/selectValidateInfo.do", {salesOrdNo : ORD_NO}, function(rsltInfo) {
            if(rsltInfo != null) {
                valid = rsltInfo.isInValid;
                msgT  = rsltInfo.msgT;
                msg   = rsltInfo.msg;
            }
        });

      if(valid == 'isInValid') {
//      if(valid != 'isInValid') { //TEST
//          Common.alert(msgT + DEFAULT_DELIMITER + "<b>"+msg+"</b>", fn_selfClose);
            Common.alert(msgT + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
            fn_disableControlAexc();
        }
    }
    
    function fn_isLockOrder(tabNm) {
        var isLock = false;
        var msg = "";
        
        console.log('isLok:'+'${orderDetail.logView.isLok}');
        console.log('prgrsId:'+'${orderDetail.logView.prgrsId}');
        console.log('prgrs:'+'${orderDetail.logView.prgrs}');
        
        if('${orderDetail.logView.isLok}' == '1' && '${orderDetail.logView.prgrsId}' != 2) {
            isLock = true;
            msg = 'This order is under progress [' + '${orderDetail.logView.prgrs}' + '].<br />';
        }

        if(isLock) {            
            if(tabNm == 'CANC') {
                msg += 'Request order cancelltion is disallowed.';
                fn_disableControlCanc();
            }
            else if(tabNm == 'PEXC') {
                msg += 'Request product exchange is disallowed.';
                fn_disableControlPexc();
            }
            else if(tabNm == 'AEXC') {
                msg += 'Request application type exchange is disallowed.';
                fn_disableControlAexc();
            }
            else if(tabNm == 'OTRN') {
                msg += 'Transfer ownership is disallowed.';
                //fn_disableControlAexc();
            }
            
            Common.alert("Order Locked" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isLock;
    }
    
    function fn_disableControlAexc() {
        $('#cmbAppTypeAexc').prop("disabled", true);
        $('#txtInstallmentDurationAexc').prop("disabled", true);
        $('#cmbPromotionAexc').prop("disabled", true);
        $('#cmbReasonAexc').prop("disabled", true);
        $('#txtPriceAexc').prop("disabled", true);
        $('#txtPVAexc').prop("disabled", true);
        $('#txtRemarkAexc').prop("disabled", true);
        
        $('#btnReqAppExch').addClass("blind");

        //hiddenDisabled.Value = "1";        
    }
    
    function fn_disableControlPexc() {
        $('#cmbOrderProduct').prop("disabled", true);
        $('#btnCurrentPromo').prop("disabled", true);
        $('#cmbPromotion').prop("disabled", true);
        $('#dpCallLogDate').prop("disabled", true);
        $('#cmbReason').prop("disabled", true);
        $('#txtRemark').prop("disabled", true);
        
        $('#btnReqPrdExch').addClass("blind");
    }
    
    function fn_disableControlCanc() {
        $('#cmbRequestor').prop("disabled", true);
        $('#cmbReason').prop("disabled", true);
        $('#dpCallLogDate').prop("disabled", true);
        $('#dpReturnDate').prop("disabled", true);
        $('#txtRemark').prop("disabled", true);
        $('#txtPenaltyAdj').prop("disabled", true);
        
        $('#btnReqOrder').addClass("blind");
    }
    
    function fn_loadOrderInfoSCHM() {
        createSchemAUIGrid();
        
        fn_selectOrderActiveFilterList();
        console.log('APP_TYPE_ID:'+APP_TYPE_ID);
        doGetComboCodeId('/sales/order/selectSalesOrderSchemeList.do', {schemeAppTypeId : APP_TYPE_ID} , '', 'cmbSchemeSchm', 'S');        
    }
        
    function fn_loadOrderInfoAexc() {
        
        fn_loadAppTypeListAexc(APP_TYPE_ID);
        fn_loadProductPriceAexc(APP_TYPE_ID, STOCK_ID);
        
        if(ORD_STUS_ID == '4') {
            $('#txtPriceAexc').removeAttr("disabled");
            $('#txtPVAexc').removeAttr("disabled");
            $('#spPrice').removeClass("blind");
            $('#spPV').removeClass("blind");
        }
        
        $('#hiddenAppTypeID').val(APP_TYPE_ID);
        $('#hiddenProductID').val(STOCK_ID);
        $('#hiddenOrderStatusID').val(ORD_STUS_ID);
        $('#hiddenCustomerID').val(CUST_ID);
    }
    
    function fn_loadAppTypeListAexc(appTypeId) {
        if(appTypeId == '66') {
            $('#cmbAppTypeAexc').append("<option value=''>Choose One</option>");
            $('#cmbAppTypeAexc').append("<option value='67'>Outright</option>");
            $('#cmbAppTypeAexc').append("<option value='68'>Installment</option>");
        }
        else if(appTypeId == '67') {
            $('#cmbAppTypeAexc').append("<option value=''>Choose One</option>");
            $('#cmbAppTypeAexc').append("<option value='68'>Installment</option>");
        }
        else if(appTypeId == '68') {
            $('#cmbAppTypeAexc').append("<option value=''>Choose One</option>");
            $('#cmbAppTypeAexc').append("<option value='67'>Outright</option>");
        }
    }
    
    function fn_loadOrderInfoOwnt() {
        if(APP_TYPE_ID == '66') {
            fn_tabOnOffSetOwnt('REN_PAY', 'SHOW');
            fn_tabOnOffSetOwnt('BIL_GRP', 'SHOW');
        }
        
        $('#dpPreferInstDateOwnt').val('${orderDetail.installationInfo.preferInstDt}');
        $('#tpPreferInstTimeOwnt').val('${orderDetail.installationInfo.preferInstTm}');
        $('#txtInstSpecialInstructionOwnt').val('${orderDetail.installationInfo.instct}');
    }
            
    function fn_loadOrderInfoCanc() {
        if(ORD_STUS_ID == '4') {
            $('#spPrfRtnDt').removeClass("blind");
            $('#dpReturnDate').removeAttr("disabled");
            
            if(APP_TYPE_ID == '66') {
                $('#scOP').removeClass("blind");
            }
        }
        if(CNVR_SCHEME_ID == '1') {
            $('#txtObPeriod').val('36');
        }
        
        fn_loadOutstandingPenaltyInfo();
    }
    
    function fn_loadOrderInfoPexc() {
        if(ORD_STUS_ID != '1') {
            if(fn_getOrderMembershipConfigByOrderID() == '0') {
                
                vAsId = fn_getCompleteASIDByOrderIDSolutionReason();
                
                if(vAsId != '') {
                    $('#hiddenFreeASID').val(vAsId);
                }
                else {
                    fn_disableControlPexc();
                    Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>This order membership was expired.<br />Exchange product is disallowed.</b>");
                }
            }
        }
    }

    function fn_loadOutstandingPenaltyInfo() {
        if(APP_TYPE_ID == '66' && ORD_STUS_ID == '4') {
            
            var vTotalUseMth = fn_getOrderLastRentalBillLedger1();
            
            if(FormUtil.isNotEmpty(vTotalUseMth)) {
                $('#txtTotalUseMth').val(vTotalUseMth);
            }
            $('#txtRentalFees').val('${orderDetail.basicInfo.ordMthRental}');
            
            var vCurrentOutstanding = fn_getOrderOutstandingInfo();
            
            if(FormUtil.isNotEmpty(vCurrentOutstanding)) {
                $('#txtCurrentOutstanding').val(vCurrentOutstanding);
            }
            
            fn_calculatePenaltyAndTotalAmount();
        }
    }

    function fn_calculatePenaltyAndTotalAmount() {
        var TotalMthUse = Number($('#txtTotalUseMth').val());
        var ObPeriod    = Number($('#txtObPeriod').val());
        var RentalFees = Number($('#txtRentalFees').val());
        var CurrentOutstanding = Number($('#txtCurrentOutstanding').val());
        var PenaltyAdj = Number($('#txtPenaltyAdj').val());
        var PenaltyAmt = 0;
        
        if (TotalMthUse < ObPeriod) {
            PenaltyAmt = ((RentalFees * (ObPeriod - TotalMthUse)) / 2);
        }
        
        $('#txtPenaltyCharge').val(PenaltyAmt);

        var TotalAmt = CurrentOutstanding + PenaltyAmt + PenaltyAdj;

        $('#txtTotalAmount').val(TotalAmt);        
        $('#spTotalAmount').text(TotalAmt);
    }
    
    function fn_getOrderOutstandingInfo() {
        console.log('fn_getOrderOutstandingInfo START');
        
        var vCurrentOutstanding = 0;
        
        Common.ajaxSync("GET", "/sales/order/selectOderOutsInfo.do", {ordId : ORD_ID}, function(result) {
            if(result != null && result.length > 0) {
//                console.log('result.outSuts[0].ordTotOtstnd:'+result.outSuts[0].ordTotOtstnd);
                console.log('result.outSuts[0].ordTotOtstnd:'+result[0].ordTotOtstnd);

                vCurrentOutstanding = result[0].ordTotOtstnd;
            }            
       });

       return vCurrentOutstanding;
    }
    
    function fn_getCompleteASIDByOrderIDSolutionReason() {

        var vAsId = '';
        
        Common.ajaxSync("GET", "/sales/order/selectCompleteASIDByOrderIDSolutionReason.do", {salesOrdId : ORD_ID, asSlutnResnId : 461}, function(result) {
            if(result != null) {
                vAsId = result.asId;
            }            
       });
        console.log('vAsId:'+vAsId);

       return vAsId;
    }
    
    function fn_getOrderMembershipConfigByOrderID() {

        var vSrvMemID = '0';
        
        Common.ajaxSync("GET", "/sales/membership/paymentConfig", {PAY_ORD_ID : ORD_ID}, function(result) {
            if(result != null) {
                vSrvMemID = result[0].srvMemId;
            }            
       });
        console.log('vSrvMemID:'+vSrvMemID);

       return vSrvMemID;
    }
    
    function fn_getOrderLastRentalBillLedger1() {

        var vTotalUseMth = 0;
        
        Common.ajaxSync("GET", "/sales/order/selectOrderLastRentalBillLedger1.do", {salesOrderId : ORD_ID}, function(result) {
            
            console.log('result:'+result);
            
            if(result != null) {
                console.log('result.custId:'+result.rentInstNo);

                vTotalUseMth = result.rentInstNo;
            }            
       });

       return vTotalUseMth;
    }
    
    function fn_clickBtnReqCancelOrder() {
        var RequestStage = "Before Install";
        
        if(ORD_STUS_ID == '4') {
            RequestStage = "After Install";
        }
        
        var msg = "";
        msg += "Request Stage : " + RequestStage + "<br />";
        msg += "Requestor : " + $('#cmbRequestor option:selected').text() + "<br />";
        msg += "Reason : " + $('#cmbReason option:selected').text() + "<br />";
        msg += "Call Log Date : " + $('#dpCallLogDate').val() + "<br />";
    
        if(ORD_STUS_ID == '4') {
            msg += "Prefer Return Date : " + $('#dpReturnDate').val() + "<br />";
            
            if(APP_TYPE_ID == 66) {
                msg += "<br />";
                msg += "Total Used Month : "   + $('#txtTotalUseMth').val()      + "<br/>";
                msg += "Obligation Period : "  + $('#txtObPeriod').val()         + "<br/>";
                msg += "Penalty Amount : "     + $('#txtPenaltyCharge').val()    + "<br/>";
                msg += "Penalty Adjustment : " + $('#txtPenaltyAdj').val().trim()+ "<br/>";
                msg += "Total Amount : "       + $('#txtTotalAmount').val()      + "<br/>";
            }
        }
        msg += "<br/>Are you sure want to request order cancellation ?<br/><br/>";

        Common.confirm("Request Cancel Confirmation" + DEFAULT_DELIMITER + "<b>"+msg+"</b>", fn_doSaveReqCanc, fn_selfClose);
    }
    
    function fn_doSaveReqAexc() {
        console.log('!@# fn_doSaveReqAexc START');

        Common.ajax("POST", "/sales/order/requestAppExch.do", $('#frmReqAppExc').serializeJSON(), function(result) {
                
                Common.alert("Application Type Exchange Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
//                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                    console.log("Error message : " + jqXHR.responseJSON.message);
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveReqSchm() {
        console.log('!@# fn_doSaveReqSchm START');
        
        $('#cmbSchemeSchmText').val($('#cmbSchemeSchm option:selected').text())
        
        Common.ajax("POST", "/sales/order/requestSchmConv.do", $('#frmReqSchmConv').serializeJSON(), function(result) {
                
                Common.alert("Save Success" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
//                  Common.alert("Failed to save" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                    console.log("Error message : " + jqXHR.responseJSON.message);
                    Common.alert("Failed to save" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveReqPexc() {
        console.log('!@# fn_doSaveReqPexc START');

        Common.ajax("POST", "/sales/order/requestProdExch.do", $('#frmReqPrdExc').serializeJSON(), function(result) {
                
                Common.alert("Product Exchange Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
//                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                    console.log("Error message : " + jqXHR.responseJSON.message);
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveReqCanc() {
        console.log('!@# fn_doSaveReqCanc START');

        Common.ajax("POST", "/sales/order/requestCancelOrder.do", $('#frmReqCanc').serializeJSON(), function(result) {
                
                Common.alert("Cancellation Request Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
//                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                    console.log("Error message : " + jqXHR.responseJSON.message);
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_doSaveReqOwnt() {
        console.log('!@# fn_doSaveReqCanc START');

        Common.ajax("POST", "/sales/order/requestOwnershipTransfer.do", $('#frmReqOwnt').serializeJSON(), function(result) {
                
                Common.alert("Ownership Transfer Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);
            
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
//                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        );
    }

    function fn_validReqOwnt() {
        var msg = "";
        
        var todayDD = Number(TODAY_DD.substr(0, 2));
        
        if(todayDD >= 26 || todayDD == 1) {
            msg = "Ownership transfer is not allowed from 26 until 1 next month.";                            
            Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);                    
            return false;
        }
        else {
            if(!fn_validReqOwntCustmer())      return false;
            if(!fn_validReqOwntMailAddress())  return false;
            if(!fn_validReqOwntContact())      return false;
            if(!fn_validReqOwntRentPaySet())   return false;
            if(!fn_validReqOwntBillGroup())    return false;
            if(!fn_validReqOwntInstallation()) return false;
        }
        return true;
    }
    
    function fn_validReqOwntInstallation() {
        var isValid = true, msg = "";
        
        if(FormUtil.checkReqValue($('#txtHiddenInstAddressIDOwnt'))) {
            isValid = false;
            msg += "* Please select an installation address.<br>";
        }
        if(FormUtil.checkReqValue($('#txtHiddenInstContactIDOwnt'))) {
            isValid = false;
            msg += "* Please select an installation contact person.<br>";
        }
        if($("#cmbDSCBranchOwnt option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the DSC branch.<br>";
        }
        if(FormUtil.checkReqValue($('#dpPreferInstDateOwnt'))) {
            isValid = false;
            msg += "* Please select prefer install date.<br>";
        }
        if(FormUtil.checkReqValue($('#tpPreferInstTimeOwnt'))) {
            isValid = false;
            msg += "* Please select prefer install time.<br>";
        }
        
        if(!isValid) {
            $('#tabIN').click();
            Common.alert("Ownership Transfer Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isValid;
    }
    
    function fn_validReqOwntBillGroup() {
        var isValid = true, msg = "";
        
        if(APP_TYPE_ID == '66') {
            if(!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(":checked")) {
                isValid = false;
                msg += "* Please select the group option.<br>";
            }
            else {
                if($('#grpOpt2').is(":checked")) {
                    if(FormUtil.checkReqValue($('#txtHiddenBillGroupIDOwnt'))) {
                        isValid = false;
                        msg += "* Please select a billing group.<br>";
                    }
                }
            }
        }
        
        if(!isValid) {
            $('#tabBG').click();
            Common.alert("Ownership Transfer Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isValid;
    }
    
    function fn_validReqOwntRentPaySet() {
        var isValid = true, msg = "";

        if(APP_TYPE_ID == '66') {
            if($('#btnThirdPartyOwnt').is(":checked")) {
                if(FormUtil.checkReqValue($('#txtHiddenThirdPartyID'))) {
                    isValid = false;
                    msg += "* Please select the third party.<br>";
                }
            }
            if($("#cmbRentPaymodeOwnt option:selected").index() <= 0) {
                Common.ajaxSync("GET", "/sales/order/selectOderOutsInfo.do", {ordId : ORD_ID}, function(result) {
                    if(result != null && result.length > 0) {
                        if(result[0].lastBillMth != 60 || result[0].ordTotOtstnd != 0) {
                            isValid = false;
                            msg += "* Please select the rental paymode.<br>";
                        }                        
                    }
                });
            }
            else {
                if($("#cmbRentPaymodeOwnt").val() <= '131') { //CRC
                    if(FormUtil.checkReqValue($('#txtHiddenRentPayCRCIDOwnt'))) {
                        isValid = false;
                        msg += "* Please select a credit card.<br>";
                    }
                    else {
                        if(FormUtil.checkReqValue($('#hiddenRentPayCRCBankIDOwnt')) || $('#hiddenRentPayCRCBankIDOwnt').val() == '0') {
                            isValid = false;
                            msg += "* Invalid credit card issue bank.<br>";
                        }
                    }
                }
                else if($("#cmbRentPaymodeOwnt").val() <= '132') { //DD
                    if(FormUtil.checkReqValue($('#txtHiddenRentPayBankAccIDOwnt'))) {
                        isValid = false;
                        msg += "* Please select a bank account.<br>";
                    }
                    else {
                        if(FormUtil.checkReqValue($('#hiddenRentPayBankAccBankIDOwnt')) || $('#hiddenRentPayBankAccBankIDOwnt').val() == '0') {
                            isValid = false;
                            msg += "* Invalid bank account issue bank.<br>";
                        }
                    }
                }
            }
        }
        
        if(!isValid) {
            $('#tabRP').click();
            Common.alert("Ownership Transfer Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isValid;
    }
    
    function fn_validReqOwntContact() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#txtHiddenContactIDOwnt'))) {
            isValid = false;
            msg += "* Please select a contact person.<br>";
        }
        
        if(!isValid) {
            $('#tabCP').click();
            Common.alert("Ownership Transfer Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isValid;
    }
    
    function fn_validReqOwntMailAddress() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#txtHiddenAddressIDOwnt'))) {
            isValid = false;
            msg += "* Please select an address.<br>";
        }
        
        if(!isValid) {
            $('#tabMA').click();
            Common.alert("Ownership Transfer Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isValid;
    }
    
    function fn_validReqOwntCustmer() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#txtHiddenCustIDOwnt'))) {
            isValid = false;
            msg += "* Please select a customer.<br>";
        }
        
        if(!isValid) {
            $('#tabCT').click();
            Common.alert("Ownership Transfer Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isValid;
    }
    
    function fn_validReqPexc() {
        var isValid = true, msg = "";

        if($("#cmbOrderProduct option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the product to exchange.<br>";
        }
        if(!$('#btnCurrentPromo').is(":checked")) {
            if($("#cmbPromotion option:selected").index() <= 0) {
                isValid = false;
                msg += "* Please select the promotion option.<br>";
            }
        }
        if(FormUtil.checkReqValue($('#dpCallLogDateExch'))) {
            isValid = false;
            msg += "* Please key in the call log date.<br>";
        }
        if($("#cmbReasonExch option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the reason.<br>";
        }
        if($("#cmbOrderProduct option:selected").index() > 0) {
            
            if(ORD_STUS_ID == '4') {
                
                var userid = fn_getLoginInfo();
                            
                //AFTER INSTALL CASE
                if(!fn_getCheckAccessRight(userid, '294')) {
                    if($('#hiddenCurrentProductMasterStockID').val() > 0) {
                        //Current Product = Stock B
                        if(($('#cmbOrderProduct').val() != $('#hiddenCurrentProductID').val())
                        && ($('#cmbOrderProduct').val() != $('#hiddenCurrentProductMasterStockID').val())) {
                            isValid = false;
                            msg += "* Order (after installation) is allowed for same model exchange only.<br />";
                        }
                    }
                    else {
                        //Current Product = Stock A
                        if($('#cmbOrderProduct').val() != $('#hiddenCurrentProductID').val()) {
                            isValid = false;
                            msg += "* Order (after installation) is allowed for same model exchange only.<br />";
                        }
                    }
                }
            }
            else {
                //BEFORE INSTALL CASE
                if($('#cmbOrderProduct').val() != $('#hiddenCurrentProductID').val()) {
                    if(fn_getMembershipPurchase()) {
                        isValid = false;
                        msg += "* Purchased membership found. Only same model exchange is allowed.<br />";
                    }
                }
            }
        }
        
        if(!isValid) Common.alert("Product Exchange Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_validReqAexc() {
        var isValid = true, msg = "";

        if($("#cmbAppTypeAexc option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the application type.<br>";
        }
        else if($("#cmbAppTypeAexc").val() == '68' && FormUtil.checkReqValue($('#txtInstallmentDurationAexc'))){
            isValid = false;
            msg += "* Please key in the installment duration.<br>";
        }
        if($("#cmbPromotionAexc option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the promotion option.<br>";
        }
        if($("#cmbReasonAexc option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the reason code.<br>";
        }
        if(FormUtil.checkReqValue($('#txtPriceAexc'))) {
            isValid = false;
            msg += "* Price/RPF is required.<br>";
        }
        if(FormUtil.checkReqValue($('#txtPVAexc'))) {
            isValid = false;
            msg += "* PV is required.<br>";
        }
        
        if(!isValid) Common.alert("Applicatiom Type Exchange Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_getMembershipPurchase() {
        var isExist = false;
        Common.ajaxSync("GET", "/sales/membership/selectMembershipList", {ORD_NO : ORD_ID, MBRSH_STUS_ID : '1', MBRSH_STUS_ID : '4'}, function(result) {
            if(result != null && result.length > 0) {
                isExist = true;
            }
       });       
       return isExist;
    }
    
    function fn_getSchemePriceSettingByPromoCode(PromoID, StockID) {
        var isExist = false;
        Common.ajaxSync("GET", "/sales/order/selectSchemePriceSettingByPromoCode.do", {schemePromoId : PromoID, schemeStockId : StockID}, function(result) {
            if(result != null) {
                isExist = true;
            }
        });       
       return isExist;
    }
    
    function fn_validReqCanc() {
        var isValid = true, msg = "";

        if($("#cmbRequestor option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the requestor.<br>";
        }
        if($("#cmbReason option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the reason.<br>";
        }
        if(FormUtil.checkReqValue($('#dpCallLogDate'))) {
            isValid = false;
            msg += "* Please key in the call log date.<br>";
        }
        if(ORD_STUS_ID == '4' && FormUtil.checkReqValue($('#dpReturnDate'))) {
            isValid = false;
            msg += "* Please key in the prefer return date.<br>";
        }
        if(FormUtil.checkReqValue($('#txtRemark'))) {
            isValid = false;
            msg += "* Please key in the remark.<br>";
        }
        
        if(!isValid) Common.alert("Order Cancellation Request Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
    
    function fn_loadListPexch() {
        var stkType = APP_TYPE_ID == '1412' ? '3' : '1';
        
        doGetProductCombo('/common/selectProductCodeList.do',  stkType, '', 'cmbOrderProduct', 'S', ''); //Product Code
        doGetComboData('/sales/order/selectResnCodeList.do', {resnTypeId : '287', stusCodeId:'1'}, '', 'cmbReasonExch', 'S', ''); //Reason Code
        doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp', 'S'); //Discount period
    }
    
    function fn_loadListAexc() {
        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, '0', 'exTradeAexc', 'S'); //EX-TRADE
        doGetComboData('/sales/order/selectResnCodeList.do', {resnTypeId : '287', stusCodeId:'1'}, '', 'cmbReasonAexc', 'S', ''); //Reason Code
        doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTpAexc', 'S'); //Discount period
    }

    function fn_loadListCanc() {
        doGetComboOrder('/common/selectCodeList.do', '52',  'CODE_ID',  '', 'cmbRequestor', 'S', ''); //Common Code
        doGetComboData('/sales/order/selectResnCodeList.do', {resnTypeId : '536', stusCodeId:'1'}, '', 'cmbReason', 'S', 'fn_removeOpt'); //Reason Code
    }
    
    function fn_loadListOwnt() {
        doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, '',  'empChkOwnt',  'S'); //EMP_CHK
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '', 'cmbRentPaymodeOwnt', 'S', ''); //Common Code
        doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '${orderDetail.installationInfo.dscId}', 'cmbDSCBranchOwnt',  'S', ''); //Branch Code
    }
    
    function fn_tabOnOffSetOwnt(tabNm, opt) {
        switch(tabNm) {
            case 'REN_PAY' :
                if(opt == 'SHOW') {
                    if($('#tabRP').hasClass("blind")) $('#tabRP').removeClass("blind");
                    if($('#atcRP').hasClass("blind")) $('#atcRP').removeClass("blind");
                } else if(opt == 'HIDE') {
                    if(!$('#tabRP').hasClass("blind")) $('#tabRP').addClass("blind");
                    if(!$('#atcRP').hasClass("blind")) $('#atcRP').addClass("blind");
                }
                break;
            case 'BIL_GRP' :
                if(opt == 'SHOW') {
                    if($('#tabBG').hasClass("blind")) $('#tabBG').removeClass("blind");
                    if($('#atcBG').hasClass("blind")) $('#atcBG').removeClass("blind");
                } else if(opt == 'HIDE') {
                    if(!$('#tabBG').hasClass("blind")) $('#tabBG').addClass("blind");
                    if(!$('#atcBG').hasClass("blind")) $('#atcBG').addClass("blind");
                }
                break;
            default :
                break;
        }
    }
    
    function fn_removeOpt() {
        $('#cmbReason').find("option").each(function() {
            if($(this).val() == '1638' || $(this).val() == '1979' || $(this).val() == '1980' || $(this).val() == '1994') {
                $(this).remove();
            }
        });
    }
    
    function fn_selfClose() {
        $('#btnCloseReq').click();
    }
    
    function fn_reloadPage(){
        Common.popupDiv("/sales/order/orderRequestPop.do", { salesOrderId : ORD_ID, ordReqType : $('#ordReqType').val() }, null , true);
        $('#btnCloseReq').click();
    }
    
    function fn_setDefaultSrvPacId() {
        if($('#srvPacIdAexc option').size() == 2) {
            $('#srvPacIdAexc option:eq(1)').attr('selected', 'selected');
            
            fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(), STOCK_ID, EMP_CHK, CUST_TYPE_ID, $("#exTradeAexc").val(), $('#srvPacIdAexc').val()); 
        }
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="hTitle">Order Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnCloseReq" href="#">CLOSE</a></p></li>
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
    <select id="ordReqType" class="mr5"></select>
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
    Order Cancellation Request START
------------------------------------------------------------------------------->
<section id="scCN" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Order Cancellation Request Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="frmReqCanc" action="#" method="post">

<input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}"/>

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
    <th scope="row">Requestor<span class="must">*</span></th>
    <td>
    <select id="cmbRequestor" name="cmbRequestor" class="w100p"></select>
    </td>
    <th scope="row">Call Log Date<span class="must">*</span></th>
    <td><input id="dpCallLogDate" name="dpCallLogDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row">Reason<span class="must">*</span></th>
    <td>
    <select id="cmbReason" name="cmbReason" class="w100p"></select>
    </td>
    <th scope="row">Prefer Return Date<span id="spPrfRtnDt" class="must blind">*</span></th>
    <td><input id="dpReturnDate" name="dpReturnDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" disabled/></td>
</tr>
<tr>
    <th scope="row">OCR Remark<span class="must">*</span></th>
    <td colspan="3"><textarea id="txtRemark" name="txtRemark" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- Outstanding & Penalty Info Edit START------------------------------------->
<section id="scOP" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Outstanding & Penalty Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="4"></td>
    <th scope="row">Total Amount (RM)</th>
    <td class="bg-black"><span id="spTotalAmount"></span>
    <input id="txtTotalAmount" name="txtTotalAmount" type="hidden" />
    </td>
</tr>
<tr>
    <th scope="row">Total Used Month</th>
    <td><input id="txtTotalUseMth" name="txtTotalUseMth" type="text" class="w100p readonly" value="0" readonly></td>
    <th scope="row">Obligation Period</th>
    <td><input id="txtObPeriod" name="txtObPeriod" type="text" class="w100p readonly" value="24" readonly></td>
    <th scope="row">Rental Fees</th>
    <td><input id="txtRentalFees" name="txtRentalFees" type="text" class="w100p readonly" readonly></td>
</tr>
<tr>
    <th scope="row">Penalty Charge</th>
    <td><input id="txtPenaltyCharge" name="txtPenaltyCharge" type="text" class="w100p readonly" readonly></td>
    <th scope="row">Penalty Adjustment<span class="must">*</span></th>
    <td><input id="txtPenaltyAdj" name="txtPenaltyAdj" type="text" title="" placeholder="Penalty Adjustment" class="w100p" value="0" /></td>
    <th scope="row">Current Outstanding</th>
    <td><input id="txtCurrentOutstanding" name="txtCurrentOutstanding" type="text" class="w100p readonly" readonly></td>
</tr>
</tbody>
</table><!-- table end -->

</section>
<!-- Outstanding & Penalty Info Edit END--------------------------------------->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="btnReqCancOrder" href="#">Request Cancel Order</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Order Cancellation Request END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Order Product Exchange Request START
------------------------------------------------------------------------------->
<section id="scPX" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Product Exchange Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="frmReqPrdExc" action="#" method="post">

<input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}"/>
<input id="hiddenFreeASID" name="hiddenFreeASID" type="hidden" value=""/>
<input id="hiddenPriceID" name="hiddenPriceID" type="hidden" value=""/>
<input id="hiddenCurrentProductMasterStockID" name="hiddenCurrentProductMasterStockID" type="hidden" value="${orderDetail.basicInfo.masterStkId}"/>
<input id="hiddenCurrentProductID" name="hiddenCurrentProductID" type="hidden" value="${orderDetail.basicInfo.stockId}"/>
<input id="hiddenCurrentPromotionID" name="hiddenCurrentPromotionID" type="hidden" value="${orderDetail.basicInfo.ordPromoId}"/>
<input id="hiddenCurrentPromotion" name="hiddenCurrentPromotion" type="hidden" value="${orderDetail.basicInfo.ordPromoDesc}"/>
        
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Product<span class="must">*</span></th>
    <td>
    <select id="cmbOrderProduct" name="cmbOrderProduct" class="w100p"></select>
    </td>
    <th scope="row">Price/RPF (RM)</th>
    <td><input id="ordPrice"    name="ordPrice"    type="text" title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly />
        <input id="ordPriceId"  name="ordPriceId"  type="hidden" />
        <input id="orgOrdPrice" name="orgOrdPrice" type="hidden" />
        <input id="orgOrdPv"    name="orgOrdPv"    type="hidden" /></td>
</tr>
<tr>
    <th scope="row">Promotion<span class="must">*</span></th>
    <td>
    <select id="cmbPromotion" name="cmbPromotion" class="w100p"></select>
    </td>
    <th scope="row">Normal Rental Fees (RM)</th>
    <td><input id="orgOrdRentalFees" name="orgOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td><input id="ordPv" name="ordPv" type="text" title="" placeholder="Point Value (PV)" class="w100p readonly" readonly /></td>
    <th scope="row">Discount Period/<br>Final Rental Fee</th>
    <td><p><select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p" disabled></select></p>
        <p><input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder="" style="width:42px;" class="readonly" readonly/></p>
        <p><input id="ordRentalFees" name="ordRentalFees" type="text" title="" placeholder="" style="width:90px;"  class="readonly" readonly/></p></td>
</tr>
<tr>
    <th scope="row">Apply Current Promotion</th>
    <td colspan="3"><input id="btnCurrentPromo" name="btnCurrentPromo" value="1" type="checkbox" disabled/></td>
</tr>
<tr>
    <th scope="row">Call Log Date<span class="must">*</span></th>
    <td><input id="dpCallLogDateExch" name="dpCallLogDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
    <th scope="row">Reason<span class="must">*</span></th>
    <td>
    <select id="cmbReasonExch" name="cmbReason" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">PEX Remark</th>
    <td colspan="3"><textarea id="txtRemarkExch" name="txtRemark" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="btnReqPrdExch" href="#">Request Product Exchange</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Order Product Exchange Request END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Order Scheme Conversion Request START
------------------------------------------------------------------------------->
<section id="scSC" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Filter Information</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_filter_wrap" style="width:100%; height:200; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Scheme Selection</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="frmReqSchmConv" action="#" method="post">

<input name="salesOrdId"    type="hidden" value="${orderDetail.basicInfo.ordId}"/>
<input name="appTypeId"     type="hidden" value="${orderDetail.basicInfo.appTypeId}"/>
<input name="schemePromoId" type="hidden" value="${orderDetail.basicInfo.ordPromoId}"/>
<input name="schemeStockId" type="hidden" value="${orderDetail.basicInfo.stockId}"/>
<input id="cmbSchemeSchmText" name="cmbSchemeSchmText" type="hidden" value="${orderDetail.basicInfo.stockId}"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Scheme<span class="must">*</span></th>
    <td>
    <select id="cmbSchemeSchm" name="cmbScheme" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td><input id="txtRemarkSchm" name="txtRemark" type="text" title="" placeholder="Remark" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="btnReqSchmConv" href="#">Request Scheme Change</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Order Scheme Conversion Request END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Application Type Exchange Request START
------------------------------------------------------------------------------->
<section id="scAE" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Application Type Exchange Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="frmReqAppExc" action="#" method="post">

<input name="salesOrdId"    type="hidden" value="${orderDetail.basicInfo.ordId}"/>
<input name="appTypeId"     type="hidden" value="${orderDetail.basicInfo.appTypeId}"/>
<input id="hiddenProductID" name="hiddenProductID" type="hidden" value="${orderDetail.basicInfo.stockId}"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Application Type<span class="must">*</span></th>
    <td>
    <p><select id="cmbAppTypeAexc" name="cmbAppType" class="w100p"></select></select></p>
    <p><select id="srvPacIdAexc" name="srvPacId" class="w100p"></select></p>
    </td>
    <th scope="row">Ex-Trade<span class="must blind">*</span></th>
    <td><p><select id="exTradeAexc" name="exTrade" class="w100p"></select></p>
        <p><input id="relatedNoAexc" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly /></p></td>
</tr>
<tr>
    <th scope="row">Product<span class="must">*</span></th>
    <td><span>${orderDetail.basicInfo.stockDesc}</span></td>
    <th scope="row">Installment Duration<span id="spInstDur" class="must blind">*</span></th>
    <td><input id="txtInstallmentDurationAexc" name="txtInstallmentDuration" type="text" title="" placeholder="Installmen Duration (1-36 months)" class="w100p" disabled/></td>
</tr>
<tr>
    <th scope="row">Promotion<span class="must">*</span></th>
    <td>
    <select id="cmbPromotionAexc" name="cmbPromotion" class="w100p" disabled></select>
    </td>
    <th scope="row">Reason<span class="must">*</span></th>
    <td>
    <select id="cmbReasonAexc" name="cmbReason" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Price/RPF<span id="spPrice" class="must blind">*</span></th>
    <td><input id="txtPriceAexc" name="txtPrice" type="text" title="" placeholder="Price/RPF" class="w100p readonly" readonly/>
        <input id="orgOrdPriceAexc" name="orgOrdPrice" type="hidden" />
        <input id="ordPriceIdAexc"  name="ordPriceId"  type="hidden" />
        <input id="orgOrdPriceIdAexc" name="orgOrdPriceId"    type="hidden" />
        <input id="orgOrdPvAexc"    name="orgOrdPv"    type="hidden" /></td>
    <th scope="row">Normal Rental Fees (RM)</th>
    <td><input id="orgOrdRentalFeesAexc" name="orgOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">PV<span id="spPV" class="must blind">*</span></th>
    <td><input id="txtPVAexc" name="txtPV" type="text" title="" placeholder="PV" class="w100p readonly" readonly/></td>
    <th scope="row">Discount Period/<br>Final Rental Fee</th>
    <td><p><select id="promoDiscPeriodTpAexc" name="promoDiscPeriodTp" class="w100p" disabled></select></p>
        <p><input id="promoDiscPeriodAexc" name="promoDiscPeriod" type="text" title="" placeholder="" style="width:42px;" class="readonly" readonly/></p>
        <p><input id="ordRentalFeesAexc" name="ordRentalFees" type="text" title="" placeholder="" style="width:90px;"  class="readonly" readonly/></p></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea id="txtRemarkAexc" name="txtRemark" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="btnReqAppExch" href="#">Exchange Application Type</a></p></li>
</ul>

</section>
<!------------------------------------------------------------------------------
    Application Type Exchange Request END
------------------------------------------------------------------------------->
<!------------------------------------------------------------------------------
    Ownership Transfer Request START
------------------------------------------------------------------------------->
<section id="scOT" class="blind">
<form id="searchFormOwnt" name="searchForm" action="#" method="post">
    <input id="searchCustIdOwnt" name="custId" type="hidden"/>
</form>

<form id="frmReqOwnt" name="frmReqOwnt" action="#" method="post">
<input                                 name="salesOrdId"             type="hidden" value="${orderDetail.basicInfo.ordId}"/>
<input                                 name="hiddenCurrentCustID"    type="hidden" value="${orderDetail.basicInfo.custId}"/>
<input id="txtHiddenCustIDOwnt"        name="txtHiddenCustID"        type="hidden"/>
<input id="hiddenCustTypeIDOwnt"       name="hiddenCustTypeID"       type="hidden"/>
<input id="txtHiddenContactIDOwnt"     name="txtHiddenContactID"     type="hidden"/>
<input id="txtHiddenAddressIDOwnt"     name="txtHiddenAddressID"     type="hidden"/>
<input id="hiddenAppTypeIDOwnt"        name="hiddenAppTypeID"        type="hidden"/>
<input id="txtHiddenInstAddressIDOwnt" name="txtHiddenInstAddressID" type="hidden"/>
<input id="txtHiddenInstContactIDOwnt" name="txtHiddenInstContactID" type="hidden"/>

<aside class="title_line"><!-- title_line start -->
<h3>Ownership Transfer Information</h3>
</aside><!-- title_line end -->

<section class="tap_wrap"><!-- tap_wrap start -->

<ul class="tap_type1 num4">
    <li id="tabCT"><a href="#" class="on">Customer</a></li>
    <li id="tabMA"><a href="#">Mailing Address</a></li>
    <li id="tabCP"><a href="#">Contact Person</a></li>
    <li id="tabRP" class="blind"><a href="#">Rental Pay Setting</a></li>
    <li id="tabBG" class="blind"><a href="#">Rental Billing Group</a></li>
    <li id="tabIN"><a href="#">Installation</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="addCustBtn" href="#">Add New Customer</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID<span class="must">*</span></th>
    <td><input id="custIdOwnt" name="txtCustID" type="text" title="" placeholder="Customer ID" class="" /><a class="search_btn" id="custBtnOwnt"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Type</th>
    <td><input id="custTypeNmOwnt" name="txtCustType" type="text" title="" placeholder="Customer Type" class="w100p" readonly/>
        <input id="typeIdOwnt" name="hiddenCustTypeID" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="nameOwnt" name="txtCustName" type="text" title="" placeholder="Customer Name" class="w100p" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="nricOwnt" name="txtCustIC" type="text" title="" placeholder="NRIC/Company No" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <td><input id="nationNmOwnt" name="txtCustNationality" type="text" title="" placeholder="Nationality" class="w100p" readonly/></td>
    <th scope="row">Race</th>
    <td><input id="raceOwnt" name="txtCustRace" type="text" title="" placeholder="Race" class="w100p" readonly/>
        <input id="raceIdOwnt" name="hiddenCustRaceID" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row">DOB</th>
    <td><input id="dobOwnt" name="txtCustDOB" type="text" title="" placeholder="DOB" class="w100p" readonly/></td>
    <th scope="row">Gender</th>
    <td><input id="genderOwnt" name="txtCustGender" type="text" title="" placeholder="Gender" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Passport Expiry</th>
    <td><input id="pasSportExprOwnt" name="txtCustPassportExpiry" type="text" title="" placeholder="Passport Expiry" class="w100p" readonly/></td>
    <th scope="row">Visa Expiry</th>
    <td><input id="visaExprOwnt" name="txtCustVisaExpiry" type="text" title="" placeholder="Visa Expiry" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="emailOwnt" name="txtCustEmail" type="text" title="" placeholder="Email Address" class="w100p" readonly/></td>
    <th scope="row">Industry Code</th>
    <td><input id="corpTypeNmOwnt" name="corpTypeNm" type="text" title="" placeholder="Industry Code" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Employee<span class="must">*</span></th>
    <td colspan="3"><select id="empChkOwnt" name="empChk" class="w100p"></select></select></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea  id="custRemOwnt" name="txtCustRemark" cols="20" rows="5" placeholder="Remark" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<ul class="right_btns mb10">
    <li id="btnAddAddress" class="blind"><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
    <li id="btnSelectAddress" class="blind"><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Address Detail<span class="must">*</span></th>
    <td colspan="3">
    <input id="txtMailAddrDtlOwnt" name="txtMailAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td colspan="3">
    <input id="txtMailStreetOwnt" name="txtMailStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td colspan="3">
    <input id="txtMailAreaOwnt" name="txtMailArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">City<span class="must">*</span></th>
    <td>
    <input id="txtMailCityOwnt" name="txtMailCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/>
    </td>
    <th scope="row">PostCode<span class="must">*</span></th>
    <td>
    <input id="txtMailPostcodeOwnt" name="txtMailPostcode" type="text" title="" placeholder="Postcode" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <input id="txtMailStateOwnt" name="txtMailState" type="text" title="" placeholder="State" class="w100p readonly" readonly/>
    </td>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <input id="txtMailCountryOwnt" name="txtMailCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<ul class="right_btns mb10">
    <li id="btnAddContact" class="blind"><p class="btn_grid"><a id="mstCntcNewAddBtn" href="#">Add New Contact</a></p></li>
    <li id="btnSelectContact" class="blind"><p class="btn_grid"><a id="mstCntcSelAddBtn" href="#">Select Another Contact</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td><input id="txtContactNameOwnt" name="txtContactName" type="text" title="" placeholder="Name" class="w100p readonly" readonly /></td>
    <th scope="row">Initial</th>
    <td><input id="txtContactInitialOwnt" name="txtContactInitial" type="text" title="" placeholder="Initial" class="w100p readonly" readonly /></td>
    <th scope="row">Gender</th>
    <td><input id="txtContactGenderOwnt" name="txtContactGender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input id="txtContactICOwnt" name="txtContactIC" type="text" title="" placeholder="NRIC" class="w100p readonly" readonly /></td>
    <th scope="row">DOB</th>
    <td><input id="txtContactDOBOwnt" name="txtContactDOB" type="text" title="" placeholder="DOB" class="w100p readonly" readonly /></td>
    <th scope="row">Race</th>
    <td><input id="txtContactRaceOwnt" name="txtContactRace" type="text" title="" placeholder="Race" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="txtContactEmailOwnt" name="txtContactEmail" type="text" title="" placeholder="Email" class="w100p readonly" readonly /></td>
    <th scope="row">Department</th>
    <td><input id="txtContactDeptOwnt" name="txtContactDept" type="text" title="" placeholder="Department" class="w100p readonly" readonly /></td>
    <th scope="row">Post</th>
    <td><input id="txtContactPostOwnt" name="txtContactPost" type="text" title="" placeholder="Post" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><input id="txtContactTelMobOwnt" name="txtContactTelMob" type="text" title="" placeholder="Telephone Number (Mobile)" class="w100p readonly" readonly /></td>
    <th scope="row">Tel (Residence)</th>
    <td><input id="txtContactTelResOwnt" name="txtContactTelRes" type="text" title="" placeholder="Telephone Number (Residence)" class="w100p readonly" readonly /></td>
    <th scope="row">Tel (Office)</th>
    <td><input id="txtContactTelOffOwnt" name="txtContactTelOff" type="text" title="" placeholder="Telephone Number (Office)" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><input id="txtContactTelFaxOwnt" name="txtContactTelFax" type="text" title="" placeholder="Telephone Number (Fax)" class="w100p readonly" readonly /></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->
<!--############################################################################
    Rental Pay Set
############################################################################-->
<article id="atcRP" class="tap_area blind"><!-- tap_area start -->


<section class="search_table"><!-- search_table start -->

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Pay By Third Party</th>
    <td colspan="3">
    <label><input id="btnThirdPartyOwnt" name="btnThirdParty" type="checkbox" value="1"/><span></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctThrdParty" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Third Party</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnAddThirdParty" href="#">Add New Third Party</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Third Party - Form ID(thrdPartyForm)
------------------------------------------------------------------------------->
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
    <td><input id="txtThirdPartyIDOwnt" name="txtThirdPartyID" type="text" title="" placeholder="Third Party ID" class="" />
        <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="txtHiddenThirdPartyIDOwnt" name="txtHiddenThirdPartyID" type="hidden" /></td>
    <th scope="row">Type</th>
    <td><input id="txtThirdPartyTypeOwnt" name="txtThirdPartyType" type="text" title="" placeholder="Costomer Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="txtThirdPartyNameOwnt" name="txtThirdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="txtThirdPartyNRICOwnt" name="txtThirdPartyNRIC" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</section>

<!------------------------------------------------------------------------------
    Rental Paymode - Form ID(rentPayModeForm)
------------------------------------------------------------------------------->
<section id="sctRentPayMode">

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
    <select id="cmbRentPaymodeOwnt" name="cmbRentPaymode" class="w100p"></select>
    </td>
    <th scope="row">NRIC on DD/Passbook</th>
    <td><input id="txtRentPayICOwnt" name="txtRentPayIC" type="text" title="" placeholder="NRIC appear on DD/Passbook" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</section>

<section id="sctCrCard" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Credit Card</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnAddCRC" href="#">Add New Credit Card</a></p></li>
    <li><p class="btn_grid"><a id="btnSelectCRC" href="#">Select Another Credit Card</a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Credit Card - Form ID(crcForm)
------------------------------------------------------------------------------->

<table class="type1 mb1m"><!-- table start -->
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
    <td><input id="txtRentPayCRCNoOwnt" name="txtRentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly/>
        <input id="txtHiddenRentPayCRCIDOwnt" name="txtHiddenRentPayCRCID" type="hidden" />
        <input id="hiddenRentPayEncryptCRCNoOwnt" name="hiddenRentPayEncryptCRCNo" type="hidden" /></td>
    <th scope="row">Credit Card Type</th>
    <td><input id="txtRentPayCRCTypeOwnt" name="txtRentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name On Card</th>
    <td><input id="txtRentPayCRCNameOwnt" name="txtRentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p readonly" readonly/></td>
    <th scope="row">Expiry</th>
    <td><input id="txtRentPayCRCExpiryOwnt" name="txtRentPayCRCExpiry" type="text" title="" placeholder="Credit Card Expiry" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><input id="txtRentPayCRCBankOwnt" name="txtRentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCBankIDOwnt" name="hiddenRentPayCRCBankID" type="hidden" title="" class="w100p" /></td>
    <th scope="row">Card Type</th>
    <td><input id="rentPayCRCCardTypeOwnt" name="rentPayCRCCardType" type="text" title="" placeholder="Card Type" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
</ul>
</section>

<section id="sctDirectDebit" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Direct Debit</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnAddBankAccount" href="#">Add New Bank Account</a></p></li>
    <li><p class="btn_grid"><a id="btnSelectBankAccount" href="#">Select Another Bank Account</a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Direct Debit - Form ID(ddForm)
------------------------------------------------------------------------------->

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
    <th scope="row">Account Number<span class="must">*</span></th>
    <td><input id="txtRentPayBankAccNoOwnt" name="txtRentPayBankAccNo" type="text" title="" placeholder="Account Number readonly" class="w100p readonly" readonly/>
        <input id="txtHiddenRentPayBankAccIDOwnt" name="txtHiddenRentPayBankAccID" type="hidden" />
        <input id="hiddenRentPayEncryptBankAccNoOwnt" name="hiddenRentPayEncryptBankAccNo" type="hidden" /></td>
    <th scope="row">Account Type</th>
    <td><input id="txtRentPayBankAccTypeOwnt" name="txtRentPayBankAccType" type="text" title="" placeholder="Account Type readonly" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><input id="txtRentPayBankAccNameOwnt" name="txtRentPayBankAccName" type="text" title="" placeholder="Account Holder" class="w100p readonly" readonly/></td>
    <th scope="row">Issue Bank Branch</th>
    <td><input id="txtRentPayBankAccBankBranchOwnt" name="txtRentPayBankAccBankBranch" type="text" title="" placeholder="Issue Bank Branch" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td colspan=3><input id="txtRentPayBankAccBankOwnt" name="txtRentPayBankAccBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenRentPayBankAccBankIDOwnt" name="hiddenRentPayBankAccBankID" type="hidden" /></td>
</tr>
</tbody>
</table><!-- table end -->

</section>

</section><!-- search_table end -->


</article><!-- tap_area end -->
<!--############################################################################
    Billing Group
############################################################################-->
<article id="atcBG" class="tap_area blind"><!-- tap_area start -->
    
<!-- New Billing Group Type start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Group Option<span class="must">*</span></th>
    <td>
    <label><input type="radio" id="grpOpt1" name="grpOpt" value="new"  /><span>New Billing Group</span></label>
    <label><input type="radio" id="grpOpt2" name="grpOpt" value="exist"/><span>Existion Billing Group</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<!------------------------------------------------------------------------------
    Billing Group Selection - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section id="sctBillSel" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Billing Group Selection</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Billing Group<span class="must">*</span></th>
    <td><input id="txtBillGroupOwnt" name="txtBillGroup" type="text" title="" placeholder="Billing Group" class="readonly" readonly/><a id="billGrpBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="txtHiddenBillGroupIDOwnt" name="txtHiddenBillGroupID" type="hidden" /></td>
    <th scope="row">Billing Type<span class="must">*</span></th>
    <td><input id="txtBillTypeOwnt" name="txtBillType" type="text" title="" placeholder="Billing Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Billing Address</th>
    <td colspan="3"><textarea id="txtBillAddressOwnt" name="txtBillAddress" cols="20" rows="5" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</section>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Remark</th>
    <td><textarea id="txtBillGroupRemarkOwnt" name="txtBillGroupRemark" cols="20" rows="5" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
<!-- Existing Type end -->

</article><!-- tap_area end -->
<!--############################################################################
    Installation
############################################################################-->
<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Address</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<ul class="right_btns mb10">
    <li id="btnAddInstAddress" class="blind"><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
    <li id="btnSelectInstAddress" class="blind"><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Address Detail<span class="must">*</span></th>
    <td colspan="3">
    <input id="txtInstAddrDtlOwnt" name="txtInstAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td colspan="3">
    <input id="txtInstStreetOwnt" name="txtInstStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td colspan="3">
    <input id="txtInstAreaOwnt" name="txtInstArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">City<span class="must">*</span></th>
    <td>
    <input id="txtInstCityOwnt" name="txtMailCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/>
    </td>
    <th scope="row">PostCode<span class="must">*</span></th>
    <td>
    <input id="txtInstPostcodeOwnt" name="txtMailPostcode" type="text" title="" placeholder="Postcode" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <input id="txtInstStateOwnt" name="txtInstState" type="text" title="" placeholder="State" class="w100p readonly" readonly/>
    </td>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <input id="txtInstCountryOwnt" name="txtInstCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Contact Person</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="btnAddInstContact" class="blind"><p class="btn_grid"><a id="mstCntcNewAddBtn" href="#">Add New Contact</a></p></li>
    <li id="btnSelectInstContact" class="blind"><p class="btn_grid"><a id="mstCntcSelAddBtn" href="#">Select Another Contact</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td><input id="txtInstContactNameOwnt" name="txtInstContactName" type="text" title="" placeholder="Name" class="w100p readonly" readonly /></td>
    <th scope="row">Initial</th>
    <td><input id="txtInstContactInitialOwnt" name="txtInstContactInitial" type="text" title="" placeholder="Initial" class="w100p readonly" readonly /></td>
    <th scope="row">Gender</th>
    <td><input id="txtInstContactGenderOwnt" name="txtInstContactGender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input id="txtInstContactICOwnt" name="txtInstContactIC" type="text" title="" placeholder="NRIC" class="w100p readonly" readonly /></td>
    <th scope="row">DOB</th>
    <td><input id="txtInstContactDOBOwnt" name="txtInstContactDOB" type="text" title="" placeholder="DOB" class="w100p readonly" readonly /></td>
    <th scope="row">Race</th>
    <td><input id="txtInstContactRaceOwnt" name="txtInstContactRaceOwnt" type="text" title="" placeholder="Race" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="txtInstContactEmailOwnt" name="txtInstContactEmail" type="text" title="" placeholder="Email" class="w100p readonly" readonly /></td>
    <th scope="row">Department</th>
    <td><input id="txtInstContactDeptOwnt" name="txtInstContactDept" type="text" title="" placeholder="Department" class="w100p readonly" readonly /></td>
    <th scope="row">Post</th>
    <td><input id="txtInstContactPostOwnt" name="txtInstContactPost" type="text" title="" placeholder="Post" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><input id="txtInstContactTelMobOwnt" name="txtInstContactTelMob" type="text" title="" placeholder="Telephone Number (Mobile)" class="w100p readonly" readonly /></td>
    <th scope="row">Tel (Residence)</th>
    <td><input id="txtInstContactTelResOwnt" name="txtInstContactTelRes" type="text" title="" placeholder="Telephone Number (Residence)" class="w100p readonly" readonly /></td>
    <th scope="row">Tel (Office)</th>
    <td><input id="txtInstContactTelOffOwnt" name="txtInstContactTelOff" type="text" title="" placeholder="Telephone Number (Office)" class="w100p readonly" readonly /></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><input id="txtInstContactTelFaxOwnt" name="txtInstContactTelFax" type="text" title="" placeholder="Telephone Number (Fax)" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Installation Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">DSC Branch<span class="must">*</span></th>
    <td colspan="3">
    <select id="cmbDSCBranchOwnt" name="cmbDSCBranch" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Prefer Install Date<span class="must">*</span></th>
    <td><input id="dpPreferInstDateOwnt" name="dpPreferInstDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
    <th scope="row">Prefer Install Time<span class="must">*</span></th>
    <td>
    <div class="time_picker w100p"><!-- time_picker start -->
    <input id="tpPreferInstTimeOwnt" name="tpPreferInstTime" type="text" title="" placeholder="" class="time_date w100p" />
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
    <td colspan=3><textarea id="txtInstSpecialInstructionOwnt" name="txtInstSpecialInstruction" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<section class="search_table mt20"><!-- search_table start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No</th>
    <td><input id="txtReferenceNoOwnt" name="txtReferenceNo" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->


<ul class="center_btns">
    <li><p class="btn_blue2"><a id="btnReqOwnTrans" href="#">Transfer Ownership</a></p></li>
</ul>
</form>

</section>
<!------------------------------------------------------------------------------
    Ownership Transfer Request END
------------------------------------------------------------------------------->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->