<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.1          RE-STRUCTURE JSP AND ADD CHECKING FOR SETTLE DATE
 -->

<script type="text/javascript">
  var myFltGrd10;
  var asMalfuncResnId;

  $(document).ready(
      function() {
        createCFilterAUIGrid();

        doGetCombo('/services/as/getASFilterInfo.do?AS_ID=${AS_ID}', '', '', 'ddlFilterCode', 'S', '');
        doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '', 'ddlFilterExchangeCode', 'S', '');
        doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=166', '', '', 'ddlFailReason', 'S', '');
        //doGetCombo('/services/as/getASMember.do', '', '','ddlCTCode', 'S' , 'fn_setCTcodeValue');
        //doGetCombo('/services/as/getBrnchId.do', '', '','ddlDSCCode', 'S' , '');
        doGetCombo('/services/as/inHouseGetProductMasters.do', '', '', 'productGroup', 'S', '');
        fn_getErrMstList('${ORD_NO}');

        AUIGrid.bind(myFltGrd10, "addRow", auiAddRowHandler);
        AUIGrid.bind(myFltGrd10, "removeRow", auiRemoveRowHandler);

        var isF = true;
        AUIGrid.bind(myFltGrd10, "rowStateCellClick", function(event) {
          if (event.marker == "added") {
            if (event.item.filterType == "CHG") {
              var fChage = Number($("#txtFilterCharge").val());
              var totchrge = Number($("#txtTotalCharge").val());

              $("#txtFilterCharge").val(fChage - Number(event.item.filterTotal));
              $("#txtTotalCharge").val(totchrge - Number(event.item.filterTotal));
            }
          } else if (event.marker == "removed") {
            if (event.item.filterType == "CHG") {
              var fChage = Number($("#txtFilterCharge").val());
              var totchrge = Number($("#txtTotalCharge").val());

              $("#txtFilterCharge").val(fChage + Number(event.item.filterTotal));
              $("#txtTotalCharge").val(totchrge + Number(event.item.filterTotal));
            }

          } else if (event.marker == "added-edited") {
          }
        });
      });

  function createCFilterAUIGrid() {
    var clayout = [ {
      dataField : "filterType",
      headerText : "Type",
      editable : false
    }, {
      dataField : "filterDesc",
      headerText : "Description",
      width : 200
    }, {
      dataField : "filterExCode",
      headerText : "Exchange Code ",
      width : 80
    }, {
      dataField : "filterQty",
      headerText : "Qty",
      width : 80
    }, {
      dataField : "filterPrice",
      headerText : "Price",
      width : 80,
      dataType : "number",
      formatString : "#,000.00",
      editable : false
    }, {
      dataField : "filterTotal",
      headerText : "Total",
      width : 80,
      dataType : "number",
      formatString : "#,000.00",
      editable : false
    }, {
      dataField : "filterRemark",
      headerText : "Remark",
      width : 200,
      editable : false
    }, {
      dataField : "undefined",
      headerText : " ",
      width : 110,
      renderer : {
        type : "ButtonRenderer",
        labelText : "Remove",
        onclick : function(rowIndex, columnIndex, value, item) {
          AUIGrid.removeRow(myFltGrd10, rowIndex);
          AUIGrid.removeSoftRows(myFltGrd10); //completed remove from AUIGrid cyc
        }
      }
    }, {
      dataField : "filterId",
      headerText : "filterId",
      width : 150,
      editable : false,
      visible : false
    }];

    var gridPros2 = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      fixedColumnCount : 1,
      selectionMode : "singleRow",
      showRowNumColumn : true
    };

    myFltGrd10 = GridCommon.createAUIGrid("asfilter_grid_wrap", clayout, "", gridPros2);
    AUIGrid.resize(myFltGrd10, 950, 200);
  }

  function auiAddRowHandler(event) {
  }

  function auiRemoveRowHandler(event) {
    if (event.items[0].filterType == "CHG") {
      var fChage = Number($("#txtFilterCharge").val());
      var totchrge = Number($("#txtTotalCharge").val());

      $("#txtFilterCharge").val(fChage - Number(event.items[0].filterTotal));
      $("#txtTotalCharge").val(totchrge - Number(event.items[0].filterTotal));
    }
  }

  function fn_setASRulstSVC0004DInfo() {
  }

  function fn_getErrMstList(_ordNo) {
    var SALES_ORD_NO = _ordNo;
    $("#ddlErrorCode option").remove();
    doGetCombo('/services/as/getErrMstList.do?SALES_ORD_NO=' + SALES_ORD_NO, '', '', 'ddlErrorCode', 'S', 'fn_errCallbackFun');
  }

  function fn_errMst_SelectedIndexChanged() {
    var DEFECT_TYPE_CODE = $("#ddlErrorCode").val();

    $("#ddlErrorDesc option").remove();
    doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE=' + DEFECT_TYPE_CODE, '', '', 'ddlErrorDesc', 'S', '');
  }

  function fn_getASRulstEditFilterInfo() {
    Common.ajax("GET", "/services/as/getASRulstEditFilterInfo", {
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val()
    }, function(result) {
      AUIGrid.setGridData(myFltGrd10, result);
    });
  }

  function fn_getASRulstSVC0004DInfo() {
    Common.ajax("GET", "/services/as/getASRulstSVC0004DInfo", {
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val()
    }, function(result) {
      if (result != "") {
        fn_setSVC0004dInfo(result);
      }
    });
  }

  function fn_callback_ddlErrorDesc() {
    $("#ddlErrorDesc").val(asMalfuncResnId);
  }

  function fn_setSVC0004dInfo(result) {
    $("#creator").val(result[0].c28);
    $("#creatorat").val(result[0].asResultCrtDt);
    $("#txtResultNo").val(result[0].asResultNo);
    if (result[0].asResultStusId == "1") {
      $("#ddlStatus").val("");
    } else {
      $("#ddlStatus").val(result[0].asResultStusId);
    }
    $("#dpSettleDate").val(result[0].asSetlDt);
    $("#ddlFailReason").val(result[0].c2);
    $("#tpSettleTime").val(result[0].asSetlTm);
    $("#ddlDSCCode").val(result[0].asBrnchId);

    $("#ddlErrorCode").val(result[0].asMalfuncId);
    $("#ddlErrorDesc").val(result[0].asMalfuncResnId);

    asMalfuncResnId = result[0].asMalfuncResnId;

    if (result[0].asMalfuncId != "") {
      $("#ddlErrorDesc option").remove();
      doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE=' + result[0].asMalfuncId, '', '', 'ddlErrorDesc', 'S', 'fn_callback_ddlErrorDesc');
    }

    //$("#ddlCTCodeText").val( result[0].c12);
    //$("#ddlCTCode").val( result[0].c11);

    /*
    c11: 35530
    c12: "CT100528"
    asBrnchId: 77
    c5: "DSC-16"
     */

    /*
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    $("#ddlCTCode").val(selectedItems[0].item.asMemId);
    $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
    $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
    $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);
     */

    $("#ddlCTCode").val(result[0].c11);
    $("#ddlDSCCode").val(result[0].asBrnchId);
    $("#ddlCTCodeText").val(result[0].c12);
    $("#ddlDSCCodeText").val(result[0].c5);

    $("#ddlWarehouse").val(result[0].asWhId);
    $("#txtRemark").val(result[0].asResultRem);

    if (result[0].c27 == "1") {
      $("#iscommission").attr("checked", true);
    }

    $('#def_type').val(result[0].c16);
    $('#def_type_text').val(result[0].c17);
    $('#def_type_id').val(result[0].asDefectTypeId);

    $('#def_code').val(result[0].c18);
    $('#def_code_text').val(result[0].c19);
    $('#def_code_id').val(result[0].asDefectId);

    $('#def_def').val(result[0].c22);
    $('#def_def_text').val(result[0].c23);
    $('#def_def_id').val(result[0].asDefectDtlResnId);

    $('#def_part').val(result[0].c20);
    $('#def_part_text').val(result[0].c21);
    $('#def_part_id').val(result[0].asDefectPartId);

    $('#solut_code').val(result[0].c25);
    $('#solut_code_text').val(result[0].c26);
    $('#solut_code_id').val(result[0].c24);

    var v = /^(\d+)([.]\d{0,2})$/;
    var regexp = new RegExp(v);

    var toamt = "" + result[0].asTotAmt;
    var tWork = "" + result[0].asWorkmnsh;
    var tFilterAmt = "" + result[0].asFilterAmt;

    if (regexp.test(toamt)) {
      $('#txtTotalCharge').val(toamt);
    } else {
      $('#txtTotalCharge').val(toamt + ".00");
    }

    if (regexp.test(tWork)) {
      $('#txtLabourCharge').val(tWork);
    } else {
      $('#txtLabourCharge').val(tWork + ".00");
    }

    if (regexp.test(tFilterAmt)) {
      $('#txtFilterCharge').val(tFilterAmt);
    } else {
      $('#txtFilterCharge').val(tFilterAmt + ".00");
    }

    if (result[0].inHuseRepairReplaceYn == "1") {
      $("input:radio[name='replacement']:radio[value='1']").attr('checked', true); // 원하는 값(Y)을 체크
      fn_replacement('1');
    } else if (result[0].inHuseRepairReplaceYn == "0") {
      $("input:radio[name='replacement']:radio[value='0']").attr('checked', true); // 원하는 값(Y)을 체크
      fn_replacement('0');
    }

    $('#productGroup').val(result[0].inHuseRepairGrpCode);
    fn_productGroup_SelectedIndexChanged_2(result[0].inHuseRepairProductCode);
    $('#productCode').val(result[0].inHuseRepairProductCode);
    $('#serialNo').val(result[0].inHuseRepairSerialNo);
    $('#inHouseRemark').val(result[0].inHuseRepairRem);
    $('#promisedDate').val(result[0].inHuseRepairPromisDt);

    if (result[0].c25 == "B8" || result[0].c25 == "B6") {
      $("input:radio[name='replacement']:radio[value='0']").attr("disabled", "disabled");
      $("input:radio[name='replacement']:radio[value='1']").attr("disabled", "disabled");
      $("#promisedDate").attr("disabled", "disabled");
      $("#productGroup").attr("disabled", "disabled");
      $("#productCode").attr("disabled", "disabled");
      if ($("#requestMod").val() == "RESULTVIEW") {
        $("#serialNo").attr("disabled", "disabled");
        $("#inHouseRemark").attr("disabled", "disabled");
      } else {
        $("#serialNo").attr("disabled", false);
        $("#inHouseRemark").attr("disabled", false);
      }
      $("#inHouseRepair_div").attr("style", "display:inline");
    }
  }

  function fn_setCTcodeValue() {
    $("#ddlCTCode").val($("#CTID").val());
  }

  function fn_getASReasonCode2(_obj, _tobj, _v) {
    var reasonCode = $(_obj).val();
    var reasonTypeId = _v;

    Common.ajax("GET", "/services/as/getASReasonCode2.do", {
      RESN_TYPE_ID : reasonTypeId,
      CODE : reasonCode
    }, function(result) {
      if (result.length > 0) {
        $("#" + _tobj + "_text").val((result[0].resnDesc.trim()).trim());
        $("#" + _tobj + "_id").val(result[0].resnId);

        if ('337' == _v) {
          if (result[0].codeId.trim() == 'B8' || result[0].codeId.trim() == 'B6') {
            $("#replacement").attr("disabled", "disabled");
            $("#promisedDate").attr("disabled", "disabled");
            $("#productGroup").attr("disabled", "disabled");
            $("#productCode").attr("disabled", "disabled");
            $("#serialNo").attr("disabled", false);
            $("#inHouseRemark").attr("disabled", false);
            $("#inHouseRepair_div").attr("style", "display:inline");
          } else {
            $("input:radio[name='replacement']").removeAttr('checked');
            $("#promisedDate").val("").attr("disabled", "disabled");
            $("#productGroup").val("").attr("disabled", "disabled");
            $("#productCode").val("").attr("disabled", "disabled");
            $("#serialNo").val("").attr("disabled", "disabled");
            $("#inHouseRemark").val("").attr("disabled", "disabled");
            $("#inHouseRepair_div").attr("style", "display:none");
            fn_replacement(0);
          }
        }
      } else {
        $("#" + _tobj + "_text").val( "* No such detail of defect found.");
        $("#promisedDate").val("").attr("disabled", "disabled");
        $("#productGroup").val("").attr("disabled", "disabled");
        $("#productCode").val("").attr("disabled", "disabled");
        $("#serialNo").val("").attr("disabled", "disabled");
        $("#inHouseRemark").val("").attr("disabled", "disabled");
        $("#inHouseRepair_div").attr("style", "display:none");
        $("input:radio[name='replacement']").removeAttr('checked');
        fn_replacement(0);
      }
    });
  }

  function fn_HasFilterUnclaim() {
    Common.ajax("GET", "/services/as/getTotalUnclaimItem", { asResultId : $('#asData_AS_RESULT_ID').val(), type : "AS" },
            function(result) {
              if (result.filter != null) {
                var isSomeFileter = true;
                if (Number(result.filter.qtyUse) > Number(result.filter.qtyClm))
                  isSomeFileter = true;

                if (isSomeFileter) {
                  Common.alert("Filter Unclaim" + DEFAULT_DELIMITER + "<b>Some filter(s) are unclaim.<br />Please claim all the filter before you edit this result.</b>");
                  $("#btnSaveDiv").attr("style", "display:none");
                }
              }
            });
  }

  function fn_ddlStatus_SelectedIndexChanged() {
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    $("#ddlCTCode").val(selectedItems[0].item.asMemId);
    $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
    $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
    $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);

    switch ($("#ddlStatus").val()) {
    case "4":
      //COMPLETE
      fn_openField_Complete();
      break;
    case "10":
      //CANCEL
      fn_openField_Cancel();
      break;
    case "21":
      //FAILED
      fn_openField_Fail();
      break;
    default:
      $("#m2").hide();
      $("#m3").hide();
      $("#m4").hide();
      $("#m5").hide();
      $("#m6").hide();
      $("#m7").hide();
      $("#m8").hide();
      $("#m9").hide();
      $("#m10").hide();
      $("#m11").hide();
      $("#m12").hide();
      $("#m13").hide();
      $("#mInH3").hide();
      break;
    }
  }

  function fn_openField_Complete() {
    // OPEN MANDATORY
    $("#m2").show();
    $("#m3").hide();
    $("#m4").show();
    $("#m5").show();
    $("#m6").show();
    $("#m7").show();
    $("#m8").show();
    $("#m9").show();
    $("#m10").show();
    $("#m11").show();
    $("#m12").show();
    $("#m13").show();

    $("#btnSaveDiv").attr("style", "display:inline");
    $("#addDiv").attr("style", "display:inline");

    $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
    $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");
    $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlErrorCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlErrorDesc').removeAttr("disabled").removeClass("readonly");
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");
    $('#iscommission').removeAttr("disabled").removeClass("readonly");

    $('#def_type').removeAttr("disabled").removeClass("readonly");
    $('#def_code').removeAttr("disabled").removeClass("readonly");
    $('#def_part').removeAttr("disabled").removeClass("readonly");
    $('#def_def').removeAttr("disabled").removeClass("readonly");
    //$('#def_type_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_code_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_part_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_def_text').removeAttr("disabled").removeClass("readonly");

    $("#txtFilterCharge").attr("disabled", false);
    $("#txtLabourCharge").attr("disabled", false);
    $("#cmbLabourChargeAmt").attr("disabled", false);
    $("#ddlFilterCode").attr("disabled", false);
    $("#ddlFilterQty").attr("disabled", false);
    $("#ddlFilterPayType").attr("disabled", false);
    $("#ddlFilterExchangeCode").attr("disabled", false);
    $("#txtFilterRemark").attr("disabled", false);
    fn_clearPanelField_ASChargesFees();

    //$("#txtRemark").val(asDataInfo[0].callRem);
    //$("#ddlErrorCode").val(asDataInfo[0].c12);
    //$("#ddlErrorDesc").val(asDataInfo[0].c15);
    //$("#ddlCTCode").val(asDataInfo[0].c9);
    //$("#ddlDSCCode").val(asDataInfo[0].c6);

    $("#serialNo").attr("disabled", false);

    if (asDataInfo[0].asAllowComm == "1") {
      $("#iscommission").attr("checked", true);
    }

    if (asDataInfo[0].asStusId != 1) {
      Common.alert("AS Not Active" + DEFAULT_DELIMITER + "<b>AS is no longer active. Result key-in is disallowed.</b>");
      $("#btnSaveDiv").attr("style", "display:none");
    }

    $("#mInH3").show();
  }

  function fn_openField_Cancel() {
    fn_clearPageField();

    // OPEN MANDATORY
    $("#m2").hide();
    $("#m3").show();
    $("#m4").hide();
    $("#m5").show();
    $("#m6").hide();
    $("#m7").show();
    $("#m8").hide();
    $("#m9").hide();
    $("#m10").hide();
    $("#m11").hide();
    $("#m12").hide();
    $("#m13").hide();

    $("#btnSaveDiv").attr("style", "display:inline");
    $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");
  }

  function fn_openField_Fail() {
    // OPEN MANDATORY
    $("#m2").hide();
    $("#m3").show();
    $("#m4").hide();
    $("#m5").show();
    $("#m6").hide();
    $("#m7").show();
    $("#m8").hide();
    $("#m9").hide();
    $("#m10").hide();
    $("#m11").hide();
    $("#m12").hide();
    $("#m13").hide();

    $("#btnSaveDiv").attr("style", "display:inline");
    $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");
  }

  function fn_clearPageField() {
    $("#btnSaveDiv").attr("style", "display:none");
    $("#addDiv").attr("style", "display:none");

    $('#dpSettleDate').val("").attr("disabled", true);
    $('#ddlFailReason').val("").attr("disabled", true);
    $('#tpSettleTime').val("").attr("disabled", true);
    $('#ddlDSCCode').val("").attr("disabled", true);
    $('#ddlErrorCode').val("").attr("disabled", true);
    $('#ddlCTCode').val("").attr("disabled", true);
    $('#ddlErrorDesc').val("").attr("disabled", true);
    $('#ddlWarehouse').val("").attr("disabled", true);
    $('#txtRemark').val("").attr("disabled", true);
    $("#iscommission").attr("disabled", true);

    fn_clearPanelField_ASChargesFees();

    $("#ddlFilterCode").val("").attr("disabled", true);
    $("#ddlFilterQty").val("").attr("disabled", true);
    $("#ddlFilterPayType").val("").attr("disabled", true);
    $("#ddlFilterExchangeCode").val("").attr("disabled", true);
    $("#txtFilterRemark").val("").attr("disabled", true);
    $("#txtLabourCharge").val("0.00").attr("disabled", true);
    $("#txtFilterCharge").val("0.00").attr("disabled", true);

    if ($("#ddlStatus").val() == '10') { // CANCEL
      $("#def_type").val("").attr("disabled", true);
      $("#def_type_id").val("");
      $("#def_type_text").val("").attr("disabled", true);

      $("#def_code").val("").attr("disabled", true);
      $("#def_code_id").val("");
      $("#def_code_text").val("").attr("disabled", true);

      $("#def_part").val("").attr("disabled", true);
      $("#def_part_id").val("");
      $("#def_part_text").val("").attr("disabled", true);

      $("#def_def").val("").attr("disabled", true);
      $("#def_def_text").val("");
      $("#def_def_text").val("").attr("disabled", true);

      $("#solut_code").val("").attr("disabled", true);
      $("#solut_code_id").val("");
      $("#solut_code_text").val("").attr("disabled", true);

      $("input:radio[name='replacement']").removeAttr('checked');
      $("#promisedDate").val("").attr("disabled", "disabled");
      $("#productGroup").val("").attr("disabled", "disabled");
      $("#productCode").val("").attr("disabled", "disabled");
      $("#serialNo").val("").attr("disabled", "disabled");
      $("#inHouseRemark").val("").attr("disabled", "disabled");
      $("#inHouseRepair_div").attr("style", "display:none");
      fn_replacement(0);
    }
  }

  function fn_LabourCharge_CheckedChanged(_obj) {
    if (_obj.checked) {
      $('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");
      $("#cmbLabourChargeAmt").val("60");
      $("#txtLabourCharge").val("60.00");
    } else {
      $("#txtLabourCharge").val("0.00");
      $("#cmbLabourChargeAmt").val("");
      $("#cmbLabourChargeAmt").attr("disabled", true);
    }

    fn_calculateTotalCharges();
  }

  function fn_calculateTotalCharges() {
    var labourCharges = 0;
    var filterCharges = 0;
    var totalCharges = 0;

    labourCharges = $("#txtLabourCharge").val();
    filterCharges = $("#txtFilterCharge").val();

    filterCharges = Number(filterCharges.replace(/,/gi, ""));
    labourCharges = Number(labourCharges.replace(/,/gi, ""));
    totalCharges = labourCharges + filterCharges;

    $("#txtTotalCharge").val(totalCharges);
  }

  function fn_cmbLabourChargeAmt_SelectedIndexChanged() {
    var v = $("#cmbLabourChargeAmt").val();
    $("#txtLabourCharge").val(v);
    fn_calculateTotalCharges();
  }

  function fn_cmbPaymentType() {
    if ($('#ddlFilterCode').val() != "") {
      if ($("#ddlFilterPayType").val() == "CHG") {
        var pCode = $("#ddlFilterCode").val();

        Common.ajaxSync("GET", "/services/as/getStockPrice.do", {
          stkID : pCode
        }, function(result) {
          var pPrice = result.FilPrice.filterprice;
          //Common.alert("aa "+pPrice + pPrice);
          $("#txtFilterCharge").val(pPrice + ".00");
        });
      } else {
        $("#txtFilterCharge").val("0.00");
      }
    }
    fn_calculateTotalCharges();
  }

  function fn_onChangeddlFilterCode() {
    $("#ddlFilterPayType").val("");
    $("#txtFilterCharge").val("0.00");
    fn_calculateTotalCharges();
  }

  function fn_filterAddVaild() {
    if (FormUtil.checkReqValue($("#ddlFilterCode option:selected"))) {
      return false;
    }

    if (FormUtil.checkReqValue($("#ddlFilterQty option:selected"))) {
      return false;
    }

    if (FormUtil.checkReqValue($("#ddlFilterPayType option:selected"))) {
      return false;
    }

    if (FormUtil.checkReqValue($("#ddlFilterExchangeCode option:selected"))) {
      return false;
    }
  }

  function fn_chStock() {
    var ct = $("#ddlCTCodeText").val();
    var sk = $("#ddlFilterCode").val();

    var availQty = isstckOk(ct, sk);

    if (availQty == 0) {
      Common.alert('*<b> There are no available stocks.</b>');
      fn_filterClear();
      return false;
    } else {
      if (availQty < Number($("#ddlFilterQty").val())) {
        Common.alert('*<b> Not enough available stock to the member.  <br> availQty[' + availQty + '] </b>');
        fn_filterClear();
        return false;
      }
      return true;
    }
  }

  function isstckOk(ct, sk) {
    var availQty = 0;

    Common.ajaxSync("GET", "/services/as/getSVC_AVAILABLE_INVENTORY.do", {
      CT_CODE : ct,
      STK_CODE : sk
    }, function(result) {
      availQty = result.availQty;
    });

    return availQty;
  }

  function fn_filterAdd() {
    if (fn_chStock() == false) {
      return;
    }

    if (fn_filterAddVaild() == false) {
      Common.alert('*<b>Please fill up the compulsory fields to add the filter.</b>');
      return false;
    }

    var fitem = new Object();

    fitem.filterType = $("#ddlFilterPayType").val();
    fitem.filterDesc = $("#ddlFilterCode option:selected").text();
    fitem.filterExCode = $("#ddlFilterExchangeCode").val();
    fitem.filterQty = $("#ddlFilterQty").val();
    fitem.filterRemark = $("#txtFilterRemark").val();
    fitem.filterID = $("#ddlFilterCode").val();
    //fitem.filterCODE =$("#ddlFilterCode").va();

    var chargePrice = 0;
    if (fitem.filterType == "CHG") {
      chargePrice = getASStockPrice(fitem.filterID);
    }

    if (chargePrice == 0) {
      //Common.alert("<b>SAL0016M(StockPrice) no data  </br>");
      // return ;
    }

    fitem.filterPrice = Number(chargePrice);

    var chargeTotalPrice = 0;

    chargeTotalPrice = Number($("#ddlFilterQty").val()) * chargePrice;
    fitem.filterTotal = Number(chargeTotalPrice);

    var v = Number($("#txtFilterCharge").val()) + chargeTotalPrice;
    //$("#txtFilterCharge").val( v);

    if (AUIGrid.isUniqueValue(myFltGrd10, "filterID", fitem.filterID)) {
      fn_addRow(fitem);
    } else {
      Common.alert("<b>This filter/spart part is existing. </br>");
      return;
    }

    fn_calculateTotalCharges();
  }

  function fn_addRow(gItem) {
    AUIGrid.addRow(myFltGrd10, gItem, "first");
  }

  function getASStockPrice(_PRC_ID) {
    var ret = 0;
    Common.ajaxSync("GET", "/services/as/getASStockPrice.do", {
      PRC_ID : _PRC_ID
    }, function(result) {
      try {
        ret = Number(result[0].amt);
      } catch (e) {
        // alert('SAL0016M no data ');
        ret = 0;
      }
    });
    return ret;
  }

  function fn_doSave() {
    if (!fn_validRequiredField_Save_ResultInfo()) {
      return;
    }

    if ($("#ddlStatus").val() == 4) {
      //COMPLETE STATUS
      if (!fn_validRequiredField_Save_DefectiveInfo()) {
        return;
      }
    }

    var fmt = fn_valDtFmt();
    if (!fmt) {
      Common.alert("Sattle Date invalid date format.");
      $("#dpSettleDate").val("");
      return;
    }

    var sDate = ($("#dpSettleDate").val()).split("/");
    var tDate = new Date();
    var tMth = tDate.getMonth();
    var tYear = tDate.getFullYear();
    var sMth = parseInt(sDate[1]);
    var sYear = parseInt(sDate[2]);

    if (tYear > sYear) {
      Common.alert("* Sattle Date must be in current month and year");
      $("#dpSettleDate").val("");
      return;
    } else {
      if (tMth > sMth) {
        Common.alert("* Sattle Date must be in current month and year");
        $("#dpSettleDate").val("");
        return;
      }
    }

    fn_setSaveFormData();
  }

  function fn_valDtFmt() {
    var dateRegex = /^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-.\/])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
    return dateRegex.test($("#dpSettleDate").val());
  }

  function fn_validRequiredField_Save_DefectiveInfo() {
    var rtnMsg = "";
    var rtnValue = true;

    if (FormUtil.checkReqValue($("#def_type_id"))) {
      rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Defect Type' htmlEscape='false'/> </br>";
      rtnValue = false;
    }

    if (FormUtil.checkReqValue($("#def_code_id"))) {
      rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Defect Code' htmlEscape='false'/> </br>";
      rtnValue = false;
    }

    if (FormUtil.checkReqValue($("#def_part_id"))) {
        rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Defect Part' htmlEscape='false'/> </br>";
        rtnValue = false;
    }

    if (FormUtil.checkReqValue($("#def_def"))) {
        rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Detail of Defect' htmlEscape='false'/> </br>";
        rtnValue = false;
    }

    if (FormUtil.checkReqValue($("#solut_code_id"))) {
        rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Solution Code' htmlEscape='false'/> </br>";
        rtnValue = false;
    }

    if ($("#solut_code_id").val() == "454") { // RETURN PRODUCT BACK TO FACTORY
      if ($("input:radio[name='replacement']:checked").val() == "1") {
        if (FormUtil.checkReqValue($("#productGroup"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Loan Product Category' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#productCode"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Loan Product' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#serialNo"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Loan Product Serial Number' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
      }
    }

    if (rtnValue == false) {
      Common.alert(rtnMsg);
    }
    return rtnValue;
  }

  function fn_validRequiredField_Save_ResultInfo() {
    var rtnMsg = "";
    var rtnValue = true;

    if (FormUtil.checkReqValue($("#ddlStatus"))) {
      rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='AS Status' htmlEscape='false'/> </br>";
      rtnValue = false;
    } else {
      if ($("#ddlStatus").val() == 4) {
        if (FormUtil.checkReqValue($("#dpSettleDate"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Settle Date' htmlEscape='false'/> </br>";
          rtnValue = false;
        } else {
          var asno = $("#txtASNo").val();

          if (asno.match(/AS/g)) {
            var nowdate = $.datepicker.formatDate($.datepicker.ATOM, new Date());
            var nowdateArry = nowdate.split("-");
            nowdateArry = nowdateArry[0] + "" + nowdateArry[1] + "" + nowdateArry[2];
            var rdateArray = $("#dpSettleDate").val().split("/");
            var requestDate = rdateArray[2] + "" + rdateArray[1] + "" + rdateArray[0];

            if ((parseInt(requestDate, 10) - parseInt(nowdateArry, 10)) > 14 || (parseInt(nowdateArry, 10) - parseInt(requestDate, 10)) > 14) {
              rtnMsg += "* Request date should not be longer than 14 days from current date.<br />";
              rtnValue = false;
            }
          }
        }

        if (FormUtil.checkReqValue($("#tpSettleTime"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Settle Time' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlDSCCode"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='DSC Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlErrorCode"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Error Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlErrorDesc"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Error Description' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlCTCode"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='CT Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
      } else {
        if (FormUtil.checkReqValue($("#ddlFailReason"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Fail Reason' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
      }
    }

    if (rtnValue == false) {
      Common.alert(rtnMsg);
    }

    return rtnValue;
  }

  function fn_productGroup_SelectedIndexChanged() {
    var STK_CTGRY_ID = $("#productGroup").val();
    $("#serialNo").val("");
    $("#productCode option").remove();

    doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + STK_CTGRY_ID, '', '', 'productCode', 'S', '');
  }

  function fn_productGroup_SelectedIndexChanged_2(val) {
    var STK_CTGRY_ID = $("#productGroup").val();
    $("#serialNo").val("");
    $("#productCode option").remove();

    doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + STK_CTGRY_ID, '', val, 'productCode', 'S', '');
  }

  function fn_setSaveFormData() {
    var allRowItems = AUIGrid.getGridData(myFltGrd10);
    var addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10);
    var editedRowItems = AUIGrid.getEditedRowColumnItems(myFltGrd10);
    var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10);

    var inHseRprInd = "";
    if ($("input[name='replacement'][value='1']").prop("checked")) {
      inHseRprInd = 1;
    } else {
      inHseRprInd = 0;
    }

    var asResultM = {
      AS_ENTRY_ID : $("#asData_AS_ID").val(),
      AS_SO_ID : $("#asData_AS_SO_ID").val(),
      AS_ORD_NO : $("#asData_AS_ORD_NO").val(),
      AS_CT_ID : $('#ddlCTCode').val(),
      AS_SETL_DT : $('#dpSettleDate').val(),
      AS_SETL_TM : $('#tpSettleTime').val(),
      AS_RESULT_STUS_ID : $('#ddlStatus').val(),
      AS_FAIL_RESN_ID : $('#ddlFailReason').val(),
      AS_REN_COLCT_ID : 0,
      AS_CMMS : $("#iscommission").prop("checked") ? '1' : '0',
      AS_BRNCH_ID : $('#ddlDSCCode').val(),
      AS_WH_ID : $('#ddlWarehouse').val(),
      AS_RESULT_REM : $('#txtRemark').val(),
      AS_MALFUNC_ID : $('#ddlErrorCode').val(),
      AS_MALFUNC_RESN_ID : $('#ddlErrorDesc').val(),
      AS_DEFECT_TYPE_ID : $('#ddlStatus').val() == 4 ? $('#def_type_id').val() : '0',
      AS_DEFECT_GRP_ID : 0,
      AS_DEFECT_ID : $('#ddlStatus').val() == 4 ? $('#def_code_id').val() : '0',
      AS_DEFECT_PART_GRP_ID : 0,
      AS_DEFECT_PART_ID : $('#ddlStatus').val() == 4 ? $('#def_part_id').val() : '0',
      AS_DEFECT_DTL_RESN_ID : $('#ddlStatus').val() == 4 ? $('#def_def_id').val() : '0',
      AS_SLUTN_RESN_ID : $('#ddlStatus').val() == 4 ? $('#solut_code_id').val() : '0',
      AS_WORKMNSH : $('#txtLabourCharge').val(),
      AS_FILTER_AMT : $('#txtFilterCharge').val(),
      AS_ACSRS_AMT : 0,
      AS_TOT_AMT : $('#txtTotalCharge').val(),
      AS_RESULT_IS_SYNCH : 0,
      AS_RCALL : 0,
      AS_RESULT_STOCK_USE : addedRowItems.length > 0 ? 1 : 0,//detail 리스트 카운트
      AS_RESULT_TYPE_ID : 457,
      AS_RESULT_IS_CURR : 1,
      AS_RESULT_MTCH_ID : 0,
      AS_RESULT_NO_ERR : '',
      AS_ENTRY_POINT : 0,
      AS_WORKMNSH_TAX_CODE_ID : 0,
      AS_WORKMNSH_TXS : 0,
      AS_RESULT_MOBILE_ID : 0,
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val(),
      AS_RESULT_ID : $('#asData_AS_RESULT_ID').val(),
      AS_NO : asDataInfo[0].asNo,
      AS_ID : asDataInfo[0].asId,
      ACC_BILL_ID : asDataInfo[0].c19,
      ACC_INVOICE_NO : asDataInfo[0].c20,
      TAX_INVOICE_CUST_NAME : $("#txtCustName").text(),
      TAX_INVOICE_CONT_PERS : $("#txtContactPerson").text(),
      productCode : aSOrderInfo.stockCode,
      productName : aSOrderInfo.stockDesc,
      serialNo : aSOrderInfo.lastInstallSerialNo,
      IN_HUSE_REPAIR_REM : $("#inHouseRemark").val(),
      IN_HUSE_REPAIR_REPLACE_YN : inHseRprInd,
      IN_HUSE_REPAIR_PROMIS_DT : $("#promisedDate").val(),
      IN_HUSE_REPAIR_GRP_CODE : $("#productGroup").val(),
      IN_HUSE_REPAIR_PRODUCT_CODE : $("#productCode").val(),
      IN_HUSE_REPAIR_SERIAL_NO : $("#serialNo").val()
    }

    var saveForm;
    alert($("#requestMod").val());

    if ($("#requestMod").val() == "INHOUSE") {
      saveForm = {
        "asResultM" : asResultM,
        "add" : addedRowItems,
        "update" : editedRowItems,
        "remove" : removedRowItems
      }

      Common
          .ajax(
              "POST",
              "/services/inhouse/save.do",
              saveForm,
              function(result) {
                if (result.asNo != "") {
                  Common
                      .alert("<b>AS result successfully saved.</b>");
                  fn_DisablePageControl();
                }
              });
    } else {
      if ($("#requestMod").val() == "NEW") {
        saveForm = {
          "asResultM" : asResultM,
          "add" : addedRowItems,
          "update" : editedRowItems,
          "remove" : removedRowItems
        }

        Common
            .ajax(
                "POST",
                "/services/as/newResultAdd.do",
                saveForm,
                function(result) {
                  if (result.asNo != "") {
                    Common.alert("<b>AS result successfully saved.</b>");
                    fn_DisablePageControl();
                  }
                });

      } else if ($("#requestMod").val() == "RESULTEDIT") {
        if (addedRowItems != "" || removedRowItems != "") {
          saveForm = {
            "asResultM" : asResultM,
            "add" : allRowItems,
            "update" : editedRowItems,
            "remove" : editedRowItems
          // "all" : allRowItems
          }
        } else {
          saveForm = {
            "asResultM" : asResultM,
            "add" : addedRowItems,
            "update" : editedRowItems,
            "remove" : removedRowItems
          }
        }

        /* if ($("#solut_code").val() == "B8" || $("#solut_code").val() == "B6") { // INHOUSE
        Common.ajax("POST", "/services/as/newASInHouseAdd.do", saveForm,
          function(result) {
            if (result.data != "") {
              $("#newResultNo").html("<B>" + result.data + "</B>");
              Common.alert("<b>AS result successfully saved.</b>");
              //fn_DisablePageControl();
              fn_asResult_viewPageContral();
              $("#btnSaveDiv").attr("style", "display:none");
            }

            try {
              fn_searchASManagement();
              $("#_newASResultDiv1").remove();
            } catch (e) {
            }
          });
        } else { */
          //Common.ajax("POST", "/services/as/newResultUpdate.do", saveForm, function(result)
          Common.ajax("POST", "/services/as/newResultUpdate_1.do", saveForm,
            function(result) {
              if (result.data != "") {
                $("#newResultNo").html("<B>" + result.data + "</B>");
                  Common.alert("<b>AS result successfully saved.</b>");
                  //fn_DisablePageControl();
                  fn_asResult_viewPageContral();
                   $("#btnSaveDiv").attr("style", "display:none");
                  }

                  try {
                    fn_searchASManagement();
                    $("#_newASResultDiv1").remove();
                  } catch (e) {
                  }
                });
        }
      }
    //}
  }

  function fn_asResult_editPageContral(_type) {
    if ("INHOUSE" == _type) {
      $("#solut_code_text").attr("disabled", true);
    } else {
      $("#newRno").attr("style", "display:inline");
      $('#solut_code').removeAttr("disabled").removeClass("readonly");
      //$('#solut_code_text').removeAttr("disabled").removeClass("readonly");
    }

    //$("#resultEditCreator").attr("style","display:inline");

    $("#btnSaveDiv").attr("style", "display:inline");
    $("#addDiv").attr("style", "display:inline");

    $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
    $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");
    $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlErrorCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlErrorDesc').removeAttr("disabled").removeClass("readonly");
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");
    $('#iscommission').removeAttr("disabled").removeClass("readonly");

    $('#def_type').removeAttr("disabled").removeClass("readonly");
    $('#def_code').removeAttr("disabled").removeClass("readonly");
    $('#def_part').removeAttr("disabled").removeClass("readonly");
    $('#def_def').removeAttr("disabled").removeClass("readonly");

    //$('#def_type_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_code_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_part_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_def_text').removeAttr("disabled").removeClass("readonly");

    $('#txtLabourch').removeAttr("disabled").removeClass("readonly");
    $('#txtTotalCharge').removeAttr("disabled").removeClass("readonly");
    $('#txtFilterCharge').removeAttr("disabled").removeClass("readonly");
    $('#txtLabourCharge').removeAttr("disabled").removeClass("readonly");
    $('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterQty').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterPayType').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterExchangeCode').removeAttr("disabled").removeClass(
        "readonly");
    $('#txtFilterRemark').removeAttr("disabled").removeClass("readonly");

    fn_clearPanelField_ASChargesFees();

  }

  function fn_clearPanelField_ASChargesFees() {
    $('#ddlFilterCode').val("");
    $('#ddlFilterQty').val("");
    $('#ddlFilterPayType').val("");
    $('#ddlFilterExchangeCode').val("");
    $('#txtFilterRemark').val("");
  }

  function fn_asResult_viewPageContral() {
    $("#asResultForm").find("input, textarea, button, select").attr(
        "disabled", true);
  }

  function fn_setASDataInit(ops) {
    $("#asData_AS_ID").val(ops.AS_ID);
    $("#asData_AS_SO_ID").val(ops.AS_SO_ID);
    $("#asData_AS_ORD_NO").val(ops.ORD_NO);
    $("#asData_AS_RESULT_ID").val(ops.AS_RESULT_ID);
    $("#asData_AS_RESULT_NO").val(ops.AS_RESULT_NO);
    $("#requestMod").val(ops.MOD);

    fn_getASRulstEditFilterInfo(); //AS_RESULT_NO
    fn_getASRulstSVC0004DInfo(); //AS_RESULT_NO
    // fn_setCTcodeValue();

    //as result edit
    if (ops.MOD == "RESULTEDIT") {
      fn_getErrMstList('${ORD_NO}', 'fn_errCallbackFun');
      fn_HasFilterUnclaim();

    } else if (ops.MOD == "RESULTVIEW") {
      fn_getErrMstList('${ORD_NO}', 'fn_errCallbackFun');

      $("#asResultForm").find("input, textarea, button, select").attr(
          "disabled", true);
      $("#btnSaveDiv").attr("style", "display:none");

      // fn_HasFilterUnclaim();
      //  fn_asResult_viewPageContral();

      $("#btnSaveDiv").attr("style", "display:none");
      $("#addDiv").attr("style", "display:none");

      $('#dpSettleDate').attr("disabled", true);
      $('#ddlFailReason').attr("disabled", true);
      $('#tpSettleTime').attr("disabled", true);
      $('#ddlDSCCode').attr("disabled", true);

      $('#ddlErrorCode').attr("disabled", true);
      $('#ddlCTCode').attr("disabled", true);
      $('#ddlErrorDesc').attr("disabled", true);
      $('#ddlWarehouse').attr("disabled", true);
      $('#txtRemark').attr("disabled", true);
      $("#iscommission").attr("disabled", true);
      $("#ddlFilterCode").attr("disabled", true);
      $("#ddlFilterQty").attr("disabled", true);
      $("#ddlFilterPayType").attr("disabled", true);
      $("#ddlFilterExchangeCode").attr("disabled", true);
      $("#txtFilterRemark").attr("disabled", true);
      $("#txtLabourCharge").attr("disabled", true);
      $("#txtFilterCharge").attr("disabled", true);

      $('#def_type').attr("disabled", true);
      $('#def_code').attr("disabled", true);
      $('#def_part').attr("disabled", true);
      $('#def_def').attr("disabled", true);

      $('#def_type_text').attr("disabled", true);
      $('#def_code_text').attr("disabled", true);
      $('#def_part_text').attr("disabled", true);
      $('#def_def_text').attr("disabled", true);
    }
  }

  function fn_errCallbackFun() {
    fn_getASRulstSVC0004DInfo();
  }

  function fn_replacement(val) {
    if (val == "0") {
      $("#mInH1").hide();
      $("#mInH2").hide();
      $("#mInH3").hide();
      $("#productGroup").attr('disabled','disabled');
      $("#productCode").attr('disabled','disabled');
      $("#serialNo").attr('disabled','disabled');

      $("#productGroup").val("");
      $("#productCode").val("");
      $("#serialNo").val("");

    } else {
      $("#mInH1").show();
      $("#mInH2").show();
      $("#productGroup").attr("disabled", false);
      $("#productCode").attr("disabled", false);
      if ($("#ddlStatus").val() == '4') {
        $("#mInH3").show();
        $("#serialNo").attr("disabled", false);
      } else {
        $("#mInH3").hide();
        $("#serialNo").attr("disabled", 'disabled');
      }
      $("#productGroup").val("");
      $("#productCode").val("");
      $("#serialNo").val("");
    }
  }

  setPopData();
</script>
<form id="asDataForm" method="post">
 <div style='display: none'>
  <input type="text" id='asData_AS_ID' name='asData_AS_ID' /> <input
   type="text" id='asData_AS_SO_ID' name='asData_AS_SO_ID' /> <input
   type="text" id='asData_AS_ORD_NO' name='asData_AS_ORD_NO' /> <input
   type="text" id='asData_AS_RESULT_ID' name='asData_AS_RESULT_ID' /> <input
   type="text" id='asData_AS_RESULT_NO' name='asData_AS_RESULT_NO' /> <input
   type="text" id='requestMod' name='requestMod' />
 </div>
</form>
<form id="asResultForm" method="post">
 <article class="acodi_wrap">
  <!-- acodi_wrap start -->
  <dl>
   <dt class="click_add_on on">
    <a href="#">AS Result Information</a>
   </dt>
   <dd>
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 110px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">New Result No</th>
       <td colspan="3">
        <div id='newRno' style='display: none'>
         <span id='newResultNo'> </span>
        </div>
       </td>
      </tr>
      <tr>
       <th scope="row">Result No</th>
       <td><input type="text" title="" placeholder="" class=""
        id='txtResultNo' name='txtResultNo' disabled /></td>
       <th scope="row">Status <span id='m1' name='m1' class="must">*</span>
       </th>
       <td><select class="w100p" id="ddlStatus" name="ddlStatus"
        onChange="fn_ddlStatus_SelectedIndexChanged()">
         <option value="" selected>Choose One</option>
         <option value="4">Complete</option>
         <option value="10">Cancel</option>
         <option value="21">Failure</option>
       </select></td>
      </tr>
      <tr>
       <th scope="row">Settle Date <span id='m2' name='m2' class="must" style="display:none">*</span>
       </th>
       <td><input type="text" title="Create start Date"
        id='dpSettleDate' name='dpSettleDate' placeholder="DD/MM/YYYY"
        class="readonly j_date" disabled="disabled" /></td>
       <th scope="row">Fail Reason <span id='m3' name='m3' class="must" style="display:none">*</span></th>
       <td><select id='ddlFailReason' name='ddlFailReason'
        disabled="disabled"></select></td>
      </tr>
      <tr>
       <th scope="row">Settle Time <span id='m4' name='m4' class="must" style="display:none">*</span>
       </th>
       <td>
        <div class="time_picker">
         <!-- time_picker start -->
         <input type="text" title="" placeholder="" id='tpSettleTime'
          name='tpSettleTime' class="readonly time_date"
          disabled="disabled" />
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
       <th scope="row">DSC Code <span id='m5' name='m5' class="must" style="display:none">*</span>
       </th>
       <td><input type="hidden" title="" placeholder="" class=""
        id='ddlDSCCode' name='ddlDSCCode' value='${BRANCH_ID}' /> <input
        type="text" title="" placeholder="" class="readonly"
        id='ddlDSCCodeText' name='ddlDSCCodeText' value='${BRANCH_NAME}' />
       </td>
      </tr>
      <tr>
       <th scope="row">Error Code <span id='m6' name='m6' class="must" style="display:none">*</span>
       </th>
       <td><select disabled="disabled" id='ddlErrorCode'
        name='ddlErrorCode' onChange="fn_errMst_SelectedIndexChanged()">
       </select></td>
       <th scope="row">CT Code <span id='m7' name='m7' class="must" style="display:none">*</span>
       </th>
       <td>
        <!--
          <select  disabled="disabled" id='ddlCTCode' name='ddlCTCode'>
          <input type="hidden" title="" placeholder="" class=""  id='CTID' name='CTID'/>
           </select>
         --> <input type="hidden" title="" placeholder="ddlCTCode"
        class="" id='ddlCTCode' name='ddlCTCode' /> <input type="text"
        title="" placeholder="" class="readonly" id='ddlCTCodeText'
        name='ddlCTCodeText' /> <!--
         <input type="hidden" title="" placeholder="ddlCTCode" class=""  id='ddlCTCode' name='ddlCTCode' value='${USER_ID}'/>
         <input type="text" title=""   placeholder="" class="readonly"     id='ddlCTCodeText' name='ddlCTCodeText'  value='${USER_NAME}'/>
         -->
       </td>
      </tr>
      <tr>
       <th scope="row">Error Description <span id='m8' name='m8' class="must" style="display:none">*</span>
       </th>
       <td><select id='ddlErrorDesc' name='ddlErrorDesc'>
       </select></td>
       <th scope="row">Warehouse</th>
       <td><select class="disabled" disabled="disabled"
        id='ddlWarehouse' name='ddlWarehouse'>
       </select></td>
      </tr>
      <tr>
       <th scope="row">Remark</th>
       <td colspan="3"><textarea cols="20" rows="5" placeholder=""
         id='txtRemark' name='txtRemark'></textarea></td>
      </tr>
      <tr>
       <th scope="row">Commission</th>
       <td colspan="3"><label><input type="checkbox"
         disabled="disabled" id='iscommission' name='iscommission' /><span>Has
          commission ? </span></label></td>
      </tr>
      <tr>
       <th scope="row">Result Creator</th>
       <td><input type="text" title="" placeholder=""
        class="disabled" disabled="disabled" id='creator' name='creator' />
       </td>
       <th scope="row">Result Create Date</th>
       <td><input type="text" title="" placeholder=""
        class="disabled" disabled="disabled" id='creatorat'
        name='creatorat' /></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </dd>
   <dt class="click_add_on">
    <a href="#">AS Defective Event</a>
   </dt>
   <dd>
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 140px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">Defect Type <span id='m9' name='m9' class="must" style="display:none">*</span>
       </th>
       <td><input type="text" title="" id='def_type' disabled="disabled" name='def_type' placeholder="ex) DT3" class="" onblur="fn_getASReasonCode2(this, 'def_type' ,'387')" onkeyup="this.value = this.value.toUpperCase();" />
        <input type="hidden" title="" id='def_type_id' name='def_type_id' placeholder="" class="" />
        <input type="text" title="" placeholder="" id='def_type_text' name='def_type_text'  disabled style="width:60%;"/>
       </td>
      </tr>
      <tr>
       <th scope="row">Defect Code <span id='m10' name='m10' class="must" style="display:none">*</span>
       </th>
       <td><input type="text" title="" placeholder="ex) FF" disabled="disabled" id='def_code' name='def_code' class="" onblur="fn_getASReasonCode2(this, 'def_code', '303')"  onkeyup="this.value = this.value.toUpperCase();" />
       <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" />
       <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' disabled style="width:60%;"/></td>
      </tr>
      <tr>
       <th scope="row">Defect Part <span id='m11' name='m11' class="must" style="display:none">*</span>
       </th>
       <td><input type="text" title="" placeholder="ex) FE12" disabled="disabled" id='def_part' name='def_part' class="" onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" />
       <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" />
       <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' disabled style="width:60%;"/></td>
      </tr>
      <tr>
       <th scope="row">Detail of Defect <span id='m12' name='m12' class="must" style="display:none">*</span>
       </th>
       <td><input type="text" title="" placeholder="ex) 18 " disabled="disabled" id='def_def' name='def_def' class="" onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" />
       <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" />
       <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' disabled style="width:60%;"/></td>
      </tr>
      <tr>
       <th scope="row">Solution Code <span id='m13' name='m13' class="must" style="display:none">*</span>
       </th>
       <td><input type="text" title="" placeholder="ex) A9" class="" disabled="disabled" id='solut_code' name='solut_code' onblur="fn_getASReasonCode2(this, 'solut_code'  ,'337')" onkeyup="this.value = this.value.toUpperCase();" />
       <input type="hidden" title="" placeholder="" class="" id='solut_code_id' name='solut_code_id' />
       <input type="text" title="" placeholder="" class="" id='solut_code_text' name='solut_code_text' disabled style="width:60%;"/></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </dd>
   <dt class="click_add_on">
    <a href="#">AS Charges Fees</a>
   </dt>
   <dd>
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 170px" />
      <col style="width: *" />
      <col style="width: 140px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">Labour Charge</th>
       <td><label><input type="checkbox" id='txtLabourch'
         name='txtLabourch'
         '  onChange="fn_LabourCharge_CheckedChanged(this)" /></label></td>
       <th scope="row">Labour Charge</th>
       <td><input type="text" id='txtLabourCharge'
        name='txtLabourCharge' value='0.00' /></td>
      </tr>
      <tr>
       <th scope="row">Labour Charge Amt</th>
       <td><select id='cmbLabourChargeAmt'
        name='cmbLabourChargeAmt'
        onChange="fn_cmbLabourChargeAmt_SelectedIndexChanged()">
         <option value=""></option>
         <option value="60">RM 60.00</option>
         <option value="100">RM 100.00</option>
         <option value="120">RM 120.00</option>
       </select></td>
       <th scope="row">Filter Charge</th>
       <td><input type="text" id='txtFilterCharge'
        name='txtFilterCharge' value='0.00' /></td>
      </tr>
      <tr>
       <th scope="row"></th>
       <td></td>
       <th scope="row">Total Charge</th>
       <td><input type="text" id='txtTotalCharge'
        name='txtTotalCharge' value='0.00' /></td>
      </tr>
      <tr>
       <th scope="row">Filter Code</th>
       <td><select id='ddlFilterCode' name='ddlFilterCode'
        onChange="fn_onChangeddlFilterCode()">
       </select></td>
       <th scope="row">Quantity</th>
       <td><select id='ddlFilterQty' name='ddlFilterQty'>
         <option value="">Choose One</option>
         <option value="1" selected>1</option>
         <option value="2">2</option>
         <option value="3">3</option>
         <option value="4">4</option>
         <option value="5">5</option>
         <option value="6">6</option>
         <option value="7">7</option>
         <option value="8">8</option>
         <option value="9">9</option>
         <option value="10">10</option>
         <option value="11">11</option>
         <option value="12">12</option>
       </select></td>
      </tr>
      <tr>
       <th scope="row">Payment Type</th>
       <td><select id='ddlFilterPayType' name='ddlFilterPayType'
        onChange="fn_cmbPaymentType()">
         <option value="">Choose One</option>
         <option value="FOC">Free of Charge</option>
         <option value="CHG">Charge</option>
       </select></td>
       <th scope="row">Exchange Code</th>
       <td><select id='ddlFilterExchangeCode'
        name='ddlFilterExchangeCode'>
       </select></td>
      </tr>
      <tr>
       <th scope="row">Remark</th>
       <td colspan="3"><textarea cols="20" rows="5" placeholder=""
         id='txtFilterRemark' name='txtFilterRemark'></textarea></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
    <ul class="center_btns" id='addDiv'>
     <li><p class="btn_blue2">
       <a href="#" onclick="fn_filterAdd()">Add Filter</a>
      </p></li>
     <li><p class="btn_blue2">
       <a href="#" onclick="fn_clearPanelField_ASChargesFees()">Clear</a>
      </p></li>
    </ul>
    <article class="grid_wrap">
     <!-- grid_wrap start -->
     <div id="asfilter_grid_wrap"
      style="width: 100%; height: 220px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
   </dd>
   <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
   <dt class="click_add_on">
    <a href="#">In-House Repair Entry</a>
   </dt>
   <dd id='inHouseRepair_div' style="display: none">
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 170px" />
      <col style="width: *" />
      <col style="width: 140px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">Replacement <span class="must">*</span></th>
       <td><label> <input type="radio" id='replacement'
         name='replacement' value='1' onclick="fn_replacement(1)"/> Y <input type="radio"
         id='replacement' name='replacement' value='0' onclick="fn_replacement(0)"/> N
       </label></td>
       <th scope="row">Promise Date <span class="must">*</span></th>
       <td><input type="text" title="Create start Date"
        placeholder="DD/MM/YYYY" class="j_date" id="promisedDate"
        name="promisedDate" onchange="fn_chkDateRange(this)" /><input type="hidden" id="lmtDt" name="lmtDt" value="${inHseLmtDy}" disabled /></td>
      </tr>
      <tr>
       <th scope="row">Loan Product Category <span id='mInH1' name='mInH1' class="must" style="display:none">*</span></th>
       <td><select id='productGroup' name='productGroup'
        onChange="fn_productGroup_SelectedIndexChanged()">
       </select></td>
       <th scope="row">Loan Product <span id='mInH2' name='mInH2' class="must" style="display:none">*</span></th>
       <td><select id='productCode' name='productCode'></select>
       </td>
      </tr>
      <tr>
       <th scope="row">Loan Product Serial Number <span id='mInH3' name='mInH3' class="must" style="display:none">*</span></th>
       <td colspan="3"><input type="text" id='serialNo'
        name='serialNo' onChange="fn_chSeriaNo()" /></td>
      </tr>
      <tr>
       <th scope="row">Remark</th>
       <td colspan="3"><textarea cols="20" rows="5" placeholder=""
         id='inHouseRemark' name='inHouseRemark'></textarea></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </dd>
   <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
  </dl>
 </article>
 <!-- acodi_wrap end -->
</form>
<script type="text/javascript">

</script>
