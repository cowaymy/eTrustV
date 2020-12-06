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
var viewColumnLayout = [{
    dataField : "salesOrdNo",
    headerText : "Sales Order Number"
}, {
    dataField : "hpCode",
    headerText : "HP Code"
}, {
	dataField : "hpViewStartDt",
	headerText : "Start Date"
}, {
	dataField : "hpViewEndDt",
	headerText : "End Date"
}];

//그리드 속성 설정
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
    viewGridID = AUIGrid.create("#loyaltyHp_view_grid_wrap", viewColumnLayout, viewGridPros);

    $("#close_btn").click(fn_closePop);

    $('#excelDown').click(function() {
        GridCommon.exportTo("loyaltyHp_view_grid_wrap", 'xlsx', 'Loyalty HP File Upload List');
    });

    AUIGrid.setGridData(viewGridID, $.parseJSON('${loyaltyHpBatchItem}'));
});

function fn_closePop() {
    $("#close_btn").click();
}

//master confirm button
function fn_confirm(){

	if('${loyaltyHpBatchInfo.stusName}' == 'Completed' || '${loyaltyHpBatchInfo.stusName}' == 'Inactive'){
		Common.alert("Batch is Completed/Inactive. Confirmation not allowed.");

	} else {

        Common.ajax("GET", "/sales/customer/loyaltyHpConfirm", $("#form_LoyaltyHpView").serializeJSON() , function(result) {
            if(result.message != null){
                //Common.alert("No valid in this batch </br> "+result.message);
                Common.alert("<spring:message code='commission.alert.incentive.noValid' arguments='"+result.message+"' htmlEscape='false'/>",fn_closePopAndReload);
            }else{
                Common.alert("This upload batch has been confirmed and saved.",fn_closePopAndReload);
            }
        });
	}

}

function fn_reject() {
	   if('${loyaltyHpBatchInfo.stusName}' == 'Completed' || '${loyaltyHpBatchInfo.stusName}' == 'Inactive'){
	        Common.alert("Batch is Completed/Inactive. Rejection not allowed.");
	    } else {
	        Common.ajax("GET", "/sales/customer/loyaltyHpReject", $("#form_LoyaltyHpView").serializeJSON() , function(result) {
	            Common.alert(result.message,fn_closePopAndReload);
	        });
	    }
}

function fn_closePopAndReload() {
	window.location.reload();
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Loyalty HP - File Upload View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_LoyaltyHpView">
<input type="hidden" name="loyaltyHpBatchId" id="loyaltyHpBatchId" value="${loyaltyHpBatchInfo.loyaltyHpBatchId }">
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
    <td>${loyaltyHpBatchInfo.loyaltyHpBatchId}</td>
    <th scope="row">Batch Status</th>
    <td>${loyaltyHpBatchInfo.stusName}</td>
      <th scope="row">Total Item</th>
    <td>${loyaltyHpBatchInfo.loyaltyHpTotItm}</td>
</tr>

</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<article class="grid_wrap" id="loyaltyHp_view_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="javascript:fn_confirm();">Confirm</a></p></li>
    <li><p class="btn_blue2 big"><a href="javascript:fn_reject();">Reject</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="excelDown"><spring:message code='pay.btn.exceldw'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
