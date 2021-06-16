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
var viewGridID;
var viewColumnLayout = [ {
    dataField : "orderNo",
    headerText : "Order No"
}, {
    dataField : "assignPic",
    headerText : "Assign PIC"
}, {
    dataField : "remarks",
    headerText : "Remarks"
}, {
    dataField : "result",
    headerText : "Result"
}
];

var viewGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 240,
    enableFilter : true,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {
	viewGridID = AUIGrid.create("#dtl_grid_wrap", viewColumnLayout, viewGridPros);

	$('#excelDown').click(function() {
        GridCommon.exportTo("dtl_grid_wrap", 'xlsx', 'CCP Assign User File Upload List');
    });

	AUIGrid.setGridData(viewGridID, $.parseJSON('${batchDtlList}'));
});

function fn_closePop() {
    $("#close_btn").click();
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CCP - Assign User File Upload View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_uploadView">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Batch ID</th>
    <td>${viewInfo.batchId}</td>
    <th scope="row">Batch Status</th>
    <td>${viewInfo.status}</td>
      <th scope="row">Total Item</th>
    <td>${viewInfo.qty}</td>
</tr>

</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<article class="grid_wrap" id="dtl_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="excelDown"><spring:message code='pay.btn.exceldw'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
