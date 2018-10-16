<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
	text-align:left;
}

/* 커스텀 칼럼 스타일 정의 */
.my-columnEditable {
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

.my-columnLeadTm {
	text-align : right;
	background : #FFCCFF;
	color : #000;
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

.my-header {
	background:#828282;
	color:#000;
}
</style>

<script type="text/javaScript">
var gWeekTh	= "";
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
var supplyPlanList	= new Object();
var childField	= new Object();
var splitInfo	= new Object();
var planId	= "";
var weekStartCol	= 19;	//	w01 칼럼이 시작되는 column 차례 : 19번째 이전에 칼럼이 추가되면 변경해줘야 함

$(function() {
	fnScmYearCbBox();		//fnSelectExcuteYear
	fnScmWeekCbBox();		//fnSelectPeriodReset
	fnScmCdcCbBox();		//fnSelectCDCComboList : 349
	fnScmStockTypeCbBox();	//fnSelectStockTypeComboList : 15
	//fnScmStockCodeCbBox();	//fnSetStockComboBox
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

//	Cdc
function fnScmCdcCbBox() {
	CommonCombo.make("scmCdcCbBox"
			, "/scm/selectScmCdc.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				chooseMessage : "Select a CDC"
			}
			, "");
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

//	supply plan header
function fnSupplyPlanHeader() {
	if ( 1 > $("#scmYearCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Year' htmlEscape='false'/>");
		return	false;
	}
	if ( 1 > $("#scmWeekCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='Week' htmlEscape='false'/>");
		return	false;
	}
	if ( 1 > $("#scmCdcCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='CDC' htmlEscape='false'/>");
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
		fixedColumnCount : weekStartCol,	//	고정칼럼 카운트 지정
		enableRestore : true,
		showRowCheckColumn : false,
		usePaging : false					//	페이징처리 설정
	};
	
	Common.ajax("POST"
			, "/scm/selectSupplyPlanHeader.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				
				console.log (result);
				
				//	if selectSupplyPlanHeader result is null then alert
				if ( null == result.selectSupplyPlanInfo || 1 > result.selectSupplyPlanInfo.length ) {
					fnBtnCtrl(result.selectSupplyPlanInfo);
					Common.alert("Sales Plan must be first created on this week");
					return	false;
				} else {
					fnSetSupplyPlanInfo(result.selectSupplyPlanInfo);
					console.log("selectSupplyPlanInfo is not null")
					//fnSetSalesPlanInfo(result.selectSupplyPlanInfo);
				}
				
				//	if selectTotalSplitInfo result is null then alert
				if ( null == result.selectTotalSplitInfo || 1 > result.selectTotalSplitInfo.length ) {
					Common.alert("Supply Plan was not created on this week2");
					return	false;
				} else {
					splitInfo	= result.selectTotalSplitInfo;
				}
				
				//	if selectChildField result is null then alert
				if ( null == result.selectChildField || 1 > result.selectChildField.length ) {
					Common.alert("Supply Plan was not created on this week3");
					return	false;
				} else {
					childField	= result.selectChildField;
				}
				
				//	if selectSupplyPlanHeader result null then remove grid
				if ( null == result.selectSupplyPlanHeader || 1 > result.selectSupplyPlanHeader.length ) {
					if ( AUIGrid.isCreated(myGridID) ) {
						AUIGrid.destroy(myGridID);
					}
					
					return	false;
				}
				
				var leadTm		= result.selectTotalSplitInfo[0].leadTm;
				var planWeekTh	= result.selectTotalSplitInfo[0].planWeekTh;
				var splitCnt	= result.selectTotalSplitInfo[0].splitCnt;
				leadTm	= parseInt(leadTm) + parseInt(planWeekTh) + parseInt(splitCnt);
				//console.log("===leadTm : " + leadTm);
				//	make header
				if ( null != result.selectSupplyPlanHeader && 0 < result.selectSupplyPlanHeader.length ) {
					dynamicLayout.push(
							{
								headerText : "Stock",
								children :
									[
									 {
										 dataField : result.selectSupplyPlanHeader[0].planId,
										 headerText : "Plan Id",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].planDtlId,
										 headerText : "Plan Dtl Id",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].cdc,
										 headerText : "Cdc",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].planStusId,
										 headerText : "Plan Stus Id",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].verNo,
										 headerText : "Ver No",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].typeId,
										 headerText : "Type Id",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].typeName,
										 headerText : "Type",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnCenter0";
											 } else {
												 return	"my-columnCenter1";
											 }
										 }
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].categoryId,
										 headerText : "Category Id",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].categoryName,
										 headerText : "Category",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnCenter0";
											 } else {
												 return	"my-columnCenter1";
											 }
										 }
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].code,
										 headerText : "Code",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnCenter0";
											 } else {
												 return	"my-columnCenter1";
											 }
										 }
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].name,
										 headerText : "Name",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnLeft0";
											 } else {
												 return	"my-columnLeft1";
											 }
										 }
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].psiId,
										 headerText : "Psi Id",
										 visible : false
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].psiName,
										 headerText : "Psi",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnLeft0";
											 } else {
												 return	"my-columnLeft1";
											 }
										 }
									 }
									 ]
							}, {
								headerText : "Monthly",
								children :
									[
									 {
										 dataField : result.selectSupplyPlanHeader[0].m0,
										 headerText : "M + 0",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnRight0";
											 } else {
												 return	"my-columnRight1";
											 }
										 },
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m1,
										 headerText : "M + 1",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnRight0";
											 } else {
												 return	"my-columnRight1";
											 }
										 },
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m2,
										 headerText : "M + 2",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnRight0";
											 } else {
												 return	"my-columnRight1";
											 }
										 },
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m3,
										 headerText : "M + 3",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnRight0";
											 } else {
												 return	"my-columnRight1";
											 }
										 },
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m4,
										 headerText : "M + 4",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnRight0";
											 } else {
												 return	"my-columnRight1";
											 }
										 },
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].overdue,
										 headerText : "OVERDUE",
										 visible : true,
										 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
											 if ( "0" == item.divOdd ) {
												 return	"my-columnRight0";
											 } else {
												 return	"my-columnRight1";
											 }
										 },
										 dataType : "numeric",
										 formatString : "#,##0"
									 }
									 ]
							}
					);
					
					m0WeekCnt	= parseInt(result.selectTotalSplitInfo[0].m0WeekCnt);
					m1WeekCnt	= parseInt(result.selectTotalSplitInfo[0].m1WeekCnt);
					m2WeekCnt	= parseInt(result.selectTotalSplitInfo[0].m2WeekCnt);
					m3WeekCnt	= parseInt(result.selectTotalSplitInfo[0].m3WeekCnt);
					m4WeekCnt	= parseInt(result.selectTotalSplitInfo[0].m4WeekCnt);
					
					m0ThWeekStart	= parseInt(result.selectChildField[0].weekTh);
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
						fieldStr	= "w" + iLoopCnt + "WeekSeq";
						if ( iLoopDataFieldCnt > leadTm ) {
							groupM0.children.push({
								dataField : "w" + intToStrFieldCnt,	//	w00
								headerText : result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( 3 != item.psiId ) {
										if ( "0" == item.divOdd ) {
											return	"my-columnRight0";
										} else {
											return	"my-columnRight1";
										}
									} else {
										return	"my-columnEditable";
									}
								}
							});
						} else {
							groupM0.children.push({
								dataField : "w" + intToStrFieldCnt,	//	w00
								headerText : result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								editable : false,
								style : "my-columnLeadTm"
							});
						}
						iLoopCnt++;
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
						if ( iLoopDataFieldCnt > leadTm ) {
							groupM1.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( 3 != item.psiId ) {
										if ( "0" == item.divOdd ) {
											return	"my-columnRight0";
										} else {
											return	"my-columnRight1";
										}
									} else {
										return	"my-columnEditable";
									}
								}
							});
						} else {
							groupM1.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								editable : false,
								style : "my-columnLeadTm"
							});
						}
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
						if ( iLoopDataFieldCnt > leadTm ) {
							groupM2.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( 3 != item.psiId ) {
										if ( "0" == item.divOdd ) {
											return	"my-columnRight0";
										} else {
											return	"my-columnRight1";
										}
									} else {
										return	"my-columnEditable";
									}
								}
							});
						} else {
							groupM2.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								editable : false,
								style : "my-columnLeadTm"
							});
						}
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
						if ( iLoopDataFieldCnt > leadTm ) {
							groupM3.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( 3 != item.psiId ) {
										if ( "0" == item.divOdd ) {
											return	"my-columnRight0";
										} else {
											return	"my-columnRight1";
										}
									} else {
										return	"my-columnEditable";
									}
								}
							});
						} else {
							groupM3.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								editable : false,
								style : "my-columnLeadTm"
							});
						}
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
						if ( iLoopDataFieldCnt > leadTm ) {
							groupM4.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									if ( 3 != item.psiId ) {
										if ( "0" == item.divOdd ) {
											return	"my-columnRight0";
										} else {
											return	"my-columnRight1";
										}
									} else {
										return	"my-columnEditable";
									}
								}
							});
						} else {
							groupM4.children.push({
								dataField : "w" + intToStrFieldCnt,
								headerText :  result.selectSupplyPlanHeader[0][fieldStr],
								dataType : "numeric",
								formatString : "#,##0",
								style : "my-columnLeadTm"
							});
						}
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
						//console.log("name : " + event.dataField);
						//console.log("columnIndex : " + event.columnIndex + ", rowIndex : " + event.rowIndex + ", dataField Name : " + AUIGrid.getDataFieldByColumnIndex(event.columnIndex));
					});
					AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
						//console.log("DobleClick(" + event.rowIndex + ", " + event.columnIndex + ") :  " + " value : " + event.value );
					});
					AUIGrid.bind(myGridID, "cellEditEnd", fnCalcPsi5);
					AUIGrid.bind(myGridID, "cellEditBegin", function(event) {
						if ( "3" != event.item.psiId ) {
							return	false;
						}
					});
					
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

function fnCalcPsi5(event) {
	var leadTm	= parseInt(supplyPlanList[0]["leadTm"]);
	var weekCnt	= parseInt(splitInfo[0]["m0WeekCnt"]) + parseInt(splitInfo[0].m1WeekCnt) + parseInt(splitInfo[0].m2WeekCnt) + parseInt(splitInfo[0].m3WeekCnt) + parseInt(splitInfo[0].m4WeekCnt);
	//var from	= event.columnIndex;
	//var to		= (parseInt(weekCnt) + parseInt(weekStartCol)) - (event.columnIndex - (parseInt(weekStartCol) + parseInt(leadTm))) - 1; 
	var psi1	= 0;
	var psi3	= 0;
	var psi5	= 0;
	
	var startWeek	= event.columnIndex - weekStartCol + 1;
	
	var psi1Row	= event.rowIndex - 2;
	var psi3Row	= event.rowIndex;
	var psi5Row	= event.rowIndex + 2;
	
	//var chngWeekCnt	= parseInt(to) - parseInt(from);
	var colNm	= "";
	var colNm2	= "";
	var colTh	= "";
	var colTh2	= "";
	for ( var i = startWeek ; i < weekCnt + weekStartCol ; i++ ) {
		if ( i < 10 ) {
			colTh	= "0" + (parseInt(i));
			colTh2	= "0" + (parseInt(i) - 1);
		} else if ( i == 10 ) {
			colTh	= (parseInt(i));
			colTh2	= "0" + (parseInt(i) - 1);
		} else {
			colTh	= (parseInt(i));
			colTh2	= (parseInt(i) - 1);
		}
		colNm	= "w" + colTh;
		colNm2	= "w" + colTh2;
		console.log("i : " + i + ", psi1Row : " + psi1Row + ", psi3Row : " + psi3Row + ", psi5Row : " + psi5Row + ", colNm : " + colNm + ", colNm2 : " + colNm2);
		psi1	= AUIGrid.getCellValue(myGridID, psi1Row, colNm);
		if ( 0 == i ) {
			psi3	= event.value;
		} else {
			psi3	= AUIGrid.getCellValue(myGridID, psi3Row, colNm);
		}
		psi5	= AUIGrid.getCellValue(myGridID, psi5Row, colNm2);
		psi5	= psi5 - psi1 + psi3;
		AUIGrid.setCellValue(myGridID, psi5Row, colNm, psi5);
	}
}

//	search
function fnSearch() {
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects")
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectSupplyPlanList.do"
			, params
			, function(result) {
				//console.log("Success fnSearch : " + result.length);
				console.log(result);
				
				AUIGrid.setGridData(myGridID, result.selectSupplyPlanList);
				
				//	set result list to object
				supplyPlanList	= result.selectSupplyPlanList;
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
	if ( 1 > $("#scmCdcCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='CDC' htmlEscape='false'/>");
		return	false;
	}
	
	var params	= { planStusId : 1 };
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/insertSupplyPlanMaster.do"
			, params
			, function(result) {
				if ( 99 == result.code ) {
					Common.alert("Already Created Sales Plan.");
				} else {
					Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
					fnSupplyPlanHeader();
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
			, "/scm/updateSupplyPlanDetail.do"
			, GridCommon.getEditData(myGridID)
			, function(result) {
				Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
				fnSupplyPlanHeader();
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

//confirm/unconfirm
function fnSaveMaster(obj, conf) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	if ( 1 > $("#scmCdcCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='CDC' htmlEscape='false'/>");
		return	false;
	}
	
	//	set planId
	var planId	= supplyPlanList[0]["planId"];
	var planStusId	= "";
	if ( "confirm" == conf ) {
		planStusId	= "4";
	} else {
		planStusId	= "1";
	}
	var msg	= "";
	var params	= { planId : planId, planStusId : planStusId };
	console.log(params);
	Common.ajax("POST"
			, "/scm/updateSupplyPlanMaster.do"
			, params
			, function(result) {
				Common.alert(msg);
				fnSupplyPlanHeader();
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

//excel
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", fileName + '_' + getTimeStamp());
}

//validation
function fnValidation() {
	var result	= true;
	var updList	= AUIGrid.getEditedRowItems(myGridID);
	
	if ( 0 == updList.length ) {
		Common.alert("No Change");
		result	= false;
	}
	
	return	result;
}

//	set sales & supply info
function fnSetSupplyPlanInfo(result) {
	var salesPlan	= result[0].salesPlanStusId;		//	12(3 Team, Confirm : 4 -> 4 + 4 + 4 = 12) : All Sales Plan Confirmed
	var supplyPlan	= result[0].supplyPlanStusId;		//	4 : Supply Plan Confirm, 1 : Supply Plan Unconfirm
	console.log("circle : salesPlan : " + salesPlan + ", supplyPlan : " + supplyPlan);
	if ( null == result ) {
		console.log("sales, supply grey");
		$("#cirSales").addClass("circle_grey");
		$("#cirSales").removeClass("circle_blue");
		$("#cirSales").removeClass("circle_red");
		$("#cirSupply").addClass("circle_grey");
		$("#cirSupply").removeClass("circle_blue");
		$("#cirSupply").removeClass("circle_red");
	} else {
		if ( 4 == salesPlan || 8 == salesPlan || 12 == salesPlan ) {
			console.log("sales blue");
			$("#cirSales").removeClass("circle_grey");
			$("#cirSales").addClass("circle_blue");
			$("#cirSales").removeClass("circle_red");
			if ( 4 == supplyPlan ) {
				console.log("supply blue");
				$("#cirSupply").removeClass("circle_grey");
				$("#cirSupply").addClass("circle_blue");
				$("#cirSupply").removeClass("circle_red");
			} else if ( 1 == supplyPlan ) {
				console.log("supply red");
				$("#cirSupply").removeClass("circle_grey");
				$("#cirSupply").removeClass("circle_blue");
				$("#cirSupply").addClass("circle_red");
			} else if ( 0 == supplyPlan ) {
				console.log("supply grey");
				$("#cirSupply").addClass("circle_grey");
				$("#cirSupply").removeClass("circle_blue");
				$("#cirSupply").removeClass("circle_red");
			} else {
				console.log("?????????????");
			}
		} else {
			console.log("sales red, supply grey");
			$("#cirSales").removeClass("circle_grey");
			$("#cirSales").removeClass("circle_blue");
			$("#cirSales").addClass("circle_red");
			$("#cirSupply").addClass("circle_grey");
			$("#cirSupply").removeClass("circle_blue");
			$("#cirSupply").removeClass("circle_red");
		}
	}
	fnBtnCtrl(result);
}

//	button control
function fnBtnCtrl(result) {
	var salesPlan	= result[0].salesPlanStusId;		//	12(3 Team, Confirm : 4 -> 4 + 4 + 4 = 12) : All Sales Plan Confirmed
	var supplyPlan	= result[0].supplyPlanStusId;		//	4 : Supply Plan Confirm, 1 : Supply Plan Unconfirm
	console.log("circle : salesPlan : " + salesPlan + ", supplyPlan : " + supplyPlan);
	if ( null == result ) {
		console.log("create");
		$("#btnCreate").removeClass("btn_disabled");
		$("#btnSave").addClass("btn_disabled");
		$("#btnConfirm").addClass("btn_disabled");
		$("#btnUnconfirm").addClass("btn_disabled");
		console.log("1");
	} else {
		//if ( 12 == salesPlan ) {	//	4 * team cnt
		if ( 4 == salesPlan || 8 == salesPlan || 12 == salesPlan ) {
			//	SalesPlan Confirm status
			if ( 4 == supplyPlan ) {
				//	SupplyPlan Confirm Status
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").removeClass("btn_disabled");
				console.log("unconfirm");
			} else if ( 1 == supplyPlan ) {
				//	SupplyPlan Unconfirm Status
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").removeClass("btn_disabled");
				$("#btnConfirm").removeClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				console.log("confirm, save");
			} else if ( 0 == supplyPlan ) {
				//	SupplyPlan Unconfirm Status
				$("#btnCreate").removeClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				console.log("create");
			} else {
				//	error
				$("#btnCreate").addClass("btn_disabled");
				$("#btnSave").addClass("btn_disabled");
				$("#btnConfirm").addClass("btn_disabled");
				$("#btnUnconfirm").addClass("btn_disabled");
				console.log("none1");
			}
		} else {
			//	SalesPlan Unconfirm status
			$("#btnCreate").addClass("btn_disabled");
			$("#btnSave").addClass("btn_disabled");
			$("#btnConfirm").addClass("btn_disabled");
			$("#btnUnconfirm").addClass("btn_disabled");
			console.log("none2");
		}
	}
}
	
//get timestamp
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

//	Grid
var myGridID;
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
<h2>Supply Plan By CDC</h2>
	<ul class="right_btns">
		<li><p class="btn_blue"><a onclick="fnSupplyPlanHeader();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
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
						<select class="sel_date"  id="scmWeekCbBox" name="scmWeekCbBox"></select>
					</div><!-- date_set end -->
				</td>
				<th scope="row">CDC</th>
				<td>
					<select class="w100p" id="scmCdcCbBox" name="scmCdcCbBox"></select>
				</td>
				<th scope="row">Planning Status</th>
				<td>
					<div class="status_result">
						<!-- circle_red, circle_blue, circle_grey -->
						<p><span id ="cirSales" class="circle circle_grey"></span> Sales Plan</p>
						<!-- <p><span id ="cirSave" class="circle circle_grey"></span> Plan Save</p> -->
						<p><span id ="cirSupply" class="circle circle_grey"></span>   Supply Plan</p>
					</div>
				</td>
			</tr>
			<tr>
				<!-- Stock Type 추가 -->
				<th scope="row">Stock Type</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
				</td>
				<th scope="row">Stock</th>
				<td colspan="3">
					<input class="w100p" type="text" id="scmStockCode" name="scmStockCode" onkeypress="if(event.keyCode==13) {fnSupplyPlanHeader(); return false;}">
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
	<div class="side_btns"><!-- side_btns start -->
		<ul class="left_btns">
			<li><p class="btn_grid"><!-- <input type='button' id='SaveBtn' value="Change Selected Items' Status To Saved" disabled /> --></p></li>
			<li><p class="btn_grid"><!-- <input type='button' id='ConfirmBtn' name='ConfirmBtn' value='Confirm' disabled /> --></p></li>
			<li><p class="btn_grid"><!-- <input type='button' id='UpdateBtn' name='UpdateBtn' value='Update M0 Data' disabled /> --></p></li>
		</ul>
		<ul class="right_btns">
			<li><p id="btnCreate" class="btn_grid btn_disabled"><a onclick="fnCreate(this);">Create</a></p></li>
			<li><p id="btnSave" class="btn_grid btn_disabled"><a onclick="fnSaveDetail(this);">Save</a></p></li>
			<li><p id="btnConfirm" class="btn_grid btn_disabled"><a onclick="fnSaveMaster(this, 'confirm');">Confirm</a></p></li>
			<li><p id="btnUnconfirm" class="btn_grid btn_disabled"><a onclick="fnSaveMaster(this, 'unconfirm');">UnConfirm</a></p></li>
			<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'SalesPlanManagement');">Excel</a></p></li>
		</ul>
	</div><!-- side_btns end -->

	<article class="grid_wrap"><!-- grid_wrap start -->
		<!-- 그리드 영역 -->
		<div id="dynamic_DetailGrid_wrap" style="height:700px;"></div>
	</article><!-- grid_wrap end -->

	<ul class="center_btns">
		<li><p class="btn_blue2 big"><!-- <a href="javascript:void(0);">Download Raw Data</a> <a onclick="fnExcelExport('SalesPlanManagement');">Download</a> --></p></li>
	</ul>
</section><!-- search_result end -->

</section><!-- content end -->