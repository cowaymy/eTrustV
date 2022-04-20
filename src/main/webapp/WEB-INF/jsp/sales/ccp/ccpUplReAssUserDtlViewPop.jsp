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
    dataField : "ccpStusId",
    headerText : "Status"
},{
    dataField : "assignPic",
    headerText : "Assign PIC"
}, {
    dataField : "remarks",
    headerText : "Assignment Batch"
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
    selectionMode : "multipleCells",
    showRowCheckColumn : true ,
};

$(document).ready(function () {
    viewGridID = AUIGrid.create("#dtl_grid_wrap", viewColumnLayout, viewGridPros);

    AUIGrid.setGridData(viewGridID, $.parseJSON('${batchDtlList}'));

    doGetCombo('/sales/ccp/selectUploadCcpUsertList', '' , '' ,'ccpUser' , 'L');        // CCP User Combo Box
});

function fn_closePop() {
    $("#close_btn").click();
}

function fn_reassignUser(){
	var checkedItems =  AUIGrid.getCheckedRowItemsAll(viewGridID);


	if(checkedItems.length <= 0) {
        Common.alert('No data selected.');
        return false;
    }

	var rowItem;
          var orderNoList = "";

        for (var i = 0, len = checkedItems.length; i < len; i++) {
           rowItem = checkedItems[i];

           orderNoList += rowItem.orderNo;

           if (i != len - 1) {
        	   orderNoList += ",";
             }

         }

        $("#orderNoList").val(orderNoList);

        fn_updateUserCcpAjax();
}

function fn_updateUserCcpAjax() {
	console.log(orderNoList);
	console.log($("#assignForm").serialize());
    Common.ajax("GET", "/sales/ccp/updateAssignUserCcpList", $("#assignForm").serialize(), function(result) {

     AUIGrid.destroy("#dtl_grid_wrap");
     viewGridID = AUIGrid.create("#dtl_grid_wrap", viewColumnLayout, viewGridPros);
     AUIGrid.setGridData(viewGridID, result.batchDtlList);
    }
    );
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CCP - Reassign User</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn"><spring:message code='sys.btn.close'/></a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form name = "" id="assignForm" method="post">
<input id="orderNoList" name="orderNoList" type="hidden" />
<input type="hidden" id="batchId" name="batchId" value = "${viewInfo.batchId}" />
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
<tr>
  <th scope="row">Assign User</th>
    <td>
          <select  id="ccpUser" name="ccpUser" class="w100p"></select>
  </td>
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
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_reassignUser()"><spring:message code='sal.title.reassign'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
