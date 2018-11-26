<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<link href="${pageContext.request.contextPath}/resources/css/select2.min.css" rel="stylesheet">
<script src ="${pageContext.request.contextPath}/resources/js/select2.min.js" type="text/javascript"></script>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align:right;
	margin-top:-20px;
}
.aui-grid-drop-list-ul {
	text-align:left;
}
.my-backColumn2 {
	text-align:right;
	background:#a1a2a3;
	color:#000;
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
.my-columnRight0 {
	text-align : right;
	background : #CCFFFF;
	color : #000;
}
.my-columnCenter0 {
	text-align : center;
	background : #CCFFFF;
	color : #000;
}
.my-columnLeft0 {
	text-align : left;
	background : #CCFFFF;
	color : #000;
}
.my-columnRight1 {
	text-align : right;
	background : #CCCCFF;
	color : #000;
}
.my-columnCenter1 {
	text-align : center;
	background : #CCCCFF;
	color : #000;
}
.my-columnLeft1 {
	text-align : left;
	background : #CCCCFF;
	color : #000;
}
</style>

<script type="text/javaScript">
var keyValueList	= new Array();
var format	= /^(19[7-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
var gridDataLength	= 0;

$(function() {
	fnScmStockCategoryCbBox();
	fnScmStockTypeCbBox();
	fnScmStockCbBox();
	doGetComboAndGroup2("/scm/selectScmStockCodeForMulti.do", "", "", "scmStockCodeCbBox", "M", "");
	$(".js-example-basic-multiple").select2();
});

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

//	stock code for default stock
function fnScmStockCbBox() {
	Common.ajaxSync("GET"
					, "/scm/selectScmStockCode.do"
					, $("#MainForm").serialize()
					, function(result) {
						for ( var i = 0 ; i < result.length ; i++ ) {
							var list	= new Object();
							list.id	= result[i].id;
							list.name	= result[i].name;
							keyValueList.push(list);
						}
					});
	return	keyValueList;
}

//	search
function fnSearch() {
	AUIGrid.clearGridData(myGridID);
	
	//	search parameters
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects"),
		scmStockCategoryCbBox : $("#scmStockCategoryCbBox").multipleSelect("getSelects"),
		scmStockCodeCbBox : $("#scmStockCodeCbBox").val()
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectScmMasterList.do"
			, params
			, function(result) {
				console.log(result);
				AUIGrid.setGridData(myGridID, result.selectScmMasterList);
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : "	+ jqXHR.status);
					console.log("code : "			+ jqXHR.responseJSON.code);
					console.log("message : "		+ jqXHR.responseJSON.message);
					console.log("detailMessage : "	+ jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			});
}

//	save
function fnSave() {
	if ( false == fnValidation() ) {
		fnSearchBtnList() ;
		return	false;
	}
	
	Common.ajax("POST"
			, "/scm/saveScmMaster.do"
			, GridCommon.getEditData(myGridID)
			, function(result) {
				Common.alert(result.data + "<spring:message code='sys.msg.savedCnt'/>");
				fnSearch() ;
				
				console.log("Success : " + JSON.stringify(result));
				console.log("data : " + result.data);
			}
			, function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("Fail Status : "	+ jqXHR.status);
					console.log("code : "			+ jqXHR.responseJSON.code);
					console.log("message : "		+ jqXHR.responseJSON.message);
					console.log("detailMessage : "	+ jqXHR.responseJSON.detailMessage);
				} catch ( e ) {
					console.log(e);
				}
				
				Common.alert("Fail : " + jqXHR.responseJSON.message);
			
			});
}

//	validation
function fnValidation() {
	var result	= true;
	var addList	= AUIGrid.getAddedRowItems(myGridID);
	var updList	= AUIGrid.getEditedRowItems(myGridID);
	var delList	= AUIGrid.getRemovedItems(myGridID);
	
	if ( 0 == addList.length && 0 == updList.length && 0 == delList.length ) {
		Common.alert("No Change");
		return	false;
	}
}

//	date validation
function isValidDate(param) {
	console.log("param: " + param);	//	03-07-2017
	var succDate	= "";
	var day		= Number(param.split("\/")[0]);
	var month	= Number(param.split("\/")[1]);
	var year	= Number(param.split("\/")[2]);
	
	if ( 1 > month || 12 < month ) {
		console.log("error1");
		return	succDate;
	}
	
	var maxDaysInMonth	= [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	var maxDay	= maxDaysInMonth[month-1];
	
	//	윤년 체크
	if ( 2 == month && (0 == year%4 && 0 != year%100 || 0 == year%400) ) {
		maxDay	= 29;
	}
	
	if ( 0 >= day || maxDay < day ) {
		console.log("error2");
		return	succDate;
	}
	
	if ( 1 == String(day).length ) {
		day = "0" + day;
	}
	
	if ( 1 == String(month).length ) {
		month = "0" + month;
	}
	
	succDate	= (day + "-" + month + "-" + year);
	
	return	succDate;
}

function fnEventHandler(event) {
	if ( "cellEditBegin" == event.type ) {
		console.log("Click_에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	} else if ( "cellEditEnd" == event.type ) {
		console.log("Click_에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
		
		if ( "Start" == event.headerText ) {
			if ( AUIGrid.formatDate(AUIGrid.getCellValue(myGridID, event.rowIndex, "endDt"), "yyyymmdd") < AUIGrid.formatDate(AUIGrid.getCellValue(myGridID, event.rowIndex, "startDt"), "yyyymmdd") ) {
				Common.alert("<spring:message code='sys.msg.limitMore' arguments='START DATE ; END DATE.' htmlEscape='false' argumentSeparator=';'/>");
				AUIGrid.restoreEditedCells(myGridID, [event.rowIndex, "startDt"] );
				return	false;
			}
		}
		
		if ( "End" == event.headerText ) {
			if ( AUIGrid.formatDate(AUIGrid.getCellValue(myGridID, event.rowIndex, "endDt"), "yyyymmdd") < AUIGrid.formatDate(AUIGrid.getCellValue(myGridID, event.rowIndex, "startDt"), "yyyymmdd") ) {
				Common.alert("<spring:message code='sys.msg.limitMore' arguments='START DATE ; END DATE.' htmlEscape='false' argumentSeparator=';'/>");
				AUIGrid.restoreEditedCells(myGridID, [event.rowIndex, "endDt"] );
				return	false;
			}
		}
		console.log("headerText : " + event.headerText);
		if ( "Target" == event.headerText ) {
			
			var chkedItems	= AUIGrid.getItemsByValue(myGridID, "isTrget", "1");
			if ( chkedItems.length != gridDataLength ) {
				document.getElementById("isTrget").checked	= false;
			} else if ( chkedItems.length == gridDataLength ) {
				document.getElementById("isTrget").checked	= true;
			}
		}
	} else if ( "cellEditCancel" == event.type ) {
		console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	}
}

function headerClickHandler(event) {
	console.log("event.dataField : " + event.dataField);
	if ( "isTrget" == event.dataField ) {console.log("event.orgEvent.target.id : " + event.orgEvent.target.id);
		if ( "isTrget" == event.orgEvent.target.id ) {
			var isChked	= document.getElementById("isTrget").checked;
			checkAll(isChked);
		}
		return	false;
	}
}

function checkAll(isChked) {
	console.log("isChked : " + isChked);
	if ( isChked ) {
		AUIGrid.updateAllToValue(myGridID, "isTrget", "1");
	} else {
		AUIGrid.updateAllToValue(myGridID, "isTrget", "0");
	}
}

function getItemsByField() {
	var activeItems	= AUIGrid.getItemsByValue(myGridID, "isTrget", "1");
	
	alert("Acitve 체크 개수 : " + activeItems.length);
}

/*************************************
**********  Grid-LayOut  ************
*************************************/
var masterManagerLayout	=
	[
		{
			//	Stock
			headerText : "<spring:message code='sys.scm.mastermanager.Stock'/>",
			width : "45%",
			usePaging : true,
			children :
				[
					{
						dataField : "stockId",
						headerText : "Stock Id",
						visible : false
					}, {
						dataField : "isNew",
						headerText : "Is New",
						visible : false
					}, {
						dataField : "typeId",
						headerText : "Type Id",
						visible : false
					}, {
						dataField : "type",
						headerText : "Type",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, {
						dataField : "categoryId",
						headerText : "Category Id",
						visible : false
					}, {
						dataField : "category",
						headerText : "Category",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, {
						dataField : "stockCode",
						headerText : "Code",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, {
						dataField : "stockDesc",
						headerText : "Name",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnLeft1";
							} else {
								return	"my-columnLeft";
							}
						}
					}, {
						dataField : "dfltStock",
						headerText : "Default Stock",
						renderer : {
							type : "DropDownListRenderer",
							showEditorBtnOver : true,
							listFunction : function(rowIndex, columnIndex, item, dataField) {
								return	keyValueList;
							},
							keyField : "id",
							valueField : "name"
						},
						labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
							var retStr	= value;
							var iCnt	= keyValueList.length;
							for ( var i = 0 ; i < iCnt ; i++ ) {
								if ( value == keyValueList[i]["id"] ) {
									retStr	= keyValueList[i]["name"];
									break;
								}
							}
							return	retStr;
						},
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnLeft1";
							} else {
								return	"my-columnLeft";
							}
						}
					}
				]
		}, {
			//	Sales Plan
			headerText : "<spring:message code='sys.scm.mastermanager.SalesPlan'/>",
			width : "20%",
			children :
				[
					{
						dataField : "isTrget",
						headerText : "<spring:message code='sys.scm.mastermanager.Target'/><br/><input type='checkbox' id='isTrget' style='width:15px;height:15px;'>",
						renderer : {
							type : "CheckBoxEditRenderer",
							showLabel : false,	//	참, 거짓 텍스트 출력여부( 기본값 false )
							editable : true,	//	체크박스 편집 활성화 여부(기본값 : false)
							checkValue : "1",	//	true, false 인 경우가 기본
							unCheckValue : "0"
						},
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, {
						dataField : "memo",
						headerText : "Memo",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnLeft1";
							} else {
								return	"my-columnLeft";
							}
						}
					}, {
						dataField : "startDt",
						headerText : "<spring:message code='sys.scm.mastermanager.Start'/>",
						dataType : "date",
						formatString : "dd-mm-yyyy",
						editRenderer : {
							type : "CalendarRenderer",
							defaultFormat : "mm/dd/yyyy",	//	원래 데이터 날짜 포맷과 일치 시키세요. (기본값: "yyyy/mm/dd")
							showEditorBtnOver : true,		//	마우스 오버 시 에디터버턴 출력 여부
							onlyCalendar : false,			//	사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
							showExtraDays : true,			//	지난 달, 다음 달 여분의 날짜(days) 출력
							validator : function(oldValue, newValue, rowItem) {
								//	에디팅 유효성 검사
								console.log("rowItem: " + JSON.stringify(rowItem));
								console.log("rowItem.endDt: " + rowItem.endDt);
								
								var date, isValid	= true;
								if ( isNaN(Number(newValue)) ) {
									//	20160201 형태 또는 그냥 1, 2 로 입력한 경우는 허락함.
									if ( isNaN(Date.parse(newValue)) ) {
										//	그냥 막 입력한 경우 인지 조사. 즉, JS 가 Date 로 파싱할 수 있는 형식인지 조사
										isValid	= false;
									} else {
										if ( 8 != newValue.length ) {
											isValid	= false;
										}
										isValid	= true;
									}
								}
								
								//	리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
								return { "validate" : isValid, "message"  : " Type In 'yyyymmdd' Input." };
							}
						},
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, {
						dataField : "endDt",
						headerText : "<spring:message code='sys.scm.mastermanager.End'/>",
						dataType : "date",
						formatString : "dd-mm-yyyy",
						editRenderer : {
							type : "CalendarRenderer",
							defaultFormat : "mm/dd/yyyy",	//	원래 데이터 날짜 포맷과 일치 시키세요. (기본값: "yyyy/mm/dd")
							showEditorBtnOver : true,		//	마우스 오버 시 에디터버턴 출력 여부
							onlyCalendar : true,			//	사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
							showExtraDays : true,			//	지난 달, 다음 달 여분의 날짜(days) 출력
							validator : function(oldValue, newValue, rowItem) {
								//	에디팅 유효성 검사
								var date, isValid	= true;
								if ( isNaN(Number(newValue)) ) {
									//	20160201 형태 또는 그냥 1, 2 로 입력한 경우는 허락함.
									if ( isNaN(Date.parse(newValue)) ) {
										//	그냥 막 입력한 경우 인지 조사. 즉, JS 가 Date 로 파싱할 수 있는 형식인지 조사
										isValid	= false;
									} else {
										isValid	= true;
									}
								}
								
								//	리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
								return { "validate" : isValid, "message"  : " Type In 'yyyyMMdd' Input." };
							}
						},
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}
				]
		},
		{
			//	Supply Plan
			headerText : "<spring:message code='sys.scm.mastermanager.SupplyPlan'/>",
			//	width : "45%",
			children :
				[
					{
						//	Supply Plan Target
						headerText : "<spring:message code='sys.scm.mastermanager.SupplyPlanTarget'/>",
						
						children :
							[
								{
									dataField : "klTarget",
									headerText : "<spring:message code='sys.scm.mastermanager.KL'/>",
									renderer : {
										type : "CheckBoxEditRenderer",
										showLabel : false,	//	참, 거짓 텍스트 출력여부( 기본값 false )
										editable : true,	//	체크박스 편집 활성화 여부(기본값 : false)
										checkValue : "1",	//	true, false 인 경우가 기본
										unCheckValue : "0"
									},
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "kkTarget",
									headerText : "<spring:message code='sys.scm.mastermanager.KK'/>",
									renderer : {
										type : "CheckBoxEditRenderer",
										showLabel  : false,	//	참, 거짓 텍스트 출력여부( 기본값 false )
										editable   : true,	//	체크박스 편집 활성화 여부(기본값 : false)
										checkValue : "1",	//	true, false 인 경우가 기본
										unCheckValue : "0"
									},
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "jbTarget",
									headerText : "<spring:message code='sys.scm.mastermanager.JB'/>",
									renderer : {
										type : "CheckBoxEditRenderer",
										showLabel : false,	//	참, 거짓 텍스트 출력여부( 기본값 false )
										editable : true,	//	체크박스 편집 활성화 여부(기본값 : false)
										checkValue : "1",	//	true, false 인 경우가 기본
										unCheckValue : "0"
									},
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "pnTarget",
									headerText : "<spring:message code='sys.scm.mastermanager.PN'/>",
									renderer : {
										type : "CheckBoxEditRenderer",
										showLabel : false,	//	참, 거짓 텍스트 출력여부( 기본값 false )
										editable : true,	//	체크박스 편집 활성화 여부(기본값 : false)
										checkValue : "1",	//	true, false 인 경우가 기본
										unCheckValue : "0"
									},
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "kcTarget",
									headerText : "<spring:message code='sys.scm.mastermanager.KC'/>",
									renderer : {
										type : "CheckBoxEditRenderer",
										showLabel : false,	//	참, 거짓 텍스트 출력여부( 기본값 false )
										editable : true,	//	체크박스 편집 활성화 여부(기본값 : false)
										checkValue : "1",	//	true, false 인 경우가 기본
										unCheckValue : "0"
									},
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}
							]
					},
					{
						//	MOQ
						headerText : "<spring:message code='sys.scm.mastermanager.MOQ'/>",
						children :
							[
								{
									dataField : "klMoq",
									headerText : "<spring:message code='sys.scm.mastermanager.KL'/>",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "kkMoq",
									headerText : "<spring:message code='sys.scm.mastermanager.KK'/>",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "jbMoq",
									headerText : "<spring:message code='sys.scm.mastermanager.JB'/>",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "pnMoq",
									headerText : "<spring:message code='sys.scm.mastermanager.PN'/>",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}, {
									dataField : "kcMoq",
									headerText : "<spring:message code='sys.scm.mastermanager.KC'/>",
									styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
										if ( 1 == item.isNew ) {
											return	"my-columnCenter1";
										} else {
											return	"my-columnCenter";
										}
									}
								}
							]
					},
					{
						//	S.Stk
						dataField : "safetyStock",
						headerText : "<spring:message code='sys.scm.mastermanager.SStk'/>",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, {
						dataField : "leadTm",
						headerText : "<spring:message code='sys.scm.mastermanager.LTime'/>",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, /*{
						dataField : "loadingQty",
						headerText : "<spring:message code='sys.scm.mastermanager.LQty'/>",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnCenter1";
							} else {
								return	"my-columnCenter";
							}
						}
					}, */{
						dataField : "formatStartDate",
						headerText : "formatStartDate",
						visible : false
					}, {
						dataField : "formatEndDate",
						headerText : "formatEndDate",
						visible : false
					}
					]
		}
	];

/****************************  Form Ready ******************************************/
var myGridID

$(document).ready(function() {
	var masterManagerOptions	= {
		usePaging : false,
		useGroupingPanel : false,
		showRowNumColumn : true,	//	그리드 넘버링
		showStateColumn : true,		//	행 상태 칼럼 보이기
		enableRestore : true,
		softRemovePolicy : "exceptNew",	//	사용자추가한 행은 바로 삭제
		pageRowCount : 30,			//	한 화면에 출력되는 행 개수 30개로 지정
		fixedColumnCount : 9,
	};
	
	//	masterGrid 그리드를 생성합니다.
	myGridID	= GridCommon.createAUIGrid("#masterManagerDiv", masterManagerLayout, "", masterManagerOptions);
	
	AUIGrid.bind(myGridID, "cellEditBegin", fnEventHandler);	//	에디팅 시작 이벤트 바인딩
	AUIGrid.bind(myGridID, "cellEditEnd", fnEventHandler);		//	에디팅 정상 종료 이벤트 바인딩
	AUIGrid.bind(myGridID, "cellEditCancel", fnEventHandler);	//	에디팅 취소 이벤트 바인딩
	//	cellClick event.
	AUIGrid.bind(myGridID, "cellClick", function(event) {
		gSelRowIdx	= event.rowIndex;
	});
	//	셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
		console.log("DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );		
	});
	//AUIGrid.bind(myGridID, "rowAllCheckClick", function(checked) {
	//	alert("전체 선택  checked : " + checked);
	//});
	AUIGrid.bind(myGridID, "headerClick", headerClickHandler);
	// ready 이벤트 바인딩
	AUIGrid.bind(myGridID, "ready", function(event) {
		gridDataLength	= AUIGrid.getGridData(myGridID).length; // 그리드 전체 행수 보관
	});
});   //$(document).ready
</script>

<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
		<h2>SCM Master Management</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside><!-- title_line end -->
	
	<section class="search_table"><!-- search_table start -->
		<form id="MainForm" method="get" action="">
			<input type ="hidden" id="planMasterId" name="planMasterId" value=""/>
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<!-- <col style="width:140px" />
					<col style="width:*" />
					<col style="width:110px" />
					<col style="width:*" /> -->
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:110px" />
					<col style="width:*" />
					<col style="width:140px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Stock Type</th>
						<td>
							<select multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox" class="w100p">
							</select>
						</td>
						<th scope="row">Stock Category</th>
						<td>
							<select multiple="multiple" id="scmStockCategoryCbBox" name="scmStockCategoryCbBox" class="w100p">
							</select>
						</td>
						<th scope="row">Material</th>
						<td>
							<!-- <input class="w100p" type="text" id="scmStockCode" name="scmStockCode" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}"> -->
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
		<ul class="right_btns">
			<!-- <li><p class="btn_grid"><a onclick="fnAddNewPop();">Add New</a></p></li> -->
			<li><p class="btn_grid"><a onclick="fnSave();">Save</a></p></li>
		</ul>
		<article class="grid_wrap"><!-- grid_wrap start -->
			<!-- 그리드 영역 1-->
			<div id="masterManagerDiv" style="width:100%; height:700px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
		<ul class="center_btns">
			<li>
				<p class="btn_blue2 big">
					<!-- <a href="javascript:void(0);">Download Raw Data</a> -->
				</p>
			</li>
		</ul>
	</section><!-- search_result end -->
</section><!-- content end -->