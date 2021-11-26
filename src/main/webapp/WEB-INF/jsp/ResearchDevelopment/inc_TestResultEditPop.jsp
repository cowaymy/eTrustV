<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var myFltGrd10;

  var failRsn;
  var errCde;
  var asMalfuncResnId;
  var currentStatus;
  var asRslt;
  var ops;

  $(document).ready(function() {


    //doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=336', '', '', 'ddlFilterExchangeCode', 'S', ''); // FILTER CHARGE EXCHANGE CODE
    doGetCombo('/services/as/getBrnchId', '', '', 'branchDSC', 'S', ''); // RECALL ENTRY DSC CODE
    doGetCombo('/services/as/inHouseGetProductMasters.do', '', '', 'productGroup', 'S', ''); // IN HOUSE PRODUCT GROUP


    var isF = true;

  });

  function trim(text) {
    return String(text).replace(/^\s+|\s+$/g, '');
  }

  function fn_setCTcodeValue() {
    $("#ddlCTCode").val($("#CTID").val());
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

    } else {
    }
  }

  // GET AS RESULT INFO
  function fn_getASRulstSVC0004DInfo() {
    Common.ajax("GET", "/services/as/getASRulstSVC0004DInfo", {
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val()
    }, function(result) {
      if (result != "") {
        // SUCCESS
        fn_setSVC0004dInfo(result);
      }
    });
  }

  function fn_setSVC0004dInfo(result) {
    currentStatus = result[0].asResultStusId; // SET BEFORE STATUS
    asRslt = result[0]; // SET 1ST IMAGE VALUE SET FOR LATER USE

    $("#ddlStatus").val(result[0].asResultStusId);

    $("#creator").val(result[0].c28); // CREATOR
    $("#creatorat").val(result[0].asResultCrtDt); // CREATE ON
    $("#txtResultNo").val(result[0].asResultNo);// REUSLT NO

    $("#dpSettleDate").val(result[0].asSetlDt); // SETTLE DATE
    $("#tpSettleTime").val(result[0].asSetlTm); // SETTLE TIME
    $("#ddlDSCCode").val(result[0].asBrnchId); // DCS BRANCH

    $("#ddlCTCode").val(result[0].c11);
    $("#ddlDSCCode").val(result[0].asBrnchId);
    $("#ddlCTCodeText").val(result[0].c12);
    $("#ddlDSCCodeText").val(result[0].c5);

    $("#txtTestResultRemark").val(result[0].asResultRem);

    $('#def_code').val(result[0].c18);
    $('#def_code_text').val(result[0].c19);
    $('#def_code_id').val(result[0].asDefectId);

    $('#def_def').val(result[0].c22);
    $('#def_def_text').val(result[0].c23);
    $('#def_def_id').val(result[0].asDefectDtlResnId);

    $('#def_part').val(result[0].c20);
    $('#def_part_text').val(result[0].c21);
    $('#def_part_id').val(result[0].asDefectPartId);


    var v = /^(\d+)([.]\d{0,2})$/;
    var regexp = new RegExp(v);

    var toamt = "0.00";
    var tWork = "0.00";
    var tFilterAmt = "0.00";

    toamt = result[0].asTotAmt;
    tWork = result[0].asWorkmnsh;
    tFilterAmt = result[0].asFilterAmt;

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


      } else {
        $("#" + _tobj + "_text").val("* No such detail of defect found.");

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


    if (typeof myGridID !== 'undefined') {
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

    $("#txtTestResultRemark").val(asRslt.asResultRem);

    $('#def_code').val(this.trim(asRslt.c18));
    $('#def_code_text').val(this.trim(asRslt.c19));
    $('#def_code_id').val(this.trim(asRslt.asDefectId));

    $('#def_def').val(this.trim(asRslt.c22));
    $('#def_def_text').val(this.trim(asRslt.c23));
    $('#def_def_id').val(this.trim(asRslt.asDefectDtlResnId));

    $('#def_part').val(this.trim(asRslt.c20));
    $('#def_part_text').val(this.trim(asRslt.c21));
    $('#def_part_id').val(this.trim(asRslt.asDefectPartId));

    $("#appDate").val("");
    $("#CTSSessionCode").val("");
    $("#branchDSC").val("");

    $("#CTCode").val("");
    $("#CTGroup").val("");
    $("#callRem").val("");

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
      $('#txtTestResultRemark').attr("disabled", true);

      $('#def_code').attr("disabled", true);
      $('#def_part').attr("disabled", true);
      $('#def_def').attr("disabled", true);

      $('#DC').hide();
      $('#DP').hide();
      $('#DD').hide();

    } else {
      $("#btnSaveDiv").show()
      $("#addDiv").show();

      $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
      $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");
      $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
      $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");
      $('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");

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
    $("#txtTestResultRemark").val("");
    $("#txtTestResultRemark").attr("disabled", "disabled");

    if (this.ops.MOD == "RESULTVIEW") {
      $("#btnSaveDiv").hide();
      $('#txtTestResultRemark').attr("disabled", true);

      $('#appDate').attr("disabled", true);
      $('#CTGroup').attr("disabled", true);
      $('#callRem').attr("disabled", true);
    } else {
      $("#btnSaveDiv").show();

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

      $("#appDate").attr("disabled", true);
      $("#CTSSessionCode").attr("disabled", true);
      $("#branchDSC").attr("disabled", true);
      $("#CTCode").attr("disabled", true);
      $("#CTGroup").attr("disabled", true);
      $("#callRem").attr("disabled", true);

      $("#def_code").attr("disabled", true);
      $("#def_code_text").attr("disabled", true);
      $("#def_part").attr("disabled", true);
      $("#def_part_text").attr("disabled", true);
      $("#def_def").attr("disabled", true);
      $("#def_def_text").attr("disabled", true);

      $("#promisedDate").attr("disabled", true);
      $("#productGroup").attr("disabled", true);
      $("#productCode").attr("disabled", true);
      $("#serialNo").attr("disabled", true);
      $("#inHouseRemark").attr("disabled", true);
      $("#inHouseRepair_div").attr("style", "display:none");
    } else {
      $('#dpSettleDate').val("").attr("disabled", true);
      $('#tpSettleTime').val("").attr("disabled", true);

      $("#appDate").val("");
      $("#CTSSessionCode").val("");
      $("#branchDSC").val("");
      $("#CTCode").val("");
      $("#CTGroup").val("");
      $("#callRem").val("");

      $("#def_code").val("").attr("disabled", true);
      $("#def_code_id").val("");
      $("#def_code_text").val("").attr("disabled", true);
      $("#def_part").val("").attr("disabled", true);
      $("#def_part_id").val("");
      $("#def_part_text").val("").attr("disabled", true);
      $("#def_def").val("").attr("disabled", true);
      $("#def_def_text").val("");
      $("#def_def_text").val("").attr("disabled", true);

      $("#btnSaveDiv").show();
      $('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");

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
      $('#txtTestResultRemark').attr("disabled", true);
    } else {
      $("#btnSaveDiv").show();
      $('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");
    }
  }

  function fn_clearPageField() {
    $("#btnSaveDiv").attr("style", "display:none");
    $("#addDiv").attr("style", "display:none");

    $('#dpSettleDate').val("").attr("disabled", true);
    $('#tpSettleTime').val("").attr("disabled", true);
    $('#ddlDSCCode').val("").attr("disabled", true);
    $('#ddlCTCode').val("").attr("disabled", true);
    $('#txtTestResultRemark').val("").attr("disabled", true);

    if ($("#ddlStatus").val() == '10') { // CANCEL

      $("#def_code").val("").attr("disabled", true);
      $("#def_code_id").val("");
      $("#def_code_text").val("").attr("disabled", true);

      $("#def_part").val("").attr("disabled", true);
      $("#def_part_id").val("");
      $("#def_part_text").val("").attr("disabled", true);

      $("#def_def").val("").attr("disabled", true);
      $("#def_def_text").val("");
      $("#def_def_text").val("").attr("disabled", true);

    }
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
    //fn_chkPmtMap() // CHECK PAYMENT MAPPING
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

        if (FormUtil.checkReqValue($("#txtTestResultRemark"))) {
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

        if (FormUtil.checkReqValue($("#txtTestResultRemark"))) {
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

  function fn_setSaveFormData() {
    var allRowItems = AUIGrid.getGridData(myFltGrd10);
    var addedRowItems = AUIGrid.getAddedRowItems(myFltGrd10);
    var editedRowItems = AUIGrid.getEditedRowColumnItems(myFltGrd10);
    var removedRowItems = AUIGrid.getRemovedItems(myFltGrd10);

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
      AS_BRNCH_ID : $('#ddlDSCCode').val(),
      AS_RESULT_REM : $('#txtTestResultRemark').val(),

      // AS RECALL ENTRY
      AS_APP_DT : $("#appDate").val(),
      AS_APP_SESS : $("#CTSSessionCode").val(),
      AS_RCL_ASG_DSC : $("#branchDSC").val(),
      AS_RCL_ASG_CT : $("#CTCode").val(),
      AS_RCL_ASG_CT_GRP : $("#CTGroup").val(),
      AS_RCL_RMK : $("#callRem").val(),

      // AS DEFECT ENTRY
      AS_DEFECT_GRP_ID : 0,
      AS_DEFECT_ID : $('#ddlStatus').val() == 4 ? $('#def_code_id').val() : '0',
      AS_DEFECT_PART_GRP_ID : 0,
      AS_DEFECT_PART_ID : $('#ddlStatus').val() == 4 ? $('#def_part_id').val() : '0',
      AS_DEFECT_DTL_RESN_ID : $('#ddlStatus').val() == 4 ? $('#def_def_id').val() : '0',

      // OTHER
      AS_RESULT_NO : $('#asData_AS_RESULT_NO').val(),
      AS_RESULT_ID : $('#asData_AS_RESULT_ID').val(),
      AS_NO : asDataInfo[0].asNo,
      AS_ID : asDataInfo[0].asId,
      ACC_BILL_ID : asDataInfo[0].c19,
      ACC_INVOICE_NO : asDataInfo[0].c20,
      TAX_INVOICE_CUST_NAME : $("#txtCustName").text(),
      TAX_INVOICE_CONT_PERS : $("#txtContactPerson").text(),

      productCode : "",
      productName : "",
      serialNo : "",
      IN_HUSE_REPAIR_REM : "",
      IN_HUSE_REPAIR_REPLACE_YN : 0,
      IN_HUSE_REPAIR_PROMIS_DT : "",
      IN_HUSE_REPAIR_GRP_CODE : "",
      IN_HUSE_REPAIR_PRODUCT_CODE : "",
      IN_HUSE_REPAIR_SERIAL_NO : "",
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
          "remove" : removedRowItems
        }

        Common.ajax("POST", "/services/as/newResultAdd.do", saveForm, function(result) {
          if (result.asNo != "") {
            Common.alert("<spring:message code='service.msg.updSucc'/>");
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
  }

  function fn_asResult_editPageContral(_type) {

    $("#btnSaveDiv").attr("style", "display:inline");
    $("#addDiv").attr("style", "display:inline");

    $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
    $('#tpSettleTime').removeAttr("disabled").removeClass("readonly");
    $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
    $('#ddlCTCode').removeAttr("disabled").removeClass("readonly");
    $('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");

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

    //fn_getASRulstEditFilterInfo(); //AS_RESULT_NO
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
      $('#tpSettleTime').attr("disabled", true);
      $('#ddlDSCCode').attr("disabled", true);

      $('#ddlCTCode').attr("disabled", true);
      $('#txtTestResultRemark').attr("disabled", true);

      $('#def_code').attr("disabled", true);
      $('#def_part').attr("disabled", true);
      $('#def_def').attr("disabled", true);

      $('#def_code_text').attr("disabled", true);
      $('#def_part_text').attr("disabled", true);
      $('#def_def_text').attr("disabled", true);
    }
  }

  function fn_errCallbackFun() {
    fn_getASRulstSVC0004DInfo();
  }



  function fn_secChk(obj) {

    if (obj.id == "defEvt_dt" || obj.id == "chrFee_dt") {
      if ($("#ddlStatus").val() != '4') {
        Common.alert("This section only applicable for <b>Complete</b> status");
        return;
      }
    }
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
      dtCde : dtCde
    }, null, true);
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

  function validate(evt) {
      var theEvent = evt || window.event;

      // Handle paste
      if (theEvent.type === 'paste') {
          key = event.clipboardData.getData('text/plain');
      } else {
          // Handle key press
          var key = theEvent.keyCode || theEvent.which;
          key = String.fromCharCode(key);
      }
      var regex = /[0-9]|\./;
      if (!regex.test(key)) {
          theEvent.returnValue = false;
          if (theEvent.preventDefault)
              theEvent.preventDefault();
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
                </div> <span id='reminder' style="color: red; font-style: italic;  display: none">
                <spring:message code='service.alert.msg.AsEditPrdChk' /></span>
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
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.DSCCode' /><span id='m5' name='m5' class="must" style="display: none">*</span></th>
              <td><input type="hidden" title="" placeholder="" class="" id='ddlDSCCode' name='ddlDSCCode' value='${BRANCH_ID}' /> <input type="text" title="" placeholder="" class="readonly w100p" id='ddlDSCCodeText' name='ddlDSCCodeText' value='${BRANCH_NAME}' /></td>
              <th scope="row"><spring:message code='service.grid.CTCode' /><span id='m7' name='m7' class="must" style="display: none">*</span></th>
              <td><input type="hidden" title="" placeholder="ddlCTCode" class="" id='ddlCTCode' name='ddlCTCode' /> <input type="text" title="" placeholder="" class="readonly w100p" id='ddlCTCodeText' name='ddlCTCodeText' /> </td>
                </select></td>
            </tr>
             <tr>
                <th scope="row">AMP Reading<span id='m7' name='m7' class="must" style="display: none">*</span></th>
                <td><input  disabled="disabled" type="text" title="" placeholder="AMP Reading" class="" id='txtAMPReading' name='txtAMPReading' onkeypress='validate(event)' /></td>
                <th scope="row">Voltage<span id='m7' name='m7' class="must" style="display: none">*</span></th>
                <td><input  disabled="disabled" type="text" title="" placeholder="Voltage" class="" id='txtVoltage' name='txtVoltage' onkeypress='validate(event)' /></td>
            </tr>
            <tr>
            <th scope="row">Product Genuine<span id='m5' name='m5' class="must" style="display: none">*</span></th>
              <td><select disabled="disabled" id='ddlProdGenuine' name='ddlProdGenuine' class="w100p"></select></td>
              <th></th>
            <td></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.title.Remark' /><span id='m14' name='m14' class="must">*</span></th>
              <td colspan="3"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />" id='txtTestResultRemark' name='txtTestResultRemark'></textarea></td>
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
              <th scope="row"><spring:message code='service.text.defPrt' /><span id='m11' name='m11' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="" disabled="disabled" id='def_part' name='def_part' class="" onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DP" name="DP" onclick="fn_dftTyp('DP')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" /> <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' class="" disabled style="width: 60%;" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.text.dtlDef' /><span id='m12' name='m12' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="" disabled="disabled" id='def_def' name='def_def' class="" onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DD" name="DD" onclick="fn_dftTyp('DD')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" /> <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' class="" disabled style="width: 60%;" /></td>
            </tr>
            <tr>
              <th scope="row"><spring:message code='service.text.defCde' /><span id='m10' name='m10' class="must" style="display: none">*</span></th>
              <td><input type="text" title="" placeholder="" disabled="disabled" id='def_code' name='def_code' class="" onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();" /> <a class="search_btn" id="DC" name="DC" onclick="fn_dftTyp('DC')"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" /> <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width: 60%;" /></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </dd>
      </dl>
  </article>
  <!-- acodi_wrap end -->
</form>
<script type="text/javascript">

</script>
