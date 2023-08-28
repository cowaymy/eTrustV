<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script type="text/javascript">
	console.log("logistics/prefixConversion/prefixConversionList.do");
	var columnLayout = [ {
		dataField : "prefixConfigId",
		headerText : "prefixConfigId",
		width : 150,
		editable : false,
		visible : false
	}, {
		dataField : "prefixStkCode",
		headerText : "Material Code",
		width : 200,
		editable : false
	}, {
		dataField : "prefixStkDesc",
		headerText : "Material Name",
		width : 200,
		editable : false
	}, {
		dataField : "prefixConvStkCode",
		headerText : "Conversion Material Code",
		width : 200,
		editable : false
	}, {
		dataField : "prefixConvStkDesc",
		headerText : "Conversion Material Name",
		width : 200,
		editable : false
	}, {
		dataField : "useYn",
		headerText : "Use (Y/N)",
		width : 150,
		editable : false
	}, {
		dataField : "crtUser",
		headerText : "Creator",
		width : 150,
		editable : false
	}, {
		dataField : "crtDt",
		headerText : "Create Date",
		width : 150,
		dataType : "date",
		formatString : "dd-mm-yyyy",
		editable : false
	} ];

	//그리드 속성 설정
	var gridPros = {
		// 페이징 사용
		usePaging : true,
		// 한 화면에 출력되는 행 개수 20(기본값:20)
		pageRowCount : 20,
		// 셀 선택모드 (기본값: singleCell)
		selectionMode : "multipleCells"
	};

	var myGridID;

	$(document)
			.ready(
					function() {
						myGridID = AUIGrid.create("#grid_wrap", columnLayout,
								gridPros);
						doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'sprefixStkId', 'S', 'fn_setOptGrpClass');//product 생성
					    doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'sprefixConvStkId', 'S', 'fn_setOptGrpClass');//product 생성
					});

	function fn_searchPrefixConversionList() {
		Common.ajax("GET",
				"/logistics/prefixConversion/searchPrefixConversionList.do", $(
						"#searchForm").serializeJSON(), function(result) {
					AUIGrid.setGridData(myGridID, result);
				});
	}

	function fn_excelDown() {
		// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
		GridCommon.exportTo("grid_wrap", "xlsx", "Material Prefix Conversion");
	}

	function fn_clear() {
		$("#sprefixStkId").val('');
		$("#sprefixConvStkId").val('');
	}

	function fn_addEditPrefixConfig(viewType) {
		if (viewType == 1) {
			Common
					.popupDiv(
							"/logistics/prefixConversion/addEditPrefixConversionPop.do?isPop=true&viewType="
									+ viewType, "", null, "false",
							"prefixConfigId");
		} else {
			var selectedItems = AUIGrid.getSelectedItems(myGridID);

			if (selectedItems.length <= 0) {
				Common.alert("<spring:message code='service.msg.NoRcd'/> ");
				return;
			}

			var prefixConfigId = selectedItems[0].item.prefixConfigId;

			Common
					.popupDiv(
							"/logistics/prefixConversion/addEditPrefixConversionPop.do?isPop=true&prefixConfigId="
									+ prefixConfigId + "&viewType=" + viewType,
							"", null, "false", "prefixConfigId");
		}

	}

	function fn_selectListAjax() {
		AUIGrid.refreshRows();
		Common.ajax("GET",
				"/logistics/prefixConversion/searchPrefixConversionList.do", $(
						"#searchForm").serializeJSON(), function(result) {
					AUIGrid.setGridData(myGridID, result);
				});
	}
</script>

<form action="#" id="searchForm" name="searchForm">

	<section id="content">
		<!-- content start -->
		<ul class="path">
			<li><img
				src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
				alt="Home" /></li>
			<li>Sales</li>
			<li>Order list</li>
		</ul>

		<aside class="title_line">
			<!-- title_line start -->
			<p class="fav">
				<a href="#" class="click_add_on">My menu</a>
			</p>
			<h2>Material Prefix Conversion</h2>
			<ul class="right_btns">
				<c:if test="${PAGE_AUTH.funcView == 'Y'}">
					<li><p class="btn_blue">
							<a href="javascript:void(0);"
								onclick="javascript:fn_searchPrefixConversionList()"><span
								class="search"></span>Search</a>
						</p></li>
					<li><p class="btn_blue">
							<a href="#" onclick="javascript:fn_clear()"><span
								class="clear"></span> <spring:message code="sal.btn.clear" /></a>
						</p></li>
				</c:if>
			</ul>
		</aside>
		<div id="prefixConfig" style="display: block;">
			<section class="search_table">
				<!-- search_table start -->
				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 150px" />
						<col style="width: *" />
						<col style="width: 150px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Material Code</th>
							<td><select class="w100p" id="sprefixStkId"
								name="sprefixStkId"></select></td>
							<th scope="row">Prefix Conversion Material Code</th>
							<td><select class="w100p" id="sprefixConvStkId"
								name="sprefixConvStkId"></select></td>
						</tr>

					</tbody>
				</table>
				<!-- table end -->

			</section>
			<!-- search_table end -->

		</div>
		<ul class="right_btns">


		</ul>
		<aside class="link_btns_wrap">
			<!-- link_btns_wrap start -->
			<p class="show_btn">
				<a href="#"><img
					src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
					alt="link show" /></a>
			</p>
			<dl class="link_list">
				<dt>Link</dt>
				<dd>
					<ul class="btns">
						<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
							<li><p class="link_btn">
									<a href="javascript:fn_addEditPrefixConfig(1)"
										id="addPrefixConfig">Add Prefix Conversion</a>
								</p></li>
							<li><p class="link_btn">
									<a href="javascript:fn_addEditPrefixConfig(2)"
										id="editPrefixConfig">Edit Prefix Conversion</a>
								</p></li>
						</c:if>
					</ul>
					<p class="hide_btn">
						<a href="#"><img
							src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
							alt="hide" /></a>
					</p>
				</dd>
			</dl>
		</aside>
		<!-- link_btns_wrap end -->

		<section class="search_result">
			<!-- search_result start -->

			<ul class="right_btns">
				<li><p class="btn_grid">
						<a href="javascript:void(0);" onclick="fn_excelDown()">Excel
							Download</a>
					</p></li>
			</ul>
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap"
					style="width: 100%; height: 500px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->

		</section>
		<!-- search_result end -->

		<ul class="center_btns">
			<!--     <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li> -->
		</ul>

	</section>
	<!-- content end -->
</form>