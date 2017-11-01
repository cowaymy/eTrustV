<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    
    var TAB_NM        = '${ordReqType}';
    var ORD_ID        = '${orderDetail.basicInfo.ordId}';
    var ORD_NO        = '${orderDetail.basicInfo.ordNo}';
    var ORD_STUS_ID   = '${orderDetail.basicInfo.ordStusId}';
    var ORD_STUS_CODE = '${orderDetail.basicInfo.ordStusCode}';
    var CUST_ID       = '${orderDetail.basicInfo.custId}';
    var CUST_TYPE_ID  = '${orderDetail.basicInfo.custTypeId}';
    var APP_TYPE_ID   = '${orderDetail.basicInfo.appTypeId}';
    var APP_TYPE_DESC = '${orderDetail.basicInfo.appTypeDesc}';
    var CUST_NRIC     = '${orderDetail.basicInfo.custNric}';
    var PROMO_CODE    = '${orderDetail.basicInfo.ordPromoCode}';
    var PROMO_DESC    = '${orderDetail.basicInfo.ordPromoDesc}';
    var CNVR_SCHEME_ID= '${orderDetail.basicInfo.cnvrSchemeId}';
    var EMP_CHK       = '${orderDetail.basicInfo.empChk}';
    var EX_TRADE      = '${orderDetail.basicInfo.exTrade}';
    var TODAY_DD      = '${toDay}';

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
                fn_loadProductPromotion(APP_TYPE_ID, stkIdVal, EMP_CHK, CUST_TYPE_ID, EX_TRADE);                
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
                    fn_loadProductPromotion(APP_TYPE_ID, $("#cmbOrderProduct").val(), EMP_CHK, CUST_TYPE_ID, EX_TRADE);
                }
            }
            else {
                fn_loadProductPrice(APP_TYPE_ID, $("#cmbOrderProduct").val());
                fn_loadProductPromotion(APP_TYPE_ID, $("#cmbOrderProduct").val(), EMP_CHK, CUST_TYPE_ID, EX_TRADE);
            }
        });
    });

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

        Common.ajax("GET", "/sales/order/selectCheckAccessRight.do", {userId : userId, moduleUnitId : moduleUnitId}, function(rsltInfo) {
            if(rsltInfo != null) {
                result = true;
            }
            console.log('fn_getLoginInfo result:'+result);
        }, null, {async : false});

        return result;
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
    function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal, exTrade) {
        console.log('fn_loadProductPromotion --> appTypeVal:'+appTypeVal);
        console.log('fn_loadProductPromotion --> stkId:'+stkId);
        console.log('fn_loadProductPromotion --> empChk:'+empChk);
        console.log('fn_loadProductPromotion --> custTypeVal:'+custTypeVal);

        $('#cmbPromotion').removeAttr("disabled");

        doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {appTypeId:appTypeVal,stkId:stkId, empChk:empChk, promoCustType:custTypeVal, exTrade:exTrade}, '', 'cmbPromotion', 'S', ''); //Common Code
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

                console.log("¼º°ø.");

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
        
        if(tabNm == 'CANC') {
            if(ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>"
                        + "Order cancellation request is disallowed.";
                        
                Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                
                return false;
            }
            
            var todayDD = Number(TODAY_DD.substr(0, 2));
            
            console.log('todayDD:'+todayDD);
            
            if(todayDD == 26 || todayDD == 27 || todayDD == 1 || todayDD == 2) {
                var msg = "Request for order cancellation is restricted on 26, 27, 1, 2 of every month";
                        
                Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                
                return false;
            }
        }
        
        if(tabNm == 'PEXC') {
            if(ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>"
                        + "Produt exchange request is disallowed.";
                        
                Common.alert("Action Restriction" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                
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

              fn_loadListExch();
            
              fn_loadOrderInfoPexc();

              fn_isLockOrder(tabNm);
        } else {
            $('#scPX').addClass("blind");
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
            
            if(tabNm == 'CANC') {
                msg += 'Request order cancelltion is disallowed.';
            }
            else if(tabNm == 'PEXC') {
                msg += 'Request product exchange is disallowed.';
            }
        }

        if(isLock) {
            fn_disableControlCanc();
            Common.alert("Order Locked" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isLock;
    }
    
    function fn_disableControlCanc() {
        $('#cmbOrderProduct').prop("disabled", true);
        $('#btnCurrentPromo').prop("disabled", true);
        $('#cmbPromotion').prop("disabled", true);
        $('#dpCallLogDate').prop("disabled", true);
        $('#cmbReason').prop("disabled", true);
        $('#txtRemark').prop("disabled", true);
        
        $('#btnReqPrdExch').addClass("blind");
    }
    
    function fn_disableControlPexc() {
        $('#cmbRequestor').prop("disabled", true);
        $('#cmbReason').prop("disabled", true);
        $('#dpCallLogDate').prop("disabled", true);
        $('#dpReturnDate').prop("disabled", true);
        $('#txtRemark').prop("disabled", true);
        $('#txtPenaltyAdj').prop("disabled", true);
        
        $('#btnReqOrder').addClass("blind");
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

        var vCurrentOutstanding = 0;
/*        
        Common.ajax("GET", "/sales/membership/callOutOutsProcedure", {ORD_ID : ORD_ID}, function(result) {

            if(result != null && result.outSuts.length >0 > 0) {
                console.log('result.outSuts[0].ordTotOtstnd:'+result.outSuts[0].ordTotOtstnd);

                vCurrentOutstanding = result.outSuts[0].ordTotOtstnd;
            }            
       }, null, {async : false});
*/
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

    function fn_doSaveReqPexc() {
        console.log('!@# fn_doSaveReqPexc START');

        Common.ajax("POST", "/sales/order/requestProdExch.do", $('#frmReqPrdExc').serializeJSON(), function(result) {
                
                Common.alert("Product Exchange Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);
            
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

    function fn_doSaveReqCanc() {
        console.log('!@# fn_doSaveReqCanc START');

        Common.ajax("POST", "/sales/order/requestCancelOrder.do", $('#frmReqCanc').serializeJSON(), function(result) {
                
                Common.alert("Cancellation Request Summary" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);
            
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
    
    function fn_getMembershipPurchase() {
        var isExist = false;
        Common.ajaxSync("GET", "/sales/membership/selectMembershipList", {ORD_NO : ORD_ID, MBRSH_STUS_ID : '1', MBRSH_STUS_ID : '4'}, function(result) {
            if(result != null && result.length > 0) {
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
    
    function fn_loadListExch() {
        var stkType = APP_TYPE_ID == '1412' ? '3' : '1';
        
        doGetProductCombo('/common/selectProductCodeList.do',  stkType, '', 'cmbOrderProduct', 'S', ''); //Product Code
        doGetComboData('/sales/order/selectResnCodeList.do', {resnTypeId : '287', stusCodeId:'1'}, '', 'cmbReasonExch', 'S', ''); //Reason Code
        doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '', 'promoDiscPeriodTp', 'S'); //Discount period
    }
    
    function fn_loadListCanc() {
        doGetComboOrder('/common/selectCodeList.do', '52',  'CODE_ID',  '', 'cmbRequestor', 'S', ''); //Common Code
        doGetComboData('/sales/order/selectResnCodeList.do', {resnTypeId : '536', stusCodeId:'1'}, '', 'cmbReason', 'S', 'fn_removeOpt'); //Reason Code
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
    <th scope="row">Discount Period/<br>Promotion Rental Fee</th>
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
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->