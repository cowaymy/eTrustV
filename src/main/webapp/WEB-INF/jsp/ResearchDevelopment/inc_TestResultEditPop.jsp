<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
  var myFltGrd10;

  var failRsn;
  var errCde;
  var asMalfuncResnId;
  var currentStatus;
  var PEXRslt;
  var ops;

  $(document).ready(function() {


  });

  function trim(text) {
    return String(text).replace(/^\s+|\s+$/g, '');
  }

  function fn_setCTcodeValue() {
    $("#ddlCTCode").val($("#CTID").val());
  }

  // GET AS RESULT INFO
  function fn_getPEXTestResultInfo() {
    Common.ajax("GET", "/ResearchDevelopment/getPEXTestResultInfo", {
    	TEST_RESULT_NO : $('#PEXData_TEST_RESULT_NO').val()
    }, function(result) {
      if (result != "") {
        // SUCCESS
        fn_setPEXTestResultInfo(result);
      }
    });
  }

  function fn_setPEXTestResultInfo(result) {

    currentStatus = result[0].testResultStus; // SET BEFORE STATUS
    PEXRslt = result[0]; // SET 1ST IMAGE VALUE SET FOR LATER USE

    console.log(result[0]);

    $("#creator").val(result[0].updUserId);
    $("#creatorat").val(result[0].updDt);
    $("#txtResultNo").val(result[0].testResultNo);
    $("#ddlStatus").val(result[0].testResultStus);

    $("#dpSettleDate").val(result[0].testSettleDt);
    $("#tpSettleTime").val(result[0].testSettleTime);

    $("#ddlDSCCode").val(result[0].dscId);
    $("#ddlDSCCodeText").val(result[0].dscCode);

    $("#ddlCTCodeText").val(result[0].ctCode);
    $("#ddlCTCode").val(result[0].ctId);
    $("#CTID").val(result[0].ctId);

    $("#txtAMPReading").val(result[0].amp);
    $("#txtVoltage").val(result[0].voltage);

    $("#ddlProdGenuine").val(result[0].prodGenuine);

    $("#txtTestResultRemark").val(result[0].testResultRem);

    $('#def_part').val(result[0].defLargeCode);
    $('#def_part_text').val(result[0].defectPartLarge);
    $('#def_part_id').val(result[0].defLargeId);

    $('#def_def').val(result[0].probLargeCode);
    $('#def_def_text').val(result[0].problemSymptomLarge);
    $('#def_def_id').val(result[0].probLargeId);

    $('#def_code').val(result[0].probSmallCode);
    $('#def_code_text').val(result[0].problemSymptomSmall);
    $('#def_code_id').val(result[0].probSmallId);

   $("#PROD_CDE").val(result[0].prodCde);

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

  function fn_ddlStatus_SelectedIndexChanged() {

    switch ($("#ddlStatus").val()) {
    case "4":
      //COMPLETE
      fn_openField_Complete();
      $("#defEvt_div").attr("style", "display:block");
      break;
    case "1":
      // ACTIVE
      fn_openField_Complete();
      $("#defEvt_div").attr("style", "display:block");
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

      break;
    }
  }

  function fn_openField_Complete() {
    failRsn = "";

    // SET BACK DATA TO EACH FIELD
         $("#creator").val(PEXRslt.updUserId);
         $("#creatorat").val(PEXRslt.updDt);
         $("#txtResultNo").val(PEXRslt.testResultNo);
         $("#ddlStatus").val(PEXRslt.testResultStus);

         $("#dpSettleDate").val(PEXRslt.testSettleDt);
         $("#tpSettleTime").val(PEXRslt.testSettleTime);

         $("#ddlDSCCode").val(PEXRslt.dscId);
         $("#ddlDSCCodeText").val(PEXRslt.dscCode);

         $("#ddlCTCodeText").val(PEXRslt.ctCode);
         $("#ddlCTCode").val(PEXRslt.ctId);
         $("#CTID").val(PEXRslt.ctId);

         $("#txtAMPReading").val(PEXRslt.amp);
         $("#txtVoltage").val(PEXRslt.voltage);

         $("#ddlProdGenuine").val(PEXRslt.prodGenuine);

         $("#txtTestResultRemark").val(PEXRslt.testResultRem);

        $('#def_part').val(this.trim(PEXRslt.defLargeCode));
        $('#def_part_text').val(this.trim(PEXRslt.defectPartLarge));
        $('#def_part_id').val(this.trim(PEXRslt.defLargeId));

        $('#def_code').val(this.trim(PEXRslt.probLargeCode));
        $('#def_code_text').val(this.trim(PEXRslt.problemSymptomLarge));
        $('#def_code_id').val(this.trim(PEXRslt.probLargeId));

        $('#def_def').val(this.trim(PEXRslt.probSmallCode));
        $('#def_def_text').val(this.trim(PEXRslt.problemSymptomSmall));
        $('#def_def_id').val(this.trim(PEXRslt.probSmallId));

        $("#PROD_CDE").val(PEXRslt.prodCde);

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

      $("#btnSaveDiv").hide()
      $("#addDiv").hide();

      $('#dpSettleDate').attr("disabled", true);
      $('#tpSettleTime').attr("disabled", true);
      $('#ddlDSCCode').attr("disabled", true);
      $('#ddlCTCode').attr("disabled", true);
      $('#txtAMPReading').attr("disabled", true);
      $('#txtVoltage').attr("disabled", true);
      $('#ddlProdGenuine').attr("disabled", true);
      $('#txtTestResultRemark').attr("disabled", true);

      $('#def_code').attr("disabled", true);
      $('#def_part').attr("disabled", true);
      $('#def_def').attr("disabled", true);

      $('#DC').hide();
      $('#DP').hide();
      $('#DD').hide();


  }

  function fn_clearPageField() {
    $("#btnSaveDiv").attr("style", "display:none");
    $("#addDiv").attr("style", "display:none");

    $('#dpSettleDate').val("").attr("disabled", true);
    $('#tpSettleTime').val("").attr("disabled", true);
    $('#ddlDSCCode').val("").attr("disabled", true);
    $('#ddlCTCode').val("").attr("disabled", true);
    $('#txtAMPReading').val("").attr("disabled", true);
    $('#txtVoltage').val("").attr("disabled", true);
    $('#ddlProdGenuine').val("").attr("disabled", true);
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

  function fn_validRequiredField_Save_DefectiveInfo() {
    var rtnMsg = "";
    var rtnValue = true;

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

    if (rtnValue == false) {
      Common.alert(rtnMsg);
    }
    return rtnValue;
  }

  function fn_asResult_viewPageContral() {
    $("#PEXResultForm").find("input, textarea, button, select").attr("disabled", true);
  }

  function fn_setPEXDataInit(ops) {
    this.ops = ops;
    $("#PEXData_TEST_RESULT_ID").val(ops.TEST_RESULT_ID);
    $("#PEXData_TEST_RESULT_NO").val(ops.TEST_RESULT_NO);
    $("#PEXData_SO_EXCHG_ID").val(ops.SO_EXCHG_ID);
    $("#requestMod").val(ops.MOD);

    //fn_getASRulstEditFilterInfo(); //AS_RESULT_NO
     fn_getPEXTestResultInfo(); //AS_RESULT_NO
    // fn_setCTcodeValue();

    // AS EDIT
    if (ops.MOD == "RESULTEDIT") {
      //fn_getErrMstList('${ORD_NO}', 'fn_errCallbackFun');
      fn_errCallbackFun();
      fn_HasFilterUnclaim();

    } else if (ops.MOD == "RESULTVIEW") {
      //fn_getErrMstList('${ORD_NO}', 'fn_errCallbackFun');
      fn_errCallbackFun();

      $("#PEXResultForm").find("input, textarea, button, select").attr("disabled", true);
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
    fn_getPEXTestResultInfo();
  }



  function fn_secChk(obj) {

    if (obj.id == "defEvt_dt" || obj.id == "chrFee_dt") {
      if ($("#ddlStatus").val() != '4') {
        Common.alert("This section only applicable for <b>Complete</b> status");
        return;
      }
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
<form id="asDataForm" method="post">
  <div style='display: none'>
    <input type="text" id='PEXData_TEST_RESULT_ID' name='PEXData_TEST_RESULT_ID' />
    <input type="text" id='PEXData_SO_EXCHG_ID' name='PEXData_SO_EXCHG_ID' />
    <input type="text" id='PEXData_TEST_RESULT_NO' name='PEXData_TEST_RESULT_NO' />
    <input type="text" id='requestMod' name='requestMod' />
  </div>
</form>
<form id="PEXResultForm" method="post">
  <article class="acodi_wrap">
    <!-- acodi_wrap start -->
    <dl>
      <dt class="click_add_on on">
        <a href="#">PEX Test Result Detail</a>
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
              <th scope="row"><spring:message code='service.grid.ResultNo' /></th>
              <td><input type="text" title="" placeholder="" class="w100p" id='txtResultNo' name='txtResultNo' disabled /></td>
              <th scope="row"><spring:message code='sys.title.status' /><span id='m1' name='m1' class="must">*</span></th>
              <td><select class="w100p" id="ddlStatus" name="ddlStatus" onChange="fn_ddlStatus_SelectedIndexChanged()">
                  <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                  <c:forEach var="list" items="${asCrtStat}" varStatus="status">
                    <option value="${list.codeId}">${list.codeName}</option>
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
              <td><select  disabled="disabled" id='ddlProdGenuine' name='ddlProdGenuine' class="w100p">
                <option value="">Choose One</option>
                <option value="G">Genuine</option>
                <option value="NG">Non-Genuine</option>
                </select></td>
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
        <a href="#">PEX Defect Entry</a>
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
