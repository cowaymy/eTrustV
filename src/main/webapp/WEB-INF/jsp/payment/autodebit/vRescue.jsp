<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //AUIGrid 그리드 객체
  var myGridID, updResultGridID, smsGridID;

  //Grid에서 선택된 RowID
  var selectedGridValue;

  // Empty Set
  var emptyData = [];

  var subPath = "/resources/WebShare/CRT";

  // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
  $(document)
      .ready(
          function() {
            // CLAIM TYPE
            doGetComboCodeId('/payment/selectVResListing.do', {
              ind : 'CLM_TYP'
            }, '', 'claimType', 'S', '');
            // STATUS
            doGetComboCodeId('/payment/selectClmStat.do', '', '',
                'status', 'S', '');
            // DEDUCTION CHANNEL
            doDefCombo(emptyData, '', 'ddtChnl', 'S', '');
            // ISSUE BANK
            doDefCombo(emptyData, '', 'issueBank', 'S', '');
            // SMS SEND
            doGetComboCodeId('/payment/selectListing.do', {
              ind : 'Y_N'
            }, '', 'smsSend', 'S', '');

            //New Result 팝업 페이지
            doGetComboCodeId('/payment/selectVResListing.do', {
              ind : 'CLM_TYP'
            }, '', 'new_claimType', 'S', '');
            //doDefCombo(claimDayData, '', 'new_claimDay', 'S', ''); //Claim Day 생성
            doGetComboCodeId('/payment/selectListing.do', {
              ind : 'CLM_DY'
            }, '', 'new_claimDay', 'S', '');


            //Claim Type Combo 변경시 Issue Bank Combo 변경
            $('#claimType')
                .change(
                    function() {
                      if ($(this).val() == 132) {
                        $('#issueBank').val('');
                        $('#issueBank').attr(
                            "disabled", false);

                        $('#ddtChnl').val('');
                        $('#ddtChnl').attr("disabled",
                            false);

                        // LOAD DEDUCTION CHANNEL LISTING
                        doGetComboCodeId(
                            '/sales/customer/selectDdlChnl.do',
                            {
                              isAllowForDd : '1'
                            }, '', 'ddtChnl', 'S',
                            '');
                      } else {
                        $('#issueBank').val('');
                        $('#issueBank').attr(
                            "disabled", true);

                        $('#ddtChnl').val('');
                        $('#ddtChnl').attr("disabled",
                            true);
                      }
                    });

            $('#ddtChnl')
                .change(
                    function() {
                      if ($('#ddtChnl').val() != "") {

                        if ($('#ddtChnl').val() == 3182) {
                          doGetComboCodeId(
                              '/payment/selectAccBank.do',
                              {
                                isAllowForDd : '1',
                                ddlChnl : $(
                                    '#ddtChnl')
                                    .val()
                              }, '', 'issueBank',
                              'S', '');
                        } else {

                          $('#issueBank option')
                              .remove();

                          doGetComboCodeId(
                              '/payment/selectListing.do',
                              {
                                ind : 'CLM_GENBNK'
                              }, '', 'issueBank',
                              'S', '');
                        }
                      } else {
                        $('#issueBank option').remove();

                        doDefCombo(emptyData, '',
                            'issueBank', 'S', '');
                      }
                    });

            //Pop-Up Claim Type Combo 변경시 Claim Day, Issue Bank Combo 변경
            $('#new_claimType')
                .change(
                    function() {

                      $('#new_claimDay').val('');
                      $('#new_ddtChnl').val('');
                      $('#new_issueBank').val('');
                      $('#new_merchantBank').val('');
                      $('#new_cardType').val('');
                      $('#new_claimDay').attr("disabled",
                          true);
                      $('#new_ddtChnl').attr("disabled",
                          true);
                      $('#new_issueBank').attr(
                          "disabled", true);
                      $('#new_merchantBank').attr(
                              "disabled", true);
                      $('#new_cardType').attr("disabled",
                          true);
                      $('#new_debitDate')
                          .attr("placeholder",
                              "Debit Date");

                      //NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
                      $("#claimDayMust").hide();
                      $("#issueBankMust").hide();
                      $("#merchantBankMust").hide();
                      $("#cardTypeMust").hide();
                      $("#ddtChnlMust").hide();

                      if ($(this).val() == 131
                          || $(this).val() == 134) {
                        $('#new_claimDay').attr(
                            "disabled", false);
                        $("#claimDayMust").show();

                        if ($(this).val() == 131) {
                          $('#new_debitDate')
                              .attr(
                                  "placeholder",
                                  "Debit Date (Same Day)");
                          $('#new_cardType').attr(
                              "disabled", false);
                          $("#cardTypeMust").show();
                          $('#new_issueBank').attr(
                              "disabled", false);
                          $('#new_merchantBank').attr(
                              "disabled", false);
                          $("#issueBankMust").show();
                          $("#merchantBankMust").show();
                          $("#ddtChnlMust").show();

                          doGetComboCodeId(
                              '/payment/selectListing.do',
                              {
                                ind : 'CLM_CRCBNK'
                              }, '',
                              'new_issueBank',
                              'S', '');

                          CommonCombo.make('new_merchantBank', '/sales/order/getBankCodeList', '' , '', {type: 'M', isCheckAll: false});

                          doGetComboCodeId(
                              '/payment/selectListing.do',
                              {
                                ind : 'CRD_TYP'
                              }, '',
                              'new_cardType',
                              'S', '');
                        }
                      } else {
                        doDefCombo(emptyData, '',
                            'new_issueBank', 'S',
                            '');

                        CommonCombo.make('new_merchantBank', '', '' , '', {type: 'M', isCheckAll: false});

                        // LOAD DEDUCTION CHANNEL LISTING
                        doGetComboCodeId(
                            '/sales/customer/selectDdlChnl.do',
                            {
                              isAllowForDd : '1'
                            }, '', 'new_ddtChnl',
                            'S', '');
                        $('#new_issueBank').attr(
                            "disabled", false);
                        $('#new_merchantBank').attr(
                            "disabled", false);
                        $('#new_ddtChnl').attr(
                            "disabled", false);
                        $("#issueBankMust").show();
                        $("#merchantBankMust").show();
                        $("#ddtChnlMust").show();
                      }

                    });

            $('#new_ddtChnl')
                .change(
                    function() {
                      if ($(this).val() != '') {
                        if ($(this).val() == 3182) {
                          doGetComboCodeId(
                              '/payment/selectAccBank.do',
                              {
                                isAllowForDd : '1',
                                ddlChnl : $(
                                    '#new_ddtChnl')
                                    .val()
                              }, '',
                              'new_issueBank',
                              'S', '');
                        } else {
                          $('#issueBank option')
                              .remove();

                          doGetComboCodeId(
                              '/payment/selectListing.do',
                              {
                                ind : 'CLM_GENBNK'
                              }, '',
                              'new_issueBank',
                              'S', '');
                        }
                      } else {
                        $('#issueBank option').remove();

                        doDefCombo(emptyData, '',
                            'new_issueBank', 'S',
                            '');
                      }

                    });

            //Pop-Up Issue Combo 변경시
            $('#new_issueBank')
                .change(
                    function() {

                      if ($('#new_claimType').val() != 131) {
                        $('#new_debitDate').attr(
                            "placeholder",
                            "Debit Date");

                        switch ($(this).val()) {
                        case "2":
                          $('#new_debitDate')
                              .attr(
                                  "placeholder",
                                  "Debit Date (+1 Day Send Same Day)");
                          break;
                        case "3":
                        case "6":
                          $('#new_debitDate')
                              .attr(
                                  "placeholder",
                                  "Debit Date (Same Day)");
                          break;
                        case "7":
                        case "9":
                        case "21":
                          $('#new_debitDate')
                              .attr(
                                  "placeholder",
                                  "Debit Date (+1 Days)");
                          break;
                        default:
                          break;
                        }
                      }
                    });

            //Grid Properties 설정
            var gridPros = {
              editable : false, // 편집 가능 여부 (기본값 : false)
              showStateColumn : false, // 상태 칼럼 사용
              softRemoveRowMode : false
            };

            // Order 정보 (Master Grid) 그리드 생성
            myGridID = GridCommon.createAUIGrid("grid_wrap",
                columnLayout, null, gridPros);
            updResultGridID = GridCommon.createAUIGrid(
                "updResult_grid_wrap", updResultColLayout,
                null, gridPros);
            smsGridID = GridCommon.createAUIGrid("sms_grid_wrap",
                smsColLayout, null, gridPros);

            // Master Grid 셀 클릭시 이벤트
            AUIGrid.bind(myGridID, "cellClick", function(event) {
              selectedGridValue = event.rowIndex;
            });

            // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
            function checkHTML5Brower() {
              var isCompatible = false;
              if (window.File && window.FileReader
                  && window.FileList && window.Blob) {
                isCompatible = true;
              }
              return isCompatible;
            }
            ;

          });

  // AUIGrid 칼럼 설정
  var columnLayout = [
      {
        dataField : "ctrlId",
        headerText : "<spring:message code='pay.head.batchId'/>",
        width : 120,
        editable : false
      },
      {
        dataField : "stusCode",
        headerText : "<spring:message code='pay.head.status'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "ctrlIsCrcName",
        headerText : "<spring:message code='pay.head.type'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "ddtChnl",
        headerText : "<spring:message code='pay.head.ddtChnl'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "ctrlDdtChl",
        headerText : "<spring:message code='pay.head.ddtChnl'/>",
        width : 100,
        visible : false,
        editable : false
      },
      {
        dataField : "bankCode",
        headerText : "<spring:message code='pay.head.issueBank'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "ctrlBatchDt",
        headerText : "<spring:message code='pay.head.debitDate'/>",
        width : 120,
        editable : false
      },
      {
        dataField : "ctrlTotItm",
        headerText : "<spring:message code='pay.head.totalItem'/>",
        width : 120,
        editable : false
      },
      {
        dataField : "ctrlBillAmt",
        headerText : "<spring:message code='pay.head.targetAmt'/>",
        width : 120,
        editable : false,
        dataType : "numeric",
        formatString : "#,##0.00"
      },
      {
        dataField : "ctrlBillPayAmt",
        headerText : "<spring:message code='pay.head.receiveAmt'/>",
        width : 120,
        editable : false,
        dataType : "numeric",
        formatString : "#,##0.00"
      },
      {
        dataField : "crtDt",
        headerText : "<spring:message code='pay.head.createDate'/>",
        width : 200,
        editable : false
      },
      {
        dataField : "crtUserName",
        headerText : "<spring:message code='pay.head.creator'/>",
        width : 150,
        editable : false
      },
      {
        dataField : "ctrlFailSmsIsPump",
        headerText : "<spring:message code='pay.head.sms'/>",
        width : 100,
        editable : false,
        labelFunction : function(rowIndex, columnIndex, value,
            headerText, item, dataField) {
          var myString = "";

          if (value == 1) {
            myString = "Yes";
          } else {
            myString = "No";
          }
          return myString;
        }
      }, {
        dataField : "ctrlWaitSync",
        headerText : "<spring:message code='pay.head.waitSync'/>",
        width : 100,
        editable : false,
        renderer : {
          type : "CheckBoxEditRenderer",
          checkValue : "1",
          unCheckValue : "0"
        }
      }, {
        dataField : "ctrlStusId",
        headerText : "<spring:message code='pay.head.statusId'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "stusName",
        headerText : "<spring:message code='pay.head.statusName'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "crtUserName",
        headerText : "<spring:message code='pay.head.creatorName'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "bankName",
        headerText : "<spring:message code='pay.head.bankName'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "updDt",
        headerText : "<spring:message code='pay.head.updateDate'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "ctrlTotSucces",
        headerText : "<spring:message code='pay.head.success'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "ctrlTotFail",
        headerText : "<spring:message code='pay.head.fail'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "ctrlIsCrc",
        headerText : "<spring:message code='pay.head.ctrlIsCrc'/>",
        width : 120,
        visible : false,
        editable : false
      }, {
        dataField : "bankId",
        headerText : "<spring:message code='pay.head.bankId'/>",
        width : 120,
        visible : false,
        editable : false
      }, ];

  var updResultColLayout = [ {
    dataField : "0",
    headerText : "<spring:message code='pay.head.refNo'/>",
    editable : true
  }, {
    dataField : "1",
    headerText : "<spring:message code='pay.head.refCode'/>",
    editable : true
  }, {
    dataField : "2",
    headerText : "<spring:message code='pay.head.itemId'/>",
    editable : true
  } ];

  var smsColLayout = [ {
    dataField : "bankDtlApprCode",
    headerText : "<spring:message code='pay.head.approvalCode'/>",
    width : 150,
    editable : false
  }, {
    dataField : "salesOrdNo",
    headerText : "<spring:message code='pay.head.orderNo'/>",
    width : 150,
    editable : false
  }, {
    dataField : "bankDtlDrAccNo",
    headerText : "<spring:message code='pay.head.accountNo'/>",
    width : 150,
    editable : false
  }, {
    dataField : "bankDtlDrName",
    headerText : "<spring:message code='pay.head.name'/>",
    width : 150,
    editable : false
  }, {
    dataField : "bankDtlDrNric",
    headerText : "<spring:message code='pay.head.nric'/>",
    width : 150,
    editable : false
  }, {
    dataField : "bankDtlAmt",
    headerText : "<spring:message code='pay.head.claimAmt'/>",
    width : 150,
    editable : false
  }, {
    dataField : "bankDtlRenAmt",
    headerText : "<spring:message code='pay.head.rentAmt'/>",
    width : 150,
    editable : false
  }, {
    dataField : "bankDtlRptAmt",
    headerText : "<spring:message code='pay.head.penaltyAmt'/>",
    width : 150,
    editable : false
  } ];

  // 리스트 조회.
  function fn_getClaimListAjax() {
    Common.ajax("GET", "/payment/selectVResClaimList", $("#searchForm")
        .serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  //View Claim Pop-UP
  function fn_openDivPop(val) {

    if (val == "VIEW" || val == "RESULT" || val == "RESULTNEXT"
        || val == "FILE" ) {

      var selectedItem = AUIGrid.getSelectedIndex(myGridID);

      if (selectedItem[0] > -1) {

        var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue,
            "ctrlId");
        var ctrlStusId = AUIGrid.getCellValue(myGridID,
            selectedGridValue, "ctrlStusId");
        var stusName = AUIGrid.getCellValue(myGridID,
            selectedGridValue, "stusName");
        var smsSend = AUIGrid.getCellValue(myGridID, selectedGridValue,
            "ctrlFailSmsIsPump");
        var type = AUIGrid.getCellValue(myGridID, selectedGridValue,
        "ctrlIsCrcName");

        if ((val == "RESULT" || val == "RESULTNEXT") && ctrlStusId != 1) {
          Common
              .alert("<spring:message code='pay.alert.claimResult' arguments='"+ctrlId+" ; "+stusName+"' htmlEscape='false' argumentSeparator=';' />");
        } else if (val == "FILE" && ctrlStusId != 1) {
          Common
              .alert("<spring:message code='pay.alert.claimFile' arguments='"+ctrlId+" ; "+stusName+"' htmlEscape='false' argumentSeparator=';' />");
        } else {

          $('#sms_grid_wrap').hide();

          Common.ajax("GET", "/payment/selectVResClaimMasterById.do", {
            "batchId" : ctrlId
          }, function(result) {
            $("#view_wrap").show();
            $("#new_wrap").hide();

            $("#view_batchId").text(result.ctrlId);
            $("#view_status").text(result.stusName);
            $("#view_type").text(result.ctrlIsCrcName);
            $("#view_creator").text(result.crtUserName);
            $("#view_ddtChnl").text(result.ddtChnl);
            $("#view_issueBank").text(
                result.bankCode + ' - ' + result.bankName);
            $("#view_createDt").text(result.crtDt);
            $("#view_totalItem").text(result.ctrlTotItm);
            $("#view_debitDate").text(result.ctrlBatchDt);
            $("#view_targetAmount").text(result.ctrlBillAmt);
            $("#view_updator").text(result.crtUserName);
            $("#view_receiveAmount").text(result.ctrlBillPayAmt);
            $("#view_updateDate").text(result.updDt);
            $("#view_totalSuccess").text(result.ctrlTotSucces);
            $("#view_totalFail").text(result.ctrlTotFail);
          });


        }

        //팝업 헤더 TEXT 및 버튼 설정
        if (val == "VIEW") {
          $('#pop_header h1').text(
              "<spring:message code='pay.title.vwClm'/>");
          $('#center_btns1').hide();
          $('#center_btns2').hide();
          $('#center_btns3').hide();
          $('#center_btns4').hide();
          if(type == "Credit Card"){
        	  $('#center_btns5').show();
          }
          else{
        	  $('#center_btns5').hide();
          }


        } else if (val == "RESULT") {
          $('#pop_header h1').text(
              "<spring:message code='pay.title.clmRst'/>");
          $('#center_btns1').show();
          $('#center_btns2').hide();
          $('#center_btns3').hide();
          $('#center_btns4').hide();
          $('#center_btns5').hide();

        } else if (val == "RESULTNEXT") {
          $('#pop_header h1').text(
              "<spring:message code='pay.title.clmRstNxtDay'/>");
          $('#center_btns1').hide();
          $('#center_btns2').show();
          $('#center_btns3').hide();
          $('#center_btns4').hide();
          $('#center_btns5').hide();

        } else if (val == "FILE") {
          $('#pop_header h1').text(
              "<spring:message code='pay.title.clmFileGen'/>");
          $('#center_btns1').hide();
          $('#center_btns2').hide();
          $('#center_btns3').show();
          $('#center_btns4').hide();
          $('#center_btns5').hide();

        } else if (val == "SMS") {
          $('#pop_header h1').text(
              "<spring:message code='pay.title.failDdtSms'/>");
          $('#center_btns1').hide();
          $('#center_btns2').hide();
          $('#center_btns3').hide();
          $('#center_btns4').show();
          $('#center_btns5').hide();
        }

      } else {
        Common.alert("<spring:message code='pay.alert.noClaim'/>");
      }
    } else {
      $("#view_wrap").hide();
      $("#new_wrap").show();

      //NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
      $("#newForm")[0].reset();
      $("#claimDayMust").hide();
      $("#issueBankMust").hide();
      $("#merchantBankMust").hide();
      $("#cardTypeMust").hide();
      $("#ddtChnlMust").hide();
    }
  }

  //Layer close
  hideViewPopup = function(val) {
    //AUIGrid.destroy(updResultGridID);
    //AUIGrid.destroy(smsGridID);
    $('#sms_grid_wrap').hide();
    $(val).hide();
  }

  // Pop-UP 에서 Deactivate 처리
  function fn_deactivate() {
    Common
        .confirm(
            "<spring:message code='pay.alert.deactivateBatch'/>",
            function() {
              var ctrlId = AUIGrid.getCellValue(myGridID,
                  selectedGridValue, "ctrlId");

              Common
                  .ajax(
                      "GET",
                      "/payment/updateDeactivate.do",
                      {
                        "ctrlId" : ctrlId
                      },
                      function(result) {
                        Common
                            .alert(
                                "<spring:message code='pay.alert.deactivateSuccess'/>",
                                "fn_openDivPop('VIEW')");

                      },
                      function(result) {
                        Common
                            .alert("<spring:message code='pay.alert.deactivateFail'/>");
                      });
            });
  }



  var updateResultItemKind = ""; //claim result update시 구분 (LIVE :current / NEXT : batch)

  //Pop-UP 에서 Update Result 버튼 클릭시 팝업창 생성
  function fn_updateResult(val) {
    updateResultItemKind = val;
    $("#updResult_wrap").show();
  }

  function fn_uploadFile() {

    var ctrlId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "ctrlId");
    var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue,
        "ctrlIsCrc");
    var bankId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "bankId");
    var bankCode = AUIGrid
    .getCellValue(myGridID, selectedGridValue, "bankCode");

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("ctrlId", ctrlId);
    formData.append("ctrlIsCrc", ctrlIsCrc);
    formData.append("bankId", bankId);
    formData.append("ddtChnl", ddtChnl);
    formData.append("bankCode", bankCode);

    Common
        .ajaxFile(
            "/payment/updateClaimResultItemBulk.do",
            formData,
            function(result) {
              resetUpdatedItems(); // 초기화

              var message = "";
              message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
            result.data.totalItem+" ; "+
            result.data.totalSuccess+" ; "+
            result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

              Common
                  .confirm(
                      message,
                      function() {
                        var ctrlId = AUIGrid
                            .getCellValue(
                                myGridID,
                                selectedGridValue,
                                "ctrlId");

                        //param data array
                        var data = {};
                        data.form = [ {
                          "ctrlId" : ctrlId,
                          "ctrlIsCrc" : ctrlIsCrc,
                          "bankId" : bankId,
                          "ddtChnl" : ddtChnl
                        } ];

                        //CALIM RESULT UPDATE
                        if (updateResultItemKind == 'LIVE') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateClaimResultLive.do",
                                  data,
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateFail'/>");
                                  });
                        }

                        //CALIM RESULT UPDATE NEXT DAY
                        if (updateResultItemKind == 'NEXT') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateClaimResultNextDay.do",
                                  data,
                                  function(
                                      result) {
                                    var resultMsg = "";
                                    resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

                                    Common
                                        .alert(resultMsg);
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
                                  });
                        }
                      });
            }, function(jqXHR, textStatus, errorThrown) {
              try {
                console.log("status : " + jqXHR.status);
                console
                    .log("code : "
                        + jqXHR.responseJSON.code);
                console.log("message : "
                    + jqXHR.responseJSON.message);
                console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
              } catch (e) {
                console.log(e);
              }
              Common
                  .alert("Fail : "
                      + jqXHR.responseJSON.message);
            });

  }

  function fn_uploadFile3() {

    var ctrlId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "ctrlId");
    var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue,
        "ctrlIsCrc");
    var bankId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "bankId");

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("ctrlId", ctrlId);
    formData.append("ctrlIsCrc", ctrlIsCrc);
    formData.append("bankId", bankId);
    formData.append("ddtChnl", ddtChnl);

    Common
        .ajaxFile(
            "/payment/updateClaimResultItemBulk3.do",
            formData,
            function(result) {
              resetUpdatedItems(); // 초기화

              var message = "";
              message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
            result.data.totalItem+" ; "+
            result.data.totalSuccess+" ; "+
            result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

              Common
                  .confirm(
                      message,
                      function() {
                        var ctrlId = AUIGrid
                            .getCellValue(
                                myGridID,
                                selectedGridValue,
                                "ctrlId");

                        //param data array
                        var data = {};
                        data.form = [ {
                          "ctrlId" : ctrlId,
                          "ctrlIsCrc" : ctrlIsCrc,
                          "bankId" : bankId,
                          "ddtChnl" : ddtChnl
                        } ];

                        //CALIM RESULT UPDATE
                        if (updateResultItemKind == 'LIVE') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateClaimResultLive.do",
                                  data,
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateFail'/>");
                                  });
                        }

                        //CALIM RESULT UPDATE NEXT DAY
                        if (updateResultItemKind == 'NEXT') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateClaimResultNextDay.do",
                                  data,
                                  function(
                                      result) {
                                    var resultMsg = "";
                                    resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

                                    Common
                                        .alert(resultMsg);
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
                                  });
                        }
                      });
            }, function(jqXHR, textStatus, errorThrown) {
              try {
                console.log("status : " + jqXHR.status);
                console
                    .log("code : "
                        + jqXHR.responseJSON.code);
                console.log("message : "
                    + jqXHR.responseJSON.message);
                console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
              } catch (e) {
                console.log(e);
              }
              Common
                  .alert("Fail : "
                      + jqXHR.responseJSON.message);
            });

  }

  function fn_uploadFile4() {

    var ctrlId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "ctrlId");
    var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue,
        "ctrlIsCrc");
    var bankId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "bankId");
    var ddtChnl = AUIGrid
    .getCellValue(myGridID, selectedGridValue, "ctrlDdtChl");
    var bankCode = AUIGrid
    .getCellValue(myGridID, selectedGridValue, "bankCode");

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("ctrlId", ctrlId);
    formData.append("ctrlIsCrc", ctrlIsCrc);
    formData.append("bankId", bankId);
    formData.append("ddtChnl", ddtChnl);
    formData.append("bankCode", bankCode);

    Common
        .ajaxFile(
            "/payment/updateClaimResultItemBulk4.do",
            formData,
            function(result) {
              resetUpdatedItems(); // 초기화

              var message = "";
              message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
            result.data.totalItem+" ; "+
            result.data.totalSuccess+" ; "+
            result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

              Common
                  .confirm(
                      message,
                      function() {
                        var ctrlId = AUIGrid
                            .getCellValue(
                                myGridID,
                                selectedGridValue,
                                "ctrlId");

                        //param data array
                        var data = {};
                        data.form = [ {
                          "ctrlId" : ctrlId,
                          "ctrlIsCrc" : ctrlIsCrc,
                          "bankId" : bankId,
                          "ddtChnl" : ddtChnl
                        } ];

                        //CALIM RESULT UPDATE
                        if (updateResultItemKind == 'LIVE' && ctrlIsCrc == '1') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateCreditCardResultLive.do",
                                  data,
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateFail'/>");
                                  });
                        }

                        if (updateResultItemKind == 'LIVE' && ctrlIsCrc == '0') {
                            Common
                                .ajax(
                                    "POST",
                                    "/payment/updateClaimResultLive.do",
                                    data,
                                    function(
                                        result) {
                                      Common
                                          .alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
                                    },
                                    function(
                                        result) {
                                      Common
                                          .alert("<spring:message code='pay.alert.claimUpdateFail'/>");
                                    });
                          }

                        //CALIM RESULT UPDATE NEXT DAY
                        if (updateResultItemKind == 'NEXT') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateClaimResultNextDay.do",
                                  data,
                                  function(
                                      result) {
                                    var resultMsg = "";
                                    resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

                                    Common
                                        .alert(resultMsg);
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
                                  });
                        }
                      });
            }, function(jqXHR, textStatus, errorThrown) {
              try {
                console.log("status : " + jqXHR.status);
                console
                    .log("code : "
                        + jqXHR.responseJSON.code);
                console.log("message : "
                    + jqXHR.responseJSON.message);
                console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
              } catch (e) {
                console.log(e);
              }
              Common
                  .alert("Fail : "
                      + jqXHR.responseJSON.message);
            });

  }

  //Result Update Pop-UP 에서 Upload 버튼 클릭시 처리
  function fn_resultFileUp() {

    var ctrlId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "ctrlId");
    var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue,
        "ctrlIsCrc");
    var bankId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "bankId");

    //param data array
    var data = {};
    var gridList = AUIGrid.getGridData(updResultGridID); //그리드 데이터

    //array에 담기
    if (gridList.length > 0) {
      data.all = gridList;
    } else {
      Common
          .alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
      return;
      //data.all = [];
    }

    //form객체 담기
    data.form = [ {
      "ctrlId" : ctrlId,
      "ctrlIsCrc" : ctrlIsCrc,
      "bankId" : bankId
    } ];

    //Ajax 호출
    Common
        .ajax(
            "POST",
            "/payment/updateClaimResultItem.do",
            data,
            function(result) {
              resetUpdatedItems(); // 초기화

              var message = "";
              message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
        result.data.totalItem+" ; "+
        result.data.totalSuccess+" ; "+
        result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

              Common
                  .confirm(
                      message,
                      function() {
                        var ctrlId = AUIGrid
                            .getCellValue(
                                myGridID,
                                selectedGridValue,
                                "ctrlId");

                        //param data array
                        var data = {};
                        data.form = [ {
                          "ctrlId" : ctrlId,
                          "ctrlIsCrc" : ctrlIsCrc,
                          "bankId" : bankId
                        } ];

                        //CALIM RESULT UPDATE
                        if (updateResultItemKind == 'LIVE') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateClaimResultLive.do",
                                  data,
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimUpdateFail'/>");
                                  });
                        }
                        //CALIM RESULT UPDATE NEXT DAY
                        if (updateResultItemKind == 'NEXT') {
                          Common
                              .ajax(
                                  "POST",
                                  "/payment/updateClaimResultNextDay.do",
                                  data,
                                  function(
                                      result) {
                                    var resultMsg = "";
                                    resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

                                    Common
                                        .alert(resultMsg);
                                  },
                                  function(
                                      result) {
                                    Common
                                        .alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
                                  });
                        }
                      });
            }, function(jqXHR, textStatus, errorThrown) {
              try {
                console.log("status : " + jqXHR.status);
                console
                    .log("code : "
                        + jqXHR.responseJSON.code);
                console.log("message : "
                    + jqXHR.responseJSON.message);
                console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
              } catch (e) {
                console.log(e);
              }
              alert("Fail : " + jqXHR.responseJSON.message);
            });
  }

  //그리드 초기화.
  function resetUpdatedItems() {
    AUIGrid.resetUpdatedItems(updResultGridID, "a");
  }

  //NEW CLAIM Pop-UP 에서 Generate Claim 처리
  function fn_genClaim() {

    if ($("#new_claimType option:selected").val() == '') {
      Common.alert("<spring:message code='pay.alert.selectClaimType'/>");
      return;
    } else {

      if ($("#new_claimType option:selected").val() == "131"
          || $("#new_claimType option:selected").val() == "134") {
        if ($("#new_claimDay option:selected").val() == '') {
          Common
              .alert("<spring:message code='pay.alert.selectClaimDay'/>");
          return;
        }
      }
      if ($("#new_claimType option:selected").val() == "131") {
        if ($("#new_cardType option:selected").val() == '') {
          Common.alert(" * Please select card type.");
          return;
        }

        if ($("#new_issueBank option:selected").val() == '') {
          Common
              .alert(" * Please select a merchant bank ");
          return;
        }

        if ($("#new_merchantBank option:selected").val() == null) {
            Common
                .alert(" * Please select issue bank ");
            return;
        }
      } else if ($("#new_claimType option:selected").val() == "132") {
        if ($("#new_issueBank option:selected").val() == '') {
          Common
              .alert("<spring:message code='pay.alert.selectClaimIssueBank'/>");
          return;
        }
        if ($("#new_ddtChnl option:selected").val() == '') {
          Common
              .alert("<spring:message code='pay.alert.selectClaimDdtChnl'/>");
          return;
        }
      }
    }

    if ($("#new_debitDate").val() == '') {
      Common.alert("<spring:message code='pay.alert.insertDate'/>");
      return;
    }

    var runNo1 = 0;
    var merchantBank = "";

    if($('#new_merchantBank :selected').length > 0){
        $('#new_merchantBank :selected').each(function(i, mul){
            if($(mul).val() != "0"){
                if(runNo1 > 0){
                	merchantBank += ", "+$(mul).val()+" ";
                }else{
                	merchantBank += " "+$(mul).val()+" ";
                }
                runNo1 += 1;
            }
        });
    }
    $("#hiddenIssueBank").val(merchantBank);

    //저장 처리
    var data = {};
    var formList = $("#newForm").serializeArray(); //폼 데이터

    if (formList.length > 0)
      data.form = formList;
    else
      data.form = [];

    Common
        .ajax(
            "POST",
            "/payment/generateVResNewClaim.do",
            data,
            function(result) {
              var message = "";

              if (result.code == "IS_BATCH") {
                message += "<spring:message code='pay.alert.claimIsBatch' arguments='"+result.data.ctrlId+" ; "+
               result.data.crtUserName+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

              } else if (result.code == "FILE_OK") {
                message += "<spring:message code='pay.alert.claimFileOk' arguments='"+result.data.ctrlId+" ; "+result.data.ctrlBillAmt+" ; "+result.data.ctrlTotItm+" ; "+
                     result.data.crtUserId+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

              } else if (result.code == "FILE_FAIL") {
                message += "<spring:message code='pay.alert.claimFileFail' arguments='"+result.data.ctrlId+" ; "+result.data.ctrlBillAmt+" ; "+result.data.ctrlTotItm+" ; "+
                     result.data.crtUserId+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

              } else {
                message += "<spring:message code='pay.alert.generateFailClaimBatch'/>";
              }

              Common.alert("<b>" + message + "</b>");
            },
            function(result) {
              Common
                  .alert("<spring:message code='pay.alert.generateFailClaimBatch'/>");
            });
  }

  //NEW CLAIM Pop-UP 에서 Generate Claim 처리
  function fn_createFile() {

    var ctrlId = AUIGrid
        .getCellValue(myGridID, selectedGridValue, "ctrlId");
    var payType = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlIsCrcName");
    if (payType == "Credit Card"){
    	var isCrc = 'crc';
    }
    else{
    	var isCrc = 'dd';
    }

    //param data array
    var data = {};
    data.form = [ {
      "ctrlId" : ctrlId, "isCrc":isCrc
    } ];

    Common
        .ajax(
            "POST",
            "/payment/createClaimFile.do",
            data,
            function(result) {
              Common
                  .alert("<spring:message code='pay.alert.claimSucessCreate'/>",function(){
                      window.open("${pageContext.request.contextPath}" + subPath + result.data);
                  });

            },
            function(result) {
              Common
                  .alert("<spring:message code='pay.alert.claimFailGenFile'/>");
            });

  }

  function fn_clear() {
    $("#searchForm")[0].reset();
  }





  //Generation File Download 팝업
  function fn_openDivPopDown() {

    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1) {

      var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue,
          "ctrlId");
      var ctrlStusId = AUIGrid.getCellValue(myGridID, selectedGridValue,
          "ctrlStusId");
      var stusName = AUIGrid.getCellValue(myGridID, selectedGridValue,
          "stusName");

      if (ctrlStusId != 1) {
        Common
            .alert("<spring:message code='pay.alert.claimFile' arguments='"+ctrlId+" ; "+stusName+"' htmlEscape='false' argumentSeparator=';' />");
      } else {
        Common.popupDiv('/payment/initClaimFileDownPop.do', {
          "ctrlId" : ctrlId
        }, null, true, '_claimFileDownPop');
      }
    } else {
      Common.alert("<spring:message code='pay.alert.noClaim'/>");
    }
  }

  function fn_report(){

	    var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	    var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }

	    $("#excelForm #reportDownFileName").val("AutoDebitDetails_" + ctrlId + "_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
	    $("#excelForm #v_BANK_DTL_CTRL_ID").val(ctrlId);

	    var option = {
	            isProcedure : true
	    };

	    Common.report("excelForm", option);

	}
</script>
<!-- content start -->
<section id="content">
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
 </ul>
 <!-- title_line start -->
 <aside class="title_line">
  <p class="fav">
   <a href="#" class="click_add_on"><spring:message
     code='pay.text.myMenu' /></a>
  </p>
  <h2>vRescue</h2>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="javascript:fn_getClaimListAjax();"><span
       class="search"></span> <spring:message code='sys.btn.search' /></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a href="javascript:fn_clear();"><span class="clear"></span> <spring:message
       code='sys.btn.clear' /></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <!-- search_table start -->
 <section class="search_table">
  <form name="searchForm" id="searchForm" method="post">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 130px" />
     <col style="width: *" />
     <col style="width: 170px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='pay.text.bchID' /></th>
      <td><input id="batchId" name="batchId" type="text"
       title="BatchID" placeholder="Batch ID" class="w100p" /></td>
      <th scope="row"><spring:message code='pay.text.creator' /></th>
      <td><input id="creator" name="creator" type="text"
       title="Creator" placeholder="Creator (Username)" class="w100p" />
      </td>
      <th scope="row"><spring:message code='pay.text.crtDt' /></th>
      <td>
       <!-- date_set start -->
       <div class="date_set w100p">
        <p>
         <input id="createDt1" name="createDt1" type="text"
          title="Create Date From" placeholder="DD/MM/YYYY"
          class="j_date" readonly />
        </p>
        <span>~</span>
        <p>
         <input id="createDt2" name="createDt2" type="text"
          title="Create Date To" placeholder="DD/MM/YYYY" class="j_date"
          readonly />
        </p>
       </div> <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.clmTyp' /></th>
      <td><select id="claimType" name="claimType" class="w100p"></select>
      </td>
      <th scope="row"><spring:message code='pay.text.stat' /></th>
      <td><select id="status" name="status" class="w100p"></select>
      </td>
      <th scope="row"><spring:message code='pay.text.dbtDt' /></th>
      <td>
       <!-- date_set start -->
       <div class="date_set w100p">
        <p>
         <input id="debitDt1" name="debitDt1" type="text"
          title="Debit Date From" placeholder="DD/MM/YYYY"
          class="j_date" readonly />
        </p>
        <span>~</span>
        <p>
         <input id="debitDt2" name="debitDt2" type="text"
          title="Debit Date To" placeholder="DD/MM/YYYY" class="j_date"
          readonly />
        </p>
       </div> <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.ddtChnl' /></th>
      <td><select id="ddtChnl" name="ddtChnl" class="w100p"></select>
      </td>
      <th scope="row"><spring:message code='pay.text.issBnk' /></th>
      <td><select id="issueBank" name="issueBank" class="w100p"></select>
      </td>
      <th scope="row"><spring:message code='pay.text.smsSend' /></th>
      <td><select id="smsSend" name="smsSend" class="w100p"></select>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.waitSync' /></th>
      <td colspan="5"><input type="checkbox" /></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <!-- link_btns_wrap start -->
   <aside class="link_btns_wrap">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
     <p class="show_btn">
      <a href="#"><img
       src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
       alt="link show" /></a>
     </p>
     <dl class="link_list">
      <dt>Link</dt>
      <dd>
       <ul class="btns">
        <li><p class="link_btn">
          <a href="javascript:fn_openDivPop('VIEW');"><spring:message
            code='pay.btn.viewClaim' /></a>
         </p></li>
        <li><p class="link_btn">
          <a href="javascript:fn_openDivPop('RESULT');"><spring:message
            code='pay.btn.claimResultLive' /></a>
         </p></li>
        <li><p class="link_btn">
          <a href="javascript:fn_openDivPop('RESULTNEXT');"><spring:message
            code='pay.btn.claimResultNextDay' /></a>
         </p></li>
        <li><p class="link_btn">
          <a href="javascript:fn_openDivPop('FILE');"><spring:message
            code='pay.btn.reGenerateClaimFile' /></a>
         </p></li>
        <!--<li><p class="link_btn"><a href="javascript:fn_openDivPopDown('FILEDN');">Generation File Down</a></p></li>-->
       </ul>
       <ul class="btns">
        <li><p class="link_btn type2">
          <a href="javascript:fn_openDivPop('NEW');"><spring:message
            code='pay.btn.newClaim' /></a>
         </p></li>
       </ul>
       <p class="hide_btn">
        <a href="#"><img
         src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
         alt="hide" /></a>
       </p>
      </dd>
     </dl>
    </c:if>
   </aside>
   <!-- link_btns_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
 <!-- search_result start -->
 <section class="search_result">
  <!-- grid_wrap start -->
  <article id="grid_wrap" class="grid_wrap"></article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->
<!-------------------------------------------------------------------------------------
    POP-UP (VIEW CLAIM / RESULT (Live) / RESULT (NEXT DAY) / FILE GENERATOR
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
 <!-- pop_header start -->
 <header class="pop_header" id="pop_header">
  <h1></h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#" onclick="hideViewPopup('#view_wrap')"><spring:message
       code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->

 <form action="#" method="post" id="excelForm" name="excelForm">

<input type="hidden" id="reportFileName" name="reportFileName" value="/payment/AutoDebitCreditCardDetails.rpt" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
<input type="hidden" id="v_BANK_DTL_CTRL_ID" name="v_BANK_DTL_CTRL_ID" value='$("#view_batchId").text()' />
</form>

 <!-- pop_body start -->
 <section class="pop_body">
  <!-- search_table start -->
  <section class="search_table">
   <!-- table start -->
   <table class="type1">
    <caption>table</caption>
    <colgroup>
     <col style="width: 165px" />
     <col style="width: *" />
     <col style="width: 165px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='pay.text.bchID' /></th>
      <!-- BATCH ID -->
      <td id="view_batchId"></td>
      <th scope="row"><spring:message code='pay.text.stat' /></th>
      <!-- STATUS -->
      <td id="view_status"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.clmTyp' /></th>
      <!-- CLAIM TYPE -->
      <td id="view_type"></td>
      <th scope="row"><spring:message code='pay.text.creator' /></th>
      <!-- CREATOR -->
      <td id="view_creator"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.ddtChnl' /></th>
      <!-- ISSUE BANK -->
      <td id="view_ddtChnl"></td>
      <th scope="row"><spring:message code='pay.text.issBnk' /></th>
      <!-- ISSUE BANK -->
      <td id="view_issueBank"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.crtDt' /></th>
      <!-- CREATE DATE -->
      <td id="view_createDt"></td>
      <th scope="row"><spring:message code='pay.text.ttlItm' /></th>
      <!-- TOTAL ITEM -->
      <td id="view_totalItem"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.dbtDt' /></th>
      <!-- DEBIT DATE -->
      <td id="view_debitDate"></td>
      <th scope="row"><spring:message code='pay.text.tgtAmt' /></th>
      <!-- TARGET AMOUNT -->
      <td id="view_targetAmount"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.updator' /></th>
      <!-- UPDATOR -->
      <td id="view_updator"></td>
      <th scope="row"><spring:message code='pay.text.recvAmt' /></th>
      <!-- RECEIVE AMOUNT -->
      <td id="view_receiveAmount"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.ttlSucc' /></th>
      <td id="view_totalSuccess"></td>
      <th scope="row"><spring:message code='pay.text.updDt' /></th>
      <!-- UPDATE DATE -->
      <td id="view_updateDate"></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.ttlFail' /></th>
      <td id="view_totalFail"></td>
      <th scope="row"></th>
      <td></td>
     </tr>
    </tbody>
   </table>
  </section>
  <!-- search_table end -->
  <section class="search_result">
   <!-- search_result start -->
   <article class="grid_wrap" id="sms_grid_wrap"></article>
   <!-- grid_wrap end -->
  </section>
  <!-- search_result end -->
  <ul class="center_btns" id="center_btns1">
   <li><p class="btn_blue2">
     <a href="javascript:fn_deactivate();"><spring:message
       code='pay.btn.deactivate' /></a>
    </p></li>
   <li><p class="btn_blue2">
     <a href="javascript:fn_updateResult('LIVE');"><spring:message
       code='pay.btn.updateResult' /></a>
    </p></li>
  </ul>
  <ul class="center_btns" id="center_btns2">
   <li><p class="btn_blue2">
     <a href="javascript:fn_deactivate();"><spring:message
       code='pay.btn.deactivate' /></a>
    </p></li>
   <li><p class="btn_blue2">
     <a href="javascript:fn_updateResult('NEXT');"><spring:message
       code='pay.btn.updateResult' /></a>
    </p></li>
  </ul>
  <ul class="center_btns" id="center_btns3">
   <li><p class="btn_blue2">
     <a href="javascript:fn_createFile();"><spring:message
       code='pay.btn.generateFile' /></a>
    </p></li>
  </ul>
  <ul class="center_btns" id="center_btns4">
   <li><p class="btn_blue2">
     <a href="javascript:fn_sendFailDeduction();"><spring:message
       code='pay.btn.sendFailDecductionSMS' /></a>
    </p></li>
  </ul>
  <ul class="center_btns" id="center_btns5">
            <li><p class="btn_blue2"><a href="javascript:fn_report();"><spring:message code='pay.btn.generateToExcel'/></a></p></li>
        </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
<!---------------------------------------------------------------
    POP-UP (NEW CLAIM)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="new_wrap" style="display: none;">
 <!-- pop_header start -->
 <header class="pop_header" id="new_pop_header">
  <h1>
   <spring:message code='pay.title.newClm' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#" onclick="hideViewPopup('#new_wrap')"><spring:message
       code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <!-- pop_body start -->
 <form name="newForm" id="newForm" method="post">
  <section class="pop_body">
   <!-- search_table start -->
   <section class="search_table">
    <!-- table start -->
    <table class="type1">
     <caption>table</caption>
     <colgroup>
      <col style="width: 165px" />
      <col style="width: *" />
      <col style="width: 165px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='pay.text.clmTyp' /> <span
        class="must">*</span></th>
       <td><select id="new_claimType" name="new_claimType"
        class="w100p"></select></td>
       <th scope="row"><spring:message code='pay.text.clmDay' /> <span
        class="must" id="claimDayMust">*</span></th>
       <td><select id="new_claimDay" name="new_claimDay"
        class="w100p" disabled></select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='pay.text.ddtChnl' />
        <span class="must" id="ddtChnlMust">*</span></th>
       <td><select id="new_ddtChnl" name="new_ddtChnl"
        class="w100p" disabled></select></td>
       <th scope="row">Merchant Bank<span
        class="must" id="issueBankMust">*</span></th>
       <td><select id="new_issueBank" name="new_issueBank"
        class="w100p" disabled></select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='pay.text.dbtDt' /> <span
        class="must">*</span></th>
       <td><input type="text" id="new_debitDate"
        name="new_debitDate" title="Debit Date" placeholder="Debit Date"
        class="j_date w100p" /></td>
       <th scope="row"><spring:message code='pay.text.crdTyp' /> <span
        class="must" id="cardTypeMust">*</span></th>
       <td><select id="new_cardType" name="new_cardType"
        class="w100p" disabled>
         <!-- <option value="">Choose One</option>
         <option value="All">All</option>
         <option value="Visa Card">Visa Card</option>
         <option value="Master Card">Master Card</option> -->
       </select></td>
      </tr>
      <tr>
      <th scope="row">Issue Bank <span class="must" id="merchantBankMust">*</span></th>
           <td>
                 <select class="multy_select w100p" multiple="multiple" id="new_merchantBank" data-placeholder="Bank Name"></select>
                 <input type="hidden"  id="hiddenIssueBank" name="hiddenIssueBank"/>
           </td>
      </tr>
     </tbody>
    </table>
   </section>
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a href="javascript:fn_genClaim();"><spring:message
        code='pay.btn.generateClaim' /></a>
     </p></li>
   </ul>
  </section>
 </form>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
<!---------------------------------------------------------------
    POP-UP (NEW CLAIM)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="updResult_wrap" style="display: none;">
 <!-- pop_header start -->
 <header class="pop_header" id="updResult_pop_header">
  <h1>
   <spring:message code='pay.title.clmRstUpd' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#" onclick="hideViewPopup('#updResult_wrap')"><spring:message
       code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <!-- pop_body start -->
 <form name="updResultForm" id="updResultForm" method="post">
  <section class="pop_body">
   <!-- search_table start -->
   <section class="search_table">
    <!-- table start -->
    <table class="type1">
     <caption>table</caption>
     <colgroup>
      <col style="width: 165px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='sys.text.rstFile' /></th>
       <td>
        <!-- auto_file start --> <!--
                           <div class="auto_file">
                               <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div>
               --> <!-- auto_file end -->
        <div class="auto_file">
         <!-- auto_file start -->
         <input type="file" title="file add" id="uploadfile"
          name="uploadfile" accept=".csv" />
        </div> <!-- auto_file end -->
       </td>
      </tr>
     </tbody>
    </table>
   </section>
   <section class="search_result">
    <!-- search_result start -->
    <article class="grid_wrap" id="updResult_grid_wrap"
     style="display: none;"></article>
    <!-- grid_wrap end -->
   </section>
   <!-- search_result end -->
   <!-- search_table end -->
   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a href="javascript:fn_uploadFile4();"><spring:message
        code='pay.btn.upload' /></a>
     </p></li>
    <!--<li><p class="btn_blue2"><a href="javascript:fn_resultFileUp();"><spring:message code='pay.btn.upload'/></a></p></li>-->
    <li><p class="btn_blue2">
      <a
       href="${pageContext.request.contextPath}/resources/download/payment/ClaimResultUpdate_Format.csv"><spring:message
        code='pay.btn.downloadCsvFormat' /></a>
     </p></li>
   </ul>
  </section>
 </form>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->