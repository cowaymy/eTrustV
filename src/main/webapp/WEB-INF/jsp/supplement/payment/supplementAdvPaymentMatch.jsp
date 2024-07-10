<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.my-custom-up {
  text-align: left;
}
</style>
<script type="text/javaScript">
  var payTypeData = [ {
    "codeId" : "",
    "codeName" : "Choose One"
  }, {
    "codeId" : "105",
    "codeName" : "Cash"
  }, {
    "codeId" : "106",
    "codeName" : "Cheque"
  }, {
    "codeId" : "108",
    "codeName" : "Online"
  } ];

  var bankTypeData = [ {
    "codeId" : "",
    "codeName" : "Choose One"
  }, {
    "codeId" : "2728",
    "codeName" : "JomPay"
  }, {
    "codeId" : "2729",
    "codeName" : "MBB CDM"
  }, {
    "codeId" : "2730",
    "codeName" : "VA"
  }, {
    "codeId" : "2731",
    "codeName" : "Others"
  } ];

  var advKeyInGridId;
  var bankStmtGridId;
  var reportGridId;
  var selectedGridValue;

  var gridPros2 = {
    editable : false,
    showRowCheckColumn : true,
    rowCheckToRadio : true,
    softRemoveRowMode : false,
    headerHeight : 35,
    showStateColumn : false
  };

  var gridPros1 = {
    editable : false,
    showRowCheckColumn : true,
    rowCheckToCheck : true,
    softRemoveRowMode : false,
    headerHeight : 50,
    showStateColumn : false
  };

  var gridPros3 = {
    editable : false,
    headerHeight : 50,
    showStateColumn : false
  };

  var advKeyInLayout = [
      {
        dataField : "groupSeq",
        headerText : "<spring:message code='supplement.head.paymentGroupNo'/>",
        width : 90,
        editable : false
      },
      {
        dataField : "payItmModeNm",
        headerText : "<spring:message code='supplement.head.paymentMode'/>",
        width : 90,
        editable : false
      },
      {
        dataField : "payItmRefDt",
        headerText : "<spring:message code='supplement.head.transactionDate'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "payItmBankAccNm",
        headerText : "<spring:message code='supplement.head.bankAccount'/>",
        editable : false
      },
      {
        dataField : "payItmBankInSlipNo",
        headerText : "<spring:message code='supplement.head.slipNo'/>",
        width : 120,
        editable : false
      },
      {
        dataField : "refDtl",
        headerText : "<spring:message code='pay.head.refDetailsJompayRef'/>",
        width : 120,
        editable : false
      },
      {
        dataField : "totAmt",
        headerText : "<spring:message code='supplement.head.amount'/>",
        width : 100,
        editable : false,
        dataType : "numeric",
        formatString : "###0.00"
      },
      {
        dataField : "bankChgAmt",
        headerText : "<spring:message code='supplement.head.bankCharge'/>",
        width : 100,
        editable : false,
        dataType : "numeric",
        formatString : "###0.00"
      } ];

  var bankStmtLayout = [
      {
        dataField : "bankId",
        headerText : "<spring:message code='supplement.head.bankId'/>",
        editable : false,
        visible : false
      },
      {
        dataField : "bankAcc",
        headerText : "<spring:message code='supplement.head.bankAccountCode'/>",
        editable : false,
        visible : false
      },
      {
        dataField : "count",
        headerText : "",
        editable : false,
        visible : false
      },
      {
        dataField : "fTrnscId",
        headerText : "<spring:message code='supplement.head.tranxId'/>",
        editable : false
      },
      {
        dataField : "bankName",
        headerText : "<spring:message code='supplement.head.bank'/>",
        editable : false
      },
      {
        dataField : "bankAccName",
        headerText : "<spring:message code='supplement.head.bankAccount'/>",
        editable : false
      },
      {
        dataField : "fTrnscDt",
        headerText : "<spring:message code='supplement.head.dateTime'/>",
        editable : false
      },
      {
        dataField : "fTrnscTellerId",
        headerText : "<spring:message code='supplement.head.refCheqNo'/>",
        editable : false
      },
      {
        dataField : "fTrnscRef3",
        headerText : "<spring:message code='supplement.head.description1'/>",
        editable : false
      },
      {
        dataField : "fTrnscRefChqNo",
        headerText : "<spring:message code='supplement.head.description2'/>",
        editable : false
      },
      {
        dataField : "fTrnscRef1",
        headerText : "<spring:message code='supplement.head.ref5'/>",
        editable : false
      },
      {
        dataField : "fTrnscRef2",
        headerText : "<spring:message code='supplement.head.ref6'/>",
        editable : false
      },
      {
        dataField : "fTrnscRef6",
        headerText : "<spring:message code='supplement.head.ref7'/>",
        editable : false
      },
      {
        dataField : "fTrnscRem",
        headerText : "<spring:message code='supplement.head.type'/>",
        editable : false
      },
      {
        dataField : "fTrnscDebtAmt",
        headerText : "<spring:message code='supplement.head.debit'/>",
        editable : false,
        dataType : "numeric",
        formatString : "#,##0.00"
      },
      {
        dataField : "fTrnscCrditAmt",
        headerText : "<spring:message code='supplement.head.credit'/>",
        editable : false,
        dataType : "numeric",
        formatString : "#,##0.00"
      },
      {
        dataField : "fTrnscRef4",
        headerText : "<spring:message code='supplement.head.depositSlipNoEftMid'/>",
        editable : false
      },
      {
        dataField : "fTrnscNewChqNo",
        headerText : "<spring:message code='supplement.head.chqNo'/>",
        editable : false
      },
      {
        dataField : "fTrnscRefVaNo",
        headerText : "<spring:message code='supplement.head.vaNumber'/>",
        editable : false
      } ];

  var reportLayout = [
      {
        dataField : "keyInDate",
        headerText : "<spring:message code='supplement.text.keyInDate'/>",
        width : 100,
        editable : false,
        visible : false
      },
      {
        dataField : "branchCode",
        headerText : "<spring:message code='supplement.text.brnchCode'/>",
        width : 100,
        editable : false,
        visible : false
      },
      {
        dataField : "userId",
        headerText : "<spring:message code='sys.title.user.id'/>",
        width : 100,
        editable : false,
        visible : false
      },
      {
        dataField : "count",
        headerText : "",
        width : 100,
        editable : false,
        visible : false
      },
      {
        dataField : "systemTransactionId",
        headerText : "<spring:message code='supplement.text.sysTransactionID'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "orderNo",
        headerText : "<spring:message code='supplement.text.order'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "customerName",
        headerText : "<spring:message code='supplement.text.custName'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "applicationType",
        headerText : "<spring:message code='supplement.text.appType'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "amount",
        headerText : "<spring:message code='supplement.head.amount'/>",
        width : 100,
        editable : false,
        dataType : "numeric",
        formatString : "#,##0.00"
      },
      {
        dataField : "receiptNumber",
        headerText : "<spring:message code='supplement.text.receiptNo'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "transactionDate",
        headerText : "<spring:message code='supplement.head.transactionDate'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "paymentType",
        headerText : "<spring:message code='supplement.text.paymentType'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "amount2",
        headerText : "<spring:message code='supplement.head.amount2'/>",
        width : 100,
        editable : false,
        dataType : "numeric",
        formatString : "#,##0.00"
      },
      {
        dataField : "bankType",
        headerText : "<spring:message code='supplement.text.bankType'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "bankAccount",
        headerText : "<spring:message code='supplement.head.bankAccount'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "vaNumber",
        headerText : "<spring:message code='supplement.head.vaNumber'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "slipNo",
        headerText : "<spring:message code='supplement.head.slipNo'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "remark",
        headerText : "<spring:message code='supplement.text.remark'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "statementTransactionId",
        headerText : "<spring:message code='supplement.text.stmtTransactionID'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "status",
        headerText : "<spring:message code='sys.title.status'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "mappingRejectDate",
        headerText : "<spring:message code='supplement.text.mappingRejectDate'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "actionDate",
        headerText : "<spring:message code='supplement.text.actionDate'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "actionByUserId",
        headerText : "<spring:message code='supplement.text.actionByUserId'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "actionType",
        headerText : "<spring:message code='supplement.text.actionType'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "adjAmount",
        headerText : "<spring:message code='supplement.text.adjAmount'/>",
        width : 100,
        editable : false,
        dataType : "numeric",
        formatString : "#,##0.00"
      },
      {
        dataField : "remark2",
        headerText : "<spring:message code='supplement.text.remark2'/>",
        width : 100,
        editable : false
      },
      {
        dataField : "remark3",
        headerText : "<spring:message code='supplement.text.remark3'/>",
        width : 100,
        editable : false
      } ];

  $(document).ready(
    function() {
      doDefComboAndMandatory(payTypeData, '108', 'payType', 'S', '');
      doDefComboAndMandatory(bankTypeData, '', 'bankType', 'S', '');
      doGetCombo('/common/selectCodeList.do', '393', '', 'accCode', 'S', '');
      fn_payTypeChange();

      advKeyInGridId = GridCommon.createAUIGrid("adv_keyin_grid_wrap", advKeyInLayout, "", gridPros1);
      bankStmtGridId = GridCommon.createAUIGrid("bank_stmt_grid_wrap", bankStmtLayout, "", gridPros2);
      //reportGridId = GridCommon.createAUIGrid("report_grid_wrap", reportLayout, null, gridPros3);

      AUIGrid.bind(advKeyInGridId, "cellDoubleClick",
        function(event) {
          var groupSeq = AUIGrid.getCellValue( advKeyInGridId,
                                                               event.rowIndex,
                                                               "groupSeq");
          Common.popupDiv('/supplement/payment/initDetailGrpPaymentPop.do', { "groupSeq" : groupSeq }, null, true,  '_viewDtlGrpPaymentPop');
        }
      );
    }
  );

  function fn_chgBankType() {
    if ($("#bankType").val() == "2728") {
      $("#bankAcc option").remove();
      $("#bankAcc").append("<option value=''>Choose One</option>");
      $("#bankAcc").append("<option value='546'>2710/010C - CIMB 641</option>");
      $("#bankAcc").append("<option value='558'>2710/205 - CIMB 7</option>");
    } else {
      $("#bankAcc option").remove();
      fn_payTypeChange();
    }
  }

  function fn_payTypeChange() {
    var payType = $("#payType").val();

    if (payType == "105") { //CASH
      $("#bankType option").remove();
      $("#bankType").append("<option value=''>Choose One</option>");
      $("#bankType").append("<option value='2729'>MBB CDM</option>");
      $("#bankType").append("<option value='2730'>VA</option>");
      $("#bankType").append("<option value='2731'>Others</option>");
    } else if (payType == "106") { //CHEQUE
      $("#bankType option").remove();
      $("#bankType").append("<option value=''>Choose One</option>");
      $("#bankType").append("<option value='2730'>VA</option>");
      $("#bankType").append("<option value='2731'>Others</option>");
    } else if (payType == "108") { //ONLINE
      $("#bankType option").remove();
      $("#bankType").append("<option value=''>Choose One</option>");
      $("#bankType").append("<option value='2728'>JomPay</option>");
      $("#bankType").append("<option value='2730'>VA</option>");
      $("#bankType").append("<option value='2731'>Others</option>");
    }

    fn_bankChange();
  }

  function fn_bankChange() {
    var bankType = $("#bankType").val();

    if (bankType == "2729") {
      $("#bankAcc option").remove();
      $("#bankAcc").append("<option value=''>Choose One</option>");
      $("#bankAcc").append("<option value='84'>2710/002 - MBB</option>");
    } else if (bankType == "2730") {
      $("#bankAcc option").remove();
      $("#bankAcc").append("<option value=''>Choose One</option>");
      $("#bankAcc").append(
          "<option value='525'>2710/010B - CIMB VA</option>");
    } else if (bankType == "2731") {
      $("#bankAcc option").remove();
      doGetCombo('/supplement/payment/getAccountList.do', '', '',
          'bankAcc', 'S', '');
    } else if (bankType == "2728") {
      $("#bankAcc option").remove();
      $("#bankAcc").append("<option value=''>Choose One</option>");
      $("#bankAcc").append("<option value='546'>2710/010C - CIMB 641</option>");
      $("#bankAcc").append("<option value='558'>2710/205 - CIMB 7</option>");
    }
  }

  function fn_bankAccChange() {
    var bankaccType = $("#bankAcc").val();

    if (bankaccType == "546" || bankaccType == "561") {
      $("#bankType").val('2728');
    }
  }

  function fn_searchAdvMatchList() {
    if (FormUtil.checkReqValue($("#transDateFr")) || FormUtil.checkReqValue($("#transDateTo"))) {
      var msgLabel = "<spring:message code='supplement.head.transactionDate'/>"
      Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
      return;
    }

    var d1Array = $("#transDateTo").val().split("/");
    var d1 = new Date(d1Array[2] + "-" + d1Array[1] + "-" + d1Array[0]);
    var d2Array = $("#transDateFr").val().split("/");
    var d2 = new Date(d2Array[2] + "-" + d2Array[1] + "-" + d2Array[0]);
    var dayDiffs = Math.floor((d1.getTime() - d2.getTime()) / (1000 * 60 * 60 * 24));

    if (!(dayDiffs <= 31)) {
       var msgLabel = "<spring:message code='supplement.head.transactionDate'/>"
       Common.alert("<spring:message code='service.msg.asSearchDtRange' arguments='" + msgLabel + " ; <b>31</b>' htmlEscape='false' argumentSeparator=';' />");
       return;
    }

    Common.ajax("POST", "/supplement/payment/selectPaymentMatchList.do", $("#searchForm").serializeJSON(), function(result) {
      AUIGrid.setGridData(advKeyInGridId, result.keyInList);
      AUIGrid.setGridData(bankStmtGridId, result.stateList);
    });
  }

  function fn_clear() {
    $("#searchForm")[0].reset();
  }

  function fn_mapping() {
    var advKeyInItems = AUIGrid.getCheckedRowItems(advKeyInGridId);
    var bankStmtItem = AUIGrid.getCheckedRowItems(bankStmtGridId);
    var keyInRowItem;
    var stateRowItem;
    var keyInAmount = 0;
    var stmtAmount = 0;
    var groupSeq = 0;
    var fTrnscId = 0;
    var flag = 'Y';

    if (advKeyInItems.length < 1 || bankStmtItem.length < 1) {
      Common.alert("<spring:message code='supplement.alert.keyInListCheck'/>");
      return;
    } else if (advKeyInItems.length == 1 && bankStmtItem.length == 1) {
      keyInRowItem = advKeyInItems[0];
      stateRowItem = bankStmtItem[0];

      keyInAmount = Number(keyInRowItem.item.totAmt) - Number(keyInRowItem.item.bankChgAmt);
      keyInAmount = $.number(keyInAmount, 2, '.', '');

      stmtAmount = Number(stateRowItem.item.fTrnscCrditAmt);
      stmtAmount = $.number(stmtAmount, 2, '.', '');

      groupSeq = keyInRowItem.item.groupSeq;
      fTrnscId = stateRowItem.item.fTrnscId;

      if (keyInAmount != stmtAmount) {
        Common.alert("<spring:message code='supplement.alert.transAmtNotSame'/>",
        function() {
          $("#journal_entry_wrap").show();
          $("#groupSeq").val(groupSeq);
          $("#fTrnscId").val(fTrnscId);
          $("#preKeyInAmt").val(keyInAmount);
          $("#bankStmtAmt").val(stmtAmount);
          $("#variance").val(
          $.number(keyInAmount - stmtAmount, 2, '.', ''));
          $("#accCode").val('');
          $("#remark").val('');
        });
      } else {
        $("#groupSeq").val(groupSeq);
        $("#fTrnscId").val(fTrnscId);
        $("#preKeyInAmt").val(keyInAmount);
        $("#bankStmtAmt").val(stmtAmount);
        $("#variance").val($.number(keyInAmount - stmtAmount, 2, '.', ''));
        $("#accCode").val('');
        $("#remark").val('');

        fn_saveMapping('N');
      }
    } else if (advKeyInItems.length > 1 && bankStmtItem.length == 1) {
      stateRowItem = bankStmtItem[0];
      stmtAmount = Number(stateRowItem.item.fTrnscCrditAmt);
      stmtAmount = $.number(stmtAmount, 2, '.', '');
      fTrnscId = stateRowItem.item.fTrnscId;

      for (var i = 0; i < advKeyInItems.length; i++) {
        keyInRowItem = advKeyInItems[i];
        keyInAmount += Number(keyInRowItem.item.totAmt);

        if (keyInRowItem.item.payItmModeNm != stateRowItem.item.fTrnscRem) {
          Common.alert("<spring:message code='supplement.alert.supplementSamePmtMethodAllow'/>");
          return false;
        }

        if (keyInRowItem.item.payItmRefDt != stateRowItem.item.fTrnscDt) {
        	Common.alert("<spring:message code='supplement.alert.supplementSamePmtDateAllow'/>");
          flag = 'N';
          return false;
        }

        if (i == 0) {
          groupSeq = keyInRowItem.item.groupSeq;
        } else {
          groupSeq += "," + keyInRowItem.item.groupSeq;
        }
      }

      keyInAmount = $.number(keyInAmount, 2, '.', '');
      if (keyInAmount != stmtAmount) {
        Common.alert("<spring:message code='supplement.alert.transAmtNotSame'/>",
          function() {
            $("#journal_entry_wrap").show();
            $("#groupSeq").val(groupSeq);
            $("#fTrnscId").val(fTrnscId);
            $("#preKeyInAmt").val(keyInAmount);
            $("#bankStmtAmt").val(stmtAmount);
            $("#variance").val(
            $.number(keyInAmount - stmtAmount, 2, '.', ''));
            $("#accCode").val('');
            $("#remark").val('');
          }
        );
      }

      if (flag == "Y") {
        $("#groupSeq").val(groupSeq);
        $("#fTrnscId").val(fTrnscId);
        $("#preKeyInAmt").val(keyInAmount);
        $("#bankStmtAmt").val(stmtAmount);
        $("#variance").val($.number(keyInAmount - stmtAmount, 2, '.', ''));
        $("#accCode").val('');
        $("#remark").val('');

        fn_saveMapping('N');
      }
    }
  }

  function fn_saveMapping(withPop) {
    if (withPop == 'Y') {
      if (FormUtil.checkReqValue($("#accCode option:selected"))) {
        Common.alert("<spring:message code='supplement.alert.accountCode'/>");
        return;
      }

      if (FormUtil.checkReqValue($("#remark"))) {
        Common.alert("<spring:message code='supplement.alert.inputRemark'/>");
        return;
      }

      if (FormUtil.byteLength($("#remark").val()) > 3000) {
        Common.alert("<spring:message code='supplement.alert.inputRemark3000Char'/>");
        return;
      }
    }

    Common.confirm("<spring:message code='supplement.alert.supplementAdvPmtMapConfirm'/>",
      function() {
        Common.ajax("POST", "/supplement/payment/saveAdvPaymentMapping.do", $("#entryForm").serializeJSON(),
        function(result) {
           var message = "<spring:message code='supplement.alert.mappingSuccess'/>";

           Common.alert(message,
             function() {
               fn_searchAdvMatchList();
               $("#journal_entry_wrap").hide();
             }
           );
         }
       );
     }
    );
  }

  function fn_debtor() {
    var advKeyInItems = AUIGrid.getCheckedRowItems(advKeyInGridId);
    var keyInRowItem;
    var keyInAmount = 0;
    var groupSeq = 0;

    if (advKeyInItems.length < 1) {
      Common.alert("<spring:message code='supplement.alert.checkKeyInList'/>");
      return;
    } else {
      keyInRowItem = advKeyInItems[0];
      keyInAmount = Number(keyInRowItem.item.totAmt) + Number(keyInRowItem.item.bankChgAmt);
      groupSeq = keyInRowItem.item.groupSeq;

      Common.alert("<spring:message code='supplement.alert.bankStatementMissing'/>",
        function() {
          $("#debtor_wrap").show();
          $("#debtorGroupSeq").val(groupSeq);
          $("#debtorRemark").val('');
        }
      );
    }
  }

  function fn_saveDebtor() {
    if (FormUtil.checkReqValue($("#debtorRemark"))) {
      Common.alert("<spring:message code='supplement.alert.inputRemark'/>");
      return;
    }

    if (FormUtil.byteLength($("#debtorRemark").val()) > 3000) {
      Common.alert("<spring:message code='supplement.alert.inputRemark3000Char'/>");
      return;
    }

    Common.confirm("<spring:message code='supplement.alert.wantToSave'/>",
      function() {
        Common.ajax("POST", "/supplement/payment/saveAdvPaymentDebtor.do", $("#debtorForm").serializeJSON(),
          function(result) {
            var message = "<spring:message code='supplement.alert.mappingSuccess'/>";

            Common.alert( message,
              function() {
                fn_searchAdvMatchList();
                $("#debtor_wrap").hide();
              }
            );
          }
        );
      }
    );
  }

  hideViewPopup = function(val) {
    $(val).hide();
  }

  function fn_advanceKeyinRaw() {
    $('#reportAdvanceKeyin_wrap').show();
    AUIGrid.destroy("#report_grid_wrap");
    reportGridId = GridCommon.createAUIGrid("report_grid_wrap", reportLayout, null, gridPros3);
  }

  function fn_generateReport() {
    var d1Array = $("#keyinDateTo").val().split("/");
    var d1 = new Date(d1Array[2] + "-" + d1Array[1] + "-" + d1Array[0]);
    var d2Array = $("#keyinDateFr").val().split("/");
    var d2 = new Date(d2Array[2] + "-" + d2Array[1] + "-" + d2Array[0]);
    var dayDiffs = Math.floor((d1.getTime() - d2.getTime()) / (1000 * 60 * 60 * 24));

    if (dayDiffs <= 31) {
      var date = new Date().getDate();
      if (date.toString().length == 1)
        date = "0" + date;

      Common.ajax("POST", "/supplement/payment/selectAdvKeyInReport.do", $("#reportForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(reportGridId, result);
      });
    } else {
      var msgLabel = "<spring:message code='supplement.head.transactionDate'/>"
      Common.alert("<spring:message code='service.msg.asSearchDtRange' arguments='" + msgLabel + " ; <b>31</b>' htmlEscape='false' argumentSeparator=';' />");
    }
  }

  function fn_excelDown() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();

    const date = year + month + day;
    GridCommon.exportTo("report_grid_wrap", "xlsx", "Supplement Advance Payment Matching-" + date);
  }
</script>
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  </ul>

  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on"><spring:message code='pay.text.myMenu' /></a>
    </p>
    <h2>
      <spring:message code='supplement.text.supplementAdvPayMatching' />
    </h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="javascript:fn_mapping();"><spring:message code='pay.btn.mapping' /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="javascript:fn_searchAdvMatchList();">
              <span class="search"></span>
              <spring:message code='sys.btn.search' />
            </a>
          </p>
        </li>
        <!-- <li>
          <p class="btn_blue">
            <a href="javascript:fn_clear();">
              <span class="clear"></span>
              <spring:message code='sys.btn.clear' />
            </a>
          </p>
        </li> -->
      </c:if>
    </ul>
  </aside>

  <section class="search_table">
    <form action="#" method="post" id="searchForm">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 200px" />
          <col style="width: *" />
          <col style="width: 200px" />
          <col style="width: *" />
          <col style="width: 200px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='supplement.head.transactionDate' /><span class="must">*</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input type="text" id="transDateFr" name="transDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" value="${bfDay}"/>
                </p>
                <span><spring:message code='sal.title.to' /></span>
                <p>
                  <input type="text" id="transDateTo" name="transDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" value="${toDay}"/>
                </p>
              </div>
            </td>
            <th scope="row">
              <spring:message code='supplement.text.paymentType' />
            </th>
            <td>
              <select id="payType" name="payType" class="w100p" onchange="javascript:fn_payTypeChange();"></select>
            </td>
            <th scope="row"><spring:message code='supplement.text.bankType' /></th>
            <td>
              <select id="bankType" name="bankType" class="w100p" onchange="javascript:fn_bankChange();"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='supplement.head.bankAccount' /></th>
            <td>
            <select id="bankAcc" name="bankAcc" class="w100p" onchange="javascript:fn_bankAccChange();"></select>
            </td>
            <th></th>
            <td></td>
            <th></th>
            <td></td>
            <!-- <th scope="row"><spring:message code='supplement.text.vaAccount' /></th>
            <td>
              <input type="text" id="vaAccount" name="vaAccount" class="w100p readonly" readonly="readonly" />
            </td>
            <th scope="row"><spring:message code='supplement.head.amount' /></th>
            <td>
              <input type="text" id="bnkCrAmt" name="bnkCrAmt" class="w100p" />
            </td> -->
          </tr>
        </tbody>
      </table>
    </form>
  </section>

  <aside class="link_btns_wrap">
    <p class="show_btn">
      <a href="#">
        <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
      </a>
    </p>
    <dl class="link_list">
      <dt>
        <spring:message code='sal.title.text.link' />
      </dt>
      <dd>
        <ul class="btns">
          <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
            <li>
              <p class="link_btn">
                <a href="javascript:fn_debtor();"><spring:message code='pay.btn.debtor' /></a>
              </p>
            </li>
          </c:if>
          <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li>
              <p class="link_btn">
                <a href="javascript:fn_advanceKeyinRaw();"><spring:message code='pay.btn.advanceKeyinRaw' /></a>
              </p>
            </li>
          </c:if>
        </ul>
        <p class="hide_btn">
          <a href="#">
            <img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" />
          </a>
        </p>
      </dd>
    </dl>
  </aside>

  <div class="divine_auto">
    <div style="width: 50%;">
      <aside class="title_line">
        <h3>
          <spring:message code='supplement.text.advKeyInList' />
        </h3>
      </aside>
      <article id="adv_keyin_grid_wrap" class="grid_wrap"></article>
    </div>
    <div style="width: 50%;">
      <aside class="title_line">
        <h3>
          <spring:message code='supplement.text.bankStatement' />
        </h3>
      </aside>
      <article id="bank_stmt_grid_wrap" class="grid_wrap"></article>
    </div>
  </div>
</section>

<!---------------------------------------------------------------
    POP-UP (JOURNAL ENTRY)
---------------------------------------------------------------->
<div class="popup_wrap" id="journal_entry_wrap" style="display: none;">
  <header class="pop_header" id="pop_header">
    <h1>JOURNAL ENTRY</h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="#" onclick="hideViewPopup('#journal_entry_wrap')"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>

  <form name="entryForm" id="entryForm" method="post">
    <input type="hidden" id="groupSeq" name="groupSeq" />
    <input type="hidden" id="fTrnscId" name="fTrnscId" />
    <section class="pop_body">
      <section class="search_table">
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 200px" />
            <col style="width: *" />
          </colgroup>

          <tbody>
            <tr>
              <th scope="row"><spring:message code='supplement.text.uploadAmt' /> (A)<span class="must">*</span></th>
              <td>
                <input id="preKeyInAmt" name="preKeyInAmt" type="text" class="readonly" readonly />
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='supplement.text.bnkStatementAmt' /> (B)<span class="must">*</span></th>
              <td>
                <input id="bankStmtAmt" name="bankStmtAmt" type="text" class="readonly" readonly />
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='supplement.text.amtVariance' /> (<spring:message code='supplement.text.amtVariance' /> = A - B)<span class="must">*</span></th>
              <td>
                <input id="variance" name="variance" type="text" class="readonly" readonly />
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='pay.head.accountCode' /><span class="must">*</span></th>
              <td>
                <select id="accCode" name="accCode" class="w100p"></select>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='supplement.text.remark' /><span class="must">*</span></th>
              <td>
                <textarea id="remark" name="remark" cols="10" rows="3" placeholder=""></textarea></td>
            </tr>
          </tbody>
        </table>
      </section>
      <ul class="center_btns">
        <li>
          <p class="btn_blue2">
            <a href="javascript:fn_saveMapping('Y');"><spring:message code='sys.btn.save' /></a>
          </p>
        </li>
      </ul>
    </section>
  </form>
</div>

<!---------------------------------------------------------------
    POP-UP (Other Debtor With Ticket)
---------------------------------------------------------------->
<div class="popup_wrap" id="debtor_wrap" style="display: none;">
  <header class="pop_header" id="pop_header">
    <h1>Other Debtor with Ticket</h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="#" onclick="hideViewPopup('#debtor_wrapp')"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>

  <form name="debtorForm" id="debtorForm" method="post">
    <input type="hidden" id="debtorGroupSeq" name="debtorGroupSeq" />
    <section class="pop_body">
      <section class="search_table">
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 200px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='supplement.text.remark' /></th>
              <td>
                <textarea id="debtorRemark" name="debtorRemark" cols="10" rows="3" placeholder=""></textarea>
              </td>
            </tr>
          </tbody>
        </table>
      </section>
      <ul class="center_btns">
        <li>
          <p class="btn_blue2">
            <a href="javascript:fn_saveDebtor();"><spring:message code='sys.btn.save' /></a>
          </p>
        </li>
      </ul>
    </section>
  </form>
</div>

<div id="reportAdvanceKeyin_wrap" class="popup_wrap" style="display: none">
  <header class="pop_header">
    <h1>
      <spring:message code='supplement.text.advKeyInRpt' />
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#none" onclick="javascript:fn_generateReport();"><spring:message code="sal.btn.search" /></a></p></li>
      <li>
        <p class="btn_blue2">
          <a href="#" onclick="hideViewPopup('#reportAdvanceKeyin_wrap');"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>

  <section class="pop_body">
    <table class="type1">
      <colgroup>
        <col style="width: 150px" />
        <col style="width: *" />
      </colgroup>
      <tr>
        <th><spring:message code='pay.text.keyinDate' /><span class="must">*</span></th>
        <td>
          <div class="date_set w100p">
            <p>
              <input type="text" class="j_date" readonly id="keyinDateFr" name="keyinDateFr" placeholder="DD/MM/YYYY" value="${bfDay}" />
            </p>
            <span><spring:message code='sal.title.to' /></span>
            <p>
              <input type="text" class="j_date" readonly id="keyinDateTo" name="keyinDateTo" placeholder="DD/MM/YYYY" value="${toDay}"/>
            </p>
          </div>
        </td>
      </tr>
      <tr>
      </tr>
    </table>
    <ul class="right_btns">
      <li>
        <p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate' /></a></p>
      </li>
    </ul>
    <section class="search_result">
      <article class="grid_wrap">
        <div style="width:100%; height:500px; margin:0 auto;" id="report_grid_wrap" />
      </article>
    </section>

  </section>
</div>

