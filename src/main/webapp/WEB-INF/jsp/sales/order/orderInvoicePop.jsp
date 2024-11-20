<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
	$(document).ready(function() {
		$('#gstType2').prop("checked", true);
		fn_makeStatementList();
	});

	function fn_makeStatementList() {

		$("#statementList")
				.append(
						"<option value='initTaxInvoiceRentalPop.do'>TaxInvoice(Rental)</option>");
		$("#statementList")
				.append(
						"<option value='initTaxInvoiceOutrightPop.do'>TaxInvoice(Outright)</option>");
		$("#statementList")
				.append(
						"<option value='initStatementCompanyRentalPop.do'>Statement Company(Rental)</option>");
		$("#statementList")
				.append(
						"<option value='initProformaInvoicePop.do'>ProformaInvoice</option>");
		$("#statementList")
				.append(
						"<option value='initAdvancedInvoiceQuotationRentalPop.do'>Advanced Invoice Quotation(Rental)</option>");
	}

	function fn_goSelectedPage() {
		var url = "/payment/" + $("#statementList").val();
		Common.popupDiv(url, {
			pdpaMonth : '${PAGE_AUTH.pdpaMonth}'
		}, null, true, "");
	}
</script>

<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->

	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Invoice Generate</h1>
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
			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th>TaxType</th>
						<td>
						   <label><input type="radio" name="gstType" id="gstType2" value="2" /><span>After GST</span></label>
						</td>
						<th scope="row">Invoice/Statement</th>
						<td><select id="statementList" name="statementList"
							class="w100p"></select></td>
					</tr>
				</tbody>
			</table>
			<ul class="center_btns">
				<li><p class="btn_blue2">
						<a href="#" onclick="javascript:fn_goSelectedPage()"><spring:message
								code='pay.btn.go' /></a>
					</p></li>
			</ul>
		</section>
		<!-- content end -->

	</section>
	<!-- container end -->
</div>
<!-- popup_wrap end -->