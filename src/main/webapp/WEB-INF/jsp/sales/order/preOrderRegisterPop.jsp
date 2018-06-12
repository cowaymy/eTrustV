<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var listGiftGridID;
    var appTypeData = [{"codeId": "66","codeName": "Rental"},{"codeId": "67","codeName": "Outright"},{"codeId": "68","codeName": "Instalment"}];
    var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

    $(document).ready(function(){

        createAUIGridStk();

        doDefCombo(appTypeData, '' ,'appType', 'S', '');                 //Status 생성
        //doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'appType',     'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '', 'rentPayMode', 'S', ''); //Common Code
      //doGetComboOrder('/common/selectCodeList.do', '17', 'CODE_NAME', '', 'billPreferInitial', 'S', ''); //Common Code
        doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code

        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, '0', 'exTrade', 'S'); //EX-TRADE
        //doGetComboData('/common/selectCodeList.do', {groupCode :'326'}, '0', 'gstChk',  'S'); //GST_CHK
        //doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp', 'S'); //Discount period

        //Attach File
        $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");

        //UpperCase Field
        $("#nric").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
        $("#sofNo").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
    });

    function createAUIGridStk() {

        //AUIGrid 칼럼 설정
        var columnLayoutGft = [
            { headerText : "Product CD",   dataField : "itmcd",              width : 180 }
          , { headerText : "Product Name", dataField : "itmname" }
          , { headerText : "Product QTY",  dataField : "promoFreeGiftQty",   width : 180 }
          , { headerText : "itmid",        dataField : "promoFreeGiftStkId", visible : false}
          , { headerText : "promoItmId",   dataField : "promoItmId",         visible : false}
          ];

        //그리드 속성 설정
        var listGridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            softRemoveRowMode   : false,
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        /* listGiftGridID = GridCommon.createAUIGrid("pop_list_gift_grid_wrap", columnLayoutGft, "", listGridPros); */
    }

    $(function(){
        $('#btnConfirm').click(function() {
            if(!fn_validConfirm())  return false;
            if(fn_isExistMember() == 'true') return false;
            if(fn_isExistESalesNo() == 'true') return false;

            //encryptIc($('#nric').val());
            $('#nric').prop("readonly", true).addClass("readonly");
            $('#sofNo').prop("readonly", true).addClass("readonly");
            $('#btnConfirm').addClass("blind");
            $('#btnClear').addClass("blind");
          //$('#scPreOrdArea').removeClass("blind");

            /* $('#refereNo').val($('#sofNo').val().trim()) */

            fn_loadCustomer(null, $('#nric').val());
        });
        $('#nric').keydown(function (event) {
            if (event.which === 13) {
                if(!fn_validConfirm())  return false;
                if(fn_isExistMember() == 'true') return false;
                if(fn_isExistESalesNo() == 'true') return false;

                /* $('#refereNo').val($('#sofNo').val().trim()) */

	            $('#nric').prop("readonly", true).addClass("readonly");
	            $('#sofNo').prop("readonly", true).addClass("readonly");
	            $('#btnConfirm').addClass("blind");
	            $('#btnClear').addClass("blind");

                fn_loadCustomer(null, $('#nric').val());
            }
        });
        $('#sofNo').keydown(function (event) {
            if (event.which === 13) {
                if(!fn_validConfirm())  return false;
                if(fn_isExistMember() == 'true') return false;
                if(fn_isExistESalesNo() == 'true') return false;

                $('#nric').prop("readonly", true).addClass("readonly");
                $('#sofNo').prop("readonly", true).addClass("readonly");
                $('#btnConfirm').addClass("blind");
                $('#btnClear').addClass("blind");
                /* $('#refereNo').val($('#sofNo').val().trim()) */

                fn_loadCustomer(null, $('#nric').val());
            }
        });
        $('#chkSameCntc').click(function() {
            if($('#chkSameCntc').is(":checked")) {
                $('#scAnothCntc').addClass("blind");
            }
            else {
                $('#scAnothCntc').removeClass("blind");
            }
        });
        $('#btnNewCntc').click(function() {
            Common.popupDiv('/sales/customer/updateCustomerNewContactPopeSales.do', {custId : $('#hiddenCustId').val(), callParam : "PRE_ORD_CNTC"}, null , true);
        });
        $('#btnSelCntc').click(function() {
            Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "PRE_ORD_CNTC"}, null, true);
        });
        $('#btnNewInstAddr').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#hiddenCustId').val(), callParam : "PRE_ORD_INST_ADD"}, null , true);
        });
        $('#btnSelInstAddr').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "PRE_ORD_INST_ADD"}, null, true);
        });
        $('#billNewAddrBtn').click(function() {
            Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : $('#hiddenCustId').val(), callParam : "PRE_ORD_BILL_ADD"}, null , true);
        });
        $('#billSelAddrBtn').click(function() {
            Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "PRE_ORD_BILL_ADD"}, null, true);
        });
        $('#billGrpBtn').click(function() {
            Common.popupDiv("/sales/customer/customerBillGrpSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "PRE_ORD_BILL_GRP"}, null, true);
        });
        $('#appType').change(function() {
            $('#scPayInfo').addClass("blind");

            //CLEAR RENTAL PAY SETTING
            $('#thrdParty').prop("checked", false);

            fn_clearRentPayMode();
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            //CLEAR BILLING GROUP
            fn_clearBillGroup();

            //ClearControl_Sales();
            fn_clearSales();

            $('[name="advPay"]').prop("disabled", true);

            var idx    = $("#appType option:selected").index();
            var selVal = $("#appType").val();

            if(idx > 0) {
                if(FormUtil.isEmpty($('#hiddenCustId').val())) {
                    $('#appType').val('');
                    Common.alert('<b>Please select customer first.</b>');

                    $('#aTabCS').click();
                }
                else {

                    switch(selVal) {
                        case '66' : //RENTAL
                            $('#scPayInfo').removeClass("blind");
                            //?FD문서에서 아래 항목 빠짐
                            //$('[name="advPay"]').removeAttr("disabled");
                            $('#installDur').val('').prop("readonly", true).addClass("readonly");
                          //$("#gstChk").val('0');
                          //$('#pBtnCal').addClass("blind");

                            appSubType = '367';

                            break;

                        case '67' : //OUTRIGHT

                            appSubType = '368';

                            break;

                        case '68' : //INSTALLMENT
                            $('#installDur').removeAttr("readonly").removeClass("readonly");

                            appSubType = '369';

                            break;

                        case '1412' : //Outright Plus
                            $('#installDur').val("36").prop("readonly", true).removeClass("readonly");

                            //$('[name="advPay"]').removeAttr("disabled");

                            $('#scPayInfo').removeClass("blind");

                            appSubType = '370';

                            break;
                        case '142' : //Sponsor
                            appSubType = '371';
                            break;
                        case '143' : //Service
                            appSubType = '372';
                            break;
                        case '144' : //Education
                            appSubType = '373';
                            break;
                        case '145' : //Free Trial
                            appSubType = '374';
                            break;
                        default :
                            $('#installDur').val('').prop("readonly", true).addClass("readonly");
                          //$("#gstChk").val('0');
                          //$('#pBtnCal').addClass("blind");
                          //fn_tabOnOffSet('REL_CER', 'HIDE');

                            break;
                    }

                    var pType = $("#appType").val() == '66' ? '1' : '2';
                    //doGetComboData('/common/selectCodeList.do', {pType : pType}, '',  'srvPacId',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
                    doGetComboData('/sales/order/selectServicePackageList.do', {appSubType : appSubType, pType : pType}, '', 'srvPacId', 'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE

                    $('#ordProudct ').removeAttr("disabled");
                }
            }
            else {
                $('#srvPacId option').remove();
            }

            $('#ordProudct option').remove();
            $('#ordProudct optgroup').remove();
        });
        $('#thrdPartyAddCustBtn').click(function() {
            Common.popupDiv("/sales/customer/customerRegistPop.do", {"callPrgm" : "PRE_ORD_3PARTY"}, null, true);
        });
        $('#thrdParty').click(function(event) {

            fn_clearRentPayMode();
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            if($('#thrdParty').is(":checked")) {
                $('#sctThrdParty').removeClass("blind");
            }
            else {
                $('#sctThrdParty').addClass("blind");
            }
        });
        $('#thrdPartyId').change(function(event) {
            fn_loadThirdParty($('#thrdPartyId').val().trim(), 2);
        });
        $('#thrdPartyId').keydown(function(event) {
            if(event.which === 13) {    //enter
                fn_loadThirdParty($('#thrdPartyId').val().trim(), 2);
            }
        });
        $('#thrdPartyBtn').click(function() {
            Common.popupDiv("/common/customerPop.do", {callPrgm : "ORD_REGISTER_PAY_3RD_PARTY"}, null, true);
        });
        $('#rentPayMode').change(function() {

            console.log('rentPayMode click event');

            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            var rentPayModeIdx = $("#rentPayMode option:selected").index();
            var rentPayModeVal = $("#rentPayMode").val();

            if(rentPayModeIdx > 0) {
                if(rentPayModeVal == '133' || rentPayModeVal == '134') {

                    Common.alert('<b>Currently we are not provide ['+rentPayModeVal+'] service.</b>');
                    fn_clearRentPayMode();
                }
                else {
                    if(rentPayModeVal == '131') {
                        if($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert('<b>Please select the third party first.</b>');
                        }
                        else {
                            $('#sctCrCard').removeClass("blind");
                        }
                    }
                    else if(rentPayModeVal == '132') {
                        if($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
                            Common.alert('<b>Please select the third party first.</b>');
                        }
                        else {
                            $('#sctDirectDebit').removeClass("blind");
                        }
                    }
                }
            }
        });
        $('#srvPacId').change(function() {

            $('#ordProudct option').remove();
            $('#ordProudct optgroup').remove();

            var idx    = $("#srvPacId option:selected").index();
            var selVal = $("#srvPacId").val();

            if(idx > 0) {
                var stkType = $("#appType").val() == '66' ? '1' : '2';
              //doGetProductCombo('/sales/order/selectProductCodeList.do',  stkType, '', 'ordProudct', 'S', ''); //Product Code

                doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:$('#srvPacId').val()}, '', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
            }
        });
        $('#ordProudct').change(function() {

            console.log('ordProudct change event start');

            if(FormUtil.checkReqValue($('#exTrade'))) {
                Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>* Please select an Ex-Trade.</b>");
                $('#ordProudct').val('');
                return;
            }

            if(FormUtil.isEmpty($('#ordProudct').val())) {
                $('#ordPromo option').remove();

                //console.log('stkIdx:'+stkIdx);
                $("#ordPrice").val('');
                $("#ordPv").val('');
                $("#ordPvGST").val('');
                $("#ordRentalFees").val('');
                $("#ordPriceId").val('');

                $("#normalOrdPrice").val('');
                $("#normalOrdPv").val('');
                $("#normalOrdRentalFees").val('');
                $("#normalOrdPriceId").val('');

                $("#promoDiscPeriodTp").val('');
                $("#promoDiscPeriod").val('');

                return;
            }

            AUIGrid.clearGridData(listGiftGridID);

            var appTypeIdx = $("#appType option:selected").index();
            var appTypeVal = $("#appType").val();
            var custTypeVal= $("#hiddenTypeId").val();
            var stkIdx     = $("#ordProudct option:selected").index();
            var stkIdVal   = $("#ordProudct").val();
//          var empChk     = $("#empChk").val();
            var empChk     = 0;
            var exTrade    = $("#exTrade").val();
            var srvPacId = 0;

            if(appTypeVal == '66')
                {
                    srvPacId   = $('#srvPacId').val();
                }

            if(stkIdx > 0) {
                fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId);
                fn_loadProductPromotion(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade);
            }
        });
        $('#ordPromo').change(function() {

//          $('#relatedNo').val('').prop("readonly", true).addClass("readonly");
//          $('#trialNoChk').prop("checked", false).prop("disabled", true);
//          $('#trialNo').val('').addClass("readonly");

            AUIGrid.clearGridData(listGiftGridID);

            var appTypeIdx = $("#appType option:selected").index();
            var appTypeVal = $("#appType").val();
            var stkIdIdx   = $("#ordProudct option:selected").index();
            var stkIdVal   = $("#ordProudct").val();
            var promoIdIdx = $("#ordPromo option:selected").index();
            var promoIdVal = $("#ordPromo").val();
            var srvPacId = 0;

            if(appTypeVal == '66')
                {
                    srvPacId   = $('#srvPacId').val();
                }

            if(promoIdIdx > 0 && promoIdVal != '0') {
/*
                if($("#exTrade").val() == '1') {
                    $('#relatedNo').removeAttr("readonly").removeClass("readonly");
                }
                if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68') {
                    $('#trialNoChk').removeAttr("disabled");
                }
*/

                fn_loadPromotionPrice(promoIdVal, stkIdVal, srvPacId);

                fn_selectPromotionFreeGiftListForList2(promoIdVal);
            }
            else {
                fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId);
            }
        });
        $('#salesmanCd').change(function(event) {
            var memCd = $('#salesmanCd').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman(0, memCd);
            }
        });
        $('#salesmanCd').keydown(function (event) {
            if (event.which === 13) {    //enter
                var memCd = $('#salesmanCd').val().trim();

                if(FormUtil.isNotEmpty(memCd)) {
                    fn_loadOrderSalesman(0, memCd);
                }
                return false;
            }
        });
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
        });
        $('[name="grpOpt"]').click(function() {
            fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
        });
        $('#btnSave').click(function() {

            if(!fn_validCustomer()) {
                $('#aTabCS').click();
                return false;
            }

            if(!fn_validOrderInfo()) {
                $('#aTabBD').click();
                return false;
            }

            if(!fn_validPaymentInfo()) {
                $('#aTabBD').click();
                return false;
            }

            fn_doSavePreOrder();
        });
        $('#btnCal').click(function() {

            var appTypeName  = $('#appType').val();
            var productName  = $('#ordProudct option:selected').text();
            //Amount before GST
            var oldPrice     = $('#normalOrdPrice').val();
            var newPrice     = $('#ordPrice').val();
            var oldRental    = $('#normalOrdPrice').val();
            var newRental    = $('#ordRentalFees').val();
            var oldPv        = $('#ordPv').val();
            //Amount of GST applied
            var oldPriceGST  = fn_calcGst(oldPrice);
            var newPriceGST  = fn_calcGst(newPrice);
            var oldRentalGST = fn_calcGst(oldRental);
            var newRentalGST = fn_calcGst(newRental);
            var newPv        = $('#ordPvGST').val();

            var msg = '';

            msg += 'Application Type : '+appTypeName +'<br>';
            msg += 'Product          : '+productName +'<br>';
            msg += 'Price(RPF)       : '+newPriceGST +'<br>';
            msg += 'Normal Rental    : '+oldRentalGST+'<br>';
            msg += 'Promotion        : '+newRentalGST+'<br>';
            msg += '<br>The Price(Fee) was applied to the tab of [Sales Order]';

            fn_excludeGstAmt();

            Common.alert('GST Amount' + DEFAULT_DELIMITER + '<b>'+msg+'</b>');
        });
        $('#gstChk').change(function(event) {
            if($("#gstChk").val() == '1') {
                $('#pBtnCal').removeClass("blind");
            }
            else {
                $('#pBtnCal').addClass("blind");

                var appTypeVal = $("#appType").val();
                var stkIdVal   = $("#ordProudct").val();
                var promoIdVal = $("#ordPromo").val();

                fn_loadProductPrice(appTypeVal, stkIdVal,srvPacId);
                if(FormUtil.isNotEmpty(promoIdVal)) {
                    fn_loadPromotionPrice(promoIdVal, stkIdVal,srvPacId);
                }
            }
        });
        $('#addCreditCardBtn').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerCreditCardeSalesAddPop.do", {custId : vCustId, callPrgm : "PRE_ORD"}, null, true);
        });
        $('#selCreditCardBtn').click(function() {

            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerCreditCardSearchPop.do", {custId : vCustId, callPrgm : "PRE_ORD"}, null, true);
        });
        //Payment Channel - Add New Bank Account
        $('#btnAddBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerBankAccountAddPop.do", {custId : vCustId, callPrgm : "PRE_ORD"}, null, true);
        });
        //Payment Channel - Select Another Bank Account
        $('#btnSelBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerBankAccountSearchPop.do", {custId : vCustId, callPrgm : "PRE_ORD"});
        });
    });

    function fn_loadBankAccountPop(bankAccId) {

        fn_clearRentPaySetDD();
        fn_loadBankAccount(bankAccId);

        $('#sctDirectDebit').removeClass("blind");

        if(!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $('#rentPayBankAccNo').val())) {
            fn_clearRentPaySetDD();
            $('#sctDirectDebit').removeClass("blind");
            Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER + "<b>Invalid account for auto debit.</b>");
        }
    }

    function fn_loadCreditCard2(custCrcId) {
        console.log("fn_loadCreditCard START");

        Common.ajax("GET", "/sales/order/selectCustomerCreditCardDetailView.do", {getparam : custCrcId}, function(rsltInfo) {
            if(rsltInfo != null) {
                $("#hiddenRentPayCRCId").val(rsltInfo.custCrcId);
                $("#rentPayCRCNo").val(rsltInfo.decryptCRCNoShow);
                $("#hiddenRentPayEncryptCRCNoId").val(rsltInfo.custCrcNo);
                $("#rentPayCRCType").val(rsltInfo.code);
                $("#rentPayCRCName").val(rsltInfo.custCrcOwner);
                $("#rentPayCRCExpiry").val(rsltInfo.custCrcExpr);
                $("#rentPayCRCBank").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankId);
                $("#hiddenRentPayCRCBankId").val(rsltInfo.custCrcBankId);
                $("#rentPayCRCCardType").val(rsltInfo.codeName);
            }
        });
    }

    function fn_loadThirdParty(custId, sMethd) {

        fn_clearRentPayMode();
        fn_clearRentPay3thParty();
        fn_clearRentPaySetCRC();
        fn_clearRentPaySetDD();

        if(custId != $('#hiddenCustId').val()) {
            Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {

            if(result != null && result.length == 1) {

                var custInfo = result[0];

                $('#hiddenThrdPartyId').val(custInfo.custId)
                $('#thrdPartyId').val(custInfo.custId)
                $('#thrdPartyType').val(custInfo.codeName1)
                $('#thrdPartyName').val(custInfo.name)
                $('#thrdPartyNric').val(custInfo.nric)

                $('#thrdPartyId').removeClass("readonly");
                $('#thrdPartyType').removeClass("readonly");
                $('#thrdPartyName').removeClass("readonly");
                $('#thrdPartyNric').removeClass("readonly");
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

	function fn_excludeGstAmt() {
        //Amount before GST
        var oldPrice     = $('#normalOrdPrice').val();
        var newPrice     = $('#ordPrice').val();
        var oldRental    = $('#normalOrdRentalFees').val();
        var newRental    = $('#ordRentalFees').val();
        var oldPv        = $('#ordPv').val();
        //Amount of GST applied
        var oldPriceGST  = fn_calcGst(oldPrice);
        var newPriceGST  = fn_calcGst(newPrice);
        var oldRentalGST = fn_calcGst(oldRental);
        var newRentalGST = fn_calcGst(newRental);
        var newPv        = $('#ordPvGST').val();

        $('#normalOrdPrice').val(oldPriceGST);
        $('#ordPrice').val(newPriceGST);
        $('#normalOrdRentalFees').val(oldRentalGST);
        $('#ordRentalFees').val(newRentalGST);
        $('#ordPv').val(newPv);

        $('#pBtnCal').addClass("blind");
	}

    function fn_isExistESalesNo() {
        var isExist = false, msg = "";

        Common.ajaxSync("GET", "/sales/order/selectExistSofNo.do", $("#frmCustSearch").serialize(), function(rsltInfo) {
            if(rsltInfo != null) {
                isExist = rsltInfo.isExist;
            }
            console.log('isExistSalesNo:'+isExist);
        });

        if(isExist == 'true') Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* this Sales has posted, no amendment allow</b>");

        return isExist;
    }

    function fn_isExistMember() {
        var isExist = false, msg = "";

        Common.ajaxSync("GET", "/sales/order/selectExistingMember.do", $("#frmCustSearch").serialize(), function(rsltInfo) {
            if(rsltInfo != null) {
                isExist = rsltInfo.isExist;
            }
            console.log('isExistMember:'+isExist);
        });

        if(isExist == 'true') Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* The member is our existing HP/Cody/Staff/CT.</b>");

        return isExist;
    }

    function fn_validPaymentInfo() {
        var isValid = true, msg = "";

        var appTypeIdx = $("#appType option:selected").index();
        var appTypeVal = $("#appType").val();
        var rentPayModeIdx = $("#rentPayMode option:selected").index();
        var rentPayModeVal = $("#rentPayMode").val();
        var grpOptSelYN = (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(":checked")) ? false : true;
        var grpOptVal   = $(':radio[name="grpOpt"]:checked').val(); //new, exist

        if(appTypeIdx > 0 && appTypeVal == '66') {

            if($('#thrdParty').is(":checked")) {

                if(FormUtil.checkReqValue($('#hiddenThrdPartyId'))) {
                    isValid = false;
                    msg += "* Please select the third party.<br>";
                }
            }

            if(rentPayModeIdx <= 0) {
                isValid = false;
                msg += "* Please select the rental paymode.<br>";
            }
            else {
                if(rentPayModeVal == '131') {
                    if(FormUtil.checkReqValue($('#hiddenRentPayCRCId'))) {
                        isValid = false;
                        msg += "* Please select a credit card.<br>";
                    }
                    else if(FormUtil.checkReqValue($('#hiddenRentPayCRCBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
                        isValid = false;
                        msg += "* Invalid credit card issue bank.<br>";
                    }
                }
                else if(rentPayModeVal == '132') {
                    if(FormUtil.checkReqValue($('#hiddenRentPayBankAccID'))) {
                        isValid = false;
                        msg += "* Please select a bank account.<br>";
                    }
                    else if(FormUtil.checkReqValue($('#hiddenAccBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
                        isValid = false;
                        msg += "* Invalid bank account issue bank.<br>";
                    }
                }
            }

            if(!grpOptSelYN) {
                isValid = false;
                msg += "* Please select the group option.<br>";
            }
            else {

                if(grpOptVal == 'exist') {

                    if(FormUtil.checkReqValue($('#hiddenBillGrpId'))) {
                        isValid = false;
                        msg += "* Please select a billing group.<br>";
                    }
                }
                else {

                    console.log('billMthdSms  checked:' + $("#billMthdSms" ).is(":checked"));
                    console.log('billMthdPost checked:' + $("#billMthdPost" ).is(":checked"));
                    console.log('billMthdEstm checked:' + $("#billMthdEstm" ).is(":checked"));

                    if(!$("#billMthdSms" ).is(":checked") && !$("#billMthdPost" ).is(":checked") && !$("#billMthdEstm" ).is(":checked")) {
                        isValid = false;
                        msg += "* Please select at least one billing method.<br>";
                    }
                    else {
                        if($("#typeId").val() == '965' && $("#billMthdSms" ).is(":checked")) {
                            isValid = false;
                            msg += "* SMS billing method is not allow for company type customer.<br>";
                        }

                        if($("#billMthdEstm" ).is(":checked")) {
                            if(FormUtil.checkReqValue($('#billMthdEmailTxt1'))) {
                                isValid = false;
                                msg += "* Please key in the email address.<br>";
                            }
                            else {
                                if(FormUtil.checkEmail($('#billMthdEmailTxt1').val())) {
                                    isValid = false;
                                    msg += "* Invalid email address.<br>";
                                }
                            }
                            if(!FormUtil.checkReqValue($('#billMthdEmailTxt2')) && FormUtil.checkEmail($('#billMthdEmailTxt2').val())) {
                                isValid = false;
                                msg += "* Invalid email address.<br>";
                            }
                        }
                    }
                }
            }
        }

        if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validOrderInfo() {
        var isValid = true, msg = "";

        var appTypeIdx = $("#appType option:selected").index();
        var appTypeVal = $("#appType").val();

        if(appTypeIdx <= 0) {
            isValid = false;
            msg += "* Please select an application type.<br>";
        }
        else {
            if(appTypeVal == '68' || appTypeVal == '1412') {
                if(FormUtil.checkReqValue($('#installDur'))) {
                    isValid = false;
                    msg += "* Please key in the installment duration.<br>";
                }
            }

            /* if(appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '1412') {
                if(FormUtil.checkReqValue($('#refereNo'))) {
                    isValid = false;
                    msg += "* Please key in the reference no.<br>";
                }
            } */

            if(appTypeVal == '66') {
                if($(':radio[name="advPay"]:checked').val() != '1' && $(':radio[name="advPay"]:checked').val() != '0') {
                    isValid = false;
                    msg += "* Please select advance rental payment.<br>";
                }
            }
        }

        if($("#ordProudct option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select a product.<br>";
        }

        if(FormUtil.checkReqValue($('#salesmanCd')) && FormUtil.checkReqValue($('#salesmanNm'))) {
            if(appTypeIdx > 0 && appTypeVal != 143) {
                isValid = false;
                msg += "* Please select a salesman.<br>";
            }
        }

/*         if(!$('#pBtnCal').hasClass("blind")) {
            isValid = false;
            msg += "* Please press the Calculation button<br>";
        } */

        if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validConfirm() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#nric'))) {
            isValid = false;
            msg += "* Please key in NRIC/Company No.<br>";
        }
        if(FormUtil.checkReqValue($('#sofNo'))) {
            isValid = false;
            msg += "* Please key in eSales(SOF) No.<br>";
        }

        if(!isValid) Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validCustomer() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#hiddenCustId'))) {
            isValid = false;
            msg += "* Please select a customer.<br>";
        }

        if($('#appType').val() == '1412' && $('#hiddenTypeId').val() == '965') {
            isValid = false;
            msg = "* Please select an individual customer<br>(Outright Plus).<br>";
        }

        if(FormUtil.checkReqValue($('#hiddenCustCntcId'))) {
            isValid = false;
            msg += "* Please select a contact person.<br>";
        }

        if(FormUtil.checkReqValue($('#hiddenCustAddId'))) {
            isValid = false;
            msg += "* Please select an installation address.<br>";
        }

        if($("#dscBrnchId option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the DSC branch.<br>";
        }

        if(FormUtil.isEmpty($('#prefInstDt').val().trim())) {
            isValid = false;
            msg += "* Please select prefer install date.<br>";
        }

        if(FormUtil.isEmpty($('#prefInstTm').val().trim())) {
            isValid = false;
            msg += "* Please select prefer install time.<br>";
        }

        if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_doSavePreOrder() {

        var vAppType    = $('#appType').val();
        var vCustCRCID  = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCId').val() : 0;
        var vCustAccID  = $('#rentPayMode').val() == '132' ? $('#hiddenRentPayBankAccID').val() : 0;
        var vBankID     = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCBankId').val() : $('#rentPayMode').val() == '132' ? $('#hiddenAccBankId').val() : 0;
        var vIs3rdParty = $('#thrdParty').is(":checked") ? 1 : 0;
        var vCustomerId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
        var vCustBillId = vAppType == '66' ? $('input:radio[name="grpOpt"]:checked').val() == 'exist' ? $('#hiddenBillGrpId').val() : 0 : 0;

        var orderVO = {
            sofNo                : $('#sofNo').val().trim(),
            custPoNo             : $('#poNo').val().trim(),
            appTypeId            : vAppType,
            srvPacId             : $('#srvPacId').val(),
//            instPriod            : $('#installDur').val().trim(),
            custId               : $('#hiddenCustId').val(),
            empChk               : 0,
            gstChk               : $('#gstChk').val(),
//          atchFileGrpId        :
            custCntcId           : $('#hiddenCustCntcId').val(),
//          keyinBrnchId         :
            instAddId            : $('#hiddenCustAddId').val(),
            dscBrnchId           : $('#dscBrnchId').val(),
            preDt                : $('#prefInstDt').val().trim(),
            preTm                : $('#prefInstTm').val().trim(),
            instct               : $('#speclInstct').val().trim(),
            exTrade              : $('#exTrade').val(),
            itmStkId             : $('#ordProudct').val(),
            promoId              : $('#ordPromo').val(),
            mthRentAmt           : $('#ordRentalFees').val().trim(),
//            promoDiscPeriodTp    : $('#promoDiscPeriodTp').val(),
//            promoDiscPeriod      : $('#promoDiscPeriod').val().trim(),
            totAmt               : $('#ordPrice').val().trim(),
            norAmt               : $('#normalOrdPrice').val().trim(),
//            norRntFee            : $('#normalOrdRentalFees').val().trim(),
            discRntFee           : $('#ordRentalFees').val().trim(),
//            totPv                : $('#ordPv').val().trim(),
//            totPvGst             : $('#ordPvGST').val().trim(),
            prcId                : $('#ordPriceId').val(),
            memCode              : $('#salesmanCd').val(),
            advBill              : $('input:radio[name="advPay"]:checked').val(),
            custCrcId            : vCustCRCID,
            bankId               : vBankID,
            custAccId            : vCustAccID,
            is3rdParty           : vIs3rdParty,
            rentPayCustId        : vCustomerId,
            rentPayModeId        : $('#rentPayMode').val(),
            custBillId           : vCustBillId,
            custBillCustId       : $('#hiddenCustId').val(),
            custBillCntId        : $("#hiddenCustCntcId").val(),
            custBillAddId        : $("#hiddenBillAddId").val(),
            custBillRem          : $('#billRem').val().trim(),
            custBillEmail        : $('#billMthdEmailTxt1').val().trim(),
            custBillIsSms        : $('#billMthdSms1').is(":checked") ? 1 : 0,
            custBillIsPost       : $('#billMthdPost').is(":checked") ? 1 : 0,
            custBillEmailAdd     : $('#billMthdEmailTxt2').val().trim(),
            custBillIsWebPortal  : $('#billGrpWeb').is(":checked")   ? 1 : 0,
            custBillWebPortalUrl : $('#billGrpWebUrl').val().trim(),
            custBillIsSms2       : $('#billMthdSms2').is(":checked") ? 1 : 0,
            custBillCustCareCntId: $("#hiddenBPCareId").val()
        };
        Common.ajax("POST", "/sales/order/registerPreOrder.do", orderVO, function(result) {
            Common.alert("Order Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_closePreOrdRegPop);
        },
        function(jqXHR, textStatus, errorThrown) {
            try {
                Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.</b>");
            }
            catch (e) {
                console.log(e);
            }
        });
    }

    function fn_closePreOrdRegPop() {
        fn_getPreOrderList();
        $('#_divPreOrdRegPop').remove();
    }

    function fn_setBillGrp(grpOpt) {

        if(grpOpt == 'new') {

            fn_clearBillGroup();

            $('#grpOpt1').prop("checked", true);

            $('#sctBillMthd').removeClass("blind");
            $('#sctBillAddr').removeClass("blind");
//          $('#sctBillPrefer').removeClass("blind");

            $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());
          //$('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());

            if($('#hiddenTypeId').val() == '965') { //Company

                console.log("fn_setBillGrp 1 typeId : "+$('#typeId').val());

                $('#sctBillPrefer').removeClass("blind");

                fn_loadBillingPreference($('#srvCntcId').val());

                $('#billMthdEstm').prop("checked", true);
                $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                $('#billMthdEmail2').removeAttr("disabled");
                $('#billMthdEmailTxt1').removeAttr("disabled");
                $('#billMthdEmailTxt2').removeAttr("disabled");
            }
            else if($('#hiddenTypeId').val() == '964') { //Individual

                console.log("fn_setBillGrp 2 typeId : "+$('#hiddenTypeId').val());
                console.log("custCntcEmail : "+$('#custCntcEmail').val());
                console.log(FormUtil.isNotEmpty($('#custCntcEmail').val().trim()));

                if(FormUtil.isNotEmpty($('#custCntcEmail').val().trim())) {
                    $('#billMthdEstm').prop("checked", true);
                    $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                    $('#billMthdEmail2').removeAttr("disabled");
                    //$('#billMthdEmailTxt1').removeAttr("disabled");
                    //$('#billMthdEmailTxt2').removeAttr("disabled");
                }

                $('#billMthdSms').prop("checked", true);
                $('#billMthdSms1').prop("checked", true).removeAttr("disabled");
                $('#billMthdSms2').removeAttr("disabled");
            }
        }
        else if(grpOpt == 'exist') {

            fn_clearBillGroup();

            $('#grpOpt2').prop("checked", true);

            $('#sctBillSel').removeClass("blind");

            $('#billRem').prop("readonly", true).addClass("readonly");
        }
    }

    function fn_loadBillingPreference(custCareCntId) {

        Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {

            if(srvCntcInfo != null) {
                $("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);
                $("#billPreferInitial").val(srvCntcInfo.custInitial);
                $("#billPreferName").val(srvCntcInfo.name);
                $("#billPreferTelO").val(srvCntcInfo.telO);
                $("#billPreferExt").val(srvCntcInfo.ext);
            }
        });

    }

    function fn_loadOrderSalesman(memId, memCode) {

        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);

        $('#salesmanCd').val('');
        $('#salesmanNm').val('');

        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
            }
            else {
                $('#salesmanCd').val(memInfo.memCode);
                $('#salesmanNm').val(memInfo.name);
            }
        });
    }

    function fn_selectPromotionFreeGiftListForList2(promoId) {
        console.log('fn_selectPromotionFreeGiftListAjax START');
        Common.ajax("GET", "/sales/promotion/selectPromotionFreeGiftList.do", { promoId : promoId }, function(result) {
            AUIGrid.setGridData(listGiftGridID, result);
        });
    }

    function fn_loadPromotionPrice(promoId, stkId, srvPacId) {

        if($('#gstChk').val() == '1') {
            $('#pBtnCal').removeClass("blind");
        }
        else {
            $('#pBtnCal').addClass("blind");
        }

        Common.ajax("GET", "/sales/order/selectProductPromotionPriceByPromoStockID.do", {promoId : promoId, stkId : stkId, srvPacId : srvPacId}, function(promoPriceInfo) {

            if(promoPriceInfo != null) {

                console.log("성공.");

//              $("#ordPrice").removeClass("readonly");
//              $("#ordPv").removeClass("readonly");
//              $("#ordRentalFees").removeClass("readonly");

                $("#ordPrice").val(promoPriceInfo.orderPricePromo);
                $("#ordPv").val(promoPriceInfo.orderPVPromo);
                $("#ordPvGST").val(promoPriceInfo.orderPVPromoGST);
                $("#ordRentalFees").val(promoPriceInfo.orderRentalFeesPromo);

                $("#promoDiscPeriodTp").val(promoPriceInfo.promoDiscPeriodTp);
                $("#promoDiscPeriod").val(promoPriceInfo.promoDiscPeriod);
            }
        });
    }

    //LoadProductPromotion
    function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal, exTrade) {
        console.log('fn_loadProductPromotion --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPromotion --> stkId:'+stkId);
        console.log('fn_loadProductPromotion --> empChk:'+empChk);
        console.log('fn_loadProductPromotion --> custTypeVal:'+custTypeVal);

        $('#ordPromo').removeAttr("disabled");

        doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val()}, '', 'ordPromo', 'S', ''); //Common Code
    }

    //LoadProductPrice
    function fn_loadProductPrice(appTypeVal, stkId, srvPacId) {

        if($('#gstChk').val() == '1') {
            $('#pBtnCal').removeClass("blind");
        }
        else {
            $('#pBtnCal').addClass("blind");
        }

        var appTypeId = 0;

        appTypeId = appTypeVal=='68' ? '67' : appTypeVal;

        $("#searchAppTypeId").val(appTypeId);
        $("#searchStkId").val(stkId);
        $("#searchSrvPacId").val(srvPacId);

        Common.ajax("GET", "/sales/order/selectStockPriceJsonInfo.do", {appTypeId : appTypeId, stkId : stkId, srvPacId : srvPacId}, function(stkPriceInfo) {

            if(stkPriceInfo != null) {

                console.log("성공.");

                $("#ordPrice").val(stkPriceInfo.orderPrice);
                $("#ordPv").val(stkPriceInfo.orderPV);
                $("#ordPvGST").val(stkPriceInfo.orderPV);
                $("#ordRentalFees").val(stkPriceInfo.orderRentalFees);
                $("#ordPriceId").val(stkPriceInfo.priceId);

                $("#normalOrdPrice").val(stkPriceInfo.orderPrice);
                $("#normalOrdPv").val(stkPriceInfo.orderPV);
                $("#normalOrdRentalFees").val(stkPriceInfo.orderRentalFees);
                $("#normalOrdPriceId").val(stkPriceInfo.priceId);

                $("#promoDiscPeriodTp").val('');
                $("#promoDiscPeriod").val('');
            }
        });
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function fn_setDefaultSrvPacId() {
        //if($('#srvPacId option').size() == 2) {
            $('#srvPacId option[value="2"]').attr('selected', 'selected');

            var stkType = $("#appType").val() == '66' ? '1' : '2';

            doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:$('#srvPacId').val()}, '', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
        //}
    }

    function fn_clearSales() {
        $('#installDur').val('');
        $('#ordProudct').val('');
        $('#ordPromo').val('');
        $('#relatedNo').val('');
      //$('#trialNoChk').prop("checked", false);
      //$('#trialNo').val('');
        $('#ordPrice').val('');
        $('#ordPriceId').val('');
        $('#ordPv').val('');
        $('#ordRentalFees').val('');
    }

    //ClearControl_BillGroup
    function fn_clearBillGroup() {

        $('#sctBillMthd').addClass("blind");
        $('#sctBillAddr').addClass("blind");
        $('#sctBillPrefer').addClass("blind");
        $('#sctBillSel').addClass("blind");

        $('#grpOpt1').removeAttr("checked");
        $('#grpOpt2').removeAttr("checked");

        $('#billMthdPost').val('');
        $('#billMthdSms').val('');
        $('#billMthdSms1').val('');
        $('#billMthdSms2').val('');
        $('#billMthdEstm').val('');
        $('#billMthdEmail1').val('');
        $('#billMthdEmail2').val('');
        $('#billMthdEmailTxt1').val('');
        $('#billMthdEmailTxt2').val('');
        $('#billGrpWebUrl').val('');

        $('#hiddenBPCareId').val('');
        $('#billPreferInitial').val('');
        $('#billPreferName').val('');
        $('#billPreferTelO').val('');
        $('#billPreferExt').val('');

        $('#billGrp').val('');
        $('#hiddenBillGrpId').val('');
        $('#billType').val('');
        $('#billAddr').val('');
    }

    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPayMode() {
        $('#rentPayMode').val('');
        $('#rentPayIC').val('');
    }

    //ClearControl_RentPaySet_ThirdParty
    function fn_clearRentPay3thParty() {
        $('#thrdPartyId').val('');
        $('#hiddenThrdPartyId').val('');
        $('#thrdPartyType').val('');
        $('#thrdPartyName').val('');
        $('#thrdPartyNric').val('');
    }

    //ClearControl_RentPaySet_DD
    function fn_clearRentPaySetDD() {
        $('#sctDirectDebit').addClass("blind");

        $('#rentPayBankAccNo').val('');
        $('#hiddenRentPayBankAccID').val('');
        $('#rentPayBankAccType').val('');
        $('#accName').val('');
        $('#accBranch').val('');
        $('#accBank').val('');
        $('#hiddenAccBankId').val('');
    }

    //ClearControl_RentPaySet_CRC
    function fn_clearRentPaySetCRC() {
        $('#sctCrCard').addClass("blind");

        $('#rentPayCRCNo').val('');
        $('#hiddenRentPayCRCId').val('');
        $('#hiddenRentPayEncryptCRCNoId').val('');
        $('#rentPayCRCType').val('');
        $('#rentPayCRCName').val('');
        $('#rentPayCRCExpiry').val('');
        $('#rentPayCRCBank').val('');
        $('#hiddenRentPayCRCBankId').val('');
        $('#rentPayCRCCardType').val('');
    }

    function fn_loadCustomer(custId, nric){

        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId, nric : nric}, function(result) {

            if(result != null && result.length == 1) {

                $('#scPreOrdArea').removeClass("blind");

                var custInfo = result[0];

                console.log("성공.");
                console.log("custId : " + result[0].custId);
                console.log("userName1 : " + result[0].name);

                var dob = custInfo.dob;
                var dobY = dob.split("/")[2];
                var nowDt = new Date();
                var nowDtY = nowDt.getFullYear();

                if(dobY != 1900) {
                    if((nowDtY - dobY) < 18) {
                        Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* Member must 18 years old and above.</b>");
                        $('#scPreOrdArea').addClass("blind");
                        return false;
                    }
                }

                //
                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
//              $("#custId").val(custInfo.custId); //Customer ID
                $("#custTypeNm").val(custInfo.codeName1); //Customer Name
                $("#hiddenTypeId").val(custInfo.typeId); //Type
                $("#name").val(custInfo.name); //Name
                $("#nric").val(custInfo.nric); //NRIC/Company No

                $("#nationNm").val(custInfo.name2); //Nationality
//              $("#raceId").val(custInfo.raceId); //Nationality
                $("#race").val(custInfo.codeName2); //
                $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                $("#gender").val(custInfo.gender); //Gender
                $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                $("#custEmail").val(custInfo.email); //Email
//              $("#custRem").val(custInfo.rem); //Remark
//              $("#gstChk").val('0').prop("disabled", true);

                if(custInfo.corpTypeId > 0) {
                    $("#corpTypeNm").val(custInfo.codeName); //Industry Code
                }
                else {
                    $("#corpTypeNm").val(""); //Industry Code
                }
/*
                if($('#hiddenTypeId').val() == '965') { //Company
                    $('#sctBillPrefer').removeClass("blind");
                } else {
                    $('#sctBillPrefer').addClass("blind");
                }
*/

                if(custInfo.custAddId > 0) {

                    //----------------------------------------------------------
                    // [Billing Detail] : Billing Address SETTING
                    //----------------------------------------------------------
//                  $('#billAddrForm').clearForm();
                    fn_loadBillAddr(custInfo.custAddId);

                    //----------------------------------------------------------
                    // [Installation] : Installation Address SETTING
                    //----------------------------------------------------------
//                  fn_clearInstallAddr();
                    fn_loadInstallAddr(custInfo.custAddId);
                }

                if(custInfo.custCntcId > 0) {
                    //----------------------------------------------------------
                    // [Master Contact] : Owner & Purchaser Contact
                    //                    Additional Service Contact
                    //----------------------------------------------------------
                    $('#custCntcForm').clearForm();
                    //$('#liMstCntcNewAddr').addClass("blind");
                    //$('#liMstCntcSelAddr').addClass("blind");
                    //$('#liMstCntcNewAddr2').addClass("blind");
                    //$('#liMstCntcSelAddr2').addClass("blind");

                    fn_loadMainCntcPerson(custInfo.custCntcId);
                    fn_loadCntcPerson(custInfo.custCntcId);
                    //----------------------------------------------------------
                    // [Installation] : Installation Contact Person
                    //----------------------------------------------------------
                  //$('#instCntcForm').clearForm();
                  //fn_loadInstallationCntcPerson(custInfo.custCntcId);
                }

                if(custInfo.codeName == 'Government') {
                    Common.alert('<b>Goverment Customer</b>');
                }

            }
            else {
                Common.confirm('<b>* This customer is NEW customer.<br>Do you want to create a customer?</b>', fn_createCustomerPop);
            }
        });
    }

    function fn_loadBillingGroup(billGrpId, custBillGrpNo, billType, billAddrFull, custBillRem, custBillAddId) {
        $('#hiddenBillGrpId').removeClass("readonly").val(billGrpId);
        $('#billGrp').removeClass("readonly").val(custBillGrpNo);
        $('#billType').removeClass("readonly").val(billType);
        $('#billAddr').removeClass("readonly").val(billAddrFull);
        $('#billRem').removeClass("readonly").val(custBillRem);

        fn_loadBillAddr(custBillAddId);
    }

    function fn_loadBillAddr(custAddId){
        console.log("fn_loadBillAddr START");

        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(billCustInfo) {

            if(billCustInfo != null) {

                console.log("성공.");
                console.log("hiddenBillAddId : " + billCustInfo.custAddId);

                $("#hiddenBillAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
                $("#billAddrDtl").val(billCustInfo.addrDtl); //Address
                $("#billStreet").val(billCustInfo.street); //Street
                $("#billArea").val(billCustInfo.area); //Area
                $("#billCity").val(billCustInfo.city); //City
                $("#billPostCode").val(billCustInfo.postcode); //Post Code
                $("#billState").val(billCustInfo.state); //State
                $("#billCountry").val(billCustInfo.country); //Country

                $("#hiddenBillStreetId").val(billCustInfo.custAddId); //Magic Address STREET_ID(Hidden)

                console.log("hiddenBillAddId2 : " + $("#hiddenBillAddId").val());
            }
        });
    }

    function fn_loadInstallAddr(custAddId){
        console.log("fn_loadInstallAddr START");

        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId}, function(custInfo) {

            if(custInfo != null) {

                console.log("성공.");
                console.log("gstChk : " + custInfo.gstChk);

                //
                $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
                $("#instAddrDtl").val(custInfo.addrDtl); //Address
                $("#instStreet").val(custInfo.street); //Street
                $("#instArea").val(custInfo.area); //Area
                $("#instCity").val(custInfo.city); //City
                $("#instPostCode").val(custInfo.postcode); //Post Code
                $("#instState").val(custInfo.state); //State
                $("#instCountry").val(custInfo.country); //Country

                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch

//              if(!$("#gstChk").is('[disabled]')) {

                    if(custInfo.gstChk == '1') {
                        $("#gstChk").val('1').prop("disabled", true);
                    }
                    else {
                        $("#gstChk").val('0').removeAttr("disabled");
                    }
//              }
            }
        });
    }

    function fn_createCustomerPop() {
    	Common.popupWin("frmCustSearch", "/sales/customer/customerRegistPopESales.do", {width : "1220px", height : "690", resizable: "no", scrollbars: "no"});
        //Common.popupDiv("/sales/customer/customerRegistPopESales.do", {"callPrgm" : "PRE_ORD"});
    }

    function fn_loadMainCntcPerson(custCntcId){
        console.log("fn_loadCntcPerson START");

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                console.log('custCntcInfo.custCntcId:'+custCntcInfo.custCntcId);
                //
                $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
                $("#custInitial").val(custCntcInfo.code);
                $("#custEmail").val(custCntcInfo.email);
                $("#custTelM").val(custCntcInfo.telM1);
                $("#custTelR").val(custCntcInfo.telR);
                $("#custTelO").val(custCntcInfo.telO);
                $("#custTelF").val(custCntcInfo.telf);
                $("#custExt").val(custCntcInfo.ext);
            }
        });
    }

    function fn_loadCntcPerson(custCntcId){
        console.log("fn_loadCntcPerson START");

        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {custCntcId : custCntcId}, function(custCntcInfo) {

            if(custCntcInfo != null) {
                console.log('custCntcInfo.custCntcId:'+custCntcInfo.custCntcId);
                //
                $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
                $("#custCntcInitial").val(custCntcInfo.code);
                $("#custCntcName").val(custCntcInfo.name1);
                $("#custCntcEmail").val(custCntcInfo.email);
                $("#custCntcTelM").val(custCntcInfo.telM1);
                $("#custCntcTelR").val(custCntcInfo.telR);
                $("#custCntcTelO").val(custCntcInfo.telO);
                $("#custCntcTelF").val(custCntcInfo.telf);
                $("#custCntcExt").val(custCntcInfo.ext);
            }
        });
    }

    function chgTab(tabNm) {
        console.log('tabNm:'+tabNm);

        switch(tabNm) {
            case 'ord' :

            	if(MEM_TYPE == '1' || MEM_TYPE == '2'){
            		$('#memBtn').addClass("blind");
            		$('#salesmanCd').val("${SESSION_INFO.userName}");
                    $('#salesmanCd').change();
            	}

            	$('#appType').val("66");
            	$('#appType').prop("disabled", true);
            	$('#appType').change();

            	$('[name="advPay"]').prop("disabled", true);
            	$('#advPayNo').prop("checked", true);
            	$('#poNo').prop("disabled", true);

            	break;
            case 'pay' :
            	if($('#appType').val() == '66'){
            		$('#rentPayMode').val('131');
            		$('#rentPayMode').change();
            		$('#rentPayMode').prop("disabled", true);
            		$('#thrdParty').prop("disabled", true);
            	}

            	$('[name="grpOpt"]').prop("disabled", true);
            	fn_setBillGrp("new"); // default set billing group option to new
                break;
            default :
                break;
        }
        /*
        if(tabNm != 'ins') {
            if(!$('#pBtnCal').hasClass("blind")) {
                //$('#aTabIN').click();
                Common.alert('<b>Please press the Calculation button</b>', fn_goInstallTab);
                return false;
            }
        }
        */
    }

    function encryptIc(nric){
    	$('#nric').attr("placeholder", nric.substr(0).replace(/[\S]/g,"*"));
    	//$('#nric').val(nric.substr(0).replace(/[\S]/g,"*"));
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eSales</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="btnPreOrdClose" href="#">CLOSE | TUTUP</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
	<li><p class="btn_blue"><a id="btnConfirm" href="#">Confirm</a></p></li>
	<li><p class="btn_blue"><a id="btnClear" href="#">Clear</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
    <input id="hiddenNric" name="hiddenNric" type="hidden" value="1" />
    <input id="selType" name="selType" type="hidden" value="1" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">NRIC/Company No</th>
	<td><input id="nric" name="nric" type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">eSales(SOF) No</th>
	<td><input id="sofNo" name="sofNo" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row" colspan="4" ><span class="must"><spring:message code='sales.msg.ordlist.icvalid'/></span></th>
</tr>
</tbody>
</table><!-- table end -->
</form>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content START
------------------------------------------------------------------------------->
<section id="scPreOrdArea" class="blind">

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
	<li><a href="#" class="on">Customer</a></li>
	<li><a href="#" onClick="javascript:chgTab('ord');">Order Info</a></li>
	<li><a href="#" onClick="javascript:chgTab('pay');">Payment Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="frmPreOrdReg" name="frmPreOrdReg" action="#" method="post">
    <input id="hiddenCustId" name="custId"   type="hidden"/>
    <input id="hiddenTypeId" name="typeId"   type="hidden"/>
    <input id="hiddenCustCntcId" name="custCntcId" type="hidden" />
    <input id="hiddenCustAddId" name="custAddId" type="hidden" />

<aside class="title_line"><!-- title_line start -->
<h3>Customer information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:350px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.custType2" /><span class="must">*</span></th>
	<td><input id="custTypeNm" name="custTypeNm" type="text" title="" placeholder="" class="w100p readonly" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.initial2" /><span class="must">*</span></th>
    <td><input id="custInitial" name="custInitial" type="text" title="Initial" placeholder="Initial" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.companyType2" /><span class="must">*</span></th>
    <td><input id="corpTypeNm" name="corpTypeNm" type="text" title="" placeholder="" class="w100p readonly" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.custName2" /><span class="must">*</span></th>
	<td><input id="name" name="name" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<!-- <tr>
	<th scope="row">GST Relief Certificate / Regist. No.</th>
	<td colspan="3"><p><select id="gstChk" name="gstChk" class="w100p"></select></p>
		<p><input id="txtCertCustRgsNo" name="txtCertCustRgsNo" type="text" title="" placeholder="" class="w100p" /></p>
		<p>
		<div class="auto_file file_flag">auto_file start
		<input type="file" title="file add" />
		</div>auto_file end
		</p>
	</td>
</tr> -->
</tbody>
</table><!-- table end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:350px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.nationality2" /></th>
    <td><input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Passport Visa expiry date | Visa passport tarikh tamat(foreigner)</th>
    <td><input id="visaExpr" name="visaExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Passport expiry date | Pasport tarikh luput(foreigner)</th>
    <td><input id="pasSportExpr" name="pasSportExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.dob2" /><span class="must">*</span></th>
    <td><input id="dob" name="dob" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.race2" /><span class="must">*</span></th>
	<td><input id="race" name="race" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.gender2" /><span class="must">*</span></th>
	<td><input id="gender" name="gender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.email2" /><span class="must">*</span></th>
	<td><input id="custEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row">Tel (Mobile)<span class="must">*</span></th>
	<td><input id="custTelM" name="custTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row">Tel (Residence)<span class="must">*</span></th>
	<td><input id="custTelR" name="custTelR" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
<!-- 	<th scope="row">Tel (Fax)<span class="must">*</span></th>
	<td><input id="custTelF" name="custTelF" type="text" title="" placeholder="" class="w100p readonly" readonly/></td> -->
</tr>
<tr>
	<th scope="row">Tel (Office)<span class="must">*</span></th>
	<td><input id="custTelO" name="custTelO" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row">Ext No.</th>
	<td><input id="custExt" name="custExt" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Contact Person information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:250px" />
	<col style="width:*" />
	<col style="width:250px" />
	<col style="width:*" />
</colgroup>
<tbody>
<!-- <tr>
	<th scope="row">If contact same as above click here</th>
	<td colspan="3"><input id="chkSameCntc" type="checkbox" checked/></td>
</tr> -->
</tbody>
</table><!-- table end -->

<section id="scAnothCntc">

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnNewCntc" href="#">Add New Contact</a></p></li>
    <li><p class="btn_grid"><a id="btnSelCntc" href="#">Select Another Contact</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:250px" />
	<col style="width:*" />
	<col style="width:250px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Initial<span class="must">*</span></th>
	<td><input id="custCntcInitial" name="custCntcInitial" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly/></td>
	<th scope="row">Second/Service contact person name</th>
	<td><input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row">Tel (Mobile)<span class="must">*</span></th>
	<td><input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
	<th scope="row">Tel (Residence)<span class="must">*</span></th>
	<td><input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
	<th scope="row">Tel (Office)<span class="must">*</span></th>
	<td><input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
	<th scope="row">Tel (Fax)<span class="must">*</span></th>
	<td><input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Ext No.(1)</th>
    <td><input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
    <th scope="row">Email(1)</th>
    <td><input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</section>

<aside class="title_line"><!-- title_line start -->
<h3>Installation Address &amp; Information</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
	<li><p class="btn_grid"><a id="btnNewInstAddr" href="#">Add New Address</a></p></li>
	<li><p class="btn_grid"><a id="btnSelInstAddr" href="#">Select Existing Address</a></p></li>
</ul>

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
    <th scope="row">Address Line 1<span class="must">*</span></th>
    <td colspan="3"><input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Address Line 2<span class="must">*</span></th>
    <td colspan="3"><input id="instStreet" name="instStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Area | Daerah<span class="must">*</span></th>
    <td colspan="3"><input id="instArea" name="instArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">City | Bandar<span class="must">*</span></th>
    <td colspan="3"><input id="instCity" name="instCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">PostCode | Poskod<span class="must">*</span></th>
    <td colspan="3"><input id="instPostCode" name="instPostCode" type="text" title="" placeholder="Post Code" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">State | Negeri<span class="must">*</span></th>
    <td colspan="3"><input id="instState" name="instState" type="text" title="" placeholder="State" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Country | Negara<span class="must">*</span></th>
    <td colspan="3"><input id="instCountry" name="instCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/></td>
</tr>

</tbody>
</table><!-- table end -->

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
    <th scope="row">DSC Branch<span class="must">*</span></th>
    <td colspan="3"><select id="dscBrnchId" name="dscBrnchId" class="w100p" disabled></select></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date<span class="must">*</span></th>
    <td colspan="3"><input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Install Date (dd/MM/yyyy)" class="j_date w100p" value="${nextDay}"  disabled/></td>
</tr>
<tr>
    <th scope="row">Prefer Install Time<span class="must">*</span></th>
    <td colspan="3">
    <div class="time_picker"><!-- time_picker start -->
    <input id="prefInstTm" name="prefInstTm" type="text" title="" placeholder="Prefer Install Time (hh:mi tt)" class="time_date w100p" value="11:00 AM" disabled/>
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
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<h3>Order information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:250px" />
	<col style="width:*" />
<!-- 	<col style="width:220px" />
	<col style="width:*" /> -->
</colgroup>
<tbody>
<tr>
    <th scope="row">Ex-Trade/Related No</th>
    <td><p><select id="exTrade" name="exTrade" class="w100p"></select></p>
        <p><input id="relatedNo" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly /></p></td>
</tr>
<tr>
	<th scope="row">Application Type | Jenis Permohonan<span class="must">*</span></th>
	<td>
    <p><select id="appType" name="appType" class="w100p"></select></p>
    <p><select id="srvPacId" name="srvPacId" class="w100p"></select></p>
	</td>
</tr>
<tr>
    <th scope="row">Product | Produk<span class="must">*</span></th>
    <td><select id="ordProudct" name="ordProudct" class="w100p" disabled></select></td>
</tr>
<tr>
    <th scope="row">Promotion | Promosi<span class="must">*</span></th>
    <td><select id="ordPromo" name="ordPromo" class="w100p" disabled></select></td>
</tr>
<!-- <tr>
	<th scope="row">Installment Duration<span class="must">*</span></th>
	<td><input id="installDur" name="installDur" type="text" title="" placeholder="Installment Duration (1-36 Months)" class="w100p readonly" readonly/></td>
</tr> -->
<tr>
    <th scope="row">Price / RPF (RM)</th>
    <td><input id="ordPrice"    name="ordPrice"    type="text" title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly />
        <input id="ordPriceId"  name="ordPriceId"  type="hidden" />
        <input id="normalOrdPrice" name="normalOrdPrice" type="hidden" />
        <input id="normalOrdPv"    name="normalOrdPv"    type="hidden" /></td>
</tr>
<tr>
    <th scope="row">Rental Fee<span class="must">*</span></th>
    <td><p><input id="ordRentalFees" name="ordRentalFees" type="text" title="" placeholder="" class="w100p readonly" readonly/></p></td>
</tr>
<tr>
    <th scope="row">Advance Rental Payment*</th>
    <td><span>Does customer make advance rental payment for 12 months and above?</sapn>
        <input id="advPayYes" name="advPay" type="radio" value="1" /><span>Yes</span>
        <input id="advPayNo" name="advPay" type="radio" value="0" /><span>No</span></td>
    <!-- <th scope="row">Normal Rental Fee<span class="must">*</span></th>
    <td><p><input id="normalOrdRentalFees" name="normalOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly /></p>
        <p id="pBtnCal" class="btn_sky blind"><a id="btnCal" href="#">Exclude GST Calc</a></p></td> -->
</tr>
<tr>
	<th scope="row">PO No</th>
	<td><input id="poNo" name="poNo" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<!-- <tr>
	<th scope="row">SOF No<span class="must">*</span></th>
	<td><input id="refereNo" name="refereNo" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr> -->
<tr>
	<th scope="row">Salesman Code / Name<span class="must">*</span></th>
    <td><input id="salesmanCd" name="salesmanCd" type="text" style="width:115px;" title="" placeholder="" class=""/>
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <p><input id="salesmanNm" name="salesmanNm" type="text" style="width:115px;" title="" placeholder="Salesman Name" readonly disabled/></p>
        </td>
</tr>
<tr>
    <th scope="row">Special Instruction<span class="must">*</span></th>
    <td><textarea id="speclInstct" name="speclInstct" cols="20" rows="5"></textarea></td>
</tr>
<!-- <tr>
	<th scope="row">PV<span class="must">*</span></th>
    <td><input id="ordPv"    name="ordPv"    type="text" title="" placeholder="Point Value (PV)" class="w100p readonly" readonly />
        <input id="ordPvGST" name="ordPvGST" type="hidden" /></td>
	<th scope="row">Discount Type /  Period (month)</th>
    <td><p><select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p" disabled></select></p>
        <p><input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder="" style="width:42px;" class="readonly" readonly/></p></td>
</tr> -->
</tbody>
</table><!-- table end -->

<!-- <aside class="title_line">title_line start
<h3>Free Gift Information</h3>
</aside>title_line end

<article class="grid_wrap">grid_wrap start
<div id="pop_list_gift_grid_wrap" style="width:100%; height:100px; margin:0 auto;"></div>
</article>grid_wrap end -->
<br><br><br><br><br>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section id="scPayInfo" class="search_table blind"><!-- search_table start -->

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:250px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Pay By Third Party</th>
    <td colspan="3">
    <label><input id="thrdParty" name="thrdParty" type="checkbox" value="1"/><span></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctThrdParty" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Third Party</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="thrdPartyAddCustBtn" href="#">Add New Third Party</a></p></li>
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
    <td><input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="Third Party ID" class="" />
        <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenThrdPartyId" name="hiddenThrdPartyId" type="hidden" title="" placeholder="Third Party ID" class="" /></td>
    <th scope="row">Type</th>
    <td><input id="thrdPartyType" name="thrdPartyType" type="text" title="" placeholder="Customer Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="thrdPartyName" name="thrdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="thrdPartyNric" name="thrdPartyNric" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly/></td>
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
    <col style="width:250px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th><spring:message code="sal.text.rentalPaymode2" /><span class="must">*</span></th>
    <td  scope="row" colspan="3"'>
    <select id="rentPayMode" name="rentPayMode" class="w100p"></select>
    </td>
    <!-- <th scope="row">NRIC on DD/Passbook</th>
    <td><input id="rentPayIC" name="rentPayIC" type="text" title="" placeholder="NRIC appear on DD/Passbook" class="w100p" /></td> -->
</tr>
</tbody>
</table><!-- table end -->

</section>

<section id="sctCrCard" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Bank Card</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="addCreditCardBtn" href="#">Add New Credit Card</a></p></li>
    <li><p class="btn_grid"><a id="selCreditCardBtn" href="#">Select Another Credit Card</a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Credit Card - Form ID(crcForm)
------------------------------------------------------------------------------->

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:250px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.creditCardNo2" /><span class="must">*</span></th>
    <td><input id="rentPayCRCNo" name="rentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" />
        <input id="hiddenRentPayEncryptCRCNoId" name="hiddenRentPayEncryptCRCNoId" type="hidden" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.type2" /></th>
    <td><input id="rentPayCRCType" name="rentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nameOnCard2" /></th>
    <td><input id="rentPayCRCName" name="rentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.expiryDate2" /></th>
    <td><input id="rentPayCRCExpiry" name="rentPayCRCExpiry" type="text" title="" placeholder="Credit Card Expiry" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.issueBank2" /></th>
    <td><input id="rentPayCRCBank" name="rentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" title="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.cardType2" /></th>
    <td><input id="rentPayCRCCardType" name="rentPayCRCCardType" type="text" title="" placeholder="Card Type" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- <ul class="center_btns">
    <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
</ul> -->
</section>

<section id="sctDirectDebit" class="blind">

<aside class="title_line"><!-- title_line start -->
<h3>Direct Debit</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="btnAddBankAccount" href="#">Add New Bank Account</a></p></li>
    <li><p class="btn_grid"><a id="btnSelBankAccount" href="#">Select Another Bank Account</a></p></li>
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
    <td><input id="rentPayBankAccNo" name="rentPayBankAccNo" type="text" title="" placeholder="Account Number readonly" class="w100p readonly" readonly/>
        <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" /></td>
    <th scope="row">Account Type</th>
    <td><input id="rentPayBankAccType" name="rentPayBankAccType" type="text" title="" placeholder="Account Type readonly" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><input id="accName" name="accName" type="text" title="" placeholder="Account Holder" class="w100p readonly" readonly/></td>
    <th scope="row">Issue Bank Branch</th>
    <td><input id="accBranch" name="accBranch" type="text" title="" placeholder="Issue Bank Branch" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td colspan=3><input id="accBank" name="accBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenAccBankId" name="hiddenAccBankId" type="hidden" /></td>
</tr>
</tbody>
</table><!-- table end -->

</section>

</section><!-- search_table end -->

<!--****************************************************************************
    Billing Detail
*****************************************************************************-->
<section class="search_table"><!-- search_table start -->

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
    <label><input type="radio" id="grpOpt1" name="grpOpt" value="new" /><span>New Billing Group</span></label>
    <label><input type="radio" id="grpOpt2" name="grpOpt" value="exist"/><span>Existion Billing Group</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<!------------------------------------------------------------------------------
    Billing Method - Form ID(billMthdForm)
------------------------------------------------------------------------------->
<section id="sctBillMthd" class="blind">

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="5">Billing Method<span class="must">*</span></th>
    <td colspan="3">
    <label><input id="billMthdPost" name="billMthdPost" type="checkbox" /><span>Post</span></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <label><input id="billMthdSms" name="billMthdSms" type="checkbox" /><span>SMS</span></label>
    <label><input id="billMthdSms1" name="billMthdSms1" type="checkbox" disabled/><span>Mobile 1</span></label>
    <label><input id="billMthdSms2" name="billMthdSms2" type="checkbox" disabled/><span>Mobile 2</span></label>
    </td>
</tr>
<tr>
    <td>
    <label><input id="billMthdEstm" name="billMthdEstm" type="checkbox" /><span>E-Billing</span></label>
    <label><input id="billMthdEmail1" name="billMthdEmail1" type="checkbox" disabled/><span>Email 1</span></label>
    <label><input id="billMthdEmail2" name="billMthdEmail2" type="checkbox" disabled/><span>Email 2</span></label>
    </td>
    <th scope="row">Email(1)<span id="spEmail1" class="must">*</span></th>
    <td><input id="billMthdEmailTxt1" name="billMthdEmailTxt1" type="text" title="" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td></td>
    <th scope="row">Email(2)</th>
    <td><input id="billMthdEmailTxt2" name="billMthdEmailTxt2" type="text" title="" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td>
    <label><input id="billGrpWeb" name="billGrpWeb" type="checkbox" /><span>Web Portal</span></label>
    </td>
    <th scope="row">Web address(URL)</th>
    <td><input id="billGrpWebUrl" name="billGrpWebUrl" type="text" title="" placeholder="Web Address" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</section>

<!------------------------------------------------------------------------------
    Billing Address - Form ID(billAddrForm)
------------------------------------------------------------------------------->
<section id="sctBillAddr" class="blind">
    <input id="hiddenBillAddId"     name="custAddId"           type="hidden"/>
    <input id="hiddenBillStreetId"  name="hiddenBillStreetId"  type="hidden"/>

<aside class="title_line"><!-- title_line start -->
<h3>Billing Address</h3>
</aside><!-- title_line end -->

<!-- <ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
    <li><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
</ul> -->

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
    <th scope="row">Address Detail<span class="must">*</span></th>
    <td colspan="3">
    <input id="billAddrDtl" name="billAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td colspan="3">
    <input id="billStreet" name="billStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td colspan="3">
    <input id="billArea" name="billArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">City<span class="must">*</span></th>
    <td colspan="3">
    <input id="billCity" name="billCity" type="text" title="" placeholder="City" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">PostCode<span class="must">*</span></th>
    <td colspan="3">
    <input id="billPostCode" name="billPostCode" type="text" title="" placeholder="Postcode" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">State<span class="must">*</span></th>
    <td colspan="3">
    <input id="billState" name="billState" type="text" title="" placeholder="State" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td colspan="3">
    <input id="billCountry" name="billCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly/>
    </td>
</tr>

</tbody>
</table><!-- table end -->
<!-- Existing Type end -->
</section>
<br>

<section id="sctBillPrefer" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3>Billing Preference</h3>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li class="blind"><p class="btn_grid"><a id="billPreferAddAddrBtn" href="#">Add New Contact</a></p></li>
    <li class="blind"><p class="btn_grid"><a id="billPreferSelAddrBtn" href="#">Select Another Contact</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Billing Preference - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section class="search_table"><!-- search_table start -->
    <input id="hiddenBPCareId" name="hiddenBPCareId" type="hidden" />
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
    <th scope="row">Initials<span class="must">*</span></th>
    <td colspan="3"><select id="billPreferInitial" name="billPreferInitial" class="w100p"></select>
        </td>
</tr>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td colspan="3"><input id="billPreferName" name="billPreferName" type="text" title="" placeholder="Name" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel(Office)<span class="must">*</span></th>
    <td><input id="billPreferTelO" name="billPreferTelO" type="text" title="" placeholder="Tel(Office)" class="w100p" readonly/></td>
    <th scope="row">Ext No.<span class="must">*</span></th>
    <td><input id="billPreferExt" name="billPreferExt" type="text" title="" placeholder="Ext No." class="w100p" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</section><!-- search_table end -->
</section>

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
    <td><input id="billGrp" name="billGrp" type="text" title="" placeholder="Billing Group" class="readonly" readonly/><a id="billGrpBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenBillGrpId" name="billGrpId" type="hidden" /></td>
    <th scope="row">Billing Type<span class="must">*</span></th>
    <td><input id="billType" name="billType" type="text" title="" placeholder="Billing Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Billing Address</th>
    <td colspan="3"><textarea id="billAddr" name="billAddr" cols="20" rows="5" readonly></textarea></td>
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
<!-- <tr>
    <th scope="row">Remark</th>
    <td><textarea id="billRem" name="billRem" cols="20" rows="5" readonly></textarea></td>
</tr> -->
</tbody>
</table><!-- table end -->
<!-- Existing Type end -->

</section><!-- search_table end -->

</article><!-- tap_area end -->


</section><!-- tap_wrap end -->

<ul class="center_btns mt20">
	<li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
</ul>

</section>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content END
------------------------------------------------------------------------------->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
