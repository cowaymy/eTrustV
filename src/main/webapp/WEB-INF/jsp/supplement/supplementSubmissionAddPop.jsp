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
  var purchaseGridID;
  var myFileCaches = {};
  var atchFileGrpId = 0;

  $(document).ready(function() {
    createPurchaseGridID();


    doGetComboSepa('/common/selectBranchCodeList.do',  '10', ' - ', '' , 'salesmanBrnch', 'S', ''); //Branch Code

    $("#nric").keyup(function() {
      $(this).val($.trim($(this).val().toUpperCase()));
    });

    $("#sofNo").keyup(function() {
      $(this).val($.trim($(this).val().toUpperCase()));
    });

    $('#nric').keypress(function(e) {
      var regex = new RegExp("^[a-zA-Z0-9\s]+$");
      var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
      if (regex.test(str)) {
        return true;
      }
      e.preventDefault();
      return false;
    });
  });

  $(function() {
    $('#btnConfirm').click(function() {
      if (!fn_validConfirm())
        return false;

      if (fn_isExistSupplementSubmissionNo() == 'true')
        return false;

      $('#nric').prop("readonly", true).addClass("readonly").hide();
      $('#sofNo').prop("readonly", true).addClass("readonly").hide();
      ;
      fn_maskingData('_NRIC', $('#nric'));
      fn_maskingData('_SOFNO', $('#sofNo'));
      $('#pNric').show();
      $('#pSofNo').show();

      $('#btnConfirm').addClass("blind");
      $('#btnClear').addClass("blind");

      fn_loadCustomer(null, $('#nric').val());
    });
    $('#nric').keydown(function(event) {
      if (event.which === 13) {
        if (!fn_validConfirm())
          return false;

        if (fn_isExistSupplementSubmissionNo() == 'true')
          return false;

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

        if (fn_isExistSupplementSubmissionNo() == 'true')
          return false;

        $('#nric').prop("readonly", true).addClass("readonly");
        $('#sofNo').prop("readonly", true).addClass("readonly");
        $('#btnConfirm').addClass("blind");
        $('#btnClear').addClass("blind");

        fn_loadCustomer(null, $('#nric').val());
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

    $('#salesmanCd').change(function(event) {
      var memCd = $('#salesmanCd').val().trim();

      if (FormUtil.isNotEmpty(memCd)) {
        fn_loadOrderSalesman(0, memCd);
      } else {
        $('#salesmanNm').val('');
        $('#salesmanBrnch').text('');
        $('#hidSalesmanBrnchId').val('');
      }
    });

    $('#salesmanCd').keydown(function(event) {
      if (event.which === 13) { //enter
        var memCd = $('#salesmanCd').val().trim();

        if (FormUtil.isNotEmpty(memCd)) {
          fn_loadOrderSalesman(0, memCd);
        } else {
          $('#salesmanNm').val('');
          $('#salesmanBrnch').text('');
          $('#hidSalesmanBrnchId').val('');
        }
        return false;
      }
    });

    $('#memBtn').click(
        function() {
          Common.popupDiv("/common/memberPop.do", $("#searchForm")
              .serializeJSON(), null, true);
        });

    $("#_addBtn").click(
        function() {
          Common.popupDiv(
              "/supplement/supplementSubmissionItemSearchPop.do",
              null, null, true);
        });

    $("#_delBtn").click(function() {
      var chkDelArray = AUIGrid.getCheckedRowItems(purchaseGridID);

      AUIGrid.removeCheckedRows(purchaseGridID);

      var purTotAmt = 0;
      purTotAmt = fn_calcuPurchaseAmt();
      if (chkDelArray == null || chkDelArray.length <= 0) {
        $("#_payTotCharges").html(' ');
      } else {
        $("#_payTotCharges").html('RM : ' + purTotAmt);
      }
    });

    $('#sofFile').change(function(evt) {
      //handleFileChange(evt, 1);
      var file = evt.target.files[0];
      if (file == null && myFileCaches[1] != null) {
        delete myFileCaches[1];
      } else if (file != null) {
        myFileCaches[1] = {
          file : file,
          contentsType : "sofFile"
        };
      }
    });
    $('#nricFile').change(function(evt) {
      //handleFileChange(evt, 2);
      var file = evt.target.files[0];
      if (file == null && myFileCaches[2] != null) {
        delete myFileCaches[2];
      } else if (file != null) {
        myFileCaches[2] = {
          file : file,
          contentsType : "nricFile"
        };
      }
    });
    $('#otherFile').change(function(evt) {
      //handleFileChange(evt, 3);
      var file = evt.target.files[0];
      if (file == null && myFileCaches[3] != null) {
        delete myFileCaches[3];
      } else if (file != null) {
        myFileCaches[3] = {
          file : file,
          contentsType : "otherFile"
        };
      }
      console.log(myFileCaches);
    });

    $('#otherFile2').change(function(evt) {
      //handleFileChange(evt, 4);
      var file = evt.target.files[0];
      if (file == null && myFileCaches[4] != null) {
        delete myFileCaches[4];
      } else if (file != null) {
        myFileCaches[4] = {
          file : file,
          contentsType : "otherFile2"
        };
      }
      console.log(myFileCaches);
    });

    $('#otherFile3').change(function(evt) {
      //handleFileChange(evt, 5);
      var file = evt.target.files[0];
      if (file == null && myFileCaches[5] != null) {
        delete myFileCaches[5];
      } else if (file != null) {
        myFileCaches[5] = {
          file : file,
          contentsType : "otherFile3"
        };
      }
      console.log(myFileCaches);
    });

    $('#otherFile4').change(function(evt) {
      //handleFileChange(evt, 6);
      var file = evt.target.files[0];
      if (file == null && myFileCaches[6] != null) {
        delete myFileCaches[6];
      } else if (file != null) {
        myFileCaches[6] = {
          file : file,
          contentsType : "otherFile4"
        };
      }
      console.log(myFileCaches);
    });

    $('#otherFile5').change(function(evt) {
      //handleFileChange(evt, 7);
      var file = evt.target.files[0];
      if (file == null && myFileCaches[7] != null) {
        delete myFileCaches[7];
      } else if (file != null) {
        myFileCaches[7] = {
          file : file,
          contentsType : "otherFile5"
        };
      }
      console.log(myFileCaches);
    });

    $('#btnSave').click(function() {
      if (!fn_validCustomer()) {
        $('#aTabCS').click();
        return false;
      }

      if (!fn_validPaymentInfo()) {
        $('#aTabBD').click();
        return false;
      }

      if (!fn_validOrderInfo()) {
        $('#aTabOI').click();
        return false;
      }

      if (!fn_validFile()) {
        $('#aTabFL').click();
        return false;
      }

      if (fn_isExistSupplementSubmissionNo() == 'true')
        return false;

      fn_SaveSupplementSubmission();
    });

  });

  function fn_validConfirm() {
    var isValid = true, msg = "";

    var nric = $('#nric').val();
    var sofNo = $('#sofNo').val();

    if (FormUtil.checkReqValue($('#nric'))) {
      isValid = false;
      msg += "* Please key in NRIC/Company No.<br>";
    } else {
      //check if NRIC is Numeric, else company number (includes alphabet)
      var nric_trim = $("#nric").val().replace(/ |-|_/g, '');
      if ($.isNumeric($("#nric_trim").val())) {
        var dob = Number($('#nric').val().substr(0, 2));
        var nowDt = new Date();
        var nowDtY = Number(nowDt.getFullYear().toString().substr(-2));
        var age = nowDtY - dob < 0 ? nowDtY - dob + 100 : nowDtY - dob;
        if (age < 18) {
          Common.alert('<spring:message code="supplement.text.supplementSubmissionSummary" />'
                  + DEFAULT_DELIMITER
                  + "<b>* Customer must 18 years old and above.</b>");
          $('#scSupplementSubmissionArea').addClass("blind");
          return false;
        }
      }
    }
    if (FormUtil.checkReqValue($('#sofNo'))) {
      isValid = false;
      msg += "* Please key in eSales(SOF) No.<br>";
    } else if ($('#sofNo').val().substring(0, 3) != "FSO") {
      isValid = false;
      msg += "* Please key in <b>FSO</b> at eSOF No";
    }

    if (!isValid)
      Common.alert('<spring:message code="supplement.text.supplementSubmissionSummary" />'
              + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_loadCustomer(custId, nric) {
    Common.ajax( "GET",
                         "/sales/customer/selectCustomerJsonList",
                        { custId : custId, nric : nric },
                        function(result) {
                          Common.removeLoader();

                          if (result.length > 0) {
                            Common.confirm( '<b>* This customer is an existing customer.<br>Do you want to proceed for key-in?</b>',
                            function() {
                              $('#scSupplementSubmissionArea').removeClass("blind");
                              var custInfo = result[0];
                              var dob = custInfo.dob;
                              var dobY = dob.split("/")[2];
                              var nowDt = new Date();
                              var nowDtY = nowDt.getFullYear();
                              if (!nric.startsWith("TST")) {
                                if (dobY != 1900) {
                                  if ((nowDtY - dobY) < 18) {
                                    Common.alert('<spring:message code="supplement.text.supplementSubmissionSummary" />'
                                                     + DEFAULT_DELIMITER
                                                     + "<b>* Customer must 18 years old and above.</b>");
                                    $('#scSupplementSubmissionArea').addClass("blind");
                                    return false;
                                  }
                                }
                              }

                          $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
                          $("#custTypeNm").text(custInfo.codeName1);
                          $("#hiddenCustTypeNm").val(custInfo.codeName1); //Customer Type Nm(Hidden)
                          $("#hiddenTypeId").val(custInfo.typeId); //Type
                          $("#name").text(custInfo.name); //Name
                          $("#nric").val(custInfo.nric); //NRIC/Company No
                          $("#nationNm").text(custInfo.name2); //Nationality
                          $("#race").text(custInfo.codeName2); //
                          $("#dob").text(custInfo.dob == '01/01/1900' ? '' : custInfo.dob); //DOB
                          $("#gender").text(custInfo.gender); //Gender
                          $("#pasSportExpr").text(custInfo.pasSportExpr == '01/01/1900' ? '' : custInfo.pasSportExpr); //Passport Expiry
                          $("#visaExpr").text(custInfo.visaExpr == '01/01/1900' ? '' : custInfo.visaExpr); //Visa Expiry
                          $("#custEmail").val(custInfo.email); //Email
                          $("#pCustEmail").show();
                          fn_maskingData("_CUSTEMAIL", $("#custEmail"));
                          $("#custEmail").text(custInfo.email); //Email
                          $("#hiddenCustStatusId").val(custInfo.custStatusId); //Customer Status
                          $("#custStatus").text(custInfo.custStatus); //Customer Status
                          if (custInfo.receivingMarketingMsgStatus == 1) {
                            $("#marketMessageYes").prop("checked", true);
                          } else {
                            $("#marketMessageNo").prop( "checked", true);
                          }

                          if (custInfo.corpTypeId > 0) {
                            $("#corpTypeNm").val(custInfo.codeName); //Industry Code
                          } else {
                            $("#corpTypeNm").val(""); //Industry Code
                          }

                          if (custInfo.custAddId > 0) {
                            fn_loadBillAddr(custInfo.custAddId);
                            fn_loadInstallAddr(custInfo.custAddId);
                          }

                          if (custInfo.custCntcId > 0) {
                            fn_loadMainCntcPerson(custInfo.custCntcId);
                            fn_loadCntcPerson(custInfo.custCntcId);
                          }

                          if (custInfo.codeName == 'Government') {
                            Common.alert('<b>Goverment Customer</b>');
                          }
                        }, fn_closeNewSubmissionPop);
              } else {
                Common.confirm('<b>* This customer is NEW customer.<br>Do you want to create a customer?</b>',
                                       fn_createCustomerPop,
                                       fn_closeNewSubmissionPop);
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
    }
  }

  function fn_isExistSupplementSubmissionNo() {
    var isExist = false, msg = "";

    Common.ajaxSync("GET",
        "/supplement/selectExistSupplementSubmissionSofNo.do", {
          selType : $('#selType').val(),
          sofNo : $('#sofNo').val().trim()
        }, function(rsltInfo) {

          if (rsltInfo != null) {
            isExist = rsltInfo.isExist;
          }
        });

    if (isExist == 'true')
      Common.alert('<spring:message code="supplement.text.supplementSubmissionSummary" />'
              + DEFAULT_DELIMITER
              + "<b>* The entered eSOF no. ("
              + $('#sofNo').val().trim()
              + ") already exists in Active or Approved status. Submission creation is not allowed.</b>");

    return isExist;
  }

  function fn_closeNewSubmissionPop() {
    $("#btnNewSubmissionClose").click();
  }

  function fn_loadMainCntcPerson(custCntcId) {
    Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", {
      custCntcId : custCntcId
    }, function(custCntcInfo) {
      if (custCntcInfo != null) {
        $("#hiddenCustCntcId").val(custCntcInfo.custCntcId);
        $("#custInitial").text(custCntcInfo.code);
        $("#custEmail").val(custCntcInfo.email);
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
        $("#custCntcExt").text(custCntcInfo.ext);
      }
    });
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
        $("#billStreet").text(billCustInfo.street); //Street
        $("#billArea").text(billCustInfo.area); //Area
        $("#billCity").text(billCustInfo.city); //City
        $("#billPostCode").text(billCustInfo.postcode); //Post Code
        $("#billState").text(billCustInfo.state); //State
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
        $("#instStreet").text(custInfo.street); //Street
        $("#instArea").text(custInfo.area); //Area
        $("#instCity").text(custInfo.city); //City
        $("#instPostCode").text(custInfo.postcode); //Post Code
        $("#instState").text(custInfo.state); //State
        $("#instCountry").text(custInfo.country); //Country
        $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
        if (MEM_TYPE == 2)
          $("#keyinBrnchId").val(custInfo.cdBrnchId); //Posting Branch
        else if (MEM_TYPE == 7)
          $("#keyinBrnchId").val(284); //Posting Branch
        else
          $("#keyinBrnchId").val(custInfo.soBrnchId); //Posting Branch
        if (custInfo.gstChk == '1') {
          $("#gstChk").val('1').prop("disabled", true);
        } else {
          $("#gstChk").val('0').removeAttr("disabled");
        }
      }
    });
  }

  function fn_loadOrderSalesman(memId, memCode) {
    Common.ajax("GET",
                        "/supplement/selectMemberByMemberIDCode.do",
                       { memId : memId, memCode : memCode },
                       function(memInfo) {
                         if (memInfo == null) {
                           Common.alert('<b>Member not found.</br>Your input member code : ' + memCode + '</b>');
                         } else {
                           $('#salesmanCd').val(memInfo.memCode);
                           $('#salesmanNm').val(memInfo.name);
                           $('#hidSalesmanId').val(memInfo.memId);
                           $('#isSuppl').val(memInfo.isSuppl);

                           if (memInfo.isSuppl == 'N' || memInfo.isSuppl == null) {
                             Common.alert('<spring:message code="supplement.alert.memCodeNotEligible" />' + ' - ' + memCode + '</b>');
                             $('#salesmanCd').val('');
                             $('#salesmanNm').val('');
                           } else {
                             Common.ajax("GET", "/supplement/selectMemBrnchByMemberCode.do",
                               { memCode : memInfo.memCode },
                               function(result) {
                                 if (result != null) {
                                  $('#salesmanBrnch').val(result.brnch);
                                  //$('#hidSalesmanBrnchId').val(result.brnchId);
                                } else {
                                  $('#salesmanBrnch').val('');
                                  //$('#hidSalesmanBrnchId').val('');
                                }
                              });
                            }
                         }
    });
  }

  // Define a common function to handle file input changes
  /*   function handleFileChange(evt, cacheIndex) {
   var file = evt.target.files[0];
   if (file == null && myFileCaches[cacheIndex] != null) {
   delete myFileCaches[cacheIndex];
   } else if (file != null) {
   myFileCaches[cacheIndex] = {
   file : file
   };
   }

   var msg = '';
   if (file && file.name.length > 30) {
   msg += "*File name wording should be not more than 30 alphabet.<br>";
   }

   var fileType = file ? file.type.split('/') : [];
   if (fileType[1] != 'jpg' && fileType[1] != 'jpeg'
   && fileType[1] != 'png' && fileType[1] != 'pdf') {
   msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
   }

   if (file && file.size > 2000000) {
   msg += "*Only allow picture with less than 2MB.<br>";
   }

   console.log(myFileCaches);
   if (msg) {
   myFileCaches[cacheIndex].file['checkFileValid'] = false;
   Common.alert(msg);
   } else {
   myFileCaches[cacheIndex].file['checkFileValid'] = true;
   }
   } */

  function fn_removeFile(name) {
    if (name == "NRIC") {
      $("#nricFile").val("");
      $('#nricFile').change();
    } else  if (name == "OTH") {
      $("#otherFile").val("");
      $('#otherFile').change();
    } else if (name == "OTH2") {
      $("#otherFile2").val("");
      $('#otherFile2').change();
    } else if (name == "OTH3") {
      $("#otherFile3").val("");
      $('#otherFile3').change();
    } else if (name == "OTH4") {
      $("#otherFile4").val("");
      $('#otherFile4').change();
    } else if (name == "OTH5") {
      $("#otherFile5").val("");
      $('#otherFile5').change();
    }
  }

  function fn_maskingData(ind, obj) {
    var maskedVal = (obj.val()).substr(-4).padStart((obj.val()).length, '*');
    $("#span" + ind).html(maskedVal);
  }

  function fn_maskingDataAddr(ind, obj) {
    var maskedVal = (obj.val()).substr(-20).padStart((obj.val()).length, '*');
    $("#span" + ind).html(maskedVal);
  }

  function createPurchaseGridID() {
    var posColumnLayout = [ {
      dataField : "stkCode",
      headerText : '<spring:message code="sal.title.itemCode" />',
      width : '10%'
    }, {
      dataField : "stkDesc",
      headerText : '<spring:message code="sal.title.itemDesc" />',
      width : '30%'
    }, {
      dataField : "inputQty",
      headerText : '<spring:message code="sal.title.qty" />',
      width : '10%'
    }, {
      dataField : "amt",
      headerText : '<spring:message code="sal.title.unitPrice" />',
      width : '10%',
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "subTotal",
      headerText : '<spring:message code="sal.title.subTotalExclGST" />',
      width : '15%',
      dataType : "numeric",
      formatString : "#,##0.00",
      expFunction : function(rowIndex, columnIndex, item, dataField) {
        var calObj = fn_calculateAmt(item.amt, item.inputQty);
        return Number(calObj.subChanges);
      }
    }, {
      dataField : "subChng",
      headerText : 'GST(0%)',
      width : '10%',
      dataType : "numeric",
      formatString : "#,##0.00",
      expFunction : function(rowIndex, columnIndex, item, dataField) {
        var calObj = fn_calculateAmt(item.amt, item.inputQty);
        return Number(calObj.taxes);
      }
    }, {
      dataField : "totalAmt",
      headerText : '<spring:message code="sal.text.totAmt" />',
      width : '15%',
      dataType : "numeric",
      formatString : "#,##0.00",
      expFunction : function(rowIndex, columnIndex, item, dataField) {
        var calObj = fn_calculateAmt(item.amt, item.inputQty);
        return Number(calObj.subTotal);
      }
    }, {
      dataField : "stkTypeId",
      visible : false
    }, {
      dataField : "stkId",
      visible : false
    } //STK_ID
    ];

    var gridPros = {
      showFooter : true,
      usePaging : true, //페이징 사용
      pageRowCount : 10, //한 화면에 출력되는 행 개수 20(기본값:20)
      editable : false,
      fixedColumnCount : 1,
      showStateColumn : true,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false, //그룹핑 패널 사용
      skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
      showRowCheckColumn : true, //checkBox
      softRemoveRowMode : false
    };

    purchaseGridID = GridCommon.createAUIGrid("#item_grid_wrap", posColumnLayout, '', gridPros); // address list
    AUIGrid.resize(purchaseGridID, 960, 300);

    var footerLayout = [ {
      labelText : "Total(RM)",
      positionField : "#base"
    }, {
      dataField : "subTotal",
      positionField : "subTotal",
      operation : "SUM",
      formatString : "#,##0.00",
      style : "aui-grid-my-footer-sum-total2"
    }, {
      dataField : "subChng",
      positionField : "subChng",
      operation : "SUM",
      formatString : "#,##0.00",
      style : "aui-grid-my-footer-sum-total2"
    }, {
      dataField : "totalAmt",
      positionField : "totalAmt",
      operation : "SUM",
      formatString : "#,##0.00",
      style : "aui-grid-my-footer-sum-total2"
    } ];
    AUIGrid.setFooter(purchaseGridID, footerLayout);
  }

  function getItemListFromSrchPop(itmList) {
    AUIGrid.setGridData(purchaseGridID, itmList);

  }

  function fn_calcuPurchaseAmt() {
    var totArr = [];
    totArr = AUIGrid.getColumnValues(purchaseGridID, 'totalAmt');

    var totalAmount = 0;
    if (totArr != null && totArr.length > 0) {
      for (var idx = 0; idx < totArr.length; idx++) {
        totalAmount += totArr[idx];
      }
    }
    totalAmount = parseFloat(totalAmount).toFixed(2);

    return totalAmount;
  }

  function fn_calculateAmt(amt, qty) {

    var subTotal = 0;
    var subChanges = 0;
    var taxes = 0;

    subTotal = amt * qty;
    subChanges = (subTotal * 100) / 100;
    subChanges = subChanges.toFixed(2); //소수점2반올림
    taxes = subTotal - subChanges;
    taxes = taxes.toFixed(2);

    var retObj = {
      subTotal : subTotal,
      subChanges : subChanges,
      taxes : taxes
    };

    return retObj;
  }

  var prev = "";
  var regexp = /^\d*(\.\d{0,2})?$/;

  function fn_inputAmt(obj) {

    if (obj.value.search(regexp) == -1) {
      obj.value = prev;
    } else {
      prev = obj.value;
    }
  }

  function fn_validCustomer() {
    var isValid = true, msg = "";
    var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

    if (FormUtil.checkReqValue($('#hiddenCustId'))) {
      isValid = false;
      msg += "* Please select a customer.<br>";
    }

    if (FormUtil.checkReqValue($('#hiddenCustCntcId'))) {
      isValid = false;
      msg += "* Please select a contact person.<br>";
    }

    if (FormUtil.checkReqValue($('#hiddenCustAddId'))) {
      isValid = false;
      msg += "* Please select an installation address.<br>";
    }

    if ($("#email").val() == '') {
      isValid = false;
      msg += "* Please fill in email address.<br>";
    }

    if ((jQuery.trim($("#email").val())).length > 0) {
      if (!regEmail.test($("#email").val())) {
        isValid = false;
        msg += "* Invalid email address format.<br>";
      }
    }

    if (!isValid)
      Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                       + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_validPaymentInfo() {
    var isValid = true, msg = "";

    if (!isValid)
      Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                       + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;

  }

  function fn_validOrderInfo() {
    var isValid = true, msg = "";
    if (AUIGrid.getGridData(purchaseGridID) <= 0) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.selectItms" /><br>';
    }

    if (null == $("#salesmanCd").val() || '' == $("#salesmanCd").val()) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.selectMemCode" /><br>';
    }

    if (null == $("#salesmanBrnch").val() || '' == $("#salesmanBrnch").val()) {
      isValid = false;
      msg += '<spring:message code="sal.alert.msg.memHasNoBrnch" /><br>';
    }

    if ('N' == $("#isSuppl").val() || '' == $("#isSuppl").val()) {
      isValid = false;
      msg += '<spring:message code="supplement.alert.memCodeNotEligible" /><br>';
    }

    if (!isValid)
      Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                       + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_validFile() {
    var isValid = true, msg = "";
    if (FormUtil.isEmpty($('#sofFile').val().trim())) {
      isValid = false;
      msg += '<spring:message code="supplement.alert.uploadSOF" />';
    }
    /*if (FormUtil.isEmpty($('#nricFile').val().trim())) {
      isValid = false;
      msg += '<spring:message code="supplement.alert.uploadNric" />';
    }*/

    $.each(myFileCaches,
              function(i, j) {
                if (myFileCaches[i].file.checkFileValid == false) {
                  isValid = false;
                  msg += myFileCaches[i].file.name
                      + '<spring:message code="supplement.alert.fileUploadFormat" />';
                }
    });

    if (!isValid)
      Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                       + DEFAULT_DELIMITER + "<b>" + msg + "</b>");

    return isValid;
  }

  function fn_SaveSupplementSubmission() {
    var prchParam = AUIGrid.getGridData(purchaseGridID);
    var totAmt = fn_calcuPurchaseAmt();
    var orderVO = {
      sofNo : $('#sofNo').val().trim(),
      custId : $('#hiddenCustId').val(),
      custCntcId : $('#hiddenCustCntcId').val(),
      custAddId : $('#hiddenCustAddId').val(),
      custBillAddId : $("#hiddenBillAddId").val(),
      memId : $('#hidSalesmanId').val(),
      memCode : $('#salesmanCd').val(),
      memBrnchId : $('#salesmanBrnch').val(),
      usrBrnchId : $('#_memBrnch').val(),
      remark : $('#remark').val().replace(/[\r\n]+/g, ' ').replace(/'/g, '"') ,
      totAmt : totAmt,
      atchFileGrpId : atchFileGrpId,
      supplementItmList : prchParam
    };

    var formData = new FormData();
    $.each(myFileCaches, function(n, v) {
      formData.append(n, v.file);
    });

    Common.ajaxFile("/supplement/attachFileUpload.do",
                            formData,
                            function(result) {
                              if (result != 0 && result.code == 00) {
                                orderVO["atchFileGrpId"] = result.data.fileGroupKey;
                                Common.ajax( "POST",
                                                     "/supplement/supplementSubmissionRegister.do",
                                                     orderVO,
                                                     function(result) {
                                                       Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                                                       + DEFAULT_DELIMITER
                                                       + "<b>"
                                                       + result.message
                                                       + "</b>",
                                                       fn_closeSupplementSubmissionPop);
                                                     },
                                                     function(jqXHR, textStatus, errorThrown) {
                                                       try {
                                                         Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
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
                Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                                 + DEFAULT_DELIMITER
                                 + result.message);
              }
            },
            function(result) {
              Common.alert("Upload Failed. Please check with System Administrator.");
            });
  }

  function fn_closeSupplementSubmissionPop() {
    myFileCaches = {};
    $('#btnNewSubmissionClose').click();

    fn_getSupplementSubmissionList();
  }

  function fn_resetSales() {
  }
</script>

<div id="popup_wrap" class="popup_wrap">
  <input type="hidden" id="_memBrnch" value="${userBrnchId}">
   <input type="hidden" name="hidSalesmanBrnchId" id="hidSalesmanBrnchId" value="">
   <input type="hidden" name="isSuppl" id="isSuppl" value="">
   <input type="hidden" name="hidTotAmt" id="hidTotAmt" value="">
   <input type="hidden" name="hidSalesmanId" id="hidSalesmanId" value="">
  <header class="pop_header">
    <h1>
      <spring:message code="supplement.text.newSubmission" />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnNewSubmissionClose" href="#"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>

  <section class="pop_body">
    <aside class="title_line">
      <ul class="right_btns">
        <li>
          <p class="btn_blue">
            <a id="btnConfirm" href="#"><spring:message code="sal.btn.confirm" /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a id="btnClear" href="#"><spring:message code="sal.btn.clear" /></a>
          </p>
        </li>
      </ul>
    </aside>

    <form id="frmCustSearch" name="frmCustSearch" action="#" method="post">
      <input id="selType" name="selType" type="hidden" value="1" />
      <input id="callPrgm" name="callPrgm" type="hidden" value="PRE_ORD" />
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sal.text.nricCompanyNo" /><span class="must">**</span></th>
            <td colspan="3">
              <input id="nric" name="nric" type="text" title="" placeholder="" class="w100p" style="min-width: 150px" value="" />
              <table id="pNric" style="display: none">
                <tr>
                  <td><span id="span_NRIC"></span></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.eSOFno" /><span class="must">**</span></th>
            <td colspan="3">
              <input id="sofNo" name="sofNo" type="text" title="" placeholder="" class="w100p" style="min-width: 150px" value="" maxlength="20" />
              <table id="pSofNo" style="display: none">
                <tr>
                  <td><span id="span_SOFNO"></span></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <th scope="row" colspan="4"><span class="must"><spring:message code='sales.msg.ordlist.icvalid' /></span></th>
          </tr>
        </tbody>
      </table>
    </form>

    <!------------------------------------------------------------------------------
      Supplement Submission Content START
    ------------------------------------------------------------------------------->
    <section id="scSupplementSubmissionArea" class="blind">
      <section class="tap_wrap">
        <ul class="tap_type1 num4">
          <li><a id="aTabCS" class="on"><spring:message code="sal.page.title.custInformation" /></a></li>
          <li><a id="aTabBD"><spring:message code="supplement.text.paymentInfo" /></a></li>
          <li><a id="aTabOI"><spring:message code="supplement.text.supplementInfo" /></a></li>
          <li><a id="aTabFL"><spring:message code="sal.text.attachment" /></a></li>
        </ul>

        <article class="tap_area">
          <section class="search_table">
            <section class="tap_wrap">
              <ul class="tap_type1 num4">
                <li><a id="aTabGI" class="on"><spring:message code="supplement.text.generalInfo" /></a></li>
                <li><a id="aTabCI"><spring:message code="sal.tap.title.contactInfo" /></a></li>
                <li><a id="aTabDI"><spring:message code="supplement.text.deliveryAddressInfo" /></a></li>
              </ul>
              <article class="tap_area">
                <form id="frmNewSubmission" name="frmNewSubmission" action="#" method="post">
                  <input id="hiddenCustId" name="custId" type="hidden" />
                  <input id="hiddenCustTypeNm" name="custTypeNm" type="hidden" />
                  <input id="hiddenTypeId" name="typeId" type="hidden" />
                  <input id="hiddenCustCntcId" name="custCntcId" type="hidden" />
                  <input id="hiddenCustAddId" name="custAddId" type="hidden" />
                  <input id="hiddenCallPrgm" name="callPrgm" type="hidden" />
                  <input id="hiddenCustStatusId" name="hiddenCustStatusId" type="hidden" />

                  <aside class="title_line">
                    <h3>
                      <spring:message code="supplement.text.generalInfo" />
                    </h3>
                  </aside>

                  <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                      <col style="width: 40%" />
                      <col style="width: *" />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.custType" /><span class="must">**</span></th>
                        <td><span id="custTypeNm" name="custTypeNm"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.title.text.companyType" /><span class="must">**</span></th>
                        <td><span id="corpTypeNm" name="corpTypeNm"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.initial" /><span class="must">**</span></th>
                        <td><span id="custInitial" name="custInitial"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.custName" /><span class="must">**</span></th>
                        <td><span id="name" name="name"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.nationality" /></th>
                        <td><span id="nationNm" name="nationNm"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="supplement.text.passportExpiryDate" /></th>
                        <td><span id="pasSportExpr" name="pasSportExpr"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="supplement.text.passportVisaExpiryDate" /></th>
                        <td><span id="visaExpr" name="visaExpr"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.dob" /></th>
                        <td><span id="dob" name="dob"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.race" /></th>
                        <td><span id="race" name="race"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.gender" /></th>
                        <td><span id="gender" name="gender"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.email" /></th>
                        <td>
                          <input id="custEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly style="display: none" />
                          <table id="pCustEmail" style="display: none">
                            <tr>
                              <td><span id="span_CUSTEMAIL"></span></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.custStus" /><span class="must">**</span></th>
                        <td><span id="custStatus" name="custStatus"></span></td>
                      </tr>
                    </tbody>
                  </table>
                </form>
              </article>
              <article class="tap_area">
                <section class="search_table">
                  <aside class="title_line">
                    <h3>
                      <spring:message code="sal.tap.title.contactInfo" />
                    </h3>
                  </aside>
                  <ul class="right_btns mb10">
                    <li>
                      <p class="btn_grid">
                        <a id="btnSelCntc" href="#"><spring:message code="supplement.btn.selectOtherContact" /></a>
                      </p>
                    </li>
                    <li>
                      <p class="btn_grid">
                        <a id="btnNewCntc" href="#"><spring:message code="pay.btn.addNewContact" /></a>
                      </p>
                    </li>
                  </ul>

                  <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                      <col style="width: 40%" />
                      <col style="width: *" />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row"><spring:message code="sal.title.text.contactPersonName" /><span class="must">**</span></th>
                        <td><span id="custCntcName" name="custCntcName"></span>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.mobileNo" /><span class="must">**</span></th>
                        <td>
                          <input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p readonly" readonly style="display: none" />
                          <table id="pCustCntcTelM" style="display: none">
                            <tr>
                              <td><span id="span_CUSTCNTCTELM"></span></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="supplement.text.residenceContactNo" /><span class="must">**</span></th>
                        <td>
                          <input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p readonly" readonly style="display: none" />
                          <table id="pCustCntcTelR" style="display: none">
                            <tr>
                              <td><span id="span_CUSTCNTCTELR"></span></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="supplement.text.officeContactNo" /></th>
                        <td>
                          <input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p readonly" readonly style="display: none" />
                          <table id="pCustCntcTelO" style="display: none">
                            <tr>
                              <td><span id="span_CUSTCNTCTELO"></span></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.faxNo" /></th>
                        <td>
                          <input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p readonly" readonly style="display: none" />
                          <table id="pCustCntcTelF" style="display: none">
                            <tr>
                              <td><span id="span_CUSTCNTCTELF"></span></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.extNo" /></th>
                        <td><span id="custCntcExt" name="custCntcExt"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.email" /><span class="must">**</span></th>
                        <td>
                          <input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p readonly" readonly style="display: none" />
                          <table id="pCntcEmail" style="display: none">
                            <tr>
                              <td><span id="span_CNTCEMAIL"></span></td>
                            </tr>
                          </table></td>
                      </tr>
                    </tbody>
                  </table>
                </section>
              </article>
              <article class="tap_area">
                <section class="search_table">
                  <aside class="title_line">
                    <h3>
                      <spring:message code="supplement.text.deliveryAddressInfo" />
                    </h3>
                  </aside>
                  <ul class="right_btns mb10">
                    <li>
                      <p class="btn_grid">
                        <a id="btnSelInstAddr" href="#"><spring:message code="supplement.btn.selectOtherAddress" /></a>
                      </p>
                    </li>
                    <li>
                      <p class="btn_grid">
                        <a id="btnNewInstAddr" href="#"><spring:message code="supplement.btn.addNewAddress" /></a>
                      </p>
                    </li>
                  </ul>

                  <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                      <col style="width: 40%" />
                      <col style="width: *" />
                      <col style="width: 40%" />
                      <col style="width: *" />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">**</span></th>
                        <td colspan="3">
                          <input id="instAddrDtl" name="instAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly style="display: none" />
                          <table id="pInstAddrDtl" style="display: none">
                            <tr>
                              <td><span id="span_INSTADDRDTL"></span></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.street" /></th>
                        <td colspan="3"><span id="instStreet" name="instStreet"></span>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.area" /><span class="must">**</span></th>
                        <td colspan="3"><span id="instArea" name="instArea"></span>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.city" /><span class="must">**</span></th>
                        <td colspan="3"><span id="instCity" name="instCity"></span>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.postCode" /><span class="must">**</span></th>
                        <td colspan="3"><span id="instPostCode"
                          name="instPostCode"></span></td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.state" /><span class="must">**</span></th>
                        <td colspan="3"><span id="instState" name="instState"></span>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><spring:message code="sal.text.country" /><span class="must">**</span></th>
                        <td colspan="3"><span id="instCountry" name="instCountry"></span></td>
                      </tr>
                    </tbody>
                  </table>
                </section>
              </article>
            </section>
          </section>
        </article>
        <article class="tap_area">
          <section class="search_table">
            <!------------------------------------------------------------------------------
              Billing Address - Form ID(billAddrForm)
            ------------------------------------------------------------------------------->
            <section id="sctBillAddr">
              <input id="hiddenBillAddId" name="custAddId" type="hidden" />
              <input id="hiddenBillStreetId" name="hiddenBillStreetId" type="hidden" />

              <aside class="title_line">
                <h3>
                  <spring:message code="sal.title.billingAddress" />
                </h3>
              </aside>

              <ul class="right_btns mb10">
                <li>
                  <p class="btn_grid">
                    <a id="billSelAddrBtn" href="#"><spring:message code="supplement.btn.selectOtherAddress" /></a>
                  </p>
                </li>
                <li>
                  <p class="btn_grid">
                    <a id="billNewAddrBtn" href="#"><spring:message code="supplement.btn.addNewAddress" /></a>
                  </p>
                </li>
              </ul>

              <table class="type1">
                <caption>table</caption>
                <colgroup>
                  <col style="width: 40%" />
                  <col style="width: *" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">**</span></th>
                    <td><input id="billAddrDtl" name="billAddrDtl" type="text" title="" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p readonly" readonly style="display: none" />
                      <table id="pBillAddrDtl" style="display: none">
                        <tr>
                          <td><span id="span_BILLADDRDTL"></span></td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.street" /></th>
                    <td><span id="billStreet" name="billStreet"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.area" /><span
                      class="must">**</span></th>
                    <td><span id="billArea" name="billArea"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.city" /><span
                      class="must">**</span></th>
                    <td><span id="billCity" name="billCity"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.postCode" /><span
                      class="must">**</span></th>
                    <td><span id="billPostCode" name="billPostCode"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.state" /><span
                      class="must">**</span></th>
                    <td><span id="billState" name="billState"></span></td>
                  </tr>
                  <tr>
                    <th scope="row"><spring:message code="sal.text.country" /><span
                      class="must">**</span></th>
                    <td><span id="billCountry" name="billCountry"></span></td>
                  </tr>
                </tbody>
              </table>
            </section>
          </section>
        </article>
        <article class="tap_area">
          <section class="search_table">
            <aside class="title_line">
              <h3>
                <spring:message code="supplement.text.supplementInfo" />
              </h3>
            </aside>
            <table class="type1">
              <caption>table</caption>
              <colgroup>
                <col style="width: 40%" />
                <col style="width: *" />
              </colgroup>
              <tr>
                <th scope="row"><spring:message code="sal.text.salManCode" /><span class="must">**</span></th>
                <td>
                  <input id="salesmanCd" name="salesmanCd" type="text" style="width: 230px;" title="" placeholder="" class="" />
                  <a id="memBtn" href="#" class="search_btn"> <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
                <td>
                  <p>
                    <input id="salesmanNm" name="salesmanNm" type="text" style="width: 250px;" class="" title="" placeholder="Salesman Name" disabled="disabled">
                  </p>
                </td>
              </tr>
              <%-- <tr>
                <th scope="row"><spring:message code="supplement.text.submissionBranch"/></th>
                <td><select  id="_cmbWhBrnchIdPop" name="cmbWhBrnchIdPop" class="w100p"></select></td>
                <td style="padding-left:0"><input type="text" disabled="disabled" id="cmbWhIdPop"  value="${locMap.whLocDesc}" class="w100p"></td>
              </tr> --%>
              <tr>
                <th scope="row"><spring:message code="supplement.text.submissionBranch" /><span class="must">**</span></th>
               <!-- <td colspan="2"><span id="salesmanBrnch" name="salesmanBrnch"></span></td> -->
                  <td colspan="2"><select  id="salesmanBrnch" name="salesmanBrnch" class="w100p"></select></td>
              </tr>
              <tr>
                <th scope="row"><spring:message code="sal.title.remark" /></th>
                <td colspan="2">
                  <!-- <input type="text" title="" placeholder="" class="w100p" id="_remark" name="_remark" maxlength = "50" /> -->
                  <textarea id="remark" name="remark" cols="20" rows="5"></textarea>
                </td>
              </tr>
            </table>
            <aside class="title_line">
              <h2>
                <spring:message code="sal.title.text.purchItems" />
              </h2>
            </aside>

            <ul class="right_btns">
              <li><p class="btn_grid">
                  <a id="_addBtn"><spring:message code="supplement.btn.addItemSelection" /></a>
                </p></li>
              <li><p class="btn_grid">
                  <a id="_delBtn"><spring:message code="sal.btn.del" /></a>
                </p></li>
            </ul>

            <article class="grid_wrap">
              <div id="item_grid_wrap"
                style="width: 100%; height: 300px; margin: 0 auto;"></div>
            </article>
          </section>
        </article>
        <article class="tap_area">
          <section class="search_table">
            <aside class="title_line">
              <h3>
                <spring:message code="sal.text.attachment" />
              </h3>
            </aside>
            <table class="type1">
              <caption>table</caption>
              <colgroup>
                <col style="width: 30%" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row"><spring:message code="supplement.text.eSofForm" /><span class="must">**</span></th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="sofFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' /> <span class='label_text'><a href='#'><spring:message code="sys.btn.upload" /></a></span>
                      </label>
                    </div>
                  </td>
                </tr>

                <!-- <tr>
                  <th scope="row"><spring:message code="supplement.text.photocopyOfNric" /><span class="must">**</span></th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="nricFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' /> <span class='label_text'> <a href='#'><spring:message code="sys.btn.upload" /></a></span> <span class='label_text'></span>
                      </label>
                    </div>
                  </td>
                </tr> -->

                <tr>
                  <th scope="row"><spring:message code="supplement.text.photocopyOfNric" /></th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="nricFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'> <a href='#'><spring:message code="sys.btn.upload" /></a></span> <span class='label_text'> <a href='#' onclick='fn_removeFile("NRIC")'><spring:message code="sys.btn.remove" /></a></span>
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message code="supplement.text.other" />1</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'> <a href='#'><spring:message code="sys.btn.upload" /></a></span> <span class='label_text'> <a href='#' onclick='fn_removeFile("OTH")'><spring:message code="sys.btn.remove" /></a></span>
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message code="supplement.text.other" />2</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile2" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'> <a href='#'><spring:message code="sys.btn.upload" /></a></span> <span class='label_text'> <a href='#' onclick='fn_removeFile("OTH2")'><spring:message code="sys.btn.remove" /></a></span>
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message code="supplement.text.other" />3</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile3" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'> <a href='#'><spring:message code="sys.btn.upload" /></a></span> <span class='label_text'> <a href='#' onclick='fn_removeFile("OTH3")'><spring:message code="sys.btn.remove" /></a></span>
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message code="supplement.text.other" />4</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile4" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'> <a href='#'><spring:message code="sys.btn.upload" /></a></span> <span class='label_text'> <a href='#' onclick='fn_removeFile("OTH4")'><spring:message  code="sys.btn.remove" /></a></span>
                      </label>
                    </div>
                  </td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code="supplement.text.other" />5</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile5" accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label>
                        <input type='text' class='input_text' readonly='readonly' />
                        <span class='label_text'> <a href='#'><spring:message code="sys.btn.upload" /></a></span> <span class='label_text'> <a href='#' onclick='fn_removeFile("OTH5")'><spring:message code="sys.btn.remove" /></a></span>
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <td colspan=2><span class="red_text"><spring:message code="supplement.text.picFormatNotice" /> </span></td>
                </tr>
              </tbody>
            </table>
          </section>
        </article>
      </section>

      <ul class="center_btns mt20">
        <li>
          <p class="btn_blue2 big">
            <a id="btnSave" href="#"><spring:message code="sys.btn.save" /></a>
          </p>
        </li>
      </ul>
    </section>
    <!------------------------------------------------------------------------------
      Supplement Submission Content END
    ------------------------------------------------------------------------------->
  </section>
</div>
