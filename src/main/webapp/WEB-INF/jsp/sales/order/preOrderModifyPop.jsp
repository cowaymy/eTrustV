<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var TODAY_DD      = "${toDay}";
var BEFORE_DD = "${bfDay}";
var blockDtFrom = "${hsBlockDtFrom}";
var blockDtTo = "${hsBlockDtTo}";
var userType = "${userType}";


    //AUIGrid 생성 후 반환 ID
    var listGiftGridID;
    var FailedRemarkGridID;
    var update = new Array();
    var remove = new Array();
    var sofFileId = 0;
    var nricFileId = 0;
    var payFileId = 0;
    var trFileId = 0;
    var otherFileId = 0;
    var otherFileId2 = 0;
    var sofTncFileId = 0;
    var msofFileId = 0;
    var msofTncFileId = 0;

    var sofFileName = "";
    var nricFileName = "";
    var payFileName = "";
    var trFileName = "";
    var otherFileName = "";
    var otherFileName2 = "";
    var sofTncFileName = "";
    var msofFileName = "";
    var msofTncFileName = "";
    var myFileCaches = {};
    var checkFileValid = true;

    var voucherAppliedStatus = 0;
    var voucherAppliedCode = "";
    var voucherAppliedEmail = "";
    var voucherPromotionId = [];

    var codeList_562 = [];
    codeList_562.push({codeId:"0", codeName:"No", code:"No"});
    <c:forEach var="obj" items="${codeList_562}">
    codeList_562.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    $(document).ready(function(){

        createAUIGridStk();
        createAUIGridFailedRemark();
        fn_selectFailedRemarkList();

        doDefCombo(codeList_562, '0', 'voucherType', 'S', 'displayVoucherSection');

        doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '${preOrderInfo.appTypeId}', 'appType',     'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '${preOrderInfo.rentPayModeId}', 'rentPayMode', 'S', ''); //Common Code
      //doGetComboOrder('/common/selectCodeList.do', '17', 'CODE_NAME', '', 'billPreferInitial', 'S', ''); //Common Code
        doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code
        doGetComboSepa ('/common/selectBranchCodeList.do', '1',  ' - ', '', 'keyinBrnchId',  'S', ''); //Branch Code

        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, '${preOrderInfo.exTrade}', 'exTrade', 'S'); //EX-TRADE
        /*doGetComboData('/common/selectCodeList.do', {groupCode :'326'}, '${preOrderInfo.gstChk}',  'gstChk',  'S'); //GST_CHK */
        /* doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '${preOrderInfo.promoDiscPeriodTp}', 'promoDiscPeriodTp', 'S'); //Discount period */
        doGetComboOrder('/common/selectCodeList.do', '415', 'CODE_ID',   '', 'corpCustType',     'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '416', 'CODE_ID',   '', 'agreementType',     'S', ''); //Common Code

        if('${preOrderInfo.voucherInfo}' != null && '${preOrderInfo.voucherInfo}' != ""){
            $('#voucherCode').val('${preOrderInfo.voucherInfo.voucherCode}');
            $('#voucherEmail').val('${preOrderInfo.voucherInfo.custEmail}');
            $('#voucherType').val('${preOrderInfo.voucherInfo.platformId}');
            applyCurrentUsedVoucher();
        }

        //Attach File
        //$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>Upload</a></span></label>");
        var custId = '${preOrderInfo.custId}';
        var salesOrdIdOld = '${preOrderInfo.salesOrdIdOld}';
        if(salesOrdIdOld != null || salesOrdIdOld != '' || salesOrdIdOld != '0'){
        	//checkExtradePreBookEligible(custId,salesOrdIdOld); //REMOVE PREBOOK
        	checkOldOrderServiceExpiryMonth(custId,salesOrdIdOld);
        }else{
        	$('#hiddenPreBook').val('0');
        	$('#hiddenMonthExpired').val('0');
        	fn_loadPreOrderInfo('${preOrderInfo.custId}', null);
        }

        //fn_loadPreOrderInfo('${preOrderInfo.custId}', null);

        if('${preOrderInfo.stusId}' == 4 || '${preOrderInfo.stusId}' == 10 ){
            $('#scPreOrdArea').find("input,textarea,button,select").attr("disabled",true);
            $("#scPreOrdArea").find("p.btn_grid").hide();
            $('#btnSave').hide();
            $(".input_text").attr('disabled',false).addClass("readonly");;
        }

        if('${preOrderInfo.atchFileGrpId}' != 0){
            fn_loadAtchment('${preOrderInfo.atchFileGrpId}');
        }

        var vCustType = $("#hiddenTypeId").val();
        console.log("vCustType : " + vCustType);
        if (vCustType == '965' && '${preOrderInfo.appTypeId}' ){
            $("#corpCustType").removeAttr("disabled");
            $("#agreementType").removeAttr("disabled");
        }
        else{
            $("#corpCustType").prop("disabled", true);
            $("#agreementType").prop("disabled", true);
        }
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

 function createAUIGridFailedRemark() {

    //AUIGrid 칼럼 설정
     var columnLayout = [
            { headerText : 'Status', dataField : "stus", width : 150}
          , { headerText : 'Fail Reason', dataField : "rem1", width : 150}
          , { headerText : 'Remark', dataField : "rem2", width : 355 }
          , { headerText : 'Creator', dataField : "crtUserId",  width : 180 }
          , { headerText : 'Create Date', dataField : "crtDt",  width : 180, dataType : "date", formatString : "dd/mm/yyyy"}
          , { headerText : 'Create Time', dataField : "crtTime",  width : 180}
     ];

     var gridPros = {
              usePaging : true,
              pageRowCount : 10,
              editable : false,
              selectionMode : "singleRow",
              showRowNumColumn : true,
              showStateColumn : false,
              wordWrap : true
     };

     FailedRemarkGridID =  GridCommon.createAUIGrid("grid_FailedRemark_wrap", columnLayout, "", gridPros);
 }

 function fn_selectFailedRemarkList() {
     Common.ajax("GET", "/sales/order/selectPreOrderFailStatus.do", {preOrdId : $('#frmPreOrdReg #hiddenPreOrdId').val().trim()}, function(result) {
            AUIGrid.setGridData(FailedRemarkGridID, result);
     });
 }

 function disableSaveButton() {
     $('#btnSave').unbind()
 }

 function enableSaveButton() {
     disableSaveButton()
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

         if(!fn_validFile()) {
             $('#aTabFL').click();
             return false;
         }

         if(!fn_validRcdTms()) {
             $('#aTabBD').click();
             return false;
         }

         var formData = new FormData();
         formData.append("atchFileGrpId", '${preOrderInfo.atchFileGrpId}');
         formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
         formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
         console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
         console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
         $.each(myFileCaches, function(n, v) {
             console.log(v.file);
             formData.append(n, v.file);
         });

         //fn_doSavePreOrder();
         checkSalesPerson($('#salesmanCd').val(),$('#txtOldOrderID').val(),$('#relatedNo').val());

     });
 }

    $(function(){
        $('#btnRltdNoEKeyIn').click(function() {
            Common.popupDiv("/sales/order/prevOrderNoPop.do", {custId : $('#hiddenCustId').val()}, null, true);
        });

        $('#btnConfirm').click(function() {
            if(!fn_validConfirm())  return false;
            if(fn_isExistESalesNo() == 'true') return false;

            $('#scPreOrdArea').removeClass("blind");

            $('#refereNo').val($('#sofNo').val().trim())

            fn_loadCustomer(null, $('#nric').val());
        });
        $('#nric').keydown(function (event) {
            if (event.which === 13) {
                if(!fn_validConfirm())  return false;
                if(fn_isExistESalesNo() == 'true') return false;

                $('#refereNo').val($('#sofNo').val().trim())

                fn_loadCustomer(null, $('#nric').val());
            }
        });
        $('#sofNo').keydown(function (event) {
            if (event.which === 13) {
                if(!fn_validConfirm())  return false;
                if(fn_isExistESalesNo() == 'true') return false;

                $('#refereNo').val($('#sofNo').val().trim())

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
            Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {custId : $('#hiddenCustId').val(), callParam : "PRE_ORD_CNTC"}, null , true);
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
                            $('[name="advPay"]').removeAttr("disabled");
                            $('#installDur').val('').prop("readonly", true).addClass("readonly");
                          //$("#gstChk").val('0');
                          //$('#pBtnCal').addClass("blind");

                            appSubType = '367';

                            var vCustType = $("#hiddenTypeId").val();
                            console.log("vCustType : " + vCustType);
                            if (vCustType == '965' ){
                                $("#corpCustType").removeAttr("disabled");
                                $("#agreementType").removeAttr("disabled");
                            }
                            else{
                                $("#corpCustType").prop("disabled", true);
                                $("#agreementType").prop("disabled", true);
                            }

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

                            $('[name="advPay"]').removeAttr("disabled");

                          //fn_tabOnOffSet('PAY_CHA', 'SHOW');
                          //fn_tabOnOffSet('REL_CER', 'HIDE');

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

                    $('#ordProudct').removeAttr("disabled");
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

            //fn_clearRentPaySetCRC();
            //fn_clearRentPaySetDD();

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
        $('#exTrade').change(function() {

            $('#ordPromo option').remove();
            fn_clearAddCpnt();
            $('#relatedNo').val("");

            if($("#exTrade").val() == '1' || $("#exTrade").val() == '2') {
                //$('#relatedNo').removeAttr("readonly").removeClass("readonly");
                $('#btnRltdNoEKeyIn').removeClass("blind");

                if($('#exTrade').val()=='1'){
                    var todayDD = Number(TODAY_DD.substr(0, 2));
                    var todayYY = Number(TODAY_DD.substr(6, 4));

                    var strBlockDtFrom = blockDtFrom + BEFORE_DD.substr(2);
                    var strBlockDtTo = blockDtTo + TODAY_DD.substr(2);

                    console.log("todayDD: " + todayDD);
                    console.log("blockDtFrom : " + blockDtFrom);
                    console.log("blockDtTo : " + blockDtTo);

                     if(todayDD >= blockDtFrom && todayDD <= blockDtTo) { // Block if date > 22th of the month
                         var msg = "Extrade sales key-in does not meet period date (Submission start on 1st of every month)";
                         Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", '');
                         return;
                     }
               }

            }
            else {
                //$('#relatedNo').val('').prop("readonly", true).addClass("readonly");
                $('#relatedNo').val('');
                $('#hiddenMonthExpired').val('');
                $('#hiddenPreBook').val('');
                $('#btnRltdNoEKeyIn').addClass("blind");
            }
            $('#isReturnExtrade').prop("checked", true);
            $('#isReturnExtrade').attr("disabled",true);
            $('#ordProudct').val('');
            $('#speclInstct').val('');


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
            disableSaveButton()
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
            var empChk     = 0;
            var exTrade    = $("#exTrade").val();
            var srvPacId = (appTypeVal == '66') ? $('#srvPacId').val() : 0;

            if(stkIdx > 0) {
                fn_loadProductPrice(appTypeVal, stkIdVal,srvPacId);
                fn_loadProductPromotion(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade);
            }

            fn_loadProductComponent(stkIdVal);
            setTimeout(function() { fn_check(0) }, 200);
        });
        $('#ordPromo').change(function() {
            disableSaveButton()
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
            var srvPacId = (appTypeVal == '66') ? $('#srvPacId').val() : 0;

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

            fn_checkPromotionExtradeAvail();
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
                    fn_loadPromotionPrice(promoIdVal, stkIdVal, srvPacId);
                }
            }
        });


        $('#addCreditCardBtn').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            var vCustNric = $('#thrdParty').is(":checked") ? "" : $('#nric').val();
            Common.popupDiv("/sales/customer/customerCreditCardeSalesAddPop.do", {custId : vCustId, callPrgm : "PRE_ORD", nric : vCustNric}, null, true);
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
        $('#sofFile').change( function(evt) {
            var file = evt.target.files[0];
             if(file.name != sofFileName){
                 myFileCaches[1] = {file:file};
                 if(sofFileName != ""){
                     update.push(sofFileId);
                 }
             }

             var msg = '';
             if(file.name.length > 30){
                 msg += "*File name wording should be not more than 30 alphabet.<br>";
             }

             var fileType = file.type.split('/');
             if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                 msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
             }

             if(file.size > 2000000){
                 msg += "*Only allow picture with less than 2MB.<br>";
             }
             if(msg != null && msg != ''){
                 myFileCaches[1].file['checkFileValid'] = false;
                 Common.alert(msg);
             }
             else{
                 myFileCaches[1].file['checkFileValid'] = true;
             }
             console.log(myFileCaches);
        });
        $('#nricFile').change( function(evt) {
            var file = evt.target.files[0];
            if(file.name != nricFileName){
                myFileCaches[2] = {file:file};
                if(nricFileName != ""){
                    update.push(nricFileId);
                }
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[2].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[2].file['checkFileValid'] = true;
            }
        });
        $('#payFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(payFileId);
            }else if(file.name != payFileName){
                myFileCaches[3] = {file:file};
                if(payFileName != ""){
                    update.push(payFileId);
                }
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[3].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[3].file['checkFileValid'] = true;
            }
        });

        $('#trFile').change(function(evt) {
            var file = evt.target.files[0];

            if(file == null){
                remove.push(trFileId);
            }else if(file.name != trFileName){
                myFileCaches[4] = {file:file};
                if(trFileName != ""){
                    update.push(trFileId);
               }
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[4].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[4].file['checkFileValid'] = true;
            }
        });

        $('#otherFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(otherFileId);
            }else if(file.name != otherFileName){
                myFileCaches[5] = {file:file};
                if(otherFileName != ""){
                    update.push(otherFileId);
                }
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[5].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[5].file['checkFileValid'] = true;
            }
        });

        $('#otherFile2').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(otherFileId2);
            }else if(file.name != otherFileName2){
                myFileCaches[6] = {file:file};
                if(otherFileName2 != ""){
                    update.push(otherFileId2);
                }
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[6].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[6].file['checkFileValid'] = true;
            }
        });

        $('#sofTncFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(sofTncFileId);
            }else if(file.name != sofTncFileName){
                myFileCaches[7] = {file:file};
                if(sofTncFileName != ""){
                    update.push(sofTncFileId);
                }
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[7].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[7].file['checkFileValid'] = true;
            }
        });

        $('#msofFile').change( function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(msofFileId);
            }else if(file.name != msofFileName){
                 myFileCaches[8] = {file:file};
                 if(msofFileName != ""){
                     update.push(msofFileId);
                 }
             }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[8].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[8].file['checkFileValid'] = true;
            }
        });

        $('#msofTncFile').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null){
                remove.push(msofTncFileId);
            }else if(file.name != msofTncFileName){
                myFileCaches[9] = {file:file};
                if(msofTncFileName != ""){
                    update.push(msofTncFileId);
                }
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[1] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[9].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[9].file['checkFileValid'] = true;
            }
        });

        enableSaveButton()
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

    function fn_clearAddCpnt() {
          $('#compType option').remove();
        }

    function fn_loadBankAccount(bankAccId) {
        console.log("fn_loadBankAccount START");

        Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

            if(rsltInfo != null) {
                console.log("fn_loadBankAccount Setting");

                $("#hiddenRentPayBankAccID").val(rsltInfo.custAccId);
                $("#rentPayBankAccNo").val(rsltInfo.custAccNo);
                $("#rentPayBankAccNoEncrypt").val(rsltInfo.custEncryptAccNo);
                $("#rentPayBankAccType").val(rsltInfo.codeName);
                $("#accName").val(rsltInfo.custAccOwner);
                $("#accBranch").val(rsltInfo.custAccBankBrnch);
                $("#accBank").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
                $("#hiddenAccBankId").val(rsltInfo.custAccBankId);
            }
        });
    }

    function fn_loadCreditCard2(custCrcId) {
        console.log("fn_loadCreditCard START");
        console.log(custCrcId);
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
            console.log('isExist:'+isExist);
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
            console.log('isExist:'+isExist);
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
        var custType = $("#hiddenTypeId").val();
        var exTrade = $("#exTrade").val();


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

        if($("#srvPacId option:selected").index() <= 0){
     	   isValid = false;
            msg += "* Please select a package.<br>";
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

        if($("#ordPromo option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select a promotion.<br>";
        }

        if(exTrade == '1' || exTrade == '2') {
            if(FormUtil.checkReqValue($('#relatedNo'))) {
                isValid = false;
                msg += "* Please select old order no.<br>";
            }
        }

        if($('#voucherType').val() == ""){
         isValid = false;
            msg += "* Please select voucher type.<br>";
       }

       if($('#voucherType').val() != "" && $('#voucherType').val() > 0){
        if(voucherAppliedStatus == 0){
         isValid = false;
            msg += "* You have selected a voucher type. Please apply a voucher is any.<br>";
        }
       }

        //if (custType == '965' && appTypeVal == '66'){
         //   if ($("#corpCustType option:selected").index() <= 0) {
        //        isValid = false;
        //        msg += '* Please select SST Type<br>';
        //    }

        //    if ($("#agreementType option:selected").index() <= 0) {
        //        isValid = false;
        //        msg += '* Please select Agreement Type<br>';
       //     }
      //  }

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
            msg += "* Please key in SOF No.<br>";
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

        if($("#keyinBrnchId option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the Posting branch.<br>";
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

        //Save attachment first
        var vAppType    = $('#appType').val();
        var vCustCRCID  = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCId').val() : 0;
        var vCustAccID  = $('#rentPayMode').val() == '132' ? $('#hiddenRentPayBankAccID').val() : 0;
        var vBankID     = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCBankId').val() : $('#rentPayMode').val() == '132' ? $('#hiddenAccBankId').val() : 0;
        var vIs3rdParty = $('#thrdParty').is(":checked") ? 1 : 0;
        var vCustomerId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
        var vCustBillId = vAppType == '66' ? $('input:radio[name="grpOpt"]:checked').val() == 'exist' ? $('#hiddenBillGrpId').val() : 0 : 0;
        var vStusId = ('${preOrderInfo.stusId}' != 1) ? 104 : 1;
        var vIsReturnExtrade = "";
        if($('#exTrade').val() == 1){
            if($('#isReturnExtrade').is(":checked")) {
                vIsReturnExtrade = 1;
            }else{
                vIsReturnExtrade = 0;
            }
        }

        var orderVO = {

                preOrdId             : $('#frmPreOrdReg #hiddenPreOrdId').val().trim(),
                sofNo                : $('#sofNo').val().trim(),
                custPoNo             : $('#poNo').val().trim(),
                appTypeId            : vAppType,
                srvPacId             : $('#srvPacId').val(),
                //instPriod            : $('#installDur').val().trim(),
                custId               : $('#hiddenCustId').val(),
                empChk               : 0,
                gstChk               : $('#gstChk').val(),
                atchFileGrpId        : '${preOrderInfo.atchFileGrpId}',
                custCntcId           : $('#hiddenCustCntcId').val(),
                keyinBrnchId         : $('#keyinBrnchId').val(),
                instAddId            : $('#hiddenCustAddId').val(),
                dscBrnchId           : $('#dscBrnchId').val(),
                preDt                : $('#prefInstDt').val().trim(),
                preTm                : $('#prefInstTm').val().trim(),
                instct               : $('#speclInstct').val().trim(),
                exTrade              : $('#exTrade').val(),
                itmStkId             : $('#ordProudct').val(),
                itmCompId          : $('#compType').val(),
                promoId              : $('#ordPromo').val(),
                mthRentAmt           : $('#ordRentalFees').val().trim(),
//                promoDiscPeriodTp    : $('#promoDiscPeriodTp').val(),
//                promoDiscPeriod      : $('#promoDiscPeriod').val().trim(),
                totAmt               : $('#ordPrice').val().trim(),
                norAmt               : $('#normalOrdPrice').val().trim(),
//                norRntFee            : $('#normalOrdRentalFees').val().trim(),
                discRntFee           : $('#ordRentalFees').val().trim(),
                totPv                : $('#ordPv').val().trim(),
                totPvGst             : $('#ordPvGST').val().trim(),
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
                //custBillRem          : $('#billRem').val().trim(),
                custBillEmail        : $('#billMthdEmailTxt1').val().trim(),
                custBillIsSms        : $('#billMthdSms1').is(":checked") ? 1 : 0,
                custBillIsPost       : $('#billMthdPost').is(":checked") ? 1 : 0,
                custBillEmailAdd     : $('#billMthdEmailTxt2').val().trim(),
                custBillIsWebPortal  : $('#billGrpWeb').is(":checked")   ? 1 : 0,
                custBillWebPortalUrl : $('#billGrpWebUrl').val().trim(),
                custBillIsSms2       : $('#billMthdSms2').is(":checked") ? 1 : 0,
                custBillCustCareCntId: $("#hiddenBPCareId").val(),
                stusId                     : vStusId,
                corpCustType         : $('#corpCustType').val(),
                agreementType         : $('#agreementType').val(),
                salesOrdIdOld          : $('#txtOldOrderID').val(),
                relatedNo               : $('#relatedNo').val(),
                isExtradePR         : vIsReturnExtrade,
                receivingMarketingMsgStatus   : $('input:radio[name="marketingMessageSelection"]:checked').val(),
                voucherCode : voucherAppliedCode
        };

        var formData = new FormData();
        formData.append("atchFileGrpId", '${preOrderInfo.atchFileGrpId}');
        formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
        console.log(JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));
        $.each(myFileCaches, function(n, v) {
            console.log(v.file);
            formData.append(n, v.file);
        });

        Common.ajaxFile("/sales/order/attachFileUpdate.do", formData, function(result) {
            if(result.code == 99){
                Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
                //myFileCaches = {};
            }else{

                Common.ajax("POST", "/sales/order/modifyPreOrder.do", orderVO, function(result) {
                    Common.alert("Order Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_closePreOrdModPop);
                },
                function(jqXHR, textStatus, errorThrown) {
                    var errMsg = jqXHR.responseJSON.message;
                    try {
                        Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order. " + errMsg + "</b>");
                    }
                    catch (e) {
                        console.log(e);
                    }
                });
                //myFileCaches = {};
            }
        },function(result){
            Common.alert(result.message+"<br/>Upload Failed. Please check with System Administrator.");
        });
    }

    function fn_check(a) {
        console.log("CURRENT LENGTH :: " + $('#compType option').length);
        if ($('#compType option').length <= 0) {
            console.log("WAITING RESPONE :: RETRY  TIMES :: " + a);
            if (a == 3) {
                return;
            } else {
              setTimeout(function() { fn_check( parseInt(a) + 1 ) }, 500);
            }
        } else if ($('#compType option').length <= 1) {
          $('#compType').addClass("blind");
          $('#compType').prop("disabled", true);
        } else if ($('#compType option').length > 1) {
          $('#compType').removeClass("blind");
          $('#compType').removeAttr("disabled");

          var key = 0;
          Common.ajax("GET", "/sales/order/selectProductComponentDefaultKey.do", {stkId : $("#ordProudct").val()}, function(defaultKey) {
            if(defaultKey != null) {
              key = defaultKey.code;
              fn_reloadPromo();
            }
            $('#compType').val(key).change();
          });
        }
      }

    function fn_reloadPromo() {
        $('#ordPromo option').remove();
        $('#ordPromo').removeClass("blind");
        $('#ordPromo').removeClass("disabled");

        var appTyp = $("#appType").val();
        var stkId = $("#ordProudct").val();
        var cpntId = $("#compType").val();
        var empInd = 0;
        var exTrade = $("#exTrade").val();
        var srvPacId = appTyp != 66 ? '' : $("#srvPacId").val();
        var custTypeId = $("#hiddenTypeId").val();

        doGetComboData('/sales/order/selectPromoBsdCpnt.do', { appTyp:appTyp, stkId:stkId, custTypeId:custTypeId, cpntId:cpntId, empInd:empInd, exTrade:exTrade, srvPacId:srvPacId, custStatus: $('#hiddenCustStatusId').val()}, '', 'ordPromo', 'S', '');
      }

    function fn_closePreOrdModPop() {
        fn_getPreOrderList();
        myFileCaches = {};
        delete update;
        delete remove;
        $('#_divPreOrdModPop').remove();
    }

    function fn_closePreOrdModPop2(){
        myFileCaches = {};
        delete update;
        delete remove;
        $('#_divPreOrdModPop').remove();
    }

    function fn_setBillGrp(grpOpt) {

        if(grpOpt == 'new') {

            fn_clearBillGroup();

            $('#grpOpt1').prop("checked", true);

            //$('#sctBillMthd').removeClass("blind");
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
                    $('#billMthdEmailTxt1').removeAttr("disabled");
                    $('#billMthdEmailTxt2').removeAttr("disabled");
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
            console.log('fn_loadOrderSalesman memId:'+memInfo);
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

               //$("#promoDiscPeriodTp").val(promoPriceInfo.promoDiscPeriodTp);
                $("#promoDiscPeriod").val(promoPriceInfo.promoDiscPeriod);

            }
            enableSaveButton()
        });
    }

    //LoadProductComponent
    function fn_loadProductComponent(stkId) {
        var cnptId = '${preOrderInfo.cpntId}' != undefined ? '${preOrderInfo.cpntId}' : 0;
        doGetComboData('/sales/order/selectProductComponent.do', {stkId:stkId}, cnptId, 'compType', 'S', ''); //Common Code
    }

    //LoadProductPromotion
    function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal, exTrade) {
        console.log('fn_loadProductPromotion --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPromotion --> stkId:'+stkId);
        console.log('fn_loadProductPromotion --> empChk:'+empChk);
        console.log('fn_loadProductPromotion --> custTypeVal:'+custTypeVal);

        $('#ordPromo').removeAttr("disabled");

        var isSrvPac = null;
        if(appTypeVal == "66") isSrvPac = "Y";

        if('${preOrderInfo.month}' >= '7' && '${preOrderInfo.year}' >= '2019') {
            doGetComboData('/sales/order/selectPromotionByAppTypeStockESales.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), isSrvPac:isSrvPac, voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, '', 'ordPromo', 'S', 'voucherPromotionCheck'); //Common Code
        }
        else
        {
            doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val(), voucherPromotion: voucherAppliedStatus,custStatus: $('#hiddenCustStatusId').val()}, '', 'ordPromo', 'S', 'voucherPromotionCheck'); //Common Code

        }
        //doGetComboData('/sales/order/selectPromotionByAppTypeStockESales.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade, srvPacId:$('#srvPacId').val()}, '', 'ordPromo', 'S', ''); //Common Code
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
            enableSaveButton()
        });
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function fn_setDefaultSrvPacId() {
        //if($('#srvPacId option').size() == 2) {
            $('#srvPacId option:eq(1)').attr('selected', 'selected');

            var stkType = $("#appType").val() == '66' ? '1' : '2';

            doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:$('#srvPacId').val()}, '', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
        //}
    }

    function fn_clearSales() {
        $('#installDur').val('');
        $('#ordProudct').val('');
        $('#ordPromo').val('');
        $('#relatedNo').val('');
        $('#hiddenMonthExpired').val('');
        $('#hiddenPreBook').val('');
        $('#isReturnExtrade').prop("checked", true);
        $('#isReturnExtrade').attr("disabled",true);
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

        //$('#hiddenBPCareId').val('');
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

    function fn_loadBillingGroupById(custId, custBillId){
        Common.ajax("GET", "/sales/customer/selectBillingGroupByKeywordCustIDList.do", {custId : custId, custBillId : custBillId}, function(result) {
            if(result != null && result.length > 0) {
                fn_loadBillingGroup(result[0].custBillId, result[0].custBillGrpNo, result[0].billType, result[0].billAddrFull, result[0].custBillRem, result[0].custBillAddId);
            }
        });
    }

    function fn_getSvrPacCombo(selVal, srvPacId){

        switch(selVal) {
            case '66' : //RENTAL
                $('#scPayInfo').removeClass("blind");
                $('[name="advPay"]').removeAttr("disabled");

                appSubType = '367';
                break;
            case '67' : //OUTRIGHT
                appSubType = '368';
                break;
            case '68' : //INSTALLMENT
                appSubType = '369';
                break;
            case '1412' : //Outright Plus
                $('#scPayInfo').removeClass("blind");
                $('[name="advPay"]').removeAttr("disabled");
                $('#installDur').val('').prop("readonly", true).addClass("readonly");
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
                break;
        }

        var pType = $("#appType").val() == '66' ? '1' : '2';
        //doGetComboData('/common/selectCodeList.do', {pType : pType}, '',  'srvPacId',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
        doGetComboData('/sales/order/selectServicePackageList.do', {appSubType : appSubType, pType : pType}, srvPacId, 'srvPacId', 'S', ''); //APPLICATION SUBTYPE
    }

    function fn_loadPreOrderInfo(custId, nric){

        var vCustTypeId = '';

        Common.ajaxSync("GET", "/sales/customer/selectCustomerJsonList", {custId : custId, nric : nric}, function(result) {

            if(result != null && result.length == 1) {

                $('#scPreOrdArea').removeClass("blind");

                var custInfo = result[0];
                console.log("성공.");
                console.log("custId : " + result[0].custId);
                console.log("userName1 : " + result[0].name);
                var maskedNric;
                //
                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
//              $("#custId").val(custInfo.custId); //Customer ID
                $("#custTypeNm").val(custInfo.codeName1); //Customer Name
                $("#hiddenTypeId").val(custInfo.typeId); //Type
                $("#name").val(custInfo.name); //Name

                var maskedNric;

                if ('${preOrderInfo.stusId}' == '4' || '${preOrderInfo.stusId}' == '10'){
                    if(userType == 1 || userType == 2 || userType == 7){
                        maskedNric = custInfo.nric.substr(-4).padStart(custInfo.nric.length, '*');
                    }
                    else{
                        maskedNric = custInfo.nric;
                    }
                }
                else{
                    maskedNric = custInfo.nric;
                }
                $("#nric2").val(maskedNric); //NRIC/Company No
                $("#nric").val(custInfo.nric); //NRIC/Company No

                vCustTypeId = custInfo.typeId;

                $("#nationNm").val(custInfo.name2); //Nationality
                $("#race").val(custInfo.codeName2); //
                $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                $("#gender").val(custInfo.gender); //Gender
                //$("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                //$("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                if(custInfo.typeId == '964'){
                    if(custInfo.nation == '1'){
                        $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                        $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                    }else{
                        $("#pasSportExpr").val(custInfo.pasSportExpr); //Passport Expiry
                        $("#visaExpr").val(custInfo.visaExpr); //Visa Expiry
                    }
               }
                $("#custEmail").val(custInfo.email); //Email
                $('#speclInstct').html('${preOrderInfo.instct}');
                if ('${preOrderInfo.appTypeId}' == '66' && custInfo.typeId == '965') {
                    doGetComboOrder('/common/selectCodeList.do', '415', 'CODE_ID',   '${preOrderInfo.corpCustType}', 'corpCustType',     'S', ''); //Common Code
                    $('#corpCustType').removeAttr("disabled");
                    doGetComboOrder('/common/selectCodeList.do', '416', 'CODE_ID',   '${preOrderInfo.agreementType}', 'agreementType',     'S', ''); //Common Code
                    $('#agreementType').removeAttr("disabled");

                  }

                $("#hiddenCustStatusId").val(custInfo.custStatusId); //Customer Status
                $("#custStatus").val(custInfo.custStatus); //Customer Status

                if(custInfo.receivingMarketingMsgStatus == 1){
                    $("#marketMessageYes").prop("checked", true);
                }
                else{
                    $("#marketMessageNo").prop("checked", true);
                }

                if(custInfo.corpTypeId > 0) {
                    $("#corpTypeNm").val(custInfo.codeName); //Industry Code
                }
                else {
                    $("#corpTypeNm").val(""); //Industry Code
                }

                if('${preOrderInfo.custBillAddId}' != null && '${preOrderInfo.instAddId}' != null) {
                    //----------------------------------------------------------
                    // [Billing Detail] : Billing Address SETTING
                    //----------------------------------------------------------
                    fn_loadBillAddr('${preOrderInfo.custBillAddId}');

                    //----------------------------------------------------------
                    // [Installation] : Installation Address SETTING
                    //----------------------------------------------------------
                    fn_loadInstallAddr('${preOrderInfo.instAddId}');
                }

                if('${preOrderInfo.custCntcId}' > 0) {
                    //----------------------------------------------------------
                    // [Master Contact] : Owner & Purchaser Contact
                    //                    Additional Service Contact
                    //----------------------------------------------------------
                    fn_loadMainCntcPerson('${preOrderInfo.custCntcId}');
                    fn_loadCntcPerson('${preOrderInfo.custCntcId}');
                    //fn_loadSrvCntcPerson('${preOrderInfo.custBillCustCareCntId}');

                    if('${preOrderInfo.custCntcId}' != custInfo.custCntcId) {
                        $('#chkSameCntc').prop("checked", false);
                        $('#scAnothCntc').removeClass("blind");
                    }
                }

                // Salesman
                fn_loadOrderSalesman(null, '${preOrderInfo.memCode}');

                if(custInfo.codeName == 'Government') {
                    Common.alert('<b>Goverment Customer</b>');
                }
            }
            else {
                Common.confirm('<b>* This customer is existing customer.<br>Do you want to create a customer?</b>', fn_createCustomerPop);
            }
        });

        //--------------------------------------------------------------
        // [Order Info]
        //--------------------------------------------------------------
        //$('#appType').val('${preOrderInfo.appTypeId}');

        fn_getSvrPacCombo('${preOrderInfo.appTypeId}', '${preOrderInfo.srvPacId}');

      //$('#srvPacId').val('${preOrderInfo.srvPacId}');

        $('#ordProudct').removeAttr("disabled");

        var stkType = '${preOrderInfo.appTypeId}' == '66' ? '1' : '2';
        doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {stkType:stkType, srvPacId:'${preOrderInfo.srvPacId}'}, '${preOrderInfo.itmStkId}', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성

        if('${preOrderInfo.cpntId}' != 0){
            $('#compType').removeClass("blind");
            fn_loadProductComponent('${preOrderInfo.itmStkId}');
        }

        $('#installDur').val('${preOrderInfo.instPriod}');
        $('#poNo').val('${preOrderInfo.custPoNo}');
        $('#refereNo').val('${preOrderInfo.sofNo}');

        $('#ordPromo').removeAttr("disabled");

        var month = '${preOrderInfo.month}';
        var year = '${preOrderInfo.year}';
        var date = year + month;

        console.log("date: "+date);
        //if('${preOrderInfo.month}' >= '07' && '${preOrderInfo.year}' == '2019') {
        if(date >= 201907) {
            doGetComboData('/sales/order/selectPromotionByAppTypeStockESales.do', {appTypeId:'${preOrderInfo.appTypeId}'
                ,stkId:'${preOrderInfo.itmStkId}'
                ,empChk:'${preOrderInfo.empChk}'
                ,promoCustType:vCustTypeId
                ,exTrade:'${preOrderInfo.exTrade}'
                ,srvPacId:'${preOrderInfo.srvPacId}'
                ,promoId:'${preOrderInfo.promoId}'
                ,isSrvPac:('${preOrderInfo.appTypeId}' == 66 ? 'Y' : '')
                ,voucherPromotion: voucherAppliedStatus
                ,custStatus: $('#hiddenCustStatusId').val()
                },'${preOrderInfo.promoId}', 'ordPromo', 'S', ''); //Common Code
        }
        else
        {
            doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:'${preOrderInfo.appTypeId}'
                ,stkId:'${preOrderInfo.itmStkId}'
                ,empChk:'${preOrderInfo.empChk}'
                ,promoCustType:vCustTypeId
                ,exTrade:'${preOrderInfo.exTrade}'
                ,srvPacId:'${preOrderInfo.srvPacId}'
                ,voucherPromotion: voucherAppliedStatus
                ,custStatus: $('#hiddenCustStatusId').val()
                }, '${preOrderInfo.promoId}', 'ordPromo', 'S', ''); //Common Code
        }


        $('#relatedNo').val('${preOrderInfo.relatedNo}');
        $('#txtOldOrderID').val('${preOrderInfo.salesOrdIdOld}');
        if('${preOrderInfo.isExtradePr}' == 1){
            $("#isReturnExtrade").prop("checked", true);
        }
        $('#ordRentalFees').val('${preOrderInfo.mthRentAmt}');
        $('#promoDiscPeriodTp').val('${preOrderInfo.promoDiscPeriodTp}');
        $('#promoDiscPeriod').val('${preOrderInfo.promoDiscPeriod}');
        $('#ordPrice').val('${preOrderInfo.totAmt}');
        $('#normalOrdPrice').val('${preOrderInfo.norAmt}');
        $('#normalOrdRentalFees').val('${preOrderInfo.norRntFee}');
        $('#ordRentalFees').val('${preOrderInfo.discRntFee}');
        $('#ordPv').val('${preOrderInfo.totPv}');
        $('#ordPvGST').val('${preOrderInfo.totPvGst}');
        $('#ordPriceId').val('${preOrderInfo.prcId}');

        $("input:radio[name='advPay']:radio[value='${preOrderInfo.advBill}']").prop("checked", true);

        if('${preOrderInfo.is3rdParty}' == '1') {
            $('#thrdParty').attr("checked", true);
            $('#sctThrdParty').removeClass("blind");
            fn_loadThirdParty('${preOrderInfo.rentPayCustId}', 2);
        }

        if('${preOrderInfo.rentPayModeId}' == '131') {
            $('#sctCrCard').removeClass("blind");
            fn_loadCreditCard2('${preOrderInfo.custCrcId}');
        }
        else if('${preOrderInfo.rentPayModeId}' == '132') {
            $('#sctDirectDebit').removeClass("blind");
            fn_loadBankAccount('${preOrderInfo.custAccId}');
        }

        if('${preOrderInfo.custBillId}' == '' || '${preOrderInfo.custBillId}' == '0') {

            $('#grpOpt1').prop("checked", true);

//            $('#sctBillMthd').removeClass("blind");
            $('#sctBillAddr').removeClass("blind");
//          $('#sctBillPrefer').removeClass("blind");

            $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());
          //$('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());

            if($('#hiddenTypeId').val() == '965') { //Company

                console.log("fn_setBillGrp 1 typeId : "+$('#hiddenTypeId').val());

                $('#sctBillPrefer').removeClass("blind");

                if('${preOrderInfo.custBillCustCareCntId}' != '' && '${preOrderInfo.custBillCustCareCntId}' != '0') {
                    fn_loadBillingPreference('${preOrderInfo.custBillCustCareCntId}');
                }

                $('#billMthdEstm').prop("checked", true);
                $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                $('#billMthdEmail2').removeAttr("disabled");
                $('#billMthdEmailTxt1').removeAttr("disabled").val("${preOrderInfo.custBillEmail}");
                $('#billMthdEmailTxt2').removeAttr("disabled").val("${preOrderInfo.custBillEmailAdd}");

                if(FormUtil.isNotEmpty("${preOrderInfo.custBillEmailAdd}")) {
                    $('#billMthdEmail2').prop("checked", true);
                }
            }
            else if($('#hiddenTypeId').val() == '964') { //Individual

                console.log("fn_setBillGrp 2 typeId : "+$('#hiddenTypeId').val());
                console.log("custCntcEmail : "+$('#custCntcEmail').val());
                console.log(FormUtil.isNotEmpty($('#custCntcEmail').val().trim()));

                if(FormUtil.isNotEmpty("${preOrderInfo.custBillEmail}")) {

                    $('#billMthdEstm').prop("checked", true);
                    $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                    $('#billMthdEmail2').removeAttr("disabled");
                    $('#billMthdEmailTxt1').removeAttr("disabled").val("${preOrderInfo.custBillEmail}");
                    $('#billMthdEmailTxt2').removeAttr("disabled").val('${preOrderInfo.custBillEmailAdd}');

                    if(FormUtil.isNotEmpty('${preOrderInfo.custBillEmailAdd}')) {
                        $('#billMthdEmail2').prop("checked", true);
                    }
                }

                $('#billMthdSms').prop("checked", true);
                $('#billMthdSms1').prop("checked", true).removeAttr("disabled").val('${preOrderInfo.custBillIsSms}');
                $('#billMthdSms2').removeAttr("disabled").val('${preOrderInfo.CustBillIsSms2}');

                if(FormUtil.isNotEmpty('${preOrderInfo.CustBillIsSms2}')) {
                    $('#billMthdSms2').prop("checked", true);
                }
            }
        }
        else {

            $('#grpOpt2').prop("checked", true);

            $('#sctBillSel').removeClass("blind");

            $('#billRem').prop("readonly", true).addClass("readonly");

            fn_loadBillingGroupById('${preOrderInfo.custBillCustId}', '${preOrderInfo.custBillId}');
        }
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
                $("#keyinBrnchId").val('${preOrderInfo.keyinBrnchId}'); //Posting Branch

//              if(!$("#gstChk").is('[disabled]')) {
/*
                    if(custInfo.gstChk == '1') {
                        $("#gstChk").val('1').prop("disabled", true);
                    }
                    else {
                        $("#gstChk").val('0').removeAttr("disabled");
                    }
*/
//              }
            }
        });
    }

    function fn_createCustomerPop() {
        Common.popupDiv("/sales/customer/customerRegistPop.do", {"callPrgm" : "PRE_ORD"}, null, true);
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
/*                 $("#custTelM").val(custCntcInfo.telM1);
                $("#custTelR").val(custCntcInfo.telR);
                $("#custTelO").val(custCntcInfo.telO);
                $("#custTelF").val(custCntcInfo.telf);
                $("#custExt").val(custCntcInfo.ext); */
            }
        });
    }

    function fn_loadSrvCntcPerson(custCareCntId) {
        console.log("fn_loadSrvCntcPerson START");

        Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {custCareCntId : custCareCntId}, function(srvCntcInfo) {

            if(srvCntcInfo != null) {

                console.log("성공.");
                console.log("srvCntcInfo:"+srvCntcInfo.custCareCntId);
                console.log("srvCntcInfo:"+srvCntcInfo.name);
                console.log("srvCntcInfo:"+srvCntcInfo.custInitial);
                console.log("srvCntcInfo:"+srvCntcInfo.email);

                //hiddenBPCareId
                $("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);
                $("#custCntcName").val(srvCntcInfo.name);
                $("#custCntcInitial").val(srvCntcInfo.custInitial);
                $("#custCntcEmail").val(srvCntcInfo.email);
                $("#custCntcTelM").val(srvCntcInfo.telM);
                $("#custCntcTelR").val(srvCntcInfo.telR);
                $("#custCntcTelO").val(srvCntcInfo.telO);
                $("#custCntcTelF").val(srvCntcInfo.telf);
                $("#custCntcExt").val(srvCntcInfo.ext);
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
                AUIGrid.resize(listGiftGridID, 980, 180);

                if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){
                    $('#memBtn').addClass("blind");
                    $('#salesmanCd').prop("readonly",true).addClass("readonly");;
                    //$('#salesmanCd').val("${SESSION_INFO.userName}");
                    //$('#salesmanCd').change();
                }

                //$('#appType').val("66");
                $('#appType').prop("disabled", true);
                $('#exTrade').prop("disabled", true);


                if($('#ordProudct').val() == null){
                       $('#appType').change();
                }

                $('[name="advPay"]').prop("disabled", true);
                //$('#advPayNo').prop("checked", true);   // for enable radio button
                $('#poNo').prop("disabled", true);

                break;
            case 'pay' :
                if($('#appType').val() == '66' && ('${preOrderInfo.stusId}' != 1 &&  '${preOrderInfo.stusId}' != 104 &&  '${preOrderInfo.stusId}' != 21)){
                    //$('#rentPayMode').val('131') //to show the correct info for rentPayMode
                    $('#rentPayMode').change();
                    $('#rentPayMode').prop("disabled", true);
                    $('#thrdParty').prop("disabled", true);
                }
                break;
            default :
                break;
        }
    }

    function fn_atchViewDown(fileGrpId, fileId) {
        var data = {
                atchFileGrpId : fileGrpId,
                atchFileId : fileId
        };
        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
            console.log(result)
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');

            if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
                console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            } else {
                console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            }
        });
    }

    function fn_loadAtchment(atchFileGrpId) {
        Common.ajax("Get", "/sales/order/selectAttachList.do", {atchFileGrpId :atchFileGrpId} , function(result) {
            console.log(result);
           if(result) {
                if(result.length > 0) {
                    $("#attachTd").html("");
                    for ( var i = 0 ; i < result.length ; i++ ) {
                        switch (result[i].fileKeySeq){
                        case '1':
                            sofFileId = result[i].atchFileId;
                            sofFileName = result[i].atchFileName;
                            $(".input_text[id='sofFileTxt']").val(sofFileName);
                            break;
                        case '2':
                            nricFileId = result[i].atchFileId;
                            nricFileName = result[i].atchFileName;
                            $(".input_text[id='nricFileTxt']").val(nricFileName);
                            break;
                        case '3':
                            payFileId = result[i].atchFileId;
                            payFileName = result[i].atchFileName;
                            $(".input_text[id='payFileTxt']").val(payFileName);
                            break;
                        case '4':
                            trFileId = result[i].atchFileId;
                            trFileName = result[i].atchFileName;
                            $(".input_text[id='trFileTxt']").val(trFileName);
                            break;
                        case '5':
                            otherFileId = result[i].atchFileId;
                            otherFileName = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt']").val(otherFileName);
                            break;
                        case '6':
                            otherFileId2 = result[i].atchFileId;
                            otherFileName2 = result[i].atchFileName;
                            $(".input_text[id='otherFileTxt2']").val(otherFileName2);
                            break;
                        case '7':
                            sofTncFileId = result[i].atchFileId;
                            sofTncFileName = result[i].atchFileName;
                            $(".input_text[id='sofTncFileTxt']").val(sofTncFileName);
                            break;
                        case '8':
                            msofFileId = result[i].atchFileId;
                            msofFileName = result[i].atchFileName;
                            $(".input_text[id='msofFileTxt']").val(msofFileName);
                            break;
                        case '9':
                            msofTncFileId = result[i].atchFileId;
                            msofTncFileName = result[i].atchFileName;
                            $(".input_text[id='msofTncFileTxt']").val(msofTncFileName);
                            break;
                         default:
                             Common.alert("no files");
                        }
                    }

                    // 파일 다운
                     if ('${preOrderInfo.stusId}' == '4' || '${preOrderInfo.stusId}' == '10'){
                         if(userType != 1 && userType != 2 && userType != 7){
                             $(".input_text").dblclick(function() {
                                 var oriFileName = $(this).val();
                                 var fileGrpId;
                                 var fileId;
                                 for(var i = 0; i < result.length; i++) {
                                     if(result[i].atchFileName == oriFileName) {
                                         fileGrpId = result[i].atchFileGrpId;
                                         fileId = result[i].atchFileId;
                                     }
                                 }
                                 if(fileId != null) fn_atchViewDown(fileGrpId, fileId);
                             });
                         }
                     }
                     else{
                         $(".input_text").dblclick(function() {
                             var oriFileName = $(this).val();
                             var fileGrpId;
                             var fileId;
                             for(var i = 0; i < result.length; i++) {
                                 if(result[i].atchFileName == oriFileName) {
                                     fileGrpId = result[i].atchFileGrpId;
                                     fileId = result[i].atchFileId;
                                 }
                             }
                             if(fileId != null) fn_atchViewDown(fileGrpId, fileId);
                         });
                     }

                }
            }
       });
    }

    function fn_removeFile(name){
        if(name == "PAY") {
             $("#payFile").val("");
             $(".input_text[name='PayFileTxt']").val("");
             $('#payFile').change();
        }else if(name == "TRF"){
            $("#trFile").val("");
            $(".input_text[name='trFileTxt']").val("");
            $('#trFile').change();
        }else if(name == "OTH"){
            $("#otherFile").val("");
            $(".input_text[name='otherFileTxt']").val("");
            $('#otherFile').change();
        }else if(name == "OTH2"){
            $("#otherFile2").val("");
            $(".input_text[name='otherFileTxt2']").val("");
            $('#otherFile2').change();
        }else if(name == "TNC"){
            $("#sofTncFile").val("");
            $(".input_text[name='sofTncFileTxt']").val("");
            $('#sofTncFile').change();
        }else if(name == "MSOF") {
            $("#msofFile").val("");
            $(".input_text[name='msofFileTxt']").val("");
            $('#msofFile').change();
        }else if(name == "MSOFTNC") {
            $("#msofTncFile").val("");
            $(".input_text[name='msofTncFileTxt']").val("");
            $('#msofTncFile').change();
        }
    }

    function fn_validFile() {
        var isValid = true, msg = "";

        if(sofFileId == null) {
            isValid = false;
            msg += "* Please upload copy of SOF<br>";
        }
        if(nricFileId == null) {
            isValid = false;
            msg += "* Please upload copy of NRIC<br>";
        }
        $.each(myFileCaches, function(i, j) {
            if(myFileCaches[i].file.checkFileValid == false){
                isValid = false;
               msg += myFileCaches[i].file.name + "<br>* File uploaded only allowed for picture format less than 2MB and 30 wordings<br>";
           }
       });

        if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_validRcdTms() {
        var isValid = true, msg = "";

        Common.ajaxSync("GET", "/sales/order/selRcdTms.do", $("#frmPreOrdReg").serialize(), function(result) {
            if(result.code == "99"){
                isValid = false;
                msg = result.message;
            }
        });

        if(!isValid) Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;

    }

    function displayVoucherSection(){
      if($('#voucherType option:selected').val() != null && $('#voucherType option:selected').val() != "" && $('#voucherType option:selected').val() != "0")
      {
          $('.voucherSection').show();
      }
      else{
          $('.voucherSection').hide();
            clearVoucherData();
      }
    }

    function applyVoucher() {
      var voucherCode = $('#voucherCode').val();
      var voucherEmail = $('#voucherEmail').val();
      var voucherType = $('#voucherType option:selected').val();

      if(voucherCode.length == 0 || voucherEmail.length ==0){
          clearVoucherData();
          Common.alert('Both voucher code and voucher email must be key in');
          return;
      }
      Common.ajax("GET", "/misc/voucher/voucherVerification.do", {platform: voucherType, voucherCode: voucherCode, custEmail: voucherEmail, isEKeyIn: true, preOrdId: "${preOrderInfo.preOrdId}"}, function(result) {
            if(result.code == "00") {
                voucherAppliedStatus = 1;
                $('#voucherMsg').text('Voucher Applied for ' + voucherCode);
                voucherAppliedCode = voucherCode;
                voucherAppliedEmail = voucherEmail;
                $('#voucherMsg').show();

                Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
                    if(result.length > 0){
                        voucherPromotionId = result;
                    }
                    else{
                        //reset everything
                        clearVoucherData();
                        Common.alert("No Promotion is being entitled for this voucher code");
                        return;
                    }
                });
            }
            else{
                clearVoucherData();
                Common.alert(result.message);
                return;
            }
      });
    }

    function voucherPromotionCheck(){
     if(voucherAppliedStatus == 1){
        var orderPromoId = [];
        var orderPromoIdToRemove = [];
        $("#ordPromo option").each(function()
        {
              orderPromoId.push($(this).val());
        });
        orderPromoIdToRemove = orderPromoId.filter(function(obj) {
            return !voucherPromotionId.some(function(obj2) {
                    return obj == obj2;
            });
        });

        if(orderPromoIdToRemove.length > 0){
            $('#ordPromo').val('');
            for(var i = 0; i < orderPromoIdToRemove.length; i++){
                if(orderPromoIdToRemove[i] == ""){
                }
                else{
                    $("#ordPromo option[value='" + orderPromoIdToRemove[i] +"']").remove();
                }
            }
        }
    }
    }

    function clearVoucherData(){
        $('#voucherCode').val('');
        $('#voucherEmail').val('');
        $('#voucherMsg').hide();
        $('#voucherMsg').text('');
        voucherAppliedStatus = 0;
        voucherAppliedCode = "";
        voucherAppliedEmail = "";
        voucherPromotionId = [];

        $('#ordProudct').val('');
        $('#ordPromo').val('');
        $('#ordPromo option').remove();
    }

    function applyCurrentUsedVoucher(){
        voucherAppliedStatus = 1;
        var voucherCode = $('#voucherCode').val();
        var voucherEmail = $('#voucherEmail').val();
        $('#voucherMsg').text('Voucher Applied for ' + voucherCode);
        voucherAppliedCode = voucherCode;
        voucherAppliedEmail = voucherEmail;
        $('#voucherMsg').show();
        displayVoucherSection();

        Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
            if(result.length > 0){
                voucherPromotionId = result;
                voucherPromotionCheck();
            }
            else{
                //reset everything
                clearVoucherData();
                Common.alert("No Promotion is being entitled for this voucher code");
                return;
            }
        });
    }

    function fn_checkPreOrderSalesPerson(memId,memCode) {
    	var isExist = false;

        Common.ajax("GET", "/sales/order/checkPreBookSalesPerson.do", {memId : memId, memCode : memCode}, function(memInfo) {
            if(memInfo == null) {
                  isExist = false;
                  Common.alert('<b>Your input member code : '+ memCode +' is not allowed for extrade pre-order.</b>');
                  $('#aTabOI').click();
             }else{
            	 isExist = true;
            	 fn_doSavePreOrder();
             }
            return isExist;
        });

        return isExist;
      }

      function fn_checkPreOrderConfigurationPerson(memId,memCode,salesOrdId,salesOrdNo) {
    	  var isExist = false;

              Common.ajax("GET", "/sales/order/checkPreBookConfigurationPerson.do", {memId : memId, memCode : memCode, salesOrdId : salesOrdId , salesOrdNo : salesOrdNo}, function(memInfo) {
                  if(memInfo == null) {
                      isExist = false;
                      Common.alert('<b>Your input member code : '+ memCode +' is not allowed for extrade pre-order.</b>');
                      $('#aTabOI').click();
                    }else{
                  	  //alert("[fn_checkPreOrderConfigurationPerson] line 1707 - checkPreBookSalesPerson.do ");
                  	  isExist = true;
                        fn_doSavePreOrder();
                    }
                  return isExist;
              });

        return isExist;
      }

     function checkSalesPerson(memCode,salesOrdId,salesOrdNo){
    	 if(memCode == "100116" || memCode == "100224" || memCode == "ASPLKW"){
             return fn_doSavePreOrder();
         }else{
        	 if($('#exTrade').val() == '1') {
            	 return fn_checkPreOrderSalesPerson(0,memCode);
           	}
//             if($('#exTrade').val() == '1' && $("#hiddenTypeId").val() == '964' && $('#relatedNo').val() == '' && $('#hiddenMonthExpired').val() != '1') {
//             	  return fn_checkPreOrderSalesPerson(0,memCode);
//             }else if ($('#exTrade').val() == '1' && $("#hiddenTypeId").val() == '964' && $('#relatedNo').val() != '' && $('#hiddenMonthExpired').val() != '1'){
//             	  return fn_checkPreOrderSalesPerson(0,memCode);
//             }else if($('#exTrade').val() == '1' && $("#hiddenTypeId").val() == '964' && $('#relatedNo').val() != '' && $('#hiddenMonthExpired').val() == '1'){
//             	  return fn_checkPreOrderConfigurationPerson(0,memCode,salesOrdId,salesOrdNo);
//             }
			else{
            	  return fn_doSavePreOrder();
            }
         }
    }

   function checkExtradePreBookEligible(custId,salesOrdIdOld){
	   Common.ajax("GET", "/sales/order/preBooking/selectPreBookOrderEligibleCheck.do", {custId : custId , salesOrdIdOld : salesOrdIdOld}, function(result) {
		   if(result == null){
			   $('#hiddenPreBook').val('0');
			   $('#hiddenMonthExpired').val('0');
			   fn_loadPreOrderInfo('${preOrderInfo.custId}', null);
			   }else{
			   $('#hiddenPreBook').val('1');
			   $('#hiddenMonthExpired').val(result.monthExpired);
			   fn_loadPreOrderInfo('${preOrderInfo.custId}', null);
			   }
	   });
   }

   function checkOldOrderServiceExpiryMonth(custId,salesOrdIdOld){
	   Common.ajax("GET", "/sales/order/checkOldOrderServiceExpiryMonth.do", {custId : custId , salesOrdIdOld : salesOrdIdOld}, function(result) {
		    if(result == null){
			   $('#hiddenMonthExpired').val('0');
			   fn_loadPreOrderInfo('${preOrderInfo.custId}', null);
			}else{
			   $('#hiddenMonthExpired').val(result.monthExpired);
			   fn_loadPreOrderInfo('${preOrderInfo.custId}', null);
		    }
	   });
   }

   function fn_checkPromotionExtradeAvail(){
		  var appTypeId = $('#appType option:selected').val();
	      var oldOrderNo = $('#relatedNo').val();
	      var promoId = $('#ordPromo option:selected').val();
	      var extradeId = $('#exTrade option:selected').val();
		  console.log("OLDORDERNO"+oldOrderNo);
		  console.log("PROMOID"+promoId);

		  if(FormUtil.isNotEmpty(promoId) && FormUtil.isNotEmpty(oldOrderNo)) {
			  Common.ajax("GET", "/sales/order/checkExtradeWithPromoOrder.do",
					  {appTypeId : appTypeId, oldOrderNo : oldOrderNo, promoId : promoId, extradeId : extradeId}, function(result) {
			        if(result == null) {
			         	  $('#ordPromo').val('');
			         	  $('#relatedNo').val('');
			         	  Common.alert("No extrade with promo order found");
			        }
			        else{
			        	if(result.code == "99"){
				         	  $('#ordPromo').val('');
				         	  //$('#relatedNo').val('');
				         	  Common.alert(result.message);
			        	}
			        }
			  });
		  }
	  }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eKey-in</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPreOrdClose" onClick="javascript:fn_closePreOrdModPop2();" href="#">CLOSE | TUTUP</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue blind"><a id="btnConfirm" href="#">Confirm</a></p></li>
    <li><p class="btn_blue blind"><a href="#">Clear</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
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
    <td><input id="nric2" name="nric2" type="text" value="" title="" placeholder="" class="w100p readonly" readonly /></td>
    <td><input id="nric" name="nric" type="hidden" value="" title="" placeholder="" class="w100p readonly" readonly /></td>
    <th scope="row">SOF No</th>
    <td><input id="sofNo" name="sofNo" type="text" value="${preOrderInfo.sofNo}" title="" placeholder="" class="w100p readonly" readonly /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<!------------------------------------------------------------------------------
    Pre-Order Regist Content START
------------------------------------------------------------------------------->
<section id="scPreOrdArea" class="">

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="aTabCS" class="on">Customer</a></li>
    <li><a href="aTabOI" onClick="javascript:chgTab('ord');">Order Info</a></li>
    <li><a href="aTabBD" onClick="javascript:chgTab('pay');">Payment Info</a></li>
    <li><a href="aTabFL" >Attachment</a></li>
    <li><a href="aTabFR" >Failed Remark</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="frmPreOrdReg" name="frmPreOrdReg" action="#" method="post">
    <input id="hiddenPreOrdId" name="preOrdId" type="hidden" value="${preOrderInfo.preOrdId}" />
    <input id="hiddenCustId" name="custId" type="hidden"/>
    <input id="hiddenTypeId" name="typeId" type="hidden"/>
    <input id="hiddenCustCntcId" name="custCntcId" type="hidden" />
    <input id="hiddenCustAddId" name="custAddId" type="hidden" />
    <input id="hiddenRcdTms" name="rcdTms" type="hidden" value="${preOrderInfo.updDt}" />

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
    <th scope="row">Passport expiry date | Passport tarikh luput(foreigner)</th>
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
    <th scope="row">Receiving Marketing Message</th>
    <td>
        <div style="display:inline-block;width:100%;">
            <div style="display:inline-block;">
            <input id="marketMessageYes" type="radio" value="1" name="marketingMessageSelection"/><label for="marketMessageYes">Yes</label>
            </div>
            <div style="display:inline-block;">
            <input  id="marketMessageNo" type="radio" value="0" name="marketingMessageSelection"/><label for="marketMessageNo">No</label>
            </div>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Customer Status</th>
    <td><input id="custStatus" name="custStatus" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<input id="hiddenCustStatusId" name="hiddenCustStatusId" type="hidden" />

<!-- <tr>
    <th scope="row">Tel (Mobile)<span class="must">*</span></th>
    <td><input id="custTelM" name="custTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Residence)<span class="must">*</span></th>
    <td><input id="custTelR" name="custTelR" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
   <th scope="row">Tel (Fax)<span class="must">*</span></th>
    <td><input id="custTelF" name="custTelF" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Office)<span class="must">*</span></th>
    <td><input id="custTelO" name="custTelO" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Ext No.</th>
    <td><input id="custExt" name="custExt" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr> -->
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
</colgroup>
<tbody>
<tr>
    <!-- <th scope="row">Initial<span class="must">*</span></th>
    <td><input id="custCntcInitial" name="custCntcInitial" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly/></td> -->
    <th scope="row">Second/Service contact person name</th>
    <td><input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)<span class="must">*</span></th>
    <td><input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
    </tr>
<tr>
    <th scope="row">Tel (Residence)<span class="must">*</span></th>
    <td><input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Office)<span class="must">*</span></th>
    <td><input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)<span class="must">*</span></th>
    <td><input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Ext No.(1)</th>
    <td><input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
</tr>
<tr>
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
    <li><p class="btn_grid"><a id="btnSelInstAddr" href="#">Select Another Address</a></p></li>
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
    <td colspan="3"><input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Address Line 2<span class="must">*</span></th>
    <td colspan="3"><input id="instStreet" name="instStreet" type="text" title="" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Area | Daerah<span class="must">*</span></th>
    <td colspan="3"><input id="instArea" name="instArea" type="text" title="" placeholder="eg. TAMAN RIMBA" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">City | Bandar<span class="must">*</span></th>
    <td colspan="3"><input id="instCity" name="instCity" type="text" title="" placeholder="eg. KOTA KINABALU" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">PostCode | Poskod<span class="must">*</span></th>
    <td colspan="3"><input id="instPostCode" name="instPostCode" type="text" title="" placeholder="eg. 88450" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">State | Negeri<span class="must">*</span></th>
    <td colspan="3"><input id="instState" name="instState" type="text" title="" placeholder="eg. SABAH" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Country | Negara<span class="must">*</span></th>
    <td colspan="3"><input id="instCountry" name="instCountry" type="text" title="" placeholder="eg. MALAYSIA" class="w100p readonly" readonly/></td>
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
    <th scope="row">Posting Branch<span class="must">*</span></th>
    <td colspan="3"><select id="keyinBrnchId" name="keyinBrnchId" class="w100p" disabled></select></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date<span class="must">*</span></th>
    <td colspan="3"><input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Install Date (dd/MM/yyyy)" class="j_date w100p" value="${preOrderInfo.preDt}"  disabled/></td>
</tr>
<tr>
    <th scope="row">Prefer Install Time<span class="must">*</span></th>
    <td colspan="3">
    <div class="time_picker"><!-- time_picker start -->
    <input id="prefInstTm" name="prefInstTm" type="text" title="" placeholder="Prefer Install Time (hh:mi tt)" class="time_date w100p" value="11:00 AM" value="${preOrderInfo.preTm}" disabled/>
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
<!--    <col style="width:220px" />
    <col style="width:*" /> -->
</colgroup>
<tbody>
<tr>
    <th scope="row">Ex-Trade/Related No</th>
    <td><p><select id="exTrade" name="exTrade" class="w100p"></select></p>
        <a id="btnRltdNoEKeyIn" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <p><input id="relatedNo" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly /></p>
        <a><input id="isReturnExtrade" name="isReturnExtrade" type="checkbox" disabled/> Return ex-trade product</a>
        <input id="hiddenMonthExpired" name="hiddenMonthExpired" type="hidden" />
        <input id="hiddenPreBook" name="hiddenPreBook" type="hidden" />
        </td>
</tr>
<tr>
    <th scope="row">Voucher Type<span class="must">*</span></th>
    <td>
        <p> <select id="voucherType" name="voucherType" onchange="displayVoucherSection()" class="w100p"></select></p>
        <p class="voucherSection"><input id="voucherCode" name="voucherCode" type="text" title="Voucher Code" placeholder="Voucher Code" class="w100p"/></p>
        <p class="voucherSection"><input id="voucherEmail" name="voucherEmail" type="text" title="Voucher Email" placeholder="Voucher Email" class="w100p"/></p>
        <p style="width: 70px;" class="voucherSection btn_grid"><a id="btnVoucherApply" href="#" onclick="javascript:applyVoucher()">Apply</a></p>
        <p style="display:none; color:red;font-size:10px;" id="voucherMsg"></p>
    </td>
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
    <td>
        <select id="ordProudct" name="ordProudct" class="w50p" disabled></select>
        <select id="compType" name="compType" class="w50p blind" onchange="fn_reloadPromo()"></select>
    </td>
</tr>
<tr>
    <th scope="row">Promotion | Promosi<span class="must">*</span></th>
    <td><select id="ordPromo" name="ordPromo" class="w50p" disabled></select></td>
    <input id="txtOldOrderID" name="txtOldOrderID" type="hidden" />
</tr>
<tr>
    <th scope="row">Installment Duration<span class="must">*</span></th>
    <td><input id="installDur" name="installDur" type="text" title="" placeholder="Installment Duration (1-36)" class="w100p readonly" readonly/></td>
</tr>
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
        <p><input id="salesmanNm" name="salesmanNm" type="text" class="w100p readonly" title="" placeholder="Salesman Name" disabled/></p>
        </td>
</tr>
<tr>
    <th scope="row">Special Instruction<span class="must">*</span></th>
    <td><textarea id="speclInstct" name="speclInstct" cols="20" rows="5"></textarea></td>
</tr>
<tr style="display:none;">
    <th scope="row">PV<span class="must">*</span></th>
    <td><input id="ordPv"    name="ordPv"    type="text" title="" placeholder="Point Value (PV)" class="w100p readonly" readonly />
        <input id="ordPvGST" name="ordPvGST" type="hidden" /></td>
    <th scope="row">Discount Type /  Period (month)</th>
    <td><p><select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p" disabled></select></p>
        <p><input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder="" style="width:42px;" class="readonly" readonly/></p></td>
</tr>
<tr style="display:none;">
    <th scope="row">SST Type<span class="must">*</span></th>
    <td><select id="corpCustType" name="corpCustType" class="w50p" disabled></select>
</tr>
<tr style="display:none;">
    <th scope="row">Agreement Type<span class="must">*</span></th>
    <td><select id="agreementType" name="agreementType" class="w50p" disabled></select>
</tr>
</tbody>
</table><!-- table end -->

<!-- <aside class="title_line">title_line start
<h3>Free Gift Information</h3>
</aside>title_line end

<article class="grid_wrap">grid_wrap start
<div id="pop_list_gift_grid_wrap" style="width:100%; height:80px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
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
<h3>Credit Card</h3>
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
<table class="type1" style="display:none"><!-- table start -->
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

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
    <li><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
</ul>

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
        <input id="hiddenBillGrpId" name="billGrpId" type="hidden" value="${preOrderInfo.custBillId}"/></td>
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

<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>Attachment area</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:350px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Sales Order Form (SOF)<span class="must">*</span></th>
    <td>
        <div class='auto_file2 auto_file3'>
            <input type='file' title='file add'  id='sofFile' accept='image/jpg, image/jpeg, image/png, application/pdf'/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='sofFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Sales Order Form's T&C (SOF T&C)</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="sofTncFile" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='sofTncFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">NRIC & Bank Card<span class="must">*</span></th>
    <td>
        <div class='auto_file2 auto_file3'>
            <input type='file' title='file add' id='nricFile' accept='image/jpg, image/jpeg, image/png, application/pdf'/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='nricFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Payment document</th>
    <td id="tdPayFile">
        <div class='auto_file2 auto_file3'>
                <input type='file' title='file add' id='payFile' accept='image/jpg, image/jpeg, image/png, application/pdf'/>
                <label>
                    <input type='text' class='input_text' readonly='readonly' id='payFileTxt' name=''/>
                    <span class='label_text'><a href='#'>Upload</a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("PAY")'>Remove</a></span>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Coway temporary receipt (TR)</th>
    <td id="tdTrFile">
        <div class='auto_file2 auto_file3'>
                <input type='file' title='file add' id='trFile' accept='image/jpg, image/jpeg, image/png, application/pdf'/>
                <label>
                    <input type='text' class='input_text' readonly='readonly' id='trFileTxt' name=''/>
                    <span class='label_text'><a href='#'>Upload</a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("TRF")'>Remove</a></span>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Declaration letter/Others form</th>
    <td id="tdOtherFile">
        <div class='auto_file2 auto_file3'>
                <input type='file' title='file add' id='otherFile' accept='image/jpg, image/jpeg, image/png, application/pdf'/>
                <label>
                    <input type='text' class='input_text' readonly='readonly' id='otherFileTxt' name=''/>
                    <span class='label_text'><a href='#'>Upload</a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("OTH")'>Remove</a></span>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Declaration letter/Others form 2</th>
    <td id="tdOtherFile2">
        <div class='auto_file2 auto_file3'>
                <input type='file' title='file add' id='otherFile2' accept='image/jpg, image/jpeg, image/png, application/pdf'/>
                <label>
                    <input type='text' class='input_text' readonly='readonly' id='otherFileTxt2' name=''/>
                    <span class='label_text'><a href='#'>Upload</a></span>
                </label>
                <span class='label_text'><a href='#' onclick='fn_removeFile("OTH2")'>Remove</a></span>
        </div>
    </td>
</tr>

<tr>
    <th scope="row">Mattress Sales Order Form (MSOF)</th>
    <td>
        <div class='auto_file2 auto_file3'>
            <input type='file' title='file add'  id='msofFile' accept='image/jpg, image/jpeg, image/png, application/pdf'/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='msofFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
            <span class='label_text'><a href='#' onclick='fn_removeFile("MSOF")'>Remove</a></span>
        </div>
    </td>
</tr>

<tr>
    <th scope="row">Mattress Sales Order Form's T&C (MSOF T&C)</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="msofTncFile" accept="image/jpg, image/jpeg, image/png, application/pdf"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='msofTncFileTxt'/>
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
            <span class='label_text'><a href='#' onclick='fn_removeFile("MSOFTNC")'>Remove</a></span>
        </div>
    </td>
</tr>

<tr>
    <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG, PDF) less than 2 MB.
    <br>
    File rename wording no more than 30 alphabet (including spacing, symbol).</span></td>
</tr>
</tbody>
</table>

</article><!-- tap_area end -->


<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_FailedRemark_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

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
