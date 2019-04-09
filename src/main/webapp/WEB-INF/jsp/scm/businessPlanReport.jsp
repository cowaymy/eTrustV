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
.my-columnCenter0 {
	text-align : center;
	background : #CCFFFF;
	color : #000;
}
.my-columnRight {
	text-align : right;
	margin-top : -20px;
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
				AUIGrid.setGridData(myGridID3, result.selectBusinessPlanDetail1);
				//AUIGrid.clearGridData(myGridID2);
				fnSwitch(false);
			});
}
function fnSaveAll(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	

}
function fnSave(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	//
	console.log($("#detail_wrap").is(":visible"));
	if ( false == $("#detail_wrap").is(":visible") ) {
		if ( false == fnValidation(false) )	return	false;
		Common.ajax("POST"
				, "/scm/saveBusinessPlan.do"
				, GridCommon.getEditData(myGridID3)
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
	} else {
		if ( false == fnValidation(true) )	return	false;
		Common.ajax("POST"
				, "/scm/saveBusinessPlanAll.do"
				, GridCommon.getGridData(myGridID2)
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
	return	false;
}
function fnUpload(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
}
function fnExcel(obj, fileName) {
	//	1. Grid Change for excel write
	fnSwitch(true);
	
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
function fnValidation(bool) {
	//	true : SaveAll
	if ( bool ) {
		var updList	= AUIGrid.getEditedRowItems(myGridID2);
		var addList	= AUIGrid.getAddedRowItems(myGridID2);
		console.log(updList.length + ", " + addList.length);
		if ( 0 == updList.length && 0 == addList.length ) {
			Common.alert("No Change added");
			return	false;
		}
	} else {
		var updList	= AUIGrid.getEditedRowItems(myGridID3);
		var updList1	= AUIGrid.getEditedRowItems(myGridID3);
		console.log(updList.length + ", " + updList1.length);
		if ( 0 == updList.length ) {
			Common.alert("No Change updated");
			return	false;
		}
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
function fnSwitch(bool) {
	//	true : excel download mode
	if ( bool ) {
		$("#detail_wrap").show();	AUIGrid.resize(myGridID2);
		$("#detail_wrap1").hide();
		//$("#btnSaveAll").removeClass("btn_disabled");
		//$("#btnSave").addClass("btn_disabled");
	} else {
		$("#detail_wrap").hide();
		$("#detail_wrap1").show();	AUIGrid.resize(myGridID3);
		//$("#btnSaveAll").addClass("btn_disabled");
		//$("#btnSave").removeClass("btn_disabled");
	}
}
/*
 * Grid create & setting
 */
var myGridID1, myGridID2, myGridID3, myGridID4;

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
	enableCellMerge : true,
	enableRestore : false,
	fixedColumnCount : 1
};
var summaryLayout	= 
	[
	 	{
	 		headerText : "Category",
	 		dataField : "categoryName",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "Category",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Total" != item.categoryName ) {
					return	"my-columnCenter";
				} else {
					return	"my-columnCenter1";
				}
			}
	 	}, {
	 		headerText : " ",
	 		dataField : "gbnName",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnCenter";
				} else {
					return	"my-columnCenter0";
				}
			}
	 	}, {
	 		headerText : "Jan",
	 		dataField : "m01",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Feb",
	 		dataField : "m02",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Mar",
	 		dataField : "m03",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Apr",
	 		dataField : "m04",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "May",
	 		dataField : "m05",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Jun",
	 		dataField : "m06",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Jul",
	 		dataField : "m07",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Aug",
	 		dataField : "m08",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Sep",
	 		dataField : "m09",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Oct",
	 		dataField : "m10",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Nov",
	 		dataField : "m11",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Dec",
	 		dataField : "m12",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Sum",
	 		dataField : "summ",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}
	 ];

//	myGridDetail
var detailOptions	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : true,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : true,
	editable : true,
	enableCellMerge : false,
	enableRestore : false,
	fixedColumnCount : 1
};
var detailLayout	=
	[
	 	{
	 		headerText : "Year",
	 		dataField : "year",
	 		style : "my-columnCenter"
	 	}, {
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
var detailOptions1	= {
		usePaging : false,
		useGroupingPanel : false,
		showRowNumColumn : true,
		showRowCheckColumn : false,
		showStateColumn : false,
		showEditedCellMarker : true,
		editable : true,
		enableCellMerge : true,
		enableRestore : false,
		fixedColumnCount : 4
	};
var detailLayout1	=
	[
	 	{
	 		headerText : "Year",
	 		dataField : "year",
	 		style : "my-columnCenter",
	 		visible : false
	 	}, {
	 		headerText : "Category",
	 		dataField : "categoryName",
	 		style : "my-columnCenter",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "Code",
			editable : false
	 	}, {
	 		headerText : "Code",
	 		dataField : "stockCode",
	 		style : "my-columnCenter",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "Code",
			editable : false
	 	}, {
	 		headerText : "Name",
	 		dataField : "stockName",
	 		style : "my-columnLeft",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "Code",
			editable : false
	 	}, {
	 		headerText : " ",
	 		dataField : "gbnName",
			editable : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnCenter";
				} else {
					return	"my-columnCenter0";
				}
			}
	 	}, {
	 		headerText : "Jan",
	 		dataField : "m01",
	 		dataType : "numeric",
	 		style : "my-columnRight",
	 		editable : true,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Feb",
	 		dataField : "m02",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Mar",
	 		dataField : "m03",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Apr",
	 		dataField : "m04",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "May",
	 		dataField : "m05",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Jun",
	 		dataField : "m06",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Jul",
	 		dataField : "m07",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Aug",
	 		dataField : "m08",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Sep",
	 		dataField : "m09",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Oct",
	 		dataField : "m10",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Nov",
	 		dataField : "m11",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Dec",
	 		dataField : "m12",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
	 	}, {
	 		headerText : "Sum",
	 		dataField : "summ",
	 		dataType : "numeric",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( "Business Plan" != item.gbnName ) {
					return	"my-columnRight";
				} else {
					return	"my-columnRight0";
				}
			}
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
	//	Detail Grid 1
	myGridID3	= GridCommon.createAUIGrid("#detail_wrap1", detailLayout1, "", detailOptions1);
	AUIGrid.bind(myGridID3, "cellEditBegin", function(event) {
		if ( "Business Plan" != event.item.gbnName ) {
			return	false;
		}
	});
	fnSwitch(false);
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
			<!-- Monthly Grid -->
			<div id="summary_wrap" style="height:210px;"></div>
		</article>								<!-- article grid_wrap end -->
		<table class="type1 mt10">				<!-- table start -->
			<caption>table10</caption>
			<colgroup>
				<col style="width:100px" />
				<col style="width:*" />
				<col style="width:244px" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><span id="detail">Detail</span></th><td><span id="detail"></span></td>
					<td>
						<ul class="right_btns">
							<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'Business Plan Upload');">Business Plan Set Up</a></p></li>
							<li><p id="btnSave" class="btn_grid"><a onclick="fnSave(this);">Save</a></p></li>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>								<!-- table end -->
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Weekly Grid -->
			<div id="detail_wrap" style="height:410px;"></div>
			<div id="detail_wrap1" style="height:410px;"></div>
		</article>								<!-- article grid_wrap end -->
	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->