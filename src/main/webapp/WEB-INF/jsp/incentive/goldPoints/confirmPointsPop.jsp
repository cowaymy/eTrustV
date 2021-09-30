<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var viewGridID;
var viewColumnLayout = [{
    dataField : "memCode",
    headerText : "Member Code"
}, {
    dataField : "memName",
    headerText : "Member Name"
}, {
	dataField : "gpDesc",
	headerText : "Description"
}, {
    dataField : "gpUplPts",
    headerText : "Earned"
}, {
    dataField : "gpStartDt",
    headerText : "Start Date"
}, {
    dataField : "gpEndDt",
    headerText : "End Date"
}];

var viewGridPros = {
    usePaging : true,
    pageRowCount : 20,
    headerHeight : 40,
    height : 240,
    enableFilter : true,
    selectionMode : "multipleCells"
};

$(document).ready(function () {
    viewGridID = AUIGrid.create("#pointsDtl_view_grid_wrap", viewColumnLayout, viewGridPros);

    $("#close_btn").click(fn_closePop);

    AUIGrid.setGridData(viewGridID, $.parseJSON('${pointsBatchDtl}'));
});

function fn_closePop() {
    $("#close_btn").click();
}

function fn_confirm(){


//     if('${loyaltyHpBatchInfo.stusName}' == 'Completed' || '${loyaltyHpBatchInfo.stusName}' == 'Inactive'){
//         Common.alert("Batch is Completed/Inactive. Confirmation not allowed.");

//     } else {

//         Common.ajax("GET", "/sales/customer/loyaltyHpConfirm", $("#form_LoyaltyHpView").serializeJSON() , function(result) {
//             if(result.message != null){
//                 //Common.alert("No valid in this batch </br> "+result.message);
//                 Common.alert("<spring:message code='commission.alert.incentive.noValid' arguments='"+result.message+"' htmlEscape='false'/>",fn_closePopAndReload);
//             }else{
//                 Common.alert("This upload batch has been confirmed and saved.",fn_closePopAndReload);
//             }
//         });
//     }

}

function fn_reject() {
//        if('${loyaltyHpBatchInfo.stusName}' == 'Completed' || '${loyaltyHpBatchInfo.stusName}' == 'Inactive'){
//             Common.alert("Batch is Completed/Inactive. Rejection not allowed.");
//         } else {
//             Common.ajax("GET", "/sales/customer/loyaltyHpReject", $("#form_LoyaltyHpView").serializeJSON() , function(result) {
//                 Common.alert(result.message,fn_closePopAndReload);
//             });
//         }
}

function fn_closePopAndReload() {
    window.location.reload();
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Gold Points - Upload Confirmation</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_pointsDtlView">
<input type="hidden" name="gpBatchId" id="gpBatchId" value="${pointsBatchInfo.gpBatchId }">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Batch ID</th>
    <td>${pointsBatchInfo.gpBatchId}</td>
    <th scope="row">Batch Status</th>
    <td>${pointsBatchInfo.stusName}</td>
</tr>

</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<article class="grid_wrap" id="pointsDtl_view_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="fn_confirm()">Confirm</a></p></li>
    <li><p class="btn_blue2 big"><a href="fn_reject()">Reject</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
