<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">
/* Custom On-Time Delivery Report Style */
.my-columnCenter {
	text-align : center;
	margin-top : -20px;
}
.my-columnRight {
	text-align : right;
	margin-top : -20px;
}
.my-columnLeft {
	text-align : left;
	margin-top : -20px;
}
.my-columnHyperLink:hover {
	text-decoration : underline;
	text-align : center;
	margin-top : -20px;
	cursor : pointer;
}
.aui-grid-selection-cell-border-lines {
	background: #22741C; 
}
</style>

<script type="text/javascript">
var gPlanYearMonth	= "";
var gPlanYear	= 0;
var gPlanMonth	= 0;
var gPlanWeek	= 0;

var listObj	= new Object();

$(function(){
	fnScmTotalPeriod();
	fnScmStockCategoryCbBox();
	fnScmStockTypeCbBox();
});

/*
 * Button Functions
 */
function fnSearch() {
	var params	= {
		scmStockTypeCbBox : $("#scmStockTypeCbBox").multipleSelect("getSelects"),
		scmStockCategoryCbBox : $("#scmStockCategoryCbBox").multipleSelect("getSelects")
	};
	params	= $.extend($("#MainForm").serializeJSON(), params);
	Common.ajax("POST"
			, "/scm/selectAgingInventory.do"
			, params
			, function(result) {
				listObj	= result.selectAgingInventory;
				fnSetResult();
			}
			, ""
			, { async : true, isShowLabel : false });
}
function fnExcel(obj, fileName) {
	//	1. grid id
	//	2. type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	//	3. export ExcelFileName  MonthlyGridID, WeeklyGridID
	if ( true == $(obj).parents().hasClass("btn_disabled") ) {
		return	false;
	}
	GridCommon.exportTo("#aging_wrap", "xlsx", fileName + "_" + getTimeStamp());
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
				gPlanYear	= result.selectScmTotalPeriod[0].scmYear;
				gPlanMonth	= result.selectScmTotalPeriod[0].scmMonth;
				gPlanWeek	= result.selectScmTotalPeriod[0].scmWeek;
				if ( 1 == gPlanMonth ) {
					gPlanYear	= parseInt(gPlanYear) - 1;
					gPlanMonth	= 12;
				} else {
					gPlanMonth	= parseInt(gPlanMonth) - 1;
				}
				if ( 0 < gPlanMonth && 10 > gPlanMonth ) {
					gPlanYearMonth	= "0" + gPlanMonth + "/" + gPlanYear;
				} else {
					gPlanYearMonth	= gPlanMonth + "/" + gPlanYear;
				}
				
				$("#planYearMonth").val(gPlanYearMonth);
			});
}
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
function fnScmStockTypeCbBox() {
	var params	= $.extend($("#MainForm").serializeJSON(), params);
	CommonCombo.make("scmStockTypeCbBox"
			, "/scm/selectScmStockType.do"
			, params
			, ""
			, {
				id : "id",
				name : "name",
				type : "M"
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
function fnPlanYearMonthChange() {
	console.log($("#planYearMonth").val());
}
function fnSetResult() {
	var qtyList	= new Array();
	var amtList	= new Array();
	
	for ( var i = 0 ; i < listObj.length ; i++ ) {
		var temp	= new Object();
		temp.typeName	= listObj[i].typeName;
		temp.categoryName	= listObj[i].categoryName;
		temp.stockCode	= listObj[i].stockCode;
		temp.stockName	= listObj[i].stockName;
		//if ( 1 == listObj[i].seq )	temp.agingName	= "Aging (Receivinig)";		else	temp.agingName	= "On-hand (Forwarding)";
		//temp.aging		= listObj[i].aging;
		//if ( 1 == listObj[i].seq )	temp.monHis		= "Receiving";	else	temp.monHis		= "Forwarding";
		temp.handQty	= listObj[i].handQty;
		temp.ageOneSum	= listObj[i].ageOneSum;
		temp.ageTwoSum	= listObj[i].ageTwoSum;
		temp.ageThrSum	= listObj[i].ageThrSum;
		temp.ovrThrSum	= listObj[i].ovrThrSum;
		temp.m101		= listObj[i].m101;	temp.m102		= listObj[i].m102;	temp.m103		= listObj[i].m103;	temp.m104		= listObj[i].m104;	temp.m105		= listObj[i].m105;	temp.m106		= listObj[i].m106;
		temp.m107		= listObj[i].m107;	temp.m108		= listObj[i].m108;	temp.m109		= listObj[i].m109;	temp.m110		= listObj[i].m110;	temp.m111		= listObj[i].m111;	temp.m112		= listObj[i].m112;
		temp.m201		= listObj[i].m201;	temp.m202		= listObj[i].m202;	temp.m203		= listObj[i].m203;	temp.m204		= listObj[i].m204;	temp.m205		= listObj[i].m205;	temp.m206		= listObj[i].m206;
		temp.m207		= listObj[i].m207;	temp.m208		= listObj[i].m208;	temp.m209		= listObj[i].m209;	temp.m210		= listObj[i].m210;	temp.m211		= listObj[i].m211;	temp.m212		= listObj[i].m212;
		temp.m301		= listObj[i].m301;	temp.m302		= listObj[i].m302;	temp.m303		= listObj[i].m303;	temp.m304		= listObj[i].m304;	temp.m305		= listObj[i].m305;	temp.m306		= listObj[i].m306;
		temp.m307		= listObj[i].m307;	temp.m308		= listObj[i].m308;	temp.m309		= listObj[i].m309;	temp.m310		= listObj[i].m310;	temp.m311		= listObj[i].m311;	temp.m312		= listObj[i].m312;
		temp.m3Over		= listObj[i].m3Over;
		
		temp.purchPrc	= listObj[i].purchPrc;
		qtyList.push(temp);
		
		var temp1	= new Object();
		temp1.typeName	= listObj[i].typeName;
		temp1.categoryName	= listObj[i].categoryName;
		temp1.stockCode	= listObj[i].stockCode;
		temp1.stockName	= listObj[i].stockName;
		//if ( 1 == listObj[i].seq )	temp1.agingName	= "Aging (Receiving)";		else	temp1.agingName	= "On-hand (Forwarding)";
		//temp1.aging		= (parseInt(listObj[i].aging) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		//if ( 1 == listObj[i].seq )	temp1.monHis	= "Receiving";	else	temp1.monHis	= "Forwarding";
		temp1.handQty	= (parseInt(listObj[i].handQty) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].ageOneSum )	temp1.ageOneSum	= " ";	else	temp1.ageOneSum	= (parseInt(listObj[i].ageOneSum) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].ageTwoSum )	temp1.ageTwoSum	= " ";	else	temp1.ageTwoSum	= (parseInt(listObj[i].ageTwoSum) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].ageThrSum )	temp1.ageThrSum	= " ";	else	temp1.ageThrSum	= (parseInt(listObj[i].ageThrSum) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].ovrThrSum )	temp1.ovrThrSum	= " ";	else	temp1.ovrThrSum	= (parseInt(listObj[i].ovrThrSum) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m101 )	temp1.m101	= " ";	else	temp1.m101		= (parseInt(listObj[i].m101) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m102 )  temp1.m102  = " ";  else  temp1.m102		= (parseInt(listObj[i].m102) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m103 )  temp1.m103  = " ";  else  temp1.m103		= (parseInt(listObj[i].m103) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m104 )  temp1.m104  = " ";  else  temp1.m104		= (parseInt(listObj[i].m104) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m105 )  temp1.m105  = " ";  else  temp1.m105		= (parseInt(listObj[i].m105) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m106 )  temp1.m106  = " ";  else  temp1.m106		= (parseInt(listObj[i].m106) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m107 )  temp1.m107  = " ";  else  temp1.m107		= (parseInt(listObj[i].m107) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m108 )  temp1.m108  = " ";  else  temp1.m108		= (parseInt(listObj[i].m108) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m109 )  temp1.m109  = " ";  else  temp1.m109		= (parseInt(listObj[i].m109) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m110 )  temp1.m110  = " ";  else  temp1.m110		= (parseInt(listObj[i].m110) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m111 )  temp1.m111  = " ";  else  temp1.m111		= (parseInt(listObj[i].m111) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m112 )  temp1.m112  = " ";  else  temp1.m112		= (parseInt(listObj[i].m112) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m201 )  temp1.m201  = " ";  else  temp1.m201		= (parseInt(listObj[i].m201) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m202 )  temp1.m202  = " ";  else  temp1.m202		= (parseInt(listObj[i].m202) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m203 )  temp1.m203  = " ";  else  temp1.m203		= (parseInt(listObj[i].m203) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m204 )  temp1.m204  = " ";  else  temp1.m204		= (parseInt(listObj[i].m204) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m205 )  temp1.m205  = " ";  else  temp1.m205		= (parseInt(listObj[i].m205) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m206 )  temp1.m206  = " ";  else  temp1.m206		= (parseInt(listObj[i].m206) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m207 )  temp1.m207  = " ";  else  temp1.m207		= (parseInt(listObj[i].m207) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m208 )  temp1.m208  = " ";  else  temp1.m208		= (parseInt(listObj[i].m208) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m209 )  temp1.m209  = " ";  else  temp1.m209		= (parseInt(listObj[i].m209) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m210 )  temp1.m210  = " ";  else  temp1.m210		= (parseInt(listObj[i].m210) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m211 )  temp1.m211  = " ";  else  temp1.m211		= (parseInt(listObj[i].m211) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m212 )  temp1.m212  = " ";  else  temp1.m312		= (parseInt(listObj[i].m212) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m301 )  temp1.m301  = " ";  else  temp1.m301		= (parseInt(listObj[i].m301) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m302 )  temp1.m302  = " ";  else  temp1.m302		= (parseInt(listObj[i].m302) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m303 )  temp1.m303  = " ";  else  temp1.m303		= (parseInt(listObj[i].m303) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m304 )  temp1.m304  = " ";  else  temp1.m304		= (parseInt(listObj[i].m304) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m305 )  temp1.m305  = " ";  else  temp1.m305		= (parseInt(listObj[i].m305) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m306 )  temp1.m306  = " ";  else  temp1.m306		= (parseInt(listObj[i].m306) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m307 )  temp1.m307  = " ";  else  temp1.m307		= (parseInt(listObj[i].m307) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m308 )  temp1.m308  = " ";  else  temp1.m308		= (parseInt(listObj[i].m308) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m309 )  temp1.m309  = " ";  else  temp1.m309		= (parseInt(listObj[i].m309) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m310 )  temp1.m310  = " ";  else  temp1.m310		= (parseInt(listObj[i].m310) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m311 )  temp1.m311  = " ";  else  temp1.m311		= (parseInt(listObj[i].m311) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m312 )  temp1.m312  = " ";  else  temp1.m312		= (parseInt(listObj[i].m312) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		if ( null == listObj[i].m3Over )  temp1.m3Over  = " ";  temp1.m3Over	= (parseInt(listObj[i].m3Over) * parseFloat(listObj[i].purchPrc)).toFixed(1);
		temp1.purchPrc	= listObj[i].purchPrc;
		amtList.push(temp1);
	}
	
	if ( "1" == $("input[name='gbn']:checked").val() ) {
		AUIGrid.setGridData(myGridID, qtyList);
	} else {
		AUIGrid.setGridData(myGridID, amtList);
	}
}

/*
 * Grid create & setting
 */
var myGridID;
var myOption	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : false,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	showFooter : false,
	editable : false,
	enableCellMerge : true,
	enableRestore : false,
	fixedColumnCount : 7
};
var myLayout	= 
	[
	 	{
	 		headerText : "Type",
	 		dataField : "typeName",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "stockCode",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "Category",
	 		dataField : "categoryName",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "stockCode",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "Code",
	 		dataField : "stockCode",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "stockCode",
	 		style : "my-columnCenter"
	 	}, {
	 		headerText : "Name",
	 		dataField : "stockName",
	 		cellMerge : true,
			mergePolicy : "restrict",
			mergeRef : "stockCode",
	 		style : "my-columnLeft"
	 	}, {
	 		headerText : "On-hand",
	 		dataField : "handQty",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "~1Year",
	 		dataField : "ageOneSum",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "~2Year",
	 		dataField : "ageTwoSum",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "~3Year",
	 		dataField : "ageThrSum",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	}, {
	 		headerText : "3Year ~",
	 		dataField : "ovrThrSum",
	 		dataType : "numeric",
	 		style : "my-columnRight"
	 	},
	 	{	headerText : "-1M",	dataField : "m101",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-2M",	dataField : "m102",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-3M",	dataField : "m103",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-4M",	dataField : "m104",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-5M",	dataField : "m105",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-6M",	dataField : "m106",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-7M",	dataField : "m107",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-8M",	dataField : "m108",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-9M",	dataField : "m109",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-10M",	dataField : "m110",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-11M",	dataField : "m111",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-12M",	dataField : "m112",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-13M",	dataField : "m201",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-14M",	dataField : "m202",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-15M",	dataField : "m203",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-16M",	dataField : "m204",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-17M",	dataField : "m205",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-18M",	dataField : "m206",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-19M",	dataField : "m207",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-20M",	dataField : "m208",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-21M",	dataField : "m209",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-22M",	dataField : "m210",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-23M",	dataField : "m211",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-24M",	dataField : "m212",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-25M",	dataField : "m301",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-26M",	dataField : "m302",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-27M",	dataField : "m300",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-28M",	dataField : "m304",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-29M",	dataField : "m305",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-30M",	dataField : "m306",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-31M",	dataField : "m307",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-32M",	dataField : "m308",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-33M",	dataField : "m309",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-34M",	dataField : "m310",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-35M",	dataField : "m311",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-36M",	dataField : "m312",	dataType : "numeric",	style : "my-columnRight"	},
	 	{	headerText : "-36M Over",	dataField : "m3Over",	dataType : "numeric",	style : "my-columnRight"	}
	 ];
$(document).ready(function() {
	//	Summary Grid
	myGridID	= GridCommon.createAUIGrid("#aging_wrap", myLayout, "", myOption);
});
</script>

<section id="content">						<!-- section content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order List</li>
	</ul>
	
	<aside class="title_line">				<!-- aside title_line start -->
		<p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
		<h2>Aging Inventory</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside>								<!-- aside title_line end -->
	
	<section class="search_table">			<!-- section search_table start -->
		<form id="MainForm" method="get" action="">
			<input type="hidden" id="stockTypeId" name="stockTypeId" />
			<table class="type1">			<!-- table type1 start -->
			<caption>table</caption>
				<colgroup>
					<col style="width:140px" />
					<col style="width:140px" />
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:100px" />
					<col style="width:*" />
					<col style="width:100px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Month &amp; Year</th>
						<td>
							<input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="planYearMonth" name="planYearMonth" onchange="fnPlanYearMonthChange();" />
						</td>
						<th scope="row">Currency</th>
						<td>
							<label><input type="radio" name="gbn" id="gbn" value="2" checked="checked" onclick="fnSetResult()"/><span>Amount</span></label>
							<label><input type="radio" name="gbn" id="gbn" value="1" onclick="fnSetResult()" /><span>Quantity</span></label>
						</td>
						<th scope="row">Type</th>
						<td>
							<select class="w100p" multiple="multiple" id="scmStockTypeCbBox" name="scmStockTypeCbBox"></select>
						</td>
						<th scope="row">Category</th>
						<td>
							<select class="w100p" id="scmStockCategoryCbBox" multiple="multiple" name="scmStockCategoryCbBox"></select>
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
	<section class="search_result">				<!-- section search_result start -->
		<article class="grid_wrap">				<!-- article grid_wrap start -->
			<!-- Detail Grid -->
			<div id="aging_wrap" style="height:694px;"></div>
		</article>								<!-- article grid_wrap end -->
	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->