<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.1          RE-STRUCTURE JSP AND ADD IN HOUSE REPAIR FUNCTION
 02/04/2019  ONGHC  1.0.2          Inherit Error Code and Error Desc.
 26/04/2019  ONGHC  1.0.3          ADD RECALL STATUS
 -->

<!-- AS ORDER > AS MANAGEMENT > VIEW / ADD AS ENTRY -->
<script type="text/javaScript">
  var regGridID;
  var myFltGrd10;
  var productCode;
  var asMalfuncResnId;

  $(document).ready(
    function() {
      createAUIGrid();
      createCFilterAUIGrid();

      //add_CreateAUIGrid();
      AUIGrid.bind(myFltGrd10, "addRow", auiAddRowHandler);
      AUIGrid.bind(myFltGrd10, "removeRow", auiRemoveRowHandler);

      var isF = true;
      AUIGrid.bind(myFltGrd10, "rowStateCellClick", function(event) {
        if (event.marker == "added") {
          if (event.item.filterType == "CHG") {
            /*var fChage = Number($("#txtFilterCharge").val());
            var totchrge = Number($("#txtTotalCharge").val());

            fChage = (fChage - Number(event.item.filterTotal)).toFixed(2);
            totchrge = (totchrge - Number(event.item.filterTotal)).toFixed(2);

            $("#txtFilterCharge").val(fChage);
            $("#txtTotalCharge").val(totchrge);*/
          }
        } else if (event.marker == "removed") {
          if (event.item.filterType == "CHG") {
            var fChage = Number($("#txtFilterCharge").val());
            var totchrge = Number($("#txtTotalCharge").val());

            fChage = (fChage + Number(event.item.filterTotal)).toFixed(2);
            totchrge = (totchrge + Number(event.item.filterTotal)).toFixed(2);

            $("#txtFilterCharge").val(fChage);
            $("#txtTotalCharge").val(totchrge);
          }
        } else if (event.marker == "added-edited") {
        }

      });

      fn_getErrMstList('${ORD_NO}');

      doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '', 'ddlFilterExchangeCode', 'S', ''); // FITLER EXCHANGE CODE
      doGetCombo('/services/as/getBrnchId', '', '', 'branchDSC', 'S', ''); // RECALL ENTRY DSC CODE
      doGetCombo('/services/as/inHouseGetProductMasters.do', '', '', 'productGroup', 'S', ''); // IN HOUSE PRODUCT CODE
      // doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=166', '', '', 'ddlFailReason', 'S', '');
      // doGetCombo('/services/as/getASMember.do', '', '','ddlCTCode', 'S' , '');
      // doGetCombo('/services/as/getBrnchId.do', '', '','ddlDSCCode', 'S' , '');

      fn_getASOrderInfo(); // GET AS ORDER INFOR.
      fn_getASEvntsInfo(); // GET AS EVENT INFOR.
      fn_getASHistoryInfo(); // GET AS HISTORY INFOR

      fn_DisablePageControl(); // DISABLE ALL THE FIELD
      $("#ddlStatus").attr("disabled", false); // ENABLE BACK STATUS

      AUIGrid.resize(myFltGrd10, 950, 200);

      fn_getASRulstSVC0004DInfo();
      fn_getASRulstEditFilterInfo();

      if ('${REF_REQST}' > 0) { // TO BE REMOVE
        //fn_getASRulstSVC0004DInfo();
        //fn_getASRulstEditFilterInfo();
        $("#IN_HOUSE_CLOSE").val("Y");
        //$("#btnSaveDiv").attr("style", "display:inline");
      }

      if ('${IS_AUTO}' == "true") { // TO BE REMOVE
        $("#inHouseRepair_div").attr("style", "display:none");
      }
    });

  function fn_inHouseAutoClose() {
    if ('${IS_AUTO}' == "true") {
      $("#ddlStatus").attr("disabled", false);
      $('#ddlStatus').val("4");
      fn_doSave();

      setTimeout(function() {
        $("#_newASResultDiv1").remove();
      }, 2000);
    }
  }

  function fn_getErrMstList(_ordNo) {
    var SALES_ORD_NO = _ordNo;
    $("#ddlErrorCode option").remove();
    doGetCombo('/services/as/getErrMstList.do?SALES_ORD_NO=' + SALES_ORD_NO, '', '', 'ddlErrorCode', 'S', '');
  }

  function fn_errMst_SelectedIndexChanged() {
    //$('#ddlErrorCode').removeAttr("disabled").removeClass("readonly");
    var DEFECT_TYPE_CODE = $("#ddlErrorCode").val();

    $("#ddlErrorDesc option").remove();
    doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE=' + DEFECT_TYPE_CODE, '', '', 'ddlErrorDesc', 'S', 'fn_errDetail_SetVal');
    //$("#ddlErrorCode").attr("disabled", true);
  }

  function fn_errDetail_SetVal() {
    $("#ddlErrorDesc").val(asMalfuncResnId);
  }

  function fn_getASRulstEditFilterInfo() {
    Common.ajax("GET", "/services/as/getASRulstEditFilterInfo", { REF_REQST : $('#REF_REQST').val() }, function(result) {
      if (result != null) {
        if (result.length > 0) {
          for (i in result) {
            AUIGrid.addRow(myFltGrd10, result[i], "last");
          }
        }
      }

    });
  }

  function fn_getASRulstSVC0004DInfo() {
    Common.ajax("GET", "/services/as/getASRulstSVC0004DInfo", $("#resultASForm").serialize(), function(result) {
      if (result != "") {
        fn_setSVC0004dInfo(result);
      } else {
        fn_checkASEntryCommission();
      }
    });
  }

  function fn_checkASEntryCommission(){
    Common.ajax("GET", "/services/as/getASEntryCommission", $("#resultASForm").serialize(), function(result) {
      if (result == "1") {
        $("#iscommission").prop("checked", true);
      } else {
        $("#iscommission").prop("checked", false);
      }
    });
  }

  function fn_setSVC0004dInfo(result) {
   console.log(result);
    $("#creator").val(result[0].c28);
    $("#creatorat").val(result[0].asResultCrtDt);
    $("#txtResultNo").text(result[0].asResultNo);

    if ('${REF_REQST}' > 0) {
      $("#txtResultNo").text("");
    }

    $("#ddlStatus").val(result[0].asResultStusId);
    $("#dpSettleDate").val(result[0].asSetlDt);
    $("#ddlFailReason").val(result[0].c2);
    $("#tpSettleTime").val(result[0].asSetlTm);
    $("#ddlDSCCode").val(result[0].asBrnchId);
    $("#ddlDSCCodeText").val(result[0].c5);
    $("#ddlErrorCode").val(result[0].asMalfuncId);
    $("#ddlErrorDesc").val(result[0].asMalfuncResnId);

    asMalfuncResnId = result[0].asMalfuncResnId;

    fn_errMst_SelectedIndexChanged(result[0].asMalfuncResnId);

    $("#ddlCTCodeText").val(result[0].c12);
    $("#ddlCTCode").val(result[0].c11);
    $("#CTID").val(result[0].c11);

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

    $('#asInHouseComDt').val(result[0].asResultDt);

    if (result[0].c25 == "B8" || result[0].c25 == "B6") {
      $("#inHouseRepair_div").attr("style", "display:inline");
    }

    if (result[0].inHuseRepairReplaceYn == "1") {
      $("input:radio[name='replacement']:radio[value='1']").attr(
          'checked', true);
      fn_replacement(1);
    } else if (result[0].inHuseRepairReplaceYn == "0") {
      $("input:radio[name='replacement']:radio[value='0']").attr(
          'checked', true);
      fn_replacement(0);
    }

    $("#promisedDate").val(result[0].inHuseRepairPromisDt);
    $("#productGroup").val(result[0].inHuseRepairGrpCode);
    $("#productCode").val(result[0].inHuseRepairProductCode);
    $("#serialNo").val(result[0].inHuseRepairSerialNo);
    $("#inHouseRemark").val(result[0].inHuseRepairRem);
    $("#APPNT_DT").val(result[0].appntDt);
    $("#asResultCrtDt").val(result[0].asResultCrtDt);

    productCode = result[0].inHuseRepairProductCode;

    if (typeof (productCode) != "undefined") { doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + result[0].inHuseRepairGrpCode, '', '', 'productCode', 'S', 'fn_inHouseGetProductDetails'); }

    $('#txtLabourCharge').val(result[0].asWorkmnsh);
    $('#txtFilterCharge').val(result[0].asFilterAmt);
    $('#txtTotalCharge').val(result[0].asTotAmt);

    fn_ddlStatus_SelectedIndexChanged("Y");

    setTimeout(function() {
      fn_inHouseAutoClose();
    }, 2000);
  }

  function fn_inHouseGetProductDetails() {
    $("#productCode").val(productCode);
  }

  function auiAddRowHandler(event) {

  }

  function auiRemoveRowHandler(event) {
    if (event.items[0].filterType == "CHG") {
      var fChage = Number($("#txtFilterCharge").val());
      var totchrge = Number($("#txtTotalCharge").val());

      if (fChage.toFixed(2) != "0.00") {
        fChage = (fChage - Number(event.items[0].filterTotal)).toFixed(2);
        totchrge = (totchrge - Number(event.items[0].filterTotal)).toFixed(2);

        $("#txtFilterCharge").val(fChage);
        $("#txtTotalCharge").val(totchrge);
      }
    }
  }

  function createAUIGrid() {
    var columnLayout = [ {
      dataField : "asNo",
      headerText : "<spring:message code='service.grid.ASTyp'/>",
      editable : false
    }, {
      dataField : "c2",
      headerText : "<spring:message code='service.grid.ASRs'/>",
      width : 80,
      editable : false,
      dataType : "date",
      formatString : "dd/mm/yyyy"
    }, {
      dataField : "code",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : 80
    }, {
      dataField : "asReqstDt",
      headerText : "<spring:message code='service.grid.ReqstDt'/>",
      width : 100,
      editable : false,
      dataType : "date",
      formatString : "dd/mm/yyyy"
    }, {
      dataField : "asSetlDt",
      headerText : "<spring:message code='service.grid.SettleDate'/>",
      width : 100,
      editable : false,
      dataType : "date",
      formatString : "dd/mm/yyyy"
    }, {
      dataField : "c3",
      headerText : "<spring:message code='service.grid.ErrCde'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c4",
      headerText : "<spring:message code='service.grid.ErrDesc'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c5",
      headerText : "<spring:message code='service.grid.CTCode'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c6",
      headerText : "<spring:message code='service.grid.Solution'/>",
      width : 150,
      editable : false
    }, {
      dataField : "c7",
      headerText : "<spring:message code='service.grid.ASAmt'/>",
      width : 150,
      dataType : "numeric",
      formatString : "#,##0.00",
      editable : false
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      fixedColumnCount : 1,
      selectionMode : "singleRow",
      showRowNumColumn : true
    };

    regGridID = GridCommon.createAUIGrid("reg_grid_wrap", columnLayout, "", gridPros);
  }

  function createCFilterAUIGrid() {
    var clayout = [ {
      dataField : "filterType",
      headerText : "<spring:message code='service.grid.ASNo'/>",
      editable : false
    }, {
      dataField : "filterDesc",
      headerText : "<spring:message code='service.grid.ASFltDesc'/>",
      editable : false,
      width : 250
    }, {
      dataField : "filterExCode",
      headerText : "<spring:message code='service.grid.ASFltCde'/>",
      editable : false,
      width : 150
    }, {
      dataField : "filterQty",
      headerText : "<spring:message code='service.grid.Quantity'/>",
      editable : false,
      width : 100
    }, {
      dataField : "filterPrice",
      headerText : "<spring:message code='service.title.Price'/>",
      editable : false,
      width : 100
    }, {
      dataField : "filterTotal",
      headerText : "<spring:message code='sal.title.total'/>",
      editable : false,
      width : 150
    }, {
      dataField : "filterRemark",
      headerText : "<spring:message code='service.title.Remark'/>",
      editable : false,
      width : 150,
      editable : false
    }, {
      dataField : "srvFilterLastSerial",
      headerText : "<spring:message code='service.title.SerialNo'/>",
      editable : false,
      width : 200,
      editable : true
    }, {
      dataField : "undefined",
      headerText : " ",
      width : 110,
      renderer : {
        type : "ButtonRenderer",
        labelText : "<spring:message code='pay.btn.remove'/>",
        onclick : function(rowIndex, columnIndex, value, item) {
          AUIGrid.removeRow(myFltGrd10, rowIndex);
        }
      }
    }, {
      dataField : "filterID",
      headerText : "<spring:message code='service.grid.FilterId'/>",
      width : 150,
      visible : false
    }
    ];

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

  function fn_getASOrderInfo() {
    Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultASForm").serialize(), function(result) {
      $("#txtASNo").text($("#AS_NO").val());
      $("#txtOrderNo").text(result[0].ordNo);
      $("#txtAppType").text(result[0].appTypeCode);
      $("#txtCustName").text(result[0].custName);
      $("#txtCustIC").text(result[0].custNric);
      $("#txtContactPerson").text(result[0].instCntName);

      $("#txtTelMobile").text(result[0].instCntTelM);
      $("#txtTelResidence").text(result[0].instCntTelR);
      $("#txtTelOffice").text(result[0].instCntTelO);
      //$("#txtInstallAddress").text(result[0].instCntName);
      $("#txtInstallAddress").text(result[0].instAddrDtl);

      $("#txtProductCode").text(result[0].stockCode);
      $("#txtProductName").text(result[0].stockDesc);
      $("#txtSirimNo").text(result[0].lastInstallSirimNo);
      $("#txtSerialNo").text(result[0].lastInstallSerialNo);

      $("#txtCategory").text(result[0].c2);
      $("#txtInstallNo").text(result[0].lastInstallNo);
      $("#txtInstallDate").text(result[0].c1);
      $("#txtInstallBy").text(result[0].lastInstallCtCode);
      $("#txtInstruction").text(result[0].instct);
      $("#txtMembership").text(result[0].c5);
      $("#txtExpiredDate").text(result[0].c6);

      doGetCombo('/services/as/getASFilterInfo.do?prdctCd=' + result[0].stockCode, '', '', 'ddlFilterCode', 'S', '');
    });
  }

  function fn_getASEvntsInfo() {
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm").serialize(), function(result) {
      $("#txtASStatus").text(result[0].code);
      $("#txtRequestDate").text(result[0].asReqstDt);
      $("#txtRequestTime").text(result[0].asReqstTm);

      $("#txtAppDt").text(result[0].asAppntDt);
      $("#txtAppTm").text(result[0].asAppntTm);

      $("#txtMalfunctionCode").text(result[0].asMalfuncId);
      $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);
      $("#txtDSCCode").text(result[0].c7 + "-" + result[0].c8);
      $("#txtInchargeCT").text(result[0].c10 + "-" + result[0].c11);

      $("#txtRequestor").text(result[0].c3);
      $("#txtASKeyBy").text(result[0].c1);
      $("#txtRequestorContact").text(result[0].asRemReqsterCntc);
      $("#txtASKeyAt").text(result[0].asCrtDt);
    });
  }

  function fn_getASHistoryInfo() {
    Common.ajax("GET", "/services/as/getASHistoryInfo.do", $("#resultASForm").serialize(), function(result) {
      AUIGrid.setGridData(regGridID, result);
    });
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

          if ('337' == _v) {
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
            }
          } else {
            $("#" + _tobj + "_text").val("<spring:message code='service.msg.NoDfctCode'/>");
            $("#promisedDate").val("").attr("disabled", true);
            $("#productGroup").val("").attr("disabled", true);
            $("#productCode").val("").attr("disabled", true);
            $("#serialNo").val("").attr("disabled", true);
            $("#inHouseRemark").val("").attr("disabled", true);
            $("#inHouseRepair_div").attr("style", "display:none");
            $("input:radio[name='replacement']").removeAttr('checked');
            fn_replacement(0);
          }
        });

  }

  function getASStockPrice(_PRC_ID) {
    var ret = 0;
    Common.ajaxSync("GET", "/services/as/getASStockPrice.do", { PRC_ID : _PRC_ID }, function(result) {
      try {
        ret = parseInt(result[0].amt, 10);
      } catch (e) {
        Common.alert("<spring:message code='service.msg.NoStkPrc'/>");
        ret = 0;
      }
    });
    return ret;

  }

  function fn_chStock() {
    var ct = $("#ddlCTCodeText").val();
    var sk = $("#ddlFilterCode").val();

    var availQty = isstckOk(ct, sk);

    if (availQty == 0) {
      Common.alert("<spring:message code='service.msg.NoStkAvl' arguments='<b>" + $("#ddlCTCodeText option:selected").text() + "</b> ; <b>" + ct +"</b>' htmlEscape='false' argumentSeparator=';' />");
      fn_filterClear();
      return false;
    } else {

      if (availQty < Number($("#ddlFilterQty").val())) {
        Common.alert("<spring:message code='service.msg.lessStkQty' arguments='<b>" + $("#ddlCTCodeText option:selected").text() + "</b> ; <b>" + ct +"</b>' htmlEscape='false' argumentSeparator=';' />");
        fn_filterClear();
        return false;
      }
      return true;
     }
  }

  function isstckOk(ct, sk) {
    // COUNT STOCK
    var availQty = 0;

    Common.ajaxSync("GET", "/services/as/getSVC_AVAILABLE_INVENTORY.do", { CT_CODE : ct, STK_CODE : sk
    }, function(result) {
      // RETURN AVAILABLE STOCK
      availQty = result.availQty;
    });

    return availQty;
  }

  function fn_filterAddVaild() {
    var msg = "";
    var text = "";
    if (FormUtil.checkReqValue($("#ddlFilterCode option:selected"))) {
      text = "<spring:message code='service.title.FilterCode'/>";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
    }
    if (FormUtil.checkReqValue($("#ddlFilterQty option:selected"))) {
      text = "<spring:message code='service.grid.Quantity'/>";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
    }
    if (FormUtil.checkReqValue($("#ddlFilterPayType option:selected"))) {
      text = "<spring:message code='service.text.asPmtTyp'/>";
     msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
    }
    if (FormUtil.checkReqValue($("#ddlFilterExchangeCode option:selected"))) {
      text = "<spring:message code='service.text.asExcRsn'/>";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
    }

    if ($("#txtLabourch").is(':checked')) {
      if (FormUtil.checkReqValue($("#cmbLabourChargeAmt option:selected"))) {
        text = "<spring:message code='service.text.asLbrChr'/>";
        msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
      }
    }

    if (msg != ""){
      Common.alert(msg);
      return false;
    }
  }

  function fn_filterAdd() {
    // CHECK AVAILABLE STOCK
    if (fn_chStock() == false) {
      return;
    }

    if (fn_filterAddVaild() == false) {
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
    fitem.srvFilterLastSerial = $("#ddSrvFilterLastSerial").val();

    // CHECK PRICE
    var chargePrice = 0;
    var chargeTotalPrice = 0;

    if (fitem.filterType == "CHG") {
      chargePrice = getASStockPrice(fitem.filterID);
      if (chargePrice == 0) {
        Common.alert("<spring:message code='service.msg.stkNoPrice'/>");
        return ;
      }
    }

    fitem.filterPrice = parseInt(chargePrice, 10).toFixed(2);

    chargeTotalPrice = Number($("#ddlFilterQty").val()) * Number((chargePrice));
    fitem.filterTotal = Number(chargeTotalPrice).toFixed(2);

    var v = Number($("#txtFilterCharge").val()) + Number(chargeTotalPrice);
    $("#txtFilterCharge").val(v.toFixed(2));

    if (AUIGrid.isUniqueValue(myFltGrd10, "filterID", fitem.filterID)) {
      fn_addRow(fitem);
    } else {
      Common.alert("<spring:message code='service.msg.rcdExist'/>");
      return;
    }

    fn_calculateTotalCharges();
    fn_filterClear();
  }

  function fn_filterClear() {
    $("#ddlFilterCode").val("");
    $("#ddlFilterQty").val("");
    $("#ddlFilterPayType").val("");
    $("#ddlFilterExchangeCode").val("");
    $("#ddSrvFilterLastSerial").val("");
    $("#txtFilterRemark").val("");
  }

  function fn_addRow(gItem) {
    AUIGrid.addRow(myFltGrd10, gItem, "first");
  }

  function fn_LabourCharge_CheckedChanged(_obj) {
    if (_obj.checked) {
      $("#fcm1").show();
      $('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");
      $("#cmbLabourChargeAmt").val("");
      $("#txtLabourCharge").val("0.00");
    } else {
      $("#fcm1").hide();
      $("#cmbLabourChargeAmt").val("");
      $("#cmbLabourChargeAmt").attr("disabled", true);
      $("#txtLabourCharge").val("0.00");
    }

    fn_calculateTotalCharges();
  }

  function fn_calculateTotalCharges() {
    var labourCharges = 0;
    var filterCharges = 0;
    var totalCharges = 0;

    labourCharges = $("#txtLabourCharge").val();
    filterCharges = $("#txtFilterCharge").val();
    totalCharges = parseFloat(labourCharges) + parseFloat(filterCharges);

    $("#txtTotalCharge").val(totalCharges.toFixed(2));
  }

  function fn_cmbLabourChargeAmt_SelectedIndexChanged() {
    var v = "0.00";
    if ($("#cmbLabourChargeAmt").val() != "") {
      v = $("#cmbLabourChargeAmt option:selected").text();
    } else {
      v = "0.00";
    }
    $("#txtLabourCharge").val(v);
    fn_calculateTotalCharges();
  }

  function fn_ddlStatus_SelectedIndexChanged(ind) {
    // STATUS CHANGE FAIL REASON CODE CHANGED
    if ($("#ddlStatus").val() == 19) { // RECALL
      doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=5551', '', '', 'ddlFailReason', 'S', '');
    } else if ($("#ddlStatus").val() == 10) { // CANCEL
      doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=5550', '', '', 'ddlFailReason', 'S', '');
    } else {
      doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=0', '', '', 'ddlFailReason', 'S', '');
      $("#ddlFailReason").attr("disabled", true);
    }

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    $("#ddlCTCode").val(selectedItems[0].item.asMemId);
    $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
    $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
    $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);

    if (selectedItems[0].item.asMalfuncId != "") {
      $("#ddlErrorCode").val(selectedItems[0].item.asMalfuncId);
      asMalfuncResnId = selectedItems[0].item.asMalfuncResnId;
      fn_errMst_SelectedIndexChanged();
    }

    switch ($("#ddlStatus").val()) {
    case "4":
      // COMPLETE
      fn_openField_Complete();
      // RESET SECTION
      fn_rstRecall(); //RECALL
      $("#defEvt_div").attr("style", "display:block");
      $("#chrFee_div").attr("style", "display:block");
      $("#recall_div").attr("style", "display:none");
      break;

    case "1":
      // INHOUSE ACTIVE
      fn_openField_Complete();
      // RESET SECTION
      fn_rstRecall(); //RECALL
      //fn_rstDftEnt(); //DEFECT ENTRY
      fn_rstChrFee(); //FEE CAHRGE
      $("#defEvt_div").attr("style", "display:block");
      $("#chrFee_div").attr("style", "display:none");
      $("#recall_div").attr("style", "display:none");
      break;

    case "10":
      // CANCEL
      fn_clearPageField();
      fn_openField_Cancel();
      // RESET SECTION
      fn_rstRecall(); //RECALL
      fn_rstDftEnt(); //DEFECT ENTRY
      fn_rstChrFee(); //FEE CAHRGE
      $("#recall_div").attr("style", "display:none");
      $("#defEvt_div").attr("style", "display:none");
      $("#chrFee_div").attr("style", "display:none");

      $("#m14").show();
      break;

    case "21":
      // FAILED
      fn_clearPageField();
      fn_openField_Fail();
      // RESET SECTION
      fn_rstRecall(); //RECALL
      fn_rstDftEnt(); //DEFECT ENTRY
      fn_rstChrFee(); //FEE CAHRGE
      $("#recall_div").attr("style", "display:none");
      $("#defEvt_div").attr("style", "display:none");
      $("#chrFee_div").attr("style", "display:none");
      break;

    case "19":
      // RECALL
      fn_clearPageField();
      fn_openField_Cancel();
      fn_getRclData();
      fn_rstDftEnt(); //DEFECT ENTRY
      fn_rstChrFee(); //FEE CAHRGE
      $("#recall_div").attr("style", "display:block");
      $("#defEvt_div").attr("style", "display:none");
      $("#chrFee_div").attr("style", "display:none");

      $("#m14").hide();
      $("#txtRemark").val("");
      $("#txtRemark").attr("disabled", "disabled");
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
      $("#").hide();
      break;
    }
  }

  function fn_getRclData() {
  Common.ajax("GET", "/services/as/getASRclInfo.do", $("#resultASForm").serialize(), function(result) {
      $("#appDate").val(result[0].appDt);
      $("#CTSSessionCode").val(result[0].appSess);
      $("#branchDSC").val(result[0].dscCde);

      $("#CTCode").val(result[0].memId);
      $("#CTGroup").val(result[0].memGrp);
      $("#callRem").val(result[0].rclRmk);
    });
  }

  function fn_rstChrFee() {
    $("#txtLabourCharge").val("0.00");
    $("#cmbLabourChargeAmt").val("");
    $("#txtFilterCharge").val("0.00");
    $("#txtTotalCharge").val("0.00");

    $("#ddlFilterCode").val("");
    $("#ddlFilterQty").val("");
    $("#ddlFilterPayType").val("");
    $("#ddlFilterExchangeCode").val("");
    $("#ddSrvFilterLastSerial").val("");
    $("#txtFilterRemark").val("");

    $("#fcm1").hide();
    $("#fcm2").hide();
    $("#fcm3").hide();
    $("#fcm4").hide();
    $("#fcm5").hide();

    var allRowItems = AUIGrid.getGridData(myFltGrd10);
    if (allRowItems.length > 0) {
      AUIGrid.clearGridData(myFltGrd10);
    }
  }

  function fn_rstRecall() {
    $("#appDate").val("");
    $("#CTSSessionCode").val("");
    $("#branchDSC").val("");
    $("#CTCode").val("");
    $("#CTGroup").val("");
    $("#callRem").val("");
  }

  function fn_rstDftEnt() {
    $("#def_type").val("");
    $("#def_type_id").val("");
    $("#def_type_text").val("");

    $("#def_code").val("");
    $("#def_code_id").val("");
    $("#def_code_text").val("");

    $("#def_part").val("");
    $("#def_part_id").val("");
    $("#def_part_text").val("");

    $("#def_def").val("");
    $("#def_def_id").val("");
    $("#def_def_text").val("");

    $("#solut_code").val("");
    $("#solut_code_id").val("");
    $("#solut_code_text").val("");
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
    $("#m14").show();

    $("#btnSaveDiv").attr("style", "display:inline");
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
    $('#solut_code').removeAttr("disabled").removeClass("readonly");
    $('#def_def').removeAttr("disabled").removeClass("readonly");

    //$('#def_type_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_code_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_part_text').removeAttr("disabled").removeClass("readonly");
    //$('#solut_code_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_def_text').removeAttr("disabled").removeClass("readonly");

    //$("#txtFilterCharge").attr("disabled", false);
    //$("#txtLabourCharge").attr("disabled", false);
    //$("#cmbLabourChargeAmt").attr("disabled", false);
    $("#ddlFilterCode").attr("disabled", false);
    $("#ddlFilterQty").attr("disabled", false);
    $("#ddlFilterPayType").attr("disabled", false);
    $("#ddlFilterExchangeCode").attr("disabled", false);
    $("#ddSrvFilterLastSerial").attr("disabled", false);
    $("#txtFilterRemark").attr("disabled", false);
    fn_clearPanelField_ASChargesFees();

    //$("#ddlFilterQty").val("1");
    //$("#ddlFilterPayType").val("FOC");

    if ($('#solut_code').val() == "B8" || $('#solut_code').val() == "B6") {
      if ($("input[name='replacement'][value='1']").prop("checked")) {
        fn_replacement($("#replacement").val());
      }
    }
  }

  function fn_openField_Cancel() {
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

    $("#iscommission").attr("disabled", false);

    $("#def_type").attr("disabled", "disabled");
    $("#def_code").attr("disabled", "disabled");
    $("#def_part").attr("disabled", "disabled");
    $("#def_def").attr("disabled", "disabled");
    $("#solut_code").attr("disabled", "disabled");

    $("#dpSettleDate").val("");
    $("#tpSettleTime").val("");

    $( "#txtLabourch" ).prop( "checked", false );

    $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");

    $("#btnSaveDiv").attr("style", "display:inline");
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
    $("#").show();

    $("#def_type").attr("disabled", "disabled");
    $("#def_code").attr("disabled", "disabled");
    $("#def_part").attr("disabled", "disabled");
    $("#def_def").attr("disabled", "disabled");
    $("#solut_code").attr("disabled", "disabled");

    $("#dpSettleDate").val("");
    $("#tpSettleTime").val("");

    $( "#txtLabourch" ).prop( "checked", false );

    $("#btnSaveDiv").attr("style", "display:inline");
    $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");
  }

  function fn_clearPageMessage() {
  }

  function fn_clearPageField() {
    //$("#btnSaveDiv").attr("style", "display:none");
    //$('#dpSettleDate').val("").attr("disabled", true);
    //$('#ddlFailReason').val("").attr("disabled", true);
    //$('#tpSettleTime').val("").attr("disabled", true);
    //$('#ddlDSCCode').val("").attr("disabled", true);
    //$('#ddlErrorCode').val("").attr("disabled", true);
    //$('#ddlCTCode').val("").attr("disabled", true);
    //$('#ddlErrorDesc').val("").attr("disabled", true);
    //$('#ddlWarehouse').val("").attr("disabled", true);
    //$('#txtRemark').val("").attr("disabled", true);
    //$("#iscommission").attr("disabled", true);

    $("#btnSaveDiv").attr("style", "display:none");
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

    // AS CHARGES FEES
    fn_clearPanelField_ASChargesFees();
    $("#ddlFilterCode").val("").attr("disabled", true);
    $("#ddlFilterQty").val("").attr("disabled", true);
    $("#ddlFilterPayType").val("").attr("disabled", true);
    $("#ddlFilterExchangeCode").val("").attr("disabled", true);
    $("#txtFilterRemark").val("").attr("disabled", true);

    $("#txtLabourCharge").val("0.00").attr("disabled", true);
    $("#txtFilterCharge").val("0.00").attr("disabled", true);

    /*$("#ddlCTCode").val("");
    $("#ddlDSCCode").val("");
    $("#ddlCTCodeText").val("");
    $("#ddlDSCCodeText").val("");*/

    // AS DEFECTIVE EVENT
    /*$("#def_type").val("");
    $("#def_type_id").val("");
    $("#def_type_text").val("");

    $("#def_code").val("");
    $("#def_code_id").val("");
    $("#def_code_text").val("");

    $("#def_part").val("");
    $("#def_part_id").val("");
    $("#def_part_text").val("");

    $("#def_def").val("");
    $("#def_def_id").val("");
    $("#def_def_text").val("");

    $("#solut_code").val("");
    $("#solut_code_id").val("");
    $("#solut_code_text").val("");*/

    // CLOSE & RESET IN-HOUSE SECTION
    /*$("#inHouseRepair_div").attr("style", "display:none");
    $("input:radio[name='replacement']").removeAttr('checked');
    $("#promisedDate").val("");
    $("#productGroup").val("");
    $("#productCode").val("");
    $("#serialNo").val("");
    $("#inHouseRemark").val("");*/

    $("#mInH1").hide();
    $("#mInH2").hide();
    $("#mInH3").hide();

  }

  function fn_doSave() {
    // AS RESULT INFORMATION
    if (!fn_validRequiredField_Save_ResultInfo()) {
      return;
    }

    if ($("#ddlStatus").val() == 4 || $("#ddlStatus").val() == 1) { // COMPLETE OR ACTIVE
      // AS DEFECTIVE EVENT
      if (!fn_validRequiredField_Save_DefectiveInfo()) {
        return;
      }
    }

    fn_setSaveFormData();
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden'
          || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = -1;
      }
    });
  };

  function fn_setSaveFormData() {
    var addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10); // FEE CHARGE ADD SET
    var editedRowItems = AUIGrid.getEditedRowItems(myFltGrd10); // FEE CHARGE EDIT SET
    var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10); // FEE CHARGE DELETE SET

    var _AS_DEFECT_TYPE_ID = 0;
    var _AS_DEFECT_GRP_ID = 0;
    var _AS_DEFECT_ID = 0;
    var _AS_DEFECT_PART_GRP_ID = 0;
    var _AS_DEFECT_PART_ID = 0;
    var _AS_DEFECT_DTL_RESN_ID = 0;
    var _AS_SLUTN_RESN_ID = 0;

    // DEFECT ENTRY
    if ($('#ddlStatus').val() == '4' || $('#ddlStatus').val() == '1') {
      _AS_DEFECT_TYPE_ID = $('#def_type_id').val();
      _AS_DEFECT_ID = $('#def_code_id').val();
      _AS_DEFECT_PART_ID = $('#def_part_id').val();
      _AS_DEFECT_DTL_RESN_ID = $('#def_def_id').val();
      _AS_SLUTN_RESN_ID = $('#solut_code_id').val();
    }

    // IN HOUSE
    var inHInd = "";
    if ($('#ddlStatus').val() == '4') {
      if ($('#solut_code').val() == 'B8' || $('#solut_code').val() == 'B6') {
        inHInd = "";
      } else {
        inHInd = 'WEB';
      }
    } else {
      inHInd = 'WEB';
    }

    var inHseRprInd = "";
    if ($("input[name='replacement'][value='1']").prop("checked")) {
      inHseRprInd = 1;
    } else {
      inHseRprInd = 0;
    }

    var asResultM = {
      // GENERAL DATA
      AS_NO : "${AS_NO}",
      AS_ENTRY_ID : "${AS_ID}",
      AS_SO_ID : $("#ORD_ID").val(),
      AS_ORD_NO : $("#ORD_NO").val(),
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

      // AS RECALL ENTRY
      AS_APP_DT : $("#appDate").val(),
      AS_APP_SESS : $("#CTSSessionCode").val(),
      AS_RCL_ASG_DSC : $("#branchDSC").val(),
      AS_RCL_ASG_CT : $("#CTCode").val(),
      AS_RCL_ASG_CT_GRP : $("#CTGroup").val(),
      AS_RCL_RMK : $("#callRem").val(),

      // AS DEFECT ENTRY
      AS_DEFECT_TYPE_ID : _AS_DEFECT_TYPE_ID,
      AS_DEFECT_GRP_ID : _AS_DEFECT_GRP_ID,
      AS_DEFECT_ID : _AS_DEFECT_ID,
      AS_DEFECT_PART_GRP_ID : _AS_DEFECT_PART_GRP_ID,
      AS_DEFECT_PART_ID : _AS_DEFECT_PART_ID,
      AS_DEFECT_DTL_RESN_ID : _AS_DEFECT_DTL_RESN_ID,
      AS_SLUTN_RESN_ID : _AS_SLUTN_RESN_ID,

      // AS FILTER FEE CHARGES
      AS_WORKMNSH : $('#txtLabourCharge').val(),
      AS_FILTER_AMT : $('#txtFilterCharge').val(),
      AS_ACSRS_AMT : 0,
      AS_TOT_AMT : $('#txtTotalCharge').val(),
      AS_RESULT_IS_SYNCH : 0,
      AS_RCALL : 0,
      AS_RESULT_STOCK_USE : addedRowItems.length > 0 ? 1 : 0,
      AS_RESULT_TYPE_ID : 457,
      AS_RESULT_IS_CURR : 1,
      AS_RESULT_MTCH_ID : 0,
      AS_RESULT_NO_ERR : '',
      AS_ENTRY_POINT : 0,
      AS_WORKMNSH_TAX_CODE_ID : 0,
      AS_WORKMNSH_TXS : 0,
      AS_RESULT_MOBILE_ID : 0,

      // AS IN HOUSE REPAIR
      IN_HUSE_REPAIR_REM : $("#inHouseRemark").val(),
      IN_HUSE_REPAIR_REPLACE_YN : inHseRprInd,
      IN_HUSE_REPAIR_PROMIS_DT : $("#promisedDate").val(),
      IN_HUSE_REPAIR_GRP_CODE : $("#productGroup").val(),
      IN_HUSE_REPAIR_PRODUCT_CODE : $("#productCode").val(),
      IN_HUSE_REPAIR_SERIAL_NO : $("#serialNo").val(),
      CHANGBN : inHInd,
      IN_HOUSE_CLOSE : $("#IN_HOUSE_CLOSE").val(),

      // OTHER
      RCD_TMS : $("#RCD_TMS").val()
    }

    var saveForm = {
      "asResultM" : asResultM,
      "add" : addedRowItems,
      "update" : editedRowItems,
      "remove" : removedRowItems
    }

    // SAVE RESULT
    Common.ajax("POST", "/services/as/newASInHouseAdd.do", saveForm,
      function(result) {
        if (result.data != "" && result.data != null && result.data != "null") {
          Common.alert("<b>AS result save successfully.</b></br> New AS Result Number : <b>" + result.data + " </b>");
          $("#txtResultNo").html("<font size='3' color='red'> <b> " + result.data + " </b></font>");
          fn_DisablePageControl();
          $("#_newASResultDiv1").remove();
          fn_searchASManagement();
        } else {
          Common.alert("<b>AS result save successfully.</b>");
          $("#txtResultNo").html("<font size='3' color='red'> <b> " + $("#txtResultNo").val() + " </b></font>");
          fn_DisablePageControl();
          $("#_newASResultDiv1").remove();
          fn_searchASManagement();
        }
      }, function() {
        $("#_newASResultDiv1").remove();
        fn_searchASManagement();
      });
  }

  function fn_clearPanelField_ASChargesFees() {
    $('#ddlFilterCode').val("");
    $('#ddlFilterQty').val("");
    $('#ddlFilterPayType').val("");
    $('#ddlFilterExchangeCode').val("");
    $('#txtFilterRemark').val("");

  }

  function fn_DisablePageControl() {
    $("#ddlStatus").attr("disabled", true);
    $("#dpSettleDate").attr("disabled", true);
    $("#ddlFailReason").attr("disabled", true);
    $("#ddlStatus").attr("disabled", true);
    $("#tpSettleTime").attr("disabled", true);
    $("#ddlDSCCode").attr("disabled", true);
    $("#ddlErrorCode").attr("disabled", true);
    $("#ddlErrorDesc").attr("disabled", true);
    $("#ddlCTCode").attr("disabled", true);
    $("#ddlWarehouse").attr("disabled", true);
    $("#txtRemark").attr("disabled", true);
    $("#iscommission").attr("disabled", true);

    $("#def_type").attr("disabled", true);
    $("#def_code").attr("disabled", true);
    $("#def_def").attr("disabled", true);
    $("#def_part").attr("disabled", true);
    $("#solut_code").attr("disabled", true);

    $("#def_type_text").attr("disabled", true);
    $("#def_code_text").attr("disabled", true);
    $("#def_def_text").attr("disabled", true);
    $("#def_part_text").attr("disabled", true);
    $("#solut_code_text").attr("disabled", true);

    $("#ddlWarehouse").attr("disabled", true);

    $("#ddlFilterQty").attr("disabled", true);
    $("#def_code").attr("disabled", true);
    $("#def_def_id").attr("disabled", true);
    $("#def_part").attr("disabled", true);
    $("#solut_code").attr("disabled", true);
    $("#ddlWarehouse").attr("disabled", true);

    $("#ddlFilterCode").attr("disabled", true);
    $("#ddlFilterQty").attr("disabled", true);
    $("#ddlFilterPayType").attr("disabled", true);
    $("#ddlFilterExchangeCode").attr("disabled", true);
    $("#ddSrvFilterLastSerial").attr("disabled", true);
    $("#txtFilterRemark").attr("disabled", true);
    fn_clearPanelField_ASChargesFees();

    $("#btnSaveDiv").attr("style", "display:none");
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

    if ($("#ddlStatus").val() == 4) { // IN HOUSE REPAIR
      if ($("#solut_code").val() == "B8" || $("#solut_code").val() == "B6") {
       if ($("input[name='replacement'][value='1']").prop("checked")) {
          if (FormUtil.checkReqValue($("#serialNo"))) {
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Loan Product Serial Nuber' htmlEscape='false'/> </br>";
            rtnValue = false;
          }
        }
      }
    }

    if (rtnValue == false) {
      Common.alert(rtnMsg);
    }

    return rtnValue;
  }

  function fn_validRequiredField_Save_ResultInfo() {
    var text = "";
    var rtnMsg = "";
    var rtnValue = true;

    if (FormUtil.checkReqValue($("#ddlStatus"))) {
      text = "<spring:message code='service.grid.Status'/>";
      rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
      rtnValue = false;
    } else {
      if ($("#ddlStatus").val() == 4 || $("#ddlStatus").val() == 1) { // COMPLETE OR ACTIVE
        if (FormUtil.checkReqValue($("#dpSettleDate"))) { // IF SATTLE DATE IS EMPTY
          text = "<spring:message code='service.grid.SettleDate'/>";
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
          rtnValue = false;
        } else {
          var asno = $("#txtASNo").val(); // AS NO.
          if (asno.match("AS")) {
            var nowdate = $.datepicker.formatDate($.datepicker.ATOM, new Date());
            var nowdateArry = nowdate.split("-");
            nowdateArry = nowdateArry[0] + "" + nowdateArry[1] + "" + nowdateArry[2];
            var rdateArray = $("#dpSettleDate").val().split("/");
            var requestDate = rdateArray[2] + "" + rdateArray[1] + "" + rdateArray[0];

            // TODO GET PERIOD FROM DB
            if ((parseInt(requestDate, 10) - parseInt(nowdateArry, 10)) > 14 || (parseInt(nowdateArry, 10) - parseInt(requestDate, 10)) > 14) {
              rtnMsg += "* <spring:message code='service.msg.RqstDtNoMore' arguments='14' htmlEscape='false'/> </br>";
              rtnValue = false;
            }

          }
        }

        if (FormUtil.checkReqValue($("#tpSettleTime"))) { // SETTLE TIME
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Settle Time' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlErrorCode"))) { // ERROR CODE
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Error Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlErrorDesc"))) { // ERROR DESCRIPTION
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Error Description' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlDSCCode"))) { // DSC CODE
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='DSC Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlCTCode"))) { // CT CODE
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='CT Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#txtRemark"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='[AS Result Detail] Remark' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
      } else if ($("#ddlStatus").val() == 19) { // RECALL
        if (FormUtil.checkReqValue($("#ddlFailReason"))) { // FAIL REASON
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Fail Reason' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
        if (FormUtil.checkReqValue($("#appDate"))) { // APPOINTMENT DATE
          text = "<spring:message code='service.title.AppointmentDate'/>";
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
        if (FormUtil.checkReqValue($("#branchDSC"))) { // DSC CODE
          text = "<spring:message code='service.title.DSCBranch'/>";
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
        if (FormUtil.checkReqValue($("#CTCode"))) { // ASSIGN CT CODE
          text = "<spring:message code='service.grid.AssignCT'/>";
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
        if (FormUtil.checkReqValue($("#callRem"))) { // CALL REMARK
          text = "<spring:message code='service.title.Remark'/>";
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
      } else { // CANCEL
        if (FormUtil.checkReqValue($("#ddlFailReason"))) { // FAIL REASON
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Fail Reason' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#txtRemark"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='[AS Result Detail] Remark' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
      }
    }

    if (rtnValue == false) {
      Common.alert(rtnMsg);
    }

    return rtnValue;
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden'
          || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = -1;
      }
    });
  };

  function fn_doClear() {
    $("#ddlStatus").val("");
    $("#dpSettleDate").val("");
    $("#ddlFailReason").val("");
    $("#ddlStatus").val("");
    $("#tpSettleTime").val("");
    $("#ddlDSCCode").val("");
    $("#ddlErrorCode").val("");
    $("#ddlErrorDesc").val("");
    $("#ddlCTCode").val("");
    $("#ddlWarehouse").val("");
    $("#txtRemark").val("");
    $("#iscommission").val("");

    $("#def_type").val("");
    $("#def_code").val("");
    $("#def_def").val("");
    $("#def_part").val("");
    $("#solut_code").val("");

    $("#def_type_id").val("");
    $("#def_code_id").val("");
    $("#def_def_id").val("");
    $("#def_part_id").val("");
    $("#solut_code_id").val("");
    $("#ddlWarehouse").val("");

    $("#ddlFilterCode").val("");
    $("#ddlFilterQty").val("");
    $("#ddlFilterPayType").val("");
    $("#ddlFilterExchangeCode").val("");
    $("#txtFilterRemark").val("");

    AUIGrid.clearGridData(myFltGrd10);
  }

  function fn_chSeriaNo() {
    if ($("#productGroup option:selected").val() == "") {
      Common.alert("Please select the productGroup.<br/>");
      return;
    }

    if ($("#productCode option:selected").val() == "") {
      Common.alert("Please select the productCode.<br/>");
      return;
    }

    Common.ajax("GET", "/services/as/inHouseIsAbStck.do", {
      PARTS_SERIAL_NO : $("#serialNo").val(),
      CT_CODE : $("#ddlCTCode").val()
    }, function(result) {
      // var is =false;
      var is = true;

      if (result != null) {
        //var is =true;
        if (result.isStk != "0") {
          is = true;
        }
      }
      if (is == false)
        $("#btnSaveDiv").attr("style", "display:none");
    });
  }

  function fn_productGroup_SelectedIndexChanged() {
    var STK_CTGRY_ID = $("#productGroup").val();

    if (STK_CTGRY_ID != null) {
      $("#serialNo").val("");
      $("#productCode option").remove();

      doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + STK_CTGRY_ID, '', '', 'productCode', 'S', '');
    }
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
      //$("#productGroup").val("");
      //$("#productCode").val("");
      //$("#serialNo").val("");
    }
  }

  function fn_chkDateRange(obj) {
    var lmtDy = $("#lmtDt").val();
    var today = new Date();
    var newDate = new Date();

    if (lmtDy != "" || lmtDy != null) {
      newDate.setDate(today.getDate() + parseInt(lmtDy));

      var dd = newDate.getDate();
      var mm = newDate.getMonth() + 1;
      var y = newDate.getFullYear();

      var someFormattedDate1 = y + '-' + mm + '-'+ dd;

      dd = today.getDate();
      mm = today.getMonth() + 1;
      y = today.getFullYear();

      var tdyDt = y + '-' + mm + '-'+ dd;

      var a = obj.value.split("/");
      var someFormattedDate2 = a[2] + '-' + a[1] + '-'+ a[0];

      var cprDt1 = new Date(someFormattedDate1);
      var cprDt2 = new Date(someFormattedDate2);
      var cprDt3 = new Date(tdyDt);

      if (cprDt3 > cprDt2) {
        Common.alert("Promise Date must greater or equal to today's date");
        obj.value = "";
        return;
      }

      if(cprDt2 > cprDt1) {
        Common.alert("Promise Date must with in " + lmtDy + " day(s)");
        obj.value = "";
        return;
      }
    }
  }

  function fn_valDtFmt(val) {
    var dateRegex = /^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-.\/])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
    return dateRegex.test(val);
  }

  function fn_chkDt(obj) {
    var vdte = $(obj).val();

    var fmt = fn_valDtFmt(vdte);
    if (!fmt) {
      Common.alert("* Settle Date invalid date format.");
      $(obj).val("");
      return;
    }

    var sDate = (vdte).split("/");
    var tDate = new Date();
    var tMth = tDate.getMonth() + 1;
    var tYear = tDate.getFullYear();
    var sMth = parseInt(sDate[1]);
    var sYear = parseInt(sDate[2]);

    if (tYear > sYear) {
      Common.alert("* Settle Date must be in current month and year");
      $(obj).val("");
      return;
    } else {
      if (tMth > sMth) {
        Common.alert("* Settle Date must be in current month and year");
        $(obj).val("");
        return;
      }
    }
  }

  function fn_doAllaction(obj) {
    var ord_id = '${orderDetail.basicInfo.ordId}';

    var vdte = $(obj).val();
    var text = "";

    if ($(obj).attr('id') == "requestDate") {
      text = "<spring:message code='service.title.RequestDate' />";
    } else {
      text = "<spring:message code='service.grid.AppntDt' />";
    }

    var fmt = fn_valDtFmt(vdte);
    if (!fmt) {
      Common.alert("* " + text + " <spring:message code='service.msg.invalidDate' />");
      $(obj).val("");
      return;
    }

    /* var sDate = (vdte).split("/");
    var tDate = new Date();
    var tMth = tDate.getMonth() + 1;
    var tYear = tDate.getFullYear();
    var sMth = parseInt(sDate[1]);
    var sYear = parseInt(sDate[2]);

    if (tYear > sYear) {
      Common.alert("* " + text + " <spring:message code='service.msg.inCrnYrMth' />");
      $(obj).val("");
      return;
    } else {
      if (tMth > sMth) {
        Common.alert("* " + text + " <spring:message code='service.msg.inCrnYrMth' />");
        $(obj).val("");
        return;
      }
    }*/

    var crtDt = new Date();
    var apptDt = vdte;
    var date = apptDt.substring(0, 2);
    var month = apptDt.substring(3, 5);
    var year = apptDt.substring(6, 10);

    var dd = String(crtDt.getDate()).padStart(2, '0');
    var mm = String(crtDt.getMonth() + 1).padStart(2, '0');
    var yyyy = crtDt.getFullYear();

    var strdate = yyyy + mm + dd;
    var enddate = year + month + date;

    if (enddate < strdate) {
      Common.alert(text + " must be greater or equal to Current Date ");
      $(obj).val("");
      return;
    }

    var options = {
      ORD_ID : ord_id,
      S_DATE : vdte,
      CTCodeObj : 'CTCodeObj',
      CTIDObj : 'CTIDObj',
      CTgroupObj : 'CTgroupObj'
    }

    Common.popupDiv("/organization/allocation/allocation.do", {
      ORD_ID : ord_id,
      S_DATE : vdte,
      OPTIONS : options,
      TYPE : 'AS'
    }, null, true, '_doAllactionDiv');
  }

  function fn_secChk(obj){
    if (obj.id == "recall_dt") {
      if ($("#ddlStatus").val() != '19') {
        Common.alert("This section only applicable for <b>Recall</b> status");
        return;
      }
    }
    if (obj.id == "defEvt_dt" || obj.id == "chrFee_dt") {
      if ($("#ddlStatus").val() != '4') {
        Common.alert("This section only applicable for <b>Complete</b> status");
        return;
      }
    }
    if (obj.id == "defEvt_dt" || obj.id == "chrFee_dt") {
      if ($("#ddlStatus").val() != '4') {
        Common.alert("This section only applicable for <b>Complete</b> status");
        return;
      }
    }
    /*if (obj.id == "inHouse_dt" || obj.id == "inHouse_dt") {
      if ($("#ddlStatus").val() != '4') {
        Common.alert("This section only applicable for <b>Complete</b> status");
        return;
      }
    }*/
  }

  function fn_setMand(obj) {
    if (obj.value != "") {
      $("#fcm3").show();
      $("#fcm4").show();
      $("#fcm5").show();

      $("#ddlFilterQty").val("");
      $("#ddlFilterPayType").val("");
      $("#ddlFilterExchangeCode").val("");
      $("#ddSrvFilterLastSerial").val("");
    } else {
      $("#fcm3").hide();
      $("#fcm4").hide();
      $("#fcm5").hide();

      $("#ddlFilterQty").val("");
      $("#ddlFilterPayType").val("");
      $("#ddlFilterExchangeCode").val("");
      $("#ddSrvFilterLastSerial").val("");
    }
  }

  function fn_chkDt2() {
    var crtDt = new Date();
    var apptDt = $("#appDate").val();
    var date = apptDt.substring(0, 2);
    var month = apptDt.substring(3, 5);
    var year = apptDt.substring(6, 10);

    var dd = String(crtDt.getDate()).padStart(2, '0');
    var mm = String(crtDt.getMonth() + 1).padStart(2, '0');
    var yyyy = crtDt.getFullYear();

    var strdate = yyyy + mm + dd;
    var enddate = year + month + date;

    if (enddate < strdate) {
      alert("Appointment Date must be greater or equal to Current Date ");
      $("#appDate").val("");
      $("#CTSSessionCode").val("");
      $("#branchDSC").val("");
      $("#CTCode").val("");
      $("#CTGroup").val("");
      $("#callRem").val("");
      return;
    } else {
      fn_doAllaction('#appDate');
    }
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <section id="content">
  <!-- content start -->
  <form id="resultASForm" method="post">
   <div style="display: none">
    <input type="text" name="ORD_ID" id="ORD_ID" value="${ORD_ID}" />
    <input type="text" name="ORD_NO" id="ORD_NO" value="${ORD_NO}" />
    <input type="text" name="AS_NO" id="AS_NO" value="${AS_NO}" />
    <input type="text" name="AS_ID" id="AS_ID" value="${AS_ID}" />
    <input type="text" name="REF_REQST" id="REF_REQST" value="${REF_REQST}" />
    <input type="text" name="RCD_TMS" id="RCD_TMS" value="${RCD_TMS}" />
    <input type="text" name="AS_RESULT_NO" id="RCD_TMS" value="${AS_RESULT_NO}" />
    <input type="text" name="IN_HOUSE_CLOSE" id="IN_HOUSE_CLOSE" />
   </div>
  </form>
  <header class="pop_header">
   <!-- pop_header start -->
   <h1><spring:message code='service.btn.addtAs'/></h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#"><spring:message code='sys.btn.close' /></a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <form id="resultASAllForm" method="post">
   <section class="pop_body">
    <!-- pop_body start -->
    <section class="tap_wrap">
     <!-- tap_wrap start -->
     <ul class="tap_type1">
      <li><a href="#" class="on"><spring:message code='service.title.General' /></a></li>
      <li><a href="#"><spring:message code='service.title.OrderInformation' /></a></li>
      <li><a href="#" onclick=" javascirpt:AUIGrid.resize(regGridID, 950,300); "><spring:message code='service.title.asPassEvt' /></a></li>
     </ul>
     <article class="tap_area">
      <!-- tap_area start -->
      <table class="type1">
       <!-- table start -->
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
         <th scope="row"><spring:message code='service.grid.ASNo' /></th>
         <td><span id="txtASNo"></span></td>
         <th scope="row"><spring:message code='service.grid.SalesOrder' /></th>
         <td><span id="txtOrderNo"></span></td>
         <th scope="row"><spring:message code='service.title.ApplicationType' /></th>
         <td><span id="txtAppType"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.asStatus' /></th>
         <td><span id='txtASStatus'></span></td>
         <th scope="row">Malfunction Code</th>
         <td><span id='txtMalfunctionCode'></span></td>
         <th scope="row">Malfunction Reason</th>
         <td><span id='txtMalfunctionReason'></span></td>
        </tr>
        <tr>
         <th scope="row"></th>
         <td><span id='txtProdCde'></span></td>
         <th scope="row"><spring:message code='service.grid.ReqstDt' /></th>
         <td><span id='txtRequestDate'></span></td>
         <th scope="row"><spring:message code='service.title.ReqstTm' /></th>
         <td><span id='txtRequestTime'></span></td>
        </tr>
        <tr>
         <th scope="row"></th>
         <td><span></span></td>
         <th scope="row"><spring:message code='service.title.AppointmentDate' /></th>
         <td><span id='txtAppDt'></span></td>
         <th scope="row"><spring:message code='service.title.AppointmentTm' /></th>
         <td><span id='txtAppTm'></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.DSCCode' /></th>
         <td><span id='txtDSCCode'></span></td>
         <th scope="row"><spring:message code='service.title.InchargeCT' /></th>
         <td colspan="3"><span id='txtInchargeCT'></span></td>
        </tr>

        <tr>
         <th scope="row"><spring:message code='service.title.CustomerName' /></th>
         <td colspan="3"><span id="txtCustName"></span></td>
         <th scope="row"><spring:message code='service.title.NRIC_CompanyNo' /></th>
         <td><span id="txtCustIC"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.ContactNo' /></th>
         <td colspan="5"><span id="txtContactPerson"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='sal.text.telM' /></th>
         <td><span id="txtTelMobile"></span></td>
         <th scope="row"><spring:message code='sal.text.telR' /></th>
         <td><span id="txtTelResidence"></span></td>
         <th scope="row"><spring:message code='sal.text.telO' /></th>
         <td><span id="txtTelOffice"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.InstallationAddress' /></th>
         <td colspan="5"><span id="txtInstallAddress"></span></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.Rqst' /></th>
         <td colspan="3"><span id="txtRequestor"></span></td>
         <th scope="row"><spring:message code='service.grid.CrtBy' /></th>
         <td></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.RqstCtc' /></th>
         <td colspan="3"><span id="txtRequestorContact"></span></td>
         <th scope="row"><spring:message code='sal.text.createDate' /></th>
         <td><span id="txtASKeyAt"></span></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
     </article>
     <!-- tap_area end -->
     <article class="tap_area">
       <!------------------------------------------------------------------------------
          Order Detail Page Include START
         ------------------------------------------------------------------------------->
         <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
       <!------------------------------------------------------------------------------
          Order Detail Page Include END
         ------------------------------------------------------------------------------->
     </article>

      <article class="grid_wrap">
       <!-- grid_wrap start -->
      </article>
      <!-- grid_wrap end -->
     </article>
     <!-- tap_area end -->
     <article class="tap_area">
      <!-- tap_area start -->
      <article class="grid_wrap">
       <!-- grid_wrap start -->
       <div id="reg_grid_wrap"
        style="width: 100%; height: 300px; margin: 0 auto;"></div>
      </article>
      <!-- grid_wrap end -->
     </article>
     <!-- tap_area end -->
    </section>
    <!-- tap_wrap end -->
    <aside class="title_line">
     <h3 class="red_text"><spring:message code='service.msg.msgFillIn' /></h3>
    </aside>
    <article class="acodi_wrap">
     <dl>
      <dt class="click_add_on on">
       <a href="#"><spring:message code='service.title.asRstDtl' /></a>
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
          <th scope="row"><spring:message code='service.grid.ResultNo' /></th>
          <td><span id='txtResultNo'></span></td>
          <th scope="row"><spring:message code='sys.title.status'/><span id='m1' name='m1' class="must">*</span>
          </th>
          <td>
            <select class="w100p" id="ddlStatus" name="ddlStatus" onChange="fn_ddlStatus_SelectedIndexChanged()">
              <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
              <c:forEach var="list" items="${asCrtStat}" varStatus="status">
                <c:choose>
                  <c:when test="${list.codeId=='1'}">
                    <!-- <option value="${list.codeId}">${list.codeName}</option>  -->
                  </c:when>
                  <c:otherwise>
                    <option value="${list.codeId}">${list.codeName}</option>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </select>
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.grid.SettleDate' /><span id='m2' name='m2' class="must" style="display:none">*</span>
          </th>
          <td>
            <input type="text" title="Create start Date" id='dpSettleDate' name='dpSettleDate' placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" onChange="fn_chkDt('#dpSettleDate')"/>
          </td>
          <th scope="row"><spring:message code='service.grid.FailReason' /><span id='m3' name='m3' class="must" style="display:none">*</span></th>
          <td>
            <select id='ddlFailReason' name='ddlFailReason' disabled="disabled" class="w100p">
              <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
            </select>
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.grid.SettleTm' /><span id='m4' name='m4' class="must" style="display:none">*</span>
          </th>
          <td>
           <div class="time_picker">
            <input type="text" title="" placeholder="Settle Time" id='tpSettleTime' name='tpSettleTime' class="readonly time_date" disabled="disabled" />
            <ul>
             <li><spring:message code='service.text.timePick' /></li>
             <c:forEach var="list" items="${timePick}" varStatus="status">
              <li><a href="#">${list.codeName}</a></li>
             </c:forEach>
            </ul>
           </div>
           <!-- time_picker end -->
          </td>
          <th scope="row"><spring:message code='service.title.DSCCode' /><span id='m5' name='m5' class="must" style="display:none">*</span>
          </th>
          <td>
           <!-- <select  disabled="disabled" id='ddlDSCCode' name='ddlDSCCode' > -->
           <!-- <input type="hidden" title="" placeholder="" class="" id='ddlDSCCode' name='ddlDSCCode' value='${BRANCH_ID}'/>
                <input type="text" title=""    placeholder="" class="readonly"   id='ddlDSCCodeText' name='ddlDSCCodeText'  value='${BRANCH_NAME}''/> -->
           <input type="hidden" title="" placeholder="<spring:message code='service.title.DSCCode' />" class="" id='ddlDSCCode' name='ddlDSCCode' />
           <input type="text" title="" placeholder="" class="readonly" disabled="disabled" id='ddlDSCCodeText' name='ddlDSCCodeText' />
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.grid.ErrCde' /><span id='m6' name='m6' class="must" style="display:none">*</span>
          </th>
          <td>
            <select disabled="disabled" id='ddlErrorCode' name='ddlErrorCode' onChange="fn_errMst_SelectedIndexChanged()" class="w100p"></select>
          </td>
          <th scope="row"><spring:message code='service.grid.CTCode' /><span id='m7' name='m7' class="must" style="display:none">*</span>
          </th>
          <td>
            <input type="hidden" title="" placeholder="<spring:message code='service.grid.CTCode' />" class="" id='ddlCTCode' name='ddlCTCode' />
            <input type="text" title="" placeholder="" disabled="disabled" id='ddlCTCodeText' name='ddlCTCodeText' />
            <!-- <input type="hidden" title="" placeholder="" class=""  id='ddlCTCode' name='ddlCTCode' value='${USER_ID}'/>
                 <input type="text" title="" placeholder="" class="readonly" id='ddlCTCodeText' name='ddlCTCodeText'  value='${USER_NAME}'/>
             -->
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.grid.ErrDesc' /><span id='m8' name='m8' class="must" style="display:none">*</span>
          </th>
          <td>
            <select id='ddlErrorDesc' name='ddlErrorDesc' class="w100p"></select>
          </td>
          <th scope="row"><spring:message code='sal.title.warehouse' /></th>
          <td>
            <select disabled="disabled" id='ddlWarehouse' name='ddlWarehouse' class="w100p"></select>
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.title.Remark' /><span id='m14' name='m14' class="must" style="display:none">*</span></th>
          <td colspan="3">
            <textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />" id='txtRemark' name='txtRemark'></textarea>
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='sal.text.commission' /></th>
          <td colspan="3">
            <label><input type="checkbox" disabled="disabled" id='iscommission' name='iscommission' /><span><spring:message code='sal.text.commissionApplied' /></span></label></td>
         </tr>
        </tbody>
       </table>
      </dd>

      <dt class="click_add_on" id='recall_dt' onclick="fn_secChk(this);">
       <a href="#"><spring:message code='service.title.asCallLog' /></a>
      </dt>
      <dd id='recall_div' style="display: none">
       <table class="type1">
        <caption>table</caption>
        <colgroup>
         <col style="width: 140px" />
         <col style="width: *" />
         <col style="width: 140px" />
         <col style="width: *" />
        </colgroup>
        <tbody>
         <tr>
           <th scope="row"><spring:message code='service.title.AppointmentDate' /><span class="must">*</span></th>
           <td>
            <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " readonly="readonly" id="appDate" name="appDate" onChange="fn_chkDt2();"/>
           </td>
           <th scope="row"><spring:message code='service.title.AppointmentSessione' /><span class="must">*</span></th>
           <td>
             <input type="text" title="" placeholder="<spring:message code='service.title.AppointmentDate' />" id="CTSSessionCode" name="CTSSessionCode" class="readonly w100p" readonly="readonly" />
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.title.DSCBranch' /><span class="must">*</span></th>
           <td>
             <select class="w100p" id="branchDSC" name="branchDSC" class="" disabled="disabled"></select>
           </td>
           <th scope="row"><spring:message code='service.grid.AssignCT' /><span class="must">*</span></th>
           <td>
             <input type="text" title="" placeholder="<spring:message code='service.grid.AssignCT' />" id="CTCode" name="CTCode" class="readonly" readonly="readonly" onchange="fn_changeCTCode(this)" />
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.title.CTGroup' /></th>
           <td colspan="3">
             <input type="text" title="<spring:message code='service.title.CTGroup' />" placeholder="<spring:message code='service.title.CTGroup' />" class="w100p" id="CTGroup" name="CTGroup" />
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.Remark' /><span class="must">*</span></th>
           <td colspan="3">
             <textarea id='callRem' name='callRem' rows='5' placeholder="<spring:message code='service.title.Remark' />" class="w100p"></textarea>
           </td>
         </tr>

        </tbody>
       </table>
       <!-- table end -->
      </dd>

      <dt class="click_add_on" id='defEvt_dt' onclick="fn_secChk(this);">
       <a href="#"><spring:message code='service.title.asDefEnt' /></a>
      </dt>
      <dd id='defEvt_div' style="display: none">
       <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
         <col style="width: 140px" />
         <col style="width: *" />
        </colgroup>
        <tbody>
         <tr>
          <th scope="row"><spring:message code='service.text.defTyp' /><span id='m9' name='m9' class="must" style="display:none">*</span></th>
          <td><input type="text" title="" id='def_type' name='def_type' placeholder="e.g. DT3" class="" onblur="fn_getASReasonCode2(this, 'def_type' ,'387')" onkeyup="this.value = this.value.toUpperCase();" />
          <input type="hidden" title="" id='def_type_id' name='def_type_id' placeholder="" class="" />
          <input type="text" title="" placeholder="" id='def_type_text' name='def_type_text' class="" disabled style="width:60%;"/></td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.text.defCde' /><span id='m10' name='m10' class="must" style="display:none">*</span></th>
          <td><input type="text" title="" placeholder="e.g. FF" disabled="disabled" id='def_code' name='def_code' class="" onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();"/>
          <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" />
          <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width:60%;"/></td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.text.defPrt' /><span id='m11' name='m11' class="must" style="display:none">*</span></th>
          <td><input type="text" title="" placeholder="e.g. FE12" disabled="disabled" id='def_part' name='def_part' class="" onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();"/>
          <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" />
          <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' class="" disabled style="width:60%;"/></td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.text.dtlDef' /><span id='m12' name='m12' class="must" style="display:none">*</span></th>
          <td><input type="text" title="" placeholder="e.g. 18" disabled="disabled" id='def_def' name='def_def' class="" onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();"/>
          <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" />
          <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' class="" disabled style="width:60%;"/>
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.text.sltCde' /><span id='m13' name='m13' class="must" style="display:none">*</span></th>
          <td><input type="text" title="" placeholder="e.g. A9" class="" disabled="disabled" id='solut_code' name='solut_code' onblur="fn_getASReasonCode2(this, 'solut_code'  ,'337')" onkeyup="this.value = this.value.toUpperCase();"/>
          <input type="hidden" title="" placeholder="" class="" id='solut_code_id' name='solut_code_id' />
          <input type="text" title="" placeholder="" class="" id='solut_code_text' name='solut_code_text' disabled style="width:60%;"/></td>
         </tr>
        </tbody>
       </table>
      </dd>

      <dt class="click_add_on" id='chrFee_dt' onclick="fn_secChk(this);">
       <a href="#"><spring:message code='service.title.asPrtChr' /></a>
      </dt>
      <dd id='chrFee_div' style="display: none">
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
          <th scope="row"><spring:message code='service.text.asLbrChr' /></th>
          <td>
            <label><input type="checkbox" id='txtLabourch' name='txtLabourch' onChange="fn_LabourCharge_CheckedChanged(this)" /></label>
          </td>
          <th scope="row"><spring:message code='service.text.asLbrChr' /></th>
          <td><input type="text" id='txtLabourCharge' name='txtLabourCharge' value='0.00' disabled/></td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.text.asLbrChr' /> (RM) <span id="fcm1" name="fcm1" class="must" style="display:none">*</span></th>
          <td>
            <select id='cmbLabourChargeAmt' name='cmbLabourChargeAmt' onChange="fn_cmbLabourChargeAmt_SelectedIndexChanged()" disabled>
              <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
              <c:forEach var="list" items="${lbrFeeChr}" varStatus="status">
                <option value="${list.codeId}">${list.codeName}</option>
              </c:forEach>
            </select>
          </td>
          <th scope="row"><spring:message code='service.text.asfltChr' /> </th>
          <td>
            <input type="text" id='txtFilterCharge' name='txtFilterCharge' value='0.00' disabled/></td>
         </tr>
         <tr>
          <th scope="row"></th>
          <td></td>
          <th scope="row"><b><spring:message code='service.text.asTtlChr' /></b></th>
          <td>
            <input type="text" id='txtTotalCharge' name='txtTotalCharge' value='0.00' disabled/>
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.grid.FilterCode' /><span id="fcm2" name="fcm2" class="must" style="display:none">*</span></th>
          <td>
            <select id='ddlFilterCode' name='ddlFilterCode' onchange="fn_setMand(this)"></select>
          </td>
          <th scope="row"><spring:message code='service.grid.Quantity' /><span id="fcm3" name="fcm3" class="must" style="display:none">*</span></th>
          <td><select id='ddlFilterQty' name='ddlFilterQty'>
            <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
            <c:forEach var="list" items="${fltQty}" varStatus="status">
              <option value="${list.codeId}">${list.codeName}</option>
            </c:forEach>
          </select></td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.text.asPmtTyp' /><span id="fcm4" name="fcm4" class="must" style="display:none">*</span></th>
          <td><select id='ddlFilterPayType' name='ddlFilterPayType'>
            <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
            <c:forEach var="list" items="${fltPmtTyp}" varStatus="status">
              <option value="${list.codeId}">${list.codeName}</option>
            </c:forEach>
          </select></td>
          <th scope="row"><spring:message code='service.text.asExcRsn' /><span id="fcm5" name="fcm5" class="must" style="display:none">*</span></th>
          <td><select id='ddlFilterExchangeCode' name='ddlFilterExchangeCode'>
              </select>
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.title.SerialNo' /></th>
          <td colspan="3">
            <input type="text" id='ddSrvFilterLastSerial' name='ddSrvFilterLastSerial' />
          </td>
         </tr>
         <tr>
          <th scope="row"><spring:message code='service.title.Remark' /></th>
          <td colspan="3"><textarea cols="20" rows="5"
            placeholder="<spring:message code='service.title.Remark' />" id='txtFilterRemark' name='txtFilterRemark'></textarea>
          </td>
         </tr>
         <tr>
          <td colspan="4">
           <span style="color:red;font-style: italic;"><spring:message code='service.msg.msgFltTtlAmt' /></span>
          </td>
         </tr>
        </tbody>
       </table>
       <!-- table end -->
       <ul class="center_btns">
        <li><p class="btn_blue2">
          <a href="#" onclick="fn_filterAdd()"><spring:message code='sys.btn.add' /></a>
         </p></li>
        <li><p class="btn_blue2">
          <a href="#" onclick="fn_filterClear()"><spring:message code='sys.btn.clear' /></a>
         </p></li>
       </ul>
       <article class="grid_wrap">
        <!-- grid_wrap start -->
        <div id="asfilter_grid_wrap"
         style="width: 100%; height: 250px; margin: 0 auto;"></div>
       </article>
       <!-- grid_wrap end -->
      </dd>

      <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
      <dt class="click_add_on" id='inHouse_dt' onclick="fn_secChk(this);">
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
            name='replacement' value='1' onclick="fn_replacement(1)"/>Y <input type="radio"
            id='replacement' name='replacement' value='0' onclick="fn_replacement(0)"/> N
          </label></td>
          <th scope="row">Promise Date <span class="must">*</span></th>
          <td><input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="promisedDate"
           name="promisedDate" onchange="fn_chkDateRange(this)"/>
           <input type="hidden" id="lmtDt" name="lmtDt" value="${inHseLmtDy}" disabled /></td>
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
           name='serialNo' onChange="fn_chSeriaNo()" placeholder='Serial Number'/></td>
         </tr>
         <tr>
          <th scope="row">Remark</th>
          <td colspan="3"><textarea cols="20" rows="5"
            placeholder="Remark" id='inHouseRemark' name='inHouseRemark'></textarea>
          </td>
         </tr>
        </tbody>
       </table>
       <!-- table end -->
      </dd>

     </dl>
    </article>

    <ul class="center_btns mt20" id='btnSaveDiv'>
     <li><p class="btn_blue2 big">
       <a href="#" onclick="fn_doSave()"><spring:message code='sys.btn.save' /></a>
      </p>
     </li>
     <li>
       <p class="btn_blue2 big">
         <a href="#" onclick="javascript:$('#resultASAllForm').clearForm();"><spring:message code='sys.btn.clear' /></a>
      </p>
     </li>
    </ul>

   </section>
  </form>
 </section>
</div>
<script type="text/javaScript">

</script>