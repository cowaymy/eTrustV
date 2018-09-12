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
var gWeekThValue	= "";
var gParamStockCode	= "";

$(function() {
	fnScmYearCbBox();		//fnSelectExcuteYear
	fnScmWeekCbBox();		//fnSelectPeriodReset
	fnScmCdcCbBox();		//fnSelectCDCComboList : 349
	fnScmStockTypeCbBox();	//fnSelectStockTypeComboList : 15
	fnScmStockCodeCbBox();	//fnSetStockComboBox
});

//	year
function fnScmYearCbBox() {
	//	callback
	var fnScmWeekCbBoxCallback	= function() {
		$("#scmYearCbBox").on("change", function() {
			var $this	= $(this);
			
			CommonCombo.initById("scmWeekCbBox");	//	scmPeriodCbBox
			
			if ( FormUtil.isNotEmpty($this.val()) ) {
				CommonCombo.make("scmWeekCbBox"	//	scmPeriodCbBox
						, "/scm/selectScmWeekByYear.do"	//	"/scm/selectPeriodByYear.do"
						, { year : $this.val() }
						, ""
						, {
							id : "weekTh",
							name : "scmWeek",	//	scmPeriod
							chooseMessage : "Select a WEEK"
						}
						, "");
			} else {
				fnScmWeekCbBox();
			}
		});
	};
	
	CommonCombo.make("scmYearCbBox"
			, "/scm/selectScmYear.do"	//	"/scm/selectExcuteYear.do"
			, ""
			, ""
			, {
				id : "year",
				name : "year",
				chooseMessage : "Year"
			}
			, fnScmWeekCbBoxCallback);
}

//	week
function fnScmWeekCbBox() {
	CommonCombo.initById("scmWeekCbBox");	//	reset
	var weekChkBox	= document.getElementById("scmWeekCbBox");
	weekChkBox.options[0]	= new Option("Select a WEEK", "");
}

//	Cdc
function fnScmCdcCbBox() {
	CommonCombo.make("scmCdcCbBox"
			, "/scm/selectScmCdc.do"	//	"/scm/selectComboSupplyCDC.do"
			, ""
			, ""
			, {
				id : "code",			//	2010, 2020, 2030, ...
				name : "codeName",		//	Kualaa Lumpur, Penang, Joho Baru, ...
				//	"codeDesc",			//	KL, PN, JB
				chooseMessage : "Select a CDC"
			}
			, "");
}

//	stock type
function fnScmStockTypeCbBox() {
	//	callback
	var fnScmStockCbBoxCallback	= function() {
		$("#scmStockTypeCbBox").on("change", function() {
			var $this	= $(this);
			
			CommonCombo.initById("scmStockCodeCbBox");
			
			if ( FormUtil.isNotEmpty($this.val()) ) {
				CommonCombo.make("scmStockCodeCbBox"
						, "/scm/selectScmStockCode.do"
						, { typeId : $this.val() + "" }
						, ""
						, {
							id : "stkCode",
							name : "stkDesc",
							type : "M",
							chooseMessage : "ALL"
						}
						, "");
			} else {
				fnScmStockCodeCbBox();
			}
		});
	};
	
	CommonCombo.make("scmStockTypeCbBox"
			, "/scm/selectScmStockType.do"	//	"/scm/selectComboSupplyCDC.do"
			, ""
			, ""
			, {
				id : "codeId",
				name : "codeName",
				type : "M",
				chooseMessage : "ALL"
			}
			, fnScmStockCbBoxCallback);
}

//	stock code
function fnScmStockCodeCbBox() {
	CommonCombo.make("scmStockCodeCbBox"
			, "/scm/selectScmStockCode.do"	//	"/scm/selectStockCode.do"
			, ""
			, ""
			, {
				id : "stkCode",
				name : "stkDesc",
				type : "M",
				chooseMessage : "ALL"
			}
			, "");
}
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
		<li><p class="btn_blue"><a onclick="fnByCdcSettiingHeader();"><span class="search"></span>Search</a></p></li>
	</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="post" action="">
	<table class="type1"><!-- table start -->
	<caption>table</caption>
		<colgroup>
			<col style="width:130px" />
			<col style="width:*" />
			<col style="width:130px" />
			<col style="width:*" />
			<col style="width:130px" />
			<col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">EST Year &amp; Week</th>
				<td colspan="3">
					<div class="date_set w100p"><!-- date_set start -->
						<select class="sel_year" id="scmYearCbBox" name="scmYearCbBox"></select>
						<select class="sel_date"  id="scmWeekCbBox" name="scmWeekCbBox"></select>
					</div><!-- date_set end -->
				</td>
				<th scope="row">CDC</th>
				<td>
					<select id="scmCdcCbBox" name="scmCdcCbBox"></select>
				</td>
			</tr>
			<tr>
				<!-- Stock Type 추가 -->
				<th scope="row">Stock Type</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
				</td>
				<th scope="row">Stock</th>
				<td>
					<select class="w100p" multiple="multiple" id="scmStockCodeCbBox" name="scmStockCodeCbBox"></select>
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
			<li><p id="btnCreate" class="btn_grid btn_disabled"><a onclick="fnCreatePreviousSupplyPlan(this);">Create</a></p></li>
			<li><p id="btnSave" class="btn_grid btn_disabled"><a onclick="fnUpdateSave(this);">Save</a></p></li>
			<li><p id="btnConfirm" class="btn_grid btn_disabled"><a onclick="fnConfirmSave(this);">Confirm</a></p></li>
		</ul>
	</div><!-- side_btns end -->

	<article class="grid_wrap"><!-- grid_wrap start -->
		<!-- 그리드 영역 -->
		<div id="dynamic_DetailGrid_wrap" style="height:350px;"></div>
	</article><!-- grid_wrap end -->

	<ul class="center_btns">
		<li><p class="btn_blue2 big"><!-- <a href="javascript:void(0);">Download Raw Data</a> <a onclick="fnExcelExport('SalesPlanManagement');">Download</a> --></p></li>
	</ul>
</section><!-- search_result end -->

</section><!-- content end -->