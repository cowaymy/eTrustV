<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP AND APPOINMENT DATE
 07/05/2019  ONGHC  1.0.1          FIX ERROR MESSAGE ISSUE
 26/04/2019  ONGHC  1.0.2          ADD RECALL STATUS
 17/09/2019  ONGHC  1.0.3          AMEND DEFECT DETAIL SECTION
 08/10/2019  ONGHC  1.0.4          AMEND SAVE FUNCTION TO ADD 1 PARAM AS_ENTRY_ID
 26/02/2020  ONGHC  1.0.5          AMEND FOR LPM
 28/02/2020  ONGHC  1.0.6          AMEND fn_loadDftCde
 30/09/2020  FARUQ   1.0.7         Default value for DP,DD,DC,DT,SC when certain err description
 -->
<!-- AS ORDER > AS MANAGEMENT > EDIT BASIC AS ENTRY -->
<script type="text/javaScript">
  var regGridID;
  var myFltGrd10;

  var productCode;
  var asMalfuncResnId;

  var failRsn;

  var errMsg;

  $(document).ready(function() {
    createAUIGrid();

    AUIGrid.bind(myFltGrd10, "addRow", auiAddRowHandler);
    AUIGrid.bind(myFltGrd10, "removeRow", auiRemoveRowHandler);

    //doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=166', '', '', 'ddlFailReason', 'S', '');
    //doGetCombo('/services/as/inHouseGetProductMasters.do', '', '', 'productGroup', 'S', ''); // FOR INHOUSE REPAIR

    //doGetCombo('/services/as/getASMember.do', '', '','ddlCTCode', 'S' , 'fn_setCTcodeValue');
    //doGetCombo('/services/as/getBrnchId.do', '', '','ddlDSCCode', 'S' , '');
    //doGetCombo('/services/as/getASFilterInfo.do', '', '','ddlFilterCode', 'S' , '');  // Customer Type Combo Box
    //doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '','ddlFilterExchangeCode', 'S' , '');

    fn_getASOrderInfo();
    fn_getASEvntsInfo();
    fn_getASHistoryInfo();
    setTimeout(function() {
      fn_errDescCheck(0)
    }, 1000);

    //fn_getASRulstEditFilterInfo();

  });

  function fn_getErrMstList(_ordNo) {
    $("#ddlErrorCode option").remove();
    doGetCombo('/services/as/getErrMstList.do?SALES_ORD_NO=' + _ordNo, '', '', 'ddlErrorCode', 'S', 'fn_setErrMsg');
    fn_getASRulstSVC0004DInfo();
  }

  function fn_setErrMsg() {
    $("#ddlErrorCode").val(errMsg);
  }

  function fn_errMst_SelectedIndexChanged() {
    $("#ddlErrorDesc option").remove();
    doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE=' + $("#ddlErrorCode").val(), '', '', 'ddlErrorDesc', 'S', '');
  }

  function fn_callback_ddlErrorDesc() {
    $("#ddlErrorDesc").val(asMalfuncResnId);
  }

  function fn_setCTcodeValue() {
    $("#ddlCTCode").val($("#CTID").val());
  }

  function fn_getASRulstEditFilterInfo() {
    Common.ajax("GET", "/services/as/getASRulstEditFilterInfo", $("#resultASForm").serialize(), function(result) {
      AUIGrid.setGridData(myFltGrd10, result);
    });
  }

  function fn_getASRulstSVC0004DInfo() {
    Common.ajax("GET", "/services/as/getASRulstSVC0004DInfo", $("#resultASForm").serialize(), function(result) {
      if (result != "") {
        fn_setSVC0004dInfo(result);
      }
    });
  }

  function fn_setSVC0004dInfo(result) {
    $("#creator").val(result[0].c28);
    $("#creatorat").val(result[0].asResultCrtDt);
    $("#txtResultNo").val(result[0].asResultNo);
    $("#ddlStatus").val(result[0].asResultStusId);
    $("#dpSettleDate").val(result[0].asSetlDt);
    //$("#ddlFailReason").val(result[0].c2);
    failRsn = result[0].c2
    $("#tpSettleTime").val(result[0].asSetlTm);
    $("#ddlErrorCode").val(result[0].asMalfuncId);
    //$("#ddlErrorDesc").val(result[0].asMalfuncResnId);
    // TEMP. KEEP
    errMsg = result[0].asMalfuncId;
    asMalfuncResnId = result[0].asMalfuncResnId;

    if (result[0].asMalfuncId != "") {
      $("#ddlErrorDesc option").remove();
      doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE=' + result[0].asMalfuncId, '', '', 'ddlErrorDesc', 'S', 'fn_callback_ddlErrorDesc');
    }

    $("#psiRcd").val(result[0].psi);
    $("#lpmRcd").val(result[0].lpm);

    /*
    $("#ddlDSCCode").val( result[0].asBrnchId);
    $("#ddlCTCodeText").val( result[0].c12);

    $("#ddlCTCode").val( result[0].c11);
     */

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    $("#ddlCTCode").val(selectedItems[0].item.asMemId);
    $("#ddlDSCCode").val(selectedItems[0].item.asBrnchId);
    $("#ddlCTCodeText").val(selectedItems[0].item.memCode);
    $("#ddlDSCCodeText").val(selectedItems[0].item.brnchCode);
    $("#CTID").val(result[0].c11);

    $("#ddlWarehouse").val(result[0].asWhId);
    $("#txtRemark").val(result[0].asResultRem);

    if (result[0].c27 == "1") {
      $("#iscommission").attr("checked", true);
    }

    $('#def_type').val(String(result[0].c16).trim());
    $('#def_type_text').val(String(result[0].c17).trim());
    $('#def_type_id').val(String(result[0].asDefectTypeId).trim());

    $('#def_code').val(String(result[0].c18).trim());
    $('#def_code_text').val(String(result[0].c19).trim());
    $('#def_code_id').val(String(result[0].asDefectId).trim());

    $('#def_def').val(String(result[0].c22).trim());
    $('#def_def_text').val(String(result[0].c23).trim());
    $('#def_def_id').val(String(result[0].asDefectDtlResnId).trim());

    $('#def_part').val(String(result[0].c20).trim());
    $('#def_part_text').val(String(result[0].c21).trim());
    $('#def_part_id').val(String(result[0].asDefectPartId).trim());

    $('#solut_code').val(String(result[0].c25).trim());
    $('#solut_code_text').val(String(result[0].c26).trim());
    $('#solut_code_id').val(String(result[0].c24).trim());

    fn_ddlStatus_SelectedIndexChanged();

    /*if (result[0].c25 == "B8" || result[0].c25 == "B6") {
      $("#inHouseRepair_div").attr("style", "display:inline");
    }

    if (result[0].inHuseRepairReplaceYn == "1") {
      $("input:radio[name='replacement']:radio[value='1']").attr('checked', true); // 원하는 값(Y)을 체크
    } else if (result[0].inHuseRepairReplaceYn == "0") {
      $("input:radio[name='replacement']:radio[value='0']").attr('checked', true); // 원하는 값(Y)을 체크
    }

    $("#promisedDate").val(result[0].inHuseRepairPromisDt);
    $("#productGroup").val(result[0].inHuseRepairGrpCode);
    $("#productCode").val(result[0].inHuseRepairProductCode);
    $("#serialNo").val(result[0].inHuseRepairSerialNo);
    $("#inHouseRemark").val(result[0].inHuseRepairRem);
    $("#APPNT_DT").val(result[0].appntDt);
    $("#asResultCrtDt").val(result[0].asResultCrtDt);

    productCode = result[0].inHuseRepairProductCode;

    if (typeof (productCode) != "undefined") {
      doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + result[0].inHuseRepairGrpCode, '', '', 'productCode', 'S', 'fn_inHouseGetProductDetails');
    }

    if (result[0].c25 == "B8") { //인하우스 데이터만 수정 가능함.
    }*/

  }

  function fn_inHouseGetProductDetails() {
    $("#productCode").val(productCode);
  }

  function auiAddRowHandler(event) {
  }

  function auiRemoveRowHandler(event) {
  }

  function createAUIGrid() {
    var columnLayout = [
        {
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
          dataField : "asCrtDt",
          headerText : "<spring:message code='service.grid.ReqstDt'/>",
          width : 100,
          editable : false,
          dataType : "date",
          formatString : "dd/mm/yyyy"
        }, {
          dataField : "asStelDt",
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
        }];

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
            }
          }
        }, {
          dataField : "filterID",
          headerText : "filterID",
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

  function fn_errDescCheck(ind) {
    //(_method, _url, _jsonObj, _callback, _errcallback, _options, _header)
    var indicator = ind;
    var jsonObj = {
      errCd : $("#ddlErrorCode").val(),
      errDesc : $("#ddlErrorDesc").val(),
      type : "DP"
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
      $("#txtInstallAddress").text(result[0].instCntName);

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

      $("#PROD_CDE").val(result[0].stockCode);

      // KR-OHK Serial Check
      $("#pItmCode").val(result[0].stockCode);

      $("#PROD_CAT").val(result[0].c2code);

      fn_getErrMstList(result[0].ordNo);
    });
  }

  function fn_getASEvntsInfo() {
    Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultASForm").serialize(), function(result) {

      $("#txtASStatus").text(result[0].code);
      $("#txtRequestDate").text(result[0].asReqstDt);
      $("#txtRequestTime").text(result[0].asReqstTm);

      $("#txtAppDt").text(result[0].asAppntDt);
      $("#txtAppTm").text(result[0].asAppntTm);

      //$("#txtMalfunctionCode").text('에러코드 정의값');
      //$("#txtMalfunctionReason").text('에러코드 desc');

      $("#txtMalfunctionCode").text(result[0].asMalfuncId);
      $("#txtMalfunctionReason").text(result[0].asMalfuncResnId);

      $("#txtDSCCode").text(result[0].c7 + "-" + result[0].c8);
      $("#txtInchargeCT").text(result[0].c10 + "-" + result[0].c11);
      $("#txtRequestor").text(result[0].c3);
      $("#txtASKeyBy").text(result[0].c1);
      $("#txtRequestorContact").text(result[0].asRemReqsterCntc);
      $("#txtASKeyAt").text(result[0].asCrtDt);

      // KR-OHK Serial Check
      $("#hidSerialRequireChkYn").val(result[0].serialRequireChkYn);
      if ($("#hidSerialRequireChkYn").val() == 'Y') {
        $("#btnSerialEdit").attr("style", "");
      }
    });
  }

  function fn_getASHistoryInfo() {
    Common.ajax("GET", "/services/as/getASHistoryInfo.do", $("#resultASForm").serialize(), function(result) {
      AUIGrid.setGridData(regGridID, result);
    });
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
      } else {
        $("#" + _tobj + "_text").val("* No such detail of defect found.");
      }
    });

  }

  function getASStockPrice(_PRC_ID) {
    var ret = 0;
    Common.ajaxSync("GET", "/services/as/getASStockPrice.do", {
      PRC_ID : _PRC_ID
    }, function(result) {
      try {
        ret = parseInt(result[0].amt, 10);
      } catch (e) {
        alert('SAL0016M no data ');
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

    fn_setSaveFormData();
  }

  function fn_setSaveFormData() {
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
      // GENERAL
      AS_MALFUNC_ID : $('#ddlErrorCode').val(),
      AS_MALFUNC_RESN_ID : $('#ddlErrorDesc').val(),
      AS_RESULT_REM : $('#txtRemark').val(),
      AS_CMMS : $("#iscommission").prop("checked") ? '1' : '0',
      AS_FAIL_RSN : $('#ddlFailReason').val(),

      AS_ENTRY_ID : $('#AS_ID').val(),

      // AS RECALL ENTRY
      /*AS_APP_DT : $("#appDate").val(),
      AS_APP_SESS : $("#CTSSessionCode").val(),
      AS_RCL_ASG_DSC : $("#branchDSC").val(),
      AS_RCL_ASG_CT : $("#CTCode").val(),
      AS_RCL_ASG_CT_GRP : $("#CTGroup").val(),
      AS_RCL_RMK : $("#callRem").val(),*/

      // DEFECT ENTRY
      AS_DEFECT_TYPE_ID : $('#ddlStatus').val() == 4 ? $('#def_type_id').val() : '0',
      AS_DEFECT_ID : $('#ddlStatus').val() == 4 ? $('#def_code_id').val() : '0',
      AS_DEFECT_PART_ID : $('#ddlStatus').val() == 4 ? $('#def_part_id').val() : '0',
      AS_DEFECT_DTL_RESN_ID : $('#ddlStatus').val() == 4 ? $('#def_def_id').val() : '0',
      AS_SLUTN_RESN_ID : $('#ddlStatus').val() == 4 ? $('#solut_code_id').val() : '0',

      // IN HOUSE
      AS_RESULT_ID : $('#AS_RESULT_ID').val(),
      IN_HUSE_REPAIR_REM : $("#inHouseRemark").val(),
      IN_HUSE_REPAIR_REPLACE_YN : inHseRprInd,
      IN_HUSE_REPAIR_PROMIS_DT : $("#promisedDate").val(),
      IN_HUSE_REPAIR_GRP_CODE : $("#productGroup").val(),
      IN_HUSE_REPAIR_PRODUCT_CODE : $("#productCode").val(),
      IN_HUSE_REPAIR_SERIAL_NO : $("#serialNo").val(),
      AS_RESULT_STUS_ID : $("#ddlStatus").val(),
      AS_REPLACEMENT : $("#replacement:checked").val(),
      // KR-OHK Serial Check
      SERIAL_NO : $("#stockSerialNo").val(),
      AS_RESULT_NO : $('#txtResultNo').val(),
      AS_SO_ID : $("#ORD_ID").val()
    }

    var saveForm = {
      "asResultM" : asResultM
    }

    // KR-OHK Serial Check
    var url = "";
    if ($("#hidSerialRequireChkYn").val() == 'Y') {
      url = "/services/as/newResultBasicUpdateSerial.do";
    } else {
      url = "/services/as/newResultBasicUpdate.do";
    }

    Common.ajax("POST", url, saveForm, function(result) {
      if (result.asNo != "") {
        Common.alert("<spring:message code='service.msg.updSucc'/>");
        $("#_newASResultBasicDiv1").remove(); // CLOSE POP UP
        fn_searchASManagement();
      }
    });
  }

  function fn_editBasicPageContral() {

    $("#resultEditCreator").attr("style", "display:inline");
    $("#btnSaveDiv").attr("style", "display:inline");

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
    //$('#solut_code').removeAttr("disabled").removeClass("readonly");
    //$('#def_def').removeAttr("disabled").removeClass("readonly");
    $('#def_type_id').removeAttr("disabled").removeClass("readonly");
    $('#def_code_id').removeAttr("disabled").removeClass("readonly");
    $('#def_part_id').removeAttr("disabled").removeClass("readonly");
    $('#solut_code_id').removeAttr("disabled").removeClass("readonly");
    $('#def_def_id').removeAttr("disabled").removeClass("readonly");

    //$('#def_type_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_code_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_part_text').removeAttr("disabled").removeClass("readonly");
    //$('#solut_code_text').removeAttr("disabled").removeClass("readonly");
    //$('#def_def_text').removeAttr("disabled").removeClass("readonly");

    //$('#txtLabourch').removeAttr("disabled").removeClass("readonly");
    //$('#txtTotalCharge').removeAttr("disabled").removeClass("readonly");
    //$('#txtFilterCharge').removeAttr("disabled").removeClass("readonly");
    //$('#txtLabourCharge').removeAttr("disabled").removeClass("readonly");
    //$('#cmbLabourChargeAmt').removeAttr("disabled").removeClass("readonly");
    //$('#ddlFilterCode').removeAttr("disabled").removeClass("readonly");
    //$('#ddlFilterQty').removeAttr("disabled").removeClass("readonly");
    //$('#ddlFilterPayType').removeAttr("disabled").removeClass("readonly");
    //$('#ddlFilterExchangeCode').removeAttr("disabled").removeClass("readonly");
    //$('#txtFilterRemark').removeAttr("disabled").removeClass("readonly");

    //fn_clearPanelField_ASChargesFees();
  }

  function fn_DisablePageControl() {

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
    $("#txtFilterRemark").attr("disabled", true);

    $("#txtLabourch").attr("disabled", true);
    $("#txtLabourCharge").attr("disabled", true);
    $("#cmbLabourChargeAmt").attr("disabled", true);
    $("#txtFilterCharge").attr("disabled", true);
    $("#txtTotalCharge").attr("disabled", true);

    $("#btnSaveDiv").attr("style", "display:none");
    $("#addDiv").attr("style", "display:none");

    //fn_clearPanelField_ASChargesFees();

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

    // RETURN PRODUCT BACK TO FACTORY
    /*if ($("#solut_code_id").val() == "454") {
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
    }*/

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
          if (asno.match("AS")) {
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

        // KR-OHK Serial Check
        if ($("#hidSerialRequireChkYn").val() == 'Y' && FormUtil.checkReqValue($("#stockSerialNo"))) {
          rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Serial No' htmlEscape='false'/> </br>";
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

  function fn_doClear() {

    $("#ddlStatus").val("");
    $("#dpSettleDate").val("");
    $("#ddlFailReason").val("");
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

  function fn_productGroup_SelectedIndexChanged() {

    var STK_CTGRY_ID = $("#productGroup").val();

    if (STK_CTGRY_ID != null) {
      $("#serialNo").val("");
      $("#productCode option").remove();

      doGetCombo('/services/as/inHouseGetProductDetails.do?STK_CTGRY_ID=' + STK_CTGRY_ID, '', '', 'productCode', 'S', '');
    }
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
      console.log("inHouseIsAbStck.");
      //console.log(result);
      // var is =false;
      var is = true;

      if (result != null) {
        //var is =true;
        if (result.isStk != "0") {
          is = true;
        }
      }
      // if(is ==false )   $("#btnSaveDiv").attr("style","display:none");
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

    switch ($("#ddlStatus").val()) {
    case "4":
      // COMPLETE
      fn_openField_Complete();
      break;

    case "10":
      // CANCEL
      fn_openField_Cancel();
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
      break;
    }
  }

  function fn_callback_ddlFailRsn() {
    if (failRsn == 0) {
      failRsn = "";
    }
    $("#ddlFailReason").val(failRsn);
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
    //$('#solut_code').removeAttr("disabled").removeClass("readonly");
    //('#def_def').removeAttr("disabled").removeClass("readonly");

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
    //fn_clearPanelField_ASChargesFees();

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

    $("#iscommission").attr("disabled", "disabled");
    $("#def_type").attr("disabled", "disabled");
    $("#def_code").attr("disabled", "disabled");
    $("#def_part").attr("disabled", "disabled");
    $("#def_def").attr("disabled", "disabled");
    $("#solut_code").attr("disabled", "disabled");

    $("#dpSettleDate").val("");
    $("#tpSettleTime").val("");

    $("#txtLabourch").prop("checked", false);

    $('#ddlFailReason').removeAttr("disabled").removeClass("readonly");
    $('#txtRemark').removeAttr("disabled").removeClass("readonly");

    $("#btnSaveDiv").attr("style", "display:inline");
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
      dtCde : dtCde
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
      } else if (prgmCde == 'SC') {
        $("#solut_code").val(itm.code);
        $("#solut_code_id").val(itm.id);
        $("#solut_code_text").val(itm.descp);
      }
    }
  }

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
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <section id="content">
    <!-- content start -->
    <form id="serialNoChangeForm" name="serialNoChangeForm" method="POST">
      <input type="hidden" name="pSerialNo" id="pSerialNo" /> <input type="hidden" name="pSalesOrdId" id="pSalesOrdId" /> <input type="hidden" name="pSalesOrdNo" id="pSalesOrdNo" /> <input type="hidden" name="pRefDocNo" id="pRefDocNo" /> <input type="hidden" name="pItmCode" id="pItmCode" /> <input type="hidden" name="pCallGbn" id="pCallGbn" /> <input type="hidden" name="pMobileYn" id="pMobileYn" />
    </form>
    <form id="resultASForm" method="post">
      <div style="display: none">
        <input type="text" name="ORD_ID" id="ORD_ID" value="${ORD_ID}" /> <input type="text" name="ORD_NO" id="ORD_NO" value="${ORD_NO}" /> <input type="text" name="AS_NO" id="AS_NO" value="${AS_NO}" /> <input type="text" name="AS_ID" id="AS_ID" value="${AS_ID}" /> <input type="text" name="MOD" id="MOD" value="${MOD}" /> <input type="text" name="AS_RESULT_NO" id="AS_RESULT_NO" value="${AS_RESULT_NO}" /> <input type="text" name="AS_RESULT_ID" id="AS_RESULT_ID" value="${AS_RESULT_ID}" /> <input type="text" name="PROD_CDE" id="PROD_CDE" /> <input type="text" name="PROD_CAT" id="PROD_CAT" /> <input type="hidden" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" /> <input type="hidden" id='hidStockSerialNo' name='hidStockSerialNo' />
      </div>
    </form>
    <header class="pop_header">
      <!-- pop_header start -->
      <h1>
        <spring:message code='service.title.asEdtBscRst' />
      </h1>
      <ul class="right_opt">
        <li><p class="btn_blue2">
            <a href="#"><spring:message code='sys.btn.close' /></a>
          </p></li>
      </ul>
    </header>
    <!-- pop_header end -->
    <section class="pop_body">
      <!-- pop_body start -->
      <section class="tap_wrap">
        <!-- tap_wrap start -->
        <ul class="tap_type1">
          <li><a href="#" class="on"><spring:message code='service.title.General' /></a></li>
          <li><a href="#"><spring:message code='service.title.OrderInformation' /></a></li>
          <li><a href="#" onclick=" javascirpt:AUIGrid.resize(regGridID, 950,300);  "><spring:message code='service.title.asPassEvt' /></a></li>
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
                <td><span></span></td>
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
        <article class="tap_area">
          <!------------------------------------------------------------------------------
          Order Detail Page Include START
         ------------------------------------------------------------------------------->
          <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
          <!------------------------------------------------------------------------------
          Order Detail Page Include END
         ------------------------------------------------------------------------------->
        </article>
        <!-- tap_area end -->
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
            <div id="reg_grid_wrap" style="width: 100%;
  height: 300px;
  margin: 0 auto;"></div>
          </article>
          <!-- grid_wrap end -->
        </article>
        <!-- tap_area end -->
      </section>
      <!-- tap_wrap end -->
      <aside class="title_line">
        <!-- title_line start -->
        <h3 class="red_text">
          <spring:message code='service.msg.msgFillIn' />
        </h3>
      </aside>
      <!-- title_line end -->
      <article class="acodi_wrap">
        <!-- acodi_wrap start -->
        <dl>
          <!-- GENERAL -->
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
                  <td><input type="text" title="" placeholder="" class="readonly w100p" id='txtResultNo' name='txtResultNo' readonly /></td>
                  <th scope="row"><spring:message code='sys.title.status' /><span id='m1' name='m1' class="must">*</span></th>
                  <td><select class="w100p" id="ddlStatus" name="ddlStatus" class="readonly w100p" disabled="disabled" onChange="fn_ddlStatus_SelectedIndexChanged()">
                      <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                      <c:forEach var="list" items="${asCrtStat}" varStatus="status">
                        <option value="${list.codeId}">${list.codeName}</option>
                      </c:forEach>
                  </select></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.grid.SettleDate' /><span id='m2' name='m2' class="must">*</span></th>
                  <td><input type="text" title="Create start Date" class="readonly w100p" id='dpSettleDate' name='dpSettleDate' placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" /></td>
                  <th scope="row"><spring:message code='service.grid.FailReason' /><span id='m3' name='m3' class="must">*</span></th>
                  <td><select id='ddlFailReason' name='ddlFailReason' class="readonly w100p" disabled="disabled"></select></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.grid.SettleTm' /><span id='m4' name='m4' class="must">*</span></th>
                  <td>
                    <div class="time_picker">
                      <!-- time_picker start -->
                      <input type="text" title="" placeholder="" id='tpSettleTime' name='tpSettleTime' class="readonly time_date w100p" disabled="disabled" />
                      <ul>
                        <li><spring:message code='service.text.timePick' /></li>
                        <c:forEach var="list" items="${timePick}" varStatus="status">
                          <li><a href="#">${list.codeName}</a></li>
                        </c:forEach>
                      </ul>
                    </div> <!-- time_picker end -->
                  </td>
                  <th scope="row"><spring:message code='service.title.DSCCode' /><span id='m5' name='m5' class="must">*</span></th>
                  <td>
                    <!-- <select  disabled="disabled" id='ddlDSCCode' name='ddlDSCCode' >  </select>--> <!-- <input type="hidden" title="" placeholder="" class=""  id='ddlDSCCode' name='ddlDSCCode' value='${BRANCH_ID}'/>
               <input type="text" title=""    placeholder="" class="readonly"    id='ddlDSCCodeText' name='ddlDSCCodeText'  value='${BRANCH_NAME}'/> --> <input type="hidden" title="" placeholder="" class="" id='ddlDSCCode' name='ddlDSCCode' /> <input type="text" title="" placeholder="" class="readonly w100p" id='ddlDSCCodeText' name='ddlDSCCodeText' readonly />
                  </td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.grid.ErrCde' /><span id='m6' name='m6' class="must">*</span></th>
                  <td><select id='ddlErrorCode' name='ddlErrorCode' onChange="fn_errMst_SelectedIndexChanged()" class="w100p">
                  </select></td>
                  <th scope="row"><spring:message code='service.grid.CTCode' /><span id='m7' name='m7' class="must">*</span></th>
                  <td>
                    <!--
         <input type="hidden" title="" placeholder="" class=""  id='ddlCTCode' name='ddlCTCode' />
         <input type="text" title=""   placeholder="" class="readonly"     id='ddlCTCodeText' name='ddlCTCodeText'  />
         <input type="hidden" title="" placeholder="" class=""  id='CTID' name='CTID'/> --> <input type="hidden" title="" placeholder="" class="" id='ddlCTCode' name='ddlCTCode' /> <input type="text" title="" placeholder="" class="readonly w100p" id='ddlCTCodeText' name='ddlCTCodeText' readonly /> <input type="hidden" title="" placeholder="" class="" id='CTID' name='CTID' />
                  </td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.grid.ErrDesc' /><span id='m8' name='m8' class="must">*</span></th>
                  <td><select id='ddlErrorDesc' name='ddlErrorDesc' class="w100p" onChange="fn_errDescCheck(1)">
                  </select></td>
                  <th scope="row"><spring:message code='sal.title.warehouse' /></th>
                  <td><select class="readonly w100p" id='ddlWarehouse' name='ddlWarehouse' disabled="disabled">
                      <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                  </select></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.title.Remark' /></th>
                  <td colspan="3"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />" id='txtRemark' name='txtRemark'></textarea></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='sal.text.commission' /></th>
                  <td><label> <input type="checkbox" id='iscommission' name='iscommission' /> <span><spring:message code='sal.text.commissionApplied' /></span>
                  </label></td>
                  <th scope="row"><spring:message code='service.title.SerialNo' /><span class="must">*</span></th>
                  <td><input type="text" id='stockSerialNo' name='stockSerialNo' value="${orderDetail.basicInfo.lastSerialNo}" class="readonly" readonly />
                    <p class="btn_grid" style="display: none" id="btnSerialEdit">
                      <a href="#" onClick="fn_serialModifyPop()">EDIT</a>
                    </p></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.title.PSIRcd' /><span class="must" id="m15" style="display: none"> *</span></th>
                  <td><input type="text" title="" placeholder="<spring:message code='service.title.PSIRcd' />" class="w100p" id="psiRcd" name="psiRcd" disabled="disabled" onkeypress='validate(event)'/></td>
                  <th scope="row"><spring:message code='service.title.lmp' /><span class="must" id="m16" style="display: none"> *</span></th>
                  <td><input type="text" title="" placeholder="<spring:message code='service.title.lmp' />" class="w100p" id="lpmRcd" name="lpmRcd" disabled="disabled" onkeypress='validate(event)'/></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.grid.CrtBy' /></th>
                  <td><input type="text" title="" placeholder="" class="disabled w100p" disabled="disabled" id='creator' name='creator' /></td>
                  <th scope="row"><spring:message code='service.grid.CrtDt' /></th>
                  <td><input type="text" title="" placeholder="" class="disabled w100p" disabled="disabled" id='creatorat' name='creatorat' /></td>
                </tr>
              </tbody>
            </table>
            <!-- table end -->
          </dd>
          <!-- CALL LOG -->
          <!-- <dt class="click_add_on" id='recall_dt' onclick="fn_secChk(this);">
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
          <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " readonly="readonly" id="appDate" name="appDate" onChange="fn_doAllaction(this)"/>
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
           <input type="text" title="" placeholder="<spring:message code='service.grid.AssignCT' />" id="CTCode" name="CTCode" class="readonly w100p" readonly="readonly" onchange="fn_changeCTCode(this)" />
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
    </dd> -->
          <!-- DEFECTIVE EVENT -->
          <dt class="click_add_on on">
            <a href="#"><spring:message code='service.title.asDefEnt' /></a>
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
                  <th scope="row"><spring:message code='service.text.defPrt' /><span id='m11' name='m11' class="must" style="display: none">*</span></th>
                  <td><input type="text" title="" placeholder="" disabled="disabled" id='def_part' name='def_part' class="" onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DP" onclick="fn_dftTyp('DP')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" /> <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' class="" disabled style="width: 60%;" /></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.text.dtlDef' /><span id='m12' name='m12' class="must" style="display: none">*</span></th>
                  <td><input type="text" title="" placeholder="" disabled="disabled" id='def_def' name='def_def' class="" onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DD" onclick="fn_dftTyp('DD')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" /> <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' class="" disabled style="width: 60%;" /></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.text.defCde' /><span id='m10' name='m10' class="must" style="display: none">*</span></th>
                  <td><input type="text" title="" placeholder="" disabled="disabled" id='def_code' name='def_code' class="" onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DC" onclick="fn_dftTyp('DC')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" /> <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width: 60%;" /></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.text.defTyp' /><span id='m9' name='m9' class="must" style="display: none">*</span></th>
                  <td><input type="text" title="" id='def_type' name='def_type' placeholder="" disabled="disabled" class="" onblur="fn_getASReasonCode2(this, 'def_type' ,'387')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DT" onclick="fn_dftTyp('DT')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" id='def_type_id' name='def_type_id' placeholder="" class="" /> <input type="text" title="" placeholder="" id='def_type_text' name='def_type_text' class="" disabled style="width: 60%;" /></td>
                </tr>
                <tr>
                  <th scope="row"><spring:message code='service.text.sltCde' /><span id='m13' name='m13' class="must" style="display: none">*</span></th>
                  <td><input type="text" title="" placeholder="" class="" disabled="disabled" id='solut_code' name='solut_code' onblur="fn_getASReasonCode2(this, 'solut_code'  ,'337')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="SC" onclick="fn_dftTyp('SC')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" class="" id='solut_code_id' name='solut_code_id' /> <input type="text" title="" placeholder="" class="" id='solut_code_text' name='solut_code_text' disabled style="width: 60%;" /></td>
                </tr>
              </tbody>
            </table>
            <!-- table end -->
          </dd>
          <!-- NO FILTER CHARGE INVOLVE -->
          <!-- IN HOUSE REPAIR -->
          <!-- <dt class="click_add_on">
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
         <th scope="row">Replacement</th>
         <td><label> <input type="radio" id='replacement'
           name='replacement' value='1' /> Y <input type="radio"
           id='replacement' name='replacement' value='0' /> N
         </label></td>
         <th scope="row">PromisedDate</th>
         <td><input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="promisedDate"
          name="promisedDate" /></td>
        </tr>
        <tr>
         <th scope="row">ProductGroup</th>
         <td><select id='productGroup' name='productGroup'
          onChange="fn_productGroup_SelectedIndexChanged()">
         </select></td>
         <th scope="row">ProductCode</th>
         <td><select id='productCode' name='productCode'></select>
         </td>
        </tr>
        <tr>
         <th scope="row">SerialNo</th>
         <td colspan="3"><input type="text" id='serialNo'
          name='serialNo' onChange="fn_chSeriaNo()" /></td>
        </tr>
        <tr>
         <th scope="row">Remark</th>
         <td colspan="3"><textarea cols="20" rows="5"
           placeholder="" id='inHouseRemark' name='inHouseRemark'></textarea>
         </td>
        </tr>
       </tbody>
      </table>
     </dd> -->
          <!-- IN HOUSE REPAIR -->
        </dl>
      </article>
      <!-- acodi_wrap end -->
      <ul class="center_btns mt20">
        <li><p class="btn_blue2 big">
            <a href="#" onclick="fn_doSave()"><spring:message code='sys.btn.save' /></a>
          </p></li>
      </ul>
    </section>
    <!-- content end -->
  </section>
  <!-- content end -->
</div>
<!-- popup_wrap end -->
<script>

</script>