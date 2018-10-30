<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-right-column {
	text-align:right;
}

/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align : right;
	margin-top : -20px;
}
.my_div_btn {
	color : #fff !important;
	background-color : #2a2d33;
	line-height : 2em;
	cursor : pointer;
}
.my_div_btn2 {
	color : #fff !important;
	background-color : #ee5315;
	line-height : 2em;
	cursor : pointer;
}
.my-columnEditable {
	text-align : right;
	margin-top : -20px;
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
var supplyPlanQty	= "";
var leadTm			= 0;
var planWeekTh		= 0;
var splitCnt		= 0;
var headSelectCnt	= 6;	//	selectPoTargetList 에서 w01 앞에 있는 칼럼 갯수
var poQtyTh			= 21;	//	selectPoTargetList 에서 poQty 의 위치
var selectedRow		= 0;

$(function() {
	fnScmYearCbBox();
	fnScmWeekCbBox();
	fnScmCdcCbBox();
	fnScmStockTypeCbBox();
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

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var poTargetListLayout	= [];
var poTargetListLayoutOptions	= {};

var poCreateListLayout	=
	[
		{
			dataField : "type",
			headerText : "Type",
			editable : false,
			style : "my-columnCenter1"
		}, {
			dataField : "stockCode",
			headerText : "Code",
			editable : false,
			style : "my-columnCenter1"
		}, {
			dataField : "name",
			headerText : "Name",
			editable : false,
			style : "my-columnLeft1"
		}, {
			dataField : "poQty",
			headerText : "Po Qty",
			dataType : "numeric",
			formatString : "#,##0",
			editable : true,
			style : "my-columnEditable"
		}, {
			dataField : "moq",
			headerText : "Moq",
			dataType : "numeric",
			formatString : "#,##0",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "fobPrc",
			headerText : "FOB Price",
			dataType : "numeric",
			formatString : "#,##0",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "fobAmt",
			headerText : "FOB Amount",
			dataType : "numeric",
			formatString : "#,##0",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "curr",
			headerText : "Currency",
			editable : false,
			style : "my-columnCenter1"
		}, , {
			dataField : "currName",
			headerText : "Currency",
			editable : false,
			style : "my-columnCenter1"
		}, {
			dataField : "vendor",
			headerText : "Vendor",
			visible : false
		}, {
			dataField : "vendorTxt",
			headerText : "Vendor",
			editable : false,
			style : "my-columnLeft1"
		}, {
			dataField : "purchPrc",
			headerText : "Purchase Price",
			dataType : "numeric",
			formatString : "#,##0",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "condPrcUnit",
			headerText : "Unit Price",
			dataType : "numeric",
			formatString : "#,##0",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "poYear",
			headerText : "Year",
			visible : false
		}, {
			dataField : "poMonth",
			headerText : "Month",
			visible : false
		}, {
			dataField : "poWeek",
			headerText : "Week",
			visible : false
		}, {
			dataField : "cdc",
			headerText : "Cdc Name",
			visible : false
		}, {
			dataField : "cdcDesc",
			headerText : "Cdc Code",
			visible : false
		}
	 ];
//	footer
var poCreatedListFooterLayout	=
	[
		{
			labelText : "SUM:",
			positionField : "fobPrice"
		}, {
			dataField : "fobAmount",
			positionField : "fobAmount",
			operation : "SUM",
			formatString : "#,##0.0000",
			width : 200
		}
	 ];
var poCreatedListLayout	=
	[
		{
			headerText : "<spring:message code='sys.scm.pomngment.pdf'/>",
			renderer :
			{
				type : "TemplateRenderer"	//	HTML 템플릿 렌더러 사용
			},
			//	dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
			labelFunction : function (rowIndex, columnIndex, value, headerText, item) {
				var template	= "<div>";
				template	+= "<span class='my_div_btn' onclick='javascript:fnPdf(" + rowIndex + ", \"" + item.poNo + "\");'>PDF</span>";
				template	+= "&nbsp;";
				template	+= "<span class='my_div_btn2' onclick='javascript:fnExcel(" + rowIndex + ", \"" + item.poNo + "\");'>EXCEL</span>";
				//template	+= '<span class="my_div_btn2" onclick="javascript:fnExportExcel(' + rowIndex + ', \''+item.poNo+'\');">EXCEL</span>';
				template	+= "</div>";
				return	template;
			},
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poNo",
			headerText : "Po No",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "cdc",
			headerText : "Cdc",
			visible : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poYear",
			headerText : "Po Year",
			visible : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poMonth",
			headerText : "Po Month",
			visible : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poWeek",
			headerText : "Po Week",
			visible : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poItemNo",
			headerText : "Po Item No",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ctgry",
			headerText : "Category",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "type",
			headerText : "Type",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "stockCode",
			headerText : "Code",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "name",
			headerText : "Name",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnLeft2";
				} else {
					return	"my-columnLeft";
				}
			}
		}, {
			dataField : "poIssQty",
			headerText : "Po Qty",
			dataType : "numeric",
			formatString : "#,##0",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnRight2";
				} else {
					return	"my-columnRight";
				}
			}
		}, {
			dataField : "fobAmt",
			headerText : "FOB Amount",
			dataType : "numeric",
			formatString : "#,##0",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnRight2";
				} else {
					return	"my-columnRight";
				}
			}
		}, {
			dataField : "poIssDt",
			headerText : "Po Issue Date",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poIssStusId",
			headerText : "Po Issue Status Id",
			visible : false
		}, {
			dataField : "poApprStusId",
			headerText : "Po Approve Status Id",
			visible : false
		}, {
			dataField : "grYear",
			headerText : "Gr Year",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "grMonth",
			headerText : "Gr Month",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "grWeek",
			headerText : "Gr Week",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "grQty",
			headerText : "Gr Qty",
			dataType : "numeric",
			formatString : "#,##0",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poApprStusId ) {
					return	"my-columnRight2";
				} else {
					return	"my-columnRight";
				}
			}
		}, {
			dataField : "grStusId",
			headerText : "Gr Status Id",
			visible : false
		}
	 ];

//	Button function
function fnSearch() {
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
	
	AUIGrid.clearGridData(myGridID);
	AUIGrid.clearGridData(myGridID2);
	AUIGrid.clearGridData(myGridID3);
	gSumAmount	= 0;
	gMyGridSelRowIdx	= "";
	
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects")	
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectPoTargetList.do"
			, params
			, function(result) {
				console.log(result);
				
				//	supplyPlanQty set
				if ( 0 > result.selectTotalSplitInfo.length ) {
					console.log("error");
				} else {
					leadTm		= result.selectTotalSplitInfo[0].leadTm;
					planWeekTh	= result.selectTotalSplitInfo[0].planWeekTh;
					splitCnt	= result.selectTotalSplitInfo[0].splitCnt;
					supplyPlanQty	= parseInt(leadTm) + parseInt(planWeekTh) + parseInt(splitCnt);
					supplyPlanQty	= "w" + supplyPlanQty;
					console.log("===========supplyPlanQty : " + supplyPlanQty);
					fnPoTargetGrid();
					
					AUIGrid.setGridData(myGridID, result.selectPoTargetList);
					AUIGrid.setGridData(myGridID3, result.selectPoCreatedList);
					
					if ( 0 < result.selectPoCreatedList.length ) {
						$("#btnDelete").removeClass("btn_disabled");
					} else {
						$("#btnDelete").addClass("btn_disabled");
					}
				}
			});
}
function fnMoveStock() {
	var planQtyTh	= 0;
	var planQty		= 0;
	var poIssQty	= 0;
	var poQty		= 0;
	var fobPrc		= 0;
	var fobAmt		= 0;
	
	planQty		= AUIGrid.getCellValue(myGridID, selectedRow, supplyPlanQty);
	poIssQty	= AUIGrid.getCellValue(myGridID, selectedRow, "poIssQty");
	//	planQty check
	if ( 0 == planQty ) {
		return	false;
	}
	//	planQty, poQty comparison
	if ( planQty == poIssQty ) {
		Common.alert("This Stock is complete to issue PO");
		return	false;
	}
	
	//	poQty
	poQty	= parseInt(planQty) - parseInt(poIssQty);
	fobPrc	= AUIGrid.getCellValue(myGridID, selectedRow, "fobPrc");
	fobAmt	= parseInt(poQty) * parseInt(fobPrc);
	console.log("planQty : " + planQty + ", poIssQty : " + poIssQty + ", poQty : " + poQty + ", fobPrc : " + fobPrc + ", fobAmt : " + fobAmt);
	//	add row myGridID2
	var item	=
		{
			poYear : AUIGrid.getCellValue(myGridID, selectedRow, "poYear"),
			poMonth : AUIGrid.getCellValue(myGridID, selectedRow, "poMonth"),
			poWeek : AUIGrid.getCellValue(myGridID, selectedRow, "poWeek"),
			cdc : AUIGrid.getCellValue(myGridID, selectedRow, "cdc"),
			cdcDesc : AUIGrid.getCellValue(myGridID, selectedRow, "cdcDesc"),
			type : AUIGrid.getCellValue(myGridID, selectedRow, "type"),
			stockCode : AUIGrid.getCellValue(myGridID, selectedRow, "stockCode"),
			name : AUIGrid.getCellValue(myGridID, selectedRow, "name"),
			poQty : poQty,
			moq : AUIGrid.getCellValue(myGridID, selectedRow, "moq"),
			fobPrc : fobPrc,
			fobAmt : fobAmt,
			curr : AUIGrid.getCellValue(myGridID, selectedRow, "curr"),
			currName : AUIGrid.getCellValue(myGridID, selectedRow, "currName"),
			vendor : AUIGrid.getCellValue(myGridID, selectedRow, "vendor"),
			vendorTxt : AUIGrid.getCellValue(myGridID, selectedRow, "vendorTxt"),
			purchPrc : AUIGrid.getCellValue(myGridID, selectedRow, "purchPrc"),
			condPrcUnit : AUIGrid.getCellValue(myGridID, selectedRow, "condPrcUnit")
		};
	console.log(item);
	AUIGrid.addRow(myGridID2, item, "last");
}
function fnClear(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	AUIGrid.removeRow(myGridID2, "selectedIndex");
}
function fnCreate(obj) {
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
function fnDelete(obj) {
	if ( true == $(obj).parents().hasClass("btn_disabled") )	return	false;
	
	var data	= {};
	var chkList	= AUIGrid.getCheckedRowItemsAll(myGridID3);
	
	if ( 0 > chkList ) {
		Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
		return	false;
	}
	data.checked	= chkList;
	//console.log(chkList);
	//return	false;
	
	Common.ajax("POST"
			, "/scm/deletePo.do"
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

//	user function
function fnValidation() {
	var addList	= AUIGrid.getAddedRowItems(myGridID2);
	
	if ( 0 == addList.length ) {
		Common.alert("No Change");
		return	false;
	}
	
	return	true;
}
function fnPoTargetGrid() {
	if ( AUIGrid.isCreated(myGridID) ) {
		AUIGrid.destroy(myGridID);
	}
	poTargetListLayout	= [];
	poTargetListLayoutOptions	= 
	{
		usePaging : false,
		useGroupingPanel : false,
		showRowNumColumn : false,
		showStateColumn : false,
		enableRestore : false,
		editable : false,
		wrapSelectionMove : true,		//	칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
		softRemovePolicy : "exceptNew",	//	사용자추가한 행은 바로 삭제
		selectionMode : "singleRow"
	};
	poTargetListLayout.push(
			{
				dataField : "poYear",
				headerText : "Po Year",
				visible : false
			}, {
				dataField : "poMonth",
				headerText : "Po Month",
				visible : false
			}, {
				dataField : "poWeek",
				headerText : "Po Week",
				visible : false
			}, {
				dataField : "cdc",
				headerText : "Cdc Name",
				visible : false
			}, {
				dataField : "cdcDesc",
				headerText : "Cdc Code",
				visible : false
			}, {
				dataField : "ctgryId",
				headerText : "Ctgry Id",
				visible : false
			}, {
				dataField : "ctgry",
				headerText : "Category",
				visible : false
			}, {
				dataField : "typeId",
				headerText : "Type Id",
				visible : false
			}, {
				dataField : "type",
				headerText : "Type",
				style : "my-columnCenter0",
				width : "10%"
			}, {
				dataField : "stockCode",
				headerText : "Code",
				style : "my-columnCenter0",
				width : "10%"
			}, {
				dataField : "name",
				headerText : "Name",
				style : "my-columnLeft0",
				width : "60%"
			}, {
				dataField : supplyPlanQty,
				headerText : "Plan Qty",
				dataType : "numeric",
				formatString : "#,##0",
				style : "my-columnRight0",
				width : "10%"
			}, {
				dataField : "poIssQty",
				headerText : "Issued Qty",
				dataType : "numeric",
				formatString : "#,##0",
				style : "my-columnRight0",
				width : "10%"
			}, {
				dataField : "poIssStusId",
				headerText : "Po Iss Stus Id",
				visible : false
			}, {
				dataField : "poApprStusId",
				headerText : "Po Appr Stus Id",
				visible : false
			}, {
				dataField : "purchPrc",
				headerText : "Purchase Price",
				visible : false
			}, {
				dataField : "condPrcUnit",
				headerText : "Unit Price",
				visible : false
			}, {
				dataField : "vendor",
				headerText : "Vendor",
				visible : false
			}, {
				dataField : "vendorTxt",
				headerText : "Vender",
				visible : false
			}, {
				dataField : "curr",
				headerText : "Currency",
				visible : false
			}, {
				dataField : "currName",
				headerText : "Currency",
				visible : false
			}, {
				dataField : "moq",
				headerText : "Moq",
				visible : false
			}, {
				dataField : "w01",
				headerText : "W01"
			}, {
				dataField : "w02",
				headerText : "W02"
			}, {
				dataField : "w03",
				headerText : "W03"
			}, {
				dataField : "w04",
				headerText : "W04"
			}, {
				dataField : "w05",
				headerText : "W05"
			}, {
				dataField : "w06",
				headerText : "W06"
			}, {
				dataField : "w07",
				headerText : "W07"
			}, {
				dataField : "w08",
				headerText : "W08"
			}, {
				dataField : "w09",
				headerText : "W09"
			}, {
				dataField : "w10",
				headerText : "W10"
			}, {
				dataField : "w11",
				headerText : "W11"
			}, {
				dataField : "w12",
				headerText : "W12"
			}, {
				dataField : "w13",
				headerText : "W13"
			}, {
				dataField : "w14",
				headerText : "W14"
			}, {
				dataField : "w15",
				headerText : "W15"
			}, {
				dataField : "fobPrc",
				headerText : "FOB Price",
				visible : false
			}, {
				dataField : "fobAmt",
				headerText : "FOB Amount",
				visible : false
			}
	);
	myGridID	= GridCommon.createAUIGrid("poTargetListGridDiv", poTargetListLayout, "", poTargetListLayoutOptions);	//	create left grid
	AUIGrid.bind(myGridID, "cellEditBegin", fnEventCellEdit);
	AUIGrid.bind(myGridID, "cellEditEnd", fnEventCellEdit);
	AUIGrid.bind(myGridID, "cellEditCancel", fnEventCellEdit);
	AUIGrid.bind(myGridID, "addRow", fnEventRowAdd);
	AUIGrid.bind(myGridID, "removeRow", fnEventRowRemove);
	AUIGrid.bind(myGridID, "cellClick", function(event) {
		gMyGridSelRowIdx	= event.rowIndex;
		gMovingStockCode	= AUIGrid.getCellValue(myGridID, event.rowIndex, 0);
		selectedRow	= event.rowIndex;
	});
	AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
		gMovingStockCode	= AUIGrid.getCellValue(myGridID, event.rowIndex, 0);
		fnMoveStock();
	});
}

//	Export function
function fnPdf(index, value) {
	$("#viewType").val("PDF");
	$("#reportDownFileName").val(value);
	$("#V_PO_NO").val(value);
	$("#reportFileName").val("/scm/PO_management.rpt");
	
	Common.report("reportDataForm");
}
function fnExcel(index, value) {
	$("#viewType").val("EXCEL_FULL");
	$("#reportDownFileName").val(value);
	$("#V_PO_NO").val(value);
	$("#reportFileName").val("/scm/PO_management.rpt");
	
	Common.report("reportDataForm");
}

//	event function
function fnEventCellEdit(event) {
	//
	if ( "cellEditEnd" == event.type ) {
		var fobAmt	= 0;
		var fobPrc	= AUIGrid.getCellValue(myGridID2, event.rowIndex, "fobPrc");
		var poQty	= parseInt(event.value);
		if ( 0 >= poQty ) {
			poQty	= 0;
			fobAmt	= 0;
		} else {
			fobAmt	= parseInt(poQty) * parseInt(fobPrc);
		}
		console.log("fobPrc : " + fobPrc + ", poQty : " + poQty + ", fobAmt : " + fobAmt);
		AUIGrid.setCellValue(myGridID2, event.rowIndex, "poQty", poQty);
		AUIGrid.setCellValue(myGridID2, event.rowIndex, "fobAmt", fobAmt);
	}
}
function fnEventRowAdd(event) {
	console.log(AUIGrid.getRowCount(myGridID2));
	if ( 0 < AUIGrid.getRowCount(myGridID2) ) {
		$("#btnClear").removeClass("btn_disabled");
		$("#btnCreate").removeClass("btn_disabled");
	} else {
		$("#btnClear").addClass("btn_disabled");
		$("#btnCreate").addClass("btn_disabled");
	}
}
function fnEventRowRemove(event) {
	
}
function addCheckedRowsByValue(selValue) {
	AUIGrid.addCheckedRowsByValue(myGridID3, "poNo", selValue);
}
function addUncheckedRowsByValue(selValue) {
	AUIGrid.addUncheckedRowsByValue(myGridID3, "poNo", selValue);
}


/****************************  Form Ready ******************************************/
var myGridID;	//	poTargetListGrid
var myGridID2;	//	poCreateListGrid
var myGridID3;	//	poCreatedListGrid

$(document).ready(function() {
	//	poCreateListGrid
	var poCreateListLayoutOptions	=
		{
			showFooter : true,
			usePaging : false,
			useGroupingPanel : false,
			showRowNumColumn : false,
			showStateColumn : true,
			enableRestore : true,
			editable : true,
			wrapSelectionMove : true,
			softRemovePolicy : "exceptNew",
			selectionMode : "singleRow"
		};
	myGridID2	= GridCommon.createAUIGrid("poCreateListGridDiv", poCreateListLayout, "", poCreateListLayoutOptions);	//	create right grid
	AUIGrid.setFooter(myGridID2, poCreatedListFooterLayout);
	AUIGrid.bind(myGridID2, "cellEditBegin", fnEventCellEdit);
	AUIGrid.bind(myGridID2, "cellEditEnd", fnEventCellEdit);
	AUIGrid.bind(myGridID2, "cellEditCancel", fnEventCellEdit);
	AUIGrid.bind(myGridID2, "addRow", fnEventRowAdd);
	AUIGrid.bind(myGridID2, "removeRow", fnEventRowRemove);
	AUIGrid.bind(myGridID2, "cellClick", function(event) {
		gSelRowIdx	= event.rowIndex;
	});
	AUIGrid.bind(myGridID2, "cellDoubleClick", function(event) {
		
	});
	
	//	poCreatedListGrid
	var poCreatedListLayoutOptions	=
		{
			usePaging : false,
			useGroupingPanel : false,
			showRowNumColumn : true,
			showStateColumn : false,
			enableRestore : true,
			editable : false,
			softRemovePolicy : "exceptNew",
			showRowCheckColumn : true,
			independentAllCheckBox : true,
			rowCheckableFunction : function(rowIndex, isChecked, item) {
				if ( false == isChecked ) {
					//addCheckedRowsByValue(AUIGrid.getCellValue(myGridID3, rowIndex, "poNo"));
				} else {
					//addUncheckedRowsByValue(AUIGrid.getCellValue(myGridID3, rowIndex, "poNo"));
				}
				return	true;
			},
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if ( 5 == item.cbBoxFlag ) {
					return	false;
				}
				return	true;
			},
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if ( 5 == item.cbBoxFlag ) {
					return	false;
				}
				return	true;
			}
		};
	myGridID3	= GridCommon.createAUIGrid("poCreatedListGridDiv", poCreatedListLayout, "", poCreatedListLayoutOptions);	//	create below grid
	AUIGrid.bind(myGridID3, "cellEditBegin", fnEventCellEdit);
	AUIGrid.bind(myGridID3, "cellEditEnd", fnEventCellEdit);
	AUIGrid.bind(myGridID3, "cellEditCancel", fnEventCellEdit);
	AUIGrid.bind(myGridID3, "addRow", fnEventRowAdd);
	AUIGrid.bind(myGridID3, "removeRow", fnEventRowRemove);
	AUIGrid.bind(myGridID3, "cellClick", function(event) {
		gSelRowIdx	= event.rowIndex;
	});
	AUIGrid.bind(myGridID3, "cellDoubleClick", function(event) {
		
	});
	AUIGrid.bind(myGridID3, "rowAllChkClick", function(event) {
		if ( event.checked ) {
			AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag", 1);
		} else {
			AUIGrid.setCheckedRowsByValue(event.pid, "cbBoxFlag", 0);
		}
	});
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
	<h2>PO Issue</h2>
	<ul class="right_btns">
		<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->

<form id="reportDataForm" action="">
	<input type ="hidden" id="reportFileName" name="reportFileName" value=""/>
	<input type ="hidden" id="viewType" name="viewType" value=""/>
	<input type ="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
	<input type ="hidden" id="V_PO_NO" name="V_PO_NO" value="" />
</form>

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
	<input type ="hidden" id="inStockCode"  name="inStockCode" value=""/>
	<input type ="hidden" id="inStkCtgryId" name="inStkCtgryId" value=""/>
	<input type ="hidden" id="inPlanQty"    name="inPlanQty" value="" />
	<input type ="hidden" id="inPoQty"      name="inPoQty" value="" />
	<input type ="hidden" id="inMoq"        name="inMoq" value=""/>
	<input type ="hidden" id="inStkTypeId"  name="inStkTypeId" value=""/>
	<input type ="hidden" id="inRoundUpPoQty"  name="inRoundUpPoQty" value=""/>
	<input type ="hidden" id="inPreCdc"        name="inPreCdc" value=""/>
	<input type ="hidden" id="inPreYear"    name="inPreYear" value=""/>
	<input type ="hidden" id="inPreWeekTh"    name="inPreWeekTh" value=""/>
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
						<select class="sel_date" id="scmWeekCbBox" name="scmWeekCbBox"></select>
					</div><!-- date_set end -->
				</td>
				<th scope="row">CDC</th>
				<td>
					<select class="w100p" id="scmCdcCbBox" name="scmCdcCbBox"></select>
				</td>
				<th scope="row">PO Status</th>
				<td>
					<div class="status_result">
						<!-- circle_red, circle_blue, circle_grey -->
						<p><span id ="cirIssue" class="circle circle_grey"></span> Po Issue</p>
						<p><span id ="cirAppro" class="circle circle_grey"></span> Po Approval</p>
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

	<div class="divine_auto type2 mt30"><!-- divine_auto start -->
		<div style="width:40%;">
			<div class="border_box" style="min-height:150px"><!-- border_box start -->
				<article class="grid_wrap"><!-- grid_wrap start -->
					<!-- 그리드 영역1 -->
					<div id="poTargetListGridDiv"></div>
				</article><!-- grid_wrap end -->
			</div><!-- border_box end -->
		</div>
		<div style="width:60%;">
			<div class="border_box" style="min-height:150px"><!-- border_box start -->
				<article class="grid_wrap"><!-- grid_wrap start -->
					<!-- 그리드 영역2 -->
					<div id="poCreateListGridDiv"></div>
				</article><!-- grid_wrap end -->
				<ul class="btns">
					<li><a onclick="fnMoveStock();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
				</ul>
				<ul class="center_btns">
					<li>
					<p id="btnClear" class="btn_blue btn_disabled">
						<a onclick="fnClear(this);">Clear</a>
					</p>
					</li>
					<li>
						<p id="btnCreate" class="btn_blue btn_disabled">
							<a onclick="fnCreate(this);">Create PO</a>
						</p>
					</li>
				</ul>
			</div><!-- border_box end -->
		</div><!-- width: 50 -->
	</div><!-- divine_auto end -->
	
	<article class="grid_wrap mt30" style=""><!-- grid_wrap start -->
		<ul class="right_btns">
			<li><p id="btnDelete" class="btn_blue btn_disabled"><a onclick="fnDelete(this);">Delete</a></p></li>
		</ul>
		<!-- 그리드 영역3 -->
		<div id="poCreatedListGridDiv"></div>
	</article><!-- grid_wrap end -->
	
	<ul class="center_btns">
		<li>
			<p class="btn_blue2 big">
				<!--    <a href="javascript:void(0);">Download Raw Data</a> <a onclick="fnExcelExport('PO ISSUE');">Download</a>-->
			</p>
		</li>
	</ul>
	
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
</section><!-- content end -->