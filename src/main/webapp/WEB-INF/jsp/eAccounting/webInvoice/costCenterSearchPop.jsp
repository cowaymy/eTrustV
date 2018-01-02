<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var costCenterColumnLayout = [ {
    dataField : "costCenter",
    headerText : '<spring:message code="webInvoice.costCenter" />'
}, {
    dataField : "costCenterText",
    headerText : '<spring:message code="costCentr.costCenterText" />',
    style : "aui-grid-user-custom-left"
}
];

//그리드 속성 설정
var costCenterGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var costCenterGridID;

$(document).ready(function () {
	costCenterGridID = AUIGrid.create("#costCenter_grid_wrap", costCenterColumnLayout, costCenterGridPros);
	
	AUIGrid.bind(costCenterGridID, "cellDoubleClick", function( event ) {
		$("#search_costCentr").val(event.item.costCenter);
		$("#search_costCentrName").val(event.item.costCenterText);
		
		if("${pop}" == "pop") {
			fn_setPopCostCenter();
		} else {
			fn_setCostCenter();
		}
        
         $("#costCenterSearchPop").remove();
	});
	
	// add jgkim
	if("${call}" == "budgetAdj") {
		$("#search_btn").click(fn_selectAdjustmentCBG);
	} else {
		$("#search_btn").click(fn_selectCostCenter);
	}
});

function fn_selectCostCenter() {
    Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), $("#form_costCenter").serializeJSON(), function(result) {
        AUIGrid.setGridData(costCenterGridID, result);
    });
}

// add jgkim
function fn_selectAdjustmentCBG() {
    Common.ajax("GET", "/eAccounting/budget/selectAdjustmentCBG.do?_cacheId=" + Math.random(), $("#form_costCenter").serializeJSON(), function(result) {
    	console.log(result);
        AUIGrid.setGridData(costCenterGridID, result[0]);
    });
}
</script>

<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="costCentr.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue"><a href="#" id="search_btn"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_costCenter">
<input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="costCenter" name="costCenter" /></td>
	<th scope="row"><spring:message code="costCentr.costCenterText" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" name="costCenterText" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="costCenter_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->