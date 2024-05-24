<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 25/06/2019  ONGHC  1.0.0          Amend Report Condition
 20/08/2019  ONGHC  1.0.1          Add Date Option Filter
 17/09/2019  ONGHC  1.0.2          AMEND DEFECT DETAIL SECTION
 03/10/2019  ONGHC  1.0.3          Set Date Range Control
 03/10/2019  ONGHC  1.0.4          Add AS Raw Report for 31Days
 17/10/2019  ONGHC  1.0.5          Add After Service (AS) Spare Part Exchange Raw Data [New]
 22/04/2021  ONGHC  1.0.6          Add V_WHERESQL2 and V_WHERESQL2LEFTJOIN
 22/04/2021 YONGJH  1.0.7          Add variable "whereSql2LeftJoin". Changes in 1.0.6 and this version is because
                                                same stored proc used by some reports in this JSP and asRawDataPop JSP.
 -->
<script type="text/javaScript">
	$(document).ready(function() {
		$("#m5").hide(); //hide mandatory indicator (*) for Settle Date
		fn_populateComboOption();
	});

	function fn_toggleAdditionalFilter(selVal) {
		if (selVal == '3') {
			$("#reportForm1 .tr_toggle_display").show();
			$("#m2").hide(); //hide mandatory indicator (*) for Request Date
			$("#m3").hide(); //hide mandatory indicator (*) for Date Option
			$("#m5").show(); //show mandatory indicator (*) for Settle Date
		}else if (selVal == '8') {
			$("#reportForm1 .tr_toggle_display").show();
			$("#m2").hide(); //hide mandatory indicator (*) for Request Date
			$("#m3").hide(); //hide mandatory indicator (*) for Date Option
			$("#m5").show(); //show mandatory indicator (*) for Settle Date
		} else {
			$("#reportForm1 .tr_toggle_display").hide();
			$("#m2").show();
			$("#m3").show();
			$("#m5").hide();
		}
	}

	function fn_populateComboOption() {
		doGetCombo('/homecare/services/as/report/selectHCProductCategory.do',
				'', '', 'cmbProductCategory', 'M', 'f_multiCombo');
		/* doGetCombo('/services/as/report/selectProductTypeList.do', '', '', 'cmbProductType', 'M', 'f_multiCombo'); */
		doGetCombo('/homecare/services/as/report/selectHCProductList.do', '',
				'', 'cmbProductCode', 'M', 'f_multiCombo');
		doGetCombo('/homecare/services/as/report/selectHCDefectTypeList.do',
				'', '', 'cmbDefectType', 'M', 'f_multiCombo');
		doGetCombo('/homecare/services/as/report/selectHCDefectRmkList.do', '',
				'', 'cmbDefectRmk', 'M', 'f_multiCombo');
		doGetCombo('/homecare/services/as/report/selectHCDefectDescList.do',
				'', '', 'cmbDefectDesc', 'M', 'f_multiCombo');
		doGetCombo(
				'/homecare/services/as/report/selectHCDefectDescSymptomList.do',
				'', '', 'cmbDefectDescSym', 'M', 'f_multiCombo');
		fn_createAsAgingCombo();
	}

	function fn_createAsAgingCombo() {
		var selectAsAging = document.getElementById("cmbAsAging");
		for (var i = 0; i < 201; i++) {
			var elOption = document.createElement("option");
			elOption.textContent = i;
			elOption.value = i;
			selectAsAging.appendChild(elOption);
		}
	}

	function f_multiCombo() {
		$(function() {

			$('#cmbAsStatus').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

			$('#cmbProductCategory').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

			$('#cmbProductCode').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

			$('#cmbAsAging').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

			$('#cmbDefectType').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

			$('#cmbDefectRmk').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

			$('#cmbDefectDesc').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

			$('#cmbDefectDescSym').change(function() {

			}).multipleSelect({
				selectAll : false,
				width : '80%'
			});

		});
	}

	function fn_validation() {

		if ($("#reportType").val() == '') {
			Common
					.alert("<spring:message code='sys.common.alert.validation' arguments='type' htmlEscape='false'/>");
			return false;
		}
		if ($("#dateType").val() == '') {
			Common
					.alert("<spring:message code='sys.common.alert.validation' arguments='type' htmlEscape='false'/>");
			return false;
		}
		if (($("#reqstDateFr").val() == '' || $("#reqstDateTo").val() == '')
				&& $("#reportType").val() != '3' && $("#reportType").val() != '8') {
			Common
					.alert("<spring:message code='sys.common.alert.validation' arguments='request date (From & To)' htmlEscape='false'/>");
			return false;
		}

		if (($("#settleDateFr").val() == '' || $("#settleDateTo").val() == '')
				&& $("#reportType").val() == '3' && $("#reportType").val() == '8') {
			Common
					.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (From & To)' htmlEscape='false'/>");
			return false;
		}

		if ($("#settleDateFr").val() != '' && $("#settleDateTo").val() == '') {
			Common
					.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (To)' htmlEscape='false'/>");
			return false;
		}
		if ($("#settleDateFr").val() == '' && $("#settleDateTo").val() != '') {
			Common
					.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (From)' htmlEscape='false'/>");
			return false;
		}

		var dtRange = 0;

		if ($("#ind").val() == 1) {
			dtRange = 31;
		} else {
			dtRange = 7;
		}

		// VALIDATE DATE RANGE OF 7 DAYS OR 31 DAYS
		if ($("#reportType").val() == '1' || $("#reportType").val() == '5'
				|| $("#reportType").val() == '3'
				|| $("#reportType").val() == '4'
				|| $("#reportType").val() == '6'
				|| $("#reportType").val() == '7') {
			if ($("#reqstDateFr").val() != '' || $("#reqstDateTo").val() != '') {
				var keyInDateFrom = $("#reqstDateFr").val().substring(3, 5)
						+ "/" + $("#reqstDateFr").val().substring(0, 2) + "/"
						+ $("#reqstDateFr").val().substring(6, 10);

				var keyInDateTo = $("#reqstDateTo").val().substring(3, 5) + "/"
						+ $("#reqstDateTo").val().substring(0, 2) + "/"
						+ $("#reqstDateTo").val().substring(6, 10);

				var date1 = new Date(keyInDateFrom);
				var date2 = new Date(keyInDateTo);

				var diff_in_time = date2.getTime() - date1.getTime();

				var diff_in_days = diff_in_time / (1000 * 3600 * 24);

				if (diff_in_days > dtRange) {
					Common
							.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
					return false;
				}
			}

			// VALIDATE SETTLE DATE ONLY FOR AS RAW (PQC)
			if ($("#reportType").val() == '3') {
				if ($("#settleDateFr").val() != ''
						|| $("#reqstDateTo").val() != '') {
					var keyInDateFrom = $("#settleDateFr").val()
							.substring(3, 5)
							+ "/"
							+ $("#settleDateFr").val().substring(0, 2)
							+ "/" + $("#settleDateFr").val().substring(6, 10);

					var keyInDateTo = $("#settleDateTo").val().substring(3, 5)
							+ "/" + $("#settleDateTo").val().substring(0, 2)
							+ "/" + $("#settleDateTo").val().substring(6, 10);

					var date1 = new Date(keyInDateFrom);
					var date2 = new Date(keyInDateTo);

					var diff_in_time = date2.getTime() - date1.getTime();

					var diff_in_days = diff_in_time / (1000 * 3600 * 24);

					if (diff_in_days > dtRange) {
						Common
								.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
						return false;
					}
				}
			}
		}

		// VALIDATE AS STATUS ONLY FOR AS RAW (PQC)
		if ($("#reportType").val() == '3' || $("#reportType").val() == '3') {
			if ($("#cmbAsStatus").val() == ''
					|| $("#cmbAsStatus").val() == null) {
				Common
						.alert("<spring:message code='sys.common.alert.validation' arguments='AS Status' htmlEscape='false'/>");
				return false;
			}
		}

		return true;
	}

	function fn_openGenerate() {
		if (fn_validation()) {
			var whereSql = "";
			var whereSql2 = "";
			var whereSql2LeftJoin = "";

			var keyInDateFrom = $("#reqstDateFr").val().substring(6, 10) + "-"
					+ $("#reqstDateFr").val().substring(3, 5) + "-"
					+ $("#reqstDateFr").val().substring(0, 2) + " 12:00:00 AM";
			var keyInDateTo = $("#reqstDateTo").val().substring(6, 10) + "-"
					+ $("#reqstDateTo").val().substring(3, 5) + "-"
					+ $("#reqstDateTo").val().substring(0, 2) + " 12:00:00 AM";

			var keyInDateFrom1 = $("#reqstDateFr").val().substring(6, 10) + "-"
					+ $("#reqstDateFr").val().substring(3, 5) + "-"
					+ $("#reqstDateFr").val().substring(0, 2);
			var keyInDateTo1 = $("#reqstDateTo").val().substring(6, 10) + "-"
					+ $("#reqstDateTo").val().substring(3, 5) + "-"
					+ $("#reqstDateTo").val().substring(0, 2);

			if ($("#reqstDateFr").val() != '' && $("#reqstDateTo").val() != ''
					&& $("#reqstDateFr").val() != null
					&& $("#reqstDateTo").val() != null) {
				if ($("#dateType").val() == '1') {
					whereSql += " AND (TO_CHAR(A.AS_CRT_DT,'YYYY-MM-DD')) >= '"
							+ keyInDateFrom1
							+ "' AND (TO_CHAR(A.AS_CRT_DT,'YYYY-MM-DD')) <= '"
							+ keyInDateTo1 + "' ";
				} else {
					whereSql += " AND (TO_CHAR(A.AS_REQST_DT,'YYYY-MM-DD')) >= '"
							+ keyInDateFrom1
							+ "' AND (TO_CHAR(A.AS_REQST_DT,'YYYY-MM-DD')) <= '"
							+ keyInDateTo1 + "' ";
				}
			}

			var settleDateFrom = $("#settleDateFr").val().substring(6, 10)
					+ "-" + $("#settleDateFr").val().substring(3, 5) + "-"
					+ $("#settleDateFr").val().substring(0, 2);

			var settleDateTo = $("#settleDateTo").val().substring(6, 10) + "-"
					+ $("#settleDateTo").val().substring(3, 5) + "-"
					+ $("#settleDateTo").val().substring(0, 2);

			if ($("#settleDateFr").val() != ''
					&& $("#settleDateTo").val() != ''
					&& $("#settleDateFr").val() != null
					&& $("#settleDateTo").val() != null) {
				//whereSql2 = " AND G.AS_SETL_DT between to_Date('"+ settleDateFrom + "','YYYY-MM-DD') AND to_Date('"+ settleDateTo + "','YYYY-MM-DD')+1";
				whereSql2 = " AND G.AS_SETL_DT between trunc(to_Date('" + settleDateFrom + "','YYYY-MM-DD')) AND trunc(to_Date('" + settleDateTo + "','YYYY-MM-DD'))";
			} else {
				whereSql2LeftJoin = " LEFT ";
			}

			if ($("#reportType").val() == '1') {
				var date = new Date();
				var month = date.getMonth() + 1;
				var day = date.getDate();
				if (date.getDate() < 10) {
					day = "0" + date.getDate();
				}
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

				whereSql += " AND H.TYPE_ID = 339 ";

				// homecare add
				whereSql += " AND B.BNDL_ID IS NOT NULL";

				// sp_cr_gen_as_raw_in_excel
				$("#reportForm1 #V_SELECTSQL").val(" ");
				$("#reportForm1 #V_ORDERBYSQL").val(" ");
				$("#reportForm1 #V_FULLSQL").val(" ");
				$("#reportForm1 #V_WHERESQL").val(whereSql);
				$("#reportForm1 #reportFileName").val(
						'/homecare/hcASRawData.rpt');
				$("#reportForm1 #viewType").val("EXCEL");
				$("#reportForm1 #reportDownFileName").val(
						"hcASRawData_" + day + month + date.getFullYear());

				var option = {
					isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
				};

				Common.report("reportForm1", option);
			} else if ($("#reportType").val() == '3') {
				var date = new Date();
				var month = date.getMonth() + 1;
				var day = date.getDate();
				if (date.getDate() < 10) {
					day = "0" + date.getDate();
				}

				var whereSql3 = "";

				if ($("#cmbAsStatus").val() != ''
						&& $("#cmbAsStatus").val() != null) {
					var whereAsStatus = " AND AS_STATUS IN ('"
							+ $("#cmbAsStatus").val().toString().replace(/,/g,
									"','") + "') ";
					whereSql3 += whereAsStatus;
				}

				if ($("#cmbProductCategory").val() != ''
						&& $("#cmbProductCategory").val() != null) {
					var wherePrdCat = " AND PRODUCT_CATEGORY IN ('"
							+ $("#cmbProductCategory").val().toString()
									.replace(/,/g, "','") + "') ";
					whereSql3 += wherePrdCat;
				}

				if ($("#cmbProductCode").val() != ''
						&& $("#cmbProductCode").val() != null) {
					var wherePrdCode = " AND PRODUCT_CODE IN ('"
							+ $("#cmbProductCode").val().toString().replace(
									/,/g, "','") + "') ";
					whereSql3 += wherePrdCode;
				}

				if ($("#cmbAsAging").val() != ''
						&& $("#cmbAsAging").val() != null) {
					var whereAsAging = " AND AS_AGING IN ('"
							+ $("#cmbAsAging").val().toString().replace(/,/g,
									"','") + "') ";
					whereSql3 += whereAsAging;
				}

				if ($("#cmbDefectType").val() != ''
						&& $("#cmbDefectType").val() != null) {
					var whereDefType = " AND AS_SOLUTION_LARGE IN ('"
							+ $("#cmbDefectType").val().toString().replace(
									/,/g, "','") + "') ";
					whereSql3 += whereDefType;
				}

				if ($("#cmbDefectRmk").val() != ''
						&& $("#cmbDefectRmk").val() != null) {
					var whereDefRmk = " AND AS_DEFECT_PART_LARGE IN ('"
							+ $("#cmbDefectRmk").val().toString().replace(/,/g,
									"','") + "') ";
					whereSql3 += whereDefRmk;
				}

				if ($("#cmbDefectDesc").val() != ''
						&& $("#cmbDefectDesc").val() != null) {
					var whereDefDesc = " AND AS_DEFECT_PART_SMALL IN ('"
							+ $("#cmbDefectDesc").val().toString().replace(
									/,/g, "','") + "') ";
					whereSql3 += whereDefDesc;
				}

				if ($("#cmbDefectDescSym").val() != ''
						&& $("#cmbDefectDescSym").val() != null) {
					var whereDefDescSym = " AND AS_PROBLEM_SYMPTOM_LARGE IN ('"
							+ $("#cmbDefectDescSym").val().toString().replace(
									/,/g, "','") + "') ";
					whereSql3 += whereDefDescSym;
				}

				// sp_cr_gen_as_raw_in_excel_new
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL3" name="V_WHERESQL3" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');
				$("#reportForm1").append(
						'<input type="hidden" id="V_DEPT" name="V_DEPT" /> ');

				whereSql += " AND B.BNDL_ID IS NOT NULL";

				$("#reportForm1 #V_SELECTSQL").val(" ");
				$("#reportForm1 #V_ORDERBYSQL").val(" ");
				$("#reportForm1 #V_FULLSQL").val(" ");
				$("#reportForm1 #V_WHERESQL").val(whereSql);
				$("#reportForm1 #V_WHERESQL2").val(whereSql2);
				$("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
				$("#reportForm1 #V_WHERESQL3").val(whereSql3);
				$("#reportForm1 #reportFileName").val(
						'/homecare/hcASRawPQC.rpt');
				$("#reportForm1 #viewType").val("EXCEL");
				$("#reportForm1 #reportDownFileName").val(
						"hcASRawPQCData_" + day + month + date.getFullYear());
				$("#reportForm1 #V_DEPT").val("PQC");

				var option = {
					isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
				};

				Common.report("reportForm1", option);
			} else if ($("#reportType").val() == '4') {
				var date = new Date();
				var month = date.getMonth() + 1;
				var day = date.getDate();
				if (date.getDate() < 10) {
					day = "0" + date.getDate();
				}
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

				whereSql += " AND A.AS_TYPE_ID IN (3154) ";

				// homecare add
				whereSql += " AND B.BNDL_ID IS NOT NULL";

				$("#reportForm1 #V_SELECTSQL").val(" ");
				$("#reportForm1 #V_ORDERBYSQL").val(" ");
				$("#reportForm1 #V_FULLSQL").val(" ");
				$("#reportForm1 #V_WHERESQL").val(whereSql);
				$("#reportForm1 #reportFileName").val(
						'/homecare/hcASRawData.rpt');
				$("#reportForm1 #viewType").val("EXCEL");
				$("#reportForm1 #reportDownFileName").val(
						"hcASRawDataAOAS_" + day + month + date.getFullYear());
				//$("#reportForm1 #V_DEPT").val("PQC");

				var option = {
					isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
				};

				Common.report("reportForm1", option);
			} else if ($("#reportType").val() == '5') {
				var date = new Date();
				var month = date.getMonth() + 1;
				var day = date.getDate();
				if (date.getDate() < 10) {
					day = "0" + date.getDate();
				}
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

				//whereSql += " AND A.AS_TYPE_ID = 339 ";
				whereSql += " AND EXISTS ( SELECT 1 " + "   FROM SAL0001D C "
						+ "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
						+ "    AND C.BNDL_ID IS NOT NULL ) ";

				// sp_cr_gen_as_raw_in_excel_kor
				$("#reportForm1 #V_SELECTSQL").val(" ");
				$("#reportForm1 #V_ORDERBYSQL").val(" ");
				$("#reportForm1 #V_FULLSQL").val(" ");
				$("#reportForm1 #V_WHERESQL").val(whereSql);
				$("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
				$("#reportForm1 #reportFileName").val(
						'/services/ASRawDataKOR.rpt');
				$("#reportForm1 #viewType").val("EXCEL");
				$("#reportForm1 #reportDownFileName").val(
						"hcASRawDataKOR_" + day + month + date.getFullYear());

				var option = {
					isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
				};

				Common.report("reportForm1", option);
			} else if ($("#reportType").val() == '6') {
				var date = new Date();
				var month = date.getMonth() + 1;
				var day = date.getDate();
				if (date.getDate() < 10) {
					day = "0" + date.getDate();
				}
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

				whereSql += " AND A.AS_TYPE_ID IN (3154) ";

				// homecare add
				whereSql += " AND EXISTS( SELECT 1 " + "   FROM SAL0001D C "
						+ "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
						+ "    AND C.BNDL_ID IS NOT NULL ) ";

				// sp_cr_gen_as_raw_in_excel_kor
				$("#reportForm1 #V_SELECTSQL").val(" ");
				$("#reportForm1 #V_ORDERBYSQL").val(" ");
				$("#reportForm1 #V_FULLSQL").val(" ");
				$("#reportForm1 #V_WHERESQL").val(whereSql);
				$("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
				$("#reportForm1 #reportFileName").val(
						'/homecare/hcASRawDataKOR.rpt');
				$("#reportForm1 #viewType").val("EXCEL");
				$("#reportForm1 #reportDownFileName").val(
						"hcASRawDataAOASKOR_" + day + month
								+ date.getFullYear());

				var option = {
					isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
				};

				Common.report("reportForm1", option);
			} else if ($("#reportType").val() == '7') {
				var date = new Date();
				var month = date.getMonth() + 1;
				var day = date.getDate();
				if (date.getDate() < 10) {
					day = "0" + date.getDate();
				}
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

				//whereSql += " AND A.AS_TYPE_ID = 339 ";

				// homecare add
				whereSql += " AND EXISTS( SELECT 1 " + "   FROM SAL0001D C "
						+ "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
						+ "    AND C.BNDL_ID IS NOT NULL ) ";

				// SP_CR_GEN_AS_RAWPRT_INEXCELKOR
				$("#reportForm1 #V_SELECTSQL").val(" ");
				$("#reportForm1 #V_ORDERBYSQL").val(" ");
				$("#reportForm1 #V_FULLSQL").val(" ");
				$("#reportForm1 #V_WHERESQL").val(whereSql);
				$("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
				$("#reportForm1 #reportFileName").val(
						'/homecare/hcASRawDataSprPrtKOR.rpt');
				$("#reportForm1 #viewType").val("EXCEL");
				$("#reportForm1 #reportDownFileName").val(
						"hcASRawDataSprPrtKOR_" + day + month
								+ date.getFullYear());

				var option = {
					isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
				};

				Common.report("reportForm1", option);
			}  else if ($("#reportType").val() == '8') {
		         var date = new Date();
		          var month = date.getMonth() + 1;
		          var day = date.getDate();
		          if (date.getDate() < 10) {
		            day = "0" + date.getDate();
		          }

		          var whereSql3 = "";

		          if ($("#cmbAsStatus").val() != '' && $("#cmbAsStatus").val() != null) {
		              var whereAsStatus = " AND AS_STATUS IN ('" + $("#cmbAsStatus").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += whereAsStatus;
		          }

		          if ($("#cmbProductCategory").val() != '' && $("#cmbProductCategory").val() != null) {
		              var wherePrdCat = " AND PRODUCT_CATEGORY IN ('" + $("#cmbProductCategory").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += wherePrdCat;
		          }

		          if ($("#cmbProductType").val() != '' && $("#cmbProductType").val() != null) {
		              var wherePrdType = " AND PRODUCT_TYPE IN ('" + $("#cmbProductType").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += wherePrdType;
		          }

		          if ($("#cmbProductCode").val() != '' && $("#cmbProductCode").val() != null) {
		              var wherePrdCode = " AND PRODUCT_CODE IN ('" + $("#cmbProductCode").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += wherePrdCode;
		          }

		          if ($("#cmbAsAging").val() != '' && $("#cmbAsAging").val() != null) {
		              var whereAsAging = " AND AS_AGING IN ('" + $("#cmbAsAging").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += whereAsAging;
		          }

		          if ($("#cmbDefectType").val() != '' && $("#cmbDefectType").val() != null) {
		              var whereDefType = " AND AS_SOLUTION_LARGE IN ('" + $("#cmbDefectType").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += whereDefType;
		          }

		          if ($("#cmbDefectRmk").val() != '' && $("#cmbDefectRmk").val() != null) {
		              var whereDefRmk = " AND AS_DEFECT_PART_LARGE IN ('" + $("#cmbDefectRmk").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += whereDefRmk;
		          }

		          if ($("#cmbDefectDesc").val() != '' && $("#cmbDefectDesc").val() != null) {
		              var whereDefDesc = " AND AS_DEFECT_PART_SMALL IN ('" + $("#cmbDefectDesc").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += whereDefDesc;
		          }

		          if ($("#cmbDefectDescSym").val() != '' && $("#cmbDefectDescSym").val() != null) {
		              var whereDefDescSym = " AND AS_PROBLEM_SYMPTOM_LARGE IN ('" + $("#cmbDefectDescSym").val().toString().replace(/,/g, "','") + "') ";
		              whereSql3 += whereDefDescSym;
		          }

		          //SP_CR_GEN_AS_INS_ACC_RAW
		          $("#reportForm1").append('<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  /> ');
		          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> ');
		          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" /> ');
		          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL2LEFTJOIN" name="V_WHERESQL2LEFTJOIN" /> ');
		          $("#reportForm1").append('<input type="hidden" id="V_WHERESQL3" name="V_WHERESQL3" /> ');
		          $("#reportForm1").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> ');
		          $("#reportForm1").append('<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> ');

		          // Homecare
		          whereSql += " AND EXISTS( SELECT 1 "
		                                + "   FROM SAL0001D C "
		                                + "  WHERE A.AS_SO_ID = C.SALES_ORD_ID "
		                                + "    AND C.BNDL_ID IS NOT NULL ) ";

		          $("#reportForm1 #V_SELECTSQL").val(" ");
		          $("#reportForm1 #V_ORDERBYSQL").val(" ");
		          $("#reportForm1 #V_FULLSQL").val(" ");
		          $("#reportForm1 #V_WHERESQL").val(whereSql);
		          $("#reportForm1 #V_WHERESQL2").val(whereSql2);
		          $("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
		          $("#reportForm1 #V_WHERESQL3").val(whereSql3);
		          $("#reportForm1 #reportFileName").val('/services/ASInstallationAccessoriesRaw_Excel.rpt');
		          $("#reportForm1 #viewType").val("EXCEL");
		          $("#reportForm1 #reportDownFileName").val("ASInstallationAccessoriesRaw_" + day + month + date.getFullYear());

		          var option = {
		            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
		          };

		          Common.report("reportForm1", option);
			}else {
				var date = new Date();
				var month = date.getMonth() + 1;
				var day = date.getDate();
				if (date.getDate() < 10) {
					day = "0" + date.getDate();
				}

				// SP_CR_PART_DLVY_ORD_RAW_HC
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_KEYINDATEFROM" name="V_KEYINDATEFROM" /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_KEYINDATETO" name="V_KEYINDATETO"  /> ');
				$("#reportForm1")
						.append(
								'<input type="hidden" id="V_DSCBRANCHID" name="V_DSCBRANCHID" /> ');
				$("#reportForm1 #V_KEYINDATEFROM").val(keyInDateFrom);
				$("#reportForm1 #V_KEYINDATETO").val(keyInDateTo);
				$("#reportForm1 #V_DSCBRANCHID").val(0);
				$("#reportForm1 #reportFileName").val(
						'/homecare/hcASSparePartRaw.rpt');
				$("#reportForm1 #viewType").val("EXCEL");
				$("#reportForm1 #reportDownFileName").val(
						"hcASSparePartRaw_" + day + month + date.getFullYear());

				var option = {
					isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
				};
				Common.report("reportForm1", option);
			}

		}
	}

	/*$.fn.clearForm = function() {
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
	      this.selectedIndex = 1;
	    }

	  });
	};*/
	$.fn.clearForm = function() {
		return this.each(function() {
			var type = this.type, tag = this.tagName.toLowerCase();
			identifier = this.id;
			if (tag === 'form') {
				return $(':input', this).clearForm();
			}
			if (type === 'text' || type === 'password' || type === 'hidden'
					|| tag === 'textarea') {
				this.value = '';
			} else if (type === 'checkbox' || type === 'radio') {
				this.checked = false;
			} else if (tag === 'select' && identifier === 'reportType') {
				this.selectedIndex = 0;
			}

			$("#reportForm1 .tr_toggle_display").hide();

		});
	};
</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>
      AS Raw Data
      <c:choose>
        <c:when test="${ind=='1'}">
          <span style="color: red">( <spring:message code='service.message.dtRange31' /> )
          </span>
        </c:when>
        <c:otherwise>
          <span style="color: red">( <spring:message code='service.message.dtRange7' /> )
          </span>
        </c:otherwise>
      </c:choose>
    </h1>
    <ul class="right_opt">
      <li><p class="btn_blue2">
          <a href="#none">CLOSE</a>
        </p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <section class="search_table">
      <!-- search_table start -->
      <form action="#" id="reportForm1">
        <!--reportFileName,  viewType 모든 레포트 필수값 -->
        <input type="hidden" id="reportFileName" name="reportFileName" /> <input type="hidden" id="viewType" name="viewType" /> <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" /> <input type="hidden" id="ind" name="ind" value="${ind}" />
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 130px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row">Report Type<span id='m1' name='m1' class='must'> *</span></th>
              <td><select id="reportType" class="w100p" onchange="javascript : fn_toggleAdditionalFilter(this.value)">
                  <!--          <option value="1">After Service (AS) Raw Data</option> -->
                  <option value="5" selected>After Service (AS) Raw Data [New]</option>
                  <option value="2">After Service (AS) Spare Part Exchange Raw Data</option>
                  <option value="7">After Service (AS) Spare Part Exchange Raw Data [New]</option>
                  <option value="3">After Service (AS) Raw Data (PQC)</option>
                  <!--          <option value="4">After Service (AS) Raw Data (AOAS)</option> -->
                  <option value="6">After Service (AS) Raw Data (AOAS) [New]</option>
                  <option value="8">After Service (AS) Install Accessories Raw</option>
              </select></td>
              <th scope="row">Date Option<span id='m3' name='m3' class='must'> *</span></th>
              <td><select id="dateType" class="w100p">
                  <option value="1" selected>Register Date</option>
                  <option value="2">Request Date</option>
              </select></td>
            </tr>
            <tr>
              <th scope="row">Request Date<span id='m2' name='m2' class='must'> *</span></th>
              <td>
                <div class="date_set">
                  <!-- date_set start -->
                  <p>
                    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="reqstDateFr" />
                  </p>
                  <span>To</span>
                  <p>
                    <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_dateHc" id="reqstDateTo" />
                  </p>
                </div> <!-- date_set end -->
              </td>
              <th scope="row">Settle Date<span id='m5' name='m5' class='must'> *</span></th>
              <td>
                <div class="date_set">
                  <!-- date_set start -->
                  <p>
                    <input type="text" title="Settle start Date" placeholder="DD/MM/YYYY" class="j_date" id="settleDateFr" />
                  </p>
                  <span>To</span>
                  <p>
                    <input type="text" title="Settle end Date" placeholder="DD/MM/YYYY" class="j_date" id="settleDateTo" />
                  </p>
                </div> <!-- date_set end -->
              </td>
            </tr>
            <tr class="tr_toggle_display" style="display: none;">
              <th scope="row">AS Status<span id='m4' name='m4' class='must'> *</span></th>
              <td><select id="cmbAsStatus" class="multy_select w100p" multiple="multiple">
                  <option value="ACT">Active</option>
                  <option value="CAN">Cancelled</option>
                  <option value="COM">Completed</option>
                  <option value="RCL">Recall</option>
              </select></td>
              <th scope="row">Product Category</th>
              <td><select id="cmbProductCategory" class="multy_select w100p" multiple="multiple"></select></td>
            </tr>
            <tr class="tr_toggle_display" style="display: none;">
              <!-- <th scope="row">Product Type</th>
        <td><select id="cmbProductType" class="multy_select w100p" multiple="multiple"></select></td> -->
              <th scope="row">Product Code</th>
              <td><select id="cmbProductCode" class="multy_select w100p" multiple="multiple"></select></td>
              <th scope="row">AS Aging</th>
              <td><select id="cmbAsAging" class="multy_select w100p" multiple="multiple"></select></td>
            </tr>
            <tr class="tr_toggle_display" style="display: none;">
              <th scope="row">AS Solution Large</th>
              <td><select id="cmbDefectType" class="multy_select w100p" multiple="multiple"></select></td>
              <th scope="row">AS Defect Part Large</th>
              <td><select id="cmbDefectRmk" class="multy_select w100p" multiple="multiple"></select></td>
            </tr>
            <tr class="tr_toggle_display" style="display: none;">
              <th scope="row">AS Defect Part Small</th>
              <td><select id="cmbDefectDesc" class="multy_select w100p" multiple="multiple"></select></td>
              <th scope="row">AS Problem Symptom Large</th>
              <td><select id="cmbDefectDescSym" class="multy_select w100p" multiple="multiple"></select></td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </form>
    </section>
    <!-- search_table end -->
    <ul class="center_btns">
      <li><p class="btn_blue2 big">
          <a href="#none" onclick="javascript:fn_openGenerate()">Generate</a>
        </p></li>
      <li><p class="btn_blue2 big">
          <a href="#none" onclick="$('#reportForm1').clearForm();">Clear</a>
        </p></li>
    </ul>
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
