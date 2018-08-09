<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    var TAB_NM        = "${ordReqType}";
    var ORD_ID        = "${orderDetail.basicInfo.ordId}";
    var ORD_NO        = "${orderDetail.basicInfo.ordNo}";
    var ORD_DT        = "${orderDetail.basicInfo.ordDt}";
    var ORD_STUS_ID   = "${orderDetail.basicInfo.ordStusId}";
    var ORD_STUS_CODE = "${orderDetail.basicInfo.ordStusCode}";
    var CUST_ID       = "${orderDetail.basicInfo.custId}";
    var CUST_TYPE_ID  = "${orderDetail.basicInfo.custTypeId}";
    var CUST_NAME  = "${orderDetail.basicInfo.custName}";
    var APP_TYPE_ID   = "${orderDetail.basicInfo.appTypeId}";
    var APP_TYPE_DESC = "${orderDetail.basicInfo.appTypeDesc}";
    var CUST_NRIC     = "${orderDetail.basicInfo.custNric}";
    var PROMO_ID      = "${orderDetail.basicInfo.ordPromoId}";
    var PROMO_CODE    = "${orderDetail.basicInfo.ordPromoCode}";
    var PROMO_DESC    = "${orderDetail.basicInfo.ordPromoDesc}";
    var STOCK_ID      = "${orderDetail.basicInfo.stockId}";
    var STOCK_DESC    = "${orderDetail.basicInfo.stockDesc}";
    var CNVR_SCHEME_ID= "${orderDetail.basicInfo.cnvrSchemeId}";
    var RENTAL_STUS   = "${orderDetail.basicInfo.rentalStus}";
    var EMP_CHK       = "${orderDetail.basicInfo.empChk}";
    var EX_TRADE      = "${orderDetail.basicInfo.exTrade}";
    var TODAY_DD      = "${toDay}";
    var SRV_PAC_ID    = "${orderDetail.basicInfo.srvPacId}";
    var GST_CHK       = "${orderDetail.basicInfo.gstChk}";
    var IS_NEW_VER    = "${orderDetail.isNewVer}";
    var txtPrice_uc_Value = "${orderDetail.basicInfo.ordAmt}";
    var txtPV_uc_Value    = "${orderDetail.basicInfo.ordPv}";
    var PRGRS_ID = "${orderDetail.logView.prgrsId}";
    var ISSUE_BANK = "${orderDetail.rentPaySetInf.rentPayIssBank}";
    var BANK_ACC_NO = "${orderDetail.rentPaySetInf.rentPayAccNo}";
    var MONTH_REN_FEE = "${orderDetail.basicInfo.mthRentalFees}";

    var filterGridID;

     $(document).ready(function(){
        //doGetComboData('/common/selectCodeList.do', {groupCode :'348'}, 'CANC', 'ordReqType', 'S'); //Order Edit Type

        if(FormUtil.isNotEmpty(TAB_NM)) {
<c:if test="${callCenterYn != 'Y'}">
            if(!fn_checkAccessRequest(TAB_NM)) return false;
</c:if>
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
/*
        Common.ajaxSync("GET", "/sales/order/selectCheckAccessRight.do", {userId : userId, moduleUnitId : moduleUnitId}, function(rsltInfo) {
            if(rsltInfo != null) {
                result = true;
            }
            console.log('fn_getLoginInfo result:'+result);
        });
*/
        return true;
    }

     function fn_changeTab(tabNm) {

        var userid = fn_getLoginInfo();
        var todayDD = Number(TODAY_DD.substr(0, 2));
        var todayYY = Number(TODAY_DD.substr(6, 4));

        if(tabNm == 'CANC') {

            if(fn_getCheckAccessRight(userid, 9)) {

                //if(ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
                	if(ORD_STUS_ID != '1') { // block if Order status is not active
                  var msg = "Order " + ORD_NO + " is under " + ORD_STUS_CODE + " status. <br/>Order cancellation request is disallowed.";
                    //msg = '<spring:message code="sal.msg.underOrdCanc" arguments="'+ORD_NO+';'+ORD_STUS_CODE+'" argumentSeparator=";"/>';
                    Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                    return false;
                    }

                if(todayYY >= 2018) {
                    if(todayDD == 26 || todayDD == 27 || todayDD == 1 || todayDD == 2) { // Block if date on 26 / 27 / 1 / 2 of the month
                        var msg = '<spring:message code="sal.msg.chkCancDate" />';
                        Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                        return false;
                    }
                }
            }
            else {
                var msg = "Sorry. You have no access rights to request order cancellation.";
                Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
                return false;
            }
        }



        var vTit = '<spring:message code="sal.page.title.ordReq" />';

/*         if($("#ordReqType option:selected").index() > 0) {
            vTit += ' - '+$('#ordReqType option:selected').text();
        } */

        if($("#ordReqType").val() != "" ) {
            vTit += ' - ' + 'Cancellation';
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

    }


    function fn_isLockOrder(tabNm) {
        var isLock = false;
        var msg = "";
        var ORD_ID = '${orderDetail.logView.salesOrdId}';
        if(("${orderDetail.logView.isLok}" == '1' && "${orderDetail.logView.prgrsId}" != 2) || "${orderDetail.logView.prgrsId}" == 1) {

            if("${orderDetail.logView.prgrsId}" == 1){
                Common.ajaxSync("GET", "/sales/order/checkeRequestAutoDebitDeduction.do", {salesOrdId : ORD_ID}, function(rsltInfo) {
                    //Valid eCash Floating Stus - 1
                    if(rsltInfo.ccpStus == 1 || rsltInfo.eCashStus == 1) {
                        isLock = true;
                        msg = 'Order ' + ORD_NO + ' is under eCash deduction progress.<br />' + rsltInfo.msg + '.<br/>';
                    }
                });
            }else{
                isLock = true;
                msg = 'Order ' + ORD_NO + ' is under ' + "${orderDetail.logView.prgrs}" + ' progress.<br />';
            }
        }

        //Valid OCR Status - (CallLog Type - 257, Stus - 20, InstallResult Stus - Active )
            Common.ajaxSync("GET", "/sales/order/validRequestOCRStus.do", {salesOrdId : ORD_ID}, function(result) {
                if(result.callLogResult == 1) {
                    isLock = true;
                    msg = 'Order ' + ORD_NO + ' is under ready installation status.<br />' + result.msg + '.<br/>' + ' Kindly refer CSS Dept via <br /><u>helpme.css@coway.com.my</u> for help.<br />';
                }
            });

        if(isLock) {
            if(tabNm == 'CANC') {
                msg += '<spring:message code="sal.alert.msg.cancDisallowed" />.<br />' ;
                fn_disableControlCanc();
            }

            Common.alert('<spring:message code="sal.alert.msg.ordLock" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");
        }
        return isLock;
    }


    function fn_disableControlCanc() {
        $('#cmbRequestor').prop("disabled", true);
        $('#cmbReason').prop("disabled", true);
        $('#dpCallLogDate').prop("disabled", true);
        $('#dpReturnDate').prop("disabled", true);
        $('#txtRemark').prop("disabled", true);
        $('#txtPenaltyAdj').prop("disabled", true);

        $('#btnReqCancOrder').addClass("blind");
    }


    function fn_loadOrderInfoCanc() {
        if(ORD_STUS_ID == '4') {
            $('#spPrfRtnDt').removeClass("blind");
            $('#dpReturnDate').removeAttr("disabled");

            if(APP_TYPE_ID == '66') {
                $('#scOP').removeClass("blind");
            }
        }


//      if(IS_NEW_VER == 'Y') {
            var vObligtPriod = fn_getObligtPriod();

            $('#txtObPeriod').val(vObligtPriod);
//      }
//      else {
//          if(CNVR_SCHEME_ID == '1') {
//              $('#txtObPeriod').val('36');
//          }
//      }

        fn_loadOutstandingPenaltyInfo();
    }



    function fn_loadOutstandingPenaltyInfo() {
        if(APP_TYPE_ID == '66' && ORD_STUS_ID == '4') {

            var vTotalUseMth = fn_getOrderLastRentalBillLedger1();

            if(FormUtil.isNotEmpty(vTotalUseMth)) {
                $('#txtTotalUseMth').val(vTotalUseMth);
            }
            $('#txtRentalFees').val("${orderDetail.basicInfo.ordMthRental}");

            var vCurrentOutstanding = fn_getOrderOutstandingInfo();

            if(FormUtil.isNotEmpty(vCurrentOutstanding)) {
                $('#txtCurrentOutstanding').val(vCurrentOutstanding);
            }

            fn_calculatePenaltyAndTotalAmount();
        }
    }

    function fn_getPenaltyAmt(usedMnth, obPeriod) {
        var vPenaltyAmt = 0;

        Common.ajaxSync("GET", "/sales/order/selectPenaltyAmt.do", {salesOrdId : ORD_ID, usedMnth : usedMnth, obPeriod : obPeriod}, function(result) {

            console.log('result:'+result);

            if(result != null) {
                vPenaltyAmt = result.penaltyAmt;
            }
        });

       return vPenaltyAmt;
    }

    function fn_calculatePenaltyAndTotalAmount() {
        var TotalMthUse = Number($('#txtTotalUseMth').val());
        var ObPeriod    = Number($('#txtObPeriod').val());
        var RentalFees = Number($('#txtRentalFees').val());
        var currentOutstandingVal = $('#txtCurrentOutstanding').val();

        currentOutstandingVal = currentOutstandingVal.replace(',','');

        var CurrentOutstanding = parseFloat(currentOutstandingVal);
        var PenaltyAdj = Number($('#txtPenaltyAdj').val());
        var PenaltyAmt = 0;

        if(IS_NEW_VER == 'N') {
            if (TotalMthUse < ObPeriod) {
                PenaltyAmt = ((RentalFees * (ObPeriod - TotalMthUse)) / 2);
            }
        }
        else {
            PenaltyAmt = fn_getPenaltyAmt(TotalMthUse, ObPeriod);
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

    function fn_getObligtPriod() {

        var vObligtPriod = 0;

        Common.ajaxSync("GET", "/sales/order/selectObligtPriod.do", {salesOrdId : ORD_ID}, function(result) {

            console.log('result:'+result);

            if(result != null) {
                console.log('result.custId:'+result.rentInstNo);

                vObligtPriod = result.obligtPriod;
            }
        });

       return vObligtPriod;
    }

    function fn_clickBtnReqCancelOrder() {
        var RequestStage = '<spring:message code="sal.text.beforeInstall" />';

        if(ORD_STUS_ID == '4') {
            RequestStage = '<spring:message code="sal.text.afterInstall" />';
        }

        var msg = "";
        //msg += '<spring:message code="sal.title.text.requestStage" /> : ' + RequestStage + '<br />';
        //msg += '<spring:message code="sal.title.text.requestor" /> : '    + $('#cmbRequestor option:selected').text() + '<br />';
        //msg += '<spring:message code="sal.title.text.reason" /> : '       + $('#cmbReason option:selected').text() + '<br />';
        msg += 'Order No.          : ' + ORD_NO + '<br />';
        msg += 'Customer Name : ' + CUST_NAME + '<br />';
        msg += 'Product             : ' + STOCK_DESC + '<br />';
        msg += 'Refund Amount  : ' + '' + '<br />';
        msg += 'Refund Account  : ' + BANK_ACC_NO + '<br />';
        //msg += '<spring:message code="sal.text.callLogDate" /> : '        + $('#dpCallLogDate').val() + '<br />';

        if(ORD_STUS_ID == '4') {
            msg += '<spring:message code="sal.alert.msg.prefRtrnDt" /> : ' + $('#dpReturnDate').val() + '<br />';

            if(APP_TYPE_ID == 66) {
                msg += '<br />';
                msg += '<spring:message code="sales.TotalUsedMonth" /> : '        + $('#txtTotalUseMth').val()      + '<br/>';
                msg += '<spring:message code="sal.text.obligationPeriod" /> : '   + $('#txtObPeriod').val()         + '<br/>';
                msg += '<spring:message code="sal.alert.msg.penaltyAmount" /> : ' + $('#txtPenaltyCharge').val()    + '<br/>';
                msg += '<spring:message code="sal.text.penaltyAdjustment" /> : '  + $('#txtPenaltyAdj').val().trim()+ '<br/>';
                msg += '<spring:message code="sal.text.totAmt" /> : '             + $('#txtTotalAmount').val()      + '<br/>';
            }
        }
        msg += '<br/><spring:message code="sal.alert.msg.wantToOrdCanc" /><br/><br/>';

        Common.confirm('<spring:message code="sal.title.text.reqCancConfrm" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>", fn_doSaveReqCanc, fn_selfClose);
    }



    function fn_doSaveReqCanc() {
        console.log('!@# fn_doSaveReqCanc START');

        Common.ajax("POST", "/sales/order/eRequestCancelOrder.do", $('#frmReqCanc').serializeJSON(), function(result) {

                Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />' + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_selfClose);

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





    function fn_validReqCanc() {
        var isValid = true, msg = "";

        if($("#cmbRequestor option:selected").index() <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelReq" />';
        }
        if($("#cmbReason option:selected").index() <= 0) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelTheReason" />';
        }
        if(FormUtil.checkReqValue($('#dpCallLogDate'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyInCallLogDt" />';
        }
        if(ORD_STUS_ID == '4' && FormUtil.checkReqValue($('#dpReturnDate'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzKeyInPrfRtnDt" />';
        }
        if(FormUtil.checkReqValue($('#txtRemark'))) {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.pleaseKeyInTheRemark" /><br>';
        }

        if(!isValid) Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }



    function fn_loadListCanc() {
        doGetComboOrder('/common/selectCodeList.do', '52',  'CODE_ID',  '526', 'cmbRequestor', 'S', ''); //Common Code
        doGetComboData('/sales/order/selectResnCodeList.do', {resnTypeId : '536', stusCodeId:'1'}, '1998', 'cmbReason', 'S', 'fn_removeOpt'); //Reason Code
        $("#dpCallLogDate").val((new Date().getDate()+1) +"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#txtRemark").val("CANCEL & REFUND");
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
        Common.popupDiv("/sales/order/eRequestCancellationPop.do", { salesOrderId : ORD_ID, ordReqType : $('#ordReqType').val() }, null , true);
        $('#btnCloseReq').click();
    }



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="hTitle"><spring:message code="sal.page.title.ordReq" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnCloseReq" href="#"><spring:message code="sal.btn.close" /></a></p></li>
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
    <th scope="row"><spring:message code="sal.text.editType" /></th>
    <td>
    <select id="ordReqType" class="mr5">
    <option value="CANC">Cancellation</option></select>
    <p class="btn_sky"><a id="btnEditType" href="#"><spring:message code="sal.btn.confirm" /></a></p>
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
<h3><spring:message code="sales.subTitle.ordCanReqInfo" /></h3>
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
    <th scope="row"><spring:message code="sal.text.requestor" /><span class="must">*</span></th>
    <td>
    <select id="cmbRequestor" name="cmbRequestor" class="w100p " ></select>
    </td>
    <th scope="row"><spring:message code="sal.text.callLogDate" /><span class="must">*</span></th>
    <td><input id="dpCallLogDate" name="dpCallLogDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p " ></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.reason" /><span class="must">*</span></th>
    <td>
    <select id="cmbReason" name="cmbReason" class="w100p " ></select>
    </td>
    <th scope="row"><spring:message code="sal.alert.msg.prefRtrnDt" /><span id="spPrfRtnDt" class="must blind">*</span></th>
    <td><input id="dpReturnDate" name="dpReturnDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" disabled/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ocrRem" /><span class="must">*</span></th>
    <td colspan="3"><textarea id="txtRemark" name="txtRemark" cols="20" rows="5" ></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- Outstanding & Penalty Info Edit START------------------------------------->
<section id="scOP" class="blind">
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.page.subTitle.outstndPnltyInfo" /></h3>
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
    <th scope="row"><spring:message code="sales.totAmt_RM" /></th>
    <td class="bg-black"><span id="spTotalAmount"></span>
    <input id="txtTotalAmount" name="txtTotalAmount" type="hidden" value="0"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.TotalUsedMonth" /></th>
    <td><input id="txtTotalUseMth" name="txtTotalUseMth" type="text" class="w100p readonly" value="0" readonly></td>
    <th scope="row"><spring:message code="sal.text.obligationPeriod" /></th>
    <td><input id="txtObPeriod" name="txtObPeriod" type="text" class="w100p readonly" value="24" readonly></td>
    <th scope="row"><spring:message code="sal.title.text.rentalFees" /></th>
    <td><input id="txtRentalFees" name="txtRentalFees" type="text" value="0" class="w100p readonly" readonly></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.PenaltyCharge" /></th>
    <td><input id="txtPenaltyCharge" name="txtPenaltyCharge" type="text" class="w100p readonly" value="0" readonly></td>
    <th scope="row"><spring:message code="sal.text.penaltyAdjustment" /><span class="must">*</span></th>
    <td><input id="txtPenaltyAdj" name="txtPenaltyAdj" type="text" value="0" title="" placeholder="Penalty Adjustment" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.currOutstnd" /></th>
    <td><input id="txtCurrentOutstanding" name="txtCurrentOutstanding" type="text" value="0" class="w100p readonly" readonly></td>
</tr>
</tbody>
</table><!-- table end -->

</section>
<!-- Outstanding & Penalty Info Edit END--------------------------------------->

</form>
</section><!-- search_table end -->


<ul class="center_btns">
    <li><p class="btn_blue2"><a id="btnReqCancOrder" href="#">Request Cancel</a></p></li>
</ul>
</section>
<!------------------------------------------------------------------------------
    Order Cancellation Request END
------------------------------------------------------------------------------->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->