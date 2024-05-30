<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var stckGridID, giftGridID;

    var stkSizeData = [{"codeId": "KING"  ,"codeName": "KING"},
                       {"codeId": "QUEEN" ,"codeName": "QUEEN"},
                       {"codeId": "SINGLE","codeName": "SINGLE"}];

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
        doGetComboData('/common/selectCodeList.do', {groupCode :'451', orderValue:'CODE_ID'}, '','eSales','S');
        doDefCombo(stkSizeData, '' ,'stkSize', 'S', '');
        doGetCombo('/common/selectCodeList.do', '568',  '', 'promoSpecialDisId',       'S'); //Discount on billing
        doGetCombo('/common/selectCodeList.do', '581', '', 'extradeAppType', 'S'); //Extrade App Type

        $("#chgRemark").keyup(function(){
            $("#characterCount").text($(this).val().length + " of 100 max characters");
      	});

        $('.extradeMonth').attr("hidden", true);

        $('#promoAppTypeId').change(function(){
        	if($('#promoAppTypeId').val() == "2284"){
                $('.extradeMonth').removeAttr("hidden");
                $('#extradeMonthFrom').val('0');
                $('#extradeMonthTo').val('0');
                $('#extradeAppType').val('0');
        	}
        	else{
                $('.extradeMonth').attr("hidden", true);
                $('#extradeMonthFrom').val('0');
                $('#extradeMonthTo').val('0');
                $('#extradeAppType').val('0');
        	}
        });
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
            , children   : [{ headerText : "<spring:message code='sales.mthFeePrc'/>", dataField : "promoAmt",    editable : true, width : 100  }
                          , { headerText : "<spring:message code='sales.rpf'/>",       dataField : "promoPrcRpf", editable : false, width : 100  }
                          , { headerText : "<spring:message code='sales.pv'/>",        dataField : "promoItmPv",  editable : true,  width : 100  }]}
          , { headerText : "promoItmPvGst", dataField   : "promoItmPvGst",  visible  : false,     width : 80  }
          , { headerText : "itmid",         dataField   : "promoItmStkId",  visible  : false,     width : 80  }
          , {dataField: "stkCtgryId", visible: false}
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

        var vCustStatusNew = "";
        var vCustStatusDisen = "";
        var vCustStatusEn = "";
        var vCustStatusEnWoutWp = "";
        var vCustStatusEnWp6m = "";
        if($('#custStatusNew').is(":checked")) {
        	vCustStatusNew = 1;
        }else{
        	vCustStatusNew = 0;
        }
        if($('#custStatusDisen').is(":checked")) {
        	vCustStatusDisen = 1;
        }else{
        	vCustStatusDisen = 0;
        }
        if($('#custStatusEn').is(":checked")) {
        	vCustStatusEn = 1;
        }else{
        	vCustStatusEn = 0;
        }
        if($('#custStatusEnWoutWp').is(":checked")) {
        	vCustStatusEnWoutWp = 1;
        }else{
        	vCustStatusEnWoutWp = 0;
        }
        if($('#custStatusEnWp6m').is(":checked")) {
        	vCustStatusEnWp6m = 1;
        }else{
        	vCustStatusEnWp6m = 0;
        }

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
                megaDeal                : $('input:radio[name="megaDeal"]:checked').val(),
                advDisc                : $('input:radio[name="advDisc"]:checked').val(),
                stkSize                 : $('#stkSize').val(),
                promoESales             :$('#eSales').val().trim(),
                voucherPromotion                : $('input:radio[name="voucherPromotion"]:checked').val(),
				preBook                : $('input:radio[name="preBook"]:checked').val(),
                chgRemark              :$('#chgRemark').val(),
                custStatusNew : vCustStatusNew,
                custStatusDisen : vCustStatusDisen,
                custStatusEn : vCustStatusEn,
                custStatusEnWoutWp : vCustStatusEnWoutWp,
                custStatusEnWp6m : vCustStatusEnWp6m,
                promoDiscOnBill : $('#promoSpecialDisId').val(),
                extradeFr: $('#extradeMonthFrom').val(),
                extradeTo: $('#extradeMonthTo').val(),
                woHs: $('input:radio[name="woHs"]:checked').val(),
                extradeAppType: $('#extradeAppType').val()
            },
            salesPromoDGridDataSetList  : GridCommon.getEditData(stckGridID),
            freeGiftGridDataSetList     : GridCommon.getEditData(giftGridID)
        };

        Common.ajax("POST", "/sales/promotion/registerPromotion.do", promotionVO, function(result) {
            Common.alert("New Promotion Request" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");

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
            if((!(AUIGrid.getCellValue(stckGridID, i, "stkCtgryId") == 7177) || dscPrcVal != 0) && $('#promoAppTypeId').val() == '2285' ) newPrcVal = (Math.trunc(newPrcVal / 10)) * 10  ; // if App Tye = Outright , trunc amount 0 -- edited by TPY 01/06/2018

            AUIGrid.setCellValue(stckGridID, i, "promoAmt", newPrcVal);
        }
    }

    function fn_calcDiscountRPF() {

        var orgRpfVal = 0;
        var dscRpfVal = FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim();
        var newRpfVal = 0;

        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {

            orgRpfVal = AUIGrid.getCellValue(stckGridID, i, "prcRpf");
            newRpfVal = orgRpfVal - dscRpfVal;

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
                        AUIGrid.setCellValue(stckGridID, j, "stkCtgryId",  result[i].stkCtgryId);
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
        	if($('#exTrade').val() == "1"){
                $('#extradeMonthFrom').prop("disabled", false);
                $('#extradeMonthTo').prop("disabled", false);
                $('#extradeAppType').prop("disabled", false);
        	}
        	else{
                $('#extradeMonthFrom').val('0').prop("disabled", true);
                $('#extradeMonthTo').val('0').prop("disabled", true);
                $('#extradeAppType').val('0').prop("disabled", true);
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
        if($('#promoAppTypeId').val() != 3220 && $('#promoAppTypeId').val() != 3221 ){
        if(!$('#promoSrvMemPacId').is(":disabled") && FormUtil.isEmpty($('#promoSrvMemPacId').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg17'/><br /> ";
        }
        }

        if(FormUtil.isEmpty($('[name="custStatus"]:checked').val())){
        	isValid = false;
            msg += "<spring:message code='sales.promo.msg19'/><br /> ";
        }

        if(!$('#promoSpecialDisId').is(":disabled") && FormUtil.isEmpty($('#promoSpecialDisId').val())) {
            isValid = false;
            msg += "<spring:message code='sales.promo.msg20'/><br />";
        }

        if($('#promoAppTypeId option:selected').val() == 2284){
	        if( !$('#extradeAppType').is(":disabled") && FormUtil.isEmpty($('#extradeAppType').val())) {
	            isValid = false;
	            msg += "Extrade App Type must be selected";
	        }
        }

        if($('#exTrade').val() == '1') {
            if(FormUtil.isEmpty($('#extradeMonthFrom').val()) || FormUtil.isEmpty($('#extradeMonthTo').val())){
            	isValid = false;
                msg += "Please enter extrade month. If there is no end month for extrade. Please set it to 999<br />";
            }
            else{
            	var extradeMonthFrom = $('#extradeMonthFrom').val();
    			var extradeMonthTo = $('#extradeMonthTo').val();

    			var mFrom = extradeMonthFrom.replace("-","");
    			var mTo = extradeMonthTo.replace("-","");

            	if(FormUtil.onlyNumCheck(mFrom) && FormUtil.onlyNumCheck(mTo)){
//             		if(mFrom >= mTo){
//                     	isValid = false;
//                         msg += "Extrade Month To must be larger or equal value than From<br />";
//             		}
            	}
            	else{
                	isValid = false;
                    msg += "Extrade Month are in number format only<br />";
            	}
            }
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

            if($('#exTrade').val() == "1"){
                $('#extradeMonthFrom').removeAttr("disabled");
                $('#extradeMonthTo').removeAttr("disabled");
                $('#extradeAppType').removeAttr("disabled");
        	}
        }
        else {
            $('#exTrade').val('0').prop("disabled", true);
            $('#extradeMonthFrom').val('0').prop("disabled", true);
            $('#extradeMonthTo').val('0').prop("disabled", true);
            $('#extradeAppType').val('').prop("disabled", true);
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
        else if(promoAppVal == '7553'){
            $('#promoDiscType').removeAttr("disabled");
            $('#promoRpfDiscAmt').removeAttr("disabled");
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
            $('#promoAddDiscPv').removeAttr("disabled");
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
            $('[name="preBook"]').removeAttr("disabled");
        }
        else {
//          $('#promoDiscPeriodTp').val('');
//          $('#promoDiscPeriod').removeAttr("disabled");

            $('[name="megaDeal"]').prop("disabled", true);
            $('#megaDealN').prop("checked", true);

            $('[name="preBook"]').prop("disabled", true);
            $('#preBookN').prop("checked", true);
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
<tr>
    <th scope="row">Voucher Promotion</th>
    <td>
        <input id="voucherPromotionY" name="voucherPromotion" type="radio" value="1" /><span>Yes</span>
        <input id="voucherPromotionN" name="voucherPromotion" type="radio" value="0" checked/><span>No</span>
    </td>
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
    <th scope="row"><span class="extradeMonth">Ex-trade Month</span></th>
	<td colspan="2">
		<div class="extradeMonth" >
			<div style="display: flex;">
			    <p><input style="width: 50px" id="extradeMonthFrom" name="extradeMonthFrom" type="number" value="0" title="Extrade Month From" disabled/></p>
			    <span style="padding: 5px;">To</span>
			    <p><input style="width: 50px" id="extradeMonthTo" name="extradeMonthTo" type="number" value="0" title="Extrade Month To" disabled/></p>
			</div>
		</div>
	</td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.employee'/><span class="must">*</span></th>
    <td>
    <select id="empChk" name="empChk" class="w100p" disabled></select>
    </td>
    <th scope="row" class="extradeMonth">Prev Ex-trade App Type<span class="must">*</span></th>
    <td class="extradeMonth">
    	<select id="extradeAppType" name="extradeAppType" class="w100p" disabled></select>
    </td>
</tr>
<tr>
<th scope="row">Customer Status<span class="must">*</span></th>
    <td colspan = "6">
        <input id="custStatusNew" name="custStatus" type="checkbox" value="7465" checked /><span>New</span>
        <input id="custStatusEn" name="custStatus" type="checkbox" value="7466" /><span>Engaged</span>
        <input id="custStatusEnWoutWp" name="custStatus" type="checkbox" value="7476" /><span>Engaged (New to WP)</span>
        <input id="custStatusEnWp6m" name="custStatus" type="checkbox" value="7502" /><span>Engaged (WP more than 6M)</span>
        <input id="custStatusDisen" name="custStatus" type="checkbox" value="7467" /><span>Disengaged</span>
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
    <td>
        <input id="megaDealY" name="megaDeal" type="radio" value="1" disabled/><span>Yes</span>
        <input id="megaDealN" name="megaDeal" type="radio" value="0" disabled checked/><span>No</span>
    </td>
    <th scope="row"><spring:message code='sales.promo.eSales'/><span class="must">*</span></th>
    <td>
        <select id="eSales" name="eSales" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Advance Discount</th>
    <td>
        <input id="advDiscY" name="advDisc" type="radio" value="1" /><span>Yes</span>
        <input id="advDiscN" name="advDisc" type="radio" value="0" checked/><span>No</span>
    </td>
    <th scope="row">Mattress Size</th>
    <td>
        <select id="stkSize" name="stkSize" class="w100p"></select>
    </td>
</tr>
<tr>
	<th scope="row">Without HS/CS</th>
    <td>
        <input id="woHsY" name="woHs" type="radio" value="1" /><span>Yes</span>
        <input id="woHsN" name="woHs" type="radio" value="0" checked/><span>No</span>
    </td>
</tr>
<tr>
 <th scope="row"><spring:message code="newWebInvoice.remark" /><span style="color:red">*</span></th>
    <td colspan="3">
        <textarea type="text" title="" placeholder="" class="w100p" id="chgRemark" name="chgRemark" maxlength="100"></textarea>
        <span id="characterCount">0 of 100 max characters</span>
    </td>
</tr>
<tr>
    <th scope="row">Discount on Billing<span style="color:red">*</span></th>
    <td>
    <select id="promoSpecialDisId" name="promoSpecialDisId" class="w100p"></select>
    </td>
    <th>
    <td>
    <th scope="row" style="display:none;">Pre Book Promotion</th>
    <td style="display:none;">
        <input id="preBookY" name="preBook" type="radio" value="1" disabled/><span>Yes</span>
        <input id="preBookN" name="preBook" type="radio" value="0" disabled checked/><span>No</span>
    </td>
</tr>
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