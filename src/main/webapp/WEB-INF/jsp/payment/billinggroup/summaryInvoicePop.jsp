<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	var myGridID;
	var gridViewData = null;

	var gridPros = {
		editable : false,
		showStateColumn : false,
		pageRowCount : 25
	};

	var columnLayout = [ {
		dataField : "orderNo",
		headerText : "<spring:message code='pay.head.orderNO'/>",
		editable : false
	}, {
		dataField : "customerName",
		headerText : "<spring:message code='pay.head.custName'/>",
		editable : false
	}, {
		dataField : "docNo",
		headerText : "<spring:message code='pay.head.docNo'/>",
		editable : false
	}, {
		dataField : "invoiceDate",
		headerText : "<spring:message code='pay.head.invoiceDate'/>",
		dataType : "date",
		editable : false
	}, {
		dataField : "invoiceAmount",
		headerText : "<spring:message code='pay.head.invoiceAmount'/>",
		editable : false
	} ];

	$(document).ready(
			function() {

				myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,
						null, gridPros);

/* 				// Master Grid 셀 클릭시 이벤트
				AUIGrid.bind(myGridID, "cellClick", function(event) {
					selectedGridValue = event.rowIndex;
				}); */

			});

	function fn_InvRefDt(field) {
		$("#" + field + "").val("");
	}

	function fn_clear() {
		$("#searchForm")[0].reset();
		gridViewData = null;
		AUIGrid.clearGridData(myGridID);
	}

	function fn_getSummaryInvoiceListAjax() {

		if (FormUtil.isEmpty($("#custID").val())
				&& FormUtil.isEmpty($("#refNo").val())) {
			Common.alert("<spring:message code='pay.msg.feildsRequired1' />");
			return;

		}

		else if ($("#custID").val() != "") {
			if (FormUtil.isEmpty($("#invoiceRefDate").val())) {
				Common
						.alert("<spring:message code='pay.msg.feildsRequired2' />");
				return;
			}

			else {
				Common.ajax("GET", "/payment/selectSummaryInvoiceList.do", $(
						"#searchForm").serialize(), function(result) {
					gridViewData = result;
					console.log('CustId!=empty: ',result);
					AUIGrid.setGridData(myGridID, result);
				});
			}
		} else {
			Common.ajax("GET", "/payment/selectSummaryInvoiceList.do", $(
					"#searchForm").serialize(), function(result) {
				console.log("----------------------------");
				console.log(result);
				gridViewData = result;
				console.log('gridViewData', gridViewData);
				if (result == null && result.length == 0) {
					gridViewData = null;
				}
				AUIGrid.setGridData(myGridID, result);
			});
		}
	}

	//Generate pdf report button
	function fn_pdfDown(result) {
		console.log(result);
		if (result.length == 0) {
			Common
					.alert("<spring:message code='customer.alert.msg.nodataingridview' />");
		} else {
			fn_report("PDF");
		}
	}

	function fn_report(viewType) {

		$("#reportFileName").val("");
		$("#reportDownFileName").val("");
		$("#viewType").val("");

		var V_WhereSQL1 = "";
		var V_WhereSQL2 = "";
		var V_CUST_ID = $("#custID").val();
		var V_MMYYYY = $("#invoiceRefDate").val();
		var V_REF_NO = $("#refNo").val();

		if (V_CUST_ID != null && V_CUST_ID.length != 0) {
			V_WhereSQL1 = " AND  CUST_ID = '" + V_CUST_ID + "'";
			V_WhereSQL2 = " AND  A.CUST_ID = '" + V_CUST_ID + "'";
		}
		if (V_MMYYYY != null && V_MMYYYY.length != 0) {
			V_WhereSQL2 = V_WhereSQL2 + " AND  TO_CHAR(TAX_INVC_REF_DT,'MMYYYY') = TO_CHAR( TO_DATE('"
					+ V_MMYYYY +"' , 'MM/YYYY'),'MMYYYY')";
		}
		if (V_REF_NO != null && V_REF_NO.length != 0) {
			V_WhereSQL2 = " AND  C.TAX_INVC_REF_NO  = '" + V_REF_NO + "'";
		}

		console.log("V_WhereSQL1" + V_WhereSQL1);
		console.log("V_WhereSQL2" + V_WhereSQL2);
      	console.log("V_CUST_ID" + V_CUST_ID);
		/*console.log("V_MMYYYY" + V_MMYYYY);
		console.log("V_REF_NO" + V_REF_NO); */
		var date = new Date().getDate();
		if (date.toString().length == 1) {
			date = "0" + date;
		}
		$("#reportDownFileName").val(
				"PUBLIC_SummaryofInvoice_" + date + (new Date().getMonth() + 1)
						+ new Date().getFullYear());
		$("#form #viewType").val("PDF");
		$("#form #reportFileName").val("/statement/SummaryOfInvoice.rpt");

		$("#form #V_WhereSQL1").val(V_WhereSQL1);
		$("#form #V_WhereSQL2").val(V_WhereSQL2);
/* 		$("#form #V_CUST_ID").val(V_CUST_ID);
		$("#form #V_MMYYYY").val(V_MMYYYY);
		$("#form #V_REF_NO").val(V_REF_NO); */
		// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
		var option = {
			isProcedure : true
		// procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
		};

		Common.report("form", option);

	}
</script>

<div id="popup_wrap" class="popup_wrap size_large">
	<!-- popup_wrap start -->

	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Summary of Invoice</h1>

		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>

	</header>
	<!-- pop_header end -->

	<section class="pop_body" style="min-height: auto;">
		<!-- pop_body start -->
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a href="javascript:fn_pdfDown(gridViewData);"><spring:message
							code='pay.btn.invoice.generate' /></a>
				</p></li>
			<li><p class="btn_blue">
					<a href="javascript:fn_getSummaryInvoiceListAjax();"><span
						class="search"></span> <spring:message code='sys.btn.search' /></a>
				</p></li>
			<li><p class="btn_blue">
					<a href="javascript:fn_clear();"><span class="clear"></span> <spring:message
							code='sys.btn.clear' /></a>
				</p></li>
		</ul>

		<!-- search_table start -->
		<section class="search_table">
			<form name="searchForm" id="searchForm" method="post">
				<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 200px" />
						<col style="width: *" />
						<col style="width: 200px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Customer ID</th>
							<td colspan="3"><input id="custID" name="custID"
								 placeholder="Customer ID (Number Only)" type="text" class="w100p" /></td>
						</tr>
						<tr>
							<th scope="row">Period</th>
							<td colspan="3"><p style="width: 70%">
									<input id="invoiceRefDate" name="invoiceRefDate" type="text"
										title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p"
										readonly />
								</p>
								<p class="btn_gray">
									<a href="#" onclick="fn_InvRefDt('invoiceRefDate')">Clear</a>
								</p></td>
						</tr>
						<tr>
							<th scope="row">Summary Invoice Ref No</th>
							<td colspan="3"><input id="refNo" name="refNo" type="text"
								class="w100p" /></td>
						</tr>
					</tbody>
				</table>
			</form>
		</section>

		<form id="form">
			<input type="hidden" id="reportFileName" name="reportFileName"
				value="" /> <input type="hidden" id="viewType" name="viewType"
				value="" /> <input type="hidden" id="reportDownFileName"
				name="reportDownFileName" value="" /> <input type="hidden"
				id="V_CUST_ID" name="V_CUST_ID" value="" /> <input type="hidden"
				id="V_MMYYYY" name="V_MMYYYY" value="" /> <input type="hidden"
				id="V_REF_NO" name="V_REF_NO" value="" /> <input type="hidden"
				id="V_WhereSQL1" name="V_WhereSQL1" value="" /><input type="hidden"
				id="V_WhereSQL2" name="V_WhereSQL2" value="" />
		</form>

		<!-- search_result start -->
		<section class="search_result">
			<!-- grid_wrap start -->
			<article id="grid_wrap" class="grid_wrap"></article>
			<!-- grid_wrap end -->
		</section>
	</section>
	</section>




</div>
<!-- popup_wrap end -->