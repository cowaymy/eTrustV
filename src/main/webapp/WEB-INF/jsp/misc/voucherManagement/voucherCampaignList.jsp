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
	var voucherCampaignGridID;
	var voucherCampaignColumnLayout = [ {
		dataField : "id",
		headerText : 'ID',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "title",
		headerText : 'Title',
		style : "aui-grid-user-custom-left"
	},{
		dataField : "masterCode",
		headerText : 'Master Code',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "module",
		visible:false
	},{
		dataField : "moduleName",
		headerText : 'Module',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "startDate",
		headerText : 'Start Date',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "endDate",
		headerText : 'End Date',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "platform",
		visible: false
	}, {
		dataField : "platformName",
		headerText : 'Platform',
		style : "aui-grid-user-custom-left"
	}, {
		dataField : "stusName",
		headerText : 'Status',
		style : "aui-grid-user-custom-left"
	} ];

	var voucherCampaignGridPros = {
		// 페이징 사용
		usePaging : true,
		// 한 화면에 출력되는 행 개수 20(기본값:20)
		pageRowCount : 20,
		// 헤더 높이 지정
		headerHeight : 30,
		// 셀 선택모드 (기본값: singleCell)
		selectionMode : "multipleCells"
	};

	$(document).ready(
			function() {
				voucherCampaignGridID = AUIGrid.create("#voucher_campaign_grid_wrap",
						voucherCampaignColumnLayout, voucherCampaignGridPros);

				doGetComboOrder('/common/selectCodeList.do', '562', 'CODE_NAME',
						'', 'platformSearch', 'M', 'fn_multiCombo');
				doGetComboOrder('/common/selectCodeList.do', '563', 'CODE_NAME',
						'', 'moduleSearch', 'M', 'fn_multiCombo');
			});

	function fn_voucherCampaignCreatePop() {
		Common.popupDiv("/misc/voucher/voucherCampaignCreatePop.do", null,
				null, true, "voucherCampaignCreatePop");
	}

	function fn_getVoucherCampaignList() {
		Common.ajax("GET", "/misc/voucher/getVoucherCampaignList.do", $('#searchForm').serialize(),
				function(result) {
					AUIGrid.setGridData(voucherCampaignGridID, result);
				});
	}

	function fn_editCampaignPop() {
		var objSelected = AUIGrid.getSelectedItems(voucherCampaignGridID);
		if(objSelected != null && objSelected.length > 0){
			var id = objSelected[0].item.id;
			Common.popupDiv("/misc/voucher/voucherCampaignEditPop.do", {campaignId: id}, null,
					true, "voucherCampaignEditPop");
		}
		else{
			Common.alert("Please select a record.");
		}
	}

	function fn_voucherViewPop() {
		var objSelected = AUIGrid.getSelectedItems(voucherCampaignGridID);
		if(objSelected != null  && objSelected.length > 0){
			var id = objSelected[0].item.id;
			Common.popupDiv("/misc/voucher/voucherListViewPop.do", {campaignId: id}, null,
					true, "voucherListViewPop");
		}
		else{
			Common.alert("Please select a record.");
		}
	}

	function fn_activateCampaign(){
		var selectedItem = AUIGrid.getSelectedItems(voucherCampaignGridID);
		if(selectedItem.length == 0){
			Common.alert("No record selected");
			return false;
		}

		Common.ajax("POST", "/misc/voucher/editVoucherCampaignStatus.do", {
			campaignId : selectedItem[0].item.id,
			status : 1
		}, function(result) {
			fn_getVoucherCampaignList();
		});
	}

	function fn_deactivateCampaign(){
		var selectedItem = AUIGrid.getSelectedItems(voucherCampaignGridID);
		if(selectedItem.length == 0){
			Common.alert("No record selected");
			return false;
		}

		Common.ajax("POST", "/misc/voucher/editVoucherCampaignStatus.do", {
			campaignId : selectedItem[0].item.id,
			status : 8
		}, function(result) {
			fn_getVoucherCampaignList();
		});
	}

    function fn_multiCombo(){
        $('#platformSearch').change(function() {
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#platformSearch').multipleSelect("checkAll");


        $('#moduleSearch').change(function() {
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#moduleSearch').multipleSelect("checkAll");


        $('#statusSearch').change(function() {
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#statusSearch').multipleSelect("checkAll");
    }
</script>

<div>
	<section id="content">
		<!-- content start -->
		<ul class="path">
			<li><img
				src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
				alt="Home" /></li>
		</ul>

		<aside class="title_line">
			<!-- title_line start -->
			<p class="fav">
				<a href="#" class="click_add_on"><spring:message
						code="webInvoice.fav" /></a>
			</p>
			<h2>Voucher Management</h2>
			<ul class="right_btns">
				<%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:fn_getVoucherCampaignList()"><span class="search"></span> <spring:message
								code="webInvoice.btn.search" /></a>
					</p></li>
				<%-- </c:if> --%>
			</ul>
		</aside>
		<!-- 	Filter Table -->
		<div>
			<table>
				<caption>
					<spring:message code="webInvoice.table" />
				</caption>
			</table>
		</div>
		<section class="search_table">
			<form id="searchForm" name="searchForm" action="#" method="post">
				<table class="type1">
					<caption>table</caption>
					<colgroup>
						<col style="width: 140px" />
						<col style="width: *" />
						<col style="width: 130px" />
						<col style="width: *" />
						<col style="width: 170px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><span>ID</span></th>
							<td><input type="text" title="ID"
								id="campaignIdSearch" name="campaignIdSearch" placeholder="Campaign ID"
								class="w100p" /></td>
							<th scope="row">Title</th>
							<td><input type="text" title="Title" id="titleSearch"
								name="titleSearch" placeholder="Title" class="w100p" /></td>

							<th scope="row">Master Code</th>
							<td><input type="text" title="masterCode" id="masterCodeSearch"
								name="masterCodeSearch" placeholder="Master Code" class="w100p" /></td>
						</tr>
						<tr>
							<th scope="row">Status</th>
							<td><select id="statusSearch" name="statusSearch"
								class="multy_select w100p" multiple="multiple">
									<option value="1">Active</option>
									<option value="8">Inactive</option>
							</select></td>
							<th scope="row">Start/End Date</th>
							<td>
								<div class="date_set w100p">
									<!-- date_set start -->
									<p>
										<input id="requestStartDate" name="requestStartDate"
											type="text" title="Create start Date" placeholder="DD/MM/YYYY"
											class="j_date" value="" />
									</p>
									<span>To</span>
									<p>
										<input id="requestEndDate" name="requestEndDate" type="text"
											title="Create end Date" placeholder="DD/MM/YYYY"
											class="j_date" value="" />
									</p>
								</div> <!-- date_set end -->
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th scope="row">Module</th>
							<td><select id="moduleSearch" name="moduleSearch"
								class="multy_select w100p" multiple="multiple">
							</select></td>
							<th scope="row">Platform</th>
							<td><select id="platformSearch" name="platformSearch"
								class="multy_select w100p" multiple="multiple">
							</select></td>
							<th></th>
							<td></td>
						</tr>
					</tbody>
				</table>
			</form>
		</section>
		<section class="search_result">
			<ul class="right_btns">
				<%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
				<li><p class="btn_grid">

						<a href="#" onclick="javascript:fn_activateCampaign()">Activate</a>
						<a href="#" onclick="javascript:fn_deactivateCampaign()">Inactive</a>
						<a href="javascript:fn_editCampaignPop();">Edit Campaign</a> <a
							href="javascript:fn_voucherViewPop();">View Voucher</a> <a
							href="#" onclick="javascript:fn_voucherCampaignCreatePop()"
							id="newVoucher">New</a>
					</p></li>
				<%-- </c:if> --%>
			</ul>

			<article class="grid_wrap" id="voucher_campaign_grid_wrap"></article>
		</section>
	</section>
</div>