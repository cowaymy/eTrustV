<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">

/* 커스텀 스타일 정의 */
.auto_file2 {
  width: 100% !important;
}

.auto_file2>label {
  width: 100% !important;
}

.auto_file2 label input[type=text] {
  width: 40% !important;
  float: left
}
</style>
<script type="text/javaScript">
  var TODAY_DD = "${toDay}";
  var BEFORE_DD = "${bfDay}";
  var blockDtFrom = "${hsBlockDtFrom}";
  var blockDtTo = "${hsBlockDtTo}";
  var preSrvType = "";
  var totPv = "";
  var totPvSs = "";

  //파일 저장 캐시
  var myFileCaches = {};

  //AUIGrid 생성 후 반환 ID
  var listGiftGridID;
  var appTypeData = [ {
    "codeId" : "66",
    "codeName" : "Rental"
  }, {
    "codeId" : "67",
    "codeName" : "Outright"
  }, {
    "codeId" : "68",
    "codeName" : "Instalment"
  } ];
  var MEM_TYPE = '${SESSION_INFO.userTypeId}';
  var atchFileGrpId = 0;
  var alwSale = 1;
  var voucherAppliedStatus = 0;
  var voucherAppliedCode = "";
  var voucherAppliedEmail = "";
  var voucherPromotionId = [];

  var codeList_19 = [];
  <c:forEach var="obj" items="${codeList_19}">
  codeList_19.push({
    codeId : "${obj.codeId}",
    codeName : "${obj.codeName}",
    code : "${obj.code}"
  });
  </c:forEach>

  var codeList_325 = [];
  <c:forEach var="obj" items="${codeList_325}">
  codeList_325.push({
    codeId : "${obj.codeId}",
    codeName : "${obj.codeName}",
    code : "${obj.code}"
  });
  </c:forEach>

  var codeList_415 = [];
  <c:forEach var="obj" items="${codeList_415}">
  codeList_415.push({
    codeId : "${obj.codeId}",
    codeName : "${obj.codeName}",
    code : "${obj.code}"
  });
  </c:forEach>

  var codeList_416 = [];
  <c:forEach var="obj" items="${codeList_416}">
  codeList_416.push({
    codeId : "${obj.codeId}",
    codeName : "${obj.codeName}",
    code : "${obj.code}"
  });
  </c:forEach>

  var branchCdList_1 = [];
  <c:forEach var="obj" items="${branchCdList_1}">
  branchCdList_1.push({
    codeId : "${obj.codeId}",
    codeName : "${obj.codeName}",
    code : "${obj.code}"
  });
  </c:forEach>

  var branchCdList_5 = [];
  <c:forEach var="obj" items="${branchCdList_5}">
  branchCdList_5.push({
    codeId : "${obj.codeId}",
    codeName : "${obj.codeName}",
    code : "${obj.code}"
  });
  </c:forEach>

  var codeList_562 = [];
  codeList_562.push({
    codeId : "0",
    codeName : "No",
    code : "No"
  });
  <c:forEach var="obj" items="${codeList_562}">
  codeList_562.push({
    codeId : "${obj.codeId}",
    codeName : "${obj.codeName}",
    code : "${obj.code}"
  });
  </c:forEach>

  var checkFileValid = true;

  $(document).ready(
      function() {

        createAUIGridStk();

        doDefCombo(appTypeData, '', 'appType', 'S', ''); // Status 생성
        doDefCombo(codeList_19, '', 'rentPayMode', 'S', ''); // Common Code
        doDefCombo(codeList_415, '', 'corpCustType', 'S', ''); // Common Code
        doDefCombo(codeList_416, '', 'agreementType', 'S', ''); // Common Code
        doDefCombo(branchCdList_5, '', 'dscBrnchId', 'S', ''); // Branch Code
        doDefCombo(branchCdList_1, '', 'keyinBrnchId', 'S', ''); // Branch Code
        doDefComboCode(codeList_325, '0', 'exTrade', 'S', ''); // EX-TRADE
        doDefCombo(codeList_562, '0', 'voucherType', 'S',
            'displayVoucherSection'); // Voucher Type Code

        //special - extrade whether need product return
        //$('#isReturnExtrade').prop("checked", true);
        //Attach File
        //$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>Upload</a></span></label>");

        //UpperCase Field
        // Function to Blocck from keyin special character
        /* $('#nric').keypress(function (event) {
            var regex = new RegExp("^[a-zA-Z0-9]+$");
            var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
            if (!regex.test(key)) {
               event.preventDefault();
               return false;
            }
        }); */
        $("#nric").keyup(function() {
          $(this).val($.trim($(this).val().toUpperCase()));
        });
        $("#sofNo").keyup(function() {
          $(this).val($.trim($(this).val().toUpperCase()));
        });
        $('#nric').keypress(
            function(e) {
              var regex = new RegExp("^[a-zA-Z0-9\s]+$");
              var str = String.fromCharCode(!e.charCode ? e.which
                  : e.charCode);
              if (regex.test(str)) {
                return true;
              }
              e.preventDefault();
              return false;
            });

        // 20190925 KR-OHK Moblie Popup Setting
        Common.setMobilePopup(true, false, '');

      });

  function createAUIGridStk() {

    //AUIGrid 칼럼 설정
    var columnLayoutGft = [ {
      headerText : "Product CD",
      dataField : "itmcd",
      width : 180
    }, {
      headerText : "Product Name",
      dataField : "itmname"
    }, {
      headerText : "Product QTY",
      dataField : "promoFreeGiftQty",
      width : 180
    }, {
      headerText : "itmid",
      dataField : "promoFreeGiftStkId",
      visible : false
    }, {
      headerText : "promoItmId",
      dataField : "promoItmId",
      visible : false
    } ];

    //그리드 속성 설정
    var listGridPros = {
      usePaging : true, //페이징 사용
      pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : false,
      //selectionMode       : "singleRow",  //"multipleCells",
      softRemoveRowMode : false,
      headerHeight : 30,
      useGroupingPanel : false, //그룹핑 패널 사용
      skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
    };

    /* listGiftGridID = GridCommon.createAUIGrid("pop_list_gift_grid_wrap", columnLayoutGft, "", listGridPros); */
  }

  function disableSaveButton() {
    $('#btnSave').unbind()
  }

  function enableSaveButton() {
    disableSaveButton()
    $('#btnSave').click(
        function() {

          if (!fn_validCustomer()) {
            $('#aTabCS').click();
            return false;
          }

          if (!fn_validOrderInfo()) {
            $('#aTabOI').click();
            return false;
          }

          if (!fn_validPaymentInfo()) {
            $('#aTabBD').click();
            return false;
          }

          if (!fn_validFile()) {
            $('#aTabFL').click();
            return false;
          }

          if (fn_isExistESalesNo() == 'true')
            return false;

          Common.popupDiv("/sales/order/cnfmPreOrderDetailPop.do",
              null, null, true, '_divPreOrderDetailPop');
          //fn_doSavePreOrder();
        });
  }

  $(function() {
    $('#btnRltdNoEKeyIn').click(function() {
      //** Start exTrade Neo to Neo Plus **//
      //  Common.popupDiv("/sales/order/prevOrderNoPop.do", {custId : $('#hiddenCustId').val(), prod : $('#ordProudct').val()}, null, true);
      //** Start exTrade Neo to Neo Plus **//
      Common.popupDiv("/sales/order/prevOrderNoPop.do", {
        custId : $('#hiddenCustId').val()
      }, null, true);
      if (MEM_TYPE == "1" || MEM_TYPE == "2") {
        $('#salesmanCd').val("${SESSION_INFO.userName}");
        $('#salesmanCd').change();
      } else {
        $('#salesmanCd').val('');
        $('#salesmanNm').val('');
      }

    });

    $('#btnPwpNoEkeyIn').click(function() {
        Common.popupDiv("/homecare/sales/order/pwpOrderNoPop.do", {custId : $('#hiddenCustId').val()}, null, true)
    });

  $('#btnConfirm').click(function() {
    if (!fn_validConfirm())
      return false;

    //if(fn_isExistMember() == 'true') return false;
    if (fn_isExistESalesNo() == 'true')
      return false;

    //encryptIc($('#nric').val());
    ///// $('#cmbTypeId').prop("disabled", true);

    $('#nric').prop("readonly", true).addClass("readonly").hide();
    $('#sofNo').prop("readonly", true).addClass("readonly").hide();;
    fn_maskingData('_NRIC', $('#nric'));
    fn_maskingData('_SOFNO', $('#sofNo'));
    $('#pNric').show();
    $('#pSofNo').show();

    $('#btnConfirm').addClass("blind");
    $('#btnClear').addClass("blind");
    //$('#scPreOrdArea').removeClass("blind");

      /* $('#refereNo').val($('#sofNo').val().trim()) */

      // fn_loadCustomer(null, $('#nric').val());
      //console.log("cmbTypeId before ::" + $('#cmbTypeId').val());
      fn_loadCustomer(null, $('#nric').val());
    });
    $('#nric').keydown(function(event) {
      if (event.which === 13) {
        if (!fn_validConfirm())
          return false;
        //if(fn_isExistMember() == 'true') return false;
        if (fn_isExistESalesNo() == 'true')
          return false;

        /* $('#refereNo').val($('#sofNo').val().trim()) */

        $('#nric').prop("readonly", true).addClass("readonly");
        $('#sofNo').prop("readonly", true).addClass("readonly");
        $('#btnConfirm').addClass("blind");
        $('#btnClear').addClass("blind");

        fn_loadCustomer(null, $('#nric').val());
      }
    });
    $('#sofNo').keydown(function(event) {
      if (event.which === 13) {
        if (!fn_validConfirm())
          return false;
        //if(fn_isExistMember() == 'true') return false;
        if (fn_isExistESalesNo() == 'true')
          return false;

        $('#nric').prop("readonly", true).addClass("readonly");
        $('#sofNo').prop("readonly", true).addClass("readonly");
        $('#btnConfirm').addClass("blind");
        $('#btnClear').addClass("blind");
        /* $('#refereNo').val($('#sofNo').val().trim()) */

        fn_loadCustomer(null, $('#nric').val());
      }
    });
    $('#chkSameCntc').click(function() {
      if ($('#chkSameCntc').is(":checked")) {
        $('#scAnothCntc').addClass("blind");
      } else {
        $('#scAnothCntc').removeClass("blind");
      }
    });
    $('#btnNewCntc').click(function() {
      Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {
        custId : $('#hiddenCustId').val(),
        callParam : "PRE_ORD_CNTC"
      }, null, true);
    });
    $('#btnSelCntc').click(function() {
      Common.popupDiv("/sales/customer/customerConctactSearchPop.do", {
        custId : $('#hiddenCustId').val(),
        callPrgm : "PRE_ORD_CNTC"
      }, null, true);
    });
    $('#btnNewInstAddr').click(function() {
      Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
        custId : $('#hiddenCustId').val(),
        callParam : "PRE_ORD_INST_ADD"
      }, null, true);
    });
    $('#btnSelInstAddr').click(function() {
      Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
        custId : $('#hiddenCustId').val(),
        callPrgm : "PRE_ORD_INST_ADD"
      }, null, true);
    });
    $('#billNewAddrBtn').click(function() {
      Common.popupDiv("/sales/customer/updateCustomerNewAddressPop.do", {
        custId : $('#hiddenCustId').val(),
        callParam : "PRE_ORD_BILL_ADD"
      }, null, true);
    });
    $('#billSelAddrBtn').click(function() {
      Common.popupDiv("/sales/customer/customerAddressSearchPop.do", {
        custId : $('#hiddenCustId').val(),
        callPrgm : "PRE_ORD_BILL_ADD"
      }, null, true);
    });
    $('#billGrpBtn').click(function() {
      Common.popupDiv("/sales/customer/customerBillGrpSearchPop.do", {
        custId : $('#hiddenCustId').val(),
        callPrgm : "PRE_ORD_BILL_GRP"
      }, null, true);
    });
    $('#appType')
        .change(
            function() {
              $('#scPayInfo').addClass("blind");

              //CLEAR RENTAL PAY SETTING
              $('#thrdParty').prop("checked", false);

              fn_clearRentPayMode();
              fn_clearRentPay3thParty();
              //fn_clearRentPaySetCRC();
              //fn_clearRentPaySetDD();

              //CLEAR BILLING GROUP
              fn_clearBillGroup();

              //ClearControl_Sales();
              fn_clearSales();

              $('[name="advPay"]').prop("disabled", true);
              fn_resetPreSrvType();

              var idx = $("#appType option:selected").index();
              var selVal = $("#appType").val();

              if (idx > 0) {
                if (FormUtil.isEmpty($('#hiddenCustId').val())) {
                  $('#appType').val('');
                  Common
                      .alert('<b>Please select customer first.</b>');

                  $('#aTabCS').click();
                } else {

                  switch (selVal) {
                  case '66': //RENTAL
                    $('#scPayInfo').removeClass("blind");
                    //?FD문서에서 아래 항목 빠짐
                    //$('[name="advPay"]').removeAttr("disabled");
                    $('#installDur').val('').prop(
                        "readonly", true).addClass(
                        "readonly");
                    //$("#gstChk").val('0');
                    //$('#pBtnCal').addClass("blind");

                    appSubType = '367';

                    var vCustType = $("#hiddenTypeId")
                        .val();
                    console.log("vCustType : " + vCustType);
                    if (vCustType == '965') {
                      $("#corpCustType").val('')
                          .removeAttr("disabled");
                      $("#agreementType").val('')
                          .removeAttr("disabled");
                    } else {
                      $("#corpCustType").val('').prop(
                          "disabled", true);
                      $("#agreementType").val('').prop(
                          "disabled", true);
                    }

                    break;

                  case '67': //OUTRIGHT

                    appSubType = '368';

                    break;

                  case '68': //INSTALLMENT
                    $('#installDur').removeAttr("readonly")
                        .removeClass("readonly");

                    appSubType = '369';

                    break;

                  case '1412': //Outright Plus
                    $('#installDur').val("36").prop(
                        "readonly", true).removeClass(
                        "readonly");

                    //$('[name="advPay"]').removeAttr("disabled");

                    $('#scPayInfo').removeClass("blind");

                    appSubType = '370';

                    break;
                  case '142': //Sponsor
                    appSubType = '371';
                    break;
                  case '143': //Service
                    appSubType = '372';
                    break;
                  case '144': //Education
                    appSubType = '373';
                    break;
                  case '145': //Free Trial
                    appSubType = '374';
                    break;
                  default:
                    $('#installDur').val('').prop(
                        "readonly", true).addClass(
                        "readonly");
                    //$("#gstChk").val('0');
                    //$('#pBtnCal').addClass("blind");
                    //fn_tabOnOffSet('REL_CER', 'HIDE');

                    break;
                  }

                  var pType = $("#appType").val() == '66' ? '1'
                      : '2';
                  //doGetComboData('/common/selectCodeList.do', {pType : pType}, '',  'srvPacId',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
                  doGetComboData(
                      '/sales/order/selectServicePackageList.do',
                      {
                        appSubType : appSubType,
                        pType : pType
                      }, '', 'srvPacId', 'S',
                      'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE

                  $('#ordProudct ').removeAttr("disabled");
                }
              } else {
                $('#srvPacId option').remove();
              }

              $('#ordProudct option').remove();
              $('#ordProudct optgroup').remove();
            });
    $('#thrdPartyAddCustBtn').click(function() {
      Common.popupDiv("/sales/customer/customerRegistPop.do", {
        "callPrgm" : "PRE_ORD_3PARTY"
      }, null, true);
    });
    $('#thrdParty').click(function(event) {

      fn_clearRentPayMode();
      fn_clearRentPay3thParty();
      fn_clearRentPaySetCRC();
      fn_clearRentPaySetDD();

      if ($('#thrdParty').is(":checked")) {
        $('#sctThrdParty').removeClass("blind");
      } else {
        $('#sctThrdParty').addClass("blind");
      }
    });
    $('#thrdPartyId').change(function(event) {
      fn_loadThirdParty($('#thrdPartyId').val().trim(), 2);
    });
    $('#thrdPartyId').keydown(function(event) {
      if (event.which === 13) { //enter
        fn_loadThirdParty($('#thrdPartyId').val().trim(), 2);
      }
    });
    $('#thrdPartyBtn').click(function() {
      Common.popupDiv("/common/customerPop.do", {
        callPrgm : "ORD_REGISTER_PAY_3RD_PARTY"
      }, null, true);
    });
    $('#rentPayMode')
        .change(
            function() {
              //fn_clearRentPaySetCRC();
              //fn_clearRentPaySetDD();

              var rentPayModeIdx = $(
                  "#rentPayMode option:selected").index();
              var rentPayModeVal = $("#rentPayMode").val();

              if (rentPayModeIdx > 0) {
                if (rentPayModeVal == '133'
                    || rentPayModeVal == '134') {

                  Common
                      .alert('<b>Currently we are not provide ['
                          + rentPayModeVal
                          + '] service.</b>');
                  fn_clearRentPayMode();
                } else {
                  if (rentPayModeVal == '131') {
                    if ($('#thrdParty').is(":checked")
                        && FormUtil.isEmpty($(
                            '#hiddenThrdPartyId')
                            .val())) {
                      Common
                          .alert('<b>Please select the third party first.</b>');
                    } else {
                      $('#sctCrCard')
                          .removeClass("blind");
                    }
                  } else if (rentPayModeVal == '132') {
                    if ($('#thrdParty').is(":checked")
                        && FormUtil.isEmpty($(
                            '#hiddenThrdPartyId')
                            .val())) {
                      Common
                          .alert('<b>Please select the third party first.</b>');
                    } else {
                      $('#sctDirectDebit').removeClass(
                          "blind");
                    }
                  }
                }
              }
            });
    $('#srvPacId').change(function() {
      $('#ordProudct option').remove();
      $('#ordProudct optgroup').remove();

      fn_resetPreSrvType();


      var idx = $("#srvPacId option:selected").index();
      var selVal = $("#srvPacId").val();

      if (idx > 0) {
        var stkType = $("#appType").val() == '66' ? '1' : '2';
        //doGetProductCombo('/sales/order/selectProductCodeList.do',  stkType, '', 'ordProudct', 'S', ''); //Product Code

        doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {
          stkType : stkType,
          srvPacId : $('#srvPacId').val(),
          alwSale : alwSale
        }, '', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
      }
    });

    $('#exTrade')
        .change(
            function() {
              $('#ordPromo option').remove();
              fn_clearAddCpnt();
              $('#relatedNo').val("");
              $('#isReturnExtrade').prop("checked", false);


              $('#isReturnExtradeChkBoxEkeyIn').removeClass("blind");
              $('#relatedNo').removeClass("blind");
              $('#pwpNo').val("");
              $('#txtMainPwpOrderID').val("");
              $('#pwpNo').addClass("blind");
              $('#btnPwpNoEkeyIn').addClass("blind");

              if ($("#exTrade").val() == '1'
                  || $("#exTrade").val() == '2') {
                //$('#relatedNo').removeAttr("readonly").removeClass("readonly");
                $('#btnRltdNoEKeyIn').removeClass("blind");

                if ($('#exTrade').val() == '1') {
                  $('#isReturnExtrade').prop("checked", true);

                  var todayDD = Number(TODAY_DD.substr(0, 2));
                  var todayYY = Number(TODAY_DD.substr(6, 4));

                  var strBlockDtFrom = blockDtFrom
                      + BEFORE_DD.substr(2);
                  var strBlockDtTo = blockDtTo
                      + TODAY_DD.substr(2);

                  console.log("todayDD: " + todayDD);
                  console.log("blockDtFrom : " + blockDtFrom);
                  console.log("blockDtTo : " + blockDtTo);

                  if (todayDD >= blockDtFrom && todayDD <= blockDtTo) { // Block if date > 22th of the month
                      $('#isReturnExtrade').attr("disabled",true);
                      $('#ordProudct').val('');
                      $('#speclInstct').val('');

                    var msg = "Extrade sales key-in does not meet period date (Submission start on 1st of every month)";
                    Common.alert(
                        '<spring:message code="sal.alert.msg.actionRestriction" />'
                            + DEFAULT_DELIMITER
                            + "<b>" + msg + "</b>",
                        '');
                    return;
                  }
                }
              }else if ($("#exTrade").val() == '4'){
            	  $('#relatedNo').val('');
                  $('#hiddenMonthExpired').val('');
                  $('#hiddenPreBook').val('');
                  $('#btnRltdNoEKeyIn').addClass("blind");

                  $('#pwpNo').removeClass("blind");
                  $('#btnPwpNoEkeyIn').removeClass("blind");
                  $('#isReturnExtradeChkBoxEkeyIn').addClass("blind");
                  $('#relatedNo').addClass("blind");

              }else {
                //$('#relatedNo').val('').prop("readonly", true).addClass("readonly");
                $('#relatedNo').val('');
                $('#txtMainPwpOrderID').val("");
                $('#hiddenMonthExpired').val('');
                $('#hiddenPreBook').val('');
                $('#btnRltdNoEKeyIn').addClass("blind");
              }

              $('#isReturnExtrade').attr("disabled", true);
              $('#ordProudct').val('');
              $('#speclInstct').val('');

            });
    $('#ordProudct').change(
        function() {
          //** Start exTrade Neo to Neo Plus **//
          //  $('#relatedNo').val('');
          //** End exTrade Neo to Neo Plus **//

          fn_resetPreSrvType();


          console.log('ordProudct change event start');
          disableSaveButton()

          if (FormUtil.checkReqValue($('#exTrade'))) {
            Common.alert("Save Sales Order Summary"
                + DEFAULT_DELIMITER
                + "<b>* Please select an Ex-Trade.</b>");
            $('#ordProudct').val('');
            return;
          }

          if (FormUtil.isEmpty($('#ordProudct').val())) {
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
          var custTypeVal = $("#hiddenTypeId").val();
          var stkIdx = $("#ordProudct option:selected").index();
          var stkIdVal = $("#ordProudct").val();
          //          var empChk     = $("#empChk").val();
          var empChk = 0;
          var exTrade = $("#exTrade").val();
          var srvPacId = (appTypeVal == '66') ? $('#srvPacId').val()
              : 0;

          if (appTypeVal == '66') {
            srvPacId = $('#srvPacId').val();
          }

          if (stkIdx > 0) {
            fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId);
            fn_loadProductPromotion(appTypeVal, stkIdVal, empChk,
                custTypeVal, exTrade);
          }

          fn_loadProductComponent(appTypeVal, stkIdVal);
          setTimeout(function() {
            fn_check(0)
          }, 200);

        });
    $('#ordPromo').change(function() {
      disableSaveButton()

      //          $('#relatedNo').val('').prop("readonly", true).addClass("readonly");
      //          $('#trialNoChk').prop("checked", false).prop("disabled", true);
      //          $('#trialNo').val('').addClass("readonly");

      AUIGrid.clearGridData(listGiftGridID);

      var appTypeIdx = $("#appType option:selected").index();
      var appTypeVal = $("#appType").val();
      var stkIdIdx = $("#ordProudct option:selected").index();
      var stkIdVal = $("#ordProudct").val();
      var promoIdIdx = $("#ordPromo option:selected").index();
      var promoIdVal = $("#ordPromo").val();
      var srvPacId = (appTypeVal == '66') ? $('#srvPacId').val() : 0;

      if (promoIdIdx > 0 && promoIdVal != '0') {
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
      } else {
        fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId);
      }

      fn_checkPromotionExtradeAvail();
    });
    $('#salesmanCd').change(function(event) {
      var memCd = $('#salesmanCd').val().trim();

      if (FormUtil.isNotEmpty(memCd)) {
        fn_loadOrderSalesman(0, memCd);
      }

    });
    $('#salesmanCd').keydown(function(event) {
      if (event.which === 13) { //enter
        var memCd = $('#salesmanCd').val().trim();

        if (FormUtil.isNotEmpty(memCd)) {
          fn_loadOrderSalesman(0, memCd);
        }
        return false;
      }
    });
    $('#memBtn').click(
        function() {
          //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
          Common.popupDiv("/common/memberPop.do", $("#searchForm")
              .serializeJSON(), null, true);
        });
    $('[name="grpOpt"]').click(function() {
      fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
    });

    $('[name="preSrvType"]').click(function() {
    	$("#preSrvTypeLbl").find("span").remove();

    	if($('input:radio[name="preSrvType"]:checked').val() == 'SS'){
    		$("#preSrvTypeLbl").append("<span><spring:message code='sales.text.serviceTypeDiscountMessage'/></span>");
    		$('#ordPv').val(totPvSs);
    	}else{
    		$('#ordPv').val(totPv);
    	}
    });

    $('#btnCal')
        .click(
            function() {
              var appTypeName = $('#appType').val();
              var productName = $('#ordProudct option:selected')
                  .text();
              //Amount before GST
              var oldPrice = $('#normalOrdPrice').val();
              var newPrice = $('#ordPrice').val();
              var oldRental = $('#normalOrdPrice').val();
              var newRental = $('#ordRentalFees').val();
              var oldPv = $('#ordPv').val();
              //Amount of GST applied
              var oldPriceGST = fn_calcGst(oldPrice);
              var newPriceGST = fn_calcGst(newPrice);
              var oldRentalGST = fn_calcGst(oldRental);
              var newRentalGST = fn_calcGst(newRental);
              var newPv = $('#ordPvGST').val();

              var msg = '';

              msg += 'Application Type : ' + appTypeName + '<br>';
              msg += 'Product          : ' + productName + '<br>';
              msg += 'Price(RPF)       : ' + newPriceGST + '<br>';
              msg += 'Normal Rental    : ' + oldRentalGST
                  + '<br>';
              msg += 'Promotion        : ' + newRentalGST
                  + '<br>';
              msg += '<br>The Price(Fee) was applied to the tab of [Sales Order]';

              fn_excludeGstAmt();

              Common.alert('GST Amount' + DEFAULT_DELIMITER
                  + '<b>' + msg + '</b>');
            });
    $('#gstChk').change(function(event) {
      if ($("#gstChk").val() == '1') {
        $('#pBtnCal').removeClass("blind");
      } else {
        $('#pBtnCal').addClass("blind");

        var appTypeVal = $("#appType").val();
        var stkIdVal = $("#ordProudct").val();
        var promoIdVal = $("#ordPromo").val();

        fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId);
        if (FormUtil.isNotEmpty(promoIdVal)) {
          fn_loadPromotionPrice(promoIdVal, stkIdVal, srvPacId);
        }
      }
    });
    $('#addCreditCardBtn')
        .click(
            function() {
              var vCustId = $('#thrdParty').is(":checked") ? $(
                  '#hiddenThrdPartyId').val() : $(
                  '#hiddenCustId').val();
              var custNric = $('#thrdParty').is(":checked") ? ""
                  : $('#nric').val();
              Common
                  .popupDiv(
                      "/sales/customer/customerCreditCardeSalesAddPop.do",
                      {
                        custId : vCustId,
                        callPrgm : "PRE_ORD",
                        nric : custNric
                      }, null, true);
            });
    $('#selCreditCardBtn').click(
        function() {

          var vCustId = $('#thrdParty').is(":checked") ? $(
              '#hiddenThrdPartyId').val() : $('#hiddenCustId')
              .val();
          Common.popupDiv(
              "/sales/customer/customerCreditCardSearchPop.do", {
                custId : vCustId,
                callPrgm : "PRE_ORD"
              }, null, true);
        });
    //Payment Channel - Add New Bank Account
    $('#btnAddBankAccount').click(
        function() {
          var vCustId = $('#thrdParty').is(":checked") ? $(
              '#hiddenThrdPartyId').val() : $('#hiddenCustId')
              .val();
          Common.popupDiv(
              "/sales/customer/customerBankAccountAddPop.do", {
                custId : vCustId,
                callPrgm : "PRE_ORD"
              }, null, true);
        });
    //Payment Channel - Select Another Bank Account
    $('#btnSelBankAccount').click(
        function() {
          var vCustId = $('#thrdParty').is(":checked") ? $(
              '#hiddenThrdPartyId').val() : $('#hiddenCustId')
              .val();
          Common.popupDiv(
              "/sales/customer/customerBankAccountSearchPop.do",
              {
                custId : vCustId,
                callPrgm : "PRE_ORD"
              });
        });
    $('#sofFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[1] != null) {
                delete myFileCaches[1];
              } else if (file != null) {
                myFileCaches[1] = {
                  file : file
                };
              }

              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[1].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[1].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#nricFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[2] != null) {
                delete myFileCaches[2];
              } else if (file != null) {
                myFileCaches[2] = {
                  file : file
                };
              }

              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[2].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[2].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#payFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[3] != null) {
                delete myFileCaches[3];
              } else if (file != null) {
                myFileCaches[3] = {
                  file : file
                };
              }
              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[3].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[3].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#trFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[4] != null) {
                delete myFileCaches[4];
              } else if (file != null) {
                myFileCaches[4] = {
                  file : file
                };
              }
              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[4].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[4].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#otherFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[5] != null) {
                delete myFileCaches[5];
              } else if (file != null) {
                myFileCaches[5] = {
                  file : file
                };
              }
              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[5].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[5].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#otherFile2')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[6] != null) {
                delete myFileCaches[6];
              } else if (file != null) {
                myFileCaches[6] = {
                  file : file
                };
              }
              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[6].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[6].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#sofTncFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[7] != null) {
                delete myFileCaches[7];
              } else if (file != null) {
                myFileCaches[7] = {
                  file : file
                };
              }
              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[7].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[7].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#msofFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[8] != null) {
                delete myFileCaches[8];
              } else if (file != null) {
                myFileCaches[8] = {
                  file : file
                };
              }
              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[8].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[8].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    $('#msofTncFile')
        .change(
            function(evt) {
              var file = evt.target.files[0];
              if (file == null && myFileCaches[9] != null) {
                delete myFileCaches[9];
              } else if (file != null) {
                myFileCaches[9] = {
                  file : file
                };
              }
              var msg = '';
              if (file.name.length > 30) {
                msg += "*File name wording should be not more than 30 alphabet.<br>";
              }

              var fileType = file.type.split('/');
              if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
                  && fileType[1] != 'png'
                  && fileType[1] != 'pdf') {
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
              }

              if (file.size > 2000000) {
                msg += "*Only allow picture with less than 2MB.<br>";
              }
              if (msg != null && msg != '') {
                myFileCaches[9].file['checkFileValid'] = false;
                Common.alert(msg);
              } else {
                myFileCaches[9].file['checkFileValid'] = true;
              }
              console.log(myFileCaches);
            });

    enableSaveButton()
  });

  function fn_loadBankAccountPop(bankAccId) {

    fn_clearRentPaySetDD();
    fn_loadBankAccount(bankAccId);

    $('#sctDirectDebit').removeClass("blind");

    if (!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $(
        '#rentPayBankAccNo').val())) {
      fn_clearRentPaySetDD();
      $('#sctDirectDebit').removeClass("blind");
      Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER
          + "<b>Invalid account for auto debit.</b>");
    }
  }

  function fn_loadCreditCard2(custCrcId) {
    console.log("fn_loadCreditCard START");

    Common.ajax("GET",
        "/sales/order/selectCustomerCreditCardDetailView.do", {
          getparam : custCrcId
        }, function(rsltInfo) {
          if (rsltInfo != null) {
            $("#hiddenRentPayCRCId").val(rsltInfo.custCrcId);
            $("#rentPayCRCNo").val(rsltInfo.decryptCRCNoShow);
            $("#hiddenRentPayEncryptCRCNoId").val(
                rsltInfo.custCrcNo);
            $("#rentPayCRCType").val(rsltInfo.code);
            $("#rentPayCRCName").val(rsltInfo.custCrcOwner);
            $("#rentPayCRCExpiry").val(rsltInfo.custCrcExpr);
            $("#rentPayCRCBank").val(
                rsltInfo.bankCode + ' - ' + rsltInfo.bankId);
            $("#hiddenRentPayCRCBankId")
                .val(rsltInfo.custCrcBankId);
            $("#rentPayCRCCardType").val(rsltInfo.codeName);
          }
        });
  }

  function fn_loadThirdParty(custId, sMethd) {

    fn_clearRentPayMode();
    fn_clearRentPay3thParty();
    fn_clearRentPaySetCRC();
    fn_clearRentPaySetDD();

    if (custId != $('#hiddenCustId').val()) {
      Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {
        custId : custId
      }, function(result) {

        if (result != null && result.length == 1) {

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
        } else {
          if (sMethd == 2) {
            Common.alert('<b>Third party not found.<br />'
                + 'Your input third party ID : ' + custId
                + '</b>');
          }
        }
      });
    } else {
      Common
          .alert('<b>Third party and customer cannot be same person/company.<br />'
              + 'Your input third party ID : ' + custId + '</b>');
    }

    $('#sctThrdParty').removeClass("blind");
  }

  function fn_excludeGstAmt() {
    //Amount before GST
    var oldPrice = $('#normalOrdPrice').val();
    var newPrice = $('#ordPrice').val();
    var oldRental = $('#normalOrdRentalFees').val();
    var newRental = $('#ordRentalFees').val();
    var oldPv = $('#ordPv').val();
    //Amount of GST applied
    var oldPriceGST = fn_calcGst(oldPrice);
    var newPriceGST = fn_calcGst(newPrice);
    var oldRentalGST = fn_calcGst(oldRental);
    var newRentalGST = fn_calcGst(newRental);
    var newPv = $('#ordPvGST').val();

    $('#normalOrdPrice').val(oldPriceGST);
    $('#ordPrice').val(newPriceGST);
    $('#normalOrdRentalFees').val(oldRentalGST);
    $('#ordRentalFees').val(newRentalGST);
    $('#ordPv').val(newPv);

    $('#pBtnCal').addClass("blind");
  }

  function fn_isExistESalesNo() {
    var isExist = false, msg = "";

    Common.ajaxSync("GET", "/sales/order/selectExistSofNo.do", {
      selType : $('#selType').val(),
      sofNo : $('#sofNo').val().trim()
    }, function(rsltInfo) {

      if (rsltInfo != null) {
        isExist = rsltInfo.isExist;
      }
      console.log('isExistSalesNo:' + isExist);
    });

    if (isExist == 'true')
      Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER
          + "<b>* this Sales has posted, no amendment allow</b>");

    return isExist;
  }

  function fn_isExistMember() {
    var isExist = false, msg = "";

    Common.ajaxSync("GET", "/sales/order/selectExistingMember.do", $(
        "#frmCustSearch").serialize(), function(rsltInfo) {
      if (rsltInfo != null) {
        isExist = rsltInfo.isExist;
      }
      console.log('isExistMember:' + isExist);
    });

    if (isExist == 'true')
      Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER
          + "<b>* The member is our existing HP/Cody/Staff/CT.</b>");

    return isExist;
  }

  function fn_validPaymentInfo() {
    var isValid = true, msg = "";

    var appTypeIdx = $("#appType option:selected").index();
    var appTypeVal = $("#appType").val();
    var rentPayModeIdx = $("#rentPayMode option:selected").index();
    var rentPayModeVal = $("#rentPayMode").val();
    var grpOptSelYN = (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(
        ":checked")) ? false : true;
    var grpOptVal = $(':radio[name="grpOpt"]:checked').val(); //new, exist

    if (appTypeIdx > 0 && appTypeVal == '66') {

      if ($('#thrdParty').is(":checked")) {

        if (FormUtil.checkReqValue($('#hiddenThrdPartyId'))) {
          isValid = false;
          msg += "* Please select the third party.<br>";
        }
      }

      if (rentPayModeIdx <= 0) {
        isValid = false;
        msg += "* Please select the rental paymode.<br>";
      } else {
        if (rentPayModeVal == '131') {
          if (FormUtil.checkReqValue($('#hiddenRentPayCRCId'))) {
            isValid = false;
            msg += "* Please select a credit card.<br>";
          } else if (FormUtil
              .checkReqValue($('#hiddenRentPayCRCBankId'))
              || $('#hiddenRentPayCRCBankId').val() == '0') {
            isValid = false;
            msg += "* Invalid credit card issue bank.<br>";
          }
        } else if (rentPayModeVal == '132') {
          if (FormUtil.checkReqValue($('#hiddenRentPayBankAccID'))) {
            isValid = false;
            msg += "* Please select a bank account.<br>";
          } else if (FormUtil.checkReqValue($('#hiddenAccBankId'))
              || $('#hiddenRentPayCRCBankId').val() == '0') {
            isValid = false;
            msg += "* Invalid bank account issue bank.<br>";
          }
        }
      }

      if (!grpOptSelYN) {
        isValid = false;
        msg += "* Please select the group option.<br>";
      } else {

        if (grpOptVal == 'exist') {

          if (FormUtil.checkReqValue($('#hiddenBillGrpId'))) {
            isValid = false;
            msg += "* Please select a billing group.<br>";
          }
        } else {

          console.log('billMthdSms  checked:'
              + $("#billMthdSms").is(":checked"));
          console.log('billMthdPost checked:'
              + $("#billMthdPost").is(":checked"));
          console.log('billMthdEstm checked:'
              + $("#billMthdEstm").is(":checked"));

          if (!$("#billMthdSms").is(":checked")
              && !$("#billMthdPost").is(":checked")
              && !$("#billMthdEstm").is(":checked")) {
            isValid = false;
            msg += "* Please select at least one billing method.<br>";
          } else {
            if ($("#typeId").val() == '965'
                && $("#billMthdSms").is(":checked")) {
              isValid = false;
              msg += "* SMS billing method is not allow for company type customer.<br>";
            }

            if ($("#billMthdEstm").is(":checked")) {
              if (FormUtil.checkReqValue($('#billMthdEmailTxt1'))) {
                isValid = false;
                msg += "* Please key in the email address.<br>";
              } else {
                if (FormUtil.checkEmail($('#billMthdEmailTxt1')
                    .val())) {
                  isValid = false;
                  msg += "* Invalid email address.<br>";
                }
              }
              if (!FormUtil
                  .checkReqValue($('#billMthdEmailTxt2'))
                  && FormUtil.checkEmail($(
                      '#billMthdEmailTxt2').val())) {
                isValid = false;
                msg += "* Invalid email address.<br>";
              }
            }
          }
        }
      }
    }

    if (!isValid)
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"
          + msg + "</b>");

    return isValid;
  }

  function fn_validOrderInfo() {
    var isValid = true, msg = "";

    var appTypeIdx = $("#appType option:selected").index();
    var appTypeVal = $("#appType").val();
    var custType = $("#hiddenTypeId").val();
    var exTrade = $("#exTrade").val();

    if (appTypeIdx <= 0) {
      isValid = false;
      msg += "* Please select an application type.<br>";
    } else {
      if (appTypeVal == '68' || appTypeVal == '1412') {
        if (FormUtil.checkReqValue($('#installDur'))) {
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

      if (appTypeVal == '66') {
        if ($(':radio[name="advPay"]:checked').val() != '1'
            && $(':radio[name="advPay"]:checked').val() != '0') {
          isValid = false;
          msg += "* Please select advance rental payment.<br>";
        }
      }
    }

    if ($(':radio[name="preSrvType"]:checked').val() != 'HS'
        && $(':radio[name="preSrvType"]:checked').val() != 'SS') {
      isValid = false;
      msg += "* Please select Service Type.<br>";
    }

    if ($("#srvPacId option:selected").index() <= 0) {
      isValid = false;
      msg += "* Please select a package.<br>";
    }

    if ($("#ordProudct option:selected").index() <= 0) {
      isValid = false;
      msg += "* Please select a product.<br>";
    }

    if (FormUtil.checkReqValue($('#salesmanCd'))
        && FormUtil.checkReqValue($('#salesmanNm'))) {
      if (appTypeIdx > 0 && appTypeVal != 143) {
        isValid = false;
        msg += "* Please select a salesman.<br>";
      }
    }

    if ($("#ordPromo option:selected").index() <= 0) {
      isValid = false;
      msg += "* Please select a promotion.<br>";
    }

    if (exTrade == '1' || exTrade == '2') {
      if (FormUtil.checkReqValue($('#relatedNo'))) {
        isValid = false;
        msg += "* Please select old order no.<br>";
      }
    }else if(exTrade == '4') {
        if(FormUtil.checkReqValue($('#pwpNo'))) {
            isValid = false;
            msg += "* Please select main PWP order no.<br>";
        }
    }

    if ($('#voucherType').val() == "") {
      isValid = false;
      msg += "* Please select voucher type.<br>";
    }

    if ($('#voucherType').val() != "" && $('#voucherType').val() > 0) {
      if (voucherAppliedStatus == 0) {
        isValid = false;
        msg += "* You have selected a voucher type. Please apply a voucher is any.<br>";
      }
    }

    //if (custType == '965' && appTypeVal == '66'){
    //    if ($("#corpCustType option:selected").index() <= 0) {
    //        isValid = false;
    //        msg += '* Please select SST Type<br>';
    //    }

    //    if ($("#agreementType option:selected").index() <= 0) {
    //        isValid = false;
    //        msg += '* Please select Agreement Type<br>';
    //    }
    //}

    /*         if(!$('#pBtnCal').hasClass("blind")) {
     isValid = false;
     msg += "* Please press the Calculation button<br>";
     } */

    if (!isValid)
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"
          + msg + "</b>");

    return isValid;
  }

  function fn_validConfirm() {
    var isValid = true, msg = "";

    /* var cmbTypeId = $('#cmbTypeId').val();
    console.log ("cmbTypeId :: "+ cmbTypeId); */

    var nric = $('#nric').val();
    console.log("nric :: " + nric);

    var sofNo = $('#sofNo').val();
    console.log("sofNo :: " + sofNo);

    /* if(FormUtil.checkReqValue($('#cmbTypeId'))) {
        isValid = false;
        msg += "* Please key in Customer Type.<br>";
    } */

    if (FormUtil.checkReqValue($('#nric'))) {
      isValid = false;
      msg += "* Please key in NRIC/Company No.<br>";
    } else {
      //check if NRIC is Numeric, else company number (includes alphabet)
      var nric_trim = $("#nric").val().replace(/ |-|_/g, '');
      console.log("nric_trim :: " + nric_trim);
      if ($.isNumeric($("#nric_trim").val())) {
        var dob = Number($('#nric').val().substr(0, 2));
        var nowDt = new Date();
        var nowDtY = Number(nowDt.getFullYear().toString().substr(-2));
        var age = nowDtY - dob < 0 ? nowDtY - dob + 100 : nowDtY - dob;
        console.log(age);
        if (age < 18) {
          Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER
              + "<b>* Member must 18 years old and above.</b>");
          $('#scPreOrdArea').addClass("blind");
          return false;
        }
      }
    }
    if (FormUtil.checkReqValue($('#sofNo'))) {
      isValid = false;
      msg += "* Please key in eSales(SOF) No.<br>";
    } else if ($('#sofNo').val().substring(0, 3) != "AAA") {
      isValid = false;
      msg += "* Please key in <b>AAA</b> at SOF No";
    }

    if (!isValid)
      Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>" + msg
          + "</b>");

    return isValid;
  }

  function fn_validCustomer() {
    var isValid = true, msg = "";

    if (FormUtil.checkReqValue($('#hiddenCustId'))) {
      isValid = false;
      msg += "* Please select a customer.<br>";
    }

    if ($('#appType').val() == '1412' && $('#hiddenTypeId').val() == '965') {
      isValid = false;
      msg = "* Please select an individual customer<br>(Outright Plus).<br>";
    }

    if (FormUtil.checkReqValue($('#hiddenCustCntcId'))) {
      isValid = false;
      msg += "* Please select a contact person.<br>";
    }

    if (FormUtil.checkReqValue($('#hiddenCustAddId'))) {
      isValid = false;
      msg += "* Please select an installation address.<br>";
    }

    if ($("#dscBrnchId option:selected").index() <= 0) {
      isValid = false;
      msg += "* Please select the DSC branch.<br>";
    }

    if ($("#keyinBrnchId option:selected").index() <= 0) {
      isValid = false;
      msg += "* Please select the Posting branch.<br>";
    }

    if (FormUtil.isEmpty($('#prefInstDt').val().trim())) {
      isValid = false;
      msg += "* Please select prefer install date.<br>";
    }

    if (FormUtil.isEmpty($('#prefInstTm').val().trim())) {
      isValid = false;
      msg += "* Please select prefer install time.<br>";
    }

    if (!isValid)
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"
          + msg + "</b>");

    return isValid;
  }

  function fn_validFile() {
    var isValid = true, msg = "";
    if (FormUtil.isEmpty($('#sofFile').val().trim())) {
      isValid = false;
      msg += "* Please upload copy of SOF<br>";
    }
    if (FormUtil.isEmpty($('#nricFile').val().trim())) {
      isValid = false;
      msg += "* Please upload copy of NRIC<br>";
    }

    $
        .each(
            myFileCaches,
            function(i, j) {
              if (myFileCaches[i].file.checkFileValid == false) {
                isValid = false;
                msg += myFileCaches[i].file.name
                    + "<br>* File uploaded only allowed for picture format less than 2MB and 30 wordings<br>";
              }
            });

    if (!isValid)
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>"
          + msg + "</b>");

    return isValid;
  }

  function fn_checkProductQuota() {
    var exceedQuota = false, msg = "";

    Common.ajaxSync("GET", "/sales/productMgmt/selectQuotaCount.do", {
      stkId : $('#ordProudct').val(),
      promoId : $('#ordPromo').val()
    }, function(result) {
      if (result != null)
        exceedQuota = true;
    });

    if (exceedQuota == true)
      Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER
          + "<b>* This product has reached the quota.</b>");

    return exceedQuota;
  }

  function fn_doSavePreOrder() {

    var vAppType = $('#appType').val();
    var vCustCRCID = $('#rentPayMode').val() == '131' ? $(
        '#hiddenRentPayCRCId').val() : 0;
    var vCustAccID = $('#rentPayMode').val() == '132' ? $(
        '#hiddenRentPayBankAccID').val() : 0;
    var vBankID = $('#rentPayMode').val() == '131' ? $(
        '#hiddenRentPayCRCBankId').val()
        : $('#rentPayMode').val() == '132' ? $('#hiddenAccBankId')
            .val() : 0;
    var vIs3rdParty = $('#thrdParty').is(":checked") ? 1 : 0;
    var vCustomerId = $('#thrdParty').is(":checked") ? $(
        '#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
    var vCustBillId = vAppType == '66' ? $(
        'input:radio[name="grpOpt"]:checked').val() == 'exist' ? $(
        '#hiddenBillGrpId').val() : 0 : 0;
    var vIsReturnExtrade = "";
    if ($('#exTrade').val() == 1) {
      if ($('#isReturnExtrade').is(":checked")) {
        vIsReturnExtrade = 1;
      } else {
        vIsReturnExtrade = 0;
      }
    }

    console.log("service :: " + $("#hiddenBPCareId").val());
    var orderVO = {
      sofNo : $('#sofNo').val().trim(),
      custPoNo : $('#poNo').val().trim(),
      appTypeId : vAppType,
      srvPacId : $('#srvPacId').val(),
      instPriod : $('#installDur').val().trim(),
      custId : $('#hiddenCustId').val(),
      empChk : 0,
      gstChk : $('#gstChk').val(),
      atchFileGrpId : atchFileGrpId,
      custCntcId : $('#hiddenCustCntcId').val(),
      keyinBrnchId : $('#keyinBrnchId').val(),
      instAddId : $('#hiddenCustAddId').val(),
      dscBrnchId : $('#dscBrnchId').val(),
      preDt : $('#prefInstDt').val().trim(),
      preTm : $('#prefInstTm').val().trim(),
      instct : $('#speclInstct').val().trim(),
      exTrade : $('#exTrade').val(),
      itmStkId : $('#ordProudct').val(),
      itmCompId : $('#compType').val(),
      promoId : $('#ordPromo').val(),
      mthRentAmt : $('#ordRentalFees').val().trim(),
      //            promoDiscPeriodTp    : $('#promoDiscPeriodTp').val(),
      //            promoDiscPeriod      : $('#promoDiscPeriod').val().trim(),
      totAmt : $('#ordPrice').val().trim(),
      norAmt : $('#normalOrdPrice').val().trim(),
      //            norRntFee            : $('#normalOrdRentalFees').val().trim(),
      discRntFee : $('#ordRentalFees').val().trim(),
      totPv : $('#ordPv').val().trim(),
      totPvGst : $('#ordPvGST').val().trim(),
      prcId : $('#ordPriceId').val(),
      memCode : $('#salesmanCd').val(),
      srvType : $('input:radio[name="preSrvType"]:checked').val(),
      advBill : $('input:radio[name="advPay"]:checked').val(),
      custCrcId : vCustCRCID,
      bankId : vBankID,
      custAccId : vCustAccID,
      is3rdParty : vIs3rdParty,
      rentPayCustId : vCustomerId,
      rentPayModeId : $('#rentPayMode').val(),
      custBillId : vCustBillId,
      custBillCustId : $('#hiddenCustId').val(),
      custBillCntId : $("#hiddenCustCntcId").val(),
      custBillAddId : $("#hiddenBillAddId").val(),
      //custBillRem          : $('#billRem').val().trim(),
      custBillEmail : $('#billMthdEmailTxt1').val().trim(),
      custBillIsSms : $('#billMthdSms1').is(":checked") ? 1 : 0,
      custBillIsPost : $('#billMthdPost').is(":checked") ? 1 : 0,
      custBillEmailAdd : $('#billMthdEmailTxt2').val().trim(),
      custBillIsWebPortal : $('#billGrpWeb').is(":checked") ? 1 : 0,
      custBillWebPortalUrl : $('#billGrpWebUrl').val().trim(),
      custBillIsSms2 : $('#billMthdSms2').is(":checked") ? 1 : 0,
      custBillCustCareCntId : $("#hiddenBPCareId").val(),
      corpCustType : $('#corpCustType').val(),
      agreementType : $('#agreementType').val(),
      salesOrdIdOld : $('#txtOldOrderID').val(),
      relatedNo : $('#relatedNo').val(),
      isExtradePR : vIsReturnExtrade,
      receivingMarketingMsgStatus : $(
          'input:radio[name="marketingMessageSelection"]:checked')
          .val(),
      voucherCode : voucherAppliedCode,
      pwpOrderId          : $('#txtMainPwpOrderID').val(),
      pwpOrderNo          : $('#pwpNo').val(),
    };

    var formData = new FormData();
    $.each(myFileCaches, function(n, v) {
      console.log("n : " + n + " v.file : " + v.file);
      formData.append(n, v.file);
    });
    //formData.append('atchFileGrpId',atchFileGrpId);

    Common
        .ajaxFile(
            "/sales/order/attachFileUpload.do",
            formData,
            function(result) {
              if (result != 0 && result.code == 00) {
                //atchFileGrpId = result.data.fileGroupKey;
                orderVO["atchFileGrpId"] = result.data.fileGroupKey;
                $("#btnConfirm_RW").hide();
                Common
                    .ajax(
                        "POST",
                        "/sales/order/registerPreOrder.do",
                        orderVO,
                        function(result) {
                          Common
                              .alert(
                                  "Order Saved"
                                      + DEFAULT_DELIMITER
                                      + "<b>"
                                      + result.message
                                      + "</b>",
                                  fn_closePreOrdRegPop);
                        },
                        function(jqXHR, textStatus,
                            errorThrown) {
                          $("#btnConfirm_RW").show();
                          try {
                            Common
                                .alert("Failed To Save"
                                    + DEFAULT_DELIMITER
                                    + "<b>Failed to save order. "
                                    + jqXHR.responseJSON.message
                                    + "</b>");
                            Common.removeLoader();
                          } catch (e) {
                            console.log(e);
                          }
                        });

              } else {
                Common.alert("Attachment Upload Failed"
                    + DEFAULT_DELIMITER + result.message);
              }
            },
            function(result) {
              Common
                  .alert("Upload Failed. Please check with System Administrator.");
            });
  }

  function fn_closePreOrdRegPop() {
    myFileCaches = {};
    $('#btnCnfmOrderClose').click();

    // 20190925 KR-OHK Moblie Popup Setting
    if (Common.checkPlatformType() == "mobile") {
      opener.fn_PopClose();
      opener.fn_getPreOrderList();
    } else {
      fn_getPreOrderList();
      $('#_divPreOrdRegPop').remove();
    }
  }

  function fn_closePreOrdRegPop2() {
    myFileCaches = {};
    // 20190925 KR-OHK Moblie Popup Setting
    if (Common.checkPlatformType() == "mobile") {
      self.close();
    } else {
      $('#_divPreOrdRegPop').remove();
    }
  }

  function fn_setBillGrp(grpOpt) {

    if (grpOpt == 'new') {

      fn_clearBillGroup();

      $('#grpOpt1').prop("checked", true);

      //$('#sctBillMthd').removeClass("blind");
      $('#sctBillAddr').removeClass("blind");
      //          $('#sctBillPrefer').removeClass("blind");

      $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());
      //$('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());

      if ($('#hiddenTypeId').val() == '965') { //Company

        console.log("fn_setBillGrp 1 typeId : " + $('#typeId').val());

        //$('#sctBillPrefer').removeClass("blind");

        fn_loadBillingPreference($('#srvCntcId').val());

        $('#billMthdEstm').prop("checked", true);
        $('#billMthdEmail1').prop("checked", true).removeAttr(
            "disabled");
        $('#billMthdEmail2').removeAttr("disabled");
        $('#billMthdEmailTxt1').removeAttr("disabled");
        $('#billMthdEmailTxt2').removeAttr("disabled");
      } else if ($('#hiddenTypeId').val() == '964') { //Individual

        console.log("fn_setBillGrp 2 typeId : "
            + $('#hiddenTypeId').val());
        console.log("custCntcEmail : " + $('#custCntcEmail').val());
        console.log(FormUtil.isNotEmpty($('#custCntcEmail').val()
            .trim()));

        if (FormUtil.isNotEmpty($('#custCntcEmail').val().trim())) {
          $('#billMthdEstm').prop("checked", true);
          $('#billMthdEmail1').prop("checked", true).removeAttr(
              "disabled");
          $('#billMthdEmail2').removeAttr("disabled");
          //$('#billMthdEmailTxt1').removeAttr("disabled");
          //$('#billMthdEmailTxt2').removeAttr("disabled");
        }

        $('#billMthdSms').prop("checked", true);
        $('#billMthdSms1').prop("checked", true).removeAttr("disabled");
        $('#billMthdSms2').removeAttr("disabled");
      }
    } else if (grpOpt == 'exist') {

      fn_clearBillGroup();

      $('#grpOpt2').prop("checked", true);

      $('#sctBillSel').removeClass("blind");

      $('#billRem').prop("readonly", true).addClass("readonly");
    }
  }

  function fn_loadBillingPreference(custCareCntId) {

    Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {
      custCareCntId : custCareCntId
    }, function(srvCntcInfo) {

      if (srvCntcInfo != null) {
        console.log("성공.");
        console.log("srvCntcInfo:" + srvCntcInfo.custCareCntId);
        console.log("srvCntcInfo:" + srvCntcInfo.name);
        console.log("srvCntcInfo:" + srvCntcInfo.custInitial);
        console.log("srvCntcInfo:" + srvCntcInfo.email);

        $("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);
        $("#billPreferInitial").val(srvCntcInfo.custInitial);
        $("#billPreferName").val(srvCntcInfo.name);
        $("#billPreferTelO").val(srvCntcInfo.telO);
        $("#billPreferExt").val(srvCntcInfo.ext);
      }
    });

  }

  function fn_loadOrderSalesman(memId, memCode) {

    console.log('fn_loadOrderSalesman memId:' + memId);
    console.log('fn_loadOrderSalesman memCd:' + memCode);

    Common
        .ajax(
            "GET",
            "/sales/order/selectMemberByMemberIDCode.do",
            {
              memId : memId,
              memCode : memCode
            },
            function(memInfo) {

              if (memInfo == null) {
                Common
                    .alert('<b>Member not found.</br>Your input member code : '
                        + memCode + '</b>');
              } else {
                $('#salesmanCd').val(memInfo.memCode);
                $('#salesmanNm').val(memInfo.name);
              }
            });
  }

  function fn_checkPreOrderSalesPerson(memId, memCode) {
    var isExist = false;

    Common.ajax("GET", "/sales/order/checkPreBookSalesPerson.do", {
      memId : memId,
      memCode : memCode
    }, function(memInfo) {
      if (memInfo == null) {
        isExist = false;
        Common.alert('<b>Your input member code : ' + memCode
            + ' is not allowed for extrade pre-order.</b>');
        $('#aTabOI').click();
      } else {
        isExist = true;
        fn_doSavePreOrder();
      }
      return isExist;
    });

    return isExist;
  }

  function fn_checkPreOrderConfigurationPerson(memId, memCode, salesOrdId,
      salesOrdNo) {
    var isExist = false;

    Common.ajax("GET", "/sales/order/checkPreBookConfigurationPerson.do", {
      memId : memId,
      memCode : memCode,
      salesOrdId : salesOrdId,
      salesOrdNo : salesOrdNo
    }, function(memInfo) {
      if (memInfo == null) {
        isExist = false;
        Common.alert('<b>Your input member code : ' + memCode
            + ' is not allowed for extrade pre-order.</b>');
        $('#aTabOI').click();
      } else {
        //alert("[fn_checkPreOrderConfigurationPerson] line 1707 - checkPreBookSalesPerson.do ");
        isExist = true;
        fn_doSavePreOrder();
      }
      return isExist;
    });

    return isExist;
  }

  function checkSalesPerson(memCode, salesOrdId, salesOrdNo) {
    if (memCode == "100116" || memCode == "100224" || memCode == "ASPLKW") {
      return true;
    } else {
    	if ($('#exTrade').val() == '1'){
    		return fn_checkPreOrderSalesPerson(0, memCode);
    	}
//       if ($('#exTrade').val() == '1' && $("#hiddenTypeId").val() == '964'
//           && $('#relatedNo').val() == ''
//           && $('#hiddenMonthExpired').val() != '1') {
//         return fn_checkPreOrderSalesPerson(0, memCode);
//       } else if ($('#exTrade').val() == '1'
//           && $("#hiddenTypeId").val() == '964'
//           && $('#relatedNo').val() != ''
//           && $('#hiddenMonthExpired').val() != '1') {
//         return fn_checkPreOrderSalesPerson(0, memCode);
//       } else if ($('#exTrade').val() == '1'
//           && $("#hiddenTypeId").val() == '964'
//           && $('#relatedNo').val() != ''
//           && $('#hiddenMonthExpired').val() == '1') {
//         return fn_checkPreOrderConfigurationPerson(0, memCode,
//             salesOrdId, salesOrdNo);
       else {
        return true;
      }
    }
  }

  function fn_selectPromotionFreeGiftListForList2(promoId) {
    Common.ajax("GET", "/sales/promotion/selectPromotionFreeGiftList.do", {
      promoId : promoId
    }, function(result) {
      AUIGrid.setGridData(listGiftGridID, result);
    });
  }

  function fn_loadPromotionPrice(promoId, stkId, srvPacId) {
    if ($('#gstChk').val() == '1') {
      $('#pBtnCal').removeClass("blind");
    } else {
      $('#pBtnCal').addClass("blind");
    }
    Common.ajax("GET",
        "/sales/order/selectProductPromotionPriceByPromoStockID.do", {
          promoId : promoId,
          stkId : stkId,
          srvPacId : srvPacId
        }, function(promoPriceInfo) {
          if (promoPriceInfo != null) {
            //              $("#ordPrice").removeClass("readonly");
            //              $("#ordPv").removeClass("readonly");
            //              $("#ordRentalFees").removeClass("readonly");

            $("#ordPrice").val(promoPriceInfo.orderPricePromo);
            $("#ordPv").val(promoPriceInfo.orderPVPromo);
            $("#ordPvGST").val(promoPriceInfo.orderPVPromoGST);
            $("#ordRentalFees").val(
                promoPriceInfo.orderRentalFeesPromo);

            $("#promoDiscPeriodTp").val(
                promoPriceInfo.promoDiscPeriodTp);
            $("#promoDiscPeriod").val(
                promoPriceInfo.promoDiscPeriod);
            totPv = promoPriceInfo.orderPVPromo;
            totPvSs = parseFloat(promoPriceInfo.promoItmPvSs).toFixed(2);
            fn_checkPreSrvType(promoPriceInfo.srvType);
          }
          enableSaveButton()
        });
  }

  /*Load Promotion*/
  //LoadProductPromotion
  function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal,
      exTrade) {
    var isSrvPac = null;
    var extradeOrder = $('#relatedNo').val();
    $('#ordPromo').removeAttr("disabled");

    if (appTypeVal == "66")
      isSrvPac = "Y";

    //function change
    //voucher management
    doGetComboData('/sales/order/selectPromotionByAppTypeStockESales.do', {
      appTypeId : appTypeVal,
      stkId : stkId,
      empChk : empChk,
      promoCustType : custTypeVal,
      exTrade : exTrade,
      srvPacId : $('#srvPacId').val(),
      isSrvPac : isSrvPac,
      voucherPromotion : voucherAppliedStatus,
      custStatus : $('#hiddenCustStatusId').val()
    }, '', 'ordPromo', 'S', 'voucherPromotionCheck'); //Common Code
  }

  //LoadProductPrice
  function fn_loadProductPrice(appTypeVal, stkId, srvPacId) {
    if ($('#gstChk').val() == '1') {
      $('#pBtnCal').removeClass("blind");
    } else {
      $('#pBtnCal').addClass("blind");
    }

    var appTypeId = 0;

    appTypeId = appTypeVal == '68' ? '67' : appTypeVal;

    $("#searchAppTypeId").val(appTypeId);
    $("#searchStkId").val(stkId);
    $("#searchSrvPacId").val(srvPacId);

    Common.ajax("GET", "/sales/order/selectStockPriceJsonInfo.do", {
      appTypeId : appTypeId,
      stkId : stkId,
      srvPacId : srvPacId
    }, function(stkPriceInfo) {

      if (stkPriceInfo != null) {
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
    $("optgroup").attr("class", "optgroup_text")
  }

  function fn_setDefaultSrvPacId() {
    //if($('#srvPacId option').size() == 2) {
    $('#srvPacId option[value="2"]').attr('selected', 'selected');

    var stkType = $("#appType").val() == '66' ? '1' : '2';

    doGetComboAndGroup2('/sales/order/selectProductCodeList.do', {
      stkType : stkType,
      srvPacId : $('#srvPacId').val(),
      alwSale : alwSale
    }, '', 'ordProudct', 'S', 'fn_setOptGrpClass');//product 생성
    //}
  }

  function fn_clearSales() {
    $('#installDur').val('');
    $('#ordProudct').val('');
    $('#ordPromo').val('');
    //$('#relatedNo').val('');
    //$('#hiddenMonthExpired').val('');
    //$('#hiddenPreBook').val('');
    //$('#isReturnExtrade').prop("checked", true);
    $('#isReturnExtrade').attr("disabled", true);
    //$('#trialNoChk').prop("checked", false);
    //$('#trialNo').val('');
    $('#ordPrice').val('');
    $('#ordPriceId').val('');
    $('#ordPv').val('');
    $('#ordRentalFees').val('');
    $('#compType').addClass("blind");
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

  function fn_loadCustomer(custId, nric) {
    Common.ajax("GET", "/sales/customer/selectCustomerJsonList", { custId : custId, nric : nric },
      function(result) {
        Common.removeLoader();

        if (result.length > 0) {
          Common.confirm( '<b>* This customer is an existing customer.<br>Do you want to proceed for key-in?</b>',
            function(){
             $('#scPreOrdArea').removeClass("blind");
              var custInfo = result[0];
              var dob = custInfo.dob;
              var dobY = dob.split("/")[2];
              var nowDt = new Date();
              var nowDtY = nowDt.getFullYear();
              if (!nric.startsWith("TST")) {
                if (dobY != 1900) {
                  if ((nowDtY - dobY) < 18) {
                    Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* b Member must 18 years old and above.</b>");
                    $('#scPreOrdArea').addClass("blind");
                    return false;
                  }
                }

              }

              $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
              // $("#custId").val(custInfo.custId); //Customer ID

              // $("#custTypeNm").val(custInfo.codeName1); //Customer Name
              $("#custTypeNm").text(custInfo.codeName1);
              $("#hiddenCustTypeNm").val(custInfo.codeName1); //Customer Type Nm(Hidden)

              $("#hiddenTypeId").val(custInfo.typeId); //Type
              // $("#name").val(custInfo.name); //Name
              $("#name").text(custInfo.name); //Name
              $("#nric").val(custInfo.nric); //NRIC/Company No

              $("#sstRegNo").text(custInfo.sstRgistNo); //SST Reg No
              $("#tin").text(custInfo.custTin); //TIN No

              // $("#nationNm").val(custInfo.name2); //Nationality
              $("#nationNm").text(custInfo.name2); //Nationality
              // $("#raceId").val(custInfo.raceId); //Nationality
              // $("#race").val(custInfo.codeName2); //
              $("#race").text(custInfo.codeName2); //
              // $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
              $("#dob").text(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
              // $("#gender").val(custInfo.gender); //Gender
               $("#gender").text(custInfo.gender); //Gender
              // $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
               $("#pasSportExpr").text(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
              // $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
              $("#visaExpr").text(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
              $("#custEmail").val(custInfo.email); //Email
              $("#pCustEmail").show();
              fn_maskingData("_CUSTEMAIL", $("#custEmail"));
              $("#custEmail").text(custInfo.email); //Email
              $("#hiddenCustStatusId").val(custInfo.custStatusId); //Customer Status
              //$("#custStatus").val(custInfo.custStatus); //Customer Status
              $("#custStatus").text(custInfo.custStatus); //Customer Status
              // $("#custRem").val(custInfo.rem); //Remark
              // $("#gstChk").val('0').prop("disabled", true);

              if (custInfo.receivingMarketingMsgStatus == 1) {
                $("#marketMessageYes").prop("checked", true);
              } else {
                $("#marketMessageNo").prop("checked", true);
              }

              if (custInfo.corpTypeId > 0) {
                $("#corpTypeNm").val(custInfo.codeName); //Industry Code
              } else {
                $("#corpTypeNm").val(""); //Industry Code
              }

              /*
               if($('#hiddenTypeId').val() == '965') { //Company
                 $('#sctBillPrefer').removeClass("blind");
               } else {
                 $('#sctBillPrefer').addClass("blind");
               }
              */

              if (custInfo.custAddId > 0) {
                //----------------------------------------------------------
                // [Billing Detail] : Billing Address SETTING
                //----------------------------------------------------------
                // $('#billAddrForm').clearForm();
                fn_loadBillAddr(custInfo.custAddId);

                //----------------------------------------------------------
                // [Installation] : Installation Address SETTING
                //----------------------------------------------------------
                // fn_clearInstallAddr();
                fn_loadInstallAddr(custInfo.custAddId);
              }

              if (custInfo.custCntcId > 0) {
                //----------------------------------------------------------
                // [Master Contact] : Owner & Purchaser Contact
                //                           Additional Service Contact
                //----------------------------------------------------------
                // $('#custCntcForm').clearForm(); // KR-OHK
                // $('#liMstCntcNewAddr').addClass("blind");
                // $('#liMstCntcSelAddr').addClass("blind");
                // $('#liMstCntcNewAddr2').addClass("blind");
                // $('#liMstCntcSelAddr2').addClass("blind");

                fn_loadMainCntcPerson(custInfo.custCntcId);
                fn_loadCntcPerson(custInfo.custCntcId);
                // fn_loadSrvCntcPerson(custInfo.custCareCntId);
                // ----------------------------------------------------------
                //  [Installation] : Installation Contact Person
                // ----------------------------------------------------------
                // $('#instCntcForm').clearForm();
                // fn_loadInstallationCntcPerson(custInfo.custCntcId);
              }

              if (custInfo.codeName == 'Government') {
                Common.alert('<b>Goverment Customer</b>');
              }
            }, fn_closePreOrdRegPop2);
        } else {
          Common.confirm( '<b>* This customer is NEW customer.<br>Do you want to create a customer?</b>', fn_createCustomerPop, fn_closePreOrdRegPop2);
        }
      });
  }

  function fn_showExistingCust() {

  }

  function fn_loadBillingGroup(billGrpId, custBillGrpNo, billType,
      billAddrFull, custBillRem, custBillAddId) {
    $('#hiddenBillGrpId').removeClass("readonly").val(billGrpId);
    $('#billGrp').removeClass("readonly").val(custBillGrpNo);
    $('#billType').removeClass("readonly").val(billType);
    $('#billAddr').removeClass("readonly").val(billAddrFull);
    $('#billRem').removeClass("readonly").val(custBillRem);

    fn_loadBillAddr(custBillAddId);
  }

  function fn_loadBillAddr(custAddId) {
    Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
      custAddId : custAddId
    }, function(billCustInfo) {
      if (billCustInfo != null) {
        $("#hiddenBillAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
        $("#billAddrDtl").val(billCustInfo.addrDtl); //Address
        $("#pBillAddrDtl").show();
        fn_maskingDataAddr("_BILLADDRDTL", $("#billAddrDtl"));

        // $("#billStreet").val(billCustInfo.street); //Street
        $("#billStreet").text(billCustInfo.street); //Street

        // $("#billArea").val(billCustInfo.area); //Area
        $("#billArea").text(billCustInfo.area); //Area

        // $("#billCity").val(billCustInfo.city); //City
        $("#billCity").text(billCustInfo.city); //City

        // $("#billPostCode").val(billCustInfo.postcode); //Post Code
        $("#billPostCode").text(billCustInfo.postcode); //Post Code

        // $("#billState").val(billCustInfo.state); //State
        $("#billState").text(billCustInfo.state); //State

        // $("#billCountry").val(billCustInfo.country); //Country
        $("#billCountry").text(billCustInfo.country); //Country

        $("#hiddenBillStreetId").val(billCustInfo.custAddId); //Magic Address STREET_ID(Hidden)
      }
    });
  }

  function fn_loadInstallAddr(custAddId) {
    Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
      custAddId : custAddId
    }, function(custInfo) {
      if (custInfo != null) {
        $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
        $("#instAddrDtl").val(custInfo.addrDtl); //Address
        $("#pInstAddrDtl").show();
        fn_maskingDataAddr("_INSTADDRDTL", $("#instAddrDtl"));

        // $("#instStreet").val(custInfo.street); //Street
        $("#instStreet").text(custInfo.street); //Street

        // $("#instArea").val(custInfo.area); //Area
        $("#instArea").text(custInfo.area); //Area

        // $("#instCity").val(custInfo.city); //City
        $("#instCity").text(custInfo.city); //City

        // $("#instPostCode").val(custInfo.postcode); //Post Code
        $("#instPostCode").text(custInfo.postcode); //Post Code

        // $("#instState").val(custInfo.state); //State
        $("#instState").text(custInfo.state); //State

        // $("#instCountry").val(custInfo.country); //Country
        $("#instCountry").text(custInfo.country); //Country

        $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
        if (MEM_TYPE == 2)
          $("#keyinBrnchId").val(custInfo.cdBrnchId); //Posting Branch
        else if (MEM_TYPE == 7)
          $("#keyinBrnchId").val(284); //Posting Branch
        else
          $("#keyinBrnchId").val(custInfo.soBrnchId); //Posting Branch
          //              if(!$("#gstChk").is('[disabled]')) {

        if (custInfo.gstChk == '1') {
          $("#gstChk").val('1').prop("disabled", true);
        } else {
          $("#gstChk").val('0').removeAttr("disabled");
        }
        //              }
      }
    });
  }

  function fn_createCustomerPop() {
    if (Common.checkPlatformType() == "mobile") {
      var strDocumentWidth = $(document).outerWidth();
      var strDocumentHeight = $(document).outerHeight();
      Common.popupWin("frmCustSearch",
          "/sales/customer/customerRegistPopESales.do", {
            width : strDocumentWidth + "px",
            height : strDocumentHeight + "px",
            resizable : "no",
            scrollbars : "yes"
          });
    } else {
      Common.popupWin("frmCustSearch",
          "/sales/customer/customerRegistPopESales.do", {
            width : "1220px",
            height : "690",
            resizable : "no",
            scrollbars : "no"
          });
      //Common.popupDiv("/sales/customer/customerRegistPopESales.do", {"callPrgm" : "PRE_ORD"});
    }
  }

  function fn_loadMainCntcPerson(custCntcId) {
    Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
      custCntcId : custCntcId
    }, function(custCntcInfo) {
      if (custCntcInfo != null) {
        $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
        // $("#custInitial").val(custCntcInfo.code);
        $("#custInitial").text(custCntcInfo.code);
        $("#custEmail").val(custCntcInfo.email);
        /*
          $("#custTelM").val(custCntcInfo.telM1);
          $("#custTelR").val(custCntcInfo.telR);
          $("#custTelO").val(custCntcInfo.telO);
          $("#custTelF").val(custCntcInfo.telf);
          $("#custExt").val(custCntcInfo.ext);
        */
      }
    });
  }

  function fn_loadSrvCntcPerson(custCareCntId) {
    Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", {
      custCareCntId : custCareCntId
    }, function(srvCntcInfo) {
      if (srvCntcInfo != null) {
        //hiddenBPCareId
        $("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);

        //$("#custCntcName").val(srvCntcInfo.name);
        $("#custCntcName").text(srvCntcInfo.name);

        $("#custCntcInitial").val(srvCntcInfo.custInitial);

        $("#custCntcEmail").val(srvCntcInfo.email);
        $("#pCntcEmail").show();
        fn_maskingData("_CNTCEMAIL", $("#custCntcEmail"));

        $("#custCntcTelM").val(srvCntcInfo.telM);
        $("#pCustCntcTelM").show();
        fn_maskingData("_CUSTCNTCTELM", $("#custCntcTelM"));

        $("#custCntcTelR").val(srvCntcInfo.telR);
        $("#pCustCntcTelR").show();
        fn_maskingData("_CUSTCNTCTELR", $("#custCntcTelR"));

        $("#custCntcTelO").val(srvCntcInfo.telO);
        $("#pCustCntcTelO").show();
        fn_maskingData("_CUSTCNTCTELO", $("#custCntcTelO"));

        $("#custCntcTelF").val(srvCntcInfo.telf);
        $("#pCustCntcTelF").show();
        fn_maskingData("_CUSTCNTCTELF", $("#custCntcTelF"));

        // $("#custCntcExt").val(srvCntcInfo.ext);
        $("#custCntcExt").text(srvCntcInfo.ext);
      }
    });
  }

  function fn_loadCntcPerson(custCntcId) {
    Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
      custCntcId : custCntcId
    }, function(custCntcInfo) {
      if (custCntcInfo != null) {
        $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
        $("#custCntcInitial").val(custCntcInfo.code);

        //$("#custCntcName").val(custCntcInfo.name1);
        $("#custCntcName").text(custCntcInfo.name1);

        $("#custCntcEmail").val(custCntcInfo.email);
        $("#pCntcEmail").show();
        fn_maskingData("_CNTCEMAIL", $("#custCntcEmail"));

        $("#custCntcTelM").val(custCntcInfo.telM1);
        $("#pCustCntcTelM").show();
        fn_maskingData("_CUSTCNTCTELM", $("#custCntcTelM"));

        $("#custCntcTelR").val(custCntcInfo.telR);
        $("#pCustCntcTelR").show();
        fn_maskingData("_CUSTCNTCTELR", $("#custCntcTelR"));

        $("#custCntcTelO").val(custCntcInfo.telO);
        $("#pCustCntcTelO").show();
        fn_maskingData("_CUSTCNTCTELO", $("#custCntcTelO"));

        $("#custCntcTelF").val(custCntcInfo.telf);
        $("#pCustCntcTelF").show();
        fn_maskingData("_CUSTCNTCTELF", $("#custCntcTelF"));

        // $("#custCntcExt").val(custCntcInfo.ext);
        $("#custCntcExt").text(custCntcInfo.ext);
      }
    });
  }

  function chgTab(tabNm) {
    console.log('tabNm:' + tabNm);

    switch (tabNm) {
    case 'ord':

      if (MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7") {
        $('#memBtn').addClass("blind");
        $('#salesmanCd').prop("readonly", true).addClass("readonly");
        ;
        $('#salesmanCd').val("${SESSION_INFO.userName}");
        $('#salesmanCd').change();
      }

      //$('#appType').val("66");
      //   $('#appType').prop("disabled", true);

      if ($('#ordProudct').val() == null) {
        $('#appType').change();
      }

      $('[name="advPay"]').prop("disabled", true);
      $('#advPayNo').prop("checked", true);
      //   $('#poNo').prop("disabled", true);

      break;
    case 'pay':
      if ($('#appType').val() == '66') {
        $('#rentPayMode').val('131');
        $('#rentPayMode').change();
        //     $('#rentPayMode').prop("disabled", true);

        console.log('hiddenCustTypeNm For Third Party: '
            + $('#hiddenCustTypeNm').val());
        if ($('#hiddenCustTypeNm').val() == 'Company') {
          $('#thrdParty').prop("disabled", false);
        } else {
          $('#thrdParty').prop("disabled", true);
        }

      }

      $('[name="grpOpt"]').prop("disabled", true);
      fn_setBillGrp("new"); // default set billing group option to new
      break;
    default:
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

  function encryptIc(nric) {
    $('#nric').attr("placeholder", nric.substr(0).replace(/[\S]/g, "*"));
    //$('#nric').val(nric.substr(0).replace(/[\S]/g,"*"));
  }

  function fn_removeFile(name) {
    if (name == "PAY") {
      $("#payFile").val("");
      $('#payFile').change();
    } else if (name == "TRF") {
      $("#trFile").val("");
      $('#trFile').change();
    } else if (name == "OTH") {
      $("#otherFile").val("");
      $('#otherFile').change();
    } else if (name == "OTH2") {
      $("#otherFile2").val("");
      $('#otherFile2').change();
    } else if (name == "TNC") {
      $("#sofTncFile").val("");
      $('#sofTncFile').change();
    } else if (name == "MSOF") {
      $("#msofFile").val("");
      $('#msofFile').change();
    } else if (name == "MSOFTNC") {
      $("#msofTncFile").val("");
      $('#msofTncFile').change();
    }
  }

  function fn_clearAddCpnt() {
    $('#trCpntId').css("visibility", "collapse");
    $('#compType option').remove();
  }

  function fn_loadProductComponent(appTyp, stkId) {
    $('#compType option').remove();
    $('#compType').removeClass("blind");
    $('#compType').removeClass("disabled");

    doGetComboData('/sales/order/selectProductComponent.do', {
      appTyp : appTyp,
      stkId : stkId
    }, '', 'compType', 'S', '');
  }

  function fn_check(a) {
    if ($('#compType option').length <= 0) {
      if (a == 3) {
        return;
      } else {
        setTimeout(function() {
          fn_check(parseInt(a) + 1)
        }, 500);
      }
    } else if ($('#compType option').length <= 1) {
      $('#trCpntId').css("visibility", "collapse");
      $('#compType option').remove();
      $('#compType').addClass("blind");
      $('#compType').prop("disabled", true);
    } else if ($('#compType option').length > 1) {
      $('#trCpntId').css("visibility", "visible");
      $('#compType').remove("blind");
      $('#compType').removeAttr("disabled");

      var key = 0;
      Common.ajax("GET",
          "/sales/order/selectProductComponentDefaultKey.do", {
            stkId : $("#ordProudct").val()
          }, function(defaultKey) {
            if (defaultKey != null) {
              key = defaultKey.code;
              $('#compType').val(key).change();
              fn_reloadPromo();
            }
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

    doGetComboData('/sales/order/selectPromoBsdCpnt.do', {
      appTyp : appTyp,
      stkId : stkId,
      custTypeId : custTypeId,
      cpntId : cpntId,
      empInd : empInd,
      exTrade : exTrade,
      srvPacId : srvPacId,
      custStatus : $('#hiddenCustStatusId').val()
    }, '', 'ordPromo', 'S', '');
  }

  function displayVoucherSection() {
    if ($('#voucherType option:selected').val() != null
        && $('#voucherType option:selected').val() != ""
        && $('#voucherType option:selected').val() != "0") {
      $('.voucherSection').show();
    } else {
      $('.voucherSection').hide();
      clearVoucherData();
    }
  }

  function applyVoucher() {
    var voucherCode = $('#voucherCode').val();
    var voucherEmail = $('#voucherEmail').val();
    var voucherType = $('#voucherType option:selected').val();

    if (voucherCode.length == 0 || voucherEmail.length == 0) {
      clearVoucherData();
      Common.alert('Both voucher code and voucher email must be key in');
      return;
    }
    Common
        .ajax(
            "GET",
            "/misc/voucher/voucherVerification.do",
            {
              platform : voucherType,
              voucherCode : voucherCode,
              custEmail : voucherEmail,
              isEKeyIn : true
            },
            function(result) {
              if (result.code == "00") {
                voucherAppliedStatus = 1;
                $('#voucherMsg').text(
                    'Voucher Applied for ' + voucherCode);
                voucherAppliedCode = voucherCode;
                voucherAppliedEmail = voucherEmail;
                $('#voucherMsg').show();

                Common
                    .ajax(
                        "GET",
                        "/misc/voucher/getVoucherUsagePromotionId.do",
                        {
                          voucherCode : voucherCode,
                          custEmail : voucherEmail
                        },
                        function(result) {
                          if (result.length > 0) {
                            voucherPromotionId = result;

                            //reload promotion dropdown
                            var appTypeVal = $(
                                "#appType")
                                .val();
                            var custTypeVal = $(
                                "#hiddenTypeId")
                                .val();
                            var stkIdVal = $(
                                "#ordProudct")
                                .val();
                            var empChk = 0;
                            var exTrade = $(
                                "#exTrade")
                                .val();
                            var stkIdx = $(
                                "#ordProudct option:selected")
                                .index();

                            if (stkIdx > 0) {
                              fn_loadProductPromotion(
                                  appTypeVal,
                                  stkIdVal,
                                  empChk,
                                  custTypeVal,
                                  exTrade);
                            }
                          } else {
                            //reset everything
                            clearVoucherData();
                            Common
                                .alert("No Promotion is being entitled for this voucher code");
                            return;
                          }
                        });
              } else {
                clearVoucherData();
                Common.alert(result.message);
                return;
              }
            });
  }

  function voucherPromotionCheck() {
    if (voucherAppliedStatus == 1) {
      var orderPromoId = [];
      var orderPromoIdToRemove = [];
      $("#ordPromo option").each(function() {
        orderPromoId.push($(this).val());
      });
      orderPromoIdToRemove = orderPromoId.filter(function(obj) {
        return !voucherPromotionId.some(function(obj2) {
          return obj == obj2;
        });
      });

      if (orderPromoIdToRemove.length > 0) {
        $('#ordPromo').val('');
        for (var i = 0; i < orderPromoIdToRemove.length; i++) {
          if (orderPromoIdToRemove[i] == "") {
          } else {
            $(
                "#ordPromo option[value='"
                    + orderPromoIdToRemove[i] + "']")
                .remove();
          }
        }
      }
    }
  }

  function clearVoucherData() {
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

  function fn_resetSales() {
    // $("#appType").change()
  }

  function fn_maskingData(ind, obj) {
    var maskedVal = (obj.val()).substr(-4).padStart((obj.val()).length, '*');
      $("#span" + ind).html(maskedVal);
      // Appear NRIC on hover over field
      /*$("#span" + ind).hover(function() {
          $("#span" + ind).html(obj.val());
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
          $("#span" + ind).html(obj.val());
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });*/
  }

  function fn_maskingDataAddr(ind, obj) {
    var maskedVal = (obj.val()).substr(-20).padStart((obj.val()).length, '*');
      $("#span" + ind).html(maskedVal);
      // Appear NRIC on hover over field
      /*$("#span" + ind).hover(function() {
          $("#span" + ind).html(obj.val());
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });
      $("#imgHover" + ind).hover(function() {
          $("#span" + ind).html(obj.val());
      }).mouseout(function() {
          $("#span" + ind).html(maskedVal);
      });*/
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

  function fn_checkPreSrvType(val){
	  $("#preSrvTypeLbl").find("span").remove();
	  preSrvType = val;
	  if(preSrvType == "HS"){
		  $('[name="preSrvType"]').prop("disabled", true);
		  $('#preSrvTypeHS').prop("checked", true);
	  }else if(preSrvType == "SS"){
		  $('[name="preSrvType"]').prop("disabled", true);
		  $('#preSrvTypeSS').prop("checked", true);
		  $("#preSrvTypeLbl").append("<span class='must'><spring:message code='sales.text.serviceTypeDiscountMessage'/></span>");
		  $('#ordPv').val(totPvSs)
	  }else if(preSrvType == "BOTH"){
		  $('[name="preSrvType"]').prop("disabled", false);
		  $('#preSrvTypeHS').prop("checked", true);
	  }else{
		  $('[name="preSrvType"]').prop("disabled", true);
		  $('#preSrvTypeHS').prop("checked", true);
	  }
  }

  function fn_resetPreSrvType(){
	  $('[name="preSrvType"]').prop("disabled", true);
      $("#preSrvTypeLbl").find("span").remove();
      $('[name="preSrvType"]').prop("checked", false);
  }

</script>

  <div id="popup_wrap" class="popup_wrap">
    <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>eKey-in</h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnPreOrdClose" onClick="javascript:fn_closePreOrdRegPop2();" href="#">CLOSE | TUTUP</a>
        </p>
      </li>
    </ul>
  </header>
  <!-- pop_header end -->

  <section class="pop_body">
    <!-- pop_body start -->
    <aside class="title_line">
      <!-- title_line start -->
      <ul class="right_btns">
        <li>
          <p class="btn_blue">
            <a id="btnConfirm" href="#">Confirm</a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a id="btnClear" href="#">Clear</a>
          </p>
        </li>
      </ul>
    </aside>
    <!-- title_line end -->

    <form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
      <input id="selType" name="selType" type="hidden" value="1" />
      <input id="callPrgm" name="callPrgm" type="hidden" value="PRE_ORD" />
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <%--
          <tr>
            <th scope="row"><spring:message code="sal.text.custType" /><span class="must">*</span></th>
            <td>
              <select name="cmbTypeId" id="cmbTypeId" >
                <option value="">Please Choose a Customer Type</option>
                <option value="965">Company</option>
                <option value="964">Individual</option>
              </select>
              <!-- <select class="w100p disabled" id="_cmbTypeId_" name="cmbTypeId" disabled="disabled"></select> -->
              <input id="_cmbTypeId_" name="cmbTypeId" type="hidden"/>
              <!--  <div id="custTypeForm">
                <label><input type="radio" id="CustCom" name="cmbTypeId" value="965"  /><span>Company</span></label>
                <label><input type="radio" id="CustInd" name="cmbTypeId" value="964" /><span>Individual</span></label>
                <input id="_cmbTypeId_" name="cmbTypeId" type="hidden"/>
              </div> -->
            </td>
          </tr> --%>
          <tr>
            <th scope="row">NRIC/Company No</th>
            <td colspan="3">
              <input id="nric" name="nric" type="text" title="" placeholder="" class="w100p" style="min-width: 150px" value="" '/>
               <table id="pNric" style="display:none">
                 <tr>
                   <!-- <td width="3%">
                     <a href="#" class="search_btn" id="imgHover_NRIC">
                       <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                     </a>
                   </td> -->
                   <td><span id="span_NRIC"></span></td>
                 </tr>
               </table>
             </td>
          </tr>
          <tr>
            <th scope="row">SOF No</th>
            <td colspan="3">
              <input id="sofNo" name="sofNo" type="text" title="" placeholder="" class="w100p" style="min-width: 150px" value="" '/>
              <table id="pSofNo" style="display:none">
                 <tr>
                   <!-- <td width="3%">
                     <a href="#" class="search_btn" id="imgHover_SOFNO">
                       <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                     </a>
                   </td> -->
                   <td><span id="span_SOFNO"></span></td>
                 </tr>
               </table>
            </td>
          </tr>
          <tr>
            <th scope="row" colspan="4"><span class="must"><spring:message code='sales.msg.ordlist.icvalid' /></span></th>
          </tr>
        </tbody>
      </table>
      <!-- table end -->
    </form>

    <!------------------------------------------------------------------------------
      Pre-Order Regist Content START
    ------------------------------------------------------------------------------->

    <section id="scPreOrdArea" class="blind">
      <section class="tap_wrap">
        <!-- tap_wrap start -->
        <ul class="tap_type1 num4">
          <li><a id="aTabCS" class="on">Customer</a></li>
          <li><a id="aTabOI" onClick="javascript:chgTab('ord');">Order Info</a></li>
          <li><a id="aTabBD" onClick="javascript:chgTab('pay');">Payment Info</a></li>
          <li><a id="aTabFL">Attachment</a></li>
        </ul>

        <article class="tap_area">
          <!-- tap_area start -->
          <section class="search_table">
            <!-- search_table start -->
            <form id="frmPreOrdReg" name="frmPreOrdReg" action="#" method="post">
              <input id="hiddenCustId" name="custId" type="hidden" />
              <input id="hiddenCustTypeNm" name="custTypeNm" type="hidden" />
              <input id="hiddenTypeId" name="typeId" type="hidden" />
              <input id="hiddenCustCntcId" name="custCntcId" type="hidden" />
              <input id="hiddenCustAddId" name="custAddId" type="hidden" />
              <input id="hiddenCallPrgm" name="callPrgm" type="hidden" />
              <input id="hiddenCustStatusId" name="hiddenCustStatusId" type="hidden" />

              <!-- title_line start -->
              <aside class="title_line">
                <h3>Customer information</h3>
              </aside>
              <!-- title_line end -->

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">
                      <spring:message code="sal.text.custType2" /> <span class="must">*</span>
                    </th>
                    <td>
                      <!-- <input id="custTypeNm" name="custTypeNm" type="text" title="" placeholder="" class="w100p readonly" />  -->
                      <span id="custTypeNm" name="custTypeNm"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.initial2" />
                      <span class="must">*</span>
                    </th>
                    <td>
                      <!-- <input id="custInitial" name="custInitial" type="text" title="Initial" placeholder="Initial" class="w100p readonly" readonly />  -->
                      <span id="custInitial" name="custInitial"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.title.text.companyType2" /></th>
                    <td>
                      <!-- <input id="corpTypeNm" name="corpTypeNm" type="text" title="" placeholder="" class="w100p readonly" /> -->
                      <span id="corpTypeNm" name="corpTypeNm"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.custName2" /><span class="must">*</span></th>
                    <td>
                      <!-- <input id="name" name="name" type="text" title="" placeholder="" class="w100p readonly" readonly /> -->
                      <span id="name" name="name"></span>
                    </td>
                  </tr>
                  <!--
                  <tr>
                    <th scope="row">GST Relief Certificate / Regist. No.</th>
                    <td colspan="3">
                      <p>
                        <select id="gstChk" name="gstChk" class="w100p"></select>
                      </p>
                      <p>
                        <input id="txtCertCustRgsNo" name="txtCertCustRgsNo" type="text" title="" placeholder="" class="w100p" />
                      </p>
                      <p>
                        <div class="auto_file file_flag">auto_file start
                          <input type="file" title="file add" />
                        </div>auto_file end
                      </p>
                    </td>
                  </tr>
                  -->
                </tbody>
              </table>
              <!-- table end -->

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.sstRegistrationNo" /><span class="must">*</span></th>
                    <td>
                      <!-- <input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p readonly" readonly />  -->
                      <span id="sstRegNo" name="sstRegNo"></span>
                     </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.tin" /><span class="must">*</span></th>
                    <td>
                      <!-- <input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p readonly" readonly />  -->
                      <span id="tin" name="tin"></span>
                     </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.nationality2" /><span class="must">*</span></th>
                    <td>
                      <!-- <input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p readonly" readonly />  -->
                      <span id="nationNm" name="nationNm"></span>
                     </td>
                  </tr>
                  <tr>
                    <th scope="row">Passport Visa expiry date | Visa passport tarikh tamat(foreigner)</th>
                    <td>
                      <!-- <input id="visaExpr" name="visaExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly /> -->
                      <span id="visaExpr" name="visaExpr"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Passport expiry date | Pasport tarikh luput(foreigner)</th>
                    <td>
                      <!-- <input id="pasSportExpr" name="pasSportExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly /> -->
                      <span id="pasSportExpr" name="pasSportExpr"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.dob2" /></th>
                    <td>
                      <!-- <input id="dob" name="dob" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly /></td> -->
                      <span id="dob" name="dob"></span>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.race2" /><span class="must">*</span></th>
                    <td>
                      <!-- <input id="race" name="race" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly /> -->
                      <span id="race" name="race"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.gender2" /></th>
                    <td>
                      <!-- <input id="gender" name="gender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly /> -->
                      <span id="gender" name="gender"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.title.text.email2" /></th>
                    <td>
                      <input id="custEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                      <table id="pCustEmail" style="display:none">
                        <tr>
                         <!-- <td width="3%">
                           <a href="#" class="search_btn" id="imgHover_CUSTEMAIL">
                             <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                           </a>
                         </td> -->
                         <td><span id="span_CUSTEMAIL"></span></td>
                       </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Receiving Marketing Message</th>
                    <td>
                      <div style="display: inline-block; width: 100%;">
                        <div style="display: inline-block;">
                          <input id="marketMessageYes" type="radio" value="1" name="marketingMessageSelection" />
                          <label for="marketMessageYes">Yes</label>
                        </div>
                        <div style="display: inline-block;">
                          <input id="marketMessageNo" type="radio" value="0" name="marketingMessageSelection" />
                          <label for="marketMessageNo">No</label>
                        </div>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Customer Status</th>
                    <td>
                      <!-- <input id="custStatus" name="custStatus" type="text" title="" placeholder="" class="w100p readonly" readonly /> -->
                      <span id="custStatus" name="custStatus"></span>
                    </td>
                  </tr>
                  <!-- <tr>
                           <th scope="row">Tel (Mobile)</th>
                           <td>
                             <input id="custTelM" name="custTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/>
                           </td>
                         </tr>
                         <tr>
                           <th scope="row">Tel (Residence)</th>
                           <td><input id="custTelR" name="custTelR" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
                           <th scope="row">Tel (Fax)<span class="must">*</span></th>
                           <td><input id="custTelF" name="custTelF" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
                         </tr>
                         <tr>
                           <th scope="row">Tel (Office)</th>
                           <td><input id="custTelO" name="custTelO" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
                         </tr>
                         <tr>
                           <th scope="row">Ext No.</th>
                           <td><input id="custExt" name="custExt" type="text" title="" placeholder="" class="w100p readonly" readonly/></td>
                         </tr>
                       -->
                 </tbody>
              </table>
              <!-- table end -->

              <aside class="title_line">
                <!-- title_line start -->
                <h3>Contact Person information</h3>
              </aside>
              <!-- title_line end -->

              <!-- 20191105 - KR-SH 모바일 화면일 경우 여백이 생김 삭제처리
              <table class="type1">
                <caption>table</caption>
                <colgroup>
                  <col style="width:250px" />
                  <col style="width:*" />
                  <col style="width:250px" />
                  <col style="width:*" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">If contact same as above click here</th>
                    <td colspan="3"><input id="chkSameCntc" type="checkbox" checked/></td>
                  </tr>
                </tbody>
              </table>
               -->

              <section id="scAnothCntc">
                <ul class="right_btns mb10">
                  <li>
                    <p class="btn_grid">
                      <a id="btnSelCntc" href="#">Select Another Contact</a>
                    </p>
                  </li>
                  <li>
                    <p class="btn_grid">
                      <a id="btnNewCntc" href="#">Add New Contact</a>
                    </p>
                  </li>
                </ul>

                <table class="type1">
                  <!-- table start -->
                  <caption>table</caption>
                  <colgroup>
                    <col style="width: 40%" />
                    <col style="width: *" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <!--
                      <th scope="row">Initial<span class="must">*</span></th>
                      <td>
                        <input id="custCntcInitial" name="custCntcInitial" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly/>
                      </td>
                       -->
                      <th scope="row">Second/Service contact person name</th>
                      <td>
                        <!-- <input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p readonly" readonly /> -->
                        <span id="custCntcName" name="custCntcName"></span>
                       </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Mobile)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelM" style="display:none">
                        <tr>
                         <!-- <td width="3%">
                           <a href="#" class="search_btn" id="imgHover_CUSTCNTCTELM">
                             <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                           </a>
                         </td> -->
                         <td><span id="span_CUSTCNTCTELM"></span></td>
                       </tr>
                      </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Residence)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelR" style="display:none">
                        <tr>
                         <!-- <td width="3%">
                           <a href="#" class="search_btn" id="imgHover_CUSTCNTCTELR">
                             <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                           </a>
                         </td> -->
                         <td><span id="span_CUSTCNTCTELR"></span></td>
                       </tr>
                      </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Office)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelO" style="display:none">
                        <tr>
                         <!-- <td width="3%">
                           <a href="#" class="search_btn" id="imgHover_CUSTCNTCTELO">
                             <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                           </a>
                         </td> -->
                         <td><span id="span_CUSTCNTCTELO"></span></td>
                       </tr>
                      </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Fax)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCustCntcTelF" style="display:none">
                          <tr>
                             <!-- <td width="3%">
                               <a href="#" class="search_btn" id="imgHover_CUSTCNTCTELF">
                                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                               </a>
                             </td> -->
                             <td><span id="span_CUSTCNTCTELF"></span></td>
                           </tr>
                         </table>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Ext No.(1)</th>
                      <td>
                        <!-- <input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p readonly" readonly /> -->
                        <span id="custCntcExt" name="custCntcExt"></span>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Email(1)</th>
                      <td>
                        <input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly style="display:none"/>
                        <table id="pCntcEmail" style="display:none">
                          <tr>
                             <!-- <td width="3%">
                               <a href="#" class="search_btn" id="imgHover_CNTCEMAIL">
                                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                               </a>
                             </td> -->
                             <td><span id="span_CNTCEMAIL"></span></td>
                           </tr>
                         </table>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- table end -->
              </section>

              <aside class="title_line">
                <!-- title_line start -->
                <h3>Installation Address &amp; Information</h3>
              </aside>
              <!-- title_line end -->

              <ul class="right_btns mb10">
                <li><p class="btn_grid">
                    <a id="btnSelInstAddr" href="#">Select Existing Address</a>
                  </p></li>
                <li><p class="btn_grid">
                    <a id="btnNewInstAddr" href="#">Add New Address</a>
                  </p></li>
              </ul>

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">Address Line 1<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly style="display:none"/>
                      <table id="pInstAddrDtl" style="display:none">
                          <tr>
                             <!-- <td width="3%">
                               <a href="#" class="search_btn" id="imgHover_INSTADDRDTL">
                                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                               </a>
                             </td> -->
                             <td><span id="span_INSTADDRDTL"></span></td>
                           </tr>
                         </table>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Address Line 2<span class="must">*</span></th>
                    <td colspan="3">
                      <!-- <input id="instStreet" name="instStreet" type="text" title="" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p readonly" readonly /> -->
                      <span id="instStreet" name="instStreet"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Area | Daerah<span class="must">*</span></th>
                    <td colspan="3">
                      <!-- <input id="instArea" name="instArea" type="text" title="" placeholder="eg. TAMAN RIMBA" class="w100p readonly" readonly /> -->
                      <span id="instArea" name="instArea"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">City | Bandar<span class="must">*</span></th>
                    <td colspan="3">
                      <!-- <input id="instCity" name="instCity" type="text" title="" placeholder="eg. KOTA KINABALU" class="w100p readonly" readonly /> -->
                      <span id="instCity" name="instCity"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">PostCode | Poskod<span class="must">*</span></th>
                    <td colspan="3">
                      <!-- <input id="instPostCode" name="instPostCode" type="text" title="" placeholder="eg. 88450" class="w100p readonly" readonly /> -->
                      <span id="instPostCode" name="instPostCode"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">State | Negeri<span class="must">*</span></th>
                    <td colspan="3">
                      <!-- <input id="instState" name="instState" type="text" title="" placeholder="eg. SABAH" class="w100p readonly" readonly /> -->
                      <span id="instState" name="instState"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Country | Negara<span class="must">*</span></th>
                    <td colspan="3">
                      <!-- <input id="instCountry" name="instCountry" type="text" title="" placeholder="eg. MALAYSIA" class="w100p readonly" readonly /> -->
                      <span id="instCountry" name="instCountry"></span>
                    </td>
                  </tr>

                </tbody>
              </table>
              <!-- table end -->

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">DSC Branch<span class="must">*</span></th>
                    <td colspan="3">
                      <select id="dscBrnchId" name="dscBrnchId" class="w100p" disabled></select>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Posting Branch<span class="must">*</span></th>
                    <td colspan="3">
                      <select id="keyinBrnchId" name="keyinBrnchId" class="w100p" disabled></select>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Prefer Install Date<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Install Date (dd/MM/yyyy)" class="j_date w100p" value="${nextDay}" disabled />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Prefer Install Time<span class="must">*</span></th>
                    <td colspan="3">
                      <div class="time_picker">
                        <!-- time_picker start -->
                        <input id="prefInstTm" name="prefInstTm" type="text" title="" placeholder="Prefer Install Time (hh:mi tt)" class="time_date w100p" value="11:00 AM" disabled />
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
                </tbody>
              </table>
              <!-- table end -->
            </form>
          </section>
          <!-- search_table end -->

        </article>
        <!-- tap_area end -->
        <article class="tap_area">
          <!-- tap_area start -->
          <section class="search_table">
            <!-- search_table start -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3>Order information</h3>
            </aside>
            <!-- title_line end -->
            <table class="type1">
              <!-- table start -->
              <caption>table</caption>
              <colgroup>
                <col style="width: 40%" />
                <col style="width: *" />
                <!--
                  <col style="width:220px" />
                  <col style="width:*" />
                -->
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row">Ex-Trade/Related No/Jom Tukar/PWP</th>
                  <td>
                    <p>
                      <select id="exTrade" name="exTrade" class="w100p"></select>
                    </p>
                    <!-- For Extrade and ICare [S]-->
                    <a id="btnRltdNoEKeyIn" href="#" class="search_btn blind">
                      <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                    </a>
                    <p>
                      <input id="relatedNo" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly />
                    </p>
                        <a id="isReturnExtradeChkBoxEkeyIn">
                      <input id="isReturnExtrade" name="isReturnExtrade" type="checkbox" disabled /> Return ex-trade product</a>
                      <!-- For Extrade and ICare [E] -->

                      <!-- For PWP [S]-->
				      <a id="btnPwpNoEkeyIn" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
				      <p><input id="pwpNo" name="pwpNo" type="text" title="" placeholder="PWP Number" class="w100p readonly blind" readonly /></p>
				      <input id="txtMainPwpOrderID" name="txtMainPwpOrderID" type="hidden" />
				      <!-- For PWP [E]-->
                      <input id="hiddenMonthExpired" name="hiddenMonthExpired" type="hidden" />
                      <input id="hiddenPreBook" name="hiddenPreBook" type="hidden" />
                  </td>
                </tr>
                <tr>
                  <th scope="row">Voucher Type<span class="must">*</span></th>
                  <td>
                    <p>
                      <select id="voucherType" name="voucherType" onchange="displayVoucherSection()" class="w100p"></select>
                    </p>
                    <p class="voucherSection">
                      <input id="voucherCode" name="voucherCode" type="text" title="Voucher Code" placeholder="Voucher Code" class="w100p" />
                    </p>
                    <p class="voucherSection">
                      <input id="voucherEmail" name="voucherEmail" type="text" title="Voucher Email" placeholder="Voucher Email" class="w100p" />
                    </p>
                    <p style="width: 70px;" class="voucherSection btn_grid">
                      <a id="btnVoucherApply" href="#" onclick="javascript:applyVoucher()">Apply</a>
                    </p>
                    <p style="display: none; color: red; font-size: 10px;" id="voucherMsg"></p>
                  </td>
                </tr>
                <tr>
                  <th scope="row">Application Type | Jenis Permohonan<span class="must">*</span></th>
                  <td>
                    <p>
                      <select id="appType" name="appType" class="w100p"></select>
                    </p>
                    <p>
                      <select id="srvPacId" name="srvPacId" class="w100p"></select>
                    </p>
                  </td>
                </tr>
                <tr>
                  <th scope="row">Product | Produk<span class="must">*</span></th>
                  <td>
                    <select id="ordProudct" name="ordProudct" class="w100p" disabled></select>
                  </td>
                </tr>
                <tr id='trCpntId' style='visibility: collapse'>
                  <th scope="row"><spring:message code="sal.title.text.cpntId" /> | Komponen Tambahan <span class="must">*</span></th>
                  <td>
                    <select id="compType" name="compType" class="w100p" onchange="fn_reloadPromo()"></select>
                  </td>
                </tr>
                <tr>
                  <th scope="row">Promotion | Promosi<span class="must">*</span></th>
                  <td>
                    <select id="ordPromo" name="ordPromo" class="w100p" disabled></select>
                    <input id="txtOldOrderID" name="txtOldOrderID" type="hidden" />
                  </td>
                </tr>
                <tr>
                <th scope="row"><spring:message code='sales.srvType'/><span class="must">*</span></th>
                <td>
                <input id="preSrvTypeHS" name="preSrvType" type="radio" value="HS" /><span><spring:message code='sales.text.heartService'/></span>
                <input id="preSrvTypeSS" name="preSrvType" type="radio" value="SS" /><span><spring:message code='sales.text.selfService'/></span>
                </td>
                </tr>
                <tr>
                <th></th>
                <td><label id="preSrvTypeLbl"></label></td>
                </tr>
                <tr>
                  <th scope="row">Installment Duration<span class="must">*</span></th>
                  <td>
                    <input id="installDur" name="installDur" type="text" title="" placeholder="Installment Duration (1-36)" class="w100p readonly" readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row">Price / RPF (RM)</th>
                  <td>
                    <input id="ordPrice" name="ordPrice" type="text" title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly />
                    <input id="ordPriceId" name="ordPriceId" type="hidden" />
                    <input id="normalOrdPrice" name="normalOrdPrice" type="hidden" />
                    <input id="normalOrdPv" name="normalOrdPv" type="hidden" />
                  </td>
                </tr>
                <tr>
                  <th scope="row">Rental Fee</th>
                  <td>
                    <input id="ordRentalFees" name="ordRentalFees" type="text" title="" placeholder="" class="w100p readonly" readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row">PV<span class="must">*</span></th>
                  <td>
                    <input id="ordPv" name="ordPv" type="text" title="" placeholder="Point Value (PV)" class="w100p readonly" readonly />
                    <input id="ordPvGST" name="ordPvGST" type="hidden" />
                  </td>
                </tr>
                <tr>
                  <th scope="row">Advance Rental Payment*</th>
                  <td>
                    <span>Does customer make advance rental payment for 12 months and above?</sapn>
                    <input id="advPayYes" name="advPay" type="radio" value="1" /><span>Yes</span>
                     <input id="advPayNo" name="advPay" type="radio" value="0" /><span>No</span>
                   </td>
                  <!--
                    <th scope="row">Normal Rental Fee<span class="must">*</span></th>
                    <td>
                      <p>
                        <input id="normalOrdRentalFees" name="normalOrdRentalFees" type="text" title="" placeholder="Rental Fees (Monthly)" class="w100p readonly" readonly />
                      </p>
                      <p id="pBtnCal" class="btn_sky blind"><a id="btnCal" href="#">Exclude GST Calc</a></p>
                    </td>
                  -->
                </tr>
                <tr>
                  <th scope="row">PO No</th>
                  <td>
                    <input id="poNo" name="poNo" type="text" title="" placeholder="" class="w100p" />
                  </td>
                </tr>
                <!--
                  <tr>
                    <th scope="row">SOF No<span class="must">*</span></th>
                    <td>
                      <input id="refereNo" name="refereNo" type="text" title="" placeholder="" class="w100p readonly" readonly/>
                    </td>
                  </tr>
                -->
                <tr>
                  <th scope="row">Salesman Code / Name<span class="must">*</span></th>
                  <td>
                    <input id="salesmanCd" name="salesmanCd" type="text" style="width: 115px;" title="" placeholder="" class="" />
                    <a id="memBtn" href="#" class="search_btn">
                      <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                    </a>
                    <p>
                      <input id="salesmanNm" name="salesmanNm" type="text" class="w100p readyonly" title="" placeholder="Salesman Name" disabled />
                    </p>
                  </td>
                </tr>
                <tr>
                  <th scope="row">Special Instruction</th>
                  <td>
                    <textarea id="speclInstct" name="speclInstct" cols="20" rows="5"></textarea>
                  </td>
                </tr>
                <tr style="display: none;">
                  <th scope="row">Discount Type / Period (month)</th>
                  <td>
                    <p>
                      <select id="promoDiscPeriodTp" name="promoDiscPeriodTp"  class="w100p" disabled></select>
                    </p>
                    <p>
                      <input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder="" style="width: 42px;" class="readonly" readonly />
                    </p>
                  </td>
                </tr>
                <tr style="display: none;">
                  <th scope="row">SST Type<span class="must">*</span></th>
                  <td>
                    <select id="corpCustType" name="corpCustType" class="w50p" disabled></select>
                </tr>
                <tr style="display: none;">
                  <th scope="row">Agreement Type<span class="must">*</span></th>
                  <td>
                    <select id="agreementType" name="agreementType" class="w50p" disabled></select>
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- table end -->

            <!--
              <aside class="title_line">title_line start
                <h3>Free Gift Information</h3>
              </aside>title_line end

              <article class="grid_wrap">grid_wrap start
                <div id="pop_list_gift_grid_wrap" style="width:100%; height:100px; margin:0 auto;"></div>
              </article>grid_wrap end -->

            <br>
            <br>
            <br>
            <br>
            <br>

          </section>
          <!-- search_table end -->
        </article>
        <!-- tap_area end -->
        <article class="tap_area">
          <!-- tap_area start -->
          <section id="scPayInfo" class="search_table blind">
            <!-- search_table start -->
            <table class="type1 mb1m">
              <!-- table start -->
              <caption>table</caption>
              <colgroup>
                <col style="width: 40%" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row">Pay By Third Party</th>
                  <td colspan="3"><label><input id="thrdParty"
                      name="thrdParty" type="checkbox" value="1" /><span></span></label></td>
                </tr>
              </tbody>
            </table>
            <!-- table end -->

            <section id="sctThrdParty" class="blind">
              <aside class="title_line">
                <!-- title_line start -->
                <h3>Third Party</h3>
              </aside>
              <!-- title_line end -->
              <ul class="right_btns mb10">
                <li><p class="btn_grid">
                    <a id="thrdPartyAddCustBtn" href="#">Add New Third Party</a>
                  </p></li>
              </ul>

              <!------------------------------------------------------------------------------
                Third Party - Form ID(thrdPartyForm)
              ------------------------------------------------------------------------------->
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
                    <th scope="row">Customer ID<span class="must">*</span></th>
                    <td>
                      <input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="Third Party ID" class="" />
                      <a href="#" class="search_btn" id="thrdPartyBtn">
                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                      </a>
                      <input id="hiddenThrdPartyId" name="hiddenThrdPartyId" type="hidden" title="" placeholder="Third Party ID" class="" />
                    </td>
                    <th scope="row">Type</th>
                    <td>
                      <input id="thrdPartyType" name="thrdPartyType"  type="text" title="" placeholder="Customer Type" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Name</th>
                    <td>
                      <input id="thrdPartyName" name="thrdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly />
                    </td>
                    <th scope="row">NRIC/Company No</th>
                    <td>
                      <input id="thrdPartyNric" name="thrdPartyNric" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly />
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
            </section>

            <!------------------------------------------------------------------------------
              Rental Paymode - Form ID(rentPayModeForm)
            ------------------------------------------------------------------------------->
            <section id="sctRentPayMode">
              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th><spring:message code="sal.text.rentalPaymode2" /><span class="must">*</span></th>
                    <td scope="row">
                      <select id="rentPayMode" name="rentPayMode" class="w100p"></select>
                    </td>
                    <!--
                      <th scope="row">NRIC on DD/Passbook</th>
                      <td>
                        <input id="rentPayIC" name="rentPayIC" type="text" title="" placeholder="NRIC appear on DD/Passbook" class="w100p" />
                      </td>
                     -->
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
            </section>

            <section id="sctCrCard" class="blind">
              <aside class="title_line">
                <!-- title_line start -->
                <h3>Bank Card</h3>
              </aside>
              <!-- title_line end -->
              <ul class="right_btns mb10">
                <li><p class="btn_grid">
                    <a id="selCreditCardBtn" href="#">Select Another Credit Card</a>
                  </p></li>
                <li><p class="btn_grid">
                    <a id="addCreditCardBtn" href="#">Add New Credit Card</a>
                  </p></li>
              </ul>
              <!------------------------------------------------------------------------------
                Credit Card - Form ID(crcForm)
              ------------------------------------------------------------------------------->
              <table class="type1 mb1m">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.creditCardNo2" /></th>
                    <td>
                      <input id="rentPayCRCNo" name="rentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly />
                      <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" />
                      <input id="hiddenRentPayEncryptCRCNoId" name="hiddenRentPayEncryptCRCNoId" type="hidden" />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.type2" /></th>
                    <td>
                      <input id="rentPayCRCType" name="rentPayCRCType" type="text" title="" placeholder="Credit Card Type"  class="w100p readonly" readonly />
                     </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.nameOnCard2" /></th>
                    <td>
                      <input id="rentPayCRCName" name="rentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.expiryDate2" /></th>
                    <td>
                      <input id="rentPayCRCExpiry" name="rentPayCRCExpiry" type="text" title="" placeholder="Credit Card Expiry" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.issueBank2" /></th>
                    <td>
                      <input id="rentPayCRCBank" name="rentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly />
                      <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" title="" class="w100p" />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.cardType2" /></th>
                    <td>
                      <input id="rentPayCRCCardType" name="rentPayCRCCardType" type="text" title="" placeholder="Card Type" class="w100p readonly" readonly />
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
              <!--
                <ul class="center_btns">
                  <li>
                    <p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p>
                  </li>
                </ul>
               -->
            </section>

            <section id="sctDirectDebit" class="blind">
              <aside class="title_line">
                <!-- title_line start -->
                <h3>Direct Debit</h3>
              </aside>
              <!-- title_line end -->
              <ul class="right_btns mb10">
                <li>
                  <p class="btn_grid">
                    <a id="btnSelBankAccount" href="#">Select Another Bank Account</a>
                  </p>
                </li>
                <li>
                  <p class="btn_grid">
                    <a id="btnAddBankAccount" href="#">Add New Bank Account</a>
                  </p>
                </li>
              </ul>
              <!------------------------------------------------------------------------------
                Direct Debit - Form ID(ddForm)
               ------------------------------------------------------------------------------->

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
                    <th scope="row">Account Number<span class="must">*</span></th>
                    <td>
                      <input id="rentPayBankAccNo" name="rentPayBankAccNo" type="text" title="" placeholder="Account Number readonly" class="w100p readonly" readonly />
                      <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" />
                    </td>
                    <th scope="row">Account Type</th>
                    <td>
                      <input id="rentPayBankAccType" name="rentPayBankAccType" type="text" title="" placeholder="Account Type readonly" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Account Holder</th>
                    <td>
                      <input id="accName" name="accName" type="text" title="" placeholder="Account Holder" class="w100p readonly" readonly />
                    </td>
                    <th scope="row">Issue Bank Branch</th>
                    <td>
                      <input id="accBranch" name="accBranch" type="text" title="" placeholder="Issue Bank Branch" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Issue Bank</th>
                    <td colspan=3>
                      <input id="accBank" name="accBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly />
                      <input id="hiddenAccBankId" name="hiddenAccBankId" type="hidden" />
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
            </section>
          </section>
          <!-- search_table end -->

          <!--****************************************************************************
             Billing Detail
          *****************************************************************************-->
          <section class="search_table">
            <!-- search_table start -->
            <!-- New Billing Group Type start -->
            <table class="type1" style="display: none">
              <!-- table start -->
              <caption>table</caption>
              <colgroup>
                <col style="width: 40%" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row">Group Option<span class="must">*</span></th>
                  <td>
                    <label>
                      <input type="radio" id="grpOpt1" name="grpOpt" value="new" /><span>New Billing Group</span>
                    </label>
                    <label>
                      <input type="radio" id="grpOpt2" name="grpOpt" value="exist" /><span>Existion Billing Group</span>
                    </label>
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- table end -->

            <!------------------------------------------------------------------------------
              Billing Method - Form ID(billMthdForm)
            ------------------------------------------------------------------------------->
            <section id="sctBillMthd" class="blind">
              <table class="type1 mb1m">
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
                    <th scope="row" rowspan="5">Billing Method<span class="must">*</span></th>
                    <td colspan="3">
                       <label>
                         <input id="billMthdPost" name="billMthdPost" type="checkbox" />
                         <span>Post</span>
                       </label>
                     </td>
                  </tr>
                  <tr>
                    <td colspan="3">
                      <label>
                        <input id="billMthdSms" name="billMthdSms" type="checkbox" /><span>SMS</span>
                      </label>
                      <label>
                        <input id="billMthdSms1" name="billMthdSms1" type="checkbox" disabled /><span>Mobile 1</span>
                      </label>
                      <label>
                        <input id="billMthdSms2" name="billMthdSms2" type="checkbox" disabled /><span>Mobile 2</span>
                      </label>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label>
                        <input id="billMthdEstm" name="billMthdEstm" type="checkbox" /><span>E-Billing</span>
                      </label>
                      <label>
                        <input id="billMthdEmail1" name="billMthdEmail1" type="checkbox" disabled /><span>Email 1</span>
                      </label>
                      <label>
                        <input id="billMthdEmail2" name="billMthdEmail2" type="checkbox" disabled /><span>Email 2</span>
                      </label>
                    </td>
                    <th scope="row">Email(1)<span id="spEmail1" class="must">*</span></th>
                    <td>
                      <input id="billMthdEmailTxt1" name="billMthdEmailTxt1" type="text" title="" placeholder="Email Address" class="w100p" disabled />
                    </td>
                  </tr>
                  <tr>
                    <td></td>
                    <th scope="row">Email(2)</th>
                    <td>
                      <input id="billMthdEmailTxt2" name="billMthdEmailTxt2" type="text" title="" placeholder="Email Address" class="w100p" disabled />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label>
                        <input id="billGrpWeb" name="billGrpWeb" type="checkbox" /><span>Web Portal</span>
                      </label>
                    </td>
                    <th scope="row">Web address(URL)</th>
                    <td>
                      <input id="billGrpWebUrl" name="billGrpWebUrl" type="text" title="" placeholder="Web Address" class="w100p" />
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
            </section>

            <!------------------------------------------------------------------------------
              Billing Address - Form ID(billAddrForm)
            ------------------------------------------------------------------------------->
            <section id="sctBillAddr" class="blind">
              <input id="hiddenBillAddId" name="custAddId" type="hidden" />
              <input id="hiddenBillStreetId" name="hiddenBillStreetId" type="hidden" />

              <aside class="title_line">
                <!-- title_line start -->
                <h3>Billing Address</h3>
              </aside>
              <!-- title_line end -->

              <ul class="right_btns mb10">
                <li>
                  <p class="btn_grid">
                    <a id="billSelAddrBtn" href="#">Select Another Address</a>
                  </p>
                </li>
                <li>
                  <p class="btn_grid">
                    <a id="billNewAddrBtn" href="#">Add New Address</a>
                  </p>
                </li>
              </ul>

              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">Address Detail<span class="must">*</span></th>
                    <td>
                      <input id="billAddrDtl" name="billAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly  style="display:none"/>
                      <table id="pBillAddrDtl" style="display:none">
                          <tr>
                             <!-- <td width="3%">
                               <a href="#" class="search_btn" id="imgHover_BILLADDRDTL">
                                 <img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" />
                               </a>
                             </td> -->
                             <td><span id="span_BILLADDRDTL"></span></td>
                           </tr>
                         </table>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Street</th>
                    <td>
                      <!-- <input id="billStreet" name="billStreet" type="text" title="" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p readonly" readonly /> -->
                      <span id="billStreet" name="billStreet"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Area<span class="must">*</span></th>
                    <td>
                      <!-- <input id="billArea" name="billArea" type="text" title="" placeholder="eg. TAMAN RIMBA" class="w100p readonly" readonly /> -->
                      <span id="billArea" name="billArea"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">City<span class="must">*</span></th>
                    <td>
                      <!-- <input id="billCity" name="billCity" type="text" title="" placeholder="eg. KOTA KINABALU"  class="w100p readonly" readonly />  -->
                      <span id="billCity" name="billCity"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">PostCode<span class="must">*</span></th>
                    <td>
                      <!-- <input id="billPostCode" name="billPostCode" type="text" title="" placeholder="eg. 88450" class="w100p readonly" readonly /> -->
                      <span id="billPostCode" name="billPostCode"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">State<span class="must">*</span></th>
                    <td>
                      <!-- <input id="billState" name="billState" type="text" title="" placeholder="eg. SABAH" class="w100p readonly" readonly /> -->
                      <span id="billState" name="billState"></span>
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Country<span class="must">*</span></th>
                    <td>
                      <!-- <input id="billCountry" name="billCountry" type="text" title="" placeholder="eg. MALAYSIA" class="w100p readonly" readonly /> -->
                      <span id="billCountry" name="billCountry"></span>
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
              <!-- Existing Type end -->
            </section>
            <br>

            <section id="sctBillPrefer" class="blind">
              <aside class="title_line">
                <!-- title_line start -->
                <h3>Billing Preference</h3>
              </aside>
              <!-- title_line end -->
              <ul class="right_btns mb10">
                <li class="blind">
                  <p class="btn_grid">
                    <a id="billPreferSelAddrBtn" href="#">Select Another Contact</a>
                  </p>
                </li>
                <li class="blind">
                  <p class="btn_grid">
                    <a id="billPreferAddAddrBtn" href="#">Add New Contact</a>
                  </p>
                </li>
              </ul>

              <!------------------------------------------------------------------------------
                Billing Preference - Form ID(billPreferForm)
              ------------------------------------------------------------------------------->
              <section class="search_table">
                <!-- search_table start -->
                <input id="hiddenBPCareId" name="hiddenBPCareId" type="hidden" />
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
                      <th scope="row">Initials<span class="must">*</span></th>
                      <td colspan="3">
                        <select id="billPreferInitial" name="billPreferInitial" class="w100p"></select>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Name<span class="must">*</span></th>
                      <td colspan="3">
                        <input id="billPreferName" name="billPreferName" type="text" title="" placeholder="Name" class="w100p" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel(Office)<span class="must">*</span></th>
                      <td>
                        <input id="billPreferTelO" name="billPreferTelO" type="text" title="" placeholder="Tel(Office)" class="w100p" readonly />
                      </td>
                      <th scope="row">Ext No.<span class="must">*</span></th>
                      <td>
                        <input id="billPreferExt" name="billPreferExt" type="text" title="" placeholder="Ext No." class="w100p" readonly />
                      </td>
                    </tr>
                  </tbody>
                </table>
                <!-- table end -->
              </section>
              <!-- search_table end -->
            </section>

            <!------------------------------------------------------------------------------
              Billing Group Selection - Form ID(billPreferForm)
             ------------------------------------------------------------------------------->
            <section id="sctBillSel" class="blind">
              <aside class="title_line">
                <!-- title_line start -->
                <h3>Billing Group Selection</h3>
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
                    <th scope="row">Billing Group<span class="must">*</span></th>
                    <td>
                      <input id="billGrp" name="billGrp" type="text" title="" placeholder="Billing Group" class="readonly" readonly />
                      <a id="billGrpBtn" href="#" class="search_btn">
                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                      </a>
                      <input id="hiddenBillGrpId" name="billGrpId" type="hidden" />
                    </td>
                    <th scope="row">Billing Type<span class="must">*</span></th>
                    <td>
                      <input id="billType" name="billType" type="text" title="" placeholder="Billing Type" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Billing Address</th>
                    <td colspan="3">
                      <textarea id="billAddr" name="billAddr" cols="20" rows="5" readonly></textarea>
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
                <!--
                  <tr>
                    <th scope="row">Remark</th>
                    <td><textarea id="billRem" name="billRem" cols="20" rows="5" readonly></textarea></td>
                  </tr>
                -->
              </tbody>
            </table>
            <!-- table end -->
            <!-- Existing Type end -->
          </section>
          <!-- search_table end -->
        </article>
        <!-- tap_area end -->

        <article class="tap_area">
          <!-- tap_area start -->
          <aside class="title_line">
            <!-- title_line start -->
            <h3>Attachment area</h3>
          </aside>
          <!-- title_line end -->

          <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
              <col style="width: 30%" />
              <col style="width: *" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row">Sales Order Form (SOF)<span class="must">*</span></th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="sofFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' />
                      <span class='label_text'><a href='#'>Upload</a></span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Sales Order Form's T&C (SOF T&C)</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="sofTncFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'>
                          <a href='#'>Upload</a></span> <span class='label_text'>
                          <a href='#' onclick='fn_removeFile("TNC")'>Remove</a></span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">NRIC & Bank Card<span class="must">*</span></th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="nricFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' /> <span class='label_text'>
                      <a href='#'>Upload</a></span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Payment document</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="payFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' /> <span class='label_text'>
                      <a href='#'>Upload</a></span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("PAY")'>Remove</a>
                      </span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Coway temporary receipt (TR)</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="trFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'>
                          <a href='#'>Upload</a></span> <span class='label_text'>
                          <a href='#' onclick='fn_removeFile("TRF")'>Remove</a>
                        </span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Declaration letter/Others form</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="otherFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'>
                          <a href='#'>Upload</a>
                        </span>
                        <span class='label_text'>
                          <a href='#' onclick='fn_removeFile("OTH")'>Remove</a>
                        </span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Declaration letter/Others form 2</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="otherFile2" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' />
                      <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH2")'>Remove</a>
                      </span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Mattress Sales Order Form (MSOF)</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="msofFile"
                      accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label> <input type='text' class='input_text'
                      readonly='readonly' /> <span class='label_text'><a
                        href='#'>Upload</a></span> <span class='label_text'><a
                        href='#' onclick='fn_removeFile("MSOF")'>Remove</a></span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Mattress Sales Order Form's T&C (MSOF T&C)</th>
                <td>
                  <div class="auto_file2">
                    <input type="file" title="file add" id="msofTncFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                    <label>
                      <input type='text' class='input_text' readonly='readonly' />
                      <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("MSOFTNC")'>Remove</a>
                      </span>
                    </label>
                  </div>
                </td>
              </tr>

              <tr>
                <td colspan=2>
                  <span class="red_text">** Only allow picture format (JPG, PNG, JPEG, PDF) less than 2 MB.
                  <br> File rename wording no more than 30 alphabet (including spacing, symbol).
                </span></td>
              </tr>
            </tbody>
          </table>
        </article>
        <!-- tap_area end -->
      </section>
      <!-- tap_wrap end -->

      <ul class="center_btns mt20">
        <li>
          <p class="btn_blue2 big">
            <a id="btnSave" href="#">Save</a>
          </p>
        </li>
      </ul>

    </section>
    <!------------------------------------------------------------------------------
      Pre-Order Regist Content END
    ------------------------------------------------------------------------------->
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
