<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/moment.min.js"></script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
	text-align: left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
	text-align: right;
}
</style>
<script>
	var generateCampaignId;

	$(document)
	.ready(
			function() {
				generateCampaignId = "${campaignId}";
			});
	function fn_generateVoucher() {
		if ($('#voucherGenAmount').val() < 0
				|| $('#voucherGenAmount').val() > 1000) {
			Common
					.alert("Maximum voucher allow to be generate are 1000 voucher only.");
			return false;
		}

		Common.ajax("POST", "/misc/voucher/generateVoucher.do", {
			campaignId : generateCampaignId,
			voucherGenAmount : $('#voucherGenAmount').val()
		}, function(result) {
			if (result.code == "00") {
				$("#voucherGeneratePop").remove();
				fn_getVoucherList();
			} else {
				Common.alert("Error: " + result.message);
				return;
			}
		});
	}
</script>

<div id="popup_wrap" class="popup_wrap size_small">
	<!-- popup_wrap start -->
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Voucher Generate</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<section class="pop_body">
		<section class="search_table">
			<!-- pop_body start -->
			<table class="type1">
				<caption>
					<spring:message code="webInvoice.table" />
				</caption>
				<colgroup>
					<col style="width: 150px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Number of voucher generate</th>
						<td><input type="number" title="Amount" placeholder="Amount"
							class="w100p" id="voucherGenAmount" name="voucherGenAmount"/></td>
					</tr>
				</tbody>
			</table>
		</section>

		<section class="search_result">
			<ul class="center_btns">
				<li><p class="btn_blue2">
						<a href="#" id="btn_create"
							onclick="javascript:fn_generateVoucher()">Confirm</a>
					</p></li>
			</ul>
		</section>
	</section>
</div>