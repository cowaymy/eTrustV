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
 * Button Functions
 */
//	Search
function fnSearch() {

    if(FormUtil.checkReqValue($("#planYearMonth"))){
        //var arg = "<spring:message code='service.grid.Year' />";
        var arg = "Month";
        Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
        return false;
    }


/*     var url = "/logistics/inbound/ReceiptList.do";
    var param = $('#searchForm').serializeJSON();

    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.dataList);
    }); */

    var myGridID1Index = 34;
    for (var i = lastIndex; i >= 0; i--) {

        AUIGrid.setColumnProp(myGridID1, myGridID1Index, {
            visible : true
        });

        myGridID1Index--;
    }

	Common.ajax("POST"
			, "/payment/report/selectIssuerBankJsonList.do"
			//, "/payment/report/selectCustomerTypeNPayChannelReporJsonList.do"
			, $("#MainForm").serializeJSON()
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

                }

				AUIGrid.setGridData(myGridID1, result.gridList);
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

function fnPlanYearMonthChange(){

}

/*
 * Grid Create & Setting
 */
var myGridID1, lastIndex;

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

var grid1Layout	=
[
 	 {   dataField : "modeCode", headerText : ' ',         width : 120 , cellMerge : true  }
     ,{   dataField : "modeDesc", headerText : ' ',     width : 120, style: "aui-grid-user-custom-left" , cellMerge : true }
     ,{   dataField : "bankCode", headerText : ' ',     width : 160, style: "aui-grid-user-custom-left" }
];

var columnLayout = [];
var chars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"];

var column;
for(var i=0; i<31; i++) {
	var txt = "";
	if(i == 0){
		txt = "st"
	}else if(i == 1){
        txt = "nd"
    }else if(i == 2){
    	txt = "rd"
    }else{
    	txt = "th"
    }
	grid1Layout.push( {
        headerText : chars[i]+txt,
        dataField : "d"+i,
        width:50,
        style: "aui-grid-user-custom-right",
      	dataType : "numeric",
        formatString : "#,###"
    });

}

$(document).ready(function() {
	// Grid 1
	myGridID1	= GridCommon.createAUIGrid("#grid1_wrap", grid1Layout, "", gridOptions);
	AUIGrid.bind(myGridID1, "cellClick", function(event) {

	});
	AUIGrid.bind(myGridID1, "cellDoubleClick", function(event) {

	});

    // 엑셀다운로드
    $('#excelDownGrid1').click(function() {
        GridCommon.exportTo("grid1_wrap", 'xlsx', "Paymode Analysis by Issuer Bank");
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
		<h2>Paymode Analysis by Issuer Bank</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a onclick="fnSearch();"><span class="search"></span>Search</a></p></li>
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
						<th scope="row">Month</th>
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
			<div id="grid1_wrap" class="mt10" style="height:580px" class="autoGridHeight" ></div>
		</article>
        <!-- Grid1 End -->

	</section>									<!-- section search_result end -->
</section>									<!-- section content end -->