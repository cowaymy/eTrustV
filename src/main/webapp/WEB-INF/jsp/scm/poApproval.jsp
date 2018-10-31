<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
	text-align:right;
}

/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
	color:#d3825c;
}
.my-columnRight {
	text-align : right;
}
.my-columnCenter {
	text-align : center;
}
.my-columnLeft {
	text-align : left;
}
.my-columnRight2 {
	text-align : right;
	background : #FFCCFF;
	color : #d3825c;
}
.my-columnCenter2 {
	text-align : center;
	background : #FFCCFF;
	color : #d3825c;
}
.my-columnLeft2 {
	text-align : left;
	background : #FFCCFF;
	color : #d3825c;
}
</style>

<script type="text/javaScript">
$(function() {
	fnScmYearCbBox();
	fnScmWeekCbBox();
	fnScmStockTypeCbBox();
});
//	year
function fnScmYearCbBox() {
	//	callback
	var fnScmWeekCbBoxCallback	= function() {
		$("#scmYearCbBox").on("change", function() {
			var $this	= $(this);

			CommonCombo.initById("scmWeekCbBox");

			if ( FormUtil.isNotEmpty($this.val()) ) {
				CommonCombo.make("scmWeekCbBox"
						, "/scm/selectScmWeek.do"
						, { scmYear : $this.val() }
						, ""
						, {
							id : "id",
							name : "name",
							chooseMessage : "Select a Year"
						}
						, "");
			} else {
				fnScmWeekCbBox();
			}
		});
	};
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
	CommonCombo.make("scmYearCbBox"
			, "/scm/selectScmYear.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				chooseMessage : "Year"
			}
			, fnScmWeekCbBoxCallback);
}

//	default week
function fnScmWeekCbBox() {
	CommonCombo.initById("scmWeekCbBox");	//	reset
	var weekChkBox	= document.getElementById("scmWeekCbBox");
	weekChkBox.options[0]	= new Option("Select a Week", "");
}

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

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var poSummaryGridLayout =
	[
		{
			dataField : "ctgry",
			headerText : "Category",
		}, {
			headerText : "KL",
			children :
			[
				{
					dataField : "qty2010",
					headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}, {
					dataField : "amt2010",
					headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}
			 ]
		}, {
			headerText : "PN",
			children :
			[
				{
					dataField : "qty2020",
					headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}, {
					dataField : "amt2020",
					headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}
			 ]
		}, {
			headerText : "JB",
			children :
			[
				{
					dataField : "qty2030",
					headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}, {
					dataField : "amt2030",
					headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}
			 ]
		}, {
			headerText : "KK",
			children :
			[
				{
					dataField : "qty2040",
					headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}, {
					dataField : "amt2040",
					headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}
			 ]
		}, {
			headerText : "KC",
			children :
			[
				{
					dataField : "qty2050",
					headerText : "<spring:message code='sys.scm.poApproval.sumOfQty'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}, {
					dataField : "amt2050",
					headerText : "<spring:message code='sys.scm.poApproval.fobAmt'/>",
					style : "aui-grid-right-column",
					dataType : "numeric",
					formatString : "#,##0"
				}
			 ]
		}, {
			dataField : "totQty",
			headerText : "<spring:message code='sys.scm.poApproval.totSumOfQty'/>",
			style : "aui-grid-right-column",
			dataType : "numeric",
			formatString : "#,##0"
		}, {
			dataField : "totAmt",
			headerText : "<spring:message code='sys.scm.poApproval.totSumOfQty'/>",
			style : "aui-grid-right-column",
			dataType : "numeric",
			formatString : "#,##0"
		}
	 ];
var poApprTargetGridLayout =
	[
		{
			dataField : "poStusId",
			headerText : "Po Stus Id",
			editable : false,
			visible : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					//return	"disable-check-style";
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poStusName",
			headerText : "Po Status",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poNo",
			headerText : "Po No",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poItemNo",
			headerText : "Po Item No",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ctgry",
			headerText : "Category",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "type",
			headerText : "Type",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "stockCode",
			headerText : "Code",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "name",
			headerText : "Name",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnLeft2";
				} else {
					return	"my-columnLeft";
				}
			}
		}, {
			dataField : "poIssQty",
			headerText : "Po Issue Qty",
			editable : false,
			dataType : "numeric",
			formatString : "#,##0",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnRight2";
				} else {
					return	"my-columnRight";
				}
			}
		}, {
			dataField : "grYear",
			headerText : "Gr Year",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "grMonth",
			headerText : "Gr Month",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	null;
				}
			}
		}, {
			dataField : "grWeek",
			headerText : "Gr Week",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ifDt",
			headerText : "IF Date",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}
	 ];

//footer
var poSummaryGridFooterLayout	=
	[
		{
			labelText : "Grand Total",
			positionField : "ctgry"
		}, {
			dataField : "qty2010",
			positionField : "qty2010",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "amt2010",
			positionField : "amt2010",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "qty2020",
			positionField : "qty2020",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "amt2020",
			positionField : "amt2020",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "qty2030",
			positionField : "qty2030",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "amt2030",
			positionField : "amt2030",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "qty2040",
			positionField : "qty2040",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "amt2040",
			positionField : "amt2040",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "qty2050",
			positionField : "qty2050",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "amt2050",
			positionField : "amt2050",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "totQty",
			positionField : "totQty",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}, {
			dataField : "totAmt",
			positionField : "totAmt",
			operation : "SUM",
			style : "aui-grid-right-column",
			formatString : "#,##0"
		}
	 ];

function fnSummaryGridCreate() {
	if ( AUIGrid.isCreated(myGridID) ) {
		AUIGrid.destroy(myGridID);
	}
	
	var poSummaryGridLayoutOptions	= {
		showFooter : true,
		usePaging : false,
		showRowNumColumn : false,
		showStateColumn : true,
		softRemovePolicy : "exceptNew",
		usePaging : false,
		useGroupingPanel : false,
		editable : false,
		headerHeight : 35
	};
	
	myGridID	= GridCommon.createAUIGrid("SummaryGrid_DIV", poSummaryGridLayout,"", poSummaryGridLayoutOptions);
	AUIGrid.setFooter(myGridID, poSummaryGridFooterLayout);
}

function fnMainGridCreate() {
	if ( AUIGrid.isCreated(myGridID2) ) {
		AUIGrid.destroy(myGridID2);
	}
	
	var poApprTargetGridLayoutOptions	= {
		usePaging : false,
		useGroupingPanel : false,
		showRowNumColumn : false,
		showStateColumn : true,
		enableRestore : true,
		showRowCheckColumn : true,
		independentAllCheckBox : true,
		rowCheckableFunction : function(rowIndex, isChecked, item) {
			if ( false == isChecked ) {
				addCheckedRowsByValue(AUIGrid.getCellValue(myGridID2, rowIndex, "poNo"));
			} else {
				addUncheckedRowsByValue(AUIGrid.getCellValue(myGridID2, rowIndex, "poNo"));
			}
		},
		rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
			if ( 5 == item.poStusId ) {
				return	false;
			}
			return	true;
		}
	};
	
	myGridID2	= GridCommon.createAUIGrid("MainGrid_DIV", poApprTargetGridLayout,"", poApprTargetGridLayoutOptions);
	AUIGrid.bind(myGridID2, "rowAllChkClick", function(event) {
		if ( event.checked ) {
			AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag", 1);
		} else {
			AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag", 0);
		}
	});
}

//	Button function
//	search
function fnSearch() {
	if ( 1 > $("#scmYearCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Year' htmlEscape='false'/>");
		return	false;
	}
	if ( 1 > $("#scmWeekCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Week' htmlEscape='false'/>");
		return	false;
	}
	
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects")	
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectPoSummary.do"
			, params
			, function(result) {
				console.log(result);
				
				AUIGrid.setGridData(myGridID, result.selectPoSummary);
				AUIGrid.setGridData(myGridID2, result.selectPoApprList);
			});
}
function fnApprove(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	
	var data	= {};
	var chkList	= AUIGrid.getCheckedRowItemsAll(myGridID2);
	
	if ( 0 > chkList ) {
		Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
		return	false;
	}
	data.checked	= chkList;
	
	Common.ajax("POST"
			, "/scm/approvePo.do"
			, data
			, function(result) {
				Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
				fnSearch();
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


//	excel
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	GridCommon.exportTo("#MainGrid_DIV", "xlsx", fileName + "_" + getTimeStamp());
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

function addCheckedRowsByValue(val) {
	AUIGrid.addCheckedRowsByValue(myGridID2, "poNo", val);
}

function addUncheckedRowsByValue(val) {
	AUIGrid.addUncheckedRowsByValue(myGridID2, "poNo", val);
}


/****************************  Form Ready ******************************************/
var myGridID;
var myGridID2;
 
$(document).ready(function() {
	fnSummaryGridCreate();
	fnMainGridCreate();
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
	<h2>PO Approval</h2>
	<ul class="right_btns">
		<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->
	
<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:140px" />
			<col style="width:*" />
			<col style="width:100px" />
			<col style="width:*" />
			<col style="width:100px" />
			<col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">EST Year &amp; Week</th>
				<td>
					<div class="date_set w100p"><!-- date_set start -->
						<select class="sel_year" id="scmYearCbBox" name="scmYearCbBox"></select>
						<select class="sel_date" id="scmWeekCbBox" name="scmWeekCbBox"></select>
					</div><!-- date_set end -->
				</td>
				<!-- Stock Type 추가 -->
				<th scope="row">Stock Type</th>
				<td colspan="3">
					<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
				</td>
			</tr>
		</tbody>
	</table><!-- table end -->
	
	<article class="grid_wrap mt10"><!-- grid_wrap start -->
		<!-- 그리드 영역 1-->
		<div id="SummaryGrid_DIV" style="height:300px;"></div>
	</article><!-- grid_wrap end -->
	<ul class="right_btns">
		<li><p class="btn_grid"><a onclick="fnExcel(this, 'PO Approval');">EXCEL</a></p></li>
	</ul>
	
	<article class="grid_wrap"><!-- grid_wrap start -->
		<!-- 그리드 영역 2-->
		<div id="MainGrid_DIV" style="height:400px;"></div>
	</article><!-- grid_wrap end -->
	
	<ul class="center_btns">
		<li><p class="btn_blue"><a onclick="fnApprove(this);">Approve</a></p></li>
	</ul>
	
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
</section><!-- content end -->