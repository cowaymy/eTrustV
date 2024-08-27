<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
  var TAB_NM = "${ordReqType}";
  var ORD_ID = "${orderDetail.basicInfo.ordId}";
  var ORD_NO = "${orderDetail.basicInfo.ordNo}";
  var AUX_ORD_ID = "${orderDetail.basicInfo.auxSalesOrdId}";
  var AUX_ORD_NO = "${orderDetail.basicInfo.auxSalesOrdNo}";
  var ORD_DT = "${orderDetail.basicInfo.ordDt}";
  var ORD_STUS_ID = "${orderDetail.basicInfo.ordStusId}";
  var ORD_STUS_CODE = "${orderDetail.basicInfo.ordStusCode}";
  var ORD_STUS_NAME = "${orderDetail.basicInfo.ordStusName}";
  var CUST_ID = "${orderDetail.basicInfo.custId}";
  var CUST_TYPE_ID = "${orderDetail.basicInfo.custTypeId}";
  var CUST_NAME = "${orderDetail.basicInfo.custName}";
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
  var PRGRS_ID = "${orderDetail.logView.prgrsId}";
  var ISSUE_BANK = "${orderDetail.rentPaySetInf.rentPayIssBank}";
  var BANK_ACC_NO = "${orderDetail.rentPaySetInf.rentPayAccNo}";
  var MONTH_REN_FEE = "${orderDetail.basicInfo.mthRentalFees}";
  var BNDL_ID = "${orderDetail.basicInfo.bndlId}";

  var CUST_ADDR_ID = "${orderDetail.basicInfo.ordAddrId}";
  var CUST_CNCT_ID = "${orderDetail.basicInfo.ordCntcId}";

  var _cancleMsg = "Another order :  " + AUX_ORD_NO + "<br/>is also canceled together.<br/><br/>";
  var _requestMsg = "Another order :  " + AUX_ORD_NO + "<br/>is also requested together.<br/><br/>";
  var filterGridID;

  $(document).ready(function() {

    if (FormUtil.isNotEmpty(TAB_NM)) {
      <c:if test="${callCenterYn != 'Y'}">
        if (!fn_checkAccessRequest(TAB_NM))
         return false;
      </c:if>
      fn_changeTab(TAB_NM);
    }

    doGetCombo('/common/selectCodeList.do', '455', '', 'ordReqType', 'S'); //Order Edit Type
    doGetComboSepa('/common/selectBranchCodeList.do', '1', ' - ', '', 'modDscBrnchId', 'S'); //Branch Code

  });

  $(function() {
    $('#btnEditType').click(function() {
      var tabNm = $('#ordReqType').val();
      fn_changeTab(tabNm);
    });

    $('#txtPenaltyAdj').change(function() {
      if (FormUtil.isEmpty($('#txtPenaltyAdj').val().trim())) {
        $('#txtPenaltyAdj').val(0);
      }
      fn_calculatePenaltyAndTotalAmount();
    });

    $('#txtPenaltyAdj').keydown(function(event) {
      if (event.which == 13) { //enter
        if (FormUtil.isEmpty($('#txtPenaltyAdj').val().trim())) {
          $('#txtPenaltyAdj').val(0);
        }
        fn_calculatePenaltyAndTotalAmount();
      }
    });

    $('#btnReqCancOrder').click(function() {
      if (fn_validReqCanc())
        fn_clickBtnReqCancelOrder();
    });

    $('#btnReqCntc').click(function() {
        //if (fn_validReqCanc())
          fn_doSaveReqCnct();
      });

    $('#btnReqInstAddr').click(function() {
        //if (fn_validReqCanc())
          fn_doSaveReqInstAddr();
      });
  });

  function fn_getCheckAccessRight(userId, moduleUnitId) {
    var result = false;
    /*
     Common.ajaxSync("GET", "/sales/order/selectCheckAccessRight.do", {userId : userId, moduleUnitId : moduleUnitId}, function(rsltInfo) {
     if(rsltInfo != null) {
     result = true;
     }
     });
     */
    return true;
  }

  function fn_changeTab(tabNm) {

    var userid = '${SESSION_INFO.userId}';
    var todayDD = Number(TODAY_DD.substr(0, 2));
    var todayYY = Number(TODAY_DD.substr(6, 4));

    var vTit = '<spring:message code="sal.page.title.ordReq" />';

    if($("#ordReqType option:selected").index() > 0) {
     vTit += ' - '+$('#ordReqType option:selected').text();
     }

    $('#hTitle').text(vTit);

    if (tabNm == 5968) {
      if (fn_getCheckAccessRight(userid, 9)) {
        if (ORD_STUS_ID != '1' || APP_TYPE_ID == '5764') { // block if Order status is not active
          var msg = "Order " + ORD_NO + " is under " + ORD_STUS_NAME + " status. <br/>Order cancellation request is disallowed.";
          Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
          return false;
        }

        if (todayDD == 1 || todayDD == 2) { // Block if date on  1 / 2 of the month
          var msg = '<spring:message code="sal.msg.chkCancDate" />';
            Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
            return false;
          }

        $('#scCN').removeClass("blind");
        $('#aTabMI').click();

        fn_loadOrderInfoCanc();

        fn_isLockOrder(tabNm);
      } else {
        var msg = "Sorry. You have no access rights to request order cancellation.";
        Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
        return false;
      }
    }else{
    	$('#scCN').addClass("blind");
    }

    if(tabNm == 5969){ // Contact Number
    	$('#scCP').removeClass("blind");
    	$('#aTabIns').click();
    	fn_isLockOrder(tabNm);
    }else{
    	$('#scCP').addClass("blind");
    }

    if(tabNm == 5970){ // Installation Address
    	$('#scIN').removeClass("blind");
    	$('#aTabIns').click();
    	fn_isLockOrder(tabNm);
    }else{
    	$('#scIN').addClass("blind");
    }

  }

  function fn_isLockOrder(tabNm) {
    var isLock = false;
    var msg = "";
    var ORD_ID = '${orderDetail.logView.salesOrdId}';

    if(tabNm == 5968){
      if (("${orderDetail.logView.isLok}" == '1' && "${orderDetail.logView.prgrsId}" != 2) || "${orderDetail.logView.prgrsId}" == 1) {

  	      if ("${orderDetail.logView.prgrsId}" == 1) {
  	        Common.ajaxSync("GET", "/sales/order/checkeRequestAutoDebitDeduction.do", { salesOrdId : ORD_ID },
  	          function(rsltInfo) {
  	            //Valid eCash Floating Stus - 1
  	            if (rsltInfo.ccpStus == 1 || rsltInfo.eCashStus == 1) {
  	             isLock = true;
  	             msg = 'Order ' + ORD_NO + ' is under eCash deduction progress.<br />' + 'Order cancellation request is disallowed.<br />';
  	           }
  	         });
  	      }
  	      /* else {
              isLock = true;
              msg = 'Order ' + ORD_NO + ' is under ' + "${orderDetail.logView.prgrs}" + ' progress.<br />' + '<br/>'  + 'Order cancellation request is disallowed.<br />';
          } */
  	    }

      //Valid OCR Status - (CallLog Type - 257, Stus - 20, InstallResult Stus - Active )
      Common.ajaxSync("GET", "/sales/order/validRequestOCRStus.do", { salesOrdId : ORD_ID },
        function(result) {
          if (result.callLogResult == 1) {
            isLock = true;
            msg = 'Order ' + ORD_NO + ' is under ready installation status.<br />' + 'Order cancellation request is disallowed.<br/>' + ' Kindly refer CSS Dept via <br /><u>helpme.css@coway.com.my</u> for help.<br />';
          }
        });

      }else if(tabNm == 5969){
    	   if(ORD_STUS_ID == '10'){
    		  isLock = true;
    		  msg = 'Cancelled order is not allowed to do eRequest.<br/>';

    	  }else if(RENTAL_STUS == 'INV' || RENTAL_STUS == 'SUS' || RENTAL_STUS == 'RET' || RENTAL_STUS == 'WOF'  || RENTAL_STUS == 'TER'){
    		  isLock = true;
    		  msg = 'Order under INV/SUS/RET/WOF status is not allowed to perform eRequest<br/>';

    	  }else if (("${orderDetail.logView.isLok}" == '1' && "${orderDetail.logView.prgrsId}" != 2) || "${orderDetail.logView.prgrsId}" == 1
    			  || "${orderDetail.logView.prgrsId}" == 4 || "${orderDetail.logView.prgrsId}" == 11 || "${orderDetail.logView.prgrsId}" == 12 ) {
    		  if ("${orderDetail.logView.prgrsId}" == 1) {
               Common.ajaxSync("GET", "/sales/order/checkeRequestAutoDebitDeduction.do", { salesOrdId : ORD_ID },
                 function(rsltInfo) {
                   if (rsltInfo.ccpStus == 1 || rsltInfo.eCashStus == 1) {
                    isLock = true;
                    msg = 'Order ' + ORD_NO + ' is under eCash deduction progress.<br />' + 'eRequest is disallowed.<br />';
                  }
                });
             }else {
                 isLock = true;
                 msg = 'Order ' + ORD_NO + ' is under ' + "${orderDetail.logView.prgrs}" + ' progress.<br />' + '<br/>'  + 'eRequest is disallowed.<br />';
             }
           }

      }else if(tabNm == 5970){

    	  if(ORD_STUS_ID == '10'){
              isLock = true;
              msg = 'Cancelled order is not allowed to do eRequest.<br/>';

    	  }else if(RENTAL_STUS == 'INV' || RENTAL_STUS == 'SUS' || RENTAL_STUS == 'RET' || RENTAL_STUS == 'WOF'  || RENTAL_STUS == 'TER'){
              isLock = true;
              msg = 'Order under INV/SUS/RET/WOF status is not allowed to perform eRequest<br/>';

          }else if(EX_TRADE > 0 && ORD_STUS_ID != 4){
        	  isLock = true;
              msg = 'Ex-trade/i-Care order (Before Install) is not allowed to do eRequest.<br/>';
          }else if (("${orderDetail.logView.isLok}" == '1' && "${orderDetail.logView.prgrsId}" != 2) || "${orderDetail.logView.prgrsId}" == 1
                  || "${orderDetail.logView.prgrsId}" == 4 || "${orderDetail.logView.prgrsId}" == 11 || "${orderDetail.logView.prgrsId}" == 12 ) {
        	  if ("${orderDetail.logView.prgrsId}" == 1) {
                Common.ajaxSync("GET", "/sales/order/checkeRequestAutoDebitDeduction.do", { salesOrdId : ORD_ID },
                  function(rsltInfo) {
                    if (rsltInfo.ccpStus == 1 || rsltInfo.eCashStus == 1) {
                     isLock = true;
                     msg = 'Order ' + ORD_NO + ' is under eCash deduction progress.<br />' + 'eRequest is disallowed.<br />';
                   }
                 });
              }else {
                  isLock = true;
                  msg = 'Order ' + ORD_NO + ' is under ' + "${orderDetail.logView.prgrs}" + ' progress.<br />' + '<br/>'  + 'eRequest is disallowed.<br />';
                }
            }
      }

    Common.ajaxSync("GET", "/sales/order/selectRequestApprovalList.do", {salesOrdId : ORD_ID, typeId : tabNm, reqStusId : 1}, function(result) {
        if(result.length > 0){
            isLock = true;
            msg = "<spring:message code='sal.alert.msg.existERequest'/>";
        }
    });

    if (isLock) {
      if (tabNm == 5968) {
        fn_disableControlCanc();
      }else if (tabNm == 5969) {
    	  fn_disableControlCnt();
      }else if (tabNm == 5970) {
    	  fn_disableControlIns();
      }

      Common.alert('<spring:message code="sal.alert.msg.ordLock" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
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
  function fn_disableControlIns() {
	  $('#scIN').addClass("blind");
  }
  function fn_disableControlCnt() {
	  $('#scCP').addClass("blind");
  }


  function fn_loadOrderInfoCanc() {
    if (ORD_STUS_ID == '4') {
      $('#spPrfRtnDt').removeClass("blind");
      $('#dpReturnDate').removeAttr("disabled");

      if (APP_TYPE_ID == '66') {
        $('#scOP').removeClass("blind");
      }
    }

    // if(IS_NEW_VER == 'Y') {
    var vObligtPriod = fn_getObligtPriod();

    $('#txtObPeriod').val(vObligtPriod);
    // } else {
    //    if(CNVR_SCHEME_ID == '1') {
    //      $('#txtObPeriod').val('36');
    //    }
    // }

    fn_loadOutstandingPenaltyInfo();
  }

  function fn_loadOutstandingPenaltyInfo() {
    if (APP_TYPE_ID == '66' && ORD_STUS_ID == '4') {

      var vTotalUseMth = fn_getOrderLastRentalBillLedger1();

      if (FormUtil.isNotEmpty(vTotalUseMth)) {
        $('#txtTotalUseMth').val(vTotalUseMth);
      }
      $('#txtRentalFees').val("${orderDetail.basicInfo.ordMthRental}");

      var vCurrentOutstanding = fn_getOrderOutstandingInfo();

      if (FormUtil.isNotEmpty(vCurrentOutstanding)) {
        $('#txtCurrentOutstanding').val(vCurrentOutstanding);
      }

      fn_calculatePenaltyAndTotalAmount();
    }
  }

  function fn_getPenaltyAmt(usedMnth, obPeriod) {
    var vPenaltyAmt = 0;

    Common.ajaxSync("GET", "/sales/order/selectPenaltyAmt.do", {
      salesOrdId : ORD_ID,
      usedMnth : usedMnth,
      obPeriod : obPeriod
    }, function(result) {

      if (result != null) {
        vPenaltyAmt = result.penaltyAmt;
      }
    });

    return vPenaltyAmt;
  }

  function fn_calculatePenaltyAndTotalAmount() {
    var TotalMthUse = Number($('#txtTotalUseMth').val());
    var ObPeriod = Number($('#txtObPeriod').val());
    var RentalFees = Number($('#txtRentalFees').val());
    var currentOutstandingVal = $('#txtCurrentOutstanding').val();

    currentOutstandingVal = currentOutstandingVal.replace(',', '');

    var CurrentOutstanding = parseFloat(currentOutstandingVal);
    var PenaltyAdj = Number($('#txtPenaltyAdj').val());
    var PenaltyAmt = 0;

    if (IS_NEW_VER == 'N') {
      if (TotalMthUse < ObPeriod) {
        PenaltyAmt = ((RentalFees * (ObPeriod - TotalMthUse)) / 2);
      }
    } else {
      PenaltyAmt = fn_getPenaltyAmt(TotalMthUse, ObPeriod);
    }

    $('#txtPenaltyCharge').val(PenaltyAmt);

    var TotalAmt = CurrentOutstanding + PenaltyAmt + PenaltyAdj;

    $('#txtTotalAmount').val(TotalAmt);
    $('#spTotalAmount').text(TotalAmt);
  }

  function fn_getOrderOutstandingInfo() {
    var vCurrentOutstanding = 0;

    Common.ajaxSync("GET", "/sales/order/selectOderOutsInfo.do", {
      ordId : ORD_ID
    }, function(result) {
      if (result != null && result.length > 0) {
        // console.log('result.outSuts[0].ordTotOtstnd:'+result.outSuts[0].ordTotOtstnd);
        vCurrentOutstanding = result[0].ordTotOtstnd;
      }
    });

    return vCurrentOutstanding;
  }

  function fn_getOrderLastRentalBillLedger1() {
    var vTotalUseMth = 0;

    Common.ajaxSync("GET", "/sales/order/selectOrderLastRentalBillLedger1.do", {
          salesOrderId : ORD_ID
        }, function(result) {
          if (result != null) {
            vTotalUseMth = result.rentInstNo;
          }
        });

    return vTotalUseMth;
  }

  function fn_getObligtPriod() {
    var vObligtPriod = 0;

    Common.ajaxSync("GET", "/sales/order/selectObligtPriod.do", {
      salesOrdId : ORD_ID
    }, function(result) {

      if (result != null) {
        vObligtPriod = result.obligtPriod;
      }
    });

    return vObligtPriod;
  }

  function fn_clickBtnReqCancelOrder() {
    var RequestStage = '<spring:message code="sal.text.beforeInstall" />';

    if (ORD_STUS_ID == '4') {
      RequestStage = '<spring:message code="sal.text.afterInstall" />';
    }

    var msg = "";
    //msg += '<spring:message code="sal.title.text.requestStage" /> : ' + RequestStage + '<br />';
    //msg += '<spring:message code="sal.title.text.requestor" /> : '    + $('#cmbRequestor option:selected').text() + '<br />';
    //msg += '<spring:message code="sal.title.text.reason" /> : '       + $('#cmbReason option:selected').text() + '<br />';
    msg += 'Order No.          : ' + ORD_NO + '<br />';
    msg += 'Customer Name : ' + CUST_NAME + '<br />';
    msg += 'Product             : ' + STOCK_DESC + '<br />';
    msg += '<br /><i>Note : Payment amount shall be refunded if any</i> '
        + '' + '<br />';
    //msg += 'Refund Account  : ' + BANK_ACC_NO + '<br />';
    //msg += '<spring:message code="sal.text.callLogDate" /> : '        + $('#dpCallLogDate').val() + '<br />';

    if (ORD_STUS_ID == '4') {
      msg += '<spring:message code="sal.alert.msg.prefRtrnDt" /> : '
          + $('#dpReturnDate').val() + '<br />';

      if (APP_TYPE_ID == 66) {
        msg += '<br />';
        msg += '<spring:message code="sales.TotalUsedMonth" /> : '
            + $('#txtTotalUseMth').val() + '<br/>';
        msg += '<spring:message code="sal.text.obligationPeriod" /> : '
            + $('#txtObPeriod').val() + '<br/>';
        msg += '<spring:message code="sal.alert.msg.penaltyAmount" /> : '
            + $('#txtPenaltyCharge').val() + '<br/>';
        msg += '<spring:message code="sal.text.penaltyAdjustment" /> : '
            + $('#txtPenaltyAdj').val().trim() + '<br/>';
        msg += '<spring:message code="sal.text.totAmt" /> : '
            + $('#txtTotalAmount').val() + '<br/>';
      }
    }

    var ordStat;
    Common.ajaxSync("GET", "/sales/order/chkSalStat.do",{
      ORD_ID : ORD_ID,
      ORD_NO : ORD_NO
    }, function(result) {
      if (result != null) {
        ordStat = result;
      }
    });

    if (ordStat != 1) {
      // ORDER IS NOT ACTIVE
      var msg = "Order " + ORD_NO + " is not under ACTIVE status. <br/>Order cancellation request is disallowed.";
      Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
      return;
    } else {
      // BY PASS - DO NOTHING
    }

    Common.ajaxSync("GET", "/sales/order/chkCboSal.do",{
        ORD_ID : ORD_ID,
        ORD_NO : ORD_NO
      }, function(result) {
        if (result != null) {
          if (result == 0) {
           // IS SUB COMBO
           // SHOULD CHANGE:-
           // CHANGE PROMO CODE AND RENTAL PRICE REMAIN
           msg += '<br/><span style="color:red;font-weight: bold"><spring:message code="sales.msg.chkCboSalMsgAP" /></span>';
         } else if (result == 1) {
           // IS MAIN COMBO
           // SHOULD CHANGE:-
           // CHANGE PROMO CODE AND CHANGE RENTAL PRICE
           msg += '<br/><span style="color:red;font-weight: bold"><spring:message code="sales.msg.chkCboSalMsgWP" /></span>';
         } else {
          // BY PASS - DO NOTHING
         }
       }
    });

    msg += '<br/> <font style="color:red;font-weight: bold">Are you sure want to confirm order cancellation? </font><br/><br/>';

    if (AUX_ORD_NO != "") {
      Common.confirm('<spring:message code="sal.title.text.reqCancConfrm" />' + DEFAULT_DELIMITER + "<b>" + _cancleMsg + msg + "</b>", fn_doSaveReqCanc, fn_selfClose);
    } else {
      Common.confirm('<spring:message code="sal.title.text.reqCancConfrm" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_doSaveReqCanc, fn_selfClose);
    }
  }


  function fn_doSaveReqCanc() {
    Common.ajax("POST", "/sales/order/eRequestCancelOrder.do", $('#frmReqCanc').serializeJSON(), function(result) {
      Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />' + DEFAULT_DELIMITER + "<b>" + result.message + "</b>", fn_selfClose);
    }, function(jqXHR, textStatus, errorThrown) {
      try {
        Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
      } catch (e) {
        console.log(e);
      }
    });
  }

  function fn_doSaveReqCnct() {

	  if($("#modCustCntcId").val() == ""){
          Common.alert("Please select a contact<br/>");
          return;
      }else if($("#modCustCntcId").val() == CUST_CNCT_ID){
          Common.alert("Same contact selected<br/>");
          return;
      }

	  if($("#modRemCntc").val() == ""){
		  Common.alert("Please fill in update reason<br/>");
          return;
	  }

	   var data = {
			    salesOrdId : ORD_ID,
			    auxOrdId : AUX_ORD_ID,
			    rqstTypeId : $("#ordReqType").val(),
			    rqstDataFr : CUST_CNCT_ID,
			    rqstDataTo : $("#modCustCntcId").val(),
			    rqstRem     : $("#modRemCntc").val()
	      };

	   Common.ajax("POST", "/sales/order/eReqEditOrdInfo.do", data, function(result) {
		   if (AUX_ORD_NO != "") {
			   Common.alert('<spring:message code="sal.alert.msg.eReqSum" />' + DEFAULT_DELIMITER + _requestMsg + "<b>" + "eRequest saved." + "</b>", fn_selfClose);
		   }else{
			   Common.alert('<spring:message code="sal.alert.msg.eReqSum" />' + DEFAULT_DELIMITER + "<b>" + "eRequest saved." + "</b>", fn_selfClose);
		   }

	    }, function(jqXHR, textStatus, errorThrown) {
	      try {
	        Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
	      } catch (e) {
	        console.log(e);
	      }
	    });
	}

  function fn_doSaveReqInstAddr() {

	  if($("#modInstCustAddId").val() == ""){
		  Common.alert("Please select a address.<br/>");
		  return;
	  }else if($("#modInstCustAddId").val() == CUST_ADDR_ID){
          Common.alert("Same address selected, please select another.<br/>");
          return;
      }

	  if($("#modRemInstAddr").val() == ""){
          Common.alert("Please fill in update reason<br/>");
          return;
      }

	    var data = {
                salesOrdId : ORD_ID,
                auxOrdId : AUX_ORD_ID,
                rqstTypeId : $("#ordReqType").val(),
                rqstDataFr : CUST_ADDR_ID,
                rqstDataTo : $("#modInstCustAddId").val(),
                rqstRem     : $("#modRemInstAddr").val(),
         };

	   Common.ajax("POST", "/sales/order/eReqEditOrdInfo.do", data , function(result) {
		   if (AUX_ORD_NO != "") {
               Common.alert('<spring:message code="sal.alert.msg.eReqSum" />' + DEFAULT_DELIMITER + _requestMsg + "<b>" + "eRequest saved." + "</b>", fn_selfClose);
           }else{
        	   Common.alert('<spring:message code="sal.alert.msg.eReqSum" />' + DEFAULT_DELIMITER + "<b>" + "eRequest saved." + "</b>", fn_selfClose);
           }
      }, function(jqXHR, textStatus, errorThrown) {
        try {
          Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.</b>");
        } catch (e) {
          console.log(e);
        }
      });
  }

  function fn_validReqCanc() {
    var isValid = true, msg = "";

    /* if($("#cmbRequestor option:selected").index() <= 0) {
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
     } */

    if (!isValid)
      Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_selfClose() {
    $('#btnCloseReq').click();
  }

  function fn_reloadPage() {
    Common.popupDiv("/sales/order/eRequestCancellationPop.do", { salesOrderId : ORD_ID, ordReqType : $('#ordReqType').val() }, null, true);
    $('#btnCloseReq').click();
  }

  function fn_loadInstallAddrInfoNew(custAddId) {
	  var isHomecare = 'N';

	  if(BNDL_ID > 0) isHomecare = 'Y';

	    Common.ajax("GET", "/sales/order/selectInstallAddrInfo.do", {
	      custAddId : custAddId, isHomecare: isHomecare
	    }, function(addrInfo) {

	      if (addrInfo != null) {
	        $("#modInstAddrDtl").text(addrInfo.addrDtl);
	        $("#modInstStreet").text(addrInfo.street);
	        $("#modInstArea").text(addrInfo.area);
	        $("#modInstCity").text(addrInfo.city);
	        $("#modInstPostCd").text(addrInfo.postcode);
	        $("#modInstState").text(addrInfo.city);
	        $("#modInstCnty").text(addrInfo.country);

	        $("#modInstAreaId").val(addrInfo.areaId);
	        $("#modInstCustAddId").val(addrInfo.custAddId);

	        $("#modDscBrnchId").val(addrInfo.brnchId); //DSC Branch

	      }
	    });
	  }

  function fn_loadCntcPerson(custCntcId) {
	Common.ajax("GET","/sales/order/selectCustCntcJsonInfo.do",{custCntcId : custCntcId},function(custCntcInfo) {
		if (custCntcInfo != null) {
			var vInit = FormUtil.isEmpty(custCntcInfo.code) ? "" : custCntcInfo.code;

			$("#modCntcPersonNew").text(vInit + ' ' + custCntcInfo.name1);
			$("#modCntcMobNoNew").text(custCntcInfo.telM1);
			$("#modCntcResNoNew").text(custCntcInfo.telR);
			$("#modCntcOffNoNew").text(custCntcInfo.telO);
			$("#modCntcFaxNoNew").text(custCntcInfo.telf);
			$("#modCustCntcId").val(custCntcInfo.custCntcId);
		}
		});
	}

    $('#btnInstNewAddr').click(function() {
        Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {custId : CUST_ID,callParam : "ORD_MODIFY_INST_ADR"}, null, true);
      });
      $('#btnInstSelAddr').click(function() {
        Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {custId : CUST_ID,callPrgm : "ORD_MODIFY_INST_ADR"}, null, true);
      });

    $('#btnNewCntc').click(function() {
      Common.popupDiv("/sales/customer/updateCustomerNewContactPop.do", {custId : CUST_ID,callParam : "ORD_MODIFY_CNTC_OWN"}, null, true);
      });
    $('#btnSelCntc').click(function() {
      Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {custId : CUST_ID,callPrgm : "ORD_MODIFY_CNTC_OWN"}, null, true);
    });

</script>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1 id="hTitle">
      <spring:message code="sal.page.title.ordReq" />
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2">
          <a id="btnCloseReq" href="#"> <spring:message code="sal.btn.close" /></a>
        </p></li>
    </ul>
  </header>
  <section class="pop_body">
    <section class="search_table">
      <form action="#" method="post">
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 110px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code="sal.text.editType" /></th>
              <td><select id="ordReqType" class="mr5"></select>
                <p class="btn_sky">
                  <a id="btnEditType" href="#"> <spring:message code="sal.btn.confirm" /></a>
                </p></td>
            </tr>
          </tbody>
        </table>
      </form>
    </section>
    <!------------------------------------------------------------------------------
    Order Detail Page Include START
    ------------------------------------------------------------------------------->
    <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
    <!------------------------------------------------------------------------------
    Order Detail Page Include END
    ------------------------------------------------------------------------------->
    <!------------------------------------------------------------------------------
    Order Cancellation Request START
    ------------------------------------------------------------------------------->
    <section id="scCN" class="blind">
      <aside class="title_line">
        <%-- <h3><spring:message code="sales.subTitle.ordCanReqInfo" /></h3> --%>
      </aside>
      <section class="search_table">
        <form id="frmReqCanc" action="#" method="post">
          <input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" /> <input name="auxOrdId" type="hidden" value="${orderDetail.basicInfo.auxSalesOrdId}" /> <input name="auxAppType" type="hidden" value="${orderDetail.basicInfo.auxAppType}" />
          <!------------------------------------------------------------------------------
             Outstanding & Penalty Info Edit START
           ------------------------------------------------------------------------------->
          <section id="scOP" class="blind">
            <aside class="title_line">
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
                  <td class="bg-black"><span id="spTotalAmount"></span> <input id="txtTotalAmount" name="txtTotalAmount" type="hidden" value="0" /></td>
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
            </table>
          </section>
          <!------------------------------------------------------------------------------
             Outstanding & Penalty Info Edit END
           ------------------------------------------------------------------------------->
        </form>
      </section>
      <ul class="center_btns">
        <li><p class="btn_blue2">
            <a id="btnReqCancOrder" href="#"><spring:message code="sal.text.reqCancOrd" /></a>
          </p></li>
      </ul>
    </section>
    <!------------------------------------------------------------------------------
    Order Cancellation Request END
    ------------------------------------------------------------------------------->
    <!------------------------------------------------------------------------------
    Contact Person Edit START
------------------------------------------------------------------------------->
    <section id="scCP" class="blind">
      <!-- title_line end -->
      <aside class="title_line">
        <h3>
          <spring:message code="sal.page.title.custContact" />
        </h3>
      </aside>
      <ul class="right_btns mb10">
        <li><p class="btn_grid">
            <a id="btnNewCntc" href="#"><spring:message code="sal.btn.addNewContact" /></a>
          </p></li>
        <li><p class="btn_grid">
            <a id="btnSelCntc" href="#"><spring:message code="sal.title.text.selContactPerson" /></a>
          </p></li>
      </ul>
      <section class="search_table">
        <!-- search_table start -->
        <form id="frmCntcPer" method="post">
          <input name="salesOrdId" type="hidden" value="${salesOrderId}" />
          <input id="modCustId2" name="custId" type="hidden" />
          <input id="modCustCntcId" name="custCntcId" type="hidden" />
          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width: 150px" />
              <col style="width: *" />
              <col style="width: 180px" />
              <col style="width: *" />
            </colgroup>
          </table>
          <!-- table end -->
          <aside class="title_line">
            <!-- title_line start -->
            <h2>
              <spring:message code="sal.btn.newContactPerson" />
            </h2>
          </aside>
          <!-- title_line end -->
          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width: 150px" />
              <col style="width: *" />
              <col style="width: 180px" />
              <col style="width: *" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row"><spring:message code="sal.text.contactPerson" /></th>
                <td colspan="3"><span id="modCntcPersonNew"></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.title.text.mobNumber" /></th>
                <td><span id="modCntcMobNoNew"></span></td>
                <th scope="row"><spring:message code="sal.title.text.officeNumber" /></th>
                <td><span id="modCntcOffNoNew"></span></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.title.text.residenceNumber" /></th>
                <td><span id="modCntcResNoNew"></span></td>
                <th scope="row"><spring:message code="sal.title.text.faxNumber" /></th>
                <td><span id="modCntcFaxNoNew"></span></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.title.text.reasonUpdate" /><span class="must">*</span></th>
                <td colspan="3"><textarea id="modRemCntc" name="modRemCntc" cols="20" rows="5"></textarea></td>
              </tr>
            </tbody>
          </table>
          <!-- table end -->
          <!-- </form> -->
      </section>
      <!-- search_table end -->
      <ul class="center_btns">
        <li><p class="btn_blue2 big">
            <a id="btnReqCntc" href="#"><spring:message code="sal.btn.save" /></a>
          </p></li>
      </ul>
    </section>
    <!------------------------------------------------------------------------------
    Contact Person Edit END
------------------------------------------------------------------------------->
    <!------------------------------------------------------------------------------
    Installation Edit START
------------------------------------------------------------------------------->
    <section id="scIN" class="blind">
      <aside class="title_line">
        <!-- title_line start -->
        <h3>
          <spring:message code="sal.text.instAddr" />
        </h3>
      </aside>
      <!-- title_line end -->
      <ul class="right_btns mb10">
        <li><p class="btn_grid">
            <a id="btnInstNewAddr" href="#"><spring:message code="sal.btn.addNewAddr" /></a>
          </p></li>
        <li><p class="btn_grid">
            <a id="btnInstSelAddr" href="#"><spring:message code="sal.title.text.selectAnotherAddress" /></a>
          </p></li>
      </ul>
      <section class="search_table">
        <!-- search_table start -->
        <form id="frmInstInfo" method="post">
          <input name="salesOrdId" type="hidden" value="${salesOrderId}" />
          <input name="salesOrdNo" type="hidden" value="${salesOrderNo}" />
          <!-- Install Address Info                                                    -->
          <input id="modInstCustAddId" name="custAddId" type="hidden" />
          <input id="modInstAreaId" name="areaId" type="hidden" />
          <!-- Install Contact Info                                                    -->
          <input id="modInstCustCntcId" name="custCntcId" type="hidden" />
          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width: 150px" />
              <col style="width: *" />
              <col style="width: 150px" />
              <col style="width: *" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
                <td colspan="3"><span id="modInstAddrDtl"></span></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.text.street" /></th>
                <td colspan="3"><span id="modInstStreet"></span></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.text.area" /></th>
                <td colspan="3" id="modInstArea"><span></span></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.text.city" /></th>
                <td><span id="modInstCity"></span></td>
                <th scope="row"><spring:message code="sal.text.postCode" /></th>
                <td><span id="modInstPostCd"></span></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.text.state" /></th>
                <td><span id="modInstState"></span></td>
                <th scope="row"><spring:message code="sal.text.country" /></th>
                <td><span id="modInstCnty"></span></td>
              </tr>
              <tr>
                  <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
                  <td colspan="3"><select id="modDscBrnchId" name="modDscBrnchId" class="w50p" disabled></select></td>
              </tr>
              <tr>
                   <th scope="row"><spring:message code="sal.title.text.reasonUpdate" /><span class="must">*</span></th>
                   <td colspan="3"><textarea id="modRemInstAddr" name="modRemInstAddr" cols="20" rows="5"></textarea></td>
              </tr>
            </tbody>
          </table>
          <!-- table end -->
        </form>
      </section>
      <!-- search_table end -->
      <ul class="center_btns">
        <li><p class="btn_blue2">
            <a id="btnReqInstAddr" href="#"><spring:message code="sal.btn.save" /></a>
          </p></li>
      </ul>
    </section>
    <!------------------------------------------------------------------------------
    Installation Edit END
------------------------------------------------------------------------------->
  </section>
</div>