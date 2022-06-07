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

var myGridIDShipping;
var param= [];

var ItmOption = {
        type: "S",
        isCheckAll: false
};

$(document).ready(function () {

    //RegionalComboBox
    var regionalPopParam = {groupCode : 509, codeIn :[6803,6804]};
    CommonCombo.make('regional_add', "/sales/pos/selectPosModuleCodeList", regionalPopParam , '', ItmOption);

    createAUIDGrid();

});


function createAUIDGrid(){

    var gridProsItem = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            showRowCheckColumn : true, //checkBox
            softRemoveRowMode : false
    };

    var columnLayout = [
                        {dataField: "regionalType",headerText :"Regional" ,width: 100   ,height:30 , visible:false, editable : false},
                        {dataField: "regional",headerText :"Regional" ,width: 100   ,height:30 , visible:true, editable : false},
                        {dataField: "totalWeightFrom",headerText :"Total Weight (KG) From", width: 150    ,height:30 , visible:true, editable : false},
                        {dataField: "totalWeightTo" ,headerText :"Total Weight (KG) To" , width:150 ,height:30 , visible:true, editable : true},
                        {dataField: "totalShippingFee" ,headerText :"Total Shipping Fees" ,width:140 ,height:30 , visible:true, editable : false},
                        {dataField: "startDt" ,headerText :"Start Date"  ,width:120 ,height:30 , visible:true, editable : false},
                        {dataField: "endDt" ,headerText :"End Date" ,width:120 ,height:30 , visible:true, editable : false},
                        {dataField: "id" ,headerText :"ID" ,width:120   ,height:30 , visible:false, editable : false}
     ];

    $("#shipping_grid_wrap2").html("");
   myGridIDShipping = GridCommon.createAUIGrid("#shipping_grid_wrap2", columnLayout,'', gridProsItem);
   AUIGrid.resize(myGridIDShipping , 960, 300);

   Common.ajax("GET", "/sales/posstock/selectShippingList", null, function(result) {
               AUIGrid.setGridData(myGridIDShipping, result);
   });
}


//Grid Add Row
function addRowToGrid(){

    var isVal = true;

    //Validation
    isVal = fn_chkItemVal();

    //Save
    if(isVal == false){
        return;
    }else{
        var item = new Object();

        item.regionalType = $("#regional_add").val();
        item.regional = "";
        if($("#regional_add").val()=='6803')
        {
            item.regional = "East Malaysia";
        }
        else if($("#regional_add").val()=='6804')
        {
            item.regional = "West Malaysia";
        }
        item.totalWeightFrom = $("#weightFrom_add").val();
        item.totalWeightTo = $("#weightTo_add").val();
        item.totalShippingFee = $("#shippingFee_add").val();
        item.startDt = $("#startDt_add").val();
        item.endDt = $("#endDt_add").val();
        item.id = "0";

        AUIGrid.addRow(myGridIDShipping, item, "first");
    }
}



function shippingSave(){

	 //Add Objects
	 var editArr = [];
	 var isVal = true;
	 var data = {};
	 var updArr = [];

	 editArr = GridCommon.getEditData(myGridIDShipping);

	 //Valition
	 //1. NullCheck
	 var shippingSize = AUIGrid.getGridData(myGridIDShipping);

	 if(shippingSize == null || shippingSize.length <= 0){
	     Common.alert('<spring:message code="sal.alert.msg.noChngData" />');
	     return false;
	 }

	 if(editArr == null || editArr.size <= 0){
	     Common.alert('<spring:message code="sal.alert.msg.noChngData" />');
	     return false;
	 }

	  if(editArr.add != null || editArr.add.size > 0){
	     data.add = editArr.add;
	  }

	   if(editArr.remove != null || editArr.remove.size > 0){
	         data.remove = editArr.remove;
	    }

	 //Save
	 Common.ajax("POST", "/sales/posstock/insUpdPosEshopShipping.do", data, function(result){
	       Common.alert(result.message);
	       createAUIDGrid();

	 });
}

function fn_chkItemVal(){
    var isVal = true;

    if(FormUtil.isEmpty($('#regional_add').val())) {
        Common.alert("Please select Regional.");
        return false;
    }

    if(FormUtil.isEmpty($('#weightFrom_add').val())) {
        Common.alert("Please key in Total Weight (KG) From.");
        return false;
     }

    if(FormUtil.isEmpty($('#weightTo_add').val())) {
        Common.alert("Please key in Total Weight (KG) To.");
        return false;
     }

    if(FormUtil.isEmpty($('#startDt_add').val())) {
        Common.alert("Please choose Start Date.");
        return false;
     }

    if(FormUtil.isEmpty($('#endDt_add').val())) {
        Common.alert("Please choose End Date.");
        return false;
     }

    if(FormUtil.isEmpty($('#shippingFee_add').val())) {
        Common.alert("Please key in Total Shipping Fees (RM).");
        return false;
     }
}


$(function() {

    $("#btnDelRow").click(function() {
        AUIGrid.removeCheckedRows(myGridIDShipping);
    });

});





</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Shipping Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<!-- title_line start -->
<aside class="title_line"><h2>Shipping Information</h2></aside>
<!-- title_line end -->

<section class="search_table mt10"><!-- search_table start -->
<form action="#" method="post" id="form_item">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->

<table class="type1"><!-- table start -->
<caption>table</caption>
        <colgroup>
            <col style="width:200px" />
            <col style="width:*" />
            <col style="width:200px" />
            <col style="width:*" />
        </colgroup>
    <tbody>
            <tr>
                    <th scope="row">Regional</th>
                    <td><select class="w100p" id="regional_add"  name="regional_add"></select></td>

                    <th></th>
                    <td></td>
            </tr>

            <tr>
                    <th scope="row">Total Weight (KG) From</th>
                    <td><input type="text" class="w100p"  id="weightFrom_add"  name="weightFrom_add"/></td>

                    <th scope="row">Total Weight (KG) To</th>
                    <td><input type="text" class="w100p"  id="weightTo_add"  name="weightTo_add" /></td>
            </tr>

            <tr>
                    <th scope="row">Start Date</th>
                    <td><input type="text" title="기준년월" id="startDt_add" name="startDt_add" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>

                    <th scope="row">End Date</th>
                    <td><input type="text" title="기준년월" id="endDt_add" name="endDt_add" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
            </tr>

            <tr>
                    <th scope="row">Total Shipping Fees (RM)</th>
                    <td><input type="text" class="w100p"  id="shippingFee_add"  name="shippingFee_add" /></td>

                    <th></th>
                    <td></td>
            </tr>

    </tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<!-- title_line start -->
<aside class="title_line"><h2>Shipping List</h2></aside>
<!-- title_line end -->

<ul class="right_btns">
        <li><p class="btn_grid"><a onclick="javascript : addRowToGrid()">Add</a></p></li>
        <li><p class="btn_grid"><a id="btnDelRow">Delete</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="shipping_grid_wrap2" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->


<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="shippingSave()"  ><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</div><!-- popup_wrap end -->