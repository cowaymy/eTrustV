<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var stckGridID, giftGridID;

    $(document).ready(function(){

        //AUIGrid 그리드를 생성합니다.
        createAUIGridStk();

        doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', '', 'promoAppTypeId',    'S', 'fn_delApptype'); //Promo Application
        doGetCombo('/common/selectCodeList.do', '76',  '', 'promoTypeId',       'S'); //Promo Type
        doGetCombo('/common/selectCodeList.do', '8',   '', 'promoCustType',     'S', 'fn_addOption'); //Customer Type
        doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp', 'S'); //Discount period
        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, '0', 'exTrade',              'S'); //EX_Trade
        doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, '0', 'empChk',               'S'); //EMP_CHK
        doGetComboData('/common/selectCodeList.do', {groupCode :'323'}, '', 'promoDiscType',        'S'); //Discount Type
      //doGetComboData('/common/selectCodeList.do', {groupCode :'321'}, '', 'promoFreesvcPeriodTp', 'S'); //Free SVC Period

    });

    function fn_addOption() {
        $("#promoCustType option:eq(0)").replaceWith("<option value='0'>ALL</option>");
        $("#promoCustType").val('0');
    }

    function createAUIGridStk() {

        //AUIGrid 칼럼 설정
        var columnLayout1 = [
            { headerText : "<spring:message code='sales.prodCd'/>", dataField  : "itmcd",   editable : false,   width : 100 }
          , { headerText : "<spring:message code='sales.prodNm'/>", dataField  : "itmname", editable : false                  }
          , { headerText : "<spring:message code='sales.normal'/>"
            , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "amt",         editable : false, width : 100  }
                          , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "prcRpf",      editable : false, width : 100  }
                          , { headerText : "<spring:message code='sales.pv'/>",        dataField : "prcPv",       editable : false, width : 100  }]}
          , { headerText : "<spring:message code='sales.title.Promotion'/>"
            , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "promoAmt",    editable : false, width : 100  }
                          , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "promoPrcRpf", editable : false, width : 100  }
                          , { headerText : "<spring:message code='sales.pv'/>",        dataField : "promoItmPv",  editable : true,  width : 100  }]}
          , { headerText : "promoItmPvGst", dataField   : "promoItmPvGst",  visible  : false,     width : 80  }
          , { headerText : "itmid",         dataField   : "promoItmStkId",  visible  : false,     width : 80  }
          ];

        //AUIGrid 칼럼 설정
        var columnLayout2 = [
            { headerText : "<spring:message code='sales.prodCd'/>", dataField : "itmcd",              editable : false, width : 100 }
          , { headerText : "<spring:message code='sales.prodNm'/>", dataField : "itmname",            editable : false                }
          , { headerText : "<spring:message code='sales.prdQty'/>", dataField : "promoFreeGiftQty",   editable : true,  width : 120 }
          , { headerText : "itmid",                                 dataField : "promoFreeGiftStkId", visible  : false }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : true,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            showRowCheckColumn  : true,
            softRemoveRowMode   : false,
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        stckGridID = GridCommon.createAUIGrid("pop_stck_grid_wrap", columnLayout1, "", gridPros);
        giftGridID = GridCommon.createAUIGrid("pop_gift_grid_wrap", columnLayout2, "", gridPros);
    }

    function fn_doSavePromtion() {
        console.log('!@# fn_doSavePromtion START');
        console.log($('#promoCode').val().trim());

        $('#exTrade').removeAttr("disabled");

        var promotionVO = {

            salesPromoMVO : {
                promoCode               : $('#promoCode').val().trim(),
                promoDesc               : $('#promoDesc').val().trim(),
                promoTypeId             : $('#promoTypeId').val(),
                promoAppTypeId          : $('#promoAppTypeId').val(),
                promoSrvMemPacId        : $('#promoSrvMemPacId').val(),
                promoDtFrom             : $('#promoDtFrom').val().trim(),
                promoDtEnd              : $('#promoDtEnd').val().trim(),
                promoPrcPrcnt           : $('#promoDiscValue').val().trim(),
                promoCustType           : $('#promoCustType').val().trim(),
                promoDiscType           : $('#promoDiscType').val(),
                promoRpfDiscAmt         : $('#promoRpfDiscAmt').val(),
                promoDiscPeriodTp       : $('#promoDiscPeriodTp').val(),
                promoDiscPeriod         : $('#promoDiscPeriod').val().trim(),
              //promoFreesvcPeriodTp    : $('#promoFreesvcPeriodTp').val(),
                promoAddDiscPrc         : $('#promoAddDiscPrc').val().trim(),
                promoAddDiscPv          : $('#promoAddDiscPv').val().trim(),
                exTrade                 : $('#exTrade').val(),
                empChk                  : $('#empChk').val(),
                megaDeal                : $('input:radio[name="megaDeal"]:checked').val()
            },
            salesPromoDGridDataSetList  : GridCommon.getEditData(stckGridID),
            freeGiftGridDataSetList     : GridCommon.getEditData(giftGridID)
        };

        Common.ajax("POST", "/sales/promotion/registerPromotion.do", promotionVO, function(result) {

            Common.alert("<spring:message code='sales.promo.msg5'/>" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");

            fn_selectPromoListAjax();

            $('#btnClosePop').click();

        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

//              Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save promotion.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert("<spring:message code='sal.alert.title.saveFail'/>" + DEFAULT_DELIMITER + "<b><spring:message code='sales.fail.msg'/></b>");
            }
            catch (e) {
                console.log(e);
//              alert("Saving data prepration failed.");
            }

//          alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

    function fn_calcDiscountPrice() {

        var orgPrcVal = 0;
        var dscPrcVal = FormUtil.isEmpty($('#promoDiscValue').val())  ? 0 : $('#promoDiscValue').val().trim();
        var addPrcVal = FormUtil.isEmpty($('#promoAddDiscPrc').val()) ? 0 : $('#promoAddDiscPrc').val().trim();
        var newPrcVal = 0;

        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {

            orgPrcVal = AUIGrid.getCellValue(stckGridID, i, "amt");

            if($('#promoDiscType').val() == '0') {//%
                newPrcVal = orgPrcVal - (orgPrcVal * (dscPrcVal / 100)) - addPrcVal;
            }
            else {
                newPrcVal = orgPrcVal - dscPrcVal - addPrcVal;
            }

            //newPrcVal = Math.floor(newPrcVal);
            if($('#promoSrvMemPacId').val() == '4' ){
            	newPrcVal = newPrcVal;
            }
            else{
            	newPrcVal = Math.floor(newPrcVal);
            }


            if(newPrcVal < 0) newPrcVal = 0;
            if($('#promoAppTypeId').val() == '2285' ) newPrcVal = (Math.trunc(newPrcVal / 10)) * 10  ; // if App Tye = Outright , trunc amount 0 -- edited by TPY 01/06/2018

            AUIGrid.setCellValue(stckGridID, i, "promoAmt", newPrcVal);
        }
    }

    function fn_calcDiscountRPF() {

        var orgRpfVal = 0;
        var dscRpfVal = FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim();
        var newRpfVal = 0;

        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {

            orgRpfVal = AUIGrid.getCellValue(stckGridID, i, "prcRpf");

            if($('#promoAppTypeId').val() != 2284 || $('#exTrade').val() == '1') {
                newRpfVal = 0;
            }
            else {
                newRpfVal = orgRpfVal - dscRpfVal;
            }

            if(newRpfVal < 0) newRpfVal = 0;

            AUIGrid.setCellValue(stckGridID, i, "promoPrcRpf", newRpfVal);
        }
    }

    function fn_calcDiscountPV() {
        console.log('fn_calcDiscountPV() START');
        var orgPvVal = 0;
        var dscPvVal = 0;
        var addPvVal = FormUtil.isEmpty($('#promoAddDiscPv').val()) ? 0 : $('#promoAddDiscPv').val().trim();
        var newPvVal = 0;
        var gstPvVal = 0;

        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {

            orgPvVal = AUIGrid.getCellValue(stckGridID, i, "prcPv");
/*
            if($('#exTrade').val() == '1' && $('#promoAppTypeId').val() == '2284') {
                orgPvVal = orgPvVal * (70/100);
//              dscPvVal = AUIGrid.getCellValue(stckGridID, i, "prcRpf") - (FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim());
                dscPvVal = FormUtil.isEmpty($('#promoRpfDiscAmt').val());
            }
            else if($('#exTrade').val() == '1' && ($('#promoAppTypeId').val() == '2285' || $('#promoAppTypeId').val() == '2287')) {
                orgPvVal = orgPvVal * (70/100);
                dscPvVal = AUIGrid.getCellValue(stckGridID, i, "amt") - AUIGrid.getCellValue(stckGridID, i, "promoAmt");
//              dscPvVal = AUIGrid.getCellValue(stckGridID, i, "promoAmt");
            }
            else if($('#exTrade').val() == '0' && ($('#promoAppTypeId').val() == '2284' || $('#promoAppTypeId').val() == '2285' || $('#promoAppTypeId').val() == '2287')) {
                dscPvVal = AUIGrid.getCellValue(stckGridID, i, "amt") - AUIGrid.getCellValue(stckGridID, i, "promoAmt");
//              dscPvVal = AUIGrid.getCellValue(stckGridID, i, "promoAmt");
            }
*/
            if($('#exTrade').val() == '1') {
                orgPvVal = orgPvVal * (70/100);
            }

            if($('#promoAppTypeId').val() == '2284') {
                dscPvVal = FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim();
            }
            else if($('#promoAppTypeId').val() == '2285' || $('#promoAppTypeId').val() == '2287'){
                dscPvVal = AUIGrid.getCellValue(stckGridID, i, "amt") - AUIGrid.getCellValue(stckGridID, i, "promoAmt");
            }

            newPvVal = fn_calcPvVal(orgPvVal - dscPvVal - addPvVal);
            gstPvVal = fn_calcPvVal(orgPvVal - Math.floor(dscPvVal*(1/1.06)) - addPvVal);

            console.log('dscPvVal   :'+dscPvVal);
            console.log('dscPvValGST:'+Math.floor(dscPvVal*(1/1.06)));

            if(newPvVal < 0) newPvVal = 0;
            if(gstPvVal < 0) gstPvVal = 0;

            AUIGrid.setCellValue(stckGridID, i, "promoItmPv", newPvVal);
            AUIGrid.setCellValue(stckGridID, i, "promoItmPvGst", gstPvVal);
        }
    }

    function fn_getPrdPriceInfo() {

        var promotionVO = {
            salesPromoMVO : {
                promoAppTypeId         : $('#promoAppTypeId').val(),
                promoSrvMemPacId       : $('#promoSrvMemPacId').val()
            },
            salesPromoDGridDataSetList : GridCommon.getGridData(stckGridID)
        };

        Common.ajax("POST", "/sales/promotion/selectPriceInfo.do", promotionVO, function(result) {

            var arrGridData = AUIGrid.getGridData(stckGridID);

            for(var i = 0; i < result.length; i++) {
                for(var j = 0; j < AUIGrid.getRowCount(stckGridID) ; j++) {
                    var stkId = AUIGrid.getCellValue(stckGridID, j, "promoItmStkId");
                    if(stkId == result[i].promoItmStkId) {
                        AUIGrid.setCellValue(stckGridID, j, "amt",    result[i].amt);
                        AUIGrid.setCellValue(stckGridID, j, "prcRpf", result[i].prcRpf);
                        AUIGrid.setCellValue(stckGridID, j, "prcPv",  result[i].prcPv);
                    }
                }
            }

            fn_calcDiscountPrice();

            fn_calcDiscountRPF();

            fn_calcDiscountPV();
        });
    }

    $(function(){
        $('#btnProductAdd').click(function() {
            var isValid = true, msg = "";

            if(FormUtil.isEmpty($('#promoAppTypeId').val())) {
                isValid = false;
                msg += "<spring:message code='sales.promo.msg6'/><br />";
            }
            if(!$('#promoSrvMemPacId').is(":disabled") && FormUtil.isEmpty($('#promoSrvMemPacId').val())) {
                isValid = false;
                msg += "<spring:message code='sales.promo.msg7'/><br />";
            }

            if(!isValid) {
                Common.alert("<spring:message code='sales.promo.msg8'/>" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
                return false;
            }

            Common.popupDiv("/sales/promotion/promotionProductPop.do", {gubun : "stocklist", promoAppTypeId : $('#promoAppTypeId').val(), srvPacId : $('#promoSrvMemPacId').val()});
        });
        $('#btnProductDel').click(function() {
            fn_getPrdPriceInfo();
        });
        $('#btnFreeGiftAdd').click(function() {
            Common.popupDiv("/sales/promotion/promotionProductPop.do", {gubun : "item"});
        });
        $('#promoAppTypeId').change(function() {
            fn_chgPromoDetail();

            doGetComboCodeId('/sales/promotion/selectMembershipPkg.do', {promoAppTypeId : $('#promoAppTypeId').val()}, '', 'promoSrvMemPacId', 'S'); //Common Code
        });
        $('#promoTypeId').change(function() {
            fn_chgPromoDetail();
        });
        $('#promoDiscPeriodTp').change(function() {
            if($('#promoDiscPeriodTp').val() == '2293') {
                $('#promoDiscPeriod').val('').prop("disabled", true);
            }
            else {
                $('#promoDiscPeriod').removeAttr("disabled");
            }
        });
        $('#promoCustType').change(function() {
            fn_chgPromoDetail();
        });
        $('#promoDiscType').change(function() {
            if($('#promoDiscType').val() == '') {
                $('#promoDiscValue').val('').prop("disabled", true);
            }
            else {
                $('#promoDiscValue').val('').removeAttr("disabled");
            }

            fn_calcDiscountPrice();
            fn_calcDiscountRPF();
            fn_calcDiscountPV();
        });
        $('#promoDiscValue').change(function() {
            fn_calcDiscountPrice();
            fn_calcDiscountRPF();
            fn_calcDiscountPV();
        });
        $('#promoAddDiscPrc').change(function() {
            fn_calcDiscountPrice();
            fn_calcDiscountRPF();
            fn_calcDiscountPV();
        });
        $('#promoRpfDiscAmt').change(function() {
            fn_calcDiscountPrice();
            fn_calcDiscountRPF();
            fn_calcDiscountPV();
        });
        $('#promoAddDiscPv').change(function() {
            fn_calcDiscountPrice();
            fn_calcDiscountRPF();
            fn_calcDiscountPV();
        });
        $('#exTrade').change(function() {
            if($('#exTrade').val() == '1') {
                $('#promoRpfDiscAmt').val('200').prop("readonly", true).addClass("readonly");
            }
            else if($('#exTrade').val() == '0') {
                $('#promoRpfDiscAmt').val('').removeAttr("readonly").removeClass("readonly");
            }

            fn_calcDiscountPrice();
            fn_calcDiscountRPF();
            fn_calcDiscountPV();
        });
        $('#btnPromoSave').click(function() {

            if(!fn_validPromotion()) {
                return;
            }

            fn_doSavePromtion();
        });
         $('#btnProductDel').click(function() {
            AUIGrid.removeCheckedRows(stckGridID);
        });
         $('#btnFreeGiftDel').click(function() {
            AUIGrid.removeCheckedRows(giftGridID);
        });
    });

    function fn_validPromotion() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#promoAppTypeId').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg9'/><br />";
        }
        if(FormUtil.isEmpty($('#promoTypeId').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg10'/><br />";
        }
        if(FormUtil.isEmpty($('#promoDtFrom').val()) || FormUtil.isEmpty($('#promoDtEnd').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg11'/><br />";
        }
/*
        if(FormUtil.checkReqValue($('#promoCode'))) {
            isValid = false;
            msg += "* Please key in the promotion code.<br />";
        }
*/
//      if(FormUtil.checkReqValue($('#promoCustType'))) {
/*
        if($("#promoCustType option:selected").index() <=0) {
            isValid = false;
            msg += "* Please select the customer type.<br />";
        }
*/
        if(!$('#exTrade').is(":disabled") && FormUtil.isEmpty($('#exTrade').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg12'/><br />";
        }
        if(!$('#empChk').is(":disabled") && FormUtil.isEmpty($('#empChk').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg13'/><br />";
        }
        if(!$('#promoDiscValue').is(":disabled") && FormUtil.isEmpty($('#promoDiscValue').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg14'/><br />";
        }
        if(!$('#promoRpfDiscAmt').is(":disabled") && FormUtil.isEmpty($('#promoRpfDiscAmt').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg15'/><br />";
        }
        if(!$('#promoDiscPeriod').is(":disabled") && FormUtil.isEmpty($('#promoDiscPeriod').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg16'/><br />";
        }
/*
        if(!$('#promoFreesvcPeriodTp').is(":disabled") && FormUtil.checkReqValue($('#promoFreesvcPeriodTp'))) {
            isValid = false;
            msg += "* Please select the free svc period.<br />";
        }
*/
        if(!$('#promoSrvMemPacId').is(":disabled") && FormUtil.isEmpty($('#promoSrvMemPacId').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg17'/><br />";
        }

        if(!isValid) Common.alert("<spring:message code='sales.promo.msg18'/>" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function fn_addItems(data, gubun){

        var rowList = [];
        var vGrid = gubun == "stocklist" ? stckGridID : giftGridID;

        var lastPos = AUIGrid.getRowCount(stckGridID);
        var aIdx = 0;
        var isExist;

        for (var i = 0 ; i < data.length ; i++){

            isExist = false;

            if(gubun == "stocklist") {

                for(var j = 0; j < AUIGrid.getRowCount(stckGridID) ; j++) {
                    if(data[i].item.itemid == AUIGrid.getCellValue(stckGridID, j, "promoItmStkId")) {
                        isExist = true;
                        break;
                    }
                }

                if(!isExist) {
                    rowList[aIdx] = {
                        promoItmStkId      : data[i].item.itemid,
                        itmcd              : data[i].item.itemcode,
                        itmname            : data[i].item.itemname,
                        amt                : 0,
                        prcRpf             : 0,
                        prcPv              : 0
                    }
                    aIdx++;
                }
            } else {

                for(var k = 0; k < AUIGrid.getRowCount(giftGridID) ; k++) {
                    if(data[i].item.itemid == AUIGrid.getCellValue(giftGridID, k, "promoFreeGiftStkId")) {
                        isExist = true;
                        break;
                    }
                }

                if(!isExist) {
                    rowList[aIdx] = {
                        promoFreeGiftStkId : data[i].item.itemid,
                        itmcd              : data[i].item.itemcode,
                        itmname            : data[i].item.itemname,
                        promoFreeGiftQty   : 1
                    }
                    aIdx++;
                }
            }
        }

        AUIGrid.addRow(vGrid, rowList, lastPos);

        fn_getPrdPriceInfo();
    }

    //TODO Outlight Plus(2287) 선택시 빠져있음
    function fn_chgPromoDetail() {
        var promoAppVal = $('#promoAppTypeId').val();
        var promoTypVal = $('#promoTypeId').val();
        var promoCustVal = $('#promoCustType').val();

        //Promo Application = Rental / Outright / Outright Plus
        if(promoAppVal == '2284'|| promoAppVal == '2285'|| promoAppVal == '2287') {
            $('#exTrade').removeAttr("disabled");
        }
        else {
            $('#exTrade').val('0').prop("disabled", true);
        }

        //Promo Application = Expired Filter(Outright SVM/Rental SVM)
        if(promoAppVal == '2290' || promoAppVal == '2744') {
            if($('#promoTypeId option').size() == 3) {
                $('#promoTypeId option:last').remove();
            }
            $('#promoAddDiscPrc').val('').prop("disabled", true);
        }
        else {
            if($('#promoTypeId option').size() == 2) {
                $('#promoTypeId option:last').after("<option value='2283'>Only FREE GIFT</option>");
            }
            $('#promoAddDiscPrc').removeAttr("disabled");
        }

        //Promo Application <> Expired Filter & Customer = Individual
//      if(promoAppVal != '2290' && (promoCustVal == '964' || promoCustVal == '')) {
        if(promoCustVal == '964' || promoCustVal == '') {
            $('#empChk').removeAttr("disabled");
        }
        else {
            $('#empChk').val('').prop("disabled", true);
        }

        //Promo Application = Rental & Promotion Type = Discount
        if(promoAppVal == '2284' && promoTypVal == '2282') {
            console.log('Promo Application = Rental & Promotion Type = Discount');

            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').removeAttr("disabled");
            $('#promoDiscPeriodTp').removeAttr("disabled");
            $('#promoDiscPeriod').removeAttr("disabled");
//          $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').val('').prop("disabled", true);
            $('#promoAddDiscPv').val('').prop("disabled", true);
//          $('#promoSrvMemPacId').val('').prop("disabled", true);

            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = 2  & Promotion Type = Discount
        else if((promoAppVal == '2285' || promoAppVal == '2286') && promoTypVal == '2282') {
            console.log('Promo Application = Outright & Promotion Type = Discount');

            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
//          $('#promoFreesvcPeriodTp').removeAttr("disabled");
            $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').removeAttr("disabled");
//          $('#promoSrvMemPacId').val('').prop("disabled", true);

            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = Rental/Outright Membership & Promotion Type = Discount
        else if((promoAppVal == '2289' || promoAppVal == '2288') && promoTypVal == '2282') {
            console.log('Promo Application = Rental/Outright Membership & Promotion Type = Discount');

            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
//          $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').val('').prop("disabled", true);
//          $('#promoSrvMemPacId').removeAttr("disabled");

            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = Expired Filter & Promotion Type = Discount
        else if((promoAppVal == '2290' || promoAppVal == '2744') && promoTypVal == '2282') {
            console.log('Promo Application = Expired Filter & Promotion Type = Discount');

            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
//          $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').val('').prop("disabled", true);
            $('#promoAddDiscPv').val('').prop("disabled", true);
 //         $('#promoSrvMemPacId').val('').prop("disabled", true);

            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = ALL (Exclude Expired Filter) & Promotion Type = Only Free Gift
        else if(promoAppVal != '' && promoTypVal == '2283') {
            console.log('Promo Application = ALL (Exclude Expired Filter) & Promotion Type = Only Free Gift');

            $('#promoDiscType').val('').prop("disabled", true);
          //$('#promoDiscValue').val('').prop("disabled", true);
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
//          $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').val('').prop("disabled", true);
            $('#promoAddDiscPv').val('').prop("disabled", true);
//          $('#promoSrvMemPacId').val('').prop("disabled", true);

//          $('#sctPromoDetail').addClass("blind");
        }
        else if(promoAppVal == '2287') {
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').removeAttr("disabled");
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
//          $('#promoFreesvcPeriodTp').removeAttr("disabled");
//          $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').removeAttr("disabled");
//          $('#promoSrvMemPacId').removeAttr("disabled");

            $('#sctPromoDetail').removeClass("blind");
        }
        else {
            console.log('etc');

            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').removeAttr("disabled");
            $('#promoDiscPeriodTp').removeAttr("disabled");
            $('#promoDiscPeriod').removeAttr("disabled");
//          $('#promoFreesvcPeriodTp').removeAttr("disabled");
//          $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').removeAttr("disabled");
//          $('#promoSrvMemPacId').removeAttr("disabled");

            $('#sctPromoDetail').removeClass("blind");
        }

        //Promo Application = Rental
        if(promoAppVal == '2284') {
            $('#promoDiscPeriodTp').val('2293');
            $('#promoDiscPeriod').val('').prop("disabled", true);

            $('[name="megaDeal"]').removeAttr("disabled");
        }
        else {
//          $('#promoDiscPeriodTp').val('');
//          $('#promoDiscPeriod').removeAttr("disabled");

            $('[name="megaDeal"]').prop("disabled", true);
            $('#megaDealN').prop("checked", true);
        }
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='sales.title.promoList'/> – <spring:message code='sales.title.promo.new'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnClosePop" href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.promoInfo'/></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoApp'/><span class="must">*</span></th>
    <td>
    <select id="promoAppTypeId" name="promoAppTypeId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.promo.promoType'/><span class="must">*</span></th>
    <td>
    <select id="promoTypeId" name="promoTypeId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.period'/><span class="must">*</span></th>
    <td colspan="3">
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="promoDtFrom" name="promoDtFrom" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="promoDtEnd" name="promoDtEnd" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.promoNm'/></th>
    <td><input id="promoDesc" name="promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promoCd'/><span class="must">*</span></th>
    <td><input id="promoCode" name="promoCode" type="text" title="" placeholder="" class="w100p" disabled /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.custInfo'/></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.custType'/><span class="must">*</span></th>
    <td>
    <select id="promoCustType" name="promoCustType" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.extrade'/><span class="must">*</span></th>
    <td>
    <select id="exTrade" name="exTrade" class="w100p" disabled></select>
    </td>
    <th scope="row"><spring:message code='sales.employee'/><span class="must">*</span></th>
    <td>
    <select id="empChk" name="empChk" class="w100p" disabled></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctPromoDetail">
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.dtl'/></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.promo.discTypeVal'/><span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="promoDiscType" name="promoDiscType" class="w100p"></select>
    </p>
    <p>
    <input id="promoDiscValue" name="promoDiscValue" type="text" title="" placeholder="" class="w100p" disabled />
    </p>
    </div>
    </td>
    <th scope="row"><spring:message code='sales.promo.rpfDisc'/><span class="must">*</span></th>
    <td>
    <input id="promoRpfDiscAmt" name="promoRpfDiscAmt" type="text" title="" placeholder="" class="w100p" disabled />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.discPeriod'/><span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p"></select>
    </p>
    <p>
    <input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder=""  class="w100p" />
    </p>
    </div>
    </td>
<!--
    <th scope="row">Free SVC Period<span class="must">*</span></th>
    <td>
    <select id="promoFreesvcPeriodTp" name="promoFreesvcPeriodTp" class="w100p"></select>
    </td>
-->
    <th scope="row"><spring:message code='sales.promo.svcPack'/><span class="must">*</span></th>
    <td>
    <select id="promoSrvMemPacId" name="promoSrvMemPacId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.promo.addDisc'/></th>
    <td><input id="promoAddDiscPrc" name="promoAddDiscPrc" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.promo.addDiscPV'/></th>
    <td><input id="promoAddDiscPv" name="promoAddDiscPv" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Mega Deal</th>
    <td colspan=3>
        <input id="megaDealY" name="megaDeal" type="radio" value="1" disabled/><span>Yes</span>
        <input id="megaDealN" name="megaDeal" type="radio" value="0" disabled checked/><span>No</span></td>
</tr>
<!--
<tr>
    <th scope="row">Service Package<span class="must">*</span></th>
    <td>
    <select id="promoSrvMemPacId" name="promoSrvMemPacId" class="w100p"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
-->
</tbody>
</table><!-- table end -->
</section>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.prodList'/></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="btnProductDel" href="#"><spring:message code='sys.btn.del'/></a></p></li>
    <li><p class="btn_grid"><a id="btnProductAdd" href="#"><spring:message code='sys.btn.add'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.sub.promo.giftList'/></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="btnFreeGiftDel" href="#"><spring:message code='sys.btn.del'/></a></p></li>
    <li><p class="btn_grid"><a id="btnFreeGiftAdd" href="#"><spring:message code='sys.btn.add'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_gift_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
<!--
    <li><p class="btn_blue2"><a href="#">Product</a></p></li>
    <li><p class="btn_blue2"><a href="#">From Gift</a></p></li>
-->
    <li><p class="btn_blue"><a id="btnPromoSave" href="#"><spring:message code='sys.btn.save'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->