<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!-- AS ORDER > AS MANAGEMENT > EDIT BASIC AS ENTRY -->
<script type="text/javaScript">
	/* var regGridID;
	var myFltGrd10; */

	var productCode;
	var asMalfuncResnId;

	var failRsn;

	var errMsg;

	$(document).ready(function() {
		//createAUIGrid();

		/* fn_getASOrderInfo();
		fn_getASEvntsInfo();
		fn_getASHistoryInfo(); */

		fn_getPEXTestResultInfo();
	});

	function fn_setCTcodeValue() {
		$("#ddlCTCode").val($("#CTID").val());
	}

	function fn_getPEXTestResultInfo() {
		Common.ajax("GET", "/ResearchDevelopment/getPEXTestResultInfo", $(
				"#resultPEXTestResultForm").serialize(), function(result) {
			if (result != "") {
				fn_setPEXTestResultInfo(result);
			}
		});
	}

	function fn_setPEXTestResultInfo(result) {

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

		var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
	    console.log(selectedItems[0]);

        $('#def_part').val(result[0].defLargeCode);
        $('#def_part_text').val(result[0].defectPartLarge);
        $('#def_part_id').val(result[0].defLargeId);

        $('#def_code').val(result[0].probLargeCode);
        $('#def_code_text').val(result[0].problemSymptomLarge);
        $('#def_code_id').val(result[0].probLargeId);

        $('#def_def').val(result[0].probSmallCode);
        $('#def_def_text').val(result[0].problemSymptomSmall);
        $('#def_def_id').val(result[0].probSmallId);

        $("#PROD_CDE").val(result[0].prodCde);

		fn_ddlStatus_SelectedIndexChanged();

	}

/* 	function fn_inHouseGetProductDetails() {
		$("#productCode").val(productCode);
	} */

	/* function createAUIGrid() {
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
		} ];

		var gridPros = {
			usePaging : true,
			pageRowCount : 20,
			editable : true,
			fixedColumnCount : 1,
			selectionMode : "singleRow",
			showRowNumColumn : true
		};
		regGridID = GridCommon.createAUIGrid("reg_grid_wrap", columnLayout, "",
				gridPros);
	} */

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

	/* function fn_getASOrderInfo() {
		Common.ajax("GET", "/services/as/getASOrderInfo.do", $("#resultPEXTestResultForm")
				.serialize(), function(result) {

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

		});
	} */

	/* function fn_getASEvntsInfo() {
		Common.ajax("GET", "/services/as/getASEvntsInfo.do", $("#resultPEXTestResultForm")
				.serialize(), function(result) {

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

			// KR-OHK Serial Check
			$("#hidSerialRequireChkYn").val(result[0].serialRequireChkYn);
			if ($("#hidSerialRequireChkYn").val() == 'Y') {
				$("#btnSerialEdit").attr("style", "");
			}
		});
	}
 */
	/* function fn_getASHistoryInfo() {
		Common.ajax("GET", "/services/as/getASHistoryInfo.do", $(
				"#resultPEXTestResultForm").serialize(), function(result) {
			AUIGrid.setGridData(regGridID, result);
		});
	} */

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
			AS_RESULT_REM : $('#txtTestResultRemark').val(),
			AS_CMMS : $("#iscommission").prop("checked") ? '1' : '0',
			AS_FAIL_RSN : $('#ddlFailReason').val(),

			AS_ENTRY_ID : $('#AS_ID').val(),

			// DEFECT ENTRY
			AS_DEFECT_TYPE_ID : $('#ddlStatus').val() == 4 ? $('#def_type_id')
					.val() : '0',
			AS_DEFECT_ID : $('#ddlStatus').val() == 4 ? $('#def_code_id').val()
					: '0',
			AS_DEFECT_PART_ID : $('#ddlStatus').val() == 4 ? $('#def_part_id')
					.val() : '0',
			AS_DEFECT_DTL_RESN_ID : $('#ddlStatus').val() == 4 ? $(
					'#def_def_id').val() : '0',
			AS_SLUTN_RESN_ID : $('#ddlStatus').val() == 4 ? $('#solut_code_id')
					.val() : '0',

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
		$('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");
		$('#iscommission').removeAttr("disabled").removeClass("readonly");

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
				} else {
					var asno = $("#txtASNo").val();
					if (asno.match("AS")) {
						var nowdate = $.datepicker.formatDate(
								$.datepicker.ATOM, new Date());
						var nowdateArry = nowdate.split("-");
						nowdateArry = nowdateArry[0] + "" + nowdateArry[1] + ""
								+ nowdateArry[2];
						var rdateArray = $("#dpSettleDate").val().split("/");
						var requestDate = rdateArray[2] + "" + rdateArray[1]
								+ "" + rdateArray[0];

						if ((parseInt(requestDate, 10) - parseInt(nowdateArry,
								10)) > 14
								|| (parseInt(nowdateArry, 10) - parseInt(
										requestDate, 10)) > 14) {
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

				if (FormUtil.checkReqValue($("#ddlCTCode"))) {
					rtnMsg += "* <spring:message code='sys.msg.necessary' arguments='CT Code' htmlEscape='false'/> </br>";
					rtnValue = false;
				}

				// KR-OHK Serial Check
				if ($("#hidSerialRequireChkYn").val() == 'Y'
						&& FormUtil.checkReqValue($("#stockSerialNo"))) {
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

	/* 	case "10":
			// CANCEL
			fn_openField_Cancel();
			break; */

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

	/* function fn_openField_Cancel() {
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

		$("#def_code").attr("disabled", "disabled");
		$("#def_part").attr("disabled", "disabled");
		$("#def_def").attr("disabled", "disabled");

		$("#dpSettleDate").val("");
		$("#tpSettleTime").val("");

		$('#txtTestResultRemark').removeAttr("disabled").removeClass("readonly");

		$("#btnSaveDiv").attr("style", "display:inline");
	} */

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
			if ($("#def_type_id").val() == ""
					|| $("#def_type_id").val() == null) {
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
</script>
<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<section id="content">
		<!-- content start -->
		<form id="serialNoChangeForm" name="serialNoChangeForm" method="POST">
			<input type="hidden" name="pSerialNo" id="pSerialNo" /> <input
				type="hidden" name="pSalesOrdId" id="pSalesOrdId" /> <input
				type="hidden" name="pSalesOrdNo" id="pSalesOrdNo" /> <input
				type="hidden" name="pRefDocNo" id="pRefDocNo" /> <input
				type="hidden" name="pItmCode" id="pItmCode" /> <input type="hidden"
				name="pCallGbn" id="pCallGbn" /> <input type="hidden"
				name="pMobileYn" id="pMobileYn" />
		</form>
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
			<%-- <section class="tap_wrap">
				<!-- tap_wrap start -->
				<ul class="tap_type1">
					<li><a href="#" class="on"><spring:message
								code='service.title.General' /></a></li>
					<li><a href="#"><spring:message
								code='service.title.OrderInformation' /></a></li>
					<li><a href="#"
						onclick=" javascirpt:AUIGrid.resize(regGridID, 950,300);  "><spring:message
								code='service.title.asPassEvt' /></a></li>
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
								<th scope="row"><spring:message
										code='service.grid.SalesOrder' /></th>
								<td><span id="txtOrderNo"></span></td>
								<th scope="row"><spring:message
										code='service.title.ApplicationType' /></th>
								<td><span id="txtAppType"></span></td>
							</tr>
							<tr>
								<th scope="row"><spring:message
										code='service.title.asStatus' /></th>
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
								<th scope="row"><spring:message
										code='service.title.ReqstTm' /></th>
								<td><span id='txtRequestTime'></span></td>
							</tr>
							<tr>
								<th scope="row"></th>
								<td><span></span></td>
								<th scope="row"><spring:message
										code='service.title.AppointmentDate' /></th>
								<td><span id='txtAppDt'></span></td>
								<th scope="row"><spring:message
										code='service.title.AppointmentTm' /></th>
								<td><span id='txtAppTm'></span></td>
							</tr>
							<tr>
								<th scope="row"><spring:message
										code='service.title.DSCCode' /></th>
								<td><span id='txtDSCCode'></span></td>
								<th scope="row"><spring:message
										code='service.title.InchargeCT' /></th>
								<td colspan="3"><span id='txtInchargeCT'></span></td>
							</tr>
							<tr>
								<th scope="row"><spring:message
										code='service.title.CustomerName' /></th>
								<td colspan="3"><span id="txtCustName"></span></td>
								<th scope="row"><spring:message
										code='service.title.NRIC_CompanyNo' /></th>
								<td><span id="txtCustIC"></span></td>
							</tr>
							<tr>
								<th scope="row"><spring:message
										code='service.title.ContactNo' /></th>
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
								<th scope="row"><spring:message
										code='service.title.InstallationAddress' /></th>
								<td colspan="5"><span id="txtInstallAddress"></span></td>
							</tr>
							<tr>
								<th scope="row"><spring:message code='service.title.Rqst' /></th>
								<td colspan="3"><span id="txtRequestor"></span></td>
								<th scope="row"><spring:message code='service.grid.CrtBy' /></th>
								<td></td>
							</tr>
							<tr>
								<th scope="row"><spring:message
										code='service.title.RqstCtc' /></th>
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
						<div id="reg_grid_wrap"
							style="width: 100%; height: 300px; margin: 0 auto;"></div>
					</article>
					<!-- grid_wrap end -->
				</article>
				<!-- tap_area end -->
			</section> --%>
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
									<th scope="row"><spring:message
											code='service.grid.ResultNo' /></th>
									<td><input type="text" title="" placeholder=""
										class="readonly w100p" id='txtResultNo' name='txtResultNo'
										readonly /></td>
									<th scope="row"><spring:message code='sys.title.status' /><span
										id='m1' name='m1' class="must">*</span></th>
									<td><select class="w100p" id="ddlStatus" name="ddlStatus"
										class="readonly w100p" disabled="disabled"
										onChange="fn_ddlStatus_SelectedIndexChanged()">
											<option value=""><spring:message
													code='sal.combo.text.chooseOne' /></option>
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


									<th scope="row"><spring:message
											code='service.grid.SettleTm' /><span id='m4' name='m4'
										class="must">*</span></th>
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
									<th scope="row"><spring:message
											code='service.title.DSCCode' /><span id='m5' name='m5'
										class="must">*</span></th>
									<td><input type="hidden" title="" placeholder="" class=""
										id='ddlDSCCode' name='ddlDSCCode' /> <input type="text"
										title="" placeholder="" class="readonly w100p"
										id='ddlDSCCodeText' name='ddlDSCCodeText' readonly /></td>
									<th scope="row"><spring:message code='service.grid.CTCode' /><span
										id='m7' name='m7' class="must">*</span></th>
									<td><input type="hidden" title="" placeholder="" class=""
										id='ddlCTCode' name='ddlCTCode' /> <input type="text"
										title="" placeholder="" class="readonly w100p"
										id='ddlCTCodeText' name='ddlCTCodeText' readonly /> <input
										type="hidden" title="" placeholder="" class="" id='CTID'
										name='CTID' /></td>
								</tr>
								<tr>
									<th scope="row">AMP Reading<span id='m7' name='m7'
										class="must" style="display: none">*</span></th>
									<td><input type="text" title="" placeholder="AMP Reading"
										class="" id='txtAMPReading' name='txtAMPReading'
										onkeypress='validate(event)' /></td>
									<th scope="row">Voltage<span id='m7' name='m7'
										class="must" style="display: none">*</span></th>
									<td><input type="text" title="" placeholder="Voltage"
										class="" id='txtVoltage' name='txtVoltage'
										onkeypress='validate(event)' /></td>
								</tr>
								<tr>
									<th scope="row">Product Genuine<span id='m5' name='m5'
										class="must" style="display: none">*</span></th>
									<td><select id='ddlProdGenuine' name='ddlProdGenuine' class="w100p">
                                            <option value="">Choose One</option>
                                            <option value="G">Genuine</option>
                                            <option value="NG">Non-Genuine</option>
                                        </select></td>
									<th></th>
									<td></td>
								</tr>
								<tr>
									<th scope="row"><spring:message
											code='service.title.Remark' /></th>
									<td colspan="3"><textarea cols="20" rows="5"
											placeholder="<spring:message code='service.title.Remark' />"
											id='txtTestResultRemark' name='txtTestResultRemark'></textarea></td>
								</tr>
								<tr>
									<th scope="row"><spring:message code='service.grid.CrtBy' /></th>
									<td><input type="text" title="" placeholder=""
										class="disabled w100p" disabled="disabled" id='creator'
										name='creator' /></td>
									<th scope="row"><spring:message code='service.grid.CrtDt' /></th>
									<td><input type="text" title="" placeholder=""
										class="disabled w100p" disabled="disabled" id='creatorat'
										name='creatorat' /></td>
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
									<th scope="row"><spring:message code='service.text.defPrt' /><span
										id='m11' name='m11' class="must" style="display: none">*</span></th>
									<td><input type="text" title="" placeholder=""
										disabled="disabled" id='def_part' name='def_part' class=""
										onblur="fn_getASReasonCode2(this, 'def_part' ,'305')"
										onkeyup="this.value = this.value.toUpperCase();" /> <a
										class="search_btn" id="DP" onclick="fn_dftTyp('DP')"><img
											src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
											alt="search" /></a> <input type="hidden" title="" placeholder=""
										id='def_part_id' name='def_part_id' class="" /> <input
										type="text" title="" placeholder="" id='def_part_text'
										name='def_part_text' class="" disabled style="width: 60%;" /></td>
								</tr>
								<tr>
									<th scope="row"><spring:message code='service.text.dtlDef' /><span
										id='m12' name='m12' class="must" style="display: none">*</span></th>
									<td><input type="text" title="" placeholder=""
										disabled="disabled" id='def_def' name='def_def' class=""
										onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')"
										onkeyup="this.value = this.value.toUpperCase();" /> <a
										class="search_btn" id="DD" onclick="fn_dftTyp('DD')"><img
											src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
											alt="search" /></a> <input type="hidden" title="" placeholder=""
										id='def_def_id' name='def_def_id' class="" /> <input
										type="text" title="" placeholder="" id='def_def_text'
										name='def_def_text' class="" disabled style="width: 60%;" /></td>
								</tr>
								<tr>
									<th scope="row"><spring:message code='service.text.defCde' /><span
										id='m10' name='m10' class="must" style="display: none">*</span></th>
									<td><input type="text" title="" placeholder=""
										disabled="disabled" id='def_code' name='def_code' class=""
										onblur="fn_getASReasonCode2(this, 'def_code', '303')"
										onkeyup="this.value = this.value.toUpperCase();" /> <a
										class="search_btn" id="DC" onclick="fn_dftTyp('DC')"><img
											src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
											alt="search" /></a> <input type="hidden" title="" placeholder=""
										id='def_code_id' name='def_code_id' class="" /> <input
										type="text" title="" placeholder="" id='def_code_text'
										name='def_code_text' class="" disabled style="width: 60%;" /></td>
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
						<a href="#" onclick="fn_doSave()"><spring:message
								code='sys.btn.save' /></a>
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