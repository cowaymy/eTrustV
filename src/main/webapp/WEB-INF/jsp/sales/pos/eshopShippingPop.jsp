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
var toDay = '${toDay}';
var ItmOption = {
        type: "S",
        isCheckAll: false
};


$(document).ready(function () {

    //RegionalComboBox
    var regionalPopParam = {groupCode : 509, codeIn :[6803,6804]};
    CommonCombo.make('regional', "/sales/pos/selectPosModuleCodeList", regionalPopParam , '', ItmOption);
    CommonCombo.make('regional_edit', "/sales/pos/selectPosModuleCodeList", regionalPopParam , '', ItmOption);

	createAUIDGridShipping();

    AUIGrid.bind(myGridIDShipping, "cellDoubleClick", function(event) {

        var id  = AUIGrid.getCellValue(myGridIDShipping, event.rowIndex, 'id');
        var regionalType  = AUIGrid.getCellValue(myGridIDShipping, event.rowIndex,  'regionalType');
        var regional  = AUIGrid.getCellValue(myGridIDShipping, event.rowIndex,  'regional');
        var totalWeightFrom  = AUIGrid.getCellValue(myGridIDShipping, event.rowIndex,  'totalWeightFrom');
        var totalWeightTo  = AUIGrid.getCellValue(myGridIDShipping, event.rowIndex,  'totalWeightTo');
        var totalShippingFee  = AUIGrid.getCellValue(myGridIDShipping, event.rowIndex,  'totalShippingFee');
        var startDt  = AUIGrid.getCellValue(myGridIDShipping,  event.rowIndex, 'startDt');
        var endDt  = AUIGrid.getCellValue(myGridIDShipping, event.rowIndex,  'endDt');
        var status  = AUIGrid.getCellValue(myGridIDShipping,  event.rowIndex, 'status');
        var status2  = AUIGrid.getCellValue(myGridIDShipping,  event.rowIndex, 'status2');

        if(status2 =="C"){
        	 document.getElementById("regional_edit").disabled=true;

            $("#weightFrom_edit").attr("class", "w100p readonly");
            $("#weightFrom_edit").attr("readonly", "readonly");

            $("#weightTo_edit").attr("class", "w100p readonly");
            $("#weightTo_edit").attr("readonly", "readonly");

            $("#startDt_edit").attr("class", "w100p readonly");
            $("#startDt_edit").attr("readonly", "readonly");

            $("#shippingFee_edit").attr("class", "w100p readonly");
            $("#shippingFee_edit").attr("readonly", "readonly");

        }
        else{

        	document.getElementById("regional_edit").disabled=false;

            $("#weightFrom_edit").removeAttr("class", "w100p");
            $("#weightFrom_edit").removeAttr("readonly", "readonly");

            $("#weightTo_edit").removeAttr("class", "w100p");
            $("#weightTo_edit").removeAttr("readonly", "readonly");

            $("#startDt_edit").removeAttr("class", "w100p");
            $("#startDt_edit").removeAttr("readonly", "readonly");

            $("#shippingFee_edit").removeAttr("class", "w100p");
            $("#shippingFee_edit").removeAttr("readonly", "readonly");
        }


        $("#regional_edit").val(regionalType);
        $("#regionalType_editShippingItem").val(regionalType);
        $("#weightFrom_edit").val(totalWeightFrom);
        $("#weightTo_edit").val(totalWeightTo);
        $("#startDt_edit").val(startDt);
        $("#endDt_edit").val(endDt);
        $("#shippingFee_edit").val(totalShippingFee);
        $("#id_editShippingItem").val(id);

        $("#table_item_edit2").show();
});

});


function createAUIDGridShipping(){

	$("#table_item_edit2").hide();

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
            showRowCheckColumn : false, //checkBox
            softRemoveRowMode : false
    };

    var columnLayout = [
                        {dataField: "regional",headerText :"Regional" ,width: 100   ,height:30 , visible:true, editable : false},
                        {dataField: "totalWeightFrom",headerText :"Total Weight (KG) From", width: 150    ,height:30 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0.00"},
                        {dataField: "totalWeightTo" ,headerText :"Total Weight (KG) To" , width:150 ,height:30 , visible:true, editable : true, dataType : "numeric", formatString : "#,##0.00"},
                        {dataField: "totalShippingFee" ,headerText :"Total Shipping Fees" ,width:140 ,height:30 , visible:true, editable : false},
                        {dataField: "startDt" ,headerText :"Start Date"  ,width:120 ,height:30 , visible:true, editable : false},
                        {dataField: "endDt" ,headerText :"End Date" ,width:120 ,height:30 , visible:true, editable : false},
                        {dataField: "status" ,headerText :"Status" ,width:100 ,height:30 , visible:true, editable : false},
                        {dataField: "status2" ,headerText :"Status2" ,width:100 ,height:30 , visible:false, editable : false},
                        {dataField: "id" ,headerText :"ID" ,width:120   ,height:30 , visible:false, editable : false},
                        {dataField: "regionalType" ,headerText :"Regional" ,width:120   ,height:30 , visible:false, editable : false}

     ];

    $("#shipping_grid_wrap").html("");
   myGridIDShipping = GridCommon.createAUIGrid("#shipping_grid_wrap", columnLayout,'', gridProsItem);
   AUIGrid.resize(myGridIDShipping , 960, 300);

   Common.ajax("GET", "/sales/posstock/selectShippingList", $("#form_item_pop").serializeJSON(), function(result) {
               AUIGrid.setGridData(myGridIDShipping, result);
   });
}


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
    });
};

function fn_saveShippingGrid(){
    Common.ajax("POST", "/sales/posstock/updatePosEshopShipping.do", $("#form_item_edit").serializeJSON(), function(result) {
        Common.alert('Success to update');
        createAUIDGridShipping();

    }, function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
    });
}



$(function(){

     $('#btnNew').click(function() {
         Common.popupDiv("/sales/posstock/eshopShippingRegisterPop.do");
     });

     $('#btnClear').click(function() {
         $('#form_item_pop').clearForm();
         createAUIDGridShipping();
     });

     $('#btnSearch').click(function() {
    	  createAUIDGridShipping();
     });

     $('#btnClose_editShippingItem').click(function() {
    	  $("#popup_wrap3").remove();
    });

});


</script>

<div id="popup_wrap3" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Shipping Fee</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<!-- title_line start -->
<aside class="title_line"><h2>Shipping Information</h2></aside>
<!-- title_line end -->


<ul class="right_btns">
    <li><p class="btn_grid"><a id="btnNew">New</a></p></li>
    <li><p class="btn_grid"><a id="btnSearch">Search</a></p></li>
    <li><p class="btn_grid"><a id="btnClear">Clear</a></p></li>
</ul>


<section class="search_table mt10"><!-- search_table start -->
<form action="#" method="post" id="form_item_pop">
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
		            <td><select class="w100p" id="regional"  name="regional"></select></td>

		            <th></th>
		            <td></td>
		    </tr>

		    <tr>
		            <th scope="row">Total Weight (KG) From</th>
		            <td><input type="text" class="w100p"  id="weightFrom"  name="weightFrom" /></td>

		            <th scope="row">Total Weight (KG) To</th>
		            <td><input type="text" class="w100p"  id="weightTo"  name="weightTo" /></td>
		    </tr>

		    <tr>
                    <th scope="row">Start Date</th>
                    <td><input type="text" title="기준년월" id="startDt" name="startDt" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>

                    <th scope="row">End Date</th>
                    <td><input type="text" title="기준년월" id="endDt" name="endDt" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
            </tr>

		    <tr>
		            <th scope="row">Status</th>
                    <td>
                            <select id="status" name="status" class="multy_select w100p" >
                                <option value="">Choose One</option>
                                <option value="1">Active</option>
                                <option value="2">Expired</option>
                             </select>
                    </td>

                    <th></th>
                    <td></td>
		    </tr>

    </tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->


<section class="search_table mt20" id="table_item_edit2" style="display:none;"><!-- search_table start -->

<!-- title_line start -->
<aside class="title_line"><h2>Edit Shipping Information</h2></aside>
<!-- title_line end -->


<form action="#" method="post" id="form_item_edit">
<!-- <input type="hidden" id="search_costCentr">
<input type="hidden" id="search_costCentrName"> -->
<input type="hidden" id="id_editShippingItem" name="id_editShippingItem"/>
<input type="hidden" id="regionalType_editShippingItem" name="regionalType_editShippingItem"/>
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
                    <td><select class="w100p" id="regional_edit"  name="regional_edit"></select></td>

                    <th></th>
                    <td></td>
            </tr>

            <tr>
                    <th scope="row">Total Weight (KG) From</th>
                    <td><input type="text" class="w100p"  id="weightFrom_edit"  name="weightFrom_edit" /></td>

                    <th scope="row">Total Weight (KG) To</th>
                    <td><input type="text" class="w100p"  id="weightTo_edit"  name="weightTo_edit" /></td>
            </tr>

            <tr>
                    <th scope="row">Start Date</th>
                    <td><input type="text" title="기준년월" id="startDt_edit" name="startDt_edit" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>

                    <th scope="row">End Date</th>
                    <td><input type="text" title="기준년월" id="endDt_edit" name="endDt_edit" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
            </tr>

            <tr>
                    <th scope="row">Total Shipping Fees (RM)</th>
                    <td><input type="text" class="w100p"  id="shippingFee_edit"  name="shippingFee_edit" /></td>

                    <th></th>
                    <td></td>
            </tr>

    </tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="btnSave_editShippingItem" onclick="javascript:fn_saveShippingGrid()"  >Save</a></p></li>
    <li><p class="btn_blue2 big"><a id="btnClose_editShippingItem">Cancel</a></p></li>
</ul>

</section><!-- search_table end -->

<!-- title_line start -->
<aside class="title_line"><h2>Shipping List</h2></aside>
<!-- title_line end -->

<!-- <ul class="right_btns"> -->
<!--         <li><p class="btn_grid"><a id="btnEdit">Edit</a></p></li> -->
<!-- </ul> -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="shipping_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->



</div><!-- popup_wrap end -->