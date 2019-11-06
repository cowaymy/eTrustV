<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

	var comboData = [ {
		"codeId" : "04",
		"codeName" : "CODY"
	} ];
	
	var brnch = ('${SESSION_INFO.userBranchId}' == null || '${SESSION_INFO.userBranchId}' == "" ) ? 0 : '${SESSION_INFO.userBranchId}';
	
	$(document).ready(function() {
		//branch
		doGetComboData('/logistics/codystock/selectTotalBranchList.do', '', brnch, 'searchBranch', 'S', '');

		//cm group
		if(brnch == null || brnch == ""){
			CommonCombo.make('cmgroup', '/logistics/codystock/getDeptCodeList', {memLvl : 3, memType : 2}, '');
		} else {
			doGetCombo("/logistics/codystock/selectCMGroupList.do", brnch, '', 'cmgroup', 'S', '');
		}
		
		//loc type
		doDefCombo(comboData, '04', 'searchlocgb', 'S', '');

		$("#searchBranch").change(function() {
			doGetCombo("/logistics/codystock/selectCMGroupList.do", $("#searchBranch").val(), '', 'cmgroup', 'S', '');
		});
	});

	function fn_ChangeCMGroup() {
		CommonCombo.make('searchLoc', '/logistics/codystock/getCodyCodeList', {
			memLvl : 4,
			memType : 2,
			upperLineMemberID : $("#cmgroup").val()
		}, '');

	}

	function validRequiredField() {

		var valid = true;
		var message = "";

		if ($("#searchBranch").val() == null || $("#searchBranch").val().length == 0) {
			valid = false;
			message += 'Please select Branch.|!|';
		}

		if ($("#cmgroup").val() == null || $("#cmgroup").val().length == 0) {
			valid = false;
			message += 'Please select CM Group.|!|';
		}

		if ($("#searchLoc").val() == null || $("#searchLoc").val().length == 0) {
			valid = false;
			message += 'Please select Location.|!|';
		}

		if (($("#hsperiod").val() == null || $("#hsperiod").val() == '')) {

			valid = false;
			message += 'Please select HS Period.|!|';
		}

		if (valid == false) {
			Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);

		}

		return valid;
	}

	function fn_report(type) {

		if (validRequiredField() == true) {

			var yyyyStr = $("#hsperiod").val().substring(3, 7);
			var mmStr = $("#hsperiod").val().substring(0, 2);
			var hsPeriod = yyyyStr + mmStr;
			var retStatus = "";
			var branchCode = "";
			var cmGroup = "";
			var codyCode = "";
			var whereSQL = "";
			var orderBySQL = "";

			$("#reportFileName").val("");
			$("#reportDownFileName").val("");
			$("#viewType").val(type);

			if (hsPeriod != null || hsPeriod != '') {
				whereSQL += " AND L93.HS_PERIOD = '" + hsPeriod + "'";
				hsPeriod = hsPeriod;

			}

			if ($("#cmgroup :selected").val() > 0) {

				whereSQL += " AND ov.MEM_UP_ID = '" + $("#cmgroup").val() + "'";
				cmGroup = $("#cmgroup :selected").text();
			}

			if ($("#searchLoc :selected").val() > 0) {

				whereSQL += " AND OV.MEM_ID = '" + $("#searchLoc").val() + "'";
				codyCode = $("#searchLoc :selected").text();

			}
			var date = new Date().getDate();
			if (date.toString().length == 1) {
				date = "0" + date;
			}

			if (type == 'PDF') {
				$("#form #reportFileName").val("/logistics/CodyStockSummary.rpt");
			}
			else {
				$("#form #reportFileName").val("/logistics/CodyStockSummary_Excel.rpt");
			}

			$("#reportDownFileName").val("CodyStockSummary" + date + (new Date().getMonth() + 1) + new Date().getFullYear());

			orderBySQL += " ORDER BY S28.WH_LOC_CODE, L93.STK_CODE ";

			$("#form #V_HSPERIOD").val(hsPeriod);
			$("#form #V_DEPTCODE").val(cmGroup);
			$("#form #V_CODYCODE").val(codyCode);
			$("#form #V_SELECTSQL").val("");
			$("#form #V_WHERESQL").val(whereSQL);
			$("#form #V_ORDERBYSQL").val(orderBySQL);
			$("#form #V_FULLSQL").val("");

			// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
			var option = {
				isProcedure : true
			};

			Common.report("form", option);

		}
		else {
			return false;
		}
	}
</script>

<section id="content">

	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>Logistics</li>
		<li>Report</li>
		<li>Cody Stock Summary Listing</li>
	</ul>

	<aside class="title_line">
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Cody Stock Summary Listing</h2>
	</aside>
	<!-- title_line end -->

	<aside class="title_line"></aside>

	<section class="search_table">
		<form action="#" method="post" id="form">
			<input type="hidden" id="reportFileName" name="reportFileName" /> <input type="hidden"
				id="viewType" name="viewType" /> <input type="hidden" id="V_HSPERIOD" name="V_HSPERIOD" /> <input
				type="hidden" id="V_DEPTCODE" name="V_DEPTCODE" /> <input type="hidden" id="V_CODYCODE"
				name="V_CODYCODE" /> <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" /> <input
				type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> <input type="hidden" id="V_ORDERBYSQL"
				name="V_ORDERBYSQL" /> <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> <input
				type="hidden" id="reportDownFileName" name="reportDownFileName" />


			<table summary="search table" class="type1">

				<caption>search table</caption>
				<colgroup>
					<col style="width: 180px" />
					<col style="width: *" />
				</colgroup>


				<tbody>
					<tr>
						<th scope="row">Branch</th>
						<td><select class="w100p" id="searchBranch" name="searchBranch"></select></td>
						<th scope="row">Location Type</th>
						<td><select class="w100p" id="searchlocgb" name="searchlocgb"></select></td>
					</tr>
					<tr>
						<th scope="row">CM Group</th>
						<td><select class="w100p" id="cmgroup" onchange="fn_ChangeCMGroup()"></select></td>
						<th scope="row">Location</th>
						<td><select class="w100p" id="searchLoc" name="searchLoc"><option value="">Choose
									One</option></select></td>
					</tr>
					<tr>
						<th scope="row">HS Period</th>
						<td><input type="text" id="hsperiod" name="hsperiod" placeholder="MM/YYYY"
							class="j_date2 w100p" /></td>
					</tr>

				</tbody>
			</table>
		</form>
	</section>

	<ul class="center_btns">
		<li><p class="btn_blue2">
				<a href="#" onclick="javascript:fn_report('PDF')"><spring:message code="sal.btn.genPDF" /></a>
			</p></li>
		<li><p class="btn_blue2">
				<a href="#" onclick="javascript:fn_report('EXCEL')"><spring:message code="sal.btn.genExcel" /></a>
			</p></li>


	</ul>

</section>


