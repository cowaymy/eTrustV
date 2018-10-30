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
	CommonCombo.make("scmIfTranStatusCbBox"
			, "/scm/selectScmIfTranStatus.do"
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
	var params	= {
			scmIfTypeCbBox : $("#scmIfTypeCbBox").multipleSelect("getSelects"),
			scmIfTranStatusCbBox : $("#scmIfTranStatusCbBox").multipleSelect("getSelects")//,
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

function fnDoInterface(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	
	var data	= {};
	var chkList	= AUIGrid.getCheckedRowItemsAll(myGridID);
	
	if ( 0 > chkList ) {
		Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
		return	false;
	}
	data.checked	= chkList;
	
	Common.ajax("POST"
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

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var interfaceLayout	=
	[
		{
			dataField : "ifType",
			headerText : "IF Type",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ifTypeName",
			headerText : "IF Type",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "tranStatusCd",
			headerText : "Tran Status Cd",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "tranStatusName",
			headerText : "Tran Status",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "errCd",
			headerText : "Err Cd",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "errName",
			headerText : "Error",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "errMsg",
			headerText : "Err Message",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "tranDt",
			headerText : "Tran Date",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "tranTm",
			headerText : "Tran Time",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "rgstDt",
			headerText : "Regist Date",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "rgstTm",
			headerText : "Regist Time",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 20 == item.tranStatusCd ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}
	 ];
/****************************  Form Ready ******************************************/

var myGridID

$(document).ready(function() {
	var interfaceLayoutOption = {
			usePaging : true,
			useGroupingPanel : false,
			showRowNumColumn : false,
			showStateColumn : false,
			showRowCheckColumn : true,
			enableRestore : true,
			softRemovePolicy : "exceptNew",
			rowCheckableFunction : function(rowIndex, isChecked, item) {
				if ( false == isChecked ) {
					//fnBtnCtrl(false);
					//$("#btnInterface").removeClass("btn_disabled");
				} else {
					//fnBtnCtrl(true);
					//$("#btnInterface").addClass("btn_disabled");
				}
			},
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if ( 20 == item.tranStatusCd ) {
					return	false;
				}
				return	true;
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
<form id="MainForm" method="post" action="">
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
					<input type="text" id="tranDtFrom" name="tranDtFrom" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
					<span>To</span>
					<p>
					<input type="text" id="tranDtTo" name="tranDtTo" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
					</div><!-- date_set end -->
				</td>
				<th scope="row">IF Type</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmIfTypeCbBox" name="scmIfTypeCbBox"></select>
				</td>
				<th scope="row">Trans Status</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmIfTranStatusCbBox" name="scmIfTranStatusCbBox"></select>
				</td>
<!-- 				<th scope="row">Error Code</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmIfErrCodeCbBox" name="scmIfErrCodeCbBox"></select>
				</td> -->
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
		<li><p id="btnInterface" class="btn_grid"><a onclick="fnDoInterface();">Do Interface</a></p></li>
	</ul>

	<article class="grid_wrap"><!-- grid_wrap start -->
		<!-- 그리드 영역1 -->
		<div id="InterfaceGridDiv" style="height:700px;"></div>
	</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->