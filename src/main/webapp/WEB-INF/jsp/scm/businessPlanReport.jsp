<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">
/* Custom Business Plan Report Style */
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
var planYearMonth	= "";
var planYear	= 0;
var planMonth	= 0;
var planWeek	= 0;

$(function(){
	fnScmTotalPeriod();
});

/*
 * Button Functions
 */
function fnSearch() {
	Common.ajax("GET"
			, "/scm/selectBusinessPlanReport.do"
			, $("#MainForm").serialize()
			, function(result) {
				//console.log(result);
				AUIGrid.setGridData(myGridID1, result.selectBusinessPlanSummary);
				AUIGrid.setGridData(myGridID2, result.selectBusinessPlanDetail);
			});
}
function fnSave(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	if ( false == fnValidation() )								return	false;
	
	Common.ajax("POST"
			, "/scm/savePo.do"
			, GridCommon.getEditData(myGridID2)
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
function fnSaveNew(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	if ( false == fnValidation() )								return	false;
	
	Common.ajax("POST"
			, "/scm/savePo.do"
			, GridCommon.getEditData(myGridID2)
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
function fnUpload(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
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
 				
 				planYear	= result.selectScmTotalPeriod[0].scmYear;
 				planMonth	= result.selectScmTotalPeriod[0].scmMonth;
 				planWeek	= result.selectScmTotalPeriod[0].scmWeek;
 				fnPlanYear();
 			});
 }
//	year
function fnPlanYear() {
	//	callback
	var fnPlanVerCallback	= function() {
		$("#planYear").on("change", function() {
			var $this	= $(this);
			
			CommonCombo.initById("planVer");
			
			if ( FormUtil.isNotEmpty($this.val()) ) {
				CommonCombo.make("planVer"
						, "/scm/selectPlanVer.do"
						, { planYear : $this.val() }
						, ""
						, {
							id : "id",
							name : "name",
							chooseMessage : "Select a Year"
						}
						, "");
			} else {
				fnPlanVer();
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
	CommonCombo.make("planYear"
			, "/scm/selectScmYear.do"
			, ""
			, planYear.toString()
			, {
				id : "id",
				name : "name",
				chooseMessage : "Year"
			}
			, fnPlanVerCallback);
}
function fnValidation() {
	var addList	= AUIGrid.getAddedRowItems(myGridID2);
	
	if ( 0 == addList.length ) {
		Common.alert("No Change");
		return	false;
	}
	
	return	true;
}


/*
 * Util Functions
 */
function resetUpdatedItems() {
	AUIGrid.resetUpdatedItems(myGridID2, "a");
}
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
 * Grid create & setting
 */
var myGridID1, myGridID2;

//	myGridTotal
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
var summaryFooterLayout	=
	[
		{
			labelText : "Sum",
			positionField : "Category"
		}, {
			dataField : "m01",
			positionField : "jan",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m02",
			positionField : "feb",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m03",
			positionField : "mar",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m04",
			positionField : "apr",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m05",
			positionField : "may",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m06",
			positionField : "jun",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m07",
			positionField : "jul",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m08",
			positionField : "aug",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m09",
			positionField : "sep",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m10",
			positionField : "oct",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m11",
			positionField : "nov",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m12",
			positionField : "dec",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "summ",
			positionField : "sum",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}
	 ];
var summaryLayout	= 
	[
	 	{
	 		headerText : "Category",
	 		dataField : "categoryName",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "Jan",
	 		dataField : "m01",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Feb",
	 		dataField : "m02",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Mar",
	 		dataField : "m03",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Apr",
	 		dataField : "m04",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "May",
	 		dataField : "m05",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Jun",
	 		dataField : "m06",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Jul",
	 		dataField : "m07",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Aug",
	 		dataField : "m08",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Sep",
	 		dataField : "m09",
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
	 	}, {
	 		headerText : "Sum",
	 		dataField : "summ",
	 		dataType : "numeric",
	 		style : "my-columnRight"
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
	fixedColumnCount : 3
};
/*
var detailFooterLayout	=
	[
		{
			labelText : "Sum",
			positionField : "categoryName"
		}, {
			dataField : "m01",
			positionField : "jan",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m02",
			positionField : "feb",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m03",
			positionField : "mar",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m04",
			positionField : "apr",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m05",
			positionField : "may",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m06",
			positionField : "jun",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m07",
			positionField : "jul",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m08",
			positionField : "aug",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m09",
			positionField : "sep",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m10",
			positionField : "oct",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m11",
			positionField : "nov",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "m12",
			positionField : "dec",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}, {
			dataField : "summ",
			positionField : "sum",
			operation : "SUM",
			dataType : "numeric",
			style : "my-columnRight"
		}
	 ];
	 */
var detailLayout	=
	[
	 	{
	 		headerText : "Category",
	 		dataField : "categoryName",
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
	 		headerText : "Jan",
	 		dataField : "m01",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Feb",
	 		dataField : "m02",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Mar",
	 		dataField : "m03",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Apr",
	 		dataField : "m04",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "May",
	 		dataField : "m05",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Jun",
	 		dataField : "m06",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Jul",
	 		dataField : "m07",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Aug",
	 		dataField : "m08",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "Sep",
	 		dataField : "m09",
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
	 	}, {
	 		headerText : "Sum",
	 		dataField : "summ",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}
	 ];

$(document).ready(function() {
	//	Summary Grid
	myGridID1	= GridCommon.createAUIGrid("#summary_wrap", summaryLayout, "", summaryOptions);
	//AUIGrid.setFooter(myGridID1, summaryFooterLayout);
	AUIGrid.bind(myGridID1, "cellClick", function(event) {
		
	});
	AUIGrid.bind(myGridID1, "cellDoubleClick", function(event) {
		
	});
	
	//	Detail Grid
	myGridID2	= GridCommon.createAUIGrid("#detail_wrap", detailLayout, "", detailOptions);
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
		<h2>Business Plan Report</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
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
							<div class="date_set w100p">
								<select class="sel_year" id="planYear" name="planYear"></select>
							</div>
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
	
	<section class="search_result">				<!-- section search_result start -->
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Monthly Grid -->
			<div id="summary_wrap" style="height:210px;"></div>
		</article>								<!-- article grid_wrap end -->
		<ul class="right_btns">
			<!-- <li><p id="btnSave" class="btn_grid btn_disabled"><a onclick="fnSave(this);">Save</a></p></li>
			<li><p id="btnSaveNew" class="btn_grid btn_disabled"><a onclick="fnSaveNew(this);">Save as New</a></p></li> -->
			<li><p id="btnUpload" class="btn_grid"><a onclick="fnUpload(this);">Upload</a></p></li>
			<li><p id="btnDownload" class="btn_grid"><a onclick="">Download CVS Format</a></p></li>
			<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'Business Plan Report');">Excel</a></p></li>
		</ul>
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Weekly Grid -->
			<div id="detail_wrap" style="height:447px;"></div>
		</article>								<!-- article grid_wrap end -->
	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->