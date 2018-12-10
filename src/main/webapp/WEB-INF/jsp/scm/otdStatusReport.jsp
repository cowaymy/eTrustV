<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
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
$(function() {
	fnScmStockTypeCbBox();
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
	console.log("fromDate : " + fromDate + ", toDate : " + toDate);
	
	if ( "" == fromDate || "" == toDate || null == fromDate || null == toDate ) {
		Common.alert("<spring:message code='sys.msg.limitMore' arguments='FROM DATE ; TO DATE.' htmlEscape='false' argumentSeparator=';'/>");
		return	false;
	}
	if ( 0 > fnGetDateGap(fromDate, toDate) ) {
		Common.alert("<spring:message code='sys.msg.limitMore' arguments='FROM DATE ; TO DATE.' htmlEscape='false' argumentSeparator=';'/>");
		return	false;
	}
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects")
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

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var OtdStatusLayout	=
	[
		{
			//	PO
			headerText : "PO",
			children :
				[
					{
						 dataField : "divOdd",
						 headerText : "Div Odd",
						 visible : false,
						 cellMerge : true
					 }, {
						dataField : "poNo",
						headerText : "<spring:message code='sys.scm.pomngment.rowNo'/>",
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
						dataField : "poDt",
						headerText : "<spring:message code='sys.scm.otdview.IssueDate'/>",
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
						dataField : "stockCode",
						headerText : "Code",
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
						headerText : "Name",
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
						headerText : "PO Qty",
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
						dataField : "poItemStusId",
						headerText : "Po Status Id",
						visible : false
					}, {
						dataField : "poItemStusName",
						headerText : "Status",
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
			//	SO
			headerText : "SO",
			children :
				[
					{
						dataField : "soQty",
						headerText : "SO Qty",
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
						headerText : "SO Date",
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
			headerText : "PP",
			children :
				[
					{
						dataField : "ppPlanQty",
						headerText : "Plan Qty",
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
						headerText : "Prod Start",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnCenter0";
							} else {
								return	"my-columnCenter1";
							}
						}
					}, {
						dataField : "ppProdEndDt",
						headerText : "Prod End",
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
			headerText : "GI",
			children :
				[
					{
						dataField : "giQty",
						headerText : "GI Qty",
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
						headerText : "GI Date",
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
						headerText : "PO No",
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
						headerText : "Item No",
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
						headerText : "PO Qty",
						visible : false,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "grDt",
						headerText : "GR Date",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( "0" == item.divOdd ) {
								return	"my-columnRight0";
							} else {
								return	"my-columnRight1";
							}
						}
					}, {
						dataField : "sapApQty",
						headerText : "AP Qty",
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
						headerText : "GR Qty",
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
	<h2>OTD Status Viewer</h2>
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
				<th scope="row">PO Status</th>
				<td>
					<select id="poStusId" name="poStusId" class="w100p">
						<option value="" selected>All</option>
						<option value="1">Active</option>	<!-- active -->
						<option value="5">Approved</option>	<!-- approved -->
					</select>
				</td>
				<th scope="row">PO NO</th>
				<td>
					<input type="text" id="poNo" name="poNo" title="" placeholder="" class="w100p" />
				</td>
			</tr>
			<tr>
				<!-- Stock Type 추가 -->
				<th scope="row">Stock Type</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
				</td>
				<td colspan="4"></td>
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