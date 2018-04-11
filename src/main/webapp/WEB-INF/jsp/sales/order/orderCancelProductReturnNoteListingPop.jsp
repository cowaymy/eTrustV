<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">
	/* 멀티셀렉트 플러그인 start */
	var date = new Date().getDate();
	$('.multy_select').change(function() {
		console.log($(this).val());
	}).multipleSelect({
		width : '100%'
	});

	/* doGetComboSepa("/common/selectBranchCodeList.do", '5', '-', '', 'dscCode',
			'S', ''); */


	CommonCombo.make('cmbAppType', '/sales/order/getApplicationTypeList', {
		codeId : 10
	}, '', {
		type : 'M'
	});
	doGetComboCodeId('/sales/order/getRetReasonList', {
		typeId : 287,
		typeId1 : 537,
		typeId2 : 538,
		inputId : 1,
		separator : '-'
	}, '', 'cmbRetReason', 'S'); //Reason Code

	   doGetComboCodeId('/sales/order/getBranchList', {
		   typeId : 43,
	        separator : '-'
	    }, '', 'cmbDscCode', 'S'); //Branch Code

	$.fn.clearForm = function() {

		//$("#cmbProductRetType").multipleSelect("checkAll");
		$("#cmbAppType").multipleSelect("checkAll");
		$("#cmbProductRetStatus").multipleSelect("checkAll");
		$("#form")[0].reset();

	};

	function btnGenerate_Click(val) {
		var retType = "";
		var orderNo = "";
		var ocrNo = "";
		var retNo = "";
		var appDate = "";
		var assignCT = "";
		var ctGroup = "";
		var dscBranch = "";
		var appType = "";
		var retStatus = "";
		var retDate = "";
		var actionCT = "";
		var reqDate = "";
		var returnReason = "";
		var orderBy = "";
		//LIST FIELD
		var dscBranchCode = "All";
		var whereSQL = "";
		var orderBySQL = "";

        var reportDownFileName = ""; //download report name
        var reportFileName = ""; //reportFileName
        var reportViewType = ""; //viewType

        $("#reportForm").append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
        $("#reportForm").append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
        $("#reportForm").append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
              };


		if ($("#cmbProductRetType :selected").length > 0) {
			retType = $("#cmbProductRetType :selected").val();

		}

		if (!($("#txtOrderNoFrom").val() == null
				|| $("#txtOrderNoFrom").val().length == 0
				|| $("#txtOrderNoTo").val() == null || $("#txtOrderNoTo").val().length == 0)) {

			orderNo = "AND (som.SALES_ORD_NO between '"
					+ $("#txtOrderNoFrom").val().trim() + "' AND '"
					+ $("#txtOrderNoTo").val().trim() + "') ";
		}

		if (!($("#txtOCRNoFrom").val() == null
				|| $("#txtOCRNoFrom").val().length == 0
				|| $("#txtOCRNoTo").val() == null || $("#txtOCRNoTo").val().length == 0)) {
			ocrNo = "AND (rc.SO_REQ_NO between '"
					+ $("#txtOCRNoFrom").val().trim() + "' AND '"
					+ $("#txtOCRNoTo").val().trim() + "') ";

		}

		if (!($("#txtRetNoFrom").val() == null
				|| $("#txtRetNoFrom").val().length == 0
				|| $("#txtRetNoTo").val() == null || $("#txtRetNoTo").val().length == 0)) {
			retNo = "AND (re.RETN_NO between '"
					+ $("#txtRetNoFrom").val().trim() + "' AND '"
					+ $("#txtRetNoTo").val().trim() + "') ";

		}

		if (!($("#dpAppointmentDtFrom").val() == null
				|| $("#dpAppointmentDtFrom").val().length == 0
				|| $("#dpAppointmentDtTo").val() == null || $(
				"#dpAppointmentDtTo").val().length == 0)) {
			appDate = "AND (TO_CHAR(re.APP_DT,'DD/MM/YYYY') between '"
					+ $("#dpAppointmentDtFrom").val() + "' AND '"
					+ $("#dpAppointmentDtTo").val() + "') ";

		}

		if (!($("#txtAssignCTFrom").val() == null
				|| $("#txtAssignCTFrom").val().length == 0
				|| $("#txtAssignCTTo").val() == null || $("#txtAssignCTTo")
				.val().length == 0)) {

			if (val == "NOTE") {
				assignCT = "AND (ct1.MEM_CODE between '"
						+ $("#txtAssignCTFrom").val().trim() + "' and '"
						+ $("#txtAssignCTTo").val().trim() + "') ";
			} else if (val == "LIST") {
				assignCT = "AND (m.MEM_CODE between '"
						+ $("#txtAssignCTFrom").val().trim() + "' and '"
						+ $("#txtAssignCTTo").val().trim() + "') ";

			}

		}

		if ($("#CTGroup :selected").index() > 0) {

			ctGroup = "AND re.CT_GRP = '" + $("#CTGroup").val() + "' ";
		}

		if ($("#cmbDscCode :selected").index() > 0) {

			dscBranch = "AND i.BRNCH_ID = " + $("#cmbDscCode").val() + " ";
			dscBranchCode = $("#cmbDscCode").val();

		}

		if (!($("#dpReqDtFrom").val() == null
				|| $("#dpReqDtFrom").val().length == 0
				|| $("#dpReqDtTo").val() == null || $("#dpReqDtTo").val().length == 0)) {
			if (retType == 296) {
				reqDate = " AND (TO_CHAR(rc.SO_REQ_CRT_DT,'DD/MM/YYYY') between '"
						+ $("#dpReqDtFrom").val() + "' AND '"
						+ $("#dpReqDtTo").val() + "') ";
			} else if (retType == 297) {
				reqDate = " AND (TO_CHAR(soe.SO_EXCHG_CRT_DT,'DD/MM/YYYY') between '"
						+ $("#dpReqDtFrom").val() + "' AND '"
						+ $("#dpReqDtTo").val() + "') ";
			}

		}

		if (!($("#cmbProductRetStatus").val() == null)) {
			retStatus += "AND (";
			$('#cmbProductRetStatus :selected').each(
					function(i, mul) {
						if (i > 0) {
							retStatus += " OR re.STUS_CODE_ID = '"
									+ $(mul).val() + "' ";

						} else {
							retStatus += " re.STUS_CODE_ID = '" + $(mul).val()
									+ "' ";

						}
						i += 1;
					});
			retStatus += ") ";
			i = 0;
		}

		if (!($("#cmbAppType").val() == null)) {
			appType += "AND (";
			$('#cmbAppType :selected').each(
					function(i, mul) {
						if (i > 0) {
							appType += " OR som.APP_TYPE_ID  = '"
									+ $(mul).val() + "' ";

						} else {
							appType += " som.APP_TYPE_ID = '" + $(mul).val()
									+ "' ";

						}
						i += 1;
					});
			appType += ") ";
			i = 0;
		}

		if (!($("#dpRetDtFrom").val() == null
				|| $("#dpRetDtFrom").val().length == 0
				|| $("#dpRetDtTo").val() == null || $("#dpRetDtTo").val().length == 0)) {

			retDate = "AND (TO_CHAR(rr.STK_RETN_DT,'DD/MM/YYYY') between '" + $("#dpRetDtFrom").val()
					+ "' AND '" + $("#dpRetDtTo").val() + "') ";
		}

		if (!($("#txtActionCTFrom").val() == null
				|| $("#txtActionCTFrom").val().length == 0
				|| $("#txtActionCTTo").val() == null || $("#txtActionCTTo")
				.val().length == 0)) {

			if (val == "NOTE")
				actionCT = "AND (ct2.MEM_CODE between '"
						+ $("#txtActionCTFrom").val().trim() + "' AND '"
						+ $("#txtActionCTTo").val().trim() + "') ";
			else if (val == "LIST")
				actionCT = "AND (m2.MEM_CODE between '"
						+ $("#txtActionCTFrom").val().trim() + "' AND '"
						+ $("#txtActionCTTo").val().trim() + "') ";
		}

		if ($("#cmbRetReason :selected").index() > 0) {

			returnReason = "AND rr.STK_RETN_RESN_ID = '"
					+ $("#cmbRetReason").val() + "' ";

		}

		if ($("#SortBy :selected").index() > 0) {

			if ($("#SortBy").val() == "1") {
				orderBy = "ORDER BY rc.SO_REQ_NO ";
			} else if ($("#SortBy").val() == "2") {
				orderBy = "ORDER BY re.RET_NO ";
			} else if ($("#SortBy").val() == "3") {
				orderBy = "ORDER BY som.SALES_ORD_NO ";
			} else if ($("#SortBy").val() == "4") {
				if (val == "NOTE") {
					orderBy = "ORDER BY ct1.MEM_CODE ";
				} else if (val == "LIST") {
					orderBy = "ORDER BY m.MEM_CODE ";
				}
			}

		}




		if (val == "NOTE") {

		     reportFileName = "/sales/ProductReturnNote.rpt"; //reportFileName
		     //set parameters
		        $("#reportForm").append('<input type="hidden" id="V_RETTYPE" name="V_RETTYPE" value="" /> ');
		        $("#reportForm").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" /> ');
		        $("#reportForm").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" /> ');
		        reportDownFileName = "ProductReturnNote_" + date+(new Date().getMonth()+1)+new Date().getFullYear(); //report name
		        reportViewType = "PDF"; //viewType

	         whereSQL += orderNo + ocrNo + retNo + appDate + assignCT + ctGroup
             + dscBranch + reqDate + retStatus + appType + retDate
             + actionCT;

			orderBySQL = orderBy;


			    $("#V_RETTYPE").val(retType);
	            $("#V_WHERESQL").val(whereSQL);
	            $("#V_ORDERBYSQL").val(orderBySQL);

	            $("#reportForm #reportFileName").val(reportFileName);
	            $("#reportForm #reportDownFileName").val(reportDownFileName);
	            $("#reportForm #viewType").val(reportViewType);

	            //  report 호출

	            Common.report("reportForm", option);


		}
	 	else if (val == "LIST") {

            reportFileName = "/sales/ProductRetNoteList.rpt"; //reportFileName
            //set parameters
        $("#reportForm").append('<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" /> ');
        $("#reportForm").append('<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" /> ');
        $("#reportForm").append('<input type="hidden" id="V_DSCBRANCHCODE" name="V_DSCBRANCHCODE" value="" /> ');
        reportDownFileName = "ProductReturnNoteList_" +date+(new Date().getMonth()+1)+new Date().getFullYear(); //report name
        reportViewType = "PDF"; //viewType

			whereSQL += orderNo + ocrNo + retNo + appDate + assignCT + ctGroup
					+ dscBranch + reqDate + retStatus + appType + retDate
					+ actionCT + returnReason;

			orderBySQL = orderBy;

			$("#V_WHERESQL").val(whereSQL);
			$("#V_ORDERBYSQL").val(orderBySQL);
			$("#V_DSCBRANCHCODE").val(dscBranchCode);

		       $("#reportForm #reportFileName").val(reportFileName);
		        $("#reportForm #reportDownFileName").val(reportDownFileName);
		        $("#reportForm #viewType").val(reportViewType);

		        //  report 호출

		        Common.report("reportForm", option);

		}

	}



</script>
<form name="reportForm" id="reportForm"></form>
<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->

	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Product Return Note</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="sal.btn.close" /></a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<section class="pop_body">
		<!-- pop_body start -->

		<aside class="title_line">
			<!-- title_line start -->

		</aside>
		<!-- title_line end -->

		<section class="search_table">
			<!-- search_table start -->
			<form action="#" method="post" id="form">

				<table class="type1">
					<!-- table start -->
					<caption>table</caption>

					<tbody>
						<tr>
							<th scope="row">Product Return Type</th>
							<td><select class="w100p" id="cmbProductRetType">
									<option value="296" selected>Order Cancellation
										Product Return</option>
									<option value="297" selected>Product Exchange Product
										Return</option>
							</select></td>
							<th scope="row">Return Status</th>
							<td><select class="multy_select w100p" multiple="multiple"
								id="cmbProductRetStatus">
									<option value="1" selected>Active</option>
									<option value="4" selected>Completed</option>
									<option value="21" selected>Failed</option>
							</select></td>
						</tr>

						<tr>
							<th scope="row">Order Number</th>
							<td>
								<div class="date_set w100p">
									<p>
										<input type="text" title="" class="w100p" id="txtOrderNoFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="" class="w100p" id="txtOrderNoTo" />
									</p>
								</div>
							</td>
							<th scope="row"><spring:message code="sal.text.appType" /></th>
							<td><select class="multy_select w100p" multiple="multiple"
								id="cmbAppType"></select></td>
						</tr>

						<tr>
							<th scope="row">Request Date</th>
							<td>
								<div class="date_set w100p">
									<!-- date_set start -->
									<p>
										<input type="text" title="Request Date From"
											placeholder="DD/MM/YYYY" class="j_date" id="dpReqDtFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="Request Date End"
											placeholder="DD/MM/YYYY" class="j_date" id="dpReqDtTo" />
									</p>
								</div> <!-- date_set end -->
							</td>
							<th scope="row">OCR Number</th>
							<td>
								<div class="date_set w100p">
									<p>
										<input type="text" title="" class="w100p" id="txtOCRNoFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="" class="w100p" id="txtOCRNoTo" />
									</p>
								</div>
							</td>
						</tr>

						<tr>
							<th scope="row">Return Date</th>
							<td>
								<div class="date_set w100p">
									<!-- date_set start -->
									<p>
										<input type="text" title="Return Date From"
											placeholder="DD/MM/YYYY" class="j_date" id="dpRetDtFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="Return Date End"
											placeholder="DD/MM/YYYY" class="j_date" id="dpRetDtTo" />
									</p>
								</div> <!-- date_set end -->
							</td>
							<th scope="row">Return Number</th>
							<td>
								<div class="date_set w100p">
									<p>
										<input type="text" title="" class="w100p" id="txtRetNoFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="" class="w100p" id="txtRetNoTo" />
									</p>
								</div>
							</td>
						</tr>

						<tr>
							<th scope="row">Assign CT</th>
							<td>
								<div class="date_set w100p">
									<p>
										<input type="text" title="" class="w100p" id="txtAssignCTFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="" class="w100p" id="txtAssignCTTo" />
									</p>
								</div>
							</td>
							<th scope="row">Action CT</th>
							<td>
								<div class="date_set w100p">
									<p>
										<input type="text" title="" class="w100p" id="txtActionCTFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="" class="w100p" id="txtActionCTTo" />
									</p>
								</div>
							</td>
						</tr>

						<tr>
							<th scope="row">Appointment Date</th>
							<td>
								<div class="date_set w100p">
									<!-- date_set start -->
									<p>
										<input type="text" title="Appointment start Date"
											placeholder="DD/MM/YYYY" class="j_date"
											id="dpAppointmentDtFrom" />
									</p>
									<span><spring:message code="sal.text.to" /></span>
									<p>
										<input type="text" title="Appointment end Date"
											placeholder="DD/MM/YYYY" class="j_date"
											id="dpAppointmentDtTo" />
									</p>
								</div> <!-- date_set end -->
							</td>
							<th scope="row">CT Group</th>
							<td><select class="w100p" id="CTGroup">
									<option value="">Choose One</option>
									<option value="A">A</option>
									<option value="B">B</option>
									<option value="C">C</option>
							</select></td>
						</tr>

						<tr>
<%-- 							<th scope="row"><spring:message code='service.title.DSCCode' /></th>
							<td><select class="w100p" id="dscCode" name="dscCode">
							</select></td>
							 --%>
							 <th scope="row">DSC Code</th>
                            <td><select class="w100p" id="cmbDscCode"
                                name="cmbDscCode"></select></td>

							<th scope="row">Sort By</th>
							<td><select class="w100p" id="SortBy">
									<option value="" selected>Choose One</option>
									<option value="1">OCR Number</option>
									<option value="2">Return Number</option>
									<option value="3">Order Number</option>
									<option value="4">Assign CT</option>
							</select></td>
						</tr>
						<tr>
							<th scope="row">Return Reason</th>
							<td><select class="w100p" id="cmbRetReason"
								name="cmbRetReason"></select></td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->

			</form>

			<div style="height: 80px"></div>
			<ul class="center_btns">
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:btnGenerate_Click('NOTE');">Generate
							Note</a>
					</p></li>
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:btnGenerate_Click('LIST');">Generate
							Listing</a>
					</p></li>
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:$('#form').clearForm();"><span
							class="clear"></span> <spring:message code="sal.btn.clear" /></a>
					</p></li>
			</ul>
		</section>
		<!-- content end -->

	</section>
	<!-- container end -->

</div>
<!-- popup_wrap end -->
