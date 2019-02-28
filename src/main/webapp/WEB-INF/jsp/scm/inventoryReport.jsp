<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">
/* Custom Inventory Report Style */
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

<script type="text/javascript">
var gPlanYearMonth	= "";
var gPlanYear	= 0;
var gPlanMonth	= 0;
var gPlanWeek	= 0;

var today	= null;
var prevMm	= 0;
var currMm	= 0;
var yyyy	= 0;

var monName	= ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
var totalHeader		= ["", ""];
var detailHeader	= ["", "", "", "", "", "", "", "", ""];
var m1		= null;	var m2		= null;	var m3		= null;
var m4		= null;	var m5		= null;	var m6		= null;
var m7		= null;	var m8		= null;	var m9		= null;

$(function(){
	fnScmTotalPeriod();
});

/*
 * Button Functions
 */
//	Search
function fnSearchTotal() {
	Common.ajax("GET"
			, "/scm/selectInventoryReportTotal.do"
			, $("#MainForm").serialize()
			, function(result) {
				console.log(result);
				
				fnSetHeader();
				
				if ( AUIGrid.isCreated(myGridID1) ) {
					console.log("destroy1");
					AUIGrid.destroy(myGridID1);
				}
				if ( AUIGrid.isCreated(myGridID2) ) {
					console.log("destroy2");
					AUIGrid.destroy(myGridID2);
				}
				//	Total Grid
				totalLayout	= 
				[
				 	{
				 		headerText : "Type",
				 		dataField : "stockTypeName",
				 		style : "my-columnCenter"
				 	}, {
				 		//	Total Inventory
				 		headerText : "Total Inventory",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									dataField : "totPrevQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : totalHeader[1],
									dataField : "totCurrQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Gap",
									dataField : "totGapQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}, {
				 		//	In-Transit
				 		headerText : "In-Transit",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									dataField : "tranPrevQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : totalHeader[1],
									dataField : "tranCurrQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Gap",
									dataField : "tranGapQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}, {
				 		//	On-Hand
				 		headerText : "On-Hand",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									dataField : "handPrevQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : totalHeader[1],
									dataField : "handCurrQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Gap",
									dataField : "handGapQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}, {
				 		//	Days in Inventory
				 		headerText : "Days in Inventory",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									dataField : "daysPrevQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : totalHeader[1],
									dataField : "daysCurrQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Gap",
									dataField : "daysGapQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}, {
				 		//	Aging
				 		headerText : "Aging",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									dataField : "agePrevQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : totalHeader[1],
									dataField : "ageCurrQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Gap",
									dataField : "ageGapQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}, {
				 		//	Stock B
				 		headerText : "Stock B",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									dataField : "stkbPrevQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : totalHeader[1],
									dataField : "stkbCurrQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Gap",
									dataField : "stkbGapQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}
				 ];
				myGridID1	= GridCommon.createAUIGrid("#inventory_report_total_wrap", totalLayout, "", totalOptions);
				AUIGrid.bind(myGridID1, "cellClick", function(event) {
					fnSearchDetail(AUIGrid.getCellValue(myGridID1, event.rowIndex, "stockTypeId"));
				});
				AUIGrid.bind(myGridID1, "cellDoubleClick", function(event) {
					
				});
				
				//	Detail Grid
				detailLayout	=
				[
					{
						headerText : "Type",
						dataField : "stockTypeName",
						style : "my-columnCenter"
					}, {
						headerText : "Category",
						dataField : "stockCategoryName",
						style : "my-columnCenter"
					}, {
						headerText : "Code",
						dataField : "stockCode",
						style : "my-columnCenter"
					}, {
						headerText : "Name",
						dataField : "stockName",
						style : "my-columnLeft"
					}, {
				 		//	Amount
				 		headerText : "Amount",
				 		children :
				 			[
								{
									headerText : "Total Inventory",
									dataField : "totAmt",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "In-Transit",
									dataField : "tranAmt",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "On-Hand",
									dataField : "handAmt",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Days in Inventory",
									dataField : "daysAmt",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Aging",
									dataField : "ageAmt",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Stock B",
									dataField : "stkbAmt",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}, {
				 		//	Quantity
				 		headerText : "Quantity",
				 		children :
				 			[
								{
									headerText : "Total Inventory",
									dataField : "totQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "In-Transit",
									dataField : "tranQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "On-Hand",
									dataField : "handQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Days in Inventory",
									dataField : "daysQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Aging",
									dataField : "ageQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Stock B",
									dataField : "stkbQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}, {
				 		//	Sales Performance and Planning(Quantity)
				 		headerText : "Sales Performance and Planning(Quantity)",
				 		children :
				 			[
								{
									headerText : detailHeader[0],
									dataField : "mm6IssQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[1],
									dataField : "mm5IssQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[2],
									dataField : "mm4IssQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[3],
									dataField : "mm3IssQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[4],
									dataField : "mm2IssQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[5],
									dataField : "mm1IssQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[6],
									dataField : "m0PlanQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[7],
									dataField : "m1PlanQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : detailHeader[8],
									dataField : "m2PlanQty",
									dataType : "numeric",
									style : "my-columnRight"
								}, {
									headerText : "Average Forwarding",
									dataField : "avgForwQty",
									dataType : "numeric",
									style : "my-columnRight"
								}
				 			 ]
				 	}
				 ];
				myGridID2	= GridCommon.createAUIGrid("#inventory_report_detail_wrap", detailLayout, "", detailOptions);
				AUIGrid.bind(myGridID2, "cellClick", function(event) {
					
				});
				AUIGrid.bind(myGridID2, "cellDoubleClick", function(event) {
					
				});
				//	Sales Plan Summary
				AUIGrid.setGridData(myGridID1, result.selectInventoryReportTotal);
				AUIGrid.setGridData(myGridID2, result.selectInventoryReportDetail);
			});
}
function fnSearchDetail(stockTypeId) {
	if ( "60" == stockTypeId ) {
		stockTypeId	= "";
	}
	var params	= {
			planYearMonth : $("#planYearMonth").val(),
			stockTypeId : stockTypeId
	};
	Common.ajax("GET"
			, "/scm/selectInventoryReportDetail.do"
			//, $("#MainForm").serialize()
			, params
			, function(result) {
				console.log(result);
				
				AUIGrid.setGridData(myGridID2, result.selectInventoryReportDetail);
			});
}
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. export ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	GridCommon.exportTo("#inventory_report_detail_wrap", "xlsx", fileName + "_" + getTimeStamp());
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
				gPlanYear	= result.selectScmTotalPeriod[0].scmYear;
				gPlanMonth	= result.selectScmTotalPeriod[0].scmMonth;
				gPlanWeek	= result.selectScmTotalPeriod[0].scmWeek;
				if ( 0 < gPlanMonth && 10 > gPlanMonth ) {
					gPlanYearMonth	= "0" + gPlanMonth + "/" + gPlanYear;
				} else {
					gPlanYearMonth	= gPlanMonth + "/" + gPlanYear;
				}
				
				$("#planYearMonth").val(gPlanYearMonth);
			});
}
function fnPlanYearMonthChange() {
	console.log($("#planYearMonth").val());
}
function fnSetHeader() {
	//console.log("fnSetHeader");
	var yyyy	= $("#planYearMonth").val().substring(3, 7);
	var mm		= $("#planYearMonth").val().substring(0, 2);
	
	today	= new Date(yyyy + "/" + mm + "/" + "01");
	m1	= new Date(yyyy + "/" + mm + "/" + "01");
	m2	= new Date(yyyy + "/" + mm + "/" + "01");
	m3	= new Date(yyyy + "/" + mm + "/" + "01");
	m4	= new Date(yyyy + "/" + mm + "/" + "01");
	m5	= new Date(yyyy + "/" + mm + "/" + "01");
	m6	= new Date(yyyy + "/" + mm + "/" + "01");
	m7	= new Date(yyyy + "/" + mm + "/" + "01");
	m8	= new Date(yyyy + "/" + mm + "/" + "01");
	m9	= new Date(yyyy + "/" + mm + "/" + "01");
	prevMm	= today.getMonth() - 1;
	currMm	= today.getMonth() + 0;
	yyyy	= today.getFullYear();
	
	//	Total Header
	if ( prevMm < 10 ) {
		if ( 0 == prevMm ) {
			prevMm	= "12";
			yyyy	= parseInt(yyyy) - 1;
		} else {
			prevMm	= "0" + prevMm;
		}
	}
	totalHeader[0]	= prevMm + "/" + yyyy;
	if ( currMm < 10 ) {
		if ( 0 == currMm ) {
			currMm	= "12";
			yyyy	= parseInt(yyyy) - 1;
		} else {
			currMm	= "0" + currMm;
		}
	}
	totalHeader[1]	= currMm + "/" + yyyy;
	
	//	Detail Header
	m1	= new Date(m1.setMonth(m1.getMonth() - 6));	console.log(m1.getMonth());
	m2	= new Date(m2.setMonth(m2.getMonth() - 5));	console.log(m2.getMonth());
	m3	= new Date(m3.setMonth(m3.getMonth() - 4));	console.log(m3.getMonth());
	m4	= new Date(m4.setMonth(m4.getMonth() - 3));	console.log(m4.getMonth());
	m5	= new Date(m5.setMonth(m5.getMonth() - 2));	console.log(m5.getMonth());
	m6	= new Date(m6.setMonth(m6.getMonth() - 1));	console.log(m6.getMonth());
	m7	= new Date(m7.setMonth(m7.getMonth() + 0));	console.log(m7.getMonth());
	m8	= new Date(m8.setMonth(m8.getMonth() + 1));	console.log(m8.getMonth());
	m9	= new Date(m9.setMonth(m9.getMonth() + 2));	console.log(m9.getMonth());
	detailHeader[0]	= "Issued (" + monName[m1.getMonth()] + ")";
	detailHeader[1]	= "Issued (" + monName[m2.getMonth()] + ")";
	detailHeader[2]	= "Issued (" + monName[m3.getMonth()] + ")";
	detailHeader[3]	= "Issued (" + monName[m4.getMonth()] + ")";
	detailHeader[4]	= "Issued (" + monName[m5.getMonth()] + ")";
	detailHeader[5]	= "Issued (" + monName[m6.getMonth()] + ")";
	detailHeader[6]	= "Planned (" + monName[m7.getMonth()] + ")";
	detailHeader[7]	= "Planned (" + monName[m8.getMonth()] + ")";
	detailHeader[8]	= "Planned (" + monName[m9.getMonth() ] + ")";
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
 * Grid Create & Setting
 */
var myGridID1, myGridID2;

//	myGridTotal
var totalOptions	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : false,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	editable : false,
	enableCellMerge : false,
	enableRestore : false,
	fixedColumnCount : 1
};
var totalLayout	= 
	[
	 	{
	 		headerText : "Type"
	 	}, {
	 		//	Total Inventory
	 		headerText : "Total Inventory",
	 		children :
	 			[
					{
						headerText : "Prev Month"
					}, {
						headerText : "Curr Month"
					}, {
						headerText : "Gap"
					}
	 			 ]
	 	}, {
	 		//	In-Transit
	 		headerText : "In-Transit",
	 		children :
	 			[
					{
						headerText : "Prev Month"
					}, {
						headerText : "Curr Month"
					}, {
						headerText : "Gap"
					}
	 			 ]
	 	}, {
	 		//	On-Hand
	 		headerText : "On-Hand",
	 		children :
	 			[
					{
						headerText : "Prev Month"
					}, {
						headerText : "Curr Month"
					}, {
						headerText : "Gap"
					}
	 			 ]
	 	}, {
	 		//	Days in Inventory
	 		headerText : "Days in Inventory",
	 		children :
	 			[
					{
						headerText : "Prev Month"
					}, {
						headerText : "Curr Month"
					}, {
						headerText : "Gap"
					}
	 			 ]
	 	}, {
	 		//	Aging
	 		headerText : "Aging",
	 		children :
	 			[
					{
						headerText : "Prev Month"
					}, {
						headerText : "Curr Month"
					}, {
						headerText : "Gap"
					}
	 			 ]
	 	}, {
	 		//	Stock B
	 		headerText : "Stock B",
	 		children :
	 			[
					{
						headerText : "Prev Month"
					}, {
						headerText : "Curr Month"
					}, {
						headerText : "Gap"
					}
	 			 ]
	 	}
	 ];

//	myGridDetail
var detailOptions	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : true,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	editable : false,
	enableCellMerge : false,
	enableRestore : false,
	fixedColumnCount : 4
};
var detailLayout	=
	[
		{
			headerText : "Type"
		}, {
			headerText : "Category"
		}, {
			headerText : "Code"
		}, {
			headerText : "Name"
		}, {
	 		//	Amount
	 		headerText : "Amount",
	 		children :
	 			[
					{
						headerText : "Total Inventory"
					}, {
						headerText : "In-Transit"
					}, {
						headerText : "On-Hand"
					}, {
						headerText : "Days in Inventory"
					}, {
						headerText : "Aging"
					}, {
						headerText : "Stock B"
					}
	 			 ]
	 	}, {
	 		//	Quantity
	 		headerText : "Quantity",
	 		children :
	 			[
					{
						headerText : "Total Inventory"
					}, {
						headerText : "In-Transit"
					}, {
						headerText : "On-Hand"
					}, {
						headerText : "Days in Inventory"
					}, {
						headerText : "Aging"
					}, {
						headerText : "Stock B"
					}
	 			 ]
	 	}, {
	 		//	Sales Performance and Planning(Quantity)
	 		headerText : "Sales Performance and Planning(Quantity)",
	 		children :
	 			[
					{
						headerText : "M-5"
					}, {
						headerText : "M-4"
					}, {
						headerText : "M-3"
					}, {
						headerText : "M-2"
					}, {
						headerText : "M-1"
					}, {
						headerText : "M-0"
					}, {
						headerText : "M+1"
					}, {
						headerText : "M+2"
					}, {
						headerText : "M+3"
					}, {
						headerText : "Average Forwarding"
					}
	 			 ]
	 	}
	 ];

$(document).ready(function() {
	//	Total Grid
	myGridID1	= GridCommon.createAUIGrid("#inventory_report_total_wrap", totalLayout, "", totalOptions);
	AUIGrid.bind(myGridID1, "cellClick", function(event) {
		
	});
	AUIGrid.bind(myGridID1, "cellDoubleClick", function(event) {
		
	});
	
	//	Detail Grid
	myGridID2	= GridCommon.createAUIGrid("#inventory_report_detail_wrap", detailLayout, "", detailOptions);
	AUIGrid.bind(myGridID2, "cellClick", function(event) {
		
	});
	AUIGrid.bind(myGridID2, "cellDoubleClick", function(event) {
		
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
		<h2>Inventory Report</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSearchTotal();"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside>								<!-- aside title_line end -->
	
	<section class="search_table">			<!-- section search_table start -->
		<form id="MainForm" method="post" action="">
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
						<th scope="row">Year &amp; Month</th>
						<td>
							<input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="planYearMonth" name="planYearMonth" onchange="fnPlanYearMonthChange();" />
						</td>
						<td colspan="4"></td>
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
		<!-- Monthly Grid -->
		<div id="inventory_report_total_wrap" style="height:186px;"></div>
	</article>								<!-- article grid_wrap end -->
	<ul class="right_btns">
		<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'InventoryReport');">Excel</a></p></li>
	</ul>
	<article class="grid_wrap">				<!-- article grid_wrap start -->
		<!-- Weekly Grid -->
		<div id="inventory_report_detail_wrap" style="height:476px;"></div>
	</article>								<!-- article grid_wrap end -->
</section>									<!-- section search_result end -->
