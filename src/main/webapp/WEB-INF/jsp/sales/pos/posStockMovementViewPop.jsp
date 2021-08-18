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

var columnLayout = [
                    {dataField: "stkCode",headerText :"Item Code"            ,width:  100   ,height:30 , visible:true, editable : false},
                    {dataField: "itemCode",headerText :"Item Code"           ,width:  100   ,height:30 , visible:false, editable : false},
                    {dataField: "itemDesc",headerText :"Item Description"    ,width: 280    ,height:30 , visible:true, editable : false},
                    {dataField: "itemPurhOrdNo",headerText :"PoNo"                ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "itemStatusDesc",headerText :"Item Status"                ,width:140   ,height:30 , visible:true, editable : false},
                    {dataField: "itemInvtQty",headerText :"Quantity(F)"                ,width:120   ,height:30 , visible:true, editable : false,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemToInvtQty" ,headerText :"Quantity(T)"                ,width:120   ,height:30 , visible:true, editable : true ,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemReqQty",headerText :"Request Quantity"                ,width:140   ,height:30 , visible:true, editable : false ,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemRecvQty",headerText :"Received Quantity"                ,width:140   ,height:30 , visible:true, editable : false ,dataType : "numeric", formatString : "#,##0"},
                    {dataField: "itemRtnQty",headerText :"Return Quantity"                ,width:140   ,height:30 , visible:true, editable : false ,dataType : "numeric", formatString : "#,##0"},

 ];


//그리드 속성 설정
var gridProsPOS = {
        usePaging : true,
        pageRowCount : 20,
        editable : false,
        showRowCheckColumn : true
};

var myViewGridIDPOS;



$(document).ready(function () {


    //CommonCombo.make('fromBrnchId', "/sales/pos/selectWhSOBrnchList", '' , '', '');
    //CommonCombo.make('toBrnchId', "/sales/pos/selectWhSOBrnchList", '' , '', '');


    myViewGridIDPOS = AUIGrid.create("#grid_wrapPOS", columnLayout, gridProsPOS);

    fn_getViewDataListAjax();

    // cellClick event.
    AUIGrid.bind(myViewGridIDPOS, "cellClick", function( event ) {
        fn_setRowInfo( event.item);
    });


});





//리스트 조회.
function fn_getViewDataListAjax  () {

  Common.ajax("GET", "/sales/posstock/selectPosStockMgmtViewInfo.do?scnNo="+'${scnNo}', null, function(result) {
     console.log("성공.");
     console.log("data : " + result);
     console.log(result);

     AUIGrid.setGridData(myViewGridIDPOS, result.dataList);


     $("#viewScnMoveType").val(result.dataInfo.scnMoveTypeCode);
     $("#viewScnMoveStat").val(result.dataInfo.scnMoveStatCode);
     $("#viewScnFromLocDesc").val(result.dataInfo.scnFromLocDesc);
     $("#viewScnToLocDesc").val(result.dataInfo.scnToLocDesc);
     //$("#viewItemPurhOrdNo").val(result.dataInfo.itemPurhOrdNo);
     $("#viewScnMoveDate").val(result.dataInfo.scnMoveDate);

 });
}



function fn_close(){
    $("#popup_wrap").remove();
}




function fn_setRowInfo(obj){

    //console.log(obj);
    //$("#viewScnFromLocDesc").val(result.dataInfo.scnFromLocDesc);
    $("#itemCtgryDesc").val(obj.itemCtgryDesc);
    $("#itemDesc").val(obj.itemDesc);
    $("#itemRtnReason").val(obj.itemRtnReason);
    $("#itemCode").val(obj.itemCode);

    $("#itemReqQty").val(obj.itemReqQty);
    $("#itemRecvQty").val(obj.itemRecvQty);
    $("#itemRtnQty").val(obj.itemRtnQty);
    $("#itemStatusDesc").val(obj.itemStatusDesc);


    if(obj.itemRejAttchGrpId  !="" && obj.itemRejAttchGrpId !=undefined ){
        $("#itemRejAttchGrpId").val(obj.atchFileId);
         $("#itemAttachmentBt").attr("style", "display:inline");
    }

}
function fn_viewAtachPop(){
    window.open("<c:url value='/file/fileDown.do?fileId="+  $("#itemRejAttchGrpId").val()+ "'/>");

}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Movement Information</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">SCN Number</th>
    <td>
               <input type="text" title="" placeholder="" class="w100p disabled"  id="scnNo"  name="scnNo" disabled="disabled" value="${scnNo}" />
    </td>
    <th scope="row">Movement Type</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="viewScnMoveType"  name="viewScnMoveType" disabled="disabled" />
    </td>
      <th scope="row">Status</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p disabled"  id="viewScnMoveStat"  name="viewScnMoveStat" disabled="disabled" />
    </td>
</tr>
<tr>
   <th scope="row">Transfer From</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="viewScnFromLocDesc"  name="viewScnFromLocDesc" disabled="disabled" />
    </td>
    <th scope="row">Transfer To</th>

    <td>
        <input type="text" title="" placeholder="" class="w100p disabled"  id="viewScnToLocDesc"  name="viewScnToLocDesc" disabled="disabled" />
    </td>
     <th scope="row">Create Date</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="viewScnMoveDate"  name="viewScnMoveDate" disabled="disabled" />
     </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="javascript:void(0);" onclick="fn_excelDown()">Excel Download</a></p></li>
</ul>

   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrapPOS"
     style="width: 100%; height: 100%; margin: 0 auto;"></div>
   </article>

</section><!-- search_result end -->




<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_view">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row">Item</th>
    <td >
               <input type="text" title="" placeholder="" class="w100p disabled"  id="itemDesc"  name="itemDesc" disabled="disabled"  />
               <input type="hidden" title="" placeholder="" class="w100p disabled"  id="itemCode"  name="itemCode" disabled="disabled"  />

    </td>

     <th scope="row">Item Status</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemStatusDesc"  style="color:red;" name="itemStatusDesc" disabled="disabled" />
    </td>
</tr>

<tr>
    <th scope="row">Category</th>
    <td>
               <input type="text" title="" placeholder="" class="w100p disabled"  id="itemCtgryDesc"  name="itemCtgryDesc" disabled="disabled" />
    </td>
    <th scope="row">Item Type</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemType"  name="itemType" disabled="disabled" value="Item Bank"/>
    </td>
</tr>




<tr>
    <th scope="row">Reason</th>
    <td >
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemRtnReason"  name="itemRtnReason" disabled="disabled"  />
    </td>
      <th scope="row">Request Quantity</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemReqQty"  name="itemReqQty" disabled="disabled" />
    </td>
</tr>
<tr>
    <th scope="row">Received Quantity</th>
    <td>
               <input type="text" title="" placeholder="" class="w100p disabled"  id="itemRecvQty"  name="itemRecvQty" disabled="disabled" />
    </td>
    <th scope="row">Return Quantity</th>
    <td>
            <input type="text" title="" placeholder="" class="w100p disabled"  id="itemRtnQty"  name="itemRtnQty" disabled="disabled"/>
    </td>
</tr>



<tr>
    <th scope="row">Attachment</th>
    <td colspan="3">

        <ul class="right_btns">
            <input type="hidden" title="" placeholder="" class="w100p disabled"  id="itemRejAttchGrpId"  name="itemRejAttchGrpId" disabled="disabled" />
            <li><p class="btn_grid"  id="itemAttachmentBt"  style="display:none"><a id="itemAttachment" onclick="fn_viewAtachPop();" >View</a></p></li>
        </ul>

    </td>

</tr>



</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->



</section><!-- pop_body end -->

</div><!-- popup_wrap end -->