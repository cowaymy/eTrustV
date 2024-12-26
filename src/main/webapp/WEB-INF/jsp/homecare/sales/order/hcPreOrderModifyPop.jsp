<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>
<script type="text/javaScript" language="javascript">

var TODAY_DD      = "${toDay}";
var BEFORE_DD = "${bfDay}";
var blockDtFrom = "${hsBlockDtFrom}";
var blockDtTo = "${hsBlockDtTo}";
var userType = '${SESSION_INFO.userTypeId}';
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
  var elecBillFileId = 0;

  var sofFileName = "";
  var nricFileName = "";
  var payFileName = "";
  var trFileName = "";
  var otherFileName = "";
  var otherFileName2 = "";
  var sofTncFileName = "";
  var msofFileName = "";
  var msofTncFileName = "";
  var elecBillFileName = "";

  var salesManType = "";

  var voucherAppliedStatus = 0;
  var voucherAppliedCode = "";
  var voucherAppliedEmail = "";
  var voucherPromotionId = [];

  var seda4PromotionId = []; //202410
  var countMatch = 0;

  var codeList_562 = [];
  codeList_562.push({codeId:"0", codeName:"No", code:"No"});
  <c:forEach var="obj" items="${codeList_562}">
  codeList_562.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  </c:forEach>

  $(document).ready(function() {
    createAUIGridStk();
    createAUIGridFailedRemark();
    fn_selectFailedRemarkList();

    doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '${preOrderInfo.appTypeId}', 'appType', 'S', ''); //Common Code
    doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '${preOrderInfo.rentPayModeId}', 'rentPayMode', 'S', ''); //Common Code
    //doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code
    //doGetComboSepa('/homecare/selectHomecareBranchList.do', '', ' - ', '', 'dscBrnchId', 'S', ''); //Branch Code
    doGetComboSepa ('/homecare/selectHomecareDscBranchList.do', '',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code
    doGetComboSepa('/common/selectBranchCodeList.do', '1', ' - ', '', 'keyinBrnchId', 'S', ''); //Branch Code
    doGetComboData('/common/selectCodeList.do', {
      groupCode : '325',
      notlike:'2'
    }, '${preOrderInfo.exTrade}', 'exTrade', 'S'); //EX-TRADE
    doGetComboOrder('/common/selectCodeList.do', '415', 'CODE_ID', '', 'corpCustType', 'S', ''); //Common Code
    doGetComboOrder('/common/selectCodeList.do', '416', 'CODE_ID', '', 'agreementType', 'S', ''); //Common Code
    doGetComboData('/common/selectCodeList.do', { groupCode : 609 , orderValue : 'CODE'}, '0', 'isStore', 'S', 'fn_loadStoreId');

    doDefCombo(codeList_562, '0', 'voucherType', 'S', 'displayVoucherSection');

    $("#tnbAccNoLbl").hide();
    $("#tnbAccNo").hide();
    Common.ajax("GET", "/homecare/sales/order/selectSeda4PromoList.do", null, function(result) {
        if(result.dataList.length > 0){
            seda4PromotionId = result.dataList;
        }
    });

    if('${preOrderInfo.voucherInfo}' != null && '${preOrderInfo.voucherInfo}' != ""){
    	$('#voucherCode').val('${preOrderInfo.voucherInfo.voucherCode}');
    	$('#voucherEmail').val('${preOrderInfo.voucherInfo.custEmail}');
    	$('#voucherType').val('${preOrderInfo.voucherInfo.platformId}');
	  	voucherAppliedStatus = 1;
    }

    if('${preOrderInfo.exTrade}' != null && '${preOrderInfo.exTrade}' != "" && '${preOrderInfo.exTrade}' == '4'){
    	$('#pwpNo').removeClass("blind");
//         $('#btnPwpNoEkeyIn').removeClass("blind");
        $('#isReturnExtradeChkBoxEkeyIn').addClass("blind");
        $('#relatedNo').addClass("blind");
        $('#btnRltdNoEKeyIn').addClass("blind");

    }else{
    	$('#pwpNo').addClass("blind");
        $('#btnPwpNoEkeyIn').addClass("blind");
        $('#isReturnExtradeChkBoxEkeyIn').removeClass("blind");
        $('#relatedNo').removeClass("blind");
        $('#btnRltdNoEKeyIn').removeClass("blind");
    }

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

    //Attach File
    //fn_loadPreOrderInfo('${preOrderInfo.custId}', null);

    if ('${preOrderInfo.stusId}' == 4 || '${preOrderInfo.stusId}' == 10) {
      $('#scPreOrdArea').find("input,textarea,button,select").attr("disabled", true);
      $("#scPreOrdArea").find("p.btn_grid").hide();
      $('#btnSave').hide();
      if(userType == 1 || userType == 2 || userType == 7 || '${pageAuth.funcUserDefine6}' != 'Y'){
      	$(".input_text").attr('disabled', true).addClass("readonly");
      }
      else{
      	$(".input_text").attr('disabled', false);
      }
    }

    if ('${preOrderInfo.atchFileGrpId}' != 0) {
      fn_loadAtchment('${preOrderInfo.atchFileGrpId}');
    }

    var vCustType = $("#hiddenTypeId").val();
    if (vCustType == '965' && '${preOrderInfo.appTypeId}') {
      $("#corpCustType").removeAttr("disabled");
      $("#agreementType").removeAttr("disabled");

    } else {
      $("#corpCustType").prop("disabled", true);
      $("#agreementType").prop("disabled", true);
    }
  });

  function createAUIGridStk() {
    //AUIGrid 칼럼 설정
    var columnLayoutGft = [
        {
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
        }];

    //그리드 속성 설정
    var listGridPros = {
      usePaging : true, //페이징 사용
      pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : false,
      softRemoveRowMode : false,
      headerHeight : 30,
      useGroupingPanel : false, //그룹핑 패널 사용
      skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
      noDataMessage : "No order found.",
      groupingMessage : "Here groupping"
    };
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

  function setupSaveButton() {
	  disableSaveButton()
	  $('#btnSave').click(function() {
	      var preOrdId = $('#frmPreOrdReg #hiddenPreOrdId').val();
	      var rcdTms = $('#hiddenRcdTms').val();

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

	      if (!fn_validRcdTms(preOrdId, rcdTms, '#popup_wrap')) {
	        $('#aTabBD').click();
	        return false;
	      }

	      if ($("#ordProduct1 option:selected").index() > 0 && $("#ordProduct2 option:selected").index() > 0) {
	        // product size check
	        Common.ajax("GET", "/homecare/sales/order/checkProductSize.do", {
	          product1 : $("#ordProduct1 option:selected").val(),
	          product2 : $("#ordProduct2 option:selected").val()
	        }, function(result) {
	          if (result.code != '00') {
	            $('#aTabOI').click();
	            Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>" + result.message + "</b>");
	            return false;

	          } else {
	        	  checkSalesPerson($('#salesmanCd').val(),$('#txtOldOrderID').val(),$('#relatedNo').val());
	          }
	        });
	      } else {
	    	  checkSalesPerson($('#salesmanCd').val(),$('#txtOldOrderID').val(),$('#relatedNo').val());
	      }
	    });
  }

  $(function() {
    $('#btnConfirm').click(function() {
      if (!fn_validConfirm())
        return false;
      if (fn_isExistESalesNo() == 'true')
        return false;

      $('#scPreOrdArea').removeClass("blind");
      $('#refereNo').val($('#sofNo').val().trim())

      fn_loadCustomer(null, $('#nric').val());
    });

    $('#nric').keydown(function(event) {
      if (event.which === 13) {
        if (!fn_validConfirm())
          return false;
        if (fn_isExistESalesNo() == 'true')
          return false;

        $('#refereNo').val($('#sofNo').val().trim())

        fn_loadCustomer(null, $('#nric').val());
      }
    });

    $('#sofNo').keydown(function(event) {
      if (event.which === 13) {
        if (!fn_validConfirm())
          return false;
        if (fn_isExistESalesNo() == 'true')
          return false;

        $('#refereNo').val($('#sofNo').val().trim())

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

    $('#srvPacId,#appType').click(function() {
        //CHECK IF EXISTING ORDER IS PWP AND CHANGE APP TYPE IS NOT ALLOW
       if('${preOrderInfo.exTrade}' == '4'){
           Common.alert('App Type is disallowed to change due to it is PWP.');
       }
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

      var idx = $("#appType option:selected").index();
      var selVal = $("#appType").val();

      if (idx > 0) {
        if (FormUtil.isEmpty($('#hiddenCustId').val())) {
          $('#appType').val('');
          Common.alert('<b>Please select customer first.</b>');

          $('#aTabCS').click();

        } else {
          switch (selVal) {
          case '66': //RENTAL
            $('#scPayInfo').removeClass("blind");
            //?FD문서에서 아래 항목 빠짐
            $('[name="advPay"]').removeAttr("disabled");
            $('#installDur').val('').prop("readonly", true).addClass("readonly");
            appSubType = '367';

            var vCustType = $("#hiddenTypeId").val();
            if (vCustType == '965') {
              $("#corpCustType").removeAttr("disabled");
              $("#agreementType").removeAttr("disabled");

            } else {
              $("#corpCustType").prop("disabled", true);
              $("#agreementType").prop("disabled", true);
            }

            break;

          case '67': //OUTRIGHT
            appSubType = '368';
            break;

          case '68': //INSTALLMENT
            $('#installDur').removeAttr("readonly").removeClass("readonly");
            appSubType = '369';

            break;

          case '1412': //Outright Plus
            $('#installDur').val("36").prop("readonly", true).removeClass("readonly");
            $('[name="advPay"]').removeAttr("disabled");
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
            $('#installDur').val('').prop("readonly", true).addClass("readonly");
            break;
          }

          var pType = selVal == '66' ? '1' : '2';
          doGetComboData('/sales/order/selectServicePackageList.do', {
            appSubType : appSubType,
            pType : pType
          }, '', 'srvPacId', 'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE

//           $('#ordProduct1').removeAttr("disabled");
//           $('#ordProduct2').removeAttr("disabled");
        }
      } else {
        $('#srvPacId option').remove();
        $('#ordProduct1').prop("disabled", true);
        $('#ordProduct2').prop("disabled", true);
      }

      $('#ordProduct1 option').remove();
      $('#ordProduct1 optgroup').remove();
      $('#ordProduct2 option').remove();
      $('#ordProduct2 optgroup').remove();

      // Promostion setting
      $('#ordPromo1 option').remove();
      $('#ordPromo1').prop("disabled", true);
      $('#ordPromo2 option').remove();
      $('#ordPromo2').prop("disabled", true);
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

    $('#rentPayMode').change(function() {
      var rentPayModeIdx = $("#rentPayMode option:selected").index();
      var rentPayModeVal = $("#rentPayMode").val();

      if (rentPayModeIdx > 0) {
        if (rentPayModeVal == '133' || rentPayModeVal == '134') {
          Common.alert('<b>Currently we are not provide [' + rentPayModeVal + '] service.</b>');
          fn_clearRentPayMode();

        } else {
          if (rentPayModeVal == '131') {
            if ($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
              Common.alert('<b>Please select the third party first.</b>');

            } else {
              $('#sctCrCard').removeClass("blind");
            }

          } else if (rentPayModeVal == '132') {
            if ($('#thrdParty').is(":checked") && FormUtil.isEmpty($('#hiddenThrdPartyId').val())) {
              Common.alert('<b>Please select the third party first.</b>');

            } else {
              $('#sctDirectDebit').removeClass("blind");
            }
          }
        }
      }
    });

    $('#srvPacId').change(function() {
      $('#ordProduct1 option').remove();
      $('#ordProduct1 optgroup').remove();
      $('#ordProduct2 option').remove();
      $('#ordProduct2 optgroup').remove();

      $('#ordPromo1 option').remove();
      $('#ordPromo1').prop("disabled", true);
      $('#ordPromo2 option').remove();
      $('#ordPromo2').prop("disabled", true);

      $('#ordProduct1, #ordProduct2').change();

      var idx = $("#srvPacId option:selected").index();
      var selVal = $("#srvPacId").val();

      if (idx > 0) {
        $('#ordProduct1').removeAttr("disabled");
        $('#ordProduct2').removeAttr("disabled");

        // product comboBox 생성
        fn_setProductCombo();

      } else {
        $('#ordProduct1').prop("disabled", true);
        $('#ordProduct2').prop("disabled", true);
      }
    });

    $('#ordProduct1, #ordProduct2').change(function(event) {
      disableSaveButton()
      var _tagObj = $(event.target);
      var _tagId = _tagObj.attr('id');
      var _tagNum = _tagId.replace(/[^0-9]/g, "");

      if (FormUtil.checkReqValue($('#exTrade'))) {
        Common.alert("Save Sales Order Summary" + DEFAULT_DELIMITER + "<b>* Please select an Ex-Trade.</b>");
        $('#ordProduct' + _tagId).val('');
        return;
      }

      $('#ordPromo' + _tagNum + ' option').remove();
      // 필드 초기화.
      var dataList = $('[data-ref="' + _tagId + '"]');
      for (var i = 0; i < dataList.length; ++i) {
        $('#' + $(dataList[i]).attr('id')).val('');
      }

      if (FormUtil.isEmpty(_tagObj.val())) {
        totSumPrice(); // 합계
        return;
      }
      $('#ordPrice' + _tagNum).addClass("readonly");
      $('#ordPv' + _tagNum).addClass("readonly");
      $('#ordRentalFees' + _tagNum).addClass("readonly");

      AUIGrid.clearGridData(listGiftGridID);

      var appTypeIdx = $("#appType option:selected").index();
      var appTypeVal = $("#appType").val();
      var custTypeVal = $("#hiddenTypeId").val();
      var stkIdx = $("#ordProduct" + _tagNum + " option:selected").index();
      var stkIdVal = $("#ordProduct" + _tagNum).val();
      var empChk = 0;
      var exTrade = $("#exTrade").val();
      var srvPacId = appTypeVal == '66' ? $('#srvPacId').val() : 0;

	  Common.ajaxSync("GET", "/homecare/checkIfIsAcInstallationProductCategoryCode.do", {stkId: stkIdVal}, function(result) {
          if(result != null)
          {
        	var custAddId =	$('#hiddenCustAddId').val()
          	if(result.data == 1){
                fn_loadInstallAddrForDiffBranch(custAddId,'N','Y');
          	}
          	else{
				fn_loadInstallAddrForDiffBranch(custAddId,'Y');
          	}
          }
      },  function(jqXHR, textStatus, errorThrown) {
          alert("Fail to check Air Conditioner. Please contact IT");
      });

      if (stkIdx > 0) {
        fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId, _tagNum);
        fn_loadProductPromotion(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade, _tagNum);
      }

      fn_loadProductComponent(stkIdVal, _tagNum);
      setTimeout(function() {
        fn_check(0, _tagNum)
      }, 200);
    });

    $('#ordPromo1, #ordPromo2').change(function(event) {
      disableSaveButton()
      AUIGrid.clearGridData(listGiftGridID);

      var _tagObj = $(event.target);
      var _tagId = _tagObj.attr('id');
      var _tagNum = _tagId.replace(/[^0-9]/g, "");

      var appTypeIdx = $("#appType option:selected").index();
      var appTypeVal = $("#appType").val();

      var stkIdIdx = $("#ordProduct" + _tagNum + " option:selected").index();
      var stkIdVal = $("#ordProduct" + _tagNum).val();
      var promoIdIdx = $("#ordPromo" + _tagNum + " option:selected").index();
      var promoIdVal = $("#ordPromo" + _tagNum).val();

      if(_tagNum == 1){
          countMatch = 0;
          for( i = 0 ; i < seda4PromotionId.length ; i ++){
              if(seda4PromotionId[i].code == $("#ordPromo"+_tagNum).val() ){
                  countMatch = countMatch + 1;
              }
          }
          if(countMatch > 0){
              $("#tnbAccNoLbl").show();
              $("#tnbAccNo").val('');
              $("#tnbAccNo").show();
          }else{
              $("#tnbAccNoLbl").hide();
              $("#tnbAccNo").val('');
              $("#tnbAccNo").hide();
          }
      }

      var srvPacId = (appTypeVal == '66') ? $('#srvPacId').val() : 0;

      if (promoIdIdx > 0 && promoIdVal != '0') {
        fn_loadPromotionPrice(promoIdVal, stkIdVal, srvPacId, _tagNum);
        console.log('yow');
        console.log(srvPacId);
        fn_selectPromotionFreeGiftListForList2(promoIdVal);
      } else {
        fn_loadProductPrice(appTypeVal, stkIdVal, srvPacId, _tagNum);
      }
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

    $('#memBtn').click(function() {
      Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });

    $('[name="grpOpt"]').click(function() {
      fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
    });

    setupSaveButton()

    $('#addCreditCardBtn').click(function() {
      var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
      var vCustNric = $('#thrdParty').is(":checked") ? "" : $('#nric').val();

      Common.popupDiv("/sales/customer/customerCreditCardeSalesAddPop.do", {
        custId : vCustId,
        callPrgm : "PRE_ORD",
        nric : vCustNric
      }, null, true);
    });

    $('#selCreditCardBtn').click(function() {
      var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
      Common.popupDiv("/sales/customer/customerCreditCardSearchPop.do", {
        custId : vCustId,
        callPrgm : "PRE_ORD"
      }, null, true);
    });

    //Payment Channel - Add New Bank Account
    $('#btnAddBankAccount').click(function() {
      var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
      Common.popupDiv("/sales/customer/customerBankAccountAddPop.do", {
        custId : vCustId,
        callPrgm : "PRE_ORD"
      }, null, true);
    });

    //Payment Channel - Select Another Bank Account
    $('#btnSelBankAccount').click(function() {
      var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
      Common.popupDiv("/sales/customer/customerBankAccountSearchPop.do", {
        custId : vCustId,
        callPrgm : "PRE_ORD"
      });
    });

    $('#sofFile').change(function(evt) {
      var file = evt.target.files[0];
      if (file.name != sofFileName) {
        myFileCaches[1] = {
          file : file
        };
        if (sofFileName != "") {
          update.push(sofFileId);
        }
      }
    });

    $('#nricFile').change(function(evt) {
      var file = evt.target.files[0];
      if (file.name != nricFileName) {
        myFileCaches[2] = {
          file : file
        };
        if (nricFileName != "") {
          update.push(nricFileId);
        }
      }
    });

    $('#payFile').change(function(evt) {
      var file = evt.target.files[0];
      if (file == null) {
        remove.push(payFileId);
      } else if (file.name != payFileName) {
        myFileCaches[3] = {
          file : file
        };
        if (payFileName != "") {
          update.push(payFileId);
        }
      }
    });

    $('#trFile').change(function(evt) {
      var file = evt.target.files[0];

      if (file == null) {
        remove.push(trFileId);
      } else if (file.name != trFileName) {
        myFileCaches[4] = {
          file : file
        };
        if (trFileName != "") {
          update.push(trFileId);
        }
      }
    });

    $('#otherFile').change(function(evt) {
      var file = evt.target.files[0];
      if (file == null) {
        remove.push(otherFileId);
      } else if (file.name != otherFileName) {
        myFileCaches[5] = {
          file : file
        };
        if (otherFileName != "") {
          update.push(otherFileId);
        }
      }
    });

    $('#otherFile2').change(function(evt) {
      var file = evt.target.files[0];
      if (file == null) {
        remove.push(otherFileId2);
      } else if (file.name != otherFileName2) {
        myFileCaches[6] = {
          file : file
        };
        if (otherFileName2 != "") {
          update.push(otherFileId2);
        }
      }
    });

    $('#sofTncFile').change(function(evt) {
      var file = evt.target.files[0];
      if (file == null) {
        remove.push(sofTncFileId);
      } else if (file.name != sofTncFileName) {
        myFileCaches[7] = {
          file : file
        };
        if (sofTncFileName != "") {
          update.push(sofTncFileId);
        }
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
    });

    $('#elecBillFile').change(function(evt) {
        var file = evt.target.files[0];
        if(file == null){
            remove.push(elecBillFileId);
        }else if(file.name != elecBillFileName){
            myFileCaches[10] = {file:file};
            if(elecBillFileName != ""){
                update.push(elecBillFileId);
            }
        }
    });

  });

  $('#exTrade').change(function() {

	  $('#ordPromo1 option').remove();
      $('#ordPromo2 option').remove();
      fn_clearAddCpnt();
      $('#relatedNo').val("");

      $('#isReturnExtradeChkBoxEkeyIn').removeClass("blind");
      $('#relatedNo').removeClass("blind");
      $('#pwpNo').val("");
      $('#txtMainPwpOrderID').val("");
      $('#pwpNo').addClass("blind");
      $('#btnPwpNoEkeyIn').addClass("blind");

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

         }else if ($("#exTrade").val() == '4'){
             $('#txtOldOrderID').val('');
             $('#txtBusType').val('');
             $('#relatedNo').val('');
             $('#hiddenMonthExpired').val('');
             $('#hiddenPreBook').val('');
             $('#btnRltdNoEKeyIn').addClass("blind");

             $('#pwpNo').removeClass("blind");
//              $('#btnPwpNoEkeyIn').removeClass("blind");
             $('#isReturnExtradeChkBoxEkeyIn').addClass("blind");
             $('#relatedNo').addClass("blind");

         }else {
             //$('#relatedNo').val('').prop("readonly", true).addClass("readonly");
             $('#relatedNo').val('');
             //$('#txtOldOrderID').val('');
             $('#hiddenMonthExpired').val('');
      	     $('#hiddenPreBook').val('');
             $('#btnRltdNoEKeyIn').addClass("blind");
         }
         $('#isReturnExtrade').attr("disabled",true);
         //$('#ordProduct1').val('');
         //$('#ordProduct2').val('');
         $('#ordProduct1 option').remove();
         $('#ordProduct2 option').remove();
         $('#speclInstct').val('');
  });

  function fn_clearAddCpnt() {
      $('#compType option').remove();
    }

  function fn_loadBankAccountPop(bankAccId) {
    fn_clearRentPaySetDD();
    fn_loadBankAccount(bankAccId);

    $('#sctDirectDebit').removeClass("blind");

    if (!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $('#rentPayBankAccNo').val())) {
      fn_clearRentPaySetDD();
      $('#sctDirectDebit').removeClass("blind");
      Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER + "<b>Invalid account for auto debit.</b>");
    }
  }

  function fn_loadBankAccount(bankAccId) {
    Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {
      getparam : bankAccId
    }, function(rsltInfo) {

      if (rsltInfo != null) {
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
    Common.ajax("GET", "/sales/order/selectCustomerCreditCardDetailView.do", {
      getparam : custCrcId
    }, function(rsltInfo) {

      if (rsltInfo != null) {
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
            Common.alert('<b>Third party not found.<br />' + 'Your input third party ID : ' + custId + '</b>');
          }
        }
      });
    } else {
      Common.alert('<b>Third party and customer cannot be same person/company.<br />' + 'Your input third party ID : ' + custId + '</b>');
    }

    $('#sctThrdParty').removeClass("blind");
  }

  function fn_isExistESalesNo() {
    var isExist = false;
    var msg = "";

    Common.ajaxSync("GET", "/sales/order/selectExistSofNo.do", $("#frmCustSearch").serialize(), function(rsltInfo) {
      if (rsltInfo != null) {
        isExist = rsltInfo.isExist;
      }
    });

    if (isExist == 'true')
      Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* this Sales has posted, no amendment allow</b>");
    return isExist;
  }

  function fn_isExistMember() {
    var isExist = false;
    var msg = "";

    Common.ajaxSync("GET", "/sales/order/selectExistingMember.do", $("#frmCustSearch").serialize(), function(rsltInfo) {
      if (rsltInfo != null) {
        isExist = rsltInfo.isExist;
      }
    });

    if (isExist == 'true')
      Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* The member is our existing HP/Cody/Staff/CT.</b>");
    return isExist;
  }

  function fn_validPaymentInfo() {
    var isValid = true;
    var msg = "";

    var appTypeIdx = $("#appType option:selected").index();
    var appTypeVal = $("#appType").val();
    var rentPayModeIdx = $("#rentPayMode option:selected").index();
    var rentPayModeVal = $("#rentPayMode").val();
    var grpOptSelYN = (!$('#grpOpt1').is(":checked") && !$('#grpOpt2').is(":checked")) ? false : true;
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

          } else if (FormUtil.checkReqValue($('#hiddenRentPayCRCBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
            isValid = false;
            msg += "* Invalid credit card issue bank.<br>";
          }

        } else if (rentPayModeVal == '132') {
          if (FormUtil.checkReqValue($('#hiddenRentPayBankAccID'))) {
            isValid = false;
            msg += "* Please select a bank account.<br>";

          } else if (FormUtil.checkReqValue($('#hiddenAccBankId')) || $('#hiddenRentPayCRCBankId').val() == '0') {
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
          if (!$("#billMthdSms").is(":checked") && !$("#billMthdPost").is(":checked") && !$("#billMthdEstm").is(":checked")) {
            isValid = false;
            msg += "* Please select at least one billing method.<br>";

          } else {
            if ($("#typeId").val() == '965' && $("#billMthdSms").is(":checked")) {
              isValid = false;
              msg += "* SMS billing method is not allow for company type customer.<br>";
            }

            if ($("#billMthdEstm").is(":checked")) {
              if (FormUtil.checkReqValue($('#billMthdEmailTxt1'))) {
                isValid = false;
                msg += "* Please key in the email address.<br>";

              } else {
                if (FormUtil.checkEmail($('#billMthdEmailTxt1').val())) {
                  isValid = false;
                  msg += "* Invalid email address.<br>";
                }
              }

              if (!FormUtil.checkReqValue($('#billMthdEmailTxt2')) && FormUtil.checkEmail($('#billMthdEmailTxt2').val())) {
                isValid = false;
                msg += "* Invalid email address.<br>";
              }
            }
          }
        }
      }
    }

    if (!isValid)
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    return isValid;
  }

  function fn_validOrderInfo() {
    var isValid = true;
    var msg = "";

    var appTypeIdx = $("#appType option:selected").index();
    var appTypeVal = $("#appType").val();
    var custType = $("#hiddenTypeId").val();

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

      if (appTypeVal == '66') {
        if ($(':radio[name="advPay"]:checked').val() != '1' && $(':radio[name="advPay"]:checked').val() != '0') {
          isValid = false;
          msg += "* Please select advance rental payment.<br>";
        }
      }
    }

    if ($("#srvPacId option:selected").index() <= 0) {
        isValid = false;
        msg += "* Please select a package.<br>";
      }


    if ($("#ordProduct1 option:selected").index() <= 0 && $("#ordProduct2 option:selected").index() <= 0) {
      isValid = false;
      msg += "* Please select a product.<br>";
    }

    // 프레임만 주문 불가.
    if ($("#ordProduct1 option:selected").index() <= 0 && $("#ordProduct2 option:selected").index() > 0) {
      isValid = false;
      msg += '* Only frames can not be ordered.<br>';
    }

    // 기존주문에 프레임이 있는경우. 프레임 필수
    if (FormUtil.isNotEmpty($('#hiddenPreOrdId2').val()) && $("#ordProduct2 option:selected").index() <= 0) {
      isValid = false;
      msg += "* Please select a product.<br>";
    }

    if (appTypeVal == '66' || appTypeVal == '67' || appTypeVal == '68' || appTypeVal == '1412') {
      if ($("#ordProduct1 option:selected").index() > 0) {
        if ($("#ordPromo1 option:selected").index() <= 0) {
          isValid = false;
          msg += "* Please select the promotion code.<br>";
        }
      }
      if ($("#ordProduct2 option:selected").index() > 0) {
        if ($("#ordPromo2 option:selected").index() <= 0) {
          isValid = false;
          msg += "* Please select the promotion code.<br>";
        }
      }
    }

    if(exTrade == '1' || exTrade == '2') {
        if(FormUtil.checkReqValue($('#relatedNo'))) {
            isValid = false;
            msg += "* Please select old order no.<br>";
        }
    }else if(exTrade == '4') {
        if(FormUtil.checkReqValue($('#pwpNo'))) {
            isValid = false;
            msg += "* Please select main PWP order no.<br>";
        }
    }

    if ($('#isStore').val() == "") {
        isValid = false;
        msg += "* Please select whether the sales belong to the store (Yes or No).<br>";
    }

    if ($('#isStore').val() != "" && $('#isStore').val() > 0) {
        if ($('#cwStoreId').val() == "" || $('#cwStoreId').val() == 0) {
            isValid = false;
            msg += "* You have specified that the sales belong to the store. Please select a store from the list.<br>";
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

    if (FormUtil.checkReqValue($('#salesmanCd')) && FormUtil.checkReqValue($('#salesmanNm'))) {
      if (appTypeIdx > 0 && appTypeVal != 143) {
        isValid = false;
        msg += "* Please select a salesman.<br>";
      }
    }

    if(countMatch == 1){
        if($("#tnbAccNo").val() == undefined || $("#tnbAccNo").val() == ''){
            isValid = false;
            text = 'TNB Acc. No.';
            msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/><br>";
        }
    }

    if (!isValid)
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    return isValid;
  }

  function fn_validConfirm() {
    var isValid = true;
    var msg = "";

    if (FormUtil.checkReqValue($('#nric'))) {
      isValid = false;
      msg += "* Please key in NRIC/Company No.<br>";
    }

    if (FormUtil.checkReqValue($('#sofNo'))) {
      isValid = false;
      msg += "* Please key in SOF No.<br>";
    }

    if (!isValid)
      Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>" + msg + "</b>");
    return isValid;
  }

  function fn_validCustomer() {
    var isValid = true;
    var msg = "";

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
      msg += "* Please select the DT branch.<br>";
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
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_doSavePreOrder() {
    var formData = new FormData();

    formData.append("atchFileGrpId", '${preOrderInfo.atchFileGrpId}');
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

    $.each(myFileCaches, function(n, v) {
      formData.append(n, v.file);
    });

    //Save attachment first
    var vAppType = $('#appType').val();
    var vCustCRCID = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCId').val() : 0;
    var vCustAccID = $('#rentPayMode').val() == '132' ? $('#hiddenRentPayBankAccID').val() : 0;
    var vBankID = $('#rentPayMode').val() == '131' ? $('#hiddenRentPayCRCBankId').val() : $('#rentPayMode').val() == '132' ? $('#hiddenAccBankId').val() : 0;
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
      preOrdId1 : $('#frmPreOrdReg #hiddenPreOrdId1').val().trim(),
      preOrdId2 : $('#frmPreOrdReg #hiddenPreOrdId2').val().trim(),
      ordSeqNo : $('#frmPreOrdReg #hiddenOrdSeqNo').val().trim(),
      sofNo : $('#sofNo').val().trim(),
      custPoNo : $('#poNo').val().trim(),
      appTypeId : vAppType,
      srvPacId : $('#srvPacId').val(),
      custId : $('#hiddenCustId').val(),
      empChk : 0,
      gstChk : 0,
      atchFileGrpId : '${preOrderInfo.atchFileGrpId}',
      custCntcId : $('#hiddenCustCntcId').val(),
      keyinBrnchId : $('#keyinBrnchId').val(),
      instAddId : $('#hiddenCustAddId').val(),
      dscBrnchId : $('#dscBrnchId').val(),
      preDt : $('#prefInstDt').val().trim(),
      preTm : $('#prefInstTm').val().trim(),
      instct : $('#speclInstct').val().trim(),
      exTrade : $('#exTrade').val(),
      itmStkId1 : $('#ordProduct1').val(),
      itmCompId1 : $('#compType1').val(),
      promoId1 : $('#ordPromo1').val(),
      mthRentAmt1 : $('#ordRentalFees1').val().trim(),
      totAmt1 : $('#ordPrice1').val().trim(),
      norAmt1 : $('#normalOrdPrice1').val().trim(),
      discRntFee1 : $('#ordRentalFees1').val().trim(),
      totPv1 : $('#ordPv1').val().trim(),
      totPvGst1 : $('#ordPvGST1').val().trim(),
      prcId1 : $('#ordPriceId1').val(),
      itmStkId2 : $('#ordProduct2').val(),
      itmCompId2 : $('#compType2').val(),
      promoId2 : $('#ordPromo2').val(),
      mthRentAmt2 : $('#ordRentalFees2').val().trim(),
      totAmt2 : $('#ordPrice2').val().trim(),
      norAmt2 : $('#normalOrdPrice2').val().trim(),
      discRntFee2 : $('#ordRentalFees2').val().trim(),
      totPv2 : $('#ordPv2').val().trim(),
      totPvGst2 : $('#ordPvGST2').val().trim(),
      prcId2 : $('#ordPriceId2').val(),
      memCode : $('#salesmanCd').val(),
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
      custBillEmail : $('#billMthdEmailTxt1').val().trim(),
      custBillIsSms : $('#billMthdSms1').is(":checked") ? 1 : 0,
      custBillIsPost : $('#billMthdPost').is(":checked") ? 1 : 0,
      custBillEmailAdd : $('#billMthdEmailTxt2').val().trim(),
      custBillIsWebPortal : $('#billGrpWeb').is(":checked") ? 1 : 0,
      custBillWebPortalUrl : $('#billGrpWebUrl').val().trim(),
      custBillIsSms2 : $('#billMthdSms2').is(":checked") ? 1 : 0,
      custBillCustCareCntId : $("#hiddenBPCareId").val(),
      stusId : vStusId,
      corpCustType : $('#corpCustType').val(),
      agreementType : $('#agreementType').val(),
      rcdTms1 : $('#hiddenRcdTms1').val(),
      rcdTms2 : $('#hiddenRcdTms2').val(),
      salesOrdIdOld          : $('#txtOldOrderID').val(),
      relatedNo               : $('#relatedNo').val(),
      isExtradePR         : vIsReturnExtrade,
      receivingMarketingMsgStatus   : $('input:radio[name="marketingMessageSelection"]:checked').val(),
      voucherCode : voucherAppliedCode,
      pwpOrderId          : $('#txtMainPwpOrderID').val(),
      pwpOrderNo          : $('#pwpNo').val(),
      tnbAccNo : $("#tnbAccNo").val(),
      chnnl : '${preOrderInfo.chnnl}',
      cwStoreId          : $('#cwStoreId').val(),
    };

    var formData = new FormData();
    formData.append("atchFileGrpId", '${preOrderInfo.atchFileGrpId}');
    formData.append("update", JSON.stringify(update).replace(/[\[\]\"]/gi, ''));
    formData.append("remove", JSON.stringify(remove).replace(/[\[\]\"]/gi, ''));

    $.each(myFileCaches, function(n, v) {
      formData.append(n, v.file);
    });

    Common.ajaxFile("/sales/order/attachFileUpdate.do", formData, function(result) {
      if (result.code == 99) {
        Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);

      } else {
        Common.ajax("POST", "/homecare/sales/order/updateHcPreOrder.do", orderVO, function(result) {
          Common.alert("Order Saved" + DEFAULT_DELIMITER + "<b>" + result.message + "</b>", fn_closePreOrdModPop);
        }, function(jqXHR, textStatus, errorThrown) {
          try {
            Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.</b>");
            Common.removeLoader();

          } catch (e) {
            console.log(e);
          }
        });
        //myFileCaches = {};
      }
    }, function(result) {
      Common.alert(result.message + "<br/>Upload Failed. Please check with System Administrator.");
    });
  }

  function fn_check(a, tagNum) {
    if ($('#compType' + tagNum + ' option').length <= 0) {
      if (a == 3) {
        return;
      } else {
        setTimeout(function() {
          fn_check(parseInt(a) + 1, tagNum)
        }, 500);
      }
    } else if ($('#compType' + tagNum + ' option').length <= 1) {
      //             $('#compType'+tagNum+' option').remove();
      $('#compType' + tagNum).addClass("blind");
      $('#compType' + tagNum).prop("disabled", true);

    } else if ($('#compType' + tagNum + ' option').length > 1) {
      $('#compType' + tagNum).removeClass("blind");
      $('#compType' + tagNum).removeAttr("disabled");

      var key = 0;
      Common.ajax("GET", "/sales/order/selectProductComponentDefaultKey.do", {
        stkId : $("#ordProduct" + tagNum).val()
      }, function(defaultKey) {
        if (defaultKey != null) {
          key = defaultKey.code;
        }
        $('#compType' + tagNum).val(key).change();
      });
    }
  }

  function fn_closePreOrdModPop() {
    fn_getPreOrderList();
    myFileCaches = {};
    delete update;
    delete remove;
    $('#_divPreOrdModPop').remove();
  }

  function fn_closePreOrdModPop2() {
    myFileCaches = {};
    delete update;
    delete remove;
    $('#_divPreOrdModPop').remove();
  }

  function fn_setBillGrp(grpOpt) {
    if (grpOpt == 'new') {
      fn_clearBillGroup();

      $('#grpOpt1').prop("checked", true);
      $('#sctBillAddr').removeClass("blind");
      $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());

      if ($('#hiddenTypeId').val() == '965') { //Company
        $('#sctBillPrefer').removeClass("blind");

        fn_loadBillingPreference($('#srvCntcId').val());

        $('#billMthdEstm').prop("checked", true);
        $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
        $('#billMthdEmail2').removeAttr("disabled");
        $('#billMthdEmailTxt1').removeAttr("disabled");
        $('#billMthdEmailTxt2').removeAttr("disabled");

      } else if ($('#hiddenTypeId').val() == '964') { //Individual
        if (FormUtil.isNotEmpty($('#custCntcEmail').val().trim())) {
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
        $("#hiddenBPCareId").val(srvCntcInfo.custCareCntId);
        $("#billPreferInitial").val(srvCntcInfo.custInitial);
        $("#billPreferName").val(srvCntcInfo.name);
        $("#billPreferTelO").val(srvCntcInfo.telO);
        $("#billPreferExt").val(srvCntcInfo.ext);
      }
    });
  }

  function fn_loadOrderSalesman(memId, memCode) {
    $('#salesmanCd').val('');
    $('#salesmanNm').val('');

    Common.ajaxSync("GET", "/sales/order/selectMemberByMemberIDCode.do", {
      memId : memId,
      memCode : memCode
    }, function(memInfo) {
      if (memInfo == null) {
        Common.alert('<b>Member not found.</br>Your input member code : ' + memCode + '</b>');

      } else {
        $('#salesmanCd').val(memInfo.memCode);
        $('#salesmanNm').val(memInfo.name);
        salesManType = memInfo.memType;
      }
    });
  }

  function fn_selectPromotionFreeGiftListForList2(promoId) {
    Common.ajax("GET", "/sales/promotion/selectPromotionFreeGiftList.do", {
      promoId : promoId
    }, function(result) {
      AUIGrid.setGridData(listGiftGridID, result);
    });
  }

  function fn_loadPromotionPrice(promoId, stkId, srvPacId, tagNum) {
    Common.ajax("GET", "/sales/order/selectProductPromotionPriceByPromoStockID.do", {
      promoId : promoId,
      stkId : stkId,
      srvPacId : srvPacId
    }, function(promoPriceInfo) {
      if (promoPriceInfo != null) {
        $("#ordPrice" + tagNum).val(promoPriceInfo.orderPricePromo);
        $("#ordPv" + tagNum).val(promoPriceInfo.orderPVPromo);
        $("#ordPvGST" + tagNum).val(promoPriceInfo.orderPVPromoGST);
        $("#ordRentalFees" + tagNum).val(promoPriceInfo.orderRentalFeesPromo);

        $("#promoDiscPeriodTp" + tagNum).val(promoPriceInfo.promoDiscPeriodTp);
        $("#promoDiscPeriod" + tagNum).val(promoPriceInfo.promoDiscPeriod);

        // 합계
        totSumPrice();
      }
    });
  }

  //LoadProductComponent
  function fn_loadProductComponent(stkId, tagNum) {
    $('#compType' + tagNum + ' option').remove();
    $('#compType' + tagNum).removeClass("blind");
    $('#compType' + tagNum).removeClass("disabled");

    var cnptId = '${preOrderInfo.cpntId}' != undefined ? '${preOrderInfo.cpntId}' : 0;
    doGetComboData('/sales/order/selectProductComponent.do', {
      stkId : stkId
    }, cnptId, 'compType' + tagNum, 'S', ''); //Common Code
  }

  //LoadProductPromotion
  function fn_loadProductPromotion(appTypeVal, stkId, empChk, custTypeVal, exTrade, tagNum) {
    $('#ordPromo' + tagNum).removeAttr("disabled");
    if(tagNum == '1'){
	    if (appTypeVal != 66) { // No Rental
		      doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {
		        appTypeId : appTypeVal,
		        stkId : stkId,
		        empChk : empChk,
		        promoCustType : custTypeVal,
		        exTrade : exTrade,
		        srvPacId : $('#srvPacId').val(),
		        isSrvPac : 'Y'
		        , voucherPromotion: voucherAppliedStatus
		        ,custStatus: $('#hiddenCustStatusId').val()
		      }, '', 'ordPromo' + tagNum, 'S', 'voucherPromotionCheck'); //Common Code
		    } else { // AppType : Rental
		      doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {
		        appTypeId : appTypeVal,
		        stkId : stkId,
		        empChk : empChk,
		        promoCustType : custTypeVal,
		        exTrade : exTrade,
		        srvPacId : $('#srvPacId').val()
		        , voucherPromotion: voucherAppliedStatus
		        ,custStatus: $('#hiddenCustStatusId').val()
		      }, '', 'ordPromo' + tagNum, 'S', 'voucherPromotionCheck'); //Common Code
		    }
    }
    else{
	    if (appTypeVal != 66) { // No Rental
	      doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {
	        appTypeId : appTypeVal,
	        stkId : stkId,
	        empChk : empChk,
	        promoCustType : custTypeVal,
	        exTrade : exTrade,
	        srvPacId : $('#srvPacId').val(),
	        isSrvPac : 'Y'
		    , voucherPromotion: voucherAppliedStatus
		    ,custStatus: $('#hiddenCustStatusId').val()
	      }, '', 'ordPromo' + tagNum, 'S', ''); //Common Code
	    } else { // AppType : Rental
	      doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {
	        appTypeId : appTypeVal,
	        stkId : stkId,
	        empChk : empChk,
	        promoCustType : custTypeVal,
	        exTrade : exTrade,
	        srvPacId : $('#srvPacId').val()
	        , voucherPromotion: voucherAppliedStatus
	        ,custStatus: $('#hiddenCustStatusId').val()
	      }, '', 'ordPromo' + tagNum, 'S', ''); //Common Code
	    }
    }
  }

  //LoadProductPrice
  function fn_loadProductPrice(appTypeVal, stkId, srvPacId, tagNum) {
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
        var pvVal = stkPriceInfo.orderPV;
        var pvValGst = Math.floor(pvVal * (1 / 1.06))

        $("#ordPrice" + tagNum).val(stkPriceInfo.orderPrice);
        $("#ordPv" + tagNum).val(pvVal);
        $("#ordPvGST" + tagNum).val(pvValGst);
        $("#ordRentalFees" + tagNum).val(stkPriceInfo.orderRentalFees);
        $("#ordPriceId" + tagNum).val(stkPriceInfo.priceId);
        $("#normalOrdPrice" + tagNum).val(stkPriceInfo.orderPrice);

        $("#promoDiscPeriodTp" + tagNum).val('');
        $("#promoDiscPeriod" + tagNum).val('');

        // 합계
        totSumPrice();
      }
    });
  }

  // 합계
  function totSumPrice() {
    // 합계
    var totOrdPrice = js.String.naNcheck($("#ordPrice1").val()) + js.String.naNcheck($("#ordPrice2").val());
    var totOrdRentalFees = js.String.naNcheck($("#ordRentalFees1").val()) + js.String.naNcheck($("#ordRentalFees2").val());
    var totOrdPv = js.String.naNcheck($("#ordPv1").val()) + js.String.naNcheck($("#ordPv2").val());

    $("#totOrdPrice").val(totOrdPrice.toFixed(2));
    $("#totOrdRentalFees").val(totOrdRentalFees.toFixed(2));
    $("#totOrdPv").val(totOrdPv.toFixed(2));
    setupSaveButton()
  }

  function fn_setOptGrpClass() {
    $("optgroup").attr("class", "optgroup_text")
  }

  function fn_setDefaultSrvPacId() {
    $('#srvPacId option:eq(1)').attr('selected', 'selected');

    // product comboBox 생성
    fn_setProductCombo();
  }

  // product comboBox 생성
  function fn_setProductCombo() {
    var stkType = $("#appType").val() == '66' ? '1' : '2';
    const postcode = $("#instPostCode").val()
    // StkCategoryID - Mattress(5706)
    doGetComboAndGroup2('/homecare/sales/order/selectHcProductCodeList.do', {
      stkType : stkType,
      srvPacId : $('#srvPacId').val(),
      stkCtgryId : '5706',
      postcode : postcode
    }, '', 'ordProduct1', 'S', 'fn_setOptGrpClass');//product 생성
    // StkCategoryID - Frame(5707)
    doGetComboAndGroup2('/homecare/sales/order/selectHcProductCodeList.do', {
      stkType : stkType,
      srvPacId : $('#srvPacId').val(),
      stkCtgryId : '5707',
      postcode : postcode
    }, '', 'ordProduct2', 'S', 'fn_setOptGrpClass');//product 생성
  }

  function fn_clearSales() {
    $('#installDur').val('');
    $('#relatedNo').val('');
    $('#pwpNo').val('');

    $('#ordProduct1').val('');
    $('#ordPromo1').val('');
    $('#ordPrice1').val('');
    $('#ordPriceId1').val('');
    $('#ordPv1').val('');
    $('#ordRentalFees1').val('');
    $('#compType1').addClass("blind");

    //$('#isReturnExtrade').prop("checked", true);--no product return
    $('#isReturnExtrade').attr("disabled",true);

    $('#ordProduct2').val('');
    $('#ordPromo2').val('');
    $('#ordPrice2').val('');
    $('#ordPriceId2').val('');
    $('#ordPv2').val('');
    $('#ordRentalFees2').val('');
    $('#compType2').addClass("blind");
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

  function fn_loadBillingGroupById(custId, custBillId) {
    Common.ajax("GET", "/sales/customer/selectBillingGroupByKeywordCustIDList.do", {
      custId : custId,
      custBillId : custBillId
    }, function(result) {
      if (result != null && result.length > 0) {
        fn_loadBillingGroup(result[0].custBillId, result[0].custBillGrpNo, result[0].billType, result[0].billAddrFull, result[0].custBillRem, result[0].custBillAddId);
      }
    });
  }

  function fn_getSvrPacCombo(selVal, srvPacId) {

    switch (selVal) {
    case '66': //RENTAL
      $('#scPayInfo').removeClass("blind");
      $('[name="advPay"]').removeAttr("disabled");

      appSubType = '367';
      break;

    case '67': //OUTRIGHT
      appSubType = '368';
      break;

    case '68': //INSTALLMENT
      appSubType = '369';
      break;

    case '1412': //Outright Plus
      $('#scPayInfo').removeClass("blind");
      $('[name="advPay"]').removeAttr("disabled");
      $('#installDur').val('').prop("readonly", true).addClass("readonly");

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
      break;
    }

    var pType = $("#appType").val() == '66' ? '1' : '2';
    //doGetComboData('/common/selectCodeList.do', {pType : pType}, '',  'srvPacId',  'S', 'fn_setDefaultSrvPacId'); //APPLICATION SUBTYPE
    doGetComboData('/sales/order/selectServicePackageList.do', {
      appSubType : appSubType,
      pType : pType
    }, srvPacId, 'srvPacId', 'S', ''); //APPLICATION SUBTYPE
  }

  function fn_loadPreOrderInfo(custId, nric) {
    var vCustTypeId = '';

    Common.ajaxSync("GET", "/sales/customer/selectCustomerJsonList", {
      custId : custId,
      nric : nric
    }, function(result) {
      if (result != null && result.length == 1) {
        $('#scPreOrdArea').removeClass("blind");

        var custInfo = result[0];

        $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
        $("#custTypeNm").val(custInfo.codeName1); //Customer Name
        $("#hiddenTypeId").val(custInfo.typeId); //Type
        $("#name").val(custInfo.name); //Name
        var maskedNric;

        if ('${preOrderInfo.stusId}' == '4' || '${preOrderInfo.stusId}' == '10'){
            if(userType == 1 || userType == 2 || userType == 7  || '${pageAuth.funcUserDefine6}' != 'Y'){
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

        $("#sstRegNo").val(custInfo.sstRgistNo); //SST Reg No
        $("#tin").val(custInfo.custTin); //TIN No

        $("#nationNm").val(custInfo.name2); //Nationality
        $("#race").val(custInfo.codeName2); //
        $("#dob").val(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
        $("#gender").val(custInfo.gender); //Gender
        $("#pasSportExpr").val(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
        $("#visaExpr").val(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
        $("#custEmail").val(custInfo.email); //Email
        $('#speclInstct').html('${preOrderInfo.instct}');

        if ('${preOrderInfo.appTypeId}' == '66' && custInfo.typeId == '965') {
          doGetComboOrder('/common/selectCodeList.do', '415', 'CODE_ID', '${preOrderInfo.corpCustType}', 'corpCustType', 'S', ''); //Common Code
          $('#corpCustType').removeAttr("disabled");
          doGetComboOrder('/common/selectCodeList.do', '416', 'CODE_ID', '${preOrderInfo.agreementType}', 'agreementType', 'S', ''); //Common Code
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

        if (custInfo.corpTypeId > 0) {
          $("#corpTypeNm").val(custInfo.codeName); //Industry Code
        } else {
          $("#corpTypeNm").val(""); //Industry Code
        }

        if ('${preOrderInfo.custBillAddId}' != null && '${preOrderInfo.instAddId}' != null) {
          //----------------------------------------------------------
          // [Billing Detail] : Billing Address SETTING
          //----------------------------------------------------------
          fn_loadBillAddr('${preOrderInfo.custBillAddId}');

          //----------------------------------------------------------
          // [Installation] : Installation Address SETTING
          //----------------------------------------------------------
          fn_loadInstallAddr('${preOrderInfo.instAddId}');

          var stkId = "${preMatOrderInfo.itmStkId}";
	      	$('#hiddenCustAddId').val('${preOrderInfo.instAddId}');
	      	checkIfIsAcInstallationProductCategoryCode(stkId);
        }

        if ('${preOrderInfo.custCntcId}' > 0) {
          //----------------------------------------------------------
          // [Master Contact] : Owner & Purchaser Contact
          //                    Additional Service Contact
          //----------------------------------------------------------
          fn_loadMainCntcPerson('${preOrderInfo.custCntcId}');
          fn_loadCntcPerson('${preOrderInfo.custCntcId}');
          //fn_loadSrvCntcPerson('${preOrderInfo.custBillCustCareCntId}');

          if ('${preOrderInfo.custCntcId}' != custInfo.custCntcId) {
            $('#chkSameCntc').prop("checked", false);
            $('#scAnothCntc').removeClass("blind");
          }
        }

        // Salesman
        fn_loadOrderSalesman(null, '${preOrderInfo.memCode}');

        if (custInfo.codeName == 'Government') {
          Common.alert('<b>Goverment Customer</b>');
        }

        if('${preOrderInfo.tnbAccNo}' != '') {
            $("#tnbAccNoLbl").show();
            $("#tnbAccNo").val("${preOrderInfo.tnbAccNo}");
            $("#tnbAccNo").show();
            countMatch = 1;
        }

      } else {
        Common.confirm('<b>* This customer is existing customer.<br>Do you want to create a customer?</b>', fn_createCustomerPop);
      }
    });

    //--------------------------------------------------------------
    // [Order Info]
    //--------------------------------------------------------------
    fn_getSvrPacCombo('${preOrderInfo.appTypeId}', '${preOrderInfo.srvPacId}');

//     $('#ordProduct1').removeAttr("disabled");
//     $('#ordProduct2').removeAttr("disabled");

    var stkType = '${preOrderInfo.appTypeId}' == '66' ? '1' : '2';
    // StkCategoryID - Mattress(5706)
    doGetComboAndGroup2('/homecare/sales/order/selectHcProductCodeList.do', {
      stkType : stkType,
      srvPacId : '${preOrderInfo.srvPacId}',
      stkCtgryId : '5706'
    }, '${preMatOrderInfo.itmStkId}', 'ordProduct1', 'S', 'fn_setOptGrpClass');//product 생성
    // StkCategoryID - Frame(5707)
    doGetComboAndGroup2('/homecare/sales/order/selectHcProductCodeList.do', {
      stkType : stkType,
      srvPacId : '${preOrderInfo.srvPacId}',
      stkCtgryId : '5707'
    }, '${preFrmOrderInfo.itmStkId}', 'ordProduct2', 'S', 'fn_setOptGrpClass');//product 생성

    if ('${preMatOrderInfo.cpntId}' != 0) {
      $('#compType1').removeClass("blind");
      fn_loadProductComponent('${preMatOrderInfo.itmStkId}', 1);
    }
    if ('${preFrmOrderInfo.cpntId}' != 0) {
      $('#compType2').removeClass("blind");
      fn_loadProductComponent('${preFrmOrderInfo.itmStkId}', 2);
    }

    $('#installDur').val('${preOrderInfo.instPriod}');
    $('#poNo').val('${preOrderInfo.custPoNo}');
    $('#refereNo').val('${preOrderInfo.sofNo}');

    $('#relatedNo').val('${preOrderInfo.relatedNo}');
    $('#txtOldOrderID').val('${preOrderInfo.salesOrdIdOld}');

    $('#pwpNo').val('${preOrderInfo.mainPwpOrdNo}');
    $('#txtMainPwpOrderID').val('${preOrderInfo.mainPwpOrdId}');
    if('${preOrderInfo.isExtradePr}' == 1){
        $("#isReturnExtrade").prop("checked", true);
    }

    $('#ordPromo1, #ordPromo2').removeAttr("disabled");
    console.log($('#ordProduct1').val());
    // Set Mattress Promotion
    if ($("#ordProduct1 option:selected").index() > 0) {
      doGetComboData('/sales/order/selectPromotionByAppTypeStockESales.do', {
        appTypeId : '${preOrderInfo.appTypeId}',
        stkId : '${preMatOrderInfo.itmStkId}',
        empChk : '${preMatOrderInfo.empChk}',
        promoCustType : vCustTypeId,
        exTrade : '${preMatOrderInfo.exTrade}',
        srvPacId : '${preMatOrderInfo.srvPacId}',
        promoId : '${preMatOrderInfo.promoId}',
        isSrvPac:('${preMatOrderInfo.appTypeId}' == 66 ? 'Y' : '')
        , voucherPromotion: voucherAppliedStatus
        ,custStatus: $('#hiddenCustStatusId').val()
      }, '${preMatOrderInfo.promoId}', 'ordPromo1', 'S', 'voucherPromotionCheck'); //Common Code


      /*if (appTypeVal != 66) { // No Rental
          doGetComboData('/sales/order/selectPromotionByAppTypeStock2.do', {
            appTypeId : appTypeVal,
            stkId : stkId,
            empChk : empChk,
            promoCustType : custTypeVal,
            exTrade : exTrade,
            srvPacId : $('#srvPacId').val(),
            isSrvPac : 'Y'
          }, '', 'ordPromo' + tagNum, 'S', ''); //Common Code
        } else { // AppType : Rental
          doGetComboData('/sales/order/selectPromotionByAppTypeStock.do', {
            appTypeId : appTypeVal,
            stkId : stkId,
            empChk : empChk,
            promoCustType : custTypeVal,
            exTrade : exTrade,
            srvPacId : $('#srvPacId').val()
          }, '', 'ordPromo' + tagNum, 'S', ''); //Common Code
        } */

      $('#ordRentalFees1').val('${preMatOrderInfo.mthRentAmt}');
      $('#promoDiscPeriodTp1').val('${preMatOrderInfo.promoDiscPeriodTp}');
      $('#promoDiscPeriod1').val('${preMatOrderInfo.promoDiscPeriod}');
      $('#ordPrice1').val('${preMatOrderInfo.totAmt}');
      $('#normalOrdPrice1').val('${preMatOrderInfo.norAmt}');
      $('#normalOrdRentalFees1').val('${preMatOrderInfo.norRntFee}');
      $('#ordRentalFees1').val('${preMatOrderInfo.discRntFee}');
      $('#ordPv1').val('${preMatOrderInfo.totPv}');
      $('#ordPvGST1').val('${preMatOrderInfo.totPvGst}');
      $('#ordPriceId1').val('${preMatOrderInfo.prcId}');
    }

    // Set Frame Promotion
    if ($("#ordProduct2 option:selected").index() > 0) {
      doGetComboData('/sales/order/selectPromotionByAppTypeStockESales.do', {
        appTypeId : '${preOrderInfo.appTypeId}',
        stkId : '${preFrmOrderInfo.itmStkId}',
        empChk : '${preFrmOrderInfo.empChk}',
        promoCustType : vCustTypeId,
        exTrade : '${preFrmOrderInfo.exTrade}',
        srvPacId : '${preFrmOrderInfo.srvPacId}',
        promoId : '${preFrmOrderInfo.promoId}',
        isSrvPac:('${preFrmOrderInfo.appTypeId}' == 5764 ? 'Y' : '')
        , voucherPromotion: voucherAppliedStatus
        ,custStatus: $('#hiddenCustStatusId').val()
      }, '${preFrmOrderInfo.promoId}', 'ordPromo2', 'S', 'voucherPromotionCheck'); //Common Code

      $('#ordRentalFees2').val('${preFrmOrderInfo.mthRentAmt}');
      $('#promoDiscPeriodTp2').val('${preFrmOrderInfo.promoDiscPeriodTp}');
      $('#promoDiscPeriod2').val('${preFrmOrderInfo.promoDiscPeriod}');
      $('#ordPrice2').val('${preFrmOrderInfo.totAmt}');
      $('#normalOrdPrice2').val('${preFrmOrderInfo.norAmt}');
      $('#normalOrdRentalFees2').val('${preFrmOrderInfo.norRntFee}');
      $('#ordRentalFees2').val('${preFrmOrderInfo.discRntFee}');
      $('#ordPv2').val('${preFrmOrderInfo.totPv}');
      $('#ordPvGST2').val('${preFrmOrderInfo.totPvGst}');
      $('#ordPriceId2').val('${preFrmOrderInfo.prcId}');
    }
    totSumPrice();

    $("input:radio[name='advPay']:radio[value='${preOrderInfo.advBill}']").prop("checked", true);

    if ('${preOrderInfo.is3rdParty}' == '1') {
      $('#thrdParty').attr("checked", true);
      $('#sctThrdParty').removeClass("blind");
      fn_loadThirdParty('${preOrderInfo.rentPayCustId}', 2);
    }

    if ('${preOrderInfo.rentPayModeId}' == '131') {
      $('#sctCrCard').removeClass("blind");
      fn_loadCreditCard2('${preOrderInfo.custCrcId}');

    } else if ('${preOrderInfo.rentPayModeId}' == '132') {
      $('#sctDirectDebit').removeClass("blind");
      fn_loadBankAccount('${preOrderInfo.custAccId}');
    }

    if ('${preOrderInfo.custBillId}' == '' || '${preOrderInfo.custBillId}' == '0') {
      $('#grpOpt1').prop("checked", true);
      $('#sctBillAddr').removeClass("blind");
      $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());

      if ($('#hiddenTypeId').val() == '965') { //Company
        $('#sctBillPrefer').removeClass("blind");

        if ('${preOrderInfo.custBillCustCareCntId}' != '' && '${preOrderInfo.custBillCustCareCntId}' != '0') {
          fn_loadBillingPreference('${preOrderInfo.custBillCustCareCntId}');
        }
        $('#billMthdEstm').prop("checked", true);
        $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
        $('#billMthdEmail2').removeAttr("disabled");
        $('#billMthdEmailTxt1').removeAttr("disabled").val("${preOrderInfo.custBillEmail}");
        $('#billMthdEmailTxt2').removeAttr("disabled").val("${preOrderInfo.custBillEmailAdd}");

        if (FormUtil.isNotEmpty("${preOrderInfo.custBillEmailAdd}")) {
          $('#billMthdEmail2').prop("checked", true);
        }

      } else if ($('#hiddenTypeId').val() == '964') { //Individual
        if (FormUtil.isNotEmpty("${preOrderInfo.custBillEmail}")) {

          $('#billMthdEstm').prop("checked", true);
          $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
          $('#billMthdEmail2').removeAttr("disabled");
          $('#billMthdEmailTxt1').removeAttr("disabled").val("${preOrderInfo.custBillEmail}");
          $('#billMthdEmailTxt2').removeAttr("disabled").val('${preOrderInfo.custBillEmailAdd}');

          if (FormUtil.isNotEmpty('${preOrderInfo.custBillEmailAdd}')) {
            $('#billMthdEmail2').prop("checked", true);
          }
        }

        $('#billMthdSms').prop("checked", true);
        $('#billMthdSms1').prop("checked", true).removeAttr("disabled").val('${preOrderInfo.custBillIsSms}');
        $('#billMthdSms2').removeAttr("disabled").val('${preOrderInfo.CustBillIsSms2}');

        if (FormUtil.isNotEmpty('${preOrderInfo.CustBillIsSms2}')) {
          $('#billMthdSms2').prop("checked", true);
        }
      }

    } else {
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

  function fn_loadBillAddr(custAddId) {
    Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
      custAddId : custAddId
    }, function(billCustInfo) {
      if (billCustInfo != null) {
        $("#hiddenBillAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
        $("#billAddrDtl").val(billCustInfo.addrDtl); //Address
        $("#billStreet").val(billCustInfo.street); //Street
        $("#billArea").val(billCustInfo.area); //Area
        $("#billCity").val(billCustInfo.city); //City
        $("#billPostCode").val(billCustInfo.postcode); //Post Code
        $("#billState").val(billCustInfo.state); //State
        $("#billCountry").val(billCustInfo.country); //Country

        $("#hiddenBillStreetId").val(billCustInfo.custAddId); //Magic Address STREET_ID(Hidden)
      }
    });
  }

  function displayStoreSection(defaultValue) {
      if ($('#isStore option:selected').val() != null
          && $('#isStore option:selected').val() != ""
          && $('#isStore option:selected').val() != "0") {
        $('#storeSection').show();
        if($('#cwStoreId > option').length == 0){
            doGetComboData('/common/selectStoreList.do', null, defaultValue, 'cwStoreId', 'S');
        }
      } else {
        $('#storeSection').hide();
        $('#cwStoreId').val('');
      }
  }

  function fn_loadStoreId(){
      if('${preOrderInfo.cwStoreId}' != null && '${preOrderInfo.cwStoreId}' != 0){
          $('#isStore').val(1);

          displayStoreSection('${preOrderInfo.cwStoreId}');
      }
  }

  function fn_resetSales() {
      $("#srvPacId").change()
  }

  function fn_loadInstallAddr(custAddId) {
    Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {
      custAddId : custAddId,
      'isHomecare' : 'Y'
    }, function(custInfo) {
      if (custInfo != null) {
        $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
        $("#instAddrDtl").val(custInfo.addrDtl); //Address
        $("#instStreet").val(custInfo.street); //Street
        $("#instArea").val(custInfo.area); //Area
        $("#instCity").val(custInfo.city); //City
        $("#instPostCode").val(custInfo.postcode); //Post Code
        $("#instState").val(custInfo.state); //State
        $("#instCountry").val(custInfo.country); //Country
        $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
        if (salesManType == 2)
          $("#keyinBrnchId").val(custInfo.cdBrnchId); //Posting Branch
        else if (salesManType == 7)
          $("#keyinBrnchId").val(custInfo.htBrnchId); //Posting Branch
        else if ('${preOrderInfo.stusId}' == 4 || '${preOrderInfo.stusId}' == 10)
          $("#keyinBrnchId").val('${preOrderInfo.keyinBrnchId}'); //Posting Branch
        else
          $("#keyinBrnchId").val(custInfo.soBrnchId); //Posting Branch
      }
    });
  }

  function fn_createCustomerPop() {
    Common.popupDiv("/sales/customer/customerRegistPop.do", {
      "callPrgm" : "PRE_ORD"
    }, null, true);
  }

  function fn_loadMainCntcPerson(custCntcId) {
    Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
      custCntcId : custCntcId
    }, function(custCntcInfo) {
      if (custCntcInfo != null) {
        $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
        $("#custInitial").val(custCntcInfo.code);
        $("#custEmail").val(custCntcInfo.email);
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

  function fn_loadCntcPerson(custCntcId) {
    Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
      custCntcId : custCntcId
    }, function(custCntcInfo) {
      if (custCntcInfo != null) {
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
    switch (tabNm) {
    case 'ord':
      AUIGrid.resize(listGiftGridID, 980, 180);

      if (MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7") {
        $('#memBtn').addClass("blind");
        $('#salesmanCd').prop("readonly", true).addClass("readonly");
        ;
      }
      //$('#appType').val("66");
      $('#appType').prop("disabled", true);

      if ($('#ordProduct1').val() == null) {
        $('#appType').change();
      }
      $('[name="advPay"]').prop("disabled", true);
      $('#advPayNo').prop("checked", true);
      $('#poNo').prop("disabled", true);

      break;

    case 'pay':
      if ($('#appType').val() == '66') {
        //$('#rentPayMode').val('131')
        $('#rentPayMode').change();
        $('#rentPayMode').prop("disabled", true);
        $('#thrdParty').prop("disabled", true);
      }
      break;

    default:
      break;
    }
  }

  function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
      atchFileGrpId : fileGrpId,
      atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
      var fileSubPath = result.fileSubPath;
      fileSubPath = fileSubPath.replace('\', ' / '');

      if (result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
        window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);

      } else {
        window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
      }
    });
  }

  function fn_loadAtchment(atchFileGrpId) {
    Common.ajax("Get", "/sales/order/selectAttachList.do", {
      atchFileGrpId : atchFileGrpId
    }, function(result) {
      if (result) {
        if (result.length > 0) {
          $("#attachTd").html("");

          for (var i = 0; i < result.length; i++) {

            switch (result[i].fileKeySeq) {
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

            case '10':
            	elecBillFileId = result[i].atchFileId;
            	elecBillFileName = result[i].atchFileName;
                $(".input_text[id='elecBillFileTxt']").val(elecBillFileName);
                break;

            default:
              Common.alert("no files");
            }
          }


          // 파일 다운
          if ('${preOrderInfo.stusId}' == '4' || '${preOrderInfo.stusId}' == '10'){
              if(userType != 1 && userType != 2 && userType != 7  && '${pageAuth.funcUserDefine6}' == 'Y'){
                  $(".input_text").dblclick(function() {
                      var oriFileName = $(this).val();
                      var fileGrpId;
                      var fileId;
                      for (var i = 0; i < result.length; i++) {
                        if (result[i].atchFileName == oriFileName) {
                          fileGrpId = result[i].atchFileGrpId;
                          fileId = result[i].atchFileId;
                        }
                      }
                      if (fileId != null)
                        fn_atchViewDown(fileGrpId, fileId);
                    });
              }
          }
          else{
              $(".input_text").dblclick(function() {
                var oriFileName = $(this).val();
                var fileGrpId;
                var fileId;
                for (var i = 0; i < result.length; i++) {
                  if (result[i].atchFileName == oriFileName) {
                    fileGrpId = result[i].atchFileGrpId;
                    fileId = result[i].atchFileId;
                  }
                }
                if (fileId != null)
                  fn_atchViewDown(fileGrpId, fileId);
              });
          }
        }
      }
    });
  }

  function fn_removeFile(name) {
    if (name == "PAY") {
      $("#payFile").val("");
      $(".input_text[name='PayFileTxt']").val("");
      $('#payFile').change();

    } else if (name == "TRF") {
      $("#trFile").val("");
      $(".input_text[name='trFileTxt']").val("");
      $('#trFile').change();

    } else if (name == "OTH") {
      $("#otherFile").val("");
      $(".input_text[name='otherFileTxt']").val("");
      $('#otherFile').change();

    } else if (name == "OTH2") {
      $("#otherFile2").val("");
      $(".input_text[name='otherFileTxt2']").val("");
      $('#otherFile2').change();

    } else if (name == "TNC") {
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
    else if(name == "ELECBILL") {
        $("#elecBillFile").val("");
        $(".input_text[name='elecBillFileTxt']").val("");
        $('#elecBillFile').change();
    }
  }

  function fn_validFile() {
    var isValid = true, msg = "";

    if (sofFileId == null) {
      isValid = false;
      msg += "* Please upload copy of SOF<br>";
    }
    if (nricFileId == null) {
      isValid = false;
      msg += "* Please upload copy of NRIC<br>";
    }

    if(countMatch == 1){
        if(FormUtil.isEmpty($('#elecBillFile').val().trim())) {
            isValid = false;
            msg += "* Please upload copy of Electric Bill<br>";
        }
    }

    if (!isValid)
      Common.alert("Save Pre-Order Summary" + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

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

    //Customise Installation DSC/HDC Load for Aircon Checking Usage and not including fn_clearSales for after onchange use
    function fn_loadInstallAddrForDiffBranch(custAddId, isHomecare,isAC) {
    	Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", {custAddId : custAddId, 'isHomecare' : isHomecare,'isAC' : isAC}, function(custInfo) {
            if(custInfo != null) {
                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
            }
        });
    }

    function checkIfIsAcInstallationProductCategoryCode(stockIdVal){
	  	Common.ajaxSync("GET", "/homecare/checkIfIsAcInstallationProductCategoryCode.do", {stkId: stockIdVal}, function(result) {
	        if(result != null)
	        {
	        	var custAddId = $('#hiddenCustAddId').val();
	        	if(result.data == 1){
	        		//change installation branch to AC //load AC combobox
	                fn_loadInstallAddrForDiffBranch(custAddId,'N','Y');
	        	}
	        	else{
	        		//change installation branch to HDC //load hdc combobox
					fn_loadInstallAddrForDiffBranch(custAddId,'Y');
	        	}
	        }
	    },  function(jqXHR, textStatus, errorThrown) {
	        alert("Fail to check Air Conditioner. Please contact IT");
	  });
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
    	  Common.ajax("GET", "/misc/voucher/voucherVerification.do", {platform: voucherType, voucherCode: voucherCode, custEmail: voucherEmail, isEKeyIn: true, preOrdId: "${preMatOrderInfo.preOrdId}"}, function(result) {
    	        if(result.code == "00") {
    	        	voucherAppliedStatus = 1;
    	        	$('#voucherMsg').text('Voucher Applied for ' + voucherCode);
    		      	voucherAppliedCode = voucherCode;
    		      	voucherAppliedEmail = voucherEmail;
    	        	$('#voucherMsg').show();

    	        	Common.ajax("GET", "/misc/voucher/getVoucherUsagePromotionId.do", {voucherCode: voucherCode, custEmail: voucherEmail}, function(result) {
    	        		if(result.length > 0){
    	        			voucherPromotionId = result;
    	        			//voucherPromotionCheck();
		    	        	var appTypeIdx = $("#appType option:selected").index();
		        		    var appTypeVal = $("#appType").val();
		        		    var custTypeVal = $("#hiddenTypeId").val();
		        		    var stkIdx = $("#ordProduct1 option:selected").index();
		        		    var stkIdVal = $("#ordProduct1").val();
		        		    var empChk = 0;
		        		    var exTrade = $("#exTrade").val();
		        		    var srvPacId = appTypeVal == '66' ? $('#srvPacId').val() : 0;
		        		    if (stkIdx > 0) {
		        		        fn_loadProductPromotion(appTypeVal, stkIdVal, empChk, custTypeVal, exTrade, "1");
		        		    }
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

      //Voucher Promotion Check only for Main Product
      function voucherPromotionCheck(){
    	 if(voucherAppliedStatus == 1){
    		var orderPromoId = [];
    		var orderPromoIdToRemove = [];
    		$("#ordPromo1 option").each(function()
    		{
    			  orderPromoId.push($(this).val());
    	    });
    		orderPromoIdToRemove = orderPromoId.filter(function(obj) {
    		    return !voucherPromotionId.some(function(obj2) {
    			        return obj == obj2;
    		    });
    		});

    		if(orderPromoIdToRemove.length > 0){
    		   	$('#ordPromo1').val('');
    			for(var i = 0; i < orderPromoIdToRemove.length; i++){
    				if(orderPromoIdToRemove[i] == ""){
    				}
    				else{
    					$("#ordPromo1 option[value='" + orderPromoIdToRemove[i] +"']").remove();
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
        voucherPromotionId =[];

        $('#ordProduct1').val('');
      	$('#ordPromo1').val('');
      	$('#ordPromo1 option').remove();
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
      	Common.ajaxSync("GET", "/homecare/sales/order/checkPreBookSalesPerson.do", {memId : memId, memCode : memCode}, function(memInfo) {
      		if(memInfo == null) {
                  //Common.alert('<b>Your input member code : '+ memCode +' is not allowed for extrade pre-order.</b>');
                  isExist = false;
                  Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* Your input member code : "+ memCode +" is not allowed for extrade pre-order.</b>");
                  $('#aTabOI').click();
              }else {
              	isExist = true;
              	fn_doSavePreOrder();
              }
              return isExist;
      	});
      	return isExist;
      }

      function fn_checkPreOrderConfigurationPerson(memId,memCode,salesOrdId,salesOrdNo) {
      	var isExist = false;
      	Common.ajax("GET", "/homecare/sales/order/hcCheckPreBookConfigurationPerson.do", {memId : memId, memCode : memCode, salesOrdId : salesOrdId , salesOrdNo : salesOrdNo}, function(memInfo) {
      		if(memInfo == null) {
                  //Common.alert('<b>Your input member code : '+ memCode +' is not allowed for extrade pre-order.</b>');
                  isExist = false;
                  Common.alert("Pre-Order Summary" + DEFAULT_DELIMITER + "<b>* Your input member code : "+ memCode +" is not allowed for extrade pre-order.</b>");
                  $('#aTabOI').click();
              } else {
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
//                 if($('#exTrade').val() == '1' && $("#hiddenTypeId").val() == '964' && $('#relatedNo').val() == '' && $('#hiddenMonthExpired').val() != '1') {
//               		return fn_checkPreOrderSalesPerson(0,memCode);
//                 }else if ($('#exTrade').val() == '1' && $("#hiddenTypeId").val() == '964' && $('#relatedNo').val() != '' && $('#hiddenMonthExpired').val() != '1'){
//               	    return fn_checkPreOrderSalesPerson(0,memCode);
//                 }else if($('#exTrade').val() == '1' && $("#hiddenTypeId").val() == '964' && $('#relatedNo').val() != '' && $('#hiddenMonthExpired').val() == '1'){
//               	    return fn_checkPreOrderConfigurationPerson(0,memCode,salesOrdId,salesOrdNo);
//                 }
				else{
         			return fn_doSavePreOrder();
               	}
           }
      }

      function checkExtradePreBookEligible(custId,salesOrdIdOld){
   	   Common.ajax("GET", "/homecare/sales/order/selectPreBookOrderEligibleCheck.do", {custId : custId , salesOrdIdOld : salesOrdIdOld}, function(result) {
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
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>eKey-in</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnPreOrdClose" onClick="javascript:fn_closePreOrdModPop2();" href="#">CLOSE</a></p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <aside class="title_line">
      <!-- title_line start -->
      <ul class="right_btns">
        <li><p class="btn_blue blind"><a id="btnConfirm" href="#">Confirm</a></p></li>
        <li><p class="btn_blue blind"><a href="#">Clear</a></p></li>
      </ul>
    </aside>
    <!-- title_line end -->
    <form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
      <input id="selType" name="selType" type="hidden" value="1" />
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 160px" />
          <col style="width: *" />
          <col style="width: 170px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">NRIC/Company No</th>
            <td><input id="nric2" name="nric2" type="text" value="" title="" placeholder="" class="w100p readonly" readonly /></td>
            <td><input id="nric" name="nric" type="hidden" value="" title="" placeholder="" class="w100p readonly" readonly /></td>
            <th scope="row">SOF No</th>
            <td>
              <input id="sofNo" name="sofNo" type="text" value="${preOrderInfo.sofNo}" title="" placeholder="" class="w100p readonly" readonly />
            </td>
          </tr>
        </tbody>
      </table>
      <!-- table end -->
    </form>
    <!------------------------------------------------------------------------------
      Pre-Order Regist Content START
    ------------------------------------------------------------------------------->
    <section id="scPreOrdArea" class="">
      <section class="tap_wrap">
        <!-- tap_wrap start -->
        <ul class="tap_type1 num4">
          <li><a href="aTabCS" class="on">Customer</a></li>
          <li><a href="aTabOI" onClick="javascript:chgTab('ord');">Order Info</a></li>
          <li><a href="aTabBD" onClick="javascript:chgTab('pay');">Payment Info</a></li>
          <li><a href="aTabFL">Attachment</a></li>
          <li><a href="aTabFR" >Failed Remark</a></li>
        </ul>
        <article class="tap_area">
          <!-- tap_area start -->
          <section class="search_table">
            <!-- search_table start -->
            <form id="frmPreOrdReg" name="frmPreOrdReg" action="#" method="post">
              <input id="hiddenPreOrdId" name="preOrdId" type="hidden" value="${preOrderInfo.preOrdId}" /> <input id="hiddenPreOrdId1" name="preOrdId1" type="hidden" value="${preMatOrderInfo.preOrdId}" /> <input id="hiddenPreOrdId2" name="preOrdId2" type="hidden" value="${preFrmOrderInfo.preOrdId}" /> <input id="hiddenOrdSeqNo" name="ordSeqNo" type="hidden" value="${hcPreOrdInfo.ordSeqNo}" /> <input id="hiddenCustId" name="custId" type="hidden" /> <input id="hiddenTypeId" name="typeId" type="hidden" /> <input id="hiddenCustCntcId" name="custCntcId" type="hidden" /> <input id="hiddenCustAddId" name="custAddId" type="hidden" /> <input id="hiddenRcdTms" name="rcdTms" type="hidden" value="${preOrderInfo.updDt}" /> <input id="hiddenRcdTms1" name="rcdTms1" type="hidden" value="${preMatOrderInfo.updDt}" /> <input id="hiddenRcdTms2" name="rcdTms2" type="hidden" value="${preFrmOrderInfo.updDt}" />
              <aside class="title_line">
                <!-- title_line start -->
                <h3>Customer information</h3>
              </aside>
              <!-- title_line end -->
              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 350px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.custType2" /><span class="must">*</span></th>
                    <td>
                      <input id="custTypeNm" name="custTypeNm" type="text" title="" placeholder="" class="w100p readonly" />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.initial2" /><span class="must">*</span></th>
                    <td>
                      <input id="custInitial" name="custInitial" type="text" title="Initial" placeholder="Initial" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.title.text.companyType2" /><span class="must">*</span></th>
                    <td>
                      <input id="corpTypeNm" name="corpTypeNm" type="text" title="" placeholder="" class="w100p readonly" />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.custName2" /><span class="must">*</span></th>
                    <td>
                      <input id="name" name="name" type="text" title="" placeholder="" class="w100p readonly" readonly />
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
                  <col style="width: 350px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                <tr>
				  <th scope="row"><spring:message code="sal.text.sstRegistrationNo" /><span class="must">*</span></th>
				  <td><input id="sstRegNo" name="sstRegNo" type="text" title="" placeholder="SST Registration No" class="w100p readonly" readonly /></td>
				    <!-- <span id="sstRegNo" name="sstRegNo"></span> -->

				</tr>
				<tr>
				  <th scope="row"><spring:message code="sal.text.tin" /><span class="must">*</span></th>
				  <td><input id="tin" name="tin" type="text" title="" placeholder="TIN No" class="w100p readonly" readonly /></td>
				    <!-- <span id="tin" name="tin"></span> -->
				</tr>
				<tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.nationality2" /></th>
                    <td>
                      <input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Passport Visa expiry date | Visa passport tarikh tamat(foreigner)</th>
                    <td>
                      <input id="visaExpr" name="visaExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Passport expiry date | Passport tarikh luput(foreigner)</th>
                    <td>
                      <input id="pasSportExpr" name="pasSportExpr" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.dob2" /><span class="must">*</span></th>
                    <td>
                      <input id="dob" name="dob" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.race2" /><span class="must">*</span></th>
                    <td>
                      <input id="race" name="race" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.gender2" /><span class="must">*</span></th>
                    <td>
                      <input id="gender" name="gender" type="text" title="" placeholder="Gender" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.title.text.email2" /><span class="must">*</span></th>
                    <td>
                      <input id="custEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly />
                    </td>
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
                  <!--
                  <tr>
                    <th scope="row">Tel (Mobile)<span class="must">*</span></th>
                    <td>
                      <input id="custTelM" name="custTelM" type="text" title="" placeholder="" class="w100p readonly" readonly/>
                    </td>
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
              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 250px" />
                  <col style="width: *" />
                  <col style="width: 250px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <!--
                  <tr>
                    <th scope="row">If contact same as above click here</th>
                    <td colspan="3"><input id="chkSameCntc" type="checkbox" checked/></td>
                  </tr>
                  -->
                </tbody>
              </table>
              <!-- table end -->
              <section id="scAnothCntc">
                <ul class="right_btns mb10">
                  <li><p class="btn_grid"><a id="btnNewCntc" href="#">Add New Contact</a></p></li>
                  <li><p class="btn_grid"><a id="btnSelCntc" href="#">Select Another Contact</a></p></li>
                </ul>
                <table class="type1">
                  <!-- table start -->
                  <caption>table</caption>
                  <colgroup>
                    <col style="width: 250px" />
                    <col style="width: *" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <!--
                      <th scope="row">Initial<span class="must">*</span></th>
                      <td><input id="custCntcInitial" name="custCntcInitial" type="text" title="Create start Date" placeholder="Race" class="w100p readonly" readonly/></td> -->
                      <th scope="row">Second/Service contact person name</th>
                      <td>
                        <input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Mobile)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Residence)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Office)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Tel (Fax)<span class="must">*</span></th>
                      <td>
                        <input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Ext No.(1)</th>
                      <td>
                        <input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p readonly" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">Email(1)</th>
                      <td>
                        <input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly />
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
                <li><p class="btn_grid"><a id="btnNewInstAddr" href="#">Add New Address</a></p></li>
                <li><p class="btn_grid"><a id="btnSelInstAddr" href="#">Select Another Address</a></p></li>
              </ul>
              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 160px" />
                  <col style="width: *" />
                  <col style="width: 160px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">Address Line 1<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Address Line 2<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instStreet" name="instStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Area | Daerah<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instArea" name="instArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">City | Bandar<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instCity" name="instCity" type="text" title="" placeholder="City" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">PostCode | Poskod<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instPostCode" name="instPostCode" type="text" title="" placeholder="Post Code" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">State | Negeri<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instState" name="instState" type="text" title="" placeholder="State" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Country | Negara<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="instCountry" name="instCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly />
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- table end -->
              <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 160px" />
                  <col style="width: *" />
                  <col style="width: 160px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">DT Branch<span class="must">*</span></th>
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
                      <input id="prefInstDt" name="prefInstDt" type="text" title="Create start Date" placeholder="Prefer Install Date (dd/MM/yyyy)" class="j_date w100p" value="${preOrderInfo.preDt}" disabled />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Prefer Install Time<span class="must">*</span></th>
                    <td colspan="3">
                      <div class="time_picker">
                        <!-- time_picker start -->
                        <input id="prefInstTm" name="prefInstTm" type="text" title="" placeholder="Prefer Install Time (hh:mi tt)" class="time_date w100p" value="11:00 AM" value="${preOrderInfo.preTm}" disabled />
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
                <col style="width: 250px" />
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
                    <p><select id="exTrade" name="exTrade" class="w100p" disabled></select></p>
                    <!-- For Extrade and ICare [S]-->
                    <p><input id="relatedNo" name="relatedNo" type="text" title="" placeholder="Related Number" class="w100p readonly" readonly /></p>
                    <a id="isReturnExtradeChkBoxEkeyIn"><input id="isReturnExtrade" name="isReturnExtrade" type="checkbox" class="" disabled/> Return ex-trade product</a>
                    <!-- For Extrade and ICare [E]-->

                    <!-- For PWP [S]-->
                    <a id="btnPwpNoEkeyIn" href="#" class="search_btn blind"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                    <p><input id="pwpNo" name="pwpNo" type="text" title="" placeholder="PWP Number" class="w100p readonly blind" readonly /></p>
                    <input id="txtMainPwpOrderID" name="txtMainPwpOrderID" type="hidden" />
                    <!-- For PWP [E]-->

                    <input id="txtOldOrderID" name="txtOldOrderID" type="hidden" />
                    <input id="txtBusType"  name="txtBusType" type="hidden" />
                    <input id="hiddenMonthExpired" name="hiddenMonthExpired" type="hidden" />
                	<input id="hiddenPreBook" name="hiddenPreBook" type="hidden" />
                  </td>
                </tr>
                <tr>
				    <th scope="row">Store<span class="must">*</span></th>
				    <td>
				        <p>
				            <select id="isStore" name="isStore" onchange="displayStoreSection()" class="w100p"></select>
				        </p>
				        <p id="storeSection" style="display: none;">
				            <select id="cwStoreId" name="cwStoreId" class="w100p"></select>
				        </p>
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
                    <p><select id="srvPacId" name="srvPacId" class="w100p" disabled></select></p>
                  </td>
                </tr>
                <tr>
                    <th scope="row">Installment Duration<span class="must">*</span></th>
                    <td><input id="installDur" name="installDur" type="text" title="" placeholder="Installment Duration (1-36)" class="w100p readonly" readonly/></td>
                </tr>
              </tbody>
            </table>
            <!-- Mattress -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3>Mattress</h3>
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
                  <th scope="row">Product | Produk<span class="must">*</span></th>
                  <td>
                    <select id="ordProduct1" name="ordProduct1" class="w100p" disabled></select>
                  </td>
                </tr>
                <tr id='trCpntId1' style='visibility: collapse'>
                  <th scope="row"><spring:message code="sal.title.text.cpntId" /> | Komponen Tambahan <span class="must">*</span></th>
                  <td>
                    <select id="compType1" name="compType1" class="w100p" onchange="fn_reloadPromo('1')"></select>
                  </td>
                </tr>
                <tr>
                  <th scope="row">Promotion | Promosi<span class="must">*</span></th>
                  <td>
                    <select id="ordPromo1" name="ordPromo1" class="w100p" disabled></select>
                  </td>
                </tr>
                <tr style="display: none;">
                  <th scope="row">Price / RPF (RM)</th>
                  <td>
                    <input id="ordPrice1" name="ordPrice1" type="text" data-ref='ordProduct1' title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly /> <input id="ordPriceId1" name="ordPriceId1" type="hidden" data-ref='ordProduct1' /> <input id="normalOrdPrice1" name="normalOrdPrice1" type="hidden" data-ref='ordProduct1' /> <input id="normalOrdPv1" name="normalOrdPv1" type="hidden" data-ref='ordProduct1' />
                  </td>
                </tr>
                <tr style="display: none;">
                  <th scope="row">Rental Fee</th>
                  <td>
                    <input id="ordRentalFees1" name="ordRentalFees1" type="text" data-ref='ordProduct1' title="" placeholder="" class="w100p readonly" readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row">PV<span class="must">*</span></th>
                  <td>
                    <input id="ordPv1" name="ordPv1" type="text" data-ref='ordProduct1' title="" placeholder="Point Value (PV)" class="w100p readonly" readonly /> <input id="ordPvGST1" name="ordPvGST1" type="hidden" data-ref='ordProduct1' />
                  </td>
                </tr>
                <tr>
                    <th scope="row"><label  id="tnbAccNoLbl">Electricity account number</label></th>
				    <td>
				        <input id="tnbAccNo" name="tnbAccNo" type="text" placeholder="TNB Account No." class="w100p "  />
				    </td>
                </tr>
              </tbody>
            </table>
            <!-- Frame -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3>Frame</h3>
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
                  <th scope="row">Product | Produk<span class="must">*</span></th>
                  <td>
                    <select id="ordProduct2" name="ordProduct2" class="w100p" disabled></select>
                  </td>
                </tr>
                <tr id='trCpntId2' style='visibility: collapse'>
                  <th scope="row"><spring:message code="sal.title.text.cpntId" /> | Komponen Tambahan <span class="must">*</span></th>
                  <td>
                    <select id="compType2" name="compType2" class="w100p" onchange="fn_reloadPromo('2')"></select>
                  </td>
                </tr>
                <tr>
                  <th scope="row">Promotion | Promosi<span class="must">*</span></th>
                  <td>
                    <select id="ordPromo2" name="ordPromo2" class="w100p" disabled></select>
                  </td>
                </tr>
                <tr style="display: none;">
                  <th scope="row">Price / RPF (RM)</th>
                  <td>
                    <input id="ordPrice2" name="ordPrice2" type="text" data-ref='ordProduct2' title="" placeholder="Price/Rental Processing Fees (RPF)" class="w100p readonly" readonly /> <input id="ordPriceId2" name="ordPriceId2" type="hidden" data-ref='ordProduct2' /> <input id="normalOrdPrice2" name="normalOrdPrice2" type="hidden" data-ref='ordProduct2' /> <input id="normalOrdPv2" name="normalOrdPv2" type="hidden" data-ref='ordProduct2' />
                  </td>
                </tr>
                <tr style="display: none;">
                  <th scope="row">Rental Fee</th>
                  <td>
                    <input id="ordRentalFees2" name="ordRentalFees2" type="text" data-ref='ordProduct2' title="" placeholder="" class="w100p readonly" readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row">PV<span class="must">*</span></th>
                  <td>
                    <input id="ordPv2" name="ordPv2" type="text" data-ref='ordProduct2' title="" placeholder="Point Value (PV)" class="w100p readonly" readonly /> <input id="ordPvGST2" name="ordPvGST2" type="hidden" data-ref='ordProduct2' />
                  </td>
                </tr>
              </tbody>
            </table>
            <!--  Total -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3>Total</h3>
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
                  <th scope="row" style="font-weight: bold;"><spring:message code="sal.title.text.priceRpfRm" /></th>
                  <td>
                    <input id="totOrdPrice" name="totOrdPrice" type="text" title="" placeholder="Price/Rental Processing Fees (RPF)" style="width: 100% !important; font-weight: bold;" class="readonly" readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row" style="font-weight: bold;"><spring:message code="sal.title.text.finalRentalFees" /></th>
                  <td>
                    <input id="totOrdRentalFees" name="totOrdRentalFees" type="text" title="" placeholder="" style="width: 100% !important; font-weight: bold;" class="readonly" readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row" style="font-weight: bold;"><spring:message code="sal.title.text.pv" /></th>
                  <td>
                    <input id="totOrdPv" name="totOrdPv" type="text" title="" placeholder="Point Value (PV)" style="width: 100% !important; font-weight: bold;" class="readonly" readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row">Advance Rental Payment*</th>
                  <td>
                    <span>Does customer make advance rental payment for 12 months and above?</sapn> <input id="advPayYes" name="advPay" type="radio" value="1" /><span>Yes</span> <input id="advPayNo" name="advPay" type="radio" value="0" /><span>No</span>
                  </td>
                </tr>
                <tr>
                  <th scope="row">PO No</th>
                  <td>
                    <input id="poNo" name="poNo" type="text" title="" placeholder="" class="w100p" />
                  </td>
                </tr>
                <tr>
                  <th scope="row">Salesman Code / Name<span class="must">*</span></th>
                  <td>
                    <input id="salesmanCd" name="salesmanCd" type="text" style="width: 115px;" title="" placeholder="" class="" /> <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                    <p><input id="salesmanNm" name="salesmanNm" type="text" class="w100p readonly" title="" placeholder="Salesman Name" disabled /></p>
                  </td>
                </tr>
                <tr>
                  <th scope="row">Special Instruction<span class="must">*</span></th>
                  <td>
                    <textarea id="speclInstct" name="speclInstct" cols="20" rows="5"></textarea>
                  </td>
                </tr>
                <tr style="display: none;">
                  <!--
                  <th scope="row">PV<span class="must">*</span></th>
                  -->
                  <!--
                  <td>
                    <input id="ordPv"    name="ordPv"    type="text" title="" placeholder="Point Value (PV)" class="w100p readonly" readonly />
                   -->
                    <!--
                    <input id="ordPvGST" name="ordPvGST" type="hidden" />
                  </td>
                  -->
                  <th scope="row">Discount Type / Period (month)</th>
                  <td>
                    <p><select id="promoDiscPeriodTp1" name="promoDiscPeriodTp1" class="w100p" disabled></select></p>
                    <p><input id="promoDiscPeriod1" name="promoDiscPeriod1" type="text" title="" placeholder="" style="width: 42px;" class="readonly" readonly /></p>
                    <p><select id="promoDiscPeriodTp2" name="promoDiscPeriodTp2" class="w100p" disabled></select></p>
                    <p><input id="promoDiscPeriod2" name="promoDiscPeriod2" type="text" title="" placeholder="" style="width: 42px;" class="readonly" readonly /></p>
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
                </tr>
              </tbody>
            </table>
            <!-- table end -->
            <!--
            <aside class="title_line">title_line start
              <h3>Free Gift Information</h3>
              </aside>title_line end

              <article class="grid_wrap">grid_wrap start
                <div id="pop_list_gift_grid_wrap" style="width:100%; height:80px; margin:0 auto;"></div>
              </article><!-- grid_wrap end -->
            <br> <br> <br> <br> <br>
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
                <col style="width: 250px" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row">Pay By Third Party</th>
                  <td colspan="3">
                    <label><input id="thrdParty" name="thrdParty" type="checkbox" value="1" /><span></span></label>
                  </td>
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
                <li><p class="btn_grid"><a id="thrdPartyAddCustBtn" href="#">Add New Third Party</a></p></li>
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
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">Customer ID<span class="must">*</span></th>
                    <td>
                      <input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="Third Party ID" class="" /> <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input id="hiddenThrdPartyId" name="hiddenThrdPartyId" type="hidden" title="" placeholder="Third Party ID" class="" />
                    </td>
                    <th scope="row">Type</th>
                    <td>
                      <input id="thrdPartyType" name="thrdPartyType" type="text" title="" placeholder="Costomer Type" class="w100p readonly" readonly />
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
                  <col style="width: 250px" />
                  <col style="width: *" />
                  <col style="width: 190px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th><spring:message code="sal.text.rentalPaymode2" /><span class="must">*</span></th>
                    <td scope="row" colspan="3"'>
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
                <h3>Credit Card</h3>
              </aside>
              <!-- title_line end -->
              <ul class="right_btns mb10">
                <li><p class="btn_grid"><a id="addCreditCardBtn" href="#">Add New Credit Card</a></p></li>
                <li><p class="btn_grid"><a id="selCreditCardBtn" href="#">Select Another Credit Card</a></p></li>
              </ul>
              <!------------------------------------------------------------------------------
                Credit Card - Form ID(crcForm)
              ------------------------------------------------------------------------------->
              <table class="type1 mb1m">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                  <col style="width: 250px" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.creditCardNo2" /><span class="must">*</span></th>
                    <td>
                      <input id="rentPayCRCNo" name="rentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly /> <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" /> <input id="hiddenRentPayEncryptCRCNoId" name="hiddenRentPayEncryptCRCNoId" type="hidden" />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.type2" /></th>
                    <td>
                      <input id="rentPayCRCType" name="rentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p readonly" readonly />
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
                      <input id="rentPayCRCBank" name="rentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly /> <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" title="" class="w100p" />
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
                <li><p class="btn_blue"><a name="ordSaveBtn" href="#">OK</a></p></li>
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
                <li><p class="btn_grid"><a id="btnAddBankAccount" href="#">Add New Bank Account</a></p></li>
                <li><p class="btn_grid"><a id="btnSelBankAccount" href="#">Select Another Bank Account</a></p></li>
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
                      <input id="rentPayBankAccNo" name="rentPayBankAccNo" type="text" title="" placeholder="Account Number readonly" class="w100p readonly" readonly /> <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" />
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
                      <input id="accBank" name="accBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly /> <input id="hiddenAccBankId" name="hiddenAccBankId" type="hidden" />
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
                <col style="width: 150px" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row">Group Option<span class="must">*</span></th>
                  <td>
                    <label><input type="radio" id="grpOpt1" name="grpOpt" value="new" /><span>New Billing Group</span></label> <label><input type="radio" id="grpOpt2" name="grpOpt" value="exist" /><span>Existion Billing Group</span></label>
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
                      <label><input id="billMthdPost" name="billMthdPost" type="checkbox" /><span>Post</span></label>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="3">
                      <label><input id="billMthdSms" name="billMthdSms" type="checkbox" /><span>SMS</span></label> <label><input id="billMthdSms1" name="billMthdSms1" type="checkbox" disabled /><span>Mobile 1</span></label> <label><input id="billMthdSms2" name="billMthdSms2" type="checkbox" disabled /><span>Mobile 2</span></label>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <label><input id="billMthdEstm" name="billMthdEstm" type="checkbox" /><span>E-Billing</span></label> <label><input id="billMthdEmail1" name="billMthdEmail1" type="checkbox" disabled /><span>Email 1</span></label> <label><input id="billMthdEmail2" name="billMthdEmail2" type="checkbox" disabled /><span>Email 2</span></label>
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
                      <label><input id="billGrpWeb" name="billGrpWeb" type="checkbox" /><span>Web Portal</span></label>
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
              <input id="hiddenBillAddId" name="custAddId" type="hidden" /> <input id="hiddenBillStreetId" name="hiddenBillStreetId" type="hidden" />
              <aside class="title_line">
                <!-- title_line start -->
                <h3>Billing Address</h3>
              </aside>
              <!-- title_line end -->
              <!--
              <ul class="right_btns mb10">
                <li><p class="btn_grid"><a id="billNewAddrBtn" href="#">Add New Address</a></p></li>
                <li><p class="btn_grid"><a id="billSelAddrBtn" href="#">Select Another Address</a></p></li>
              </ul>
              -->
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
                    <th scope="row">Address Detail<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="billAddrDtl" name="billAddrDtl" type="text" title="" placeholder="Address Detail" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Street</th>
                    <td colspan="3">
                      <input id="billStreet" name="billStreet" type="text" title="" placeholder="Street" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Area<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="billArea" name="billArea" type="text" title="" placeholder="Area" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">City<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="billCity" name="billCity" type="text" title="" placeholder="City" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">PostCode<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="billPostCode" name="billPostCode" type="text" title="" placeholder="Postcode" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">State<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="billState" name="billState" type="text" title="" placeholder="State" class="w100p readonly" readonly />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">Country<span class="must">*</span></th>
                    <td colspan="3">
                      <input id="billCountry" name="billCountry" type="text" title="" placeholder="Country" class="w100p readonly" readonly />
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
                <li class="blind"><p class="btn_grid"><a id="billPreferAddAddrBtn" href="#">Add New Contact</a></p></li>
                <li class="blind"><p class="btn_grid"><a id="billPreferSelAddrBtn" href="#">Select Another Contact</a></p></li>
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
                      <input id="billGrp" name="billGrp" type="text" title="" placeholder="Billing Group" class="readonly" readonly /><a id="billGrpBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input id="hiddenBillGrpId" name="billGrpId" type="hidden" value="${preOrderInfo.custBillId}" />
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
              <col style="width: 350px" />
              <col style="width: *" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row">Sales Order Form (SOF)<span class="must">*</span></th>
                <td>
                  <div class='auto_file2 auto_file3'>
                    <input type='file' title='file add' id='sofFile' accept='image/*' '/> <label> <input type='text' class='input_text' readonly='readonly' id='sofFileTxt' /> <span class='label_text'><a href='#'>Upload</a></span>
                    </label>
                  </div>
                </td>
              </tr>
              <tr>
                <th scope="row">Sales Order Form's T&C (SOF T&C)</th>
                <td>
                  <div class="auto_file2 auto_file3">
                    <input type="file" title="file add" id="sofTncFile" accept="image/*" /> <label> <input type='text' class='input_text' readonly='readonly' id='sofTncFileTxt' /> <span class='label_text'><a href='#'>Upload</a></span>
                    </label>
                  </div>
                </td>
              </tr>
              <tr>
              <tr>
                <th scope="row">NRIC & Bank Card<span class="must">*</span></th>
                <td>
                  <div class='auto_file2 auto_file3'>
                    <input type='file' title='file add' id='nricFile' accept='image/*' '/> <label> <input type='text' class='input_text' readonly='readonly' id='nricFileTxt' /> <span class='label_text'><a href='#'>Upload</a></span>
                    </label>
                  </div>
                </td>
              </tr>
              <tr>
                <th scope="row">Payment document</th>
                <td id="tdPayFile">
                  <div class='auto_file2 auto_file3'>
                    <input type='file' title='file add' id='payFile' accept='image/*' '/> <label> <input type='text' class='input_text' readonly='readonly' id='payFileTxt' name='' /> <span class='label_text'><a href='#'>Upload</a></span>
                    </label> <span class='label_text'><a href='#' onclick='fn_removeFile("PAY")'>Remove</a></span>
                  </div>
                </td>
              </tr>
              <tr>
                <th scope="row">Coway temporary receipt (TR)</th>
                <td id="tdTrFile">
                  <div class='auto_file2 auto_file3'>
                    <input type='file' title='file add' id='trFile' accept='image/*' '/> <label> <input type='text' class='input_text' readonly='readonly' id='trFileTxt' name='' /> <span class='label_text'><a href='#'>Upload</a></span>
                    </label> <span class='label_text'><a href='#' onclick='fn_removeFile("TRF")'>Remove</a></span>
                  </div>
                </td>
              </tr>
              <tr>
                <th scope="row">Declaration letter/Others form</th>
                <td id="tdOtherFile">
                  <div class='auto_file2 auto_file3'>
                    <input type='file' title='file add' id='otherFile' accept='image/*' '/> <label> <input type='text' class='input_text' readonly='readonly' id='otherFileTxt' name='' /> <span class='label_text'><a href='#'>Upload</a></span>
                    </label> <span class='label_text'><a href='#' onclick='fn_removeFile("OTH")'>Remove</a></span>
                  </div>
                </td>
              </tr>
              <tr>
                <th scope="row">Declaration letter/Others form 2</th>
                <td id="tdOtherFile2">
                  <div class='auto_file2 auto_file3'>
                    <input type='file' title='file add' id='otherFile2' accept='image/*' '/> <label> <input type='text' class='input_text' readonly='readonly' id='otherFileTxt2' name='' /> <span class='label_text'><a href='#'>Upload</a></span>
                    </label> <span class='label_text'><a href='#' onclick='fn_removeFile("OTH2")'>Remove</a></span>
                  </div>
                </td>
              </tr>

              <tr>
                <th scope="row">Mattress Sales Order Form (MSOF)</th>
                <td>
                    <div class='auto_file2 auto_file3'>
                        <input type='file' title='file add'  id='msofFile' accept='image/*''/>
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
                        <input type="file" title="file add" id="msofTncFile" accept="image/*"/>
                        <label>
                            <input type='text' class='input_text' readonly='readonly' id='msofTncFileTxt'/>
                            <span class='label_text'><a href='#'>Upload</a></span>
                        </label>
                        <span class='label_text'><a href='#' onclick='fn_removeFile("MSOFTNC")'>Remove</a></span>
                    </div>
                </td>
            </tr>
            <tr>
                <th scope="row">Electric Bill</th>
                <td>
                    <div class="auto_file2 auto_file3">
                        <input type="file" title="file add" id="elecBillFile" accept="image/*"/>
                        <label>
                            <input type='text' class='input_text' readonly='readonly' id='elecBillFileTxt'/>
                            <span class='label_text'><a href='#'>Upload</a></span>
                        </label>
                        <span class='label_text'><a href='#' onclick='fn_removeFile("ELECBILL")'>Remove</a></span>
                    </div>
                </td>
            </tr>

              <tr>
                <td colspan=2>
                  <span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span>
                </td>
              </tr>
            </tbody>
          </table>
        </article>
        <!-- tap_area end -->

        <article class="tap_area"><!-- tap_area start -->

		<article class="grid_wrap"><!-- grid_wrap start -->
		<div id="grid_FailedRemark_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->

		</article><!-- tap_area end -->

      </section>
      <!-- tap_wrap end -->
      <ul class="center_btns mt20">
        <li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
      </ul>
    </section>
    <!------------------------------------------------------------------------------
      Pre-Order Regist Content END
     ------------------------------------------------------------------------------->
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
