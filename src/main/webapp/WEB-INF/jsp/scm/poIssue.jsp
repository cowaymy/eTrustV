<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
<link href="${pageContext.request.contextPath}/resources/css/select2.min.css" rel="stylesheet">
<script src ="${pageContext.request.contextPath}/resources/js/select2.min.js" type="text/javascript"></script>
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
var headSelectCnt	= 6;	//	selectPoTargetList 에서 w01 앞에 있는 칼럼 갯수
var poQtyTh			= 21;	//	selectPoTargetList 에서 poQty 의 위치
var selectedRow		= 0;

var leadCnt	= 0;
var splitCnt	= 0;
var lastSplitYn	= 0;
var lastWeekSplitYn	= 0;
var planWeekTh	= 0;
var fromPlanToPoSpltCnt	= 0;
var planGrWeekSpltYn	= 0;

var poTargetList	= new Array();

var planYear	= 0;
var planMonth	= 0;
var planWeek	= 0;

$(function() {
	//	Set combo box
	fnScmTotalPeriod();
	//fnScmYearCbBox();
	//fnScmWeekCbBox();
	fnScmCdcCbBox();
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
	//var params	= $.extend($("#MainForm").serializeJSON(), params);
	CommonCombo.make("scmStockTypeCbBox"
			, "/scm/selectScmStockType.do"
			//, params
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
			}
			, "");
}

/*************************************
 **********  Grid-LayOut  ************
 *************************************/
var poTargetListLayout	= [];
var poTargetListLayoutOptions	= {};

var poCreateListFooterLayout	=
	[
		{
			labelText : "Total",
			positionField : "type"
		}, {
			dataField : "planQty",
			positionField : "planQty",
			operation : "SUM",
			formatString : "#,##0",
			width : 200,
			style : "aui-grid-right-column"
		}, {
			dataField : "poQty",
			positionField : "poQty",
			operation : "SUM",
			formatString : "#,##0",
			width : 200,
			style : "aui-grid-right-column"
		}
	 ];
var poCreateListLayout	=
	[
		{
			dataField : "type",
			headerText : "Type",
			editable : false,
			style : "my-columnCenter1"
		}, {
			dataField : "stockCode",
			headerText : "Material",
			editable : false,
			style : "my-columnCenter1"
		}, {
			dataField : "name",
			headerText : "Desc.",
			editable : false,
			style : "my-columnLeft1"
		}, {
			dataField : "poQty",
			headerText : "PO Qty",
			dataType : "numeric",
			//formatString : "#,##0",
			editable : false,
			//style : "my-columnEditable"
			style : "my-columnRight1"
		}, {
			dataField : "moq",
			headerText : "MOQ",
			dataType : "numeric",
			//formatString : "#,##0",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "fobPrc",
			headerText : "FOB Price",
			dataType : "numeric",
			formatString : "#,##0.00",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "fobAmt",
			headerText : "FOB Amount",
			dataType : "numeric",
			formatString : "#,##0.00",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "curr",
			headerText : "Currency",
			editable : false,
			visible : false,
			style : "my-columnCenter1"
		}, {
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
			//formatString : "#,##0",
			editable : false,
			style : "my-columnRight1"
		}, {
			dataField : "prcUnit",
			headerText : "Unit Price",
			dataType : "numeric",
			//formatString : "#,##0",
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
		}, {
			dataField : "planGrYear",
			headerText : "Plan GR Year",
			visible : false
		}, {
			dataField : "planGrMonth",
			headerText : "Plan GR Month",
			visible : false
		}, {
			dataField : "planGrWeek",
			headerText : "Plan GR Week",
			visible : false
		}
	 ];
//	footer
var poCreatedListFooterLayout	=
	[
		{
			labelText : "Total",
			positionField : "type"
		}, {
			dataField : "fobAmt",
			positionField : "fobAmt",
			operation : "SUM",
			formatString : "#,##0",
			width : 200,
			style : "aui-grid-right-column"
		}, {
			dataField : "poQty",
			positionField : "poQty",
			operation : "SUM",
			formatString : "#,##0",
			width : 200,
			style : "aui-grid-right-column"
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
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poNo",
			headerText : "PO No.",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poItemNo",
			headerText : "PO Item No.",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "cdc",
			headerText : "CDC",
			visible : false,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poYear",
			headerText : "PO Year",
			visible : true,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poMonth",
			headerText : "PO Month",
			visible : true,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poWeek",
			headerText : "PO Week",
			visible : true,
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "type",
			headerText : "Type",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "ctgry",
			headerText : "Category",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "stockCode",
			headerText : "Material",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "name",
			headerText : "Desc.",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnLeft2";
				} else {
					return	"my-columnLeft";
				}
			}
		}, {
			dataField : "poQty",
			headerText : "PO Qty",
			dataType : "numeric",
			formatString : "#,##0.00",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnRight2";
				} else {
					return	"my-columnRight";
				}
			}
		}, {
			dataField : "fobAmt",
			headerText : "FOB Amount",
			dataType : "numeric",
			formatString : "#,##0.00",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnRight2";
				} else {
					return	"my-columnRight";
				}
			}
		}, {
			dataField : "poIssDt",
			headerText : "PO Issue Date",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "poStusId",
			headerText : "Po Status Id",
			visible : false
		}, {
			dataField : "planGrYear",
			headerText : "GR Year",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "planGrMonth",
			headerText : "GR Month",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}, {
			dataField : "planGrWeek",
			headerText : "GR Week",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnCenter2";
				} else {
					return	"my-columnCenter";
				}
			}
		}/*, {
			dataField : "grQty",
			headerText : "Gr Qty",
			dataType : "numeric",
			//formatString : "#,##0",
			styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
				if ( 5 == item.poItemStusId ) {
					return	"my-columnRight2";
				} else {
					return	"my-columnRight";
				}
			}
		}, {
			dataField : "grStusId",
			headerText : "Gr Status Id",
			visible : true
		}*/
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
	
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects"),
		scmStockCategoryCbBox : $("#scmStockCategoryCbBox").multipleSelect("getSelects"),
		scmStockCodeCbBox : $("#scmStockCodeCbBox").val()
	};
	
	params	= $.extend($("#MainForm").serializeJSON(), params);
	
	Common.ajax("POST"
			, "/scm/selectPoTargetList.do"
			, params
			, function(result) {
				console.log(result);
				
				//	supplyPlanQty set
				//leadTm		= result.selectScmTotalInfo[0].leadTm;
				//planWeekTh	= result.selectScmTotalInfo[0].planWeekTh;
				//fromPlanToPoSpltCnt	= result.selectScmTotalInfo[0].fromPlanToPoSpltCnt;
				//planGrWeekSpltYn	= result.selectScmTotalInfo[0].planGrWeekSpltYn;
				leadCnt	= parseInt(result.selectGetPoCntTargetCnt[0].leadCnt);
				planGrWeekSpltYn	= parseInt(result.selectGetPoCntTargetCnt[0].planGrWeekSpltYn);
				fnPoTargetGrid();
				
				fnSetPlanQty(result.selectPoTargetList);
				fnFilterPoTargetList(result.selectPoTargetList);
				//AUIGrid.setGridData(myGridID, result.selectPoTargetList);
				AUIGrid.setGridData(myGridID3, result.selectPoCreatedList);
				
				if ( 0 < poTargetList.length ) {
					$("#btnDelete").removeClass("btn_disabled");
				} else {
					$("#btnDelete").addClass("btn_disabled");
				}
				
				fnCircleControl(poTargetList);
			});
}
function fnFilterPoTargetList(list) {
	//var poTargetList	= new Array();
	poTargetList	= [];
	for ( var i = 0 ; i < list.length ; i++ ) {
		if ( 0 < list[i].planQty ) {
			var poList	= new Object();
			
			poList.poYear	= list[i].poYear;
			poList.poMonth	= list[i].poMonth;
			poList.poWeek	= list[i].poWeek;
			poList.cdc		= list[i].cdc;
			poList.cdcDesc	= list[i].cdcDesc;
			poList.planGrYear	= list[i].planGrYear;
			poList.planGrMonth	= list[i].planGrMonth;
			poList.planGrWeek	= list[i].planGrWeek;
			poList.desc		= list[i].desc;
			poList.stockCode	= list[i].stockCode;
			poList.name	= list[i].name;
			poList.ctgryId	= list[i].ctgryId;
			poList.ctgry	= list[i].ctgry;
			poList.typeId	= list[i].typeId;
			poList.type		= list[i].type;
			poList.planQty	= list[i].planQty;
			poList.moq		= list[i].moq;
			poList.poQty	= list[i].poQty;
			poList.fobPrc	= list[i].fobPrc;
			poList.fobAmt	= list[i].fobAmt;
			poList.poStusId	= list[i].poStusId;
			poList.poItemStusId	= list[i].poItemStusId;
			poList.purchPrc	= list[i].purchPrc;
			poList.prcUnit	= list[i].prcUnit;
			poList.vendor	= list[i].vendor;
			poList.vendorTxt	= list[i].vendorTxt;
			poList.curr		= list[i].curr;
			poList.currName	= list[i].currName;
			
			poTargetList.push(poList);
		}
	}
	AUIGrid.setGridData(myGridID, poTargetList);
}
function fnSetPlanQty(list) {
	var planQty1	= 0;
	var planQty2	= 0;
	//var totLeadCnt	= 0;
	
	//totLeadCnt	= parseInt(leadTm) + parseInt(planWeekTh) + parseInt(fromPlanToPoSpltCnt) + 1;
	//totLeadCnt	= parseInt(leadTm);
	console.log("leadCnt : " + leadCnt + ", planGrWeekSpltYn : " + planGrWeekSpltYn);
	for ( var i = 0 ; i < list.length ; i++ ) {
		if ( 1 == planGrWeekSpltYn ) {
			//	PLAN_GR_WEEK IS NOT SPLIT WEEK
			if ( 9 == leadCnt ) {
				planQty1	= list[i].w09;	planQty2	= 0;
			} else if ( 10 == leadCnt ) {
				planQty1	= list[i].w10;	planQty2	= 0;
			} else if ( 11 == leadCnt ) {
				planQty1	= list[i].w11;	planQty2	= 0;
			} else if ( 12 == leadCnt ) {
				planQty1	= list[i].w12;	planQty2	= 0;
			} else if ( 13 == leadCnt ) {
				planQty1	= list[i].w13;	planQty2	= 0;
			} else if ( 14 == leadCnt ) {
				planQty1	= list[i].w14;	planQty2	= 0;
			} else if ( 15 == leadCnt ) {
				planQty1	= list[i].w15;	planQty2	= 0;
			} else if ( 16 == leadCnt ) {
				planQty1	= list[i].w16;	planQty2	= 0;
			} else if ( 17 == leadCnt ) {
				planQty1	= list[i].w17;	planQty2	= 0;
			} else if ( 18 == leadCnt ) {
				planQty1	= list[i].w18;	planQty2	= 0;
			} else if ( 19 == leadCnt ) {
				planQty1	= list[i].w19;	planQty2	= 0;
			} else if ( 20 == leadCnt ) {
				planQty1	= list[i].w20;	planQty2	= 0;
			} else {
				console.log("u must make more else if");
			}
		} else if ( 2 == planGrWeekSpltYn ) {
			//	PLAN_GR_WEEK IS SPLIT WEEK
			if ( 9 == leadCnt ) {
				planQty1	= list[i].w08;	planQty2	= list[i].w09;
			} else if ( 10 == leadCnt ) {
				planQty1	= list[i].w09;	planQty2	= list[i].w10;
			} else if ( 11 == leadCnt ) {
				planQty1	= list[i].w10;	planQty2	= list[i].w11;
			} else if ( 12 == leadCnt ) {
				planQty1	= list[i].w11;	planQty2	= list[i].w12;
			} else if ( 13 == leadCnt ) {
				planQty1	= list[i].w12;	planQty2	= list[i].w13;
			} else if ( 14 == leadCnt ) {
				planQty1	= list[i].w13;	planQty2	= list[i].w14;
			} else if ( 15 == leadCnt ) {
				planQty1	= list[i].w14;	planQty2	= list[i].w15;
			} else if ( 16 == leadCnt ) {
				planQty1	= list[i].w15;	planQty2	= list[i].w16;
			} else if ( 17 == leadCnt ) {
				planQty1	= list[i].w16;	planQty2	= list[i].w17;
			} else if ( 18 == leadCnt ) {
				planQty1	= list[i].w17;	planQty2	= list[i].w18;
			} else if ( 19 == leadCnt ) {
				planQty1	= list[i].w18;	planQty2	= list[i].w19;
			} else if ( 20 == leadCnt ) {
				planQty1	= list[i].w19;	planQty2	= list[i].w20;
			} else {
				console.log("u must make more else if");
			}
		}
		console.log("planQty1 : " + planQty1 + ", planQty2 : " + planQty2);
		list[i].planQty	= parseInt(planQty1) + parseInt(planQty2);
	}
}
function fnMoveStockGroup() {
	var planQtyTh	= 0;
	var planQty		= 0;
	var issQty		= 0;
	var poQty		= 0;
	var fobPrc		= 0;
	var fobAmt		= 0;
	var stockCode	= 0;
	var list		= AUIGrid.getCheckedRowItemsAll(myGridID);
	
	for ( var i = 0 ; i < list.length ; i++ ) {
		stockCode	= list[i].stockCode;
		planQty	= list[i].planQty;
		issQty	= list[i].poQty;
		
		console.log("stockCode : " + stockCode);
		var rows	= AUIGrid.getRowsByValue(myGridID2, "stockCode", stockCode);
		//	stockCode check
		if ( 0 < rows.length ) {
			Common.alert("This(" + stockCode + ") Stock is already moved");
			//AUIGrid.clearGridData(myGridID2);
			return	false;
		} else {
			console.log("this stock is first move");
		}
		//	planQty check
		if ( 0 == planQty ) {
			Common.alert("This(" + stockCode + ") Stock Plan Qty is 0");
			//AUIGrid.clearGridData(myGridID2);
			return	false;
		}
		//	planQty, issQty comparison
		if ( planQty <= issQty ) {
			Common.alert("This(" + stockCode + ") Stock is complete to issue PO");
			//AUIGrid.clearGridData(myGridID2);
			return	false;
		}
		
		//	poQty
		poQty	= parseInt(planQty) - parseInt(issQty);
		//fobPrc	= AUIGrid.getCellValue(myGridID, selectedRow, "fobPrc");
		fobAmt	= parseFloat(poQty) * parseFloat(fobPrc);
		console.log("qty : " + poQty + ", fobPrc : " + fobPrc + ", forAmt : " + fobAmt);
		//	add row myGridID2
		var item	=
		{
			poYear : list[i].poYear,
			poMonth : list[i].poMonth,
			poWeek : list[i].poWeek,
			cdc : list[i].cdc,
			cdcDesc : list[i].cdcDesc,
			planGrYear : list[i].planGrYear,
			planGrMonth : list[i].planGrMonth,
			planGrWeek : list[i].planGrWeek,
			type : list[i].type,
			stockCode : stockCode,
			name : list[i].name,
			poQty : poQty,
			moq : list[i].moq,
			fobPrc : list[i].fobPrc,
			fobAmt : parseFloat(poQty) * parseFloat(list[i].fobPrc),
			curr : list[i].curr,
			currName : list[i].currName,
			vendor : list[i].vendor,
			vendorTxt : list[i].vendorTxt,
			purchPrc : list[i].purchPrc,
			prcUnit : list[i].prcUnit
		};
		AUIGrid.addRow(myGridID2, item, "last");
	}
	AUIGrid.setAllCheckedRows(myGridID, false);
	/*
	//	add row myGridID2
	var item	=
		{
			poYear : AUIGrid.getCellValue(myGridID, selectedRow, "poYear"),
			poMonth : AUIGrid.getCellValue(myGridID, selectedRow, "poMonth"),
			poWeek : AUIGrid.getCellValue(myGridID, selectedRow, "poWeek"),
			cdc : AUIGrid.getCellValue(myGridID, selectedRow, "cdc"),
			cdcDesc : AUIGrid.getCellValue(myGridID, selectedRow, "cdcDesc"),
			planGrYear : AUIGrid.getCellValue(myGridID, selectedRow, "planGrYear"),
			planGrMonth : AUIGrid.getCellValue(myGridID, selectedRow, "planGrMonth"),
			planGrWeek : AUIGrid.getCellValue(myGridID, selectedRow, "planGrWeek"),
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
			prcUnit : AUIGrid.getCellValue(myGridID, selectedRow, "prcUnit")
		};
	console.log(item);
	AUIGrid.addRow(myGridID2, item, "last");*/
}
function fnMoveStock() {
	var planQtyTh	= 0;
	var planQty		= 0;
	var issQty		= 0;
	var poQty		= 0;
	var fobPrc		= 0;
	var fobAmt		= 0;
	var stockCode	= 0;
	
	stockCode	= AUIGrid.getCellValue(myGridID, selectedRow, "stockCode");
	planQty	= AUIGrid.getCellValue(myGridID, selectedRow, "planQty");
	issQty	= AUIGrid.getCellValue(myGridID, selectedRow, "poQty");
	
	var rows	= AUIGrid.getRowsByValue(myGridID2, "stockCode", stockCode);
	//	stockCode check
	if ( 0 < rows.length ) {
		Common.alert("This Stock is already moved");
		return	false;
	} else {
		console.log("this stock is first move");
	}
	
	//	planQty check
	if ( 0 == planQty ) {
		return	false;
	}
	//	planQty, issQty comparison
	if ( planQty <= issQty ) {
		Common.alert("This Stock is complete to issue PO");
		return	false;
	}
	
	//	poQty
	poQty	= parseInt(planQty) - parseInt(issQty);
	fobPrc	= AUIGrid.getCellValue(myGridID, selectedRow, "fobPrc");
	fobAmt	= parseFloat(poQty) * parseFloat(fobPrc);
	console.log("planQty : " + planQty + ", issQty : " + issQty + ", poQty : " + poQty + ", fobPrc : " + fobPrc + ", fobAmt : " + fobAmt);
	
	//	add row myGridID2
	var item	=
		{
			poYear : AUIGrid.getCellValue(myGridID, selectedRow, "poYear"),
			poMonth : AUIGrid.getCellValue(myGridID, selectedRow, "poMonth"),
			poWeek : AUIGrid.getCellValue(myGridID, selectedRow, "poWeek"),
			cdc : AUIGrid.getCellValue(myGridID, selectedRow, "cdc"),
			cdcDesc : AUIGrid.getCellValue(myGridID, selectedRow, "cdcDesc"),
			planGrYear : AUIGrid.getCellValue(myGridID, selectedRow, "planGrYear"),
			planGrMonth : AUIGrid.getCellValue(myGridID, selectedRow, "planGrMonth"),
			planGrWeek : AUIGrid.getCellValue(myGridID, selectedRow, "planGrWeek"),
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
			prcUnit : AUIGrid.getCellValue(myGridID, selectedRow, "prcUnit")
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
	
	if ( 0 >= chkList ) {
		Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
		return	false;
	}
	data.checked	= chkList;
	
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
function fnCircleControl(list) {
	var poTargetCnt	= list.length;
	var poIssCnt	= 0;
	var poApprCnt	= 0;
	
	for ( var i = 0 ; i < poTargetCnt ; i++ ) {
		if ( 0 < list[i].poQty ) {
			poIssCnt	= poIssCnt + 1;
			if ( 5 == list[i].poItemStusId ) {
				poApprCnt	= poApprCnt + 1;
			}
		}
	}
	console.log("poTargetCnt : " + poTargetCnt + ", poIssCnt : " + poIssCnt + ", poArrpCnt : " + poApprCnt);
	if ( 0 == poIssCnt ) {
		$("#cirIssue").addClass("circle_grey");
		$("#cirIssue").removeClass("circle_red");
		$("#cirIssue").removeClass("circle_blue");
		$("#cirAppro").addClass("circle_grey");
		$("#cirAppro").removeClass("circle_red");
		$("#cirAppro").removeClass("circle_blue");
	} else {
		if ( poTargetCnt == poIssCnt ) {
			$("#cirIssue").removeClass("circle_grey");
			$("#cirIssue").removeClass("circle_red");
			$("#cirIssue").addClass("circle_blue");
			if ( poIssCnt == poApprCnt ) {
				$("#cirAppro").removeClass("circle_grey");
				$("#cirAppro").removeClass("circle_red");
				$("#cirAppro").addClass("circle_blue");
			} else {
				$("#cirAppro").removeClass("circle_grey");
				$("#cirAppro").addClass("circle_red");
				$("#cirAppro").removeClass("circle_blue");
			}
		} else {
			$("#cirIssue").removeClass("circle_grey");
			$("#cirIssue").addClass("circle_red");
			$("#cirIssue").removeClass("circle_blue");
			if ( 0 < poApprCnt ) {
				$("#cirAppro").removeClass("circle_grey");
				$("#cirAppro").addClass("circle_red");
				$("#cirAppro").removeClass("circle_blue");
			} else {
				$("#cirAppro").addClass("circle_grey");
				$("#cirAppro").removeClass("circle_red");
				$("#cirAppro").removeClass("circle_blue");
			}
		}
	}
}
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
			editable : false,
			usePaging : false,
			showFooter : true,
			showRowNumColumn : false,
			showRowCheckColumn : true,
			showStateColumn : false,
			wrapSelectionMove : true		//	칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
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
				dataField : "planGrYear",
				headerText : "Plan Gr Year",
				visible : false
			}, {
				dataField : "planGrMonth",
				headerText : "Plan Gr Month",
				visible : false
			}, {
				dataField : "planGrWeek",
				headerText : "Plan Gr Week",
				visible : false
			}, {
				dataField : "cdc",
				headerText : "Cdc Name",
				visible : false
			}, {
				dataField : "cdcDesc",
				headerText : "cdcDesc",
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
			}/*, {
				dataField : "chk",
				headerText : "<input type='checkbox' id='allCheckBox' style='width:15px;height:15px;'>",
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false,
					editable : true,
					checkValue : "1",
					unCheckValue : "0"
				}
			}*/, {
				dataField : "type",
				headerText : "Type",
				filter : {
					showIcon : true
				},
				style : "my-columnCenter0",
				width : "13%"
			}, {
				dataField : "stockCode",
				headerText : "Material",
				style : "my-columnCenter0",
				width : "13%"
			}, {
				dataField : "name",
				headerText : "Desc.",
				style : "my-columnLeft0",
				width : "40%"
			}, {
				dataField : "planQty",
				headerText : "Plan Qty",
				dataType : "numeric",
				//formatString : "#,##0",
				style : "my-columnRight0",
				width : "17%"
			}, {
				dataField : "poQty",
				headerText : "Issued Qty",
				dataType : "numeric",
				//formatString : "#,##0",
				style : "my-columnRight0",
				width : "17%"
			}, {
				dataField : "poStusId",
				headerText : "Po Stus Id",
				visible : false
			}, {
				dataField : "purchPrc",
				headerText : "Purchase Price",
				visible : false
			}, {
				dataField : "prcUnit",
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
				headerText : "W01",
				visible : false
			}, {
				dataField : "w02",
				headerText : "W02",
				visible : false
			}, {
				dataField : "w03",
				headerText : "W03",
				visible : false
			}, {
				dataField : "w04",
				headerText : "W04",
				visible : false
			}, {
				dataField : "w05",
				headerText : "W05",
				visible : false
			}, {
				dataField : "w06",
				headerText : "W06",
				visible : false
			}, {
				dataField : "w07",
				headerText : "W07",
				visible : false
			}, {
				dataField : "w08",
				headerText : "W08",
				visible : false
			}, {
				dataField : "w09",
				headerText : "W09",
				visible : false
			}, {
				dataField : "w10",
				headerText : "W10",
				visible : false
			}, {
				dataField : "w11",
				headerText : "W11",
				visible : false
			}, {
				dataField : "w12",
				headerText : "W12",
				visible : false
			}, {
				dataField : "w13",
				headerText : "W13",
				visible : false
			}, {
				dataField : "w14",
				headerText : "W14",
				visible : false
			}, {
				dataField : "w15",
				headerText : "W15",
				visible : false
			}, {
				dataField : "w16",
				headerText : "W16",
				visible : false
			}, {
				dataField : "w17",
				headerText : "W17",
				visible : false
			}, {
				dataField : "w18",
				headerText : "W18",
				visible : false
			}, {
				dataField : "w19",
				headerText : "W19",
				visible : false
			}, {
				dataField : "w20",
				headerText : "W20",
				visible : false
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
	AUIGrid.setFooter(myGridID, poCreateListFooterLayout);
	AUIGrid.bind(myGridID, "cellEditBegin", fnEventCellEdit);
	AUIGrid.bind(myGridID, "cellEditEnd", fnEventCellEdit);
	AUIGrid.bind(myGridID, "cellEditCancel", fnEventCellEdit);
	AUIGrid.bind(myGridID, "addRow", fnEventRowAdd);
	AUIGrid.bind(myGridID, "removeRow", fnEventRowRemove);
	AUIGrid.bind(myGridID, "cellClick", function(event) {
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
							<!-- <input class="w100p" type="text" id="scmStockCode" name="scmStockCode" onkeypress="if(event.keyCode==13) {fnSalesPlanHeader(); return false;}"> -->
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
		<div class="divine_auto type2 mt30"><!-- divine_auto start -->
			<div style="width:40%;">
				<div class="border_box" style="min-height:130px"><!-- border_box start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역1 -->
						<div id="poTargetListGridDiv"></div>
					</article><!-- grid_wrap end -->
				</div><!-- border_box end -->
			</div>
			<div style="width:60%;">
				<div class="border_box" style="min-height:130px"><!-- border_box start -->
					<article class="grid_wrap"><!-- grid_wrap start -->
						<!-- 그리드 영역2 -->
						<div id="poCreateListGridDiv"></div>
					</article><!-- grid_wrap end -->
					<ul class="btns">
						<li><a onclick="fnMoveStockGroup();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
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
			<div id="poCreatedListGridDiv" style="height:234px;"></div>
		</article><!-- grid_wrap end -->
	</section>
</section><!-- content end -->