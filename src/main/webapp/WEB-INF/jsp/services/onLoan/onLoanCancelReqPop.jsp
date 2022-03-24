<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  var TAB_NM = "${ordReqType}";
  var ORD_ID = "${orderDetail.basicInfo.ordId}";
  var ORD_NO = "${orderDetail.basicInfo.ordNo}";
  var ORD_DT = "${orderDetail.basicInfo.ordDt}";
  var ORD_STUS_ID = "${orderDetail.basicInfo.ordStusId}";
  var ORD_STUS_CODE = "${orderDetail.basicInfo.ordStusCode}";
  var CUST_ID = "${orderDetail.basicInfo.custId}";
  var CUST_TYPE_ID = "${orderDetail.basicInfo.custTypeId}";
  var APP_TYPE_ID = "${orderDetail.basicInfo.appTypeId}";
  var APP_TYPE_DESC = "${orderDetail.basicInfo.appTypeDesc}";
  var CUST_NRIC = "${orderDetail.basicInfo.custNric}";
  var PROMO_ID = "${orderDetail.basicInfo.ordPromoId}";
  var PROMO_CODE = "${orderDetail.basicInfo.ordPromoCode}";
  var PROMO_DESC = "${orderDetail.basicInfo.ordPromoDesc}";
  var STOCK_ID = "${orderDetail.basicInfo.stockId}";
  var STOCK_DESC = "${orderDetail.basicInfo.stockDesc}";
  var CNVR_SCHEME_ID = "${orderDetail.basicInfo.cnvrSchemeId}";
  var RENTAL_STUS = "${orderDetail.basicInfo.rentalStus}";
  var EMP_CHK = "${orderDetail.basicInfo.empChk}";
  var EX_TRADE = "${orderDetail.basicInfo.exTrade}";
  var TODAY_DD = "${toDay}";
  var SRV_PAC_ID = "${orderDetail.basicInfo.srvPacId}";
  var GST_CHK = "${orderDetail.basicInfo.gstChk}";
  var IS_NEW_VER = "${orderDetail.isNewVer}";
  var txtPrice_uc_Value = "${orderDetail.basicInfo.ordAmt}";
  var txtPV_uc_Value = "${orderDetail.basicInfo.ordPv}";

  var filterGridID;

  $(document).ready(function() {
	  <%-- doGetComboData('/common/selectCodeList.do', {
      groupCode : '348'
    }, TAB_NM, 'ordReqType', 'S'); //Order Edit Type

    if (FormUtil.isNotEmpty(TAB_NM)) {
      <c:if test="${callCenterYn != 'Y'}">
        if(!fn_checkAccessRequest(TAB_NM)) return false;
      </c:if>
      fn_changeTab(TAB_NM);
    } --%>

    // j_date
    var dateToday = new Date();
    var pickerOpts = { changeMonth:true,
                       changeYear:true,
                       dateFormat: "dd/mm/yy",
                       minDate: dateToday
                     };

    $("#dpCallLogDate").datepicker(pickerOpts);
  });

  $(function() {
    $('#btnEditType').click(function() {
      var tabNm = $('#ordReqType').val();
      fn_changeTab(tabNm);
    });
    $('#btnReqCancOrder').click(function() {
      if (fn_validReqCanc())
        fn_clickBtnReqCancelOrder();
    });
  });

  function fn_changeTab(tabNm) {

    var userid = fn_getLoginInfo();
    var todayDD = Number(TODAY_DD.substr(0, 2));
    var todayYY = Number(TODAY_DD.substr(6, 4));

    if (tabNm == 'CANC') {

        if (ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
          //                  var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>Order cancellation request is disallowed.";
          msg = '<spring:message code="sal.msg.underOrdCanc" arguments="'+ORD_NO+';'+ORD_STUS_CODE+'" argumentSeparator=";"/>';

          Common.alert(
              '<spring:message code="sal.alert.msg.actionRestriction" />'
                  + DEFAULT_DELIMITER + "<b>" + msg + "</b>",
              fn_selfClose);
          return false;
        }
        if (todayYY >= 2018) {
          if (todayDD == 26 || todayDD == 27 || todayDD == 1
              || todayDD == 2) {
            var msg = '<spring:message code="sal.msg.chkCancDate" />';
            Common.alert(
                '<spring:message code="sal.alert.msg.actionRestriction" />'
                    + DEFAULT_DELIMITER + "<b>" + msg
                    + "</b>", fn_selfClose);
            return false;
          }
        }
    }

    var vTit = '<spring:message code="service.title.request.cancel" />';

   /*  if ($("#ordReqType option:selected").index() > 0) {
      vTit += ' - ' + $('#ordReqType option:selected').text();
    } */

    $('#hTitle').text(vTit);

    if (tabNm == 'CANC') {
      $('#scCN').removeClass("blind");
      $('#aTabMI').click();
      console.log('call fn_loadListCanc');
      fn_loadListCanc();

     // fn_loadOrderInfoCanc();

      fn_isLockOrder(tabNm);
    } else {
      $('#scCN').addClass("blind");
    }
  }

  function fn_getLoginInfo() {
	    var userId = 0;

	    Common.ajaxSync("GET", "/sales/order/loginUserId.do", '', function(
	        rsltInfo) {
	      if (rsltInfo != null) {
	        userId = rsltInfo.userId;
	      }
	      console.log('fn_getLoginInfo userid:' + userId);
	    });

	    return userId;
	  }

  function fn_isLockOrder(tabNm) {
    var isLock = false;
    var msg = "";
    var ORD_ID = '${orderDetail.logView.salesOrdId}';
    //BY KV order installation no yet complete (CallLog Type - 257, CCR0001D - 20, SAL00046 - Active )
    Common
        .ajaxSync(
            "GET",
            "/sales/order/validOCRStus.do",
            {
              salesOrdId : ORD_ID
            },
            function(result) {
              if (result.callLogResult == 1) {
                isLock = true;
                msg = 'This order is under progress [ Call for Install ].<br />'
                    + result.msg + '.<br/>';
              }
            });

    /*BY KV - waiting call for installation, cant do product return , ccr0006d active but SAL0046D no record */
    //Valid OCR Status - (CallLog Type - 257, CCR0001D - 1, SAL00046 - NO RECORD  )
    Common
        .ajaxSync(
            "GET",
            "/sales/order/validOCRStus2.do",
            {
              salesOrdId : ORD_ID
            },
            function(result) {
              if (result.callLogResult == 1) {
                isLock = true;
                msg = 'This order is under progress [ Call for Install ].<br />'
                    + result.msg + '.<br/>';
              }
            });

    //BY KV -order cancellation no yet complete sal0020d)
    Common.ajaxSync("GET", "/sales/order/validOCRStus3.do", {
      salesOrdId : ORD_ID
    }, function(result) {
      if (result.callLogResult == 1) {
        isLock = true;
        msg = 'This order is under progress [ Call for Cancel ].<br />'
            + result.msg + '.<br/>';
      }
    });

    //By KV - Valid OCR Status - (CallLog Type - 259, SAL0020D - 32 LOG0038D Stus - Active )
    Common
        .ajaxSync(
            "GET",
            "/sales/order/validOCRStus4.do",
            {
              salesOrdId : ORD_ID
            },
            function(result) {
              if (result.callLogResult == 1) {
                isLock = true;
                msg = 'This order is under progress [Confirm To Cancel ].<br />'
                    + result.msg + '.<br/>';
              }
            });

    if (isLock) {
      if (tabNm == 'CANC') {
        msg += '<spring:message code="sal.alert.msg.cancDisallowed" />';
        fn_disableControlCanc();
      }
      Common.alert('<spring:message code="sal.alert.msg.ordLock" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }
    return isLock;
  }

  function fn_loadListCanc() {
	    //doGetComboOrder('/common/selectCodeList.do', '52', 'CODE_ID', '', 'cmbRequestor', 'S', ''); //Common Code
	    doGetComboOrder('/sales/order/selectCodeList.do', '52', 'CODE_ID', '', 'cmbRequestor', 'S', ''); //Common Code
	    doGetComboData('/sales/order/selectResnCodeList.do', {
	      resnTypeId : '536',
	      stusCodeId : '1'
	    }, '', 'cmbReason', 'S', 'fn_removeOpt'); //Reason Code
	  }

  function fn_removeOpt() {
	    $('#cmbReason').find("option").each(
	        function() {
	          if ($(this).val() == '1638' || $(this).val() == '1979'
	              || $(this).val() == '1980'
	              || $(this).val() == '1994') {
	            $(this).remove();
	          }
	        });
	  }

  function fn_clickBtnReqCancelOrder() {
    var RequestStage = '<spring:message code="sal.text.beforeInstall" />';

    if (ORD_STUS_ID == '4') {
      RequestStage = '<spring:message code="sal.text.afterInstall" />';
    }

    var msg = "";
    // CHECK COMBO PACKAGE
    Common.ajaxSync("GET", "/sales/order/chkCboSal.do", {ORD_ID : ORD_ID, ORD_NO : ORD_NO},
      function(result) {
        if (result != null) {
          if (result == 0) {
            // IS SUB COMBO
            // SHOULD CHANGE:-
            // CHANGE PROMO CODE AND RENTAL PRICE REMAIN
            msg += '<span style="color:red;font-weight: bold"><spring:message code="sales.msg.chkCboSalMsgAP" /></span><br/>';
          } else if (result == 1) {
            // IS MAIN COMBO
            // SHOULD CHANGE:-
            // CHANGE PROMO CODE AND CHANGE RENTAL PRICE
            msg += '<span style="color:red;font-weight: bold"><spring:message code="sales.msg.chkCboSalMsgWP" /></span><br/>';
          } else {
            // BY PASS - DO NOTHING
          }
        }
      });

    msg += '<spring:message code="sal.title.text.requestStage" /> : '
        + RequestStage + '<br />';
    msg += '<spring:message code="sal.title.text.requestor" /> : '
        + $('#cmbRequestor option:selected').text() + '<br />';
    msg += '<spring:message code="sal.title.text.reason" /> : '
        + $('#cmbReason option:selected').text() + '<br />';
    msg += '<spring:message code="sal.text.callLogDate" /> : '
        + $('#dpCallLogDate').val() + '<br />';

    if (ORD_STUS_ID == '4') {
      msg += '<spring:message code="sal.alert.msg.prefRtrnDt" /> : '
          + $('#dpReturnDate').val() + '<br />';

    }

    msg += '<br/><spring:message code="sal.alert.msg.wantToOrdCanc" /><br/><br/>';

    Common.confirm('<spring:message code="sal.title.text.reqCancConfrm" />'
        + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_doSaveReqCanc,
        fn_selfClose);
  }

  function fn_validReqCanc() {
	    var isValid = true, msg = "";

	    if ($("#cmbRequestor option:selected").index() <= 0) {
	      isValid = false;
	      msg += '<spring:message code="sal.alert.msg.plzSelReq" />';
	    }
	    if ($("#cmbReason option:selected").index() <= 0) {
	      isValid = false;
	      msg += '<spring:message code="sal.alert.msg.plzSelTheReason" />';
	    }
	    if (FormUtil.checkReqValue($('#dpCallLogDate'))) {
	      isValid = false;
	      msg += '<spring:message code="sal.alert.msg.plzKeyInCallLogDt" />';
	    }
	    if (ORD_STUS_ID == '4' && FormUtil.checkReqValue($('#dpReturnDate'))) {
	      isValid = false;
	      msg += '<spring:message code="sal.alert.msg.plzKeyInPrfRtnDt" />';
	    }
	    if (FormUtil.checkReqValue($('#txtRemark'))) {
	      isValid = false;
	      msg += '* <spring:message code="sal.alert.msg.pleaseKeyInTheRemark" /><br>';
	    }

	    if (!isValid)
	      Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />'
	          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

	    return isValid;
	  }

  function fn_doSaveReqCanc() {
    console.log('!@# fn_doSaveReqCanc START');

    Common.ajax("POST", "/sales/order/requestCancelOrder.do", $(
        '#frmReqCanc').serializeJSON(), function(result) {

      Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />'
          + DEFAULT_DELIMITER + "<b>" + result.message + "</b>",
          fn_selfClose);

    }, function(jqXHR, textStatus, errorThrown) {
      try {
        //                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
        console.log("Error message : " + jqXHR.responseJSON.message);
        Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER
            + "<b>Saving data prepration failed.</b>");
      } catch (e) {
        console.log(e);
      }
    });
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

  function fn_selfClose() {
    $('#btnCloseReq').click();
  }

  function fn_reloadPage() {
    Common.popupDiv("/services/onLoan/cancelReqPop.do", {
      salesOrderId : ORD_ID,
      ordReqType : $('#ordReqType').val()
    }, null, true);
    $('#btnCloseReq').click();
  }


</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1 id="hTitle">
   <spring:message code="service.title.request.cancel" />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="btnCloseReq" href="#"><spring:message
       code="sal.btn.close" /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" method="post">
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 110px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code="sal.text.editType" /></th>
       <td><select id="ordReqType" name="ordReqType" class="mr5">
            <option value="CANC">Cancellation</option>
        </select>
        <p class="btn_sky">
         <a id="btnEditType" href="#"><spring:message
           code="sal.btn.confirm" /></a>
        </p></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <!------------------------------------------------------------------------------
     On-Loan Order Detail Page Include START
    ------------------------------------------------------------------------------->
  <%@ include file="/WEB-INF/jsp/services/onLoan/onLoanOrderDtlContent.jsp"%>
  <!------------------------------------------------------------------------------
     Order Detail Page Include END
    ------------------------------------------------------------------------------->
  <!------------------------------------------------------------------------------
     Order Cancellation Request START
    ------------------------------------------------------------------------------->
  <section id="scCN" class="blind">
   <aside class="title_line">
    <!-- title_line start -->
    <h3>
     <spring:message code="sales.subTitle.ordCanReqInfo" />
    </h3>
   </aside>
   <!-- title_line end -->
   <section class="search_table">
    <!-- search_table start -->
    <form id="frmReqCanc" action="#" method="post">
     <input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
     <input name="loanOrdId" type="hidden" value="${orderDetail.basicInfo.loanOrdId}" />
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 180px" />
       <col style="width: *" />
       <col style="width: 180px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code="sal.text.requestor" /><span
         class="must"> *</span></th>
        <td><select id="cmbRequestor" name="cmbRequestor"
         class="w100p"></select></td>
        <th scope="row"><spring:message code="sal.text.callLogDate" /><span
         class="must"> *</span></th>
        <td><input id="dpCallLogDate" name="dpCallLogDate"
         type="text" title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date w100p" /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.reason" /><span
         class="must">*</span></th>
        <td><select id="cmbReason" name="cmbReason" class="w100p"></select>
        </td>
        <th scope="row"><spring:message
          code="sal.alert.msg.prefRtrnDt" /><span id="spPrfRtnDt"
         class="must blind">*</span></th>
        <td><input id="dpReturnDate" name="dpReturnDate"
         type="text" title="Create start Date" placeholder="DD/MM/YYYY"
         class="j_date w100p" disabled /></td>
       </tr>
       <tr>
        <th scope="row"><spring:message code="sal.text.ocrRem" /><span
         class="must">*</span></th>
        <td colspan="3"><textarea id="txtRemark" name="txtRemark"
          cols="20" rows="5"></textarea></td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
     <!-- Outstanding & Penalty Info Edit START------------------------------------->
     <section id="scOP" class="blind">
      <aside class="title_line">
       <!-- title_line start -->
       <h3>
        <spring:message code="sal.page.subTitle.outstndPnltyInfo" />
       </h3>
      </aside>
      <!-- title_line end -->
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
       </colgroup>
       <tbody>
        <tr>
         <td colspan="4"></td>
         <th scope="row"><spring:message code="sales.totAmt_RM" /></th>
         <td class="bg-black"><span id="spTotalAmount"></span> <input
          id="txtTotalAmount" name="txtTotalAmount" type="hidden"
          value="0" /></td>
        </tr>
        <tr>
         <th scope="row"><spring:message
           code="sales.TotalUsedMonth" /></th>
         <td><input id="txtTotalUseMth" name="txtTotalUseMth"
          type="text" class="w100p readonly" value="0" readonly></td>
         <th scope="row"><spring:message
           code="sal.text.obligationPeriod" /></th>
         <td><input id="txtObPeriod" name="txtObPeriod" type="text"
          class="w100p readonly" value="24" readonly></td>
         <th scope="row"><spring:message
           code="sal.title.text.rentalFees" /></th>
         <td><input id="txtRentalFees" name="txtRentalFees"
          type="text" value="0" class="w100p readonly" readonly></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code="sales.PenaltyCharge" /></th>
         <td><input id="txtPenaltyCharge" name="txtPenaltyCharge"
          type="text" class="w100p readonly" value="0" readonly></td>
         <th scope="row"><spring:message
           code="sal.text.penaltyAdjustment" /><span class="must">*</span></th>
         <td><input id="txtPenaltyAdj" name="txtPenaltyAdj"
          type="text" value="0" title=""
          placeholder="Penalty Adjustment" class="w100p" /></td>
         <th scope="row"><spring:message
           code="sal.text.currOutstnd" /></th>
         <td><input id="txtCurrentOutstanding"
          name="txtCurrentOutstanding" type="text" value="0"
          class="w100p readonly" readonly></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
     </section>
     <!-- Outstanding & Penalty Info Edit END--------------------------------------->
    </form>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnReqCancOrder" href="#"><spring:message
        code="sal.text.reqCancOrd" /></a>
     </p></li>
   </ul>
  </section>
  <!------------------------------------------------------------------------------
     Order Cancellation Request END
    ------------------------------------------------------------------------------->

 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->