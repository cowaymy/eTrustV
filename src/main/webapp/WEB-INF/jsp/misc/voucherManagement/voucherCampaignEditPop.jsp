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
	var promotionGridID;
	var existPromotionGridID;
	var isEditable;
	$(document)
			.ready(
					function() {
						console.log("voucherCampaignEditPop.jsp");
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
						isEditable = "${campaignDetail.isEditable}";
						$('#startDate').val(startDate);
						$('#endDate').val(endDate);
						$('#campaignId').val("${campaignDetail.id}");
						$('#status').val(status);
						$('#title').val(title);
						$('#masterCode').val(masterCode);

						doGetComboOrder('/common/selectCodeList.do', '320',
								'CODE_ID', '', 'promoAppTypeId', 'M',
								'fn_multiCombo'); //Common Code
						createPromotionAUIGrid();
						createExistingPromotionAUIGrid();
						fn_selectExistingPromoListAjax();
						fn_disableEditFeature(isEditable);
					});

	function setDropdownValue(){
		$('#platform').val("${campaignDetail.platform}");
		$('#module').val("${campaignDetail.moduleType}");
	}

	function fn_disableEditFeature() {
		$('#buttonSectionDate').hide();
		if (isEditable == 1) {
			$('#voucherCampaignForm :input').prop('disabled', false);
			$('#addPromotionSection').show();
			$('#buttonSection').show();
		}
		else{
			$('#voucherCampaignForm :input').prop('disabled', true);
			$('#addPromotionSection').hide();
			$('#buttonSection').hide();
			fn_enableDateEditFeatureOnly();
		}
	}

	function fn_enableDateEditFeatureOnly(){
		$('#campaignId').prop('disabled', false);
		$('#startDate').prop('disabled', false);
		$('#endDate').prop('disabled', false);
		$('#buttonSectionDate').show();
	}

	function fn_multiCombo() {
		$('#promoAppTypeId').change(function() {
			//console.log($(this).val());
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});
		$('#promoAppTypeId').multipleSelect("checkAll");
		fn_delApptype2();
	}

	function fn_delApptype2() {
		$("#promoAppTypeId").find("option").each(function() {
			if (this.value == '2286') {
				$(this).remove();
			}
		});
	}

	function createPromotionAUIGrid() {
		//AUIGrid 칼럼 설정
		var columnLayout = [ {
			headerText : "<spring:message code='sal.text.promotionId'/>",
			dataField : "promoId",
			editable : false,
			width : 100
		}, {
			headerText : "<spring:message code='sales.AppType2'/>",
			dataField : "promoAppTypeName",
			editable : false,
			width : 100
		}, {
			headerText : "<spring:message code='sales.promo.promoType'/>",
			dataField : "promoTypeName",
			editable : false,
			width : 100
		}, {
			headerText : "<spring:message code='sales.promo.promoCd'/>",
			dataField : "promoCode",
			editable : false,
			width : 140
		}, {
			headerText : "<spring:message code='sales.promo.promoNm'/>",
			dataField : "promoDesc",
			editable : false
		}, {
			headerText : "<spring:message code='sales.StartDate'/>",
			dataField : "promoDtFrom",
			editable : false,
			width : 100
		}, {
			headerText : "<spring:message code='sales.EndDate'/>",
			dataField : "promoDtEnd",
			editable : false,
			width : 100
		}, {
			headerText : "<spring:message code='sales.Status'/>",
			dataField : "status",
			editable : false,
			width : 80
		}, {
			headerText : "promoId",
			dataField : "promoId",
			visible : false
		}, {
			headerText : "promoAppTypeId",
			dataField : "promoAppTypeId",
			visible : false
		} ];

		//그리드 속성 설정
		var gridPros = {
			usePaging : true, //페이징 사용
			pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
			editable : true,
			fixedColumnCount : 1,
			showStateColumn : false,
			displayTreeOpen : false,
			//selectionMode       : "singleRow",  //"multipleCells",
			headerHeight : 30,
			useGroupingPanel : false, //그룹핑 패널 사용
			skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
			wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
			showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
			noDataMessage : "No order found.",
			groupingMessage : "Here groupping",
			showRowCheckColumn : true
		};

		promotionGridID = GridCommon.createAUIGrid("promotion_grid_wrap",
				columnLayout, "", gridPros);

		AUIGrid.bind(promotionGridID, "cellClick", function(event) {
			//selectedGridValue = event.rowIndex;
			var item = event.item, rowIdField, rowId, rowOrNo;

			rowIdField = AUIGrid.getProp(event.pid, "rowIdField");
			rowId = item[rowIdField];

			// check if already checked
			if (AUIGrid.isCheckedRowById(event.pid, rowId)) {
				// Add extra checkbox unchecked
				AUIGrid.addUncheckedRowsByIds(event.pid, rowId);

			} else {
				// add extra checkbox check
				AUIGrid.addCheckedRowsByIds(event.pid, rowId);
			}
		});

		AUIGrid.bind(promotionGridID, "rowCheckClick", function(event) {
			var item = event.item, rowIdField, rowId, rowOrNo;

			// check if already checked
			if (AUIGrid.isCheckedRowById(event.pid, rowId)) {
				// Add extra checkbox unchecked
				AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
			} else {
				// add extra checkbox check
				AUIGrid.addCheckedRowsByIds(event.pid, rowId);
			}
		});

		AUIGrid.bind(promotionGridID, "rowAllChkClick", function(event) {
			var item = event.item, rowIdField, rowId, rowOrNo;

			// check if already checked
			if (AUIGrid.isCheckedRowById(event.pid, rowId)) {
				// Add extra checkbox unchecked
				AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
			} else {
				// add extra checkbox check
				AUIGrid.addCheckedRowsByIds(event.pid, rowId);
			}
		});
	}

	function fn_selectPromoListAjax() {
		Common.ajax("GET", "/misc/voucher/selectPromotionList.do", $(
				"#promoListForm").serialize(), function(result) {
			AUIGrid.setGridData(promotionGridID, result);
		});
	}

	function submit() {
		if ($('#startDate').val() == "" || $('#endDate').val() == ""
				|| $('#platform').val() == "" || $('#module').val() == ""
				|| $('#title').val() == "" || $('#masterCode').val() == "") {
			Common.alert("Please fill in all required fields");
			return false;
		}

		if ($('#title').val().length >= 100 || $('#title').val().length <= 0) {
			Common.alert("Maximum length of the title is 100 characters only");
			return false;
		}

		if ($('#masterCode').val().length >= 100
				|| $('#masterCode').val().length <= 0) {
			Common
					.alert("Maximum length of the master code is 100 characters only");
			return false;
		}

		var selectedAddItemList = AUIGrid.getCheckedRowItems(promotionGridID);

		var promotionAddIdArr = [];
		for (var i = 0; i < selectedAddItemList.length; i++) {
			promotionAddIdArr.push(selectedAddItemList[i].item.promoId);
		}
		$('#promotionPackageIdList').val(promotionAddIdArr.join(","));

		Common.ajax("POST", "/misc/voucher/editVoucherCampaign.do", $(
				"#voucherCampaignForm").serializeJSON(), function(result) {
			console.log(result);
			if (result.code == "00") {
				fn_getVoucherCampaignList();
				$("#voucherCampaignEditPop").remove();
				Common.alert("Success");
			} else {
				Common.alert("Error: " + result.message);
				return;
			}
		});
	}

	function submitDateEdit(){
		if ($('#startDate').val() == "" || $('#endDate').val() == "") {
			Common.alert("Please fill in all required fields");
			return false;
		}

		Common.ajax("POST", "/misc/voucher/editVoucherCampaignDate.do", $("#voucherCampaignForm").serializeJSON(), function(result) {
			console.log(result);
			if (result.code == "00") {
				fn_getVoucherCampaignList();
				$("#voucherCampaignEditPop").remove();
				Common.alert("Success");
			} else {
				Common.alert("Error: " + result.message);
				return;
			}
		});
	}

	function createExistingPromotionAUIGrid() {
		var columnLayout = null;
		if (isEditable == 1) {
			columnLayout = [ {
				headerText : "<spring:message code='sal.text.promotionId'/>",
				dataField : "promoId",
				editable : false,
				width : 100
			}, {
				headerText : "<spring:message code='sales.promo.promoCd'/>",
				dataField : "promoCode",
				editable : false,
				width : 140
			}, {
				headerText : "<spring:message code='sales.promo.promoNm'/>",
				dataField : "promoDesc",
				editable : false
			}, {
				headerText : "<spring:message code='sales.StartDate'/>",
				dataField : "promoDtFrom",
				editable : false,
				width : 100
			}, {
				headerText : "<spring:message code='sales.EndDate'/>",
				dataField : "promoDtEnd",
				editable : false,
				width : 100
			}, {
				dataField : "",
				headerText : "",
				width : 80,
				editable : false,
				renderer : {
					type : "ButtonRenderer",
					labelText : "Delete",
					onclick : function(rowIndex, columnIndex, value, item) {
						fn_removePromotionItem(item.promoId);
					}
				}
			} ];
		} else {
			columnLayout = [ {
				headerText : "<spring:message code='sal.text.promotionId'/>",
				dataField : "promoId",
				editable : false,
				width : 100
			}, {
				headerText : "<spring:message code='sales.promo.promoCd'/>",
				dataField : "promoCode",
				editable : false,
				width : 140
			}, {
				headerText : "<spring:message code='sales.promo.promoNm'/>",
				dataField : "promoDesc",
				editable : false
			}, {
				headerText : "<spring:message code='sales.StartDate'/>",
				dataField : "promoDtFrom",
				editable : false,
				width : 100
			}, {
				headerText : "<spring:message code='sales.EndDate'/>",
				dataField : "promoDtEnd",
				editable : false,
				width : 100
			} ];
		}

		//그리드 속성 설정
		var gridPros = {
			usePaging : true, //페이징 사용
			pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
			editable : true,
			fixedColumnCount : 1,
			showStateColumn : false,
			displayTreeOpen : false,
			//selectionMode       : "singleRow",  //"multipleCells",
			headerHeight : 30,
			useGroupingPanel : false, //그룹핑 패널 사용
			skipReadonlyColumns : true, //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
			wrapSelectionMove : true, //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
			showRowNumColumn : true, //줄번호 칼럼 렌더러 출력
			noDataMessage : "No order found.",
			groupingMessage : "Here groupping"
		};

		existPromotionGridID = GridCommon.createAUIGrid(
				"exist_promotion_grid_wrap", columnLayout, "", gridPros);
	}

	function fn_selectExistingPromoListAjax() {
		Common.ajax("GET", "/misc/voucher/selectExistPromotionList.do", $(
				"#voucherCampaignForm").serialize(), function(result) {
			AUIGrid.setGridData(existPromotionGridID, result);
		});
	}

	function fn_removePromotionItem(id) {
		Common.ajax("GET", "/misc/voucher/deleteVoucherPromotionPackage.do", {
			campaignId : $('#campaignId').val(),
			promoId : id
		}, function(result) {
			if (result.code == "00") {
				fn_selectExistingPromoListAjax();
			} else {
				Common.alert("Error to delete. Please try again.");
			}
		});
	}
</script>

<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>Edit Campaign</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#"><spring:message code="newWebInvoice.btn.close" /></a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->

	<section class="pop_body">
		<section class="search_table">
			<form action="#" method="post" id="voucherCampaignForm"
				name="voucherCampaignForm">
				<input type="hidden" id="promotionPackageIdList"
					name="promotionPackageIdList" /> <input type="hidden"
					id="campaignId" name="campaignId" value="" />
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
							<th scope="row">Title<span style="color: red;">*</span></th>
							<td><input type="text" title="Title" placeholder="Title"
								class="w100p" id="title" name="title" maxlength="100" /></td>
						</tr>
						<tr>
							<th scope="row">Master Code<span style="color: red;">*</span></th>
							<td><input type="text" title="Master Code"
								placeholder="Master Code" class="w100p" id="masterCode"
								name="masterCode" maxlength="100" /></td>
						</tr>
						<tr>
							<th scope="row">Platform<span style="color: red;">*</span></th>
							<td><select id="platform" name="platform">
							</select></td>

							<th scope="row">Module<span style="color: red;">*</span></th>
							<td><select id="module" name="module">
							</select></td>
						</tr>
						<tr>
							<th scope="row">Start Date<span style="color: red;">*</span></th>
							<td><input type="text" title="Create start Date"
								placeholder="DD/MM/YYYY" class="j_date w100p" id="startDate"
								name="startDate" autocomplete="off" /></td>
							<th scope="row">End Date<span style="color: red;">*</span></th>
							<td><input type="text" title="Create start Date"
								placeholder="DD/MM/YYYY" class="j_date w100p" id="endDate"
								name="endDate" autocomplete="off" /></td>
						</tr>
						<tr>
							<th scope="row">Status<span style="color: red;">*</span></th>
							<td><select id="status" name="status">
									<option value="1">Active</option>
									<option value="8">InActive</option>
							</select></td>
						</tr>
					</tbody>
				</table>
			</form>
		</section>
		<section>
			<h5>Existing Promotion</h5>
			<article class="grid_wrap">
				<div id="exist_promotion_grid_wrap"
					style="width: 100%; height: 160px; margin: 0 auto;"></div>
			</article>
		</section>
		<section id="addPromotionSection" style="margin-top: 20px">
			<h5 style="margin-bottom: 10px">Add Promotion</h5>
			<form id="promoListForm" name="promoListForm" action="#"
				method="post">
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
							<th scope="row"><spring:message code='sales.promo.promoApp' /></th>
							<td><select id="promoAppTypeId" name="promoAppTypeId"
								class="multy_select w100p" multiple="multiple"></select></td>
							<th scope="row"><spring:message code='sales.EffectDate' /></th>
							<td><input id="list_promoDt" name="promoDt" type="text"
								title="<spring:message code='sales.EffetDate'/>"
								value="${toDay}" placeholder="DD/MM/YYYY" class="j_date w100p" />
							</td>
							<td>
								<p class="btn_blue2">
									<a href="#" id="btn_promoSearch"
										onclick="javascript:fn_selectPromoListAjax()">Search Promo</a>
								</p>
							</td>
						</tr>
						<tr>
							<th scope="row"><spring:message code='sales.promo.promoCd' /></th>
							<td><input id="promoCode" name="promoCode" type="text"
								title="" placeholder="" class="w100p" /></td>
							<th scope="row"><spring:message code='sales.promo.promoNm' /></th>
							<td><input id="promoDesc" name="promoDesc" type="text"
								title="" placeholder="" class="w100p" /></td>
						</tr>
					</tbody>
				</table>
			</form>
			<article class="grid_wrap">
				<div id="promotion_grid_wrap"
					style="width: 100%; height: 240px; margin: 0 auto;"></div>
			</article>
		</section>
		<ul class="center_btns" id="buttonSection">
			<li><p class="btn_blue2">
					<a href="#" id="btn_edit" onclick="javascript:submit()">Save</a>
				</p></li>
		</ul>
		<ul class="center_btns" id="buttonSectionDate">
			<li><p class="btn_blue2">
					<a href="#" id="btn_edit_date" onclick="javascript:submitDateEdit()">Save</a>
				</p></li>
		</ul>
	</section>
</div>