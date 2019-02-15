<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">
/* Custom Sales Accuracy Style */
</style>

<script type="text/javascript">
var planYearMonth	= "";
var planYear	= 0;
var planMonth	= 0;
var planWeek	= 0;

$(function(){
	fnScmTotalPeriod();
	fnScmTeamCbBox();
});

/*
 * Button Functions
 */
function fnSearch() {
	
}
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. export ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	GridCommon.exportTo("#sales_plan_wrap", "xlsx", fileName + "_" + getTimeStamp());
}

/*
 * User Functions
 */
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
				if ( 0 < planMonth && 10 > planMonth ) {
					planYearMonth	= planYear + "0" + planMonth;
				} else {
					planYearMonth	= planYear + planMonth;
				}
				fnScmWeekCbBox();
			});
}
//	month change
function fnPlanYearMOnthChange() {
	console.log("planYearMonth : " + $("#sales").val());
	//planYear	= $("#sales").val().substring
}
//	today week
function fnScmWeekCbBox() {
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
//	team
function fnScmTeamCbBox() {
	CommonCombo.make("scmTeamCbBox"
			, "/scm/selectScmTeam.do"
			, ""
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
				//chooseMessage : "All"
			}
			, "");
}

/*
 * Util Functions
 */
function getTimeStamp() {
	function fnLeadingZeros(n, digits) {
		var zero	= "";
		n	= n.toString();
		if ( n.length < digits ) {
			for ( var i = 0 ; i < digits - n.length ; i++ ) {
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
/*
 * Grid create & setting
 */

</script>

<section id="content">						<!-- section content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order List</li>
	</ul>
	
	<aside class="title_line">				<!-- aside title_line start -->
		<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
		<h2>Sales Plan Accuracy</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick=""><span class="search"></span>Search</a></p></li>
		</ul>
	</aside>								<!-- aside title_line end -->
	
	<section class="search_table">			<!-- section search_table start -->
		<form id="MainForm" method="post" action="">
			<table class="type1">			<!-- table type1 start -->
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
						<th scope="row">Year &amp; Month</th>
						<td>
							<input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="planYearMonth" name="planYearMonth" onchange="fnPlanYearMOnthChange();" />
						</td>
						<th scope="row">Week</th>
						<td>
							<select class="w100p" id="scmTeamCbBox" name="scmTeamCbBox"></select>
						</td>
						<th scope="row">Team</th>
						<td>
							<select class="w100p" id="scmTeamCbBox" name="scmTeamCbBox"></select>
						</td>
					</tr>
				</tbody>
			</table>						<!-- table type1 end -->
			
			<aside class="link_btns_wrap">	<!-- aside link_btns_wrap start -->
				<p class="show_btn"></p>
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
			</aside>						<!-- aside link_btns_wrap end -->
		</form>
	</section>								<!-- section search_table end -->
</section>									<!-- section content end -->

<section class="search_result">				<!-- section search_result start -->
	<article class="grid_wrap">				<!-- article grid_wrap start -->
		<!-- Monthly Grid -->
		<div id="monthly_wrap" style="height:226;"></div>
	</article>								<!-- article grid_wrap end -->
	<ul class="right_btns">
		<li><p id="btnExcel" class="btn_grid btn_disabled"><a onclick="fnExcel(this, 'SalesPlanAccuracy');">Excel</a></p></li>
	</ul>
	<article class="grid_wrap">				<!-- article grid_wrap start -->
		<!-- Weekly Grid -->
		<div id="weekly_wrap" style="height:400px;"></div>
	</article>								<!-- article grid_wrap end -->
</section>									<!-- section search_result end -->