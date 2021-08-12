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
$(function() {
	fnSearchPop();
});

function fnSearchPop() {
	var	params	= {	planYear : 2019	};
	Common.ajax("POST"
			, "/scm/selectSalesPlanAccuracyMaster.do"
			, params
			, function(result) {
				console.log(result);
				AUIGrid.setGridData(myGridID5, result.selectSalesPlanAccuracyMaster);
			});
}
function fnSave() {
	if ( false == fnValidationCdcCheck() ) {
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/saveSalesPlanAccuracyMaster.do"
			, GridCommon.getEditData(myGridID5)
			, function(result) {
				Common.alert(result.data + "<spring:message code='sys.msg.saveCnt' />");
				fnSearchPop();
				fnClose();
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : " + jqXHR.status);
					console.log("code : " + jqXHR.responseJSON.code);
					console.log("message : " + jqXHR.responseJSON.message);
					console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}

function fnValidationCdcCheck() {
	var result	= true;
	var insList	= AUIGrid.getAddedRowItems(myGridID5);
	var updList	= AUIGrid.getEditedRowItems(myGridID5);
	var delList	= AUIGrid.getRemovedItems(myGridID5);
	
	if ( 0 == insList.length && 0 == updList.length && 0 == delList.length ) {
		Common.alert("No Change");
		return	false;
	}
	
	return	result;
}

function fnClose() {
	//alert(myGridID1);
	$("#salesPlanAccuracyMasterPopup").remove();
	console.log(AUIGrid.isCreated(myGridID1));
	console.log(AUIGrid.isCreated(myGridID2));
	console.log(AUIGrid.isCreated(myGridID3));
	console.log(AUIGrid.isCreated(myGridID4));
	/*AUIGrid.destroy(myGridID1);
	AUIGrid.destroy(myGridID2);
	AUIGrid.destroy(myGridID3);
	AUIGrid.destroy(myGridID4);*/
	//location.reload();
}

/***************************************************[ Main GRID] ***************************************************/
var myGridID5;
var masterOption	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : false,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	showFooter : false,
	editable : false,
	enableCellMerge : true,
	enableRestore : false,
	//defaultColumnWidth : 10,
	fixedColumnCount : 1
};
var masterLayout	=
	[
	 	{
	 		headerText : "Year",
	 		dataField : "year",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "year",
	 		style : "my-columnCenter2"
	 	},	{
	 		headerText : " ",
	 		dataField : "gbnNm",
	 		style : "my-columnCenter2"
	 	},	{
	 		headerText : "-1W",
	 		dataField : "w1",
	 		//defaultColumnWidth : "40px",
	 		//rowHeight : 20,
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 1,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-2W",
	 		dataField : "w2",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 2,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-3W",
	 		dataField : "w3",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 3,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-4W",
	 		dataField : "w4",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 4,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-5W",
	 		dataField : "w5",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 5,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-6W",
	 		dataField : "w6",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 6,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-7W",
	 		dataField : "w7",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 7,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-8W",
	 		dataField : "w8",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 8,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-9W",
	 		dataField : "w9",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 9,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-10W",
	 		dataField : "w10",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 10,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-11W",
	 		dataField : "w11",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 11,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-12W",
	 		dataField : "w12",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 12,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-13W",
	 		dataField : "w13",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 13,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-14W",
	 		dataField : "w14",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 14,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-15W",
	 		dataField : "w15",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 15,
	 			unCheckValue : 0
	 		}
	 	},	{
	 		headerText : "-16W",
	 		dataField : "w16",
	 		renderer : {
	 			type : "CheckBoxEditRenderer",
	 			showLabel : false,
	 			editable : true,
	 			checkValue : 16,
	 			unCheckValue : 0
	 		}
	 	}
	 ];

$(document).ready(function() {
	myGridID5	= GridCommon.createAUIGrid("sales_plan_accuracy_master_wrap", masterLayout, "", masterOption);
});	//$(document).ready
</script>

<body>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Sales Plan Accuracy Master</h1>
		<ul class="right_opt">
			<!-- <li><p class="btn_blue"><a onclick="fnSearchPop();"><span class="search"></span>Search</a></p></li> -->
			<li><p class="btn_blue"><a onclick="fnSave();"><span class="save"></span>Save</a></p></li>
			<li><p class="btn_blue"><a onclick="fnClose();"><span class="close"></span>Close</a></p></li>
			<!-- <li><p class="btn_blue"><a href="fnClose();">CLOSE</a></p></li> -->
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<form id="PopForm" method="get" action="">
			<section class="tap_wrap mt0"><!-- tap_wrap start -->
				<article class="tap_area"><!-- tap_area start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역 1-->
						<div id="sales_plan_accuracy_master_wrap"></div>
					</article><!-- grid_wrap end -->
				</article><!-- tap_area end -->
			</section><!-- tap_wrap end -->
		</form>
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
</body>
</html>