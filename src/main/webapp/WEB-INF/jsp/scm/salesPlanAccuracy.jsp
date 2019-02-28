<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">
/* Custom Sales Accuracy Style */
</style>

<script type="text/javascript">
var planYear	= 0;
var planMonth	= 0;
var planWeek	= 0;
var clickYear	= 0;
var clickMonth	= 0;
var clickWeek	= 0;
var weekDiff	= 0;
var monthDiff	= 0;
var team		= "";

$(function(){
	fnScmTotalPeriod();
});

/*
 * Button Functions
 */
function fnSalesAccuracyDetailHeader(gbn) {
	if ( 1 > $("#planYear").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Year' htmlEscape='false'/>");
		return	false;
	}
	
	var weeklyDetailLayout	= [];	//	myGridID3
	var weeklyDetalOption	= {};
	var monthlyDetailLayout	= [];	//	myGridID4
	var monthlyDetailOption	= {};
	
	if ( AUIGrid.isCreated(myGridID3) ) {
		AUIGrid.destroy(myGridID3);
	}
	if ( AUIGrid.isCreated(myGridID4) ) {
		AUIGrid.destroy(myGridID4);
	}
	
	var weeklyDetailOption	= {
		usePaging : false,
		useGroupingPanel : false,
		showRowNumColumn : false,
		showRowCheckColumn : false,
		showStateColumn : false,
		showEditedCellMarker : false,
		showFooter : true,
		editable : false,
		enableCellMerge : false,
		enableRestore : false,
		fixedColumnCount : 1
	};
	var monthlyDetailOption	= {
		usePaging : false,
		useGroupingPanel : false,
		showRowNumColumn : false,
		showRowCheckColumn : false,
		showStateColumn : false,
		showEditedCellMarker : false,
		showFooter : true,
		editable : false,
		enableCellMerge : false,
		enableRestore : false,
		fixedColumnCount : 1
	};
	
	if ( "search" == gbn ) {
		weekDiff	= 0;
		monthDiff	= 0;
	}
	var params	= {
		team : team,
		currYear : planYear,
		currMonth : planMonth,
		currWeek : planWeek,
		clickYear : clickYear,
		clickWeek : clickWeek,
		clickMonth : clickMonth,
		weekDiff : weekDiff,
		monthDiff : monthDiff
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("GET"
			, "/scm/selectSalesAccuracyDetailHeader.do"
			//, $("#MainForm").serializeJSON()
			, params
			, function(result) {
				
				//console.log(result);
				
				//	result check
				if ( null == result.selectSalesAccuracyDetailHeader || 1 > result.selectSalesAccuracyDetailHeader.length ) {
					Common.alert("Scm Calendar Information is wrong");
					return	false;
				}
				
				//	create grid
				if ( null != result.selectSalesAccuracyDetailHeader && 0 < result.selectSalesAccuracyDetailHeader.length ) {
					weeklyDetailLayout.push(
							{
								headerText : "Team",
								dataField : result.selectSalesAccuracyDetailHeader[0].team,
								style : "my-columnCenter"
							}, {
								headerText : "Code",
								dataField : result.selectSalesAccuracyDetailHeader[0].stockCode,
								style : "my-columnCenter"
							}, {
								headerText : "Issued Qty",
								dataField : result.selectSalesAccuracyDetailHeader[0].salesIssQty,
								style : "my-columnCenter"
							}, {
								headerText : "Accuracy",
								dataField : result.selectSalesAccuracyDetailHeader[0].saleesAccPer,
								style : "my-columnCenter"
							}, {
								headerText : "Start",
								dataField : result.selectSalesAccuracyDetailHeader[0].startWeek,
								style : "my-columnCenter"
							}, {
								headerText : "End",
								dataField : result.selectSalesAccuracyDetailHeader[0].endWeek,
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w1ScmWeek,
								dataField : "w1",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w2ScmWeek,
								dataField : "w2",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w3ScmWeek,
								dataField : "w3",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w4ScmWeek,
								dataField : "w4",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w5ScmWeek,
								dataField : "w5",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w6ScmWeek,
								dataField : "w6",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w7ScmWeek,
								dataField : "w7",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w8ScmWeek,
								dataField : "w8",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w9ScmWeek,
								dataField : "w9",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w10ScmWeek,
								dataField : "w10",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w11ScmWeek,
								dataField : "w11",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w12ScmWeek,
								dataField : "w12",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w13ScmWeek,
								dataField : "w13",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w14ScmWeek,
								dataField : "w14",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w15ScmWeek,
								dataField : "w15",
								style : "my-columnCenter"
							}, {
								headerText : result.selectSalesAccuracyDetailHeader[0].w16ScmWeek,
								dataField : "w16",
								style : "my-columnCenter"
							}
					);
					
					//	Create Grid
					myGridID3	= GridCommon.createAUIGrid("weekly_detail_wrap", weeklyDetailLayout, "", weeklyDetailOption);
					myGridID4	= GridCommon.createAUIGrid("monthly_detail_wrap", weeklyDetailLayout, "", weeklyDetailOption);
					
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
		currYear : planYear,
		currMonth : planMonth,
		currWeek : planWeek,
		clickYear : clickYear,
		clickWeek : clickWeek,
		clickMonth : clickMonth,
		weekDiff : weekDiff,
		monthDiff : monthDiff
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("GET"
			, "/scm/selectSalesAccuracy.do"
			//, $("#MainForm").serialize()
			, params
			, function(result) {
				//console.log(result);
				AUIGrid.setGridData(myGridID1, result.selectSalesPlanAccuracyWeeklySummary);
				AUIGrid.setGridData(myGridID2, result.selectSalesPlanAccuracyMonthlySummary);
				AUIGrid.setGridData(myGridID3, result.selectSalesPlanAccuracyWeeklyDetail);
				AUIGrid.setGridData(myGridID4, result.selectSalesPlanAccuracyMonthlyDetail);
			});
}
function fnSearchDetail() {
	var params	= {
		team : team,
		currYear : planYear,
		currMonth : planMonth,
		currWeek : planWeek,
		clickYear : clickYear,
		clickWeek : clickWeek,
		clickMonth : clickMonth,
		weekDiff : weekDiff,
		monthDiff : monthDiff
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("GET"
			, "/scm/selectSalesAccuracyDetail.do"
			//, $("#MainForm").serialize()
			, params
			, function(result) {
				//console.log(result);
				AUIGrid.setGridData(myGridID3, result.selectSalesPlanAccuracyWeeklyDetail);
				AUIGrid.setGridData(myGridID4, result.selectSalesPlanAccuracyMonthlyDetail);
			});
}
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. export ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	GridCommon.exportTo("#sales_plan_wrap", "xlsx", fileName + "_" + getTimeStamp());
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
				//console.log(result);
				
				planYear	= result.selectScmTotalPeriod[0].scmYear;
				planMonth	= result.selectScmTotalPeriod[0].scmMonth;
				planWeek	= result.selectScmTotalPeriod[0].scmWeek;
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
			, planYear.toString()
			, {
				id : "id",
				name : "name",
				chooseMessage : "Year"
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
function fnRadioButton(val) {
	if ( 1 == val ) {
		$("#weekly_summary_wrap").show();
		$("#weekly_detail_wrap").show();
		$("#monthly_summary_wrap").hide();
		$("#monthly_detail_wrap").hide();
	} else {
		$("#weekly_summary_wrap").hide();
		$("#weekly_detail_wrap").hide();
		$("#monthly_summary_wrap").show();
		$("#monthly_detail_wrap").show();
	}
}
/*
 * Grid create & setting
 */
var myGridID1, myGridID2, myGridID3, myGridID4;

//	Summary Weekly Grid
var weeklySummaryOption	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : false,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	showFooter : true,
	editable : false,
	enableCellMerge : false,
	enableRestore : false,
	fixedColumnCount : 1
};
var weeklySummaryLayout	= 
	[
	 	{	headerText : "Team",	dataField : "team",	style : "my-columnCenter"	},
	 	{	headerText : "1W",		dataField : "w1",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "2W",		dataField : "w2",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "3W",		dataField : "w3",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "4W",		dataField : "w4",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "5W",		dataField : "w5",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "6W",		dataField : "w6",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "7W",		dataField : "w7",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "8W",		dataField : "w8",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "9W",		dataField : "w9",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "10W",		dataField : "w10",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "11W",		dataField : "w11",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "12W",		dataField : "w12",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "13W",		dataField : "w13",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "14W",		dataField : "w14",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "15W",		dataField : "w15",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "16W",		dataField : "w16",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "17W",		dataField : "w17",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "18W",		dataField : "w18",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "19W",		dataField : "w19",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "20W",		dataField : "w20",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "21W",		dataField : "w21",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "22W",		dataField : "w22",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "23W",		dataField : "w23",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "24W",		dataField : "w24",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "25W",		dataField : "w25",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "26W",		dataField : "w26",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "27W",		dataField : "w27",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "28W",		dataField : "w28",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "29W",		dataField : "w29",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "30W",		dataField : "w30",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "31W",		dataField : "w31",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "32W",		dataField : "w32",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "33W",		dataField : "w33",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "34W",		dataField : "w34",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "35W",		dataField : "w35",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "36W",		dataField : "w36",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "37W",		dataField : "w37",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "38W",		dataField : "w38",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "39W",		dataField : "w39",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "40W",		dataField : "w40",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "41W",		dataField : "w41",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "42W",		dataField : "w42",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "43W",		dataField : "w43",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "44W",		dataField : "w44",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "45W",		dataField : "w45",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "46W",		dataField : "w46",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "47W",		dataField : "w47",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "48W",		dataField : "w48",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "49W",		dataField : "w49",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "50W",		dataField : "w50",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "51W",		dataField : "w51",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "52W",		dataField : "w52",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "year",	dataField : "planYear",	dataType : "numeric",	style : "my-columnRight", visible : false	}
	 ];
	 
var monthlySummaryOption	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : false,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	showFooter : true,
	editable : false,
	enableCellMerge : false,
	enableRestore : false,
	fixedColumnCount : 1
};
var monthlySummaryLayout	= 
	[
	 	{	headerText : "Team",	dataField : "team",	style : "my-columnCenter"	},
	 	{	headerText : "Jan",		dataField : "m1",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Feb",		dataField : "m2",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Mar",		dataField : "m3",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Apr",		dataField : "m4",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "May",		dataField : "m5",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Jun",		dataField : "m6",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Jul",		dataField : "m7",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Aug",		dataField : "m8",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Sep",		dataField : "m9",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Oct",		dataField : "m10",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Nov",		dataField : "m11",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "Dec",		dataField : "m12",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "year",	dataField : "planYear",	dataType : "numeric",	style : "my-columnRight", visible : false	}
	 ];

$(document).ready(function() {
	//	Summary Weekly Grid
	myGridID1	= GridCommon.createAUIGrid("#weekly_summary_wrap", weeklySummaryLayout, "", weeklySummaryOption);
	AUIGrid.bind(myGridID1, "cellClick", function(event) {
		if ( "ALL" == AUIGrid.getCellValue(myGridID1, event.rowIndex, "team") ) {
			team	= "";
		} else {
			team	= AUIGrid.getCellValue(myGridID1, event.rowIndex, "team");
		}
		clickYear	= AUIGrid.getCellValue(myGridID1, event.rowIndex, "planYear");
		clickMonth	= 0;
		clickWeek	= event.columnIndex;	//	1W 앞에 칼럼이 1개 추가되면 event.columnIndex + 1, 1개 삭제되면 event.columnIndex - 1
		weekDiff	= (parseInt(planWeek) - parseInt(clickWeek) - 1) * 7;
		monthDiff	= 0;
		console.log("weekDiff : " + weekDiff + ", monthDiff : " + monthDiff);
		fnSalesAccuracyDetailHeader("click");
	});
	AUIGrid.bind(myGridID1, "cellDoubleClick", function(event) {
		
	});
	
	//	Summary Monthly Grid
	myGridID2	= GridCommon.createAUIGrid("#monthly_summary_wrap", monthlySummaryLayout, "", monthlySummaryOption);
	AUIGrid.bind(myGridID2, "cellClick", function(event) {
		if ( "ALL" == AUIGrid.getCellValue(myGridID2, event.rowIndex, "team") ) {
			team	= "";
		} else {
			team	= AUIGrid.getCellValue(myGridID2, event.rowIndex, "team");
		}
		clickYear	= AUIGrid.getCellValue(myGridID2, event.rowIndex, "planYear");
		clickMonth	= event.columnIndex;	//	1M 앞에 칼럼이 1개 추가되면 event.columnIndex + 1, 1개 삭제되면 event.columnIndex - 1
		clickWeek	= 0;
		weekDiff	= 0;
		monthDiff	= parseInt(planMonth) - parseInt(clickMonth) - 1;
		fnSalesAccuracyDetailHeader("click");
	});
	AUIGrid.bind(myGridID2, "cellDoubleClick", function(event) {
		
	});
	$("#monthly_summary_wrap").hide();
	$("#monthly_detail_wrap").hide();
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
			<li><p class="btn_blue"><a onclick="fnSalesAccuracyDetailHeader('search')"><span class="search"></span>Search</a></p></li>
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
							<label><input type="radio" name="gbn" id="gbn" value="1" checked="checked" onclick="fnRadioButton(1)" /><span>Weeky</span></label>
							<label><input type="radio" name="gbn" id="gbn" value="2" onclick="fnRadioButton(2)"/><span>Monthly</span></label>
						</td>
						<td colspan="2" />
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
</section>									<!-- section content end -->

<section class="search_result">				<!-- section search_result start -->
	<article class="grid_wrap">				<!-- article grid_wrap start -->
		<!-- Summary Grid -->
		<div id="weekly_summary_wrap" style="height:126;"></div>
		<div id="monthly_summary_wrap" style="height:126;"></div>
	</article>								<!-- article grid_wrap end -->
	<ul class="right_btns">
		<li><p id="btnExcel" class="btn_grid btn_disabled"><a onclick="fnExcel(this, 'SalesPlanAccuracy');">Excel</a></p></li>
	</ul>
	<article class="grid_wrap">				<!-- article grid_wrap start -->
		<!-- Detail Grid -->
		<div id="weekly_detail_wrap" style="height:500px;"></div>
		<div id="monthly_detail_wrap" style="height:500px;"></div>
	</article>								<!-- article grid_wrap end -->
</section>									<!-- section search_result end -->