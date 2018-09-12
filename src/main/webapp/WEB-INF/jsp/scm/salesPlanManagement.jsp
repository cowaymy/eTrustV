<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
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
.my-backColumn1 {
	text-align:right;
	background:#818284;
	color:#000;
}
.my-backColumn2 {
	text-align:right;
	background:#a1a2a3;
	color:#000;
}
.my-backColumn3 {
	text-align : right;
	background : #c0c0c0;
	color : #000;
}
.my-backColumn4 {
	text-align : center;
	background : #c0c0c0;
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
</style>

<script type="text/javaScript">
//	Global Variables
var gWeekTh	= "";
var gToday	= new Date();
var gYear	= "";
var gMonth	= "";
var gDay	= "";
var m0WeekCnt	= 0;	var m0WeekStart	= 0;
var m1WeekCnt	= 0;	var m1WeekStart	= 0;
var m2WeekCnt	= 0;	var m2WeekStart	= 0;
var m3WeekCnt	= 0;	var m3WeekStart	= 0;
var m4WeekCnt	= 0;	var m4WeekStart	= 0;
var salesPlanList	= new Object();

$(function() {
	//	Get Today Year, Week
	gYear	= gToday.getFullYear();
	gYear1	= gToday.getFullYear() - 1;
	gMonth	= gToday.getMonth() + 1;
	gDay	= gToday.getDate();
	
	console.log("======= : " + gYear);
	//	Set combo box
	fnScmYearCbBox();
	fnScmWeekCbBox();
	fnScmTeamCbBox();
	fnScmStockCategoryCbBox();
	fnScmStockTypeCbBox();
	//fnScmStockCodeCbBox();
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

//	today week
function fnScmWeekCbBox1() {
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
	//	callback
/*	var fnScmStockCodeCbBoxCallback	= function() {
		$("#scmStockCategoryCbBox").on("change", function() {
			var $this	= $(this);
			
			CommonCombo.initById("scmStockCodeCbBox");
			
			if ( FormUtil.isNotEmpty($this.val()) ) {
				CommonCombo.make("scmStockCodeCbBox"
						, "/scm/selectScmStockCode.do"
						, { scmStockCategory : $this.val() + "" }
						, ""
						, {
							id : "id",
							name : "name",
							type : "M"
						}
						, "");
			} else {
				fnScmStockCodeCbBox();
			}
		});
	};*/
	
	CommonCombo.make("scmStockCategoryCbBox"
			, "/scm/selectScmStockCategory.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
			}
			//, fnScmStockCodeCbBoxCallback);
			, "");
}

//	stock type
function fnScmStockTypeCbBox() {
	//	callback
/*	var fnScmStockCodeCbBoxCallback	= function() {
		$("#scmStockTypeCbBox").on("change", function() {
			var $this	= $(this);
			
			CommonCombo.initById("scmStockCodeCbBox");
			
			if ( FormUtil.isNotEmpty($this.val()) ) {
				CommonCombo.make("scmStockCodeCbBox"
						, "/scm/selectScmStockCode.do"
						, { scmStockType : $this.val() + "" }
						, ""
						, {
							id : "id",
							name : "name",
							type : "M"
						}
						, "");
			} else {
				fnScmStockCodeCbBox();
			}
		});
	};*/
	
	CommonCombo.make("scmStockTypeCbBox"
			, "/scm/selectScmStockType.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
			}
			//, fnScmStockCodeCbBoxCallback);
			, "");
}
/*
//	stock code
function fnScmStockCodeCbBox() {
	CommonCombo.make("scmStockCodeCbBox"
			, "/scm/selectScmStockCode.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
			}
			, "");
}
*/
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
	
	var dynamicLayout	= [];
	var dynamicOption	= {};
	
	if ( AUIGrid.isCreated(myGridID) ) {
		AUIGrid.destroy(myGridID);
	}
	
	dynamicOption	=
	{
		usePaging : true,
		useGroupingPanel : false,
		showRowNumColumn : true,
		editable : true,
		showStateColumn : true,
		showEditedCellMarker : true,
		enableCellMerge : true,
		fixedColumnCount : 5,			//	고정칼럼 카운트 지정
		enableRestore : true,
		//softRemovePolicy : "exceptNew",	//	사용자추가한 행은 바로 삭제
		showRowCheckColumn : false,
		//independentAllCheckBox : true,	//	전체 선택 체크박스가 독립적인 역할을 할지 여부
		usePaging : false				//	페이징처리 설정
	};
	
	Common.ajax("POST"
			, "/scm/selectSalesPlanHeader.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				
				console.log (result);
				
				//	if selectSalesPlanInfo result is null then alert
				if ( null == result.selectSalesPlanInfo || 1 > result.selectSalesPlanInfo.length ) {
					Common.alert("Sales Plan Master Info is null");
					return	false;
				} else {
					console.log("selectSalesPlanInfo is not null")
					fnSetSalesPlanInfo(result.selectSalesPlanInfo);
				}
				
				//	if selectSplitInfo result is null then alert
				if ( null == result.selectSplitInfo || 1 > result.selectSplitInfo.length ) {
					Common.alert("Week Split Info is null");
					return	false;
				}
				
				//	if selectChildField result is null then alert
				if ( null == result.selectChildField || 1 > result.selectChildField.length ) {
					Common.alert("Child Filed Info is null");
					return	false;
				}
				
				//	if selectSalesPlanHeader result null then remove grid
				if ( null == result.selectSalesPlanHeader || 1 > result.selectSalesPlanHeader.length ) {
					if ( AUIGrid.isCreated(myGridID) ) {
						AUIGrid.destroy(myGridID);
					}
					
					return	false;
				}
				
				//	make header
				if ( null != result.selectSalesPlanHeader && 0 < result.selectSalesPlanHeader.length ) {
					dynamicLayout.push(
							{
								headerText : "Stock",
								children :
									[
									 {
										 dataField : result.selectSalesPlanHeader[0].h1PlanId,
										 headerText : "Plan Id",
										 visible : true
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h1PlanDtlId,
										 headerText : "Plan Dtl Id",
										 visible : true
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h1Stock,
										 headerText : "Stock",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2Team,
										 headerText : "Team",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2TypeId,
										 headerText : "Type Id",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2TypeName,
										 headerText : "Type Name",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2CategoryId,
										 headerText : "Category Id",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2CategoryName,
										 headerText : "Category Name",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2Code,
										 headerText : "Code",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2Name,
										 headerText : "Name",
										 visible : true,
										 style : "my-backColumn3"
									 }
									 ]
							}, {
								//	M-3 Issue Avg
								dataField : result.selectSalesPlanHeader[0].h1M3IssueAvg,
								headerText : "M-3 Issue<br/>Avg",
								visible : true,
								style : "my-backColumn4"
							}, {
								headerText : "Monthly",
								children :
									[
									 {
										 dataField : result.selectSalesPlanHeader[0].h2M1Issue,
										 headerText : "M-1 Issue",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2M0Order,
										 headerText : "M0 Order",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2M0Plan,
										 headerText : "M0 Plan",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2M1,
										 headerText : "M+1",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2M2,
										 headerText : "M+2",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2M3,
										 headerText : "M+3",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSalesPlanHeader[0].h2M4,
										 headerText : "M+4",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }
									 ]
							}
					);
					
					m0WeekCnt	= parseInt(result.selectSplitInfo[0].m0WeekCnt);
					m1WeekCnt	= parseInt(result.selectSplitInfo[0].m1WeekCnt);
					m2WeekCnt	= parseInt(result.selectSplitInfo[0].m2WeekCnt);
					m3WeekCnt	= parseInt(result.selectSplitInfo[0].m3WeekCnt);
					m4WeekCnt	= parseInt(result.selectSplitInfo[0].m4WeekCnt);
					
					m0WeekStart	= 1;
					m1WeekStart	= m0WeekCnt + 1;
					m2WeekStart	= m0WeekCnt + m1WeekCnt + 1;
					m3WeekStart	= m0WeekCnt + m1WeekCnt + m2WeekCnt + 1;
					m4WeekStart	= m0WeekCnt + m1WeekCnt + m2WeekCnt + m3WeekCnt + 1;
					
					var iLoopCnt	= 1;
					var iLoopDataFieldCnt	= 1;
					var intToStrFieldCnt	= "";
					var fieldStr	= "";
					var startCnt	= 0;
					var strWeekTh	= "W";
					
					//var sumWeekThStr	= "";
					var m0HeaderLabel	= "";
					//console.log("gWeekTh : " + gWeekTh);
					/******************************
					******** M0 Header
					******************************/
					var groupM0	= {
						headerText : "M0",
						children : []
					};
					for ( var i = 0 ; i < m0WeekCnt ; i++ ) {
						intToStrFieldCnt	= iLoopDataFieldCnt.toString();
						if ( 1 == intToStrFieldCnt.length ) {
							intToStrFieldCnt	= "0" + intToStrFieldCnt;
						}
						if ( 0 == i ) {
							startCnt	= parseInt(result.selectChildField[i].weekTh);
						} else {
							startCnt	= startCnt + 1;
						}
						if ( parseInt(gWeekTh) > startCnt ) {
							//console.log("1. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
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
								formatString : "#,##0",
								editable : false,
								style : "my-backColumn1"
							});
							iLoopCnt++;
						} else if ( parseInt(gWeekTh) == startCnt ) {
							//console.log("2. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							fieldStr	= "w" + iLoopCnt + "WeekSeq";
							groupM0.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText : result.selectSalesPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								editable : false,
								style : "my-backColumn2"
							});
							iLoopCnt++;
						} else {
							//console.log("3. startCnt : " + startCnt + ", gWeekTh : " + gWeekTh);
							fieldStr	= "w" + iLoopCnt + "WeekSeq";
							groupM0.children.push({
								dataField : "w" + intToStrFieldCnt,	//	w00
								headerText : result.selectSalesPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								//editable : false,
								style : "my-column"
							});
							iLoopCnt++;
						}
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM0);
					
					/******************************
					******** M1 Header
					******************************/
					var groupM1 = {
						headerText : "M + 1",
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
							headerText :  result.selectSalesPlanHeader[0][fieldStr],
							dataType : "numeric",
							formatString : "#,##0",
							style : "my-column"
						});
						iLoopCnt ++;
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM1);
					
					/******************************
					******** M2 Header
					******************************/
					var groupM2 = {
						headerText : "M + 2",
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
							formatString : "#,##0",
							style : "my-column"
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					};
					dynamicLayout.push(groupM2);
					
					/******************************
					******** M3 Header
					******************************/
					var groupM3 = {
						headerText : "M + 3",
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
							formatString : "#,##0",
							style : "my-column"
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM3);
					
					/******************************
					******** M4 Header
					******************************/
					var groupM4 = {
						headerText : "M + 4",
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
							formatString : "#,##0",
							style : "my-column"
						});
						iLoopCnt++;
						iLoopDataFieldCnt++;
					}
					dynamicLayout.push(groupM4);
					
					//	Create Grid
					myGridID	= AUIGrid.create("#dynamic_DetailGrid_wrap", dynamicLayout, dynamicOption);
					
					//	Grid Event
					AUIGrid.bind(myGridID, "cellClick", function(event) {
						//gSelMainRowIdx	= event.rowIndex;
						//console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex);
						console.log("name : " + event.dataField);
						console.log("columnIndex : " + event.columnIndex + ", rowIndex : " + event.rowIndex + ", dataField Name : " + AUIGrid.getDataFieldByColumnIndex(event.columnIndex));
					});
					AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
						console.log("DobleClick(" + event.rowIndex + ", " + event.columnIndex + ") :  " + " value : " + event.value );
					});
					AUIGrid.bind(myGridID, "cellEditEnd", fnSumMnPlan);
					
					//	
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
		scmStockCategoryCbBox : $("#scmStockCategoryCbBox").multipleSelect("getSelects"),
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects"),
		scmStockCodeCbBox : $("#scmStockCodeCbBox").multipleSelect("getSelects")
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectSalesPlanList.do"
			, params
			, function(result) {
				//console.log("Success fnSearch : " + result.length);
				console.log(result);
				
				AUIGrid.setGridData(myGridID, result.selectSalesPlanList);
				
				//	set result list to object
				salesPlanList	= result.selectSalesPlanList;
				//console.log("-=======================-");
				//console.log(salesPlanList);
				
				if ( null != result && 0 < result.selectSalesPlanList.length ) {
				//	$("#btnConfirm").removeClass("btn_disabled");
				//	$("#btnSave").removeClass("btn_disabled");
				//	$("#btnDownload").removeClass("btn_disabled");
				} else if ( 0 == result.selectSalesPlanList.length ) {
				//	$("#btnUnconfirm").removeClass("btn_disabled");
				//	$("#btnDownload").addClass("btn_disabled");
				//	$("#btnSave").addClass("btn_disabled");
				}
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
	
	var params	= { planStusId : 1 };
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/insertSalesPlanMaster.do"
			, params
			, function(result) {
				if ( 99 == result.code ) {
					Common.alert("Already Created Sales Plan.");
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
				Common.alert(result.data  + "<spring:message code='sys.msg.saveCnt'/>");
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
	
	//	set planId
	if ( "DST" == $("#scmTeamCbBox").val() ) {
		$("#planId").val($("#planId1").val());
	} else if ( "CODY" == $("#scmTeamCbBox").val() ) {
		$("#planId").val($("#planId2").val());
	} else if ( "CS" == $("#scmTeamCbBox").val() ) {
		$("#planId").val($("#planId3").val());
	} else {
		Common.alert("Error");
		return	false;
	}
	
	//	set planStusId
	if ( "confirm" == conf ) {
		$("#planStusId").val(4);
	} else if ( "unconfirm" == conf ) {
		$("#planStusId").val(1);
	}
	
	Common.ajax("POST"
			, "/scm/updateSalesPlanMaster.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				Common.alert(result.data  + "<spring:message code='sys.msg.saveCnt'/>");
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
	
	GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", fileName + '_' + getTimeStamp());
}

//	sum each Mn plan
function fnSumMnPlan(event) {
	//console.log(event);
	var colStartIdx		= 18;	//	every week's cnt start column index : It should be changable, selectSalesPlanList query column count change
	var colChangeIdx	= event.columnIndex;
	var m0	= 0;	var m1	= 0;	var m2	= 0;	var m3	= 0;	var m4	= 0;
	var ms0	= "";	var ms1	= "";	var ms2	= "";	var ms3	= "";	var ms4	= "";
	if ( "cellEditEnd" == event.type ) {
		console.log("m0WeekCnt : " + m0WeekCnt + ", m1WeekCnt : " + m1WeekCnt + ", m2WeekCnt : " + m2WeekCnt + ", m3WeekCnt : " + m3WeekCnt + ", m4WeekCnt : " + m4WeekCnt);
		console.log("m0WeekStart : " + m0WeekStart + ", m1WeekStart : " + m1WeekStart + ", m2WeekStart : " + m2WeekStart + ", m3WeekStart : " + m3WeekStart + ", m4WeekStart : " + m4WeekStart);
		console.log(event.columnIndex);
		
		//	sum m0
		for ( var i = 0 ; i < m0WeekCnt ; i++ ) {
			ms0	= "w0" + (parseInt(m0WeekStart) + parseInt(i)).toString();
			//console.log("parseInt(i) + parseInt(colStartIdx) + parseInt(m0WeekStart) : " + parseInt(i) + parseInt(colStartIdx) + parseInt(m0WeekStart) + ", colidx : " + colChangeIdx);
			if ( parseInt(i) + parseInt(colStartIdx) + parseInt(m0WeekStart) - 1 == parseInt(colChangeIdx) ) {
				m0	= parseInt(m0) + parseInt(event.value);
				salesPlanList[event.rowIndex][ms0]	= event.value;
				console.log("11. i : " + i + ", ms0 : " + ms0 + ", value : " + event.value);
			} else {
				m0	= parseInt(m0) + parseInt(salesPlanList[event.rowIndex][ms0]);
				console.log("12. i : " + i + ", ms0 : " + ms0 + ", value : " + salesPlanList[event.rowIndex][ms0]);
			}
		}
		//console.log("m0 : " + m0);
		salesPlanList[event.rowIndex]["m0Plan"]	= m0;
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m0Plan", m0);
		//console.log("m0Plan : " + salesPlanList[event.rowIndex]["m0Plan"]);
		
		//	sum 01
		for ( var i = 0 ; i < m1WeekCnt ; i++ ) {
			if ( 10 > parseInt(m1WeekStart) + parseInt(i) ) {
				ms1	= "w0" + (parseInt(m1WeekStart) + parseInt(i)).toString();
			} else {
				ms1	= "w" + (parseInt(m1WeekStart) + parseInt(i)).toString();
			}
			if ( parseInt(i) + parseInt(colStartIdx) + parseInt(m1WeekStart) - 1 == parseInt(colChangeIdx) ) {
				m1	= parseInt(m1) + parseInt(event.value);
				console.log("21. i : " + i + ", ms1 : " + ms1 + ", value : " + event.value);
			} else {
				m1	= parseInt(m1) + parseInt(salesPlanList[event.rowIndex][ms1]);
				console.log("22. i : " + i + ", ms1 : " + ms1 + ", value : " + salesPlanList[event.rowIndex][ms1]);
			}
		}
		salesPlanList[event.rowIndex]["m1"]	= m1;
		AUIGrid.setCellValue(myGridID, event.rowIndex, "m1", m1);
	}
}

//	set plan info
function fnSetSalesPlanInfo(result) {
	console.log(result);
	for ( var i = 0 ; i < result.length ; i++ ) {
		if ( "DST" == result[i].team ) {
			$("#planId1").val(result[i].planId);
			$("#planStusId1").val(result[i].planStusId);
			$("#crtDt1").val(result[i].crtDt);
			$("#planTeam1").text(result[i].team);
			$("#planStatus1").text(result[i].planStusNm);
			$("#planCreatedAt1").text(result[i].crtDt);
		} else if ( "CODY" == result[i].team ) {
			$("#planId2").val(result[i].planId);
			$("#planStusId2").val(result[i].planStusId);
			$("#crtDt2").val(result[i].crtDt);
			$("#planTeam2").text(result[i].team);
			$("#planStatus2").text(result[i].planStusNm);
			$("#planCreatedAt2").text(result[i].crtDt);
		} else if ( "CS" == result[i].team ) {
			$("#planId3").val(result[i].planId);
			$("#planStusId3").val(result[i].planStusId);
			$("#crtDt3").val(result[i].crtDt);
			$("#planTeam3").text(result[i].team);
			$("#planStatus3").text(result[i].planStusNm);
			$("#planCreatedAt3").text(result[i].crtDt);
		}
	}
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

//	button Control
function fnBtnCtrl(header, result) {
	var scmTeamCbBox	= $("#scmTeamCbBox").val();
	var planId1	= $("#planId1").val();	var planStusId1	= $("#planStusId1").val();	//	DST
	var planId2	= $("#planId2").val();	var planStusId2	= $("#planStusId2").val();	//	CODY
	var planId3	= $("#planId3").val();	var planStusId1	= $("#planStusId3").val();	//	CS
	
	if ( null == result ) {
		$("#btnCreate").addClass("btn_disabled");
		$("#btnSave").addClass("btn_disabled");
		$("#btnConfirm").addClass("btn_disabled");
		$("#btnUnconfirm").addClass("btn_disabled");
		$("#btnExcel").addClass("btn_disabled");
	} else {
		if ( "" == scmTeamCbBox ) {
			$("#btnCreate").addClass("btn_disabled");
			$("#btnSave").removeClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			$("#btnExcel").removeClass("btn_disabled");
		} else if ( "DST" == scmTeamCbBox ) {
			if ( 1 == planStusId1 || "1" == planStusId1 ) {
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").removeClass("btn_disabled");
				$("#btnConfirm").removeClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				$("#btnExcel").removeClass("btn_disabled");
			} else if ( 4 == planStusId1 || "4" == planStusId1 ) {
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").removeClass("btn_disabled");
				$("#btnExcel").removeClass("btn_disabled");
			} else {
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				$("#btnExcel").addClass("btn_disabled");
			}
		} else if ( "CODY" == scmTeamCbBox ) {
			$("#btnCreate").addClass("btn_disabled");
			$("#btnSave").removeClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			$("#btnExcel").removeClass("btn_disabled");
		} else if ( "CS" == scmTeamCbBox ) {
			$("#btnCreate").addClass("btn_disabled");
			$("#btnSave").removeClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			$("#btnExcel").removeClass("btn_disabled");
		}
	}
}

//	Event
function fnScmWeekCbBoxChange(object) {
	gWeekTh	= object.value;
}

//	Grid
var myGridID;
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
			<input type="hidden" id="planId" name="planId" value=""/>			<!-- for confirm/unconfirm -->
			<input type="hidden" id="planStusId" name="planStusId" value=""/>	<!-- for confirm/unconfirm -->
			<input type="hidden" id="planId1" name="planId1" value=""/>
			<input type="hidden" id="planId2" name="planId2" value=""/>
			<input type="hidden" id="planId3" name="planId3" value=""/>
			<input type="hidden" id="planStusId1" name="planStusId1" value=""/>
			<input type="hidden" id="planStusId2" name="planStusId2" value=""/>
			<input type="hidden" id="planStusId3" name="planStusId3" value=""/>
			<input type="hidden" id="crtDt1" name="crtDt1" value=""/>
			<input type="hidden" id="crtDt2" name="crtDt2" value=""/>
			<input type="hidden" id="crtDt3" name="crtDt3" value=""/>
			<input type="hidden" id="planMonth" name="planMonth" value=""/>
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
						<th scope="row">Stock</th>
						<td colspan="3">
							<input class="w100p" type="text" id="scmStockCode" name="scmStockCode" onkeypress="if(event.keyCode==13) {fnSalesPlanHeader(); return false;}">
						</td>
					</tr>
					<tr>
						<th scope="row">Team</th>
						<td>
							<select class="w100p" id="scmTeamCbBox" name="scmTeamCbBox"></select>
						</td>
						<th scope="row">Category</th>
						<td>
							<select class="w100p" id="scmStockCategoryCbBox" multiple="multiple" name="scmStockCategoryCbBox"></select>
						</td>
						<th scope="row">Type</th>
						<td>
							<!-- <select class="multy_select w100p" multiple="multiple" id="scmStockCodeCbBox" name="scmStockCodeCbBox"></select> -->
							<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
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
		<ul class="right_btns">
			<li><p id="btnCreate" class="btn_grid"><a onclick="fnCreate(this);">Create</a></p></li>
			<li><p id="btnSave" class="btn_grid"><a onclick="fnSaveDetail(this);">Save</a></p></li>
			<li><p id="btnConfirm" class="btn_grid"><a onclick="fnSaveMaster(this, 'confirm');">Confirm</a></p></li>
			<li><p id="btnUnconfirm" class="btn_grid"><a onclick="fnSaveMaster(this, 'unconfirm');">UnConfirm</a></p></li>
			<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'SalesPlanManagement');">Excel</a></p></li>
			<!-- <li><p id='btnExcel'  class="btn_grid btn_disabled"><a onclick="fnExcel(this,'SalesPlanManagement');">Download</a></p></li> -->
		</ul>
		
		<table class="type1 mt10"><!-- table start -->
			<caption>table</caption>
			<colgroup>
				<col style="width:90px" />
				<col style="width:*" />
				<col style="width:60px" />
				<col style="width:*" />
				<col style="width:60px" />
				<col style="width:*" />
				<col style="width:60px" />
				<col style="width:*" />
				<col style="width:120px" />
				<col style="width:90px" />
				<col style="width:160px" />
				<col style="width:150px" />
			</colgroup>
			<tbody>
				<tr><!-- Team DST -->
					<!-- <th scope="row">Year</th><td><span id="planYear1"></span></td>
					<th scope="row">Month</th><td><span id="planMonth1"></span></td>
					<th scope="row">Week</th><td><span id="planWeek1"></span></td> -->
					<th scope="row">Team</th><td colspan="3"><span id="planTeam1"></span></td>
					<th scope="row">Status</th><td colspan="3"><span id="planStatus1"></span></td>
					<th scope="row">Created At</th><td colspan="3"><span id="planCreatedAt1"></span></td>
					<!-- <th scope="row">Last Updated At</th><td><span id="lastUpdatedAt1"></span></td> -->
				</tr>
				<tr><!-- Team CODY -->
					<!-- <th scope="row">Year</th><td><span id="planYear2"></span></td>
					<th scope="row">Month</th><td><span id="planMonth2"></span></td>
					<th scope="row">Week</th><td><span id="planWeek2"></span></td> -->
					<th scope="row">Team</th><td colspan="3"><span id="planTeam2"></span></td>
					<th scope="row">Status</th><td colspan="3"><span id="planStatus2"></span></td>
					<th scope="row">Created At</th><td colspan="3"><span id="planCreatedAt2"></span></td>
					<!-- <th scope="row">Last Updated At</th><td><span id="lastUpdatedAt2"></span></td> -->
				</tr>
				<tr><!-- Team CS -->
					<!-- <th scope="row">Year</th><td><span id="planYear3"></span></td>
					<th scope="row">Month</th><td><span id="planMonth3"></span></td>
					<th scope="row">Week</th><td><span id="planWeek3"></span></td> -->
					<th scope="row">Team</th><td colspan="3"><span id="planTeam3"></span></td>
					<th scope="row">Status</th><td colspan="3"><span id="planStatus3"></span></td>
					<th scope="row">Created At</th><td colspan="3"><span id="planCreatedAt3"></span></td>
					<!-- <th scope="row">Last Updated At</th><td><span id="lastUpdatedAt3"></span></td> -->
				</tr>
			</tbody>
		</table><!-- table end -->
		
		<br/>
		
		<article class="grid_wrap"><!-- grid_wrap start -->
			<!-- 그리드 영역 2-->
			<div id="dynamic_DetailGrid_wrap" style="height:600px;"></div>
		</article><!-- grid_wrap end -->
	</section><!-- search_result end -->
</section><!-- content end -->