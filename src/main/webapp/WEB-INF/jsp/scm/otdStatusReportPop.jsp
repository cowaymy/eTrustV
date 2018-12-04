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
var soGIGridID, soPPGridID, gridOptions, otdSOGILayout, otdSOPPLayout;
var flag	= "GI";
var	poNo	= "";
$(function() {
	poNo	= "${params.poNoParam}";
	if ( null != poNo && "" != poNo ) {
		fnSearchPop(poNo);
	}
});

function fnSearchPop(poNo) {
	var params	= {
			poNo : poNo,
			startDate : "00000000",
			endDate : "99999999",
			poItemStusId : "",
			scmStockTypeCbBox : null
		};
	console.log(params);
	//params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("POST"
			, "/scm/selectOtdStatus.do"
			, params
			, function(result) {
				console.log(result);
				
				if ( "GI" == flag ) {
					//	grid destroy
					if ( AUIGrid.isCreated(soGIGridID) ) {
						AUIGrid.destroy(soGIGridID);
					}
					if ( AUIGrid.isCreated(soPPGridID) ) {
						AUIGrid.destroy(soPPGridID);
					}
					
					//	set grid option
					gridOptions	= {
							usePaging : false,
							useGroupingPanel : false,
							editable : false,
							showRowNumColumn : false,
							enableCellMerge : true,
							showBranchOnGrouping : false,
							groupingFields : ["poNo", "stockCode", "name", "type", "poQty"]
					};
					
					//	otdSOGILayout
					otdSOGILayout	= [
						{
							dataField : "poNo",
							headerText : "PO NO"
						}, {
							dataField : "stockCode",
							headerText : "Material"
						}, {
							dataField : "name",
							headerText : "Desc",
							style : ".my-columnText"
						}, {
							dataField : "type",
							headerText : "Type"
						}, {
							dataField : "poQty",
							headerText : "PO Qty",
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-columnNumber"
						}, {
							dataField : "soQty",
							headerText : "SO Qty",
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-columnNumber"
						}, {
							dataField : "giQty",
							headerText : "GI Qty",
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-columnNumber"
						}, {
							dataField : "soDate",
							headerText : "SO Date",
							dataType : "date",
							formatString : "dd-mm-yyyy"
						}, {
							dataField : "giDate",
							headerText : "GI Date",
							dataType : "date",
							formatString : "dd-mm-yyyy"
						}
					];
					
					soGIGridID	= GridCommon.createAUIGrid("soGIGridDiv", otdSOGILayout, "", gridOptions);
					AUIGrid.setGridData(soGIGridID, result.selectOtdStatus);
				} else {
					//	set grid option
					gridOptions	= {
							usePaging : false,
							useGroupingPanel : false,
							editable : false,
							showRowNumColumn : false,
							enableCellMerge : true,
							showBranchOnGrouping : false,
							groupingFields : ["poNo", "stockCode", "name", "type", "poQty", "soNo", "soQty"]
					};
					//	otdSOPPLayout
					otdSOPPLayout	= [
						{
							dataField : "poNo",
							headerText : "PO NO"
						}, {
							dataField : "stockCode",
							headerText : "Material"
						}, {
							dataField : "name",
							headerText : "Desc",
							style : "my-columnText"
						}, {
							dataField : "type",
							headerText : "Type"
						}, {
							dataField : "poQty",
							headerText : "PO Qty",
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-columnNumber"
						}, {
							dataField : "soNo",
							headerText : "SO No"
						}, {
							dataField : "soQty",
							headerText : "SO Qty",
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-columnNumber"
						}, {
							dataField : "planQty",
							headerText : "Plan Qty",
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-columnNumber"
						}, {
							dataField : "planDate",
							headerText : "Plan Date",
							dataType : "date",
							formatString : "dd-mm-yyyy"
						}, {
							dataField : "resultQty",
							headerText : "Result Qty"
						}, {
							dataField : "resultDate",
							headerText : "Result Date",
							dataType : "date",
							formatString : "dd-mm-yyyy"
						}
					];
					soPPGridID	= GridCommon.createAUIGrid("soPPGridDiv", otdSOPPLayout, "", gridOptions);
					AUIGrid.setGridData(soPPGridID, result.selectOtdStatus);
				}
			});
}
function fnDetailTabClick(pFlag) {
	if ( "GI" == pFlag ) {
		flag	= "GI";
	} else if ( "PP" == pFlag ) {
		flag	= "PP";
	}
	fnSearchPop(poNo);
}

/***************************************************[ Main GRID] ***************************************************/

$(document).ready(function() {

});	//$(document).ready
</script>

<body>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>OTD Detail</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="fnClose();">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<form id="PopForm" method="get" action="">
			<section class="tap_wrap mt0"><!-- tap_wrap start -->
				<ul class="tap_type1 num4">
					<li><a onclick="javascript:fnDetailTabClick('GI');" class="on">SO GI Details</a></li>
					<li><a onclick="javascript:fnDetailTabClick('PP');">SO PP Details</a></li>
				</ul>
				<article class="tap_area"><!-- tap_area start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역 1-->
						<div id="soGIGridDiv"></div>
					</article><!-- grid_wrap end -->
				</article><!-- tap_area end -->
				<article class="tap_area"><!-- tap_area start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역 2-->
						<div id="soPPGridDiv"></div>
					</article><!-- grid_wrap end -->
				</article><!-- tap_area end -->
			</section><!-- tap_wrap end -->
		</form>
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
</body>
</html>