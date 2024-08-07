<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">
.my-custom-up div {
  color: #FF0000;
}

.my-row-style {
  background: #FFB6C1;
  font-weight: bold;
  color: #22741C;
}
</style>

<script type="text/javaScript">
  var myGridID;
  var batchInfoGridID;
  var batchConfGridID;
  var myUploadGridID;
  var selectedGridValue;

  var gridPros = {
    editable : false,
    showStateColumn : false,
    selectionMode : "singleRow"
  };

  var gridPros2 = {
    editable : false,
    showStateColumn : false,
    rowStyleFunction : function(rowIndex, item) {
      if (item.validStusId == "21") {
        return "my-row-style";
      }
      return "";
    }
  };

  var gridPros3 = {
    showStateColumn : false,
    headerHeight : 35,
    softRemoveRowMode : false
  };

  $(document).ready(
    function() {
      myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, null, gridPros);
      myUploadGridID = GridCommon.createAUIGrid( "grid_upload_wrap", uploadGridLayout, null, gridPros3);

      AUIGrid.bind(myGridID, "cellClick", function(event) {
        selectedGridValue = event.rowIndex;
      });

      $("#payMode").multipleSelect("setSelects", [ 105, 106, 107, 108 ]);
      $("#confirmStatus").multipleSelect("setSelects", [ 44 ]);
      $("#batchStatus").multipleSelect("setSelects", [ 1 ]);

      $('#uploadfile').on('change', function(evt) {
        var fileInput = this;
        var file = fileInput.files[0];

        if (!file) {
            var msgLabel = "<spring:message code='sal.text.attachment'/>"
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
            return;
        }

        var fileType = file.type;
        var fileName = file.name;

        var isCSV = fileName.endsWith('.csv');

        if (!isCSV) {
          Common.alert("<spring:message code='supplement.alert.supplementBatchUploadCsv' />");
          $("#uploadForm")[0].reset();
          AUIGrid.clearGridData(myUploadGridID);
          return;
        }

        if (!checkHTML5Brower()) {
          commitFormSubmit();
        } else {
           var data = null;
           var file = evt.target.files[0];
           if (typeof file == "undefined") {
             return;
           }

           var reader = new FileReader();
           reader.readAsText(file, "EUC-KR");
           reader.onload = function(event) {
             if (typeof event.target.result != "undefined") {
               AUIGrid.setCsvGridData(myUploadGridID, event.target.result, false);
               AUIGrid.removeRow(myUploadGridID, 0);
             } else {
               Common.alert("<spring:message code='pay.alert.noData'/>");
             }
           };

           reader.onerror = function() {
             Common.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
           };
         }
       });

       $('#excelDown').click(
         function() {
            GridCommon.exportTo("grid_wrap", "xlsx", "Supplement - Batch Payment Collection List");
         });
       });

    var columnLayout = [ {
      dataField : "batchId",
      headerText : "<spring:message code='pay.head.batchId'/>",
      editable : false
    }, {
      dataField : "codeName",
      headerText : "<spring:message code='sal.text.payMode'/>",
      editable : false
    }, {
      dataField : "name",
      headerText : "<spring:message code='pay.head.batchStatus'/>",
      editable : false
    }, {
      dataField : "name1",
      headerText : "<spring:message code='pay.head.confirmStatus'/>",
      editable : false
    }, {
      dataField : "updDt",
      headerText : "<spring:message code='pay.head.uploadDate'/>",
      editable : false
    }, {
     dataField : "userName",
      headerText : "<spring:message code='pay.head.uploadBy'/>",
      editable : false
    }, {
      dataField : "cnfmDt",
      headerText : "<spring:message code='pay.head.confirmDate'/>",
      editable : false
    }, {
      dataField : "c1",
      headerText : "<spring:message code='pay.head.confirmBy'/>",
      editable : false
    }, {
      dataField : "batchStusId",
      headerText : "",
      editable : false,
      visible : false
    }, {
      dataField : "cnfmStusId",
      headerText : "",
      editable : false,
      visible : false
    } ];

    var uploadGridLayout = [ {
      dataField : "0",
      headerText : "<spring:message code='pay.head.orderNo'/>",
      editable : true
    }, {
      dataField : "1",
      headerText : "<spring:message code='pay.head.TRNo'/>",
      editable : true
    }, {
      dataField : "2",
      headerText : "<spring:message code='pay.head.refNo'/>",
      editable : true
    }, {
      dataField : "3",
      headerText : "<spring:message code='pay.head.Amount'/>",
      editable : true,
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "4",
      headerText : "<spring:message code='pay.head.bankAcc'/>",
      editable : true
    }, {
      dataField : "5",
      headerText : "<spring:message code='pay.head.chqNo'/>",
      editable : true
    }, {
      dataField : "6",
      headerText : "<spring:message code='pay.head.issueBank'/>",
      editable : true
    }, {
      dataField : "7",
      headerText : "<spring:message code='pay.head.runningNo'/>",
      editable : true
    }, {
      dataField : "8",
      headerText : "<spring:message code='pay.head.eftNo'/>",
      editable : true
    }, {
      dataField : "9",
      headerText : "<spring:message code='pay.head.refDateMonth'/>",
      editable : true
    }, {
      dataField : "10",
      headerText : "<spring:message code='pay.head.refDateDay'/>",
      editable : true
    }, {
      dataField : "11",
      headerText : "<spring:message code='pay.head.refDateYear'/>",
      editable : true
    }, {
      dataField : "12",
      headerText : "<spring:message code='pay.head.bankChargeAmt'/>",
      editable : true
    }, {
      dataField : "13",
      headerText : "<spring:message code='pay.head.bankChargeAcc'/>",
      editable : true
    }, {
      dataField : "14",
      headerText : "<spring:message code='pay.head.trDate'/>",
      editable : true
    }, {
      dataField : "15",
      headerText : "<spring:message code='sal.text.collectorCode'/>",
      editable : true
    }, {
      dataField : "16",
      headerText : "<spring:message code='pay.head.payType'/>",
      editable : true
    }, {
      dataField : "17",
      headerText : "<spring:message code='pay.head.advanceMonth'/>",
      editable : true
    }, {
      dataField : "18",
      headerText : "<spring:message code='pay.head.remark'/>",
      editable : true
    }, {
      dataField : "19",
      headerText : "<spring:message code='pay.head.crc.cardNo'/>",
      editable : true
    }, {
      dataField : "20",
      headerText : "<spring:message code='pay.head.approvalCode'/>",
      editable : true
    }, {
      dataField : "21",
      headerText : "<spring:message code='pay.head.cardMode'/>",
      editable : true
    }, {
      dataField : "22",
      headerText : "<spring:message code='sal.title.text.paymentChnnl'/>",
      editable : true
    } ];

    var batchInfoLayout = [ {
      dataField : "code",
      headerText : "<spring:message code='pay.head.validStatus'/>",
      editable : false,
      width : 100
    }, {
      dataField : "validRem",
      headerText : "<spring:message code='pay.head.validRemark'/>",
      editable : false,
      width : 180
    }, {
      dataField : "userOrdNo",
      headerText : "<spring:message code='pay.head.orderNo'/>",
      editable : false
    }, {
      dataField : "userTrNo",
      headerText : "<spring:message code='pay.head.trNo'/>",
      editable : false
    }, {
      dataField : "userRefNo",
      headerText : "<spring:message code='pay.head.refNo'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userAmt",
      headerText : "<spring:message code='pay.head.amount'/>",
      editable : false,
      width : 150,
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "userBankAcc",
      headerText : "<spring:message code='pay.head.bankAcc'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userChqNo",
      headerText : "<spring:message code='pay.head.chqNo'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userIssBank",
      headerText : "<spring:message code='pay.head.issueBank'/>",
      editable : false
    }, {
      dataField : "userRunNo",
      headerText : "<spring:message code='pay.head.runningNo'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userEftNo",
      headerText : "<spring:message code='pay.head.eftNo'/>",
      editable : false
    }, {
      dataField : "userRefDtMonth",
      headerText : "<spring:message code='pay.head.refDateMonth'/>",
      editable : false,
      width : 130
    }, {
      dataField : "userRefDtDay",
      headerText : "<spring:message code='pay.head.refDateDay'/>",
      editable : false,
      width : 130
    }, {
      dataField : "userRefDtYear",
      headerText : "<spring:message code='pay.head.refDateYear'/>",
      editable : false,
      width : 130
    }, {
      dataField : "userBcAmt",
      headerText : "<spring:message code='pay.head.bankChargeAmt'/>",
      editable : false,
      width : 150,
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "userBcAcc",
      headerText : "<spring:message code='pay.head.bankChargeAcc'/>",
      editable : false,
      width : 150
    }, {
      dataField : "payChannel",
      headerText : "<spring:message code='sal.title.text.paymentChnnl'/>",
      editable : false,
      width : 150
    } ];

    var batchListLayout = [{
      dataField : "history",
      width : 30,
      headerText : " ",
      renderer : {
        type : "IconRenderer",
        iconTableRef : {
          "default" : "${pageContext.request.contextPath}/resources/images/common/icon_gabage_s.png"// default
        },
        iconWidth : 16,
        iconHeight : 16,
        onclick : function(rowIndex, columnIndex, value, item) {
          if (item.validStusId == "4" || item.validStusId == "21") {
            fn_removeItem(item.detId);
          } else {
            Common.alert("<spring:message code='supplement.alert.supplementBatchPmtRemove'/>");
            return;
          }
        }
      }
    }, {
      dataField : "code",
      headerText : "<spring:message code='pay.head.validStatus'/>",
      editable : false,
      width : 100
    }, {
      dataField : "validRem",
      headerText : "<spring:message code='pay.head.validRemark'/>",
      editable : false,
      width : 250
    }, {
      dataField : "userOrdNo",
      headerText : "<spring:message code='pay.head.orderNo'/>",
      editable : false
    }, {
      dataField : "userTrNo",
      headerText : "<spring:message code='pay.head.trNo'/>",
      editable : false
    }, {
      dataField : "userRefNo",
      headerText : "<spring:message code='pay.head.refNo'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userAmt",
      headerText : "<spring:message code='pay.head.amount'/>",
      editable : false,
      width : 150,
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "userBankAcc",
      headerText : "<spring:message code='pay.head.bankAcc'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userChqNo",
      headerText : "<spring:message code='pay.head.chqNo'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userIssBank",
      headerText : "<spring:message code='pay.head.issueBank'/>",
      editable : false
    }, {
      dataField : "userRunNo",
      headerText : "<spring:message code='pay.head.runningNo'/>",
      editable : false,
      width : 150
    }, {
      dataField : "userEftNo",
      headerText : "<spring:message code='pay.head.eftNo'/>",
      editable : false
    }, {
      dataField : "userRefDtMonth",
      headerText : "<spring:message code='pay.head.refDateMonth'/>",
      editable : false,
      width : 130
    }, {
      dataField : "userRefDtDay",
      headerText : "<spring:message code='pay.head.refDateDay'/>",
      editable : false,
      width : 130
    }, {
      dataField : "userRefDtYear",
      headerText : "<spring:message code='pay.head.refDateYear'/>",
      editable : false,
      width : 130
    }, {
      dataField : "userBcAmt",
      headerText : "<spring:message code='pay.head.bankChargeAmt'/>",
      editable : false,
      width : 150,
      dataType : "numeric",
      formatString : "#,##0.00"
    }, {
      dataField : "userBcAcc",
      headerText : "<spring:message code='pay.head.bankChargeAcc'/>",
      editable : false,
      width : 150
    }, {
      dataField : "cardNo",
      headerText :  "<spring:message code='sal.text.creditCardNo'/>",
      editable : false,
      width : 150
    }, {
      dataField : "approvalCode",
      headerText : "<spring:message code='sal.text.approvalCode'/>",
      editable : false,
      width : 150
    }, {
      dataField : "payChannel",
      headerText : "<spring:message code='sal.title.text.paymentChnnl'/>",
      editable : false,
      width : 150
    } ];

  function searchList() {
    Common.ajax("GET", "/supplement/payment/selectSupplementBatchPaymentList.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  function fn_viewBatchPopup() {
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1) {
      var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");

      Common.ajax("GET", "/supplement/payment/selectSupplementBatchInfo.do", { "batchId" : batchId }, function(result) {
        $('#view_popup_wrap').show();
        var confAt = result.batchPaymentView.cnfmDt;
        var confAtArray = confAt.split('-');
        var cnvrAt = result.batchPaymentView.cnvrDt;
        var cnvrAtArray = cnvrAt.split('-');

        $('#txtBatchId').text(result.batchPaymentView.batchId);
        $('#txtBatchStatus').text(result.batchPaymentView.name);
        $('#txtConfirmStatus').text(result.batchPaymentView.name1);
        $('#txtPayMode').text(result.batchPaymentView.codeName);
        $('#txtUploadBy').text(result.batchPaymentView.userName);
        $('#txtUploadAt').text(result.batchPaymentView.crtDt);
        $('#txtConfirmBy').text(result.batchPaymentView.c1);
        $('#txtBatchIsAdv').text(result.batchPaymentView.batchIsAdv);

        if (confAtArray[2].substr(0, 4) > 1900) {
          $('#txtConfirmAt').text(result.batchPaymentView.cnfmDt);
        } else {
          $('#txtConfirmAt').text("");
        }

        if (cnvrAtArray[2].substr(0, 4) > 1900) {
          $('#txtConvertAt').text(
              result.batchPaymentView.cnvrDt);
           } else {
              $('#txtConvertAt').text("");
           }
           $('#txtConvertBy').text(result.batchPaymentView.c2);

           $('#totalAmount').text(result.totalValidAmt.sysAmt);
           $('#totalItem').text(result.totalItem);
           $('#totalValid').text(result.totalValidAmt.c1);
           $('#totalInvalid').text((result.totalItem) - (result.totalValidAmt.c1));

           AUIGrid.destroy(batchInfoGridID);
           batchInfoGridID = GridCommon.createAUIGrid("view_grid_wrap", batchInfoLayout, null, gridPros2);
           AUIGrid.setGridData(batchInfoGridID, result.batchPaymentDetList);
           AUIGrid.resize(batchInfoGridID, 1140, 280);
         });
    } else {
      Common.alert("<spring:message code='service.msg.selectRcd'/>");
      return;
    }
  }

  function fn_batchPayItemList(validStatusId, gubun) {
    var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");

    Common.ajax("GET", "/supplement/payment/selectBatchPayItemList.do", {
      "batchId" : batchId,
      "validStatusId" : validStatusId
    }, function(result) {
      if (gubun == "V") {//VIEW
        if (validStatusId == "4") {
          $('#itemGubun').text("Valid Items");
        } else if (validStatusId == "21") {
          $('#itemGubun').text("Invalid Items");
        } else {
          $('#itemGubun').text("All Items");
        }

        AUIGrid.destroy(batchInfoGridID);
        batchInfoGridID = GridCommon.createAUIGrid("view_grid_wrap", batchInfoLayout, null, gridPros2);
        AUIGrid.setGridData(batchInfoGridID, result.batchPaymentDetList);
        AUIGrid.resize(batchInfoGridID, 1140, 280);

      } else if (gubun == "C") {//CONFIRM
        if (validStatusId == "4") {
          $('#itemGubun_conf').text("Valid Items");
        } else if (validStatusId == "21") {
          $('#itemGubun_conf').text("Invalid Items");
        } else {
          $('#itemGubun_conf').text("All Items");
        }

        AUIGrid.destroy(batchConfGridID);
        batchConfGridID = GridCommon.createAUIGrid("conf_grid_wrap", batchListLayout, null, gridPros2);
        AUIGrid.setGridData(batchConfGridID, result.batchPaymentDetList);
        AUIGrid.resize(batchConfGridID, 1140, 280);
      }
    });
  }

  function fn_confirmBatchPopup() {
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

    if (selectedItem[0] > -1) {
      var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");
      var cnfmStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "cnfmStusId");
      var batchStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchStusId");

      if (batchStusId == "1") {
        if (cnfmStusId == "77") {
          $('#btnConf').hide();
        } else {
          $('#btnConf').show();
        }

        Common.ajax( "GET", "/supplement/payment/selectSupplementBatchInfo.do", { "batchId" : batchId },
          function(result) {
            $('#conf_popup_wrap').show();

            var confAt = result.batchPaymentView.cnfmDt;
            var confAtArray = confAt.split('-');
            var cnvrAt = result.batchPaymentView.cnvrDt;
            var cnvrAtArray = cnvrAt.split('-');

            $('#txtBatchId_conf').text(result.batchPaymentView.batchId);
            $('#txtBatchStatus_conf').text(result.batchPaymentView.name);
            $('#txtConfirmStatus_conf').text(result.batchPaymentView.name1);
            $('#txtPayMode_conf').text(result.batchPaymentView.codeName);
            $('#txtUploadBy_conf').text(result.batchPaymentView.userName);
            $('#txtUploadAt_conf').text(result.batchPaymentView.crtDt);
            $('#txtConfirmBy_conf').text(result.batchPaymentView.c1);
            $('#txtConvertBy_conf').text(result.batchPaymentView.c2);
            $('#txtBatchIsAdv_conf').text(result.batchPaymentView.batchIsAdv);

            if (confAtArray[2].substr(0, 4) > 1900) {
              $('#txtConfirmAt_conf').text(result.batchPaymentView.cnfmDt);
            } else {
              $('#txtConfirmAt_conf').text("");
            }

            if (cnvrAtArray[2].substr(0, 4) > 1900) {
              $('#txtConvertAt_conf').text(result.batchPaymentView.cnvrDt);
            } else {
              $('#txtConvertAt_conf').text("");
            }

            $('#totalAmount_conf').text(result.totalValidAmt.sysAmt);
            $('#totalItem_conf').text(result.totalItem);
            $('#totalValid_conf').text(result.totalValidAmt.c1);
            $('#totalInvalid_conf').text((result.totalItem) - (result.totalValidAmt.c1));

            AUIGrid.destroy(batchConfGridID);
            batchConfGridID = GridCommon.createAUIGrid("conf_grid_wrap", batchListLayout, null, gridPros2);
            AUIGrid.setGridData(batchConfGridID, result.batchPaymentDetList);
            AUIGrid.resize(batchConfGridID, 1140, 280);
          });
      } else {
        Common.alert("<spring:message code='pay.alert.isNotBatch' arguments='"+batchId+"' htmlEscape='false'/>");
      }    } else {
      Common.alert("<spring:message code='pay.alert.noBatchSelected'/>");
    }
  }

  function fn_removeItem(detId) {
    Common.ajax("GET", "/supplement/payment/updRemoveItem.do", { "detId" : detId },
      function(result) {
        fn_confirmBatchPopup();
        Common.alert(result.message);
      });
  }

  function fn_confirmBatch() {
    Common.confirm("<spring:message code='pay.alert.confPayBatch'/>",
      function() {
        var totalInvalid = $('#totalInvalid_conf').text();
        var totalValid = $('#totalValid_conf').text();
        var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");

        if (totalInvalid > 0) {
          Common.alert("<spring:message code='pay.alert.invalidItemExist'/>");
          return;
        } else {
          if (totalValid > 0) {
            Common.ajax( "GET", "/supplement/payment/saveConfirmBatch.do", { "batchId" : batchId },
              function(result) {
                //fn_confirmBatchPopup();
                $('#btnConf').hide();
                $('#btnDeactivate').hide();
                Common.alert(result.message);
                fn_hideViewPop("#conf_popup_wrap");
              });
          } else {
            Common.alert("<spring:message code='pay.alert.noValidItemFound'/>");
            return;
          }
        }
      });
  }

  function fn_deactivateBatch() {
    Common.confirm("<spring:message code='pay.alert.deactivatePayBatch'/>",
      function() {
        var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");
          Common.ajax("GET", "/supplement/payment/saveDeactivateBatch.do", { "batchId" : batchId }, function(result) {
            $('#btnConf').hide();
            $('#btnDeactivate').hide();
            Common.alert(result.message);
            fn_hideViewPop("#conf_popup_wrap");
          });
      });
  }

  function fn_uploadPopup() {
    $('#upload_popup_wrap').show();
    $("#paymentMode").val("108");
    AUIGrid.resize(myUploadGridID);
  }

  function fn_uploadFile() {
    var formData = new FormData();
    var payModeId = $("#paymentMode option:selected").val();
    var msgLabel = "";
    var message = "";

    if (FormUtil.checkReqValue($("#paymentMode"))) {
      msgLabel = "<spring:message code='sal.text.payMode'/>"
      Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
      return;
    }

    if (FormUtil.checkReqValue($("#uploadfile"))) {
      msgLabel = "<spring:message code='sal.text.attachment'/>"
      Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ msgLabel +"'/>");
      return;
    }


    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("payModeId", payModeId);

    Common.ajaxFile("/supplement/payment/csvFileUpload.do", formData,
        function(result) {
          $('#paymentMode option[value=""]').attr('selected', 'selected');
          if (result.code == "00") {
            message = result.message;
          } else {
            message = result.message;
          }

          Common.alert(message, function() {
            hideViewPopup('#upload_popup_wrap');
          });
        });
  }

  function fn_validation() {
    var data = GridCommon.getGridData(myUploadGridID);
    var length = data.all.length;

    if (length < 1) {
      Common.alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
      return false;
    }

    if (length > 0) {
      for (var i = 0; i < length - 1; i++) {
        if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "0")))) {
          var text = '<spring:message code="pay.head.orderNo"/>';
          Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ text +"'/>");
          return false;
        }

        if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "4")))) {
          var text = '<spring:message code="pay.head.Amount"/>';
          Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ text +"'/>");
          return false;
        }

        if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "5")))) {
          var text = '<spring:message code="pay.head.bankAcc"/>';
          Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ text +"'/>");
          return false;
        }
        if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "10")))) {
          var text = '<spring:message code="pay.head.refDateMonth"/>';
          Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ text +"'/>");
          return false;
        }
        if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "11")))) {
          var text = '<spring:message code="pay.head.refDateDay"/>';
          Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ text +"'/>");
          return false;
        }
        if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "12")))) {
          var text = '<spring:message code="pay.head.refDateYear"/>';
          Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ text +"'/>");
          return false;
        }
        if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "17")))) {
          var text = '<spring:message code="pay.head.payType"/>';
          Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ text +"'/>");
          return false;
        }
      }
    }
    return true;
  }

  function fn_checkMandatory(objValue) {
    if (objValue == null || objValue == "" || objValue == "undefined") {
      return true;
    }
  }

  function onlyNumber(obj) {
    $(obj).keyup(function() {
      $(this).val($(this).val().replace(/[^0-9]/g, ""));
    });
  }

  function fn_hideViewPop(val) {
    $(val).hide();

    if ("#conf_popup_wrap" == val) {
      $('#txtBatchId_conf').text("");
      $('#txtBatchStatus_conf').text("");
      $('#txtConfirmStatus_conf').text("");
      $('#txtPayMode_conf').text("");
      $('#txtUploadBy_conf').text("");
      $('#txtUploadAt_conf').text("");
      $('#txtConfirmBy_conf').text("");
      $('#txtConfirmAt_conf').text("");
      $('#totalAmount_conf').text("");
      $('#totalItem_conf').text("");
      $('#totalValid_conf').text("");
      $('#totalInvalid_conf').text("");

      $("#paymentInfo_conf").trigger("click");
    } else if ("#view_popup_wrap" == val) {
      $('#txtBatchId').text("");
      $('#txtBatchStatus').text("");
      $('#txtConfirmStatus').text("");
      $('#txtPayMode').text("");
      $('#txtUploadBy').text("");
      $('#txtUploadAt').text("");
      $('#txtConfirmBy').text("");
      $('#txtConfirmAt').text("");
      $('#totalAmount').text("");
      $('#totalItem').text("");
      $('#totalValid').text("");
      $('#totalInvalid').text("");

      $("#paymentInfo").trigger("click");
    }

    searchList();
  }

  function fn_clear() {
    $("#searchForm")[0].reset();
    $("#payMode").multipleSelect("checkAll");
    $("#confirmStatus").multipleSelect("setSelects", [ 44 ]);
    $("#batchStatus").multipleSelect("setSelects", [ 1 ]);
  }

  function checkHTML5Brower() {
    var isCompatible = false;
    if (window.File && window.FileReader && window.FileList && window.Blob) {
      isCompatible = true;
    }

    return isCompatible;
  };

  function commitFormSubmit() {
    AUIGrid.showAjaxLoader(myUploadGridID);

    $('#uploadForm').ajaxSubmit({
      type : "json",
      success : function(responseText, statusText) {
        if (responseText != "error") {
          var csvText = responseText;
          csvText = csvText.replace(/\r?\n/g, "\r\n");

          AUIGrid.setCsvGridData(myUploadGridID, csvText);
          AUIGrid.removeAjaxLoader(myUploadGridID);
          AUIGrid.removeRow(myUploadGridID, 0);
        }
      },
      error : function(e) {
        Common.alert("ajaxSubmit Error : " + e);
      }
    });

  }

  function uploadClear() {
    if ($("#uploadfile").val() == "" || $("#uploadfile").val() == null) {
      Common.alert('<spring:message code="supplement.alert.noDataRemove" />');
      return;
    }

    $("#uploadForm")[0].reset();
    AUIGrid.clearGridData(myUploadGridID);
    $("#paymentMode").val("108");
  }

  hideViewPopup = function(val) {
    $(val).hide();

    if (val == '#upload_wrap') {
      uploadClear();
    }
  }
</script>

<section id="content">
  <ul class="path">
    <li>
    <img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  </ul>
  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on"><spring:message code='pay.text.myMenu' /></a>
    </p>
    <h2><spring:message code='supplement.title.supplementPmtUploadConfirm' /></h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" onclick="fn_uploadPopup();"><spring:message code='supplement.btn.batPmtUpload' /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" onclick="fn_confirmBatchPopup();"><spring:message code='supplement.btn.batPmtConfirm' /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="javascript:fn_viewBatchPopup();"><spring:message code='sys.scm.inventory.ViewDetail' /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a href="#" onclick="searchList();">
              <span class="search"></span>
              <spring:message code='sys.btn.search' />
            </a>
          </p>
        </li>
      </c:if>
      <!-- <li>
        <p class="btn_blue">
          <a href="#" onclick="fn_clear();">
            <span class="clear"></span>
            <spring:message code='sys.btn.clear' />
          </a>
        </p>
      </li>  -->
    </ul>
  </aside>

  <section class="search_table">
    <form id="searchForm" action="#" method="post">
      <input type="hidden" id="validStatusId" name="validStatusId">
      <input type="hidden" id="payType" name="payType" value="577">
      <input type="hidden" id="payCustType" name="payCustType" value="1368">
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 170px" />
          <col style="width: *" />
          <col style="width: 170px" />
          <col style="width: *" />
          <col style="width: 170px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='supplement.text.pmtBatId' /></th>
            <td>
              <input type="text" id="batchId" name="batchId" title="" placeholder="Payment Batch ID" class="w100p" onkeydown="onlyNumber(this)" />
            </td>
            <th scope="row"><spring:message code='sal.text.payMode' /></th>
            <td>
              <!-- <select id="payMode" name="payMode" class="multy_select w100p" multiple="multiple">
                <option value="105">Cash (CSH)</option>
                <option value="106">Cheque (CHQ)</option>
                <option value="108">Online Payment (ONL)</option>
                <option value="107">Credit Card (CRC)</option>
              </select> -->
              <select id="payMode" name="payMode" class="multy_select w100p" multiple="multiple">
                <c:forEach var="list" items="${paymentMode}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code='supplement.text.pmtBatStat' /></th>
            <td>
              <!-- <select id="batchStatus" name="batchStatus" class="multy_select w100p" multiple="multiple">
                <option value="1">Active</option>
                <option value="4">Completed</option>
                <option value="8">Inactive</option>
              </select> -->
              <select id="batchStatus" name="batchStatus" class="multy_select w100p" multiple="multiple">
                <c:forEach var="list" items="${paymentBatchStatus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='supplement.text.pmtConfirmStat' /></th>
            <td>
              <!-- <select id="confirmStatus" name="confirmStatus" class="multy_select w100p" multiple="multiple">
                <option value="44">Pending</option>
                <option value="77">Confirm</option>
                <option value="8">Inactive</option>
              </select> -->
              <select id="confirmStatus" name="confirmStatus" class="multy_select w100p" multiple="multiple">
                <c:forEach var="list" items="${paymentBatchConfirmationStatus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code='supplement.text.pmtBatUploadBy' /></th>
            <td>
              <input type="text" id="creator" name="creator" title="" placeholder="Create User Name" class="w100p" />
            </td>
            <th scope="row"><spring:message code='supplement.text.pmtBatUploadDt' /></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input type="text" id="createDateFr" name="createDateFr" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
                <span><spring:message code='sal.text.to' /></span>
                <p>
                  <input type="text" id="createDateTo" name="createDateTo" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
              </div>
            </td>
          </tr>
        </tbody>
      </table>

      <aside class="link_btns_wrap">
        <p class="show_btn">
          <a href="#">
            <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
          </a>
        </p>
        <dl class="link_list">
          <dt>Link</dt>
          <dd>
            <ul class="btns">
            </ul>
            <p class="hide_btn">
              <a href="#">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" />
              </a>
            </p>
          </dd>
        </dl>
      </aside>
    </form>
  </section>

  <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
      <li>
        <p class="btn_grid">
          <a href="#" id="excelDown"><spring:message code='pay.btn.generate' /></a>
        </p>
      </li>
    </c:if>
  </ul>

  <section class="search_result">
    <article class="grid_wrap">
      <div style="width:100%; height:480px; margin:0 auto;" id="grid_wrap" />
    </article>
  </section>
</section>

<!-- Batch Payment View -->
<div id="view_popup_wrap" class="popup_wrap size_big" style="display: none;">
  <header class="pop_header">
    <h1><spring:message code='supplement.title.supplementBatPmtUpload' /></h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="#" onclick="fn_hideViewPop('#view_popup_wrap');"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <section class="tap_wrap">
      <ul class="tap_type1">
        <li><a href="#" class="on" id="paymentInfo"><spring:message code='supplement.text.generalInfo' /></a></li>
        <li><a href="#"><spring:message code='supplement.text.batPmtDtlLst' /></a></li>
      </ul>
      <article class="tap_area">
        <table class="type1">
          <caption>table</caption>
          <colgroup>
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 150px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><spring:message code='supplement.text.pmtBatId' /></th>
              <td>
                <span id="txtBatchId"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatStat' /></th>
              <td id="txtBatchStatus"></td>
              <th scope="row"><spring:message code='supplement.text.pmtConfirmStat' /></th>
              <td>
                <span id="txtConfirmStatus"></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='sal.text.payMode' /></th>
              <td>
                <span id="txtPayMode"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatUploadBy' /></th>
              <td>
                <span id="txtUploadBy"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatUploadDt' /></th>
              <td>
                <span id="txtUploadAt"></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='supplement.text.pmtBatConfirmBy' /></th>
              <td>
                <span id="txtConfirmBy"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatConfirmDt' /></th>
              <td>
                <span id="txtConfirmAt"></span>
              </td>
              <!-- <th scope="row">Advance Batch</th>
              <td><span id="txtBatchIsAdv"></span></td> -->
              <th scope="row"></th>
              <td></td>
            </tr>
            <!-- <tr>
              <th scope="row">Convert By</th>
              <td><span id="txtConvertBy"></span></td>
              <th scope="row">Convert At</th>
              <td><span id="txtConvertAt"></span></td>
              <th scope="row">Total Amount (Valid)</th>
              <td><span id="totalAmount"></span></td>
            </tr> -->
            <tr>
              <th scope="row"><spring:message code='sal.title.text.totItem' /></th>
              <td>
                <span id="totalItem"></span>
              </td>
              <th scope="row"><spring:message code='sal.text.totalValidItem' /></th>
              <td>
                <span id="totalValid"></span>
              </td>
              <th scope="row"><spring:message code='sal.text.totalInvalidItem' /></th>
              <td>
                <span id="totalInvalid"></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='sales.totAmt_RM' /> (<spring:message code='pay.btn.validItems' />)</th>
              <td colspan="5">
                <span id="totalItem"></span>
              </td>
            </tr>
          </tbody>
        </table>
      </article>
      <article class="tap_area">
        <aside class="title_line">
          <!-- <h2 id="itemGubun">All Items</h2> -->
          <ul class="right_btns">
            <li>
              <p class="btn_grid">
                <a href="javascript:fn_batchPayItemList('' , 'V');"><spring:message code='pay.btn.allItems' /></a>
              </p>
            </li>
            <li>
              <p class="btn_grid">
                <a href="javascript:fn_batchPayItemList('4' , 'V');"><spring:message code='pay.btn.validItems' /></a>
              </p>
            </li>
            <li>
              <p class="btn_grid">
                <a href="javascript:fn_batchPayItemList('21' , 'V');"><spring:message code='pay.btn.invalidItems' /></a>
              </p>
            </li>
          </ul>
        </aside>
        <section class="search_result">
          <article class="grid_wrap">
            <div style="width:100%; height:480px; margin:0 auto;" id="view_grid_wrap" />
          </article>
        </section>
      </article>
    </section>
  </section>
</div>

<!-- Batch Payment Confirmation -->
<div id="conf_popup_wrap" class="popup_wrap size_big" style="display: none;">
  <header class="pop_header">
    <h1><spring:message code='supplement.title.supplementBatPmtConfirm' /></h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="#" onclick="fn_hideViewPop('#conf_popup_wrap');"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <section class="tap_wrap">
      <ul class="tap_type1">
        <li><a href="#" class="on" id="paymentInfo_conf"><spring:message code='supplement.text.generalInfo' /></a></li>
        <li><a href="#"><spring:message code='supplement.text.batPmtDtlLst' /></a></li>
      </ul>
      <article class="tap_area">
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
              <th scope="row"><spring:message code='supplement.text.pmtBatId' /></th>
              <td>
                <span id="txtBatchId_conf"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatStat' /></th>
              <td>
                <span id="txtBatchStatus_conf"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtConfirmStat' /></th>
              <td>
                <span id="txtConfirmStatus_conf"></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='sal.text.payMode' /></th>
              <td>
                <span id="txtPayMode_conf"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatUploadBy' /></th>
              <td>
                <span id="txtUploadBy_conf"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatUploadDt' /></th>
              <td>
                <span id="txtUploadAt_conf"></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='supplement.text.pmtBatConfirmBy' /></th>
              <td>
                <span id="txtConfirmBy_conf"></span>
              </td>
              <th scope="row"><spring:message code='supplement.text.pmtBatConfirmDt' /></th>
              <td>
                <span id="txtConfirmAt_conf"></span>
              </td>
              <!-- <th scope="row">Total Amount (Valid)</th>
              <td><span id="totalAmount_conf"></span></td> -->
              <th scope="row"></th>
              <td></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='sal.title.text.totItem' /></th>
              <td>
                <span id="totalItem_conf"></span>
              </td>
              <th scope="row"><spring:message code='sal.text.totalValidItem' /></th>
              <td>
                <span id="totalValid_conf"></span>
              </td>
              <th scope="row"><spring:message code='sal.text.totalInvalidItem' /></th>
              <td>
                <span id="totalInvalid_conf"></span>
              </td>
            </tr>
          </tbody>
        </table>
      </article>
      <article class="tap_area">
        <aside class="title_line">
          <!-- <h2 id="itemGubun_conf">All Items</h2> -->
          <ul class="right_btns">
            <li>
              <p class="btn_grid">
                <a href="javascript:fn_batchPayItemList('','C');"><spring:message code='pay.btn.allItems' /></a>
              </p>
            </li>
            <li>
              <p class="btn_grid">
                <a href="javascript:fn_batchPayItemList('4' , 'C');"><spring:message code='pay.btn.validItems' /></a>
              </p>
            </li>
            <li>
              <p class="btn_grid">
                <a href="javascript:fn_batchPayItemList('21' , 'C');"><spring:message code='pay.btn.invalidItems' /></a>
              </p>
            </li>
          </ul>
        </aside>
        <section class="search_result">
          <article class="grid_wrap">
            <div style="width:100%; height:450px; margin:0 auto;" id="conf_grid_wrap" />
          </article>
        </section>
      </article>
      <ul class="center_btns mt20">
        <li>
          <p class="btn_blue2 big">
            <a href="javascript:fn_confirmBatch();" id="btnConf"><spring:message code='pay.btn.confirm' /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue2 big">
            <a href="javascript:fn_deactivateBatch();" id="btnDeactivate"><spring:message code='pay.btn.deactivate' /></a>
          </p>
        </li>
      </ul>
    </section>
  </section>
</div>

<!-- Batch Payment Upload -->
<div id="upload_popup_wrap" class="popup_wrap" style="display: none;">
  <header class="pop_header">
    <h1><spring:message code='supplement.title.supplementPmtUpload' /></h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a href="${pageContext.request.contextPath}/resources/download/supplement/SupplementBatchPaymentFormat.csv"><spring:message code='pay.btn.downloadTemplate' /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a href="#" onclick="fn_hideViewPop('#upload_popup_wrap')"><spring:message code='sys.btn.close' /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <form action="#" method="post" id="uploadForm">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='sal.text.payMode' /><span class="must">*</span></th>
            <td>
              <!-- <select class="" id="paymentMode" name="paymentMode" class="w100p">
                <option value="">Choose One</option>
                <option value="105">Cash (CSH)</option>
                <option value="106">Cheque (CHQ)</option>
                <option value="108">Online Payment (ONL)</option>
                <option value="107">Credit Card (CRC)</option>
              </select> -->
              <select id="paymentMode" name="paymentMode" class="w100p">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${paymentMode}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.attachment' /><span class="must">*</span></th>
            <td>
              <div class="auto_file">
                <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
              </div>
            </td>
          </tr>
          <tr>
          <td colspan="2">
            <span class="red_text">** <spring:message code="supplement.alert.supplementBatchUploadCsvNotice" /></span>
          </td>
          </tr>
        </tbody>
      </table>
    </form>
    <ul class="center_btns mt20">
      <li>
        <p class="btn_blue2 big">
          <a href="javascript:fn_uploadFile();"><spring:message code='sys.btn.upload' /> <spring:message code='sal.text.attachment' /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a href="javascript:uploadClear();"><spring:message code='sys.btn.remove' /> <spring:message code='sal.text.attachment' /></a>
        </p>
      </li>
    </ul>

    <section class="search_result">
      <article class="grid_wrap">
        <div style="width:100%; height:450px; margin:0 auto;" id="grid_upload_wrap" />
      </article>
    </section>

  </section>
</div>