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
	var voucherListGridID;
	var voucherListExcelGridID;
	var campaignID;
	var voucherListColumnLayout = [ {
		dataField : "detailId",
		headerText : 'ID',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "voucherCode",
		headerText : 'Voucher',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "custEmail",
		headerText : 'Customer Email',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "ordId",
		headerText : 'Order ID',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "stusName",
		headerText : 'Status',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "used",
		headerText : 'Used',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "emailSent",
		headerText : 'Email Sent',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "crtDt",
		headerText : 'Created Date',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "stusCodeId",
		style : "aui-grid-user-custom-left",
		visible : false
	}  ];

	var voucherListGridPros = {
		// 페이징 사용
		usePaging : true,
		// 한 화면에 출력되는 행 개수 20(기본값:20)
		pageRowCount : 20,
		// 헤더 높이 지정
		headerHeight : 30,
		// 셀 선택모드 (기본값: singleCell)

		showRowCheckColumn : true
	};

	var voucherListExcelColumnLayout = [
	{
		dataField : "id",
		headerText : 'Batch',
		style : "aui-grid-user-custom-left"
	},{
		dataField : "detailId",
		headerText : 'ID',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "masterCode",
		headerText : 'Master Code',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "title",
		headerText : 'Title',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "platform",
		headerText : 'Platform',
		style : "aui-grid-user-custom-left"
	},{
		dataField : "voucherCode",
		headerText : 'Voucher',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "custEmail",
		headerText : 'Customer Email',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "ordId",
		headerText : 'Order ID',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "stusName",
		headerText : 'Status',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "used",
		headerText : 'Used',
		style : "aui-grid-user-custom-left"
	},{
		dataField : "emailSent",
		headerText : 'Email Sent',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "crtDt",
		headerText : 'Created Date',
		style : "aui-grid-user-custom-left"
	} ];

	$(document)
			.ready(
					function() {
						console.log("voucherListViewPop.jsp");
						doGetComboOrder('/common/selectCodeList.do', '562', 'CODE_NAME',
								'', 'platform', 'S', 'setDropdownValue');
						doGetComboOrder('/common/selectCodeList.do', '563', 'CODE_NAME',
								'', 'module', 'S', 'setDropdownValue');

						var startDate, endDate, status, title, masterCode;
						startDate = "${campaignDetail.startDate}";
						endDate = "${campaignDetail.endDate}";
						status = "${campaignDetail.stusCodeId}";
						title = "${campaignDetail.title}";
						masterCode = "${campaignDetail.masterCode}";
						campaignID = "${campaignDetail.id}";
						$('#startDate').val(startDate);
						$('#endDate').val(endDate);
						$('#campaignId').val(campaignID);
						$('#status').val(status);
						$('#title').val(title);
						$('#masterCode').val(masterCode);

						voucherListGridID = AUIGrid.create(
								"#voucher_list_grid_wrap",
								voucherListColumnLayout, voucherListGridPros);

						voucherListExcelGridID = AUIGrid.create(
								"#voucher_list_excel_grid_wrap",
								voucherListExcelColumnLayout, voucherListGridPros);

						AUIGrid
								.bind(
										voucherListGridID,
										"cellClick",
										function(event) {
											selectedGridValue = event.rowIndex;
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
										voucherListGridID,
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
										voucherListGridID,
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

						fn_getVoucherList();
					});

	function setDropdownValue(){
		$('#platform').val("${campaignDetail.platform}");
		$('#module').val("${campaignDetail.moduleType}");
	}

	function fn_getVoucherList() {
		Common.ajax("GET", "/misc/voucher/getVoucherList.do", {
			campaignId : campaignID,
			voucher : $('#voucher').val()
		}, function(result) {
			AUIGrid.setGridData(voucherListGridID, result);
		});
	}

	function fn_voucherGeneratePop() {
		Common.popupDiv("/misc/voucher/voucherGeneratePop.do", {campaignId:campaignID},
				null, true, "voucherGeneratePop");
	}

	function fn_activateVoucher(){
		var selectedItemList = AUIGrid.getCheckedRowItems(voucherListGridID);
		if(selectedItemList.length == 0){
			Common.alert("No record selected");
			return false;
		}

		var detailIdArr = [];
		for(var i = 0 ; i < selectedItemList.length ; i++){
			detailIdArr.push(selectedItemList[i].item.detailId);
       }

		Common.ajax("POST", "/misc/voucher/activateVoucher.do", {
			campaignId : campaignID,
			detailIdList : detailIdArr.join(",")
		}, function(result) {
				fn_getVoucherList();
		});
	}

	function fn_deactivateVoucher(){
		var selectedItemList = AUIGrid.getCheckedRowItems(voucherListGridID);
		if(selectedItemList.length == 0){
			Common.alert("No record selected");
			return false;
		}

		var detailIdArr = [];
		for(var i = 0 ; i < selectedItemList.length ; i++){
			detailIdArr.push(selectedItemList[i].item.detailId);
       }

		Common.ajax("POST", "/misc/voucher/deactivateVoucher.do", {
			campaignId : campaignID,
			detailIdList : detailIdArr.join(",")
		}, function(result) {
				fn_getVoucherList();
		});
	}

	function fn_uploadCSV(){
		Common.popupDiv("/misc/voucher/voucherUploadCustomerPop.do", {campaignId:campaignID},
				null, true, "voucherUploadCustomerPop");
		$('#voucherListViewPop').remove();
	}

	function fn_downloadCSV(){
		Common.ajax("GET", "/misc/voucher/getVoucherListForExcel.do", {
			campaignId : campaignID,
			voucher : $('#voucher').val()
		}, function(result) {
			  if(result.length > 0) {
					  var date = new Date();
				      var month = date.getMonth() + 1;
				      var day = date.getDate();

				      var formatDate = day+month+date.getFullYear();
					AUIGrid.setGridData(voucherListExcelGridID, result);
		            GridCommon.exportTo("voucher_list_excel_grid_wrap", 'xlsx', "Voucher_Batch_" + campaignID + "(" + formatDate + ")");
		        } else {
		            Common.alert('There is no data to download.');
		        }
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
					<col style="width: 150px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Title</th>
						<td><input type="text" title="Title" placeholder="Title"
							class="w100p" id="title" name="title" maxlength="100" readonly /></td>
						<th scope="row">Master Code</th>
						<td><input type="text" title="Master Code"
							placeholder="Master Code" class="w100p" id="masterCode"
							name="masterCode" maxlength="100" /></td>
					</tr>
					<tr>
						<th scope="row">Platform</th>
						<td><select id="platform" name="platform" class="w100p"
							disabled>
						</select></td>

						<th scope="row">Module</th>
						<td><select id="module" name="module" class="w100p" disabled>
						</select></td>
					</tr>
					<tr>
						<th scope="row">Start Date</th>
						<td><input type="text" title="Create start Date"
							placeholder="DD/MM/YYYY" class="j_date w100p" id="startDate"
							name="startDate" autocomplete="off" disabled /></td>
						<th scope="row">End Date</th>
						<td><input type="text" title="Create start Date"
							placeholder="DD/MM/YYYY" class="j_date w100p" id="endDate"
							name="endDate" autocomplete="off" disabled /></td>
					</tr>
					<tr>
						<th scope="row">Status</th>
						<td><select id="status" name="status" class="w100p" disabled>
								<option value="1">Active</option>
								<option value="8">InActive</option>
						</select></td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</section>

		<section class="search_result">
			<table class="type1">
				<tbody>
				<tr>
						<th scope="row">Voucher</th>
						<td><input type="text" title="Voucher" placeholder="Voucher"
							class="w100p" id="voucher" name="voucher" maxlength="100" /></td>
					</tr>
				</tbody>
			</table>
			<ul class="right_btns">
				<%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
				<li>
					<p class="btn_grid" style="margin-bottom:10px;">
						<a href="#" onclick="javascript:fn_downloadCSV()">Excel</a>
						<a href="#" onclick="javascript:fn_uploadCSV()">Upload Info</a>
						<a href="#" onclick="javascript:fn_voucherGeneratePop()">Generate Voucher</a>
						<a href="#" onclick="javascript:fn_getVoucherList()">Search</a>
					</p>
					<p class="btn_grid">
						<a href="#" onclick="javascript:fn_activateVoucher()">Activate</a>
						<a href="#" onclick="javascript:fn_deactivateVoucher()">Inactive</a>
					</p>
				</li>
				<%-- </c:if> --%>
			</ul>

			<article class="grid_wrap" id="voucher_list_grid_wrap"></article>
			<article class="grid_wrap" id="voucher_list_excel_grid_wrap"  style="display: none;"></article>
		</section>
	</section>
</div>