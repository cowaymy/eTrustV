<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* Custom Sales Accuracy Master Style */
.my-columnCenter2 {
	text-align : center;
	margin-top : -20px;
}
.my-columnRight2 {
	text-align : right;
	margin-top : -20px;
}
.my-columnLeft2 {
	text-align : left;
	margin-top : -20px;
}
.salesPlanAccuracyMaster{position:fixed; top:200px; left:10%; z-index:1001; width:1000px; background:#fff; border:1px solid #ccc;}
</style>

<script type="text/javaScript">
var planYearP	= "";

$(function() {
	planYearP		= "${params.planYear}";
	console.log("planYearP : " + planYearP);
	fnScmYearCbBox();
});

function fnScmYearCbBox() {
    /**
     * 공통 콤보박스 : option 으로 처리.
     *
     * @param _comboId           : 콤보박스 id     String               => "comboId" or "#comboId"
     * @param _url                  : 호출 URL
     * @param _jsonParam        : 넘길 파라미터  json object      => {id : "im7015", name : "lim"}
     * @param _sSelectData      : 선택될 id        String              =>단건 : "aaa", 다건 :  "aaa|!|bbb|!|ccc"
     * @param _option              : 옵션.             소스내                => var option 참조.
     * @param _callback            : 콜백함수         function           => function(){..........}
     */
	CommonCombo.make("planYearP"
			, "/scm/selectScmYear.do"
			, ""
			, planYearP.toString()
			, {
				id : "id",
				name : "name",
				chooseMessage : "Year"
			}
			, "");
}

function fnSearchPop() {
	var params	= {
		//planYear : $("#planYearP").val()
		planYear : 2019
	};
/*	Common.ajax("POST"
			, "/scm/selectSalesPlanAccuracyMaster.do"
			, params
			, function(result) {
				AUIGrid.setGridData(myGridID1, result.selectSalesPlanAccuracyMaster);
			});*/
	Common.ajax("GET"
			, "/scm/selectSalesPlanAccuracyMaster1.do"
			, params
			, function(result) {
				AUIGrid.setGridData(myGridID1, result);
			});
}

function fnClose() {
	$("#salesPlanAccuracyMaster").remove();
}

//	save
/*
function fnSave() {
	if ( false == fnValidationCdcCheck() ) {
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/saveSalesPlanAccuracyMaster.do"
			, GridCommon.getEditData(myGridID1)
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
	var insList	= AUIGrid.getAddedRowItems(myGridID1);
	var updList	= AUIGrid.getEditedRowItems(myGridID1);
	var delList	= AUIGrid.getRemovedItems(myGridID1);
	
	if ( 0 == insList.length && 0 == updList.length && 0 == delList.length ) {
		Common.alert("No Change");
		return	false;
	}
	
	return	result;
}
*/
/***************************************************[ Main GRID] ***************************************************/
var myGridID1;
var masterOption	= {
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
	//defaultColumnWidth : 10,
	fixedColumnCount : 1
};
var masterLayout	=
	[
	 	{
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
	myGridID1	= GridCommon.createAUIGrid("master_wrap", masterLayout, "", masterOption);
});	//$(document).ready
</script>

<body>
<div id="popup_wrap" class="popup_wrap sales_master"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Sales Plan Accuracy Master</h1>
		<ul class="right_opt">
			<li><p class="btn_blue"><a onclick="fnSearchPop();"><span class="search"></span>Search</a></p></li>
			<li><p class="btn_blue"><a onclick="fnClose();"><span class="close"></span>Close</a></p></li>
			<!-- <li><p class="btn_blue2"><a href="fnSearchPop();">Search</a></p></li>
			<li><p class="btn_blue2"><a href="fnClose();">Close</a></p></li> -->
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<table class="type1">			<!-- table type1 start -->
		<caption>table1</caption>
			<colgroup>
				<col style="width:140px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">Year</th>
					<td>
						<select class="sel_year" id="planYearP" name="planYearP"></select>
					</td>
				</tr>
			</tbody>
		</table>
		<form id="PopForm" method="get">
			<section class="tap_wrap mt0"><!-- tap_wrap start -->
				<article class="tap_area"><!-- tap_area start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역 1-->
						<div id="master_wrap"></div>
					</article><!-- grid_wrap end -->
				</article><!-- tap_area end -->
			</section><!-- tap_wrap end -->
		</form>
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
</body>
</html>