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
	$(document).ready(
			function() {
				doGetComboOrder('/common/selectCodeList.do', '562', 'CODE_NAME',
						'', 'platform', 'S', '');
				doGetComboOrder('/common/selectCodeList.do', '563', 'CODE_NAME',
						'', 'module', 'S', '');
				doGetComboOrder('/common/selectCodeList.do', '320', 'CODE_ID',
						'', 'promoAppTypeId', 'M', 'fn_multiCombo'); //Common Code

				createPromotionAUIGrid();
			});

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
			selectedGridValue = event.rowIndex;
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
				|| $('#title').val() == "" || $('#masterCode').val() == ""
				|| $('#voucherGenAmount').val() < 0) {
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

		if ($('#voucherGenAmount').val() < 0
				|| $('#voucherGenAmount').val() > 1000) {
			Common
					.alert("Maximum voucher allow to be generate are 1000 voucher only.");
			return false;
		}

		var selectedItemList = AUIGrid.getCheckedRowItems(promotionGridID);

		if (selectedItemList.length == 0) {
			Common.alert("At least one Promotion Package is required.");
			return;
		}

		var promotionIdArr = [];
		for(var i = 0 ; i < selectedItemList.length ; i++){
			promotionIdArr.push(selectedItemList[i].item.promoId);
       }
		$('#promotionPackageIdList').val(promotionIdArr.join(","));

		Common.ajax("POST", "/misc/voucher/createVoucherCampaign.do", $(
				"#voucherCampaignForm").serializeJSON(), function(result) {
			console.log(result);
			if (result.code == "00") {
				$("#voucherCampaignCreatePop").remove();
			} else {
				Common.alert("Error: " + result.message);
				return;
			}
		});
	}
</script>

<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>New Campaign</h1>
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
				<input type="hidden" id="promotionPackageIdList" name="promotionPackageIdList"/>
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
							<th scope="row">Master Code<span style="color: red;">*</span></th>
							<td><input type="text" title="masterCode"
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
						<tr>
							<th scope="row">Number of voucher generate<span
								style="color: red;">*</span></th>
							<td><input id="voucherGenAmount" name="voucherGenAmount"
								class="w100p" type="number" min="0" max="1000" value="0" /></td>
						</tr>
					</tbody>
				</table>
			</form>
		</section>
		<section>
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
		<ul class="center_btns">
			<li><p class="btn_blue2">
					<a href="#" id="btn_create" onclick="javascript:submit()"><spring:message
							code="newWebInvoice.btn.add" /></a>
				</p></li>
		</ul>
	</section>
</div>