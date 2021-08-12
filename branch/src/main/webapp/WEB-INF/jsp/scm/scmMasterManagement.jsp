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
var type61	= new Array();
var type62	= new Array();
var type63	= new Array();
var type64	= new Array();
//var n61	= 0;	int n62	= 0;	int n63	= 0;	int n64	= 0;
var format	= /^(19[7-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
var gridDataLength	= 0;
var gWeekTh	= "";
var gToday	= new Date();
var gYear	= "";
var gMonth	= "";
var gDay	= "";
var gYYYYMMDD	= "";

$(function() {
	fnScmStockCategoryCbBox();
	fnScmStockTypeCbBox();
	fnScmStockCbBox();
	doGetComboAndGroup2("/scm/selectScmStockCodeForMulti.do", "", "", "scmStockCodeCbBox", "M", "");
	$(".js-example-basic-multiple").select2();
	console.log("today : " + gToday);

	gYear	= gToday.getFullYear();
	gMonth	= gToday.getMonth() + 1;
	gDay	= gToday.getDate();
	if ( 10 != gMonth && 11 != gMonth && 12 != gMonth ) {
		gMonth	= "0" + gMonth;
	}
	gYYYYMMDD	= gYear + "" + gMonth + "" + gDay;
	console.log("gYYYYMMDD : " + gYYYYMMDD);
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
							list.type	= result[i].type;
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

				Common.alert("Fail message : " + jqXHR.responseJSON.message +" detailMessage : "  + jqXHR.responseJSON.detailMessage);

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

		if ( "klTarget" == event.dataField ) {
			var items	= AUIGrid.getItemsByValue(myGridID, "klTarget", "1");
			if ( gridDataLength != items.length ) {
				document.getElementById("klTarget").checked	= false;
			} else if ( gridDataLength == items.length ) {
				document.getElementById("klTarget").checked	= true;
			}
		} else if ( "kkTarget" == event.dataField ) {
			var items	= AUIGrid.getItemsByValue(myGridID, "kkTarget", "1");
			if ( gridDataLength != items.length ) {
				document.getElementById("kkTarget").checked	= false;
			} else if ( gridDataLength == items.length ) {
				document.getElementById("kkTarget").checked	= true;
			}
		} else if ( "jbTarget" == event.dataField ) {
			var items	= AUIGrid.getItemsByValue(myGridID, "jbTarget", "1");
			if ( gridDataLength != items.length ) {
				document.getElementById("jbTarget").checked	= false;
			} else if ( gridDataLength == items.length ) {
				document.getElementById("jbTarget").checked	= true;
			}
		} else if ( "pnTarget" == event.dataField ) {
			var items	= AUIGrid.getItemsByValue(myGridID, "pnTarget", "1");
			if ( gridDataLength != items.length ) {
				document.getElementById("pnTarget").checked	= false;
			} else if ( gridDataLength == items.length ) {
				document.getElementById("pnTarget").checked	= true;
			}
		} else if ( "kcTarget" == event.dataField ) {
			var items	= AUIGrid.getItemsByValue(myGridID, "kcTarget", "1");
			if ( gridDataLength != items.length ) {
				document.getElementById("kcTarget").checked	= false;
			} else if ( gridDataLength == items.length ) {
				document.getElementById("kcTarget").checked	= true;
			}
		}
	} else if ( "cellEditCancel" == event.type ) {
		console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	}
}

function headerClickHandler(event) {
	if ( "klTarget" == event.dataField ) {
		if ( "klTarget" == event.orgEvent.target.id ) {
			var isChecked	= document.getElementById("klTarget").checked;
			checkAll(isChecked, "klTarget");
		}
		return	false;
	} else if ( "kkTarget" == event.dataField ) {
		if ( "kkTarget" == event.orgEvent.target.id ) {
			var isChecked	= document.getElementById("kkTarget").checked;
			checkAll(isChecked, "kkTarget");
		}
		return	false;
	} else if ( "jbTarget" == event.dataField ) {
		if ( "jbTarget" == event.orgEvent.target.id ) {
			var isChecked	= document.getElementById("jbTarget").checked;
			checkAll(isChecked, "jbTarget");
		}
		return	false;
	} else if ( "pnTarget" == event.dataField ) {
		if ( "pnTarget" == event.orgEvent.target.id ) {
			var isChecked	= document.getElementById("pnTarget").checked;
			checkAll(isChecked, "pnTarget");
		}
		return	false;
	} else if ( "kcTarget" == event.dataField ) {
		if ( "kcTarget" == event.orgEvent.target.id ) {
			var isChecked	= document.getElementById("kcTarget").checked;
			checkAll(isChecked, "kcTarget");
		}
		return	false;
	}
}

function checkAll(isChecked, field) {
	if ( isChecked ) {
		if ( "klTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "klTarget", "1");
			document.getElementById("klTarget").checked	= true;
		} else if ( "kkTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "kkTarget", "1");
			document.getElementById("kkTarget").checked	= true;
		} else if ( "jbTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "jbTarget", "1");
			document.getElementById("jbTarget").checked	= true;
		} else if ( "pnTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "pnTarget", "1");
			document.getElementById("pnTarget").checked	= true;
		} else if ( "kcTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "kcTarget", "1");
			document.getElementById("kcTarget").checked	= true;
		}
	} else {
		if ( "klTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "klTarget", "0");
			document.getElementById("klTarget").checked	= false;
		} else if ( "kkTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "kkTarget", "0");
			document.getElementById("kkTarget").checked	= false;
		} else if ( "jbTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "jbTarget", "0");
			document.getElementById("jbTarget").checked	= false;
		} else if ( "pnTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "pnTarget", "0");
			document.getElementById("pnTarget").checked	= false;
		} else if ( "kcTarget" == field ) {
			AUIGrid.updateAllToValue(myGridID, "kcTarget", "0");
			document.getElementById("kcTarget").checked	= false;
		}
	}
}

//	excel
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. exprot ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}

	GridCommon.exportTo("#masterManagerDiv", "xlsx", fileName + "_" + getTimeStamp());
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

/*************************************
**********  Grid-LayOut  ************
*************************************/
var masterManagerLayout	=
	[
		{
			//	Stock
			headerText : "Material",
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
						headerText : "Desc.",
						styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
							if ( 1 == item.isNew ) {
								return	"my-columnLeft1";
							} else {
								return	"my-columnLeft";
							}
						}
					}, {
						dataField : "dfltStock",
						headerText : "Default<br/>Stock",
						renderer : {
							type : "DropDownListRenderer",
							showEditorBtnOver : true,
							keyField : "id",
							valueField : "name",
							listFunction : function(rowIndcex, columnIndex, item, dataField) {
								if ( 61 == item.typeId ) {
									type61	= new Array();
									var temp	= { id : "", name : "None", type : 0 };
									type61.push(temp);
									for ( var i = 0 ; i < keyValueList.length ; i++ ) {
										if ( 61 == keyValueList[i]["type"] ) {
											type61.push(keyValueList[i]);
										}
									}
									return	type61;
								} else if ( 62 == item.typeId ) {
									type62	= new Array();
									var temp	= { id : "", name : "None", type : 0 };
									type62.push(temp);
									for ( var i = 0 ; i < keyValueList.length ; i++ ) {
										if ( 62 == keyValueList[i]["type"] ) {
											type62.push(keyValueList[i]);
										}
									}
									return	type62;
								} else if ( 63 == item.typeId ) {
									type63	= new Array();
									var temp	= { id : "", name : "None", type : 0 };
									type63.push(temp);
									for ( var i = 0 ; i < keyValueList.length ; i++ ) {
										if ( 63 == keyValueList[i]["type"] ) {
											type63.push(keyValueList[i]);
										}
									}
									return	type63;
								} else if ( 64 == item.typeId ) {
									type64	= new Array();
									var temp	= { id : "", name : "None", type : 0 };
									type64.push(temp);
									for ( var i = 0 ; i < keyValueList.length ; i++ ) {
										if ( 64 == keyValueList[i]["type"] ) {
											type64.push(keyValueList[i]);
										}
									}
									return	type64;
								} else {
									return	keyValueList;
								}
							}
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
						headerText : "<spring:message code='sys.scm.mastermanager.Target'/>",
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
									headerText : "<spring:message code='sys.scm.mastermanager.KL'/><input type='checkbox' id='klTarget' style='width:15px;height:15px;'>",
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
									headerText : "<spring:message code='sys.scm.mastermanager.KK'/><input type='checkbox' id='kkTarget' style='width:15px;height:15px;'>",
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
									headerText : "<spring:message code='sys.scm.mastermanager.JB'/><input type='checkbox' id='jbTarget' style='width:15px;height:15px;'>",
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
									headerText : "<spring:message code='sys.scm.mastermanager.PN'/><input type='checkbox' id='pnTarget' style='width:15px;height:15px;'>",
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
									headerText : "<spring:message code='sys.scm.mastermanager.KC'/><input type='checkbox' id='kcTarget' style='width:15px;height:15px;'>",
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
	AUIGrid.bind(myGridID, "headerClick", headerClickHandler);	//	헤더 클릭 이벤트
	AUIGrid.bind(myGridID, "ready", function(event) {
		gridDataLength	= AUIGrid.getGridData(myGridID).length; // 그리드 전체 행수 보관
	});
	AUIGrid.bind(myGridID, "cellClick", function(event) {
		if ( "isTrget" == event.dataField ) {
			var isTrget	= event.item.isTrget;
			if ( "1" == isTrget ) {
				//if ( "" == AUIGrid.getCellValue(myGridID, event.rowIndex, "startDt") ) {
					AUIGrid.setCellValue(myGridID, event.rowIndex, "startDt", gYYYYMMDD);
					AUIGrid.setCellValue(myGridID, event.rowIndex, "endDt", "20991231");
				//}
			} else if ( "0" == isTrget ) {
				//if ( "" != AUIGrid.getCellValue(myGridID, event.rowIndex, "startDt") || "" != AUIGrid.getCellValue(myGridID, event.rowIndex, "endDt") ) {
					AUIGrid.setCellValue(myGridID, event.rowIndex, "startDt", "");
					AUIGrid.setCellValue(myGridID, event.rowIndex, "endDt", "");
				//}
			}
		}
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
			<li><p id="btnExcel" class="btn_grid"><a onclick="fnExcel(this, 'SCM Master');">Excel</a></p></li>
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