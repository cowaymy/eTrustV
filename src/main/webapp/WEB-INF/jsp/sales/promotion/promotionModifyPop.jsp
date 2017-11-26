<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var stckGridID, giftGridID;
    
    $(document).ready(function(){

        //AUIGrid 그리드를 생성합니다.
        createAUIGridStk();
        
        doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID', ${promoInfo.promoAppTypeId},    'promoAppTypeId', 'S'); //Promo Application
        doGetCombo('/common/selectCodeList.do', '76',  ${promoInfo.promoTypeId},       'promoTypeId',       'S'); //Promo Type
        doGetCombo('/common/selectCodeList.do', '8',   ${promoInfo.promoCustType},     'promoCustType',     'S', 'fn_addOption'); //Customer Type
        doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', ${promoInfo.promoDiscPeriodTp}, 'promoDiscPeriodTp', 'S'); //Discount period
        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, ${promoInfo.exTrade},              'exTrade',              'S'); //EX_Trade
        doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, ${promoInfo.empChk},               'empChk',               'S'); //EMP_CHK
        doGetComboData('/common/selectCodeList.do', {groupCode :'323'}, ${promoInfo.promoDiscType},        'promoDiscType',        'S'); //Discount Type
      //doGetComboData('/common/selectCodeList.do', {groupCode :'321'}, ${promoInfo.promoFreesvcPeriodTp}, 'promoFreesvcPeriodTp', 'S'); //Free SVC Period
        
      //doGetCombo('/sales/promotion/selectMembershipPkg.do', ${promoInfo.promoSrvMemPacId}, '9', 'promoSrvMemPacId', 'S'); //Common Code
        doGetComboCodeId('/sales/promotion/selectMembershipPkg.do', {promoAppTypeId : ${promoInfo.promoAppTypeId}}, ${promoInfo.promoSrvMemPacId}, 'promoSrvMemPacId', 'S'); //Common Code

        fn_chgPageMode('VIEW');
    });
    
    function createAUIGridStk() {
        
        //AUIGrid 칼럼 설정
        var columnLayout1 = [
            { headerText : "Product CD",    dataField  : "itmcd",   editable : false,   width : 100 }
          , { headerText : "Product Name",  dataField  : "itmname", editable : false                  }
          , { headerText : "Normal" 
            , children   : [{ headerText : "Monthly Fee<br>/Price", dataField : "amt",         editable : false, width : 100 }
                          , { headerText : "RPF",                   dataField : "prcRpf",      editable : false, width : 100 }
                          , { headerText : "PV",                    dataField : "prcPv",       editable : false, width : 100 }]}
          , { headerText : "Promotion" 
            , children   : [{ headerText : "Monthly Fee<br>/Price", dataField : "promoAmt",    editable : false, width : 100 }
                          , { headerText : "RPF",                   dataField : "promoPrcRpf", editable : false, width : 100 }
                          , { headerText : "PV",                    dataField : "promoItmPv",  editable : true,  width : 100 }]}
          , { headerText : "itmid",         dataField   : "promoItmStkId",    visible  : false, width : 80 }
          , { headerText : "promoItmId",    dataField   : "promoItmId",       visible  : false, width : 80 }
          ];

        //AUIGrid 칼럼 설정
        var columnLayout2 = [
            { headerText : "Product CD",    dataField : "itmcd",              editable : false, width : 100 }
          , { headerText : "Product Name",  dataField : "itmname",            editable : false              }
          , { headerText : "Product QTY",   dataField : "promoFreeGiftQty",   editable : true, width : 120 }
          , { headerText : "itmid",         dataField : "promoFreeGiftStkId", false    : true,  width : 120 }
          , { headerText : "promoItmId",    dataField : "promoItmId",         false    : true,  width : 80  }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : true,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells", 
            showRowCheckColumn  : true,
            showEditedCellMarker: false,
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
    
    function fn_selectPromotionPrdListAjax(promoId) {
        console.log('fn_selectPromotionPrdListAjax START');
        Common.ajax("GET", "/sales/promotion/selectPromotionPrdList.do", { promoId : promoId }, function(result) {
            AUIGrid.setGridData(stckGridID, result);
            
            fn_getPrdPriceInfo();
        });
    }
    
    function fn_selectPromotionFreeGiftListAjax(promoId) {
        console.log('fn_selectPromotionFreeGiftListAjax START');
        Common.ajax("GET", "/sales/promotion/selectPromotionFreeGiftList.do", { promoId : promoId }, function(result) {
            AUIGrid.setGridData(giftGridID, result);
        });
    }
    
    function fn_doSavePromtion() {
        console.log('!@# fn_doSavePromtion START');
        console.log($('#promoCode').val().trim());
        
        $('#exTrade').removeAttr("disabled");
        
        var promotionVO = {
            
            salesPromoMVO : {
                promoId                 : ${promoInfo.promoId},
//              promoCode               : $('#promoCode').val().trim(),
                promoDesc               : $('#promoDesc').val().trim(),
//              promoTypeId             : $('#promoTypeId').val(),
//              promoAppTypeId          : $('#promoAppTypeId').val(),
                promoSrvMemPacId        : $('#promoSrvMemPacId').val(),
                promoDtFrom             : $('#promoDtFrom').val().trim(),
                promoDtEnd              : $('#promoDtEnd').val().trim(),
                promoPrcPrcnt           : $('#promoDiscValue').val().trim(),
                promoCustType           : $('#promoCustType').val().trim(),
                promoDiscType           : $('#promoDiscType').val(),
                promoRpfDiscAmt         : $('#promoRpfDiscAmt').val(),
                promoDiscPeriodTp       : $('#promoDiscPeriodTp').val(),
                promoDiscPeriod         : $('#promoDiscPeriod').val().trim(),
//              promoFreesvcPeriodTp    : $('#promoFreesvcPeriodTp').val(),
                promoAddDiscPrc         : $('#promoAddDiscPrc').val().trim(),
                promoAddDiscPv          : $('#promoAddDiscPv').val().trim(),
                exTrade                 : $('#exTrade').val(),
                empChk                  : $('#empChk').val()
            },
            salesPromoDGridDataSetList  : GridCommon.getEditData(stckGridID),
            freeGiftGridDataSetList     : GridCommon.getEditData(giftGridID)
        };

        Common.ajax("POST", "/sales/promotion/updatePromotion.do", promotionVO, function(result) {

            Common.alert("Promotion Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");
            
//          fn_chgPageMode('VIEW');
           
            fn_selectPromoListAjax();

            $('#btnClosePop').click();
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save promotion.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
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
            
            newPrcVal = Math.floor(newPrcVal);
            
            if(newPrcVal < 0) newPrcVal = 0;
            
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
            
            if($('#exTrade').val() == '1' && $('#promoAppTypeId').val() == '2284') {
                orgPvVal = orgPvVal * (70/100);
                dscPvVal = AUIGrid.getCellValue(stckGridID, i, "prcRpf") - (FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim());
            }
            else if($('#exTrade').val() == '1' && ($('#promoAppTypeId').val() == '2285' || $('#promoAppTypeId').val() == '2287')) {
                orgPvVal = orgPvVal * (70/100);
//              dscPvVal = AUIGrid.getCellValue(stckGridID, i, "amt") - AUIGrid.getCellValue(stckGridID, i, "promoAmt");
                dscPvVal = AUIGrid.getCellValue(stckGridID, i, "promoAmt");
            }
            else if($('#exTrade').val() == '0' && ($('#promoAppTypeId').val() == '2284' || $('#promoAppTypeId').val() == '2285' || $('#promoAppTypeId').val() == '2287')) {
//              dscPvVal = AUIGrid.getCellValue(stckGridID, i, "amt") - AUIGrid.getCellValue(stckGridID, i, "promoAmt");
                dscPvVal = AUIGrid.getCellValue(stckGridID, i, "promoAmt");
            }
            
            newPvVal = Math.round(orgPvVal - dscPvVal - addPvVal);
            
            gstPvVal = Math.round(orgPvVal - Math.floor(dscPvVal*(1/1.06)) - addPvVal);
            
            if(newPvVal < 0) newPvVal = 0;
            if(gstPvVal < 0) gstPvVal = 0;
            
            AUIGrid.setCellValue(stckGridID, i, "promoItmPv", newPvVal);
            AUIGrid.setCellValue(stckGridID, i, "promoItmPvGst", gstPvVal);
        }
    }
    
    function fn_getPrdPriceInfo() {
         
        var promotionVO = {            
            salesPromoMVO : {
                promoAppTypeId         : $('#promoAppTypeId').val()
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
            
//          fn_calcDiscountPV();
        });
    }
    
    $(function(){
        $('#btnProductAdd').click(function() {
            var isValid = true, msg = "";
            
            if(FormUtil.checkReqValue($('#promoAppTypeId'))) {
                isValid = false;
                msg += "* Please select the promotion application.<br />";
            }
            if(!$('#promoSrvMemPacId').is(":disabled") && FormUtil.checkReqValue($('#promoSrvMemPacId'))) {
                isValid = false;
                msg += "* Please select the membership package.<br />";
            }
            
            if(!isValid) {
                Common.alert("Add Product Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
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
            fn_chgPromoDetail(null, null, null);

            fn_chgPromoDetail(${promoInfo.promoAppTypeId}, ${promoInfo.promoTypeId}, ${promoInfo.promoCustType});
        });
        $('#promoTypeId').change(function() {
            fn_chgPromoDetail(null, null, null);
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
            fn_chgPromoDetail(null, null, null);
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
        $('#btnPromoEdit').click(function() {
            fn_chgPageMode('MODIFY');
        });
    });
    
    function fn_chgPageMode(vMode) {
        
        if(vMode == 'MODIFY') {

            $('#btnPromoEdit').addClass("blind");
            $('#btnPromoSave').removeClass("blind");
            
            $('#liProductDel').removeClass("blind");
            $('#liProductAdd').removeClass("blind");
            $('#liFreeGiftDel').removeClass("blind");
            $('#liFreeGiftAdd').removeClass("blind");

            fn_chgPromoDetail(null, null, null);

            $('#promoAppTypeId').prop("disabled", true);
            $('#promoTypeId').prop("disabled", true);
            $('#promoCode').prop("disabled", true);
        
            AUIGrid.setProp(stckGridID, "editable" , true);
        }
        else if(vMode == 'VIEW') {
            $('#btnPromoEdit').removeClass("blind");
            $('#btnPromoSave').addClass("blind");
            
            $('#liProductDel').addClass("blind");
            $('#liProductAdd').addClass("blind");
            $('#liFreeGiftDel').addClass("blind");
            $('#liFreeGiftAdd').addClass("blind");
            
            //Product List Search
            fn_selectPromotionPrdListAjax(${promoInfo.promoId});
            
            //Free Gift List Search
            fn_selectPromotionFreeGiftListAjax(${promoInfo.promoId});
        
            $('#modifyForm').find(':input').prop("disabled", true);
            
            AUIGrid.setProp(stckGridID, "editable" , false);
        }
    }
    
    function fn_validPromotion() {
        var isValid = true, msg = "";

        if(FormUtil.checkReqValue($('#promoAppTypeId'))) {
            isValid = false;
            msg += "* Please select the promotion application.<br />";
        }
        if(FormUtil.checkReqValue($('#promoTypeId'))) {
            isValid = false;
            msg += "* Please select the application type.<br />";
        }
        if(FormUtil.isEmpty($('#promoDtFrom').val()) || FormUtil.isEmpty($('#promoDtEnd').val())) {
            isValid = false;
            msg += "* Please key in the promotion period.<br />";
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
        if(!$('#exTrade').is(":disabled") && FormUtil.checkReqValue($('#exTrade'))) {
            isValid = false;
            msg += "* Please select the Ex-Trade.<br />";
        }
        if(!$('#empChk').is(":disabled") && FormUtil.checkReqValue($('#empChk'))) {
            isValid = false;
            msg += "* Please select the employee.<br />";
        }
        if(!$('#promoDiscValue').is(":disabled") && FormUtil.checkReqValue($('#promoDiscValue'))) {
            isValid = false;
            msg += "* Please key in the discount value.<br />";
        }
        if(!$('#promoRpfDiscAmt').is(":disabled") && FormUtil.checkReqValue($('#promoRpfDiscAmt'))) {
            isValid = false;
            msg += "* Please key in the RPF discount.<br />";
        }
        if(!$('#promoDiscPeriod').is(":disabled") && FormUtil.checkReqValue($('#promoDiscPeriod'))) {
            isValid = false;
            msg += "* Please key in the discount period.<br />";
        }
        /*
        if(!$('#promoFreesvcPeriodTp').is(":disabled") && FormUtil.checkReqValue($('#promoFreesvcPeriodTp'))) {
            isValid = false;
            msg += "* Please select the free svc period.<br />";
        }
        */
        if(!$('#promoSrvMemPacId').is(":disabled") && FormUtil.checkReqValue($('#promoSrvMemPacId'))) {
            isValid = false;
            msg += "* Please select the membership package.<br />";
        }
        
        if(!isValid) Common.alert("Add Product Summary" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        
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
    function fn_chgPromoDetail(promoAppVal, promoTypVal, promoCustVal) {
        
        console.log('fn_chgPromoDetail() START');
        console.log('before promoAppVal  :'+promoAppVal);
        console.log('before promoTypVal  :'+promoTypVal);
        console.log('before promoCustVal :'+promoCustVal);
        
        $(':input').removeAttr("disabled");
        
        var promoAppVal  = FormUtil.isEmpty(promoAppVal)  ? $('#promoAppTypeId').val() : promoAppVal;
        var promoTypVal  = FormUtil.isEmpty(promoTypVal)  ? $('#promoTypeId').val()    : promoTypVal;
        var promoCustVal = FormUtil.isEmpty(promoCustVal) ? $('#promoCustType').val()  : promoCustVal;

        console.log('after promoAppVal  :'+promoAppVal);
        console.log('after promoTypVal  :'+promoTypVal);
        console.log('after promoCustVal :'+promoCustVal);
        
        //Promo Application = Rental / Outright / Outright Plus
        if(promoAppVal == '2284'|| promoAppVal == '2285'|| promoAppVal == '2287') {
            $('#exTrade').removeAttr("disabled");
        }
        else {
            $('#exTrade').val('0').prop("disabled", true);
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
        else if(promoAppVal == '2290' && promoTypVal == '2282') {
            console.log('Promo Application = Expired Filter & Promotion Type = Discount');
            
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
//          $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').val('').prop("disabled", true);
            $('#promoAddDiscPv').val('').prop("disabled", true);
//          $('#promoSrvMemPacId').val('').prop("disabled", true);
            
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
            
            $('#sctPromoDetail').addClass("blind");
        }
        else {
            console.log('etc');
            
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').removeAttr("disabled");
            $('#promoDiscPeriodTp').removeAttr("disabled");
            $('#promoDiscPeriod').removeAttr("disabled");
//          $('#promoFreesvcPeriodTp').removeAttr("disabled");
            $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').removeAttr("disabled");
//          $('#promoSrvMemPacId').removeAttr("disabled");
            
            $('#sctPromoDetail').removeClass("blind");
        }
        
    }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Promotion Management – VIEW promotion</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnClosePop" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
<!--
    <li><p class="btn_blue2"><a href="#">Product</a></p></li>
    <li><p class="btn_blue2"><a href="#">From Gift</a></p></li>
-->
    <li><p class="btn_blue"><a id="btnPromoEdit" href="#">Edit</a></p></li>
    <li><p class="btn_blue"><a id="btnPromoSave" href="#" class="blind">Save</a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>Promotion Information</h2>
</aside><!-- title_line end -->
<form id="modifyForm" name="modifyForm">
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
    <th scope="row">Promotion Application<span class="must">*</span></th>
    <td>
    <select id="promoAppTypeId" name="promoAppTypeId" class="w100p"></select>
    </td>
    <th scope="row">Promotion Type<span class="must">*</span></th>
    <td>
    <select id="promoTypeId" name="promoTypeId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Promotion Period<span class="must">*</span></th>
    <td colspan="3">
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="promoDtFrom" name="promoDtFrom" value="${promoInfo.promoDtFrom}" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="promoDtEnd" name="promoDtEnd" value="${promoInfo.promoDtEnd}" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Promotion Name</th>
    <td><input id="promoDesc" name="promoDesc" value="${promoInfo.promoDesc}" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Promotion Code<span class="must">*</span></th>
    <td><input id="promoCode" name="promoCode" value="${promoInfo.promoCode}" type="text" title="" placeholder="" class="w100p" disabled/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
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
    <th scope="row">Customer Type<span class="must">*</span></th>
    <td>
    <select id="promoCustType" name="promoCustType" class="w100p"></select>
    </td>
    <th scope="row">Ex-Trade<span class="must">*</span></th>
    <td>
    <select id="exTrade" name="exTrade" class="w100p" disabled></select>
    </td>
    <th scope="row">Employee<span class="must">*</span></th>
    <td>
    <select id="empChk" name="empChk" class="w100p" disabled></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctPromoDetail">
<aside class="title_line"><!-- title_line start -->
<h2>Promotion Detail</h2>
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
    <th scope="row">Discount(Type/Value)<span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="promoDiscType" name="promoDiscType" class="w100p"></select>
    </p>
    <p>
    <input id="promoDiscValue" name="promoDiscValue" value="${promoInfo.promoPrcPrcnt}" type="text" title="" placeholder="" class="w100p" />   
    </p>
    </div>    
    </td>
    <th scope="row">RPF Discunt<span class="must">*</span></th>
    <td>
    <input id="promoRpfDiscAmt" name="promoRpfDiscAmt" value="${promoInfo.promoRpfDiscAmt}" type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Discount period<span class="must">*</span></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p>
    <select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p"></select>
    </p>
    <p>
    <input id="promoDiscPeriod" name="promoDiscPeriod" value="${promoInfo.promoDiscPeriod}" type="text" title="" placeholder=""  class="w100p" />   
    </p>
    </div>    
    </td>
<!--
    <th scope="row">Free SVC Period<span class="must">*</span></th>
    <td>
    <select id="promoFreesvcPeriodTp" name="promoFreesvcPeriodTp" class="w100p"></select>
    </td>
-->
    <th scope="row">Service Package<span class="must">*</span></th>
    <td>
    <select id="promoSrvMemPacId" name="promoSrvMemPacId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Additional Discount (RM)</th>
    <td><input id="promoAddDiscPrc" name="promoAddDiscPrc" value="${promoInfo.promoAddDiscPrc}" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Additional Discount (PV)</th>
    <td><input id="promoAddDiscPv" name="promoAddDiscPv" value="${promoInfo.promoAddDiscPv}" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<!--
<tr>
    <th scope="row">Membership Package<span class="must">*</span></th>
    <td>
    <select id="promoSrvMemPacId" name="promoSrvMemPacId" class="w100p"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
-->
</tbody>
</table><!-- table end -->
</form>
</section>

<aside class="title_line"><!-- title_line start -->
<h2>Product List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li id="liProductDel" class="blind"><p class="btn_grid"><a id="btnProductDel" href="#">DEL</a></p></li>
    <li id="liProductAdd" class="blind"><p class="btn_grid"><a id="btnProductAdd" href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Free Gift List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li id="liFreeGiftDel" class="blind"><p class="btn_grid"><a id="btnFreeGiftDel" href="#">DEL</a></p></li>
    <li id="liFreeGiftAdd" class="blind"><p class="btn_grid"><a id="btnFreeGiftAdd" href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_gift_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

