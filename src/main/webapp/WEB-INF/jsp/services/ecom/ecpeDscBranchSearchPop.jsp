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
var dscBranchColumnLayout = [ {
    dataField : "dscBranch",
    headerText : 'Code'
}, {
    dataField : "dscBranchText",
    headerText : 'Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "dscBranchId",
    visible : false
}
];

//그리드 속성 설정
var dscBranchGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var dscBranchGridID;

$(document).ready(function () {
	dscBranchGridID = AUIGrid.create("#dscBranch_grid_wrap", dscBranchColumnLayout, dscBranchGridPros);

	AUIGrid.bind(dscBranchGridID, "cellDoubleClick", function( event ) {
		$("#search_dscBranchId").val(event.item.dscBranchId);
		$("#search_dscBranch").val(event.item.dscBranch);
		$("#search_dscBranchName").val(event.item.dscBranchText);

		if("${pop}" == "pop") {
			fn_setPopDscBranch();
        } else {
        	fn_setDscBranch();
        }

         $("#dscBranchSearchPop").remove();
	});


    $("#search_btn").click(fn_selectdscBranch);

});

function fn_selectdscBranch() {
    Common.ajax("GET", "/services/ecom/selectDscBranch.do?_cacheId=" + Math.random(), $("#form_dscBranch").serializeJSON(), function(result) {
        AUIGrid.setGridData(dscBranchGridID, result);
    });
}

</script>

<div id="popup_wrap" class="popup_wrap size_mid2"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Dsc Branch Search</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<ul class="right_btns mb10">
	<li><p class="btn_blue"><a href="#" id="search_btn"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_dscBranch">
<input type="hidden" id="search_dscBranchId">
<input type="hidden" id="search_dscBranch">
<input type="hidden" id="search_dscBranchName">

<table class="type1"><!-- table start -->
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Code</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="dscBranch" name="dscBranch" /></td>
	<th scope="row">Name</th>
	<td><input type="text" title="" placeholder="" class="w100p" name="dscBranchText" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap" id="dscBranch_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->