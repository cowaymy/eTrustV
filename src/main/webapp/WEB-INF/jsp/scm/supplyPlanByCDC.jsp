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
}

.my-backColumn1 {
	background:#1E9E9E;
	color:#000;
}

.my-backColumn2 {
	background:#818284;
	color:#000;
}

.my-backColumn3 {
	background:#a1a2a3;
	color:#000;
}

.my-backColumn4 {
	background : #c0c0c0;
	color : #000;
}

.my-header {
	background:#828282;
	color:#000;
}
</style>

<script type="text/javaScript">
var gWeekTh	= "";
var m0WeekCnt	= 0;
var m1WeekCnt	= 0;
var m2WeekCnt	= 0;
var m3WeekCnt	= 0;
var m4WeekCnt	= 0;
var m0ThWeekStart	= 0;
var m1ThWeekStart	= 0;
var m2ThWeekStart	= 0;
var m3ThWeekStart	= 0;
var m4ThWeekStart	= 0;

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
		fixedColumnCount : 10,			//	고정칼럼 카운트 지정
		enableRestore : true,
		showRowCheckColumn : false,
		usePaging : false				//	페이징처리 설정
	};
	
	Common.ajax("POST"
			, "/scm/selectSupplyPlanHeader.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				
				console.log (result);
				
				//	if selectSupplyPlanHeader result is null then alert
				if ( null == result.selectSupplyPlanHeader || 1 > result.selectSupplyPlanHeader.length ) {
					Common.alert("Supply Plan was not created on this week");
					return	false;
				} else {
					console.log("selectSupplyPlanInfo is not null")
					//fnSetSalesPlanInfo(result.selectSupplyPlanInfo);
				}
				
				//	if selectSplitInfo result is null then alert
				if ( null == result.selectSplitInfo || 1 > result.selectSplitInfo.length ) {
					Common.alert("Supply Plan was not created on this week");
					return	false;
				}
				
				//	if selectChildField result is null then alert
				if ( null == result.selectChildField || 1 > result.selectChildField.length ) {
					Common.alert("Supply Plan was not created on this week");
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
										 visible : true
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].planDtlId,
										 headerText : "Plan Dtl Id",
										 visible : true
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].stock,
										 headerText : "Stock",
										 visible : true
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].cdc,
										 headerText : "Cdc",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].planStusId,
										 headerText : "Plan Stus Id",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].verNo,
										 headerText : "Ver No",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].typeId,
										 headerText : "Type Id",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].typeName,
										 headerText : "Type",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].categoryId,
										 headerText : "Category Id",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].categoryName,
										 headerText : "Category",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].code,
										 headerText : "Code",
										 visible : true,
										 style : "my-backColumn4"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].name,
										 headerText : "Name",
										 visible : true,
										 style : "my-backColumn3"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].psiId,
										 headerText : "Psi Id",
										 visible : true,
										 style : "my-backColumn3"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].psiName,
										 headerText : "Psi",
										 visible : true,
										 style : "my-backColumn3"
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
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m1,
										 headerText : "M + 1",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m2,
										 headerText : "M + 2",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m3,
										 headerText : "M + 3",
										 visible : true,
										 style : "my-backColumn3",
										 dataType : "numeric",
										 formatString : "#,##0"
									 }, {
										 dataField : result.selectSupplyPlanHeader[0].m4,
										 headerText : "M + 4",
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
								headerText : result.selectSupplyPlanHeader[0][fieldStr],
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
								headerText : result.selectSupplyPlanHeader[0][fieldStr],
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
								headerText : result.selectSupplyPlanHeader[0][fieldStr],
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
							headerText :  result.selectSupplyPlanHeader[0][fieldStr],
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
							headerText :  result.selectSupplyPlanHeader[0][fieldStr],
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
							headerText :  result.selectSupplyPlanHeader[0][fieldStr],
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
							headerText :  result.selectSupplyPlanHeader[0][fieldStr],
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
						//console.log("name : " + event.dataField);
						//console.log("columnIndex : " + event.columnIndex + ", rowIndex : " + event.rowIndex + ", dataField Name : " + AUIGrid.getDataFieldByColumnIndex(event.columnIndex));
					});
					AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
						//console.log("DobleClick(" + event.rowIndex + ", " + event.columnIndex + ") :  " + " value : " + event.value );
					});
					//AUIGrid.bind(myGridID, "cellEditEnd", fnSumMnPlan);
					
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

//	confirm
/*
function fnSaveMaster(obj, conf) {
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	
	if ( 1 > $("#scmCdcCbBox").val().length ) {
		Common.alert("<spring:message code='sys.msg.necessary' arguments='CDC' htmlEscape='false'/>");
		return	false;
	}
	
	//	set planId
	
	var msg	= "";
	//	set planStusId
	
	Common.ajax("POST"
			, "/scm/updateSupplyPlanMaster.do"
			, $("#MainForm").serializeJSON()
			, function(result) {
				//Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
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
*/

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
						<p><span id ="cir_sales" class="circle circle_grey"></span> Sales</p>
						<p><span id ="cir_save" class="circle circle_grey"></span> Plan Save</p>
						<p><span id ="cir_cinfirm" class="circle circle_grey"></span> Confirm</p>
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
			<li><p id="btnConfirm" class="btn_grid btn_disabled"><a onclick="fnSaveMaster(this);">Confirm</a></p></li>
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