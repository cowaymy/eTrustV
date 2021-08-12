<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* Custom Ontime Delivery Report Popup */
.my-columnCenter {
	text-align : center;
	margin-top : -20px;
}
.my-columnRight {
	text-align : right;
	margin-top : -20px;
}
.my-columnLeft {
	text-align : left;
	margin-top : -20px;
}
</style>

<script type="text/javaScript">
var sapPoNo		= "";
var sapPoItemNo	= 0;
var	stockCode	= "";

$(function() {
	sapPoNo		= "${params.sapPoNo}";
	sapPoItemNo	= "${params.sapPoItemNo}";
	stockCode	= "${params.stockCode}";
	
	fnSearchPop();
});

function fnSearchPop() {
	var params	= {
		sapPoNo : sapPoNo,
		sapPoItemNo : sapPoItemNo,
		stockCode : stockCode
	};
	console.log(params);
	//params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("GET"
			, "/scm/selectOntimeDeliveryPopup.do"
			, params
			, function(result) {
				console.log(result);
				AUIGrid.setGridData(myGridID3, result.selectOntimeDeliveryPopup);
			});
}
function fnClose() {
	$("#ontimeDeliveryReportPopup").remove();
}

/***************************************************[ Main GRID] ***************************************************/
var myGridID3, myGridID3Option, myGridID3Layout;
var myGridID3Option	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : false,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	showFooter : false,
	editable : false,
	enableCellMerge : false,
	enableRestore : false,
	fixedColumnCount : 1
};
var myGridID3Layout	=
	[
		{
			headerText : "GR Year",
			dataField : "grYear",
			style : ".my-columnCenter"
		}, {
			headerText : "GR Month",
			dataField : "grMonth",
			style : ".my-columnCenter"
		}, {
			headerText : "GR Week",
			dataField : "grWeek",
			style : ".my-columnCenter"
		}, {
			headerText : "GR Date",
			dataField : "grDt",
			dataType : "date",
			style : ".my-columnCenter"
		}, {
			headerText : "AP Qty",
			dataField : "apQty",
			dataType : "numeric",
			style : ".my-columnRight"
		}, {
			headerText : "GR Qty",
			dataField : "grQty",
			dataType : "numeric",
			style : ".my-columnRight"
		}, {
			headerText : "CI Date",
			dataField : "ciDt",
			dataType : "date",
			style : ".my-columnCenter"
		}, {
			headerText : "Ship Date",
			dataField : "shipDt",
			dataType : "date",
			style : ".my-columnCenter"
		}
	 ];

$(document).ready(function() {
	myGridID3	= GridCommon.createAUIGrid("#gr_wrap", myGridID3Layout, "", myGridID3Option);
});	//$(document).ready
</script>

<body>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>GR List</h1>
		<ul class="right_opt">
			<!-- <li><p class="btn_blue2"><a href="fnClose();">Close</a></p></li>
			<li><p class="btn_blue"><a onclick="fnSearchPop();"><span class="search"></span>Search</a></p></li> -->
			<li><p class="btn_blue"><a onclick="fnClose();"><span class="close"></span>Close</a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<form id="PopForm" method="get" action="">
			<section class="tap_wrap mt0"><!-- tap_wrap start -->
				<article class="tap_area"><!-- tap_area start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역 1-->
						<div id="gr_wrap"></div>
					</article><!-- grid_wrap end -->
				</article><!-- tap_area end -->
			</section><!-- tap_wrap end -->
		</form>
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
</body>
</html>