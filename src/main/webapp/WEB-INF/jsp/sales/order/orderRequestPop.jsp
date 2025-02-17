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
  var CUST_NAME = "${orderDetail.basicInfo.custName}";
  var CUST_TYPE_ID = "${orderDetail.basicInfo.custTypeId}";
  var APP_TYPE_ID = "${orderDetail.basicInfo.appTypeId}";
  var APP_TYPE_DESC = "${orderDetail.basicInfo.appTypeDesc}";
  var CUST_NRIC = "${orderDetail.basicInfo.custNric}";
  var PROMO_ID = "${orderDetail.basicInfo.ordPromoId}";
  var PROMO_CODE = "${orderDetail.basicInfo.ordPromoCode}";
  var PROMO_DESC = "${orderDetail.basicInfo.ordPromoDesc}";
  var STOCK_ID = "${orderDetail.basicInfo.stockId}";
  var STOCK_CDE = "${orderDetail.basicInfo.stockCode}";
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
  var custStatusId = "${orderDetail.basicInfo.custStatusId}";
  var salesOrdIdOld = "${orderDetail.basicInfo.salesOrdIdOld}";
  var SRV_TYPE = "${orderDetail.orderCfgInfo.srvType}";

  var preSrvType = "";
  var totPvSs = "";

  var myFileCaches = {};
  var atchFileGrpId = 0;

  var filterGridID;
  var globalCmbFlg = 0; // VARIABLE FOR COMBO PACKAGE PROMOTION FLAG. 0 > NOT COMBO PROMO. 1 > IS COMBO PROMO.

  var voucherAppliedStatus = 0;
  var voucherAppliedCode = "";
  var voucherAppliedEmail = "";
  var voucherPromotionId = [];

  var codeList_562 = [];
  codeList_562.push({codeId:"0", codeName:"No", code:"No"});
  <c:forEach var="obj" items="${codeList_562}">
  codeList_562.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  </c:forEach>

  $(document).ready(function() {
    doGetComboData('/common/selectCodeList.do', {
      groupCode : '348'
    }, TAB_NM, 'ordReqType', 'S'); //Order Edit Type

    doDefCombo(codeList_562, '0', 'voucherTypeAexc', 'S', 'displayVoucherSectionAexc');    // Voucher Type Code
    doDefCombo(codeList_562, '0', 'voucherTypePrdEx', 'S', 'displayVoucherSectionPrdEx');    // Voucher Type Code

    if(salesOrdIdOld != null || salesOrdIdOld != '' || salesOrdIdOld != '0'){
    	//checkExtradePreBookEligible(CUST_ID,salesOrdIdOld); //REMOVE PREBOOK
    	checkOldOrderServiceExpiryMonth(CUST_ID,salesOrdIdOld);
    }else{
    	$('#hiddenPreBook').val('0');
    	$('#hiddenMonthExpired').val('0');
    }

    if (FormUtil.isNotEmpty(TAB_NM)) {
		var isValid = true;
		if (window["fn_checkAccessRequest"]) {
			isValid = fn_checkAccessRequest(TAB_NM);
		}
		if (!isValid) {
			return false;
		} else {
			fn_changeTab(TAB_NM);
		}
    }

    fn_resetPreSrvType();

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
		var isValid = true;
		if (window["fn_checkAccessRequest"]) {
			isValid = fn_checkAccessRequest(tabNm);
		}
		if (!isValid) {
			return false;
		} else {
			fn_changeTab(tabNm);
		}
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

    $('#btnReqPrdExch').click(function() {
      if (fn_validReqPexc())
        //fn_doSaveReqPexc();
    	  Common.popupDiv("/sales/order/cnfmProductExchangeDetailPop.do");
    });

    $('#btnReqSchmConv').click(function() {
      // fn_doSaveReqSchm();
      Common.popupDiv("/sales/order/schemConvPop.do", '');
    });

    $('#btnReqAppExch').click(function() {
      if (!fn_isLockOrder('AEXC')) {
        if (fn_validReqAexc())
          fn_doSaveReqAexc();
      }
    });

    $('#cmbOrderProduct').change(
      function() {
        if (FormUtil.isEmpty($('#cmbOrderProduct').val())) {
          $('#cmbPromotion option').remove();
          return;
        }
        fn_resetPreSrvType();
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

        var stkIdVal = $("#cmbOrderProduct").val();

        if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
          SRV_PAC_ID = 0;
        }

        if ($("#cmbOrderProduct option:selected").index() > 0) {
          fn_loadProductPrice(APP_TYPE_ID, stkIdVal, SRV_PAC_ID);
          fn_loadProductPromotion(APP_TYPE_ID, stkIdVal, EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
          $('#btnCurrentPromo').removeAttr("disabled");

          if (GST_CHK == '1') {
            fn_excludeGstAmt();
          }
        }
      });

    $('#cmbPromotion').change(function() {
      var stkIdVal = $("#cmbOrderProduct").val();
      var promoIdIdx = $("#cmbPromotion option:selected").index();
      var promoIdVal = $("#cmbPromotion").val();

      if (promoIdIdx > 0 && promoIdVal != '0') {
        fn_loadPromotionPrice(promoIdVal, stkIdVal, SRV_PAC_ID);
      } else {
        fn_loadProductPrice(APP_TYPE_ID, stkIdVal, SRV_PAC_ID);
      }

      if (GST_CHK == '1') {
        fn_excludeGstAmt();
      }
    });

    $('#btnCurrentPromo').click(
        function(event) {
          if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
            SRV_PAC_ID = 0;
          }

          $('#cmbPromotion').val('').removeAttr("disabled");
          if ($('#btnCurrentPromo').is(":checked")) {
            $('#cmbPromotion').prop("disabled", true);
            if ($('#hiddenCurrentPromotionID').val() > 0) {
              //$('#cmbPromotion').text($('#hiddenCurrentPromotion').val());
              $('#cmbPromotion option').remove();
              $('#cmbPromotion').append("<option value='"+ $("#hiddenCurrentPromotionID").val() + "'>" + $('#hiddenCurrentPromotion').val() + "</option>");
              fn_loadPromotionPrice($("#hiddenCurrentPromotionID").val(), $("#cmbOrderProduct").val(), SRV_PAC_ID);
            } else {
              fn_loadProductPrice(APP_TYPE_ID, $("#cmbOrderProduct").val(), SRV_PAC_ID);
              fn_loadProductPromotion(APP_TYPE_ID, $("#cmbOrderProduct").val(), EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
            }
          } else {
            fn_loadProductPrice(APP_TYPE_ID, $("#cmbOrderProduct").val(), SRV_PAC_ID);
            fn_loadProductPromotion(APP_TYPE_ID, $("#cmbOrderProduct").val(), EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
          }

          if (GST_CHK == '1') {
            fn_excludeGstAmt();
          }
        });

    $('#cmbAppTypeAexc').change(function() {
      var appSubType = '';
      if ($('#cmbAppTypeAexc').val() == '66') {
        appSubType = '367';
      } else if ($('#cmbAppTypeAexc').val() == '67') {
        appSubType = '368';
      } else if ($('#cmbAppTypeAexc').val() == '68') {
        appSubType = '369';
      } else {
        $('#srvPacIdAexc option').remove();
      }

      if (appSubType != '') {
        doGetComboData('/common/selectCodeList.do', { groupCode : appSubType }, '', 'srvPacIdAexc', 'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
      }

      $('#txtInstallmentDurationAexc').addClass("blind");
      $("#txtInstallmentDurationAexc").val('').prop("disabled", true);

      $('#cmbPromotionAexc option').remove();

      //$("#txtPriceAexc").val('');
      //$("#txtPVAexc").val('');

      if ($("#cmbAppTypeAexc option:selected").index() > 0) {
        if ($("#cmbAppTypeAexc").val() == '68') {
          $('#txtInstallmentDurationAexc').removeClass("blind");
          $('#txtInstallmentDurationAexc').removeAttr("disabled");
        }

        $('#cmbPromotionAexc').removeAttr("disabled");
        $('#txtPriceAexc').removeAttr("disabled");
        $('#txtPVAexc').removeAttr("disabled");

        //this.LoadPromotionPrice(int.Parse(cmbPromotion.SelectedValue), int.Parse(hiddenProductID.Value));
        //fn_loadPromotionPriceAexc($('#cmbPromotionAexc').val(), STOCK_ID);
      }
    });

    $('#cmbPromotionAexc').change(
        function() {
          var promoIdIdx = $("#cmbPromotionAexc option:selected").index();
          var promoIdVal = $("#cmbPromotionAexc").val();

          if ($("#cmbAppTypeAexc").val() == 67 || $("#cmbAppTypeAexc").val() == 68) {
            SRV_PAC_ID = 0;
          } else {
            SRV_PAC_ID = $("#srvPacIdAexc").val();
          }

          if (promoIdIdx > 0 && promoIdVal != '0') {
            fn_loadPromotionPriceAexc($('#cmbPromotionAexc').val(), STOCK_ID, SRV_PAC_ID);
          } else {
            if ($('#cmbAppTypeAexc option:selected').index() == 0) {
              fn_loadProductPriceAexc(APP_TYPE_ID, STOCK_ID, SRV_PAC_ID);
            } else {
              fn_loadProductPriceAexc($("#cmbAppTypeAexc").val(), STOCK_ID, SRV_PAC_ID);
            }

            if (GST_CHK == '1') {
              fn_excludeGstAmtAexc();
            }
          }
        });

    $('#srvPacIdAexc').change(
      function() {
              var idx = $("#srvPacIdAexc option:selected")
                  .index();
              var selVal = $("#srvPacIdAexc").val();

              if ($("#cmbAppTypeAexc").val() == 67 || $("#cmbAppTypeAexc").val() == 68) {
                SRV_PAC_ID = 0;
              } else {
                SRV_PAC_ID = $("#srvPacIdAexc").val();
              }

              if (idx > 0) {
            	  var stkType = $("#cmbAppTypeAexc").val() == '66' ? '1' : '2';

                Common.ajax("GET", "/sales/order/selectProductCodeList.do", { stkType : stkType,srvPacId : selVal }, function(result) {
                	if (result != null && result.length > 0) {
                		var isExist = false;
                		for (var i = 0; i < result.length; i++) {
                			if (result[i].stkId == STOCK_ID) {
                				isExist = true;
                				break;
                				}
                			}
                		}


                	if (!isExist) {
                		Common.alert('<spring:message code="sal.msg.subtypeSelected" />'+ DEFAULT_DELIMITER + '<spring:message code="sal.msg.notSubtypeSuit" />');
                		$('#srvPacIdAexc').val('');
                		} else {
                			if ($('#cmbAppTypeAexc option:selected').index() == 0) {
                				fn_loadProductPriceAexc(APP_TYPE_ID,STOCK_ID,SRV_PAC_ID);
                			} else {
                				fn_loadProductPriceAexc($("#cmbAppTypeAexc").val(),STOCK_ID,SRV_PAC_ID);
                            }
                            fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(),STOCK_ID,EMP_CHK,CUST_TYPE_ID,$("#exTradeAexc").val());

                            if (GST_CHK == '1') {
                              fn_excludeGstAmtAexc();
                            }
                            Common.showLoader();
                            setTimeout(
                                function() {
                                  fn_loadPromotionPriceAexc($('#cmbPromotionAexc').val(),STOCK_ID,SRV_PAC_ID)
                                  Common.removeLoader();}
                                , 200);
                          }
                        });
              }
            });
    $('#exTradeAexc').change(
        function() {

          if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
            SRV_PAC_ID = 0;
          } else {
            SRV_PAC_ID = $("#srvPacIdAexc").val();
          }

          $('#cmbPromotionAexc option').remove();

          if ($("#exTradeAexc").val() == '1') {
            $('#relatedNoAexc').removeAttr("readonly").removeClass(
                "readonly");
          } else {
            $('#relatedNoAexc').val('').prop("readonly", true)
                .addClass("readonly");
          }

          fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(),
              STOCK_ID, EMP_CHK, CUST_TYPE_ID, $("#exTradeAexc")
                  .val());
          fn_loadPromotionPriceAexc($('#cmbPromotionAexc').val(),
              STOCK_ID, SRV_PAC_ID);
        });
    $('#custIdOwnt').change(function(event) {
      fn_selectCustInfo();
    });
    $('#custIdOwnt').keydown(function(event) {
      if (event.which === 13) { //enter
        fn_selectCustInfo();
        return false;
      }
    });
    $('#addCustBtn').click(
        function() {
          Common.popupWin("searchFormOwnt",
              "/sales/customer/customerRegistPop.do", {
                width : "1200px",
                height : "580x"
              });
          //Common.popupDiv("/sales/customer/customerRegistPop.do", $("#searchForm").serializeJSON(), null, true);
        });
    $('#custBtnOwnt').click(function() {
      //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
      Common.popupDiv("/common/customerPop.do", {
        callPrgm : "ORD_REGISTER_CUST_CUST"
      }, null, true);
    });
    $('#btnReqOwnTrans').click(function() {
      if (!fn_isLockOrder('OTRN')) {
        if (fn_validReqOwnt()) {
          fn_doSaveReqOwnt();
        }
      }
    });
    $('#btnAddAddress').click(function() {
      Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
        custId : $('#txtHiddenCustIDOwnt').val(),
        callParam : "ORD_REQUEST_MAIL"
      }, null, true);
    });
    $('#btnSelectAddress').click(function() {
      Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
        custId : $('#txtHiddenCustIDOwnt').val(),
        callPrgm : "fn_loadMailAddress"
      }, null, true);
    });
    $('#btnAddContact').click(function() {
      Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {
        "custId" : $('#txtHiddenCustIDOwnt').val(),
        callParam : "ORD_REQUEST_MAIL"
      }, null, true, '_editDiv3New');
    });
    $('#btnSelectContact').click(function() {
      Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
        custId : $('#txtHiddenCustIDOwnt').val(),
        callPrgm : "fn_loadCntcPerson"
      }, null, true);
    });
    $('#btnAddInstAddress').click(function() {
      Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
        custId : $('#txtHiddenCustIDOwnt').val(),
        callParam : "ORD_REQUEST_MAIL"
      }, null, true);
    });
    $('#btnSelectInstAddress').click(function() {
      Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
        custId : $('#txtHiddenCustIDOwnt').val(),
        callPrgm : "fn_loadInstAddress"
      }, null, true);
    });
    $('#btnAddInstContact').click(function() {
      Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {
        "custId" : $('#txtHiddenCustIDOwnt').val(),
        callParam : "ORD_REQUEST_MAIL"
      }, null, true, '_editDiv3New');
    });
    $('#btnSelectInstContact').click(function() {
      Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
        custId : $('#txtHiddenCustIDOwnt').val(),
        callPrgm : "fn_loadInstallationCntcPerson"
      }, null, true);
    });
    $('#btnThirdPartyOwnt').click(function(event) {

      fn_clearRentPayMode();
      fn_clearRentPay3thParty();
      fn_clearRentPaySetCRC();
      fn_clearRentPaySetDD();

      if ($('#btnThirdPartyOwnt').is(":checked")) {
        $('#sctThrdParty').removeClass("blind");
      } else {
        $('#sctThrdParty').addClass("blind");
      }
    });
    $('#cmbRentPaymodeOwnt')
        .change(
            function() {
              fn_clearRentPaySetCRC();
              fn_clearRentPaySetDD();

              var rentPayModeIdx = $(
                  "#cmbRentPaymodeOwnt option:selected")
                  .index();
              var rentPayModeVal = $("#cmbRentPaymodeOwnt").val();

              if (rentPayModeIdx > 0) {
                if (rentPayModeVal == '133'
                    || rentPayModeVal == '134') {

                  var rentPayModeTxt = $(
                      "#cmbRentPaymodeOwnt option:selected")
                      .text();

                  //                  Common.alert('<b>Currently we are not provide ['+rentPayModeVal+'] service.</b>');
                  Common
                      .alert('<spring:message code="sal.alert.msg.rentPayRestriction" />'
                          + DEFAULT_DELIMITER
                          + '<spring:message code="sal.alert.msg.notProvideSvc" arguments="'+rentPayModeTxt+'"/>');
                  fn_clearRentPayMode();
                } else {
                  if (rentPayModeVal == '131') {
                    if ($('#btnThirdPartyOwnt').is(
                        ":checked")
                        && FormUtil
                            .isEmpty($(
                                '#txtHiddenThirdPartyIDOwnt')
                                .val())) {
                      Common
                          .alert('<spring:message code="sal.alert.title.thirdPartyRequired" />'
                              + DEFAULT_DELIMITER
                              + '<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
                    } else {
                      $('#sctCrCard')
                          .removeClass("blind");
                    }
                  } else if (rentPayModeVal == '132') {
                    if ($('#btnThirdPartyOwnt').is(
                        ":checked")
                        && FormUtil
                            .isEmpty($(
                                '#txtHiddenThirdPartyIDOwnt')
                                .val())) {
                      Common
                          .alert('<spring:message code="sal.alert.title.thirdPartyRequired" />'
                              + DEFAULT_DELIMITER
                              + '<spring:message code="sal.alert.msg.plzSelThirdPartyFirst" />');
                    } else {
                      $('#sctDirectDebit').removeClass(
                          "blind");
                    }
                  }
                }
              }
            });
    $('#txtThirdPartyIDOwnt').change(function(event) {
      fn_loadThirdParty($('#txtThirdPartyIDOwnt').val().trim(), 2);
    });
    $('#txtThirdPartyIDOwnt').keydown(function(event) {
      if (event.which === 13) { //enter
        fn_loadThirdParty($('#txtThirdPartyIDOwnt').val().trim(), 2);
      }
    });
    $('#thrdPartyBtn').click(function() {
      //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
      Common.popupDiv("/common/customerPop.do", {
        callPrgm : "ORD_REQUEST_PAY"
      }, null, true);
    });
    $('#btnAddCRC').click(
            function() {
              var vCustId = $('#btnThirdPartyOwnt').is(":checked") ? $(
                  '#txtHiddenThirdPartyIDOwnt').val() : $(
                  '#txtHiddenCustIDOwnt').val();
              if(FormUtil.isEmpty($("#nricOwnt").val())) {
                  Common.alert("NRIC required to add new Credit Card!");
                  return false;
              }
              Common.popupDiv(
                  "/sales/customer/customerCreditCardAddPop.do", {
                    custId : vCustId,
                    nric : $("#nricOwnt").val()
                  }, null, true);
            });
    $('#btnSelectCRC').click(
        function() {
          var vCustId = $('#btnThirdPartyOwnt').is(":checked") ? $(
              '#txtHiddenThirdPartyIDOwnt').val() : $(
              '#txtHiddenCustIDOwnt').val();
          Common.popupDiv(
              "/sales/customer/customerCreditCardSearchPop.do", {
                custId : vCustId,
                callPrgm : "ORD_REQUEST_PAY"
              }, null, true);
        });
    $('#btnAddBankAccount').click(
        function() {
          var vCustId = $('#thrdParty').is(":checked") ? $(
              '#txtHiddenThirdPartyIDOwnt').val() : $(
              '#txtHiddenCustIDOwnt').val();
          Common.popupDiv(
              "/sales/customer/customerBankAccountAddPop.do", {
                custId : vCustId
              }, null, true);
        });
    $('#btnSelectBankAccount').click(
        function() {
          var vCustId = $('#thrdParty').is(":checked") ? $(
              '#txtHiddenThirdPartyIDOwnt').val() : $(
              '#txtHiddenCustIDOwnt').val();
          Common.popupDiv(
              "/sales/customer/customerBankAccountSearchPop.do",
              {
                custId : vCustId,
                callPrgm : "ORD_REQUEST_PAY"
              });
        });
    $('#btnAddThirdParty').click(
        function() {
          Common.popupWin("searchFormOwnt",
              "/sales/customer/customerRegistPop.do", {
                width : "1200px",
                height : "580x"
              });
        });
    $('[name="grpOpt"]').click(function() {
      fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
    });
    $('#billGrpBtn').click(function() {
      Common.popupDiv("/sales/customer/customerBillGrpSearchPop.do", {
        custId : $('#txtHiddenCustIDOwnt').val(),
        callPrgm : "ORD_REQUEST_BILLGRP"
      }, null, true);
    });
    $('[name="reqSrvType"]').click(function() {
    	$("#srvTypeLbl").find("span").remove();
    	if($('input:radio[name="reqSrvType"]:checked').val() == 'SS'){
    		$("#srvTypeLbl").append("<span><spring:message code='sales.text.serviceTypeDiscountMessage'/></span>");
    		$('#ordPvSs').val(totPvSs);
    		$("#selfSrvPvLbl").show();
    	}else{
    		$('#ordPvSs').val('');
    		$("#selfSrvPvLbl").hide();
    	}
    });

  });

  function fn_excludeGstAmt() {
    //Amount before GST
    var oldPrice = $('#orgOrdPrice').val();
    var newPrice = $('#ordPrice').val();
    var oldRental = $('#orgOrdRentalFees').val();
    var newRental = $('#ordRentalFees').val();
    var oldPv = $('#ordPv').val();
    //Amount of GST applied
    var oldPriceGST = fn_calcGst(oldPrice);
    var newPriceGST = fn_calcGst(newPrice);
    var oldRentalGST = fn_calcGst(oldRental);
    var newRentalGST = fn_calcGst(newRental);
    var newPv = $('#ordPvGST').val();

    if (APP_TYPE_ID != '66') {
      oldPriceGST = Math.floor(oldPriceGST / 10) * 10;
      newPriceGST = Math.floor(newPriceGST / 10) * 10;
    }

    $('#orgOrdPrice').val(oldPriceGST);
    $('#ordPrice').val(newPriceGST);
    $('#orgOrdRentalFees').val(oldRentalGST);
    $('#ordRentalFees').val(newRentalGST);
    $('#ordPv').val(newPv);

    //$('#pBtnCal').addClass("blind");
  }

  function fn_excludeGstAmtAexc() {
    //Amount before GST
    var oldPrice = $('#orgOrdPriceAexc').val();
    var newPrice = $('#txtPriceAexc').val();
    var oldRental = $('#orgOrdRentalFeesAexc').val();
    var newRental = $('#ordRentalFeesAexc').val();
    var oldPv = $('#txtPVAexc').val();
    //Amount of GST applied
    var oldPriceGST = fn_calcGst(oldPrice);
    var newPriceGST = fn_calcGst(newPrice);
    var oldRentalGST = fn_calcGst(oldRental);
    var newRentalGST = fn_calcGst(newRental);
    var newPv = $('#ordPvGSTAexc').val();

    if ($('#cmbAppTypeAexc').val() != '66') {
      oldPriceGST = Math.floor(oldPriceGST / 10) * 10;
      newPriceGST = Math.floor(newPriceGST / 10) * 10;
    }

    $('#orgOrdPriceAexc').val(oldPriceGST);
    $('#txtPriceAexc').val(newPriceGST);
    $('#orgOrdRentalFeesAexc').val(oldRentalGST);
    $('#ordRentalFeesAexc').val(newRentalGST);
    $('#txtPVAexc').val(newPv);

    //$('#pBtnCal').addClass("blind");
  }

  function fn_loadBillingGroup(billGrpId, custBillGrpNo, billType,
      billAddrFull, custBillRem, custBillAddId) {
    $('#txtHiddenBillGroupIDOwnt').removeClass("readonly").val(billGrpId);
    $('#txtBillGroupOwnt').removeClass("readonly").val(custBillGrpNo);
    $('#txtBillTypeOwnt').removeClass("readonly").val(billType);
    $('#txtBillAddressOwnt').removeClass("readonly").val(billAddrFull);
    $('#txtBillGroupRemarkOwnt').removeClass("readonly").val(custBillRem);

    fn_loadMailAddress(custBillAddId);
  }

  function fn_setBillGrp(grpOpt) {

    if (grpOpt == 'new') {

      $('#btnAddAddress').removeClass("blind");
      $('#btnSelectAddress').removeClass("blind");

      fn_clearBillGroup();

      $('#grpOpt1').prop("checked", true);
    } else if (grpOpt == 'exist') {

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

    if (!FormUtil.IsValidBankAccount($('#txtHiddenRentPayBankAccIDOwnt')
        .val(), $('#txtRentPayBankAccNoOwnt').val())) {
      fn_clearRentPaySetDD();
      $('#sctDirectDebit').removeClass("blind");
      Common
          .alert('<spring:message code="sal.alert.title.invalidBankAcc" />'
              + DEFAULT_DELIMITER
              + '<spring:message code="sal.alert.msg.invalidAccForAutoDebit" />');
    }
  }

  function fn_loadBankAccount(bankAccId) {
    Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {
      getparam : bankAccId
    }, function(rsltInfo) {

      if (rsltInfo != null) {
        $("#txtHiddenRentPayBankAccIDOwnt").val(rsltInfo.custAccId);
        $("#txtRentPayBankAccNoOwnt").val(rsltInfo.custAccNo);
        $("#hiddenRentPayEncryptBankAccNoOwnt").val(
            rsltInfo.custEncryptAccNo);
        $("#txtRentPayBankAccTypeOwnt").val(rsltInfo.codeName);
        $("#txtRentPayBankAccNameOwnt").val(rsltInfo.custAccOwner);
        $("#txtRentPayBankAccBankBranchOwnt").val(
            rsltInfo.custAccBankBrnch);
        $("#txtRentPayBankAccBankOwnt").val(
            rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
        $("#hiddenRentPayBankAccBankIDOwnt")
            .val(rsltInfo.custAccBankId);
      }
    });
  }

  function fn_loadCreditCard(crcId, custOriCrcNo, custCrcNo, custCrcType,
      custCrcName, custCrcExpr, custCRCBank, custCrcBankId, crcCardType) {
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

    if (custId != $('#txtHiddenCustIDOwnt').val()) {
      Common
          .ajax(
              "GET",
              "/sales/customer/selectCustomerJsonList",
              {
                custId : custId
              },
              function(result) {

                if (result != null && result.length == 1) {

                  var custInfo = result[0];

                  $('#txtHiddenThirdPartyIDOwnt').val(
                      custInfo.custId)
                  $('#txtThirdPartyIDOwnt').val(
                      custInfo.custId)
                  $('#txtThirdPartyTypeOwnt').val(
                      custInfo.codeName1)
                  $('#txtThirdPartyNameOwnt').val(
                      custInfo.name)
                  $('#txtThirdPartyNRICOwnt').val(
                      custInfo.nric)
                  /*
                   $('#thrdPartyId').removeClass("readonly");
                   $('#thrdPartyType').removeClass("readonly");
                   $('#thrdPartyName').removeClass("readonly");
                   $('#thrdPartyNric').removeClass("readonly");
                   */
                } else {
                  if (sMethd == 2) {
                    //                  Common.alert('<b>Third party not found.<br />Your input third party ID : ' + custId + '</b>');
                    Common
                        .alert('<spring:message code="sal.alert.msg.input3rdPartyId" arguments="'+custId+'"/>');
                  }
                }
              });
    } else {
      //          Common.alert('<b>Third party and customer cannot be same person/company.<br />Your input third party ID : ' + custId + '</b>');
      Common
          .alert('<spring:message code="sal.alert.msg.samePerson3rdPartyId" arguments="'+custId+'"/>');
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

    if (FormUtil.isNotEmpty(strCustId) && strCustId > 0) {
      if (CUST_ID == strCustId) {
        $('#custIdOwnt').val('');
        Common.alert('<spring:message code="sal.msg.invalidCustId" />'
            + DEFAULT_DELIMITER
            + '<spring:message code="sal.msg.ownerOfOrder" />');
      } else {
        fn_loadCustomer(strCustId);
      }
    } else {
      Common
          .alert('<b><spring:message code="sal.msg.invalidCustId" /></b>');
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

  function fn_loadCustomer(custId) {

    $("#searchCustIdOwnt").val(custId);

    Common
        .ajax(
            "GET",
            "/sales/customer/selectCustomerJsonList",
            {
              custId : custId
            },
            function(result) {

              if (result != null && result.length == 1) {

                //fn_tabOnOffSet('BIL_DTL', 'SHOW');

                var custInfo = result[0];
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
                $("#dobOwnt").val(
                    custInfo.dob == '01/01/1900' ? ''
                        : custInfo.dob); //DOB
                $("#genderOwnt").val(custInfo.gender); //Gender
                $("#pasSportExprOwnt")
                    .val(
                        custInfo.pasSportExpr == '01/01/1900' ? ''
                            : custInfo.pasSportExpr); //Passport Expiry
                $("#visaExprOwnt").val(
                    custInfo.visaExpr == '01/01/1900' ? ''
                        : custInfo.visaExpr); //Visa Expiry
                $("#emailOwnt").val(custInfo.email); //Email
                $("#custRemOwnt").val(custInfo.rem); //Remark
                $("#empChkOwnt").val(
                    "${orderDetail.basicInfo.empChk}"); //Employee
                //              $("#gstChk").val('0').prop("disabled", true);

                if (custInfo.corpTypeId > 0) {
                  $("#corpTypeNmOwnt").val(custInfo.codeName); //Industry Code
                } else {
                  $("#corpTypeNmOwnt").val(""); //Industry Code
                }

                if (custInfo.custAddId > 0) {

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

                if (custInfo.custCntcId > 0) {
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
              } else {
                //              Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
                Common
                    .alert('<spring:message code="sal.alert.msg.custNotFound" arguments="'+custId+'"/>');
              }
            });
  }

  function createSchemAUIGrid() {
    //AUIGrid 칼럼 설정
    var docColumnLayout = [ {
      headerText : '<spring:message code="sal.title.filterCode" />',
      dataField : "stkCode",
      width : 120
    }, {
      headerText : '<spring:message code="sal.text.name" />',
      dataField : "stkDesc"
    }, {
      headerText : '<spring:message code="sal.title.changePeriod" />',
      dataField : "srvFilterPriod",
      width : 120
    }, {
      headerText : '<spring:message code="sal.title.lastChangeDate" />',
      dataField : "srvFilterPrvChgDt",
      width : 120
    } ];

    //그리드 속성 설정
    var filterGridPros = {
      usePaging : true, //페이징 사용
      pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode       : "singleRow",  //"multipleCells",
      headerHeight : 30,
      useGroupingPanel : false, //그룹핑 패널 사용
      skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
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

  function fn_loadInstallationCntcPerson(custCntcId) {
    $("#searchCustCntcId").val(custCntcId);

    Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
      custCntcId : custCntcId
    }, function(rslt) {

      if (rslt != null) {
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

  function fn_loadCntcPerson(custCntcId) {
    Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
      custCntcId : custCntcId
    }, function(rslt) {

      if (rslt != null) {
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

  function fn_loadMailAddress(custAddId) {
    Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
      custAddId : custAddId
    }, function(rslt) {

      if (rslt != null) {
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

  function fn_loadInstAddress(custAddId) {
    Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
      custAddId : custAddId
    }, function(rslt) {

      if (rslt != null) {
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
    Common.ajax("GET", "/sales/membership/selectMembershipFree_oList", {
      ORD_ID : ORD_ID
    }, function(result) {
      AUIGrid.setGridData(filterGridID, result);
    });
  }

  function fn_getLoginInfo() {
    var userId = 0;

    Common.ajaxSync("GET", "/sales/order/loginUserId.do", '', function(
        rsltInfo) {
      if (rsltInfo != null) {
        userId = rsltInfo.userId;
      }
    });

    return userId;
  }

  function fn_getCheckAccessRight(userId, moduleUnitId) {
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

  function fn_loadPromotionPriceAexc(promoId, stkId, srvPacId) {
    var isNull1 = true;
    var isNull2 = true;
    var PromoItemPrice = 0;
    var PromoItemPV = 0;

    Common.ajaxSync("GET",
        "/sales/order/selectProductPromotionPriceByPromoStockID.do", {
          promoId : promoId,
          stkId : stkId,
          srvPacId : srvPacId
        }, function(promoPriceInfo) {

          if (promoPriceInfo != null) {

            $("#txtPriceAexc").val(promoPriceInfo.orderPricePromo);
            $("#txtPVAexc").val(promoPriceInfo.orderPVPromo);
            $("#ordPvGSTAexc").val(promoPriceInfo.orderPVPromoGST);
            $("#ordRentalFeesAexc").val(
                promoPriceInfo.orderRentalFeesPromo);
            $("#orgOrdRentalFeesAexc").val(
                promoPriceInfo.normalRentalFees);

            $("#promoDiscPeriodTpAexc").val(
                promoPriceInfo.promoDiscPeriodTp);
            $("#promoDiscPeriodAexc").val(
                promoPriceInfo.promoDiscPeriod);

            PromoItemPrice = promoPriceInfo.orderPricePromo;
            PromoItemPV = promoPriceInfo.orderPVPromo;

            isNull1 = false;
          }
        });

    var totalAmount = 0;

    if ("${orderDetail.basicInfo.appTypeId}" == "66") {
      Common.ajaxSync("GET","/sales/order/selectOrderSimulatorViewByOrderNo.do",{ salesOrdNo : ORD_NO}, function(result) {

                if (result != null) isNull2 = false;

                if (fn_validateOrderAexc2(ORD_NO) == true) {

                  var installdate = result.installdate;
                  var today = '${toDay}';

                  var monthDiff = ((Number(today.substr(6, 4)) * 12) + Number(today.substr(3, 2))) - ((Number(installdate.substr(0, 4)) * 12) + Number(installdate.substr(4, 2)));

                  var totalRPF = result.totalbillrpf + result.totaldnrpf - result.totalcnrpf;
                  var totalBillAmount = result.totalbillamt + result.totaldnbill - result.totalcnbill;
console.log("result.lastbillmth;"+result.lastbillmth);
                  if (monthDiff >= 1 && result.lastbillmth > 1) {
                    totalAmount = parseFloat(PromoItemPrice)  - (totalBillAmount / 2);
                  } else {
                    totalAmount = parseFloat(PromoItemPrice) - (totalRPF + totalBillAmount);
                  }
                }
              });
    }

    if (isNull1 == false && isNull2 == false) {
      totalAmount = Math.floor(totalAmount);

      $('#txtPriceAexc').val(totalAmount);
      $('#txtPVAexc').val(PromoItemPV);
    } else {
      $('#txtPriceAexc').val(txtPrice_uc_Value);
      $('#txtPVAexc').val(txtPV_uc_Value);
    }
  }

  function fn_loadPromotionPrice(promoId, stkId, srvPacId) {
    var data;

    Common.ajaxSync("GET",
                              "/sales/order/selectProductPromotionPriceByPromoStockID.do",
                             { promoId : promoId,
                                stkId : stkId,
                                srvPacId : srvPacId
                             },
                             function(promoPriceInfo) {
                               if (promoPriceInfo != null) {
                                $("#ordPrice").val(promoPriceInfo.orderPricePromo);
                                $("#ordPv").val(promoPriceInfo.orderPVPromo);
                                $("#ordPvGST").val(promoPriceInfo.orderPVPromoGST);
                                $("#ordRentalFees").val(promoPriceInfo.orderRentalFeesPromo);
                                //$("#orgOrdRentalFees").val(promoPriceInfo.normalRentalFees);

                                $("#promoDiscPeriodTp").val(promoPriceInfo.promoDiscPeriodTp);
                                $("#promoDiscPeriod").val(promoPriceInfo.promoDiscPeriod);

                                totPvSs = parseFloat(promoPriceInfo.promoItmPvSs).toFixed(2);
                 				console.log('totPvSs : ' + totPvSs);
                 				fn_checkSrvType(promoPriceInfo.srvType);
                 				console.log('srvType : ' + promoPriceInfo.srvType);

                                data = { ordPrice : promoPriceInfo.orderPricePromo,
                                             ordPv : promoPriceInfo.orderPVPromo,
                                             ordPvGST : promoPriceInfo.orderPVPromoGST,
                                             ordRentalFees : promoPriceInfo.orderRentalFeesPromo,
                                             promoDiscPeriodTp : promoPriceInfo.promoDiscPeriodTp,
                                             promoDiscPeriod : promoPriceInfo.promoDiscPeriod,
                                             srvType : promoPriceInfo.srvType
                                }
                              } else {
                                Common.alert('<spring:message code="sal.msg.unableFindPromo" />'
                                + DEFAULT_DELIMITER
                                + '<spring:message code="sal.msg.unableFindPromoForPord" />');

                                 if ($('#btnCurrentPromo').is(":checked")) {
                                   $('#btnCurrentPromo').click();
                                 }
                               }
    });

    return data;
  }

  //LoadProductPromotion For Application Type Exchange
  function fn_loadProductPromotionAexc(appTypeVal, stkId, empChk,
      custTypeVal, exTrade) {

    $('#cmbPromotionAexc option').remove();

    if (appTypeVal == '' || exTrade == '')
      return;

    if (appTypeVal == 67 || appTypeVal == 68) {
      doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {
        appTypeId : appTypeVal,
        stkId : stkId,
        empChk : empChk,
        promoCustType : custTypeVal,
        exTrade : exTrade,
        srvPacId : $("#srvPacIdAexc").val()
        , voucherPromotion: voucherAppliedStatus
        ,custStatus: custStatusId
      }, '', 'cmbPromotionAexc', 'S', 'fn_setDefaultPromotionAexc'); //Common Code
    }
    else {
      doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {
        appTypeId : appTypeVal,
        stkId : stkId,
        empChk : empChk,
        promoCustType : custTypeVal,
        exTrade : exTrade,
        srvPacId : $("#srvPacIdAexc").val()
        , voucherPromotion: voucherAppliedStatus
        ,custStatus: custStatusId
      }, '', 'cmbPromotionAexc', 'S','voucherPromotionCheckAexc'); //Common Code
    }
  }

  //LoadProductPromotion
  function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal,
      exTrade, srvPacId) {
    $('#cmbPromotion').removeAttr("disabled");

    if (appTypeVal == 67 || appTypeVal == 68) {
      doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {
        appTypeId : appTypeVal,
        stkId : stkId,
        empChk : empChk,
        promoCustType : custTypeVal,
        exTrade : exTrade,
        srvPacId : srvPacId
        , voucherPromotion: voucherAppliedStatus
        ,custStatus: custStatusId
      }, '', 'cmbPromotion', 'S', 'voucherPromotionCheckPrdEx'); //Common Code
    }
    else {
      doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {
        appTypeId : appTypeVal,
        stkId : stkId,
        empChk : empChk,
        promoCustType : custTypeVal,
        exTrade : exTrade,
        srvPacId : srvPacId
        , voucherPromotion: voucherAppliedStatus
        ,custStatus: custStatusId
      }, '', 'cmbPromotion', 'S', 'voucherPromotionCheckPrdEx'); //Common Code
    }
  }

  //LoadProductPrice
  function fn_loadProductPriceAexc(appTypeVal, stkId, srvPacId) {
    var appTypeId = 0;

    appTypeId = appTypeVal == '68' ? '67' : appTypeVal;

    Common.ajaxSync("GET", "/sales/order/selectStockPriceJsonInfo.do", {
      appTypeId : appTypeId,
      stkId : stkId,
      srvPacId : srvPacId
    }, function(stkPriceInfo) {

      if (stkPriceInfo != null) {
        var pvVal = stkPriceInfo.orderPV;
        var pvValGst = Math.floor(pvVal * (1 / 1.06))

        $("#txtPriceAexc").val(stkPriceInfo.orderPrice);
        $("#txtPVAexc").val(pvVal);
        $("#ordPvGSTAexc").val(pvValGst);
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
  function fn_loadProductPrice(appTypeVal, stkId, srvPacId) {
    var appTypeId = 0;

    appTypeId = appTypeVal == '68' ? '67' : appTypeVal;
    /*
     $("#searchAppTypeId").val(appTypeId);
     $("#searchStkId").val(stkId);
     */
    Common.ajaxSync("GET", "/sales/order/selectStockPriceJsonInfo.do", {
      appTypeId : appTypeId,
      stkId : stkId,
      srvPacId : srvPacId
    }, function(stkPriceInfo) {

      if (stkPriceInfo != null) {
        var pvVal = stkPriceInfo.orderPV;
        var pvValGst = Math.floor(pvVal * (1 / 1.06))

        $("#ordPrice").val(stkPriceInfo.orderPrice);
        $("#ordPv").val(stkPriceInfo.orderPV);
        $("#ordPvGST").val(pvValGst);
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
    var todayYY = Number(TODAY_DD.substr(6, 4));

    if (tabNm == 'CANC') {

      if (fn_getCheckAccessRight(userid, 9)) {

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
          if (todayDD == 1 || todayDD == 2) {
            var msg = '<spring:message code="sal.msg.chkCancDate" />';
            Common.alert(
                '<spring:message code="sal.alert.msg.actionRestriction" />'
                    + DEFAULT_DELIMITER + "<b>" + msg
                    + "</b>", fn_selfClose);
            return false;
          }
        }
      } else {
        var msg = "Sorry. You have no access rights to request order cancellation.";
        Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>"
            + msg + "</b>", fn_selfClose);
        return false;
      }
    }

    if (tabNm == 'PEXC') {

      if (fn_getCheckAccessRight(userid, 10)) {
        // ONGHC - CHECK PROMOTION CODE IS IT FALL ON COMBO PACKAGE PROMOTION
        // IF YES - EDIT PROMOTION DISALLOW
        // ELSE NO - PROMOTION EDITABLE
        var stat = "";
        Common.ajaxSync("GET", "/sales/order/chkCboPromPck.do", {
           promo : PROMO_CODE
        }, function(rsltInfo) {
           if (rsltInfo == 1) {
             stat = rsltInfo;
             globalCmbFlg = rsltInfo;
             Common.alert('<spring:message code="sales.msg.popEdtPromCbo" />');
             //return;
           }
        });

        //if (stat == 1) {
          //return;
        //}
        // END

        if (ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
          //                  var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>Produt exchange request is disallowed.";
          var msg = '<spring:message code="sal.msg.underProdExch" arguments="'+ORD_NO+';'+ORD_STUS_CODE+'" argumentSeparator=";"/>';

          Common.alert(
              '<spring:message code="sal.alert.msg.actionRestriction" />'
                  + DEFAULT_DELIMITER + "<b>" + msg + "</b>",
              fn_selfClose);
          return false;
        }
      } else {
        var msg = "Sorry. You have no access rights to request product exchange.";
        Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>"
            + msg + "</b>", fn_selfClose);
        return false;
      }

      applyCurrentUsedVoucherPrdEx();
    }

    if (tabNm == 'SCHM') {
      var isValid = true, msg = "";

      if (FormUtil.isEmpty(RENTAL_STUS)) {
        isValid = false;
        msg += '<spring:message code="sal.msg.statusNotREG" />';
      } else if (RENTAL_STUS != 'REG') {
        isValid = false;
        msg = '<spring:message code="sal.msg.statusNotREG" />';
      }

      if (!fn_getSchemePriceSettingByPromoCode(PROMO_ID, STOCK_ID)) {
        isValid = false;
        msg = '<spring:message code="sal.msg.entitledSchemeExch" />';
      }

      if (ORD_DT >= '2016-04-27') {
        isValid = false;
        msg = '<spring:message code="sal.msg.chkSchemeExchDate" />';
      }

      if (!isValid) {
        Common.confirm('<spring:message code="sales.msg.invOrd" />'
            + DEFAULT_DELIMITER + msg, fn_selfClose);
        return false;
      }
    }

    if (tabNm == 'AEXC') {

      if (fn_getCheckAccessRight(userid, 11)) {
        if (ORD_STUS_ID != '1' && ORD_STUS_ID != '4') {
          //                  var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>Application type exchange request is disallowed.";
          var msg = '<spring:message code="sal.msg.underAppExch" arguments="'+ORD_NO+';'+ORD_STUS_CODE+'" argumentSeparator=";"/>';

          Common.alert(
              '<spring:message code="sal.alert.msg.actionRestriction" />'
                  + DEFAULT_DELIMITER + "<b>" + msg + "</b>",
              fn_selfClose);
          return false;
        } else {
          if (APP_TYPE_ID != '66' && APP_TYPE_ID != '67'
              && APP_TYPE_ID != '68') {
            //                      var msg = "[" + ORD_NO + "] is [" + APP_TYPE_DESC + "] order.<br/>Only rental/outright/installment order is allow to request application type exchange.";
            var msg = '<spring:message code="sal.msg.underAppExch2" arguments="'+ORD_NO+';'+APP_TYPE_DESC+'" argumentSeparator=";"/>';

            Common.alert(
                '<spring:message code="sal.alert.msg.actionRestriction" />'
                    + DEFAULT_DELIMITER + "<b>" + msg
                    + "</b>", fn_selfClose);
            return false;
          }
        }
      } else {
        var msg = "Sorry. You have no access rights to request application type exchange.";
        Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>"
            + msg + "</b>", fn_selfClose);
        return false;
      }

      applyCurrentUsedVoucherAexc();
    }

    if (tabNm == 'OTRN') {

      if (fn_getCheckAccessRight(userid, 12)) {

        if (ORD_STUS_ID != '4') {
          //                  var msg = "[" + ORD_NO + "] is under [" + ORD_STUS_CODE + "] status.<br/>Only complete order is allow to transfer ownership.";
          var msg = '<spring:message code="sal.msg.underOwnTrans" arguments="'+ORD_NO+';'+ORD_STUS_CODE+'" argumentSeparator=";"/>';

          Common.alert(
              '<spring:message code="sal.alert.msg.actionRestriction" />'
                  + DEFAULT_DELIMITER + "<b>" + msg + "</b>",
              fn_selfClose);
          return false;
        }

        if (todayYY >= 2018) {
          if (  todayDD == 1 || todayDD == 2) {
            //                      var msg = "Ownership transfer is not allowed from 26 until 1 next month.";
            var msg = '<spring:message code="sal.msg.underOwnTrans2" />';

            Common.alert(
                '<spring:message code="sal.alert.msg.actionRestriction" />'
                    + DEFAULT_DELIMITER + "<b>" + msg
                    + "</b>", fn_selfClose);
            return false;
          }
        }
      } else {
        var msg = "Sorry. You have no access rights to request ownership transfer.";
        Common.alert("No Access Rights" + DEFAULT_DELIMITER + "<b>"
            + msg + "</b>", fn_selfClose);
        return false;
      }
    }

    var vTit = '<spring:message code="sal.page.title.ordReq" />';

    if ($("#ordReqType option:selected").index() > 0) {
      vTit += ' - ' + $('#ordReqType option:selected').text();
    }

    $('#hTitle').text(vTit);

    if (tabNm == 'CANC') {
      $('#scCN').removeClass("blind");
      $('#aTabMI').click();
      fn_loadListCanc();

      fn_loadOrderInfoCanc();

      fn_isLockOrder(tabNm);
    } else {
      $('#scCN').addClass("blind");
    }
    if (tabNm == 'PEXC') {
      $('#scPX').removeClass("blind");
      $('#aTabBI').click();

      fn_loadListPexch();

      fn_loadOrderInfoPexc();

      fn_isLockOrder(tabNm);
    } else {
      $('#scPX').addClass("blind");
    }
    if (tabNm == 'SCHM') {
      $('#scSC').removeClass("blind");
      $('#aTabBI').click();

      fn_loadOrderInfoSCHM();
    } else {
      $('#scSC').addClass("blind");
    }
    if (tabNm == 'AEXC') {
      $('#scAE').removeClass("blind");
      $('#aTabBI').click();

      fn_loadListAexc();

      fn_loadOrderInfoAexc();

      fn_isLockOrder(tabNm);

      //fn_validateOrderAexc(ORD_NO);
    } else {
      $('#scAE').addClass("blind");
    }
    if (tabNm == 'OTRN') {
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

    Common.ajaxSync("GET", "/sales/order/selectValidateInfo.do", {
      salesOrdNo : ORD_NO
    }, function(rsltInfo) {
      if (rsltInfo != null) {
        valid = rsltInfo.isInValid;
        msgT = rsltInfo.msgT;
        msg = rsltInfo.msg;
      }
    });

    if (valid == 'isInValid') {
      //      if(valid != 'isInValid') { //TEST
      //          Common.alert(msgT + DEFAULT_DELIMITER + "<b>"+msg+"</b>", fn_selfClose);
      Common.alert(msgT + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
      fn_disableControlAexc();
    }
  }

  function fn_validateOrderAexc2(ORD_NO) {
    var valid = '';
    var msgT = '';
    var msg = '';
    var isTrue = true;

    Common.ajaxSync("GET", "/sales/order/selectValidateInfo.do", {
      salesOrdNo : ORD_NO
    }, function(rsltInfo) {
      if (rsltInfo != null) {
        valid = rsltInfo.isInValid;
        msgT = rsltInfo.msgT;
        msg = rsltInfo.msg;
      }
    });

    if (valid == 'isInValid') {
      Common.alert(msgT + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
      fn_disableControlAexc();
      isTrue = false;
    }

    return isTrue;
  }

  function fn_isLockOrder(tabNm) {
    var isLock = false;
    var msg = "";
    var ORD_ID = '${orderDetail.logView.salesOrdId}';
    if (("${orderDetail.logView.isLok}" == '1' && "${orderDetail.logView.prgrsId}" != 2)
        || "${orderDetail.logView.prgrsId}" == 1) {

      if ("${orderDetail.logView.prgrsId}" == 1) {
        Common
            .ajaxSync(
                "GET",
                "/sales/order/checkeAutoDebitDeduction.do",
                {
                  salesOrdId : ORD_ID
                },
                function(rsltInfo) {

                  if (rsltInfo.ccpStus == 1
                      || rsltInfo.eCashStus == 1) {
                    isLock = true;
                    msg = 'This order is under progress [ eCash Deduction ].<br />'
                        + rsltInfo.msg + '.<br/>';
                  }
                });
      } else {
        isLock = true;
        msg = 'This order is under progress ['
            + "${orderDetail.logView.prgrs}" + '].<br />';
      }
    }

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
      } else if (tabNm == 'PEXC') {
        msg += '<spring:message code="sal.alert.msg.prodExchDisallowed" />';
        fn_disableControlPexc();
      } else if (tabNm == 'AEXC') {
        msg += '<spring:message code="sal.alert.msg.appExchDisallowed" />';
        fn_disableControlAexc();
      } else if (tabNm == 'OTRN') {
        msg += '<spring:message code="sal.alert.msg.transOwnDisallowed" />';
        //fn_disableControlAexc();
      }

      Common.alert('<spring:message code="sal.alert.msg.ordLock" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
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
    $('#cmbFollowUp').prop("disabled", true);

    $('#btnReqCancOrder').addClass("blind");
  }

  function fn_loadOrderInfoSCHM() {
    createSchemAUIGrid();

    fn_selectOrderActiveFilterList();
    doGetComboCodeId('/sales/order/selectSalesOrderSchemeList.do', {
      schemeAppTypeId : APP_TYPE_ID
    }, '', 'cmbSchemeSchm', 'S');
  }

  function fn_loadOrderInfoAexc() {

    if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
      SRV_PAC_ID = 0;
    }

    fn_loadAppTypeListAexc(APP_TYPE_ID);
    fn_loadProductPriceAexc(APP_TYPE_ID, STOCK_ID, SRV_PAC_ID);

    if (ORD_STUS_ID == '4') {
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
    if (appTypeId == '66') {
      $('#cmbAppTypeAexc').append("<option value=''>Choose One</option>");
      $('#cmbAppTypeAexc').append("<option value='67'>Outright</option>");
      $('#cmbAppTypeAexc').append(
          "<option value='68'>Installment</option>");
    } else if (appTypeId == '67') {
      $('#cmbAppTypeAexc').append("<option value=''>Choose One</option>");
      $('#cmbAppTypeAexc').append(
          "<option value='68'>Installment</option>");
    } else if (appTypeId == '68') {
      $('#cmbAppTypeAexc').append("<option value=''>Choose One</option>");
      $('#cmbAppTypeAexc').append("<option value='67'>Outright</option>");
    }
  }

  function fn_loadOrderInfoOwnt() {
    if (APP_TYPE_ID == '66') {
      fn_tabOnOffSetOwnt('REN_PAY', 'SHOW');
    }

    fn_tabOnOffSetOwnt('BIL_GRP', 'SHOW');

    $('#dpPreferInstDateOwnt').val(
        "${orderDetail.installationInfo.preferInstDt}");
    $('#tpPreferInstTimeOwnt').val(
        "${orderDetail.installationInfo.preferInstTm}");
    /*KV - previous without linkapptypeid*/
    $('#hiddenAppTypeIDOwnt').val(APP_TYPE_ID);

    Common.ajax("GET", "/sales/order/selectInstallInfo.do", {
      salesOrderId : ORD_ID
    }, function(instInfo) {

      if (instInfo != null) {
        $("#txtInstSpecialInstructionOwnt").val(instInfo.instct);
      }
    });
  }

  function fn_loadOrderInfoCanc() {
    if (ORD_STUS_ID == '4') {
      $('#spPrfRtnDt').removeClass("blind");
      $('#dpReturnDate').removeAttr("disabled");

      if (APP_TYPE_ID == '66') {
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

  function fn_loadOrderInfoPexc() {
    if (ORD_STUS_ID != '1') {
      if (fn_getOrderMembershipConfigByOrderID() == '0') {

        vAsId = fn_getCompleteASIDByOrderIDSolutionReason();

        if (vAsId != '') {
          $('#hiddenFreeASID').val(vAsId);
        } else {
          fn_disableControlPexc();
          Common
              .alert('<spring:message code="sal.alert.msg.actionRestriction" />'
                  + DEFAULT_DELIMITER
                  + '<spring:message code="sal.alert.msg.mbsExpired" />');
        }
      }
    }
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
        //                console.log('result.outSuts[0].ordTotOtstnd:'+result.outSuts[0].ordTotOtstnd);

        vCurrentOutstanding = result[0].ordTotOtstnd;
      }
    });

    return vCurrentOutstanding;
  }

  function fn_getCompleteASIDByOrderIDSolutionReason() {

    var vAsId = '';

    Common.ajaxSync("GET",
        "/sales/order/selectCompleteASIDByOrderIDSolutionReason.do", {
          salesOrdId : ORD_ID,
          asSlutnResnId : 461
        }, function(result) {
          if (result != null) {
            vAsId = result.asId;
          }
        });

    return vAsId;
  }

  function fn_getOrderMembershipConfigByOrderID() {

    var vSrvMemID = '0';

    Common.ajaxSync("GET", "/sales/membership/paymentConfig", {
      PAY_ORD_ID : ORD_ID
    }, function(result) {
      if (result != null) {
        vSrvMemID = result[0].srvMemId;
      }
    });

    return vSrvMemID;
  }

  function fn_getOrderLastRentalBillLedger1() {

    var vTotalUseMth = 0;

    Common.ajaxSync("GET",
        "/sales/order/selectOrderLastRentalBillLedger1.do", {
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
      msg += 'Follow Up By : '
          + $('#cmbFollowUp option:selected').text() + '<br />';

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

    msg += '<br/><spring:message code="sal.alert.msg.wantToOrdCanc" /><br/><br/>';

    Common.confirm('<spring:message code="sal.title.text.reqCancConfrm" />'
        + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_doSaveReqCanc,
        fn_selfClose);
  }

  function fn_doSaveReqAexc() {

	  let formData = new FormData();
      $.each(myFileCaches, function(n, v) {
          formData.append(n, v.file);
      });

		Common.ajaxFile("/sales/order/attachmentFileUpload.do", formData, function(result) {
			if(result != 0 && result.code == 00){
				let jsonObj =  $('#frmReqAppExc').serializeJSON();
				jsonObj.soExchgAtchGrpId = result.data.fileGroupKey;
				jsonObj.voucherCode = voucherAppliedCode;

				Common.ajax("POST","/sales/order/requestAppExch.do",jsonObj, function(result) {
					Common.alert('<spring:message code="sal.alert.msg.appTypeExchSum" />'+ DEFAULT_DELIMITER + "<b>"+ result.message + "</b>",fn_selfClose);
				},
				function(jqXHR, textStatus, errorThrown) {
				    try {
				        Common.alert('<spring:message code="sal.msg.dataPrepFail" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.savingDataPreprationFailed" /></b>');
				    } catch (e) {
				}
				});
			}
		});


  }

  function fn_doSaveReqSchm() {
    $('#cmbSchemeSchmText').val($('#cmbSchemeSchm option:selected').text())

    Common.ajax(
            "POST",
            "/sales/order/requestSchmConv.do",
            $('#frmReqSchmConv').serializeJSON(),
            function(result) {

              Common.alert(
                  '<spring:message code="sal.alert.msg.saveSucc" />'
                      + DEFAULT_DELIMITER + "<b>"
                      + result.message + "</b>",
                  fn_selfClose);

            },
            function(jqXHR, textStatus, errorThrown) {
              try {
                //                  Common.alert("Failed to save" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                //                  console.log("Error message : " + jqXHR.responseJSON.message);
                Common
                    .alert('<spring:message code="sal.msg.dataPrepFail" />'
                        + DEFAULT_DELIMITER
                        + '<b><spring:message code="sal.alert.msg.savingDataPreprationFailed" /></b>');
              } catch (e) {
              }
            });
  }

  function fn_doSaveReqPexc() {
    $('#cmbOrderProduct').prop("disabled", false); //UNABLE THE FIELD
    $('#cmbPromotion').prop("disabled", false); //UNABLE THE FIELD
    $('[name="reqSrvType"]').prop("disabled", false);
    Common.ajax("POST",
                        "/sales/order/requestProdExch.do",
                        $('#frmReqPrdExc').serializeJSON(),
                        function(result) {
                          Common.alert('<spring:message code="sal.alert.msg.prodExchSum" />'
                                              + DEFAULT_DELIMITER + "<b>"
                                              + result.message + "</b>", fn_selfClosePexc());

                        }, function(jqXHR, textStatus, errorThrown) {
                            try {
                              Common.alert('<spring:message code="sal.msg.dataPrepFail" />'
                                                  + DEFAULT_DELIMITER
                                                  + '<b><spring:message code="sal.alert.msg.savingDataPreprationFailed" /></b>');
                            } catch (e) {
                            }
                        });
    $('#cmbOrderProduct').prop("disabled", true);
    $('#cmbPromotion').prop("disabled", true);
    $('[name="reqSrvType"]').prop("disabled", true);
  }

  $(function(){
	  $('#attchmentFile').change(function(evt) {
	      var file = evt.target.files[0];
	      if(file == null && myFileCaches[1] != null){
	          delete myFileCaches[1];
	      }else if(file != null){
	          myFileCaches[1] = {file:file};
	      }
	      console.log(myFileCaches);
	  });

	  $('#attchmentFileAexc').change(function(evt) {
          let fileAexc = evt.target.files[0];

          if(fileAexc == null && myFileCaches[1] != null){
              delete myFileCaches[0];
          }else if(fileAexc != null){
              myFileCaches[1] = {file:fileAexc};
          }
          let msg = '';
          if(fileAexc.name.length > 30){
              msg += "*File name wording should be not more than 30 alphabet.<br>";
          }

          let fileType = fileAexc.type.split('/');

          if(fileType[1] != 'zip' && fileType[1] != 'rar' && fileType[1] != '7zip' && fileType[1] != 'x-zip-compressed'){
              msg += "*Only allow zip file (ZIP, RAR, 7ZIP).<br>";
          }

          if(fileAexc.size > 2000000){
              msg += "*Only allow file with less than 2MB.<br>";
          }
          if(msg != null && msg != ''){
              myFileCaches[1].file['checkFileValid'] = false;
              Common.alert(msg);
          }
          else{
              myFileCaches[1].file['checkFileValid'] = true;
          }

          return msg;
      });

	  });

  function fn_doSaveReqCanc() {

      var formData = new FormData();
      $.each(myFileCaches, function(n, v) {
          console.log("n : " + n + " v.file : " + v.file);
          formData.append(n, v.file);
      });


      Common.ajaxFile("/sales/order/attachmentFileUpload.do", formData, function(result) {
          if(result != 0 && result.code == 00){
              atchFileGrpId = result.data.fileGroupKey;
               console.log("atchFileGrpId :: " + atchFileGrpId);
                var jsonObj =  {
                		  salesOrdId : '${orderDetail.basicInfo.ordId}',
                		  cmbRequestor : $("#cmbRequestor").val(),
                		  dpCallLogDate : $("#dpCallLogDate").val(),
                		  cmbReason : $("#cmbReason").val(),
                		  dpReturnDate : $("#dpReturnDate").val(),
                		  txtRemark : $("#txtRemark").val(),
                		  txtTotalUseMth : $("#txtTotalUseMth").val(),
                		  txtObPeriod : $("#txtObPeriod").val(),
                		  txtRentalFees : $("#txtRentalFees").val(),
                		  txtPenaltyCharge : $("#txtPenaltyCharge").val(),
                		  txtPenaltyAdj : $("#txtPenaltyAdj").val(),
                		  txtCurrentOutstanding : $("#txtCurrentOutstanding").val(),
                		  spTotalAmount : $("#spTotalAmount").val(),
                		  atchFileGrpId : atchFileGrpId,
                		  cmbFollowUp   : $("#cmbFollowUp").val()

                };

                console.log("-------------------------" + JSON.stringify(jsonObj));
    //Common.ajax("POST", "/sales/order/requestCancelOrder.do", $('#frmReqCanc').serializeJSON(), function(result) {
    	Common.ajax("POST", "/sales/order/requestCancelOrder.do", jsonObj, function(result) {

      Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />'
          + DEFAULT_DELIMITER + "<b>" + result.message + "</b>",
          fn_selfClose);

    }, function(jqXHR, textStatus, errorThrown) {
      try {
        //                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
        Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER
            + "<b>Saving data prepration failed.</b>");
      } catch (e) {
      }
    });
          }else{
              Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
          }
      },function(result){
          Common.alert("Upload Failed. Please check with System Administrator.");
      });
      }

  function fn_doSaveReqOwnt() {
    Common.ajax("POST", "/sales/order/requestOwnershipTransfer.do", $(
        '#frmReqOwnt').serializeJSON(), function(result) {

      Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
          + DEFAULT_DELIMITER + "<b>" + result.message + "</b>",
          fn_selfClose);

    }, function(jqXHR, textStatus, errorThrown) {
      try {
        //                  Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER + "<b>Saving data prepration failed.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
        Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER
            + "<b>Saving data prepration failed.</b>");
      } catch (e) {
      }
    });
  }

  function fn_validReqOwnt() {
    var msg = "";

    var todayDD = Number(TODAY_DD.substr(0, 2));
    var todayYY = Number(TODAY_DD.substr(6, 4));

    if (todayYY >= 2018 && ( todayDD == 1 || todayDD == 2)) {
      msg = '<spring:message code="sal.msg.underOwnTrans2" />';
      Common.alert(
          '<spring:message code="sal.alert.msg.actionRestriction" />'
              + DEFAULT_DELIMITER + "<b>" + msg + "</b>",
          fn_selfClose);
      return false;
    } else {
      if (!fn_validReqOwntCustmer()) {
        return false;
      }
      if (!fn_validReqOwntMailAddress()) {
        return false;
      }
      if (!fn_validReqOwntContact()) {
        return false;
      }
      if (!fn_validReqOwntRentPaySet()) {
        return false;
      }
      if (!fn_validReqOwntBillGroup()) {
        return false;
      }
      if (!fn_validReqOwntInstallation()) {
        return false;
      }
    }
    return true;
  }

  function fn_validReqOwntInstallation() {
    var isValid = true, msg = "";

    if (FormUtil.checkReqValue($('#txtHiddenInstAddressIDOwnt'))) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelInstallAddr" />';
    }
    if (FormUtil.checkReqValue($('#txtHiddenInstContactIDOwnt'))) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelInstallContact" />';
    }
    if ($("#cmbDSCBranchOwnt option:selected").index() <= 0) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelDscBrnch" />';
    }
    if (FormUtil.checkReqValue($('#dpPreferInstDateOwnt'))) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelPreferInstDate" />';
    }
    if (FormUtil.checkReqValue($('#tpPreferInstTimeOwnt'))) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelPreferInstTime" />';
    }

    if (!isValid) {
      $('#tabIN').click();
      Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }
    return isValid;
  }

  function fn_validReqOwntBillGroup() {
    var isValid = true, msg = "";

    //if(APP_TYPE_ID == '66' || IS_NEW_VER == 'Y') {
    if (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(":checked")) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelGrpOpt2" />';
    } else {
      if ($('#grpOpt2').is(":checked")) {
        if (FormUtil.checkReqValue($('#txtHiddenBillGroupIDOwnt'))) {
          isValid = false;
          msg += '* <spring:message code="sal.alert.msg.plzSelBillGrp" /><br>';
        }
      }
    }
    //}

    if (!isValid) {
      $('#tabBG').click();
      Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }
    return isValid;
  }

  function fn_validReqOwntRentPaySet() {
    var isValid = true, msg = "";
    if (APP_TYPE_ID == '66') {
      if ($('#btnThirdPartyOwnt').is(":checked")) {
        if (FormUtil.checkReqValue($('#txtHiddenThirdPartyIDOwnt'))) {
          isValid = false;
          msg += '<spring:message code="sal.alert.msg.plzSelThirdParty" />';
        }
      }
      if ($("#cmbRentPaymodeOwnt option:selected").index() <= 0) {
        Common
            .ajaxSync(
                "GET",
                "/sales/order/selectOderOutsInfo.do",
                {
                  ordId : ORD_ID
                },
                function(result) {
                  if (result != null && result.length > 0) {
                    if (result[0].lastBillMth != 60
                        || result[0].ordTotOtstnd != 0) {
                      isValid = false;
                      msg += '<spring:message code="sal.alert.msg.plzSelRentPayMode" />';
                    }
                  }
                });
      } else {
        if ($("#cmbRentPaymodeOwnt").val() == '131') { //CRC
          if (FormUtil.checkReqValue($('#txtHiddenRentPayCRCIDOwnt'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelCrdCard" />';
          } else {
            if (FormUtil
                .checkReqValue($('#hiddenRentPayCRCBankIDOwnt'))
                || $('#hiddenRentPayCRCBankIDOwnt').val() == '0') {
              isValid = false;
              msg += '<spring:message code="sal.alert.msg.invalidCrdCardIssuebank" />';
            }
          }
        } else if ($("#cmbRentPaymodeOwnt").val() == '132') { //DD
          if (FormUtil
              .checkReqValue($('#txtHiddenRentPayBankAccIDOwnt'))) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.plzSelBankAccount" />';
          } else {
            if (FormUtil
                .checkReqValue($('#hiddenRentPayBankAccBankIDOwnt'))
                || $('#hiddenRentPayBankAccBankIDOwnt').val() == '0') {
              isValid = false;
              msg += '<spring:message code="sal.alert.msg.invalidBankAccIssueBank" />';
            }
          }
        }
      }
    }

    if (!isValid) {
      $('#tabRP').click();
      Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }
    return isValid;
  }

  function fn_validReqOwntContact() {
    var isValid = true, msg = "";

    if (FormUtil.checkReqValue($('#txtHiddenContactIDOwnt'))) {
      isValid = false;
      msg += '* <spring:message code="sal.alert.msg.plzSelCntcPer" /><br>';
    }

    if (!isValid) {
      $('#tabCP').click();
      Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }
    return isValid;
  }

  function fn_validReqOwntMailAddress() {
    var isValid = true, msg = "";

    if (FormUtil.checkReqValue($('#txtHiddenAddressIDOwnt'))) {
      isValid = false;
      msg += '<spring:message code="sal.msg.plzSelAddr" />'
    }

    if (!isValid) {
      $('#tabMA').click();
      Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }
    return isValid;
  }

  function fn_validReqOwntCustmer() {
    var isValid = true, msg = "";

    if (FormUtil.checkReqValue($('#txtHiddenCustIDOwnt'))) {
      isValid = false;
      msg += '* <spring:message code="sal.alert.msg.plzSelCust2" /><br>';
    }

    if (!isValid) {
      $('#tabCT').click();
      Common.alert('<spring:message code="sal.alert.msg.ownTransSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    }
    return isValid;
  }

  function fn_validReqPexc() {
    var isValid = true, msg = "", label = "";
    if($('#voucherTypePrdEx').val() == ""){
     	 isValid = false;
          msg += "* Please select voucher type.<br>";
     }

     if($('#voucherTypePrdEx').val() != "" && $('#voucherTypePrdEx').val() > 0){
     	if(voucherAppliedStatus == 0){
     	 isValid = false;
          msg += "* You have selected a voucher type. Please apply a voucher is any.<br>";
     	}
     }

    if (fn_ReasonChk($("#cmbReasonExch option:selected").val(), '') > 0) {
      if (FormUtil.checkReqValue($('#def_part_id'))) {
        isValid = false;
        label = "<spring:message code='service.text.defPrt' />";
        msg += "* <spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/><br/>";
      }

      if (FormUtil.checkReqValue($('#def_def_id'))) {
        isValid = false;
        label = "<spring:message code='service.text.dtlDef' />";
        msg += "* <spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/><br/>";
      }

      if (FormUtil.checkReqValue($('#def_code_id'))) {
        isValid = false;
        label = "<spring:message code='service.text.defCde' />";
        msg += "* <spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/><br/>";
      }
    }

    if ($("#cmbOrderProduct option:selected").index() <= 0) {
      isValid = false;
      label = "<spring:message code='sal.text.product' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/><br/>";
    }
    /*
    if(!$('#btnCurrentPromo').is(":checked")) {
        if($("#cmbPromotion option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select the promotion option.<br>";
        }
    }
     */
    if (FormUtil.checkReqValue($('#dpCallLogDateExch'))) {
      isValid = false;
      label = "<spring:message code='sal.text.callLogDate' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/><br/>";
    }
    if ($("#cmbReasonExch option:selected").index() <= 0) {
      isValid = false;
      label = "<spring:message code='sal.text.reason' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='"+ label + "' htmlEscape='false'/><br/>";
    }
    if ($("#cmbOrderProduct option:selected").index() > 0) {

      if (ORD_STUS_ID == '4') {

        var userid = fn_getLoginInfo();

        //AFTER INSTALL CASE
        if (!fn_getCheckAccessRight(userid, '294')) {
          if ($('#hiddenCurrentProductMasterStockID').val() > 0) {
            //Current Product = Stock B
            if (($('#cmbOrderProduct').val() != $(
                '#hiddenCurrentProductID').val())
                && ($('#cmbOrderProduct').val() != $(
                    '#hiddenCurrentProductMasterStockID')
                    .val())) {
              isValid = false;
              msg += '<spring:message code="sal.alert.msg.sameModelExchOnly" />';
            }
          } else {
            //Current Product = Stock A
            if ($('#cmbOrderProduct').val() != $(
                '#hiddenCurrentProductID').val()) {
              isValid = false;
              msg += '<spring:message code="sal.alert.msg.sameModelExchOnly" />';
            }
          }
        }
      } else {
        //BEFORE INSTALL CASE
        if ($('#cmbOrderProduct').val() != $('#hiddenCurrentProductID')
            .val()) {
          if (fn_getMembershipPurchase()) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.puchMbsSameModelExchOnly" />';
          }
        }
      }
    }

    if (!isValid)
      Common.alert('<spring:message code="sal.alert.msg.prodExchSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_validReqAexc() {
    var isValid = true, msg = "";

    if($('#voucherTypeAexc').val() == ""){
      	 isValid = false;
           msg += "* Please select voucher type.<br>";
      }

      if($('#voucherTypeAexc').val() != "" && $('#voucherTypeAexc').val() > 0){
      	if(voucherAppliedStatus == 0){
      	 isValid = false;
           msg += "* You have selected a voucher type. Please apply a voucher is any.<br>";
      	}
      }

    if ($("#cmbAppTypeAexc option:selected").index() <= 0) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelAppType" />';
    } else if ($("#cmbAppTypeAexc").val() == '68'
        && FormUtil.checkReqValue($('#txtInstallmentDurationAexc'))) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzKeyinInstDuration" />';
    }
    /*
     if($("#cmbPromotionAexc option:selected").index() <= 0) {
     isValid = false;
     msg += "* Please select the promotion option.<br>";
     }
     */
    if ($("#cmbReasonAexc option:selected").index() <= 0) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.plzSelReasonCd" />';
    }
    if (FormUtil.checkReqValue($('#txtPriceAexc'))) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.prcRpfRequired" />';
    }
    if (FormUtil.checkReqValue($('#txtPVAexc'))) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.pvRequired" />';
    }
    if($('#attchmentFileAexc')[0].files.length == 0){
      isValid = false;
      msg += '* Please upload attachment.<br/>';
    }

    if (!isValid)
      Common
          .alert('<spring:message code="sal.alert.msg.appTypeExchSum" />'
              + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_getMembershipPurchase() {
    var isExist = false;
    Common.ajaxSync("GET", "/sales/membership/selectMembershipList", {
      ORD_ID : ORD_ID,
      MBRSH_STUS_ID : '1',
      MBRSH_STUS_ID : '4'
    }, function(result) {
      if (result != null && result.length > 0) {
        isExist = true;
      }
    });
    return isExist;
  }

  function fn_getSchemePriceSettingByPromoCode(PromoID, StockID) {
    var isExist = false;
    Common.ajaxSync("GET",
        "/sales/order/selectSchemePriceSettingByPromoCode.do", {
          schemePromoId : PromoID,
          schemeStockId : StockID
        }, function(result) {
          if (result != null) {
            isExist = true;
          }
        });
    return isExist;
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
    if ($("#cmbFollowUp option:selected").index() <= 0 && '${orderDetail.basicInfo.ordStusId }' == 4) {
        isValid = false;
        msg += '* Please select Follow Up PIC';
      }

    if (!isValid)
      Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />'
          + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_loadListPexch() {
    var stkType = APP_TYPE_ID == '66' ? '1' : '2';
    var stockId = globalCmbFlg == '1' ? STOCK_ID : "";
    var data;

    // COMBO SALES PROMO. FEATURE
    if (globalCmbFlg == 1) {
      if (STOCK_ID != "") {
        fn_loadProductPrice(APP_TYPE_ID, STOCK_ID, SRV_PAC_ID);
        //fn_loadProductPromotion(APP_TYPE_ID, stockId, EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
        //$('#btnCurrentPromo').removeAttr("disabled");

        if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
          SRV_PAC_ID = 0;
        }

        $('#cmbPromotion option').remove();
        //$('#cmbPromotion').append("<option value=''>" + $('#hiddenCurrentPromotion').val() + "</option>");
        $('#cmbPromotion').append("<option value='"+ $("#hiddenCurrentPromotionID").val() + "'>" + $('#hiddenCurrentPromotion').val() + "</option>");
        data = fn_loadPromotionPrice($("#hiddenCurrentPromotionID").val(), STOCK_ID, SRV_PAC_ID);

        $('#btnCurrentPromo').prop("checked", true);
        $('#cmbPromotion').prop("disabled", true);
        $('#cmbOrderProduct').prop("disabled", true);

        if (GST_CHK == '1') {
         fn_excludeGstAmt();
        }
      }
    }

    var promoDiscPeriodTp = typeof data !== 'undefined' ? data.promoDiscPeriodTp : "";

    //doGetProductCombo('/common/selectProductCodeList.do',  stkType, '', 'cmbOrderProduct', 'S', ''); //Product Code
    doGetComboAndGroup2('/sales/order/selectProductCodeList.do', { stkType : stkType, srvPacId : SRV_PAC_ID }, stockId, 'cmbOrderProduct', 'S', 'fn_setOptGrpClass');  // PRODUCT LIST
    doGetComboData('/sales/order/selectResnCodeList.do', { resnTypeId : '287',  stusCodeId : '1' }, '', 'cmbReasonExch', 'S', ''); // EXCHANGE REASON LIST
    doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', promoDiscPeriodTp, 'promoDiscPeriodTp', 'S'); // DISCOUNT PERIOD LIST
  }

  function fn_loadListAexc() {
    doGetComboData('/common/selectCodeList.do', {
      groupCode : '325'
    }, '0', 'exTradeAexc', 'S'); //EX-TRADE
    doGetComboData('/sales/order/selectResnCodeList.do', {
      resnTypeId : '287',
      stusCodeId : '1'
    }, '', 'cmbReasonAexc', 'S', ''); //Reason Code
    doGetComboOrder('/common/selectCodeList.do', '322', 'CODE_ID', '',
        'promoDiscPeriodTpAexc', 'S'); //Discount period
  }

  function fn_loadListCanc() {
    //doGetComboOrder('/common/selectCodeList.do', '52', 'CODE_ID', '', 'cmbRequestor', 'S', ''); //Common Code
    doGetComboOrder('/sales/order/selectCodeList.do', '52', 'CODE_ID', '', 'cmbRequestor', 'S', ''); //Common Code
    doGetComboOrder('/common/selectCodeList.do', '565', 'CODE_NAME', '', 'cmbFollowUp', 'S', ''); //Common Code
    doGetComboData('/sales/order/selectResnCodeList.do', {
      resnTypeId : '536',
      stusCodeId : '1'
    }, '', 'cmbReason', 'S', 'fn_removeOpt'); //Reason Code
  }

  function fn_loadListOwnt() {
    doGetComboData('/common/selectCodeList.do', {
      groupCode : '324'
    }, '', 'empChkOwnt', 'S'); //EMP_CHK
    doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '', 'cmbRentPaymodeOwnt', 'S', ''); //Common Code
    doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', "${orderDetail.installationInfo.dscId}", 'cmbDSCBranchOwnt', 'S', ''); //Branch Code
  }

  function fn_tabOnOffSetOwnt(tabNm, opt) {
    switch (tabNm) {
    case 'REN_PAY':
      if (opt == 'SHOW') {
        if ($('#tabRP').hasClass("blind"))
          $('#tabRP').removeClass("blind");
        if ($('#atcRP').hasClass("blind"))
          $('#atcRP').removeClass("blind");
      } else if (opt == 'HIDE') {
        if (!$('#tabRP').hasClass("blind"))
          $('#tabRP').addClass("blind");
        if (!$('#atcRP').hasClass("blind"))
          $('#atcRP').addClass("blind");
      }
      break;
    case 'BIL_GRP':
      if (opt == 'SHOW') {
        if ($('#tabBG').hasClass("blind"))
          $('#tabBG').removeClass("blind");
        if ($('#atcBG').hasClass("blind"))
          $('#atcBG').removeClass("blind");
      } else if (opt == 'HIDE') {
        if (!$('#tabBG').hasClass("blind"))
          $('#tabBG').addClass("blind");
        if (!$('#atcBG').hasClass("blind"))
          $('#atcBG').addClass("blind");
      }
      break;
    default:
      break;
    }
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

  function fn_selfClose() {
    $('#btnCloseReq').click();
  }

  function fn_selfClosePexc() {
	$('#btnCloseReq').click();
	$('#btnCnfmProductExchangeClose').click();
  }



  function fn_reloadPage() {
    Common.popupDiv("/sales/order/orderRequestPop.do", {
      salesOrderId : ORD_ID,
      ordReqType : $('#ordReqType').val()
    }, null, true);
    $('#btnCloseReq').click();
  }

  function fn_setDefaultSrvPacId() {

    if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
      SRV_PAC_ID = 0;
    } else {
      SRV_PAC_ID = $("#srvPacIdAexc").val();
    }

    if ($('#srvPacIdAexc option').size() == 2) {
      $('#srvPacIdAexc option:eq(1)').attr('selected', 'selected');

      fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(), STOCK_ID, EMP_CHK, CUST_TYPE_ID, $("#exTradeAexc").val());
      fn_loadPromotionPriceAexc($('#cmbPromotionAexc').val(), STOCK_ID, SRV_PAC_ID);
    }
  }

  function fn_setDefaultPromotionAexc() {
    if ($('#cmbPromotionAexc option').size() >= 2) {
      $('#cmbPromotionAexc option:eq(3)').attr('selected', 'selected');
    }
    voucherPromotionCheckAexc();
  }

  function fn_getASReasonCode2(_obj, _tobj, _v) {
    //txtDefectType.Text.Trim(), 387
    var reasonCode = $(_obj).val();
    var reasonTypeId = _v;

    if (reasonCode == "") {
      return;
    }

    Common.ajax("GET", "/services/as/getASReasonCode2.do", { RESN_TYPE_ID : reasonTypeId, CODE : reasonCode },
      function(result) {
        if (result.length > 0) {
          $("#" + _tobj + "_text").val((result[0].resnDesc.trim()).trim());
          $("#" + _tobj + "_id").val(result[0].resnId);

          /*if ('337' == _v) {
            if (result[0].codeId.trim() == 'B8' || result[0].codeId.trim() == 'B6') {
              $("#replacement").attr("disabled", false);
              $("#promisedDate").attr("disabled", false);
              $("#productGroup").attr("disabled", false);
              $("#productCode").attr("disabled", false);
              $("#serialNo").attr("disabled", false);
              $("#inHouseRemark").attr("disabled", false);
              $("#inHouseRepair_div").attr("style", "display:inline");
            } else {
              $("input:radio[name='replacement']").removeAttr('checked');
              $("#promisedDate").val("").attr("disabled", true);
              $("#productGroup").val("").attr("disabled", true);
              $("#productCode").val("").attr("disabled", true);
              $("#serialNo").val("").attr("disabled", true);
              $("#inHouseRemark").val("").attr("disabled", true);
              $("#inHouseRepair_div").attr("style", "display:none");

              fn_replacement(0);
            }
          }*/
          } else {
            $("#" + _tobj + "_text").val("<spring:message code='service.msg.NoDfctCode'/>");
            /*$("#promisedDate").val("").attr("disabled", true);
            $("#productGroup").val("").attr("disabled", true);
            $("#productCode").val("").attr("disabled", true);
            $("#serialNo").val("").attr("disabled", true);
            $("#inHouseRemark").val("").attr("disabled", true);
            $("#inHouseRepair_div").attr("style", "display:none");
            $("input:radio[name='replacement']").removeAttr('checked');
            fn_replacement(0);*/
          }
        });
  }

  function fn_dftTyp(dftTyp){
    var ddCde = "";
    var dtCde = "";
    if (dftTyp == "DC") {
      if ($("#def_def_id").val() == "" || $("#def_def_id").val() == null) {
        var text = "<spring:message code='service.text.dtlDef' />";
        var msg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
        Common.alert(msg);
        return false;
      } else {
        ddCde = $("#def_def_id").val();
      }
    }else if (dftTyp == "SC"){
        if ($("#def_type_id").val() == "" || $("#def_type_id").val() == null) {
              var text = "<spring:message code='service.text.defTyp' />";
              var msg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
              Common.alert(msg);
              return false;
            } else {
              dtCde = $("#def_type_id").val();
            }
    }
    Common.popupDiv("/services/as/dftTypPop.do", {callPrgm : dftTyp, prodCde : STOCK_CDE, ddCde: ddCde, dtCde : dtCde}, null, true);
  }

  function fn_loadDftCde(itm, prgmCde) {
    if (itm != null) {
      if (prgmCde == 'DT') {
        $("#def_type").val(itm.code);
        $("#def_type_id").val(itm.id);
        $("#def_type_text").val(itm.descp);

        //DEPENDENCY
        $("#solut_code").val("");
        $("#solut_code_id").val("");
        $("#solut_code_text").val("");

        var msg = "";

        if (itm.id == "7059") {
          if ($("#def_part_id").val() == "5299" || $("#def_part_id").val() == "5300" || $("#def_part_id").val() == "5301" || $("#def_part_id").val() == "5302" || $("#def_part_id").val() == "5321" || $("#def_part_id").val() == "5332") {
              var text1 = "<spring:message code='service.text.defPrt' />";
              var text2= $("#def_part_text").val();
              var text3 = itm.descp;
              var text4 = "<spring:message code='service.text.defTyp' />";
              var text = text1 + ";" + text2 + ";" + text3;
              msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

              $("#def_type").val("");
              $("#def_type_id").val("");
              $("#def_type_text").val("");
          }

          if ($("#def_def_id").val() == "6041" || $("#def_def_id").val() == "6042" || $("#def_def_id").val() == "6043" || $("#def_def_id").val() == "6044" || $("#def_def_id").val() == "6045" || $("#def_def_id").val() == "6046") {
              var text1 = "<spring:message code='service.text.dtlDef' />";
              var text2= $("#def_def_text").val();
              var text3 = itm.descp;
              var text4 = "<spring:message code='service.text.defTyp' />";
              var text = text1 + ";" + text2 + ";" + text3;
              msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

              $("#def_type").val("");
              $("#def_type_id").val("");
              $("#def_type_text").val("");
          }

          if (msg != ""){
            Common.alert(msg);
            return false;
          }
        }

        if (itm.id == "7072") {
          if ($("#def_part_id").val() == "5299" || $("#def_part_id").val() == "5300" || $("#def_part_id").val() == "5301" || $("#def_part_id").val() == "5302" || $("#def_part_id").val() == "5321" || $("#def_part_id").val() == "5332") {
            var text1 = "<spring:message code='service.text.defPrt' />";
            var text2= $("#def_part_text").val();
            var text3 = itm.descp;
            var text4 = "<spring:message code='service.text.defTyp' />";
            var text = text1 + ";" + text2 + ";" + text3;
            msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

            $("#def_type").val("");
            $("#def_type_id").val("");
            $("#def_type_text").val("");
          }

          if ($("#def_def_id").val() == "6041" || $("#def_def_id").val() == "6042" || $("#def_def_id").val() == "6043" || $("#def_def_id").val() == "6044" || $("#def_def_id").val() == "6045" || $("#def_def_id").val() == "6046" ||
              $("#def_def_id").val() == "6008" || $("#def_def_id").val() == "6015" || $("#def_def_id").val() == "6023" || $("#def_def_id").val() == "6031") {
              var text1 = "<spring:message code='service.text.dtlDef' />";
              var text2= $("#def_def_text").val();
              var text3 = itm.descp;
              var text4 = "<spring:message code='service.text.defTyp' />";
              var text = text1 + ";" + text2 + ";" + text3;
              msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

              $("#def_type").val("");
              $("#def_type_id").val("");
              $("#def_type_text").val("");
          }

          if (msg != ""){
            Common.alert(msg);
            return false;
          }
        }
      } else if (prgmCde == 'DC') {
        $("#def_code").val(itm.code);
        $("#def_code_id").val(itm.id);
        $("#def_code_text").val(itm.descp);
      } else if (prgmCde == 'DP') {
        $("#def_part").val(itm.code);
        $("#def_part_id").val(itm.id);
        $("#def_part_text").val(itm.descp);

        if (itm.id == "5299" || itm.id == "5300" || itm.id == "5301" || itm.id == "5302" || itm.id == "5321" || itm.id== "5332") {
          if ($("#def_type_id").val() == "7059") {
              var text1 = "<spring:message code='service.text.defTyp' />";
              var text2= $("#def_type_text").val();
              var text3 = itm.descp;
              var text4 = "<spring:message code='service.text.defPrt' />";
              var text = text1 + ";" + text2 + ";" + text3;
              var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

              $("#def_part").val("");
              $("#def_part_id").val("");
              $("#def_part_text").val("");

              Common.alert(msg);
              return false;
          }

          if ($("#def_type_id").val() == "7072") {
            var text1 = "<spring:message code='service.text.defTyp' />";
            var text2= $("#def_type_text").val();
            var text3 = itm.descp;
            var text4 = "<spring:message code='service.text.defPrt' />";
            var text = text1 + ";" + text2 + ";" + text3;
            var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

            $("#def_part").val("");
            $("#def_part_id").val("");
            $("#def_part_text").val("");

            Common.alert(msg);
            return false;
          }
        }
      } else if (prgmCde == 'DD') {
        $("#def_def").val(itm.code);
        $("#def_def_id").val(itm.id);
        $("#def_def_text").val(itm.descp);

        // DEPENDENCY
        $("#def_code").val("");
        $("#def_code_id").val("");
        $("#def_code_text").val("");

        if (itm.id == "6041" || itm.id == "6042" || itm.id == "6043" || itm.id== "6044" || itm.id == "6045" || itm.id == "6046") {
          if ($("#def_type_id").val() == "7059") {
            var text1 = "<spring:message code='service.text.defTyp' />";
            var text2= $("#def_type_text").val();
            var text3 = itm.descp;
            var text4 = "<spring:message code='service.text.dtlDef' />";
            var text = text1 + ";" + text2 + ";" + text3;
            var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

            $("#def_def").val("");
            $("#def_def_id").val("");
            $("#def_def_text").val("");

            Common.alert(msg);
            return false;
          }
        }

        if (itm.id == "6041" || itm.id == "6042" || itm.id == "6043" || itm.id== "6044" || itm.id == "6045" || itm.id == "6046" ||
            itm.id == "6008" || itm.id== "6015" || itm.id == "6023" || itm.id == "6031") {
            if ($("#def_type_id").val() == "7072") {
             var text1 = "<spring:message code='service.text.defTyp' />";
             var text2= $("#def_type_text").val();
             var text3 = itm.descp;
             var text4 = "<spring:message code='service.text.dtlDef' />";
             var text = text1 + ";" + text2 + ";" + text3;
             var msg = "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

             $("#def_def").val("");
             $("#def_def_id").val("");
             $("#def_def_text").val("");

              Common.alert(msg);
              return false;
            }
        }
      } else if (prgmCde == 'SC') {
        $("#solut_code").val(itm.code);
        $("#solut_code_id").val(itm.id);
        $("#solut_code_text").val(itm.descp);
      }
    }
  }

  function fn_ReasonChk(obj, event) {
    var rslt;

    Common.ajaxSync("GET",
                              "/sales/order/checkDefectByReason.do",
                              { cmbReason : obj },
                              function(result) {
                                if (result != null) {
                                  if (event == "onchange") {
                                    if (result > 0) {
                                      $("#m1").show();
                                      $("#m2").show();
                                      $("#m3").show();
                                      return;
                                    } else {
                                      $("#m1").hide();
                                      $("#m2").hide();
                                      $("#m3").hide();
                                      return;
                                    }
                                  } else {
                                    rslt = result;
                                  }
                                }
                              });

    return rslt;
  }

  function displayVoucherSectionAexc(){
	  if($('#voucherTypeAexc option:selected').val() != null && $('#voucherTypeAexc option:selected').val() != "" && $('#voucherTypeAexc option:selected').val() != "0")
	  {
		  $('.voucherSectionAexc').show();
	  }
	  else{
		  $('.voucherSectionAexc').hide();
			clearVoucherDataAexc();
	  }
  }

  function applyVoucherAexc() {
	  var voucherCode = $('#voucherCodeAexc').val();
	  var voucherEmail = $('#voucherEmailAexc').val();
	  var voucherType = $('#voucherTypeAexc option:selected').val();

	  if(voucherCode.length == 0 || voucherEmail.length ==0){
		clearVoucherDataAexc();
		  Common.alert('Both voucher code and voucher email must be key in');
		  return;
	  }
	  Common.ajax("GET", "/misc/voucher/voucherVerification.do", {platform: voucherType, voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
	        if(result.code == "00") {
	        	voucherAppliedStatus = 1;
	        	$('#voucherMsgAexc').text('Voucher Applied for ' + voucherCode);
		      	voucherAppliedCode = voucherCode;
		      	voucherAppliedEmail = voucherEmail;
	        	$('#voucherMsgAexc').show();

	        	Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
	        		if(result.length > 0){
	        			voucherPromotionId = result;
	        			//voucherPromotionCheck();
	        			fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(), STOCK_ID, EMP_CHK, CUST_TYPE_ID, $("#exTradeAexc").val());
	        		}
	        		else{
	        			//reset everything
	    				clearVoucherDataAexc();
	        			Common.alert("No Promotion is being entitled for this voucher code");
	        			return;
	        		}
	        	});
	        }
	        else{
				clearVoucherDataAexc();
	        	Common.alert(result.message);
	        	return;
	        }
	  });
  }

  function voucherPromotionCheckAexc(){
	 if(voucherAppliedStatus == 1){
		displayVoucherSectionAexc();
		var orderPromoId = [];
		var orderPromoIdToRemove = [];
		$("#cmbPromotionAexc option").each(function()
		{
			  orderPromoId.push($(this).val());
	    });
		orderPromoIdToRemove = orderPromoId.filter(function(obj) {
		    return !voucherPromotionId.some(function(obj2) {
			        return obj == obj2;
		    });
		});

		if(orderPromoIdToRemove.length > 0){
		   	$('#cmbPromotionAexc').val('');
			for(var i = 0; i < orderPromoIdToRemove.length; i++){
				if(orderPromoIdToRemove[i] == ""){
				}
				else{
					$("#cmbPromotionAexc option[value='" + orderPromoIdToRemove[i] +"']").remove();
				}
			}
		}
	}
  }

  function clearVoucherDataAexc(){
	  $('#voucherCodeAexc').val('');
  		$('#voucherEmailAexc').val('');
		$('#voucherMsgAexc').hide();
		$('#voucherMsgAexc').text('');
	  voucherAppliedStatus = 0;
  	  voucherAppliedCode = "";
  	  voucherAppliedEmail = "";
      voucherPromotionId =[];

   	  $('#cmbPromotionAexc').val('');
   	  $('#cmbPromotionAexc option').remove();
   	  if($('#cmbAppTypeAexc').val() != null){
   		  fn_loadProductPromotionAexc($('#cmbAppTypeAexc').val(), STOCK_ID, EMP_CHK, CUST_TYPE_ID, $("#exTradeAexc").val());
   	  }
  }

  function applyCurrentUsedVoucherAexc(){
	  var voucherCode = "${orderDetail.basicInfo.voucherCode}";
      if(voucherCode != null && voucherCode != ""){
    	var voucherInfo = "${orderDetail.basicInfo.voucherInfo}";
        if(voucherInfo != null && voucherInfo != ""){
          	$('#voucherCodeAexc').val("${orderDetail.basicInfo.voucherInfo.voucherCode}");
          	$('#voucherEmailAexc').val("${orderDetail.basicInfo.voucherInfo.custEmail}");
          	$('#voucherTypeAexc').val("${orderDetail.basicInfo.voucherInfo.platformId}");

          	voucherAppliedStatus = 1;
    	  	var voucherCode = $('#voucherCodeAexc').val();
      		var voucherEmail = $('#voucherEmailAexc').val();
    		$('#voucherMsgAexc').text('Voucher Applied for ' + voucherCode);
    	  	voucherAppliedCode = voucherCode;
    	  	voucherAppliedEmail = voucherEmail;
    		$('#voucherMsgAexc').show();

    		Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
    			if(result.length > 0){
    				voucherPromotionId = result;
    				voucherPromotionCheckAexc();
    			}
    			else{
    				//reset everything
    				clearVoucherDataAexc();
    				Common.alert("No Promotion is being entitled for this voucher code");
    				return;
    			}
    		});
        }
      }
	}

  function displayVoucherSectionPrdEx(){
	  if($('#voucherTypePrdEx option:selected').val() != null && $('#voucherTypePrdEx option:selected').val() != "" && $('#voucherTypePrdEx option:selected').val() != "0")
	  {
		  $('.voucherSectionPrdEx').show();
	  }
	  else{
		  $('.voucherSectionPrdEx').hide();
			clearVoucherDataPrdEx();
	  }
  }

  function applyVoucherPrdEx() {
	  var voucherCode = $('#voucherCodePrdEx').val();
	  var voucherEmail = $('#voucherEmailPrdEx').val();
	  var voucherType = $('#voucherTypePrdEx option:selected').val();

	  if(voucherCode.length == 0 || voucherEmail.length ==0){
		clearVoucherDataPrdEx();
		  Common.alert('Both voucher code and voucher email must be key in');
		  return;
	  }
	  Common.ajax("GET", "/misc/voucher/voucherVerification.do", {platform: voucherType, voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
	        if(result.code == "00") {
	        	voucherAppliedStatus = 1;
	        	$('#voucherMsgPrdEx').text('Voucher Applied for ' + voucherCode);
		      	voucherAppliedCode = voucherCode;
		      	voucherAppliedEmail = voucherEmail;
	        	$('#voucherMsgPrdEx').show();

	        	Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
	        		if(result.length > 0){
	        			voucherPromotionId = result;
	        			//voucherPromotionCheck();
	        			var stkIdVal = $("#cmbOrderProduct").val();
				        if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
				          SRV_PAC_ID = 0;
				        }
	        			fn_loadProductPromotion(APP_TYPE_ID, stkIdVal, EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
	        		}
	        		else{
	        			//reset everything
	    				clearVoucherDataPrdEx();
	        			Common.alert("No Promotion is being entitled for this voucher code");
	        			return;
	        		}
	        	});
	        }
	        else{
	        	clearVoucherDataPrdEx();
	        	Common.alert(result.message);
	        	return;
	        }
	  });
  }

  function voucherPromotionCheckPrdEx(){
		 if(voucherAppliedStatus == 1){
			displayVoucherSectionPrdEx();
			var orderPromoId = [];
			var orderPromoIdToRemove = [];
			$("#cmbPromotion option").each(function()
			{
				  orderPromoId.push($(this).val());
		    });
			orderPromoIdToRemove = orderPromoId.filter(function(obj) {
			    return !voucherPromotionId.some(function(obj2) {
				        return obj == obj2;
			    });
			});

			if(orderPromoIdToRemove.length > 0){
			   	$('#cmbPromotion').val('');
				for(var i = 0; i < orderPromoIdToRemove.length; i++){
					if(orderPromoIdToRemove[i] == ""){
					}
					else{
						$("#cmbPromotion option[value='" + orderPromoIdToRemove[i] +"']").remove();
					}
				}
			}
		}
	  }

  	function clearVoucherDataPrdEx(){
		$('#voucherCodePrdEx').val('');
	  	$('#voucherEmailPrdEx').val('');
		$('#voucherMsgPrdEx').hide();
		$('#voucherMsgPrdEx').text('');
		voucherAppliedStatus = 0;
	  	voucherAppliedCode = "";
	  	voucherAppliedEmail = "";
	    voucherPromotionId =[];

	    $('#cmbPromotion').val('');
	   	$('#cmbPromotion option').remove();

	   	//reload promotion
	   	var stkIdVal = $("#cmbOrderProduct").val();

	   	// add only combo will reset pac id. ticket 24035325
	   	if(stkIdVal != null){
	        if (APP_TYPE_ID == 67 || APP_TYPE_ID == 68) {
	            SRV_PAC_ID = 0;
	          }
	   	}

		fn_loadProductPromotion(APP_TYPE_ID, stkIdVal, EMP_CHK, CUST_TYPE_ID, EX_TRADE, SRV_PAC_ID);
  	}

  function applyCurrentUsedVoucherPrdEx(){
	  var voucherCode = "${orderDetail.basicInfo.voucherCode}";
      if(voucherCode != null && voucherCode != ""){
    	var voucherInfo = "${orderDetail.basicInfo.voucherInfo}";
        if(voucherInfo != null && voucherInfo != ""){
          	$('#voucherCodePrdEx').val("${orderDetail.basicInfo.voucherInfo.voucherCode}");
          	$('#voucherEmailPrdEx').val("${orderDetail.basicInfo.voucherInfo.custEmail}");
          	$('#voucherTypePrdEx').val("${orderDetail.basicInfo.voucherInfo.platformId}");

          	voucherAppliedStatus = 1;
    	  	var voucherCode = $('#voucherCodePrdEx').val();
      		var voucherEmail = $('#voucherEmailPrdEx').val();
    		$('#voucherMsgPrdEx').text('Voucher Applied for ' + voucherCode);
    	  	voucherAppliedCode = voucherCode;
    	  	voucherAppliedEmail = voucherEmail;
    		$('#voucherMsgPrdEx').show();

    		Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
    			if(result.length > 0){
    				voucherPromotionId = result;
    				voucherPromotionCheckPrdEx();
    			}
    			else{
    				//reset everything
    				clearVoucherDataPrdEx();
    				Common.alert("No Promotion is being entitled for this voucher code");
    				return;
    			}
    		});
        }
      }
	}

  function checkExtradePreBookEligible(custId,salesOrdIdOld){
	   Common.ajax("GET", "/sales/order/preBooking/selectPreBookOrderEligibleCheck.do", {custId : custId , salesOrdIdOld : salesOrdIdOld}, function(result) {
		   if(result == null){
			   $('#hiddenPreBook').val('0');
			   $('#hiddenMonthExpired').val('0');
			   }else{
			   $('#hiddenPreBook').val('1');
			   $('#hiddenMonthExpired').val(result.monthExpired);
			   }
	   });
 }

  function checkOldOrderServiceExpiryMonth(custId,salesOrdIdOld){
	   Common.ajax("GET", "/sales/order/checkOldOrderServiceExpiryMonth.do", {custId : custId , salesOrdIdOld : salesOrdIdOld}, function(result) {
		    if(result == null){
			   $('#hiddenMonthExpired').val('0');
			}else{
			   $('#hiddenMonthExpired').val(result.monthExpired);
		    }
	   });
  }

  function fn_checkSrvType(val){
	  $("#srvTypeLbl").find("span").remove();
	  preSrvType = val;
	  if(preSrvType == "HS"){
		  $('[name="reqSrvType"]').prop("disabled", true);
		  $('#reqSrvTypeHS').prop("checked", true);
		  $("#selfSrvPvLbl").hide();
	  }else if(preSrvType == "SS"){
		  $('[name="reqSrvType"]').prop("disabled", true);
		  $('#reqSrvTypeSS').prop("checked", true);
		  $("#srvTypeLbl").append("<span><spring:message code='sales.text.serviceTypeDiscountMessage'/></span>");
		  $('#ordPvSs').val(totPvSs);
		  $("#selfSrvPvLbl").show();

	  }else if(preSrvType == "BOTH"){
		  $('[name="reqSrvType"]').prop("disabled", false);
		  $('#reqSrvTypeHS').prop("checked", true);
		  $("#selfSrvPvLbl").hide();
	  }else{
		  $('[name="reqSrvType"]').prop("disabled", true);
		  $('#reqSrvTypeHS').prop("checked", true);
		  $("#selfSrvPvLbl").hide();
	  }
  }

  function fn_resetPreSrvType(){
	  $('[name="reqSrvType"]').prop("disabled", true);
      $("#srvTypeLbl").find("span").remove();
      $('[name="reqSrvType"]').prop("checked", false);
      $("#selfSrvPvLbl").hide();
      $('#reqSrvTypeHS').prop("checked", true);
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1 id="hTitle">
      <spring:message code="sal.page.title.ordReq" />
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnCloseReq" href="#"><spring:message code="sal.btn.close" /></a></p></li>
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
              <td>
                <select id="ordReqType" class="mr5"></select>
                <p class="btn_sky"><a id="btnEditType" href="#"><spring:message code="sal.btn.confirm" /></a></p>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </form>
    </section>
    <!-- search_table end -->
    <!--
      ****************************************************************************
                                         Order Detail Page Include START
      *****************************************************************************
    -->
    <jsp:include page="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"/>
    <!--
      ****************************************************************************
                                         Order Detail Page Include END
      *****************************************************************************
    -->
    <!--
      ****************************************************************************
                                         Order Cancellation Request START
      *****************************************************************************
    -->
    <section id="scCN" class="blind">
      <aside class="title_line">
        <!-- title_line start -->
        <!--<h3>
          <spring:message code="sales.subTitle.ordCanReqInfo" />
        </h3>-->
      </aside>
      <!-- title_line end -->
      <section class="search_table">
        <!-- search_table start -->
        <form id="frmReqCanc" action="#" method="post">
          <input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
          <article class="acodi_wrap">
            <dl>
              <dt class="click_add_on on">
                <a href="#"> <spring:message code="sales.subTitle.ordCanReqInfo" /></a>
              </dt>
              <dd>
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
                      <th scope="row"><spring:message code="sal.text.requestor" /><span class="must"> *</span></th>
                      <td>
                        <select id="cmbRequestor" name="cmbRequestor" class="w100p"></select>
                      </td>
                      <th scope="row"><spring:message code="sal.text.callLogDate" /><span class="must"> *</span></th>
                      <td>
                        <input id="dpCallLogDate" name="dpCallLogDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.reason" /><span class="must">*</span></th>
                      <td>
                        <select id="cmbReason" name="cmbReason" class="w100p"></select>
                      </td>
                      <th scope="row"><spring:message code="sal.alert.msg.prefRtrnDt" /><span id="spPrfRtnDt" class="must blind">*</span></th>
                      <td>
                        <input id="dpReturnDate" name="dpReturnDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" disabled />
                      </td>
                    </tr>
                    <th scope="row"><spring:message code="sal.alert.msg.prefRtrnDt" /><span id="spPrfRtnDt" class="must blind">*</span></th>
                      <td>
                        <input id="dpReturnDate" name="dpReturnDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" disabled />
                      </td>
                    </tr>

                    <c:if test='${orderDetail.basicInfo.ordStusId == 4 }'>
                    <tr>
                        <th>Follow up by</th>
                        <td>
                            <select id="cmbFollowUp" name="cmbFollowUp" class="w100p" ><span class="must">*</span></select>
                        </td>
                    </tr>
                    </c:if>

                    <tr>
                      <th scope="row"><spring:message code="sal.text.ocrRem" /><span class="must">*</span></th>
                      <td colspan="3">
                        <textarea id="txtRemark" name="txtRemark" cols="20" rows="5"></textarea>
                      </td>
                    </tr>
                    <tr>
                    <th scope="row">Attachment</th>
                    <td >
                    <div class="auto_file2">
                    <input type="file" title="file add" id="attchmentFile" accept=".zip"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' />
                <span class='label_text'><a href='#'>Upload</a></span>
            </label>
        </div>
    </td>
</tr>


                  </tbody>
                </table>
              </dd>
            </dl>
          </article>
          <!-- table end -->
          <!--
      ****************************************************************************
                                         Outstanding & Penalty Info Edit START
      *****************************************************************************
          -->
          <section id="scOP" class="blind">
            <aside class="title_line">
              <!-- title_line start -->
              <!-- <h3>
                <spring:message code="sal.page.subTitle.outstndPnltyInfo" />
              </h3>  -->
            </aside>
            <!-- title_line end -->
            <article class="acodi_wrap">
              <dl>
                <dt class="click_add_on on">
                  <a href="#"> <spring:message code="sal.page.subTitle.outstndPnltyInfo" /></a>
                </dt>
                <dd>
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
                        <th scope="row"><spring:message code="sales.TotalUsedMonth" /></th>
                        <td>
                          <input id="txtTotalUseMth" name="txtTotalUseMth" type="text" class="w100p readonly" value="0" readonly>
                        </td>
                        <th scope="row"><spring:message code="sal.text.obligationPeriod" /></th>
                        <td>
                          <input id="txtObPeriod" name="txtObPeriod" type="text" class="w100p readonly" value="24" readonly>
                        </td>
                        <th scope="row"><spring:message code="sal.title.text.rentalFees" /></th>
                        <td>
                          <input id="txtRentalFees" name="txtRentalFees" type="text" value="0" class="w100p readonly" readonly>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sales.PenaltyCharge" /></th>
                        <td>
                          <input id="txtPenaltyCharge" name="txtPenaltyCharge" type="text" class="w100p readonly" value="0" readonly>
                        </td>
                        <th scope="row"><spring:message code="sal.text.penaltyAdjustment" /><span class="must">*</span></th>
                        <td>
                          <input id="txtPenaltyAdj" name="txtPenaltyAdj" type="text" value="0" title="" placeholder="Penalty Adjustment" class="w100p" />
                        </td>
                        <th scope="row"><spring:message code="sal.text.currOutstnd" /></th>
                        <td>
                          <input id="txtCurrentOutstanding" name="txtCurrentOutstanding" type="text" value="0" class="w100p readonly" readonly>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row" colspan="5"><spring:message code="sales.totAmt_RM" /></th>
                        <td class="bg-black">
                          <span id="spTotalAmount"></span> <input id="txtTotalAmount" name="txtTotalAmount" type="hidden" value="0" />
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </dd>
              </dl>
            </article>
            <!-- table end -->
          </section>
          <!--
      ****************************************************************************
                                         Outstanding & Penalty Info Edit END
      *****************************************************************************
          -->
        </form>
      </section>
      <!-- search_table end -->
      <ul class="center_btns">
        <li><p class="btn_blue2"><a id="btnReqCancOrder" href="#"><spring:message code="sal.text.reqCancOrd" /></a></p></li>
      </ul>
    </section>
    <!--
      ****************************************************************************
                                         Order Cancellation Request END
      *****************************************************************************
    -->
    <!--
      ****************************************************************************
                                         Order Product Exchange Request START
      *****************************************************************************
    -->
    <section id="scPX" class="blind">
      <aside class="title_line">
        <!-- title_line start -->
        <!-- <h3>
          <spring:message code="sal.text.prodExchInfo" />
        </h3> -->
      </aside>
      <!-- title_line end -->
      <section class="search_table">
        <!-- search_table start -->
        <form id="frmReqPrdExc" action="#" method="post">
          <input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" /> <input id="hiddenFreeASID" name="hiddenFreeASID" type="hidden" value="" /> <input id="hiddenPriceID" name="hiddenPriceID" type="hidden" value="" /> <input id="hiddenCurrentProductMasterStockID" name="hiddenCurrentProductMasterStockID" type="hidden" value="${orderDetail.basicInfo.masterStkId}" /> <input id="hiddenCurrentProductID" name="hiddenCurrentProductID" type="hidden" value="${orderDetail.basicInfo.stockId}" /> <input id="hiddenCurrentPromotionID" name="hiddenCurrentPromotionID" type="hidden" value="${orderDetail.basicInfo.ordPromoId}" /> <input id="hiddenCurrentPromotion" name="hiddenCurrentPromotion" type="hidden" value="${orderDetail.basicInfo.ordPromoDesc}" />
          <input name="hiddenSrvType" type="hidden" value="${orderDetail.orderCfgInfo.srvType}" />
          <input name="hiddenSrvPacId" type="hidden" value="${orderDetail.basicInfo.srvPacId}" />
          <article class="acodi_wrap">
            <dl>
              <dt class="click_add_on on">
                <a href="#"> <spring:message code="sal.text.prodExchInfo" /></a>
              </dt>
              <dd>
                <table class="type1">
                  <!-- table start -->
                  <caption>table</caption>
                  <colgroup>
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 160px" />
                    <col style="width: *" />
                  </colgroup>
                  <tbody>
                     <tr>
				        <th scope="row">Voucher Type<span class="must">*</span></th>
					    <td colspan="3">
						    <p> <select id="voucherTypePrdEx" name="voucherTypePrdEx" onchange="displayVoucherSectionPrdEx()" class="w100p"></select></p>
					        <p class="voucherSectionPrdEx"><input id="voucherCodePrdEx" name="voucherCode" type="text" title="Voucher Code" placeholder="Voucher Code" class="w100p"/></p>
					        <p class="voucherSectionPrdEx"><input id="voucherEmailPrdEx" name="voucherEmail" type="text" title="Voucher Email" placeholder="Voucher Email" class="w100p"/></p>
					        <p style="width: 70px;" class="voucherSectionPrdEx btn_grid"><a id="btnVoucherApplyPrdEx" href="#" onclick="javascript:applyVoucherPrdEx()">Apply</a></p>
					        <br/><p style="display:none; color:red;font-size:10px;float: right;" id="voucherMsgPrdEx"></p>
					    </td>
				    </tr>
                    <tr>
                      <th scope="row">Product<span class="must">*</span></th>
                      <td>
                        <select id="cmbOrderProduct" name="cmbOrderProduct" class="w100p"></select>
                      </td>
                      <th scope="row"><spring:message code="sal.title.text.priceRpfRm" /></th>
                      <td>
                        <input id="ordPrice" name="ordPrice" type="text" title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly /> <input id="ordPriceId" name="ordPriceId" type="hidden" /> <input id="orgOrdPrice" name="orgOrdPrice" type="hidden" /> <input id="orgOrdPv" name="orgOrdPv" type="hidden" /> <input id="ordPvGST" name="ordPvGST" type="hidden" />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.title.text.promo" /><span class="must">*</span></th>
                      <td>
                        <select id="cmbPromotion" name="cmbPromotion" class="w100p"></select>
                      </td>
                      <th scope="row"><spring:message code="sal.title.text.nomalRentFeeRm" /></th>
                      <td>
                        <input id="orgOrdRentalFees" name="orgOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code='sales.srvType'/><span class="must">*</span></th>
    					<td><input id="reqSrvTypeHS" name="reqSrvType" type="radio" value="HS" /><span><spring:message code='sales.text.heartService'/></span>
        					<input id="reqSrvTypeSS" name="reqSrvType" type="radio" value="SS" /><span><spring:message code='sales.text.selfService'/></span>
    					</td>
                      <th scope="row"><spring:message code="sal.text.dscntPeriodFinalRenFee" /></th>
                      <td>
                        <p><select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p" disabled></select></p>
                        <p><input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder="" style="width: 42px;" class="readonly" readonly /></p>
                        <p><input id="ordRentalFees" name="ordRentalFees" type="text" title="" placeholder="" style="width: 90px;" class="readonly" readonly /></p>
                      </td>
                    </tr>
                    <tr>
                    	<th></th>
    					<td><label id="srvTypeLbl"></label></td>
						<th scope="row"><spring:message code="sal.title.text.pv" /></th>
                      	<td>
                        <input id="ordPv" name="ordPv" type="text" title="" placeholder="Point Value (PV)" class="w100p readonly" readonly />
                      	</td>
					</tr>
					<tr id = "selfSrvPvLbl">
						<th></th>
    					<td></td>
    					<th scope="row">SS <spring:message code="sal.title.text.pv" /><span class="must">*</span></th>
    					<td><input id="ordPvSs" name="ordPvSs" type="text" title="" placeholder="Self Service Point Value (SS PV)" class="w100p readonly" readonly />
    					</td>
					</tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.applyCurrPromo" /></th>
                      <td colspan="3">
                        <input id="btnCurrentPromo" name="btnCurrentPromo" value="1" type="checkbox" disabled />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.callLogDate" /><span class="must">*</span></th>
                      <td>
                        <input id="dpCallLogDateExch" name="dpCallLogDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                      </td>
                      <th scope="row"><spring:message code="sal.text.reason" /><span class="must">*</span></th>
                      <td>
                        <select id="cmbReasonExch" name="cmbReason" class="w100p" onchange="fn_ReasonChk(this.value, 'onchange')"></select>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.pexRem" /></th>
                      <td colspan="3">
                        <textarea id="txtRemarkExch" name="txtRemark" cols="20" rows="5"></textarea>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </dd>
            </dl>
          </article>
          <article class="acodi_wrap">
            <dl>
              <dt class="click_add_on on">
                <a href="#"><spring:message code='service.title.pexDefEnt' /></a>
              </dt>
              <dd id='defEvt_div'>
                <table class="type1">
                  <!-- table start -->
                  <caption>table</caption>
                  <colgroup>
                    <col style="width: 140px" />
                    <col style="width: *" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <th scope="row"><spring:message code='service.text.defPrt' /><span id='m1' name='m1' class='must' style="display:none"> *</span></th>
                      <td>
                        <input type="text" title="" placeholder="" disabled="disabled" id='def_part' name='def_part' class="" onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DP" onclick="fn_dftTyp('DP')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" /> <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' class="" disabled style="width: 60%;" />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code='service.text.dtlDef' /><span id='m2' name='m2' class='must' style="display:none"> *</span></th>
                      <td>
                        <input type="text" title="" placeholder="" disabled="disabled" id='def_def' name='def_def' class="" onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DD" onclick="fn_dftTyp('DD')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" /> <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' class="" disabled style="width: 60%;" />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code='service.text.defCde' /><span id='m3' name='m3' class='must' style="display:none"> *</span></th>
                      <td>
                        <input type="text" title="" placeholder="" disabled="disabled" id='def_code' name='def_code' class="" onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DC" onclick="fn_dftTyp('DC')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" /> <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width: 60%;" />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </dd>
            </dl>
          </article>
          <!-- table end -->
        </form>
      </section>
      <!-- search_table end -->
      <ul class="center_btns">
        <li><p class="btn_blue2"><a id="btnReqPrdExch" href="#"><spring:message code="sal.btn.reqProdExchg" /></a></p></li>
      </ul>
    </section>
    <!--
      ****************************************************************************
                                         Order Product Exchange Request END
      *****************************************************************************
    -->
    <!--
      ****************************************************************************
                                         Order Scheme Conversion Request START
      *****************************************************************************
    -->
    <section id="scSC" class="blind">
      <aside class="title_line">
        <!-- title_line start -->
        <!-- <h3>
          <spring:message code="sal.page.subTitle.filterInfo" />
        </h3>  -->
      </aside>
      <!-- title_line end -->
      <article class="grid_wrap">
        <!-- grid_wrap start -->
        <div id="grid_filter_wrap" style="width: 100%;
  height: 200;
  margin: 0 auto;"></div>
      </article>
      <!-- grid_wrap end -->
      <aside class="title_line">
        <!-- title_line start -->
        <!-- <h3>
          <spring:message code="sal.page.schemSel" />
        </h3> -->
      </aside>
      <article class="acodi_wrap">
        <dl>
          <dt class="click_add_on on">
            <a href="#"> <spring:message code="sal.page.subTitle.filterInfo" /></a>
          </dt>
          <dd>
            <!-- title_line end -->
            <section class="search_table">
              <!-- search_table start -->
              <form id="frmReqSchmConv" action="#" method="post">
                <input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" /> <input name="appTypeId" type="hidden" value="${orderDetail.basicInfo.appTypeId}" /> <input name="schemePromoId" type="hidden" value="${orderDetail.basicInfo.ordPromoId}" /> <input name="schemeStockId" type="hidden" value="${orderDetail.basicInfo.stockId}" /> <input id="cmbSchemeSchmText" name="cmbSchemeSchmText" type="hidden" value="${orderDetail.basicInfo.stockId}" />
                <article class="acodi_wrap">
                  <dl>
                    <dt class="click_add_on on">
                      <a href="#"> <spring:message code="sal.page.schemSel" /></a>
                    </dt>
                    <dd>
                      <table class="type1">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                          <col style="width: 160px" />
                          <col style="width: *" />
                        </colgroup>
                        <tbody>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.scheme" /><span class="must">*</span></th>
                            <td>
                              <select id="cmbSchemeSchm" name="cmbScheme" class="w100p"></select>
                            </td>
                          </tr>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.remark" /></th>
                            <td>
                              <input id="txtRemarkSchm" name="txtRemark" type="text" title="" placeholder="Remark" class="w100p" />
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </dd>
                  </dl>
                </article>
                <!-- table end -->
              </form>
            </section>
            <!-- search_table end -->
            <ul class="center_btns">
              <li><p class="btn_blue2"><a id="btnReqSchmConv" href="#"><spring:message code="sal.btn.reqSchemChg" /></a></p></li>
            </ul>
    </section>
    <!--
      ****************************************************************************
                                         Order Scheme Conversion Request END
      *****************************************************************************
    -->
    <!--
      ****************************************************************************
                                         Application Type Exchange Request START
      *****************************************************************************
    -->
    <section id="scAE" class="blind">
      <aside class="title_line">
        <!-- title_line start -->
        <!-- <h3>
          <spring:message code="sal.page.subTitle.appTypeExchgInfo" />
        </h3> -->
      </aside>
      <!-- title_line end -->
      <section class="search_table">
        <!-- search_table start -->
        <form id="frmReqAppExc" action="#" method="post">
          <input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
          <input name="appTypeId" type="hidden" value="${orderDetail.basicInfo.appTypeId}" />
          <input id="hiddenProductID" name="hiddenProductID" type="hidden" value="${orderDetail.basicInfo.stockId}" />
          <article class="acodi_wrap">
            <dl>
              <dt class="click_add_on on">
                <a href="#"> <spring:message code="sal.page.subTitle.appTypeExchgInfo" /></a>
              </dt>
              <dd>
                <table class="type1">
                  <!-- table start -->
                  <caption>table</caption>
                  <colgroup>
                    <col style="width: 170px" />
                    <col style="width: *" />
                    <col style="width: 180px" />
                    <col style="width: *" />
                  </colgroup>
                  <tbody>
                     <tr>
				        <th scope="row">Voucher Type<span class="must">*</span></th>
					    <td colspan="3">
						    <p> <select id="voucherTypeAexc" name="voucherTypeAexc" onchange="displayVoucherSectionAexc()" class="w100p"></select></p>
					        <p class="voucherSectionAexc"><input id="voucherCodeAexc" name="voucherCode" type="text" title="Voucher Code" placeholder="Voucher Code" class="w100p"/></p>
					        <p class="voucherSectionAexc"><input id="voucherEmailAexc" name="voucherEmail" type="text" title="Voucher Email" placeholder="Voucher Email" class="w100p"/></p>
					        <p style="width: 70px;" class="voucherSectionAexc btn_grid"><a id="btnVoucherApplyAexc" href="#" onclick="javascript:applyVoucherAexc()">Apply</a></p>
					        <br/><p style="display:none; color:red;font-size:10px;float: right;" id="voucherMsgAexc"></p>
					    </td>
				    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.appType" /><span class="must">*</span></th>
                      <td>
                        <p><select id="cmbAppTypeAexc" name="cmbAppType" class="w100p"></select> </select></p>
                        <p><select id="srvPacIdAexc" name="srvPacId" class="w100p"></select></p>
                      </td>
                      <th scope="row"><spring:message code="sales.extrade" /><span class="must blind">*</span></th>
                      <td>
                        <p><select id="exTradeAexc" name="exTrade" class="w100p"></select></p>
                        <p><input id="relatedNoAexc" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly />
                        </p>
                        <input id="hiddenMonthExpired" name="hiddenMonthExpired" type="hidden" />
        				<input id="hiddenPreBook" name="hiddenPreBook" type="hidden" />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.product" /><span class="must">*</span></th>
                      <td>
                        <span>${orderDetail.basicInfo.stockDesc}</span>
                      </td>
                      <th scope="row"><spring:message code="sal.title.text.instDuration" /><span id="spInstDur" class="must blind">*</span></th>
                      <td>
                        <input id="txtInstallmentDurationAexc" name="txtInstallmentDuration" type="text" title="" placeholder="Installmen Duration (1-36 months)" class="w100p" disabled />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.title.text.promo" /><span class="must">*</span></th>
                      <td>
                        <select id="cmbPromotionAexc" name="cmbPromotion" class="w100p" disabled></select>
                      </td>
                      <th scope="row"><spring:message code="sal.text.reason" /><span class="must">*</span></th>
                      <td>
                        <select id="cmbReasonAexc" name="cmbReason" class="w100p"></select>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.prcRpf" /><span id="spPrice" class="must blind">*</span></th>
                      <td>
                        <input id="txtPriceAexc" name="txtPrice" type="text" title="" placeholder="Price/RPF" class="w100p readonly" readonly /> <input id="orgOrdPriceAexc" name="orgOrdPrice" type="hidden" /> <input id="ordPriceIdAexc" name="ordPriceId" type="hidden" /> <input id="orgOrdPriceIdAexc" name="orgOrdPriceId" type="hidden" /> <input id="orgOrdPvAexc" name="orgOrdPv" type="hidden" />
                      </td>
                      <th scope="row"><spring:message code="sal.title.text.nomalRentFeeRm" /></th>
                      <td>
                        <input id="orgOrdRentalFeesAexc" name="orgOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.title.text.pv" /><span id="spPV" class="must blind">*</span></th>
                      <td>
                        <input id="txtPVAexc" name="txtPV" type="text" title="" placeholder="PV" class="w100p readonly" readonly /> <input id="ordPvGSTAexc" name="ordPvGST" type="hidden" />
                      </td>
                      <th scope="row"><spring:message code="sal.text.dscntPeriodFinalRenFee" /></th>
                      <td>
                        <p><select id="promoDiscPeriodTpAexc" name="promoDiscPeriodTp" class="w100p" disabled></select></p>
                        <p><input id="promoDiscPeriodAexc" name="promoDiscPeriod" type="text" title="" placeholder="" style="width: 42px;" class="readonly" readonly /></p>
                        <p><input id="ordRentalFeesAexc" name="ordRentalFees" type="text" title="" placeholder="" style="width: 90px;" class="readonly" readonly /></p>
                      </td>
                    </tr>
                    <tr>
                    <th scope="row">Attachment<span class="must">*</span></th>
                    <td >
                        <div class="auto_file2">
                        <input type="file" title="file add" id="attchmentFileAexc"  accept="zip,application/octet-stream,application/zip,application/x-zip,application/x-zip-compressed"/>
                          <label>
                                <input type='text' class='input_text' readonly='readonly'"/>
                                <span class='label_text'><a href='#'>Upload</a></span>
                            </label>
                        </div>
                    </td>
                    </tr>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.remark" /></th>
                      <td colspan="3">
                        <textarea id="txtRemarkAexc" name="txtRemark" cols="20" rows="5"></textarea>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </dd>
            </dl>
          </article>
          <!-- table end -->
        </form>
      </section>
      <!-- search_table end -->
      <ul class="center_btns">
        <li><p class="btn_blue2"><a id="btnReqAppExch" href="#"><spring:message code="sal.btn.exchgAppType" /></a></p></li>
      </ul>
    </section>
    <!--
      ****************************************************************************
                                         Application Type Exchange Request END
      *****************************************************************************
    -->
    <!--
      ****************************************************************************
                                         Ownership Transfer Request START
      *****************************************************************************
    -->
    <section id="scOT" class="blind">
      <form id="searchFormOwnt" name="searchForm" action="#" method="post">
        <input id="searchCustIdOwnt" name="custId" type="hidden" />
      </form>
      <form id="frmReqOwnt" name="frmReqOwnt" action="#" method="post">
        <input name="salesOrdId" type="hidden" value="${orderDetail.basicInfo.ordId}" /> <input name="hiddenCurrentCustID" type="hidden" value="${orderDetail.basicInfo.custId}" /> <input id="txtHiddenCustIDOwnt" name="txtHiddenCustID" type="hidden" /> <input id="hiddenCustTypeIDOwnt" name="hiddenCustTypeID" type="hidden" /> <input id="txtHiddenContactIDOwnt" name="txtHiddenContactID" type="hidden" /> <input id="txtHiddenAddressIDOwnt" name="txtHiddenAddressID" type="hidden" /> <input id="hiddenAppTypeIDOwnt" name="hiddenAppTypeID" type="hidden" /> <input id="txtHiddenInstAddressIDOwnt" name="txtHiddenInstAddressID" type="hidden" /> <input id="txtHiddenInstContactIDOwnt" name="txtHiddenInstContactID" type="hidden" /> <input id="isNewVer" name="isNewVer" type="hidden" value="${orderDetail.isNewVer}" />
        <aside class="title_line">
          <!-- title_line start -->
          <!-- <h3>
            <spring:message code="sal.page.subTitle.ownTransInfo" />
          </h3>  -->
        </aside>
        <article class="acodi_wrap">
          <dl>
            <dt class="click_add_on on">
              <a href="#"> <spring:message code="sal.page.subTitle.ownTransInfo" /></a>
            </dt>
            <dd>
              <!-- title_line end -->
              <section class="tap_wrap">
                <!-- tap_wrap start -->
                <ul class="tap_type1 num4">
                  <li id="tabCT"><a href="#" class="on"><spring:message code="sal.title.text.customer" /></a></li>
                  <li id="tabMA"><a href="#"><spring:message code="sal.title.text.mailingAddr" /></a></li>
                  <li id="tabCP"><a href="#"><spring:message code="sal.tap.title.contactPerson" /></a></li>
                  <li id="tabRP" class="blind"><a href="#"><spring:message code="sal.title.text.rentalPaySetting" /></a></li>
                  <li id="tabBG" class="blind"><a href="#"><spring:message code="sal.page.subtitle.rentalBillingGroup" /></a></li>
                  <li id="tabIN"><a href="#"><spring:message code="sal.text.inst" /></a></li>
                </ul>
                <article class="tap_area">
                  <!-- tap_area start -->
                  <ul class="right_btns mb10">
                    <li><p class="btn_grid"><a id="addCustBtn" href="#"><spring:message code="sal.btn.addNewCust" /></a></p></li>
                  </ul>
                  <section class="search_table">
                    <!-- search_table start -->
                    <table class="type1">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.customerId" /><span class="must">*</span></th>
                          <td>
                            <input id="custIdOwnt" name="txtCustID" type="text" title="" placeholder="Customer ID" class="" /><a class="search_btn" id="custBtnOwnt"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                          </td>
                          <th scope="row"><spring:message code="sal.text.type" /></th>
                          <td>
                            <input id="custTypeNmOwnt" name="txtCustType" type="text" title="" placeholder="Customer Type" class="w100p" readonly /> <input id="typeIdOwnt" name="hiddenCustTypeID" type="hidden" />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.name" /></th>
                          <td>
                            <input id="nameOwnt" name="txtCustName" type="text" title="" placeholder="Customer Name" class="w100p" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
                          <td>
                            <input id="nricOwnt" name="txtCustIC" type="text" title="" placeholder="NRIC/Company No" class="w100p" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.nationality" /></th>
                          <td>
                            <input id="nationNmOwnt" name="txtCustNationality" type="text" title="" placeholder="Nationality" class="w100p" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.race" /></th>
                          <td>
                            <input id="raceOwnt" name="txtCustRace" type="text" title="" placeholder="Race" class="w100p" readonly /> <input id="raceIdOwnt" name="hiddenCustRaceID" type="hidden" />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.dob" /></th>
                          <td>
                            <input id="dobOwnt" name="txtCustDOB" type="text" title="" placeholder="DOB" class="w100p" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.gender" /></th>
                          <td>
                            <input id="genderOwnt" name="txtCustGender" type="text" title="" placeholder="Gender" class="w100p" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
                          <td>
                            <input id="pasSportExprOwnt" name="txtCustPassportExpiry" type="text" title="" placeholder="Passport Expiry" class="w100p" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
                          <td>
                            <input id="visaExprOwnt" name="txtCustVisaExpiry" type="text" title="" placeholder="Visa Expiry" class="w100p" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.email" /></th>
                          <td>
                            <input id="emailOwnt" name="txtCustEmail" type="text" title="" placeholder="Email Address" class="w100p" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.indutryCd" /></th>
                          <td>
                            <input id="corpTypeNmOwnt" name="corpTypeNm" type="text" title="" placeholder="Industry Code" class="w100p" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.employee" /><span class="must">*</span></th>
                          <td colspan="3">
                            <select id="empChkOwnt" name="empChk" class="w100p"></select>
                            </select>
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.remark" /></th>
                          <td colspan="3">
                            <textarea id="custRemOwnt" name="txtCustRemark" cols="20" rows="5" placeholder="Remark" readonly></textarea>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                  </section>
                  <!-- search_table end -->
                </article>
                <!-- tap_area end -->
                <article class="tap_area">
                  <!-- tap_area start -->
                  <section class="search_table">
                    <!-- search_table start -->
                    <ul class="right_btns mb10">
                      <li id="btnAddAddress" class="blind"><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
                      <li id="btnSelectAddress" class="blind"><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
                    </ul>
                    <table class="type1">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
                          <td colspan="3">
                            <input id="txtMailAddrDtlOwnt" name="txtMailAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.street" /></th>
                          <td colspan="3">
                            <input id="txtMailStreetOwnt" name="txtMailStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.area" /><span class="must">*</span></th>
                          <td colspan="3">
                            <input id="txtMailAreaOwnt" name="txtMailArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.city" /><span class="must">*</span></th>
                          <td>
                            <input id="txtMailCityOwnt" name="txtMailCity" type="text" title="" placeholder="City" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">*</span></th>
                          <td>
                            <input id="txtMailPostcodeOwnt" name="txtMailPostcode" type="text" title="" placeholder="Postcode" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.state" /><span class="must">*</span></th>
                          <td>
                            <input id="txtMailStateOwnt" name="txtMailState" type="text" title="" placeholder="State" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
                          <td>
                            <input id="txtMailCountryOwnt" name="txtMailCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly />
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                  </section>
                  <!-- search_table end -->
                </article>
                <!-- tap_area end -->
                <article class="tap_area">
                  <!-- tap_area start -->
                  <section class="search_table">
                    <!-- search_table start -->
                    <ul class="right_btns mb10">
                      <li id="btnAddContact" class="blind"><p class="btn_grid"><a id="mstCntcNewAddBtn" href="#"><spring:message code="sal.title.text.addNewCntc" /></a></p></li>
                      <li id="btnSelectContact" class="blind"><p class="btn_grid"><a id="mstCntcSelAddBtn" href="#"><spring:message code="sal.btn.selNewContact" /></a></p></li>
                    </ul>
                    <table class="type1">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
                          <td>
                            <input id="txtContactNameOwnt" name="txtContactName" type="text" title="" placeholder="Name" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.initial" /></th>
                          <td>
                            <input id="txtContactInitialOwnt" name="txtContactInitial" type="text" title="" placeholder="Initial" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.gender" /></th>
                          <td>
                            <input id="txtContactGenderOwnt" name="txtContactGender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.nric" /></th>
                          <td>
                            <input id="txtContactICOwnt" name="txtContactIC" type="text" title="" placeholder="NRIC" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.dob" /></th>
                          <td>
                            <input id="txtContactDOBOwnt" name="txtContactDOB" type="text" title="" placeholder="DOB" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.race" /></th>
                          <td>
                            <input id="txtContactRaceOwnt" name="txtContactRace" type="text" title="" placeholder="Race" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.email" /></th>
                          <td>
                            <input id="txtContactEmailOwnt" name="txtContactEmail" type="text" title="" placeholder="Email" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.dept" /></th>
                          <td>
                            <input id="txtContactDeptOwnt" name="txtContactDept" type="text" title="" placeholder="Department" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.post" /></th>
                          <td>
                            <input id="txtContactPostOwnt" name="txtContactPost" type="text" title="" placeholder="Post" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.telM" /></th>
                          <td>
                            <input id="txtContactTelMobOwnt" name="txtContactTelMob" type="text" title="" placeholder="Telephone Number (Mobile)" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.telR" /></th>
                          <td>
                            <input id="txtContactTelResOwnt" name="txtContactTelRes" type="text" title="" placeholder="Telephone Number (Residence)" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.telO" /></th>
                          <td>
                            <input id="txtContactTelOffOwnt" name="txtContactTelOff" type="text" title="" placeholder="Telephone Number (Office)" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.telF" /></th>
                          <td>
                            <input id="txtContactTelFaxOwnt" name="txtContactTelFax" type="text" title="" placeholder="Telephone Number (Fax)" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"></th>
                          <td></td>
                          <th scope="row"></th>
                          <td></td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                  </section>
                  <!-- search_table end -->
                </article>
                <!-- tap_area end -->
                <!--
      ****************************************************************************
                                                             Rental Pay Set
      *****************************************************************************
          -->
                <article id="atcRP" class="tap_area blind">
                  <!-- tap_area start -->
                  <section class="search_table">
                    <!-- search_table start -->
                    <table class="type1 mb1m">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.payByThirdParty" /></th>
                          <td colspan="3">
                            <label><input id="btnThirdPartyOwnt" name="btnThirdParty" type="checkbox" value="1" /><span></span></label>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                    <section id="sctThrdParty" class="blind">
                      <aside class="title_line">
                        <!-- title_line start -->
                        <h3>
                          <spring:message code="sal.text.thirdParty" />
                        </h3>
                      </aside>
                      <!-- title_line end -->
                      <ul class="right_btns mb10">
                        <li><p class="btn_grid"><a id="btnAddThirdParty" href="#"><spring:message code="sal.btn.addNewThirdParty" /></a></p></li>
                      </ul>
                      <!--
      ****************************************************************************
                                           Third Party - Form ID(thrdPartyForm)
      *****************************************************************************
                 -->
                      <table class="type1">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                          <col style="width: 170px" />
                          <col style="width: *" />
                          <col style="width: 190px" />
                          <col style="width: *" />
                        </colgroup>
                        <tbody>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.customerId" /><span class="must">*</span></th>
                            <td>
                              <input id="txtThirdPartyIDOwnt" name="txtThirdPartyID" type="text" title="" placeholder="Third Party ID" class="" /> <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input id="txtHiddenThirdPartyIDOwnt" name="txtHiddenThirdPartyID" type="hidden" />
                            </td>
                            <th scope="row"><spring:message code="sal.text.type" /></th>
                            <td>
                              <input id="txtThirdPartyTypeOwnt" name="txtThirdPartyType" type="text" title="" placeholder="Costomer Type" class="w100p readonly" readonly />
                            </td>
                          </tr>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.name" /></th>
                            <td>
                              <input id="txtThirdPartyNameOwnt" name="txtThirdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly />
                            </td>
                            <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
                            <td>
                              <input id="txtThirdPartyNRICOwnt" name="txtThirdPartyNRIC" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly />
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <!-- table end -->
                    </section>
                    <!--
      ****************************************************************************
                                        Rental Paymode - Form ID(rentPayModeForm)
      *****************************************************************************
                    -->
                    <section id="sctRentPayMode">
                      <table class="type1">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                          <col style="width: 170px" />
                          <col style="width: *" />
                          <col style="width: 190px" />
                          <col style="width: *" />
                        </colgroup>
                        <tbody>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.rentalPaymode" /><span class="must">*</span></th>
                            <td>
                              <select id="cmbRentPaymodeOwnt" name="cmbRentPaymode" class="w100p"></select>
                            </td>
                            <th scope="row"><spring:message code="sal.text.nricPassbook" /></th>
                            <td>
                              <input id="txtRentPayICOwnt" name="txtRentPayIC" type="text" title="" placeholder="NRIC appear on DD/Passbook" class="w100p" />
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <!-- table end -->
                    </section>
                    <section id="sctCrCard" class="blind">
                      <aside class="title_line">
                        <!-- title_line start -->
                        <h3>
                          <spring:message code="sal.page.subtitle.creditCard" />
                        </h3>
                      </aside>
                      <!-- title_line end -->
                      <ul class="right_btns mb10">
                        <li><p class="btn_grid"><a id="btnAddCRC" href="#"><spring:message code="sal.btn.addNewCreditCard" /></a></p></li>
                        <li><p class="btn_grid"><a id="btnSelectCRC" href="#"><spring:message code="sal.btn.selectAnotherCreditCard" /></a></p></li>
                      </ul>
                      <!--
      ****************************************************************************
                                        Credit Card - Form ID(crcForm)
      *****************************************************************************
               -->
                      <table class="type1 mb1m">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                          <col style="width: 170px" />
                          <col style="width: *" />
                          <col style="width: 190px" />
                          <col style="width: *" />
                        </colgroup>
                        <tbody>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.creditCardNumber" /><span class="must">*</span></th>
                            <td>
                              <input id="txtRentPayCRCNoOwnt" name="txtRentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly /> <input id="txtHiddenRentPayCRCIDOwnt" name="txtHiddenRentPayCRCID" type="hidden" /> <input id="hiddenRentPayEncryptCRCNoOwnt" name="hiddenRentPayEncryptCRCNo" type="hidden" />
                            </td>
                            <th scope="row"><spring:message code="sal.text.creditCardType" /></th>
                            <td>
                              <input id="txtRentPayCRCTypeOwnt" name="txtRentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p readonly" readonly />
                            </td>
                          </tr>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.nameOnCard" /></th>
                            <td>
                              <input id="txtRentPayCRCNameOwnt" name="txtRentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p readonly" readonly />
                            </td>
                            <th scope="row"><spring:message code="sal.text.expiry" /></th>
                            <td>
                              <input id="txtRentPayCRCExpiryOwnt" name="txtRentPayCRCExpiry" type="text" title="" placeholder="Credit Card Expiry" class="w100p readonly" readonly />
                            </td>
                          </tr>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.issueBank" /></th>
                            <td>
                              <input id="txtRentPayCRCBankOwnt" name="txtRentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly /> <input id="hiddenRentPayCRCBankIDOwnt" name="hiddenRentPayCRCBankID" type="hidden" title="" class="w100p" />
                            </td>
                            <th scope="row"><spring:message code="sal.text.cardType" /></th>
                            <td>
                              <input id="rentPayCRCCardTypeOwnt" name="rentPayCRCCardType" type="text" title="" placeholder="Card Type" class="w100p readonly" readonly />
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <!-- table end -->
                      <ul class="center_btns">
                        <li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
                      </ul>
                    </section>
                    <section id="sctDirectDebit" class="blind">
                      <aside class="title_line">
                        <!-- title_line start -->
                        <h3>
                          <spring:message code="sal.page.subtitle.directDebit" />
                        </h3>
                      </aside>
                      <!-- title_line end -->
                      <ul class="right_btns mb10">
                        <li><p class="btn_grid"><a id="btnAddBankAccount" href="#"><spring:message code="sal.btn.addNewBankAccount" /></a></p></li>
                        <li><p class="btn_grid"><a id="btnSelectBankAccount" href="#"><spring:message code="sal.btn.selectAnotherBankAccount" /></a></p></li>
                      </ul>
                      <!--
      ****************************************************************************
                                        Direct Debit - Form ID(ddForm)
      *****************************************************************************
               -->
                      <table class="type1">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                          <col style="width: 170px" />
                          <col style="width: *" />
                          <col style="width: 190px" />
                          <col style="width: *" />
                        </colgroup>
                        <tbody>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.accountNumber" /><span class="must">*</span></th>
                            <td>
                              <input id="txtRentPayBankAccNoOwnt" name="txtRentPayBankAccNo" type="text" title="" placeholder="Account Number readonly" class="w100p readonly" readonly /> <input id="txtHiddenRentPayBankAccIDOwnt" name="txtHiddenRentPayBankAccID" type="hidden" /> <input id="hiddenRentPayEncryptBankAccNoOwnt" name="hiddenRentPayEncryptBankAccNo" type="hidden" />
                            </td>
                            <th scope="row"><spring:message code="sal.text.accountType" /></th>
                            <td>
                              <input id="txtRentPayBankAccTypeOwnt" name="txtRentPayBankAccType" type="text" title="" placeholder="Account Type readonly" class="w100p readonly" readonly />
                            </td>
                          </tr>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.accountHolder" /></th>
                            <td>
                              <input id="txtRentPayBankAccNameOwnt" name="txtRentPayBankAccName" type="text" title="" placeholder="Account Holder" class="w100p readonly" readonly />
                            </td>
                            <th scope="row"><spring:message code="sal.text.issueBankBranch" /></th>
                            <td>
                              <input id="txtRentPayBankAccBankBranchOwnt" name="txtRentPayBankAccBankBranch" type="text" title="" placeholder="Issue Bank Branch" class="w100p readonly" readonly />
                            </td>
                          </tr>
                          <tr>
                            <th scope="row"><spring:message code="sal.text.issueBank" /></th>
                            <td colspan=3>
                              <input id="txtRentPayBankAccBankOwnt" name="txtRentPayBankAccBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly /> <input id="hiddenRentPayBankAccBankIDOwnt" name="hiddenRentPayBankAccBankID" type="hidden" />
                            </td>
                          </tr>
                        </tbody>
                      </table>
                      <!-- table end -->
                    </section>
                  </section>
                  <!-- search_table end -->
                </article>
                <!-- tap_area end -->
                <!--
      ****************************************************************************
                                                            Billing Group
      *****************************************************************************
           -->
                <article id="atcBG" class="tap_area blind">
                  <!-- tap_area start -->
                  <!-- New Billing Group Type start -->
                  <table class="type1">
                    <!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                      <col style="width: 150px" />
                      <col style="width: *" />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.groupOption" /><span class="must">*</span></th>
                        <td>
                          <label><input type="radio" id="grpOpt1" name="grpOpt" value="new" /><span><spring:message code="sal.btn.newBillingGroup" /></span></label> <label><input type="radio" id="grpOpt2" name="grpOpt" value="exist" /><span><spring:message code="sal.btn.existBillGrp" /></span></label>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  <!-- table end -->
                  <!--
      ****************************************************************************
                                      Billing Group Selection - Form ID(billPreferForm)
      *****************************************************************************
            -->
                  <section id="sctBillSel" class="blind">
                    <aside class="title_line">
                      <!-- title_line start -->
                      <h3>
                        <spring:message code="sal.page.subtitle.billingGroupSelection" />
                      </h3>
                    </aside>
                    <!-- title_line end -->
                    <table class="type1">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 150px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.billingGroup" /><span class="must">*</span></th>
                          <td>
                            <input id="txtBillGroupOwnt" name="txtBillGroup" type="text" title="" placeholder="Billing Group" class="readonly" readonly /><a id="billGrpBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input id="txtHiddenBillGroupIDOwnt" name="txtHiddenBillGroupID" type="hidden" />
                          </td>
                          <th scope="row"><spring:message code="sal.text.billingType" /><span class="must">*</span></th>
                          <td>
                            <input id="txtBillTypeOwnt" name="txtBillType" type="text" title="" placeholder="Billing Type" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.billingAddress" /></th>
                          <td colspan="3">
                            <textarea id="txtBillAddressOwnt" name="txtBillAddress" cols="20" rows="5" readonly></textarea>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                  </section>
                  <table class="type1">
                    <!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                      <col style="width: 150px" />
                      <col style="width: *" />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.remark" /></th>
                        <td>
                          <textarea id="txtBillGroupRemarkOwnt" name="txtBillGroupRemark" cols="20" rows="5" readonly></textarea>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  <!-- table end -->
                  <!-- Existing Type end -->
                </article>
                <!-- tap_area end -->
                <!--
      ****************************************************************************
                                                                Installation
      *****************************************************************************
            -->
                <article class="tap_area">
                  <!-- tap_area start -->
                  <aside class="title_line">
                    <!-- title_line start -->
                    <h3>
                      <spring:message code="sal.text.instAddr" />
                    </h3>
                  </aside>
                  <!-- title_line end -->
                  <section class="search_table">
                    <!-- search_table start -->
                    <ul class="right_btns mb10">
                      <li id="btnAddInstAddress" class="blind"><p class="btn_grid"><a id="billNewAddrBtn" href="#"><spring:message code="sal.text.instAddr" /></a></p></li>
                      <li id="btnSelectInstAddress" class="blind"><p class="btn_grid"><a id="billSelAddrBtn" href="#"><spring:message code="sal.title.text.selectAnotherAddress" /></a></p></li>
                    </ul>
                    <table class="type1">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
                          <td colspan="3">
                            <input id="txtInstAddrDtlOwnt" name="txtInstAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.street" /></th>
                          <td colspan="3">
                            <input id="txtInstStreetOwnt" name="txtInstStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.area" /><span class="must">*</span></th>
                          <td colspan="3">
                            <input id="txtInstAreaOwnt" name="txtInstArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.city" /><span class="must">*</span></th>
                          <td>
                            <input id="txtInstCityOwnt" name="txtMailCity" type="text" title="" placeholder="City" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">*</span></th>
                          <td>
                            <input id="txtInstPostcodeOwnt" name="txtMailPostcode" type="text" title="" placeholder="Postcode" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.state" /><span class="must">*</span></th>
                          <td>
                            <input id="txtInstStateOwnt" name="txtInstState" type="text" title="" placeholder="State" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
                          <td>
                            <input id="txtInstCountryOwnt" name="txtInstCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly />
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                    <aside class="title_line">
                      <!-- title_line start -->
                      <h3>
                        <spring:message code="sal.title.text.installCntcPerson" />
                      </h3>
                    </aside>
                    <!-- title_line end -->
                    <ul class="right_btns mb10">
                      <li id="btnAddInstContact" class="blind"><p class="btn_grid"><a id="mstCntcNewAddBtn" href="#"><spring:message code="sal.title.text.addNewCntc" /></a></p></li>
                      <li id="btnSelectInstContact" class="blind"><p class="btn_grid"><a id="mstCntcSelAddBtn" href="#"><spring:message code="sal.btn.selNewContact" /></a></p></li>
                    </ul>
                    <table class="type1">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
                          <td>
                            <input id="txtInstContactNameOwnt" name="txtInstContactName" type="text" title="" placeholder="Name" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.initial" /></th>
                          <td>
                            <input id="txtInstContactInitialOwnt" name="txtInstContactInitial" type="text" title="" placeholder="Initial" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.gender" /></th>
                          <td>
                            <input id="txtInstContactGenderOwnt" name="txtInstContactGender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.nric" /></th>
                          <td>
                            <input id="txtInstContactICOwnt" name="txtInstContactIC" type="text" title="" placeholder="NRIC" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.dob" /></th>
                          <td>
                            <input id="txtInstContactDOBOwnt" name="txtInstContactDOB" type="text" title="" placeholder="DOB" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.race" /></th>
                          <td>
                            <input id="txtInstContactRaceOwnt" name="txtInstContactRaceOwnt" type="text" title="" placeholder="Race" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.email" /></th>
                          <td>
                            <input id="txtInstContactEmailOwnt" name="txtInstContactEmail" type="text" title="" placeholder="Email" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.dept" /></th>
                          <td>
                            <input id="txtInstContactDeptOwnt" name="txtInstContactDept" type="text" title="" placeholder="Department" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.post" /></th>
                          <td>
                            <input id="txtInstContactPostOwnt" name="txtInstContactPost" type="text" title="" placeholder="Post" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.telM" /></th>
                          <td>
                            <input id="txtInstContactTelMobOwnt" name="txtInstContactTelMob" type="text" title="" placeholder="Telephone Number (Mobile)" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.telR" /></th>
                          <td>
                            <input id="txtInstContactTelResOwnt" name="txtInstContactTelRes" type="text" title="" placeholder="Telephone Number (Residence)" class="w100p readonly" readonly />
                          </td>
                          <th scope="row"><spring:message code="sal.text.telO" /></th>
                          <td>
                            <input id="txtInstContactTelOffOwnt" name="txtInstContactTelOff" type="text" title="" placeholder="Telephone Number (Office)" class="w100p readonly" readonly />
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.text.telF" /></th>
                          <td>
                            <input id="txtInstContactTelFaxOwnt" name="txtInstContactTelFax" type="text" title="" placeholder="Telephone Number (Fax)" class="w100p" />
                          </td>
                          <th scope="row"></th>
                          <td></td>
                          <th scope="row"></th>
                          <td></td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                    <aside class="title_line">
                      <!-- title_line start -->
                      <h3>
                        <spring:message code="sal.title.text.installInfomation" />
                      </h3>
                    </aside>
                    <!-- title_line end -->
                    <table class="type1">
                      <!-- table start -->
                      <caption>table</caption>
                      <colgroup>
                        <col style="width: 140px" />
                        <col style="width: *" />
                        <col style="width: 170px" />
                        <col style="width: *" />
                      </colgroup>
                      <tbody>
                        <tr>
                          <th scope="row"><spring:message code="sal.title.text.dscBrnch" /><span class="must">*</span></th>
                          <td colspan="3">
                            <select id="cmbDSCBranchOwnt" name="cmbDSCBranch" class="w100p"></select>
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.title.text.perferInstDate" /><span class="must">*</span></th>
                          <td>
                            <input id="dpPreferInstDateOwnt" name="dpPreferInstDate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                          </td>
                          <th scope="row"><spring:message code="sal.title.text.perferInstTime" /><span class="must">*</span></th>
                          <td>
                            <div class="time_picker w100p">
                              <!-- time_picker start -->
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
                            </div>
                            <!-- time_picker end -->
                          </td>
                        </tr>
                        <tr>
                          <th scope="row"><spring:message code="sal.title.text.specialInstruction" /><span class="must">*</span></th>
                          <td colspan=3>
                            <textarea id="txtInstSpecialInstructionOwnt" name="txtInstSpecialInstruction" cols="20" rows="5"></textarea>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- table end -->
                  </section>
                  <!-- search_table end -->
                </article>
                <!-- tap_area end -->
              </section>
              <!-- tap_wrap end -->
              <section class="search_table mt20">
                <!-- search_table start -->
                <table class="type1">
                  <!-- table start -->
                  <caption>table</caption>
                  <colgroup>
                    <col style="width: 140px" />
                    <col style="width: *" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <th scope="row"><spring:message code="sal.text.refNo" /></th>
                      <td>
                        <input id="txtReferenceNoOwnt" name="txtReferenceNo" type="text" title="" placeholder="" class="w100p" />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- table end -->
              </section>
            </dd>
          </dl>
        </article>
        <!-- search_table end -->
        <ul class="center_btns">
          <li><p class="btn_blue2"><a id="btnReqOwnTrans" href="#"><spring:message code="sal.btn.tranfOwn" /></a></p></li>
        </ul>
      </form>
    </section>
    <!--
      ****************************************************************************
                                         Ownership Transfer Request END
      *****************************************************************************
    -->
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->