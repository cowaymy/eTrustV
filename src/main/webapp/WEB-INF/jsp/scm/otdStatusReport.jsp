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

//	excel
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", fileName + "_" + getTimeStamp());
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
	$("poNo").val(poNo);
	
	var popUpObj	= Common.popupDiv("/scm/selectOTDStatusDetail.do"
									, $("#MainForm").serializeJSON()
									, null
									, false
									, "otdStatusDetailPop");
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
						dataField : "poNo",
						headerText : "<spring:message code='sys.scm.pomngment.rowNo'/>",
						style : "myLinkStyle",
						cellMerge : true
					}, {
						dataField : "poDt",
						headerText : "<spring:message code='sys.scm.otdview.IssueDate'/>",
						cellMerge : true
					}, {
						dataField : "type",
						headerText : "Type",
						cellMerge : true
					}, {
						dataField : "stockCode",
						headerText : "Code",
						cellMerge : true
					}, {
						dataField : "name",
						headerText : "Name",
						cellMerge : true
					}, {
						dataField : "grDt",
						headerText : "GR Date",
						cellMerge : true
					}, {
						dataField : "poQty",
						headerText : "PO Qty",
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "poItemStusId",
						headerText : "Po Status Id",
						cellMerge : true
					}, {
						dataField : "poItemStusName",
						headerText : "Status",
						cellMerge : true,
						rederer : {
							type : "TemplateRenderer"
						},
						labelFunction : function (rowIndex, columnIndex, value, headerText, item) {
							if ( "5" == item.poItemStusId ) {
								var template	= "<div class='closeDiv'>";
								template	+= "<span id='closeDiv'>";	//	"<span id='closeSpan'>";
								template	+= "●";
								template	+= "</span>";
								return	template;
							} else if ( "1" == item.poItemStusId ) {
								var template	= "<div class='openDiv'>";
								template	+= "<span id='openDiv'>";
								template	+= "●";
								template	+= "</span>";
								return	template;
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
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "soDt",
						headerText : "SO Date",
						cellMerge : true
					}
				 ]
		}, {
			headerText : "PP",
			children :
				[
					{
						dataField : "ppPlanQty",
						headerText : "Plan Qty",
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "ppProdQty",
						headerText : "Prod Qty",
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "ppProdStartDt",
						headerText : "Prod Start",
						cellMerge : true
					}, {
						dataField : "ppProdEndDt",
						headerText : "Prod End",
						cellMerge : true
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
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "giDt",
						headerText : "GI Date",
						cellMerge : true
					}
				 ]
		}, {
			//	SAP
			headerText : "SAP",
			children :
				[
					{
						dataField : "sapPoNo",
						headerText : "Po No",
						cellMerge : true,
						formatString : "#,##0"
					}, {
						dataField : "sapPoItemNo",
						headerText : "Item No",
						cellMerge : true,
						formatString : "#,##0"
					}, {
						dataField : "sapPoQty",
						headerText : "Po Qty",
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "sapApQty",
						headerText : "Ap Qty",
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
					}, {
						dataField : "sapGrQty",
						headerText : "Gr Qty",
						cellMerge : true,
						dataType : "numeric",
						style : "aui-grid-right-column",
						formatString : "#,##0"
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
			softRemovePolicy : "exceptNew",
			fixedColumnCount : 7
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
	<input type="hidden" id="poNo" name="poNo" />
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
	<ul class="right_btns">
		<!-- <li><input id="inputTxtPoNo" name="inputTxtPoNo" type="text" title="" placeholder="Enter PO Number" disabled /><li>
		<li class="ml10"><p class="btn_blue3 btn_disabled"><a href="javascript:void(0);">Update OTD Status</a></p></li> -->
	</ul>

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