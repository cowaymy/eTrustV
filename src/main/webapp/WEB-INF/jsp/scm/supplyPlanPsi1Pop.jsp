<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
	text-align:left;
}
.my-columnNumber {
	text-align:Right;
}
.my-columnText {
	text-align:left;
}
.my-columnCode {
	text-align:Center;
}
</style>

<script type="text/javaScript">
var myGridPopID, myGridOption, myGridLayout;
var	stockCode	= "";
var scmYearCbBox	= 0;
var scmWeekCbBox	= 0;

$(function() {
	stockCode		= "${params.stockCodeParam}";
	scmYearCbBox	= "${params.scmYearCbBoxParam}";
	scmWeekCbBox	= "${params.scmWeekCbBoxParam}";
	
	fnSearchPop();
});

function fnSearchPop() {
	var params	= {
			stockCode : stockCode,
			scmYearCbBox : scmYearCbBox,
			scmWeekCbBox : scmWeekCbBox
		};
	console.log(params);
	//params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("POST"
			, "/scm/selectSupplyPlanPsi1.do"
			, params
			, function(result) {
				console.log(result);
				
				//	grid destroy
				if ( AUIGrid.isCreated(myGridPopID) ) {
					AUIGrid.destroy(myGridPopID);
				}
				
				//	set grid option
				myGridOption	= {
						usePaging : false,
						useGroupingPanel : false,
						editable : false,
						showRowNumColumn : false,
						enableCellMerge : true,
						showBranchOnGrouping : false
				};
				
				//	myGridLayout
				myGridLayout	= [
					{
						dataField : "stockCode",
						headerText : "Material"
					}, {
						dataField : "name",
						headerText : "Name",
						style : ".my-columnText"
					}, {
						dataField : "cdcName",
						headerText : "CDC"
					}, {
						dataField : "m3",
						headerText : "M-3",
						dataType : "numeric",
						formatString : "#,##0",
						style : "my-columnNumber"
					}, {
						dataField : "m2",
						headerText : "M-2",
						dataType : "numeric",
						formatString : "#,##0",
						style : "my-columnNumber"
					}, {
						dataField : "m1",
						headerText : "M-1",
						dataType : "numeric",
						formatString : "#,##0",
						style : "my-columnNumber"
					}, {
						dataField : "tot",
						headerText : "AVG",
						dataType : "numeric",
						formatString : "#,##0",
						style : "my-columnNumber"
					}, {
						dataField : "perEach",
						headerText : "%",
						dataType : "numeric",
						formatString : "#,##0",
						style : "my-columnNumber"
					}
				];
				
				myGridPopID	= GridCommon.createAUIGrid("supplyPlanPsi1", myGridLayout, "", myGridOption);
				AUIGrid.setGridData(myGridPopID, result.selectSupplyPlanPsi1);
			});
}

/***************************************************[ Main GRID] ***************************************************/

$(document).ready(function() {

});	//$(document).ready
</script>

<body>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Sales Plan / SO</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="fnClose();">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<form id="PopForm" method="get" action="">
			<section class="tap_wrap mt0"><!-- tap_wrap start -->
				<article class="tap_area"><!-- tap_area start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역 1-->
						<div id="supplyPlanPsi1"></div>
					</article><!-- grid_wrap end -->
				</article><!-- tap_area end -->
			</section><!-- tap_wrap end -->
		</form>
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
</body>
</html>