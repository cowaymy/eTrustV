<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<link href="${pageContext.request.contextPath}/resources/css/select2.min.css" rel="stylesheet">
<script src ="${pageContext.request.contextPath}/resources/js/select2.min.js" type="text/javascript"></script>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
	text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align:right;
	margin-top:-20px;
}
.my-columnCenter {
	text-align:center;
	margin-top:-20px;
}
.my-backColumn1 {
	text-align:right;
	background:#CCE5FF;
	color:#000;
}
.my-backColumn2 {
	text-align:right;
	background:#cccccc;
	color:#000;
}
.my-backColumn3 {
	text-align : right;
	background : #cccccc;
	color : #000;
}
.my-backColumn4 {
	text-align : center;
	background : #cccccc;
	color : #000;
}
.my-editable {
	background:#A9BCF5;
	color:#000;
}
.Atag-Disabled {
	pointer-events: none;
	cursor: default;
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
.my-columnCenter2 {
	text-align : center;
	background : #FFFFCC;
	color : #000;
}
.my-columnCenter3 {
	text-align : center;
	background : #FFCCCC;
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
.my-columnLeft2 {
	text-align : left;
	background : #FFFFCC;
	color : #000;
}
.my-columnLeft3 {
	text-align : left;
	background : #FFCCCC;
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
.my-columnRight2 {
	text-align : right;
	background : #FFFFCC;
	color : #000;
}
.my-columnRight3 {
	text-align : right;
	background : #FFCCCC;
	color : #000;
}
.my-columnleadCnt {
	text-align : right;
	background : #FFCCFF;
	color : #000;
}
</style>

<script type="text/javaScript">
//	Global Variables
var gWeekTh	= "";
var gToday	= new Date();
var gYear	= "";
var gMonth	= "";
var gDay	= "";
var m0WeekCnt	= 0;	//	M0월 주차갯수
var m1WeekCnt	= 0;	//	M+1월 주차갯수
var m2WeekCnt	= 0;	//	M+2월 주차갯수
var m3WeekCnt	= 0;	//	M+3월 주차갯수
var m4WeekCnt	= 0;	//	M+4월 주차갯수
var m0ThWeekStart	= 0;	//	M0월 시작주차
var m1ThWeekStart	= 0;	//	M1월 시작주차
var m2ThWeekStart	= 0;	//	M2월 시작주차
var m3ThWeekStart	= 0;	//	M3월 시작주차
var m4ThWeekStart	= 0;	//	M4월 시작주차
var salesPlanList	= new Object();
var childField	= new Object();

var planFstWeek		= 0;
var planFstSpltWeek	= 0;
var planWeekTh		= 0;

var planYear	= 0;
var planMonth	= 0;
var planWeek	= 0;

$(function() {
	//	Set combo box
	fnScmTotalPeriod();
	//fnScmYearCbBox();
	//fnScmWeekCbBox();
	fnScmTeamCbBox();
	fnScmStockCategoryCbBox();
	fnScmStockTypeCbBox();
	doGetComboAndGroup2("/scm/selectScmStockCodeForMulti.do", "", "", "scmStockCodeCbBox", "M", "");
	$(".js-example-basic-multiple").select2();
});

//	Scm Total Period
function fnScmTotalPeriod() {
	Common.ajax("POST"
			, "/scm/selectScmTotalPeriod.do"
			, ""
			, function(result) {
				console.log(result);
				
				planYear	= result.selectScmTotalPeriod[0].scmYear;
				planMonth	= result.selectScmTotalPeriod[0].scmMonth;
				planWeek	= result.selectScmTotalPeriod[0].scmWeek;
				fnScmYearCbBox();
				fnScmWeekCbBoxThis();
			});
}

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
			, planYear.toString()
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

//	today week
function fnScmWeekCbBoxThis() {
	CommonCombo.make("scmWeekCbBox"
			, "/scm/selectScmWeek.do"
			, { scmYear : planYear }
			, planWeek.toString()
			, {
				id : "id",
				name : "name",
				chooseMessage : "Select a Year"
			}
			, "");
	gWeekTh	= planWeek.toString();
}

//	team
function fnScmTeamCbBox() {
	CommonCombo.make("scmTeamCbBox"
			, "/scm/selectScmTeam.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				chooseMessage : "All"
			}
			, "");
}

//	category
function fnScmStockCategoryCbBox() {
	CommonCombo.make("scmStockCategoryCbBox"
			, "/scm/selectScmStockCategory.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
			}
			, "");
}

//	stock type
function fnScmStockTypeCbBox() {
	var params	= $.extend($("#MainForm").serializeJSON(), params);
	CommonCombo.make("scmStockTypeCbBox"
			, "/scm/selectScmStockType.do"
			, params
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
			}
			, "");
}

//	header
function fnSalesPlanHeader() {
	if ( 1 > $("#scmYearCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Year' htmlEscape='false'/>");
		return	false;
	}
	if ( 1 > $("#scmWeekCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Week' htmlEscape='false'/>");
		return	false;
	}
	
	var dynamicSummaryLayout	= [];
	var dynamicSummaryOption	= {};
	var dynamicLayout	= [];
	var dynamicOption	= {};
	
	if ( AUIGrid.isCreated(mySummaryGridID) ) {
		AUIGrid.destroy(mySummaryGridID);
	}
	if ( AUIGrid.isCreated(myGridID) ) {
		AUIGrid.destroy(myGridID);
	}
	
	dynamicSummaryOption	= {
			usePaging : false,
			useGroupingPanel : false,
			showRowNumColumn : true,
			showRowCheckColumn : false,
			showStateColumn : false,
			showEditedCellMarker : false,
			editable : false,
			enableCellMerge : true,
			enableRestore : false,
			fixedColumnCount : 2
	};
	dynamicOption	= {
			usePaging : false,
			useGroupingPanel : false,
			showRowNumColumn : true,
			showRowCheckColumn : false,
			showStateColumn : true,
			showEditedCellMarker : true,
			editable : true,
			enableCellMerge : true,
			enableRestore : true,
			fixedColumnCount : 10
	};
	
	Common.ajax("POST"
			, "/scm/selectSalesPlanHeader.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				
				console.log (result);
				
				//	scm total info check
				if ( null == result.selectScmTotalInfo || 1 > result.selectScmTotalInfo.length ) {
					Common.alert("Scm Total Information is wrong");
					return	false;
				}
				//	if selectSalesPlanSummaryHeader result null then remove grid
				if ( null == result.selectSalesPlanSummaryHeader || 1 > result.selectSalesPlanSummaryHeader.length ) {
					if ( AUIGrid.isCreated(mySummaryGridID) ) {
						AUIGrid.destroy(mySummaryGridID);
					}
					Common.alert("Calendar Information is wrong");
					return	false;
				}
				//	if selectSalesPlanHeader result null then remove grid
				if ( null == result.selectSalesPlanHeader || 1 > result.selectSalesPlanHeader.length ) {
					if ( AUIGrid.isCreated(myGridID) ) {
						AUIGrid.destroy(myGridID);
					}
					Common.alert("Calendar Information is wrong");
					return	false;
				}
				
				var planFstSpltWeek		= result.selectScmTotalInfo[0].planFstSpltWeek;
				//	1. make summary header
				if ( null != result.selectSalesPlanSummaryHeader && 0 < result.selectSalesPlanSummaryHeader.length ) {
					dynamicSummaryLayout.push(
							{
								headerText : "Team",
								dataField : result.selectSalesPlanSummaryHeader[0].team,
								cellMerge : true,
								mergePolicy : "restrict",
								mergeRef : "team",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( "DST" == item.team ) {
										return	"my-columnCenter0";
									} else if ( "CODY" == item.team ) {
										return	"my-columnCenter1";
									} else if ( "CS" == item.team ) {
										return	"my-columnCenter2";
									}
								}
							}, {
								headerText : "Type",
								dataField : result.selectSalesPlanSummaryHeader[0].typeName,
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( "DST" == item.team ) {
										return	"my-columnCenter0";
									} else if ( "CODY" == item.team ) {
										return	"my-columnCenter1";
									} else if ( "CS" == item.team ) {
										return	"my-columnCenter2";
									}
								}
							}, {
								headerText : result.selectScmTotalInfo[0].m0Mon,
								dataField : result.selectSalesPlanSummaryHeader[0].m0,
								dataType : "numeric",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( "DST" == item.team ) {
										return	"my-columnRight0";
									} else if ( "CODY" == item.team ) {
										return	"my-columnRight1";
									} else if ( "CS" == item.team ) {
										return	"my-columnRight2";
									}
								}
							}, {
								headerText : result.selectScmTotalInfo[0].m1Mon,
								dataField : result.selectSalesPlanSummaryHeader[0].m1,
								dataType : "numeric",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( "DST" == item.team ) {
										return	"my-columnRight0";
									} else if ( "CODY" == item.team ) {
										return	"my-columnRight1";
									} else if ( "CS" == item.team ) {
										return	"my-columnRight2";
									}
								}
							}, {
								headerText : result.selectScmTotalInfo[0].m2Mon,
								dataField : result.selectSalesPlanSummaryHeader[0].m2,
								dataType : "numeric",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( "DST" == item.team ) {
										return	"my-columnRight0";
									} else if ( "CODY" == item.team ) {
										return	"my-columnRight1";
									} else if ( "CS" == item.team ) {
										return	"my-columnRight2";
									}
								}
							}, {
								headerText : result.selectScmTotalInfo[0].m3Mon,
								dataField : result.selectSalesPlanSummaryHeader[0].m3,
								dataType : "numeric",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( "DST" == item.team ) {
										return	"my-columnRight0";
									} else if ( "CODY" == item.team ) {
										return	"my-columnRight1";
									} else if ( "CS" == item.team ) {
										return	"my-columnRight2";
									}
								}
							}, {
								headerText : result.selectScmTotalInfo[0].m4Mon,
								dataField : result.selectSalesPlanSummaryHeader[0].m4,
								dataType : "numeric",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( "DST" == item.team ) {
										return	"my-columnRight0";
									} else if ( "CODY" == item.team ) {
										return	"my-columnRight1";
									} else if ( "CS" == item.team ) {
										return	"my-columnRight2";
									}
								}
							}
					);
					
					m0WeekCnt	= parseInt(result.selectScmTotalInfo[0].m0WeekCnt);
					m1WeekCnt	= parseInt(result.selectScmTotalInfo[0].m1WeekCnt);
					m2WeekCnt	= parseInt(result.selectScmTotalInfo[0].m2WeekCnt);
					m3WeekCnt	= parseInt(result.selectScmTotalInfo[0].m3WeekCnt);
					m4WeekCnt	= parseInt(result.selectScmTotalInfo[0].m4WeekCnt);
					
					planFstWeek	= parseInt(result.selectScmTotalInfo[0].planFstWeek);
					planFstSpltWeek	= parseInt(result.selectScmTotalInfo[0].planFstSpltWeek);
					planWeekTh	= parseInt(result.selectScmTotalInfo[0].planWeekTh);
					
					m0ThWeekStart	= parseInt(result.selectScmTotalInfo[0].planFstSpltWeek);	//	수립주차가 포함된 월의 스플릿여부 상관없이 첫주차
					m1ThWeekStart	= m0ThWeekStart + m0WeekCnt;
					m2ThWeekStart	= m1ThWeekStart + m1WeekCnt;
					m3ThWeekStart	= m2ThWeekStart + m2WeekCnt;
					m4ThWeekStart	= m3ThWeekStart + m3WeekCnt;
					
					var iLoopCnt	= 1;
					var iLoopDataFieldCnt	= 1;
					var intToStrFieldCnt	= "";
					var fieldStr	= "";
					var startCnt	= 0;
					var strWeekTh	= "W";
					
					/******************************
					******** M0 Header
					******************************/
					var groupM0	= {
						headerText : result.selectScmTotalInfo[0].m0Mon,
						children : []
					};
					for ( var i = 0 ; i < m0WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						groupM0.children.push({
							dataField : "w" + intToStrFieldCnt,	//	w00
							headerText : result.selectSalesPlanHeader[0][fieldStr],
							dataType : "numeric",
							styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								if ( "DST" == item.team ) {
									return	"my-columnRight0";
								} else if ( "CODY" == item.team ) {
									return	"my-columnRight1";
								} else if ( "CS" == item.team ) {
									return	"my-columnRight2";
								}
							}
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicSummaryLayout.push(groupM0);
					
					/******************************
					******** M1 Header
					******************************/
					var groupM1 = {
						headerText : result.selectScmTotalInfo[0].m1Mon,
						children : []
					};
					for ( var i = 0 ; i < m1WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						groupM1.children.push({
							dataField : "w" + intToStrFieldCnt,
							headerText : result.selectSalesPlanHeader[0][fieldStr],
							dataType : "numeric",
							styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								if ( "DST" == item.team ) {
									return	"my-columnRight0";
								} else if ( "CODY" == item.team ) {
									return	"my-columnRight1";
								} else if ( "CS" == item.team ) {
									return	"my-columnRight2";
								}
							}
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicSummaryLayout.push(groupM1);
					
					/******************************
					******** M2 Header
					******************************/
					var groupM2 = {
						headerText : result.selectScmTotalInfo[0].m2Mon,
						children : []
					};
					for ( var i = 0 ; i < m2WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						groupM2.children.push({
							dataField : "w" + intToStrFieldCnt,
							headerText :  result.selectSalesPlanHeader[0][fieldStr],
							dataType : "numeric",
							styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								if ( "DST" == item.team ) {
									return	"my-columnRight0";
								} else if ( "CODY" == item.team ) {
									return	"my-columnRight1";
								} else if ( "CS" == item.team ) {
									return	"my-columnRight2";
								}
							}
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					};
					dynamicSummaryLayout.push(groupM2);
					
					/******************************
					******** M3 Header
					******************************/
					var groupM3 = {
						headerText : result.selectScmTotalInfo[0].m3Mon,
						children : []
					};
					for ( var i = 0 ; i < m3WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						groupM3.children.push({
							dataField : "w" + intToStrFieldCnt,
							headerText :  result.selectSalesPlanHeader[0][fieldStr],
							dataType : "numeric",
							styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								if ( "DST" == item.team ) {
									return	"my-columnRight0";
								} else if ( "CODY" == item.team ) {
									return	"my-columnRight1";
								} else if ( "CS" == item.team ) {
									return	"my-columnRight2";
								}
							}
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicSummaryLayout.push(groupM3);
					
					/******************************
					******** M4 Header
					******************************/
					var groupM4 = {
						headerText : result.selectScmTotalInfo[0].m4Mon,
						children : []
					};
					for ( var i = 0 ; i < m4WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						groupM4.children.push({
							dataField : "w" + intToStrFieldCnt,
							headerText :  result.selectSalesPlanHeader[0][fieldStr],
							dataType : "numeric",
							styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								if ( "DST" == item.team ) {
									return	"my-columnRight0";
								} else if ( "CODY" == item.team ) {
									return	"my-columnRight1";
								} else if ( "CS" == item.team ) {
									return	"my-columnRight2";
								}
							}
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicSummaryLayout.push(groupM4);
				}
				
				//	2. make plan header
				if ( null != result.selectSalesPlanHeader && 0 < result.selectSalesPlanHeader.length ) {
					dynamicLayout.push(
							{
								headerText : "Material",
								children :
									[
									 {
										 dataField : result.selectSalesPlanHeader[0].planId,
										 headerText : "Plan Id",
										 visible : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].planDtlId,
										 headerText : "Plan Dtl Id",
										 visible : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].stock,
										 headerText : "Stock",
										 visible : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].team,
										 headerText : "Team",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].typeId,
										 headerText : "Type Id",
										 visible : false,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].typeName,
										 headerText : "Type",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].categoryId,
										 headerText : "Category Id",
										 visible : false,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].categoryName,
										 headerText : "Category",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].code,
										 headerText : "Code",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].name,
										 headerText : "Desc.",
										 visible : true,
										 style : "my-backColumn3"
									 }
									 ]
							}, {
								//	M-3 Issue Avg
								dataField : result.selectSalesPlanHeader[0].preM3IssAvg,
								headerText : "M-3 Issue<br/>Avg",
								visible : true,
								 style : "my-backColumn3",
								 dataType : "numeric",
								 //formatString : "#,##0",
								 editable : false
							}, {
								//	M-1 Order Sum
								 dataField : result.selectSalesPlanHeader[0].preM1OrdSum,
								 headerText : "M-1 Order<br/>Sum",
								 visible : true,
								 style : "my-backColumn3",
								 dataType : "numeric",
								 //formatString : "#,##0",
								 editable : false
							}, {
								headerText : "Monthly",
								children :
									[
									 {
										 dataField : result.selectSalesPlanHeader[0].m0OrdSum,
										 headerText : result.selectScmTotalInfo[0].m0Mon + " Order",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 //formatString : "#,##0",
										 editable : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].m0,
										 headerText : result.selectScmTotalInfo[0].m0Mon,
										 visible : false,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 //formatString : "#,##0",
										 editable : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].m0Exp,
										 headerText : result.selectScmTotalInfo[0].m0Mon + " Exp",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 //formatString : "#,##0",
										 editable : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].m1,
										 headerText : result.selectScmTotalInfo[0].m1Mon,
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 //formatString : "#,##0",
										 editable : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].m2,
										 headerText : result.selectScmTotalInfo[0].m2Mon,
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 //formatString : "#,##0",
										 editable : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].m3,
										 headerText : result.selectScmTotalInfo[0].m3Mon,
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 //formatString : "#,##0",
										 editable : false
									 }, {
										 dataField : result.selectSalesPlanHeader[0].m4,
										 headerText : result.selectScmTotalInfo[0].m4Mon,
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 //formatString : "#,##0",
										 editable : false
									 }
									 ]
							}
					);
					
					m0WeekCnt	= parseInt(result.selectScmTotalInfo[0].m0WeekCnt);
					m1WeekCnt	= parseInt(result.selectScmTotalInfo[0].m1WeekCnt);
					m2WeekCnt	= parseInt(result.selectScmTotalInfo[0].m2WeekCnt);
					m3WeekCnt	= parseInt(result.selectScmTotalInfo[0].m3WeekCnt);
					m4WeekCnt	= parseInt(result.selectScmTotalInfo[0].m4WeekCnt);
					
					planFstWeek	= parseInt(result.selectScmTotalInfo[0].planFstWeek);
					planFstSpltWeek	= parseInt(result.selectScmTotalInfo[0].planFstSpltWeek);
					planWeekTh	= parseInt(result.selectScmTotalInfo[0].planWeekTh);
					
					m0ThWeekStart	= parseInt(result.selectScmTotalInfo[0].planFstSpltWeek);	//	수립주차가 포함된 월의 스플릿여부 상관없이 첫주차
					m1ThWeekStart	= m0ThWeekStart + m0WeekCnt;
					m2ThWeekStart	= m1ThWeekStart + m1WeekCnt;
					m3ThWeekStart	= m2ThWeekStart + m2WeekCnt;
					m4ThWeekStart	= m3ThWeekStart + m3WeekCnt;
					
					var iLoopCnt	= 1;
					var iLoopDataFieldCnt	= 1;
					var intToStrFieldCnt	= "";
					var fieldStr	= "";
					var startCnt	= 0;
					var strWeekTh	= "W";
					
					var planGrWeekSpltYn	= parseInt(result.selectGetPoCntTargetCnt[0].planGrWeekSpltYn);
					var leadCnt	= 0;
					if ( 1 == planGrWeekSpltYn ) {
						leadCnt	= parseInt(result.selectGetPoCntTargetCnt[0].leadCnt) - parseInt(1);
						console.log("1. leadCnt : " + leadCnt + ", planGrWeekSpltYn : " + planGrWeekSpltYn);
					} else if ( 2 == planGrWeekSpltYn ) {
						leadCnt	= parseInt(result.selectGetPoCntTargetCnt[0].leadCnt) - parseInt(2);
						console.log("2. leadCnt : " + leadCnt + ", planGrWeekSpltYn : " + planGrWeekSpltYn);
					} else {
						console.log("selectScmTotalInfo or selectGetPoCntTargetCnt is error.");
					}
					
					/******************************
					******** M0 Header
					******************************/
					var groupM0	= {
						headerText : result.selectScmTotalInfo[0].m0Mon,
						children : []
					};
					for ( var i = 0 ; i < m0WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						if ( 0 == i ) {
							startCnt	= m0ThWeekStart;
						} else {
							startCnt	= startCnt + 1;
						}
						if ( parseInt(gWeekTh) > startCnt ) {
							//	수립주차 기준 당월의 과거 주차
							console.log("1. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							if ( 2 > startCnt.toString().length ) {
								strWeekTh	= "W0";
							} else {
								strWeekTh	= "W";
							}
							fieldStr		= "w" + iLoopCnt + "WeekSeq";
							groupM0.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText : result.selectSalesPlanHeader[0][fieldStr],
								dataType : "numeric",
								////formatString : "#,##0",
								editable : false,
								style : "my-backColumn1"
							});
							iLoopCnt++;
						} else if ( parseInt(gWeekTh) == startCnt ) {
							//	수립주차 기준 당월의 바로 전 주차
							console.log("2. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							fieldStr	= "w" + iLoopCnt + "WeekSeq";
							groupM0.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText : result.selectSalesPlanHeader[0][fieldStr],
								dataType : "numeric",
								////formatString : "#,##0",
								editable : false,
								style : "my-backColumn2"
							});
							iLoopCnt++;
						} else {
							//	수립주차 기준 당월의 미래 주차
							console.log("3. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							fieldStr	= "w" + iLoopCnt + "WeekSeq";
							var planStusId	= result.selectSalesPlanInfo[0].planStusId;//	console.log("planStusId : " + planStusId);
							if ( "5" == planStusId ) {
								//	Confirm이면 읽기전용
								groupM0.children.push({
									dataField : "w" + intToStrFieldCnt,	//	w00
									headerText : result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									////formatString : "#,##0",
									editable : false,
									style : "my-column"
								});
							} else {
								//	Unconfirm이면 편집가능
								groupM0.children.push({
									dataField : "w" + intToStrFieldCnt,	//	w00
									headerText : result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									////formatString : "#,##0",
									editable : true,
									style : "my-column"
								});
							}
							iLoopCnt++;
						}
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM0);
					
					/******************************
					******** M1 Header
					******************************/
					var groupM1 = {
						headerText : result.selectScmTotalInfo[0].m1Mon,
						children : []
					};
					for ( var i = 0 ; i < m1WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						if ( parseInt(gWeekTh) > startCnt ) {
							//console.log("4. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							if ( 2 > startCnt.toString().length ) {
								strWeekTh	= "W0";
							} else {
								strWeekTh	= "W";
							}
							fieldStr		= "w" + iLoopCnt + "WeekSeq";
							groupM1.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText : result.selectSalesPlanHeader[0][fieldStr],
								dataType : "numeric",
								//formatString : "#,##0",
								editable : false,
								style : "my-backColumn1"
							});
							iLoopCnt++;
						} else if ( parseInt(gWeekTh) == startCnt ) {
							//console.log("5. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							fieldStr	= "w" + iLoopCnt + "WeekSeq";
							groupM1.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText : result.selectSalesPlanHeader[0][fieldStr],
								dataType : "numeric",
								//formatString : "#,##0",
								editable : false,
								style : "my-backColumn2"
							});
							iLoopCnt++;
						} else {
							//console.log("6. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							fieldStr	= "w" + iLoopCnt + "WeekSeq";
							var planStusId	= result.selectSalesPlanInfo[0].planStusId;//	console.log("planStusId : " + planStusId);
							if ( "5" == planStusId ) {
								groupM1.children.push({
									dataField : "w" + intToStrFieldCnt,	//	w00
									headerText : result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : false,
									style : "my-column"
								});
							} else {
								groupM1.children.push({
									dataField : "w" + intToStrFieldCnt,	//	w00
									headerText : result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : true,
									style : "my-column"
								});
							}
							iLoopCnt++;
						}
						startCnt	= startCnt + 1;
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM1);
					
					/******************************
					******** M2 Header
					******************************/
					var groupM2 = {
						headerText : result.selectScmTotalInfo[0].m2Mon,
						children : []
					};
					for ( var i = 0 ; i < m2WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						var planStusId	= result.selectSalesPlanInfo[0].planStusId;//	console.log("planStusId : " + planStusId);
						if ( iLoopDataFieldCnt > leadCnt ) {
							if ( "5" == planStusId ) {
								groupM2.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : false,
									style : "my-columnleadCnt"
								});
							} else {
								groupM2.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : true,
									style : "my-columnleadCnt"
								});
							}
						} else {
							if ( "5" == planStusId ) {
								groupM2.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : false,
									style : "my-column"
								});
							} else {
								groupM2.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : true,
									style : "my-column"
								});
							}
						}
						iLoopCnt++;
						iLoopDataFieldCnt++;
					};
					dynamicLayout.push(groupM2);
					
					/******************************
					******** M3 Header
					******************************/
					var groupM3 = {
						headerText : result.selectScmTotalInfo[0].m3Mon,
						children : []
					};
					for ( var i = 0 ; i < m3WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						var planStusId	= result.selectSalesPlanInfo[0].planStusId;//	console.log("planStusId : " + planStusId);
						if ( iLoopDataFieldCnt > leadCnt ) {
							if ( "5" == planStusId ) {
								groupM3.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : false,
									style : "my-columnleadCnt"
								});
							} else {
								groupM3.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : true,
									style : "my-columnleadCnt"
								});
							}
						}
						else {
							if ( "5" == planStusId ) {
								groupM3.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : false,
									style : "my-column"
								});
							} else {
								groupM3.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : true,
									style : "my-column"
								});
							}
						}
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM3);
					
					/******************************
					******** M4 Header
					******************************/
					var groupM4 = {
						headerText : result.selectScmTotalInfo[0].m4Mon,
						children : []
					};
					for ( var i = 0 ; i < m4WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						var planStusId	= result.selectSalesPlanInfo[0].planStusId;//	console.log("planStusId : " + planStusId);
						if ( iLoopDataFieldCnt > leadCnt ) {
							if ( "5" == planStusId ) {
								groupM4.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : false,
									style : "my-columnleadCnt"
								});
							} else {
								groupM4.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : true,
									style : "my-columnleadCnt"
								});
							}
						} else {
							if ( "5" == planStusId ) {
								groupM4.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : false,
									style : "my-column"
								});
							} else {
								groupM4.children.push({
									dataField : "w" + intToStrFieldCnt,
									headerText :  result.selectSalesPlanHeader[0][fieldStr],
									dataType : "numeric",
									//formatString : "#,##0",
									editable : true,
									style : "my-column"
								});
							}
						}
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM4);
					
					//	Create Grid
					mySummaryGridID	= GridCommon.createAUIGrid("sales_plan_summary_wrap", dynamicSummaryLayout, "", dynamicSummaryOption);
					myGridID	= GridCommon.createAUIGrid("sales_plan_wrap", dynamicLayout, "", dynamicOption);
					
					//	Event
					AUIGrid.bind(myGridID, "cellEditEnd", fnSumMnPlan);
					
					//	search
					fnSearch();
				}
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

//	search
function fnSearch() {
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects"),
		scmStockCategoryCbBox : $("#scmStockCategoryCbBox").multipleSelect("getSelects"),
		scmStockCodeCbBox : $("#scmStockCodeCbBox").val()
	};
	var team	= $("#scmTeamCbBox").val();
	var url		= "";
	//console.log("team : " + team + ", ddd : " + $("#scmTeamCbBox").val());
	if ( "" == team ) {
		url	= "/scm/selectSalesPlanListAll.do";
	} else {
		url	= "/scm/selectSalesPlanList.do";
	}
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, url
			, params
			//, $("#MainForm").serialize()
			, function(result) {
				console.log(result);
				
				//	Sales Plan Summary
				AUIGrid.setGridData(mySummaryGridID, result.selectSalesPlanSummaryList);
				
				//	Sales Plan
				if ( "/scm/selectSalesPlanListAll.do" == url ) {
					fnButtonControl("All", result.selectSalesPlanInfo, result.selectSalesPlanList);
				} else if ( "/scm/selectSalesPlanList.do" == url ) {
					fnButtonControl("Each", result.selectSalesPlanInfo, result.selectSalesPlanList);
				} else {
					console.log("fnSearch Error");
					return	false;
				}
				AUIGrid.setGridData(myGridID, result.selectSalesPlanList);
				
				salesPlanList	= result.selectSalesPlanList;
			});
}

//	create
function fnCreate(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	
	if ( 1 > $("#scmYearCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Year' htmlEscape='false'/>");
		return	false;
	}
	if ( 1 > $("#scmWeekCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Week' htmlEscape='false'/>");
		return	false;
	}
	if ( 1 > $("#scmTeamCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Team' htmlEscape='false'/>");
		return	false;
	}
	
	var params	= {
			planStusId : 1,
			reCalcYn : "N"
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/insertSalesPlanMaster.do"
			, params
			, function(result) {
				if ( "98" == result.code ) {
					Common.alert("You must confirm before week's Sales Plan");
				} else if ( "97" == result.code ) {
					Common.alert("Already Created this week's Sales Plan.");
				} else {
					Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
					fnSalesPlanHeader();
					console.log("Success : " + JSON.stringify(result) + " /data : " + result.data);
				}
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

//	save
function fnSaveDetail(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	if ( false == fnValidation() ) {
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/updateSalesPlanDetail.do"
			, GridCommon.getEditData(myGridID)
			, function(result) {
				Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
				fnSalesPlanHeader();
				console.log("Success : " + JSON.stringify(result) + " /data : " + result.data);
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

//	confirm/unconfirm
function fnSaveMaster(obj, conf) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	if ( 1 > $("#scmTeamCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Team' htmlEscape='false'/>");
		return	false;
	}
	
	//	그리드에 수정사항이 있는 경우 메시지
	var updList	= AUIGrid.getEditedRowItems(myGridID);
	if ( 0 < updList.length ) {
		Common.alert("Save First");
		return	false;
	}
	
	var msg	= "";
	var url	= "";
	var planId	= salesPlanList[0].planId;
	var planStusId	= 0;
	var reCalcYn	= "N";
	
	//	set planStusId
	if ( "confirm" == conf ) {
		msg	= $("#scmYearCbBox").val() + " year " + $("#scmWeekCbBox").val() + " th Week Sales Plan is confirmed";
		url	= "/scm/updateSalesPlanMaster.do";
		planStusId	= 5;
	} else if ( "unconfirm" == conf ) {
		msg	= $("#scmYearCbBox").val() + " year " + $("#scmWeekCbBox").val() + " th Week Sales Plan is Unconfirmed";
		url	= "/scm/updateSalesPlanMaster.do";
		planStusId	= 1;
	} else if ( "reCalc" == conf ) {
		url	= "/scm/insertSalesPlanMaster.do";
		reCalcYn	= "Y";
		planStusId	= 1;
	}
	
	var params	= {
			planId : planId,
			planStusId : planStusId,
			reCalcYn : reCalcYn
		};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("POST"
			, url
			, params
			, function(result) {
				Common.alert(msg);
				fnSalesPlanHeader();
				console.log("Success : " + JSON.stringify(result) + " /data : " + result.data);
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
	
	GridCommon.exportTo("#sales_plan_wrap", "xlsx", fileName + '_' + getTimeStamp());
}

//	validation
function fnValidation() {
	var result	= true;
	var updList	= AUIGrid.getEditedRowItems(myGridID);
	
	if ( 0 == updList.length ) {
		Common.alert("No Change");
		result	= false;
	}
	
	return	result;
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

//	sum each Mn plan
function fnSumMnPlan(event) {
	//console.log(event);
	var colStartIdx		= 19;	//	every week's cnt start column index : It should be changable, selectSalesPlanList query column count change
	var colChangeIdx	= event.columnIndex;
	var planWeek	= $("#scmWeekCbBox").val();
	var m0	= 0;	var m1	= 0;	var m2	= 0;	var m3	= 0;	var m4	= 0;
	var ms0	= "";	var ms1	= "";	var ms2	= "";	var ms3	= "";	var ms4	= "";
	var team	= "";	var type	= 0;	var weekFrom	= 0;	var weekTo	= 0;	var value	= 0;
	
	if ( "cellEditEnd" == event.type ) {
		//console.log("m0WeekCnt : " + m0WeekCnt + ", m1WeekCnt : " + m1WeekCnt + ", m2WeekCnt : " + m2WeekCnt + ", m3WeekCnt : " + m3WeekCnt + ", m4WeekCnt : " + m4WeekCnt);
		
		console.log("planFstWeek : " + planFstWeek + ", planFstSpltWeek : " + planFstSpltWeek + ", planWeekTh : " + planWeekTh);
		
		//	sum m0
		for ( var i = 0 ; i < m0WeekCnt ; i++ ) {
			ms0	= "w0" + (i + 1).toString();
			//console.log("planWeek : " + planWeek + ", m0ThWeekStart : " + m0ThWeekStart + ", i : " + i + ", colChangeIdx : " + colChangeIdx);
			//if ( planWeek < parseInt(i) + parseInt(m0ThWeekStart) ) {
				//console.log("sum");
			if ( planFstWeek == planFstSpltWeek ) {
				if ( i < parseInt(planWeekTh) + 1 ) {
					null;
					console.log("null");
				} else {
					if ( parseInt(i) + parseInt(colStartIdx) == parseInt(colChangeIdx) ) {
						m0	= parseInt(m0) + parseInt(event.value);
						salesPlanList[event.rowIndex][ms0]	= ((event.value).toString()).replace(",", "");
						//console.log("01. i : " + i + ", ms0 : " + ms0 + ", value : " + event.value);
					} else {
						m0	= parseInt(m0) + parseInt(salesPlanList[event.rowIndex][ms0]);
						//console.log("02. i : " + i + ", ms0 : " + ms0 + ", value : " + salesPlanList[event.rowIndex][ms0]);
					}
				}
			} else {
				if ( i < parseInt(planWeekTh) ) {
					null;
					//console.log("null");
				} else {
					if ( parseInt(i) + parseInt(colStartIdx) == parseInt(colChangeIdx) ) {
						m0	= parseInt(m0) + parseInt(event.value);
						salesPlanList[event.rowIndex][ms0]	= ((event.value).toString()).replace(",", "");
						//console.log("21. i : " + i + ", ms0 : " + ms0 + ", value : " + event.value);
					} else {
						m0	= parseInt(m0) + parseInt(salesPlanList[event.rowIndex][ms0]);
						//console.log("22. i : " + i + ", ms0 : " + ms0 + ", value : " + salesPlanList[event.rowIndex][ms0]);
					}
				}
			}
			//} else {
			//	console.log("not sum");
			//}
		}
		salesPlanList[event.rowIndex]["m0"]	= parseInt(m0);
		salesPlanList[event.rowIndex]["m0Exp"]	= parseInt(salesPlanList[event.rowIndex]["m0OrdSum"]) + parseInt(salesPlanList[event.rowIndex]["m0"]);
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m0", m0);
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m0Exp", parseInt(salesPlanList[event.rowIndex]["m0OrdSum"]) + parseInt(salesPlanList[event.rowIndex]["m0"]));
		
		//	sum 01
		for ( var i = 0 ; i < m1WeekCnt ; i++ ) {
			if ( 10 > i + 1 + parseInt(m0WeekCnt) ) {
				ms1	= "w0" + (i + 1 + parseInt(m0WeekCnt)).toString();
			} else {
				ms1	= "w" + (i + 1 + parseInt(m0WeekCnt)).toString();
			}
			//console.log("planWeek : " + planWeek + ", m1ThWeekStart : " + m1ThWeekStart + ", i : " + i + ", colChangeIdx : " + colChangeIdx);
			if ( i + parseInt(m0WeekCnt) + parseInt(colStartIdx) == parseInt(colChangeIdx) ) {
				m1	= parseInt(m1) + parseInt(event.value);
				salesPlanList[event.rowIndex][ms1]	= ((event.value).toString()).replace(",", "");
				//console.log("11. i : " + i + ", ms1 : " + ms1 + ", value : " + event.value);
			} else {
				m1	= parseInt(m1) + parseInt(salesPlanList[event.rowIndex][ms1]);
				//console.log("12. i : " + i + ", ms1 : " + ms1 + ", value : " + salesPlanList[event.rowIndex][ms1]);
			}
		}
		salesPlanList[event.rowIndex]["m1"]	= parseInt(m1);
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m1", m1);
		
		//	sum m2
		for ( var i = 0 ; i < m2WeekCnt ; i++ ) {
			if ( 10 > i + 1 + parseInt(m0WeekCnt) + parseInt(m1WeekCnt) ) {
				ms2	= "w0" + (i + 1 + parseInt(m0WeekCnt) + parseInt(m1WeekCnt)).toString();
			} else {
				ms2	= "w" + (i + 1 + parseInt(m0WeekCnt) + parseInt(m1WeekCnt)).toString();
			}
			if ( i + parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(colStartIdx) == parseInt(colChangeIdx) ) {
				m2	= parseInt(m2) + parseInt(event.value);
				salesPlanList[event.rowIndex][ms2]	=  ((event.value).toString()).replace(",", "");
				//console.log("21. i : " + i + ", ms2 : " + ms2 + ", value : " + event.value);
			} else {
				m2	= parseInt(m2) + parseInt(salesPlanList[event.rowIndex][ms2]);
				//console.log("22. i : " + i + ", ms2 : " + ms2 + ", value : " + salesPlanList[event.rowIndex][ms2]);
			}
		}
		salesPlanList[event.rowIndex]["m2"]	= parseInt(m2);
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m2", m2);
		
		//	sum m3
		for ( var i = 0 ; i < m3WeekCnt ; i++ ) {
			ms3	= "w" + (i + 1 + parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt)).toString();
			if ( i + parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) + parseInt(colStartIdx) == parseInt(colChangeIdx) ) {
				m3	= parseInt(m3) + parseInt(event.value);
				salesPlanList[event.rowIndex][ms3]	= ((event.value).toString()).replace(",", "");
				//console.log("31. i : " + i + ", ms3 : " + ms3 + ", value : " + event.value);
			} else {
				m3	= parseInt(m3) + parseInt(salesPlanList[event.rowIndex][ms3]);
				//console.log("32. i : " + i + ", ms3 : " + ms3 + ", value : " + salesPlanList[event.rowIndex][ms3]);
			}
		}
		salesPlanList[event.rowIndex]["m3"]	= parseInt(m3);
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m3", m3);
		
		//	sum m4
		for ( var i = 0 ; i < m4WeekCnt ; i++ ) {
			ms4	= "w" + (i + 1 + parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) + parseInt(m3WeekCnt)).toString();
			if ( i + parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) + parseInt(m3WeekCnt) + parseInt(colStartIdx) == parseInt(colChangeIdx) ) {
				m4	= parseInt(m4) + parseInt(event.value);
				salesPlanList[event.rowIndex][ms4]	= ((event.value).toString()).replace(",", "");
				//console.log("41. i : " + i + ", ms4 : " + ms4 + ", value : " + event.value);
			} else {
				m4	= parseInt(m4) + parseInt(salesPlanList[event.rowIndex][ms4]);
				//console.log("42. i : " + i + ", ms4 : " + ms4 + ", value : " + salesPlanList[event.rowIndex][ms4]);
			}
		}
		salesPlanList[event.rowIndex]["m4"]	= parseInt(m4);
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m4", m4);
		
		team	= AUIGrid.getCellValue(myGridID, event.rowIndex, "team");
		type	= AUIGrid.getCellValue(myGridID, event.rowIndex, "typeId");
		var week	= colChangeIdx - 18;
		var month	= "";
		value	= event.value;
		if ( 1 <= week && parseInt(m0WeekCnt) >= week ) {
			month	= "m0";
		} else if ( parseInt(m0WeekCnt) + 1 <= week && parseInt(m0WeekCnt) + parseInt(m1WeekCnt) >= week ) {
			month	= "m1";
		} else if ( parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + 1 <= week && parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) >= week ) {
			month	= "m2";
		} else if ( parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) + 1 <= week && parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) + parseInt(m3WeekCnt) >= week ) {
			month	= "m3";
		} else if ( parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) + parseInt(m3WeekCnt) + 1 <= week && parseInt(m0WeekCnt) + parseInt(m1WeekCnt) + parseInt(m2WeekCnt) + parseInt(m3WeekCnt) + parseInt(m4WeekCnt) >= week ) {
			month	= "m4";
		}
		console.log("team : " + team + ", type : " + type + ", month : " + month + ", week : " + week + ", value : " + value);
	}
}

//	Summary calc
function fnSummaryCalc(event) {
	
}

//	Button & status
function fnButtonControl(div, list1, list2) {
	//	list1 : SalesPlan Info. 무조건 2개의 row
	//	list2 : SalesPlan List. row가 없을 수도 있음
	var currWeek	= list1[0].planStusId;	//	this week
	var prevWeek	= list1[1].planStusId;	//	before week
	var currSupp	= list1[2].planStusId;	//	this week supply plan
	console.log("prevWeek : " + prevWeek + ", currWeek : " + currWeek + ", currSupp : " + currSupp);
	//	Button
	if ( "All" == div ) {
		$("#btnCreate").addClass("btn_disabled");
		$("#btnSave").addClass("btn_disabled");
		$("#btnConfirm").addClass("btn_disabled");
		$("#btnUnconfirm").addClass("btn_disabled");
		$("#btnReCalc").addClass("btn_disabled");
		if ( null == list2 ) {
			//	팀전체, 판매계획 데이터가 없는 경우
			$("#btnExcel").addClass("btn_disabled");
		} else {
			//	팀전체, 판매계획 데이터가 있는 경우
			$("#btnExcel").removeClass("btn_disabled");
		}
	} else if ( "Each" == div ) {
		//	prevWeek : 0 / 1 / 5
		if ( 0 == prevWeek || 1 == prevWeek ) {
			//	팀개별, 전주 판매계획이 없거나, confirmed인 경우
			$("#btnCreate").addClass("btn_disabled");
			$("#btnSave").addClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			$("#btnReCalc").addClass("btn_disabled");
			$("#btnExcel").addClass("btn_disabled");
		} else if ( 5 == prevWeek ) {
			//	팀개별, 전주 판매계획 confirmed인 경우
			if ( 0 == currWeek ) {
				//	팀개별, 금주 판매계획 데이터가 없는 경우
				$("#btnCreate").removeClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				$("#btnReCalc").addClass("btn_disabled");
				$("#btnExcel").addClass("btn_disabled");
			} else if ( 1 == currWeek ) {
				//	팀개별, 금주 판매계획 unconfirmed인 경우
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").removeClass("btn_disabled");
				$("#btnConfirm").removeClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				$("#btnReCalc").removeClass("btn_disabled");
				$("#btnExcel").removeClass("btn_disabled");
			} else if ( 5 == currWeek ) {
				//	팀개별, 금주 판매계획 confirmed인 경우
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnReCalc").addClass("btn_disabled");
				$("#btnExcel").removeClass("btn_disabled");
				if ( 0 == currSupp ) {
					//	금주 공급계획이 아무것도 생성되지 않은 경우
					$("#btnUnconfirm").removeClass("btn_disabled");
				} else {
					//	금주 공급계획이 최소 생성이 된 경우
					$("#btnUnconfirm").addClass("btn_disabled");
				}
			} else {
				console.log("button currWeek error");
			}
		} else {
			console.log("button prevWeek error");
		}
	} else {
		console.log("button div error");
	}
	
	//	Circle
	if ( "All" == div ) {
		//	prevWeek 정보
		if ( 0 == prevWeek ) {
			//	prevWeek에 판매계획정보 아무것도 없음
			$("#cirPrevWeek").addClass("circle_grey");
			$("#cirPrevWeek").removeClass("circle_red");
			$("#cirPrevWeek").removeClass("circle_blue");
		} else if ( 15 == prevWeek ) {
			//	prevWeek에 판매계획정보 3개팀 전부 confirm
			//	만약 팀이 1개 늘어날때마다 +5씩 해줘야 함
			$("#cirPrevWeek").removeClass("circle_grey");
			$("#cirPrevWeek").removeClass("circle_red");
			$("#cirPrevWeek").addClass("circle_blue");
		} else {
			//	prevWeek에 판매계획정보 최소 생성 ~ 모든 팀이 confirm 은 아님
			$("#cirPrevWeek").removeClass("circle_grey");
			$("#cirPrevWeek").addClass("circle_red");
			$("#cirPrevWeek").removeClass("circle_blue");
		}
		//	currWeek 정보
		if ( 0 == currWeek ) {
			//	currWeek에 판매계획정보 아무것도 없음
			$("#cirCurrWeek").addClass("circle_grey");
			$("#cirCurrWeek").removeClass("circle_red");
			$("#cirCurrWeek").removeClass("circle_blue");
		} else if ( 15 == currWeek ) {
			//	currWeek에 판매계획정보 3개팀 전부 confirm
			//	만약 팀이 1개 늘어날때마다 +5씩 해줘야 함
			$("#cirCurrWeek").removeClass("circle_grey");
			$("#cirCurrWeek").removeClass("circle_red");
			$("#cirCurrWeek").addClass("circle_blue");
		} else {
			//	currWeek에 판매계획정보 최소 생성 ~ 모든 팀이 confirm 은 아님
			$("#cirCurrWeek").removeClass("circle_grey");
			$("#cirCurrWeek").addClass("circle_red");
			$("#cirCurrWeek").removeClass("circle_blue");
		}
	} else if ( "Each" == div ) {
		//	prevWeek 정보
		if ( 0 == prevWeek ) {
			//	prevWeek에 판매계획정보 아무것도 없음
			$("#cirPrevWeek").addClass("circle_grey");
			$("#cirPrevWeek").removeClass("circle_red");
			$("#cirPrevWeek").removeClass("circle_blue");
		} else if ( 5 == prevWeek ) {
			//	prevWeek에 판매계획정보 1개팀 confirm
			$("#cirPrevWeek").removeClass("circle_grey");
			$("#cirPrevWeek").removeClass("circle_red");
			$("#cirPrevWeek").addClass("circle_blue");
		} else {
			//	prevWeek에 판매계획정보 1개팀 unconfirm
			$("#cirPrevWeek").removeClass("circle_grey");
			$("#cirPrevWeek").addClass("circle_red");
			$("#cirPrevWeek").removeClass("circle_blue");
		}
		//	currWeek 정보
		if ( 0 == currWeek ) {
			//	currWeek에 판매계획정보 아무것도 없음
			$("#cirCurrWeek").addClass("circle_grey");
			$("#cirCurrWeek").removeClass("circle_red");
			$("#cirCurrWeek").removeClass("circle_blue");
		} else if ( 5 == currWeek ) {
			//	currWeek에 판매계획정보 1개팀 confirm
			$("#cirCurrWeek").removeClass("circle_grey");
			$("#cirCurrWeek").removeClass("circle_red");
			$("#cirCurrWeek").addClass("circle_blue");
		} else {
			//	currWeek에 판매계획정보 1개팀 unconfirm
			$("#cirCurrWeek").removeClass("circle_grey");
			$("#cirCurrWeek").addClass("circle_red");
			$("#cirCurrWeek").removeClass("circle_blue");
		}
	} else {
		console.log("circle div error");
	}
}

//	Event
function fnScmWeekCbBoxChange(object) {
	gWeekTh	= object.value;
}

//	Grid
var myGridID;
var mySummaryGridID;
/*
$(document).ready(function() {
	//
	
}
*/
</script>

<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
		<h2>Sales Plan Management</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSalesPlanHeader();"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside><!-- title_line end -->
	
	<section class="search_table"><!-- search_table start -->
		<form id="MainForm" method="get" action="">
			<table class="type1"><!-- table start -->
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
						<th scope="row">EST Year &amp; Week</th>
						<td>
							<div class="date_set w100p"><!-- date_set start -->
							<select class="sel_year" id="scmYearCbBox" name="scmYearCbBox"></select>
							<select class="sel_date" id="scmWeekCbBox" name="scmWeekCbBox" onchange="fnScmWeekCbBoxChange(this);"></select>
							</div><!-- date_set end -->
						</td>
						<th scope="row">Team</th>
						<td>
							<select class="w100p" id="scmTeamCbBox" name="scmTeamCbBox" onchange="fnScmStockTypeCbBox();"></select>
						</td>
						<th scope="row">Planning Status</th>
						<td>
							<div class="status_result">
								<!-- circle_red, circle_blue, circle_grey -->
								<p><span id ="cirPrevWeek" class="circle circle_grey"></span>  Previous Week Plan</p>
								<p><span id ="cirCurrWeek" class="circle circle_grey"></span>  Current Week Plan</p>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">Type</th>
						<td>
							<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
						</td>
						<th scope="row">Category</th>
						<td>
							<select class="w100p" id="scmStockCategoryCbBox" multiple="multiple" name="scmStockCategoryCbBox"></select>
						</td>
						<th scope="row">Material</th>
						<td>
							<!-- <input class="w100p" type="text" id="scmStockCode" name="scmStockCode" onkeypress="if(event.keyCode==13) {fnSalesPlanHeader(); return false;}">
							<select class="js-example-basic-multiple" id="select2t1m" name="select2t1m" multiple="multiple"> -->
							<select class="js-example-basic-multiple" id="scmStockCodeCbBox" name="scmStockCodeCbBox" multiple="multiple">
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
		<article class="grid_wrap"><!-- grid_wrap start -->
			<!-- 그리드 영역 1-->
			<div id="sales_plan_summary_wrap" style="height:226px;"></div>
		</article><!-- grid_wrap end -->
		<ul class="right_btns">
			<li><p id="btnCreate" class="btn_grid btn_disabled"><a onclick="fnCreate(this);">Create</a></p></li>
			<li><p id="btnSave" class="btn_grid btn_disabled"><a onclick="fnSaveDetail(this);">Save</a></p></li>
			<li><p id="btnConfirm" class="btn_grid btn_disabled"><a onclick="fnSaveMaster(this, 'confirm');">Confirm</a></p></li>
			<li><p id="btnUnconfirm" class="btn_grid btn_disabled"><a onclick="fnSaveMaster(this, 'unconfirm');">UnConfirm</a></p></li>
			<li><p id="btnReCalc" class="btn_grid btn_disabled"><a onclick="fnSaveMaster(this, 'reCalc');">Re-Calculation</a></p></li>
			<li><p id="btnExcel" class="btn_grid btn_disabled"><a onclick="fnExcel(this, 'SalesPlanManagement');">Excel</a></p></li>
			<!-- <li><p id='btnExcel'  class="btn_grid btn_disabled"><a onclick="fnExcel(this,'SalesPlanManagement');">Download</a></p></li> -->
		</ul>
		<article class="grid_wrap"><!-- grid_wrap start -->
			<!-- 그리드 영역 2-->
			<div id="sales_plan_wrap" style="height:400px;"></div>
		</article><!-- grid_wrap end -->
	</section><!-- search_result end -->
</section><!-- content end -->