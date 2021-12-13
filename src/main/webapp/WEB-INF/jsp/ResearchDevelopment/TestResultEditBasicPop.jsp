<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!-- AS ORDER > AS MANAGEMENT > EDIT BASIC AS ENTRY -->
<script type="text/javaScript">
	var productCode;

	$(document).ready(function() {
		fn_getPEXTestResultInfo();
	});

	function fn_getPEXTestResultInfo() {
		Common.ajax("GET", "/ResearchDevelopment/getPEXTestResultInfo", $(
				"#resultPEXTestResultForm").serialize(), function(result) {
			if (result != "") {
				 console.log(result);
				fn_setPEXTestResultInfo(result);
			}
		});
	}

	function fn_setPEXTestResultInfo(result) {

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
				$("#" + _tobj + "_text")
						.val((result[0].resnDesc.trim()).trim());
				$("#" + _tobj + "_id").val(result[0].resnId);
			} else {
				$("#" + _tobj + "_text").val(
						"* No such detail of defect found.");
			}
		});

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

		var _PEX_DEFECT_ID = 0;
        var _PEX_DEFECT_PART_ID = 0;
        var _PEX_DEFECT_DTL_RESN_ID = 0;

        // DEFECT ENTRY
        if ($('#ddlStatus').val() == '4' || $('#ddlStatus').val() == '1') {
             _PEX_DEFECT_PART_ID = $('#def_part_id').val();
             _PEX_DEFECT_DTL_RESN_ID = $('#def_def_id').val();
             _PEX_DEFECT_ID = $('#def_code_id').val();

             console.log($('#def_part_id').val());
             console.log($('#def_def_id').val());
             console.log($('#def_code_id').val());
        }

		var PEXResultM = {
			// GENERAL
			TEST_RESULT_ID : $("#TEST_RESULT_ID").val(),
            TEST_RESULT_NO : $("#TEST_RESULT_NO").val(),
            //CT_ID : $('#ddlCTCode').val(),
            TEST_SETTLE_DT : $('#dpSettleDate').val(),
            TEST_SETTLE_TIME : $('#tpSettleTime').val(),
            TEST_RESULT_STUS : $('#ddlStatus').val(),
            AMP : $('#txtAMPReading').val(),
            VOLTAGE : $('#txtVoltage').val(),
            PROD_GENUINE : $('#ddlProdGenuine').val(),
            //AS_BRNCH_ID : $('#ddlDSCCode').val(),
            TEST_RESULT_REM : $('#txtTestResultRemark').val(),

            // PEX DEFECT ENTRY
            PEX_DEFECT_PART_ID : _PEX_DEFECT_PART_ID,
            PEX_DEFECT_DTL_RESN_ID : _PEX_DEFECT_DTL_RESN_ID, //_PEX_DEFECT_DTL_RESN_ID
            PEX_DEFECT_ID : _PEX_DEFECT_ID, //_PEX_DEFECT_ID

            // OTHER
            RCD_TMS : $("#RCD_TMS").val(),

		}

		var saveForm = {
			"PEXResultM" : PEXResultM
		}

		Common.ajax("POST", "/ResearchDevelopment/PEXTestResultUpdate.do", saveForm, function(result) {
			console.log(result);
			 if (result.data != "" && result.data != null && result.data != "null") {
				Common.alert("<spring:message code='service.msg.updSucc'/>");
				$("#_newPEXResultBasicDiv1").remove(); // CLOSE POP UP
				fn_searchPEXTestResult();
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
        $("#txtAMPReading").removeAttr("disabled").removeClass("readonly");
        $("#txtVoltage").removeAttr("disabled").removeClass("readonly");
        $("#ddlProdGenuine").removeAttr("disabled").removeClass("readonly");
		$('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");

		$('#def_code_id').removeAttr("disabled").removeClass("readonly");
		$('#def_part_id').removeAttr("disabled").removeClass("readonly");
		$('#def_def_id').removeAttr("disabled").removeClass("readonly");
	}

	function fn_DisablePageControl() {

		$("#dpSettleDate").attr("disabled", true);
		$("#ddlStatus").attr("disabled", true);
		$("#tpSettleTime").attr("disabled", true);
		$("#ddlDSCCode").attr("disabled", true);
		$("#ddlCTCode").attr("disabled", true);
		$("#txtAMPReading").attr("disabled", true);
	    $("#txtVoltage").attr("disabled", true);
	    $("#ddlProdGenuine").attr("disabled", true);
		$("#txtTestResultRemark").attr("disabled", true);

		$("#def_code").attr("disabled", true);
		$("#def_def").attr("disabled", true);
		$("#def_part").attr("disabled", true);

		$("#def_code_text").attr("disabled", true);
		$("#def_def_text").attr("disabled", true);
		$("#def_part_text").attr("disabled", true);

		$("#def_def_id").attr("disabled", true);
		$("#def_part").attr("disabled", true);

		$("#btnSaveDiv").attr("style", "display:none");
		$("#addDiv").attr("style", "display:none");

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
				} /* else {
					var PEXtestresultNo = $("#txtResultNo").val();

					var nowdate = $.datepicker.formatDate($.datepicker.ATOM, new Date());
					var nowdateArry = nowdate.split("-");
					nowdateArry = nowdateArry[0] + "" + nowdateArry[1] + "" + nowdateArry[2];
					var rdateArray = $("#dpSettleDate").val().split("/");
					var requestDate = rdateArray[2] + "" + rdateArray[1] + "" + rdateArray[0];

					if ((parseInt(requestDate, 10) - parseInt(nowdateArry,10)) > 14
						|| (parseInt(nowdateArry, 10) - parseInt(requestDate, 10)) > 14) {
						rtnMsg += "* Request date should not be longer than 14 days from current date.<br />";
						rtnValue = false;
					}
				} */
			}

			if (FormUtil.checkReqValue($("#tpSettleTime"))) {
				rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='Settle Time' htmlEscape='false'/> </br>";
				rtnValue = false;
			}

				if (FormUtil.checkReqValue($("#ddlDSCCode"))) {
					rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='DSC Code' htmlEscape='false'/> </br>";
					rtnValue = false;
				}

				if (FormUtil.checkReqValue($("#ddlCTCode"))) {
					rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='CT Code' htmlEscape='false'/> </br>";
					rtnValue = false;
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
		$("#tpSettleTime").val("");
		$("#ddlDSCCode").val("");
		$("#ddlCTCode").val("");
		$("#txtAMPReading").val("");
        $("#txtVoltage").val("");
        $("#ddlProdGenuine").val("");
		$("#txtTestResultRemark").val("");

		$("#def_code").val("");
		$("#def_def").val("");
		$("#def_part").val("");

		$("#def_code_id").val("");
		$("#def_def_id").val("");
		$("#def_part_id").val("");

	}

	function fn_ddlStatus_SelectedIndexChanged() {

		switch ($("#ddlStatus").val()) {
		case "4":
			// COMPLETE
			fn_openField_Complete();
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
		/* $('#dpSettleDate').removeAttr("disabled").removeClass("readonly");
		$('#tpSettleTime').removeAttr("disabled").removeClass("readonly"); */
		/* $('#ddlDSCCode').removeAttr("disabled").removeClass("readonly");
		$('#ddlCTCode').removeAttr("disabled").removeClass("readonly"); */
		$('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");

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
		}
		Common.popupDiv("/services/as/dftTypPop.do", {
			callPrgm : dftTyp,
			prodCde : $("#PROD_CDE").val(),
			ddCde : ddCde,
			dtCde : dtCde
		}, null, true);

	}
</script>
<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<section id="content">
		<!-- content start -->
		<form id="resultPEXTestResultForm" method="post">
			<div style="display: none">
			    <input type="text" name="TEST_RESULT_ID" id="TEST_RESULT_ID" value="${TEST_RESULT_ID}" />
                <input type="text" name="TEST_RESULT_NO" id="TEST_RESULT_NO" value="${TEST_RESULT_NO}" />
                <input type="text" name="SO_EXCHG_ID" id="SO_EXCHG_ID" value="${SO_EXCHG_ID}" />
                <input type="text" name="RCD_TMS" id="RCD_TMS" value="${RCD_TMS}" />
                <input type="text" name="PROD_CDE" id="PROD_CDE" />
                <input type="text" name="PROD_CAT" id="PROD_CAT" />
                <input type="text" name="MOD" id="MOD" value="${MOD}" />
			</div>
		</form>
		<header class="pop_header">
			<!-- pop_header start -->
			<h1>
				Edit PEX Test Result Basic Info
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
						<a href="#">PEX Test Result Detail</a>
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
									<th scope="row">
									<spring:message code='service.grid.ResultNo' />
									</th>
									<td><input type="text" title="" placeholder=""class="readonly w100p" id='txtResultNo'
									name='txtResultNo' readonly /></td>
									<th scope="row"><spring:message code='sys.title.status' />
									<span id='m1' name='m1' class="must">*</span></th>
									<td>
									<select class="w100p" id="ddlStatus" name="ddlStatus" class="readonly w100p"
									disabled="disabled" onChange="fn_ddlStatus_SelectedIndexChanged()">
									   <option value="">
									   <spring:message code='sal.combo.text.chooseOne' />
									   </option>
									   <c:forEach var="list" items="${asCrtStat}" varStatus="status">
										  <option value="${list.codeId}">${list.codeName}</option>
									   </c:forEach>
									</select></td>
								</tr>
								<tr>
									<th scope="row"><spring:message code='service.grid.SettleDate' />
									<span id='m2' name='m2' class="must">*</span></th>
									<td><input type="text" class="readonly w100p" id='dpSettleDate' name='dpSettleDate'
										placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" /></td>
									<th scope="row">
									<spring:message code='service.grid.SettleTm' />
									<span id='m4' name='m4' class="must">*</span></th>
									<td>
										<div class="time_picker">
											<!-- time_picker start -->
											<input type="text" title="" placeholder="" id='tpSettleTime' name='tpSettleTime'
											class="readonly time_date w100p" disabled="disabled" />
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
									<th scope="row">
									<spring:message code='service.title.DSCCode' />
									<span id='m5' name='m5' class="must">*</span></th>
									<td>
									<input type="hidden" title="" placeholder="" class="" id='ddlDSCCode' name='ddlDSCCode' />
									<input type="text" title="" placeholder="" class="readonly w100p"
										id='ddlDSCCodeText' name='ddlDSCCodeText' readonly />
									</td>
									<th scope="row"><spring:message code='service.grid.CTCode' />
									<span id='m7' name='m7' class="must">*</span></th>
									<td>
									<input type="hidden" title="" placeholder="" class="" id='ddlCTCode' name='ddlCTCode' />
									<input type="text" title="" placeholder="" class="readonly w100p" id='ddlCTCodeText' name='ddlCTCodeText' readonly />
									<input type="hidden" title="" placeholder="" class="" id='CTID' name='CTID' /></td>
								</tr>
								<tr>
									<th scope="row">AMP Reading
									<span id='m7' name='m7' class="must" style="display: none">*</span>
									</th>
									<td>
									<input type="text" title="" placeholder="AMP Reading" class="" id='txtAMPReading'
									name='txtAMPReading' onkeypress='validate(event)' /></td>
									<th scope="row">Voltage
									<span id='m7' name='m7' class="must" style="display: none">*</span>
									</th>
									<td>
									<input type="text" title="" placeholder="Voltage" class="" id='txtVoltage'
									name='txtVoltage' onkeypress='validate(event)' /></td>
								</tr>
								<tr>
									<th scope="row">Product Genuine
									<span id='m5' name='m5' class="must" style="display: none">*</span>
									</th>
									<td><select id='ddlProdGenuine' name='ddlProdGenuine' class="w100p">
                                            <option value="">Choose One</option>
                                            <option value="G">Genuine</option>
                                            <option value="NG">Non-Genuine</option>
                                        </select></td>
									<th></th>
									<td></td>
								</tr>
								<tr>
									<th scope="row">
									<spring:message code='service.title.Remark' /></th>
									<td colspan="3">
									<textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />"
											id='txtTestResultRemark' name='txtTestResultRemark'></textarea></td>
								</tr>
								<tr>
									<th scope="row"><spring:message code='service.grid.CrtBy' /></th>
									<td>
									<input type="text" title="" placeholder="" class="disabled w100p" disabled="disabled"
									id='creator' name='creator' /></td>
									<th scope="row">
									<spring:message code='service.grid.CrtDt' /></th>
									<td>
									<input type="text" title="" placeholder="" class="disabled w100p" disabled="disabled"
									id='creatorat' name='creatorat' /></td>
								</tr>
							</tbody>
						</table>
						<!-- table end -->
					</dd>
					<!-- DEFECTIVE EVENT -->
					<dt class="click_add_on on">
						<a href="#">PEX Defect Entry</a>
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
									<th scope="row"><spring:message code='service.text.defPrt' />
									<span id='m11' name='m11' class="must" style="display: none">*</span></th>
									<td>
									<input type="text" title="" placeholder="" disabled="disabled" id='def_part'
									    name='def_part' class="" onblur="fn_getASReasonCode2(this, 'def_part' ,'305')"
										onkeyup="this.value = this.value.toUpperCase();" />
									<a class="search_btn" id="DP" onclick="fn_dftTyp('DP')">
									<img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
									<input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" />
									<input type="text" title="" placeholder="" id='def_part_text'
										name='def_part_text' class="" disabled style="width: 60%;" /></td>
								</tr>
								<tr>
									<th scope="row"><spring:message code='service.text.dtlDef' /><span
										id='m12' name='m12' class="must" style="display: none">*</span></th>
									<td><input type="text" title="" placeholder="" disabled="disabled" id='def_def' name='def_def'
									class="" onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" /> <a
									class="search_btn" id="DD" onclick="fn_dftTyp('DD')">
									<img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
									<input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" />
									<input type="text" title="" placeholder="" id='def_def_text' name='def_def_text'
									class="" disabled style="width: 60%;" /></td>
								</tr>
								<tr>
									<th scope="row"><spring:message code='service.text.defCde' />
									<span id='m10' name='m10' class="must" style="display: none">*</span></th>
									<td>
									<input type="text" title="" placeholder="" disabled="disabled" id='def_code' name='def_code' class=""
										onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();" />
									<a class="search_btn" id="DC" onclick="fn_dftTyp('DC')">
									<img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
									<input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" />
									<input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width: 60%;" /></td>
								</tr>
							</tbody>
						</table>
						<!-- table end -->
					</dd>
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