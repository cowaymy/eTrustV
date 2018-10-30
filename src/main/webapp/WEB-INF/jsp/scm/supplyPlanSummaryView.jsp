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
.my-backColumn0 {
	background:#73EAA8;
	color:#000;
	text-align:right;
}
.my-backColumn1 {
	background:#1E9E9E;
	color:#000;
	text-align:right;
}
.my-header {
	background:#828282;
	color:#000;
}
</style>

<script type="text/javaScript">
var gWeekThValue	= "";

$(function() {
	fnScmYearCbBox();		//fnSelectExcuteYear
	fnScmWeekCbBox();		//fnSelectPeriodReset
	//fnScmCdcCbBox();		//fnSelectCDCComboList : 349
	fnScmStockTypeCbBox();	//fnSelectStockTypeComboList : 15
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

//	excel
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	GridCommon.exportTo("#dynamic_DetailGrid_wrap", "xlsx", fileName + $("#scmWeekCbBox").val());
}

//	search
function fnSearch() {
	var params	= {
			scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects")
		};
		
		params	= $.extend($("#MainForm").serializeJSON(), params);
		
		Common.ajax("POST"
				, "/scm/selectSupplyPlanSummaryList.do"
				, params
				, function(result) {
					//console.log("Success fnSearch : " + result.length);
					console.log(result);
					
					AUIGrid.setGridData(myGridID, result.selectSupplyPlanSummaryList);
					
					//	set result list to object
					//supplyPlanList	= result.selectSupplyPlanList;
				});
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
		showRowNumColumn : false,
		editable : false,
		showStateColumn : true,
		//showEditedCellMarker : true,
		//enableCellMerge : true,
		fixedColumnCount : weekStartCol,	//	고정칼럼 카운트 지정
		//enableRestore : true,
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

/****************************  Form Ready ******************************************/

var myGridID;

$(document).ready(function() {
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
<h2>Supply Plan Summary View</h2>
	<ul class="right_btns">
		<li><p class="btn_blue"><a onclick="fnSupplyPlanHeader();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
	<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:160px" />
			<col style="width:*" />
			<col style="width:90px" />
			<col style="width:*" />
			<col style="width:120px" />
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
<ul class="right_btns">
	<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'SupplyPlanSummary');">Excel</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
	<!-- 그리드 영역 -->
	<div id="dynamic_DetailGrid_wrap" style="height:700px;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li>
		<p class="btn_blue2 big">
			<!--   <a href="javascript:void(0);">Download Raw Data</a> -->
		</p>
	</li>
</ul>
</section><!-- search_result end -->
</section><!-- content end -->