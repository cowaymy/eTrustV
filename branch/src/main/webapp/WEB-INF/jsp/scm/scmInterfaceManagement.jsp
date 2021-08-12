<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.coway.trust.util.FtpConnection"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<jsp:useBean id="ftpConnection" class="com.coway.trust.util.FtpConnection" scope="page"></jsp:useBean>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
	text-align:right;
}
.aui-grid-left-column {
	text-align:right;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align:right;
	margin-top:-20px;
}
.my-backColumn0 {
	background:#73EAA8;
	color:#000;
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
	fnScmIfTypeCbBox();
	fnScmIfTranStatusCbBox();
	//fnScmIfErrCodeCbBox();
});

function fnScmIfTypeCbBox() {
	CommonCombo.make("scmIfTypeCbBox"
			, "/scm/selectScmIfType.do"
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
function fnScmIfTranStatusCbBox() {
	CommonCombo.make("scmIfStatusCbBox"
			, "/scm/selectScmIfStatus.do"
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
function fnScmIfErrCodeCbBox() {
	CommonCombo.make("scmIfErrCodeCbBox"
			, "/scm/selectScmIfErrCode.do"
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
			scmIfTypeCbBox : $("#scmIfTypeCbBox").multipleSelect("getSelects"),
			scmIfStatusCbBox : $("#scmIfStatusCbBox").multipleSelect("getSelects")//,
			//scmIfErrCodeCbBox : $("#scmIfErrCodeCbBox").multipleSelect("getSelects")
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectInterfaceList.do"
			, params
			, function(result) {
				console.log(result);
				
				AUIGrid.setGridData(myGridID, result.selectInterfaceList);
			});
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

function fnDoInterface(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	
	var data	= {};
	var chkList	= AUIGrid.getCheckedRowItemsAll(myGridID);
	
	if ( 0 > chkList ) {
		Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
		return	false;
	}
	data.checked	= chkList;
	
	Common.ajax("GET"
			, "/scm/doInterface.do"
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
function fnTest() {
	var params	= { scmYearCbBox : $("#year").val(), scmWeekCbBox : $("#week").val() };
	console.log(params);
	Common.ajax("POST"
			, "/scm/scmtest.do"
			, params
			, ""
			, "");
}
function fnExecuteSo() {
	var params	= $.extend($("#MainForm").serializeJSON(), params);
	//console.log(params);
	Common.ajax("POST"
			, "/scm/executeOtdSo.do"
			//, "/scm/executeSupplyPlanRtp.do"
			, params
			, function(result) {
				fnExecutePp();
			} 
			, "");
}
function fnExecutePp() {
	var params	= $.extend($("#MainForm").serializeJSON(), params);
	//console.log(params);
	Common.ajax("POST"
			, "/scm/executeOtdPp.do"
			, params
			, function(result) {
				fnExecuteGi();
			}
			, "");
}
function fnExecuteGi() {
	var params	= $.extend($("#MainForm").serializeJSON(), params);
	//console.log(params);
	Common.ajax("POST"
			, "/scm/executeOtdGi.do"
			, params
			, function(result) {
				fnSearch();
			}
			, "");
}

function fnExecute() {
	var params	= $.extend($("#MainForm").serializeJSON(), params);
	//console.log(params);
	Common.ajax("POST"
			, "/scm/executeSupplyPlanRtp.do"
			, params
			, function(result) {
				fnSearch();
			}
			, "");
}

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var interfaceLayout	=
	[
		{
			dataField : "ifDate",
			headerText : "IF Date",
			width : "5%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ifTime",
			headerText : "IF Time",
			width : "5%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ifSeq",
			headerText : "SEQ",
			width : "5%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ifType",
			headerText : "IF Type",
			//width : "25%",
			visible : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ifTypeName",
			headerText : "IF Type",
			width : "25%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnLeft2";
				} else {
					return	"my-columnLeft";
				}
			}
		}, {
			dataField : "ifStatusName",
			headerText : "IF Status",
			width : "10%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ifCycleName",
			headerText : "IF Cycle",
			width : "10%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "execCnt",
			headerText : "Result Count",
			width : "10%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "errMsg",
			headerText : "Error",
			width : "30%",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.ifStatus ) {
					return	"my-columnLeft2";
				} else {
					return	"my-columnLeft";
				}
			}
		}
	 ];
/****************************  Form Ready ******************************************/

var myGridID

$(document).ready(function() {
	var interfaceLayoutOption = {
			usePaging : false,
			useGroupingPanel : false,
			showRowNumColumn : false,
			showStateColumn : false,
			showRowCheckColumn : true,
			editable : false,
			enableRestore : true,
			softRemovePolicy : "exceptNew",
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if ( 20 == item.ifStatus ) {
					return	true;
				}
				return	false;
			}
	};
	
	myGridID	= GridCommon.createAUIGrid("InterfaceGridDiv", interfaceLayout, "", interfaceLayoutOption);
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
<h2>Interface</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="">
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:110px" />
			<col style="width:*" />
			<col style="width:110px" />
			<col style="width:*" />
			<col style="width:110px" />
			<col style="width:*" />
<!-- 			<col style="width:110px" />
			<col style="width:*" /> -->
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">IF Date</th>
				<td>
					<div class="date_set w100p"><!-- date_set start -->
						<p>
						<input type="text" id="startDate" name="startDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
						<span>To</span>
						<p>
						<input type="text" id="endDate" name="endDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
					</div><!-- date_set end -->
				</td>
				<th scope="row">IF Type</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmIfTypeCbBox" name="scmIfTypeCbBox"></select>
				</td>
				<th scope="row">IF Status</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmIfStatusCbBox" name="scmIfStatusCbBox"></select>
				</td>
			</tr>
			<tr>
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
		<li><p id="btnTest" class="btn_grid"><a onclick="fnTest();">Test</a></p></li>
		<li><p id="btnInterface" class="btn_grid"><a onclick="fnDoInterface();">Do Interface</a></p></li>
		<li><p id="btnExecuteAll" class="btn_grid"><a onclick="fnExecuteSo();">Execute OTD</a></p></li>
		<li><p id="btnExecute" class="btn_grid"><a onclick="fnExecute();">Execute RTP</a></p></li>
	</ul>

	<article class="grid_wrap"><!-- grid_wrap start -->
		<!-- 그리드 영역1 -->
		<div id="InterfaceGridDiv" style="height:700px;"></div>
	</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->