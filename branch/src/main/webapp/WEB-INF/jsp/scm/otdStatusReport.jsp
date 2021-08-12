<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<link href="${pageContext.request.contextPath}/resources/css/select2.min.css" rel="stylesheet">
<script src ="${pageContext.request.contextPath}/resources/js/select2.min.js" type="text/javascript"></script>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
	text-align:right;
}
.aui-grid-left-column {
	text-align:right;
}

/* HTML 템플릿에서 사용할 스타일 정의*/
.closeDiv span{
	color: red;
	vertical-align:middle;
	font-size: 12pt;
}
.openDiv span{
	color: blue;
	vertical-align:middle;
	font-size: 12pt;
}

/* 커스텀 칼럼 스타일 정의*/
.myLinkStyle {
	text-decoration: underline;
	color:#4374D9;
}
.myLinkStyle :hover{
	color:#FF0000;
}

.my-columnCenter0 {
	text-align : center;
	background : #CCFFFF;
	color : #000;
}
.my-columnCenter1 {
	text-align : center;
	background : #CCCCFF;
	color : #000;
}
.my-columnLeft0 {
	text-align : left;
	background : #CCFFFF;
	color : #000;
}
.my-columnLeft1 {
	text-align : left;
	background : #CCCCFF;
	color : #000;
}
.my-columnRight0 {
	text-align : right;
	background : #CCFFFF;
	color : #000;
}
.my-columnRight1 {
	text-align : right;
	background : #CCCCFF;
	color : #000;
}
</style>

<script type="text/javaScript">
var gToday	= new Date();
var gYear	= "";
var gMonth	= "";
var gDay	= "";

$(function() {
	var start	= new Date();
	var end		= new Date();
	start.setMonth(start.getMonth() - 3);
	end.setMonth(end.getMonth());
	
	if ( 10 == (start.getMonth()+1)|| 11 == (start.getMonth()+1) || 12 == (start.getMonth()+1) ) {
		if ( 1 == start.getDate() || 2 == start.getDate() || 3 == start.getDate() || 4 == start.getDate() || 5 == start.getDate()
			|| 6 == start.getDate() || 7 == start.getDate() || 8 == start.getDate() || 9 == start.getDate() ) {
			$("#startDate").val("0" + start.getDate() + "/" + (start.getMonth()+1) + "/" + start.getFullYear());
			console.log("1. start.getDate : " + start.getDate() + ", start.getMonth : " + start.getMonth()+1 + ", start.getFullYear : " + start.getFullYear());
		} else {
			$("#startDate").val(start.getDate() + "/" + (start.getMonth()+1) + "/" + start.getFullYear());
			console.log("2. start.getDate : " + start.getDate() + ", start.getMonth : " + start.getMonth()+1 + ", start.getFullYear : " + start.getFullYear());
		}
	} else {
		if ( 1 == start.getDate() || 2 == start.getDate() || 3 == start.getDate() || 4 == start.getDate() || 5 == start.getDate()
			|| 6 == start.getDate() || 7 == start.getDate() || 8 == start.getDate() || 9 == start.getDate() ) {
			$("#startDate").val("0" + start.getDate() + "/0" + (start.getMonth()+1) + "/" + start.getFullYear());
			console.log("3. start.getDate : " + start.getDate() + ", start.getMonth : " + start.getMonth()+1 + ", start.getFullYear : " + start.getFullYear());
		} else {
			$("#startDate").val(start.getDate() + "/0" + (start.getMonth()+1) + "/" + start.getFullYear());
			console.log("4. start.getDate : " + start.getDate() + ", start.getMonth : " + start.getMonth()+1 + ", start.getFullYear : " + start.getFullYear());
		}
	}
	if ( 10 == (end.getMonth()+1) || 11 == (end.getMonth()+1) || 12 == (end.getMonth()+1) ) {
		if ( 1 == start.getDate() || 2 == start.getDate() || 3 == start.getDate() || 4 == start.getDate() || 5 == start.getDate()
			|| 6 == start.getDate() || 7 == start.getDate() || 8 == start.getDate() || 9 == start.getDate() ) {
			$("#endDate").val("0" + end.getDate() + "/" + (end.getMonth()+1) + "/" + end.getFullYear());
			console.log("5. end.getDate : " + end.getDate() + ", end.getMonth : " + end.getMonth()+1 + ", end.getFullYear : " + end.getFullYear());
		} else {
			$("#endDate").val(end.getDate() + "/" + (end.getMonth()+1) + "/" + end.getFullYear());
			console.log("6. end.getDate : " + end.getDate() + ", end.getMonth : " + end.getMonth()+1 + ", end.getFullYear : " + end.getFullYear());
		}
	} else {
		if ( 1 == start.getDate() || 2 == start.getDate() || 3 == start.getDate() || 4 == start.getDate() || 5 == start.getDate()
			|| 6 == start.getDate() || 7 == start.getDate() || 8 == start.getDate() || 9 == start.getDate() ) {
			$("#endDate").val("0" + end.getDate() + "/0" + (end.getMonth()+1) + "/" + end.getFullYear());
			console.log("7. end.getDate : " + end.getDate() + ", end.getMonth : " + end.getMonth()+1 + ", end.getFullYear : " + end.getFullYear());
		} else {
			$("#endDate").val(end.getDate() + "/0" + (end.getMonth()+1) + "/" + end.getFullYear());
			console.log("8. end.getDate : " + end.getDate() + ", end.getMonth : " + end.getMonth()+1 + ", end.getFullYear : " + end.getFullYear());
		}
	}
	fnScmStockTypeCbBox();
	doGetComboAndGroup2("/scm/selectScmStockCodeForMulti.do", "", "", "scmStockCodeCbBox", "M", "");
	$(".js-example-basic-multiple").select2();
});

//	stock type
function fnScmStockTypeCbBox() {
	CommonCombo.make("scmStockTypeCbBox"
			, "/scm/selectScmStockType.do"	//	"/scm/selectComboSupplyCDC.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M",
				chooseMessage : "ALL"
			}
			, "");
}

//	search
function fnSearch() {
	var fromDate	= $("#startDate").val();
	var toDate		= $("#endDate").val();
	//console.log("fromDate : " + fromDate + ", toDate : " + toDate);
	
	if ( "" == fromDate || "" == toDate || null == fromDate || null == toDate ) {
		Common.alert("<spring:message code='sys.msg.limitMore' arguments='FROM DATE ; TO DATE.' htmlEscape='false' argumentSeparator=';'/>");
		return	false;
	}
	if ( 0 > fnGetDateGap(fromDate, toDate) ) {
		Common.alert("<spring:message code='sys.msg.limitMore' arguments='FROM DATE ; TO DATE.' htmlEscape='false' argumentSeparator=';'/>");
		return	false;
	}
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects"),
		scmStockCodeCbBox : $("#scmStockCodeCbBox").val()
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectOtdStatus.do"
			, params
			, function(result) {
				//console.log("Success fnSearch : " + result.length);
				console.log(result);
				
				AUIGrid.setGridData(myGridID, result.selectOtdStatus);
			});
}
//	get timestamp
function getTimeStamp() {
	function fnLeadingZeros(n, digits) {
		var zero	= "";
		n	= n.toString();
		
		if ( n.length < digits ) {
			for (var i = 0 ; i < digits - n.length ; i++ ) {
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

function fnGetDateGap(val1, val2) {
	var format	= "\/";
	console.log("val1 : " + val1 + ", val2 : " + val2);
	if ( 10 != val1.length || 10 != val2.length ) {
		return	null;
	}
	if ( 0 > val1.indexOf(format) || 0 > val2.indexOf(format) ) {
		return	null;
	}
	
	var fromDate	= val1.split(format);
	var toDate		= val2.split(format);
	
	//	Number()를 이용하여 10진수(08,09)로 인식하게 함.
	fromDate[1]	= (Number(fromDate[1]) - 1) + "";
	toDate[1]	= (Number(toDate[1]) - 1) + "";
	
	var finFromDate	= new Date(fromDate[2], fromDate[1], fromDate[0] );
	var finToDate	= new Date(toDate[2], toDate[1], toDate[0]);
	
	return	(finToDate.getTime() - finFromDate.getTime()) / 1000 / 60 / 60 / 24;
}

function fnOtdDetail(poNo) {
	if ( 1 > poNo.length ) {
		Common.alert("<spring:message code='sys.msg.first.Select' arguments='PO NO' htmlEscape='false'/>");
		return	false;
	}
	$("#poNoParam").val(poNo);
	//console.log("on No : " + $})
	//Common.alert($("poNo").val());
	//var params	= {	poNo : poNo	};console.log(params)
	var popUpObj	= Common.popupDiv("/scm/otdStatusReportPopView.do"
									//, params
									, $("#MainForm").serializeJSON()
									, null
									, false
									, "otdStatusReportPop");
	//window.open("otdStatusReportPop.jsp", "child", "width=570, height=350, resizable=no, scrollbars=no");
}

//	excel
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	GridCommon.exportTo("#OTDStatusDiv", "xlsx", fileName + "_" + getTimeStamp());
}

function fnExecute() {
	Common.ajax("GET"
			, "/scm/connection2.do"
			, ""
			, ""
			, "");
}

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var OtdStatusLayout	=
	[
		{
			//	PO
			headerText : "Purchase Order",
			children :
				[
					{
						 dataField : "divOdd",
						 headerText : "Div Odd",
						 visible : false,
						 cellMerge : true
					 }, {
						 dataField : "poDivOdd",
						 headerText : "PO Div Odd",
						 visible : false,
						 cellMerge : true
					 }, {
						dataField : "poDt",
						headerText : "Issue Date",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "poNo",
						headerText : "P/O No.",
						//style : "myLinkStyle",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "type",
						headerText : "Type",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "poItemNo",
						headerText : "Item No.",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "stockCode",
						headerText : "Material",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "name",
						headerText : "Desc.",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnLeft0";
							} else {
								return	"my-columnLeft1";
							}
						}
					}, {
						dataField : "poQty",
						headerText : "Qty",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}
				 ]
		}, {
			//	SO
			headerText : "Sales Order(HQ)",
			children :
				[
					{
						dataField : "soNo",
						headerText : "S/O No.",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "soItemNo",
						headerText : "Item No.",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "soQty",
						headerText : "Qty",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}, {
						dataField : "soDt",
						headerText : "S/O Date",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}
				 ]
		}, {
			headerText : "Production(HQ)",
			children :
				[
					{
						dataField : "ppPlanQty",
						headerText : "Plan Qty",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}, {
						dataField : "ppProdQty",
						headerText : "Prod Qty",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}, {
						dataField : "ppProdStartDt",
						headerText : "Start Date",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "ppProdEndDt",
						headerText : "End Date",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}
				 ]
		}, {
			//	GI
			headerText : "Good Issue(HQ)",
			children :
				[
					{
						dataField : "giQty",
						headerText : "G/I Qty",
						//cellMerge : true,
						//mergePolicy : "restrict",
						//mergeRef : "poDivOdd",
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}, {
						dataField : "giDt",
						headerText : "G/I Date",
						//cellMerge : true,
						//mergePolicy : "restrict",
						//mergeRef : "poDivOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}
				 ]
		}, {
			//	SAP
			headerText : "SAP",
			children :
				[
					{
						dataField : "sapPoNo",
						headerText : "P/O No.",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "divOdd",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "sapPoItemNo",
						headerText : "Item No.",
						cellMerge : true,
						mergePolicy : "restrict",
						mergeRef : "poDivOdd",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "sapPoQty",
						headerText : "P/O Qty",
						//cellMerge : true,
						///mergePolicy : "restrict",
						//mergeRef : "poDivOdd",
						visible : false,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "grDt",
						headerText : "G/R Date",
						//cellMerge : true,
						//mergePolicy : "restrict",
						//mergeRef : "poDivOdd",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}, {
						dataField : "sapApQty",
						headerText : "A/P Qty",
						//cellMerge : true,
						//mergePolicy : "restrict",
						//mergeRef : "poDivOdd",
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}, {
						dataField : "sapGrQty",
						headerText : "G/R Qty",
						//cellMerge : true,
						//mergePolicy : "restrict",
						//mergeRef : "poDivOdd",
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}
				 ]
		}
	 ];

/****************************  Form Ready ******************************************/
var myGridID;

$(document).ready(function() {
	var otdStatusLayoutOptions =
		{
			usePaging : false,
			editable : false,
			useGroupingPanel : false,
			showRowNumColumn : false,
			showStateColumn : false,
			enableRestore : true,
			enableCellMerge : true,
			softRemovePolicy : "exceptNew",
			fixedColumnCount : 9
		};
	myGridID	= GridCommon.createAUIGrid("OTDStatusDiv", OtdStatusLayout, "", otdStatusLayoutOptions);
	AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
		var poNo	= AUIGrid.getCellValue(myGridID, event.rowIndex, "poNo");
		//fnOtdDetail(poNo);
	});
});	//$(document).ready
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>
	
<aside class="title_line"><!-- title_line start -->
	<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
	<h2>OTD(Order To Delivery) Status Viewer</h2>
	<ul class="right_btns">
		<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
	<form id="MainForm" method="post" action="">
	<input type="hidden" id="poNoParam" name="poNoParam" />
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:130px" />
			<col style="width:*" />
			<col style="width:130px" />
			<col style="width:*" />
			<col style="width:130px" />
			<col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">PO Issue Date</th>
				<td>
					<div class="date_set w100p"><!-- date_set start -->
						<p>
						<input type="text" id="startDate" name="startDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
						<span>To</span>
						<p>
						<input type="text" id="endDate" name="endDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
					</div><!-- date_set end -->
				</td>
				<!-- Stock Type 추가 -->
				<th scope="row">Stock Type</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
				</td>
				<th scope="row">Material</th>
				<td>
					<!-- <input class="w100p" type="text" id="scmStockCode" name="scmStockCode" onkeypress="if(event.keyCode==13) {fnSalesPlanHeader(); return false;}">
					<select class="js-example-basic-multiple" id="select2t1m" name="select2t1m" multiple="multiple"> -->
					<select class="js-example-basic-multiple" id="scmStockCodeCbBox" name="scmStockCodeCbBox" multiple="multiple">
				</td>
			</tr>
			<tr>
				<th scope="row">PO No</th>
				<td>
					<input type="text" id="poNo" name="poNo" title="" placeholder="" class="w100p" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}" />
				</td>
				<th scope="row">SO No</th>
				<td>
					<input type="text" id="soNo" name="soNo" title="" placeholder="" class="w100p" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}"  />
				</td>
				<th scope="row">SAP PO No</th>
				<td>
					<input type="text" id="sapPoNo" name="sapPoNo" title="" placeholder="" class="w100p" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}"  />
				</td>
			</tr>
			<tr>
				<th scope="row">CI No</th>
				<td>
					<input type="text" id="ciNo" name="ciNo" title="" placeholder="" class="w100p" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}" />
				</td>
				<th scope="row">BL No</th>
				<td>
					<input type="text" id="blNo" name="blNo" title="" placeholder="" class="w100p" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}" />
				</td>
				<th scope="row">DN No</th>
				<td>
					<input type="text" id="delvNo" name="delvNo" title="" placeholder="" class="w100p" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}" />
				</td>
			</tr>
		</tbody>
	</table><!-- table end -->
	
	<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
		<p class="show_btn">
		<%-- <a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a> --%>
		</p>
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
	</aside><!-- link_btns_wrap end -->
	</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
	<div class="side_btns">
		<ul class="right_btns">
			<!-- <li><p id="btnExecute" class="btn_grid"><a onclick="fnExecute();">Execute</a></p></li> -->
			<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'Otd Report');">Excel</a></p></li>
		</ul>
	</div>

	<article class="grid_wrap"><!-- grid_wrap start -->
		<!-- 그리드 영역1 -->
		<div id="OTDStatusDiv" style="height:700px;"></div>
	</article><!-- grid_wrap end -->

	<ul class="center_btns">
		<li>
			<p class="btn_blue2 big">
			<!--    <a href="javascript:void(0);">Download Raw Data</a> <a onclick="fnExcelExport('OTD Status Viewer');">Download</a> -->
			</p>
		</li>
	</ul>
</section><!-- search_result end -->
</section><!-- content end -->