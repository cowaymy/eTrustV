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
	console.log("logistics/useFilterBlock/useFilterBlockList.do");

	var prdCat = [
                     {"codeId" : "54","codeName":"Water Purifier"},
                     {"codeId" : "55","codeName":"Air Purifier"}
                 ];

	var prdType = [
                     {"codeId" : "62","codeName":"Filter"},
                     {"codeId" : "63","codeName":"Spare Part"}
                 ];

	var prdStatus = [
	                 {"codeId" : "1","codeName":"Active"},
	                 {"codeId" : "8","codeName":"Inactive"}
	             ];

	var myGridID;

	$(document).ready(function() {
		createAUIGrid();
		doDefCombo(prdCat, '', 'cmbProductCtgry', 'M' , 'f_multiCombo');
		doDefCombo(prdType, '', 'cmbMatType', 'M' , 'f_multiCombo');
		doDefCombo(prdStatus, '', 'cmbStatus', 'M' , 'f_multiCombo');
	});

	function createAUIGrid() {
		var columnLayout = [ {
			dataField : "stkId",
			headerText : "stockId",
			width : 150,
			editable : false,
			visible : false
		}, {
			dataField : "stkCategory",
			headerText : "Category",
			width : 200,
			editable : false
		}, {
			dataField : "stkType",
			headerText : "Type",
			width : 200,
			editable : false
		}, {
			dataField : "stkCode",
			headerText : "Material Code",
			width : 200,
			editable : false
		}, {
			dataField : "stkDesc",
			headerText : "Material Name",
			width : 200,
			editable : false
		}, {
			dataField : "status",
			headerText : "Status",
			width : 150,
			editable : false
		}, {
			dataField : "userName",
			headerText : "Creator",
			width : 150,
			editable : false
		}, {
			dataField : "crtDt",
			headerText : "Create Date",
			width : 150,
			dataType : "date",
			formatString : "DD/MM/YYYY",
			editable : false
		} ];

		//그리드 속성 설정
		var gridPros = {
			// 페이징 사용
			usePaging : true,
			// 한 화면에 출력되는 행 개수 20(기본값:20)
			pageRowCount : 20
			// 셀 선택모드 (기본값: singleCell)
			//selectionMode : "multipleCells"
		};

		myGridID = AUIGrid.create("#grid_wrap", columnLayout,
				gridPros);
	}

	function fn_searchUseFilterBlockList() {
		Common.ajax("GET",
				"/logistics/useFilterBlock/searchUseFilterBlockList.do", $(
						"#searchForm").serialize(), function(result) {
					AUIGrid.setGridData(myGridID, result);
				});
	}

	function fn_excelDown() {
		// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
		GridCommon.exportTo("grid_wrap", "xlsx", "Use Filter Block List");
	}

	function fn_clear() {

	}

	function fn_addEditUseFilterBlock(viewType) {
		if (viewType == 1) {
			Common
					.popupDiv(
							"/logistics/useFilterBlock/addEditUseFilterBlockPop.do?isPop=true&viewType="
									+ viewType, "", null, "false",
							"stkId");
		} else {
			var selectedItems = AUIGrid.getSelectedItems(myGridID);

			if (selectedItems.length <= 0) {
				Common.alert("<spring:message code='service.msg.NoRcd'/> ");
				return;
			}

			var stkId = selectedItems[0].item.stkId;

			Common
					.popupDiv(
							"/logistics/useFilterBlock/addEditUseFilterBlockPop.do?isPop=true&stkId="
									+ stkId + "&viewType=" + viewType,
							"", null, "false", "stkId");
		}

	}

	function fn_selectListAjax() {
		AUIGrid.refreshRows();
		Common.ajax("GET",
				"/logistics/useFilterBlock/searchUseFilterBlockList.do", $(
						"#searchForm").serialize(), function(result) {
					AUIGrid.setGridData(myGridID, result);
				});
	}

	function fn_setOptGrpClass() {
	    $("optgroup").attr("class" , "optgroup_text")
	}

	 function f_multiCombo(){
	       $(function() {

	           $('#cmbProductCtgry').change(function() {

	           }).multipleSelect({
	               selectAll: true, // 전체선택
	               width: '100%'
	           });

	           $('#cmbProductCtgry').multipleSelect("checkAll");

	           $('#cmbMatType').change(function() {

	           }).multipleSelect({
	               selectAll : true,
	               width : '100%'
	           });

	           $('#cmbMatType').multipleSelect("checkAll");

	           $('#cmbStatus').change(function() {

	           }).multipleSelect({
	               selectAll : true,
	               width : '100%'
	           });

	           $('#cmbStatus').multipleSelect("checkAll");
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
			<li>Logistics</li>
			<li>Master Data</li>
			<li>Used Filter Block Management</li>
		</ul>

		<aside class="title_line">
			<!-- title_line start -->
			<p class="fav">
				<a href="#" class="click_add_on">My menu</a>
			</p>
			<h2>Used Filter Block Management</h2>
			<ul class="right_btns">
				<c:if test="${PAGE_AUTH.funcView == 'Y'}">
					<li><p class="btn_blue">
							<a href="javascript:void(0);"
								onclick="javascript:fn_searchUseFilterBlockList()"><span
								class="search"></span>Search</a>
						</p></li>
					<li><p class="btn_blue">
							<a href="#" onclick="javascript:fn_clear()"><span
								class="clear"></span> <spring:message code="sal.btn.clear" /></a>
						</p></li>
				</c:if>
			</ul>
		</aside>
		<div id="useFilterBlock" style="display: block;">
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
    <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
    	<td>
    		<select class="w100p" id="cmbProductCtgry" name="cmbProductCtgry">
    		</select>
    	</td>
    <th scope="row">Type</th>
    <td>
        <select class="w100p" id="cmbMatType" name="cmbMatType"></select>
    </td>
    <th scope="row">Status</th>
    <td>
        <select class="w100p" id="cmbStatus" name="cmbStatus"></select>
    </td>
</tr>
 	<tr>
    	<th scope="row">Material Code</th>
    	<td>
        	<input type=text name="stkCode" id="stkCode" class="w100p" value=""/>
    	</td>
    		<th scope="row">Material Name</th>
    	<td>
        <input type=text name="stkDesc" id="stkDesc" class="w100p" value=""/>
    	</td>
    <th scope="row"></th><td></td>
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
									<a href="javascript:fn_addEditUseFilterBlock(1)"
										id="addUseFilterBlock">Add Used Filter Block</a>
								</p></li>
							<li><p class="link_btn">
									<a href="javascript:fn_addEditUseFilterBlock(2)"
										id="editUseFilterBlock">Edit Used Filter Block</a>
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