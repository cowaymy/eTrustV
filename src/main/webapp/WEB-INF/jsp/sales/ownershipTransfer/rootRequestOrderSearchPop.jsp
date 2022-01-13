<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
	var TODAY_DD = "${toDay}";

	$(document).ready(function() {
		console.log("rootRequestOrderSearch");

		// Search Order Form
		$("#sReset").attr("style", "display : none");
		$("#sOrdNoResult").attr("style", "display : none");

		$("sOrdNo").keydown(function(key) {
			if (key.keyCode == 13) {
				fn_cnfmOrdNo();
			}
		});

		//$('#btnCloseReq').click(fn_back("ordNoSearch"));
	});

	// Search Order Form functions - Start
	function fn_cnfmOrdNo() {
		console.log("fn_cnfmOrdNo");

		Common
				.ajax(
						"GET",
						"/sales/ownershipTransfer/getOrdId.do",
						$("#ordSearchForm").serialize(),
						function(result) {
							console.log(result);

							/*
							fn_changeTab
							- if order status != 4 return false;
							- if todayYY >= 2018
							  - if todayDD >= 26 || todayDD == 1 return false
							- fn_loadListOwnt > fn_loadOrderInfoOwnt > fn_isLockOrder
							 */

							if (result.code != 99) {
								// Success
								//var userid = fn_getLoginInfo();
								var todayDD = Number(TODAY_DD.substr(0, 2));
								var todayYY = Number(TODAY_DD.substr(6, 4));

								var ORD_NO = $("#sOrdNo").val();
								var ORD_ID = result.data[0].ordId;
								var ORD_STUS_ID = result.data[0].ordStusId;

								if (ORD_STUS_ID != '4') {
									var msg = '<spring:message code="sal.msg.underOwnTrans" arguments="'+ORD_NO+';'+ORD_STUS_CODE+'" argumentSeparator=";"/>';
									Common.alert(
											'<spring:message code="sal.alert.msg.actionRestriction" />'
													+ DEFAULT_DELIMITER + "<b>"
													+ msg + "</b>",
											fn_selfClose);
									return false;
								}
								/* to remove this section's comment before going live
								 if (todayYY >= 2018) {
								 if (todayDD >= 26 || todayDD == 1) {
								 var msg = '<spring:message code="sal.msg.underOwnTrans2" />';
								 Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_selfClose);
								 return false;
								 }
								 }
								 to remove this section's comment
								 */
								// fn_isLockOrder
								var isLock = false;
								var msg = "";
								if (("${orderDetail.logView.isLok}" == '1' && "${orderDetail.logView.prgrsId}" != 2)
										|| "${orderDetail.logView.prgrsId}" == 1) {
									if ("${orderDetail.logView.prgrsId}" == 1) {
										Common
												.ajaxSync(
														"GET",
														"/sales/order/checkeAutoDebitDeduction.do",
														{
															salesOrdId : ORD_ID
														},
														function(rsltInfo) {
															if (rsltInfo.ccpStus == 1
																	|| rsltInfo.eCashStus == 1) {
																isLock = true;
																msg = 'This order is under progress [ eCash Deduction ].<br />'
																		+ rsltInfo.msg
																		+ '.<br/>';
															}
														});
									} else {
										isLock = true;
										msg = 'This order is under progress ['
												+ "${orderDetail.logView.prgrs}"
												+ '].<br />';
									}
								}

								// order installation no yet complete (CallLog Type - 257, CCR0001D - 20, SAL00046 - Active )
								Common
										.ajaxSync(
												"GET",
												"/sales/order/validOCRStus.do",
												{
													salesOrdId : ORD_ID
												},
												function(result) {
													if (result.callLogResult == 1) {
														isLock = true;
														msg = 'This order is under progress [ Call for Install ].<br />'
																+ result.msg
																+ '.<br/>';
													}
												});

								// Waiting call for installation, cant do product return , ccr0006d active but SAL0046D no record */
								// Valid OCR Status - (CallLog Type - 257, CCR0001D - 1, SAL00046 - NO RECORD  )
								Common
										.ajaxSync(
												"GET",
												"/sales/order/validOCRStus2.do",
												{
													salesOrdId : ORD_ID
												},
												function(result) {
													if (result.callLogResult == 1) {
														isLock = true;
														msg = 'This order is under progress [ Call for Install ].<br />'
																+ result.msg
																+ '.<br/>';
													}
												});

								// Order cancellation no yet complete sal0020d)
								Common
										.ajaxSync(
												"GET",
												"/sales/order/validOCRStus3.do",
												{
													salesOrdId : ORD_ID
												},
												function(result) {
													if (result.callLogResult == 1) {
														isLock = true;
														msg = 'This order is under progress [ Call for Cancel ].<br />'
																+ result.msg
																+ '.<br/>';
													}
												});

								// Valid OCR Status - (CallLog Type - 259, SAL0020D - 32 LOG0038D Stus - Active )
								Common
										.ajaxSync(
												"GET",
												"/sales/order/validOCRStus4.do",
												{
													salesOrdId : ORD_ID
												},
												function(result) {
													if (result.callLogResult == 1) {
														isLock = true;
														msg = 'This order is under progress [Confirm To Cancel ].<br />'
																+ result.msg
																+ '.<br/>';
													}
												});

								if (isLock) {
									console
											.log("rootRequestOrderSearch :: fn_isLockOrder :: true - [disallowed]");
									msg += '<spring:message code="sal.alert.msg.transOwnDisallowed" />';
									Common
											.alert('<spring:message code="sal.alert.msg.ordLock" />'
													+ DEFAULT_DELIMITER
													+ "<b>"
													+ msg + "</b>");
									return false;
								} else {
									console
											.log("rootRequestOrderSearch :: fn_isLockOrder :: false - [allowed] ");

									// TO-DO :: add validation for active ROT request before pop up Request ROT
									/*
									Common.popupDiv("/sales/ownershipTransfer/requestROT.do", {salesOrderId : ORD_ID}, null, true, "requestROT");
									$("#btnCloseReq").click();
									 */

									fn_requestROT(ORD_ID);
								}

							} else {
								// Failed
								Common.alert("Order Number does not exist!");
							}
						});
	}



	function fn_searchOrdNo() {
		console.log("fn_searchOrdNo");
		Common.popupDiv('/sales/ccp/searchOrderNoPop.do', $('#sForm')
				.serializeJSON(), null, true, 'sOrdDiv');
	}

	function fn_callbackOrdSearchFunciton(item) {
		console.log(item);
		$("#sOrdNo").val(item.ordNo);
		fn_cnfmOrdNo();
	}

	function fn_resetOrdSearch() {
		console.log("fn_resetOrdSearch");
	}

	// Search Order Form functions - End
</script>

<!-- ==================== Design ==================== -->

<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
	<!-- pop_header start -->
	<header class="pop_header">
		<h1>ROT Request</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a  href="#"><spring:message
							code="sal.btn.close" /></a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<!-- pop_body start -->
	<section class="pop_body">
		<!-- Order Number Search - Start -->
		<form action="#" id="ordSearchForm" name="ordSearchForm" method="post">
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 180px" />
					<col style="width: *" />
				</colgroup>

				<tbody>
					<tr>
						<th scope="row">Order Number</th>
						<td><input type="text" title="" id="sOrdNo" name="sOrdNo"
							placeholder="" class="" />
							<p class="btn_sky" id='sCnfmOrdNo'>
								<a href="#" onclick="javascript: fn_cnfmOrdNo()"> <spring:message
										code="sal.btn.confirm" /></a>
							</p>
							<p class="btn_sky" id='sSearch'>
								<a href="#" onclick="javascript: fn_searchOrdNo()"><spring:message
										code="sal.btn.search" /></a>
							</p></td>
					</tr>
				</tbody>
			</table>
		</form>
		<!-- Order Number Search - End -->
	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->