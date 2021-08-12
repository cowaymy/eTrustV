<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
	text-align:left;
}
</style>

<script type="text/javaScript">
var setMainRowIdx	= 0;

$(function() {
	//	stock type
	fnSelectStockTypeComboList("15");
	//	category
	fnSelectCategoryComboList("11");
});

function fnSelectStockTypeComboList(codeId) {
	CommonCombo.make("scmStockTypeCbBox"
					, "/scm/selectComboSupplyCDC.do"
					, { codeMasterId: codeId }
					, ""
					, {
						id  : "codeId",		//	use By query's parameter values(real value)
						name: "codeName",	//	display
						chooseMessage: "All"
					}
					, "");
}
			
function fnSelectCategoryComboList(codeId) {
	CommonCombo.make("scmCategoryCbBox"
					, "/scm/selectComboSupplyCDC.do"
					, { codeMasterId: codeId }
					, ""
					, {
						id  : "codeId",		//	use By query's parameter values(real value)
						name: "codeName",	//	display
						chooseMessage: "All"
					}
				, "");
}

function fnSelectBoxChanged() {
	$("#menuCdNm").val("");
	$("#menuCdNm").focus();
}

function fnClose() {
	$("#scmMstMngmentAddPop").remove();
}

function fnStockTypeCbBoxChangeEvent(obj) {
	fnSelectCategoryData();
}

function fnCategoryCbBoxChangeEvent(obj) {
	fnSelectCategoryData();
}

function fnSelectCategoryData() {
	Common.ajax("GET"
	, "/scm/selectInvenCbBoxByCategory.do"
	, $("#PopForm").serialize()
	, function(result) {
		AUIGrid.setGridData(MasterGridID, result.scmMstInvenByCategoryList);
		
		if ( 0 < result.scmMstInvenByCategoryList.length ) {
			//console.log("Length: " + result.scmMstInvenByCategoryList.length + " /stockCode: " + result.scmMstInvenByCategoryList[0].stkCode );
		}
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

function fnSaveAsIns() {
	if ( 0 == $("#stkId").val().length ) {
		Common.alert('<spring:message code="sys.msg.first.Select" arguments=" [Stock Infomation] " htmlEscape="false"/>');
		return	false;
	}
	
	isValidDate($("#StartedDateTxt").val());
	isValidDate($("#EndDateTxt").val());
	
	if ( AUIGrid.formatDate(isValidDate($("#EndDateTxt").val()), "yyyymmdd") < AUIGrid.formatDate(isValidDate($("#StartedDateTxt").val()), "yyyymmdd") ) {
		Common.alert("<spring:message code='sys.msg.limitMore' arguments='START DATE ; END DATE.' htmlEscape='false' argumentSeparator=';'/>");
		$("#EndDateTxt").val("");
		return	false;
	}
	
	if ( $("#supplyPlanSafetyStockTxt").val().length == 0 || $("#supplyPlanSafetyStockTxt").val() < 0 )	$("#supplyPlanSafetyStockTxt").val("0");
	if ( $("#supplyPlanLTtxt").val().length == 0  || $("#supplyPlanLTtxt").val() < 0 )					$("#supplyPlanLTtxt").val("0");
	if ( $("#supplyPlanMoqTxt").val().length == 0 || $("#supplyPlanMoqTxt").val() < 0 )					$("#supplyPlanMoqTxt").val("0");
	if ( $("#supplyPlanLoadingQtyTxt").val().length == 0 || $("#supplyPlanLoadingQtyTxt").val() < 0 )	$("#supplyPlanLoadingQtyTxt").val("0");
	
	Common.ajax("POST"
		, "/scm/insertMstMngMasterCDC.do"
		, $("#PopForm").serializeJSON({checkboxUncheckedValue: "0"})
		, function(result) {
			Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
			fnSelectCategoryData();
			console.log("성공." + JSON.stringify(result));
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

var MasterGridLayout	=
	[
		{
			dataField : "stkCode",
			headerText : "<spring:message code='sys.scm.pomngment.stockCode' />",
			style : "aui-grid-left-column",
			width : "20%",
		},
		{
			dataField : "stkName",
			headerText : "<spring:message code='sys.scm.pomngment.stockName' />",
			style : "aui-grid-left-column",
			width : "80%",
		},
		{
			dataField : "stkId",
			visible : false,
		},
		{
			dataField : "categoryId",
			visible : false,
		},
		{
			dataField : "stkTypeCode",
			visible : false,
		},
		{
			dataField : "categoryCode",
			visible : false,
		},
		{
			dataField : "stkType",
			visible : false,
		}
	];

var MainGridOptions	=
	{
		usePaging : true,
		pagingMode : "simple",	//	페이징을 간단한 유형으로 나오도록 설정
		useGroupingPanel : false,
		editable : false,
		showStateColumn : false,	//	행 상태 칼럼 보이기
		showRowNumColumn : false	//	그리드 넘버링
	};

/***************************************************[ Main GRID] ***************************************************/
var MasterGridID;

$(document).ready(function() {
	$("#scmStockNameTxt").bind("keyup", function() {
		$(this).val($(this).val().toUpperCase());
	});
	
	$("#scmStockNameTxt").keypress(function (event) {
		if ( 13 == event.keyCode )	fnSelectCategoryData();
	});
	
	$("#stkId").val("");
	
	/********************************
	Master GRID
	*********************************/
	//	AUIGrid 그리드를 생성합니다.
	MasterGridID	= GridCommon.createAUIGrid("MasterGridDiv", MasterGridLayout,"", MainGridOptions);
	
	//	cellClick event.
	AUIGrid.bind(MasterGridID, "cellClick", function( event ) {
		$("#stockCodeTxt").val(AUIGrid.getCellValue(MasterGridID, event.rowIndex, "stkCode"));
		$("#stockTypeTxt").val(AUIGrid.getCellValue(MasterGridID, event.rowIndex, "stkType"));
		$("#categoryTxt").val(AUIGrid.getCellValue(MasterGridID, event.rowIndex, "categoryCode"));
		$("#descriptionTxt").val(AUIGrid.getCellValue(MasterGridID, event.rowIndex, "stkName"));
		$("#stkId").val(AUIGrid.getCellValue(MasterGridID, event.rowIndex, "stkId"));
	});
	
	//	셀 더블클릭 이벤트 바인딩
	AUIGrid.bind(MasterGridID, "cellDoubleClick", function(event) {
		console.log("cellDoubleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
	});
	
	//	CategoryList search
	fnSelectCategoryData();
});	//$(document).ready
</script>

<body>
	<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>SCM Master Management Add New</h1>
		<ul class="right_opt">
			<!-- <li><p class="btn_blue2"><a onclick="fnClose();">CLOSE</a></p></li>  -->
		</ul>
	</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<form id="PopForm" method="get" action="" onsubmit="return false;">
				<input type ="hidden" id="stkId" name="stkId" value=""/>
				<div class="divine_auto"><!-- divine_auto start -->
					<div style="width:35%;">
						<div class="border_box" style="height:506px;"><!-- border_box start -->
							<ul class="right_btns">
								<li><p class="btn_blue"><a onclick="fnSelectCategoryData();"><span class="search"></span>Search</a></p></li>
							</ul>
							<table class="type1 mt10"><!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width:110px" />
									<col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">Stock Type</th>
										<td>
											<select class="w100p" id="scmStockTypeCbBox" name="scmStockTypeCbBox" onchange="fnStockTypeCbBoxChangeEvent(this);">
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">Category</th>
										<td>
											<select class="w100p" id="scmCategoryCbBox" name="scmCategoryCbBox" onchange="fnCategoryCbBoxChangeEvent(this);">
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">Stock Name</th>
										<td>
											<input type="text" id="scmStockNameTxt" name="scmStockNameTxt" title="" placeholder="" class="w100p" />
										</td>
									</tr>
								</tbody>
							</table><!-- table end -->
							<article class="grid_wrap"><!-- grid_wrap start -->
								<div id="MasterGridDiv" style="width:100%; height:390px; margin:0 auto;"></div>
							</article><!-- grid_wrap end -->
						</div><!-- border_box end -->
					</div>
					<div style="width:65%;">
						<div class="border_box"><!-- border_box start -->
							<aside class="title_line"><!-- title_line start -->
								<h2>Stock Info</h2>
							</aside><!-- title_line end -->
							<table class="type1"><!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width:110px" />
									<col style="width:*" />
									<col style="width:100px" />
									<col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">Stock Code</th>
										<td colspan="3">
											<input type="text" id="stockCodeTxt" name="stockCodeTxt" title="" placeholder="" class="w100p readonly" readonly="readonly" onkeydown="return false;"/>
										</td>
									</tr>
									<tr>
										<th scope="row">Stock Type</th>
										<td>
											<input type="text" id="stockTypeTxt" name="stockTypeTxt" title="" placeholder="" class="w100p readonly" readonly="readonly" onkeydown="return false;"/>
										</td>
										<th scope="row">Category</th>
										<td>
											<input type="text" id="categoryTxt" name="categoryTxt" title="" placeholder="" class="w100p readonly" readonly="readonly" onkeydown="return false;"/>
										</td>
									</tr>
									<tr>
										<th scope="row">Description</th>
										<td colspan="3">
											<input type="text" id="descriptionTxt" name="descriptionTxt" title="" placeholder="" class="w100p readonly" readonly="readonly" onkeydown="return false;"/>
										</td>
									</tr>
								</tbody>
							</table><!-- table end -->
							<aside class="title_line"><!-- title_line start -->
								<h2>Sales Planning</h2>
							</aside><!-- title_line end -->
							<table class="type1"><!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width:110px" />
									<col style="width:*" />
									<col style="width:100px" />
									<col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">Target</th>
										<td colspan="3">
											<label><input type="radio" id="targetYNRadioY" name="targetYNRadio" value="1" checked="checked"/><span>Yes</span></label>
											<label><input type="radio" id="targetYNRadioN" name="targetYNRadio" value="0"/><span>No</span></label>
										</td>
									</tr>
									<tr>
										<th scope="row">Started</th>
										<td>
											<input type="text" id="StartedDateTxt" name="StartedDateTxt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
										</td>
										<th scope="row">Ended</th>
										<td>
											<input type="text" id="EndDateTxt" name="EndDateTxt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
										</td>
									</tr>
									<tr>
										<th scope="row">Memo</th>
										<td colspan="3">
											<textarea cols="20" rows="5" id="memoTxt" name="memoTxt" placeholder=""></textarea>
										</td>
									</tr>
								</tbody>
							</table><!-- table end -->
							<aside class="title_line"><!-- title_line start -->
								<h2>Supply Planning</h2>
							</aside><!-- title_line end -->
							<table class="type1"><!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width:110px" />
									<col style="width:*" />
									<col style="width:100px" />
									<col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">Target</th>
										<td colspan="3">
											<label><input type="checkbox" id="klChkbox" name="klChkbox" value="1"  checked="checked"/><span>KL</span></label>
											<label><input type="checkbox" id="kkChkbox" name="kkChkbox" value="1"  checked="checked"/><span>KK</span></label>
											<label><input type="checkbox" id="jbChkbox" name="jbChkbox" value="1"  checked="checked"/><span>JB</span></label>
											<label><input type="checkbox" id="pnChkbox" name="pnChkbox" value="1"  checked="checked"/><span>PN</span></label>
											<label><input type="checkbox" id="kcChkbox" name="kcChkbox" value="1"  checked="checked"/><span>KC</span></label>
										</td>
									</tr>
									<tr>
										<th scope="row">Safety Stock</th>
										<td>
											<input type="text" title="" id="supplyPlanSafetyStockTxt" name="supplyPlanSafetyStockTxt" value="60" placeholder="" class="w100p al_right" />
										</td>
										<th scope="row">LT</th>
										<td>
											<input type="text" title="" id="supplyPlanLTtxt" name="supplyPlanLTtxt" value="8" placeholder="" class="w100p al_right" />
										</td>
									</tr>
									<tr>
										<th scope="row">MOQ</th>
										<td>
											<input type="text" title="" id="supplyPlanMoqTxt" name="supplyPlanMoqTxt" value="50" placeholder="" class="w100p al_right" />
										</td>
										<th scope="row">Loading Quantity</th>
										<td>
											<input type="text" title="" id="supplyPlanLoadingQtyTxt" name="supplyPlanLoadingQtyTxt" value="0" placeholder="" class="w100p al_right" />
										</td>
									</tr>
									<tr>
										<th scope="row">Remark</th>
										<td colspan="3">
											<textarea id="supplyPlanRemarkTxt" name="supplyPlanRemarkTxt"  cols="20" rows="5" placeholder=""></textarea>
										</td>
									</tr>
								</tbody>
							</table><!-- table end -->
							<ul class="center_btns">
								<li><p class="btn_blue2 big"><a onclick="fnSaveAsIns();">Save</a></p></li>
								<!-- <li><p class="btn_blue2 big"><a href="javascript:void(0);">Delete</a></p></li> -->
								<li><p class="btn_blue2 big"><a onclick="fnClose();">Close</a></p></li>
							</ul>
						</div><!-- border_box end -->
					</div>
				</div><!-- divine_auto end -->
			</form>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
</body>
</html>