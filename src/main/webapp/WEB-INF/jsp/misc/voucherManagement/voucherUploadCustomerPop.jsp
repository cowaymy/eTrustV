<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

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
	var voucherCsvUploadGridID;
	var uploadCampaignID;
	var selectedUploadGridValue;
	var voucherCsvUploadColumnLayout = [ {
		dataField : "0",
		headerText : "Voucher Code",
		editable : false
	}, {
		dataField : "1",
		headerText : "Customer Email",
		editable : false
	}, {
		dataField : "2",
		headerText : "Sales Order No",
		editable : false
	} ];

	var voucherCsvUploadGridPros = {
		// 페이징 사용
		usePaging : true,
		// 한 화면에 출력되는 행 개수 20(기본값:20)
		pageRowCount : 20,
		// 헤더 높이 지정
		headerHeight : 30,
		// 셀 선택모드 (기본값: singleCell)

		showRowCheckColumn : false,

		softRemoveRowMode : false
	};

	$(document)
			.ready(
					function() {
						console.log("voucherUploadCustomerPop.jsp");
						uploadCampaignID = "${campaignId}";
						voucherCsvUploadGridID = GridCommon.createAUIGrid(
								"cvs_grid_upload_wrap",
								voucherCsvUploadColumnLayout, null,
								voucherCsvUploadGridPros);

						AUIGrid
								.bind(
										voucherCsvUploadGridID,
										"cellClick",
										function(event) {
											selectedUploadGridValue = event.rowIndex;
											var item = event.item, rowIdField, rowId, rowOrNo;

											rowIdField = AUIGrid.getProp(
													event.pid, "rowIdField");
											rowId = item[rowIdField];

											// check if already checked
											if (AUIGrid.isCheckedRowById(
													event.pid, rowId)) {
												// Add extra checkbox unchecked
												AUIGrid.addUncheckedRowsByIds(
														event.pid, rowId);

											} else {
												// add extra checkbox check
												AUIGrid.addCheckedRowsByIds(
														event.pid, rowId);
											}
										});

						AUIGrid
								.bind(
										voucherCsvUploadGridID,
										"rowCheckClick",
										function(event) {
											var item = event.item, rowIdField, rowId, rowOrNo;

											// check if already checked
											if (AUIGrid.isCheckedRowById(
													event.pid, rowId)) {
												// Add extra checkbox unchecked
												AUIGrid.addUncheckedRowsByIds(
														event.pid, rowId);
											} else {
												// add extra checkbox check
												AUIGrid.addCheckedRowsByIds(
														event.pid, rowId);
											}
										});

						AUIGrid
								.bind(
										voucherCsvUploadGridID,
										"rowAllChkClick",
										function(event) {
											var item = event.item, rowIdField, rowId, rowOrNo;

											// check if already checked
											if (AUIGrid.isCheckedRowById(
													event.pid, rowId)) {
												// Add extra checkbox unchecked
												AUIGrid.addUncheckedRowsByIds(
														event.pid, rowId);
											} else {
												// add extra checkbox check
												AUIGrid.addCheckedRowsByIds(
														event.pid, rowId);
											}
										});

						$('#uploadfile')
								.on(
										'change',
										function(evt) {
											if (!checkHTML5Brower()) {
												commitFormSubmit();

											} else {
												var data = null;
												var file = evt.target.files[0];
												if (typeof file == "undefined") {
													return;
												}

												var reader = new FileReader();
												reader.readAsText(file,
														"EUC-KR");
												reader.onload = function(event) {
													if (typeof event.target.result != "undefined") {
														AUIGrid
																.setCsvGridData(
																		voucherCsvUploadGridID,
																		event.target.result,
																		false);

														AUIGrid
																.removeRow(
																		voucherCsvUploadGridID,
																		0);
													} else {
														Common
																.alert("<spring:message code='pay.alert.noData'/>");
													}
												};

												reader.onerror = function() {
													Common
															.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
												};
											}

										});

					});

	function checkHTML5Brower() {
		var isCompatible = false;
		if (window.File && window.FileReader && window.FileList && window.Blob) {
			isCompatible = true;
		}

		return isCompatible;
	}

	function commitFormSubmit() {
		AUIGrid.showAjaxLoader(voucherCsvUploadGridID);

		$('#uploadForm').ajaxSubmit({
			type : "json",
			success : function(responseText, statusText) {
				if (responseText != "error") {
					var csvText = responseText;

					csvText = csvText.replace(/\r?\n/g, "\r\n")

					AUIGrid.setCsvGridData(voucherCsvUploadGridID, csvText);
					AUIGrid.removeAjaxLoader(voucherCsvUploadGridID);

					AUIGrid.removeRow(voucherCsvUploadGridID, 0);
				}
			},
			error : function(e) {
				Common.alert("ajaxSubmit Error : " + e);
			}
		});
	}

	function fn_uploadClear() {
		$("#uploadForm")[0].reset();
		AUIGrid.clearGridData(voucherCsvUploadGridID);
	}

	function fn_uploadCSV() {
		if (fn_validation()) {
			var formData = new FormData();
			var confirmMsg = "Confirm Upload? Only once is allowed.";

			formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
			formData.append("campaignId", uploadCampaignID);

			Common.confirm(confirmMsg, function() {
				Common.ajaxFile("/misc/voucher/csvFileUpload.do", formData,
						function(result) {
							if (result.code == "00") {
								Common.alert(result.message, function() {
									Common.popupDiv("/misc/voucher/voucherListViewPop.do", {campaignId: uploadCampaignID}, null,
											true, "voucherListViewPop");
									$('#voucherUploadCustomerPop').remove();
								});
							}
						});
			});
		}
	}

	function fn_validation() {

		var data = GridCommon.getGridData(voucherCsvUploadGridID);
		var length = data.all.length;

		if (length < 1) {
			Common
					.alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
			return false;
		}

		if (length > 0) {
			for (var i = 0; i < length - 1; i++) {
				if (fn_checkMandatory((AUIGrid.getCellValue(
						voucherCsvUploadGridID, i, "0")))) {
					var text = 'Voucher Code';
					Common.alert(text + " is mandatory.");
					return false;
				}
				if (fn_checkMandatory((AUIGrid.getCellValue(
						voucherCsvUploadGridID, i, "1")))) {
					var text = 'Customer Email';
					Common.alert(text + " is mandatory.");
					return false;
				}
				if (fn_checkMandatory((AUIGrid.getCellValue(
						voucherCsvUploadGridID, i, "2")))) {
					var text = 'Order ID';
					Common.alert(text + " is mandatory.");
					return false;
				}
				if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
						.test(AUIGrid.getCellValue(voucherCsvUploadGridID, i,
								"1")))) {
					Common.alert("Email format is invalid for "
							+ AUIGrid.getCellValue(voucherCsvUploadGridID, i,
									"1"));
					return false;
				}
			}
		}
		return true;
	}

	function fn_checkMandatory(objValue) {

		if (objValue == null || objValue == "" || objValue == "undefined") {
			return true;
		}
	}

	function onlyNumber(obj) {
		$(obj).keyup(function() {
			$(this).val($(this).val().replace(/[^0-9]/g, ""));
		});
	}
</script>

<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Voucher List</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>
	</header>

	<section class="pop_body">
		<form action="#" method="post" id="uploadForm">
			<!-- pop_body start -->
			<table class="type1">
				<caption>
					<spring:message code="webInvoice.table" />
				</caption>
				<colgroup>
					<col style="width: 150px" />
					<col style="width: *" />
					<col style="width: 150px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">File</th>
						<td>
							<div class="auto_file">
								<input type="file" title="file add" id="uploadfile"
									name="uploadfile" /> <label> <span class="label_text"><a
										id="txtFileInput" href="#">File</a></span> <input class="input_text"
									type="text" readonly="readonly">
								</label>
							</div>
						</td>
						<th scope="row"></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</form>
		<section>
			<ul class="center_btns mt20">
				<li>
					<p class="btn_blue2">
						<a href="#" onclick="javascript:fn_uploadClear()">Clear</a> <a
							href="#" onclick="javascript:fn_uploadCSV()">Upload File</a> <a
							href="${pageContext.request.contextPath}/resources/download/misc/VoucherUploadTemplate.csv">Download
							CSV Format</a>
					</p>
				</li>
			</ul>

			<article class="grid_wrap" id="cvs_grid_upload_wrap"></article>
		</section>
	</section>
</div>