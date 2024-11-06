<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.1          RE-STRUCTURE JSP AND ADD CHECKING FOR SETTLE DATE
 06/05/2019  ONGHC  1.0.2          Check Settle Date Only When Status Complete
 26/04/2019  ONGHC  1.0.3          ADD RECALL STATUS
 05/09/2019  ONGHC  1.0.4          REMOVE IN-HOUSE REPAIR SECTION
 17/09/2019  ONGHC  1.0.5          AMEND DEFECT DETAIL SECTION
 21/10/2019  ONGHC  1.0.6          ADD CHECKING FOR AS PAYMENT MAPPING
 19/11/2019  ONGHC  1.0.7          AMEND FOR ORDER MANAGEMENT VIEW ISSUE
 14/02/2020  ONGHC  1.0.8          AMEND FOR PSI
 26/02/2020  ONGHC  1.0.9          AMEND FOR LPM
 28/02/2020  ONGHC  1.0.10        AMEND fn_loadDftCde
 04/06/2020  ONGHC  1.0.11        AMEND fn_loadDftCde
 30/09/2020 FARUQ   1.0.12         Default value for DP,DD,DC,DT,SC when certain err description
 -->
<!-- AS ORDER > AS MANAGEMENT > EDIT / VIEW AS ENTRY PLUG IN -->
<script type="text/javascript">
  var myFltGrd10;

  var failRsn;
  var errCde;
  var asMalfuncResnId;
  var currentStatus;
  var asRslt;
  var ops;
  var matchMatDefCode = [];
  var removeList = [];
  var installAccTypeId = 582;
  var installAccValues = JSON.parse("${installAccValues}");
  var isSet = 0;

  $(document).ready(function() {
    createCFilterAUIGrid();

    doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
    doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '', 'ddlFilterExchangeCode', 'S', ''); // FILTER CHARGE EXCHANGE CODE
    doGetCombo('/services/as/getBrnchId', '', '', 'branchDSC', 'S', ''); // RECALL ENTRY DSC CODE
    doGetCombo('/services/as/inHouseGetProductMasters.do', '', '', 'productGroup', 'S', ''); // IN HOUSE PRODUCT GROUP

    AUIGrid.bind(myFltGrd10, "addRow", auiAddRowHandler);
    AUIGrid.bind(myFltGrd10, "removeRow", auiRemoveRowHandler);

    var isF = true;
    AUIGrid.bind(myFltGrd10, "rowStateCellClick", function(event) {
      if (event.marker == "added") {
        /*if (event.item.filterType == "CHG") {
          var fChage = Number($("#txtFilterCharge").val());
          var totchrge = Number($("#txtTotalCharge").val());

          $("#txtFilterCharge").val(fChage - Number(event.item.filterTotal));
          $("#txtTotalCharge").val(totchrge - Number(event.item.filterTotal));
        }*/
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
    setTimeout(function() {
      fn_errDescCheck(0)
    }, 1000);
  });

  function trim(text) {
    return String(text).replace(/^\s+|\s+$/g, '');
  }

  function createCFilterAUIGrid() {
    var clayout = [
        {
          dataField : "filterType",
          headerText : "<spring:message code='service.grid.ASNo'/>",
          editable : false
        }, {
          dataField : "filterDesc",
          headerText : "<spring:message code='service.grid.ASFltDesc'/>",
          width : 200
        }, {
          dataField : "filterExCode",
          headerText : "<spring:message code='service.grid.ASFltCde'/>",
          width : 80
        }, {
          dataField : "filterQty",
          headerText : "<spring:message code='service.grid.Quantity'/>",
          width : 80
        }, {
          dataField : "filterPrice",
          headerText : "<spring:message code='service.title.Price'/>",
          width : 80,
          dataType : "number",
          formatString : "#,000.00",
          editable : false
        }, {
          dataField : "filterTotal",
          headerText : "<spring:message code='sal.title.total'/>",
          width : 80,
          dataType : "number",
          formatString : "#,000.00",
          editable : false
        }, {
          dataField : "filterRemark",
          headerText : "<spring:message code='service.title.Remark'/>",
          width : 200,
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
        }, {
            dataField : "filterCode",
            headerText : "Filter Code",
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
     //Added by keyi - restructure AS result 202208
     matchMatDefCode.push(event.items[0].filterId);
  }

  function auiRemoveRowHandler(event) {
    const filters = AUIGrid.getOrgGridData(myFltGrd10)
    const fTotal = filters.reduce((t, f) => f.filterType == "CHG" ? Number(f.filterTotal) + t : t, 0)
    const cFilter = event.items[0]
    $("#txtFilterCharge").val((fTotal - (cFilter.filterType == "CHG" ? cFilter.filterTotal : 0)).toFixed(2));
    fn_calculateTotalCharges()
    /*if (event.items[0].filterType == "CHG") {
      var fChage = Number($("#txtFilterCharge").val());
      var totchrge = Number($("#txtTotalCharge").val());

      if (fChage.toFixed(2) != "0.00") {
        fChage = (fChage - Number(event.items[0].filterTotal)).toFixed(2);
        totchrge = (totchrge - Number(event.items[0].filterTotal)).toFixed(2);

        $("#txtFilterCharge").val(fChage);
        $("#txtTotalCharge").val(totchrge);
      }
    }*/
    //Added by keyi - restructure AS result 202208
    console.log("removeRow");
    debugger;
    var index = matchMatDefCode.indexOf(event.items[0].filterId);
    if (index >= 0) {
        console.log("index: " + index);
    	matchMatDefCode.splice(index,1);
    }

    removeList.push(event.items[0]);
    console.log("removeList" + JSON.stringify(removeList));
  }

  // RE-INSERT BACK VALUE
  function fn_setErrCde() {
    $("#ddlErrorCode").val(errCde);
    fn_errMst_SelectedIndexChanged(0);
  }

  function fn_callback_ddlErrorDesc() {
    $("#ddlErrorDesc").val(asMalfuncResnId);
  }

  function fn_callback_ddlFailRsn() {
    $("#ddlFailReason").val(failRsn);
  }

  function fn_setCTcodeValue() {
    $("#ddlCTCode").val($("#CTID").val());
  }

  // RELOAD DATA
  function fn_getErrMstList(_ordNo) {
    $("#ddlErrorCode option").remove();
    doGetCombo('/services/as/getErrMstList.do?SALES_ORD_NO=' + _ordNo, '', errCde, 'ddlErrorCode', 'S', 'fn_setErrCde');
  }

  function fn_errMst_SelectedIndexChanged(ind) {

    var indicator = ind;

    if (indicator == 0) {
      $("#ddlErrorDesc option").remove();
      if ($("#ddlErrorCode").val() != "" || $("#ddlErrorCode").val() != null) {
        errCde = $("#ddlErrorCode").val();
      } else {
        if (errCde == "" || errCde == null) {
          errCde = $("#ddlErrorCode").val();
        }
      }
      doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE=' + errCde, '', '', 'ddlErrorDesc', 'S', 'fn_callback_ddlErrorDesc');
      setTimeout(function() {
        fn_errDescCheck(0)
      }, 1000);
    } else {
      $("#ddlErrorDesc option").remove();
      doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE=' + $("#ddlErrorCode").val(), '', '', 'ddlErrorDesc', 'S', '');

    }
  }

  function fn_errDescCheck(ind) {
    //(_method, _url, _jsonObj, _callback, _errcallback, _options, _header)
    var indicator = ind;
    var jsonObj = {
      errCd : $("#ddlErrorCode").val(),
      errDesc : $("#ddlErrorDesc").val()
    };
    Common.ajax("GET", "/services/as/getAsDefectEntry.do", jsonObj, function(result) {
      if (result) {
        if (result.length > 0) {
          fn_asDefectEntryHideSearch(result);
        } else {
          fn_asDefectEntryNormal(indicator);
        }
      }
    });
  }

  function fn_asDefectEntryHideSearch(result) {
    //DP DEFETC PART
    $("#def_part").val(result[0].defectCode);
    $("#def_part_id").val(result[0].defectId);
    $("#def_part_text").val(result[0].defectDesc);
    $("#DP").hide();
    //DD AS PROBLEM SYMPTOM LARGE
    $("#def_def").val(result[1].defectCode);
    $("#def_def_id").val(result[1].defectId);
    $("#def_def_text").val(result[1].defectDesc);
    $("#DD").hide();
    //DC AS PROBLEM SYMPTOM SMALL
    $("#def_code").val(result[2].defectCode);
    $("#def_code_id").val(result[2].defectId);
    $("#def_code_text").val(result[2].defectDesc);
    $("#DC").hide();
    //DT AS SOLUTION LARGE
    $("#def_type").val(result[3].defectCode);
    $("#def_type_id").val(result[3].defectId);
    $("#def_type_text").val(result[3].defectDesc);
    $("#DT").hide();
    //SC AS SOLUTION SMALL
    $("#solut_code").val(result[4].defectCode);
    $("#solut_code_id").val(result[4].defectId);
    $("#solut_code_text").val(result[4].defectDesc);
    $("#SC").hide();
  }

  function fn_asDefectEntryNormal(indicator) {

    if (indicator == 1) {
      //DP DEFETC PART
      $("#def_part").val("");
      $("#def_part_id").val("");
      $("#def_part_text").val("");
      $("#DP").show();
      //DD AS PROBLEM SYMPTOM LARGE
      $("#def_def").val("");
      $("#def_def_id").val("");
      $("#def_def_text").val("");
      $("#DD").show();
      //DC AS PROBLEM SYMPTOM SMALL
      $("#def_code").val("");
      $("#def_code_id").val("");
      $("#def_code_text").val("");
      $("#DC").show();
      //DT AS SOLUTION LARGE
      $("#def_type").val("");
      $("#def_type_id").val("");
      $("#def_type_text").val("");
      $("#DT").show();
      //SC AS SOLUTION SMALL
      $("#solut_code").val("");
      $("#solut_code_id").val("");
      $("#solut_code_text").val("");
      $("#SC").show();
    } else {
    }
  }
  // GET FILTER INFO.
  function fn_getASRulstEditFilterInfo() {
    Common.ajax("GET", "/services/as/getASRulstEditFilterInfo", {
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val()
    }, function(result) {
      AUIGrid.setGridData(myFltGrd10, result);
      const filters = AUIGrid.getOrgGridData(myFltGrd10)
      const fTotal = filters.reduce((t, f) => f.filterType == "CHG" ? Number(f.filterTotal) + t : t, 0)
      $("#txtFilterCharge").val(fTotal.toFixed(2));
    });
  }

  // GET AS RESULT INFO
  function fn_getASRulstSVC0004DInfo() {
    Common.ajax("GET", "/services/as/getASRulstSVC0004DInfo", {
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val()
    }, function(result) {
      if (result != "") {
        // SUCCESS
        fn_setSVC0004dInfo(result);
        const filters = AUIGrid.getOrgGridData(myFltGrd10)
        const fTotal = filters.reduce((t, f) => f.filterType == "CHG" ? Number(f.filterTotal) + t : t, 0)
        $("#txtFilterCharge").val(fTotal.toFixed(2));
      }
    });
  }

  function fn_setSVC0004dInfo(result) {
    currentStatus = result[0].asResultStusId; // SET BEFORE STATUS
    asRslt = result[0]; // SET 1ST IMAGE VALUE SET FOR LATER USE

    $("#reworkProj").val(result[0].reworkProjName);
    $("#ddlStatus").val(result[0].asResultStusId);

    $("#creator").val(result[0].c28); // CREATOR
    $("#creatorat").val(result[0].asResultCrtDt); // CREATE ON
    $("#txtResultNo").val(result[0].asResultNo);// REUSLT NO

    $("#dpSettleDate").val(result[0].asSetlDt); // SETTLE DATE
    $("#tpSettleTime").val(result[0].asSetlTm); // SETTLE TIME
    failRsn = result[0].c2; // FAIL REASON
    $("#ddlDSCCode").val(result[0].asBrnchId); // DCS BRANCH

    errCde = result[0].asMalfuncId; // ERROR CODE
    asMalfuncResnId = result[0].asMalfuncResnId; // ERROR DESCRIPTION

    // GET ERROR CODE LISTING
    fn_getErrMstList('${ORD_NO}');
    //fn_errMst_SelectedIndexChanged();

    //$("#ddlCTCodeText").val( result[0].c12);
    //$("#ddlCTCode").val( result[0].c11);

    /*
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    $("#ddlCTCode").val(selectedItems[0].item.asMemId);
    $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
    $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
    $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);
     */

    $("#psiRcd").val(result[0].psi);
    $("#lpmRcd").val(result[0].lpm);
    $("#waterSrcType").val(result[0].waterSrcType);
    $("#asNotMatch").val(result[0].asUnmatchReason);
    $("#ntuCom").val(result[0].ntu);

    $("#ddlCTCode").val(result[0].c11);
    $("#ddlDSCCode").val(result[0].asBrnchId);
    $("#ddlCTCodeText").val(result[0].c12);
    $("#ddlDSCCodeText").val(result[0].c5);
    isSet = 1;

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

    var toamt = "0.00";
    var tWork = "0.00";
    var tFilterAmt = "0.00";

    toamt = result[0].asTotAmt;
    tWork = result[0].asWorkmnsh;
    tFilterAmt = result[0].asFilterAmt;

    /*if (regexp.test(toamt)) {
      $('#txtTotalCharge').val(toamt);
    } else {
      $('#txtTotalCharge').val(toamt + ".00");
    }*/

    $('#txtTotalCharge').val(toamt.toFixed(2));

    /*if (regexp.test(tWork)) {
      $('#txtLabourCharge').val(tWork);
    } else {
      $('#txtLabourCharge').val(tWork + ".00");
    }*/

    $('#txtLabourCharge').val(tWork.toFixed(2));

    /*if (regexp.test(tFilterAmt)) {
      $('#txtFilterCharge').val(tFilterAmt);
    } else {
      $('#txtFilterCharge').val(tFilterAmt + ".00");
    }*/

    $('#txtFilterCharge').val(tFilterAmt.toFixed(2));

    // IN HOUSE REPAIR
    /* if (result[0].inHuseRepairReplaceYn == "1") {
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
    }*/

    if ($("#ddlStatus").val() == 4) {
      $("#ddlStatus").attr("disabled", "disabled");
    }

    fn_ddlStatus_SelectedIndexChanged();
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

        /*if ('337' == _v) {
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
        }*/
      } else {
        $("#" + _tobj + "_text").val("* No such detail of defect found.");
        /* $("#promisedDate").val("").attr("disabled", "disabled");
        $("#productGroup").val("").attr("disabled", "disabled");
        $("#productCode").val("").attr("disabled", "disabled");
        $("#serialNo").val("").attr("disabled", "disabled");
        $("#inHouseRemark").val("").attr("disabled", "disabled");
        $("#inHouseRepair_div").attr("style", "display:none");
        $("input:radio[name='replacement']").removeAttr('checked');
        fn_replacement(0); */
      }
    });
  }

  function fn_HasFilterUnclaim() {
    Common.ajax("GET", "/services/as/getTotalUnclaimItem", {
      asResultId : $('#asData_AS_RESULT_ID').val(),
      type : "AS"
    }, function(result) {
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
    // STATUS CHANGE FAIL REASON CODE CHANGED
    if ($("#ddlStatus").val() == 19) { // RECALL
      doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=5551', '', '', 'ddlFailReason', 'S', 'fn_callback_ddlFailRsn');
    } else if ($("#ddlStatus").val() == 10) { // CANCEL
      doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=5550', '', '', 'ddlFailReason', 'S', 'fn_callback_ddlFailRsn');
    } else {
      doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=0', '', '', 'ddlFailReason', 'S', 'fn_callback_ddlFailRsn');
      $("#ddlFailReason").attr("disabled", true);
    }

    if (typeof myGridID !== 'undefined' && isSet == 0) {
      var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
      $("#ddlCTCode").val(selectedItems[0].item.asMemId);
      $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
      $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
      $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);
    }

    switch ($("#ddlStatus").val()) {
    case "4":
      //COMPLETE
      fn_openField_Complete();
      $("#defEvt_div").attr("style", "display:block");
      $("#chrFee_div").attr("style", "display:block");
      $("#recall_div").attr("style", "display:none");

      $("#reminder").show();
      break;
    case "1":
      // ACTIVE
      fn_openField_Complete();
      $("#defEvt_div").attr("style", "display:block");
      $("#chrFee_div").attr("style", "display:block");
      $("#recall_div").attr("style", "display:none");

      $("#reminder").hide();
      break;
    case "10":
      //CANCEL
      fn_openField_Cancel();
      $("#recall_div").attr("style", "display:none");
      $("#defEvt_div").attr("style", "display:none");
      $("#chrFee_div").attr("style", "display:none");
      break;
    case "19":
      // RECALL
      fn_openField_Recall();
      fn_getRclData();
      $("#recall_div").attr("style", "display:block");
      $("#defEvt_div").attr("style", "display:none");
      $("#chrFee_div").attr("style", "display:none");
      break;
    case "21":
      //FAILED
      fn_openField_Fail();
      $("#recall_div").attr("style", "display:none");
      $("#defEvt_div").attr("style", "display:none");
      $("#chrFee_div").attr("style", "display:none");

      $("#reminder").hide();
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
      $("#m14").hide();
      $("#mInH3").hide();

      $("#reminder").hide();
      break;
    }
  }

  function fn_openField_Complete() {
    failRsn = "";

    // SET BACK DATA TO EACH FIELD
    $('#dpSettleDate').val(asRslt.asSetlDt);
    $('#tpSettleTime').val(asRslt.asSetlTm);

    //$("#ddlCTCode").val(asRslt.c11);
    //$("#ddlDSCCode").val(asRslt.asBrnchId);
    //$("#ddlCTCodeText").val(asRslt.c12);
    $//("#ddlDSCCodeText").val(asRslt.c5);

    $("#ddlWarehouse").val(asRslt.asWhId);
    $("#txtRemark").val(asRslt.asResultRem);

    if (asRslt.c27 == "1") {
      $("#iscommission").attr("checked", true);
    } else {
      $("#iscommission").attr("checked", false);
    }

    $("#psiRcd").val(asRslt.psi);
    $("#lpmRcd").val(asRslt.lpm);
    $("#ntuCom").val(asRslt.ntu);

    $('#def_type').val(this.trim(asRslt.c16));
    $('#def_type_text').val(this.trim(asRslt.c17));
    $('#def_type_id').val(this.trim(asRslt.asDefectTypeId));

    $('#def_code').val(this.trim(asRslt.c18));
    $('#def_code_text').val(this.trim(asRslt.c19));
    $('#def_code_id').val(this.trim(asRslt.asDefectId));

    $('#def_def').val(this.trim(asRslt.c22));
    $('#def_def_text').val(this.trim(asRslt.c23));
    $('#def_def_id').val(this.trim(asRslt.asDefectDtlResnId));

    $('#def_part').val(this.trim(asRslt.c20));
    $('#def_part_text').val(this.trim(asRslt.c21));
    $('#def_part_id').val(this.trim(asRslt.asDefectPartId));

    $('#solut_code').val(this.trim(asRslt.c25));
    $('#solut_code_text').val(this.trim(asRslt.c26));
    $('#solut_code_id').val(this.trim(asRslt.c24));

    if (asRslt.asWorkmnsh > 0) {
      $("#txtLabourch").prop("checked", true);
      $('#cmbLabourChargeAmt').val(asRslt.asWorkmnsh);
    } else {
      $("#txtLabourch").prop("checked", false);
      $('#cmbLabourChargeAmt').val("");
    }

    $("#appDate").val("");
    $("#CTSSessionCode").val("");
    $("#branchDSC").val("");

    $("#CTCode").val("");
    $("#CTGroup").val("");
    $("#callRem").val("");

    // ONGHC - 20200221 ADD FOR PSI
    // 54 - WP
    // 57 - SOFTENER
    // 58 - BIDET
    // 400 - POE
    if ($('#PROD_CAT').val() == "54" || $('#PROD_CAT').val() == "400" || $('#PROD_CAT').val() == "57" || $('#PROD_CAT').val() == "56") {
      $("#m15").show();
      $("#psiRcd").attr("disabled", false);
      $("#m16").show();
      $("#lpmRcd").attr("disabled", false);
    } else {
      $("#m15").hide();
      $("#psiRcd").attr("disabled", true);
      $("#m16").hide();
      $("#lpmRcd").attr("disabled", true);
    }

    if ($('#PROD_CAT').val() == "54" || $('#PROD_CAT').val() == "400" ){
        $("#m28").show();
        $("#ntuCom").attr("disabled", false);
    }else{
        $("#m28").hide();
        $("#ntuCom").attr("disabled", true);
        $("#ntuCom").val("0");
    }

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

    if (this.ops.MOD == "RESULTVIEW") {
      $("#btnSaveDiv").hide()
      $("#addDiv").hide();

      $('#dpSettleDate').attr("disabled", true);
      $('#tpSettleTime').attr("disabled", true);
      $('#ddlDSCCode').attr("disabled", true);
      $('#ddlCTCode').attr("disabled", true);
      $('#ddlErrorCode').attr("disabled", true);
      $('#ddlErrorDesc').attr("disabled", true);
      $('#txtRemark').attr("disabled", true);
      $("#iscommission").attr("disabled", true);
      $("#psiRcd").attr("disabled", true);
      $("#lpmRcd").attr("disabled", true);
      $("#ntuCom").attr("disabled", true);

      $('#def_type').attr("disabled", true);
      $('#def_code').attr("disabled", true);
      $('#def_part').attr("disabled", true);
      $('#def_def').attr("disabled", true);
      $('#solut_code').attr("disabled", true);

      $('#DT').hide();
      $('#DC').hide();
      $('#DP').hide();
      $('#DD').hide();
      $('#SC').hide();

      $("#txtLabourch").attr("disabled", true);
      $("#cmbLabourChargeAmt").attr("disabled", true);
      $("#ddlFilterCode").attr("disabled", true);
      $("#ddlFilterQty").attr("disabled", true);
      $("#ddlFilterPayType").attr("disabled", true);
      $("#ddlFilterExchangeCode").attr("disabled", true);
      $("#txtFilterRemark").attr("disabled", true);

      $("#serialNo").attr("disabled", true);
    } else {
      $("#btnSaveDiv").show()
      $("#addDiv").show();

      $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
      $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");
      $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
      $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");
      $('#ddlErrorCode').removeAttr("disabled").removeClass("readonly");
      $('#ddlErrorDesc').removeAttr("disabled").removeClass("readonly");
      $('#txtRemark').removeAttr("disabled").removeClass("readonly");
      $('#psiRcd').removeAttr("disabled").removeClass("readonly");
      $('#lpmRcd').removeAttr("disabled").removeClass("readonly");
      $('#ntuCom').removeAttr("disabled").removeClass("readonly");

      //$('#iscommission').removeAttr("disabled").removeClass("readonly");

      $("#iscommission").attr("disabled", false);

      //$('#def_type').removeAttr("disabled").removeClass("readonly");
      //$('#def_code').removeAttr("disabled").removeClass("readonly");
      //$('#def_part').removeAttr("disabled").removeClass("readonly");
      //$('#def_def').removeAttr("disabled").removeClass("readonly");
      //$('#solut_code').removeAttr("disabled").removeClass("readonly");

      //$("#txtFilterCharge").attr("disabled", false);
      //$("#txtLabourCharge").attr("disabled", false);
      $("#txtLabourch").attr("disabled", false);

      if (asRslt.asWorkmnsh > 0) {
        $("#cmbLabourChargeAmt").attr("disabled", false);
      } else {
        $("#cmbLabourChargeAmt").attr("disabled", true);
      }

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

      //if (asDataInfo[0].asStusId != 1) {
      //Common.alert("AS Not Active" + DEFAULT_DELIMITER + "<b>AS is no longer active. Result key-in is disallowed.</b>");
      //$("#btnSaveDiv").attr("style", "display:none");
      //}

      $("#mInH3").show();
    }
  }

  function fn_openField_Recall() {
    fn_clearPageField();
    //failRsn = "";

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

    $("#reminder").hide();
    $("#m14").hide();
    $("#txtRemark").val("");
    $("#txtRemark").attr("disabled", "disabled");

    if (this.ops.MOD == "RESULTVIEW") {
      $("#btnSaveDiv").hide();
      $('#ddlFailReason').attr("disabled", true);
      $('#txtRemark').attr("disabled", true);

      $('#appDate').attr("disabled", true);
      $('#CTGroup').attr("disabled", true);
      $('#callRem').attr("disabled", true);
    } else {
      $("#btnSaveDiv").show();
      $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
      //$('#txtRemark').removeAttr("disabled").removeClass("readonly");

      $('#iscommission').attr("disabled", false);

      $('#appDate').removeAttr("disabled").removeClass("readonly");
      $('#CTGroup').removeAttr("disabled").removeClass("readonly");
      $('#callRem').removeAttr("disabled").removeClass("readonly");

      // CLEAR DATE
      $('#dpSettleDate').val("");
      $('#tpSettleTime').val("");
    }
  }

  function fn_getRclData() {
    Common.ajax("GET", "/services/as/getASRclInfo.do", $("#resultASForm").serialize(), function(result) {
      if (result.length != 0) {
        if (result[0].appDt != null) {
          $("#appDate").val(result[0].appDt);
        } else {
          $("#appDate").val("");
        }
        if (result[0].appSess != null) {
          $("#CTSSessionCode").val(result[0].appSess);
        } else {
          $("#CTSSessionCode").val("");
        }
        if(result[0].segmentType != null){
            $("#CTSSessionSegmentType").val(result[0].segmentType);
        }
        else{
            $("#CTSSessionSegmentType").val("");
        }
        if (result[0].dscCde != null) {
          $("#branchDSC").val(result[0].dscCde);
        } else {
          $("#branchDSC").val("");
        }
        if (result[0].memId != null) {
          $("#CTCode").val(result[0].memId);
        } else {
          $("#CTCode").val("");
        }
        if (result[0].memGrp != null) {
          $("#CTGroup").val(result[0].memGrp);
        } else {
          $("#CTGroup").val("");
        }
        if (result[0].rclRmk != null) {
          $("#callRem").val(result[0].rclRmk);
        } else {
          $("#callRem").val("");
        }
      }
    });
  }

  function fn_openField_Cancel() {
    // failRsn = "";

    if (this.ops.MOD == "RESULTVIEW") {
      $('#dpSettleDate').attr("disabled", true);
      $('#tpSettleTime').attr("disabled", true);
      $("#iscommission").attr("disabled", true);
      $("#psiRcd").attr("disabled", true);
      $("#lpmRcd").attr("disabled", true);
      $("#ntuCom").attr("disabled", true);

      $("#appDate").attr("disabled", true);
      $("#CTSSessionCode").attr("disabled", true);
      $("#branchDSC").attr("disabled", true);
      $("#CTCode").attr("disabled", true);
      $("#CTGroup").attr("disabled", true);
      $("#callRem").attr("disabled", true);

      $("#def_type").attr("disabled", true);
      $("#def_type_text").attr("disabled", true);
      $("#def_code").attr("disabled", true);
      $("#def_code_text").attr("disabled", true);
      $("#def_part").attr("disabled", true);
      $("#def_part_text").attr("disabled", true);
      $("#def_def").attr("disabled", true);
      $("#def_def_text").attr("disabled", true);
      $("#solut_code").attr("disabled", true);
      $("#solut_code_text").attr("disabled", true);

      $("#txtLabourch").attr("disabled", true);
      $("#cmbLabourChargeAmt").attr("disabled", true);
      $("#ddlFilterCode").attr("disabled", true);
      $("#ddlFilterQty").attr("disabled", true);
      $("#ddlFilterPayType").attr("disabled", true);
      $("#ddlFilterExchangeCode").attr("disabled", true);
      $("#txtFilterRemark").attr("disabled", true);
      $("#txtLabourCharge").attr("disabled", true);
      $("#txtFilterCharge").attr("disabled", true);
      $("#txtTotalCharge").attr("disabled", true);

      $("#promisedDate").attr("disabled", true);
      $("#productGroup").attr("disabled", true);
      $("#productCode").attr("disabled", true);
      $("#serialNo").attr("disabled", true);
      $("#inHouseRemark").attr("disabled", true);
      $("#inHouseRepair_div").attr("style", "display:none");
    } else {
      $('#dpSettleDate').val("").attr("disabled", true);
      $('#tpSettleTime').val("").attr("disabled", true);
      $("#iscommission").attr("disabled", true);
      $('#psiRcd').val("").attr("disabled", true);
      $('#lpmRcd').val("").attr("disabled", true);
      $('#ntuCom').val("").attr("disabled", true);

      $("#appDate").val("");
      $("#CTSSessionCode").val("");
      $("#branchDSC").val("");
      $("#CTCode").val("");
      $("#CTGroup").val("");
      $("#callRem").val("");

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

      fn_clearPanelField_ASChargesFees();

      $("#txtLabourch").prop("checked", false).attr("disabled", true);
      $("#cmbLabourChargeAmt").val("").attr("disabled", true);
      $("#ddlFilterCode").val("").attr("disabled", true);
      $("#ddlFilterQty").val("").attr("disabled", true);
      $("#ddlFilterPayType").val("").attr("disabled", true);
      $("#ddlFilterExchangeCode").val("").attr("disabled", true);
      $("#txtFilterRemark").val("").attr("disabled", true);
      $("#txtLabourCharge").val("0.00").attr("disabled", true);
      $("#txtFilterCharge").val("0.00").attr("disabled", true);
      $("#txtTotalCharge").val("0.00").attr("disabled", true);

      /*$("input:radio[name='replacement']").removeAttr('checked');
      $("#promisedDate").val("").attr("disabled", "disabled");
      $("#productGroup").val("").attr("disabled", "disabled");
      $("#productCode").val("").attr("disabled", "disabled");
      $("#serialNo").val("").attr("disabled", "disabled");
      $("#inHouseRemark").val("").attr("disabled", "disabled");
      $("#inHouseRepair_div").attr("style", "display:none");
      fn_replacement(0);*/

      $("#btnSaveDiv").show();
      $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
      $('#txtRemark').removeAttr("disabled").removeClass("readonly");

      $('#appDate').removeAttr("disabled").removeClass("readonly");
      $('#CTGroup').removeAttr("disabled").removeClass("readonly");
      $('#callRem').removeAttr("disabled").removeClass("readonly");
    }

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
    $("#m14").show();
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
    $("#m14").show();

    if (this.ops.MOD == "RESULTVIEW") {
      $("#btnSaveDiv").hide();
      $('#ddlFailReason').attr("disabled", true);
      $('#txtRemark').attr("disabled", true);
    } else {
      $("#btnSaveDiv").show();
      $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
      $('#txtRemark').removeAttr("disabled").removeClass("readonly");
    }
  }

  function fn_clearPageField() {
    $("#btnSaveDiv").attr("style", "display:none");
    $("#addDiv").attr("style", "display:none");

    $('#dpSettleDate').val("").attr("disabled", true);
    $('#ddlFailReason').val("").attr("disabled", true);
    $('#tpSettleTime').val("").attr("disabled", true);
    $('#ddlDSCCode').val("").attr("disabled", true);
    //$('#ddlErrorCode').val("").attr("disabled", true);
    $('#ddlCTCode').val("").attr("disabled", true);
    //$('#ddlErrorDesc').val("").attr("disabled", true);
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

      /* $("input:radio[name='replacement']").removeAttr('checked');
      $("#promisedDate").val("").attr("disabled", "disabled");
      $("#productGroup").val("").attr("disabled", "disabled");
      $("#productCode").val("").attr("disabled", "disabled");
      $("#serialNo").val("").attr("disabled", "disabled");
      $("#inHouseRemark").val("").attr("disabled", "disabled");
      $("#inHouseRepair_div").attr("style", "display:none");
      fn_replacement(0);*/
    }
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
    /*var labourCharges = 0;
    var filterCharges = 0;
    var totalCharges = 0;

    labourCharges = $("#txtLabourCharge").val();
    filterCharges = $("#txtFilterCharge").val();

    filterCharges = Number(filterCharges.replace(/,/gi, ""));
    labourCharges = Number(labourCharges.replace(/,/gi, ""));
    totalCharges = labourCharges + filterCharges;

    $("#txtTotalCharge").val(totalCharges);*/
    var labourCharges = 0;
    var filterCharges = 0;
    var totalCharges = 0;

    labourCharges = $("#txtLabourCharge").val();
    filterCharges = $("#txtFilterCharge").val();
    totalCharges = parseFloat(labourCharges) + parseFloat(filterCharges);

    $("#txtTotalCharge").val(totalCharges.toFixed(2));
  }

  function fn_cmbLabourChargeAmt_SelectedIndexChanged() {
    // var v = $("#cmbLabourChargeAmt option:selected").text();
    // $("#txtLabourCharge").val(v.toFixed(2));
    // lfn_calculateTotalCharges();

    var v = "0.00";
    if ($("#cmbLabourChargeAmt").val() != "") {
      v = $("#cmbLabourChargeAmt option:selected").text();
    } else {
      v = "0.00";
    }
    $("#txtLabourCharge").val(v);
    fn_calculateTotalCharges();
  }

  function fn_cmbPaymentType() {
    /*if ($('#ddlFilterCode').val() != "") {
      if ($("#ddlFilterPayType").val() == "CHG") {
        var pCode = $("#ddlFilterCode").val();

        Common.ajaxSync("GET", "/services/as/getStockPrice.do", {
          stkID : pCode
        }, function(result) {
          var pPrice = result.FilPrice.filterprice;
          //Common.alert("aa "+pPrice + pPrice);
          $("#txtFilterCharge").val(pPrice.toFixed(2));
        });
      } else {
        $("#txtFilterCharge").val("0.00");
      }
    }
    fn_calculateTotalCharges();*/
  }

  function fn_onChangeddlFilterCode() {
    //$("#ddlFilterPayType").val("");
    //$("#txtFilterCharge").val("0.00");
    //fn_calculateTotalCharges();
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

    if (msg != "") {
      Common.alert(msg);
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

      // KR-OHK Serial Check
      if ($("#hidSerialRequireChkYn").val() == 'Y' && $("#hidSerialChk").val() == 'Y' && $("#ddlFilterQty").val() > 1) {
        Common.alert("For serial check items, only quantity 1 can be entered.");
        $("#ddlFilterQty").val("1");
        return false;
      }
      if ($("#hidSerialRequireChkYn").val() == 'Y' && $("#hidSerialChk").val() == 'Y' && FormUtil.isEmpty($("#ddSrvFilterLastSerial").val())) {
        var arg = "<spring:message code='service.title.SerialNo'/>";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
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
      // KR-OHK Serial Check
      $("#hidSerialChk").val(result.serialChk);

      availQty = result.availQty;
    });

    return availQty;
  }

  function fn_filterAdd() {
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
    fitem.filterId = $("#ddlFilterCode").val();
    //fitem.filterCODE =$("#ddlFilterCode").val();
    fitem.srvFilterLastSerial = $("#ddSrvFilterLastSerial").val();
    var ddlFilterCodeText = $("#ddlFilterCode option:selected").text();
    ddlFilterCodeText = ddlFilterCodeText.substr(0, ddlFilterCodeText.indexOf(" "));
    fitem.filterCode = ddlFilterCodeText;

    var chargePrice = 0;
    var chargeTotalPrice = 0;

    if (fitem.filterType == "CHG") {
      chargePrice = getASStockPrice(fitem.filterId);

      if (chargePrice == 0) {
        Common.alert("<spring:message code='service.msg.stkNoPrice'/>");
        return;
      }
    }

    fitem.filterPrice = parseInt(chargePrice, 10).toFixed(2);

    chargeTotalPrice = Number($("#ddlFilterQty").val()) * Number((chargePrice));
    fitem.filterTotal = Number(chargeTotalPrice).toFixed(2);

    if (AUIGrid.isUniqueValue(myFltGrd10, "filterId", fitem.filterId)) {
      fn_addRow(fitem);

      const filters = AUIGrid.getOrgGridData(myFltGrd10)
      const fTotal = filters.reduce((t, f) => f.filterType == "CHG" ? Number(f.filterTotal) + t : t, 0)
      $("#txtFilterCharge").val(fTotal.toFixed(2));
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

    $("#fcm3").hide();
    $("#fcm4").hide();
    $("#fcm5").hide();

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

  function fn_valDtFmt(val) {
    var dateRegex = /^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-.\/])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
    return dateRegex.test(val);
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

      var fmt = fn_valDtFmt($("#dpSettleDate").val());
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
        Common.alert("* " + "<spring:message code='service.grid.SettleDate' /> " + " <spring:message code='service.msg.inCrnYrMth' />");
        $("#dpSettleDate").val("");
        return;
      } else {
        if (tMth > sMth) {
          Common.alert("* " + "<spring:message code='service.grid.SettleDate' /> " + " <spring:message code='service.msg.inCrnYrMth' />");
          $("#dpSettleDate").val("");
          return;
        }
      }
    }

    //fn_setSaveFormData();
    fn_chkPmtMap() // CHECK PAYMENT MAPPING
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

    /*if ($("#solut_code_id").val() == "454") { // RETURN PRODUCT BACK TO FACTORY
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
    } */

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
      if ($("#ddlStatus").val() == 4 || $("#ddlStatus").val() == 1) {
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

       if($('#PROD_CAT').val() == "54" || $('#PROD_CAT').val() == "400"){ // WP & POE
            if (!($("#ntuCom").val() == "" || $("#ntuCom").val() == null )){
                if(!($("#ntuCom").val() >= 0 && $("#ntuCom").val() <= 10 )){
                    rtnMsg += "* <spring:message code='sys.msg.range' arguments='NTU,0.00,10.00' htmlEscape='false'/> </br>";
                    rtnValue = false;
                }
            }else{
                    rtnMsg += "* <spring:message code='sys.msg.invalid' arguments='NTU' htmlEscape='false'/> </br>";
                    rtnValue = false;
                }
            }

       // Installation Accessory checking for Complete status
       if($("#ddlStatus").val() == 4 ){
          if($("#chkInstallAcc").is(":checked") && ($("#installAcc").val() == "" || $("#installAcc").val() == null)){
              rtnMsg += "* <spring:message code='sys.msg.invalid' arguments='Installation Accessory' htmlEscape='false'/> </br>";
              rtnValue = false;
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

      //if (FormUtil.checkReqValue($("#ddlErrorCode"))) {
        if(!$("#ddlErrorCode").val()){
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Error Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        //if (FormUtil.checkReqValue($("#ddlErrorDesc"))) {
        if(!$("#ddlErrorDesc").val()){
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Error Description' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#ddlCTCode"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='CT Code' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if (FormUtil.checkReqValue($("#txtRemark"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='[AS Result Detail] Remark' htmlEscape='false'/> </br>";
          rtnValue = false;
        }

        if ($('#PROD_CAT').val() == "54" || $('#PROD_CAT').val() == "400" || $('#PROD_CAT').val() == "57" || $('#PROD_CAT').val() == "56") {
          if (FormUtil.checkReqValue($("#psiRcd"))) {
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Water Pressure (PSI)' htmlEscape='false'/> </br>";
            rtnValue = false;
          }

          if (FormUtil.checkReqValue($("#lpmRcd"))) {
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Liter Per Minute(LPM)' htmlEscape='false'/> </br>";
            rtnValue = false;
          }
          if (FormUtil.checkReqValue($("#waterSrcType"))) { // CT CODE
              rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='water source Type' htmlEscape='false'/> </br>";
              rtnValue = false;
          }
        }

        // KR-OHK Serial Check
        if ($("#hidSerialRequireChkYn").val() == 'Y' && FormUtil.checkReqValue($("#stockSerialNo"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
        /* if (FormUtil.checkReqValue($("#asNotMatch"))) { // CT CODE
            rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='AS not match reason' htmlEscape='false'/> </br>";
            rtnValue = false;
        } */
      } else if ($("#ddlStatus").val() == 19) { // RECALL
        if (FormUtil.checkReqValue($("#ddlFailReason"))) { // FAIL REASON
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Fail Reason' htmlEscape='false'/> </br>";
          rtnValue = false;
        }
        if (FormUtil.checkReqValue($("#appDate"))) { // APPOINTMENT DATE
          text = "<spring:message code='service.title.AppointmentDate'/>";
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
          rtnValue = false;
        } else {
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
            text = "<spring:message code='service.title.AppointmentDate'/>";
            rtnMsg += "* " + text + " must be greater or equal to Current Date  </br>";
            rtnValue = false;
          }
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
        if (FormUtil.checkReqValue($("#ddlFailReason"))) {
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

  function fn_productGroup_SelectedIndexChanged() {
    var STK_CTGRY_ID = $("#productGroup").val();

    if (STK_CTGRY_ID != null) {
      $("#serialNo").val("");
      $("#productCode option").remove();

      doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + STK_CTGRY_ID, '', '', 'productCode', 'S', '');
    }
  }

  function fn_productGroup_SelectedIndexChanged_2(val) {
    var STK_CTGRY_ID = $("#productGroup").val();

    if (STK_CTGRY_ID != null) {
      $("#serialNo").val("");
      $("#productCode option").remove();

      doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + STK_CTGRY_ID, '', val, 'productCode', 'S', '');
    }
  }

  function fn_chkPmtMap() {
    Common.ajax("POST", "/services/as/chkPmtMap.do", {
      AS_ENTRY_ID : asDataInfo[0].asId,
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val(),
    }, function(result) {
      if (result.code == "99") {
        // PAYMENT MAPPED
        Common.confirm("<spring:message code='service.msg.confirmPmtMap'/>", fn_setSaveFormData);
      } else {
        fn_setSaveFormData();
      }
    });
  }

  function fn_setSaveFormData() {
    var allRowItems = AUIGrid.getGridData(myFltGrd10);
    var addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10);
    var editedRowItems = AUIGrid.getEditedRowColumnItems(myFltGrd10);
    var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10);

    /*var inHseRprInd = "";
    if ($("input[name='replacement'][value='1']").prop("checked")) {
      inHseRprInd = 1;
    } else {
      inHseRprInd = 0;
    }*/

    // TEMPORARY OPEN LABOUR CHARGE, FILTER CHARGE, TOTAL CHARGE
    $('#txtLabourCharge').attr("disabled", false);
    $('#txtFilterCharge').attr("disabled", false);
    $('#txtTotalCharge').attr("disabled", false);

    var asResultM = {
      // GENERAL DATA
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

      AS_PSI : $('#psiRcd').val(),
      AS_LPM : $('#lpmRcd').val(),
      WATER_SRC_TYPE : $('#waterSrcType').val(),
      AS_UNMATCH_REASON : $('#asNotMatch').val(),
      NTU : $('#ntuCom').val(),
      INS_ACC_CHK : $("#chkInstallAcc").prop("checked") ? 'on' : '',

      // AS RECALL ENTRY
      AS_APP_DT : $("#appDate").val(),
      AS_APP_SESS : $("#CTSSessionCode").val(),
      SEGMENT_TYPE : $("#CTSSessionSegmentType").val(),
      AS_RCL_ASG_DSC : $("#branchDSC").val(),
      AS_RCL_ASG_CT : $("#CTCode").val(),
      AS_RCL_ASG_CT_GRP : $("#CTGroup").val(),
      AS_RCL_RMK : $("#callRem").val(),

      // AS DEFECT ENTRY
      AS_DEFECT_TYPE_ID : $('#ddlStatus').val() == 4 ? $('#def_type_id').val() : '0',
      AS_DEFECT_GRP_ID : 0,
      AS_DEFECT_ID : $('#ddlStatus').val() == 4 ? $('#def_code_id').val() : '0',
      AS_DEFECT_PART_GRP_ID : 0,
      AS_DEFECT_PART_ID : $('#ddlStatus').val() == 4 ? $('#def_part_id').val() : '0',
      AS_DEFECT_DTL_RESN_ID : $('#ddlStatus').val() == 4 ? $('#def_def_id').val() : '0',
      AS_SLUTN_RESN_ID : $('#ddlStatus').val() == 4 ? $('#solut_code_id').val() : '0',

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

      // OTHER
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val(),
      AS_RESULT_ID : $('#asData_AS_RESULT_ID').val(),
      AS_NO : asDataInfo[0].asNo,
      AS_ID : asDataInfo[0].asId,
      ACC_BILL_ID : asDataInfo[0].c19,
      ACC_INVOICE_NO : asDataInfo[0].c20,
      TAX_INVOICE_CUST_NAME : $("#txtCustName").text(),
      TAX_INVOICE_CONT_PERS : $("#txtContactPerson").text(),

      // AS IN HOUSE REPAIR
      /* productCode : aSOrderInfo.stockCode,
      productName : aSOrderInfo.stockDesc,
      serialNo : aSOrderInfo.lastInstallSerialNo,
      IN_HUSE_REPAIR_REM : $("#inHouseRemark").val(),
      IN_HUSE_REPAIR_REPLACE_YN : inHseRprInd,
      IN_HUSE_REPAIR_PROMIS_DT : $("#promisedDate").val(),
      IN_HUSE_REPAIR_GRP_CODE : $("#productGroup").val(),
      IN_HUSE_REPAIR_PRODUCT_CODE : $("#productCode").val(),
      IN_HUSE_REPAIR_SERIAL_NO : $("#serialNo").val() */

      productCode : "",
      productName : "",
      serialNo : "",
      IN_HUSE_REPAIR_REM : "",
      IN_HUSE_REPAIR_REPLACE_YN : 0,
      IN_HUSE_REPAIR_PROMIS_DT : "",
      IN_HUSE_REPAIR_GRP_CODE : "",
      IN_HUSE_REPAIR_PRODUCT_CODE : "",
      IN_HUSE_REPAIR_SERIAL_NO : "",
      // KR-OHK Serial Check
      SERIAL_NO : $("#stockSerialNo").val(),
      SERIAL_REQUIRE_CHK_YN : $("#hidSerialRequireChkYn").val()
    }

    var saveForm;
    if ($("#requestMod").val() == "INHOUSE") { // IN HOUSE SESSION
      saveForm = {
        "asResultM" : asResultM,
        "add" : addedRowItems,
        "update" : editedRowItems,
        "remove" : removedRowItems
      }

      Common.ajax("POST", "/services/inhouse/save.do", saveForm, function(result) {
        if (result.asNo != "") {
          Common.alert("<spring:message code='service.msg.updSucc'/>");
          fn_DisablePageControl();
        }
      });
    } else {
      if ($("#requestMod").val() == "NEW") {
        saveForm = {
          "asResultM" : asResultM,
          "add" : addedRowItems,
          "update" : editedRowItems,
          "remove" : removedRowItems,
          "installAccList" : $("#installAcc").val(),
          "mobileYn" : "N"
        }

        Common.ajax("POST", "/services/as/newResultAdd.do", saveForm, function(result) {
          if (result.asNo != "") {
            Common.alert("<spring:message code='service.msg.updSucc'/>");
            fn_DisablePageControl();
          }
        });

      } else if ($("#requestMod").val() == "RESULTEDIT") {
        if (addedRowItems == "" || removedRowItems == "") {
          saveForm = {
            "asResultM" : asResultM,
            "add" : allRowItems,
            "update" : editedRowItems,
            "remove" : editedRowItems,
            "installAccList" : $("#installAcc").val(),
            "mobileYn" : "N",
            "removeList" : removeList
          // "all" : allRowItems
          }
        } else {
          saveForm = {
            "asResultM" : asResultM,
            "add" : addedRowItems,
            "update" : editedRowItems,
            "remove" : removedRowItems,
            "installAccList" : $("#installAcc").val(),
            "mobileYn" : "N",
            "removeList" : removeList
          }
        }
        console.log("SaveForm: " + JSON.stringify(saveForm));
        // KR-OHK Serial Check add
        var url = "";
        if ($("#hidSerialRequireChkYn").val() == 'Y') {
          url = "/services/as/newResultUpdateSerial.do";
        } else {
          url = "/services/as/newResultUpdate_1.do";
        }

        Common.ajax("POST", url, saveForm, function(result) {
          if (result.data != "") {
            $("#newResultNo").html("<B>" + result.data + "</B>");
            Common.alert("<spring:message code='service.msg.updSucc'/>");
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

    // DISABLE LABOUR CHARGE, FILTER CHARGE, TOTAL CHARGE
    $('#txtLabourCharge').attr("disabled", true);
    $('#txtFilterCharge').attr("disabled", true);
    $('#txtTotalCharge').attr("disabled", true);
  }

  function fn_asResult_editPageContral(_type) {
    if ("INHOUSE" == _type) {
      $("#solut_code_text").attr("disabled", true);
    } else {
      $("#newRno").attr("style", "display:inline");
      //$('#solut_code').removeAttr("disabled").removeClass("readonly");
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

    //$('#def_type').removeAttr("disabled").removeClass("readonly");
    //$('#def_code').removeAttr("disabled").removeClass("readonly");
    //$('#def_part').removeAttr("disabled").removeClass("readonly");
    //$('#def_def').removeAttr("disabled").removeClass("readonly");

    //$('#def_type_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_code_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_part_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_def_text').removeAttr("disabled").removeClass("readonly");

    $('#txtLabourch').removeAttr("disabled").removeClass("readonly");
    //$('#txtTotalCharge').removeAttr("disabled").removeClass("readonly");
    //$('#txtFilterCharge').removeAttr("disabled").removeClass("readonly");
    //$('#txtLabourCharge').removeAttr("disabled").removeClass("readonly");
    $('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterQty').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterPayType').removeAttr("disabled").removeClass("readonly");
    $('#ddlFilterExchangeCode').removeAttr("disabled").removeClass("readonly");
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
    $("#asResultForm").find("input, textarea, button, select").attr("disabled", true);
  }

  function fn_setASDataInit(ops) {
    this.ops = ops;
    $("#asData_AS_ID").val(ops.AS_ID);
    $("#asData_AS_SO_ID").val(ops.AS_SO_ID);
    $("#asData_AS_ORD_NO").val(ops.ORD_NO);
    $("#asData_AS_RESULT_ID").val(ops.AS_RESULT_ID);
    $("#asData_AS_RESULT_NO").val(ops.AS_RESULT_NO);
    $("#requestMod").val(ops.MOD);

    fn_getASRulstEditFilterInfo(); //AS_RESULT_NO
    // fn_getASRulstSVC0004DInfo(); //AS_RESULT_NO
    // fn_setCTcodeValue();

    // AS EDIT
    if (ops.MOD == "RESULTEDIT") {
      //fn_getErrMstList('${ORD_NO}', 'fn_errCallbackFun');
      fn_errCallbackFun();
      fn_HasFilterUnclaim();

    } else if (ops.MOD == "RESULTVIEW") {
      //fn_getErrMstList('${ORD_NO}', 'fn_errCallbackFun');
      fn_errCallbackFun();

      $("#asResultForm").find("input, textarea, button, select").attr("disabled", true);
      $("#btnSaveDiv").attr("style", "display:none");

      // fn_HasFilterUnclaim();
      // fn_asResult_viewPageContral();

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
      $("#productGroup").attr('disabled', 'disabled');
      $("#productCode").attr('disabled', 'disabled');
      $("#serialNo").attr('disabled', 'disabled');

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

  function fn_secChk(obj) {
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

  function fn_valDtFmt(val) {
    var dateRegex = /^(?=\d)(?:(?:31(?!.(?:0?[2469]|11))|(?:30|29)(?!.0?2)|29(?=.0?2.(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(?:\x20|$))|(?:2[0-8]|1\d|0?[1-9]))([-.\/])(?:1[012]|0?[1-9])\1(?:1[6-9]|[2-9]\d)?\d\d(?:(?=\x20\d)\x20|$))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
    return dateRegex.test(val);
  }

  function fn_doAllaction(obj) {
    var ord_id = $("#ORD_ID").val();

    var vdte = obj.value;
    var text = "<spring:message code='service.grid.AppntDt' />";

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

  function fn_chkDt2(obj) {
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
      Common.alert("Appointment Date must be greater or equal to Current Date ");
      $("#appDate").val("");
      $("#CTSSessionCode").val("");
      $("#branchDSC").val("");
      $("#CTCode").val("");
      $("#CTGroup").val("");
      $("#callRem").val("");
      return;
    } else {
      fn_doAllaction(obj);
    }
  }

  function fn_dftTyp(dftTyp) {
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
    } else if (dftTyp == "SC") {
      if ($("#def_type_id").val() == "" || $("#def_type_id").val() == null) {
        var text = "<spring:message code='service.text.defTyp' />";
        var msg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false' argumentSeparator=';' /></br>";
        Common.alert(msg);
        return false;
      } else {
        dtCde = $("#def_type_id").val();
      }
    }

    Common.popupDiv("/services/as/dftTypPop.do", {
      callPrgm : dftTyp,
      prodCde : $("#PROD_CDE").val(),
      ddCde : ddCde,
      dtCde : dtCde,
      matchMatDefCode : JSON.stringify(matchMatDefCode)
    }, null, true);
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
            var text2 = $("#def_part_text").val();
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
            var text2 = $("#def_def_text").val();
            var text3 = itm.descp;
            var text4 = "<spring:message code='service.text.defTyp' />";
            var text = text1 + ";" + text2 + ";" + text3;
            msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

            $("#def_type").val("");
            $("#def_type_id").val("");
            $("#def_type_text").val("");
          }

          if (msg != "") {
            Common.alert(msg);
            return false;
          }
        }

        if (itm.id == "7072") {
          if ($("#def_part_id").val() == "5299" || $("#def_part_id").val() == "5300" || $("#def_part_id").val() == "5301" || $("#def_part_id").val() == "5302" || $("#def_part_id").val() == "5321" || $("#def_part_id").val() == "5332") {
            var text1 = "<spring:message code='service.text.defPrt' />";
            var text2 = $("#def_part_text").val();
            var text3 = itm.descp;
            var text4 = "<spring:message code='service.text.defTyp' />";
            var text = text1 + ";" + text2 + ";" + text3;
            msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

            $("#def_type").val("");
            $("#def_type_id").val("");
            $("#def_type_text").val("");
          }

          if ($("#def_def_id").val() == "6041" || $("#def_def_id").val() == "6042" || $("#def_def_id").val() == "6043" || $("#def_def_id").val() == "6044" || $("#def_def_id").val() == "6045" || $("#def_def_id").val() == "6046" || $("#def_def_id").val() == "6008" || $("#def_def_id").val() == "6015" || $("#def_def_id").val() == "6023" || $("#def_def_id").val() == "6031") {
            var text1 = "<spring:message code='service.text.dtlDef' />";
            var text2 = $("#def_def_text").val();
            var text3 = itm.descp;
            var text4 = "<spring:message code='service.text.defTyp' />";
            var text = text1 + ";" + text2 + ";" + text3;
            msg += "<spring:message code='sys.msg.defAsSolCusReq' arguments='" + text4 + ";" + text3 + ";" + text1 + ";" + text2 + "' htmlEscape='false' argumentSeparator=';'/></br>";

            $("#def_type").val("");
            $("#def_type_id").val("");
            $("#def_type_text").val("");
          }

          if (msg != "") {
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

        if (itm.id == "5299" || itm.id == "5300" || itm.id == "5301" || itm.id == "5302" || itm.id == "5321" || itm.id == "5332") {
          if ($("#def_type_id").val() == "7059") {
            var text1 = "<spring:message code='service.text.defTyp' />";
            var text2 = $("#def_type_text").val();
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
            var text2 = $("#def_type_text").val();
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

        if (itm.id == "6041" || itm.id == "6042" || itm.id == "6043" || itm.id == "6044" || itm.id == "6045" || itm.id == "6046") {
          if ($("#def_type_id").val() == "7059") {
            var text1 = "<spring:message code='service.text.defTyp' />";
            var text2 = $("#def_type_text").val();
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

        if (itm.id == "6041" || itm.id == "6042" || itm.id == "6043" || itm.id == "6044" || itm.id == "6045" || itm.id == "6046" || itm.id == "6008" || itm.id == "6015" || itm.id == "6023" || itm.id == "6031") {
          if ($("#def_type_id").val() == "7072") {
            var text1 = "<spring:message code='service.text.defTyp' />";
            var text2 = $("#def_type_text").val();
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

  setPopData();

  function fn_serialModifyPop() {
    $("#serialNoChangeForm #pSerialNo").val($("#stockSerialNo").val()); // Serial No
    $("#serialNoChangeForm #pSalesOrdId").val($("#ORD_ID").val()); // 주문 ID
    $("#serialNoChangeForm #pSalesOrdNo").val($("#ORD_NO").val()); // 주문 번호
    $("#serialNoChangeForm #pRefDocNo").val($("#AS_NO").val()); //
    // $("#serialNoModifyForm #pItmCode").val( $("#stkCode").val()  ); // 제품 ID
    $("#serialNoChangeForm #pCallGbn").val("AS_EDIT");
    $("#serialNoChangeForm #pMobileYn").val("N");

    if (Common.checkPlatformType() == "mobile") {
      popupObj = Common.popupWin("serialNoChangeForm", "/logistics/serialChange/serialNoChangePop.do", {
        width : "1000px",
        height : "1000px",
        height : "720",
        resizable : "no",
        scrollbars : "yes"
      });
    } else {
      Common.popupDiv("/logistics/serialChange/serialNoChangePop.do", $("#serialNoChangeForm").serializeJSON(), null, true, '_serialNoChangePop');
    }
  }

  function fn_PopSerialChangeClose(obj) {

    //console.log("++++ obj.asIsSerialNo ::" + obj.asIsSerialNo +", obj.beforeSerialNo ::"+ obj.beforeSerialNo);

    $("#stockSerialNo").val(obj.asIsSerialNo);
    $("#hidStockSerialNo").val(obj.beforeSerialNo);

    if (popupObj != null)
      popupObj.close();
    //fn_viewInstallResultSearch(); //조회
  }

  //팝업에서 호출하는 조회 함수
  function SearchListAjax(obj) {

    //console.log("++++ obj.asIsSerialNo ::" + obj.asIsSerialNo +", obj.beforeSerialNo ::"+ obj.beforeSerialNo);

    $("#stockSerialNo").val(obj.asIsSerialNo);
    $("#hidStockSerialNo").val(obj.beforeSerialNo);

    //fn_viewInstallResultSearch(); //조회
  }

  function fn_serialSearchPop() {
    var filterCodeVal = $("#ddlFilterCode option:selected").val();
    var filterCodeText = $("#ddlFilterCode option:selected").text();
    filterCodeText = filterCodeText.substr(0, filterCodeText.indexOf(" "))

    $("#pItemCodeOrName").val(filterCodeText);

    if (FormUtil.isEmpty(filterCodeVal)) {
      var text = "<spring:message code='service.grid.FilterCode'/>";
      var rtnMsg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
      Common.alert(rtnMsg);
      return false;
    }

    Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {
      width : "1000px",
      height : "580",
      resizable : "no",
      scrollbars : "no"
    });
  }

  function fnSerialSearchResult(data) {
    data.forEach(function(dataRow) {
      $("#ddSrvFilterLastSerial").val(dataRow.serialNo);
      //console.log("serialNo : " + dataRow.serialNo);
    });
  }

  function f_multiCombo(){
        $(function() {
            $('#installAcc').change(function() {
            }).multipleSelect({
                selectAll: false, // 전체선택
                width: '80%'
            }).multipleSelect("setSelects", installAccValues);
        });
    }

    function fn_InstallAcc_CheckedChanged(_obj) {
            if (_obj.checked) {
                doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
            } else {
                doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');
            }
          }

</script>
<form id="serialNoChangeForm" name="serialNoChangeForm" method="POST">
  <input type="hidden" name="pSerialNo" id="pSerialNo" /> <input type="hidden" name="pSalesOrdId" id="pSalesOrdId" /> <input type="hidden" name="pSalesOrdNo" id="pSalesOrdNo" /> <input type="hidden" name="pRefDocNo" id="pRefDocNo" /> <input type="hidden" name="pItmCode" id="pItmCode" /> <input type="hidden" name="pCallGbn" id="pCallGbn" /> <input type="hidden" name="pMobileYn" id="pMobileYn" />
</form>
<form id="frmSearchSerial" name="frmSearchSerial" method="post">
  <input id="pGubun" name="pGubun" type="hidden" value="RADIO" /> <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" /> <input id="pLocationType" name="pLocationType" type="hidden" value="" /> <input id="pLocationCode" name="pLocationCode" type="hidden" value="" /> <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" /> <input id="pStatus" name="pStatus" type="hidden" value="" /> <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
</form>
<form id="asDataForm" method="post">
  <div style='display: none'>
    <input type="text" id='asData_AS_ID' name='asData_AS_ID' /> <input type="text" id='asData_AS_SO_ID' name='asData_AS_SO_ID' /> <input type="text" id='asData_AS_ORD_NO' name='asData_AS_ORD_NO' /> <input type="text" id='asData_AS_RESULT_ID' name='asData_AS_RESULT_ID' /> <input type="text" id='asData_AS_RESULT_NO' name='asData_AS_RESULT_NO' /> <input type="text" id='requestMod' name='requestMod' />
  </div>
</form>
<form id="asResultForm" method="post">
  <input type="hidden" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" /> <input type="hidden" id='hidStockSerialNo' name='hidStockSerialNo' /> <input type="hidden" id='hidSerialChk' name='hidSerialChk' />
  <article class="acodi_wrap">
    <!-- acodi_wrap start -->
    <dl>
      <dt class="click_add_on on">
        <a href="#"><spring:message code='service.title.asRstDtl' /></a>
      </dt>
      <dd>
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 160px" />
            <col style="width: *" />
            <col style="width: 110px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row">
                <!--<spring:message code='service.grid.ResultNo' /> -->
              </th>
              <td colspan="3">
                <div id='newRno' style='display: none'>
                  <span id='newResultNo'> </span>
                </div> <span id='reminder' style="color: red;
  font-style: italic;
  display: none"><spring:message code='service.alert.msg.AsEditPrdChk' /></span>
              </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.ResultNo' /></th>
              <td><input type="text" title="" placeholder="" class="w100p" id='txtResultNo' name='txtResultNo' disabled /></td>
              <th scope="row"><spring:message code='sys.title.status' /><span id='m1' name='m1' class="must">*</span></th>
              <td><select class="w100p" id="ddlStatus" name="ddlStatus" onChange="fn_ddlStatus_SelectedIndexChanged()">
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
              </select></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.SettleDate' /><span id='m2' name='m2' class="must" style="display: none">*</span></th>
              <td><input type="text" title="Create start Date" id='dpSettleDate' name='dpSettleDate' placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" /></td>
              <th scope="row"><spring:message code='service.grid.FailReason' /><span id='m3' name='m3' class="must" style="display: none">*</span></th>
              <td><select id='ddlFailReason' name='ddlFailReason' disabled="disabled" class="w100p">
                  <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
              </select></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.SettleTm' /><span id='m4' name='m4' class="must" style="display: none">*</span></th>
              <td>
                <div class="time_picker">
                  <input type="text" title="" placeholder="" id='tpSettleTime' name='tpSettleTime' class="readonly time_date" disabled="disabled" />
                  <ul>
                    <li><spring:message code='service.text.timePick' /></li>
                    <c:forEach var="list" items="${timePick}" varStatus="status">
                      <li><a href="#">${list.codeName}</a></li>
                    </c:forEach>
                  </ul>
                </div> <!-- time_picker end -->
              </td>
              <th scope="row"><spring:message code='service.title.DSCCode' /><span id='m5' name='m5' class="must" style="display: none">*</span></th>
              <td><input type="hidden" title="" placeholder="" class="" id='ddlDSCCode' name='ddlDSCCode' value='${BRANCH_ID}' /> <input type="text" title="" placeholder="" class="readonly w100p" id='ddlDSCCodeText' name='ddlDSCCodeText' value='${BRANCH_NAME}' /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.ErrCde' /><span id='m6' name='m6' class="must" style="display: none">*</span></th>
              <td><select disabled="disabled" id='ddlErrorCode' name='ddlErrorCode' onChange="fn_errMst_SelectedIndexChanged(1)" class="w100p"></select></td>
              <th scope="row"><spring:message code='service.grid.CTCode' /><span id='m7' name='m7' class="must" style="display: none">*</span></th>
              <td><input type="hidden" title="" placeholder="ddlCTCode" class="" id='ddlCTCode' name='ddlCTCode' /> <input type="text" title="" placeholder="" class="readonly w100p" id='ddlCTCodeText' name='ddlCTCodeText' /> <!--
           <input type="hidden" title="" placeholder="ddlCTCode" class=""  id='ddlCTCode' name='ddlCTCode' value='${USER_ID}'/>
           <input type="text" title=""   placeholder="" class="readonly"     id='ddlCTCodeText' name='ddlCTCodeText'  value='${USER_NAME}'/>
         --></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.ErrDesc' /><span id='m8' name='m8' class="must" style="display: none">*</span></th>
              <td><select id='ddlErrorDesc' name='ddlErrorDesc' class="w100p" onChange="fn_errDescCheck(1)"></select></td>
              <th scope="row"><spring:message code='sal.title.warehouse' /></th>
              <td><select class="disabled w100p" disabled="disabled" id='ddlWarehouse' name='ddlWarehouse'>
                  <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
              </select></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.Remark' /><span id='m14' name='m14' class="must">*</span></th>
              <td colspan="3"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />" id='txtRemark' name='txtRemark'></textarea></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='sal.text.commission' /></th>
              <td><label> <input type="checkbox" disabled="disabled" id='iscommission' name='iscommission' /> <span><spring:message code='sal.text.commissionApplied' /></span></label></td>
              <th scope="row"><spring:message code='service.title.SerialNo' /><span class="must">*</span></th>
              <td><input type="text" id='stockSerialNo' name='stockSerialNo' value="${orderDetail.basicInfo.lastSerialNo}" class="readonly" readonly />
                <p class="btn_grid" style="display: none" id="btnSerialEdit">
                  <a id="serialEdit" href="#" onClick="fn_serialModifyPop()">EDIT</a>
                </p></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.PSIRcd' /><span class="must" id="m15" style="display: none"> *</span></th>
              <td><input type="text" title="" placeholder="<spring:message code='service.title.PSIRcd' />" class="w100p" id="psiRcd" name="psiRcd" disabled="disabled" onkeypress='validate(event)'/></td>
              <th scope="row"><spring:message code='service.title.lmp' /><span class="must" id="m16" style="display: none"> *</span></th>
              <td><input type="text" title="" placeholder="<spring:message code='service.title.lmp' />" class="w100p" id="lpmRcd" name="lpmRcd" disabled="disabled" onkeypress='validate(event)'/></td>
            </tr>
            <tr>
                <th scope="row">Water Source Type<span name="m18" id="m18" class="must">*</span></th>
                <td><select class="w100p" id="waterSrcType" name="waterSrcType">
                    <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                    <c:forEach var="list" items="${waterSrcType}" varStatus="status">
                       <option value="${list.codeId}">${list.codeName}</option>
                    </c:forEach>
                </select></td>
                <th scope="row">AS Error Not Match<span name="m19" id="m19" class="must">*</span></th>
                <td><select class="w100p" id="asNotMatch" name="asNotMatch" >
                    <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                    <c:forEach var="list" items="${asNotMatch}" varStatus="status">
                       <option value="${list.codeId}">${list.codeName}</option>
                    </c:forEach>
                </select></td>
           </tr>
           <tr>
              <th scope="row">Rework Project<span id='m100' name='m100' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="Rework Project" class="disabled w100p" disabled="disabled" id='reworkProj' name='reworkProj' /></td>
              <th scope="row"><spring:message code='service.title.ntu'/><span id="m28" class="must">*</span></th>
              <td><input type="text" title="NTU" class="w100p" id="ntuCom" name="ntuCom" placeholder="0.00" maxlength="5" onkeypress='validate(event)' />
              </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="service.title.installation.accessories" />
                <input type="checkbox" id="chkInstallAcc" name="chkInstallAcc" onChange="fn_InstallAcc_CheckedChanged(this)" checked/></th>
                <td colspan="3">
                <select class="w100p" id="installAcc" name="installAcc">
                </select>
                </td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.CrtBy' /></th>
              <td><input type="text" title="" placeholder="<spring:message code='service.grid.CrtBy' />" class="disabled w100p" disabled="disabled" id='creator' name='creator' /></td>
              <th scope="row"><spring:message code='service.grid.CrtDt' /><span class="must">*</span></th>
              <td><input type="text" title="" placeholder="<spring:message code='service.grid.CrtDt' />" class="disabled w100p" disabled="disabled" id='creatorat' name='creatorat' /></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
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
              <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " readonly="readonly" id="appDate" name="appDate" onChange="fn_chkDt2(this);" /></td>
              <th scope="row"><spring:message code='service.title.AppointmentSessione' /><span class="must">*</span></th>
              <td><input type="text" title="" placeholder="<spring:message code='service.title.AppointmentDate' />" id="CTSSessionCode" name="CTSSessionCode" class="readonly w100p" readonly="readonly" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.DSCBranch' /><span class="must">*</span></th>
              <td><select class="w100p" id="branchDSC" name="branchDSC" class="" disabled="disabled"></select></td>
              <th scope="row"><spring:message code='service.grid.AssignCT' /><span class="must">*</span></th>
              <td><input type="text" title="" placeholder="<spring:message code='service.grid.AssignCT' />" id="CTCode" name="CTCode" class="readonly w100p" readonly="readonly" onchange="fn_changeCTCode(this)" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.CTGroup' /></th>
              <td colspan="3"><input type="text" title="<spring:message code='service.title.CTGroup' />" placeholder="<spring:message code='service.title.CTGroup' />" class="w100p" id="CTGroup" name="CTGroup" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.Remark' /><span class="must">*</span></th>
              <td colspan="3"><textarea id='callRem' name='callRem' rows='5' placeholder="<spring:message code='service.title.Remark' />" class="w100p"></textarea></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
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
              <td><label> <input type="checkbox" id='txtLabourch' name='txtLabourch' onChange="fn_LabourCharge_CheckedChanged(this)" disabled />
              </label></td>
              <th scope="row"><spring:message code='service.text.asLbrChr' /></th>
              <td><input type="text" id='txtLabourCharge' name='txtLabourCharge' value='0.00' class='readonly' readonly /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.text.asLbrChr' /> (RM) <span id="fcm1" name="fcm1" class="must" style="display: none">*</span></th>
              <td><select id='cmbLabourChargeAmt' name='cmbLabourChargeAmt' onChange="fn_cmbLabourChargeAmt_SelectedIndexChanged()" disabled>
                  <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                  <c:forEach var="list" items="${lbrFeeChr}" varStatus="status">
                    <option value="${list.codeId}">${list.codeName}</option>
                  </c:forEach>
              </select></td>
              <th scope="row"><spring:message code='service.text.asfltChr' /></th>
              <td><input type="text" id='txtFilterCharge' name='txtFilterCharge' value='0.00' class='readonly' readonly /></td>
            </tr>
            <tr>
              <th scope="row"></th>
              <td><i class="red_text"><spring:message code='sys.common.sst.msg.incld' /></i></td>
              <th scope="row"><b><spring:message code='service.text.asTtlChr' /></b></th>
              <td><input type="text" id='txtTotalCharge' name='txtTotalCharge' value='0.00' class='readonly' readonly /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.grid.FilterCode' /><span id="fcm2" name="fcm2" class="must" style="display: none">*</span></th>
              <td><select id='ddlFilterCode' name='ddlFilterCode' onChange="fn_setMand(this);fn_onChangeddlFilterCode()"></select></td>
              <th scope="row"><spring:message code='service.grid.Quantity' /><span id="fcm3" name="fcm3" class="must" style="display: none">*</span></th>
              <td><select id='ddlFilterQty' name='ddlFilterQty'>
                  <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                  <c:forEach var="list" items="${fltQty}" varStatus="status">
                    <option value="${list.codeId}">${list.codeName}</option>
                  </c:forEach>
              </select></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.text.asPmtTyp' /><span id="fcm4" name="fcm4" class="must" style="display: none">*</span></th>
              <td><select id='ddlFilterPayType' name='ddlFilterPayType' onChange="fn_cmbPaymentType()">
                  <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                  <c:forEach var="list" items="${fltPmtTyp}" varStatus="status">
                    <option value="${list.codeId}">${list.codeName}</option>
                  </c:forEach>
              </select></td>
              <th scope="row"><spring:message code='service.text.asExcRsn' /><span id="fcm5" name="fcm5" class="must" style="display: none">*</span></th>
              <td><select id='ddlFilterExchangeCode' name='ddlFilterExchangeCode'></select></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.SerialNo' /></th>
              <td colspan="3"><input type="text" id='ddSrvFilterLastSerial' name='ddSrvFilterLastSerial' /> <a id="serialSearch" class="search_btn" onclick="fn_serialSearchPop()" style="display: none"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.Remark' /></th>
              <td colspan="3"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />" id='txtFilterRemark' name='txtFilterRemark'></textarea></td>
            </tr>
            <td colspan="4"><span style="color: red;
  font-style: italic;"><spring:message code='service.msg.msgFltTtlAmt' /></span></td>
          </tbody>
        </table>
        <!-- table end -->
        <div id='addDiv'>
          <ul class="center_btns">
            <li><p class="btn_blue2">
                <a href="#" onclick="fn_filterAdd()"><spring:message code='sys.btn.add' /></a>
              </p></li>
            <li><p class="btn_blue2">
                <a href="#" onclick="fn_clearPanelField_ASChargesFees()"><spring:message code='sys.btn.clear' /></a>
              </p></li>
          </ul>
        </div>
        <article class="grid_wrap">
          <!-- grid_wrap start -->
          <div id="asfilter_grid_wrap" style="width: 100%;
  height: 220px;
  margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->
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
              <th scope="row"><spring:message code='service.text.defTyp' /><span id='m9' name='m9' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" id='def_type' name='def_type' placeholder="" disabled="disabled" class="" onblur="fn_getASReasonCode2(this, 'def_type' ,'387')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DT" name="DT" onclick="fn_dftTyp('DT')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" id='def_type_id' name='def_type_id' placeholder="" class="" /> <input type="text" title="" placeholder="" id='def_type_text' name='def_type_text' class="" disabled style="width: 60%;" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.text.sltCde' /><span id='m13' name='m13' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="" class="" disabled="disabled" id='solut_code' name='solut_code' onblur="fn_getASReasonCode2(this, 'solut_code'  ,'337')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="SC" name="SC" onclick="fn_dftTyp('SC')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" class="" id='solut_code_id' name='solut_code_id' /> <input type="text" title="" placeholder="" class="" id='solut_code_text' name='solut_code_text' disabled style="width: 60%;" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.text.dtlDef' /><span id='m12' name='m12' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="" disabled="disabled" id='def_def' name='def_def' class="" onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DD" name="DD" onclick="fn_dftTyp('DD')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" /> <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' class="" disabled style="width: 60%;" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.text.defCde' /><span id='m10' name='m10' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="" disabled="disabled" id='def_code' name='def_code' class="" onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DC" name="DC" onclick="fn_dftTyp('DC')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" /> <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width: 60%;" /></td>
            </tr>
             <tr>
              <th scope="row"><spring:message code='service.text.defPrt' /><span id='m11' name='m11' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="" disabled="disabled" id='def_part' name='def_part' class="" onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DP" name="DP" onclick="fn_dftTyp('DP')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" /> <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' class="" disabled style="width: 60%;" /></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </dd>
      <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
      <!-- <dt class="click_add_on" id='inHouse_dt' onclick="fn_secChk(this);">
    <a href="#">In-House Repair Entry</a>
   </dt>
   <dd id='inHouseRepair_div' style="display: none">
    <table class="type1">
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
   </dd> -->
      <!-- ////////////////////////////////////////////in house repair////////////////////////////////// -->
    </dl>
  </article>
  <!-- acodi_wrap end -->
</form>
<script type="text/javascript">

</script>
