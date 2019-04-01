<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<link href="${pageContext.request.contextPath}/resources/css/select2.min.css" rel="stylesheet">
<script src ="${pageContext.request.contextPath}/resources/js/select2.min.js" type="text/javascript"></script>
<!-- char js -->
<!-- <link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script> -->

<style type="text/css">
/* Custom Sales Accuracy Style */
.my-columnCenter {
	text-align : center;
	margin-top : -20px;
}
.my-currDetailCenter {
	text-align : center;
	background : #CCFFFF;
	color : #000;
}
.my-currSummaryCenter {
	text-align : center;
	background : #CCCCFF;
	color : #000;
}
.my-clickSummaryCenter {
	text-align : center;
	background : #FFCCFF;
	color : #000;
}
.my-columnRight {
	text-align : right;
	margin-top : -20px;
}
.my-currDetailRight {
	text-align : right;
	background : #CCFFFF;
	color : #000;
}
.my-currSummaryRight {
	text-align : right;
	background : #CCCCFF;
	color : #000;
}
.my-clickSummaryRight {
	text-align : right;
	background : #FFCCFF;
	color : #000;
}
.my-columnLeft {
	text-align : left;
	margin-top : -20px;
}
.my-currDetailLeft {
	text-align : left;
	background : #CCFFFF;
	color : #000;
}
.my-currSummaryLeft {
	text-align : left;
	background : #CCCCFF;
	color : #000;
}
.my-clickSummaryLeft {
	text-align : left;
	background : #FFCCFF;
	color : #000;
}
.aui-grid-selection-cell-border-lines {
	background: #22741C; 
}
</style>

<script type="text/javascript">
var beforeStyle	= "";
var currYear	= 0;
var currMonth	= 0;
var currWeek	= 0;

var weeklyHeader	= "";
var weeklyYear	= 0;
var weeklyWeek	= 0;
var weeklyCalcYear	= 0;
var weeklyCalcWeek	= 0;

var monthlyHeader	= "";
var monthlyYear	= 0;
var monthlyMonth	= 0;
var monthlyCalcYear	= 0;
var monthlyCalcMonth	= 0;

var team		= "";

$(function(){
	if ( 1 == $("input[name='gbn']:checked").val() ) {
		$("#periodLabel").text("Year/Week");
		$("#period").text(currWeek + "W / " + currYear);
	} else {
		$("#periodLabel").text("Year/Month");
		$("#period").text(currMonth + "M / " + currYear);
	}
	fnScmTotalPeriod();
	fnScmStockTypeCbBox();
});

/*
 * Button Functions
 */
function fnSalesPlanAccuracyDetailHeader(gbn) {
	if ( 1 > $("#planYear").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Year' htmlEscape='false'/>");
		return	false;
	}
	
	var weeklySummaryLayout		= [];	//	myGridID1
	var monthlySummaryLayout	= [];	//	myGridID2
	var weeklyDetailLayout		= [];	//	myGridID3
	var monthlyDetailLayout		= [];	//	myGridID4
	//console.log(AUIGrid.isCreated(myGridID1));
	//console.log(AUIGrid.isCreated(myGridID2));
	//console.log(AUIGrid.isCreated(myGridID3));
	//console.log(AUIGrid.isCreated(myGridID4));
	//alert(myGridID1);
	if ( "search" == gbn ) {
		if ( AUIGrid.isCreated(myGridID1) ) {console.log("myGridID1 : " + AUIGrid.isCreated(myGridID1));
			AUIGrid.destroy(myGridID1);
		}
		if ( AUIGrid.isCreated(myGridID2) ) {console.log("myGridID2 : " + AUIGrid.isCreated(myGridID2));
			AUIGrid.destroy(myGridID2);
		}
	}
	if ( AUIGrid.isCreated(myGridID3) ) {console.log("myGridID3 : " + AUIGrid.isCreated(myGridID3));
		AUIGrid.destroy(myGridID3);
	}
	if ( AUIGrid.isCreated(myGridID4) ) {console.log("myGridID4 : " + AUIGrid.isCreated(myGridID4));
		AUIGrid.destroy(myGridID4);
	}
	var gridOption	= {
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
	var params	= {
		team : team,
		currYear : currYear,
		currMonth : currMonth,
		currWeek : currWeek,
		weeklyYear : weeklyYear,
		weeklyWeek : weeklyWeek,
		weeklyCalcYear : weeklyCalcYear,
		weeklyCalcWeek : weeklyCalcWeek,
		monthlyYear : monthlyYear,
		monthlyMonth : monthlyMonth,
		monthlyCalcYear : monthlyCalcYear,
		monthlyCalcMonth : monthlyCalcMonth
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("GET"
			, "/scm/selectSalesPlanAccuracyDetailHeader.do"
			, params
			, function(result) {
				//	result check
				if ( null == result.selectSalesPlanAccuracyDetailHeader || 1 > result.selectSalesPlanAccuracyDetailHeader.length ) {
					Common.alert("Scm Calendar Information is wrong");
					return	false;
				}
				
				//	create grid
				if ( null != result.selectSalesPlanAccuracyDetailHeader && 0 < result.selectSalesPlanAccuracyDetailHeader.length ) {
					if ( "1" == $("input[name='gbn']:checked").val() ) {
						if ( "search" == gbn ) {
							//	weekly summary
							weeklySummaryLayout.push(
								 	{	headerText : "Team",	dataField : "team",	style : "my-columnCenter"	},
								 	{	headerText : "1W",		dataField : "w1",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "2W",		dataField : "w2",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "3W",		dataField : "w3",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "4W",		dataField : "w4",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "5W",		dataField : "w5",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "6W",		dataField : "w6",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "7W",		dataField : "w7",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "8W",		dataField : "w8",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "9W",		dataField : "w9",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "10W",		dataField : "w10",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "11W",		dataField : "w11",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "12W",		dataField : "w12",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "13W",		dataField : "w13",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "14W",		dataField : "w14",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "15W",		dataField : "w15",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "16W",		dataField : "w16",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "17W",		dataField : "w17",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "18W",		dataField : "w18",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "19W",		dataField : "w19",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "20W",		dataField : "w20",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "21W",		dataField : "w21",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "22W",		dataField : "w22",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "23W",		dataField : "w23",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "24W",		dataField : "w24",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "25W",		dataField : "w25",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "26W",		dataField : "w26",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "27W",		dataField : "w27",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "28W",		dataField : "w28",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "29W",		dataField : "w29",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "30W",		dataField : "w30",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "31W",		dataField : "w31",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "32W",		dataField : "w32",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "33W",		dataField : "w33",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "34W",		dataField : "w34",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "35W",		dataField : "w35",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "36W",		dataField : "w36",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "37W",		dataField : "w37",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "38W",		dataField : "w38",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "39W",		dataField : "w39",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "40W",		dataField : "w40",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "41W",		dataField : "w41",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "42W",		dataField : "w42",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "43W",		dataField : "w43",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "44W",		dataField : "w44",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "45W",		dataField : "w45",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "46W",		dataField : "w46",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "47W",		dataField : "w47",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "48W",		dataField : "w48",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "49W",		dataField : "w49",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "50W",		dataField : "w50",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "51W",		dataField : "w51",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "52W",		dataField : "w52",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == weeklyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},
								 	{	headerText : "year",	dataField : "planYear",	dataType : "numeric",	style : "my-columnRight", visible : false	}
							);
							myGridID1	= GridCommon.createAUIGrid("summary_wrap", weeklySummaryLayout, "", gridOption);
							AUIGrid.bind(myGridID1, "cellClick", function(event) {
								if ( parseInt(currWeek) > event.columnIndex ) {
									team	= AUIGrid.getCellValue(myGridID1, event.rowIndex, "team");
									weeklyYear	= AUIGrid.getCellValue(myGridID1, event.rowIndex, "planYear");
									weeklyWeek	= event.columnIndex;
									if ( 1 == event.columnIndex ) {
										//	2주차 ~ 52주차 클릭
										weeklyCalcYear	= parseInt(AUIGrid.getCellValue(myGridID1, event.rowIndex, "planYear")) - 1;
										weeklyCalcWeek	= 52;
									} else {
										//	2주차 ~ 52주차 클릭
										weeklyCalcYear	= AUIGrid.getCellValue(myGridID1, event.rowIndex, "planYear");
										weeklyCalcWeek	= parseInt(event.columnIndex) - 1;
									}
									//console.log("weeklyYear : " + weeklyYear + ", weeklyWeek : " + weeklyWeek);
									fnSalesPlanAccuracyDetailHeader("click");
									
									$("#period").text(event.columnIndex + "W / " + event.item.planYear);
									$("#team").text(event.item.team);
								} else {
									console.log("none");
								}
							});
						}
						weeklyDetailLayout.push(
								{
									headerText : "Team",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].team,
									style : "my-columnCenter"
								}, {
									headerText : "Code",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].stockCode,
									style : "my-columnCenter"
								}, {
									headerText : "Ordered Qty",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].salesOrdQty,
									style : "my-columnRight"
								}, {
									headerText : "Accuracy",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].salesAccPer,
									style : "my-columnCenter"
								}, {
									headerText : "Start",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].startWeek,
									style : "my-columnCenter"
								}, {
									headerText : "End",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].endWeek,
									style : "my-columnCenter"
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w1ScmWeek,
									dataField : "w1",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w2ScmWeek,
									dataField : "w2",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w3ScmWeek,
									dataField : "w3",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w4ScmWeek,
									dataField : "w4",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w5ScmWeek,
									dataField : "w5",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w6ScmWeek,
									dataField : "w6",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w7ScmWeek,
									dataField : "w7",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w8ScmWeek,
									dataField : "w8",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w9ScmWeek,
									dataField : "w9",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w10ScmWeek,
									dataField : "w10",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w11ScmWeek,
									dataField : "w11",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w12ScmWeek,
									dataField : "w12",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w13ScmWeek,
									dataField : "w13",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w14ScmWeek,
									dataField : "w14",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w15ScmWeek,
									dataField : "w15",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w16ScmWeek,
									dataField : "w16",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}
						);
						myGridID3	= GridCommon.createAUIGrid("detail_wrap", weeklyDetailLayout, "", gridOption);
						console.log("grid1 : " + AUIGrid.isCreated(myGridID1));
						console.log("grid3 : " + AUIGrid.isCreated(myGridID3));
						//	hide
						$("#summary_wrap").show();
						$("#summary_wrap1").hide();
						$("#detail_wrap").show();
						$("#detail_wrap1").hide();
					} else {
						if ( "search" == gbn ) {
							//	monthly summary
							monthlySummaryLayout.push(
								 	{	headerText : "Team",	dataField : "team",	style : "my-columnCenter"	},
								 	{	headerText : "Jan",		dataField : "m1",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "Feb",		dataField : "m2",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "Mar",		dataField : "m3",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "Apr",		dataField : "m4",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "May",		dataField : "m5",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "Jun",		dataField : "m6",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "Jul",		dataField : "m7",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "Aug",		dataField : "m8",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "Sep",		dataField : "m9",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	}, 	{	headerText : "Oct",		dataField : "m10",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "Nov",		dataField : "m11",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},	{	headerText : "Dec",		dataField : "m12",	dataType : "numeric",	
								 		styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 			if ( headerText == monthlyHeader )	return	"my-currSummaryRight";
								 			else						return	"my-columnRight";
								 		}
								 	},
								 	{	headerText : "year",	dataField : "planYear",	dataType : "numeric",	style : "my-columnRight", visible : false	}
							);
							myGridID2	= GridCommon.createAUIGrid("summary_wrap1", monthlySummaryLayout, "", gridOption);
							AUIGrid.bind(myGridID2, "cellClick", function(event) {
								if ( parseInt(currWeek) > event.columnIndex ) {
									team	= AUIGrid.getCellValue(myGridID2, event.rowIndex, "team");
									monthlyYear	= AUIGrid.getCellValue(myGridID2, event.rowIndex, "planYear");
									monthlyMonth	= event.columnIndex;
									if ( 1 == event.columnIndex ) {
										//	1월 클릭
										monthlyCalcYear	= parseInt(AUIGrid.getCellValue(myGridID2, event.rowIndex, "planYear")) - 1;
										monthlyCalcMonth	= 12;
									} else {
										//	2월 ~ 12월 클릭
										monthlyCalcYear	= AUIGrid.getCellValue(myGridID2, event.rowIndex, "planYear");
										monthlyCalcMonth	= parseInt(event.columnIndex) - 1;
									}
									fnSalesPlanAccuracyDetailHeader("click");
									
									$("#period").text(event.columnIndex + "M / " + event.item.planYear);
									$("#team").text(event.item.team);
								} else {
									console.log("none");
								}
							});
						}
						//	monthly detail
						monthlyDetailLayout.push(
								{
									headerText : "Team",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].team,
									style : "my-columnCenter"
								}, {
									headerText : "Code",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].stockCode,
									style : "my-columnCenter"
								}, {
									headerText : "Ordered Qty",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].salesOrdQty,
									style : "my-columnRight"
								}, {
									headerText : "Accuracy",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].salesAccPer,
									style : "my-columnCenter"
								}, {
									headerText : "Start",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].startWeek,
									style : "my-columnCenter"
								}, {
									headerText : "End",
									dataField : result.selectSalesPlanAccuracyDetailHeader[0].endWeek,
									style : "my-columnCenter"
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w1ScmWeek,
									dataField : "w1",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w2ScmWeek,
									dataField : "w2",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w3ScmWeek,
									dataField : "w3",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w4ScmWeek,
									dataField : "w4",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w5ScmWeek,
									dataField : "w5",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w6ScmWeek,
									dataField : "w6",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w7ScmWeek,
									dataField : "w7",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w8ScmWeek,
									dataField : "w8",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w9ScmWeek,
									dataField : "w9",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w10ScmWeek,
									dataField : "w10",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w11ScmWeek,
									dataField : "w11",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w12ScmWeek,
									dataField : "w12",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w13ScmWeek,
									dataField : "w13",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w14ScmWeek,
									dataField : "w14",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w15ScmWeek,
									dataField : "w15",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}, {
									headerText : result.selectSalesPlanAccuracyDetailHeader[0].w16ScmWeek,
									dataField : "w16",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										var header	= 0;
										var start	= 0;
										var end		= 0;
										
										header	= parseInt(headerText.replace("W", ""));
										start	= parseInt(item.startWeek.replace("W", ""));
										end		= parseInt(item.endWeek.replace("W", ""));
										
										if ( start < end ) {
											if ( header <= start || header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										} else {
											if ( header <= start && header >= end )	return	"my-currDetailRight";
											else									return	"my-columnRight";
										}
							 		}
								}
						);
						myGridID4	= GridCommon.createAUIGrid("detail_wrap1", monthlyDetailLayout, "", gridOption);
						console.log("grid2 : " + AUIGrid.isCreated(myGridID2));
						console.log("grid4 : " + AUIGrid.isCreated(myGridID4));
						//	hide
						$("#summary_wrap").hide();
						$("#summary_wrap1").show();
						$("#detail_wrap").hide();
						$("#detail_wrap1").show();
					}
					
					//	search
					if ( "search" == gbn ) {
						fnSearch();
					} else if ( "click" == gbn ) {
						fnSearchDetail();
					}
				}
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("HeaderFail Status : " + jqXHR.status);
					console.log("code : "        + jqXHR.responseJSON.code);
					console.log("message : "     + jqXHR.responseJSON.message);
					console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}
function fnSearch() {
	var params	= {
		team : team,
		currYear : currYear,
		currMonth : currMonth,
		currWeek : currWeek,
		weeklyYear : weeklyYear,
		weeklyWeek : weeklyWeek,
		weeklyCalcYear : weeklyCalcYear,
		weeklyCalcWeek : weeklyCalcWeek,
		monthlyYear : monthlyYear,
		monthlyMonth : monthlyMonth,
		monthlyCalcYear : monthlyCalcYear,
		monthlyCalcMonth : monthlyCalcMonth,
		scmStockTypeCbBox : $("#scmStockTypeCbBox").val()
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("GET"
			, "/scm/selectSalesPlanAccuracy.do"
			, params
			, function(result) {
				if ( "1" == $("input[name='gbn']:checked").val() ) {
					AUIGrid.setGridData(myGridID1, result.selectSalesPlanAccuracySummary);
					AUIGrid.setGridData(myGridID3, result.selectSalesPlanAccuracyDetail);
				} else {
					AUIGrid.setGridData(myGridID2, result.selectSalesPlanAccuracySummary);
					AUIGrid.setGridData(myGridID4, result.selectSalesPlanAccuracyDetail);
				}
				//fnRadioButton($("input[name='gbn']:checked").val());
				$("#team").text("ALL");
			}
			, ""
			, { async : true, isShowLabel : false });
}
function fnSearchDetail() {
	var params	= {
		team : team,
		currYear : currYear,
		currMonth : currMonth,
		currWeek : currWeek,
		weeklyYear : weeklyYear,
		weeklyWeek : weeklyWeek,
		weeklyCalcYear : weeklyCalcYear,
		weeklyCalcWeek : weeklyCalcWeek,
		monthlyYear : monthlyYear,
		monthlyMonth : monthlyMonth,
		monthlyCalcYear : monthlyCalcYear,
		monthlyCalcMonth : monthlyCalcMonth,
		scmStockTypeCbBox : $("#scmStockTypeCbBox").val()
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("GET"
			, "/scm/selectSalesPlanAccuracyDetail.do"
			, params
			, function(result) {
				if ( "1" == $("input[name='gbn']:checked").val() ) {
					AUIGrid.setGridData(myGridID3, result.selectSalesPlanAccuracyDetail);
				} else {
					AUIGrid.setGridData(myGridID4, result.selectSalesPlanAccuracyDetail);
				}
				//fnRadioButton($("input[name='gbn']:checked").val());
				$("#team").text(team);
			}
			, ""
			, { async : true, isShowLabel : false });
}
function fnMaster() {
	var popUpObj	= Common.popupDiv("/scm/salesPlanAccuracyMasterPopup.do"
			, null
			, null
			, false
			, "salesPlanAccuracyMasterPopup"
	);
}
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. export ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	GridCommon.exportTo("#detail_wrap", "xlsx", fileName + "_" + getTimeStamp());
}

/*
 * User Functions
 */
//	Scm Total Period
function fnScmTotalPeriod() {
	Common.ajax("POST"
			, "/scm/selectScmTotalPeriod.do"
			, ""
			, function(result) {
				currYear	= result.selectScmTotalPeriod[0].scmYear;
				currMonth	= result.selectScmTotalPeriod[0].scmMonth;
				currWeek	= result.selectScmTotalPeriod[0].scmWeek;
				
				if ( 2 == currWeek ) {
					weeklyYear	= currYear;
					weeklyWeek	= 1;
					weeklyCalcYear	= parseInt(currYear) - 1;
					weeklyCalcWeek	= 52;
				} else if ( 1 == currWeek ) {
					weeklyYear	= parseInt(currYear) - 1;
					weeklyWeek	= 52;
					weeklyCalcYear	= parseInt(currYear) - 1;
					weeklyCalcWeek	= 51;
				} else {
					weeklyYear	= currYear;
					weeklyWeek	= parseInt(currWeek) - 1;
					weeklyCalcYear	= currYear;
					weeklyCalcWeek	= parseInt(currWeek) - 2;
				}
				if ( 2 == currMonth ) {
					monthlyYear	= currYear;
					monthlyMonth	= 1;
					monthlyCalcYear	= parseInt(currYear) - 1;
					monthlyCalcMonth	= 12;
				} else if ( 1 == currMonth ) {
					monthlyYear	= parseInt(currYear) - 1;
					monthlyMonth	= 12;
					monthlyCalcYear	= parseInt(currYear) - 1;
					monthlyCalcMonth	= 11;
				} else {
					monthlyYear	= currYear;
					monthlyMonth	= parseInt(currMonth) - 1;
					monthlyCalcYear	= currYear;
					monthlyCalcMonth	= parseInt(currMonth) - 2;
				}
				
				weeklyHeader	= weeklyWeek + "W";
				if ( 1 == monthlyMonth )	monthlyHeader	= "Jan";
				else if ( 2 == monthlyMonth )	monthlyHeader	= "Feb";
				else if ( 3 == monthlyMonth )	monthlyHeader	= "Mar";
				else if ( 4 == monthlyMonth )	monthlyHeader	= "Apr";
				else if ( 5 == monthlyMonth )	monthlyHeader	= "May";
				else if ( 6 == monthlyMonth )	monthlyHeader	= "Jun";
				else if ( 7 == monthlyMonth )	monthlyHeader	= "Jul";
				else if ( 8 == monthlyMonth )	monthlyHeader	= "Aug";
				else if ( 9 == monthlyMonth )	monthlyHeader	= "Sep";
				else if ( 10 == monthlyMonth )	monthlyHeader	= "Oct";
				else if ( 11 == monthlyMonth )	monthlyHeader	= "Nov";
				else if ( 12 == monthlyMonth )	monthlyHeader	= "Dec";
				
				team	= "ALL";
				fnScmYearCbBox();
			});
}
//	year
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
	CommonCombo.make("planYear"
			, "/scm/selectScmYear.do"
			, ""
			, currYear.toString()
			, {
				id : "id",
				name : "name",
				chooseMessage : "Year"
			}
			, "");
}
function fnScmStockTypeCbBox() {
	CommonCombo.make("scmStockTypeCbBox"
			, "/scm/selectScmStockType.do"
			, ""
			, "61"
			, {
				id : "id",
				name : "name",
				chooseMessage : "ALL"
			}
			, "");
}

/*
 * Util Functions
 */
function getTimeStamp() {
	function fnLeadingZeros(n, digits) {
		var zero	= "";
		n	= n.toString();
		if ( n.length < digits ) {
			for ( var i = 0 ; i < digits - n.length ; i++ ) {
				zero	+= "0";
			}
		}
		return	zero + n;
	}
	var d	= new Date();
	var date	= fnLeadingZeros(d.getFullYear(), 4) + fnLeadingZeros(d.getMonth() + 1, 2) + fnLeadingZeros(d.getDate(), 2);
	var time	= fnLeadingZeros(d.getHours(), 2) + fnLeadingZeros(d.getMinutes(), 2) + fnLeadingZeros(d.getSeconds(), 2);
	
	return	date + "_" + time;
}

/*
 * Grid create & setting
 */
var myGridID1, myGridID2, myGridID3, myGridID4;

function fnCreateGrid() {
	var gridOption	= {
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
	
	var weeklySummaryLayout	=
		[
		 {	headerText : "Team"	},
		 {	headerText : "W01"	},	{	headerText : "W02"	},	{	headerText : "W03"	},	{	headerText : "W04"	},	{	headerText : "W05"	},
		 {	headerText : "W06"	},	{	headerText : "W07"	},	{	headerText : "W08"	},	{	headerText : "W09"	},	{	headerText : "W10"	},
		 {	headerText : "W11"	},	{	headerText : "W12"	},	{	headerText : "W13"	},	{	headerText : "W14"	},	{	headerText : "W15"	},
		 {	headerText : "W16"	},	{	headerText : "W17"	},	{	headerText : "W18"	},	{	headerText : "W19"	},	{	headerText : "W20"	},
		 {	headerText : "W21"	},	{	headerText : "W22"	},	{	headerText : "W23"	},	{	headerText : "W24"	},	{	headerText : "W25"	},
		 {	headerText : "W26"	},	{	headerText : "W27"	},	{	headerText : "W28"	},	{	headerText : "W29"	},	{	headerText : "W30"	},
		 {	headerText : "W31"	},	{	headerText : "W32"	},	{	headerText : "W33"	},	{	headerText : "W34"	},	{	headerText : "W35"	},
		 {	headerText : "W36"	},	{	headerText : "W37"	},	{	headerText : "W38"	},	{	headerText : "W39"	},	{	headerText : "W40"	},
		 {	headerText : "W41"	},	{	headerText : "W42"	},	{	headerText : "W43"	},	{	headerText : "W44"	},	{	headerText : "W45"	},
		 {	headerText : "W46"	},	{	headerText : "W47"	},	{	headerText : "W48"	},	{	headerText : "W49"	},	{	headerText : "W50"	},	{	headerText : "W51"	},	{	headerText : "W52"	}
		 ];
	myGridID1	= GridCommon.createAUIGrid("summary_wrap", weeklySummaryLayout, "", gridOption);
	
	var monthlySummaryLayout	=
		[
		 {	headerText : "Team"	},
		 {	headerText : "Jan"	},	{	headerText : "Feb"	},	{	headerText : "Mar"	},	{	headerText : "Apr"	},	{	headerText : "May"	},	{	headerText : "Jun"	},
		 {	headerText : "Jul"	},	{	headerText : "Aug"	},	{	headerText : "Sep"	},	{	headerText : "Oct"	},	{	headerText : "Nov"	},	{	headerText : "Dec"	}
		 ];
	myGridID2	= GridCommon.createAUIGrid("summary_wrap1", monthlySummaryLayout, "", gridOption);
	
	var detailLayout	=
		[
		 {	headerText : "Team"	},	{	headerText : "Code"	},	{	headerText : "Name"	},	{	headerText : "Ordered"	},	{	headerText : "Accuracy"	},	{	headerText : "Start"	},	{	headerText : "End"	},
		 {	headerText : "W16"	},	{	headerText : "W15"	},	{	headerText : "W14"	},	{	headerText : "W13"	},
		 {	headerText : "W12"	},	{	headerText : "W11"	},	{	headerText : "W10"	},	{	headerText : "W09"	},
		 {	headerText : "W08"	},	{	headerText : "W07"	},	{	headerText : "W06"	},	{	headerText : "W05"	},
		 {	headerText : "W04"	},	{	headerText : "W03"	},	{	headerText : "W02"	},	{	headerText : "W01"	}
		 ];
	myGridID3	= GridCommon.createAUIGrid("detail_wrap", detailLayout, "", gridOption);
	myGridID4	= GridCommon.createAUIGrid("detail_wrap1", detailLayout, "", gridOption);
	
	$("#summary_wrap").show();
	$("#summary_wrap1").hide();
	$("#detail_wrap").show();
	$("#detail_wrap1").hide();
}

$(document).ready(function() {
	fnCreateGrid();
});
</script>

<section id="content">						<!-- section content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order List</li>
	</ul>
	
	<aside class="title_line">				<!-- aside title_line start -->
		<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
		<h2>Sales Plan Accuracy</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSalesPlanAccuracyDetailHeader('search')"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside>								<!-- aside title_line end -->
	
	<section class="search_table">			<!-- section search_table start -->
		<form id="MainForm" method="post" action="">
			<table class="type1">			<!-- table type1 start -->
			<caption>table</caption>
				<colgroup>
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:70px" />
					<col style="width:*" />
					<col style="width:100px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Year</th>
						<td>
							<select class="sel_year" id="planYear" name="planYear"></select>
						</td>
						<th scope="row"></th>
						<td>
							<label><input type="radio" name="gbn" id="gbn" value="1" checked="checked" onclick="fnSalesPlanAccuracyDetailHeader('search')" /><span>Weeky</span></label>
							<label><input type="radio" name="gbn" id="gbn" value="2" onclick="fnSalesPlanAccuracyDetailHeader('search')"/><span>Monthly</span></label>
						</td>
						<th scope="row">Type</th>
						<td>
							<select class="w100p" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
						</td>
					</tr>
				</tbody>
			</table>						<!-- table type1 end -->
			
			<aside class="link_btns_wrap">	<!-- aside link_btns_wrap start -->
				<p class="show_btn"></p>
				<dl class="link_list">
					<dt>Link</dt>
					<dd>
						<ul class="btns">
							<li><p class="link_btn"><a href="javascript:void(0);">menu1</a></p></li>
							<li><p class="link_btn"><a href="javascript:void(0);">menu2</a></p></li>
							<li><p class="link_btn"><a href="javascript:void(0);">menu3</a></p></li>
							<li><p class="link_btn"><a href="javascript:void(0);">menu4</a></p></li>
							<li><p class="link_btn"><a href="javascript:void(0);">Search Payment</a></p></li>
							<li><p class="link_btn"><a href="javascript:void(0);">menu6</a></p></li>
							<li><p class="link_btn"><a href="javascript:void(0);">menu7</a></p></li>
							<li><p class="link_btn"><a href="javascript:void(0);">menu8</a></p></li>
						</ul>
						<ul class="btns">
							<li><p class="link_btn type2"><a href="javascript:void(0);">menu1</a></p></li>
							<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
							<li><p class="link_btn type2"><a href="javascript:void(0);">menu3</a></p></li>
							<li><p class="link_btn type2"><a href="javascript:void(0);">menu4</a></p></li>
							<li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
							<li><p class="link_btn type2"><a href="javascript:void(0);">menu6</a></p></li>
							<li><p class="link_btn type2"><a href="javascript:void(0);">menu7</a></p></li>
							<li><p class="link_btn type2"><a href="javascript:void(0);">menu8</a></p></li>
						</ul>
						<p class="hide_btn"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
					</dd>
				</dl>
			</aside>						<!-- aside link_btns_wrap end -->
		</form>
	</section>								<!-- section search_table end -->
	<section class="search_result">				<!-- section search_result start -->
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Summary Grid -->
			<div id="summary_wrap" style="height:146px;"></div>
			<div id="summary_wrap1" style="height:146px;"></div>
		</article>								<!-- article grid_wrap end -->
		<table class="type1 mt10">				<!-- table start -->
			<caption>table10</caption>
			<colgroup>
				<col style="width:100px" />
				<col style="width:100px" />
				<col style="width:100px" />
				<col style="width:100px" />
				<col style="width:*" />
				<col style="width:200px" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><span id="teamLabel">Team</span></th><td><span id="team"></span></td>
					<th scope="row"><span id="periodLabel"></span></th><td><span id="period"></span></td>
					<td></td>
					<td align="rignt">
						<ul class="right_btns">
							<li><p id="btnMaster" class="btn_grid"><a onclick="fnMaster();">Master</a></p></li>
							<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'SalesPlanAccuracy');">Excel</a></p></li>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>								<!-- table end -->
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Detail Grid -->
			<div id="detail_wrap" style="height:511px;width:100%;"></div>
			<div id="detail_wrap1" style="height:511px;width:100%;"></div>
		</article>								<!-- article grid_wrap end -->
	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->