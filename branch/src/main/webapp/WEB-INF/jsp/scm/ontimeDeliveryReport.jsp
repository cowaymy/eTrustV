<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">
/* Custom On-Time Delivery Report Style */
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
.my-columnHyperLink:hover {
	text-decoration : underline;
	text-align : center;
	margin-top : -20px;
	cursor : pointer;
}
.aui-grid-selection-cell-border-lines {
	background: #22741C; 
}
</style>

<script type="text/javascript">
var currYear	= 0;
var currMonth	= 0;
var currWeek	= 0;
var planYear	= 0;
var planMonth	= 0;
var planWeek	= 0;

$(function(){
	fnScmTotalPeriod();
	fnScmCdcCbBox();
});

/*
 * Button Functions
 */
function fnSearch() {
	var params	= {
			planYear : planYear,
			planMonth : planMonth,
			cdc : $("#scmCdcCbBox").val()
	}
	//console.log(planMonth);
	Common.ajax("GET"
			, "/scm/selectOntimeDelivery.do"
			//, $("#MainForm").serialize()
			, params
			, function(result) {
				AUIGrid.setGridData(myGridID1, result.selectOntimeDeliverySummary);
				AUIGrid.setGridData(myGridID2, result.selectOntimeDeliveryDetail);
				var planMonthNm	= "";
				if ( 1 == planMonth )		planMonthNm	= "Jan";
				else if ( 2 == planMonth )	planMonthNm	= "Feb";
				else if ( 3 == planMonth )	planMonthNm	= "Mar";
				else if ( 4 == planMonth )	planMonthNm	= "Apr";
				else if ( 5 == planMonth )	planMonthNm	= "May";
				else if ( 6 == planMonth )	planMonthNm	= "Jun";
				else if ( 7 == planMonth )	planMonthNm	= "Jul";
				else if ( 8 == planMonth )	planMonthNm	= "Aug";
				else if ( 9 == planMonth )	planMonthNm	= "Sep";
				else if ( 10 == planMonth )	planMonthNm	= "Oct";
				else if ( 11 == planMonth )	planMonthNm	= "Nov";
				else if ( 12 == planMonth )	planMonthNm	= "Dec";
				$("#yearMonth").text(planMonthNm + " / " + AUIGrid.getCellValue(myGridID1, 0, "planYear"));
				$("#issPoQty").text(AUIGrid.getCellValue(myGridID1, 0, currMonth));
				$("#onTimeQty").text(AUIGrid.getCellValue(myGridID1, 1, currMonth));
				$("#onTimeRate").text(AUIGrid.getCellValue(myGridID1, 2, currMonth));
			}
			, ""
			, { async : true, isShowLabel : false });
}
function fnSearchDetail() {
	var params	= {
			planYear : planYear,
			planMonth : planMonth,
			cdc : $("#scmCdcCbBox").val()
	}
	Common.ajax("GET"
			, "/scm/selectOntimeDeliveryDetail.do"
			//, $("#MainForm").serialize()
			, params
			, function(result) {
				AUIGrid.setGridData(myGridID2, result.selectOntimeDeliveryDetail);
			});
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
				//console.log(result);
				
				currYear	= result.selectScmTotalPeriod[0].scmYear;
				currMonth	= result.selectScmTotalPeriod[0].scmMonth;
				currWeek	= result.selectScmTotalPeriod[0].scmWeek;
				planYear	= currYear;
				planMonth	= currMonth;
				planWeek	= currWeek;
				fnPlanYear();
			});
}
function fnPlanYear() {
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
function fnScmCdcCbBox() {
	CommonCombo.make("scmCdcCbBox"
			, "/scm/selectScmCdc.do"
			, ""
			, ""
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
function fnChangeYear() {
	planYear	= $("#planYear").val();
	if ( planYear != currYear ) {
		planMonth	= 1;
	} else {
		planMonth	= currMonth;
	}
	console.log("planYear : " + planYear + ", planMonth : " + planMonth);
}

/*
 * Grid create & setting
 */
var myGridID1, myGridID2;
var summaryOptions	= {
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
var summaryLayout	= 
	[
	 	{
	 		headerText : " ",
	 		dataField : "gbn",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "Jan",
	 		dataField : "m1",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Feb",
	 		dataField : "m2",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Mar",
	 		dataField : "m3",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Apr",
	 		dataField : "m4",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "May",
	 		dataField : "m5",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Jun",
	 		dataField : "m6",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Jul",
	 		dataField : "m7",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Aug",
	 		dataField : "m8",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Sep",
	 		dataField : "m9",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Oct",
	 		dataField : "m10",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Nov",
	 		dataField : "m11",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Dec",
	 		dataField : "m12",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}
	 ];
var detailOptions	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : true,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	showFooter : false,
	editable : false,
	enableCellMerge : false,
	enableRestore : false,
	fixedColumnCount : 5
};
var detailLayout	=
	[
	 	{
	 		headerText : "PO No.",
	 		dataField : "poNo",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "PO Item No.",
	 		dataField : "poItemNo",
	 		style : "my-columnCenter"
	 	},{
	 		headerText : "SAP PO No.",
	 		dataField : "sapPoNo",
	 		style : "my-columnCenter",
	 		visible : false
	 	}, {
	 		headerText : "SAP PO Item No.",
	 		dataField : "sapPoItemNo",
	 		style : "my-columnCenter",
	 		visible : false
	 	}, {
	 		headerText : "Code",
	 		dataField : "stockCode",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "Name",
	 		dataField : "stockName",
	 		style : "my-columnLeft"
	 	}, {
	 		headerText : "PO Issue Date",
	 		dataField : "poIssDt",
	 		dataType : "date",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "Planned GR Week",
	 		dataField : "planGrWeek",
	 		dataType : "numeric",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "GR Week(1st)",
	 		dataField : "fstGrWeek",
	 		dataType : "numeric",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "GR Week(Last)",
	 		dataField : "lstGrWeek",
	 		dataType : "numeric",
	 		style : "my-columnHyperLink"
	 	}, {
	 		headerText : "PO Qty",
	 		dataField : "poQty",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "On-Time GR Qty",
	 		dataField : "onTimeGrQty",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "On-Time",
	 		dataField : "onTimeChk",
	 		renderer : {
	 			type : "TemplateRenderer"
	 		},
	 		labelFunction : function (rowIndex, columnIndex, value, headerText, item) {
 				var template	= "<div class='status_result'>";
 				if ( "1" == value ) {
 					template	+= "<span id='circle' class='circle circle_blue'></span>";
 				} else if ( "0" == value ) {
 					template	+= "<span id='circle' class='circle circle_red'></span>";
 				} else {
 					template	+= "<span id='circle' class='circle circle_grey'></span>";
 				}
 				template	+= "</div>";
 				return	template
 			}
	 	}, {
	 		headerText : "Etc",
	 		dataField : "etc",
	 		style : "my-columnLeft"
	 	}
	 ];
	 
$(document).ready(function() {
	//	Summary Grid
	myGridID1	= GridCommon.createAUIGrid("#summary_wrap", summaryLayout, "", summaryOptions);
	AUIGrid.bind(myGridID1, "cellClick", function(event) {
		console.log("currYear : " + currYear);
		if ( 0 == event.columnIndex )	return	false;
		if ( $("#planYear").val() < currYear ) {
			planYear	= AUIGrid.getCellValue(myGridID1, event.rowIndex, "planYear");
			planMonth	= event.columnIndex;
			fnSearchDetail();
		} else if ( $("#planYear").val() == currYear ) {
			if ( parseInt(currMonth) >= event.columnIndex ) {
				planYear	= AUIGrid.getCellValue(myGridID1, event.rowIndex, "planYear");
				planMonth	= event.columnIndex;
				fnSearchDetail();
			}
		} else {
			
		}
		var planMonthNm	= "";
		if ( 1 == event.columnIndex )		planMonthNm	= "Jan";
		else if ( 2 == event.columnIndex )	planMonthNm	= "Feb";
		else if ( 3 == event.columnIndex )	planMonthNm	= "Mar";
		else if ( 4 == event.columnIndex )	planMonthNm	= "Apr";
		else if ( 5 == event.columnIndex )	planMonthNm	= "May";
		else if ( 6 == event.columnIndex )	planMonthNm	= "Jun";
		else if ( 7 == event.columnIndex )	planMonthNm	= "Jul";
		else if ( 8 == event.columnIndex )	planMonthNm	= "Aug";
		else if ( 9 == event.columnIndex )	planMonthNm	= "Sep";
		else if ( 10 == event.columnIndex )	planMonthNm	= "Oct";
		else if ( 11 == event.columnIndex )	planMonthNm	= "Nov";
		else if ( 12 == event.columnIndex )	planMonthNm	= "Dec";
		$("#yearMonth").text(planMonthNm + " / " + event.item.planYear);
		$("#issPoQty").text(AUIGrid.getCellValue(myGridID1, 0, event.columnIndex));
		$("#onTimeQty").text(AUIGrid.getCellValue(myGridID1, 1, event.columnIndex));
		$("#onTimeRate").text(AUIGrid.getCellValue(myGridID1, 2, event.columnIndex));
	});
	
	//	Detail Grid
	myGridID2	= GridCommon.createAUIGrid("#detail_wrap", detailLayout, "", detailOptions);
	AUIGrid.bind(myGridID2, "cellClick", function(event) {
		console.log(event);
		if ( "" != event.value && null != event.value && 9 == event.columnIndex ) {
			//	click GR Week(Last)
			var params	= {
					sapPoNo : event.item.sapPoNo,
					sapPoItemNo : event.item.sapPoItemNo,
					stockCode : event.item.stockCode
			}
			
			var popUpObj	= Common.popupDiv("/scm/ontimeDeliveryReportPopup.do"
					, params
					, null
					, false
					, "ontimeDeliveryReportPopup"
			);
		}
	});
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
		<h2>On-Time Delivery Report</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside>								<!-- aside title_line end -->
	
	<section class="search_table">			<!-- section search_table start -->
		<form id="MainForm" method="get" action="">
			<input type="hidden" id="stockTypeId" name="stockTypeId" />
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
							<select class="sel_year" id="planYear" name="planYear" onchange="fnChangeYear();"></select>
						</td>
						<th scope="row">CDC</th>
						<td>
							<select class="w100p" id="scmCdcCbBox" name="scmCdcCbBox"></select>
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
	<section class="search_result">				<!-- section search_result start -->
		<table class="type1 mt10">				<!-- table start -->
			<caption>table10</caption>
			<colgroup>
				<col style="width:100px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><span id="teamLabel">Summary</span></th>
					<td></td>
				</tr>
			</tbody>
		</table>
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Summary Grid -->
			<div id="summary_wrap" style="height:106px;"></div>
		</article>								<!-- article grid_wrap end -->
		<table class="type1 mt10">				<!-- table start -->
			<caption>table10</caption>
			<colgroup>
				<col style="width:100px" />
				<col style="width:100px" />
				<col style="width:100px" />
				<col style="width:*" />
				<col style="width:100px" />
				<col style="width:*" />
				<col style="width:100px" />
				<col style="width:*" />
				<col style="width:100px" />
				<col style="width:*" />
				<col style="width:100px" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><span id="detail">Detail</span></th><td><span id="detail"></span></td>
					<th scope="row">Month / Year</th><td><span id="yearMonth"></span></td>
					<th scope="row">Issued PO</th><td><span id="issPoQty"></span></td>
					<th scope="row">On-Time</th><td><span id="onTimeQty"></span></td>
					<th scope="row">On-Time Rate</th><td><span id="onTimeRate"></span></td>
					<td>
						<ul class="right_btns">
							<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'OntimeDelivery Report');">Excel</a></p></li>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>								<!-- table end -->
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Detail Grid -->
			<div id="detail_wrap" style="height:514px;"></div>
		</article>								<!-- article grid_wrap end -->
	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->