<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
<!-- char js -->
<link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>

<style type="text/css">

</style>

<script type="text/javascript">

$(function(){
//	fnScmTotalPeriod();
});

/*
 * Grid Create & Setting
 */
var myGridID1, myGridID2, myGridID3, myGridID4, lastIndex;

//	myGridTotal
var gridOptions	= {
	usePaging : false,
	useGroupingPanel : false,
	showRowNumColumn : false,
	showRowCheckColumn : false,
	showStateColumn : false,
	showEditedCellMarker : false,
	editable : false,
	enableCellMerge : true,  // 셀 병합 실행
	enableRestore : false,
	fixedColumnCount : 3,

    // enableCellMerge 할 때 실제로 rowspan 적용 시킬지 여부
    // 만약 false 설정하면 실제 병합은 하지 않고(rowspan 적용 시키지 않고) 최상단에 값만 출력 시킵니다.
    cellMergeRowSpan : false,
    // 셀 병합 정책
    // "default"(기본값) : null 을 셀 병합에서 제외하여 병합을 실행하지 않습니다.
    // "withNull" : null 도 하나의 값으로 간주하여 다수의 null 을 병합된 하나의 공백으로 출력 시킵니다.
    // "valueWithNull" : null 이 상단의 값과 함께 병합되어 출력 시킵니다.
    cellMergePolicy : "withNull",
    // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
    rowSelectionWithMerge : true
};


//myGridTotal
var gridOptions2 = {
    usePaging : false,
    useGroupingPanel : false,
    showRowNumColumn : false,
    showRowCheckColumn : false,
    showStateColumn : false,
    showEditedCellMarker : false,
    editable : false,
    enableCellMerge : true,  // 셀 병합 실행
    enableRestore : false,
    fixedColumnCount : 2,

    // enableCellMerge 할 때 실제로 rowspan 적용 시킬지 여부
    // 만약 false 설정하면 실제 병합은 하지 않고(rowspan 적용 시키지 않고) 최상단에 값만 출력 시킵니다.
    cellMergeRowSpan : false,
    // 셀 병합 정책
    // "default"(기본값) : null 을 셀 병합에서 제외하여 병합을 실행하지 않습니다.
    // "withNull" : null 도 하나의 값으로 간주하여 다수의 null 을 병합된 하나의 공백으로 출력 시킵니다.
    // "valueWithNull" : null 이 상단의 값과 함께 병합되어 출력 시킵니다.
    cellMergePolicy : "withNull",
    // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
    rowSelectionWithMerge : true
};
var grid1Layout	=
[
 	 {   dataField : "typeName", headerText : ' ',         width : 100 , cellMerge : true  }
     ,{   dataField : "modeCode", headerText : ' ',     width : 50, style: "aui-grid-user-custom-left" , cellMerge : true }
     ,{   dataField : "modeDesc", headerText : ' ',     width : 80, style: "aui-grid-user-custom-left" }
];

var grid2Layout =
[
    {   dataField : "modeCode", headerText : ' ',     width : 150, style: "aui-grid-user-custom-left" , cellMerge : true }
    ,{   dataField : "modeDesc", headerText : ' ',     width : 80, style: "aui-grid-user-custom-left" }
];

var grid3Layout =
[
    {   dataField : "modeCode", headerText : ' ',     width : 150, style: "aui-grid-user-custom-left" , cellMerge : true }
    ,{   dataField : "modeDesc", headerText : ' ',     width : 80, style: "aui-grid-user-custom-left" }
];

var grid4Layout =
[
    {   dataField : "modeCode", headerText : ' ',     width : 150, style: "aui-grid-user-custom-left" , cellMerge : true }
    ,{   dataField : "modeDesc", headerText : ' ',     width : 80, style: "aui-grid-user-custom-left" }
];


var columnLayout = [];
var chars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"];

var column;
for(var i=1; i<32; i++) {
	var txt = "";
	if(i == 1){
		txt = "st"
	}else if(i == 2){
        txt = "nd"
    }else if(i == 3){
    	txt = "rd"
    }else{
    	txt = "th"
    }
	grid1Layout.push( {
        headerText : chars[i]+txt,
        dataField : "d"+i,
        width:100,
        style: "aui-grid-user-custom-right",
        dataType : "numeric",
        formatString : "#,###"
    });

	grid2Layout.push( {
        headerText : chars[i]+txt,
        dataField : "d"+i,
        width:100,
        style: "aui-grid-user-custom-right",
        dataType : "numeric",
        formatString : "#,###"
    });

   grid3Layout.push( {
        headerText : chars[i]+txt,
        dataField : "d"+i,
        width:100,
        style: "aui-grid-user-custom-right",
        dataType : "numeric",
        formatString : "#,###"
    });

    grid4Layout.push( {
        headerText : chars[i]+txt,
        dataField : "d"+i,
        width:100,
        style: "aui-grid-user-custom-right",
        dataType : "numeric",
        formatString : "#,###"
    });
}



/*
 * Button Functions
 */
//  Search
function fnSearchTotal() {

    if(FormUtil.checkReqValue($("#planYearMonth"))){
        //var arg = "<spring:message code='service.grid.Year' />";
        var arg = "Month";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
        return false;
    }

    var myGridID1Index = 34;
    for (var i = lastIndex; i >= 0; i--) {

        AUIGrid.setColumnProp(myGridID1, myGridID1Index, {
            visible : true
        });

        myGridID1Index--;
    }


    var myGridID2Index = 33;
    for (var i = lastIndex; i >= 0; i--) {

        AUIGrid.setColumnProp(myGridID2, myGridID2Index, {
            visible : true
        });

        AUIGrid.setColumnProp(myGridID3, myGridID2Index, {
            visible : true
        });

        AUIGrid.setColumnProp(myGridID4, myGridID2Index, {
            visible : true
        });

        myGridID2Index--;
    }

    Common.ajax("GET"
            , "/payment/report/selectCustomerTypeNPayChannelReportJsonList.do"
            , $("#MainForm").serialize()
            , function(result) {


            	// 그리드 헤더 사이즈 조정
                lastIndex =  31 - Number( result.lastDay );

            	if( lastIndex > 0 ){
                    var myGridID1Index = 34;
                    for (var i = lastIndex; i >= 0; i--) {

                        AUIGrid.setColumnProp(myGridID1, myGridID1Index, {
                            visible : false
                        });

                        myGridID1Index--;
                    }


                    var myGridID2Index = 33;
                    for (var i = lastIndex; i >= 0; i--) {

                        AUIGrid.setColumnProp(myGridID2, myGridID2Index, {
                            visible : false
                        });

                        AUIGrid.setColumnProp(myGridID3, myGridID2Index, {
                            visible : false
                        });

                        AUIGrid.setColumnProp(myGridID4, myGridID2Index, {
                            visible : false
                        });

                        myGridID2Index--;
                    }
            	}

                /* AUIGrid.setColumnProp(myGridID1, 4, {
                	visible : false
                }); */

                // 컬럼 변경
//                AUIGrid.changeColumnLayout(myGridID1, grid1Layout);

                //
                AUIGrid.setGridData(myGridID1, result.grid1List);
                AUIGrid.setGridData(myGridID2, result.grid2List);
                AUIGrid.setGridData(myGridID3, result.grid3List);
                AUIGrid.setGridData(myGridID4, result.grid4List);
            });
}

function fnPlanYearMonthChange() {
    console.log($("#planYearMonth").val());
}

/*
 * Util Functions
 */
function getTimeStamp() {
    function fnLeadingZeros(n, digits) {
        var zero    = "";
        n   = n.toString();
        if ( n.length < digits ) {
            for ( var i = 0 ; i < digits - n.length ; i++ ) {
                zero    += "0";
            }
        }
        return  zero + n;
    }
    var d   = new Date();
    var date    = fnLeadingZeros(d.getFullYear(), 4) + fnLeadingZeros(d.getMonth() + 1, 2) + fnLeadingZeros(d.getDate(), 2);
    var time    = fnLeadingZeros(d.getHours(), 2) + fnLeadingZeros(d.getMinutes(), 2) + fnLeadingZeros(d.getSeconds(), 2);

    return  date + "_" + time;
}

function fnPlanYearMonthChange(){

}


$(document).ready(function() {
	// Grid 1
	myGridID1	= GridCommon.createAUIGrid("#grid1_wrap", grid1Layout, "", gridOptions);
	AUIGrid.bind(myGridID1, "cellClick", function(event) {

	});
	AUIGrid.bind(myGridID1, "cellDoubleClick", function(event) {

	});

	// Grid 2
	myGridID2	= GridCommon.createAUIGrid("#grid2_wrap", grid2Layout, "", gridOptions2);
	AUIGrid.bind(myGridID2, "cellClick", function(event) {

	});
	AUIGrid.bind(myGridID2, "cellDoubleClick", function(event) {

	});

    // Grid 3
    myGridID3   = GridCommon.createAUIGrid("#grid3_wrap", grid3Layout, "", gridOptions2);
    AUIGrid.bind(myGridID3, "cellClick", function(event) {

    });
    AUIGrid.bind(myGridID3, "cellDoubleClick", function(event) {

    });

    // Grid 4
    myGridID4   = GridCommon.createAUIGrid("#grid4_wrap", grid4Layout, "", gridOptions2);
    AUIGrid.bind(myGridID4, "cellClick", function(event) {

    });
    AUIGrid.bind(myGridID4, "cellDoubleClick", function(event) {

    });

    // 엑셀다운로드
    $('#excelDownGrid1').click(function() {
        GridCommon.exportTo("grid1_wrap", 'xlsx', "Paymode Analysis by Customer Type & Pay Channel 1");
     });

    $('#excelDownGrid2').click(function() {
        GridCommon.exportTo("grid2_wrap", 'xlsx', "Paymode Analysis by Customer Type & Pay Channel 2");
     });

    $('#excelDownGrid3').click(function() {
        GridCommon.exportTo("grid3_wrap", 'xlsx', "Paymode Analysis by Customer Type & Pay Channel 3");
     });

    $('#excelDownGrid4').click(function() {
        GridCommon.exportTo("grid4_wrap", 'xlsx', "Paymode Analysis by Customer Type & Pay Channel 4");
     });
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
		<h2>Paymode Analysis by Customer Type & Pay Channel</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSearchTotal();"><span class="search"></span>Search</a></p></li>
		</ul>
	</aside>								<!-- aside title_line end -->

	<section class="search_table">			<!-- section search_table start -->
		<form id="MainForm" method="post" action="">
			<input type="hidden" id="stockTypeId" name="stockTypeId" />
			<table class="type1">			<!-- table type1 start -->
			<caption>table</caption>
				<colgroup>
					<col style="width:140px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<!-- <th scope="row">Month &amp; Year</th> -->
						<th scope="row">Month<span class="must">*</span></th>
						<td>
							<input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w95p" id="planYearMonth" name="planYearMonth" onchange="fnPlanYearMonthChange();" value="${toDay}"  />
						</td>
					</tr>
				</tbody>
			</table>						<!-- table type1 end -->
		</form>

	</section>								<!-- section search_table end -->
	<section class="search_result">				<!-- section search_result start -->

        <!-- Grid1 Start -->
        <aside class="title_line mt0"><!-- title_line start -->
            <h3 class="pt0"></h3>
            <ul class="right_btns">
                <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                    <li><p class="btn_grid"><a href="#" id="excelDownGrid1"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                </c:if>
            </ul>
        </aside>

		<article class="grid_wrap">
			<!-- Summary Grid -->
			<div id="grid1_wrap" style="height:310px;"></div>
			 * App Type = REN, Order Status = COM, Open Rental Status = REG & INV, Billing month = 1-60, exclude current month Net Sales
		</article>
        <!-- Grid1 End -->

        <!-- Grid2 Start -->
        <aside class="title_line mt0"><!-- title_line start -->
            <h3 class="pt0"></h3>
            <ul class="right_btns">
                <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                    <li><p class="btn_grid"><a href="#" id="excelDownGrid2"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                </c:if>
            </ul>

        </aside>

        <article class="grid_wrap">             <!-- article grid_wrap start -->
            <!-- Summary Grid -->
            <div id="grid2_wrap" style="height:156px;"></div>
            * Customer Type = Individual + Company, Deduction = Success (exclude hand-collect), Dedcution month = 1st & 2nd

        </article>                              <!-- article grid_wrap end -->
        <!-- Grid2 End -->

        <!-- Grid3 Start -->
        <aside class="title_line mt0"><!-- title_line start -->
            <h3 class="pt0"></h3>
            <ul class="right_btns">
                <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                    <li><p class="btn_grid"><a href="#" id="excelDownGrid3"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                </c:if>
            </ul>
        </aside>

        <article class="grid_wrap">             <!-- article grid_wrap start -->
            <!-- Summary Grid -->
            <div id="grid3_wrap" style="height:156px;"></div>
            * Customer Type = Individual + Company, Deduction = Success (exclude hand-collect), Dedcution month = 2nd only

        </article>                              <!-- article grid_wrap end -->
        <!-- Grid3 End -->

        <!-- Grid4 Start -->
        <aside class="title_line mt0"><!-- title_line start -->
            <h3 class="pt0"></h3>
            <ul class="right_btns">
                <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                    <li><p class="btn_grid"><a href="#" id="excelDownGrid4"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                </c:if>
            </ul>
        </aside>

        <article class="grid_wrap">             <!-- article grid_wrap start -->
            <!-- Summary Grid -->
            <div id="grid4_wrap" style="height:156px;"></div>
            * Customer Type = Individual + Company, Deduction = Success (exclude hand-collect), vRescue flag = TRUE

        </article>                              <!-- article grid_wrap end -->
        <!-- Grid4 End -->

	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->