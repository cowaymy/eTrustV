<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
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
.my-columnRight1 {
	text-align : right;
	background : #CCFFFF;
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

var curr	= 0;
var codeId	= "";

var currObj	= new Object();
var detObj	= new Object();
//JSONObject jsonList	= new JSONObject();
//JSONArray krwList	= new JSONArray();
//JSONArray myrList	= new JSONArray();

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
				 		//headerStyle : "aui-grid-user-custom-header",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "totPrevQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : totalHeader[1],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "totCurrQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "Gap",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "totGapQty",
									dataType : "numeric",
									style : "my-columnRight1"
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
				 		//headerStyle : "aui-grid-user-custom-header",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "handPrevQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : totalHeader[1],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "handCurrQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "Gap",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "handGapQty",
									dataType : "numeric",
									style : "my-columnRight1"
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
				 		//headerStyle : "aui-grid-user-custom-header",
				 		children :
				 			[
								{
									headerText : totalHeader[0],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "agePrevQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : totalHeader[1],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "ageCurrQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "Gap",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "ageGapQty",
									dataType : "numeric",
									style : "my-columnRight1"
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
				 		//headerStyle : "aui-grid-user-custom-header",
				 		children :
				 			[
								{
									headerText : "Total Inventory",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "totAmt",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "In-Transit",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "tranAmt",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "On-Hand",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "handAmt",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "Days in Inventory",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "daysAmt",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "Aging",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "ageAmt",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "Stock B",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "stkbAmt",
									dataType : "numeric",
									style : "my-columnRight1"
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
				 		//headerStyle : "aui-grid-user-custom-header",
				 		children :
				 			[
								{
									headerText : detailHeader[0],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "mm6IssQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[1],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "mm5IssQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[2],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "mm4IssQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[3],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "mm3IssQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[4],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "mm2IssQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[5],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "mm1IssQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[6],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "m0PlanQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[7],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "m1PlanQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : detailHeader[8],
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "m2PlanQty",
									dataType : "numeric",
									style : "my-columnRight1"
								}, {
									headerText : "Average Forwarding",
									//headerStyle : "aui-grid-user-custom-header",
									dataField : "avgForwQty",
									dataType : "numeric",
									style : "my-columnRight1"
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
				//AUIGrid.setGridData(myGridID2, result.selectInventoryReportDetail);
				currObj	= result.selectScmCurrency;
				detObj	= result.selectInventoryReportDetail;
				curr	= currObj[0].curr;
				codeId	= currObj[0].codeId;
				$("#curr").val(curr);
				fnSetResult(result.selectInventoryReportDetail, result.selectScmCurrency);
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
				
				//AUIGrid.setGridData(myGridID2, result.selectInventoryReportDetail);
				currObj	= result.selectScmCurrency;
				detObj	= result.selectInventoryReportDetail;
				curr	= currObj[0].curr;
				codeId	= currObj[0].codeId;
				$("#curr").val(curr);
				fnSetResult(result.selectInventoryReportDetail, result.selectScmCurrency);
				//detKor	= result.selectInventoryReportDetail;
			});
}
function fnExecuteBatch() {
	var params	= {	staValue : 0, retValue : ""	};
	
	Common.ajax("POST"
			, "/scm/executeScmInventory.do"
			, params
			, function(result) {
				
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
function fnSaveCurr() {
	if ( 1 > $("#curr").val().length ) {
		//Common.alert("<spring:message code='sys.msg.necessary' arguments='Currency' htmlEscape='false'/>");
		return	false;
	}
	
	var params	= {
			curr : $("#curr").val()
	};
	console.log(params);
	Common.ajax("POST"
			, "/scm/updateScmCurrency.do"
			, params
			, function(result) {
				
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
function fnSetResult() {
	var myr	= $("#curr").val();
	var krwList	= new Array();
	var myrList	= new Array();
	
	console.log("curr : " + curr + ", codeId : " + codeId + ", $('#curr').val() : " + $("#curr").val() + ", myr : " + myr);
	myrList	= detObj;
	for ( var i = 0 ; i < detObj.length ; i++ ) {
		var temp	= new Object();
		temp.stockTypeName	= detObj[i].stockTypeName;
		temp.stockCategoryName	= detObj[i].stockCategoryName;
		temp.stockCode	= detObj[i].stockCode;
		temp.stockName	= detObj[i].stockName;
		temp.totAmt		= ((parseInt(detObj[i].totAmt) * parseFloat(myr)) / 1000000).toFixed(1);
		temp.tranAmt	= ((parseInt(detObj[i].tranAmt) * parseFloat(myr)) / 1000000).toFixed(1);
		temp.handAmt	= ((parseInt(detObj[i].handAmt) * parseFloat(myr)) / 1000000).toFixed(1);
		temp.daysAmt	= ((parseInt(detObj[i].daysAmt) * parseFloat(myr)) / 1000000).toFixed(1);
		temp.ageAmt		= ((parseInt(detObj[i].ageAmt) * parseFloat(myr)) / 1000000).toFixed(1);
		temp.stkbAmt	= ((parseInt(detObj[i].stkbAmt) * parseFloat(myr)) / 1000000).toFixed(1);
		temp.totQty	= detObj[i].totQty;
		temp.tranQty	= detObj[i].tranQty;
		temp.handQty	= detObj[i].handQty;
		temp.daysQty	= detObj[i].daysQty;
		temp.ageQty	= detObj[i].ageQty;
		temp.stkbQty	= detObj[i].stkbQty;
		temp.mm6IssQty	= detObj[i].mm6IssQty;
		temp.mm5IssQty	= detObj[i].mm5IssQty;
		temp.mm4IssQty	= detObj[i].mm4IssQty;
		temp.mm3IssQty	= detObj[i].mm3IssQty;
		temp.mm2IssQty	= detObj[i].mm2IssQty;
		temp.mm1IssQty	= detObj[i].mm1IssQty;
		temp.m0PlanQty	= detObj[i].m0PlanQty;
		temp.m1PlanQty	= detObj[i].m1PlanQty;
		temp.m2PlanQty	= detObj[i].m2PlanQty;
		krwList.push(temp);
	}
	
	if ( "1" == $("input[name='gbn']:checked").val() ) {
		AUIGrid.setGridData(myGridID2, krwList);
	} else {
		AUIGrid.setGridData(myGridID2, myrList);
	}
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
	 		headerStyle : "aui-grid-user-custom-header",
	 		children :
	 			[
					{
						headerText : "Prev Month",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Curr Month",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Gap",	headerStyle : "aui-grid-user-custom-header"
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
	 		headerStyle : "aui-grid-user-custom-header",
	 		children :
	 			[
					{
						headerText : "Prev Month",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Curr Month",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Gap",	headerStyle : "aui-grid-user-custom-header"
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
	 		headerStyle : "aui-grid-user-custom-header",
	 		children :
	 			[
					{
						headerText : "Prev Month",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Curr Month",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Gap",	headerStyle : "aui-grid-user-custom-header"
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
	 		headerStyle : "aui-grid-user-custom-header",
	 		children :
	 			[
					{
						headerText : "Total Inventory",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "In-Transit",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "On-Hand",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Days in Inventory",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Aging",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Stock B",	headerStyle : "aui-grid-user-custom-header"
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
	 		headerStyle : "aui-grid-user-custom-header",
	 		children :
	 			[
					{
						headerText : "M-5",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M-4",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M-3",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M-2",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M-1",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M-0",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M+1",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M+2",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "M+3",	headerStyle : "aui-grid-user-custom-header"
					}, {
						headerText : "Average Forwarding",	headerStyle : "aui-grid-user-custom-header"
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
						<th scope="row"></th>
						<td>
							<label><input type="radio" name="gbn" id="gbn" value="2" checked="checked" onclick="fnSetResult()"/><span>Myr</span></label>
							<label><input type="radio" name="gbn" id="gbn" value="1" onclick="fnSetResult()" /><span>Krw / Million</span></label>
						</td>
						<td colspan="2"></td>
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
			<!-- Monthly Grid -->
			<div id="inventory_report_total_wrap" style="height:186px;"></div>
		</article>								<!-- article grid_wrap end -->
		<ul class="right_btns">
			<li><p id="btnExecute" class="btn_grid"><a onclick="fnExecuteBatch();">Execute Batch</a></p></li>
			<li><input type="text" id="curr" name="curr" /></li>
			<li><p id="btnSave" class="btn_grid"><a onclick="fnSaveCurr();">Save</a></p></li>
			<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'InventoryReport');">Excel</a></p></li>
		</ul>
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Weekly Grid -->
			<div id="inventory_report_detail_wrap" style="height:471px;"></div>
		</article>								<!-- article grid_wrap end -->
	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->